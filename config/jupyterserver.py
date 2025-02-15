import os
from dotenv import dotenv_values

# Load environment variables from the .env files
env_files = ['/workspace/config/config.env', '/workspace/config/secrets.env']
env_vars = {}
for file in env_files:
    env_vars.update(dotenv_values(file))

# Update the process environment if needed
os.environ.update(env_vars)

c = get_config()

# Server configuration
c.ServerApp.token = ''  # Disable token authentication
c.ServerApp.disable_check_xsrf = True  # Disable XSRF checks
c.ServerApp.ip = '0.0.0.0'  # Bind to all IP addresses
c.ServerApp.port = 8000  # Listen on port 8000
c.ServerApp.notebook_dir = '/workspace'  # Set the working directory
c.ServerApp.allow_origin = '*'  # Allow all cross-origin requests
c.ServerApp.cookie_secret_file = '/workspace/.jupyter/jupyterhub_cookie.secret'
c.ServerApp.log_level = 'INFO'
c.ServerApp.default_url = '/lab'  # Open JupyterLab by default
c.ServerApp.open_browser = False  # Do not open a browser on startup

c.LabApp.disable_check_for_updates = True
c.LabApp.check_for_updates_class = "jupyterlab.NeverCheckForUpdate"
c.ServerApp.token = os.environ.get('JUPYTER_TOKEN')