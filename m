From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 1/5] crypto: talitos - add hmac algorithms
Date: Wed, 16 Nov 2011 18:19:16 -0600
Message-ID: <20111116181916.e2473c5856b852dea7bcf83f@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Lee Nipper <lee.nipper@gmail.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:16055
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501Ab1KQAU0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Nov 2011 19:20:26 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lee Nipper <lee.nipper@gmail.com>

Add these hmac algorithms to talitos:
    hmac(md5),
    hmac(sha1),
    hmac(sha224),
    hmac(sha256),
    hmac(sha384),
    hmac(sha512).
These are all type ahash.

Signed-off-by: Lee Nipper <lee.nipper@gmail.com>

Fixed up to not register HMAC algorithms on sec2.0 devices.
Rationale (from Lee):

on an 8349E Rev1.1, there's a problem with hmac for any talitos
hmac sequence requiring an intermediate hash context (Pointer
DWORD 1); the result is an incorrect hmac.  An intermediate hash
context is required for something longer than (65536-blocksize),
and for other cases when update/finup/final are used inefficiently.
Interestingly, a normal hash (without hmac) works perfectly
when using an intermediate context.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |  237 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 235 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index dbe76b5..8ce8731 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -157,6 +157,7 @@ struct talitos_private {
 #define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
 #define TALITOS_FTR_HW_AUTH_CHECK 0x00000002
 #define TALITOS_FTR_SHA224_HWINIT 0x00000004
+#define TALITOS_FTR_HMAC_OK 0x00000008
 
 static void to_talitos_ptr(struct talitos_ptr *talitos_ptr, dma_addr_t dma_addr)
 {
@@ -1874,6 +1875,97 @@ static int ahash_digest(struct ahash_request *areq)
 	return ahash_process_req(areq, areq->nbytes);
 }
 
+struct keyhash_result {
+	struct completion completion;
+	int err;
+};
+
+static void keyhash_complete(struct crypto_async_request *req, int err)
+{
+	struct keyhash_result *res = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	res->err = err;
+	complete(&res->completion);
+}
+
+static int keyhash(struct crypto_ahash *tfm, const u8 *key, unsigned int keylen,
+		   u8 *hash)
+{
+	struct talitos_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+
+	struct scatterlist sg[1];
+	struct ahash_request *req;
+	struct keyhash_result hresult;
+	int ret;
+
+	init_completion(&hresult.completion);
+
+	req = ahash_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	/* Keep tfm keylen == 0 during hash of the long key */
+	ctx->keylen = 0;
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   keyhash_complete, &hresult);
+
+	sg_init_one(&sg[0], key, keylen);
+
+	ahash_request_set_crypt(req, sg, hash, keylen);
+	ret = crypto_ahash_digest(req);
+	switch (ret) {
+	case 0:
+		break;
+	case -EINPROGRESS:
+	case -EBUSY:
+		ret = wait_for_completion_interruptible(
+			&hresult.completion);
+		if (!ret)
+			ret = hresult.err;
+		break;
+	default:
+		break;
+	}
+	ahash_request_free(req);
+
+	return ret;
+}
+
+static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
+			unsigned int keylen)
+{
+	struct talitos_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	unsigned int blocksize =
+			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+	unsigned int digestsize = crypto_ahash_digestsize(tfm);
+	unsigned int keysize = keylen;
+	u8 hash[SHA512_DIGEST_SIZE];
+	int ret;
+
+	if (keylen <= blocksize)
+		memcpy(ctx->key, key, keysize);
+	else {
+		/* Must get the hash of the long key */
+		ret = keyhash(tfm, key, keylen, hash);
+
+		if (ret) {
+			crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+			return -EINVAL;
+		}
+
+		keysize = digestsize;
+		memcpy(ctx->key, hash, digestsize);
+	}
+
+	ctx->keylen = keysize;
+
+	return 0;
+}
+
+
 struct talitos_alg_template {
 	u32 type;
 	union {
@@ -2217,6 +2309,138 @@ static struct talitos_alg_template driver_algs[] = {
 				     DESC_HDR_SEL0_MDEUB |
 				     DESC_HDR_MODE0_MDEUB_SHA512,
 	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
+			.setkey = ahash_setkey,
+			.halg.digestsize = MD5_DIGEST_SIZE,
+			.halg.base = {
+				.cra_name = "hmac(md5)",
+				.cra_driver_name = "hmac-md5-talitos",
+				.cra_blocksize = MD5_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					     CRYPTO_ALG_ASYNC,
+				.cra_type = &crypto_ahash_type
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_MD5,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
+			.setkey = ahash_setkey,
+			.halg.digestsize = SHA1_DIGEST_SIZE,
+			.halg.base = {
+				.cra_name = "hmac(sha1)",
+				.cra_driver_name = "hmac-sha1-talitos",
+				.cra_blocksize = SHA1_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					     CRYPTO_ALG_ASYNC,
+				.cra_type = &crypto_ahash_type
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_SHA1,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
+			.setkey = ahash_setkey,
+			.halg.digestsize = SHA224_DIGEST_SIZE,
+			.halg.base = {
+				.cra_name = "hmac(sha224)",
+				.cra_driver_name = "hmac-sha224-talitos",
+				.cra_blocksize = SHA224_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					     CRYPTO_ALG_ASYNC,
+				.cra_type = &crypto_ahash_type
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_SHA224,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
+			.setkey = ahash_setkey,
+			.halg.digestsize = SHA256_DIGEST_SIZE,
+			.halg.base = {
+				.cra_name = "hmac(sha256)",
+				.cra_driver_name = "hmac-sha256-talitos",
+				.cra_blocksize = SHA256_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					     CRYPTO_ALG_ASYNC,
+				.cra_type = &crypto_ahash_type
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_SHA256,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
+			.setkey = ahash_setkey,
+			.halg.digestsize = SHA384_DIGEST_SIZE,
+			.halg.base = {
+				.cra_name = "hmac(sha384)",
+				.cra_driver_name = "hmac-sha384-talitos",
+				.cra_blocksize = SHA384_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					     CRYPTO_ALG_ASYNC,
+				.cra_type = &crypto_ahash_type
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUB |
+				     DESC_HDR_MODE0_MDEUB_SHA384,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
+			.setkey = ahash_setkey,
+			.halg.digestsize = SHA512_DIGEST_SIZE,
+			.halg.base = {
+				.cra_name = "hmac(sha512)",
+				.cra_driver_name = "hmac-sha512-talitos",
+				.cra_blocksize = SHA512_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					     CRYPTO_ALG_ASYNC,
+				.cra_type = &crypto_ahash_type
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUB |
+				     DESC_HDR_MODE0_MDEUB_SHA512,
+	}
 };
 
 struct talitos_crypto_alg {
@@ -2373,8 +2597,12 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	case CRYPTO_ALG_TYPE_AHASH:
 		alg = &t_alg->algt.alg.hash.halg.base;
 		alg->cra_init = talitos_cra_init_ahash;
+		if (!(priv->features & TALITOS_FTR_HMAC_OK) &&
+		    !strncmp(alg->cra_name, "hmac", 4))
+			return ERR_PTR(-ENOTSUPP);
 		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
-		    !strcmp(alg->cra_name, "sha224")) {
+		    (!strcmp(alg->cra_name, "sha224") ||
+		     !strcmp(alg->cra_name, "hmac(sha224)"))) {
 			t_alg->algt.alg.hash.init = ahash_init_sha224_swinit;
 			t_alg->algt.desc_hdr_template =
 					DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2471,7 +2699,8 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	if (of_device_is_compatible(np, "fsl,sec2.1"))
 		priv->features |= TALITOS_FTR_HW_AUTH_CHECK |
-				  TALITOS_FTR_SHA224_HWINIT;
+				  TALITOS_FTR_SHA224_HWINIT |
+				  TALITOS_FTR_HMAC_OK;
 
 	priv->chan = kzalloc(sizeof(struct talitos_channel) *
 			     priv->num_channels, GFP_KERNEL);
@@ -2530,6 +2759,10 @@ static int talitos_probe(struct platform_device *ofdev)
 			t_alg = talitos_alg_alloc(dev, &driver_algs[i]);
 			if (IS_ERR(t_alg)) {
 				err = PTR_ERR(t_alg);
+				if (err == -ENOTSUPP) {
+					kfree(t_alg);
+					continue;
+				}
 				goto err_out;
 			}
 
-- 
1.7.7
