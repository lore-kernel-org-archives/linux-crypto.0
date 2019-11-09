Return-Path: <SRS0=z9QW=ZB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA39EC17440
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 17:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98CEF21D7B
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573319455;
	bh=1l2ShDRcjXZd8K8RysorlwdakSaYZYE/teEvjvaqvVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZPgNRlJZRFoEEbrx+oSmGm/kQWp/DDk29QV1Ojivgo/Q6njXWE/peB9KLoGt2A5g5
	 Ttetp9JJN7WtrwsYmOnpA0UuFdYBucDXTr8VHwj6kUbxnQVQDp+7xSunP4SAvAWHZR
	 5vkYWw9wFg4mDMO+xsl+jdrL8CEShZPcQVQMQybI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfKIRKz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 12:10:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfKIRKz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 12:10:55 -0500
Received: from e123331-lin.home (lfbn-mar-1-643-104.w90-118.abo.wanadoo.fr [90.118.215.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C394121D7E;
        Sat,  9 Nov 2019 17:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573319453;
        bh=1l2ShDRcjXZd8K8RysorlwdakSaYZYE/teEvjvaqvVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/0FFzids7JOO6d0/9a6Pu2Jb0lHFbXYcxHZtw4wKMLH6noK3Ni1OeRLVflZCIB5C
         koW92ZE7lrowzyEaIv5NM9qJOpUcNbtHwZ4rbLk0es6J+2bz5h00xFPODSmBW3HBIz
         LvSEV+/zA3Nn3TPOXv4auvDPRwQuYvxxSpcNQL5k=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 07/29] crypto: s5p - switch to skcipher API
Date:   Sat,  9 Nov 2019 18:09:32 +0100
Message-Id: <20191109170954.756-8-ardb@kernel.org>
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

Reviewed-by: Kamil Konieczny <k.konieczny@samsung.com>
Tested-by: Kamil Konieczny <k.konieczny@samsung.com>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/s5p-sss.c | 187 ++++++++++----------
 1 file changed, 89 insertions(+), 98 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 010f1bb20dad..d66e20a2f54c 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -303,7 +303,7 @@ struct s5p_aes_dev {
 	void __iomem			*aes_ioaddr;
 	int				irq_fc;
 
-	struct ablkcipher_request	*req;
+	struct skcipher_request		*req;
 	struct s5p_aes_ctx		*ctx;
 	struct scatterlist		*sg_src;
 	struct scatterlist		*sg_dst;
@@ -456,7 +456,7 @@ static void s5p_free_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist **sg)
 	if (!*sg)
 		return;
 
-	len = ALIGN(dev->req->nbytes, AES_BLOCK_SIZE);
+	len = ALIGN(dev->req->cryptlen, AES_BLOCK_SIZE);
 	free_pages((unsigned long)sg_virt(*sg), get_order(len));
 
 	kfree(*sg);
@@ -478,27 +478,27 @@ static void s5p_sg_copy_buf(void *buf, struct scatterlist *sg,
 
 static void s5p_sg_done(struct s5p_aes_dev *dev)
 {
-	struct ablkcipher_request *req = dev->req;
-	struct s5p_aes_reqctx *reqctx = ablkcipher_request_ctx(req);
+	struct skcipher_request *req = dev->req;
+	struct s5p_aes_reqctx *reqctx = skcipher_request_ctx(req);
 
 	if (dev->sg_dst_cpy) {
 		dev_dbg(dev->dev,
 			"Copying %d bytes of output data back to original place\n",
-			dev->req->nbytes);
+			dev->req->cryptlen);
 		s5p_sg_copy_buf(sg_virt(dev->sg_dst_cpy), dev->req->dst,
-				dev->req->nbytes, 1);
+				dev->req->cryptlen, 1);
 	}
 	s5p_free_sg_cpy(dev, &dev->sg_src_cpy);
 	s5p_free_sg_cpy(dev, &dev->sg_dst_cpy);
 	if (reqctx->mode & FLAGS_AES_CBC)
-		memcpy_fromio(req->info, dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), AES_BLOCK_SIZE);
+		memcpy_fromio(req->iv, dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), AES_BLOCK_SIZE);
 
 	else if (reqctx->mode & FLAGS_AES_CTR)
