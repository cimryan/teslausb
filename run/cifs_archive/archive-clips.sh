#!/bin/bash -eu

log "Moving clips to archive..."

NUM_FILES_MOVED=0

for file_name in "$CAM_MOUNT"/TeslaCam/saved*; do
  [ -e "$file_name" ] || continue
  log "Moving $file_name ..."
  mv -- "$file_name" "$ARCHIVE_MOUNT" >> "$LOG_FILE" 2>&1 || echo ""
  log "Moved $file_name."
  NUM_FILES_MOVED=$((NUM_FILES_MOVED + 1))
done
log "Moved $NUM_FILES_MOVED file(s)."

/root/bin/send-pushover "$NUM_FILES_MOVED"

log "Finished moving clips to archive."
