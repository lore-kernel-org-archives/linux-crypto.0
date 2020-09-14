Return-Path: <SRS0=QXJz=CX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DACD7C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 04:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F32B21974
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 04:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgINEWn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Sep 2020 00:22:43 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40912 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgINEW0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Sep 2020 00:22:26 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kHg0M-0004sL-9E; Mon, 14 Sep 2020 14:22:15 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 14 Sep 2020 14:22:14 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 14 Sep 2020 14:22:14 +1000
Subject: [PATCH 2/3] crypto: inside-secure - Move ipad/opad into safexcel_context
References: <20200914042055.GA19691@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Message-Id: <E1kHg0M-0004sL-9E@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As both safexcel_ahash_ctx and safexcel_cipher_ctx contain ipad
and opad buffers this patch moves them into the common struct
safexcel_context.  It also adds a union so that they can be accessed
in the appropriate endian without crazy casts.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/inside-secure/safexcel.h        |    9 ++
 drivers/crypto/inside-secure/safexcel_cipher.c |   20 ++--
 drivers/crypto/inside-secure/safexcel_hash.c   |  106 ++++++++++++-------------
 3 files changed, 72 insertions(+), 63 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 77eb285b335f4..dd095f6622ace 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -12,7 +12,9 @@
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha.h>
+#include <crypto/sha3.h>
 #include <crypto/skcipher.h>
+#include <linux/types.h>
 
 #define EIP197_HIA_VERSION_BE			0xca35
 #define EIP197_HIA_VERSION_LE			0x35ca
@@ -822,6 +824,13 @@ struct safexcel_context {
 	struct safexcel_crypto_priv *priv;
 	dma_addr_t ctxr_dma;
 
+	union {
+		__le32 le[SHA3_512_BLOCK_SIZE / 4];
+		__be32 be[SHA3_512_BLOCK_SIZE / 4];
+		u32 word[SHA3_512_BLOCK_SIZE / 4];
+		u8 byte[SHA3_512_BLOCK_SIZE];
+	} ipad, opad;
+
 	int ring;
 	bool needs_inv;
 	bool exit_inv;
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 052df0da02f47..d0cfdbb144a3a 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -61,8 +61,6 @@ struct safexcel_cipher_ctx {
 	/* All the below is AEAD specific */
 	u32 hash_alg;
 	u32 state_sz;
-	__be32 ipad[SHA512_DIGEST_SIZE / sizeof(u32)];
-	__be32 opad[SHA512_DIGEST_SIZE / sizeof(u32)];
 
 	struct crypto_cipher *hkaes;
 	struct crypto_aead *fback;
@@ -500,8 +498,8 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	}
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma &&
-	    (memcmp(ctx->ipad, istate.state, ctx->state_sz) ||
-	     memcmp(ctx->opad, ostate.state, ctx->state_sz)))
+	    (memcmp(&ctx->base.ipad, istate.state, ctx->state_sz) ||
+	     memcmp(&ctx->base.opad, ostate.state, ctx->state_sz)))
 		ctx->base.needs_inv = true;
 
 	/* Now copy the keys into the context */
@@ -509,8 +507,8 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 		ctx->key[i] = cpu_to_le32(((u32 *)keys.enckey)[i]);
 	ctx->key_len = keys.enckeylen;
 
-	memcpy(ctx->ipad, &istate.state, ctx->state_sz);
-	memcpy(ctx->opad, &ostate.state, ctx->state_sz);
+	memcpy(&ctx->base.ipad, &istate.state, ctx->state_sz);
+	memcpy(&ctx->base.opad, &ostate.state, ctx->state_sz);
 
 	memzero_explicit(&keys, sizeof(keys));
 	return 0;
