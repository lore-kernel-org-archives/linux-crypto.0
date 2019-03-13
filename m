Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7264EC10F0B
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40F1F218A3
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552454139;
	bh=yr5n0Wxdm1XUCzFgkf3PqRgYoApvSKI9VmTjgjcFNO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=im1YNkzBqxsJKhZYIvz7MMUHhZifexTndhGAWpYwxys0aZGpdV6MDAiwZ/QQ3OZce
	 xb3aoBO0I3SNYkCUKe6+oumDQO0kASsNEgARHIkEaPjanxCuvXmEJrqOkgkJuA0Z2w
	 cHZqrhGoW1QH3pyhrqD7aNFf3TwUaUHDijeX9d/8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfCMFPh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 01:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbfCMFPh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 01:15:37 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DF0621855;
        Wed, 13 Mar 2019 05:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552454135;
        bh=yr5n0Wxdm1XUCzFgkf3PqRgYoApvSKI9VmTjgjcFNO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3INadTDTroCXX099wNTLjHcQqucz95Met5vuINgtdgHwchN0JVBQkSv6oGjvKSxr
         AnWDvdB5VQxXBC0J3S+teMnuqkdF/x4Yl2y3SpPorzzgmX3qj6ayCRS6Bz5FpZD2ND
         kjqUeWhflk3uip4rCk/AET8eJoXC4ZMMSGdlmM58=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: [PATCH 5/8] crypto: arm - convert to use crypto_simd_usable()
Date:   Tue, 12 Mar 2019 22:12:49 -0700
Message-Id: <20190313051252.2917-6-ebiggers@kernel.org>
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

Replace all calls to may_use_simd() in the arm crypto code with
crypto_simd_usable(), in order to allow testing the no-SIMD code paths.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/chacha-neon-glue.c     | 5 +++--
 arch/arm/crypto/crc32-ce-glue.c        | 5 +++--
 arch/arm/crypto/crct10dif-ce-glue.c    | 3 ++-
 arch/arm/crypto/ghash-ce-glue.c        | 7 ++++---
 arch/arm/crypto/nhpoly1305-neon-glue.c | 3 ++-
 arch/arm/crypto/sha1-ce-glue.c         | 5 +++--
 arch/arm/crypto/sha1_neon_glue.c       | 5 +++--
 arch/arm/crypto/sha2-ce-glue.c         | 5 +++--
 arch/arm/crypto/sha256_neon_glue.c     | 5 +++--
 arch/arm/crypto/sha512-neon-glue.c     | 5 +++--
 10 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/arm/crypto/chacha-neon-glue.c b/arch/arm/crypto/chacha-neon-glue.c
index 9d6fda81986d..48a89537b828 100644
--- a/arch/arm/crypto/chacha-neon-glue.c
+++ b/arch/arm/crypto/chacha-neon-glue.c
@@ -21,6 +21,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/chacha.h>
+#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -93,7 +94,7 @@ static int chacha_neon(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
+	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
 		return crypto_chacha_crypt(req);
 
 	return chacha_neon_stream_xor(req, ctx, req->iv);
@@ -107,7 +108,7 @@ static int xchacha_neon(struct skcipher_request *req)
 	u32 state[16];
 	u8 real_iv[16];
 
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
+	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
 		return crypto_xchacha_crypt(req);
 
 	crypto_chacha_init(state, ctx, req->iv);
