#!/bin/bash

repos_base_dir="/mnt/nasbox/repos/el8"

# Start sync if base repo directory exist
if [[ -d "$repos_base_dir" ]] ; then
  # Start Sync
  rsync  -avSHP --progress --delete --exclude-from=/opt/scripts/excludes.txt rsync://rocky.deadbatteries.work/rocky  "$repos_base_dir" --delete-excluded
  # Download Rocky 8 repository key
  if [[ -e /mnt/nasbox/repos/el8/RPM-GPG-KEY-rockyofficial ]]; then
     exit
  else
      wget -P $repos_base_dir https://dl.rockylinux.org/pub/rocky/RPM-GPG-KEY-rockyofficial
  fi
fi