@@ -718,10 +716,10 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 			totlen_dst += digestsize;
 
 		memcpy(ctx->base.ctxr->data + ctx->key_len / sizeof(u32),
-		       ctx->ipad, ctx->state_sz);
+		       &ctx->base.ipad, ctx->state_sz);
 		if (!ctx->xcm)
 			memcpy(ctx->base.ctxr->data + (ctx->key_len +
-			       ctx->state_sz) / sizeof(u32), ctx->opad,
+			       ctx->state_sz) / sizeof(u32), &ctx->base.opad,
 			       ctx->state_sz);
 	} else if ((ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) &&
 		   (sreq->direction == SAFEXCEL_DECRYPT)) {
@@ -2618,7 +2616,7 @@ static int safexcel_aead_gcm_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < AES_BLOCK_SIZE / sizeof(u32); i++) {
-			if (be32_to_cpu(ctx->ipad[i]) != hashkey[i]) {
+			if (be32_to_cpu(ctx->base.ipad.be[i]) != hashkey[i]) {
 				ctx->base.needs_inv = true;
 				break;
 			}
@@ -2626,7 +2624,7 @@ static int safexcel_aead_gcm_setkey(struct crypto_aead *ctfm, const u8 *key,
 	}
 
 	for (i = 0; i < AES_BLOCK_SIZE / sizeof(u32); i++)
-		ctx->ipad[i] = cpu_to_be32(hashkey[i]);
+		ctx->base.ipad.be[i] = cpu_to_be32(hashkey[i]);
 
 	memzero_explicit(hashkey, AES_BLOCK_SIZE);
 	memzero_explicit(&aes, sizeof(aes));
@@ -2714,7 +2712,7 @@ static int safexcel_aead_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 	for (i = 0; i < len / sizeof(u32); i++) {
 		ctx->key[i] = cpu_to_le32(aes.key_enc[i]);
-		ctx->ipad[i + 2 * AES_BLOCK_SIZE / sizeof(u32)] =
+		ctx->base.ipad.be[i + 2 * AES_BLOCK_SIZE / sizeof(u32)] =
 			cpu_to_be32(aes.key_enc[i]);
 	}
 
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index cdedd7976f26b..1711ccfc5d36d 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -28,9 +28,6 @@ struct safexcel_ahash_ctx {
 	bool fb_init_done;
 	bool fb_do_setkey;
 
-	__le32 ipad[SHA3_512_BLOCK_SIZE / sizeof(__le32)];
-	__le32 opad[SHA3_512_BLOCK_SIZE / sizeof(__le32)];
-
 	struct crypto_cipher *kaes;
 	struct crypto_ahash *fback;
 	struct crypto_shash *shpre;
@@ -123,7 +120,7 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 	 */
 	if (unlikely(req->digest == CONTEXT_CONTROL_DIGEST_XCM)) {
 		if (req->xcbcmac)
-			memcpy(ctx->base.ctxr->data, ctx->ipad, ctx->key_sz);
+			memcpy(ctx->base.ctxr->data, &ctx->base.ipad, ctx->key_sz);
 		else
 			memcpy(ctx->base.ctxr->data, req->state, req->state_sz);
 
@@ -205,7 +202,7 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 		} else { /* HMAC */
 			/* Need outer digest for HMAC finalization */
 			memcpy(ctx->base.ctxr->data + (req->state_sz >> 2),
-			       ctx->opad, req->state_sz);
+			       &ctx->base.opad, req->state_sz);
 
 			/* Single pass HMAC - no digest count */
 			cdesc->control_data.control0 |=
@@ -274,7 +271,7 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv,
 			memcpy(sreq->cache, sreq->state,
 			       crypto_ahash_digestsize(ahash));
 
-			memcpy(sreq->state, ctx->opad, sreq->digest_sz);
+			memcpy(sreq->state, &ctx->base.opad, sreq->digest_sz);
 
 			sreq->len = sreq->block_sz +
 				    crypto_ahash_digestsize(ahash);
@@ -378,10 +375,14 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 				// 10- padding for XCBCMAC & CMAC
 				req->cache[cache_len + skip] = 0x80;
 				// HW will use K2 iso K3 - compensate!
-				for (i = 0; i < AES_BLOCK_SIZE / sizeof(u32); i++)
-					((__be32 *)req->cache)[i] ^=
-					  cpu_to_be32(le32_to_cpu(
-					    ctx->ipad[i] ^ ctx->ipad[i + 4]));
+				for (i = 0; i < AES_BLOCK_SIZE / 4; i++) {
+					u32 *cache = (void *)req->cache;
+					u32 *ipad = ctx->base.ipad.word;
+					u32 x;
+
+					x = ipad[i] ^ ipad[i + 4];
+					cache[i] ^= swab(x);
+				}
 			}
 			cache_len = AES_BLOCK_SIZE;
 			queued = queued + extra;
@@ -701,7 +702,7 @@ static int safexcel_ahash_enqueue(struct ahash_request *areq)
 		     /* invalidate for HMAC finish with odigest changed */
 		     (req->finish && req->hmac &&
 		      memcmp(ctx->base.ctxr->data + (req->state_sz>>2),
-			     ctx->opad, req->state_sz))))
+			     &ctx->base.opad, req->state_sz))))
 			/*
 			 * We're still setting needs_inv here, even though it is
 			 * cleared right away, because the needs_inv flag can be
@@ -802,7 +803,7 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 			    ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_MD5 &&
 			    req->len == sizeof(u32) && !areq->nbytes)) {
 		/* Zero length CRC32 */
