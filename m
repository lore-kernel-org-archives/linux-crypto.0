From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] CRC32 for ARM and arm64 using PMULL and CRC instructions
Date: Sat, 26 Nov 2016 20:15:12 +0000
Message-ID: <1480191314-2331-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, linux@arm.linux.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f171.google.com ([209.85.210.171]:35946 "EHLO
        mail-wj0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbcKZUP0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Nov 2016 15:15:26 -0500
Received: by mail-wj0-f171.google.com with SMTP id qp4so84152025wjc.3
        for <linux-crypto@vger.kernel.org>; Sat, 26 Nov 2016 12:15:25 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Version 8 of the ARM architecture introduces both a set of dedicated CRC32
instructions, and a 64x64 to 128 bit polynomial multiplication instruction,
both of which can be used to accelerate CRC32 calculations.

These patches contains ports of the existing polynomial multiplication based
CRC32 code that resides in arch/x86/crypto/crc32-pclmul_asm.S, but since that
algorithm operates on multiples of 16 bytes only, and requires at least 64
bytes of input, the remainders are calculated with the CRC32 instructions,
if available.

These patches apply on top of the CRC-T10DIF series I sent out last Thursday.

https://git.kernel.org/cgit/linux/kernel/git/ardb/linux.git/log/?h=crc32

Ard Biesheuvel (2):
  crypto: arm64/crc32 - accelerated support based on x86 SSE
    implementation
  crypto: arm/crc32 - accelerated support based on x86 SSE
    implementation

 arch/arm/crypto/Kconfig           |   5 +
 arch/arm/crypto/Makefile          |   2 +
 arch/arm/crypto/crc32-ce-core.S   | 257 ++++++++++++++++++++
 arch/arm/crypto/crc32-ce-glue.c   | 129 ++++++++++
 arch/arm64/crypto/Kconfig         |   6 +
 arch/arm64/crypto/Makefile        |   3 +
 arch/arm64/crypto/crc32-ce-core.S | 246 +++++++++++++++++++
 arch/arm64/crypto/crc32-ce-glue.c | 124 ++++++++++
 8 files changed, 772 insertions(+)
 create mode 100644 arch/arm/crypto/crc32-ce-core.S
 create mode 100644 arch/arm/crypto/crc32-ce-glue.c
 create mode 100644 arch/arm64/crypto/crc32-ce-core.S
 create mode 100644 arch/arm64/crypto/crc32-ce-glue.c

-- 
2.7.4
