# Production Setup on Raspberry Pi

## 1. Install Docker

```bash
sudo apt update && sudo apt upgrade -y
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

Log out and back in, then verify:

```bash
docker --version
docker compose version
```

Enable Docker on boot:

```bash
sudo systemctl enable docker
```

## 2. Clone the repository

```bash
git clone <repo-url> house-keep
cd house-keep
```

## 3. Create the .env file

```bash
nano .env
```

Paste and fill in the values:

```
SECRET_KEY_BASE=<run: openssl rand -hex 64>
HOUSE_KEEP_DATABASE_PASSWORD=<choose a password>
```

## 4. Start the app

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

Check logs:

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml logs -f
```

## 5. Set up auto-start on boot

Create the systemd service:

```bash
sudo nano /etc/systemd/system/house-keep.service
```

Paste the following (adjust `WorkingDirectory` if your path differs):

```ini
[Unit]
Description=House Keep
Requires=docker.service
After=docker.service network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/joao/house-keep
ExecStart=/usr/bin/docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
ExecStop=/usr/bin/docker compose -f docker-compose.yml -f docker-compose.prod.yml down
TimeoutStartSec=300

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable house-keep
sudo systemctl start house-keep
```

Verify:

```bash
sudo systemctl status house-keep
```

## Useful commands

| Action | Command |
|---|---|
| Start | `sudo systemctl start house-keep` |
| Stop | `sudo systemctl stop house-keep` |
| Restart | `sudo systemctl restart house-keep` |
| Status | `sudo systemctl status house-keep` |
| Logs | `docker compose -f docker-compose.yml -f docker-compose.prod.yml logs -f` |
| Rebuild after deploy | `docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build` |
