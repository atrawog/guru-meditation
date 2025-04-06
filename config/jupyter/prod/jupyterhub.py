# Configuration file for JupyterHub
import os
from dotenv import dotenv_values

c = get_config()  # Initialize configuration first

# Load environment variables from .env files (for other variables if needed)
env_files = ['/workspace/config.env', '/workspace/config-prod.env','/workspace/secrets.env']
env_vars = {}
for file in env_files:
    env_vars.update(dotenv_values(file))

# Get environment variables directly from OS environment with fallbacks
jh_data_dir = os.environ.get('JH_DATA_DIR', '/workspace/data/jupyterhub/prod')
jh_port = os.environ.get('JH_PORT', '8010')

# Core configuration
c.JupyterHub.authenticator_class = 'pam'
c.Authenticator.allowed_users = {'gm'}
c.JupyterHub.bind_url = f'http://:{jh_port}'
c.JupyterHub.log_level = 'DEBUG'

# Path configurations using JH_DATA_DIR
c.JupyterHub.cookie_secret_file = f'{jh_data_dir}/jupyterhub_cookie.secret'
c.JupyterHub.db_url = f'sqlite:///{jh_data_dir}/jupyterhub.sqlite'
c.ConfigurableHTTPProxy.pid_file = f'{jh_data_dir}/jupyterhub-proxy.pid'

# Spawner configuration
c.Spawner.environment = env_vars
c.Spawner.default_url = '/lab'
c.Spawner.notebook_dir = '/workspace'
c.Spawner.debug = True
c.Spawner.args = [
    '--NotebookApp.token=""',
    '--NotebookApp.disable_check_xsrf=True',
    f'--NotebookApp.cookie_secret_file={jh_data_dir}/jupyterhub_cookie.secret'
]

# Notebook/Lab configuration
c.NotebookApp.allow_origin = '*'
c.NotebookApp.disable_check_xsrf = True
c.LabApp.disable_check_for_updates = True

# Security and authentication
c.PAMAuthenticator.open_sessions = False
c.Authenticator.admin_users = {'gm'}