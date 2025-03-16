#!/bin/bash

# 실행할 PaperMC 버전
PAPER_VERSION="1.21.4"
BUILD_VERSION="188"
JAR_FILE="paper-${PAPER_VERSION}-${BUILD_VERSION}.jar"

# 메모리 최적화 설정 (현재 램 사용량 고려하여 조정)
XMS="512M"   # 최소 힙 메모리
XMX="4G"     # 최대 힙 메모리 (기본 램 사용량 감안하여 5GB로 제한)

# 서버 실행 경로 설정 (스크립트가 위치한 폴더 기준)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# 서버 실행 로그 저장
LOG_FILE="$SCRIPT_DIR/minecraft-server.log"

# PaperMC 실행
java -Xms$XMS -Xmx$XMX \
     -XX:+UseG1GC \
     -XX:+ParallelRefProcEnabled \
     -XX:MaxGCPauseMillis=100 \
     -XX:+UnlockExperimentalVMOptions \
     -XX:+DisableExplicitGC \
     -XX:+AlwaysPreTouch \
     -XX:G1NewSizePercent=25 \
     -XX:G1MaxNewSizePercent=35 \
     -XX:G1HeapRegionSize=8M \
     -XX:G1ReservePercent=15 \
     -XX:G1HeapWastePercent=5 \
     -XX:G1MixedGCCountTarget=4 \
     -XX:InitiatingHeapOccupancyPercent=20 \
     -XX:G1MixedGCLiveThresholdPercent=90 \
     -XX:G1RSetUpdatingPauseTimePercent=5 \
     -XX:SurvivorRatio=32 \
     -XX:MaxTenuringThreshold=1 \
     -jar ./"$JAR_FILE" nogui | tee "$LOG_FILE"
