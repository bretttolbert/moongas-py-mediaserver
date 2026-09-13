from typing import Any, Iterable, Optional, cast
from datetime import datetime
from urllib.parse import quote_plus
from flask import Flask
import flask_jsglue
import pandas as pd
from sqlalchemy import create_engine
import sys

from app.types.config.mediaserver_config import MediaServerConfig


def format_results_string(l: Iterable[Any], max_results: int):
    L = len(list(l))
    return f"{L:,}{'+' if L >= max_results else ''} {'result' if L == 1 else 'results'}"


def register_filters(app: Flask, config: MediaServerConfig):
    filters = cast(dict[str, Any], cast(Any, app.jinja_env).filters)

    def format_results(l: Iterable[Any]) -> str:
        return format_results_string(l, config.max_results)

    filters["result_or_results"] = format_results

    def format_album_covers_results(l: Iterable[Any]) -> str:
        return format_results_string(l, config.max_results_album_covers)

    filters["result_or_results_album_covers"] = format_album_covers_results
    filters["quote_plus"] = quote_plus
    def make_list(s: Iterable[Any]) -> list[Any]:
        return list(s)

    filters["make_list"] = make_list


def set_globals(
    app: Flask,
    config: MediaServerConfig,
):
    globals_ = cast(dict[str, Any], cast(Any, app.jinja_env).globals)

    globals_["PRESENT_YEAR"] = datetime.now().year
    globals_["PLAYBACK_METHOD_LOCAL_ENABLED"] = config.playback_methods.local.enabled

    globals_["WEB_SEARCH_PLAYBACK_METHODS"] = [
        method for method in config.playback_methods.webSearch if method.enabled
    ]

    globals_["AGE_VERIFICATION"] = config.age_verification

    globals_["LIMIT_BANDWIDTH"] = config.limit_bandwidth


def register_blueprint(app: Flask, config: MediaServerConfig, url_prefix: Optional[str] = None):
    from app.main import bp
    globals_ = cast(dict[str, Any], cast(Any, app.jinja_env).globals)

    if url_prefix is None:
        app.register_blueprint(bp)
        globals_["URL_PREFIX"] = ""
    else:
        app.register_blueprint(bp, url_prefix=url_prefix)
        globals_["URL_PREFIX"] = url_prefix


def create_app(config: MediaServerConfig) -> Flask:
    root_path = config.flask_config.root_path
    url_prefix = config.flask_config.url_prefix
    static_url_path = config.flask_config.static_url_path
    app = Flask(__name__, root_path=root_path, static_url_path=static_url_path)
    flask_jsglue.init(app, url_prefix)
    app.logger.debug("flask_config.root_path: %s", root_path)
    app.logger.debug("flask_config.url_prefix: %s", url_prefix)
    app.logger.debug("flask_config.static_url_path: %s", static_url_path)
    app.config["MEDIASERVER_CONFIG"] = config

    db_path = config.mediascan_database_file_path
    engine = None
    try:
        engine = create_engine(db_path)
        app.config["ENGINE"] = engine
    except Exception as ex:
        print(ex, db_path)
        sys.exit(1)

    with engine.connect() as conn:
        app.config["MEDIASCAN_DB_CONN"] = conn
        app.config["MEDIASCAN_DB_FILES"] = pd.read_sql_query("SELECT * FROM mediafile", conn)
        app.config["MEDIASCAN_DB_ARTISTS"] = pd.read_sql_query("SELECT * FROM artist", conn)
        app.config["MEDIASCAN_DB_FILES_ARTISTS_JOINED"] = pd.read_sql_query(
            "SELECT * FROM mediafile LEFT JOIN artist ON mediafile.artistpath = artist.path", conn
        )

    app.debug = config.flask_config.debug
    register_filters(app, config)
    set_globals(app, config)
    register_blueprint(app, config, url_prefix)
    return app
