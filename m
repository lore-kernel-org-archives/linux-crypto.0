Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58DDC47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 09:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0ED221D6C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 09:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GGMDuU/t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfJKJII (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 05:08:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50250 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbfJKJII (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 05:08:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id 5so9619891wmg.0
        for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2019 02:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=osW9rjE+e6peUtuaNcDyISMJ0h1vI1FUHiMcs3jdGNc=;
        b=GGMDuU/t6Ot5KXu1N3L8+DMaT0soqnK/gj1Hkh3tqCepIJkcvVMP6TR1PyCT2a4lFX
         om9eN/6pEDfIKA5B+yB/bibXDoA0lYT6FJKnOvSO5/6VORKdJVntJEAcDKBnzd5VhIJD
         VaafxsdFyDi6uHklKGZbimw7fEpCaqdZ68735VvvBNEeXpjvyleAKPBwC5tuG570ICp8
         DyZS6U7XXTxwJ2seplIY67xhLKEbeMHJHyg3Xqhp/9VAm7pbNf9uVzI1fIME2kC7Y4lC
         q4h7jV8Si+7bqXTvAVtEWvogP22XNwXGrDlQrPxlv9PeUNAFzZWLX7HAroaboSvVFVQF
         eKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=osW9rjE+e6peUtuaNcDyISMJ0h1vI1FUHiMcs3jdGNc=;
        b=pVpUtHsbAyxcNUlDgKjCWdaX6DnTrPyE2PIX4d9dbkkPYrJKlh8kDuIqbnCECtTfub
         3mwk0sbKMERnfco/3FNOCTUV6/vi3Gs9A7VwRXLEh4dbqsvwvSBMEE76vrYWa7GcrJU4
         l+J4epV3yg68EneYPmcH3Aabgzp9orZ7B3lF1026Qf8V8STgAzId5ixoYglTJLq7+A+F
         w/DayGfg7JP7u3G9TmLz1rL+TQRa+0ScMMR4p5h9aDIOiEMkZF8bLwyPkgVXCB3vKAG/
         lcVGehfBXu58ORVVuTFPZAbfx3D7YSlGG7NeQNoPxB6VoH5wbqNDkM1H0HMXlTzSOIps
         XEtQ==
X-Gm-Message-State: APjAAAUhbUOTk9VDjph3cj8lTvWUATFc/fsvDEG4EGTiDyELedcmfWYF
        yaMLA7mf6qbHMXS0TLGDVoQQVygg0svTFQ==
X-Google-Smtp-Source: APXvYqx8fAlFUXm6NdBEdEQJEpAeQwMxfq7Og9Xu8MteeVJOvdC36RxUcWR+rt1YZYBkyPth6eAeAA==
X-Received: by 2002:a1c:5408:: with SMTP id i8mr2324548wmb.149.1570784884349;
        Fri, 11 Oct 2019 02:08:04 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:89d9:ced7:2b7a:29ff])
        by smtp.gmail.com with ESMTPSA id e18sm11482346wrv.63.2019.10.11.02.08.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 02:08:03 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        arnd@arndb.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm - use Kconfig based compiler checks for crypto opcodes
Date:   Fri, 11 Oct 2019 11:08:00 +0200
Message-Id: <20191011090800.29386-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of allowing the Crypto Extensions algorithms to be selected when
using a toolchain that does not support them, and complain about it at
build time, use the information we have about the compiler to prevent
them from being selected in the first place. Users that are stuck with
a GCC version <4.8 are unlikely to care about these routines anyway, and
it cleans up the Makefile considerably.

While at it, add explicit 'armv8-a' CPU specifiers to the code that uses
the 'crypto-neon-fp-armv8' FPU specifier so we don't regress Clang, which
will complain about this in version 10 and later.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig             | 14 +++++++------
 arch/arm/crypto/Makefile            | 32 ++++++-----------------------
 arch/arm/crypto/aes-ce-core.S       |  1 +
 arch/arm/crypto/crct10dif-ce-core.S |  2 +-
 arch/arm/crypto/ghash-ce-core.S     |  1 +
 arch/arm/crypto/sha1-ce-core.S      |  1 +
 arch/arm/crypto/sha2-ce-core.S      |  1 +
 7 files changed, 19 insertions(+), 33 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index a618f3e65822..562e48ee54cd 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -30,7 +30,7 @@ config CRYPTO_SHA1_ARM_NEON
 
 config CRYPTO_SHA1_ARM_CE
 	tristate "SHA1 digest algorithm (ARM v8 Crypto Extensions)"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
 	select CRYPTO_SHA1_ARM
 	select CRYPTO_HASH
 	help
@@ -39,7 +39,7 @@ config CRYPTO_SHA1_ARM_CE
 
 config CRYPTO_SHA2_ARM_CE
 	tristate "SHA-224/256 digest algorithm (ARM v8 Crypto Extensions)"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
 	select CRYPTO_SHA256_ARM
 	select CRYPTO_HASH
 	help
@@ -96,7 +96,7 @@ config CRYPTO_AES_ARM_BS
 
 config CRYPTO_AES_ARM_CE
 	tristate "Accelerated AES using ARMv8 Crypto Extensions"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_SIMD
 	help
