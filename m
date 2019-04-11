Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7303C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B717E2184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfDKIvY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:24 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41280 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfDKIvX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:23 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQX-0003Sv-Hl
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:21 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQX-0006ow-7P; Thu, 11 Apr 2019 16:51:21 +0800
Subject: [PATCH 23/24] crypto: talitos - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQX-0006ow-7P@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:21 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/talitos.c |  108 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 95 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index de78b54bcfb1..1d429fc073d1 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -913,6 +913,54 @@ static int aead_setkey(struct crypto_aead *authenc,
 	return -EINVAL;
 }
 
+static int aead_des3_setkey(struct crypto_aead *authenc,
+			    const u8 *key, unsigned int keylen)
+{
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	struct device *dev = ctx->dev;
+	struct crypto_authenc_keys keys;
+	u32 flags;
+	int err;
+
+	err = crypto_authenc_extractkeys(&keys, key, keylen);
+	if (unlikely(err))
+		goto badkey;
+
+	err = -EINVAL;
+	if (keys.authkeylen + keys.enckeylen > TALITOS_MAX_KEY_SIZE)
+		goto badkey;
+
+	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
+		goto badkey;
+
+	flags = crypto_aead_get_flags(authenc);
+	err = __des3_verify_key(&flags, keys.enckey);
+	if (unlikely(err)) {
+		crypto_aead_set_flags(authenc, flags);
+		goto out;
+	}
+
+	if (ctx->keylen)
+		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
+
+	memcpy(ctx->key, keys.authkey, keys.authkeylen);
+	memcpy(&ctx->key[keys.authkeylen], keys.enckey, keys.enckeylen);
+
+	ctx->keylen = keys.authkeylen + keys.enckeylen;
+	ctx->enckeylen = keys.enckeylen;
+	ctx->authkeylen = keys.authkeylen;
+	ctx->dma_key = dma_map_single(dev, ctx->key, ctx->keylen,
+				      DMA_TO_DEVICE);
+
+out:
+	memzero_explicit(&keys, sizeof(keys));
+	return err;
+
+badkey:
+	crypto_aead_set_flags(authenc, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	goto out;
+}
+
 /*
  * talitos_edesc - s/w-extended descriptor
  * @src_nents: number of segments in input scatterlist
@@ -1527,12 +1575,22 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 {
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 	struct device *dev = ctx->dev;
-	u32 tmp[DES_EXPKEY_WORDS];
 
-	if (keylen > TALITOS_MAX_KEY_SIZE) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	if (ctx->keylen)
+		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
+
+	memcpy(&ctx->key, key, keylen);
+	ctx->keylen = keylen;
+
+	ctx->dma_key = dma_map_single(dev, ctx->key, keylen, DMA_TO_DEVICE);
+
+	return 0;
+}
+
+static int ablkcipher_des_setkey(struct crypto_ablkcipher *cipher,
+				 const u8 *key, unsigned int keylen)
+{
+	u32 tmp[DES_EXPKEY_WORDS];
 
 	if (unlikely(crypto_ablkcipher_get_flags(cipher) &
 		     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) &&
@@ -1541,15 +1599,23 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 		return -EINVAL;
 	}
 
-	if (ctx->keylen)
-		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
+	return ablkcipher_setkey(cipher, key, keylen);
+}
 
-	memcpy(&ctx->key, key, keylen);
-	ctx->keylen = keylen;
+static int ablkcipher_des3_setkey(struct crypto_ablkcipher *cipher,
+				  const u8 *key, unsigned int keylen)
+{
+	u32 flags;
+	int err;
 
-	ctx->dma_key = dma_map_single(dev, ctx->key, keylen, DMA_TO_DEVICE);
+	flags = crypto_ablkcipher_get_flags(cipher);
+	err = __des3_verify_key(&flags, key);
+	if (unlikely(err)) {
+		crypto_ablkcipher_set_flags(cipher, flags);
+		return err;
+	}
 
-	return 0;
+	return ablkcipher_setkey(cipher, key, keylen);
 }
 
 static void common_nonsnoop_unmap(struct device *dev,
@@ -2313,6 +2379,7 @@ static struct talitos_alg_template driver_algs[] = {
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
@@ -2336,6 +2403,7 @@ static struct talitos_alg_template driver_algs[] = {
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
 				     DESC_HDR_SEL0_DEU |
@@ -2399,6 +2467,7 @@ static struct talitos_alg_template driver_algs[] = {
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
@@ -2422,6 +2491,7 @@ static struct talitos_alg_template driver_algs[] = {
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
 				     DESC_HDR_SEL0_DEU |
@@ -2485,6 +2555,7 @@ static struct talitos_alg_template driver_algs[] = {
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
@@ -2508,6 +2579,7 @@ static struct talitos_alg_template driver_algs[] = {
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
 				     DESC_HDR_SEL0_DEU |
@@ -2550,6 +2622,7 @@ static struct talitos_alg_template driver_algs[] = {
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
@@ -2592,6 +2665,7 @@ static struct talitos_alg_template driver_algs[] = {
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
@@ -2654,6 +2728,7 @@ static struct talitos_alg_template driver_algs[] = {
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
@@ -2676,6 +2751,7 @@ static struct talitos_alg_template driver_algs[] = {
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
 				     DESC_HDR_SEL0_DEU |
@@ -2748,6 +2824,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.min_keysize = DES_KEY_SIZE,
 				.max_keysize = DES_KEY_SIZE,
 				.ivsize = DES_BLOCK_SIZE,
+				.setkey = ablkcipher_des_setkey,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2764,6 +2841,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.min_keysize = DES_KEY_SIZE,
 				.max_keysize = DES_KEY_SIZE,
 				.ivsize = DES_BLOCK_SIZE,
+				.setkey = ablkcipher_des_setkey,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2781,6 +2859,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.min_keysize = DES3_EDE_KEY_SIZE,
 				.max_keysize = DES3_EDE_KEY_SIZE,
 				.ivsize = DES3_EDE_BLOCK_SIZE,
+				.setkey = ablkcipher_des3_setkey,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2798,6 +2877,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.min_keysize = DES3_EDE_KEY_SIZE,
 				.max_keysize = DES3_EDE_KEY_SIZE,
 				.ivsize = DES3_EDE_BLOCK_SIZE,
+				.setkey = ablkcipher_des3_setkey,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -3144,7 +3224,8 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		alg->cra_init = talitos_cra_init;
 		alg->cra_exit = talitos_cra_exit;
 		alg->cra_type = &crypto_ablkcipher_type;
-		alg->cra_ablkcipher.setkey = ablkcipher_setkey;
+		alg->cra_ablkcipher.setkey = alg->cra_ablkcipher.setkey ?:
+					     ablkcipher_setkey;
 		alg->cra_ablkcipher.encrypt = ablkcipher_encrypt;
 		alg->cra_ablkcipher.decrypt = ablkcipher_decrypt;
 		break;
@@ -3152,7 +3233,8 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		alg = &t_alg->algt.alg.aead.base;
 		alg->cra_exit = talitos_cra_exit;
 		t_alg->algt.alg.aead.init = talitos_cra_init_aead;
-		t_alg->algt.alg.aead.setkey = aead_setkey;
+		t_alg->algt.alg.aead.setkey = t_alg->algt.alg.aead.setkey ?:
+					      aead_setkey;
 		t_alg->algt.alg.aead.encrypt = aead_encrypt;
 		t_alg->algt.alg.aead.decrypt = aead_decrypt;
 		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
