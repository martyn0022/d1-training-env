#!/bin/bash
# Runs under /iris-main's -a hook, which fires AFTER IRIS has already started.
# Never call "iris start" here -- it fails with "database already running" and
# takes the container down with it.
set -e

echo "[d1-setup] running first-start setup"
iris session IRIS -U %SYS < /opt/d1/setup/setup.script
echo "[d1-setup] hook finished"