-		memcpy(areq->result, ctx->ipad, sizeof(u32));
+		memcpy(areq->result, &ctx->base.ipad, sizeof(u32));
 		return 0;
 	} else if (unlikely(ctx->cbcmac && req->len == AES_BLOCK_SIZE &&
 			    !areq->nbytes)) {
@@ -814,9 +815,12 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 		/* Zero length (X)CBC/CMAC */
 		int i;
 
-		for (i = 0; i < AES_BLOCK_SIZE / sizeof(u32); i++)
-			((__be32 *)areq->result)[i] =
-				cpu_to_be32(le32_to_cpu(ctx->ipad[i + 4]));//K3
+		for (i = 0; i < AES_BLOCK_SIZE / sizeof(u32); i++) {
+			u32 *result = (void *)areq->result;
+
+			/* K3 */
+			result[i] = swab(ctx->base.ipad.word[i + 4]);
+		}
 		areq->result[0] ^= 0x80;			// 10- padding
 		crypto_cipher_encrypt_one(ctx->kaes, areq->result, areq->result);
 		return 0;
@@ -1011,7 +1015,7 @@ static int safexcel_hmac_sha1_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Start from ipad precompute */
-	memcpy(req->state, ctx->ipad, SHA1_DIGEST_SIZE);
+	memcpy(req->state, &ctx->base.ipad, SHA1_DIGEST_SIZE);
 	/* Already processed the key^ipad part now! */
 	req->len	= SHA1_BLOCK_SIZE;
 	req->processed	= SHA1_BLOCK_SIZE;
@@ -1198,12 +1202,12 @@ static int safexcel_hmac_alg_setkey(struct crypto_ahash *tfm, const u8 *key,
 		return ret;
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr &&
-	    (memcmp(ctx->ipad, istate.state, state_sz) ||
-	     memcmp(ctx->opad, ostate.state, state_sz)))
+	    (memcmp(&ctx->base.ipad, istate.state, state_sz) ||
+	     memcmp(&ctx->base.opad, ostate.state, state_sz)))
 		ctx->base.needs_inv = true;
 
-	memcpy(ctx->ipad, &istate.state, state_sz);
-	memcpy(ctx->opad, &ostate.state, state_sz);
+	memcpy(&ctx->base.ipad, &istate.state, state_sz);
+	memcpy(&ctx->base.opad, &ostate.state, state_sz);
 
 	return 0;
 }
@@ -1376,7 +1380,7 @@ static int safexcel_hmac_sha224_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Start from ipad precompute */
-	memcpy(req->state, ctx->ipad, SHA256_DIGEST_SIZE);
+	memcpy(req->state, &ctx->base.ipad, SHA256_DIGEST_SIZE);
 	/* Already processed the key^ipad part now! */
 	req->len	= SHA256_BLOCK_SIZE;
 	req->processed	= SHA256_BLOCK_SIZE;
