# 🧬 SKY130 Process Design Kit

### Naresh Lankalapalli

The SkyWater SKY130 is a 130nm open-source PDK.

| Tool | Purpose | Script | Storage |
|------|---------|--------|---------|
| **SKY130 OpenPDKs** | Process design kit with tech files for all tools | `install_sky130_pdk.sh` | ~10 GB |
| **SKY130 Launchers** | Smart wrappers for Magic & Xschem (normal vs SKY130 mode) | `install_sky130_launchers.sh` | negligible |

## ⚠️ Prerequisites
Install analog tools first (Magic, Xschem):
```bash
../install.sh --analog
```

## Install
```bash
./install_sky130_pdk.sh          # Takes ~30-60 minutes
./install_sky130_launchers.sh    # Instant
```
