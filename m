From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] ARM: crypto: enable NEON SHA-1 for big endian
Date: Mon,  4 Aug 2014 12:34:28 +0200
Message-ID: <1407148469-26190-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
	jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55365 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbaHDKeh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2014 06:34:37 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so7477131wes.19
        for <linux-crypto@vger.kernel.org>; Mon, 04 Aug 2014 03:34:36 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This tweaks the SHA-1 NEON code slightly so it works correctly under big endian,
and removes the Kconfig condition preventing it from being selected if
CONFIG_CPU_BIG_ENDIAN is set.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/sha1-armv7-neon.S | 8 ++++----
 crypto/Kconfig                    | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/crypto/sha1-armv7-neon.S b/arch/arm/crypto/sha1-armv7-neon.S
index 50013c0e2864..49179e0653e6 100644
--- a/arch/arm/crypto/sha1-armv7-neon.S
+++ b/arch/arm/crypto/sha1-armv7-neon.S
@@ -150,9 +150,9 @@
 #define W_PRECALC_00_15() \
 	add       RWK, sp, #(WK_offs(0));			\
 	\
-	vld1.32   {tmp0, tmp1}, [RDATA]!;			\
+	vld1.8    {tmp0, tmp1}, [RDATA]!;			\
 	vrev32.8  W0, tmp0;		/* big => little */	\
-	vld1.32   {tmp2, tmp3}, [RDATA]!;			\
+	vld1.8    {tmp2, tmp3}, [RDATA]!;			\
 	vadd.u32  tmp0, W0, curK;				\
 	vrev32.8  W7, tmp1;		/* big => little */	\
 	vrev32.8  W6, tmp2;		/* big => little */	\
@@ -164,7 +164,7 @@
 	vst1.32   {tmp2, tmp3}, [RWK];				\
 
 #define WPRECALC_00_15_0(i,W,W_m04,W_m08,W_m12,W_m16,W_m20,W_m24,W_m28) \
-	vld1.32   {tmp0, tmp1}, [RDATA]!;			\
+	vld1.8    {tmp0, tmp1}, [RDATA]!;			\
 
 #define WPRECALC_00_15_1(i,W,W_m04,W_m08,W_m12,W_m16,W_m20,W_m24,W_m28) \
 	add       RWK, sp, #(WK_offs(0));			\
@@ -173,7 +173,7 @@
 	vrev32.8  W0, tmp0;		/* big => little */	\
 
 #define WPRECALC_00_15_3(i,W,W_m04,W_m08,W_m12,W_m16,W_m20,W_m24,W_m28) \
-	vld1.32   {tmp2, tmp3}, [RDATA]!;			\
+	vld1.8    {tmp2, tmp3}, [RDATA]!;			\
 
 #define WPRECALC_00_15_4(i,W,W_m04,W_m08,W_m12,W_m16,W_m20,W_m24,W_m28) \
 	vadd.u32  tmp0, W0, curK;				\
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 749b1e05c490..deef2a4b6559 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -542,7 +542,7 @@ config CRYPTO_SHA1_ARM
 
 config CRYPTO_SHA1_ARM_NEON
 	tristate "SHA1 digest algorithm (ARM NEON)"
-	depends on ARM && KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
+	depends on ARM && KERNEL_MODE_NEON
 	select CRYPTO_SHA1_ARM
 	select CRYPTO_SHA1
 	select CRYPTO_HASH
-- 
1.8.3.2
