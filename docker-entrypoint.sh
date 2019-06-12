#!/bin/bash
set -e
SERVICES="/opt/lliurex-smart/smart-product-drivers/SMARTBoardService"
for s in "$SERVICES"; do
    $s &
done
exec /opt/SMART\ Technologies/SMART\ Product\ Drivers/bin/.SMART\ Board\ Tools_elf