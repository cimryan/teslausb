#!/bin/bash -eu

log "Moving clips to archive..."

NUM_FILES_MOVED=0

for file_name in "$CAM_MOUNT"/TeslaCam/saved*; do
  [ -e "$file_name" ] || continue
  log "Moving $file_name ..."
  
  if mv -f -t "$ARCHIVE_MOUNT" -- "$file_name" >> "$LOG_FILE" 2>&1
  then
    log "Moved $file_name."
    NUM_FILES_MOVED=$((NUM_FILES_MOVED + 1))
  else
    log "Failed to move $file_name."
  fi
  
done
log "Moved $NUM_FILES_MOVED file(s)."

if [ $NUM_FILES_MOVED -gt 0 ]
then
/root/bin/send-pushover "$NUM_FILES_MOVED"
fi

log "Finished moving clips to archive."
