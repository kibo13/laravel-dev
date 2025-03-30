## Laravel Docker Environment

This repository provides a Docker-based environment for managing Laravel projects without installing dependencies on the local machine. It includes a `docker-compose.yml` file for running Composer inside a container and a `Makefile` for simplified project creation.

### Available Commands

```sh
# Create project
make po-new name=your_project

# Set env variables
make po-env name=your_project

# Install Sail
make po-install name=your_project

# Open shell
make po-sh name=your_project

# Full init (new + env + install)
make po-init name=your_project
```