diff --git a/arch/arm/crypto/crc32-ce-glue.c b/arch/arm/crypto/crc32-ce-glue.c
index cd9e93b46c2d..e712c2a7d387 100644
--- a/arch/arm/crypto/crc32-ce-glue.c
+++ b/arch/arm/crypto/crc32-ce-glue.c
@@ -16,6 +16,7 @@
 #include <linux/string.h>
 
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
@@ -113,7 +114,7 @@ static int crc32_pmull_update(struct shash_desc *desc, const u8 *data,
 	u32 *crc = shash_desc_ctx(desc);
 	unsigned int l;
 
-	if (may_use_simd()) {
+	if (crypto_simd_usable()) {
 		if ((u32)data % SCALE_F) {
 			l = min_t(u32, length, SCALE_F - ((u32)data % SCALE_F));
 
@@ -147,7 +148,7 @@ static int crc32c_pmull_update(struct shash_desc *desc, const u8 *data,
 	u32 *crc = shash_desc_ctx(desc);
 	unsigned int l;
 
-	if (may_use_simd()) {
+	if (crypto_simd_usable()) {
 		if ((u32)data % SCALE_F) {
 			l = min_t(u32, length, SCALE_F - ((u32)data % SCALE_F));
 
diff --git a/arch/arm/crypto/crct10dif-ce-glue.c b/arch/arm/crypto/crct10dif-ce-glue.c
index 3d6b800b8396..3b24f2872592 100644
--- a/arch/arm/crypto/crct10dif-ce-glue.c
+++ b/arch/arm/crypto/crct10dif-ce-glue.c
@@ -15,6 +15,7 @@
 #include <linux/string.h>
 
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 
 #include <asm/neon.h>
 #include <asm/simd.h>
@@ -36,7 +37,7 @@ static int crct10dif_update(struct shash_desc *desc, const u8 *data,
 {
 	u16 *crc = shash_desc_ctx(desc);
 
-	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && may_use_simd()) {
+	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
 		kernel_neon_begin();
 		*crc = crc_t10dif_pmull(*crc, data, length);
 		kernel_neon_end();
diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index b7d30b6cf49c..60123e9ea9d8 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -14,6 +14,7 @@
 #include <asm/unaligned.h>
 #include <crypto/cryptd.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <crypto/gf128mul.h>
 #include <linux/cpufeature.h>
 #include <linux/crypto.h>
@@ -196,7 +197,7 @@ static int ghash_async_update(struct ahash_request *req)
 	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
 
-	if (!may_use_simd() ||
+	if (!crypto_simd_usable() ||
 	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
 		memcpy(cryptd_req, req, sizeof(*req));
 		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
@@ -214,7 +215,7 @@ static int ghash_async_final(struct ahash_request *req)
 	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
 
-	if (!may_use_simd() ||
+	if (!crypto_simd_usable() ||
 	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
 		memcpy(cryptd_req, req, sizeof(*req));
 		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
@@ -232,7 +233,7 @@ static int ghash_async_digest(struct ahash_request *req)
 	struct ahash_request *cryptd_req = ahash_request_ctx(req);
 	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
 
-	if (!may_use_simd() ||
+	if (!crypto_simd_usable() ||
 	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
 		memcpy(cryptd_req, req, sizeof(*req));
 		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
diff --git a/arch/arm/crypto/nhpoly1305-neon-glue.c b/arch/arm/crypto/nhpoly1305-neon-glue.c
index 49aae87cb2bc..ae5aefc44a4d 100644
--- a/arch/arm/crypto/nhpoly1305-neon-glue.c
+++ b/arch/arm/crypto/nhpoly1305-neon-glue.c
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
diff --git a/arch/arm/crypto/sha1-ce-glue.c b/arch/arm/crypto/sha1-ce-glue.c
index b732522e20f8..4c6c6900853c 100644
--- a/arch/arm/crypto/sha1-ce-glue.c
+++ b/arch/arm/crypto/sha1-ce-glue.c
@@ -9,6 +9,7 @@
  */
 
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <crypto/sha.h>
 #include <crypto/sha1_base.h>
 #include <linux/cpufeature.h>
@@ -33,7 +34,7 @@ static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
 
-	if (!may_use_simd() ||
+	if (!crypto_simd_usable() ||
 	    (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
 		return sha1_update_arm(desc, data, len);
 
@@ -47,7 +48,7 @@ static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
 static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
 			 unsigned int len, u8 *out)
 {
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return sha1_finup_arm(desc, data, len, out);
 
 	kernel_neon_begin();
diff --git a/arch/arm/crypto/sha1_neon_glue.c b/arch/arm/crypto/sha1_neon_glue.c
index d15e0ea2c95e..d6c95c213d42 100644
--- a/arch/arm/crypto/sha1_neon_glue.c
+++ b/arch/arm/crypto/sha1_neon_glue.c
@@ -19,6 +19,7 @@
  */
 
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
@@ -39,7 +40,7 @@ static int sha1_neon_update(struct shash_desc *desc, const u8 *data,
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
 
-	if (!may_use_simd() ||
+	if (!crypto_simd_usable() ||
 	    (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
 		return sha1_update_arm(desc, data, len);
 
@@ -54,7 +55,7 @@ static int sha1_neon_update(struct shash_desc *desc, const u8 *data,
 static int sha1_neon_finup(struct shash_desc *desc, const u8 *data,
 			   unsigned int len, u8 *out)
 {
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return sha1_finup_arm(desc, data, len, out);
 
 	kernel_neon_begin();
diff --git a/arch/arm/crypto/sha2-ce-glue.c b/arch/arm/crypto/sha2-ce-glue.c
index 1211a5c129fc..a47a9d4b663e 100644
--- a/arch/arm/crypto/sha2-ce-glue.c
+++ b/arch/arm/crypto/sha2-ce-glue.c
@@ -9,6 +9,7 @@
  */
 
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <crypto/sha.h>
 #include <crypto/sha256_base.h>
 #include <linux/cpufeature.h>
@@ -34,7 +35,7 @@ static int sha2_ce_update(struct shash_desc *desc, const u8 *data,
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
 
-	if (!may_use_simd() ||
+	if (!crypto_simd_usable() ||
 	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
 		return crypto_sha256_arm_update(desc, data, len);
 
@@ -49,7 +50,7 @@ static int sha2_ce_update(struct shash_desc *desc, const u8 *data,
 static int sha2_ce_finup(struct shash_desc *desc, const u8 *data,
 			 unsigned int len, u8 *out)
 {
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return crypto_sha256_arm_finup(desc, data, len, out);
 
 	kernel_neon_begin();
diff --git a/arch/arm/crypto/sha256_neon_glue.c b/arch/arm/crypto/sha256_neon_glue.c
index 1d82c6cd31a4..f3f6b1624fc3 100644
--- a/arch/arm/crypto/sha256_neon_glue.c
+++ b/arch/arm/crypto/sha256_neon_glue.c
@@ -15,6 +15,7 @@
  */
 
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -34,7 +35,7 @@ static int sha256_update(struct shash_desc *desc, const u8 *data,
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
 
-	if (!may_use_simd() ||
+	if (!crypto_simd_usable() ||
 	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
 		return crypto_sha256_arm_update(desc, data, len);
 
@@ -49,7 +50,7 @@ static int sha256_update(struct shash_desc *desc, const u8 *data,
 static int sha256_finup(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out)
 {
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return crypto_sha256_arm_finup(desc, data, len, out);
 
 	kernel_neon_begin();
diff --git a/arch/arm/crypto/sha512-neon-glue.c b/arch/arm/crypto/sha512-neon-glue.c
index 8a5642b41fd6..d33ab59c26c0 100644
--- a/arch/arm/crypto/sha512-neon-glue.c
+++ b/arch/arm/crypto/sha512-neon-glue.c
@@ -9,6 +9,7 @@
  */
 
 #include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
 #include <crypto/sha.h>
 #include <crypto/sha512_base.h>
 #include <linux/crypto.h>
@@ -30,7 +31,7 @@ static int sha512_neon_update(struct shash_desc *desc, const u8 *data,
 {
 	struct sha512_state *sctx = shash_desc_ctx(desc);
 
-	if (!may_use_simd() ||
+	if (!crypto_simd_usable() ||
 	    (sctx->count[0] % SHA512_BLOCK_SIZE) + len < SHA512_BLOCK_SIZE)
 		return sha512_arm_update(desc, data, len);
 
@@ -45,7 +46,7 @@ static int sha512_neon_update(struct shash_desc *desc, const u8 *data,
 static int sha512_neon_finup(struct shash_desc *desc, const u8 *data,
 			     unsigned int len, u8 *out)
 {
-	if (!may_use_simd())
+	if (!crypto_simd_usable())
 		return sha512_arm_finup(desc, data, len, out);
 
 	kernel_neon_begin();
-- 
2.21.0

