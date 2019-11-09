Return-Path: <SRS0=z9QW=ZB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CAB1C43331
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 17:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAD35214E0
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 17:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573319454;
	bh=34nassVodwGVyAJ0sFnZbq9L3mxBBRYCkYQgk0dkgXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OJ7aPBXQUk6LrjGYGAquOOymo5ixZp17M7GBGTP0ELpkjEGMr4hFyaZbcnFpFKB9a
	 Fo0SxE8apa5eBaqfdX77onOHNfbujUj/n7yQMRTz69/hPXUY6wCMbV7+beSvEslV9j
	 uR31J9MEyRMMRa13REfUSOsdmlT7Eki9QIjHqkWk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfKIRKx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 12:10:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfKIRKx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 12:10:53 -0500
Received: from e123331-lin.home (lfbn-mar-1-643-104.w90-118.abo.wanadoo.fr [90.118.215.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A56D21924;
        Sat,  9 Nov 2019 17:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573319451;
        bh=34nassVodwGVyAJ0sFnZbq9L3mxBBRYCkYQgk0dkgXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vb9vuv3RsMZb9B0gcV3vGusdi6lIV23IDI08nOmg0c1sSu7iq34Mk8O2kjXGvUKJl
         YThfcobENOlsNrylKY8cG6baBs/25aFO9N6gDKs8HTX064NxzKa+pTz0m8RQccKEo8
         Yn7OQsSJWMGE2v4CxK5M3yYJMakyxfxGTmScvRvc=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 06/29] crypto: ux500 - switch to skcipher API
Date:   Sat,  9 Nov 2019 18:09:31 +0100
Message-Id: <20191109170954.756-7-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109170954.756-1-ardb@kernel.org>
References: <20191109170954.756-1-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface")
dated 20 august 2015 introduced the new skcipher API which is supposed to
replace both blkcipher and ablkcipher. While all consumers of the API have
been converted long ago, some producers of the ablkcipher remain, forcing
us to keep the ablkcipher support routines alive, along with the matching
code to expose [a]blkciphers via the skcipher API.

So switch this driver to the skcipher API, allowing us to finally drop the
ablkcipher code in the near future.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 371 ++++++++------------
 1 file changed, 156 insertions(+), 215 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 1628ae7a1467..95fb694a2667 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -30,6 +30,7 @@
 #include <crypto/algapi.h>
 #include <crypto/ctr.h>
 #include <crypto/internal/des.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 
 #include <linux/platform_data/crypto-ux500.h>
@@ -828,10 +829,10 @@ static int get_nents(struct scatterlist *sg, int nbytes)
 	return nents;
 }
 
-static int ablk_dma_crypt(struct ablkcipher_request *areq)
+static int ablk_dma_crypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
-	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
+	struct cryp_ctx *ctx = crypto_skcipher_ctx(cipher);
 	struct cryp_device_data *device_data;
 
 	int bytes_written = 0;
@@ -840,8 +841,8 @@ static int ablk_dma_crypt(struct ablkcipher_request *areq)
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
 
-	ctx->datalen = areq->nbytes;
-	ctx->outlen = areq->nbytes;
+	ctx->datalen = areq->cryptlen;
+	ctx->outlen = areq->cryptlen;
 
 	ret = cryp_get_device_data(ctx, &device_data);
 	if (ret)
@@ -885,11 +886,11 @@ static int ablk_dma_crypt(struct ablkcipher_request *areq)
 	return 0;
 }
 
