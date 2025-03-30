# Checker
Bash automation for SOC security drills and simulated attack scenarios.

# SOC Security Testing Automation Toolkit

## Introduction

The SOC Security Testing Automation Toolkit is a robust and interactive Bash script developed to support Security Operations Center (SOC) teams in executing simulated attack scenarios. It streamlines the testing of security protocols through automated and controlled simulations, including ARP spoofing, DDoS SYN floods, brute-force attacks leveraging Nmap and Hydra, and randomized attack sequences. The toolkit is designed to enhance the effectiveness of internal security training, incident response exercises, and security posture assessments.

**Disclaimer:** This toolkit is provided exclusively for educational purposes, ethical hacking training, and authorized internal security testing. Unauthorized use is strictly prohibited.

---

## Key Features

- **Interactive Command-line Interface:** Intuitive selection of simulated security attacks.
- **Flexible Targeting:** Manually select targets or automatically choose random IP addresses from detected network devices.
- **Supported Simulated Attack Techniques:**
  - ARP Spoofing
  - DDoS SYN Flood Simulation (using hping3)
  - Brute-force Attacks (with Nmap & Hydra)
  - Randomized Attack Execution
- **Comprehensive Logging:** Maintains detailed logs including timestamps, attack type, and target IP.

---

## System Requirements

The following tools must be installed and accessible within your environment:

- `nmap`
- `hydra`
- `ettercap`
- `hping3`
- `figlet` (optional, for ASCII art banner)

### Installation Example (Debian/Ubuntu):

```bash
sudo apt install nmap hydra ettercap-text-only hping3 figlet
```

---

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/EveRoy/Checker.git
cd checker
```

### Set Permissions

```bash
chmod +x chekcer.sh
```

### Execute the Script

```bash
./chekcer.sh
```
OR 
```bash
sudo ./chekcer.sh
```

Follow the guided prompts to select targets and execute simulated security tests.

---

## Logging

All attack simulations and relevant activities are logged and stored at:

```
~/attack_logs.log
```

---

## Contribution Guidelines

Your contributions are welcome! Please follow these steps:

- Fork the repository.
- Create a new branch for your feature or fix.
- Submit a detailed pull request.

---

## License

This toolkit is intended strictly for educational use only.


