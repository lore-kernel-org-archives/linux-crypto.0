Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EDCC10F0F
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F99721874
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552454140;
	bh=cyapBt7M4Bzi+09na+L92Osp2bMFOqtEydBtlXm+Vtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fVp5a1KXVO+NegiBIk1tSoe38BNEzwiPt4chf2MtBCHQBJIZKs8TuaH9bDPn71eC5
	 Sl0XN5nUUAibPeKF21XVRcAifelLd58bWnCL3YDIfl6VI6wDHtk0wg9B5fapc/Vst7
	 uvFBD0FdNY1AZr9rbms5Q7vWdFOyVjD+Jz4ugEI8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfCMFPj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 01:15:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfCMFPi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 01:15:38 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F9321871;
        Wed, 13 Mar 2019 05:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552454136;
        bh=cyapBt7M4Bzi+09na+L92Osp2bMFOqtEydBtlXm+Vtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nF60bKReAZovejhun/eyOWNjJzrXlSRnT1D7yc/Sf4qZmoMdNy62lk7Rjuo3LIQE
         BmfWn1XME99c2FGxt613p+JpeuYyxFXGWONi887BIagy1exCj9nW/AGyqgWkLTJjdi
         s8AiBhLtGWh8We9VyyMaV6fJ7MVdDq+St9c10+2E=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: [PATCH 6/8] crypto: arm64 - convert to use crypto_simd_usable()
Date:   Tue, 12 Mar 2019 22:12:50 -0700
Message-Id: <20190313051252.2917-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190313051252.2917-1-ebiggers@kernel.org>
References: <20190313051252.2917-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Replace all calls to may_use_simd() in the arm64 crypto code with
crypto_simd_usable(), in order to allow testing the no-SIMD code paths.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c      | 7 ++++---
 arch/arm64/crypto/aes-ce-glue.c          | 5 +++--
 arch/arm64/crypto/aes-glue.c             | 4 ++--
 arch/arm64/crypto/aes-neonbs-glue.c      | 2 +-
 arch/arm64/crypto/chacha-neon-glue.c     | 5 +++--
 arch/arm64/crypto/crct10dif-ce-glue.c    | 5 +++--
 arch/arm64/crypto/ghash-ce-glue.c        | 7 ++++---
 arch/arm64/crypto/nhpoly1305-neon-glue.c | 3 ++-
 arch/arm64/crypto/sha1-ce-glue.c         | 7 ++++---
 arch/arm64/crypto/sha2-ce-glue.c         | 7 ++++---
 arch/arm64/crypto/sha256-glue.c          | 5 +++--
 arch/arm64/crypto/sha3-ce-glue.c         | 5 +++--
 arch/arm64/crypto/sha512-ce-glue.c       | 7 ++++---
 arch/arm64/crypto/sm3-ce-glue.c          | 7 ++++---
 arch/arm64/crypto/sm4-ce-glue.c          | 5 +++--
 15 files changed, 47 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 5fc6f51908fd..9dc4110a2e61 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -14,6 +14,7 @@
 #include <crypto/aes.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
+#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/module.h>
 
