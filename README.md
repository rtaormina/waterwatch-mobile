
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

#  WATERWATCH Mobile
This is the mobile application developed from the WATERWATCH website.
## Live Website
The live production version of [WATERWATCH](https://waterwatch.tudelft.nl)

## Documentation

## Installation

### Development

Requirements before install:
- python
- docker

To set up the development environment in VSCode, follow the these steps:
- Download and unpack flutter sdk 3.19.6. You can find all the sdk versions [here](https://docs.flutter.dev/install/archive).
- Install the Flutter VSCode extension
- Hit Ctrl + Shift + P, type flutter and start creating a new project. VSCode will prompt you that it is missing the Flutter sdk, from that message you can set the path to the sdk to where you saved it in the first step.
- In the terminal, run the following command: `flutter pub get` This installs all necessary dependencies.

### Production

## Running Tests
To run tests please first run:
```bash
docker compose up -d
```
This starts a docker container with the image that will later be used in the pipeline.

To run the unit tests in the project run:
```bash
docker exec mobile-app flutter test test/unit_tests
```

To run the widget tests in the project run:
```bash
docker exec mobile-app flutter test test/widget_tests
```

To get coverage information on the project
```bash
docker exec mobile-app ./coverage-tests.sh
```
You can view the results by opening `coverage/index.html`. This can be done by running `start coverage/index.html` on Windows or `open coverage/index.html` on Linux.

## Support

## Contributing
Running `flutter pub get` should install all the necessary dependencies needed to start coding in the project. To start committing code, you also need to install `pre-commit`, instructions on this can be found in the section called [Pre-commit](#Pre-Commit).

### Documentation Guidelines


### Style-checking

### Pre-commit
For additional code style checking, contributors must ensure that [pre-commit](https://pre-commit.com/) is installed. This can be done by running:
```bash
python -m pip install pre-commit
```
After pre-commit is installed, to create the commit hook:
```bash
pre-commit install
```
This makes sure that the pre-commit hooks will be run before commiting.

Sometimes on Windows, the above command will fail and you will get a error such as:
```
'pre-commit' is not recognized as an internal or external command,
operable program or batch file.
```

To resolve this issue run:
```bash
python -m pre_commit install
```


## License
[MIT](./LICENSE)

## Authors and Acknowledgment

### Development Team:
- Thomas Bood
- Nico Hammer
- Pieter van den Haspel
- Erik Koprivanacz
- Stella Schultz
### Domain Experts:
- Mirjam Blokker
- Andrea Cominola
- Demetris Eliades
- Riccardo Taormina
### Additional Support:
- Ivo van Kreveld
- Alexandra Marcu


> Additional thanks to everyone who helped in any way, shape, or form.
