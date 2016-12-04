From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/6] crypto: ARM/arm64 CRC-T10DIF/CRC32/CRC32C roundup
Date: Sun,  4 Dec 2016 11:54:01 +0000
Message-ID: <1480852447-25082-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f176.google.com ([209.85.210.176]:33042 "EHLO
        mail-wj0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750867AbcLDLyQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Dec 2016 06:54:16 -0500
Received: by mail-wj0-f176.google.com with SMTP id xy5so267853484wjc.0
        for <linux-crypto@vger.kernel.org>; Sun, 04 Dec 2016 03:54:15 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This v2 combines the CRC-T10DIF and CRC32 implementations for both ARM and
arm64 that I sent out a couple of weeks ago, and adds support to the latter
for CRC32C.

Ard Biesheuvel (6):
  crypto: testmgr - avoid overlap in chunked tests
  crypto: testmgr - add/enhance test cases for CRC-T10DIF
  crypto: arm64/crct10dif - port x86 SSE implementation to arm64
  crypto: arm/crct10dif - port x86 SSE implementation to ARM
  crypto: arm64/crc32 - accelerated support based on x86 SSE
    implementation
  crypto: arm/crc32 - accelerated support based on x86 SSE
    implementation

 arch/arm/crypto/Kconfig               |  10 +
 arch/arm/crypto/Makefile              |   4 +
 arch/arm/crypto/crc32-ce-core.S       | 306 +++++++++++++++++
 arch/arm/crypto/crc32-ce-glue.c       | 195 +++++++++++
 arch/arm/crypto/crct10dif-ce-core.S   | 349 ++++++++++++++++++++
 arch/arm/crypto/crct10dif-ce-glue.c   |  95 ++++++
 arch/arm64/crypto/Kconfig             |  11 +
 arch/arm64/crypto/Makefile            |   6 +
 arch/arm64/crypto/crc32-ce-core.S     | 266 +++++++++++++++
 arch/arm64/crypto/crc32-ce-glue.c     | 188 +++++++++++
 arch/arm64/crypto/crct10dif-ce-core.S | 317 ++++++++++++++++++
 arch/arm64/crypto/crct10dif-ce-glue.c |  91 +++++
 crypto/testmgr.c                      |   2 +-
 crypto/testmgr.h                      |  70 ++--
 14 files changed, 1881 insertions(+), 29 deletions(-)
 create mode 100644 arch/arm/crypto/crc32-ce-core.S
 create mode 100644 arch/arm/crypto/crc32-ce-glue.c
 create mode 100644 arch/arm/crypto/crct10dif-ce-core.S
 create mode 100644 arch/arm/crypto/crct10dif-ce-glue.c
 create mode 100644 arch/arm64/crypto/crc32-ce-core.S
 create mode 100644 arch/arm64/crypto/crc32-ce-glue.c
 create mode 100644 arch/arm64/crypto/crct10dif-ce-core.S
 create mode 100644 arch/arm64/crypto/crct10dif-ce-glue.c

-- 
2.7.4