-static int ablk_crypt(struct ablkcipher_request *areq)
+static int ablk_crypt(struct skcipher_request *areq)
 {
-	struct ablkcipher_walk walk;
-	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
-	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct skcipher_walk walk;
+	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
+	struct cryp_ctx *ctx = crypto_skcipher_ctx(cipher);
 	struct cryp_device_data *device_data;
 	unsigned long src_paddr;
 	unsigned long dst_paddr;
@@ -902,21 +903,20 @@ static int ablk_crypt(struct ablkcipher_request *areq)
 	if (ret)
 		goto out;
 
-	ablkcipher_walk_init(&walk, areq->dst, areq->src, areq->nbytes);
-	ret = ablkcipher_walk_phys(areq, &walk);
+	ret = skcipher_walk_async(&walk, areq);
 
 	if (ret) {
-		pr_err(DEV_DBG_NAME "[%s]: ablkcipher_walk_phys() failed!",
+		pr_err(DEV_DBG_NAME "[%s]: skcipher_walk_async() failed!",
 			__func__);
 		goto out;
 	}
 
 	while ((nbytes = walk.nbytes) > 0) {
 		ctx->iv = walk.iv;
-		src_paddr = (page_to_phys(walk.src.page) + walk.src.offset);
+		src_paddr = (page_to_phys(walk.src.phys.page) + walk.src.phys.offset);
 		ctx->indata = phys_to_virt(src_paddr);
 
-		dst_paddr = (page_to_phys(walk.dst.page) + walk.dst.offset);
+		dst_paddr = (page_to_phys(walk.dst.phys.page) + walk.dst.phys.offset);
 		ctx->outdata = phys_to_virt(dst_paddr);
 
 		ctx->datalen = nbytes - (nbytes % ctx->blocksize);
@@ -926,11 +926,10 @@ static int ablk_crypt(struct ablkcipher_request *areq)
 			goto out;
 
 		nbytes -= ctx->datalen;
-		ret = ablkcipher_walk_done(areq, &walk, nbytes);
+		ret = skcipher_walk_done(&walk, nbytes);
 		if (ret)
 			goto out;
 	}
-	ablkcipher_walk_complete(&walk);
 
 out:
 	/* Release the device */
@@ -948,10 +947,10 @@ static int ablk_crypt(struct ablkcipher_request *areq)
 	return ret;
 }
 
-static int aes_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
+static int aes_skcipher_setkey(struct crypto_skcipher *cipher,
 				 const u8 *key, unsigned int keylen)
 {
-	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct cryp_ctx *ctx = crypto_skcipher_ctx(cipher);
 	u32 *flags = &cipher->base.crt_flags;
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
@@ -983,15 +982,15 @@ static int aes_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 	return 0;
 }
 
-static int des_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
+static int des_skcipher_setkey(struct crypto_skcipher *cipher,
 				 const u8 *key, unsigned int keylen)
 {
-	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct cryp_ctx *ctx = crypto_skcipher_ctx(cipher);
 	int err;
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
 
-	err = verify_ablkcipher_des_key(cipher, key);
+	err = verify_skcipher_des_key(cipher, key);
 	if (err)
 		return err;
 
@@ -1002,15 +1001,15 @@ static int des_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 	return 0;
 }
 
-static int des3_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
+static int des3_skcipher_setkey(struct crypto_skcipher *cipher,
 				  const u8 *key, unsigned int keylen)
 {
-	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct cryp_ctx *ctx = crypto_skcipher_ctx(cipher);
 	int err;
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
 
-	err = verify_ablkcipher_des3_key(cipher, key);
+	err = verify_skcipher_des3_key(cipher, key);
 	if (err)
 		return err;
 
@@ -1021,10 +1020,10 @@ static int des3_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 	return 0;
 }
 
-static int cryp_blk_encrypt(struct ablkcipher_request *areq)
+static int cryp_blk_encrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
-	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
+	struct cryp_ctx *ctx = crypto_skcipher_ctx(cipher);
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
 
@@ -1039,10 +1038,10 @@ static int cryp_blk_encrypt(struct ablkcipher_request *areq)
 	return ablk_crypt(areq);
 }
 
-static int cryp_blk_decrypt(struct ablkcipher_request *areq)
+static int cryp_blk_decrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
-	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
+	struct cryp_ctx *ctx = crypto_skcipher_ctx(cipher);
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
 
@@ -1058,19 +1057,19 @@ static int cryp_blk_decrypt(struct ablkcipher_request *areq)
 
 struct cryp_algo_template {
 	enum cryp_algo_mode algomode;
-	struct crypto_alg crypto;
+	struct skcipher_alg skcipher;
 };
 
-static int cryp_cra_init(struct crypto_tfm *tfm)
+static int cryp_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct cryp_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_alg *alg = tfm->__crt_alg;
+	struct cryp_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct cryp_algo_template *cryp_alg = container_of(alg,
 			struct cryp_algo_template,
-			crypto);
+			skcipher);
 
 	ctx->config.algomode = cryp_alg->algomode;
-	ctx->blocksize = crypto_tfm_alg_blocksize(tfm);
+	ctx->blocksize = crypto_skcipher_blocksize(tfm);
 
 	return 0;
 }
