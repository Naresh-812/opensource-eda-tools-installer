# 🏭 Physical Design (Place & Route)

### Naresh Lankalapalli

Tools for the physical design (backend) stage of ASIC design.

| Tool | Purpose | Script | Storage |
|------|---------|--------|---------|
| **OpenROAD** | Autonomous place-and-route (floorplan, placement, CTS, routing) | `install_openroad.sh` | ~5 GB |
| **OpenROAD deps** | All libraries OpenROAD needs (Abseil, OR-Tools, Boost, etc.) | `install_openroad_deps.sh` | ~10 GB |
| **KLayout** | GDSII/OASIS layout viewer and editor | `install_klayout.sh` | ~200 MB |

## ⚠️ Important: Install Order
```bash
# Step 1: Install dependencies FIRST
./install_openroad_deps.sh

# Step 2: Then install OpenROAD
./install_openroad.sh

# Step 3: KLayout (independent)
./install_klayout.sh
```

Or use the master installer which handles order automatically:
```bash
../install.sh --physical
```
