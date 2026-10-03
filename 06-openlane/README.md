# 🚀 OpenLane — RTL-to-GDSII

### Naresh Lankalapalli

OpenLane is a complete automated RTL-to-GDSII flow running inside Docker.

| Tool | Purpose | Script | Storage |
|------|---------|--------|---------|
| **Docker** | Container platform required by OpenLane | `install_docker.sh` | ~2 GB |
| **OpenLane** | Automated RTL-to-GDSII flow | `install_openlane.sh` | ~20 GB |

## ⚠️ Install Order
```bash
# Step 1: Docker first
./install_docker.sh

# Step 2: LOGOUT and LOGIN again (for Docker group permissions)

# Step 3: Verify Docker works
docker run hello-world

# Step 4: Install OpenLane
./install_openlane.sh
```

## After Installation
```bash
openlane   # Launches OpenLane Docker environment
```
