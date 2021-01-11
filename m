Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C12C433E6
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1CAD2250F
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389041AbhAKQxf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:53:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389086AbhAKQxe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 11:53:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC2D8229CA;
        Mon, 11 Jan 2021 16:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610383973;
        bh=dbwT85pGXyl/xe9gDylWrwUYY28BJ2J4ql/h9Mis97Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbRR07m9AY8S8X8N3DC1VKJU5UuEm+kkeJdU5hAWXxyUyvKlamsAbwWex2gzdjgFX
         nkHBHjIvr6nbW0BRm+TQ0qNFmVSU7rgAex52KrxR3+CSTdh3OtR9qI3PaJIQSiSjom
         AcXh5VqmoVVNfci4fxrFlP+AKfbgmBmim3Un4pcWO3CpDWT+tn58UKFnzoi3jkSrvY
         caOMHsMwmVeco4Z0eslLKisHfV/BXsBZo3cO54xwovZ4/frQQKdk4r5cHFgGqnLQBr
         JnlO+AdfHn3/1mcpMD8LMCXaTyUHUqWBKk6fy5L9B+QerpuLRRbp09iK/ip2c6gnOK
         r43n5PCBHqqMA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/7] crypto: crc-t10dif - turn library wrapper for shash into generic library
Date:   Mon, 11 Jan 2021 17:52:31 +0100
Message-Id: <20210111165237.18178-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111165237.18178-1-ardb@kernel.org>
References: <20210111165237.18178-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As a first step towards moving CRC-T10DIF out of the crypto API, drop
the shash wrapping code from the library implementation, and move the
generic core CRC-T10DIF into it from the generic crypto SHASH driver.

In a future patch, the library interface will be augmented with the
facilities to register and unregister optimized implementations.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/Kconfig   |   2 +-
 arch/arm64/crypto/Kconfig |   3 +-
 crypto/Kconfig            |   7 +-
 crypto/Makefile           |   2 +-
 crypto/crct10dif_common.c |  82 ------------
 lib/Kconfig               |   2 -
 lib/crc-t10dif.c          | 136 +++++++-------------
 7 files changed, 57 insertions(+), 177 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 2b575792363e..939de9ceed0f 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -138,8 +138,8 @@ config CRYPTO_GHASH_ARM_CE
 config CRYPTO_CRCT10DIF_ARM_CE
 	tristate "CRCT10DIF digest algorithm using PMULL instructions"
 	depends on KERNEL_MODE_NEON
-	depends on CRC_T10DIF
 	select CRYPTO_HASH
+	select CRC_T10DIF
 
 config CRYPTO_CRC32_ARM_CE
 	tristate "CRC32(C) digest algorithm using CRC and/or PMULL instructions"
diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index b8eb0453123d..e5d2f989521f 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -62,8 +62,9 @@ config CRYPTO_GHASH_ARM64_CE
 
 config CRYPTO_CRCT10DIF_ARM64_CE
 	tristate "CRCT10DIF digest algorithm using PMULL instructions"
-	depends on KERNEL_MODE_NEON && CRC_T10DIF
+	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
+	select CRC_T10DIF
 
 config CRYPTO_AES_ARM64
 	tristate "AES core cipher using scalar instructions"
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 94f0fde06b94..3e8cf6c2215a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -700,6 +700,7 @@ config CRYPTO_BLAKE2S_X86
 config CRYPTO_CRCT10DIF
 	tristate "CRCT10DIF algorithm"
 	select CRYPTO_HASH
+	select CRC_T10DIF
 	help
 	  CRC T10 Data Integrity Field computation is being cast as
 	  a crypto transform.  This allows for faster crc t10 diff
@@ -707,8 +708,9 @@ config CRYPTO_CRCT10DIF
 
 config CRYPTO_CRCT10DIF_PCLMUL
 	tristate "CRCT10DIF PCLMULQDQ hardware acceleration"
-	depends on X86 && 64BIT && CRC_T10DIF
+	depends on X86 && 64BIT
 	select CRYPTO_HASH
+	select CRC_T10DIF
 	help
 	  For x86_64 processors with SSE4.2 and PCLMULQDQ supported,
 	  CRC T10 DIF PCLMULQDQ computation can be hardware