@@ -1448,7 +1452,7 @@ static int safexcel_hmac_sha256_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Start from ipad precompute */
-	memcpy(req->state, ctx->ipad, SHA256_DIGEST_SIZE);
+	memcpy(req->state, &ctx->base.ipad, SHA256_DIGEST_SIZE);
 	/* Already processed the key^ipad part now! */
 	req->len	= SHA256_BLOCK_SIZE;
 	req->processed	= SHA256_BLOCK_SIZE;
@@ -1634,7 +1638,7 @@ static int safexcel_hmac_sha512_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Start from ipad precompute */
-	memcpy(req->state, ctx->ipad, SHA512_DIGEST_SIZE);
+	memcpy(req->state, &ctx->base.ipad, SHA512_DIGEST_SIZE);
 	/* Already processed the key^ipad part now! */
 	req->len	= SHA512_BLOCK_SIZE;
 	req->processed	= SHA512_BLOCK_SIZE;
@@ -1706,7 +1710,7 @@ static int safexcel_hmac_sha384_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Start from ipad precompute */
-	memcpy(req->state, ctx->ipad, SHA512_DIGEST_SIZE);
+	memcpy(req->state, &ctx->base.ipad, SHA512_DIGEST_SIZE);
 	/* Already processed the key^ipad part now! */
 	req->len	= SHA512_BLOCK_SIZE;
 	req->processed	= SHA512_BLOCK_SIZE;
@@ -1828,7 +1832,7 @@ static int safexcel_hmac_md5_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Start from ipad precompute */
-	memcpy(req->state, ctx->ipad, MD5_DIGEST_SIZE);
+	memcpy(req->state, &ctx->base.ipad, MD5_DIGEST_SIZE);
 	/* Already processed the key^ipad part now! */
 	req->len	= MD5_HMAC_BLOCK_SIZE;
 	req->processed	= MD5_HMAC_BLOCK_SIZE;
@@ -1899,7 +1903,7 @@ static int safexcel_crc32_cra_init(struct crypto_tfm *tfm)
 	int ret = safexcel_ahash_cra_init(tfm);
 
 	/* Default 'key' is all zeroes */
-	memset(ctx->ipad, 0, sizeof(u32));
+	memset(&ctx->base.ipad, 0, sizeof(u32));
 	return ret;
 }
 
@@ -1911,7 +1915,7 @@ static int safexcel_crc32_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Start from loaded key */
-	req->state[0]	= (__force __le32)le32_to_cpu(~ctx->ipad[0]);
+	req->state[0]	= cpu_to_le32(~ctx->base.ipad.word[0]);
 	/* Set processed to non-zero to enable invalidation detection */
 	req->len	= sizeof(u32);
 	req->processed	= sizeof(u32);
@@ -1933,7 +1937,7 @@ static int safexcel_crc32_setkey(struct crypto_ahash *tfm, const u8 *key,
 	if (keylen != sizeof(u32))
 		return -EINVAL;
 
-	memcpy(ctx->ipad, key, sizeof(u32));
+	memcpy(&ctx->base.ipad, key, sizeof(u32));
 	return 0;
 }
 
@@ -1983,7 +1987,7 @@ static int safexcel_cbcmac_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Start from loaded keys */
-	memcpy(req->state, ctx->ipad, ctx->key_sz);
+	memcpy(req->state, &ctx->base.ipad, ctx->key_sz);
 	/* Set processed to non-zero to enable invalidation detection */
 	req->len	= AES_BLOCK_SIZE;
 	req->processed	= AES_BLOCK_SIZE;
@@ -2008,9 +2012,9 @@ static int safexcel_cbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	if (ret)
 		return ret;
 
-	memset(ctx->ipad, 0, 2 * AES_BLOCK_SIZE);
+	memset(&ctx->base.ipad, 0, 2 * AES_BLOCK_SIZE);
 	for (i = 0; i < len / sizeof(u32); i++)
