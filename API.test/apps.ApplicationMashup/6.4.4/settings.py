# -*- coding: utf-8 -*-
# Django settings for wirecloud_instance project.

from os import path
from wirecloud.commons.utils.conf import load_default_wirecloud_conf
from django.core.urlresolvers import reverse_lazy

DEBUG = False
BASEDIR = path.dirname(path.abspath(__file__))
load_default_wirecloud_conf(locals())

USE_XSENDFILE = False

ADMINS = (
    # ('Your Name', 'your_email@example.com'),
)

MANAGERS = ADMINS

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',       # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': 'wirecloud',           # Or path to database file if using sqlite3.
        # The following settings are not used with sqlite3:
        'USER': 'wc_user',
        'PASSWORD': 'wc_user',
        'HOST': '',                      # Empty for localhost through domain sockets or '127.0.0.1' for localhost through TCP.
        'PORT': '',                      # Set to empty string for default.
    }
}

# Hosts/domain names that are valid for this site; required if DEBUG is False
# See https://docs.djangoproject.com/en/1.5/ref/settings/#allowed-hosts
ALLOWED_HOSTS = ['*']

# Local time zone for this installation. Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# In a Windows environment this must be set to your system time zone.
TIME_ZONE = 'America/Chicago'

# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html
LANGUAGE_CODE = 'en-us'

# If you set this to False, Django will make some optimizations so as not
# to load the internationalization machinery.
USE_I18N = True

# If you set this to False, Django will not format dates, numbers and
# calendars according to the current locale.
USE_L10N = True

# Absolute filesystem path to the directory that will hold user-uploaded files.
# Example: "/var/www/example.com/media/"
MEDIA_ROOT = ''

# URL that handles the media served from MEDIA_ROOT. Make sure to use a
# trailing slash.
# Examples: "http://example.com/media/", "http://media.example.com/"
MEDIA_URL = ''

# Absolute path to the directory static files should be collected to.
# Don't put anything in this directory yourself; store your static files
# in apps' "static/" subdirectories and in STATICFILES_DIRS.
# Example: "/var/www/example.com/static/"
STATIC_ROOT = path.join(BASEDIR, '../static')

# Controls the absolute file path that linked static will be read from and
# compressed static will be written to when using the default COMPRESS_STORAGE.
COMPRESS_ROOT = STATIC_ROOT

# URL prefix for static files.
# Example: "http://example.com/static/", "http://static.example.com/"
STATIC_URL = '/static/'

# Additional locations of static files
# STATICFILES_DIRS = (
#     # Put strings here, like "/home/html/static" or "C:/www/django/static".
#     # Always use forward slashes, even on Windows.
#     # Don't forget to use absolute paths, not relative paths.
# )

# List of finder classes that know how to find static files in
# various locations.
# STATICFILES_FINDERS += (
#     'django.contrib.staticfiles.finders.FileSystemFinder',
#     'django.contrib.staticfiles.finders.DefaultStorageFinder',
# )

# Make this unique, and don't share it with anybody.
SECRET_KEY = '92+5fj_e06yt)@gj9^$k)qh^frs+c*m=g7l-cd7jjg*kylfa)2'

ROOT_URLCONF = 'wirecloud_instance.urls'

# Python dotted path to the WSGI application used by Django's runserver.
WSGI_APPLICATION = 'wirecloud_instance.wsgi.application'

INSTALLED_APPS += (
    # 'django.contrib.sites',
    #'wirecloud.oauth2provider',
    'social_django',
    'wirecloud.fiware',
)

# Login/logout URLs
LOGIN_URL = reverse_lazy('login')
LOGOUT_URL = reverse_lazy('wirecloud.root')
LOGIN_REDIRECT_URL = reverse_lazy('wirecloud.root')

THEME_ACTIVE = "wirecloud.defaulttheme"
DEFAULT_LANGUAGE = 'browser'

AUTHENTICATION_BACKENDS = (
'wirecloud.fiware.social_auth_backend.FIWAREOAuth2',
'django.contrib.auth.backends.ModelBackend',
)

# WGT deployment dirs
CATALOGUE_MEDIA_ROOT = path.join(BASEDIR, 'catalogue_resources')
GADGETS_DEPLOYMENT_DIR = path.join(BASEDIR, 'widget_files')

# Cache settings
CACHES = {
    'default': {
        'BACKEND': 'wirecloud.platform.cache.backends.locmem.LocMemCache',
        'OPTIONS': {
            'MAX_ENTRIES': 3000,
        },
    }
}

# WireCloud autodiscover Wirecloud plugins by default. Uncomment this for settings
# the list of plugins manually.
#
# WIRECLOUD_PLUGINS = (
#     'wirecloud.oauth2provider.plugins.OAuth2ProviderPlugin',
#     'wirecloud.fiware.plugins.FiWarePlugin',
# )

NOT_PROXY_FOR = ['localhost', '127.0.0.1']

FIWARE_IDM_SERVER = "https://account.lab.fiware.org"
SOCIAL_AUTH_FIWARE_KEY = "14f4a2b23d2c4d87b808cadd3210ccd3"
SOCIAL_AUTH_FIWARE_SECRET = "0d4edcb7757b4339a7bc67b470400790"