@@ -718,8 +720,9 @@ config CRYPTO_CRCT10DIF_PCLMUL
 
 config CRYPTO_CRCT10DIF_VPMSUM
 	tristate "CRC32T10DIF powerpc64 hardware acceleration"
-	depends on PPC64 && ALTIVEC && CRC_T10DIF
+	depends on PPC64 && ALTIVEC
 	select CRYPTO_HASH
+	select CRC_T10DIF
 	help
 	  CRC10T10DIF algorithm implemented using vector polynomial
 	  multiply-sum (vpmsum) instructions, introduced in POWER8. Enable on
diff --git a/crypto/Makefile b/crypto/Makefile
index b279483fba50..69d06a28c8e6 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -148,7 +148,7 @@ obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32_generic.o
-obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_common.o crct10dif_generic.o
+obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_generic.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o lzo-rle.o
 obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
diff --git a/crypto/crct10dif_common.c b/crypto/crct10dif_common.c
deleted file mode 100644
index b2fab366f518..000000000000
--- a/crypto/crct10dif_common.c
+++ /dev/null
@@ -1,82 +0,0 @@
-/*
- * Cryptographic API.
- *
- * T10 Data Integrity Field CRC16 Crypto Transform
- *
- * Copyright (c) 2007 Oracle Corporation.  All rights reserved.
- * Written by Martin K. Petersen <martin.petersen@oracle.com>
- * Copyright (C) 2013 Intel Corporation
- * Author: Tim Chen <tim.c.chen@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-
-#include <linux/crc-t10dif.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-
-/* Table generated using the following polynomium:
- * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
- * gt: 0x8bb7
- */
-static const __u16 t10_dif_crc_table[256] = {
-	0x0000, 0x8BB7, 0x9CD9, 0x176E, 0xB205, 0x39B2, 0x2EDC, 0xA56B,
-	0xEFBD, 0x640A, 0x7364, 0xF8D3, 0x5DB8, 0xD60F, 0xC161, 0x4AD6,
-	0x54CD, 0xDF7A, 0xC814, 0x43A3, 0xE6C8, 0x6D7F, 0x7A11, 0xF1A6,
-	0xBB70, 0x30C7, 0x27A9, 0xAC1E, 0x0975, 0x82C2, 0x95AC, 0x1E1B,
-	0xA99A, 0x222D, 0x3543, 0xBEF4, 0x1B9F, 0x9028, 0x8746, 0x0CF1,
-	0x4627, 0xCD90, 0xDAFE, 0x5149, 0xF422, 0x7F95, 0x68FB, 0xE34C,
-	0xFD57, 0x76E0, 0x618E, 0xEA39, 0x4F52, 0xC4E5, 0xD38B, 0x583C,
-	0x12EA, 0x995D, 0x8E33, 0x0584, 0xA0EF, 0x2B58, 0x3C36, 0xB781,
-	0xD883, 0x5334, 0x445A, 0xCFED, 0x6A86, 0xE131, 0xF65F, 0x7DE8,
-	0x373E, 0xBC89, 0xABE7, 0x2050, 0x853B, 0x0E8C, 0x19E2, 0x9255,
-	0x8C4E, 0x07F9, 0x1097, 0x9B20, 0x3E4B, 0xB5FC, 0xA292, 0x2925,
-	0x63F3, 0xE844, 0xFF2A, 0x749D, 0xD1F6, 0x5A41, 0x4D2F, 0xC698,
-	0x7119, 0xFAAE, 0xEDC0, 0x6677, 0xC31C, 0x48AB, 0x5FC5, 0xD472,
-	0x9EA4, 0x1513, 0x027D, 0x89CA, 0x2CA1, 0xA716, 0xB078, 0x3BCF,
-	0x25D4, 0xAE63, 0xB90D, 0x32BA, 0x97D1, 0x1C66, 0x0B08, 0x80BF,
-	0xCA69, 0x41DE, 0x56B0, 0xDD07, 0x786C, 0xF3DB, 0xE4B5, 0x6F02,
-	0x3AB1, 0xB106, 0xA668, 0x2DDF, 0x88B4, 0x0303, 0x146D, 0x9FDA,
-	0xD50C, 0x5EBB, 0x49D5, 0xC262, 0x6709, 0xECBE, 0xFBD0, 0x7067,
-	0x6E7C, 0xE5CB, 0xF2A5, 0x7912, 0xDC79, 0x57CE, 0x40A0, 0xCB17,
-	0x81C1, 0x0A76, 0x1D18, 0x96AF, 0x33C4, 0xB873, 0xAF1D, 0x24AA,
-	0x932B, 0x189C, 0x0FF2, 0x8445, 0x212E, 0xAA99, 0xBDF7, 0x3640,
-	0x7C96, 0xF721, 0xE04F, 0x6BF8, 0xCE93, 0x4524, 0x524A, 0xD9FD,
-	0xC7E6, 0x4C51, 0x5B3F, 0xD088, 0x75E3, 0xFE54, 0xE93A, 0x628D,
-	0x285B, 0xA3EC, 0xB482, 0x3F35, 0x9A5E, 0x11E9, 0x0687, 0x8D30,
-	0xE232, 0x6985, 0x7EEB, 0xF55C, 0x5037, 0xDB80, 0xCCEE, 0x4759,
-	0x0D8F, 0x8638, 0x9156, 0x1AE1, 0xBF8A, 0x343D, 0x2353, 0xA8E4,
-	0xB6FF, 0x3D48, 0x2A26, 0xA191, 0x04FA, 0x8F4D, 0x9823, 0x1394,
-	0x5942, 0xD2F5, 0xC59B, 0x4E2C, 0xEB47, 0x60F0, 0x779E, 0xFC29,
-	0x4BA8, 0xC01F, 0xD771, 0x5CC6, 0xF9AD, 0x721A, 0x6574, 0xEEC3,
-	0xA415, 0x2FA2, 0x38CC, 0xB37B, 0x1610, 0x9DA7, 0x8AC9, 0x017E,
-	0x1F65, 0x94D2, 0x83BC, 0x080B, 0xAD60, 0x26D7, 0x31B9, 0xBA0E,
-	0xF0D8, 0x7B6F, 0x6C01, 0xE7B6, 0x42DD, 0xC96A, 0xDE04, 0x55B3
-};
-
-__u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer, size_t len)
-{
-	unsigned int i;
-
-	for (i = 0 ; i < len ; i++)
-		crc = (crc << 8) ^ t10_dif_crc_table[((crc >> 8) ^ buffer[i]) & 0xff];
-
-	return crc;
-}
-EXPORT_SYMBOL(crc_t10dif_generic);
-
-MODULE_DESCRIPTION("T10 DIF CRC calculation common code");
-MODULE_LICENSE("GPL");
diff --git a/lib/Kconfig b/lib/Kconfig
index 46806332a8cc..203a50674602 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -120,8 +120,6 @@ config CRC16
 
 config CRC_T10DIF
 	tristate "CRC calculation for the T10 Data Integrity Field"
