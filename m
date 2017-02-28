From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: arm - add build time test for CRC instruction support
Date: Tue, 28 Feb 2017 14:36:57 +0000
Message-ID: <1488292617-27317-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1488292617-27317-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, jonathanh@nvidia.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        arnd@arndb.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34975 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751431AbdB1OhR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Feb 2017 09:37:17 -0500
Received: by mail-wm0-f54.google.com with SMTP id v186so87084978wmd.0
        for <linux-crypto@vger.kernel.org>; Tue, 28 Feb 2017 06:37:07 -0800 (PST)
In-Reply-To: <1488292617-27317-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The accelerated CRC32 module for ARM may use either the scalar CRC32
instructions, the NEON 64x64 to 128 bit polynomial multiplication
(vmull.p64) instruction, or both, depending on what the current CPU
supports.

However, this also requires support in binutils, and as it turns out,
versions of binutils exist that support the vmull.p64 instruction but
not the crc32 instructions.

So refactor the Makefile logic so that this module only gets built if
binutils has support for both.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Makefile | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index 1822c4697278..f2215fbeed13 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -15,7 +15,17 @@ ce-obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
 ce-obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
 ce-obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
 ce-obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM_CE) += crct10dif-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_CRC32_ARM_CE) += crc32-arm-ce.o
+crc-obj-$(CONFIG_CRYPTO_CRC32_ARM_CE) += crc32-arm-ce.o
+
+ifneq ($(crc-obj-y)$(crc-obj-m),)
+ifeq ($(call as-instr,.arch armv8-a\n.arch_extension crc,y,n),y)
+ce-obj-y += $(crc-obj-y)
+ce-obj-m += $(crc-obj-m)
+else
+$(warning These CRC Extensions modules need binutils 2.23 or higher)
+$(warning $(crc-obj-y) $(crc-obj-m))
+endif
+endif
 
 ifneq ($(ce-obj-y)$(ce-obj-m),)
 ifeq ($(call as-instr,.fpu crypto-neon-fp-armv8,y,n),y)
-- 
2.7.4
