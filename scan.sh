#!/bin/bash

# Automated Network Reconnaissance Script
# Author: Dev Town
# Description: A simple script to automate Nmap scans

# Print banner
echo "=========================================="
echo "    Automated Network Reconnaissance"
echo "          Using Nmap and Bash"
echo "=========================================="

# Check if Nmap is installed
if ! command -v nmap &> /dev/null; then
    echo "Error: Nmap is not installed or not in PATH."
    echo "Please install Nmap before running this script."
    exit 1
fi

# Get the target from user input
read -p "Enter the target IP or domain: " target

# Create results directory if it doesn't exist
mkdir -p results

# Create a filename based on target and timestamp
timestamp=$(date +%Y%m%d_%H%M%S)
filename="results/${target}_${timestamp}_scan.txt"

echo "Scanning host: $target"
echo "Results will be saved in $filename"

# Header for the results file
echo "===========================================================" > "$filename"
echo "             Scan Results for $target" >> "$filename"
echo "             $(date)" >> "$filename"
echo "===========================================================" >> "$filename"

# Ping Scan
echo -e "\nRunning Ping Scan..." | tee -a "$filename"
echo -e "\n=== PING SCAN RESULTS ===\n" >> "$filename"
nmap -sn "$target" | tee -a "$filename"

# Basic Port Scan
echo -e "\nRunning Basic Port Scan..." | tee -a "$filename"
echo -e "\n=== PORT SCAN RESULTS ===\n" >> "$filename"
nmap "$target" | tee -a "$filename"

# Full Port Scan
echo -e "\nRunning Full Port Scan (this may take some time)..." | tee -a "$filename"
echo -e "\n=== FULL PORT SCAN RESULTS ===\n" >> "$filename"
nmap -p- "$target" | tee -a "$filename"

# OS Detection and Service Version Scan
echo -e "\nRunning OS Detection and Service Version Scan..." | tee -a "$filename"
echo -e "\n=== OS DETECTION AND SERVICE VERSION RESULTS ===\n" >> "$filename"
nmap -A "$target" | tee -a "$filename"

# Vulnerability Scan (optional, may require root privileges)
echo -e "\nWould you like to run a vulnerability scan? (requires root/sudo privileges) (y/n)"
read -p "Your choice: " run_vuln_scan

if [[ "$run_vuln_scan" == "y" || "$run_vuln_scan" == "Y" ]]; then
    echo -e "\nRunning Vulnerability Scan..." | tee -a "$filename"
    echo -e "\n=== VULNERABILITY SCAN RESULTS ===\n" >> "$filename"
    nmap --script vuln "$target" | tee -a "$filename"
fi

echo -e "\nScan completed. Results saved to: $filename"
echo -e "Thank you for using Automated Network Reconnaissance Tool!" 