@@ -1078,205 +1077,147 @@ static int cryp_cra_init(struct crypto_tfm *tfm)
 static struct cryp_algo_template cryp_algs[] = {
 	{
 		.algomode = CRYP_ALGO_AES_ECB,
-		.crypto = {
-			.cra_name = "aes",
-			.cra_driver_name = "aes-ux500",
-			.cra_priority =	300,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-					CRYPTO_ALG_ASYNC,
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct cryp_ctx),
-			.cra_alignmask = 3,
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_init = cryp_cra_init,
-			.cra_module = THIS_MODULE,
-			.cra_u = {
-				.ablkcipher = {
-					.min_keysize = AES_MIN_KEY_SIZE,
-					.max_keysize = AES_MAX_KEY_SIZE,
-					.setkey = aes_ablkcipher_setkey,
-					.encrypt = cryp_blk_encrypt,
-					.decrypt = cryp_blk_decrypt
-				}
-			}
-		}
-	},
-	{
-		.algomode = CRYP_ALGO_AES_ECB,
-		.crypto = {
-			.cra_name = "ecb(aes)",
-			.cra_driver_name = "ecb-aes-ux500",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-					CRYPTO_ALG_ASYNC,
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct cryp_ctx),
-			.cra_alignmask = 3,
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_init = cryp_cra_init,
-			.cra_module = THIS_MODULE,
-			.cra_u = {
-				.ablkcipher = {
-					.min_keysize = AES_MIN_KEY_SIZE,
-					.max_keysize = AES_MAX_KEY_SIZE,
-					.setkey = aes_ablkcipher_setkey,
-					.encrypt = cryp_blk_encrypt,
-					.decrypt = cryp_blk_decrypt,
-				}
-			}
+		.skcipher = {
+			.base.cra_name		= "ecb(aes)",
+			.base.cra_driver_name	= "ecb-aes-ux500",
+			.base.cra_priority	= 300,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_blocksize	= AES_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
+			.base.cra_alignmask	= 3,
+			.base.cra_module	= THIS_MODULE,
+
+			.min_keysize		= AES_MIN_KEY_SIZE,
+			.max_keysize		= AES_MAX_KEY_SIZE,
+			.setkey			= aes_skcipher_setkey,
+			.encrypt		= cryp_blk_encrypt,
+			.decrypt		= cryp_blk_decrypt,
+			.init			= cryp_init_tfm,
 		}
 	},
 	{
 		.algomode = CRYP_ALGO_AES_CBC,
-		.crypto = {
-			.cra_name = "cbc(aes)",
-			.cra_driver_name = "cbc-aes-ux500",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-					CRYPTO_ALG_ASYNC,
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct cryp_ctx),
-			.cra_alignmask = 3,
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_init = cryp_cra_init,
-			.cra_module = THIS_MODULE,
-			.cra_u = {
-				.ablkcipher = {
-					.min_keysize = AES_MIN_KEY_SIZE,
-					.max_keysize = AES_MAX_KEY_SIZE,
-					.setkey = aes_ablkcipher_setkey,
-					.encrypt = cryp_blk_encrypt,
-					.decrypt = cryp_blk_decrypt,
-					.ivsize = AES_BLOCK_SIZE,
-				}
-			}
+		.skcipher = {
+			.base.cra_name		= "cbc(aes)",
+			.base.cra_driver_name	= "cbc-aes-ux500",
+			.base.cra_priority	= 300,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_blocksize	= AES_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
+			.base.cra_alignmask	= 3,
+			.base.cra_module	= THIS_MODULE,
+
+			.min_keysize		= AES_MIN_KEY_SIZE,
+			.max_keysize		= AES_MAX_KEY_SIZE,
+			.setkey			= aes_skcipher_setkey,
+			.encrypt		= cryp_blk_encrypt,
+			.decrypt		= cryp_blk_decrypt,
+			.init			= cryp_init_tfm,
+			.ivsize			= AES_BLOCK_SIZE,
 		}
 	},
 	{
 		.algomode = CRYP_ALGO_AES_CTR,
-		.crypto = {
-			.cra_name = "ctr(aes)",
-			.cra_driver_name = "ctr-aes-ux500",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-						CRYPTO_ALG_ASYNC,
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct cryp_ctx),
-			.cra_alignmask = 3,
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_init = cryp_cra_init,
-			.cra_module = THIS_MODULE,
-			.cra_u = {
-				.ablkcipher = {
-					.min_keysize = AES_MIN_KEY_SIZE,
-					.max_keysize = AES_MAX_KEY_SIZE,
-					.setkey = aes_ablkcipher_setkey,
-					.encrypt = cryp_blk_encrypt,
-					.decrypt = cryp_blk_decrypt,
-					.ivsize = AES_BLOCK_SIZE,
-				}
-			}
+		.skcipher = {
+			.base.cra_name		= "ctr(aes)",
+			.base.cra_driver_name	= "ctr-aes-ux500",
+			.base.cra_priority	= 300,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_blocksize	= 1,
+			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
+			.base.cra_alignmask	= 3,
+			.base.cra_module	= THIS_MODULE,
+
+			.min_keysize		= AES_MIN_KEY_SIZE,
+			.max_keysize		= AES_MAX_KEY_SIZE,
+			.setkey			= aes_skcipher_setkey,
+			.encrypt		= cryp_blk_encrypt,
+			.decrypt		= cryp_blk_decrypt,
+			.init			= cryp_init_tfm,
+			.ivsize			= AES_BLOCK_SIZE,
+			.chunksize		= AES_BLOCK_SIZE,
 		}
 	},
 	{
 		.algomode = CRYP_ALGO_DES_ECB,
-		.crypto = {
-			.cra_name = "ecb(des)",
-			.cra_driver_name = "ecb-des-ux500",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-					CRYPTO_ALG_ASYNC,
-			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct cryp_ctx),
-			.cra_alignmask = 3,
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_init = cryp_cra_init,
-			.cra_module = THIS_MODULE,
-			.cra_u = {
-				.ablkcipher = {
-					.min_keysize = DES_KEY_SIZE,
-					.max_keysize = DES_KEY_SIZE,
-					.setkey = des_ablkcipher_setkey,
-					.encrypt = cryp_blk_encrypt,
-					.decrypt = cryp_blk_decrypt,
-				}
-			}
+		.skcipher = {
+			.base.cra_name		= "ecb(des)",
+			.base.cra_driver_name	= "ecb-des-ux500",
+			.base.cra_priority	= 300,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_blocksize	= DES_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
+			.base.cra_alignmask	= 3,
+			.base.cra_module	= THIS_MODULE,
+
+			.min_keysize		= DES_KEY_SIZE,
+			.max_keysize		= DES_KEY_SIZE,
+			.setkey			= des_skcipher_setkey,
+			.encrypt		= cryp_blk_encrypt,
+			.decrypt		= cryp_blk_decrypt,
+			.init			= cryp_init_tfm,
 		}
 	},
 	{
 		.algomode = CRYP_ALGO_TDES_ECB,
-		.crypto = {
-			.cra_name = "ecb(des3_ede)",
-			.cra_driver_name = "ecb-des3_ede-ux500",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-					CRYPTO_ALG_ASYNC,
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct cryp_ctx),
-			.cra_alignmask = 3,
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_init = cryp_cra_init,
-			.cra_module = THIS_MODULE,
-			.cra_u = {
-				.ablkcipher = {
-					.min_keysize = DES3_EDE_KEY_SIZE,
-					.max_keysize = DES3_EDE_KEY_SIZE,
-					.setkey = des3_ablkcipher_setkey,
-					.encrypt = cryp_blk_encrypt,
-					.decrypt = cryp_blk_decrypt,
-				}
-			}
+		.skcipher = {
+			.base.cra_name		= "ecb(des3_ede)",
+			.base.cra_driver_name	= "ecb-des3_ede-ux500",
+			.base.cra_priority	= 300,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
+			.base.cra_alignmask	= 3,
+			.base.cra_module	= THIS_MODULE,
+
+			.min_keysize		= DES3_EDE_KEY_SIZE,
+			.max_keysize		= DES3_EDE_KEY_SIZE,
+			.setkey			= des3_skcipher_setkey,
+			.encrypt		= cryp_blk_encrypt,
+			.decrypt		= cryp_blk_decrypt,
+			.init			= cryp_init_tfm,
 		}
 	},
 	{
 		.algomode = CRYP_ALGO_DES_CBC,
-		.crypto = {
-			.cra_name = "cbc(des)",
-			.cra_driver_name = "cbc-des-ux500",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-					CRYPTO_ALG_ASYNC,
-			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct cryp_ctx),
-			.cra_alignmask = 3,
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_init = cryp_cra_init,
-			.cra_module = THIS_MODULE,
-			.cra_u = {
-				.ablkcipher = {
-					.min_keysize = DES_KEY_SIZE,
-					.max_keysize = DES_KEY_SIZE,
-					.setkey = des_ablkcipher_setkey,
-					.encrypt = cryp_blk_encrypt,
-					.decrypt = cryp_blk_decrypt,
-				}
-			}
+		.skcipher = {
+			.base.cra_name		= "cbc(des)",
+			.base.cra_driver_name	= "cbc-des-ux500",
+			.base.cra_priority	= 300,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_blocksize	= DES_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
+			.base.cra_alignmask	= 3,
+			.base.cra_module	= THIS_MODULE,
+
+			.min_keysize		= DES_KEY_SIZE,
+			.max_keysize		= DES_KEY_SIZE,
+			.setkey			= des_skcipher_setkey,
+			.encrypt		= cryp_blk_encrypt,
+			.decrypt		= cryp_blk_decrypt,
+			.ivsize			= DES_BLOCK_SIZE,
+			.init			= cryp_init_tfm,
 		}
 	},
 	{
 		.algomode = CRYP_ALGO_TDES_CBC,
-		.crypto = {
-			.cra_name = "cbc(des3_ede)",
-			.cra_driver_name = "cbc-des3_ede-ux500",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-					CRYPTO_ALG_ASYNC,
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct cryp_ctx),
-			.cra_alignmask = 3,
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_init = cryp_cra_init,
-			.cra_module = THIS_MODULE,
-			.cra_u = {
-				.ablkcipher = {
-					.min_keysize = DES3_EDE_KEY_SIZE,
-					.max_keysize = DES3_EDE_KEY_SIZE,
-					.setkey = des3_ablkcipher_setkey,
-					.encrypt = cryp_blk_encrypt,
-					.decrypt = cryp_blk_decrypt,
-					.ivsize = DES3_EDE_BLOCK_SIZE,
-				}
-			}
+		.skcipher = {
+			.base.cra_name		= "cbc(des3_ede)",
+			.base.cra_driver_name	= "cbc-des3_ede-ux500",
+			.base.cra_priority	= 300,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
+			.base.cra_alignmask	= 3,
+			.base.cra_module	= THIS_MODULE,
+
+			.min_keysize		= DES3_EDE_KEY_SIZE,
+			.max_keysize		= DES3_EDE_KEY_SIZE,
+			.setkey			= des3_skcipher_setkey,
+			.encrypt		= cryp_blk_encrypt,
+			.decrypt		= cryp_blk_decrypt,
+			.ivsize			= DES3_EDE_BLOCK_SIZE,
+			.init			= cryp_init_tfm,
 		}
 	}
 };
