Return-Path: <SRS0=4IwG=SP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CEBEC10F11
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Apr 2019 05:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB8F821721
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Apr 2019 05:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555133788;
	bh=/KnHRO3/tJl3wMTTK1G75rpHxym3GpLsnK8cCceY7Po=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=PAs6khRfEowDhId5avei0YymBGO6/w/FANiLEUTEz7eyhJMfMaSPe4i/FyNveShvR
	 Lki/OXwsS71OGC047ofXLtlggD3XI1qRyNOTMZ5YsaOUe4yT03vXiZXlljcz8/XjTN
	 s1AL+qbZjmtacgbLIw0oY3dBMfP6/AqyV94ZQrPY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfDMFg1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Apr 2019 01:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfDMFg1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Apr 2019 01:36:27 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FA3520869;
        Sat, 13 Apr 2019 05:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555133786;
        bh=/KnHRO3/tJl3wMTTK1G75rpHxym3GpLsnK8cCceY7Po=;
        h=From:To:Cc:Subject:Date:From;
        b=RLg4N31cABzH96APR8tlKL81ehan3WuKRaMEdZnq7lzlk5ECgeVZLFLFGlh8E+VO+
         oXBgpTqO9ls3XZ8xoOFpGEgxNYXE3OD1b0/NESh5T0Jcnnmadmn0zKgOvsBX+bVtiq
         er32cRdWgo1YTKvGzVDJhhC1z2uuI+69A1H8d7jE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linuxppc-dev@lists.ozlabs.org, Daniel Axtens <dja@axtens.net>,
        Nayna <nayna@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] crypto: powerpc - convert to use crypto_simd_usable()
Date:   Fri, 12 Apr 2019 22:33:12 -0700
Message-Id: <20190413053312.8783-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Replace all calls to in_interrupt() in the PowerPC crypto code with
!crypto_simd_usable().  This causes the crypto self-tests to test the
no-SIMD code paths when CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.

The p8_ghash algorithm is currently failing and needs to be fixed, as it
produces the wrong digest when no-SIMD updates are mixed with SIMD ones.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/powerpc/crypto/crc32c-vpmsum_glue.c    | 4 +++-
 arch/powerpc/crypto/crct10dif-vpmsum_glue.c | 4 +++-
 arch/powerpc/include/asm/Kbuild             | 1 +
 drivers/crypto/vmx/aes.c                    | 7 ++++---
 drivers/crypto/vmx/aes_cbc.c                | 7 ++++---
 drivers/crypto/vmx/aes_ctr.c                | 5 +++--
 drivers/crypto/vmx/aes_xts.c                | 5 +++--
 drivers/crypto/vmx/ghash.c                  | 9 ++++-----
 8 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/crypto/crc32c-vpmsum_glue.c b/arch/powerpc/crypto/crc32c-vpmsum_glue.c
index fd1d6c83f0c02..c4fa242dd652d 100644
--- a/arch/powerpc/crypto/crc32c-vpmsum_glue.c
+++ b/arch/powerpc/crypto/crc32c-vpmsum_glue.c
@@ -1,10 +1,12 @@
 #include <linux/crc32.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/cpufeature.h>
+#include <asm/simd.h>
 #include <asm/switch_to.h>
 
 #define CHKSUM_BLOCK_SIZE	1
@@ -22,7 +24,7 @@ static u32 crc32c_vpmsum(u32 crc, unsigned char const *p, size_t len)
 	unsigned int prealign;
 	unsigned int tail;
 
