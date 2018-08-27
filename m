From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/4] arm64: wire CRC32 instructions into core crc32 routines
Date: Mon, 27 Aug 2018 13:02:41 +0200
Message-ID: <20180827110245.14812-1-ard.biesheuvel@linaro.org>
Cc: will.deacon@arm.com, catalin.marinas@arm.com,
        herbert@gondor.apana.org.au, ebiggers@google.com,
        suzuki.poulose@arm.com, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

There are many crc32 users in the kernel that call the library routine
rather than the crypto API wrapper, and so none of these callers use the
accelerated arm64 instructions when available.

While this is not known to cause performance issues, calling a table based
time variant implementation with a non-negligible D-cache footprint (8 KB)
is wasteful in any case, and now that the crc32 instructions have been made
mandatory in the architecture, let's wire them up into the core crc routines.

This also means that they will be exposed to the crypto API via the generic
CRC32 driver, and so we can remove the scalar routines from the crypto API
driver. This leaves the PMULL code, which will only be useful on systems
that implement 64x64 PMULL but not the CRC32 instructions. Given that no
such systems are known to exist, this driver is removed entirely in patch #4.

Ard Biesheuvel (4):
  lib/crc32: make core crc32() routines weak so they can be overridden
  arm64: cpufeature: add feature for CRC32 instructions
  arm64/lib: add accelerated crc32 routines
  crypto: arm64/crc32 - remove PMULL based CRC32 driver

 arch/arm64/Kconfig                |   1 +
 arch/arm64/configs/defconfig      |   1 -
 arch/arm64/crypto/Kconfig         |   5 -
 arch/arm64/crypto/Makefile        |   3 -
 arch/arm64/crypto/crc32-ce-core.S | 287 --------------------
 arch/arm64/crypto/crc32-ce-glue.c | 244 -----------------
 arch/arm64/include/asm/cpucaps.h  |   3 +-
 arch/arm64/kernel/cpufeature.c    |   9 +
 arch/arm64/lib/Makefile           |   2 +
 arch/arm64/lib/crc32.S            |  60 ++++
 lib/crc32.c                       |  11 +-
 11 files changed, 81 insertions(+), 545 deletions(-)
 delete mode 100644 arch/arm64/crypto/crc32-ce-core.S
 delete mode 100644 arch/arm64/crypto/crc32-ce-glue.c
 create mode 100644 arch/arm64/lib/crc32.S

-- 
2.18.0
