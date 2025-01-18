# Guru-Meditation

Guru-Meditation is a cloud-native AI workbench that integrates various tools and technologies to facilitate the development and deployment of AI-assisted DevOps systems. This workbench is designed to be self-hosted, providing flexibility and control over your AI and DevOps workflows.

## Requirements

- [Docker](https://www.docker.com/): Docker is a platform that enables developers to build, ship, and run applications in containers. Containers are lightweight, portable, and ensure consistency across different environments.
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html): The NVIDIA Container Toolkit allows users to build and run GPU-accelerated Docker containers. It provides the necessary components to leverage NVIDIA GPUs within containers.
- GPU with 16 GB NVRAM: A powerful GPU with at least 16 GB of NVRAM is required to handle the computational demands of AI workloads and ensure smooth performance.

## Included Tools

- **Arch Linux Container Image with CUDA enabled**: This is a lightweight and flexible Linux distribution that comes with CUDA support for GPU acceleration. It provides a robust environment for running AI and machine learning workloads efficiently.

- **Pixi.sh Conda-Forge / PyPi environment for common AI Tools**: Pixi.sh offers a pre-configured environment that includes popular AI tools from Conda-Forge and PyPi repositories. This simplifies the installation and management of AI libraries and dependencies, making it easier to set up and maintain your AI development environment.

- **Devcontainer configuration for VS Code**: The development container configuration for Visual Studio Code includes Docker in Docker and SSH Forwarding. This setup allows developers to work in a consistent development environment, regardless of the underlying host system. It enhances productivity by providing a seamless integration with VS Code's features.

- **Supervisord Config to run JupyterHub and Ollama**: Supervisord is a process control system that enables you to manage and monitor processes. The provided configuration allows you to run JupyterHub and Ollama services efficiently. JupyterHub is a multi-user server for Jupyter notebooks, while Ollama is a tool for managing and deploying machine learning models.

- **Continue.dev config for Ollama**: Continue.dev provides a configuration for running your own model and LanceDB Vector Database on your local system. This setup allows you to manage and query vector data efficiently, facilitating the development and deployment of AI models.

- **DevOps Tools**:
  - [Ansible](https://www.ansible.com/): Ansible is an open-source automation tool for configuration management, application deployment, and task automation. It simplifies complex tasks and ensures consistency across your infrastructure.
  - [OpenTofu](https://opentofu.org/): OpenTofu is an open-source infrastructure as code tool that allows you to define and provision infrastructure using a high-level configuration language. It helps manage and automate infrastructure deployments.
  - [Libvirt](https://libvirt.org/): Libvirt is an open-source API, daemon, and management tool for managing platform virtualization. It provides a consistent interface for managing virtual machines across different hypervisors.
  - [Kubectl](https://kubernetes.io/docs/reference/kubectl/): Kubectl is a command-line tool for interacting with Kubernetes clusters. It allows you to deploy applications, inspect and manage cluster resources, and view logs.
  - [Minikube](https://minikube.sigs.k8s.io/docs/): Minikube is a tool that runs a single-node Kubernetes cluster inside a virtual machine on your local machine. It is ideal for local development and testing of Kubernetes applications.

- **Jupyter Book workflow for documentation**: Jupyter Book is a tool for creating and managing documentation using Jupyter notebooks. It allows you to combine narrative text, code, and visualizations in a single document, making it an excellent choice for technical documentation and educational materials.

## Getting Started

To get started with Guru-Meditation, follow these steps:

1. **Clone the repository**:
    ```sh
    git clone https://github.com/atrawog/guru-meditation.git
    cd guru-meditation
    ```

2. **Build the Container image**:
    ```sh
    just build
    ```

3. **Run the Container image**:
    ```sh
    just shell
    ```

4. **Access JupyterHub**:
    Open your web browser and navigate to `http://localhost:8000` to access JupyterHub.

## Contributing

We welcome contributions to Guru-Meditation! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request on our [GitHub repository](https://github.com/atrawog/guru-meditation).

## License

This project is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License