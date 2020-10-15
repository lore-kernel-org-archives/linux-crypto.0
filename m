Return-Path: <SRS0=zNo2=DW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2458DC433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Oct 2020 03:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA89D22243
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Oct 2020 03:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgJODcM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Oct 2020 23:32:12 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:44046 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbgJODcM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Oct 2020 23:32:12 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kStzd-0004qJ-An; Thu, 15 Oct 2020 14:31:54 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2020 14:31:53 +1100
Date:   Thu, 15 Oct 2020 14:31:53 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     Keerthy <j-keerthy@ti.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, Tero Kristo <t-kristo@ti.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [RESEND PATCH] crypto: sa2ul - Reduce stack usage
Message-ID: <20201015033153.GA10972@gondor.apana.org.au>
References: <202008161440.gqdm1lpp%lkp@intel.com>
 <20200824131230.GA4813@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824131230.GA4813@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Resending to linux-crypto.
 
---8<---
This patch reduces the stack usage in sa2ul:

1. Move the exported sha state into sa_prepare_iopads so that it
can occupy the same space as the k_pad buffer.

2. Use one buffer for ipad/opad in sa_prepare_iopads.

3. Remove ipad/opad buffer from sa_set_sc_auth.

4. Use async skcipher fallback and remove on-stack request from
sa_cipher_run.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 5bc099052bd2..66629cad9531 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -9,8 +9,10 @@
  *		Tero Kristo
  */
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -356,42 +358,45 @@ static void sa_swiz_128(u8 *in, u16 len)
 }
 
 /* Prepare the ipad and opad from key as per SHA algorithm step 1*/
-static void prepare_kiopad(u8 *k_ipad, u8 *k_opad, const u8 *key, u16 key_sz)
+static void prepare_kipad(u8 *k_ipad, const u8 *key, u16 key_sz)
 {
 	int i;
 
-	for (i = 0; i < key_sz; i++) {
+	for (i = 0; i < key_sz; i++)
 		k_ipad[i] = key[i] ^ 0x36;
-		k_opad[i] = key[i] ^ 0x5c;
-	}
 
 	/* Instead of XOR with 0 */
-	for (; i < SHA1_BLOCK_SIZE; i++) {
+	for (; i < SHA1_BLOCK_SIZE; i++)
 		k_ipad[i] = 0x36;
+}
+
+static void prepare_kopad(u8 *k_opad, const u8 *key, u16 key_sz)
+{
+	int i;
+
+	for (i = 0; i < key_sz; i++)
+		k_opad[i] = key[i] ^ 0x5c;
+
+	/* Instead of XOR with 0 */
+	for (; i < SHA1_BLOCK_SIZE; i++)
 		k_opad[i] = 0x5c;
-	}
 }
 
