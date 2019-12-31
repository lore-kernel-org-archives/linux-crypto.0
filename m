Return-Path: <SRS0=jNyN=2V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F90C2D0C8
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 03:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC18A2053B
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 03:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577762978;
	bh=S5uwpRmcReyMsJ7xNZEIy9mZWw8W7U7ih+VMEFPgtcM=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fGxuFkPXxJWujST/XShglv5XJa3Ve5Su16D68vBnBGvjqfMbItRn9QbzvsXTrr8Vi
	 YSBqDafrkaXr/b/cEo1StqXlOR0PPGJoIgAAndjoVxt7UEztjiDs1qaYL4eUIzGrVj
	 PjRtTBadmp/CBPXOUGJlR+ut6OVccFYdIzfNqvqI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfLaD3h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 22:29:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbfLaD3h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 22:29:37 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FD6920722
        for <linux-crypto@vger.kernel.org>; Tue, 31 Dec 2019 03:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577762460;
        bh=S5uwpRmcReyMsJ7xNZEIy9mZWw8W7U7ih+VMEFPgtcM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=m7+1VCuuN8pn/HQ8indlc7SnYp7E/U0eabjmdmjd9ypRg3H9sYmj3XAhnZSgbgMgC
         xs86EK4SPoptbevcR4fBYpFokyhHbo/wnxNUhENhHKmogfR2auLPSHh5UsGyosFnMa
         rur9c7Lb3ejtx2on9ewecINexsYzEVPjiBJvpQA8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 8/8] crypto: remove propagation of CRYPTO_TFM_RES_* flags
Date:   Mon, 30 Dec 2019 21:19:38 -0600
Message-Id: <20191231031938.241705-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191231031938.241705-1-ebiggers@kernel.org>
References: <20191231031938.241705-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The CRYPTO_TFM_RES_* flags were apparently meant as a way to make the
->setkey() functions provide more information about errors.  But these
flags weren't actually being used or tested, and in many cases they
weren't being set correctly anyway.  So they've now been removed.

Also, if someone ever actually needs to start better distinguishing
->setkey() errors (which is somewhat unlikely, as this has been unneeded
for a long time), we'd be much better off just defining different return
values, like -EINVAL if the key is invalid for the algorithm vs.
-EKEYREJECTED if the key was rejected by a policy like "no weak keys".
That would be much simpler, less error-prone, and easier to test.

So just remove CRYPTO_TFM_RES_MASK and all the unneeded logic that
propagates these flags around.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/ghash-ce-glue.c               |  7 +-----
 arch/s390/crypto/aes_s390.c                   | 23 +++---------------
 arch/x86/crypto/ghash-clmulni-intel_glue.c    |  7 +-----
 crypto/adiantum.c                             |  8 -------
 crypto/authenc.c                              |  6 -----
 crypto/authencesn.c                           |  6 -----
 crypto/ccm.c                                  | 20 ++++------------
 crypto/chacha20poly1305.c                     |  7 +-----
 crypto/cipher.c                               |  1 -
 crypto/cryptd.c                               | 13 ++--------
 crypto/ctr.c                                  |  7 +-----
 crypto/cts.c                                  |  6 +----
 crypto/essiv.c                                | 22 ++++-------------
 crypto/gcm.c                                  | 19 ++-------------
 crypto/lrw.c                                  |  2 --
 crypto/simd.c                                 | 12 ++--------
 crypto/skcipher.c                             |  6 +----
 crypto/xts.c                                  |  8 +------
 drivers/crypto/amcc/crypto4xx_alg.c           | 20 ++--------------
 drivers/crypto/atmel-aes.c                    |  5 +---
 drivers/crypto/atmel-authenc.h                |  3 +--
 drivers/crypto/atmel-sha.c                    | 11 +++------
 drivers/crypto/bcm/cipher.c                   | 14 ++---------
 drivers/crypto/chelsio/chcr_algo.c            | 24 +------------------
 drivers/crypto/geode-aes.c                    | 16 ++-----------
 .../crypto/inside-secure/safexcel_cipher.c    |  5 ----
 drivers/crypto/inside-secure/safexcel_hash.c  |  6 -----
 drivers/crypto/mediatek/mtk-aes.c             |  2 --
 drivers/crypto/mxs-dcp.c                      | 12 +---------
 drivers/crypto/picoxcell_crypto.c             |  9 -------
 drivers/crypto/sahara.c                       |  9 +------
 include/linux/crypto.h                        |  2 --
 32 files changed, 38 insertions(+), 280 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 7e8b2f55685c..a00fd329255f 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -294,16 +294,11 @@ static int ghash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 {
 	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct crypto_ahash *child = &ctx->cryptd_tfm->base;
-	int err;
 
 	crypto_ahash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_ahash_set_flags(child, crypto_ahash_get_flags(tfm)
 			       & CRYPTO_TFM_REQ_MASK);
-	err = crypto_ahash_setkey(child, key, keylen);
-	crypto_ahash_set_flags(tfm, crypto_ahash_get_flags(child)
-			       & CRYPTO_TFM_RES_MASK);
-
-	return err;
+	return crypto_ahash_setkey(child, key, keylen);
 }
 
 static int ghash_async_init_tfm(struct crypto_tfm *tfm)
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 2db167e5871c..1c23d84a9097 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -72,19 +72,12 @@ static int setkey_fallback_cip(struct crypto_tfm *tfm, const u8 *in_key,
 		unsigned int key_len)
 {
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
-	int ret;
 
 	sctx->fallback.cip->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
 	sctx->fallback.cip->base.crt_flags |= (tfm->crt_flags &
 			CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_cipher_setkey(sctx->fallback.cip, in_key, key_len);
-	if (ret) {
-		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (sctx->fallback.cip->base.crt_flags &
-				CRYPTO_TFM_RES_MASK);
-	}
-	return ret;
+	return crypto_cipher_setkey(sctx->fallback.cip, in_key, key_len);
 }
 
 static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
@@ -182,18 +175,13 @@ static int setkey_fallback_skcipher(struct crypto_skcipher *tfm, const u8 *key,
 				    unsigned int len)
 {
 	struct s390_aes_ctx *sctx = crypto_skcipher_ctx(tfm);
-	int ret;
 
 	crypto_skcipher_clear_flags(sctx->fallback.skcipher,
 				    CRYPTO_TFM_REQ_MASK);
 	crypto_skcipher_set_flags(sctx->fallback.skcipher,
 				  crypto_skcipher_get_flags(tfm) &
 				  CRYPTO_TFM_REQ_MASK);
-	ret = crypto_skcipher_setkey(sctx->fallback.skcipher, key, len);
-	crypto_skcipher_set_flags(tfm,
-				  crypto_skcipher_get_flags(sctx->fallback.skcipher) &
-				  CRYPTO_TFM_RES_MASK);
-	return ret;
+	return crypto_skcipher_setkey(sctx->fallback.skcipher, key, len);
 }
 
 static int fallback_skcipher_crypt(struct s390_aes_ctx *sctx,
@@ -389,17 +377,12 @@ static int xts_fallback_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			       unsigned int len)
 {
 	struct s390_xts_ctx *xts_ctx = crypto_skcipher_ctx(tfm);
-	int ret;
 
 	crypto_skcipher_clear_flags(xts_ctx->fallback, CRYPTO_TFM_REQ_MASK);
 	crypto_skcipher_set_flags(xts_ctx->fallback,
 				  crypto_skcipher_get_flags(tfm) &
 				  CRYPTO_TFM_REQ_MASK);
-	ret = crypto_skcipher_setkey(xts_ctx->fallback, key, len);
-	crypto_skcipher_set_flags(tfm,
-				  crypto_skcipher_get_flags(xts_ctx->fallback) &
-				  CRYPTO_TFM_RES_MASK);
-	return ret;
+	return crypto_skcipher_setkey(xts_ctx->fallback, key, len);
 }
 
 static int xts_aes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 4a9c9833a7d6..a4b728518e28 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -255,16 +255,11 @@ static int ghash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 {
 	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct crypto_ahash *child = &ctx->cryptd_tfm->base;
-	int err;
 
 	crypto_ahash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_ahash_set_flags(child, crypto_ahash_get_flags(tfm)
 			       & CRYPTO_TFM_REQ_MASK);
-	err = crypto_ahash_setkey(child, key, keylen);
-	crypto_ahash_set_flags(tfm, crypto_ahash_get_flags(child)
-			       & CRYPTO_TFM_RES_MASK);
-
-	return err;
+	return crypto_ahash_setkey(child, key, keylen);
 }
 
 static int ghash_async_init_tfm(struct crypto_tfm *tfm)
diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 177b1bfbd330..89ca7c77839a 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -133,9 +133,6 @@ static int adiantum_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				  crypto_skcipher_get_flags(tfm) &
 				  CRYPTO_TFM_REQ_MASK);
 	err = crypto_skcipher_setkey(tctx->streamcipher, key, keylen);