-	select CRYPTO
-	select CRYPTO_CRCT10DIF
 	help
 	  This option is only needed if a module that's not in the
 	  kernel tree needs to calculate CRC checks for use with the
diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index 1ed2ed487097..cbb739f0a0d7 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -4,6 +4,8 @@
  *
  * Copyright (c) 2007 Oracle Corporation.  All rights reserved.
  * Written by Martin K. Petersen <martin.petersen@oracle.com>
+ * Copyright (C) 2013 Intel Corporation
+ * Author: Tim Chen <tim.c.chen@linux.intel.com>
  */
 
 #include <linux/types.h>
@@ -16,70 +18,59 @@
 #include <linux/static_key.h>
 #include <linux/notifier.h>
 
-static struct crypto_shash __rcu *crct10dif_tfm;
-static DEFINE_STATIC_KEY_TRUE(crct10dif_fallback);
-static DEFINE_MUTEX(crc_t10dif_mutex);
-static struct work_struct crct10dif_rehash_work;
-
-static int crc_t10dif_notify(struct notifier_block *self, unsigned long val, void *data)
-{
-	struct crypto_alg *alg = data;
-
-	if (val != CRYPTO_MSG_ALG_LOADED ||
-	    strcmp(alg->cra_name, CRC_T10DIF_STRING))
-		return NOTIFY_DONE;
-
-	schedule_work(&crct10dif_rehash_work);
-	return NOTIFY_OK;
-}
+/* Table generated using the following polynomium:
+ * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
+ * gt: 0x8bb7
+ */
+static const __u16 __cacheline_aligned t10_dif_crc_table[256] = {
+	0x0000, 0x8BB7, 0x9CD9, 0x176E, 0xB205, 0x39B2, 0x2EDC, 0xA56B,
+	0xEFBD, 0x640A, 0x7364, 0xF8D3, 0x5DB8, 0xD60F, 0xC161, 0x4AD6,
+	0x54CD, 0xDF7A, 0xC814, 0x43A3, 0xE6C8, 0x6D7F, 0x7A11, 0xF1A6,
+	0xBB70, 0x30C7, 0x27A9, 0xAC1E, 0x0975, 0x82C2, 0x95AC, 0x1E1B,
+	0xA99A, 0x222D, 0x3543, 0xBEF4, 0x1B9F, 0x9028, 0x8746, 0x0CF1,
+	0x4627, 0xCD90, 0xDAFE, 0x5149, 0xF422, 0x7F95, 0x68FB, 0xE34C,
+	0xFD57, 0x76E0, 0x618E, 0xEA39, 0x4F52, 0xC4E5, 0xD38B, 0x583C,
+	0x12EA, 0x995D, 0x8E33, 0x0584, 0xA0EF, 0x2B58, 0x3C36, 0xB781,
+	0xD883, 0x5334, 0x445A, 0xCFED, 0x6A86, 0xE131, 0xF65F, 0x7DE8,
+	0x373E, 0xBC89, 0xABE7, 0x2050, 0x853B, 0x0E8C, 0x19E2, 0x9255,
+	0x8C4E, 0x07F9, 0x1097, 0x9B20, 0x3E4B, 0xB5FC, 0xA292, 0x2925,
+	0x63F3, 0xE844, 0xFF2A, 0x749D, 0xD1F6, 0x5A41, 0x4D2F, 0xC698,
+	0x7119, 0xFAAE, 0xEDC0, 0x6677, 0xC31C, 0x48AB, 0x5FC5, 0xD472,
+	0x9EA4, 0x1513, 0x027D, 0x89CA, 0x2CA1, 0xA716, 0xB078, 0x3BCF,
+	0x25D4, 0xAE63, 0xB90D, 0x32BA, 0x97D1, 0x1C66, 0x0B08, 0x80BF,
+	0xCA69, 0x41DE, 0x56B0, 0xDD07, 0x786C, 0xF3DB, 0xE4B5, 0x6F02,
+	0x3AB1, 0xB106, 0xA668, 0x2DDF, 0x88B4, 0x0303, 0x146D, 0x9FDA,
+	0xD50C, 0x5EBB, 0x49D5, 0xC262, 0x6709, 0xECBE, 0xFBD0, 0x7067,
+	0x6E7C, 0xE5CB, 0xF2A5, 0x7912, 0xDC79, 0x57CE, 0x40A0, 0xCB17,
+	0x81C1, 0x0A76, 0x1D18, 0x96AF, 0x33C4, 0xB873, 0xAF1D, 0x24AA,
+	0x932B, 0x189C, 0x0FF2, 0x8445, 0x212E, 0xAA99, 0xBDF7, 0x3640,
+	0x7C96, 0xF721, 0xE04F, 0x6BF8, 0xCE93, 0x4524, 0x524A, 0xD9FD,
+	0xC7E6, 0x4C51, 0x5B3F, 0xD088, 0x75E3, 0xFE54, 0xE93A, 0x628D,
+	0x285B, 0xA3EC, 0xB482, 0x3F35, 0x9A5E, 0x11E9, 0x0687, 0x8D30,
+	0xE232, 0x6985, 0x7EEB, 0xF55C, 0x5037, 0xDB80, 0xCCEE, 0x4759,
+	0x0D8F, 0x8638, 0x9156, 0x1AE1, 0xBF8A, 0x343D, 0x2353, 0xA8E4,
+	0xB6FF, 0x3D48, 0x2A26, 0xA191, 0x04FA, 0x8F4D, 0x9823, 0x1394,
+	0x5942, 0xD2F5, 0xC59B, 0x4E2C, 0xEB47, 0x60F0, 0x779E, 0xFC29,
+	0x4BA8, 0xC01F, 0xD771, 0x5CC6, 0xF9AD, 0x721A, 0x6574, 0xEEC3,
+	0xA415, 0x2FA2, 0x38CC, 0xB37B, 0x1610, 0x9DA7, 0x8AC9, 0x017E,
+	0x1F65, 0x94D2, 0x83BC, 0x080B, 0xAD60, 0x26D7, 0x31B9, 0xBA0E,
+	0xF0D8, 0x7B6F, 0x6C01, 0xE7B6, 0x42DD, 0xC96A, 0xDE04, 0x55B3
+};
 
