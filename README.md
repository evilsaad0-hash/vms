# EVILSAAD VM Toolkit

Run the toolkit directly from GitHub (the script automatically clones the full repository into `~/vms`):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/evilsaad0-hash/vms/main/main.sh)
```

Or clone and run it manually:

```bash
git clone https://github.com/evilsaad0-hash/vms.git
cd vms
chmod +x *.sh
bash main.sh
```

To choose a different clone directory for the one-line command:

```bash
VMS_INSTALL_DIR="$HOME/my-vm-toolkit" bash <(curl -fsSL https://raw.githubusercontent.com/evilsaad0-hash/vms/main/main.sh)
```