@@ -1293,18 +1234,18 @@ static int cryp_algs_register_all(void)
 	pr_debug("[%s]", __func__);
 
 	for (i = 0; i < ARRAY_SIZE(cryp_algs); i++) {
-		ret = crypto_register_alg(&cryp_algs[i].crypto);
+		ret = crypto_register_skcipher(&cryp_algs[i].skcipher);
 		if (ret) {
 			count = i;
 			pr_err("[%s] alg registration failed",
-					cryp_algs[i].crypto.cra_driver_name);
+					cryp_algs[i].skcipher.base.cra_driver_name);
 			goto unreg;
 		}
 	}
 	return 0;
 unreg:
 	for (i = 0; i < count; i++)
-		crypto_unregister_alg(&cryp_algs[i].crypto);
+		crypto_unregister_skcipher(&cryp_algs[i].skcipher);
 	return ret;
 }
 
@@ -1318,7 +1259,7 @@ static void cryp_algs_unregister_all(void)
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
 
 	for (i = 0; i < ARRAY_SIZE(cryp_algs); i++)
-		crypto_unregister_alg(&cryp_algs[i].crypto);
+		crypto_unregister_skcipher(&cryp_algs[i].skcipher);
 }
 
 static int ux500_cryp_probe(struct platform_device *pdev)
-- 
2.17.1

