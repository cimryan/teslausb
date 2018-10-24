#!/bin/bash -eu

log "Moving clips to archive..."

local move_count=0

for file_name in "$CAM_MOUNT"/TeslaCam/saved*; do
  [ -e "$file_name" ] || continue
  log "Moving $file_name ..."
  mv -- "$file_name" "$ARCHIVE_MOUNT" >> "$LOG_FILE" 2>&1 || echo ""
  log "Moved $file_name."
  move_count=$((move_count + 1))
done
log "Moved $move_count file(s)."

/root/bin/send-pushover "$num_files_moved"

log "Finished moving clips to archive."
