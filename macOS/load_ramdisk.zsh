#!/usr/bin/env -S zsh -f

load_ramdisk() {
  local -r DISK_NAME=${1:-Workbench}
  integer -r DISK_SIZE=${2:-16}
  local -r SIZE_UNIT=${3:-GiB}
  local -r DISK_PATH="/Volumes/${DISK_NAME}"

  if [[ -d $DISK_PATH ]]; then
    print -u 2 -- "$0: RAM Disk ${DISK_NAME} already exists"
    return 0
  fi

  case ${(L)SIZE_UNIT} in
    gib|gb) integer -r shift_amount=30;;
    mig|mb) integer -r shift_amount=20;;
    *)      print -u 2 -- "$0: Invalid unit"; exit 64  # BSD EX_USAGE
  esac

  integer -r block_size=512
  integer -r sector_count=$(( DISK_SIZE * ( 1 << shift_amount ) / block_size ))

  local -r device_path=${$(hdiutil attach -nomount ram://$sector_count)[(w)1]}
  if [[ -z $device_path ]]; then
    print -u 2 -- "$0: Failed to allocate RAM device"
    return 1
  fi

  if newfs_apfs -v "$DISK_NAME" $device_path; then
    diskutil mount "$DISK_NAME"
    touch "${DISK_PATH}/.metadata_never_index"
    mdutil -i off "$DISK_PATH"
  else
    print -u 2 -- "$0: Formatting failed"
    hdiutil detach "$device_path"
    return 1
  fi
}

if [[ $ZSH_EVAL_CONTEXT == toplevel ]]; then
  load_ramdisk "$@"
fi