-static void crc_t10dif_rehash(struct work_struct *work)
+__u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer, size_t len)
 {
-	struct crypto_shash *new, *old;
+	unsigned int i;
 
-	mutex_lock(&crc_t10dif_mutex);
-	old = rcu_dereference_protected(crct10dif_tfm,
-					lockdep_is_held(&crc_t10dif_mutex));
-	new = crypto_alloc_shash(CRC_T10DIF_STRING, 0, 0);
-	if (IS_ERR(new)) {
-		mutex_unlock(&crc_t10dif_mutex);
-		return;
-	}
-	rcu_assign_pointer(crct10dif_tfm, new);
-	mutex_unlock(&crc_t10dif_mutex);
+	for (i = 0 ; i < len ; i++)
+		crc = (crc << 8) ^ t10_dif_crc_table[((crc >> 8) ^ buffer[i]) & 0xff];
 
-	if (old) {
-		synchronize_rcu();
-		crypto_free_shash(old);
-	} else {
-		static_branch_disable(&crct10dif_fallback);
-	}
+	return crc;
 }
-
-static struct notifier_block crc_t10dif_nb = {
-	.notifier_call = crc_t10dif_notify,
-};
+EXPORT_SYMBOL(crc_t10dif_generic);
 
 __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
 {
-	struct {
-		struct shash_desc shash;
-		__u16 crc;
-	} desc;
-	int err;
-
-	if (static_branch_unlikely(&crct10dif_fallback))
-		return crc_t10dif_generic(crc, buffer, len);
-
-	rcu_read_lock();
-	desc.shash.tfm = rcu_dereference(crct10dif_tfm);
-	desc.crc = crc;
-	err = crypto_shash_update(&desc.shash, buffer, len);
-	rcu_read_unlock();
-
-	BUG_ON(err);
-
-	return desc.crc;
+	return crc_t10dif_generic(crc, buffer, len);
 }
 EXPORT_SYMBOL(crc_t10dif_update);
 