-	if (len < (VECTOR_BREAKPOINT + VMX_ALIGN) || in_interrupt())
+	if (len < (VECTOR_BREAKPOINT + VMX_ALIGN) || !crypto_simd_usable())
 		return __crc32c_le(crc, p, len);
 
 	if ((unsigned long)p & VMX_ALIGN_MASK) {
diff --git a/arch/powerpc/crypto/crct10dif-vpmsum_glue.c b/arch/powerpc/crypto/crct10dif-vpmsum_glue.c
index 02ea277863d15..e27ff16573b5b 100644
--- a/arch/powerpc/crypto/crct10dif-vpmsum_glue.c
+++ b/arch/powerpc/crypto/crct10dif-vpmsum_glue.c
@@ -12,11 +12,13 @@
 
 #include <linux/crc-t10dif.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/cpufeature.h>
+#include <asm/simd.h>
 #include <asm/switch_to.h>
 
 #define VMX_ALIGN		16
@@ -32,7 +34,7 @@ static u16 crct10dif_vpmsum(u16 crci, unsigned char const *p, size_t len)
 	unsigned int tail;
 	u32 crc = crci;
 
-	if (len < (VECTOR_BREAKPOINT + VMX_ALIGN) || in_interrupt())
+	if (len < (VECTOR_BREAKPOINT + VMX_ALIGN) || !crypto_simd_usable())
 		return crc_t10dif_generic(crc, p, len);
 
 	if ((unsigned long)p & VMX_ALIGN_MASK) {
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index a0c132bedfae8..5ac3dead69523 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -11,3 +11,4 @@ generic-y += preempt.h
 generic-y += rwsem.h
 generic-y += vtime.h
 generic-y += msi.h
+generic-y += simd.h
diff --git a/drivers/crypto/vmx/aes.c b/drivers/crypto/vmx/aes.c
index b00d6947e02f4..603a620819941 100644
--- a/drivers/crypto/vmx/aes.c
+++ b/drivers/crypto/vmx/aes.c
@@ -23,9 +23,10 @@
 #include <linux/err.h>
 #include <linux/crypto.h>
 #include <linux/delay.h>
-#include <linux/hardirq.h>
+#include <asm/simd.h>
 #include <asm/switch_to.h>
 #include <crypto/aes.h>
+#include <crypto/internal/simd.h>
 
 #include "aesp8-ppc.h"
 
@@ -92,7 +93,7 @@ static void p8_aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct p8_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (in_interrupt()) {
+	if (!crypto_simd_usable()) {
 		crypto_cipher_encrypt_one(ctx->fallback, dst, src);
 	} else {
 		preempt_disable();
@@ -109,7 +110,7 @@ static void p8_aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct p8_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (in_interrupt()) {
+	if (!crypto_simd_usable()) {
 		crypto_cipher_decrypt_one(ctx->fallback, dst, src);
 	} else {
 		preempt_disable();
diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
index fbe882ef1bc5d..a1a9a6f0d42cf 100644
--- a/drivers/crypto/vmx/aes_cbc.c
+++ b/drivers/crypto/vmx/aes_cbc.c
@@ -23,9 +23,10 @@
 #include <linux/err.h>
 #include <linux/crypto.h>
 #include <linux/delay.h>
-#include <linux/hardirq.h>
+#include <asm/simd.h>
 #include <asm/switch_to.h>
 #include <crypto/aes.h>
+#include <crypto/internal/simd.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/skcipher.h>
 
@@ -100,7 +101,7 @@ static int p8_aes_cbc_encrypt(struct blkcipher_desc *desc,
 	struct p8_aes_cbc_ctx *ctx =
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
 
-	if (in_interrupt()) {
+	if (!crypto_simd_usable()) {
 		SYNC_SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
 		skcipher_request_set_sync_tfm(req, ctx->fallback);
 		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
@@ -139,7 +140,7 @@ static int p8_aes_cbc_decrypt(struct blkcipher_desc *desc,
 	struct p8_aes_cbc_ctx *ctx =
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
 
-	if (in_interrupt()) {
+	if (!crypto_simd_usable()) {
 		SYNC_SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
 		skcipher_request_set_sync_tfm(req, ctx->fallback);
 		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index 214c69db9ebdf..192a53512f5e8 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -23,9 +23,10 @@
 #include <linux/err.h>
 #include <linux/crypto.h>
 #include <linux/delay.h>
-#include <linux/hardirq.h>
+#include <asm/simd.h>
 #include <asm/switch_to.h>
 #include <crypto/aes.h>
+#include <crypto/internal/simd.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/skcipher.h>
 
@@ -119,7 +120,7 @@ static int p8_aes_ctr_crypt(struct blkcipher_desc *desc,
 	struct p8_aes_ctr_ctx *ctx =
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
 
-	if (in_interrupt()) {
+	if (!crypto_simd_usable()) {
 		SYNC_SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
 		skcipher_request_set_sync_tfm(req, ctx->fallback);
 		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
index 5bf4c38566502..00d412d811ae6 100644
--- a/drivers/crypto/vmx/aes_xts.c
+++ b/drivers/crypto/vmx/aes_xts.c
@@ -23,9 +23,10 @@
 #include <linux/err.h>
 #include <linux/crypto.h>
 #include <linux/delay.h>
-#include <linux/hardirq.h>
+#include <asm/simd.h>
 #include <asm/switch_to.h>
 #include <crypto/aes.h>
+#include <crypto/internal/simd.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/xts.h>
 #include <crypto/skcipher.h>
@@ -109,7 +110,7 @@ static int p8_aes_xts_crypt(struct blkcipher_desc *desc,
 	struct p8_aes_xts_ctx *ctx =
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
 
-	if (in_interrupt()) {
+	if (!crypto_simd_usable()) {
 		SYNC_SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
 		skcipher_request_set_sync_tfm(req, ctx->fallback);
 		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
diff --git a/drivers/crypto/vmx/ghash.c b/drivers/crypto/vmx/ghash.c
index dd8b8716467a2..611ff591410ea 100644
--- a/drivers/crypto/vmx/ghash.c
+++ b/drivers/crypto/vmx/ghash.c
@@ -23,16 +23,15 @@
 #include <linux/err.h>
 #include <linux/crypto.h>
 #include <linux/delay.h>
-#include <linux/hardirq.h>
+#include <asm/simd.h>
 #include <asm/switch_to.h>
 #include <crypto/aes.h>
 #include <crypto/ghash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <crypto/b128ops.h>
 
-#define IN_INTERRUPT in_interrupt()
-
 void gcm_init_p8(u128 htable[16], const u64 Xi[2]);
 void gcm_gmult_p8(u64 Xi[2], const u128 htable[16]);
 void gcm_ghash_p8(u64 Xi[2], const u128 htable[16],
@@ -131,7 +130,7 @@ static int p8_ghash_update(struct shash_desc *desc,
 	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
 	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	if (IN_INTERRUPT) {
+	if (!crypto_simd_usable()) {
 		return crypto_shash_update(&dctx->fallback_desc, src,
 					   srclen);
 	} else {
@@ -182,7 +181,7 @@ static int p8_ghash_final(struct shash_desc *desc, u8 *out)
 	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
 	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	if (IN_INTERRUPT) {
+	if (!crypto_simd_usable()) {
 		return crypto_shash_final(&dctx->fallback_desc, out);
 	} else {
 		if (dctx->bytes) {
-- 
2.21.0