-		memcpy_fromio(req->info, dev->aes_ioaddr + SSS_REG_AES_CNT_DATA(0), AES_BLOCK_SIZE);
+		memcpy_fromio(req->iv, dev->aes_ioaddr + SSS_REG_AES_CNT_DATA(0), AES_BLOCK_SIZE);
 }
 
 /* Calls the completion. Cannot be called with dev->lock hold. */
-static void s5p_aes_complete(struct ablkcipher_request *req, int err)
+static void s5p_aes_complete(struct skcipher_request *req, int err)
 {
 	req->base.complete(&req->base, err);
 }
@@ -523,7 +523,7 @@ static int s5p_make_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist *src,
 	if (!*dst)
 		return -ENOMEM;
 
-	len = ALIGN(dev->req->nbytes, AES_BLOCK_SIZE);
+	len = ALIGN(dev->req->cryptlen, AES_BLOCK_SIZE);
 	pages = (void *)__get_free_pages(GFP_ATOMIC, get_order(len));
 	if (!pages) {
 		kfree(*dst);
@@ -531,7 +531,7 @@ static int s5p_make_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist *src,
 		return -ENOMEM;
 	}
 
-	s5p_sg_copy_buf(pages, src, dev->req->nbytes, 0);
+	s5p_sg_copy_buf(pages, src, dev->req->cryptlen, 0);
 
 	sg_init_table(*dst, 1);
 	sg_set_buf(*dst, pages, len);
@@ -660,7 +660,7 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
 	struct s5p_aes_dev *dev = platform_get_drvdata(pdev);
-	struct ablkcipher_request *req;
+	struct skcipher_request *req;
 	int err_dma_tx = 0;
 	int err_dma_rx = 0;
 	int err_dma_hx = 0;
