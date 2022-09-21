#! /bin/bash

function displaytime {
  local T=$1
  run_d=$((T/60/60/24))
  run_h=$((T/60/60%24))
  run_m=$((T/60%60))
  local run_s=$((T%60))
}
