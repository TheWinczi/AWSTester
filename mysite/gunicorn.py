from mysite import settings

# Classic Gunicorn variables
command = str(settings.BASE_DIR / 'venv' / 'bin' / 'gunicorn')
pythonpath = str(settings.BASE_DIR)
bind = settings.BIND
workers = settings.WORKERS