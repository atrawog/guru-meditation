# Guru-Meditation

Guru-Meditation is a cloud-native AI workbench that integrates various tools and technologies to facilitate the development and deployment of AI-assisted DevOps systems. This workbench is designed to be self-hosted, providing flexibility and control over your AI and DevOps workflows.

## Goals & Purpose

### Keep Control of Your Code

Sending every bit of your code to a commercial AI provider isn't ideal. Even if you're writing and running 100% OpenSource software, it's important to maintain control over your codebase. Guru-Meditation allows you to keep your code secure and private by running your AI models locally.

### Run Any OpenSource AI Model You Want

While the costs and VRAM size of your GPU may be limiting factors for some time, even small and medium-sized models are becoming powerful enough to handle serious work. Guru-Meditation supports running various OpenSource AI models via Ollama, giving you the flexibility to choose the best model for your needs.

### Provide the AI with the Context and Documentation It Needs

Current AI services often provide subpar answers because they don't understand the context of your question or refer to outdated code or documentation. Running your AI locally enables you to use Continue.dev to create a LanceDB embedding database that includes both your complete codebase and up-to-date documentation. This provides your AI with the context it needs to answer project-related questions accurately.

## Included Tools

- **Arch Linux Container Image with CUDA Enabled**: This is a lightweight and flexible Linux distribution that comes with CUDA support for GPU acceleration. It provides a robust container environment for running AI and machine learning workloads efficiently.

- **Pixi.sh Conda-Forge / PyPi Environment for Common AI Tools**: Pixi.sh offers a pre-configured environment that includes popular AI tools from Conda-Forge and PyPi repositories. This simplifies the installation and management of AI libraries and dependencies, making it easier to set up and maintain your AI development environment.

- **Devcontainer Configuration for VS Code**: The development container configuration for Visual Studio Code includes Docker in Docker and SSH Forwarding. This setup allows developers to work in a consistent development environment, regardless of the underlying host system. It enhances productivity by providing seamless integration with VS Code's features.

- **Supervisord Config to Run JupyterHub and Ollama**: Supervisord is a process control system that enables you to manage and monitor processes. The provided configuration allows you to run JupyterHub and Ollama services efficiently. JupyterHub is a multi-user server for Jupyter notebooks, while Ollama is a tool for managing and deploying machine learning models.

- **Continue.dev Config for Ollama**: Continue.dev provides a configuration for running your own model and LanceDB Vector Database on your local system. This setup allows you to manage and query vector data efficiently, facilitating the development and deployment of AI models.

