Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB44C17461
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 13:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 892CD2190F
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572960558;
	bh=R0LGAS5VEoqUEPzD9v2It66swn4xhRl9MFbN5usMX2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gre39ZcDDtlUWFI2fFzeEX50fsp1qiQlaVHR97Zx1ZUOiCsgkgsi1B2qsto1Sk4Jq
	 rTpvNzhHu7p4Dtjt1rNJoqU2H53e6E6YRpjl0Y2NfyTtdEyxwwqJMJmw73H75brv8H
	 g8RS9lGS2iQRvp3leXWkOSgELeSn6E78w22Qa7Sw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389098AbfKEN3S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 08:29:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389116AbfKEN3R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 08:29:17 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2967E21882;
        Tue,  5 Nov 2019 13:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572960556;
        bh=R0LGAS5VEoqUEPzD9v2It66swn4xhRl9MFbN5usMX2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rua1N0Y1JHwqaJqFyAhEGis6OFQ2UO89TJDqBRwNXBqcI4zGMUj+4e4Y3EAEKFD3c
         683AhS774y++k6y1U2ZGkjMPyAnCYGT9UrOoD4kl+0wwudBIUC9appkz7S4SSWLMZx
         PI6ubIhvXj774MfzHhnDIl+VlgPrDCvcwNpI5VS0=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 18/29] crypto: sahara - switch to skcipher API
Date:   Tue,  5 Nov 2019 14:28:15 +0100
Message-Id: <20191105132826.1838-19-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105132826.1838-1-ardb@kernel.org>
References: <20191105132826.1838-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
blkcipher code in the near future.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/sahara.c | 156 ++++++++++----------
 1 file changed, 75 insertions(+), 81 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 8ac8ec6decd5..d4ea2f11ca68 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -547,7 +547,7 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	return -EINVAL;
 }
 
-static int sahara_aes_process(struct ablkcipher_request *req)
+static int sahara_aes_process(struct skcipher_request *req)
 {
 	struct sahara_dev *dev = dev_ptr;
 	struct sahara_ctx *ctx;
@@ -558,20 +558,20 @@ static int sahara_aes_process(struct ablkcipher_request *req)
 	/* Request is ready to be dispatched by the device */
 	dev_dbg(dev->device,
 		"dispatch request (nbytes=%d, src=%p, dst=%p)\n",
-		req->nbytes, req->src, req->dst);
+		req->cryptlen, req->src, req->dst);
 
 	/* assign new request to device */
-	dev->total = req->nbytes;
+	dev->total = req->cryptlen;
 	dev->in_sg = req->src;
 	dev->out_sg = req->dst;
 
-	rctx = ablkcipher_request_ctx(req);
-	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
+	rctx = skcipher_request_ctx(req);
+	ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
 	rctx->mode &= FLAGS_MODE_MASK;
 	dev->flags = (dev->flags & ~FLAGS_MODE_MASK) | rctx->mode;
 
-	if ((dev->flags & FLAGS_CBC) && req->info)
-		memcpy(dev->iv_base, req->info, AES_KEYSIZE_128);
+	if ((dev->flags & FLAGS_CBC) && req->iv)
+		memcpy(dev->iv_base, req->iv, AES_KEYSIZE_128);
 
 	/* assign new context to device */
 	dev->ctx = ctx;
@@ -597,10 +597,10 @@ static int sahara_aes_process(struct ablkcipher_request *req)
 	return 0;
 }
 
-static int sahara_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+static int sahara_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			     unsigned int keylen)
 {
-	struct sahara_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct sahara_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int ret;
 
 	ctx->keylen = keylen;
@@ -630,16 +630,16 @@ static int sahara_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	return ret;
 }
 
-static int sahara_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
+static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 {
-	struct sahara_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
 	struct sahara_dev *dev = dev_ptr;
 	int err = 0;
 
 	dev_dbg(dev->device, "nbytes: %d, enc: %d, cbc: %d\n",
-		req->nbytes, !!(mode & FLAGS_ENCRYPT), !!(mode & FLAGS_CBC));
+		req->cryptlen, !!(mode & FLAGS_ENCRYPT), !!(mode & FLAGS_CBC));
 
-	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE)) {
+	if (!IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE)) {
 		dev_err(dev->device,
 			"request size is not exact amount of AES blocks\n");
 		return -EINVAL;
@@ -648,7 +648,7 @@ static int sahara_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 	rctx->mode = mode;
 
 	mutex_lock(&dev->queue_mutex);
-	err = ablkcipher_enqueue_request(&dev->queue, req);
+	err = crypto_enqueue_request(&dev->queue, &req->base);
 	mutex_unlock(&dev->queue_mutex);
 
 	wake_up_process(dev->kthread);
@@ -656,10 +656,10 @@ static int sahara_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 	return err;
 }
 
