
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
                    'Venue': '/talks/venue/',
                    'Swag bag': '/talks/swag_bag/',
                    'Grants': '/talks/grants/',
                    'Django girls': '/talks/django_girls/',
                    'Sprints': '/talks/sprints/',
                    'Announcements': '/talks/announcements/',
                },
            },
            'Sponsors': {
                'dropdown': 'true',
                'submenu': {
                    'Sponsors': '/talks/sponsors/',
                    'Contributors': '/talks/contributors/',
                    'Sponsorship': '/talks/sponsorship/',
                },
            },
            'Conduct': {
                'dropdown': 'true',
                'submenu': {
                    'Code of conduct': '/talks/code_of_conduct/',
                    'Response guide': '/talks/response_guide/',
                    'Privacy guide': '/talks/privacy_guide/',
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
    }
