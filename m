Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE355C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Mar 2022 03:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbiCNDMZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Mar 2022 23:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiCNDMX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Mar 2022 23:12:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6193EB80
        for <linux-crypto@vger.kernel.org>; Sun, 13 Mar 2022 20:11:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD9D860F0A
        for <linux-crypto@vger.kernel.org>; Mon, 14 Mar 2022 03:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4934C340E9;
        Mon, 14 Mar 2022 03:11:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jAvey9tI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1647227469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bi+VtSZtj+GycjPn7pGNkwAd+qU0v3I8ddwVm4CA5Wg=;
        b=jAvey9tIkNwAzOJ9lKHXJ9QlIgbBAOUek/rWxTy4COQ2wM/p9ATcWOwP6hcngPOu1IGMgO
        fKkLf3pqt6HSExGTV/3NZxzfjWit3ZxcrYY/Yq8sPIs/vrBzm36A3Fl3cjgTtisUaRkAnp
        /NNGnjlSZmGFp0nW2M6Q3Zr7gRduNfM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 779d1a3a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 14 Mar 2022 03:11:09 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        tianjia.zhang@linux.alibaba.com, ebiggers@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] crypto: move sm3 and sm4 into crypto directory
Date:   Sun, 13 Mar 2022 21:11:01 -0600
Message-Id: <20220314031101.663883-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The lib/crypto libraries live in lib because they are used by various
drivers of the kernel. In contrast, the various helper functions in
crypto are there because they're used exclusively by the crypto API. The
SM3 and SM4 helper functions were erroniously moved into lib/crypto/
instead of crypto/, even though there are no in-kernel users outside of
the crypto API of those functions. This commit moves them into crypto/.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/arm64/crypto/Kconfig    |  4 ++--
 crypto/Kconfig               | 18 ++++++++++++------
 crypto/Makefile              |  6 ++++--
 {lib/crypto => crypto}/sm3.c |  0
 {lib/crypto => crypto}/sm4.c |  0
 lib/crypto/Kconfig           |  6 ------
 lib/crypto/Makefile          |  6 ------
 7 files changed, 18 insertions(+), 22 deletions(-)
 rename {lib/crypto => crypto}/sm3.c (100%)
 rename {lib/crypto => crypto}/sm4.c (100%)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 2a965aa0188d..454621a20eaa 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -45,13 +45,13 @@ config CRYPTO_SM3_ARM64_CE
 	tristate "SM3 digest algorithm (ARMv8.2 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
-	select CRYPTO_LIB_SM3
+	select CRYPTO_SM3
 
 config CRYPTO_SM4_ARM64_CE
 	tristate "SM4 symmetric cipher (ARMv8.2 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_ALGAPI
-	select CRYPTO_LIB_SM4
+	select CRYPTO_SM4
 
 config CRYPTO_GHASH_ARM64_CE
 	tristate "GHASH/AES-GCM using ARMv8 Crypto Extensions"
diff --git a/crypto/Kconfig b/crypto/Kconfig
index d6d7e84bb7f8..517525d7d12e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -274,7 +274,7 @@ config CRYPTO_ECRDSA
 
 config CRYPTO_SM2
 	tristate "SM2 algorithm"
-	select CRYPTO_LIB_SM3
+	select CRYPTO_SM3
 	select CRYPTO_AKCIPHER
 	select CRYPTO_MANAGER
 	select MPILIB
@@ -1005,9 +1005,12 @@ config CRYPTO_SHA3
 	  http://keccak.noekeon.org/
 
 config CRYPTO_SM3
+	tristate
+
+config CRYPTO_SM3_GENERIC
 	tristate "SM3 digest algorithm"
 	select CRYPTO_HASH
-	select CRYPTO_LIB_SM3
+	select CRYPTO_SM3
 	help
 	  SM3 secure hash function as defined by OSCCA GM/T 0004-2012 SM3).
 	  It is part of the Chinese Commercial Cryptography suite.
@@ -1020,7 +1023,7 @@ config CRYPTO_SM3_AVX_X86_64
 	tristate "SM3 digest algorithm (x86_64/AVX)"
 	depends on X86 && 64BIT
 	select CRYPTO_HASH
-	select CRYPTO_LIB_SM3
+	select CRYPTO_SM3
 	help
 	  SM3 secure hash function as defined by OSCCA GM/T 0004-2012 SM3).
 	  It is part of the Chinese Commercial Cryptography suite. This is
