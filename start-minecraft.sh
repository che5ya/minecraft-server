#!/bin/bash

# ===== PaperMC Server Start Script Guide =====
# Assumes JAR file is in './papermc' folder
# Edit XMS/XMX based on available RAM
# Stop server: type 'stop' or press Ctrl+C
# Run in background:
#   nohup ./start-minecraft.sh &
#   screen -S minecraft ./start-minecraft.sh
#   tmux new -s minecraft './start-minecraft.sh'
# For persistent/auto-start:
#   Use systemd service (see docs/setup-systemd.md)
# =============================================

# Target PaperMC version to run
PAPER_VERSION="1.21.4"
BUILD_VERSION="231"
JAR_FILE="paper-${PAPER_VERSION}-${BUILD_VERSION}.jar"

# Memory optimization settings (adjusted based on current RAM usage)
XMS="2G"   # Minimum heap memory
XMX="3G"   # Maximum heap memory (limited to 5GB considering base RAM usage)

# Set the working directory (based on the script's location)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Set log file path for server output
LOG_FILE="$SCRIPT_DIR/minecraft-server.log"

# Run the PaperMC server
java -Xms$XMS -Xmx$XMX \
     -XX:+UseG1GC \
     -XX:+ParallelRefProcEnabled \
     -XX:MaxGCPauseMillis=100 \
     -XX:+UnlockExperimentalVMOptions \
     -XX:+DisableExplicitGC \
     -jar ./papermc/"$JAR_FILE" nogui | tee "$LOG_FILE"

# Check if the server started successfully
if [ $? -ne 0 ]; then
    echo "Failed to start the Minecraft server. Check $LOG_FILE for details."
    exit 1
fi

# Print server start message
echo "Minecraft server started successfully. Logs are being written to $LOG_FILE."

# Keep the script running to maintain the server process
while true; do
    sleep 60
done