@@ -109,7 +110,7 @@ static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
 static void ccm_update_mac(struct crypto_aes_ctx *key, u8 mac[], u8 const in[],
 			   u32 abytes, u32 *macp)
 {
-	if (may_use_simd()) {
+	if (crypto_simd_usable()) {
 		kernel_neon_begin();
 		ce_aes_ccm_auth_data(mac, in, abytes, macp, key->key_enc,
 				     num_rounds(key));
@@ -255,7 +256,7 @@ static int ccm_encrypt(struct aead_request *req)
 
 	err = skcipher_walk_aead_encrypt(&walk, req, false);
 
-	if (may_use_simd()) {
+	if (crypto_simd_usable()) {
 		while (walk.nbytes) {
 			u32 tail = walk.nbytes % AES_BLOCK_SIZE;
 
@@ -313,7 +314,7 @@ static int ccm_decrypt(struct aead_request *req)
 
 	err = skcipher_walk_aead_decrypt(&walk, req, false);
 
-	if (may_use_simd()) {
+	if (crypto_simd_usable()) {
 		while (walk.nbytes) {
 			u32 tail = walk.nbytes % AES_BLOCK_SIZE;
 
diff --git a/arch/arm64/crypto/aes-ce-glue.c b/arch/arm64/crypto/aes-ce-glue.c
index e6b3227bbf57..3213843fcb46 100644
--- a/arch/arm64/crypto/aes-ce-glue.c
+++ b/arch/arm64/crypto/aes-ce-glue.c
@@ -12,6 +12,7 @@
 #include <asm/simd.h>
 #include <asm/unaligned.h>
 #include <crypto/aes.h>
+#include <crypto/internal/simd.h>
 #include <linux/cpufeature.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
@@ -52,7 +53,7 @@ static void aes_cipher_encrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
 {
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (!may_use_simd()) {
+	if (!crypto_simd_usable()) {
 		__aes_arm64_encrypt(ctx->key_enc, dst, src, num_rounds(ctx));
 		return;
 	}
@@ -66,7 +67,7 @@ static void aes_cipher_decrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
 {
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (!may_use_simd()) {
+	if (!crypto_simd_usable()) {
 		__aes_arm64_decrypt(ctx->key_dec, dst, src, num_rounds(ctx));
 		return;
 	}
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 1e676625ef33..692cb75f2ca2 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -405,7 +405,7 @@ static int ctr_encrypt_sync(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return aes_ctr_encrypt_fallback(ctx, req);
 
 	return ctr_encrypt(req);
@@ -642,7 +642,7 @@ static void mac_do_update(struct crypto_aes_ctx *ctx, u8 const in[], int blocks,
 {
 	int rounds = 6 + ctx->key_length / 4;
 
-	if (may_use_simd()) {
+	if (crypto_simd_usable()) {
 		kernel_neon_begin();
 		aes_mac_update(in, ctx->key_enc, rounds, blocks, dg, enc_before,
 			       enc_after);
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index e7a95a566462..4737b6c6c5cf 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -288,7 +288,7 @@ static int ctr_encrypt_sync(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return aes_ctr_encrypt_fallback(&ctx->fallback, req);
 
 	return ctr_encrypt(req);
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index bece1d85bd81..3a26a98a7e17 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -21,6 +21,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/chacha.h>
+#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -90,7 +91,7 @@ static int chacha_neon(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
+	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
 		return crypto_chacha_crypt(req);
 
 	return chacha_neon_stream_xor(req, ctx, req->iv);
@@ -104,7 +105,7 @@ static int xchacha_neon(struct skcipher_request *req)
 	u32 state[16];
 	u8 real_iv[16];
 
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
+	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
 		return crypto_xchacha_crypt(req);
 
 	crypto_chacha_init(state, ctx, req->iv);
diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index dd325829ee44..64e92ab70269 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -16,6 +16,7 @@
 #include <linux/string.h>
 
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 
 #include <asm/neon.h>
 #include <asm/simd.h>
@@ -38,7 +39,7 @@ static int crct10dif_update_pmull_p8(struct shash_desc *desc, const u8 *data,
 {
 	u16 *crc = shash_desc_ctx(desc);
 
-	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && may_use_simd()) {
+	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
 		kernel_neon_begin();
 		*crc = crc_t10dif_pmull_p8(*crc, data, length);
 		kernel_neon_end();
@@ -54,7 +55,7 @@ static int crct10dif_update_pmull_p64(struct shash_desc *desc, const u8 *data,
 {
 	u16 *crc = shash_desc_ctx(desc);
 
-	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && may_use_simd()) {
+	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
 		kernel_neon_begin();
 		*crc = crc_t10dif_pmull_p64(*crc, data, length);
 		kernel_neon_end();
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 089b09286da7..fcd458c83bc1 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -17,6 +17,7 @@
 #include <crypto/gf128mul.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/cpufeature.h>
@@ -89,7 +90,7 @@ static void ghash_do_update(int blocks, u64 dg[], const char *src,
 						struct ghash_key const *k,
 						const char *head))
 {
-	if (likely(may_use_simd())) {
+	if (likely(crypto_simd_usable())) {
 		kernel_neon_begin();
 		simd_update(blocks, dg, src, key, head);
 		kernel_neon_end();
@@ -441,7 +442,7 @@ static int gcm_encrypt(struct aead_request *req)
 
 	err = skcipher_walk_aead_encrypt(&walk, req, false);
 
-	if (likely(may_use_simd() && walk.total >= 2 * AES_BLOCK_SIZE)) {
+	if (likely(crypto_simd_usable() && walk.total >= 2 * AES_BLOCK_SIZE)) {
 		u32 const *rk = NULL;
 
 		kernel_neon_begin();
@@ -565,7 +566,7 @@ static int gcm_decrypt(struct aead_request *req)
 
 	err = skcipher_walk_aead_decrypt(&walk, req, false);
 
-	if (likely(may_use_simd() && walk.total >= 2 * AES_BLOCK_SIZE)) {
+	if (likely(crypto_simd_usable() && walk.total >= 2 * AES_BLOCK_SIZE)) {
 		u32 const *rk = NULL;
 
 		kernel_neon_begin();
diff --git a/arch/arm64/crypto/nhpoly1305-neon-glue.c b/arch/arm64/crypto/nhpoly1305-neon-glue.c
index 22cc32ac9448..d15e872fa3f5 100644
--- a/arch/arm64/crypto/nhpoly1305-neon-glue.c
+++ b/arch/arm64/crypto/nhpoly1305-neon-glue.c
@@ -9,6 +9,7 @@
 #include <asm/neon.h>
 #include <asm/simd.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <crypto/nhpoly1305.h>
 #include <linux/module.h>
 
@@ -25,7 +26,7 @@ static void _nh_neon(const u32 *key, const u8 *message, size_t message_len,
 static int nhpoly1305_neon_update(struct shash_desc *desc,
 				  const u8 *src, unsigned int srclen)
 {
-	if (srclen < 64 || !may_use_simd())
+	if (srclen < 64 || !crypto_simd_usable())
 		return crypto_nhpoly1305_update(desc, src, srclen);
 
 	do {
diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index 17fac2889f56..eaa7a8258f1c 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -12,6 +12,7 @@
 #include <asm/simd.h>
 #include <asm/unaligned.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <crypto/sha.h>
 #include <crypto/sha1_base.h>
 #include <linux/cpufeature.h>
@@ -38,7 +39,7 @@ static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
 {
 	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
 
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return crypto_sha1_update(desc, data, len);
 
 	sctx->finalize = 0;
@@ -56,7 +57,7 @@ static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
 	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
 	bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE);
 
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return crypto_sha1_finup(desc, data, len, out);
 
 	/*
@@ -78,7 +79,7 @@ static int sha1_ce_final(struct shash_desc *desc, u8 *out)
 {
 	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
 
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return crypto_sha1_finup(desc, NULL, 0, out);
 
 	sctx->finalize = 0;
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index 261f5195cab7..a725997e55f2 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -12,6 +12,7 @@
 #include <asm/simd.h>
 #include <asm/unaligned.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <crypto/sha.h>
 #include <crypto/sha256_base.h>
 #include <linux/cpufeature.h>
@@ -42,7 +43,7 @@ static int sha256_ce_update(struct shash_desc *desc, const u8 *data,
 {
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
 
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return sha256_base_do_update(desc, data, len,
 				(sha256_block_fn *)sha256_block_data_order);
 
@@ -61,7 +62,7 @@ static int sha256_ce_finup(struct shash_desc *desc, const u8 *data,
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
 	bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE);
 
-	if (!may_use_simd()) {
+	if (!crypto_simd_usable()) {
 		if (len)
 			sha256_base_do_update(desc, data, len,
 				(sha256_block_fn *)sha256_block_data_order);
@@ -90,7 +91,7 @@ static int sha256_ce_final(struct shash_desc *desc, u8 *out)
 {
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
 
-	if (!may_use_simd()) {
+	if (!crypto_simd_usable()) {
 		sha256_base_do_finalize(desc,
 				(sha256_block_fn *)sha256_block_data_order);
 		return sha256_base_finish(desc, out);
diff --git a/arch/arm64/crypto/sha256-glue.c b/arch/arm64/crypto/sha256-glue.c
index 4aedeaefd61f..54586e0be9fd 100644
--- a/arch/arm64/crypto/sha256-glue.c
+++ b/arch/arm64/crypto/sha256-glue.c
@@ -14,6 +14,7 @@
 #include <asm/neon.h>
 #include <asm/simd.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <crypto/sha.h>
 #include <crypto/sha256_base.h>
 #include <linux/cryptohash.h>
@@ -89,7 +90,7 @@ static int sha256_update_neon(struct shash_desc *desc, const u8 *data,
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
 
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return sha256_base_do_update(desc, data, len,
 				(sha256_block_fn *)sha256_block_data_order);
 
@@ -119,7 +120,7 @@ static int sha256_update_neon(struct shash_desc *desc, const u8 *data,
 static int sha256_finup_neon(struct shash_desc *desc, const u8 *data,
 			     unsigned int len, u8 *out)
 {
-	if (!may_use_simd()) {
+	if (!crypto_simd_usable()) {
 		if (len)
 			sha256_base_do_update(desc, data, len,
 				(sha256_block_fn *)sha256_block_data_order);
diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
index a336feac0f59..9a4bbfc45f40 100644
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ b/arch/arm64/crypto/sha3-ce-glue.c
@@ -14,6 +14,7 @@
 #include <asm/simd.h>
 #include <asm/unaligned.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <crypto/sha3.h>
 #include <linux/cpufeature.h>
 #include <linux/crypto.h>
@@ -32,7 +33,7 @@ static int sha3_update(struct shash_desc *desc, const u8 *data,
 	struct sha3_state *sctx = shash_desc_ctx(desc);
 	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
 
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return crypto_sha3_update(desc, data, len);
 
 	if ((sctx->partial + len) >= sctx->rsiz) {
@@ -76,7 +77,7 @@ static int sha3_final(struct shash_desc *desc, u8 *out)
 	__le64 *digest = (__le64 *)out;
 	int i;
 
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return crypto_sha3_final(desc, out);
 
 	sctx->buf[sctx->partial++] = 0x06;
diff --git a/arch/arm64/crypto/sha512-ce-glue.c b/arch/arm64/crypto/sha512-ce-glue.c
index f2c5f28c622a..2369540040aa 100644
--- a/arch/arm64/crypto/sha512-ce-glue.c
+++ b/arch/arm64/crypto/sha512-ce-glue.c
@@ -13,6 +13,7 @@
 #include <asm/simd.h>
 #include <asm/unaligned.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <crypto/sha.h>
 #include <crypto/sha512_base.h>
 #include <linux/cpufeature.h>
@@ -31,7 +32,7 @@ asmlinkage void sha512_block_data_order(u64 *digest, u8 const *src, int blocks);
 static int sha512_ce_update(struct shash_desc *desc, const u8 *data,
 			    unsigned int len)
 {
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return sha512_base_do_update(desc, data, len,
 				(sha512_block_fn *)sha512_block_data_order);
 
@@ -46,7 +47,7 @@ static int sha512_ce_update(struct shash_desc *desc, const u8 *data,
 static int sha512_ce_finup(struct shash_desc *desc, const u8 *data,
 			   unsigned int len, u8 *out)
 {
-	if (!may_use_simd()) {
+	if (!crypto_simd_usable()) {
 		if (len)
 			sha512_base_do_update(desc, data, len,
 				(sha512_block_fn *)sha512_block_data_order);
@@ -65,7 +66,7 @@ static int sha512_ce_finup(struct shash_desc *desc, const u8 *data,
 
 static int sha512_ce_final(struct shash_desc *desc, u8 *out)
 {
-	if (!may_use_simd()) {
+	if (!crypto_simd_usable()) {
 		sha512_base_do_finalize(desc,
 				(sha512_block_fn *)sha512_block_data_order);
 		return sha512_base_finish(desc, out);
diff --git a/arch/arm64/crypto/sm3-ce-glue.c b/arch/arm64/crypto/sm3-ce-glue.c
index 88938a20d9b2..5d15533799a2 100644
--- a/arch/arm64/crypto/sm3-ce-glue.c
+++ b/arch/arm64/crypto/sm3-ce-glue.c
@@ -12,6 +12,7 @@
 #include <asm/simd.h>
 #include <asm/unaligned.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <crypto/sm3.h>
 #include <crypto/sm3_base.h>
 #include <linux/cpufeature.h>
@@ -28,7 +29,7 @@ asmlinkage void sm3_ce_transform(struct sm3_state *sst, u8 const *src,
 static int sm3_ce_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int len)
 {
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return crypto_sm3_update(desc, data, len);
 
 	kernel_neon_begin();
@@ -40,7 +41,7 @@ static int sm3_ce_update(struct shash_desc *desc, const u8 *data,
 
 static int sm3_ce_final(struct shash_desc *desc, u8 *out)
 {
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return crypto_sm3_finup(desc, NULL, 0, out);
 
 	kernel_neon_begin();
@@ -53,7 +54,7 @@ static int sm3_ce_final(struct shash_desc *desc, u8 *out)
 static int sm3_ce_finup(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out)
 {
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return crypto_sm3_finup(desc, data, len, out);
 
 	kernel_neon_begin();
diff --git a/arch/arm64/crypto/sm4-ce-glue.c b/arch/arm64/crypto/sm4-ce-glue.c
index 0c4fc223f225..2754c875d39c 100644
--- a/arch/arm64/crypto/sm4-ce-glue.c
+++ b/arch/arm64/crypto/sm4-ce-glue.c
@@ -3,6 +3,7 @@
 #include <asm/neon.h>
 #include <asm/simd.h>
 #include <crypto/sm4.h>
+#include <crypto/internal/simd.h>
 #include <linux/module.h>
 #include <linux/cpufeature.h>
 #include <linux/crypto.h>
@@ -20,7 +21,7 @@ static void sm4_ce_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (!may_use_simd()) {
+	if (!crypto_simd_usable()) {
 		crypto_sm4_encrypt(tfm, out, in);
 	} else {
 		kernel_neon_begin();
@@ -33,7 +34,7 @@ static void sm4_ce_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (!may_use_simd()) {
+	if (!crypto_simd_usable()) {
 		crypto_sm4_decrypt(tfm, out, in);
 	} else {
 		kernel_neon_begin();
-- 
2.21.0

