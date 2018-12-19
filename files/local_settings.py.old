import ldap
from django_auth_ldap.config import LDAPSearch

STATIC_ROOT = "/home/user/site/static/"
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.filebased.FileBasedCache',
        'LOCATION': '/home/user/site/cache/',
    }
}
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'dmoj',
        'USER': 'dmoj',
        'PASSWORD': 'edf123=4',
        'HOST': '',
        'PORT': '',
    }
}
ALLOWED_HOSTS = ['localhost', '127.0.0.1', '[::1]', u'dsp0722618.postes.calibre.edf.fr']
AUTHENTICATION_BACKENDS = [
    'django_auth_ldap.backend.LDAPBackend',
    'django.contrib.auth.backends.ModelBackend',
]
AUTH_LDAP_SERVER_URI = 'ldaps://noe-gardiansesame.edf.fr'

AUTH_LDAP_BIND_DN = 'uid=9TPTI001,ou=Applis,dc=gardiansesame'
AUTH_LDAP_BIND_PASSWORD = 'h+hGXe7U'
AUTH_LDAP_USER_SEARCH = LDAPSearch(
    'ou=people,dc=gardiansesame',
    ldap.SCOPE_SUBTREE,
    '(uid=%(user)s)',
)
AUTH_LDAP_USER_ATTR_MAP = {
    'first_name': 'givenName',
    'last_name': 'sn',
    'email': 'mail',
}

AUTH_LDAP_ALWAYS_UPDATE_USER = True
AUTH_LDAP_FIND_GROUP_PERMS = False
ldap.set_option( ldap.OPT_X_TLS_REQUIRE_CERT, ldap.OPT_X_TLS_NEVER ) 
AUTH_LDAP_AUTHORIZE_ALL_USERS = True

ACE_URL = '/static/libs/ace/'


EVENT_DAEMON_USE = True
EVENT_DAEMON_GET = 'ws://dsp0722618.postes.calibre.edf.fr:15100'
EVENT_DAEMON_POST = 'ws://dsp0722618.postes.calibre.edf.fr:15101'
EVENT_DAEMON_POLL = 'http://dsp0722618.postes.calibre.edf.fr:15102'
EVENT_DAEMON_KEY = None