@@ -105,7 +105,7 @@ config CRYPTO_AES_ARM_CE
 
 config CRYPTO_GHASH_ARM_CE
 	tristate "PMULL-accelerated GHASH using NEON/ARMv8 Crypto Extensions"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
 	select CRYPTO_HASH
 	select CRYPTO_CRYPTD
 	select CRYPTO_GF128MUL
@@ -117,12 +117,14 @@ config CRYPTO_GHASH_ARM_CE
 
 config CRYPTO_CRCT10DIF_ARM_CE
 	tristate "CRCT10DIF digest algorithm using PMULL instructions"
-	depends on KERNEL_MODE_NEON && CRC_T10DIF
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
+	depends on CRC_T10DIF
 	select CRYPTO_HASH
 
 config CRYPTO_CRC32_ARM_CE
 	tristate "CRC32(C) digest algorithm using CRC and/or PMULL instructions"
-	depends on KERNEL_MODE_NEON && CRC32
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
+	depends on CRC32
 	select CRYPTO_HASH
 
 config CRYPTO_CHACHA20_NEON
diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index a432bc8bb3eb..01d2eabc016a 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -14,32 +14,12 @@ obj-$(CONFIG_CRYPTO_POLY1305_ARM) += poly1305-arm.o
 obj-$(CONFIG_CRYPTO_NHPOLY1305_NEON) += nhpoly1305-neon.o
 obj-$(CONFIG_CRYPTO_LIB_CURVE25519_NEON) += libcurve25519-neon.o
 
-ce-obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM_CE) += crct10dif-arm-ce.o
-crc-obj-$(CONFIG_CRYPTO_CRC32_ARM_CE) += crc32-arm-ce.o
-
-ifneq ($(crc-obj-y)$(crc-obj-m),)
-ifeq ($(call as-instr,.arch armv8-a\n.arch_extension crc,y,n),y)
-ce-obj-y += $(crc-obj-y)
-ce-obj-m += $(crc-obj-m)
-else
-$(warning These CRC Extensions modules need binutils 2.23 or higher)
-$(warning $(crc-obj-y) $(crc-obj-m))
-endif
-endif
-
-ifneq ($(ce-obj-y)$(ce-obj-m),)
-ifeq ($(call as-instr,.fpu crypto-neon-fp-armv8,y,n),y)
-obj-y += $(ce-obj-y)
-obj-m += $(ce-obj-m)
-else
-$(warning These ARMv8 Crypto Extensions modules need binutils 2.23 or higher)
-$(warning $(ce-obj-y) $(ce-obj-m))
-endif
-endif
+obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
+obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
+obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
+obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
+obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM_CE) += crct10dif-arm-ce.o
+obj-$(CONFIG_CRYPTO_CRC32_ARM_CE) += crc32-arm-ce.o
 
 aes-arm-y	:= aes-cipher-core.o aes-cipher-glue.o
 aes-arm-bs-y	:= aes-neonbs-core.o aes-neonbs-glue.o
diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
index b978cdf133af..4d1707388d94 100644
--- a/arch/arm/crypto/aes-ce-core.S
+++ b/arch/arm/crypto/aes-ce-core.S
@@ -9,6 +9,7 @@
 #include <asm/assembler.h>
 
 	.text
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 	.align		3
 
diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
index 86be258a803f..46c02c518a30 100644
--- a/arch/arm/crypto/crct10dif-ce-core.S
+++ b/arch/arm/crypto/crct10dif-ce-core.S
@@ -72,7 +72,7 @@
 #endif
 
 	.text
-	.arch		armv7-a
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 
 	init_crc	.req	r0
diff --git a/arch/arm/crypto/ghash-ce-core.S b/arch/arm/crypto/ghash-ce-core.S
index c47fe81abcb0..534c9647726d 100644
--- a/arch/arm/crypto/ghash-ce-core.S
+++ b/arch/arm/crypto/ghash-ce-core.S
@@ -88,6 +88,7 @@
 	T3_H		.req	d17
 
 	.text
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 
 	.macro		__pmull_p64, rd, rn, rm, b1, b2, b3, b4
diff --git a/arch/arm/crypto/sha1-ce-core.S b/arch/arm/crypto/sha1-ce-core.S
index 49a74a441aec..8a702e051738 100644
--- a/arch/arm/crypto/sha1-ce-core.S
+++ b/arch/arm/crypto/sha1-ce-core.S
@@ -10,6 +10,7 @@
 #include <asm/assembler.h>
 
 	.text
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 
 	k0		.req	q0
diff --git a/arch/arm/crypto/sha2-ce-core.S b/arch/arm/crypto/sha2-ce-core.S
index 4ad517577e23..b6369d2440a1 100644
--- a/arch/arm/crypto/sha2-ce-core.S
+++ b/arch/arm/crypto/sha2-ce-core.S
@@ -10,6 +10,7 @@
 #include <asm/assembler.h>
 
 	.text
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 
 	k0		.req	q7
-- 
2.20.1