-	crypto_skcipher_set_flags(tfm,
-				crypto_skcipher_get_flags(tctx->streamcipher) &
-				CRYPTO_TFM_RES_MASK);
 	if (err)
 		return err;
 
@@ -165,9 +162,6 @@ static int adiantum_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				CRYPTO_TFM_REQ_MASK);
 	err = crypto_cipher_setkey(tctx->blockcipher, keyp,
 				   BLOCKCIPHER_KEY_SIZE);
-	crypto_skcipher_set_flags(tfm,
-				  crypto_cipher_get_flags(tctx->blockcipher) &
-				  CRYPTO_TFM_RES_MASK);
 	if (err)
 		goto out;
 	keyp += BLOCKCIPHER_KEY_SIZE;
@@ -180,8 +174,6 @@ static int adiantum_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	crypto_shash_set_flags(tctx->hash, crypto_skcipher_get_flags(tfm) &
 					   CRYPTO_TFM_REQ_MASK);
 	err = crypto_shash_setkey(tctx->hash, keyp, NHPOLY1305_KEY_SIZE);
-	crypto_skcipher_set_flags(tfm, crypto_shash_get_flags(tctx->hash) &
-				       CRYPTO_TFM_RES_MASK);
 	keyp += NHPOLY1305_KEY_SIZE;
 	WARN_ON(keyp != &data->derived_keys[ARRAY_SIZE(data->derived_keys)]);
 out:
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 4b0b2dc99676..56eea0c90b30 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -97,9 +97,6 @@ static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	crypto_ahash_set_flags(auth, crypto_aead_get_flags(authenc) &
 				    CRYPTO_TFM_REQ_MASK);
 	err = crypto_ahash_setkey(auth, keys.authkey, keys.authkeylen);
-	crypto_aead_set_flags(authenc, crypto_ahash_get_flags(auth) &
-				       CRYPTO_TFM_RES_MASK);
-
 	if (err)
 		goto out;
 
@@ -107,9 +104,6 @@ static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	crypto_skcipher_set_flags(enc, crypto_aead_get_flags(authenc) &
 				       CRYPTO_TFM_REQ_MASK);
 	err = crypto_skcipher_setkey(enc, keys.enckey, keys.enckeylen);
