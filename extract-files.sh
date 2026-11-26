#!/bin/bash
#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
# Proprietary blob extractor for TECNO POVA 6 Pro 5G (LI9)
# Firmware Base:  HiOS 15.1.2.170SP05
# Firmware Build: OP001PF001AZ
#
# Written in POSIX-compatible shell syntax so it runs cleanly under both
# bash (Linux/macOS AOSP build hosts) and POSIX sh/ash environments.
# Supports local extracted firmware dumps and ADB device pulls.
# Never modifies original firmware dumps, deletes user directories, or
# downloads blobs from external sources.

set -eu

DEVICE="li9"
VENDOR="tecno"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BLOB_LIST="${SCRIPT_DIR}/proprietary-files.txt"
if [ -z "${ANDROID_ROOT:-}" ]; then
    ANDROID_ROOT="$(cd "${SCRIPT_DIR}/../../.." 2>/dev/null && pwd || echo "${SCRIPT_DIR}")"
fi

SOURCE="adb"
OUTPUT_DIR="${ANDROID_ROOT}/vendor/${VENDOR}/${DEVICE}"
DRY_RUN=0
SKIP_MAKEFILES=0
USE_LINEAGE_UTILS=0

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] [SOURCE_DIR]

Extract proprietary blobs listed in proprietary-files.txt for TECNO POVA 6 Pro 5G (LI9).

Arguments:
  SOURCE_DIR            Local directory containing extracted partitions
                        (vendor/, vendor_dlkm/, system_dlkm/, system_ext/ or *_a/ variants),
                        or 'adb' to pull from a connected device (default: adb).

Options:
  -s, --source DIR      Same as positional SOURCE_DIR.
  -o, --output DIR      Target vendor tree root (default: <ANDROID_ROOT>/vendor/tecno/li9).
  -n, --dry-run         Validate all source blob paths without copying files.
      --skip-makefiles  Do not run setup-makefiles.sh after extraction.
      --use-lineage-utils Delegate to LineageOS tools/extract-utils if present.
  -h, --help            Show this help message.
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        -s|--source)
            [ $# -ge 2 ] || { echo "Error: $1 requires an argument." >&2; exit 2; }
            SOURCE="$2"
            shift 2
            ;;
        -o|--output)
            [ $# -ge 2 ] || { echo "Error: $1 requires an argument." >&2; exit 2; }
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -n|--dry-run)
            DRY_RUN=1
            shift
            ;;
        --skip-makefiles)
            SKIP_MAKEFILES=1
            shift
            ;;
        --use-lineage-utils)
            USE_LINEAGE_UTILS=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            echo "Error: Unknown option '$1'." >&2
            usage >&2
            exit 2
            ;;
        *)
            SOURCE="$1"
            shift
            ;;
    esac
done

if [ ! -f "${BLOB_LIST}" ]; then
    echo "Error: Blob list not found: ${BLOB_LIST}" >&2
    exit 1
fi

# Optional LineageOS extract-utils delegation when explicitly requested
if [ "${USE_LINEAGE_UTILS}" -eq 1 ]; then
    HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
    if [ ! -f "${HELPER}" ]; then
        echo "Error: LineageOS extract-utils helper not found at ${HELPER}" >&2
        exit 1
    fi
    # shellcheck disable=SC1090
    . "${HELPER}"
    setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false false
    extract "${BLOB_LIST}" "${SOURCE}"
    if [ "${SKIP_MAKEFILES}" -eq 0 ]; then
        "${SCRIPT_DIR}/setup-makefiles.sh" --output "${OUTPUT_DIR}"
    fi
    exit 0
fi

# Resolve a partition/relpath inside a local extracted dump (supports both vendor/ and vendor_a/)
resolve_local_path() {
    base_dir="$1"
    entry="$2"
    part="${entry%%/*}"
    rel="${entry#*/}"

    if [ -f "${base_dir}/${entry}" ]; then
        printf '%s\n' "${base_dir}/${entry}"
        return 0
    fi
    if [ -f "${base_dir}/${part}_a/${rel}" ]; then
        printf '%s\n' "${base_dir}/${part}_a/${rel}"
        return 0
    fi
    if [ -f "${base_dir}/system/${entry}" ]; then
        printf '%s\n' "${base_dir}/system/${entry}"
        return 0
    fi
    return 1
}

