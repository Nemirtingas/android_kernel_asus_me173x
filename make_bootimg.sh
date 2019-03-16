#! /bin/bash

COMP="gzip"

function build_ramdisk
{
    pushd "${IMG}" >/dev/null
    find . | cpio -H newc -o |$COMP >"../${IMG}.img-ramdisk.comp"
    popd >/dev/null
}

function build_img
{
    BOOT_ARGS=()
    BOOT_ARGS+=("--kernel" "${IMG}.img-zImage")
    BOOT_ARGS+=("--ramdisk" "${IMG}.img-ramdisk.comp")
    BOOT_ARGS+=("--base" "0x10000000")
    BOOT_ARGS+=("--kernel_offset" "0x00008000")
    BOOT_ARGS+=("--second_offset" "0x00f00000")
    BOOT_ARGS+=("--tags_offset" "0x00000100")
    BOOT_ARGS+=("--pagesize" "2048")
    BOOT_ARGS+=("--ramdisk_offset" "0x01000000")
    BOOT_ARGS+=("--mtk_magic" "0x58881688")
    BOOT_ARGS+=("--mtk_type" "RECOVERY")
    BOOT_ARGS+=("--mtk_unk1" "recovery.img-unknown1")
    BOOT_ARGS+=("--mtk_unk2" "recovery.img-unknown2")
    BOOT_ARGS+=("-o" "/tmp/${IMG}.img")

    ./mkbootimg "${BOOT_ARGS[@]}"
}

IMG=recovery
build_ramdisk
build_img
