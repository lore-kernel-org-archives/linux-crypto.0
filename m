From: lee.nipper@gmail.com
Subject: [PATCH][RFC] crypto: talitos - add hmac algorithms
Date: Wed, 28 Apr 2010 05:33:57 -0700 (PDT)
Message-ID: <4bd82b35.064c640a.62c0.4de1@mx.google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59615 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab0D1Md7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Apr 2010 08:33:59 -0400
Received: by mail-gw0-f46.google.com with SMTP id 19so4752758gwj.19
        for <linux-crypto@vger.kernel.org>; Wed, 28 Apr 2010 05:33:58 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the these hmac algorithms to talitos:
    hmac(md5),
    hmac(sha1),
    hmac(sha256),
    hmac(sha384),
    hmac(sha512).
These are all type ahash.

Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
---
Currently on an 8349E, there's a problem with hmac for
any talitos hmac sequence requiring an
intermediate hash context (Pointer DWORD 1);
the result is an incorrect hmac.
An intermediate hash context is required for
something longer than (65536-blocksize), and for other
cases when update/finup/final are used inefficiently.
Interestingly, a normal hash (without hmac) works perfectly
when using an intermediate context.
So, I solicit any hints/help for figuring this out,
since this hmac patch is a bust without this being corrected.

 drivers/crypto/talitos.c |  203 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 203 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 38c2de1..eb31db2 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1850,6 +1850,99 @@ static int ahash_digest(struct ahash_request *areq)
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
+		if (ret)
+			goto badkey;
+
+		keysize = digestsize;
+		memcpy(ctx->key, hash, digestsize);
+	}
+
+	ctx->keylen = keysize;
+
+	return 0;
+
+badkey:
+	crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	return -EINVAL;
+}
+
+
 struct talitos_alg_template {
 	u32 type;
 	union {
@@ -2172,6 +2265,116 @@ static struct talitos_alg_template driver_algs[] = {
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
-- 
1.6.0.4