@@ -1870,7 +1870,7 @@ static bool s5p_is_sg_aligned(struct scatterlist *sg)
 }
 
 static int s5p_set_indata_start(struct s5p_aes_dev *dev,
-				struct ablkcipher_request *req)
+				struct skcipher_request *req)
 {
 	struct scatterlist *sg;
 	int err;
@@ -1897,7 +1897,7 @@ static int s5p_set_indata_start(struct s5p_aes_dev *dev,
 }
 
 static int s5p_set_outdata_start(struct s5p_aes_dev *dev,
-				 struct ablkcipher_request *req)
+				 struct skcipher_request *req)
 {
 	struct scatterlist *sg;
 	int err;
@@ -1925,7 +1925,7 @@ static int s5p_set_outdata_start(struct s5p_aes_dev *dev,
 
 static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 {
-	struct ablkcipher_request *req = dev->req;
+	struct skcipher_request *req = dev->req;
 	u32 aes_control;
 	unsigned long flags;
 	int err;
@@ -1938,12 +1938,12 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 
 	if ((mode & FLAGS_AES_MODE_MASK) == FLAGS_AES_CBC) {
 		aes_control |= SSS_AES_CHAIN_MODE_CBC;
-		iv = req->info;
+		iv = req->iv;
 		ctr = NULL;
 	} else if ((mode & FLAGS_AES_MODE_MASK) == FLAGS_AES_CTR) {
 		aes_control |= SSS_AES_CHAIN_MODE_CTR;
 		iv = NULL;
-		ctr = req->info;
+		ctr = req->iv;
 	} else {
 		iv = NULL; /* AES_ECB */
 		ctr = NULL;
@@ -2021,21 +2021,21 @@ static void s5p_tasklet_cb(unsigned long data)
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
 
-	dev->req = ablkcipher_request_cast(async_req);
+	dev->req = skcipher_request_cast(async_req);
 	dev->ctx = crypto_tfm_ctx(dev->req->base.tfm);
-	reqctx   = ablkcipher_request_ctx(dev->req);
+	reqctx   = skcipher_request_ctx(dev->req);
 
 	s5p_aes_crypt_start(dev, reqctx->mode);
 }
 
 static int s5p_aes_handle_req(struct s5p_aes_dev *dev,
-			      struct ablkcipher_request *req)
+			      struct skcipher_request *req)
 {
 	unsigned long flags;
 	int err;
 
 	spin_lock_irqsave(&dev->lock, flags);
-	err = ablkcipher_enqueue_request(&dev->queue, req);
+	err = crypto_enqueue_request(&dev->queue, &req->base);
 	if (dev->busy) {
 		spin_unlock_irqrestore(&dev->lock, flags);
 		return err;
@@ -2049,17 +2049,17 @@ static int s5p_aes_handle_req(struct s5p_aes_dev *dev,
 	return err;
 }
 
-static int s5p_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
+static int s5p_aes_crypt(struct skcipher_request *req, unsigned long mode)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct s5p_aes_reqctx *reqctx = ablkcipher_request_ctx(req);
-	struct s5p_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct s5p_aes_reqctx *reqctx = skcipher_request_ctx(req);
+	struct s5p_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct s5p_aes_dev *dev = ctx->dev;
 
-	if (!req->nbytes)
+	if (!req->cryptlen)
 		return 0;
 
-	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE) &&
+	if (!IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE) &&
 			((mode & FLAGS_AES_MODE_MASK) != FLAGS_AES_CTR)) {
 		dev_dbg(dev->dev, "request size is not exact amount of AES blocks\n");
 		return -EINVAL;
@@ -2070,10 +2070,10 @@ static int s5p_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 	return s5p_aes_handle_req(dev, req);
 }
 
-static int s5p_aes_setkey(struct crypto_ablkcipher *cipher,
+static int s5p_aes_setkey(struct crypto_skcipher *cipher,
 			  const u8 *key, unsigned int keylen)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
 	struct s5p_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (keylen != AES_KEYSIZE_128 &&
@@ -2087,106 +2087,97 @@ static int s5p_aes_setkey(struct crypto_ablkcipher *cipher,
 	return 0;
 }
 
-static int s5p_aes_ecb_encrypt(struct ablkcipher_request *req)
+static int s5p_aes_ecb_encrypt(struct skcipher_request *req)
 {
 	return s5p_aes_crypt(req, 0);
 }
 
-static int s5p_aes_ecb_decrypt(struct ablkcipher_request *req)
+static int s5p_aes_ecb_decrypt(struct skcipher_request *req)
 {
 	return s5p_aes_crypt(req, FLAGS_AES_DECRYPT);
 }
 
-static int s5p_aes_cbc_encrypt(struct ablkcipher_request *req)
+static int s5p_aes_cbc_encrypt(struct skcipher_request *req)
 {
 	return s5p_aes_crypt(req, FLAGS_AES_CBC);
 }
 
-static int s5p_aes_cbc_decrypt(struct ablkcipher_request *req)
+static int s5p_aes_cbc_decrypt(struct skcipher_request *req)
 {
 	return s5p_aes_crypt(req, FLAGS_AES_DECRYPT | FLAGS_AES_CBC);
 }
 
-static int s5p_aes_ctr_crypt(struct ablkcipher_request *req)
+static int s5p_aes_ctr_crypt(struct skcipher_request *req)
 {
 	return s5p_aes_crypt(req, FLAGS_AES_CTR);
 }
 
-static int s5p_aes_cra_init(struct crypto_tfm *tfm)
+static int s5p_aes_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct s5p_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct s5p_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	ctx->dev = s5p_dev;
-	tfm->crt_ablkcipher.reqsize = sizeof(struct s5p_aes_reqctx);
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct s5p_aes_reqctx));
 
 	return 0;
 }
 
-static struct crypto_alg algs[] = {
+static struct skcipher_alg algs[] = {
 	{
-		.cra_name		= "ecb(aes)",
-		.cra_driver_name	= "ecb-aes-s5p",
-		.cra_priority		= 100,
-		.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
-					  CRYPTO_ALG_ASYNC |
+		.base.cra_name		= "ecb(aes)",
+		.base.cra_driver_name	= "ecb-aes-s5p",
+		.base.cra_priority	= 100,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY,
-		.cra_blocksize		= AES_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct s5p_aes_ctx),
-		.cra_alignmask		= 0x0f,
-		.cra_type		= &crypto_ablkcipher_type,
-		.cra_module		= THIS_MODULE,
-		.cra_init		= s5p_aes_cra_init,
-		.cra_u.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.setkey		= s5p_aes_setkey,
-			.encrypt	= s5p_aes_ecb_encrypt,
-			.decrypt	= s5p_aes_ecb_decrypt,
-		}
+		.base.cra_blocksize	= AES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct s5p_aes_ctx),
+		.base.cra_alignmask	= 0x0f,
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= AES_MIN_KEY_SIZE,
+		.max_keysize		= AES_MAX_KEY_SIZE,
+		.setkey			= s5p_aes_setkey,
+		.encrypt		= s5p_aes_ecb_encrypt,
+		.decrypt		= s5p_aes_ecb_decrypt,
+		.init			= s5p_aes_init_tfm,
 	},
 	{
-		.cra_name		= "cbc(aes)",
-		.cra_driver_name	= "cbc-aes-s5p",
-		.cra_priority		= 100,
-		.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
-					  CRYPTO_ALG_ASYNC |
+		.base.cra_name		= "cbc(aes)",
+		.base.cra_driver_name	= "cbc-aes-s5p",
+		.base.cra_priority	= 100,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY,
-		.cra_blocksize		= AES_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct s5p_aes_ctx),
-		.cra_alignmask		= 0x0f,
-		.cra_type		= &crypto_ablkcipher_type,
-		.cra_module		= THIS_MODULE,
-		.cra_init		= s5p_aes_cra_init,
-		.cra_u.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= s5p_aes_setkey,
-			.encrypt	= s5p_aes_cbc_encrypt,
-			.decrypt	= s5p_aes_cbc_decrypt,
-		}
+		.base.cra_blocksize	= AES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct s5p_aes_ctx),
+		.base.cra_alignmask	= 0x0f,
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= AES_MIN_KEY_SIZE,
+		.max_keysize		= AES_MAX_KEY_SIZE,
+		.ivsize			= AES_BLOCK_SIZE,
+		.setkey			= s5p_aes_setkey,
+		.encrypt		= s5p_aes_cbc_encrypt,
+		.decrypt		= s5p_aes_cbc_decrypt,
+		.init			= s5p_aes_init_tfm,
 	},
 	{
-		.cra_name		= "ctr(aes)",
-		.cra_driver_name	= "ctr-aes-s5p",
-		.cra_priority		= 100,
-		.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
-					  CRYPTO_ALG_ASYNC |
+		.base.cra_name		= "ctr(aes)",
+		.base.cra_driver_name	= "ctr-aes-s5p",
+		.base.cra_priority	= 100,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY,
-		.cra_blocksize		= 1,
-		.cra_ctxsize		= sizeof(struct s5p_aes_ctx),
-		.cra_alignmask		= 0x0f,
-		.cra_type		= &crypto_ablkcipher_type,
-		.cra_module		= THIS_MODULE,
-		.cra_init		= s5p_aes_cra_init,
-		.cra_u.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= s5p_aes_setkey,
-			.encrypt	= s5p_aes_ctr_crypt,
-			.decrypt	= s5p_aes_ctr_crypt,
-		}
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct s5p_aes_ctx),
+		.base.cra_alignmask	= 0x0f,
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= AES_MIN_KEY_SIZE,
+		.max_keysize		= AES_MAX_KEY_SIZE,
+		.ivsize			= AES_BLOCK_SIZE,
+		.setkey			= s5p_aes_setkey,
+		.encrypt		= s5p_aes_ctr_crypt,
+		.decrypt		= s5p_aes_ctr_crypt,
+		.init			= s5p_aes_init_tfm,
 	},
 };
 
