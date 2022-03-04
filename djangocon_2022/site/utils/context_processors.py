
def links(request):
    return {
        'home': '/home/',
        'site_menu': {
            'Talks': {
                'dropdown': 'true',
                'submenu': {
                    'Schedule': '/talks/schedule/',
                    'Cfp': '/talks/cfp/',
                    'Selection process': '/talks/selection_process/',
                },
            },
            'Information': {
                'dropdown': 'true',
                'submenu': {
                    'Venue': '/information/venue/',
                    'Swag bag': '/information/swag_bag/',
                    'Grants': '/information/grants/',
                    'Django girls': '/information/django_girls/',
                    'Sprints': '/information/sprints/',
                    'Announcements': '/information/announcements/',
                },
            },
            'Sponsors': {
                'dropdown': 'true',
                'submenu': {
                    'Sponsors': '/sponsors/sponsors/',
                    'Contributors': '/sponsors/contributors/',
                    'Sponsorship': '/sponsors/sponsorship/',
                },
            },
            'Conduct': {
                'dropdown': 'true',
                'submenu': {
                    'Code of conduct': '/conduct/code_of_conduct/',
                    'Response guide': '/conduct/response_guide/',
                    'Privacy guide': '/conduct/privacy_guide/',
                },
            },
            'Jobs': {
                'dropdown': 'false',
                'href': '/jobs/',
            },
            'About': {
                'dropdown': 'true',
                'submenu': {
                    'Tickets': '/about/tickets/',
                    'Contact': '/about/contact/',
                    'Credits': '/about/credits/',
                },
            },
        },
        'social_media': {
            'twitter': 'https://twitter.com/',
            'slack': 'https://slack.com/',
            'youtube': 'https://youtube.com/',
            'linkedin': 'https://linked.in/',
            'github': 'https://github.com/djangocon/2022.djangocon.eu/',
        }
    }