if [ "${SOURCE}" = "adb" ]; then
    if ! command -v adb >/dev/null 2>&1; then
        echo "Error: 'adb' not found in PATH. Pass a local extracted dump path with --source <DIR>." >&2
        exit 1
    fi
    if [ "${DRY_RUN}" -eq 0 ]; then
        adb get-state >/dev/null 2>&1 || {
            echo "Error: No ADB device detected. Connect device with USB debugging enabled or pass --source <DIR>." >&2
            exit 1
        }
    fi
else
    if [ ! -d "${SOURCE}" ]; then
        echo "Error: Source directory does not exist: ${SOURCE}" >&2
        exit 1
    fi
fi

PROP_OUT="${OUTPUT_DIR}/proprietary"
TOTAL=0
COPIED=0
MISSING=0
MISSING_SAMPLE=""
CR="$(printf '\r')"

echo "Extracting proprietary blobs for TECNO POVA 6 Pro 5G (LI9)"
echo "  Blob list : ${BLOB_LIST}"
echo "  Source    : ${SOURCE}"
echo "  Output    : ${PROP_OUT}"
if [ "${DRY_RUN}" -eq 1 ]; then
    echo "  Mode      : DRY RUN (no files will be written)"
fi

while IFS= read -r raw_line || [ -n "${raw_line}" ]; do
    line="${raw_line%"${CR}"}"
    line="${line%%#*}"
    # Trim leading/trailing ASCII spaces and tabs
    while :; do
        case "${line}" in
            " "*|"	"*) line="${line#?}" ;;
            *) break ;;
        esac
    done
    while :; do
        case "${line}" in
            *" "|*"	") line="${line%?}" ;;
            *) break ;;
        esac
    done
    [ -z "${line}" ] && continue

    # Strip optional leading '-' (Soong target marker) and trailing ';flags'
    line="${line#-}"
    line="${line%%;*}"

    case "${line}" in
        *:*)
            src_rel="${line%%:*}"
            dst_rel="${line#*:}"
            ;;
        *)
            src_rel="${line}"
            dst_rel="${line}"
            ;;
    esac

    TOTAL=$((TOTAL + 1))

    if [ "${SOURCE}" = "adb" ]; then
        if [ "${DRY_RUN}" -eq 1 ]; then
            COPIED=$((COPIED + 1))
            continue
        fi
        dst_file="${PROP_OUT}/${dst_rel}"
        mkdir -p "$(dirname -- "${dst_file}")"
        if adb pull "/${src_rel}" "${dst_file}" >/dev/null 2>&1; then
            COPIED=$((COPIED + 1))
        else
            MISSING=$((MISSING + 1))
            if [ "${MISSING}" -le 25 ]; then
                MISSING_SAMPLE="${MISSING_SAMPLE}  - ${src_rel}
"
            fi
        fi
    else
        if resolved="$(resolve_local_path "${SOURCE}" "${src_rel}")"; then
            if [ "${DRY_RUN}" -eq 0 ]; then
                dst_file="${PROP_OUT}/${dst_rel}"
                mkdir -p "$(dirname -- "${dst_file}")"
                cp -p "${resolved}" "${dst_file}"
            fi
            COPIED=$((COPIED + 1))
        else
            MISSING=$((MISSING + 1))
            if [ "${MISSING}" -le 25 ]; then
                MISSING_SAMPLE="${MISSING_SAMPLE}  - ${src_rel}
"
            fi
        fi
    fi
done < "${BLOB_LIST}"

echo "Summary: ${COPIED}/${TOTAL} blobs verified/copied, ${MISSING} missing."

if [ "${MISSING}" -gt 0 ]; then
    echo "Error: ${MISSING} proprietary blob(s) could not be found in '${SOURCE}':" >&2
    printf '%s' "${MISSING_SAMPLE}" >&2
    if [ "${MISSING}" -gt 25 ]; then
        echo "  ... and $((MISSING - 25)) more." >&2
    fi
    exit 1
fi

if [ "${DRY_RUN}" -eq 0 ] && [ "${SKIP_MAKEFILES}" -eq 0 ]; then
    "${SCRIPT_DIR}/setup-makefiles.sh" --output "${OUTPUT_DIR}"
fi

echo "Done."
