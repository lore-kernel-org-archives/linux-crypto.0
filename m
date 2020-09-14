Return-Path: <SRS0=QXJz=CX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD7BC43461
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 04:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5722A21655
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 04:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgINEW1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Sep 2020 00:22:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40906 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbgINEWZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Sep 2020 00:22:25 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kHg0O-0004sN-IQ; Mon, 14 Sep 2020 14:22:17 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 14 Sep 2020 14:22:16 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 14 Sep 2020 14:22:16 +1000
Subject: [PATCH 3/3] crypto: inside-secure - Reuse code in safexcel_hmac_alg_setkey
References: <20200914042055.GA19691@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Message-Id: <E1kHg0O-0004sN-IQ@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The code in the current implementation of safexcel_hmac_alg_setkey
can be reused by safexcel_cipher.  This patch does just that by
renaming the previous safexcel_hmac_setkey to __safexcel_hmac_setkey.
The now-shared safexcel_hmac_alg_setkey becomes safexcel_hmac_setkey
and a new safexcel_hmac_alg_setkey has been added for use by ahash
transforms.

As a result safexcel_aead_setkey's stack frame has been reduced by
about half in size, or about 512 bytes.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/inside-secure/safexcel.h        |    5 ++-
 drivers/crypto/inside-secure/safexcel_cipher.c |   36 ++++++------------------
 drivers/crypto/inside-secure/safexcel_hash.c   |   37 +++++++++++++++----------
 3 files changed, 36 insertions(+), 42 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index dd095f6622ace..7bbb6fcec3739 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -908,8 +908,9 @@ void safexcel_rdr_req_set(struct safexcel_crypto_priv *priv,
 inline struct crypto_async_request *
 safexcel_rdr_req_get(struct safexcel_crypto_priv *priv, int ring);
 void safexcel_inv_complete(struct crypto_async_request *req, int error);
-int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
-			 void *istate, void *ostate);
+int safexcel_hmac_setkey(struct safexcel_context *base, const u8 *key,
+			 unsigned int keylen, const char *alg,
+			 unsigned int state_sz);
 
 /* available algorithms */
 extern struct safexcel_alg_template safexcel_alg_ecb_des;
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index d0cfdbb144a3a..9bcfb79a030f1 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -404,11 +404,11 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_ahash_export_state istate, ostate;
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct crypto_authenc_keys keys;
 	struct crypto_aes_ctx aes;
 	int err = -EINVAL, i;
+	const char *alg;
 
 	if (unlikely(crypto_authenc_extractkeys(&keys, key, len)))
 		goto badkey;
@@ -463,53 +463,37 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	/* Auth key */
 	switch (ctx->hash_alg) {
 	case CONTEXT_CONTROL_CRYPTO_ALG_SHA1:
-		if (safexcel_hmac_setkey("safexcel-sha1", keys.authkey,
-					 keys.authkeylen, &istate, &ostate))
-			goto badkey;
+		alg = "safexcel-sha1";
 		break;
 	case CONTEXT_CONTROL_CRYPTO_ALG_SHA224:
-		if (safexcel_hmac_setkey("safexcel-sha224", keys.authkey,
-					 keys.authkeylen, &istate, &ostate))
-			goto badkey;
+		alg = "safexcel-sha224";
 		break;
 	case CONTEXT_CONTROL_CRYPTO_ALG_SHA256:
-		if (safexcel_hmac_setkey("safexcel-sha256", keys.authkey,
-					 keys.authkeylen, &istate, &ostate))
-			goto badkey;
+		alg = "safexcel-sha256";
 		break;
 	case CONTEXT_CONTROL_CRYPTO_ALG_SHA384:
-		if (safexcel_hmac_setkey("safexcel-sha384", keys.authkey,
-					 keys.authkeylen, &istate, &ostate))
-			goto badkey;
+		alg = "safexcel-sha384";
 		break;
 	case CONTEXT_CONTROL_CRYPTO_ALG_SHA512:
-		if (safexcel_hmac_setkey("safexcel-sha512", keys.authkey,
-					 keys.authkeylen, &istate, &ostate))
-			goto badkey;
+		alg = "safexcel-sha512";
 		break;
 	case CONTEXT_CONTROL_CRYPTO_ALG_SM3:
-		if (safexcel_hmac_setkey("safexcel-sm3", keys.authkey,
-					 keys.authkeylen, &istate, &ostate))
-			goto badkey;
+		alg = "safexcel-sm3";
 		break;
 	default:
 		dev_err(priv->dev, "aead: unsupported hash algorithm\n");
 		goto badkey;
 	}
 