-static int sahara_aes_ecb_encrypt(struct ablkcipher_request *req)
+static int sahara_aes_ecb_encrypt(struct skcipher_request *req)
 {
-	struct sahara_ctx *ctx = crypto_ablkcipher_ctx(
-		crypto_ablkcipher_reqtfm(req));
+	struct sahara_ctx *ctx = crypto_skcipher_ctx(
+		crypto_skcipher_reqtfm(req));
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
@@ -669,7 +669,7 @@ static int sahara_aes_ecb_encrypt(struct ablkcipher_request *req)
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
-					   req->nbytes, req->info);
+					   req->cryptlen, req->iv);
 		err = crypto_skcipher_encrypt(subreq);
 		skcipher_request_zero(subreq);
 		return err;
@@ -678,10 +678,10 @@ static int sahara_aes_ecb_encrypt(struct ablkcipher_request *req)
 	return sahara_aes_crypt(req, FLAGS_ENCRYPT);
 }
 
-static int sahara_aes_ecb_decrypt(struct ablkcipher_request *req)
+static int sahara_aes_ecb_decrypt(struct skcipher_request *req)
 {
-	struct sahara_ctx *ctx = crypto_ablkcipher_ctx(
-		crypto_ablkcipher_reqtfm(req));
+	struct sahara_ctx *ctx = crypto_skcipher_ctx(
+		crypto_skcipher_reqtfm(req));
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
@@ -691,7 +691,7 @@ static int sahara_aes_ecb_decrypt(struct ablkcipher_request *req)
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
-					   req->nbytes, req->info);
+					   req->cryptlen, req->iv);
 		err = crypto_skcipher_decrypt(subreq);
 		skcipher_request_zero(subreq);
 		return err;
@@ -700,10 +700,10 @@ static int sahara_aes_ecb_decrypt(struct ablkcipher_request *req)
 	return sahara_aes_crypt(req, 0);
 }
 
-static int sahara_aes_cbc_encrypt(struct ablkcipher_request *req)
+static int sahara_aes_cbc_encrypt(struct skcipher_request *req)
 {
-	struct sahara_ctx *ctx = crypto_ablkcipher_ctx(
-		crypto_ablkcipher_reqtfm(req));
+	struct sahara_ctx *ctx = crypto_skcipher_ctx(
+		crypto_skcipher_reqtfm(req));
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
@@ -713,7 +713,7 @@ static int sahara_aes_cbc_encrypt(struct ablkcipher_request *req)
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
-					   req->nbytes, req->info);
+					   req->cryptlen, req->iv);
 		err = crypto_skcipher_encrypt(subreq);
 		skcipher_request_zero(subreq);
 		return err;
@@ -722,10 +722,10 @@ static int sahara_aes_cbc_encrypt(struct ablkcipher_request *req)
 	return sahara_aes_crypt(req, FLAGS_ENCRYPT | FLAGS_CBC);
 }
 
-static int sahara_aes_cbc_decrypt(struct ablkcipher_request *req)
+static int sahara_aes_cbc_decrypt(struct skcipher_request *req)
 {
-	struct sahara_ctx *ctx = crypto_ablkcipher_ctx(
-		crypto_ablkcipher_reqtfm(req));
+	struct sahara_ctx *ctx = crypto_skcipher_ctx(
+		crypto_skcipher_reqtfm(req));
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
@@ -735,7 +735,7 @@ static int sahara_aes_cbc_decrypt(struct ablkcipher_request *req)
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
-					   req->nbytes, req->info);
+					   req->cryptlen, req->iv);
 		err = crypto_skcipher_decrypt(subreq);
 		skcipher_request_zero(subreq);
 		return err;
@@ -744,10 +744,10 @@ static int sahara_aes_cbc_decrypt(struct ablkcipher_request *req)
 	return sahara_aes_crypt(req, FLAGS_CBC);
 }
 
-static int sahara_aes_cra_init(struct crypto_tfm *tfm)
+static int sahara_aes_init_tfm(struct crypto_skcipher *tfm)
 {
-	const char *name = crypto_tfm_alg_name(tfm);
-	struct sahara_ctx *ctx = crypto_tfm_ctx(tfm);
+	const char *name = crypto_tfm_alg_name(&tfm->base);
+	struct sahara_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	ctx->fallback = crypto_alloc_sync_skcipher(name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
@@ -756,14 +756,14 @@ static int sahara_aes_cra_init(struct crypto_tfm *tfm)
 		return PTR_ERR(ctx->fallback);
 	}
 
-	tfm->crt_ablkcipher.reqsize = sizeof(struct sahara_aes_reqctx);
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct sahara_aes_reqctx));
 
 	return 0;
 }
 
