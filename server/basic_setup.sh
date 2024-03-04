#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
LIGHT_GRAY='\033[0;37m'
DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
LIGHT_YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_MAGENTA='\033[1;35m'
LIGHT_CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Emojis
CHECK_MARK="✅"
CROSS_MARK="❌"
WRENCH="🔧"
PARTY_POPPER="🎉"
ROCKET="🚀"
COMPUTER="💻"
WARNING="⚠️"

echo -e "${LIGHT_CYAN}Starting the user setup process...${NC} ${WRENCH}"

# Ensure the script is run with root privileges
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${LIGHT_RED}This script must be run as root${NC} ${CROSS_MARK}" >&2
  exit 1
fi

echo -e "\n${LIGHT_MAGENTA}Please enter the following user details.${NC} ${COMPUTER}"

# Prompt for user input
read -p "$(echo -e ${LIGHT_YELLOW}Enter username:${NC}) " username
read -p "$(echo -e ${LIGHT_YELLOW}Enter shell \(e.g., /bin/bash\):${NC}) " shell
read -p "$(echo -e ${LIGHT_YELLOW}Enter groups \(comma-separated, no spaces\):${NC}) " groups
read -s -p "${LIGHT_YELLOW}Enter password:${NC} " password
echo

# Inform the user about manual upgrade
echo -e "${WARNING}${LIGHT_YELLOW} Please remember to manually upgrade your system regularly to ensure it stays secure and up to date. You can do this by running 'sudo apt update && sudo apt upgrade' in the terminal.${NC}"

# Add a new user
echo -e "${CYAN}Adding new user '${username}'...${NC}"
if useradd -m "$username" -s "$shell" -G "$groups"; then
  echo -e "${GREEN}User '${username}' added successfully.${NC} ${CHECK_MARK}"
else
  echo -e "${RED}Failed to add user '${username}'.${NC} ${CROSS_MARK}" >&2
  exit 2
fi

# Set password for the new user
if echo "$username:$password" | chpasswd; then
  echo -e "${GREEN}Password for user '${username}' set successfully.${NC} ${CHECK_MARK}"
else
  echo -e "${RED}Failed to set password for user '${username}'.${NC} ${CROSS_MARK}" >&2
  exit 3
fi

echo -e "${MAGENTA}User setup process completed successfully.${NC} ${PARTY_POPPER}"