@@ -1567,9 +1570,12 @@ config CRYPTO_SERPENT_AVX2_X86_64
 	  <https://www.cl.cam.ac.uk/~rja14/serpent.html>
 
 config CRYPTO_SM4
+	tristate
+
+config CRYPTO_SM4_GENERIC
 	tristate "SM4 cipher algorithm"
 	select CRYPTO_ALGAPI
-	select CRYPTO_LIB_SM4
+	select CRYPTO_SM4
 	help
 	  SM4 cipher algorithms (OSCCA GB/T 32907-2016).
 
@@ -1598,7 +1604,7 @@ config CRYPTO_SM4_AESNI_AVX_X86_64
 	select CRYPTO_SKCIPHER
 	select CRYPTO_SIMD
 	select CRYPTO_ALGAPI
-	select CRYPTO_LIB_SM4
+	select CRYPTO_SM4
 	help
 	  SM4 cipher algorithms (OSCCA GB/T 32907-2016) (x86_64/AES-NI/AVX).
 
@@ -1619,7 +1625,7 @@ config CRYPTO_SM4_AESNI_AVX2_X86_64
 	select CRYPTO_SKCIPHER
 	select CRYPTO_SIMD
 	select CRYPTO_ALGAPI
-	select CRYPTO_LIB_SM4
+	select CRYPTO_SM4
 	select CRYPTO_SM4_AESNI_AVX_X86_64
 	help
 	  SM4 cipher algorithms (OSCCA GB/T 32907-2016) (x86_64/AES-NI/AVX2).
diff --git a/crypto/Makefile b/crypto/Makefile
index d76bff8d0ffd..1a4fa7d51b2f 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -78,7 +78,8 @@ obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512_generic.o
 obj-$(CONFIG_CRYPTO_SHA3) += sha3_generic.o
-obj-$(CONFIG_CRYPTO_SM3) += sm3_generic.o
+obj-$(CONFIG_CRYPTO_SM3) += sm3.o
+obj-$(CONFIG_CRYPTO_SM3_GENERIC) += sm3_generic.o
 obj-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
@@ -134,7 +135,8 @@ obj-$(CONFIG_CRYPTO_SERPENT) += serpent_generic.o
 CFLAGS_serpent_generic.o := $(call cc-option,-fsched-pressure)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_AES) += aes_generic.o
 CFLAGS_aes_generic.o := $(call cc-option,-fno-code-hoisting) # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
-obj-$(CONFIG_CRYPTO_SM4) += sm4_generic.o
+obj-$(CONFIG_CRYPTO_SM4) += sm4.o
+obj-$(CONFIG_CRYPTO_SM4_GENERIC) += sm4_generic.o
 obj-$(CONFIG_CRYPTO_AES_TI) += aes_ti.o
 obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia_generic.o
 obj-$(CONFIG_CRYPTO_CAST_COMMON) += cast_common.o
diff --git a/lib/crypto/sm3.c b/crypto/sm3.c
similarity index 100%
rename from lib/crypto/sm3.c
rename to crypto/sm3.c
diff --git a/lib/crypto/sm4.c b/crypto/sm4.c
similarity index 100%
rename from lib/crypto/sm4.c
rename to crypto/sm4.c
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 379a66d7f504..9856e291f414 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -123,10 +123,4 @@ config CRYPTO_LIB_CHACHA20POLY1305
 config CRYPTO_LIB_SHA256
 	tristate
 
-config CRYPTO_LIB_SM3
-	tristate
-
-config CRYPTO_LIB_SM4
-	tristate
-
 endmenu
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 6c872d05d1e6..26be2bbe09c5 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -37,12 +37,6 @@ libpoly1305-y					+= poly1305.o
 obj-$(CONFIG_CRYPTO_LIB_SHA256)			+= libsha256.o
 libsha256-y					:= sha256.o
 
-obj-$(CONFIG_CRYPTO_LIB_SM3)			+= libsm3.o
-libsm3-y					:= sm3.o
-
-obj-$(CONFIG_CRYPTO_LIB_SM4)			+= libsm4.o
-libsm4-y					:= sm4.o
-
 ifneq ($(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS),y)
 libblake2s-y					+= blake2s-selftest.o
 libchacha20poly1305-y				+= chacha20poly1305-selftest.o
-- 
2.35.1