- **DevOps Tools**:
  - [Ansible](https://www.ansible.com/): Ansible is an open-source automation tool for configuration management, application deployment, and task automation. It simplifies complex tasks and ensures consistency across your infrastructure.
  - [OpenTofu](https://opentofu.org/): OpenTofu is an open-source infrastructure as code tool that allows you to define and provision infrastructure using a high-level configuration language. It helps manage and automate infrastructure deployments.
  - [Libvirt](https://libvirt.org/): Libvirt is an open-source API, daemon, and management tool for managing platform virtualization. It provides a consistent interface for managing virtual machines across different hypervisors.
  - [Kubectl](https://kubernetes.io/docs/reference/kubectl/): Kubectl is a command-line tool for interacting with Kubernetes clusters. It allows you to deploy applications, inspect and manage cluster resources, and view logs.
  - [Minikube](https://minikube.sigs.k8s.io/docs/): Minikube is a tool that runs a single-node Kubernetes cluster inside a virtual machine on your local machine. It is ideal for local development and testing of Kubernetes applications.

- **Jupyter Book Workflow for Documentation**: Jupyter Book is a tool for creating and managing documentation using Jupyter notebooks. It allows you to combine narrative text, code, and visualizations in a single document, making it an excellent choice for technical documentation and educational materials.

## Requirements

- [Docker](https://www.docker.com/): Docker is a platform that enables developers to build, ship, and run applications in containers. Containers are lightweight, portable, and ensure consistency across different environments.
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html): The NVIDIA Container Toolkit allows users to build and run GPU-accelerated Docker containers. It provides the necessary components to leverage NVIDIA GPUs within containers.
- A NVIDIA GPU with at least 16 GB of VRAM is required to handle the computational demands of AI workloads and ensure smooth performance.


## Getting Started

To get started with Guru-Meditation, follow these steps:

1. **Clone the repository**:
    ```sh
    git clone https://github.com/your-repo/guru-meditation.git
    cd guru-meditation
    ```

2. **Build the Docker image**:
    ```sh
    docker build -t guru-meditation .
    ```

3. **Run the Docker container**:
    ```sh
    docker run --gpus all -it --rm -p 8888:8888 guru-meditation
    ```

4. **Access JupyterHub**:
    Open your web browser and navigate to `http://localhost:8888` to access JupyterHub.

## Contributing

We welcome contributions to Guru-Meditation! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request on our [GitHub repository](https://github.com/your-repo/guru-meditation).

## License

This project is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.

## Acknowledgments

We would like to thank the developers and maintainers of the various tools and libraries integrated into Guru-Meditation.

# Pixi
mkdir -p /workspace/pixi/dev/jupyter
cd /workspace/pixi/dev/jupyter
sudo rm -rf pixi.* .pixi/
pixi init -c conda-forge -c pytorch -c nvidia
pixi add python=3.11
pixi add --pypi unsloth[colab-new]@git+https://github.com/unslothai/unsloth.git peft accelerate bitsandbytes torch torchvision torchaudio transformers mistral mistral-inference jupyterhub jupyter-ai jupyterlab mystmd jupyter-ai-magics jupyter-book==2.0.0a1  jupyterlab-myst langchain-ollama ansible ansible-runner libvirt-python huggingface-hub altair numpy pandas geopandas kubernetes nbdev papermill fastapi configurable-http-proxy bitsandbytes accelerate xformers==0.0.29 peft triton cut_cross_entropy unsloth_zoo protobuf datasets huggingface_hub hf_transfer tqdm ipywidgets trl pip openai langchain-openai langchain-aws langchain-anthropic langchain-cohere langchain-google-genai langchain-mistralai langchain-nvidia-ai-endpoints r5py
pixi run pip install vllm

pixi task add jupyterhub "python -m jupyterhub --config  /workspace/config/jupyterhub.py"
pixi task rm jupyterserver; pixi task add jupyterserver -- jupyter-server --config  /workspace/config/jupyterserver.py
pixi task rm jupyterserver-dev; pixi task add jupyterserver-dev -- jupyter-server --config  /workspace/config/jupyterserver-dev.py
pixi task add jupyterbook "python -m jupyter book start"

mkdir -p /workspace/pixi/dev/openwebui
cd /workspace/pixi/dev/openwebui
sudo rm -rf pixi.* .pixi/
pixi init -c conda-forge -c pytorch -c nvidia
pixi add python=3.11
pixi add --pypi open-webui
pixi task rm  openwebui; pixi task add openwebui -- DATA_DIR=/workspace/data/openwebui open-webui serve --port 3000
pixi task rm  openwebui-dev; pixi task add openwebui-dev -- DATA_DIR=/workspace/data/openwebui-dev open-webui serve --port 3001


# UV
rm -rf .venv pyproject.toml uv.lock 
uv init .
uv python install 3.11
uv add open-webui

# VLLM

vllm serve meta-llama/Llama-2-7b-hf \
    --port 8090 \
    --enable-lora \
    --lora-modules sql-lora=/workspace/.cache/huggingface/hub/models--yard1--llama-2-7b-sql-lora-test/snapshots/0dfa347e8877a4d4ed19ee56c140fa518470028c/

# Ports
jupyterserver: 8000
jupyterserver-dev: 8001

jupyterhub: 8010
jupyterhub-dev: 8011

