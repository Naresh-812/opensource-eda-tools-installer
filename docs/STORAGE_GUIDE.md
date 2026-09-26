# 💾 Storage Requirements Guide

### by **CIRCUIT_IQ** — *circuits to silicon*

---

## Per-Tool Storage Breakdown

| Category | Tool | Install Method | Storage (approx) | Build Time |
|----------|------|---------------|-------------------|------------|
| **RTL Design** | Yosys | apt | ~200 MB | ~2 min |
| | Verilator 5.038 | source build | ~800 MB | ~15-20 min |
| | Icarus Verilog | apt | ~50 MB | ~2 min |
| | GTKWave | apt | ~50 MB | ~2 min |
| **STA** | OpenSTA | source build | ~300 MB | ~10 min |
| | OpenTimer | source build | ~200 MB | ~5 min |
| **Physical Design** | OpenROAD deps | source build | ~8-10 GB | ~30-45 min |
| | OpenROAD | source build | ~3-5 GB | ~30-60 min |
| | KLayout | apt | ~200 MB | ~2 min |
| **Analog** | Ngspice | source build | ~500 MB | ~10-15 min |
| | Xschem | source build | ~200 MB | ~5 min |
| | Magic VLSI | source build | ~300 MB | ~10 min |
| | Netgen | apt | ~100 MB | ~2 min |
| **PDK** | SKY130 | source build | ~8-10 GB | ~30-60 min |
| **OpenLane** | Docker | apt/script | ~1-2 GB | ~5 min |
| | OpenLane | Docker pull | ~15-20 GB | ~30-45 min |
| **Extras** | RISC-V Toolchain | apt | ~200 MB | ~2 min |
| | IRSIM | apt | ~50 MB | ~2 min |

---

## Category Totals

| Category | Total Storage | Total Build Time |
|----------|--------------|-----------------|
| 📦 RTL Design | ~1.1 GB | ~25 min |
| ⏱️ STA | ~500 MB | ~15 min |
| 🏭 Physical Design | ~15 GB | ~90 min |
| 📐 Analog Design | ~1.1 GB | ~30 min |
| 🧬 SKY130 PDK | ~10 GB | ~60 min |
| 🚀 OpenLane | ~20 GB | ~45 min |
| 🎁 Extras | ~250 MB | ~5 min |
| **GRAND TOTAL** | **~48 GB** | **~4-5 hours** |

---

## Tips

- **Install only what you need** — you don't have to install everything
- **OpenROAD + PDK + OpenLane** are the biggest consumers (~45 GB combined)
- **Build directories** can be cleaned after installation to save space:
  ```bash
  rm -rf ~/eda-tools-build  # Saves ~20-30 GB
  ```
- **Docker images** can be pruned:
  ```bash
  docker system prune -a  # Reclaims unused Docker space
  ```

---

*CIRCUIT_IQ — circuits to silicon — Made with ❤️*
