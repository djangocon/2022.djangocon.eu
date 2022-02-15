<img src="images/logo_blue.png" height=100 />

🌍 [2022.djangocon.eu](https://2022.djangocon.eu/) \
📍 Hybrid from Porto, Portugal 🇵🇹 \
📅 September 21-25

[![built-with](https://img.shields.io/badge/built%20with-Cookiecutter%20Django-blue.svg)](https://github.com/pydanny/cookiecutter-django/)
[![code-style](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/ambv/black)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)]()

## Running

First, make sure to have all requirements installed using:
```bash
> pip install -r requirements/[ local | base | production ].txt
```

And create a PostgreSQL database 'djangocon_2022'
* On Debian-based 10+: 
```bash
sudo su - postgres -c "createdb djangocon_2022"
```

Then start the server through gulp:
```bash
> gulp
...
[Browsersync] Proxying: http://localhost:8000
[Browsersync] Access URLs:
 ---------------------------------------
       Local: http://localhost:3000
    External: http://10.101.176.121:3000
 ---------------------------------------
          UI: http://localhost:3001
 UI External: http://localhost:3001
 ---------------------------------------
[Browsersync] Watching files...
```

## Code of Conduct

As a contributor, you can help us keep the Django community open and inclusive.
Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## Getting Started

Get started contributing by reading our [Contributing](CONTRIBUTING.md) guidelines.

## Built With

* [Python](https://docs.python.org/3/) - Programming language
* [Django](https://docs.djangoproject.com/) - Web framework

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.
