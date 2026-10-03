# 🔧 Troubleshooting Guide

### by Naresh Lankalapalli

---

## Common Issues and Solutions

### 1. Docker Permission Denied

**Error:** `Got permission denied while trying to connect to the Docker daemon socket`

**Solution:**
```bash
sudo usermod -aG docker $USER
```
Then **logout and login again** (or restart your terminal).

Verify:
```bash
docker run hello-world
```

---

### 2. GUI Applications Not Opening (WSL)

**Windows 11:** WSLg is built-in, GUI apps should work automatically.

**Windows 10:** Install an X Server:
- [VcXsrv](https://sourceforge.net/projects/vcxsrv/)
- [Xming](https://sourceforge.net/projects/xming/)

Then set:
```bash
export DISPLAY=:0
```

Add to `~/.bashrc` to make permanent:
```bash
echo 'export DISPLAY=:0' >> ~/.bashrc
```

---

### 3. OpenGL / Mesa Errors

```bash
sudo apt install mesa-utils libgl1 libglx-mesa0 libgl1-mesa-dri x11-apps -y
```

Test:
```bash
glxgears   # Should show spinning gears
```

---

### 4. Build Fails with Out of Memory

Large tools like OpenROAD can consume a lot of RAM during compilation.

**Solution:** Reduce parallel jobs:
```bash
export JOBS=2
# Then re-run the installer
```

Or add swap:
```bash
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

---

### 5. CMake Version Issues

Some tools need a specific CMake version.

**Check version:**
```bash
cmake --version
```

**Install specific version via pipx:**
```bash
pipx install cmake==3.29.6
pipx ensurepath
export PATH=$HOME/.local/bin:$PATH
```

---

### 6. `dos2unix` Errors (Windows Line Endings)

If you edited scripts on Windows:
```bash
sudo apt install dos2unix -y
dos2unix *.sh
dos2unix **/*.sh
```

---

### 7. Git Clone Fails

**Check internet:**
```bash
ping -c 3 github.com
```

**If behind proxy:**
```bash
git config --global http.proxy http://proxy.example.com:8080
```

---

### 8. SKY130 PDK Build Fails

The PDK build downloads a large amount of data. Common issues:
- **Disk space:** Need ~10 GB free. Check with `df -h`
- **Network timeout:** Run on a stable connection
- **Missing deps:** Run `./install.sh --analog` first to install Magic/Xschem

---

### 9. OpenROAD CMake Configure Fails

Ensure all dependencies are installed:
```bash
./03-physical-design/install_openroad_deps.sh
```

Check the CMake log:
```bash
cat ~/eda-tools-build/logs/openroad_cmake.log
```

---

### 10. Tool Not Found After Install

Refresh your shell:
```bash
source ~/.bashrc
hash -r
```

Or open a new terminal.

---

## 📋 Getting Help

1. Check the build logs in `~/eda-tools-build/logs/`
2. Run `./verify.sh` to see what's installed vs. missing
3. Open an issue on GitHub with:
   - Your OS version (`lsb_release -a`)
   - The error message
   - The relevant log file

---

*Naresh Lankalapalli — Made with ❤️*
