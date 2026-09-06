# moongas-py-mediaserver

Flask web application server for browsing and playing media library files, with advanced search filtering.

- A component of the `moongas` ecosystem of media library tools.
- A minimalist Flask web application for browsing and playing music files

Uses related projects [moongas-go-mediascan](https://github.com/bretttolbert/moongas-go-mediascan) and [moongas-py-mediascan](https://github.com/bretttolbert/moongas-py-mediascan) for scanning music library files to an sqlite database and then loading the database, respectively.

## [mediaserver Live Demo (aka _Brettify_)](https://bretttolbert.com/mediaserver)

### Filter by year range

[bretttolbert.com/mediaserver/albums?minYear=1990&maxYear=2004](https://bretttolbert.com/mediaserver/albums?minYear=1990&maxYear=2004)

### Filter by year range and genre(s)

[bretttolbert.com/mediaserver/player?minYear=1960&maxYear=2024&genre=Industrial+Metal&genre=Punk&genre=Punk+Rock&genre=Heavy+Metal&genre=Hip+Hop&genre=Urbano&genre=Thrash+Metal&genre=Nu+Metal&genre=Rock+en+español&genre=Funk+Metal&genre=Hip-Hop+français](https://bretttolbert.com/mediaserver/player?minYear=1960&maxYear=2024&genre=Industrial+Metal&genre=Punk&genre=Punk+Rock&genre=Heavy+Metal&genre=Hip+Hop&genre=Urbano&genre=Thrash+Metal&genre=Nu+Metal&genre=Rock+en+español&genre=Funk+Metal&genre=Hip-Hop+français)

### Filter by artist, album and title

[bretttolbert.com/mediaserver/player?artist=Rush&album=Grace%20Under%20Pressure&title=The%20Body%20Electric](https://bretttolbert.com/mediaserver/player?artist=Rush&album=Grace%20Under%20Pressure&title=The%20Body%20Electric)

## Screenshots

[Screenshots](./doc/screenshots/README.md)

## Features

- Simple minimalist web interface
- Perfect for a party jukebox hosted on your home WiFi network
- Multiple playback options (configurable):
    1. Play local media files in the browser (using HTML5 `<audio>` tag)
    2. "Play" by opening YouTube search for _"(artist) (album) (title) video"_ (configurable)
        - Great for finding music videos of your favorite music
        - Great for creating YouTube playlists of music videos meeting certain filter criteria (e.g. 80s New Wave music videos for your 80s party)
        - IMHO mediaserver + YouTube premium (no ads) is better than YouTube Music or Spotify
    3. (Default) Display both options
- Album art displayed at a beautiful `1000x1000px` resolution
    - (bandwidth optimized by converting to `.webp` at 80% quality if hosted by yours truly)
- Continuous shuffle playback with filtering options
- Fast (tested with a library of 20,000+ music files)
- Versatile filtering and sorting via a common set of intuitive url parameters
- Comprehensive browsing options--browse by _artist_, _album_, _genre_, _year_, _year range_, and more
- _Name That Tune_--plays a song without displaying the info, but offering hints, challenging the user to name the artist/tune
- Direct download of music files via hyperlinks
- Accessible from mobile devices (tested in Chrome on Android)


## Limitations

- Doesn't work with some `.m4a` files
    - Error: html5 audio element can't decode
- Requires that your music library be scanned with [moongas-go-mediascan](https://github.com/bretttolbert/moongas-go-mediascan)
    - `moongas-go-mediascan/cmd/scantodb` scans your music library and outputs a `mediascan.db` file
    - This must be repeated to update the music library (e.g. add new files)
    - Album art may be extracted (and converted to .webp) using the mediascan copy covers script
    - I cannot share my music files, of course, as they are copyrighted, but I can share my mediascan database with over 20,000+ tracks, allowing you to browse my extensive and painstakingly organized music library (with accurate tags, genre and year) and _play_ any track by opening a YouTube search for it. 
- Requires that music library be organized with the directory and file structure that Moongas expects
    - For example:
        - Artist folders containing album folders with `cover.jpg` (or `cover.webp`) files
        - Music filenames do not contain prohibited characters such as `+`
    - You can enforce these requirements by testing your music library with [moongas-py-mediatest](https://github.com/bretttolbert/moongas-py-mediatest)

## Coming soon

- Play entire albums
- Playlists
- Back button to go back to previous track(s) in player
- Sort by modified time

## Dependencies

- [moongas-go-mediascan](https://github.com/bretttolbert/moongas-go-mediascan) A simple and fast Go (golang) command-line utility to recursively scan a directory for media files, extract metadata (including ID3v2 tags from both MP3 and M4A files), and save the output in an sqlite3 database e.g. [mediascan.db](https://github.com/bretttolbert/mediascan/blob/main/out/mediascan.db)
- [moongas-py-mediascan] a Python library with data classes for working with the database output by `mediascan.go`
- [Flask-JSGlue](https://github.com/bretttolbert/Flask-JSGlue) This project depends on my fork of `Flask-JSGlue`

## Installation

### Install bretttolbert/Flask-JSGlue from GitHub
- Install my fork of the `Flask-JSGlue` python package
```bash
pip install git+https://github.com/bretttolbert/Flask-JSGlue.git
```

### Install bretttolbert/moongas-py-mediascan from GitHub source 
- Install the Moongas `mediascan` python package
```bash
pip install git+https://github.com/bretttolbert/moongas-py-mediascan.git
```
- Modify the mediascan config (`mediascan-config.yaml`) values (`mediadirs` etc.) as needed
- Run the `scantodb` command (requires [go](https://go.dev/doc/install))
```bash
cd moongas-go-mediascan
go run cmd/scantodb/main.go mediascan-config.yaml ../mediascan.db
```

### Install bretttolbert/moongas-py-mediaserver from GitHub source 
- Clone the repo
```bash
git clone git@github.com:bretttolbert/moongas-py-mediaserver.git
cd moongas-py-mediaserver
python -m pip install -r requirements.txt
```
- Configure `mediaPath`, etc. in the [`mediaserver-config.yaml`](./mediaserver-config.yaml)
- Run mediaserver
```bash
cd moongas-py-mediaserver
python run.py mediaserver-config.yaml
```

### Automatically start and run as a SystemD service

- Customize the .service file [`mediaserver.service`](mediaserver.service) as required
    - Create a compatible Python virtual environment with the necessary dependencies
    - Active it and install mediaserver `python -m pip install .`
    - Update the service file to point to your virtual environment
    - Update the username and group name from `brett` to the user and group name you want to use
- Copy the .service file into the systemd system folder to install it as a systemd service
    1. `sudo bash`
    2. `cp mediaserver.service /etc/systemd/system/`
    3. `cd /etc/systemd/system`
    4. `chmod 644 mediaserver.service`
    5. `ln -s mediaserver.service ./multi-user.target.wants/mediaserver.service`
- Use the `systemctl daemon-reload` command to force systemd to load the `mediaserver.service` file
    1. `systemctl daemon-reload`
- Start the `mediaserver` service and use journalctl to verify that it is running
    1. `systemctl start mediaserver.service`
    2. `systemctl status mediaserver`

Once you have it set up to run as a service, re-scanning your library is as easy as this:

```bash
cd moongas-go-mediascan
go run cmd/scantodb/main.go mediascan-conf.yaml ../mediascan.db
sudo systemctl restart mediaserver.service
journalctl -fu mediaserver.service
```
- Use `-fu` to follow the log so you can watch the server startup.