-	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma &&
-	    (memcmp(&ctx->base.ipad, istate.state, ctx->state_sz) ||
-	     memcmp(&ctx->base.opad, ostate.state, ctx->state_sz)))
-		ctx->base.needs_inv = true;
+	if (safexcel_hmac_setkey(&ctx->base, keys.authkey, keys.authkeylen,
+				 alg, ctx->state_sz))
+		goto badkey;
 
 	/* Now copy the keys into the context */
 	for (i = 0; i < keys.enckeylen / sizeof(u32); i++)
 		ctx->key[i] = cpu_to_le32(((u32 *)keys.enckey)[i]);
 	ctx->key_len = keys.enckeylen;
 
-	memcpy(&ctx->base.ipad, &istate.state, ctx->state_sz);
-	memcpy(&ctx->base.opad, &ostate.state, ctx->state_sz);
-
 	memzero_explicit(&keys, sizeof(keys));
 	return 0;
 
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 1711ccfc5d36d..1b634889d1115 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -1138,8 +1138,9 @@ static int safexcel_hmac_init_iv(struct ahash_request *areq,
 	return crypto_ahash_export(areq, state);
 }
 
-int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
-			 void *istate, void *ostate)
+static int __safexcel_hmac_setkey(const char *alg, const u8 *key,
+				  unsigned int keylen,
+				  void *istate, void *ostate)
 {
 	struct ahash_request *areq;
 	struct crypto_ahash *tfm;
@@ -1188,30 +1189,38 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 	return ret;
 }
 
-static int safexcel_hmac_alg_setkey(struct crypto_ahash *tfm, const u8 *key,
-				    unsigned int keylen, const char *alg,
-				    unsigned int state_sz)
+int safexcel_hmac_setkey(struct safexcel_context *base, const u8 *key,
+			 unsigned int keylen, const char *alg,
+			 unsigned int state_sz)
 {
-	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
-	struct safexcel_crypto_priv *priv = ctx->base.priv;
+	struct safexcel_crypto_priv *priv = base->priv;
 	struct safexcel_ahash_export_state istate, ostate;
 	int ret;
 
-	ret = safexcel_hmac_setkey(alg, key, keylen, &istate, &ostate);
+	ret = __safexcel_hmac_setkey(alg, key, keylen, &istate, &ostate);
 	if (ret)
 		return ret;
 
-	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr &&
-	    (memcmp(&ctx->base.ipad, istate.state, state_sz) ||
-	     memcmp(&ctx->base.opad, ostate.state, state_sz)))
-		ctx->base.needs_inv = true;
+	if (priv->flags & EIP197_TRC_CACHE && base->ctxr &&
+	    (memcmp(&base->ipad, istate.state, state_sz) ||
+	     memcmp(&base->opad, ostate.state, state_sz)))
+		base->needs_inv = true;
 
-	memcpy(&ctx->base.ipad, &istate.state, state_sz);
-	memcpy(&ctx->base.opad, &ostate.state, state_sz);
+	memcpy(&base->ipad, &istate.state, state_sz);
+	memcpy(&base->opad, &ostate.state, state_sz);
 
 	return 0;
 }
 
+static int safexcel_hmac_alg_setkey(struct crypto_ahash *tfm, const u8 *key,
+				    unsigned int keylen, const char *alg,
+				    unsigned int state_sz)
+{
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
+
+	return safexcel_hmac_setkey(&ctx->base, key, keylen, alg, state_sz);
+}
+
 static int safexcel_hmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
 				     unsigned int keylen)
 {
