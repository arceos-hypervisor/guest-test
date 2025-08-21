#!/bin/bash
make -C .arceos A=$(pwd) LOG=info QEMU_ARGS="--machine gic-version=3" LD_SCRIPT=link.x FEATURES=driver-dyn MYPLAT=axplat-aarch64-dyn run