-static void sa_export_shash(struct shash_desc *hash, int block_size,
+static void sa_export_shash(void *state, struct shash_desc *hash,
 			    int digest_size, __be32 *out)
 {
-	union {
-		struct sha1_state sha1;
-		struct sha256_state sha256;
-		struct sha512_state sha512;
-	} sha;
-	void *state;
+	struct sha1_state *sha1;
+	struct sha256_state *sha256;
 	u32 *result;
-	int i;
 
 	switch (digest_size) {
 	case SHA1_DIGEST_SIZE:
-		state = &sha.sha1;
-		result = sha.sha1.state;
+		sha1 = state;
+		result = sha1->state;
 		break;
 	case SHA256_DIGEST_SIZE:
-		state = &sha.sha256;
-		result = sha.sha256.state;
+		sha256 = state;
+		result = sha256->state;
 		break;
 	default:
 		dev_err(sa_k3_dev, "%s: bad digest_size=%d\n", __func__,
@@ -401,8 +406,7 @@ static void sa_export_shash(struct shash_desc *hash, int block_size,
 
 	crypto_shash_export(hash, state);
 
-	for (i = 0; i < digest_size >> 2; i++)
-		out[i] = cpu_to_be32(result[i]);
+	cpu_to_be32_array(out, result, digest_size / 4);
 }
 
 static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
@@ -411,24 +415,28 @@ static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
 	SHASH_DESC_ON_STACK(shash, data->ctx->shash);
 	int block_size = crypto_shash_blocksize(data->ctx->shash);
 	int digest_size = crypto_shash_digestsize(data->ctx->shash);
-	u8 k_ipad[SHA1_BLOCK_SIZE];
-	u8 k_opad[SHA1_BLOCK_SIZE];
+	union {
+		struct sha1_state sha1;
+		struct sha256_state sha256;
+		u8 k_pad[SHA1_BLOCK_SIZE];
+	} sha;
 
 	shash->tfm = data->ctx->shash;
 
-	prepare_kiopad(k_ipad, k_opad, key, key_sz);
-
-	memzero_explicit(ipad, block_size);
-	memzero_explicit(opad, block_size);
+	prepare_kipad(sha.k_pad, key, key_sz);
 
 	crypto_shash_init(shash);
-	crypto_shash_update(shash, k_ipad, block_size);
-	sa_export_shash(shash, block_size, digest_size, ipad);
+	crypto_shash_update(shash, sha.k_pad, block_size);
+	sa_export_shash(&sha, shash, digest_size, ipad);
+
+	prepare_kopad(sha.k_pad, key, key_sz);
 
 	crypto_shash_init(shash);
-	crypto_shash_update(shash, k_opad, block_size);
+	crypto_shash_update(shash, sha.k_pad, block_size);
 
-	sa_export_shash(shash, block_size, digest_size, opad);
+	sa_export_shash(&sha, shash, digest_size, opad);
+
+	memzero_explicit(&sha, sizeof(sha));
 }
 
 /* Derive the inverse key used in AES-CBC decryption operation */
@@ -501,7 +509,8 @@ static int sa_set_sc_enc(struct algo_data *ad, const u8 *key, u16 key_sz,
 static void sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
 			   u8 *sc_buf)
 {
-	__be32 ipad[64], opad[64];
+	__be32 *ipad = (void *)(sc_buf + 32);
+	__be32 *opad = (void *)(sc_buf + 64);
 
 	/* Set Authentication mode selector to hash processing */
 	sc_buf[0] = SA_HASH_PROCESSING;
@@ -510,14 +519,9 @@ static void sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
 	sc_buf[1] |= ad->auth_ctrl;
 
 	/* Copy the keys or ipad/opad */
-	if (ad->keyed_mac) {
+	if (ad->keyed_mac)
 		ad->prep_iopad(ad, key, key_sz, ipad, opad);
-
-		/* Copy ipad to AuthKey */
-		memcpy(&sc_buf[32], ipad, ad->hash_size);
-		/* Copy opad to Aux-1 */
-		memcpy(&sc_buf[64], opad, ad->hash_size);
-	} else {
+	else {
 		/* basic hash */
 		sc_buf[1] |= SA_BASIC_HASH;
 	}
@@ -814,7 +818,7 @@ static void sa_cipher_cra_exit(struct crypto_skcipher *tfm)
 	sa_free_ctx_info(&ctx->enc, data);
 	sa_free_ctx_info(&ctx->dec, data);
 
-	crypto_free_sync_skcipher(ctx->fallback.skcipher);
+	crypto_free_skcipher(ctx->fallback.skcipher);
 }
 
 static int sa_cipher_cra_init(struct crypto_skcipher *tfm)
@@ -822,6 +826,7 @@ static int sa_cipher_cra_init(struct crypto_skcipher *tfm)
 	struct sa_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
 	const char *name = crypto_tfm_alg_name(&tfm->base);
+	struct crypto_skcipher *child;
 	int ret;
 
 	memzero_explicit(ctx, sizeof(*ctx));
@@ -836,14 +841,17 @@ static int sa_cipher_cra_init(struct crypto_skcipher *tfm)
 		return ret;
 	}
 
-	ctx->fallback.skcipher =
-		crypto_alloc_sync_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
+	child = crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
 
-	if (IS_ERR(ctx->fallback.skcipher)) {
+	if (IS_ERR(child)) {
 		dev_err(sa_k3_dev, "Error allocating fallback algo %s\n", name);
-		return PTR_ERR(ctx->fallback.skcipher);
+		return PTR_ERR(child);
 	}
 
+	ctx->fallback.skcipher = child;
+	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(child) +
+					 sizeof(struct skcipher_request));
+
 	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
 		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
 		ctx->dec.sc_id, &ctx->dec.sc_phys);
@@ -854,6 +862,7 @@ static int sa_cipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			    unsigned int keylen, struct algo_data *ad)
 {
 	struct sa_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child = ctx->fallback.skcipher;
 	int cmdl_len;
 	struct sa_cmdl_cfg cfg;
 	int ret;
@@ -869,12 +878,10 @@ static int sa_cipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	cfg.enc_eng_id = ad->enc_eng.eng_id;
 	cfg.iv_size = crypto_skcipher_ivsize(tfm);
 
-	crypto_sync_skcipher_clear_flags(ctx->fallback.skcipher,
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child, tfm->base.crt_flags &
 					 CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(ctx->fallback.skcipher,
-				       tfm->base.crt_flags &
-				       CRYPTO_TFM_REQ_MASK);
-	ret = crypto_sync_skcipher_setkey(ctx->fallback.skcipher, key, keylen);
+	ret = crypto_skcipher_setkey(child, key, keylen);
 	if (ret)
 		return ret;
 
@@ -1234,7 +1241,6 @@ static int sa_cipher_run(struct skcipher_request *req, u8 *iv, int enc)
 	    crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
 	struct crypto_alg *alg = req->base.tfm->__crt_alg;
 	struct sa_req sa_req = { 0 };
-	int ret;
 
 	if (!req->cryptlen)
 		return 0;
@@ -1246,20 +1252,18 @@ static int sa_cipher_run(struct skcipher_request *req, u8 *iv, int enc)
 	if (req->cryptlen > SA_MAX_DATA_SZ ||
 	    (req->cryptlen >= SA_UNSAFE_DATA_SZ_MIN &&
 	     req->cryptlen <= SA_UNSAFE_DATA_SZ_MAX)) {
-		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback.skcipher);
+		struct skcipher_request *subreq = skcipher_request_ctx(req);
 
-		skcipher_request_set_sync_tfm(subreq, ctx->fallback.skcipher);
+		skcipher_request_set_tfm(subreq, ctx->fallback.skcipher);
 		skcipher_request_set_callback(subreq, req->base.flags,
-					      NULL, NULL);
+					      req->base.complete,
+					      req->base.data);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
 					   req->cryptlen, req->iv);
 		if (enc)
-			ret = crypto_skcipher_encrypt(subreq);
+			return crypto_skcipher_encrypt(subreq);
 		else
-			ret = crypto_skcipher_decrypt(subreq);
-
-		skcipher_request_zero(subreq);
-		return ret;
+			return crypto_skcipher_decrypt(subreq);
 	}
 
 	sa_req.size = req->cryptlen;
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 7f7e3fe60d11..bb40df3876e5 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -12,10 +12,8 @@
 #ifndef _K3_SA2UL_
 #define _K3_SA2UL_
 
-#include <linux/interrupt.h>
-#include <linux/skbuff.h>
-#include <linux/hw_random.h>
 #include <crypto/aes.h>
+#include <crypto/sha.h>
 
 #define SA_ENGINE_ENABLE_CONTROL	0x1000
 
@@ -311,7 +309,7 @@ struct sa_tfm_ctx {
 	struct crypto_shash	*shash;
 	/* for fallback */
 	union {
-		struct crypto_sync_skcipher	*skcipher;
+		struct crypto_skcipher		*skcipher;
 		struct crypto_ahash		*ahash;
 		struct crypto_aead		*aead;
 	} fallback;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