@@ -2297,7 +2288,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	crypto_init_queue(&pdata->queue, CRYPTO_QUEUE_LEN);
 
 	for (i = 0; i < ARRAY_SIZE(algs); i++) {
-		err = crypto_register_alg(&algs[i]);
+		err = crypto_register_skcipher(&algs[i]);
 		if (err)
 			goto err_algs;
 	}
@@ -2334,11 +2325,11 @@ static int s5p_aes_probe(struct platform_device *pdev)
 
 err_algs:
 	if (i < ARRAY_SIZE(algs))
-		dev_err(dev, "can't register '%s': %d\n", algs[i].cra_name,
+		dev_err(dev, "can't register '%s': %d\n", algs[i].base.cra_name,
 			err);
 
 	for (j = 0; j < i; j++)
-		crypto_unregister_alg(&algs[j]);
+		crypto_unregister_skcipher(&algs[j]);
 
 	tasklet_kill(&pdata->tasklet);
 
@@ -2362,7 +2353,7 @@ static int s5p_aes_remove(struct platform_device *pdev)
 		return -ENODEV;
 
 	for (i = 0; i < ARRAY_SIZE(algs); i++)
-		crypto_unregister_alg(&algs[i]);
+		crypto_unregister_skcipher(&algs[i]);
 
 	tasklet_kill(&pdata->tasklet);
 	if (pdata->use_hash) {
-- 
2.17.1

