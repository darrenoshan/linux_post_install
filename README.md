# Linux Post Install Scripts

A collection of shell scripts designed to automate the installation and configuration of essential applications and tools across multiple Linux distributions. Each script streamlines the setup process for its respective distribution, saving time and ensuring consistency.

⚠️ **Use at your own risk.** These scripts are provided as-is, with no warranties or guarantees. See the [Disclaimer](#disclaimer) below for full details.

---

## Supported Distributions

- **Fedora**
- **Rocky**

Each script is self-contained and tailored to its specific distribution.

---

## Features

- **Automated Installation** – Installs commonly used packages and tools for each distribution
- **Distribution-Specific Optimizations** – Tailored commands and package managers for each distro
- **Flathub Integration** – Adds the Flathub repository where applicable for broader application availability
- **Independent Scripts** – Each script can be run standalone without dependencies on other files
- **Regular Updates** – Scripts are updated to support new distribution versions and packages

---

## Prerequisites

- A supported Linux distribution (preferably fresh installation)
- Active internet connection
- Sudo privileges
- Basic familiarity with terminal commands

---

## Usage

### Direct Execution (if you accept the [Disclaimer](#disclaimer))

You can run scripts directly from the repository without cloning:

**Fedora: Server**
```bash
curl -Ls https://raw.githubusercontent.com/darrenoshan/linux_post_install/refs/heads/main/fedora/server/run.sh | sudo bash
```

**Fedora: Workstation**
```bash
curl -Ls https://raw.githubusercontent.com/darrenoshan/linux_post_install/refs/heads/main/fedora/workstation/run.sh | sudo bash
```

**Rocky Linux:**
```bash
curl -Ls https://raw.githubusercontent.com/darrenoshan/linux_post_install/refs/heads/main/rocky/10/run.sh | sudo bash
```

---

## Customization

Each script is designed to be easily customizable. You can:

1. Fork the repository
2. Edit the script for your distribution
3. Add or remove packages based on your needs
4. Submit a pull request if you'd like to share your improvements

---

## Disclaimer

This project is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and noninfringement. In no event shall the author(s) be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from or in connection with the scripts or the use or other dealings in the software.

These scripts are personal projects and are **not affiliated with or endorsed by any Linux distribution, the Fedora Project, Canonical, Arch Linux, SUSE, or any other organization**.

**Always review scripts before executing them with sudo privileges.**

---

## Contributing

Contributions are welcome! If you have:

- Scripts for additional distributions
- Improvements to existing scripts
- Bug fixes or optimizations
- Documentation enhancements

Please feel free to:

1. Open an issue for discussion
2. Fork the repository
3. Create a feature branch
4. Submit a pull request

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## FAQ

**Q: Can I run these scripts on an existing installation?**  
A: Yes, but they're optimized for fresh installations. Review the script carefully to avoid conflicts with existing configurations.

**Q: What if my distribution isn't listed?**  
A: Feel free to open an issue requesting support, or contribute a script for your distribution!

**Q: Are these scripts safe?**  
A: The scripts are open source and can be reviewed before running. However, always exercise caution when running scripts with sudo privileges.

**Q: Will these scripts be updated for new distribution versions?**  
A: Yes, scripts will be updated as new versions are released. Check back regularly or watch the repository for updates.