-	crypto_aead_set_flags(authenc, crypto_skcipher_get_flags(enc) &
-				       CRYPTO_TFM_RES_MASK);
-
 out:
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index d43326d6bf5d..edd28f41c1a1 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -71,9 +71,6 @@ static int crypto_authenc_esn_setkey(struct crypto_aead *authenc_esn, const u8 *
 	crypto_ahash_set_flags(auth, crypto_aead_get_flags(authenc_esn) &
 				     CRYPTO_TFM_REQ_MASK);
 	err = crypto_ahash_setkey(auth, keys.authkey, keys.authkeylen);
-	crypto_aead_set_flags(authenc_esn, crypto_ahash_get_flags(auth) &
-					   CRYPTO_TFM_RES_MASK);
-
 	if (err)
 		goto out;
 
@@ -81,9 +78,6 @@ static int crypto_authenc_esn_setkey(struct crypto_aead *authenc_esn, const u8 *
 	crypto_skcipher_set_flags(enc, crypto_aead_get_flags(authenc_esn) &
 					 CRYPTO_TFM_REQ_MASK);
 	err = crypto_skcipher_setkey(enc, keys.enckey, keys.enckeylen);
-	crypto_aead_set_flags(authenc_esn, crypto_skcipher_get_flags(enc) &
-					   CRYPTO_TFM_RES_MASK);
-
 out:
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 40814a00df80..ab501e29d4eb 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -89,26 +89,19 @@ static int crypto_ccm_setkey(struct crypto_aead *aead, const u8 *key,
 	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(aead);
 	struct crypto_skcipher *ctr = ctx->ctr;
 	struct crypto_ahash *mac = ctx->mac;
-	int err = 0;
+	int err;
 
 	crypto_skcipher_clear_flags(ctr, CRYPTO_TFM_REQ_MASK);
 	crypto_skcipher_set_flags(ctr, crypto_aead_get_flags(aead) &
 				       CRYPTO_TFM_REQ_MASK);
 	err = crypto_skcipher_setkey(ctr, key, keylen);
-	crypto_aead_set_flags(aead, crypto_skcipher_get_flags(ctr) &
-			      CRYPTO_TFM_RES_MASK);
 	if (err)
-		goto out;
+		return err;
 
 	crypto_ahash_clear_flags(mac, CRYPTO_TFM_REQ_MASK);
 	crypto_ahash_set_flags(mac, crypto_aead_get_flags(aead) &
 				    CRYPTO_TFM_REQ_MASK);
-	err = crypto_ahash_setkey(mac, key, keylen);
-	crypto_aead_set_flags(aead, crypto_ahash_get_flags(mac) &
-			      CRYPTO_TFM_RES_MASK);
-
-out:
-	return err;
+	return crypto_ahash_setkey(mac, key, keylen);
 }
 
 static int crypto_ccm_setauthsize(struct crypto_aead *tfm,
@@ -583,7 +576,6 @@ static int crypto_rfc4309_setkey(struct crypto_aead *parent, const u8 *key,
 {
 	struct crypto_rfc4309_ctx *ctx = crypto_aead_ctx(parent);
 	struct crypto_aead *child = ctx->child;
-	int err;
 
 	if (keylen < 3)
 		return -EINVAL;
@@ -594,11 +586,7 @@ static int crypto_rfc4309_setkey(struct crypto_aead *parent, const u8 *key,
 	crypto_aead_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_aead_set_flags(child, crypto_aead_get_flags(parent) &
 				     CRYPTO_TFM_REQ_MASK);
-	err = crypto_aead_setkey(child, key, keylen);
-	crypto_aead_set_flags(parent, crypto_aead_get_flags(child) &
-				      CRYPTO_TFM_RES_MASK);
-
-	return err;
+	return crypto_aead_setkey(child, key, keylen);
 }
 
 static int crypto_rfc4309_setauthsize(struct crypto_aead *parent,
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 714532041dab..2ff0166afa15 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -475,7 +475,6 @@ static int chachapoly_setkey(struct crypto_aead *aead, const u8 *key,
 			     unsigned int keylen)
 {
 	struct chachapoly_ctx *ctx = crypto_aead_ctx(aead);
-	int err;
 
 	if (keylen != ctx->saltlen + CHACHA_KEY_SIZE)
 		return -EINVAL;
@@ -486,11 +485,7 @@ static int chachapoly_setkey(struct crypto_aead *aead, const u8 *key,
 	crypto_skcipher_clear_flags(ctx->chacha, CRYPTO_TFM_REQ_MASK);
 	crypto_skcipher_set_flags(ctx->chacha, crypto_aead_get_flags(aead) &
 					       CRYPTO_TFM_REQ_MASK);
-
-	err = crypto_skcipher_setkey(ctx->chacha, key, keylen);
-	crypto_aead_set_flags(aead, crypto_skcipher_get_flags(ctx->chacha) &
-				    CRYPTO_TFM_RES_MASK);
-	return err;
+	return crypto_skcipher_setkey(ctx->chacha, key, keylen);
 }
 
 static int chachapoly_setauthsize(struct crypto_aead *tfm,
diff --git a/crypto/cipher.c b/crypto/cipher.c
index 2dc47e4efec7..f9ce10df557c 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -45,7 +45,6 @@ int crypto_cipher_setkey(struct crypto_cipher *tfm,
 	struct cipher_alg *cia = crypto_cipher_alg(tfm);
 	unsigned long alignmask = crypto_cipher_alignmask(tfm);
 
-	crypto_cipher_clear_flags(tfm, CRYPTO_TFM_RES_MASK);
 	if (keylen < cia->cia_min_keysize || keylen > cia->cia_max_keysize)
 		return -EINVAL;
 
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 7e8d2baee1b5..1963f68e2096 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -226,17 +226,12 @@ static int cryptd_skcipher_setkey(struct crypto_skcipher *parent,
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(parent);
 	struct crypto_sync_skcipher *child = ctx->child;
-	int err;
 
 	crypto_sync_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_sync_skcipher_set_flags(child,
 				       crypto_skcipher_get_flags(parent) &
 					 CRYPTO_TFM_REQ_MASK);
-	err = crypto_sync_skcipher_setkey(child, key, keylen);
-	crypto_skcipher_set_flags(parent,
-				  crypto_sync_skcipher_get_flags(child) &
-					  CRYPTO_TFM_RES_MASK);
-	return err;
+	return crypto_sync_skcipher_setkey(child, key, keylen);
 }
 
 static void cryptd_skcipher_complete(struct skcipher_request *req, int err)
@@ -465,15 +460,11 @@ static int cryptd_hash_setkey(struct crypto_ahash *parent,
 {
 	struct cryptd_hash_ctx *ctx   = crypto_ahash_ctx(parent);
 	struct crypto_shash *child = ctx->child;
-	int err;
 
 	crypto_shash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_shash_set_flags(child, crypto_ahash_get_flags(parent) &
 				      CRYPTO_TFM_REQ_MASK);
-	err = crypto_shash_setkey(child, key, keylen);
-	crypto_ahash_set_flags(parent, crypto_shash_get_flags(child) &
-				       CRYPTO_TFM_RES_MASK);
-	return err;
+	return crypto_shash_setkey(child, key, keylen);
 }
 
 static int cryptd_hash_enqueue(struct ahash_request *req,
diff --git a/crypto/ctr.c b/crypto/ctr.c
index c8076d9106a1..a8feab621c6c 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -170,7 +170,6 @@ static int crypto_rfc3686_setkey(struct crypto_skcipher *parent,
 {
 	struct crypto_rfc3686_ctx *ctx = crypto_skcipher_ctx(parent);
 	struct crypto_skcipher *child = ctx->child;
-	int err;
 
 	/* the nonce is stored in bytes at end of key */
 	if (keylen < CTR_RFC3686_NONCE_SIZE)
@@ -184,11 +183,7 @@ static int crypto_rfc3686_setkey(struct crypto_skcipher *parent,
 	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
 					 CRYPTO_TFM_REQ_MASK);
-	err = crypto_skcipher_setkey(child, key, keylen);
-	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
-					  CRYPTO_TFM_RES_MASK);
-
-	return err;
+	return crypto_skcipher_setkey(child, key, keylen);
 }
 
 static int crypto_rfc3686_crypt(struct skcipher_request *req)
diff --git a/crypto/cts.c b/crypto/cts.c
index b98c5a563346..48188adc8e91 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -78,15 +78,11 @@ static int crypto_cts_setkey(struct crypto_skcipher *parent, const u8 *key,
 {
 	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(parent);
 	struct crypto_skcipher *child = ctx->child;
-	int err;
 
 	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
 					 CRYPTO_TFM_REQ_MASK);
-	err = crypto_skcipher_setkey(child, key, keylen);
-	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
-					  CRYPTO_TFM_RES_MASK);
-	return err;
+	return crypto_skcipher_setkey(child, key, keylen);
 }
 
 static void cts_cbc_crypt_done(struct crypto_async_request *areq, int err)
diff --git a/crypto/essiv.c b/crypto/essiv.c
index 0bc73abb948f..20d7c1fdbf5d 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -75,9 +75,6 @@ static int essiv_skcipher_setkey(struct crypto_skcipher *tfm,
 				  crypto_skcipher_get_flags(tfm) &
 				  CRYPTO_TFM_REQ_MASK);
 	err = crypto_skcipher_setkey(tctx->u.skcipher, key, keylen);
-	crypto_skcipher_set_flags(tfm,
-				  crypto_skcipher_get_flags(tctx->u.skcipher) &
-				  CRYPTO_TFM_RES_MASK);
 	if (err)
 		return err;
 
@@ -90,13 +87,8 @@ static int essiv_skcipher_setkey(struct crypto_skcipher *tfm,
 	crypto_cipher_set_flags(tctx->essiv_cipher,
 				crypto_skcipher_get_flags(tfm) &
 				CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(tctx->essiv_cipher, salt,
-				   crypto_shash_digestsize(tctx->hash));
-	crypto_skcipher_set_flags(tfm,
-				  crypto_cipher_get_flags(tctx->essiv_cipher) &
-				  CRYPTO_TFM_RES_MASK);
-
-	return err;
+	return crypto_cipher_setkey(tctx->essiv_cipher, salt,
+				    crypto_shash_digestsize(tctx->hash));
 }
 
 static int essiv_aead_setkey(struct crypto_aead *tfm, const u8 *key,
@@ -112,8 +104,6 @@ static int essiv_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	crypto_aead_set_flags(tctx->u.aead, crypto_aead_get_flags(tfm) &
 					    CRYPTO_TFM_REQ_MASK);
 	err = crypto_aead_setkey(tctx->u.aead, key, keylen);
-	crypto_aead_set_flags(tfm, crypto_aead_get_flags(tctx->u.aead) &
-				   CRYPTO_TFM_RES_MASK);
 	if (err)
 		return err;
 
@@ -130,12 +120,8 @@ static int essiv_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	crypto_cipher_clear_flags(tctx->essiv_cipher, CRYPTO_TFM_REQ_MASK);
 	crypto_cipher_set_flags(tctx->essiv_cipher, crypto_aead_get_flags(tfm) &
 						    CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(tctx->essiv_cipher, salt,
-				   crypto_shash_digestsize(tctx->hash));
-	crypto_aead_set_flags(tfm, crypto_cipher_get_flags(tctx->essiv_cipher) &
-				   CRYPTO_TFM_RES_MASK);
-
-	return err;
+	return crypto_cipher_setkey(tctx->essiv_cipher, salt,
+				    crypto_shash_digestsize(tctx->hash));
 }
 
 static int essiv_aead_setauthsize(struct crypto_aead *tfm,
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 8330dd2ffec3..9d5a58c1a46c 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -110,8 +110,6 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	crypto_skcipher_set_flags(ctr, crypto_aead_get_flags(aead) &
 				       CRYPTO_TFM_REQ_MASK);
 	err = crypto_skcipher_setkey(ctr, key, keylen);
-	crypto_aead_set_flags(aead, crypto_skcipher_get_flags(ctr) &
-				    CRYPTO_TFM_RES_MASK);
 	if (err)
 		return err;
 
@@ -140,9 +138,6 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	crypto_ahash_set_flags(ghash, crypto_aead_get_flags(aead) &
 			       CRYPTO_TFM_REQ_MASK);
 	err = crypto_ahash_setkey(ghash, (u8 *)&data->hash, sizeof(be128));
-	crypto_aead_set_flags(aead, crypto_ahash_get_flags(ghash) &
-			      CRYPTO_TFM_RES_MASK);
-
 out:
 	kzfree(data);
 	return err;
@@ -705,7 +700,6 @@ static int crypto_rfc4106_setkey(struct crypto_aead *parent, const u8 *key,
 {
 	struct crypto_rfc4106_ctx *ctx = crypto_aead_ctx(parent);
 	struct crypto_aead *child = ctx->child;
-	int err;
 
 	if (keylen < 4)
 		return -EINVAL;
@@ -716,11 +710,7 @@ static int crypto_rfc4106_setkey(struct crypto_aead *parent, const u8 *key,
 	crypto_aead_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_aead_set_flags(child, crypto_aead_get_flags(parent) &
 				     CRYPTO_TFM_REQ_MASK);
-	err = crypto_aead_setkey(child, key, keylen);
-	crypto_aead_set_flags(parent, crypto_aead_get_flags(child) &
-				      CRYPTO_TFM_RES_MASK);
-
-	return err;
+	return crypto_aead_setkey(child, key, keylen);
 }
 
 static int crypto_rfc4106_setauthsize(struct crypto_aead *parent,
@@ -936,7 +926,6 @@ static int crypto_rfc4543_setkey(struct crypto_aead *parent, const u8 *key,
 {
 	struct crypto_rfc4543_ctx *ctx = crypto_aead_ctx(parent);
 	struct crypto_aead *child = ctx->child;
-	int err;
 
 	if (keylen < 4)
 		return -EINVAL;
@@ -947,11 +936,7 @@ static int crypto_rfc4543_setkey(struct crypto_aead *parent, const u8 *key,
 	crypto_aead_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_aead_set_flags(child, crypto_aead_get_flags(parent) &
 				     CRYPTO_TFM_REQ_MASK);
-	err = crypto_aead_setkey(child, key, keylen);
-	crypto_aead_set_flags(parent, crypto_aead_get_flags(child) &
-				      CRYPTO_TFM_RES_MASK);
-
-	return err;
+	return crypto_aead_setkey(child, key, keylen);
 }
 
 static int crypto_rfc4543_setauthsize(struct crypto_aead *parent,
diff --git a/crypto/lrw.c b/crypto/lrw.c
index ae72f8ab1d9f..63c485c0d8a6 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -79,8 +79,6 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
 	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
 					 CRYPTO_TFM_REQ_MASK);
 	err = crypto_skcipher_setkey(child, key, keylen - bsize);
-	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
-					  CRYPTO_TFM_RES_MASK);
 	if (err)
 		return err;
 
diff --git a/crypto/simd.c b/crypto/simd.c
index 48876266cf2d..56885af49c24 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -52,15 +52,11 @@ static int simd_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 {
 	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *child = &ctx->cryptd_tfm->base;
-	int err;
 
 	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(tfm) &
 					 CRYPTO_TFM_REQ_MASK);
-	err = crypto_skcipher_setkey(child, key, key_len);
-	crypto_skcipher_set_flags(tfm, crypto_skcipher_get_flags(child) &
-				       CRYPTO_TFM_RES_MASK);
-	return err;
+	return crypto_skcipher_setkey(child, key, key_len);
 }
 
 static int simd_skcipher_encrypt(struct skcipher_request *req)
@@ -295,15 +291,11 @@ static int simd_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 {
 	struct simd_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_aead *child = &ctx->cryptd_tfm->base;
-	int err;
 
 	crypto_aead_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_aead_set_flags(child, crypto_aead_get_flags(tfm) &
 				     CRYPTO_TFM_REQ_MASK);
-	err = crypto_aead_setkey(child, key, key_len);
-	crypto_aead_set_flags(tfm, crypto_aead_get_flags(child) &
-				   CRYPTO_TFM_RES_MASK);
-	return err;
+	return crypto_aead_setkey(child, key, key_len);
 }
 
 static int simd_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index c50a25f6bef2..e19c7d5715fc 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -880,15 +880,11 @@ static int skcipher_setkey_simple(struct crypto_skcipher *tfm, const u8 *key,
 				  unsigned int keylen)
 {
 	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
-	int err;
 
 	crypto_cipher_clear_flags(cipher, CRYPTO_TFM_REQ_MASK);
 	crypto_cipher_set_flags(cipher, crypto_skcipher_get_flags(tfm) &
 				CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(cipher, key, keylen);
-	crypto_skcipher_set_flags(tfm, crypto_cipher_get_flags(cipher) &
-				  CRYPTO_TFM_RES_MASK);
-	return err;
+	return crypto_cipher_setkey(cipher, key, keylen);
 }
 
 static int skcipher_init_tfm_simple(struct crypto_skcipher *tfm)
diff --git a/crypto/xts.c b/crypto/xts.c
index 43e9048ba36b..29efa15f1495 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -61,8 +61,6 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
 	crypto_cipher_set_flags(tweak, crypto_skcipher_get_flags(parent) &
 				       CRYPTO_TFM_REQ_MASK);
 	err = crypto_cipher_setkey(tweak, key + keylen, keylen);
-	crypto_skcipher_set_flags(parent, crypto_cipher_get_flags(tweak) &
-					  CRYPTO_TFM_RES_MASK);
 	if (err)
 		return err;
 
@@ -71,11 +69,7 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
 	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
 					 CRYPTO_TFM_REQ_MASK);
-	err = crypto_skcipher_setkey(child, key, keylen);
-	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
-					  CRYPTO_TFM_RES_MASK);
-
-	return err;
+	return crypto_skcipher_setkey(child, key, keylen);
 }
 
 /*
diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 121eb81df64f..f7fc0c464125 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -289,19 +289,11 @@ static int crypto4xx_sk_setup_fallback(struct crypto4xx_ctx *ctx,
 				       const u8 *key,
 				       unsigned int keylen)
 {
-	int rc;
-
 	crypto_sync_skcipher_clear_flags(ctx->sw_cipher.cipher,
 				    CRYPTO_TFM_REQ_MASK);
 	crypto_sync_skcipher_set_flags(ctx->sw_cipher.cipher,
 		crypto_skcipher_get_flags(cipher) & CRYPTO_TFM_REQ_MASK);
-	rc = crypto_sync_skcipher_setkey(ctx->sw_cipher.cipher, key, keylen);
-	crypto_skcipher_clear_flags(cipher, CRYPTO_TFM_RES_MASK);
-	crypto_skcipher_set_flags(cipher,
-		crypto_sync_skcipher_get_flags(ctx->sw_cipher.cipher) &
-			CRYPTO_TFM_RES_MASK);
-
-	return rc;
+	return crypto_sync_skcipher_setkey(ctx->sw_cipher.cipher, key, keylen);
 }
 
 int crypto4xx_setkey_aes_ctr(struct crypto_skcipher *cipher,
@@ -376,18 +368,10 @@ static int crypto4xx_aead_setup_fallback(struct crypto4xx_ctx *ctx,
 					 const u8 *key,
 					 unsigned int keylen)
 {
-	int rc;
-
 	crypto_aead_clear_flags(ctx->sw_cipher.aead, CRYPTO_TFM_REQ_MASK);
 	crypto_aead_set_flags(ctx->sw_cipher.aead,
 		crypto_aead_get_flags(cipher) & CRYPTO_TFM_REQ_MASK);
-	rc = crypto_aead_setkey(ctx->sw_cipher.aead, key, keylen);
-	crypto_aead_clear_flags(cipher, CRYPTO_TFM_RES_MASK);
-	crypto_aead_set_flags(cipher,
-		crypto_aead_get_flags(ctx->sw_cipher.aead) &
-			CRYPTO_TFM_RES_MASK);
-
-	return rc;
+	return crypto_aead_setkey(ctx->sw_cipher.aead, key, keylen);
 }
 
 /**
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 898f66cb2eb2..466c15b474da 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2041,7 +2041,6 @@ static int atmel_aes_authenc_setkey(struct crypto_aead *tfm, const u8 *key,
 {
 	struct atmel_aes_authenc_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
@@ -2051,11 +2050,9 @@ static int atmel_aes_authenc_setkey(struct crypto_aead *tfm, const u8 *key,
 		goto badkey;
 
 	/* Save auth key. */
-	flags = crypto_aead_get_flags(tfm);
 	err = atmel_sha_authenc_setkey(ctx->auth,
 				       keys.authkey, keys.authkeylen,
-				       &flags);
-	crypto_aead_set_flags(tfm, flags & CRYPTO_TFM_RES_MASK);
+				       crypto_aead_get_flags(tfm));
 	if (err) {
 		memzero_explicit(&keys, sizeof(keys));
 		return err;
diff --git a/drivers/crypto/atmel-authenc.h b/drivers/crypto/atmel-authenc.h
index d6de810df44f..c6530a1c8c20 100644
--- a/drivers/crypto/atmel-authenc.h
+++ b/drivers/crypto/atmel-authenc.h
@@ -30,8 +30,7 @@ unsigned int atmel_sha_authenc_get_reqsize(void);
 struct atmel_sha_authenc_ctx *atmel_sha_authenc_spawn(unsigned long mode);
 void atmel_sha_authenc_free(struct atmel_sha_authenc_ctx *auth);
 int atmel_sha_authenc_setkey(struct atmel_sha_authenc_ctx *auth,
-			     const u8 *key, unsigned int keylen,
-			     u32 *flags);
+			     const u8 *key, unsigned int keylen, u32 flags);
 
 int atmel_sha_authenc_schedule(struct ahash_request *req,
 			       struct atmel_sha_authenc_ctx *auth,
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index d3bcd14201c2..079fdb8114e9 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2207,18 +2207,13 @@ void atmel_sha_authenc_free(struct atmel_sha_authenc_ctx *auth)
 EXPORT_SYMBOL_GPL(atmel_sha_authenc_free);
 
 int atmel_sha_authenc_setkey(struct atmel_sha_authenc_ctx *auth,
-			     const u8 *key, unsigned int keylen,
-			     u32 *flags)
+			     const u8 *key, unsigned int keylen, u32 flags)
 {
 	struct crypto_ahash *tfm = auth->tfm;
-	int err;
 
 	crypto_ahash_clear_flags(tfm, CRYPTO_TFM_REQ_MASK);
-	crypto_ahash_set_flags(tfm, *flags & CRYPTO_TFM_REQ_MASK);
-	err = crypto_ahash_setkey(tfm, key, keylen);
-	*flags = crypto_ahash_get_flags(tfm);
-
-	return err;
+	crypto_ahash_set_flags(tfm, flags & CRYPTO_TFM_REQ_MASK);
+	return crypto_ahash_setkey(tfm, key, keylen);
 }
 EXPORT_SYMBOL_GPL(atmel_sha_authenc_setkey);
 
diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 184a3e1245cf..c8b9408541a9 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2893,13 +2893,8 @@ static int aead_authenc_setkey(struct crypto_aead *cipher,
 		ctx->fallback_cipher->base.crt_flags |=
 		    tfm->crt_flags & CRYPTO_TFM_REQ_MASK;
 		ret = crypto_aead_setkey(ctx->fallback_cipher, key, keylen);
-		if (ret) {
+		if (ret)
 			flow_log("  fallback setkey() returned:%d\n", ret);
-			tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-			tfm->crt_flags |=
-			    (ctx->fallback_cipher->base.crt_flags &
-			     CRYPTO_TFM_RES_MASK);
-		}
 	}
 
 	ctx->spu_resp_hdr_len = spu->spu_response_hdr_len(ctx->authkeylen,
@@ -2965,13 +2960,8 @@ static int aead_gcm_ccm_setkey(struct crypto_aead *cipher,
 		    tfm->crt_flags & CRYPTO_TFM_REQ_MASK;
 		ret = crypto_aead_setkey(ctx->fallback_cipher, key,
 					 keylen + ctx->salt_len);
-		if (ret) {
+		if (ret)
 			flow_log("  fallback setkey() returned:%d\n", ret);
-			tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-			tfm->crt_flags |=
-			    (ctx->fallback_cipher->base.crt_flags &
-			     CRYPTO_TFM_RES_MASK);
-		}
 	}
 
 	ctx->spu_resp_hdr_len = spu->spu_response_hdr_len(ctx->authkeylen,
diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 720b2ff55464..b4b9b22125d1 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -870,20 +870,13 @@ static int chcr_cipher_fallback_setkey(struct crypto_skcipher *cipher,
 				       const u8 *key,
 				       unsigned int keylen)
 {
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
 	struct ablk_ctx *ablkctx = ABLK_CTX(c_ctx(cipher));
-	int err = 0;
 
 	crypto_sync_skcipher_clear_flags(ablkctx->sw_cipher,
 				CRYPTO_TFM_REQ_MASK);
 	crypto_sync_skcipher_set_flags(ablkctx->sw_cipher,
 				cipher->base.crt_flags & CRYPTO_TFM_REQ_MASK);
-	err = crypto_sync_skcipher_setkey(ablkctx->sw_cipher, key, keylen);
-	tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-	tfm->crt_flags |=
-		crypto_sync_skcipher_get_flags(ablkctx->sw_cipher) &
-		CRYPTO_TFM_RES_MASK;
-	return err;
+	return crypto_sync_skcipher_setkey(ablkctx->sw_cipher, key, keylen);
 }
 
 static int chcr_aes_cbc_setkey(struct crypto_skcipher *cipher,
@@ -3302,9 +3295,6 @@ static int chcr_aead_ccm_setkey(struct crypto_aead *aead,
 	crypto_aead_set_flags(aeadctx->sw_cipher, crypto_aead_get_flags(aead) &
 			      CRYPTO_TFM_REQ_MASK);
 	error = crypto_aead_setkey(aeadctx->sw_cipher, key, keylen);
-	crypto_aead_clear_flags(aead, CRYPTO_TFM_RES_MASK);
-	crypto_aead_set_flags(aead, crypto_aead_get_flags(aeadctx->sw_cipher) &
-			      CRYPTO_TFM_RES_MASK);
 	if (error)
 		return error;
 	return chcr_ccm_common_setkey(aead, key, keylen);
@@ -3324,9 +3314,6 @@ static int chcr_aead_rfc4309_setkey(struct crypto_aead *aead, const u8 *key,
 	crypto_aead_set_flags(aeadctx->sw_cipher, crypto_aead_get_flags(aead) &
 			      CRYPTO_TFM_REQ_MASK);
 	error = crypto_aead_setkey(aeadctx->sw_cipher, key, keylen);
-	crypto_aead_clear_flags(aead, CRYPTO_TFM_RES_MASK);
-	crypto_aead_set_flags(aead, crypto_aead_get_flags(aeadctx->sw_cipher) &
-			      CRYPTO_TFM_RES_MASK);
 	if (error)
 		return error;
 	keylen -= 3;
@@ -3348,9 +3335,6 @@ static int chcr_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	crypto_aead_set_flags(aeadctx->sw_cipher, crypto_aead_get_flags(aead)
 			      & CRYPTO_TFM_REQ_MASK);
 	ret = crypto_aead_setkey(aeadctx->sw_cipher, key, keylen);
-	crypto_aead_clear_flags(aead, CRYPTO_TFM_RES_MASK);
-	crypto_aead_set_flags(aead, crypto_aead_get_flags(aeadctx->sw_cipher) &
-			      CRYPTO_TFM_RES_MASK);
 	if (ret)
 		goto out;
 
@@ -3416,9 +3400,6 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	crypto_aead_set_flags(aeadctx->sw_cipher, crypto_aead_get_flags(authenc)
 			      & CRYPTO_TFM_REQ_MASK);
 	err = crypto_aead_setkey(aeadctx->sw_cipher, key, keylen);
-	crypto_aead_clear_flags(authenc, CRYPTO_TFM_RES_MASK);
-	crypto_aead_set_flags(authenc, crypto_aead_get_flags(aeadctx->sw_cipher)
-			      & CRYPTO_TFM_RES_MASK);
 	if (err)
 		goto out;
 
@@ -3544,9 +3525,6 @@ static int chcr_aead_digest_null_setkey(struct crypto_aead *authenc,
 	crypto_aead_set_flags(aeadctx->sw_cipher, crypto_aead_get_flags(authenc)
 			      & CRYPTO_TFM_REQ_MASK);
 	err = crypto_aead_setkey(aeadctx->sw_cipher, key, keylen);
-	crypto_aead_clear_flags(authenc, CRYPTO_TFM_RES_MASK);
-	crypto_aead_set_flags(authenc, crypto_aead_get_flags(aeadctx->sw_cipher)
-			      & CRYPTO_TFM_RES_MASK);
 	if (err)
 		goto out;
 
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index eb6e6b618361..f4f18bfc2247 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -110,7 +110,6 @@ static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
 		unsigned int len)
 {
 	struct geode_aes_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
-	unsigned int ret;
 
 	tctx->keylen = len;
 
@@ -130,20 +129,13 @@ static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
 	tctx->fallback.cip->base.crt_flags |=
 		(tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_cipher_setkey(tctx->fallback.cip, key, len);
-	if (ret) {
-		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (tctx->fallback.cip->base.crt_flags &
-				   CRYPTO_TFM_RES_MASK);
-	}
-	return ret;
+	return crypto_cipher_setkey(tctx->fallback.cip, key, len);
 }
 
 static int geode_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
 				 unsigned int len)
 {
 	struct geode_aes_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
-	unsigned int ret;
 
 	tctx->keylen = len;
 
@@ -164,11 +156,7 @@ static int geode_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
 	crypto_skcipher_set_flags(tctx->fallback.skcipher,
 				  crypto_skcipher_get_flags(tfm) &
 				  CRYPTO_TFM_REQ_MASK);
-	ret = crypto_skcipher_setkey(tctx->fallback.skcipher, key, len);
-	crypto_skcipher_set_flags(tfm,
-				  crypto_skcipher_get_flags(tctx->fallback.skcipher) &
-				  CRYPTO_TFM_RES_MASK);
-	return ret;
+	return crypto_skcipher_setkey(tctx->fallback.skcipher, key, len);
 }
 
 static void
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 5ee66532f336..0c5e80c3f6e3 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -499,9 +499,6 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 		goto badkey;
 	}
 
-	crypto_aead_set_flags(ctfm, crypto_aead_get_flags(ctfm) &
-				    CRYPTO_TFM_RES_MASK);
-
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma &&
 	    (memcmp(ctx->ipad, istate.state, ctx->state_sz) ||
 	     memcmp(ctx->opad, ostate.state, ctx->state_sz)))
@@ -2583,8 +2580,6 @@ static int safexcel_aead_gcm_setkey(struct crypto_aead *ctfm, const u8 *key,
 	crypto_cipher_set_flags(ctx->hkaes, crypto_aead_get_flags(ctfm) &
 				CRYPTO_TFM_REQ_MASK);
 	ret = crypto_cipher_setkey(ctx->hkaes, key, len);
-	crypto_aead_set_flags(ctfm, crypto_cipher_get_flags(ctx->hkaes) &
-			      CRYPTO_TFM_RES_MASK);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 088d7f8aab5e..43962bc709c6 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -2069,8 +2069,6 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	crypto_cipher_set_flags(ctx->kaes, crypto_ahash_get_flags(tfm) &
 				CRYPTO_TFM_REQ_MASK);
 	ret = crypto_cipher_setkey(ctx->kaes, key, len);
-	crypto_ahash_set_flags(tfm, crypto_cipher_get_flags(ctx->kaes) &
-			       CRYPTO_TFM_RES_MASK);
 	if (ret)
 		return ret;
 
@@ -2090,8 +2088,6 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	ret = crypto_cipher_setkey(ctx->kaes,
 				   (u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
 				   AES_MIN_KEY_SIZE);
-	crypto_ahash_set_flags(tfm, crypto_cipher_get_flags(ctx->kaes) &
-			       CRYPTO_TFM_RES_MASK);
 	if (ret)
 		return ret;
 
@@ -2174,8 +2170,6 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	crypto_cipher_set_flags(ctx->kaes, crypto_ahash_get_flags(tfm) &
 				CRYPTO_TFM_REQ_MASK);
 	ret = crypto_cipher_setkey(ctx->kaes, key, len);
-	crypto_ahash_set_flags(tfm, crypto_cipher_get_flags(ctx->kaes) &
-			       CRYPTO_TFM_RES_MASK);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 00e580bf8536..78d660d963e2 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -1031,8 +1031,6 @@ static int mtk_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	crypto_skcipher_set_flags(ctr, crypto_aead_get_flags(aead) &
 				  CRYPTO_TFM_REQ_MASK);
 	err = crypto_skcipher_setkey(ctr, key, keylen);
-	crypto_aead_set_flags(aead, crypto_skcipher_get_flags(ctr) &
-			      CRYPTO_TFM_RES_MASK);
 	if (err)
 		return err;
 
diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index f438b425c655..435ac1c83df9 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -492,7 +492,6 @@ static int mxs_dcp_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			      unsigned int len)
 {
 	struct dcp_async_ctx *actx = crypto_skcipher_ctx(tfm);
-	unsigned int ret;
 
 	/*
 	 * AES 128 is supposed by the hardware, store key into temporary
@@ -513,16 +512,7 @@ static int mxs_dcp_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	crypto_sync_skcipher_clear_flags(actx->fallback, CRYPTO_TFM_REQ_MASK);
 	crypto_sync_skcipher_set_flags(actx->fallback,
 				  tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
-
-	ret = crypto_sync_skcipher_setkey(actx->fallback, key, len);
-	if (!ret)
-		return 0;
-
-	tfm->base.crt_flags &= ~CRYPTO_TFM_RES_MASK;
-	tfm->base.crt_flags |= crypto_sync_skcipher_get_flags(actx->fallback) &
-			       CRYPTO_TFM_RES_MASK;
-
-	return ret;
+	return crypto_sync_skcipher_setkey(actx->fallback, key, len);
 }
 
 static int mxs_dcp_aes_fallback_init_tfm(struct crypto_skcipher *tfm)
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index ced4cbed9ea0..7384e91c8b32 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -465,9 +465,6 @@ static int spacc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	crypto_aead_set_flags(ctx->sw_cipher, crypto_aead_get_flags(tfm) &
 					      CRYPTO_TFM_REQ_MASK);
 	err = crypto_aead_setkey(ctx->sw_cipher, key, keylen);
-	crypto_aead_clear_flags(tfm, CRYPTO_TFM_RES_MASK);
-	crypto_aead_set_flags(tfm, crypto_aead_get_flags(ctx->sw_cipher) &
-				   CRYPTO_TFM_RES_MASK);
 	if (err)
 		return err;
 
@@ -802,12 +799,6 @@ static int spacc_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 					  CRYPTO_TFM_REQ_MASK);
 
 		err = crypto_sync_skcipher_setkey(ctx->sw_cipher, key, len);
-
-		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |=
-			crypto_sync_skcipher_get_flags(ctx->sw_cipher) &
-			CRYPTO_TFM_RES_MASK;
-
 		if (err)
 			goto sw_setkey_failed;
 	}
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index d4ea2f11ca68..466e30bd529c 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -601,7 +601,6 @@ static int sahara_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			     unsigned int keylen)
 {
 	struct sahara_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int ret;
 
 	ctx->keylen = keylen;
 
@@ -621,13 +620,7 @@ static int sahara_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	crypto_sync_skcipher_clear_flags(ctx->fallback, CRYPTO_TFM_REQ_MASK);
 	crypto_sync_skcipher_set_flags(ctx->fallback, tfm->base.crt_flags &
 						 CRYPTO_TFM_REQ_MASK);
-
-	ret = crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
-
-	tfm->base.crt_flags &= ~CRYPTO_TFM_RES_MASK;
-	tfm->base.crt_flags |= crypto_sync_skcipher_get_flags(ctx->fallback) &
-			       CRYPTO_TFM_RES_MASK;
-	return ret;
+	return crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
 }
 
 static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index accd0c8038fd..763863dbc079 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -107,8 +107,6 @@
 #define CRYPTO_TFM_NEED_KEY		0x00000001
 
 #define CRYPTO_TFM_REQ_MASK		0x000fff00
-#define CRYPTO_TFM_RES_MASK		0xfff00000
-
 #define CRYPTO_TFM_REQ_FORBID_WEAK_KEYS	0x00000100
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
 #define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
-- 
2.24.1

