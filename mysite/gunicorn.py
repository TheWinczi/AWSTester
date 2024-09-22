from mysite import settings

# Classic Gunicorn variables
command = settings.BASE_DIR / 'venv' / 'bin' / 'gunicorn'
pythonpath = settings.BASE_DIR
bind = settings.BINF
workers = settings.WORKERS