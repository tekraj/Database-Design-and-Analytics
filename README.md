# Database-Design-and-Analytics

This repository includes a Docker Compose setup for:

1. MySQL 8.4
2. PostgreSQL 16
3. MongoDB 7

The stack uses local persistent folders under data so your database data survives container restarts.

## Prerequisites

1. Docker Engine + Docker Compose (Linux Ubuntu), or Docker Desktop (Windows/macOS)
2. Git (optional, for cloning)

## Required Local Folders

Create these folders before starting the stack:

1. data/mysql
2. data/pgsql
3. data/mongodb

From the project root, run:

```bash
mkdir -p data/mysql data/pgsql data/mongodb
```

## Run With Docker Compose

Run from the project root where docker-compose.yml exists.

### Linux (Ubuntu)

1. Start services:

```bash
docker compose up -d
```

2. Check status:

```bash
docker compose ps
```

3. View logs:

```bash
docker compose logs -f
```

4. Stop services:

```bash
docker compose down
```

### Windows (Docker Desktop)

Use PowerShell from the repository root.

1. Create folders:

```powershell
mkdir data\mysql, data\pgsql, data\mongodb
```

2. Start services:

```powershell
docker compose up -d
```

3. Check status:

```powershell
docker compose ps
```

4. Stop services:

```powershell
docker compose down
```

### macOS (Docker Desktop)

Use Terminal from the repository root.

1. Create folders:

```bash
mkdir -p data/mysql data/pgsql data/mongodb
```

2. Start services:

```bash
docker compose up -d
```

3. Check status:

```bash
docker compose ps
```

4. Stop services:

```bash
docker compose down
```

## Database Connection Details

Use localhost because ports are published to your host machine.

### MySQL

1. Host: localhost
2. Port: 3306
3. Username: app_user
4. Password: 1234_12ASDF
5. Database: app_db
6. Root user: root
7. Root password: 1234_Asdf

### PostgreSQL

1. Host: localhost
2. Port: 5432
3. Username: app_user
4. Password: 1234_Asdf
5. Database: app_db

### MongoDB

1. Host: localhost
2. Port: 27017
3. Username: root
4. Password: 1234_Asdf
5. Authentication Database: admin

## Connect Using GUI Clients

### MySQL Workbench (MySQL)

1. Open MySQL Workbench.
2. Create a new connection.
3. Set Hostname to localhost and Port to 3306.
4. Set Username to app_user.
5. Store password 1234_12ASDF.
6. Connect and select schema app_db.

### pgAdmin (PostgreSQL)

1. Open pgAdmin.
2. Right-click Servers, then Register > Server.
3. In General, set any Name (for example local-postgres).
4. In Connection:
	Host name/address: localhost
	Port: 5432
	Maintenance database: app_db
	Username: app_user
	Password: 1234_Asdf
5. Save and connect.

### MongoDB Compass (MongoDB interface)

Use this connection string:

```text
mongodb://root:1234_Asdf@localhost:27017/?authSource=admin
```

### DBeaver (or "DBWeaver")

DBeaver can connect to all three databases.

1. Open DBeaver and click New Database Connection.
2. Choose MySQL, PostgreSQL, or MongoDB.
3. Use the same host, port, username, password, and database values listed above.
4. Test Connection, then Finish.

## Useful Commands

1. Start only one service:

```bash
docker compose up -d mysql
docker compose up -d postgres
docker compose up -d mongodb
```

2. Restart one service:

```bash
docker compose restart mysql
```

3. Show recent logs:

```bash
docker compose logs --tail=100 mysql
docker compose logs --tail=100 postgres
docker compose logs --tail=100 mongodb
```

## Notes

1. These credentials are hardcoded in docker-compose.yml for local development convenience.
2. For shared environments, replace them with stronger secrets before use.