@@ -89,43 +80,12 @@ __u16 crc_t10dif(const unsigned char *buffer, size_t len)
 }
 EXPORT_SYMBOL(crc_t10dif);
 
-static int __init crc_t10dif_mod_init(void)
-{
-	INIT_WORK(&crct10dif_rehash_work, crc_t10dif_rehash);
-	crypto_register_notifier(&crc_t10dif_nb);
-	crc_t10dif_rehash(&crct10dif_rehash_work);
-	return 0;
-}
-
-static void __exit crc_t10dif_mod_fini(void)
-{
-	crypto_unregister_notifier(&crc_t10dif_nb);
-	cancel_work_sync(&crct10dif_rehash_work);
-	crypto_free_shash(rcu_dereference_protected(crct10dif_tfm, 1));
-}
-
-module_init(crc_t10dif_mod_init);
-module_exit(crc_t10dif_mod_fini);
-
 static int crc_t10dif_transform_show(char *buffer, const struct kernel_param *kp)
 {
-	struct crypto_shash *tfm;
-	int len;
-
-	if (static_branch_unlikely(&crct10dif_fallback))
-		return sprintf(buffer, "fallback\n");
-
-	rcu_read_lock();
-	tfm = rcu_dereference(crct10dif_tfm);
-	len = snprintf(buffer, PAGE_SIZE, "%s\n",
-		       crypto_shash_driver_name(tfm));
-	rcu_read_unlock();
-
-	return len;
+	return sprintf(buffer, "fallback\n");
 }
 
 module_param_call(transform, NULL, crc_t10dif_transform_show, NULL, 0444);
 
 MODULE_DESCRIPTION("T10 DIF CRC calculation (library API)");
 MODULE_LICENSE("GPL");
-MODULE_SOFTDEP("pre: crct10dif");
-- 
2.17.1