-static void sahara_aes_cra_exit(struct crypto_tfm *tfm)
+static void sahara_aes_exit_tfm(struct crypto_skcipher *tfm)
 {
-	struct sahara_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct sahara_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_sync_skcipher(ctx->fallback);
 }
@@ -1071,8 +1071,8 @@ static int sahara_queue_manage(void *data)
 
 				ret = sahara_sha_process(req);
 			} else {
-				struct ablkcipher_request *req =
-					ablkcipher_request_cast(async_req);
+				struct skcipher_request *req =
+					skcipher_request_cast(async_req);
 
 				ret = sahara_aes_process(req);
 			}
@@ -1189,48 +1189,42 @@ static int sahara_sha_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static struct crypto_alg aes_algs[] = {
+static struct skcipher_alg aes_algs[] = {
 {
-	.cra_name		= "ecb(aes)",
-	.cra_driver_name	= "sahara-ecb-aes",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct sahara_ctx),
-	.cra_alignmask		= 0x0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= sahara_aes_cra_init,
-	.cra_exit		= sahara_aes_cra_exit,
-	.cra_u.ablkcipher = {
-		.min_keysize	= AES_MIN_KEY_SIZE ,
-		.max_keysize	= AES_MAX_KEY_SIZE,
-		.setkey		= sahara_aes_setkey,
-		.encrypt	= sahara_aes_ecb_encrypt,
-		.decrypt	= sahara_aes_ecb_decrypt,
-	}
+	.base.cra_name		= "ecb(aes)",
+	.base.cra_driver_name	= "sahara-ecb-aes",
+	.base.cra_priority	= 300,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct sahara_ctx),
+	.base.cra_alignmask	= 0x0,
+	.base.cra_module	= THIS_MODULE,
+
+	.init			= sahara_aes_init_tfm,
+	.exit			= sahara_aes_exit_tfm,
+	.min_keysize		= AES_MIN_KEY_SIZE ,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.setkey			= sahara_aes_setkey,
+	.encrypt		= sahara_aes_ecb_encrypt,
+	.decrypt		= sahara_aes_ecb_decrypt,
 }, {
-	.cra_name		= "cbc(aes)",
-	.cra_driver_name	= "sahara-cbc-aes",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct sahara_ctx),
-	.cra_alignmask		= 0x0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= sahara_aes_cra_init,
-	.cra_exit		= sahara_aes_cra_exit,
-	.cra_u.ablkcipher = {
-		.min_keysize	= AES_MIN_KEY_SIZE ,
-		.max_keysize	= AES_MAX_KEY_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
-		.setkey		= sahara_aes_setkey,
-		.encrypt	= sahara_aes_cbc_encrypt,
-		.decrypt	= sahara_aes_cbc_decrypt,
-	}
+	.base.cra_name		= "cbc(aes)",
+	.base.cra_driver_name	= "sahara-cbc-aes",
+	.base.cra_priority	= 300,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct sahara_ctx),
+	.base.cra_alignmask	= 0x0,
+	.base.cra_module	= THIS_MODULE,
+
+	.init			= sahara_aes_init_tfm,
+	.exit			= sahara_aes_exit_tfm,
+	.min_keysize		= AES_MIN_KEY_SIZE ,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.ivsize			= AES_BLOCK_SIZE,
+	.setkey			= sahara_aes_setkey,
+	.encrypt		= sahara_aes_cbc_encrypt,
+	.decrypt		= sahara_aes_cbc_decrypt,
 }
 };
 
@@ -1318,7 +1312,7 @@ static int sahara_register_algs(struct sahara_dev *dev)
 	unsigned int i, j, k, l;
 
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
-		err = crypto_register_alg(&aes_algs[i]);
+		err = crypto_register_skcipher(&aes_algs[i]);
 		if (err)
 			goto err_aes_algs;
 	}
@@ -1348,7 +1342,7 @@ static int sahara_register_algs(struct sahara_dev *dev)
 
 err_aes_algs:
 	for (j = 0; j < i; j++)
-		crypto_unregister_alg(&aes_algs[j]);
+		crypto_unregister_skcipher(&aes_algs[j]);
 
 	return err;
 }
@@ -1358,7 +1352,7 @@ static void sahara_unregister_algs(struct sahara_dev *dev)
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++)
-		crypto_unregister_alg(&aes_algs[i]);
+		crypto_unregister_skcipher(&aes_algs[i]);
 
 	for (i = 0; i < ARRAY_SIZE(sha_v3_algs); i++)
 		crypto_unregister_ahash(&sha_v3_algs[i]);
-- 
2.20.1

