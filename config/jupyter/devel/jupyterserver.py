import os
from dotenv import dotenv_values

# Save the original environment variables before processing .env files
original_env = os.environ.copy()

env_files = [
    '/workspace/config.env',
    '/workspace/secrets.env'
]
env_vars = {}
protected_vars = {'JS_DATA_DIR', 'JS_PORT'}

for file in env_files:
    current_vars = dotenv_values(file)
    # Filter out protected variables already set in the original environment
    filtered_vars = {
        k: v for k, v in current_vars.items()
        if k not in protected_vars or k not in original_env
    }
    env_vars.update(filtered_vars)

# Update the environment with the filtered variables
os.environ.update(env_vars)

# Get values directly from the environment (prioritizes existing variables)
js_data_dir = os.environ.get('JS_DATA_DIR', '/workspace/data/jupyterserver/devel')
js_port = int(os.environ.get('JS_PORT', '8011'))
c = get_config()

# Server configuration
c.ServerApp.disable_check_xsrf = True  # Disable XSRF checks
c.ServerApp.ip = '0.0.0.0'  # Bind to all IP addresses
c.ServerApp.port = js_port  # Listen on port 8000
c.ServerApp.root_dir = '/workspace'  # Set the working directory
c.ServerApp.allow_origin = '*'  # Allow all cross-origin requests
c.ServerApp.cookie_secret_file = f'{js_data_dir}/jupyterserver_cookie.secret'
c.ServerApp.log_level = 'INFO'
c.ServerApp.default_url = '/lab'  # Open JupyterLab by default
c.ServerApp.open_browser = False  # Do not open a browser on startup
c.IdentityProvider.token = os.environ.get('JUPYTER_TOKEN')