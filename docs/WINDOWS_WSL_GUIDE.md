# Windows WSL Setup Guide for EDA Tools

**CIRCUIT_IQ** — circuits to silicon

This guide will walk you through setting up these EDA tools on a Windows machine using Windows Subsystem for Linux (WSL). By the end, you'll be able to run Linux-based ASIC tools seamlessly on your Windows PC.

---

## Part 1: Installing WSL and Ubuntu

1. **Open PowerShell as Administrator**
   - Click the Start menu, type `PowerShell`, right-click on it, and select **Run as administrator**.

2. **Install WSL**
   - Run the following command:
     ```powershell
     wsl --install
     ```
   - This will automatically install WSL and download Ubuntu as the default Linux distribution.

3. **Restart Your Computer**
   - Once the installation completes, restart your PC.

4. **Set Up Your Linux Username and Password**
   - After restarting, a Linux terminal will automatically open.
   - It will ask you to create a **UNIX username** and **password**. (Remember this password; you will need it when running `sudo` commands for the installer).

---

## Part 2: Installing the EDA Tools

Now that Ubuntu is running, you can install the tools just like on a native Linux machine.

1. **Update Ubuntu**
   - Run this to make sure your new Ubuntu system is up to date:
     ```bash
     sudo apt update && sudo apt upgrade -y
     ```

2. **Clone the Installer Repository**
   - Run:
     ```bash
     git clone https://github.com/YOUR_USERNAME/opensource-eda-tools-installer.git
     cd opensource-eda-tools-installer
     ```

3. **Run the Installer**
   - Make the scripts executable:
     ```bash
     chmod +x install.sh verify.sh
     chmod +x **/*.sh
     ```
   - Launch the installer:
     ```bash
     ./install.sh
     ```
   - Type the number of the tool category you want to install, or `A` for all, and press Enter.

---

## Part 3: Setting up the GUI (Graphical User Interface)

Many EDA tools (like Magic, KLayout, and GTKWave) require a GUI to open windows.

### If you are on Windows 11
Windows 11 comes with WSLg built-in. GUI applications should open automatically without any extra setup! Just launch a tool (e.g., type `magic`), and the window will appear on your Windows desktop.

### If you are on Windows 10
You will need to install an "X Server" to display Linux windows.

1. **Download and Install VcXsrv on Windows:**
   - Download it from [here](https://sourceforge.net/projects/vcxsrv/).
   - Install it with default settings.
   - Launch **XLaunch** from your Start menu.
   - Important: Keep clicking Next, but on the "Extra Settings" screen, make sure **Disable access control** is CHECKED. Then finish.

2. **Configure Ubuntu to use VcXsrv:**
   - In your Ubuntu terminal, run:
     ```bash
     echo "export DISPLAY=\$(cat /etc/resolv.conf | grep nameserver | awk '{print \$2}'):0" >> ~/.bashrc
     echo "export LIBGL_ALWAYS_INDIRECT=1" >> ~/.bashrc
     source ~/.bashrc
     ```

---

## Part 4: How to Access Your Tools After a Reboot

When you turn off your PC and turn it back on later, here is how you access your tools:

1. **Open Ubuntu**
   - Click the Windows Start menu, type `Ubuntu`, and press Enter. This will open your Linux terminal.

2. **(Windows 10 only) Start your X Server**
   - If you are on Windows 10, remember to open **XLaunch** from your Start menu before trying to open any GUI tools.

3. **Launch your tools!**
   - Your tools are now installed globally on the Linux system. You can launch them from any directory by simply typing their name.
   - Examples:
     - `yosys`
     - `magic`
     - `klayout`
     - `openlane`

4. **Accessing Windows Files from Linux**
   - If you have design files saved on your Windows `C:` drive (for example, in your Documents folder), you can access them in Ubuntu at this path:
     ```bash
     cd /mnt/c/Users/YourWindowsUsername/Documents
     ```
   
5. **Accessing Linux Files from Windows**
   - If you want to view your Ubuntu files using Windows File Explorer, open File Explorer and type this into the address bar:
     ```text
     \\wsl$
     ```
     You will see an `Ubuntu` folder containing all your Linux files.

Happy designing!