-		ctx->ipad[i + 8] = (__force __le32)cpu_to_be32(aes.key_enc[i]);
+		ctx->base.ipad.be[i + 8] = cpu_to_be32(aes.key_enc[i]);
 
 	if (len == AES_KEYSIZE_192) {
 		ctx->alg    = CONTEXT_CONTROL_CRYPTO_ALG_XCBC192;
@@ -2092,8 +2096,7 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	crypto_cipher_encrypt_one(ctx->kaes, (u8 *)key_tmp + AES_BLOCK_SIZE,
 		"\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3");
 	for (i = 0; i < 3 * AES_BLOCK_SIZE / sizeof(u32); i++)
-		ctx->ipad[i] =
-			cpu_to_le32((__force u32)cpu_to_be32(key_tmp[i]));
+		ctx->base.ipad.word[i] = swab(key_tmp[i]);
 
 	crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
 	crypto_cipher_set_flags(ctx->kaes, crypto_ahash_get_flags(tfm) &
@@ -2176,8 +2179,7 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 		return ret;
 
 	for (i = 0; i < len / sizeof(u32); i++)
-		ctx->ipad[i + 8] =
-			cpu_to_le32((__force u32)cpu_to_be32(aes.key_enc[i]));
+		ctx->base.ipad.word[i + 8] = swab(aes.key_enc[i]);
 
 	/* precompute the CMAC key material */
 	crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
@@ -2208,7 +2210,7 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	/* end of code borrowed from crypto/cmac.c */
 
 	for (i = 0; i < 2 * AES_BLOCK_SIZE / sizeof(u32); i++)
-		ctx->ipad[i] = (__force __le32)cpu_to_be32(((u32 *)consts)[i]);
+		ctx->base.ipad.be[i] = cpu_to_be32(((u32 *)consts)[i]);
 
 	if (len == AES_KEYSIZE_192) {
 		ctx->alg    = CONTEXT_CONTROL_CRYPTO_ALG_XCBC192;
@@ -2330,7 +2332,7 @@ static int safexcel_hmac_sm3_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Start from ipad precompute */
-	memcpy(req->state, ctx->ipad, SM3_DIGEST_SIZE);
+	memcpy(req->state, &ctx->base.ipad, SM3_DIGEST_SIZE);
 	/* Already processed the key^ipad part now! */
 	req->len	= SM3_BLOCK_SIZE;
 	req->processed	= SM3_BLOCK_SIZE;
@@ -2423,11 +2425,11 @@ static int safexcel_sha3_fbcheck(struct ahash_request *req)
 				/* Set fallback cipher HMAC key */
 				u8 key[SHA3_224_BLOCK_SIZE];
 
-				memcpy(key, ctx->ipad,
+				memcpy(key, &ctx->base.ipad,
 				       crypto_ahash_blocksize(ctx->fback) / 2);
 				memcpy(key +
 				       crypto_ahash_blocksize(ctx->fback) / 2,
-				       ctx->opad,
+				       &ctx->base.opad,
 				       crypto_ahash_blocksize(ctx->fback) / 2);
 				ret = crypto_ahash_setkey(ctx->fback, key,
 					crypto_ahash_blocksize(ctx->fback));
@@ -2800,7 +2802,7 @@ static int safexcel_hmac_sha3_setkey(struct crypto_ahash *tfm, const u8 *key,
 		 * first using our fallback cipher
 		 */
 		ret = crypto_shash_digest(ctx->shdesc, key, keylen,
-					  (u8 *)ctx->ipad);
+					  ctx->base.ipad.byte);
 		keylen = crypto_shash_digestsize(ctx->shpre);
 
 		/*
@@ -2809,8 +2811,8 @@ static int safexcel_hmac_sha3_setkey(struct crypto_ahash *tfm, const u8 *key,
 		 */
 		if (keylen > crypto_ahash_blocksize(tfm) / 2)
 			/* Buffers overlap, need to use memmove iso memcpy! */
-			memmove(ctx->opad,
-				(u8 *)ctx->ipad +
+			memmove(&ctx->base.opad,
+				ctx->base.ipad.byte +
 					crypto_ahash_blocksize(tfm) / 2,
 				keylen - crypto_ahash_blocksize(tfm) / 2);
 	} else {
@@ -2820,11 +2822,11 @@ static int safexcel_hmac_sha3_setkey(struct crypto_ahash *tfm, const u8 *key,
 		 * to match the existing HMAC driver infrastructure.
 		 */
 		if (keylen <= crypto_ahash_blocksize(tfm) / 2) {
-			memcpy(ctx->ipad, key, keylen);
+			memcpy(&ctx->base.ipad, key, keylen);
 		} else {
-			memcpy(ctx->ipad, key,
+			memcpy(&ctx->base.ipad, key,
 			       crypto_ahash_blocksize(tfm) / 2);
-			memcpy(ctx->opad,
+			memcpy(&ctx->base.opad,
 			       key + crypto_ahash_blocksize(tfm) / 2,
 			       keylen - crypto_ahash_blocksize(tfm) / 2);
 		}
@@ -2832,11 +2834,11 @@ static int safexcel_hmac_sha3_setkey(struct crypto_ahash *tfm, const u8 *key,
 
 	/* Pad key with zeroes */
 	if (keylen <= crypto_ahash_blocksize(tfm) / 2) {
-		memset((u8 *)ctx->ipad + keylen, 0,
+		memset(ctx->base.ipad.byte + keylen, 0,
 		       crypto_ahash_blocksize(tfm) / 2 - keylen);
-		memset(ctx->opad, 0, crypto_ahash_blocksize(tfm) / 2);
+		memset(&ctx->base.opad, 0, crypto_ahash_blocksize(tfm) / 2);
 	} else {
-		memset((u8 *)ctx->opad + keylen -
+		memset(ctx->base.opad.byte + keylen -
 		       crypto_ahash_blocksize(tfm) / 2, 0,
 		       crypto_ahash_blocksize(tfm) - keylen);
 	}
@@ -2855,7 +2857,7 @@ static int safexcel_hmac_sha3_224_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Copy (half of) the key */
-	memcpy(req->state, ctx->ipad, SHA3_224_BLOCK_SIZE / 2);
+	memcpy(req->state, &ctx->base.ipad, SHA3_224_BLOCK_SIZE / 2);
 	/* Start of HMAC should have len == processed == blocksize */
 	req->len	= SHA3_224_BLOCK_SIZE;
 	req->processed	= SHA3_224_BLOCK_SIZE;
@@ -2926,7 +2928,7 @@ static int safexcel_hmac_sha3_256_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Copy (half of) the key */
-	memcpy(req->state, ctx->ipad, SHA3_256_BLOCK_SIZE / 2);
+	memcpy(req->state, &ctx->base.ipad, SHA3_256_BLOCK_SIZE / 2);
 	/* Start of HMAC should have len == processed == blocksize */
 	req->len	= SHA3_256_BLOCK_SIZE;
 	req->processed	= SHA3_256_BLOCK_SIZE;
@@ -2997,7 +2999,7 @@ static int safexcel_hmac_sha3_384_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Copy (half of) the key */
-	memcpy(req->state, ctx->ipad, SHA3_384_BLOCK_SIZE / 2);
+	memcpy(req->state, &ctx->base.ipad, SHA3_384_BLOCK_SIZE / 2);
 	/* Start of HMAC should have len == processed == blocksize */
 	req->len	= SHA3_384_BLOCK_SIZE;
 	req->processed	= SHA3_384_BLOCK_SIZE;
@@ -3068,7 +3070,7 @@ static int safexcel_hmac_sha3_512_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Copy (half of) the key */
-	memcpy(req->state, ctx->ipad, SHA3_512_BLOCK_SIZE / 2);
+	memcpy(req->state, &ctx->base.ipad, SHA3_512_BLOCK_SIZE / 2);
 	/* Start of HMAC should have len == processed == blocksize */
 	req->len	= SHA3_512_BLOCK_SIZE;
 	req->processed	= SHA3_512_BLOCK_SIZE;
