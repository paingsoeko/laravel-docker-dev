# Laravel Docker Development Environment

This project is containerized using Docker to simplify the development workflow.

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Make](https://www.gnu.org/software/make/) (optional, but recommended for using the Makefile)

## Getting Started

### Quick Setup (using Make)

1.  Clone the repository.
2.  Run the setup command:
    ```bash
    make setup
    ```
    This command will:
    - Copy `.env.example` to `.env` if it doesn't exist.
    - Build and start the Docker containers.
    - Install PHP dependencies via Composer (ignoring `ext-http` and `ext-mysql_xdevapi` requirements).
    - Generate the application key.

### Manual Setup

1.  Copy the environment file:
    ```bash
    cp .env.example .env
    ```
2.  Build and start the containers:
    ```bash
    docker-compose up -d --build
    ```
3.  Install dependencies:
    ```bash
    docker-compose exec app_1 composer install --ignore-platform-req=ext-http --ignore-platform-req=ext-mysql_xdevapi
    ```
4.  Generate key:
    ```bash
    docker-compose exec app_1 php artisan key:generate
    ```

## Usage

Access the application at [http://localhost](http://localhost).
Access phpMyAdmin at [http://localhost:8080](http://localhost:8080).

### Common Commands

We have included a `Makefile` to simplify common tasks.

| Command | Description |
|Str |Str |
| `make up` | Start containers in detached mode |
| `make down` | Stop and remove containers |
| `make build` | Rebuild containers |
| `make shell` | Access the application container shell (bash) |
| `make logs` | View container logs |
| `make artisan cmd="..."` | Run Artisan commands (e.g., `make artisan cmd="migrate"`) |
| `make composer cmd="..."` | Run Composer commands (e.g., `make composer cmd="require package"`) |

### Examples

**Run migrations:**
```bash
make artisan cmd="migrate"
```

**Create a controller:**
```bash
make artisan cmd="make:controller UserController"
```

**Install a package:**
```bash
make composer cmd="require laravel/sanctum"
```

## Directory Structure & Configuration

- `src/`: Your Laravel application code.
- `nginx/`: Nginx configuration.
- `php/`: PHP Dockerfile and configuration.
- `docker-compose.yml`: Docker services definition.

> **Note:**
> You should place your Laravel application code in the `src` folder (or a subdirectory within it).
> The location of your application code is configured in the `.env` file using the `HOST_PATH` variable.
>
> Example `.env` configuration:
> ```ini
> HOST_PATH=src/your_project_name
> ```
> This path will be mounted to `/var/www/html` inside the container.
