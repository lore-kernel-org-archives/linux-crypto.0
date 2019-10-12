Return-Path: <SRS0=sxdd=YF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9044ECE587
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 20:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A97AD21850
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 20:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570911616;
	bh=MLDWHl57yKmt5GFjcZ6ni6gw59uMizTd+U8Law8MkCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=U2cfKJgVu8dZMQx+AHKhfMoO5PJ3SuSX1zCzCtOYrKRHamuefeOLGT1pFuQ477aZn
	 F8DMhM1cAAa45TLqShQ92ShMd+Ly8DKu1zLCer7yBi8h0/V86qhsIQkXAOTWw4B5o5
	 NPUZlJSPLd9MKl9bUyBbofbHAX+T/XGDCGC/8sLQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfJLUUQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 16:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729432AbfJLUUQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 16:20:16 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49BBB2089C;
        Sat, 12 Oct 2019 20:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570911612;
        bh=MLDWHl57yKmt5GFjcZ6ni6gw59uMizTd+U8Law8MkCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYsCYcIMqGVTNfDos07A5VE2/Jt/yRCE6yIlzd2Iv36XmLqZP8OYlQdLE2dMavXan
         61ASZro3a+u8Qeq1hAXOBQ9llCYQE6xFxpHNOcxz1iUKMVG0m3B6q/M6ryPSkwEapI
         1Ai1kJAuAHzCXewL7p8CKrb5pPSMo9BUHPygq0+A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-s390@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>
Subject: [RFT PATCH 1/3] crypto: s390/aes - convert to skcipher API
Date:   Sat, 12 Oct 2019 13:18:07 -0700
Message-Id: <20191012201809.160500-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191012201809.160500-1-ebiggers@kernel.org>
References: <20191012201809.160500-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert the glue code for the S390 CPACF implementations of AES-ECB,
AES-CBC, AES-XTS, and AES-CTR from the deprecated "blkcipher" API to the
"skcipher" API.  This is needed in order for the blkcipher API to be
removed.

Note: I made CTR use the same function for encryption and decryption,
since CTR encryption and decryption are identical.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/s390/crypto/aes_s390.c | 609 ++++++++++++++----------------------
 1 file changed, 234 insertions(+), 375 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 9803e96d2924..ead0b2c9881d 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -44,7 +44,7 @@ struct s390_aes_ctx {
 	int key_len;
 	unsigned long fc;
 	union {
-		struct crypto_sync_skcipher *blk;
+		struct crypto_skcipher *skcipher;
 		struct crypto_cipher *cip;
 	} fallback;
 };
@@ -54,7 +54,7 @@ struct s390_xts_ctx {
 	u8 pcc_key[32];
 	int key_len;
 	unsigned long fc;
-	struct crypto_sync_skcipher *fallback;
+	struct crypto_skcipher *fallback;
 };
 
 struct gcm_sg_walk {
@@ -178,66 +178,41 @@ static struct crypto_alg aes_alg = {
 	}
 };
 
-static int setkey_fallback_blk(struct crypto_tfm *tfm, const u8 *key,
-		unsigned int len)
+static int setkey_fallback_skcipher(struct crypto_skcipher *tfm, const u8 *key,
+				    unsigned int len)
 {
-	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
-	unsigned int ret;
-
-	crypto_sync_skcipher_clear_flags(sctx->fallback.blk,
-					 CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(sctx->fallback.blk, tfm->crt_flags &
-						      CRYPTO_TFM_REQ_MASK);
-
-	ret = crypto_sync_skcipher_setkey(sctx->fallback.blk, key, len);
-
-	tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-	tfm->crt_flags |= crypto_sync_skcipher_get_flags(sctx->fallback.blk) &
-			  CRYPTO_TFM_RES_MASK;
-
-	return ret;
-}
-
-static int fallback_blk_dec(struct blkcipher_desc *desc,
-		struct scatterlist *dst, struct scatterlist *src,
-		unsigned int nbytes)
-{
-	unsigned int ret;
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(tfm);
-	SYNC_SKCIPHER_REQUEST_ON_STACK(req, sctx->fallback.blk);
-
-	skcipher_request_set_sync_tfm(req, sctx->fallback.blk);
-	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
-	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
-
-	ret = crypto_skcipher_decrypt(req);
+	struct s390_aes_ctx *sctx = crypto_skcipher_ctx(tfm);
+	int ret;
 
-	skcipher_request_zero(req);
+	crypto_skcipher_clear_flags(sctx->fallback.skcipher,
+				    CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(sctx->fallback.skcipher,
+				  crypto_skcipher_get_flags(tfm) &
+				  CRYPTO_TFM_REQ_MASK);
+	ret = crypto_skcipher_setkey(sctx->fallback.skcipher, key, len);
+	crypto_skcipher_set_flags(tfm,
+				  crypto_skcipher_get_flags(sctx->fallback.skcipher) &
+				  CRYPTO_TFM_RES_MASK);
 	return ret;
 }
 
-static int fallback_blk_enc(struct blkcipher_desc *desc,
-		struct scatterlist *dst, struct scatterlist *src,
-		unsigned int nbytes)
+static int fallback_skcipher_crypt(struct s390_aes_ctx *sctx,
+				   struct skcipher_request *req,
+				   unsigned long modifier)
 {
-	unsigned int ret;
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(tfm);
-	SYNC_SKCIPHER_REQUEST_ON_STACK(req, sctx->fallback.blk);
-
-	skcipher_request_set_sync_tfm(req, sctx->fallback.blk);
-	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
-	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
+	struct skcipher_request *subreq = skcipher_request_ctx(req);
 
-	ret = crypto_skcipher_encrypt(req);
-	return ret;
+	*subreq = *req;
+	skcipher_request_set_tfm(subreq, sctx->fallback.skcipher);
+	return (modifier & CPACF_DECRYPT) ?
+		crypto_skcipher_decrypt(subreq) :
+		crypto_skcipher_encrypt(subreq);
 }
 
-static int ecb_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+static int ecb_aes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 			   unsigned int key_len)
 {
-	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct s390_aes_ctx *sctx = crypto_skcipher_ctx(tfm);
 	unsigned long fc;
 
 	/* Pick the correct function code based on the key length */
@@ -248,111 +223,92 @@ static int ecb_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	/* Check if the function code is available */
 	sctx->fc = (fc && cpacf_test_func(&km_functions, fc)) ? fc : 0;
 	if (!sctx->fc)
-		return setkey_fallback_blk(tfm, in_key, key_len);
+		return setkey_fallback_skcipher(tfm, in_key, key_len);
 
 	sctx->key_len = key_len;
 	memcpy(sctx->key, in_key, key_len);
 	return 0;
 }
 
-static int ecb_aes_crypt(struct blkcipher_desc *desc, unsigned long modifier,
-			 struct blkcipher_walk *walk)
+static int ecb_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 {
-	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct s390_aes_ctx *sctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
 	unsigned int nbytes, n;
 	int ret;
 
-	ret = blkcipher_walk_virt(desc, walk);
-	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
+	if (unlikely(!sctx->fc))
+		return fallback_skcipher_crypt(sctx, req, modifier);
+
+	ret = skcipher_walk_virt(&walk, req, false);
+	while ((nbytes = walk.nbytes) != 0) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_km(sctx->fc | modifier, sctx->key,
-			 walk->dst.virt.addr, walk->src.virt.addr, n);
-		ret = blkcipher_walk_done(desc, walk, nbytes - n);
+			 walk.dst.virt.addr, walk.src.virt.addr, n);
+		ret = skcipher_walk_done(&walk, nbytes - n);
 	}
-
 	return ret;
 }
 
-static int ecb_aes_encrypt(struct blkcipher_desc *desc,
-			   struct scatterlist *dst, struct scatterlist *src,
-			   unsigned int nbytes)
+static int ecb_aes_encrypt(struct skcipher_request *req)
 {
-	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-
-	if (unlikely(!sctx->fc))
-		return fallback_blk_enc(desc, dst, src, nbytes);
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_aes_crypt(desc, 0, &walk);
+	return ecb_aes_crypt(req, 0);
 }
 
-static int ecb_aes_decrypt(struct blkcipher_desc *desc,
-			   struct scatterlist *dst, struct scatterlist *src,
-			   unsigned int nbytes)
+static int ecb_aes_decrypt(struct skcipher_request *req)
 {
-	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-
-	if (unlikely(!sctx->fc))
-		return fallback_blk_dec(desc, dst, src, nbytes);
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_aes_crypt(desc, CPACF_DECRYPT, &walk);
+	return ecb_aes_crypt(req, CPACF_DECRYPT);
 }
 
-static int fallback_init_blk(struct crypto_tfm *tfm)
+static int fallback_init_skcipher(struct crypto_skcipher *tfm)
 {
-	const char *name = tfm->__crt_alg->cra_name;
-	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+	const char *name = crypto_tfm_alg_name(&tfm->base);
+	struct s390_aes_ctx *sctx = crypto_skcipher_ctx(tfm);
 
-	sctx->fallback.blk = crypto_alloc_sync_skcipher(name, 0,
-						   CRYPTO_ALG_NEED_FALLBACK);
+	sctx->fallback.skcipher = crypto_alloc_skcipher(name, 0,
+				CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC);
 
-	if (IS_ERR(sctx->fallback.blk)) {
+	if (IS_ERR(sctx->fallback.skcipher)) {
 		pr_err("Allocating AES fallback algorithm %s failed\n",
 		       name);
-		return PTR_ERR(sctx->fallback.blk);
+		return PTR_ERR(sctx->fallback.skcipher);
 	}
 
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct skcipher_request) +
+				    crypto_skcipher_reqsize(sctx->fallback.skcipher));
 	return 0;
 }
 
-static void fallback_exit_blk(struct crypto_tfm *tfm)
+static void fallback_exit_skcipher(struct crypto_skcipher *tfm)
 {
-	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct s390_aes_ctx *sctx = crypto_skcipher_ctx(tfm);
 
-	crypto_free_sync_skcipher(sctx->fallback.blk);
+	crypto_free_skcipher(sctx->fallback.skcipher);
 }
 
-static struct crypto_alg ecb_aes_alg = {
-	.cra_name		=	"ecb(aes)",
-	.cra_driver_name	=	"ecb-aes-s390",
-	.cra_priority		=	401,	/* combo: aes + ecb + 1 */
-	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
-					CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct s390_aes_ctx),
-	.cra_type		=	&crypto_blkcipher_type,
-	.cra_module		=	THIS_MODULE,
-	.cra_init		=	fallback_init_blk,
-	.cra_exit		=	fallback_exit_blk,
-	.cra_u			=	{
-		.blkcipher = {
-			.min_keysize		=	AES_MIN_KEY_SIZE,
-			.max_keysize		=	AES_MAX_KEY_SIZE,
-			.setkey			=	ecb_aes_set_key,
-			.encrypt		=	ecb_aes_encrypt,
-			.decrypt		=	ecb_aes_decrypt,
-		}
-	}
+static struct skcipher_alg ecb_aes_alg = {
+	.base.cra_name		=	"ecb(aes)",
+	.base.cra_driver_name	=	"ecb-aes-s390",
+	.base.cra_priority	=	401,	/* combo: aes + ecb + 1 */
+	.base.cra_flags		=	CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_blocksize	=	AES_BLOCK_SIZE,
+	.base.cra_ctxsize	=	sizeof(struct s390_aes_ctx),
+	.base.cra_module	=	THIS_MODULE,
+	.init			=	fallback_init_skcipher,
+	.exit			=	fallback_exit_skcipher,
+	.min_keysize		=	AES_MIN_KEY_SIZE,
+	.max_keysize		=	AES_MAX_KEY_SIZE,
+	.setkey			=	ecb_aes_set_key,
+	.encrypt		=	ecb_aes_encrypt,
+	.decrypt		=	ecb_aes_decrypt,
 };
 
-static int cbc_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+static int cbc_aes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 			   unsigned int key_len)
 {
-	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct s390_aes_ctx *sctx = crypto_skcipher_ctx(tfm);
 	unsigned long fc;
 
 	/* Pick the correct function code based on the key length */
@@ -363,17 +319,18 @@ static int cbc_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	/* Check if the function code is available */
 	sctx->fc = (fc && cpacf_test_func(&kmc_functions, fc)) ? fc : 0;
 	if (!sctx->fc)
-		return setkey_fallback_blk(tfm, in_key, key_len);
+		return setkey_fallback_skcipher(tfm, in_key, key_len);
 
 	sctx->key_len = key_len;
 	memcpy(sctx->key, in_key, key_len);
 	return 0;
 }
 
-static int cbc_aes_crypt(struct blkcipher_desc *desc, unsigned long modifier,
-			 struct blkcipher_walk *walk)
+static int cbc_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 {
-	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct s390_aes_ctx *sctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
 	unsigned int nbytes, n;
 	int ret;
 	struct {
@@ -381,134 +338,74 @@ static int cbc_aes_crypt(struct blkcipher_desc *desc, unsigned long modifier,
 		u8 key[AES_MAX_KEY_SIZE];
 	} param;
 
-	ret = blkcipher_walk_virt(desc, walk);
-	memcpy(param.iv, walk->iv, AES_BLOCK_SIZE);
+	if (unlikely(!sctx->fc))
+		return fallback_skcipher_crypt(sctx, req, modifier);
+
+	ret = skcipher_walk_virt(&walk, req, false);
+	if (ret)
+		return ret;
+	memcpy(param.iv, walk.iv, AES_BLOCK_SIZE);
 	memcpy(param.key, sctx->key, sctx->key_len);
-	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
+	while ((nbytes = walk.nbytes) != 0) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_kmc(sctx->fc | modifier, &param,
-			  walk->dst.virt.addr, walk->src.virt.addr, n);
-		ret = blkcipher_walk_done(desc, walk, nbytes - n);
+			  walk.dst.virt.addr, walk.src.virt.addr, n);
+		memcpy(walk.iv, param.iv, AES_BLOCK_SIZE);
+		ret = skcipher_walk_done(&walk, nbytes - n);
 	}
-	memcpy(walk->iv, param.iv, AES_BLOCK_SIZE);
 	return ret;
 }
 
-static int cbc_aes_encrypt(struct blkcipher_desc *desc,
-			   struct scatterlist *dst, struct scatterlist *src,
-			   unsigned int nbytes)
+static int cbc_aes_encrypt(struct skcipher_request *req)
 {
-	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-
-	if (unlikely(!sctx->fc))
-		return fallback_blk_enc(desc, dst, src, nbytes);
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_aes_crypt(desc, 0, &walk);
+	return cbc_aes_crypt(req, 0);
 }
 
-static int cbc_aes_decrypt(struct blkcipher_desc *desc,
-			   struct scatterlist *dst, struct scatterlist *src,
-			   unsigned int nbytes)
+static int cbc_aes_decrypt(struct skcipher_request *req)
 {
-	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-
-	if (unlikely(!sctx->fc))
-		return fallback_blk_dec(desc, dst, src, nbytes);
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_aes_crypt(desc, CPACF_DECRYPT, &walk);
+	return cbc_aes_crypt(req, CPACF_DECRYPT);
 }
 
-static struct crypto_alg cbc_aes_alg = {
-	.cra_name		=	"cbc(aes)",
-	.cra_driver_name	=	"cbc-aes-s390",
-	.cra_priority		=	402,	/* ecb-aes-s390 + 1 */
-	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
-					CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct s390_aes_ctx),
-	.cra_type		=	&crypto_blkcipher_type,
-	.cra_module		=	THIS_MODULE,
-	.cra_init		=	fallback_init_blk,
-	.cra_exit		=	fallback_exit_blk,
-	.cra_u			=	{
-		.blkcipher = {
-			.min_keysize		=	AES_MIN_KEY_SIZE,
-			.max_keysize		=	AES_MAX_KEY_SIZE,
-			.ivsize			=	AES_BLOCK_SIZE,
-			.setkey			=	cbc_aes_set_key,
-			.encrypt		=	cbc_aes_encrypt,
-			.decrypt		=	cbc_aes_decrypt,
-		}
-	}
+static struct skcipher_alg cbc_aes_alg = {
+	.base.cra_name		=	"cbc(aes)",
+	.base.cra_driver_name	=	"cbc-aes-s390",
+	.base.cra_priority	=	402,	/* ecb-aes-s390 + 1 */
+	.base.cra_flags		=	CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_blocksize	=	AES_BLOCK_SIZE,
+	.base.cra_ctxsize	=	sizeof(struct s390_aes_ctx),
+	.base.cra_module	=	THIS_MODULE,
+	.init			=	fallback_init_skcipher,
+	.exit			=	fallback_exit_skcipher,
+	.min_keysize		=	AES_MIN_KEY_SIZE,
+	.max_keysize		=	AES_MAX_KEY_SIZE,
+	.ivsize			=	AES_BLOCK_SIZE,
+	.setkey			=	cbc_aes_set_key,
+	.encrypt		=	cbc_aes_encrypt,
+	.decrypt		=	cbc_aes_decrypt,
 };
 
-static int xts_fallback_setkey(struct crypto_tfm *tfm, const u8 *key,
-				   unsigned int len)
-{
-	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
-	unsigned int ret;
-
-	crypto_sync_skcipher_clear_flags(xts_ctx->fallback,
-					 CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(xts_ctx->fallback, tfm->crt_flags &
-						     CRYPTO_TFM_REQ_MASK);
-
-	ret = crypto_sync_skcipher_setkey(xts_ctx->fallback, key, len);
-
-	tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-	tfm->crt_flags |= crypto_sync_skcipher_get_flags(xts_ctx->fallback) &
-			  CRYPTO_TFM_RES_MASK;
-
-	return ret;
-}
-
-static int xts_fallback_decrypt(struct blkcipher_desc *desc,
-		struct scatterlist *dst, struct scatterlist *src,
-		unsigned int nbytes)
-{
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(tfm);
-	SYNC_SKCIPHER_REQUEST_ON_STACK(req, xts_ctx->fallback);
-	unsigned int ret;
-
-	skcipher_request_set_sync_tfm(req, xts_ctx->fallback);
-	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
-	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
-
-	ret = crypto_skcipher_decrypt(req);
-
-	skcipher_request_zero(req);
-	return ret;
-}
-
-static int xts_fallback_encrypt(struct blkcipher_desc *desc,
-		struct scatterlist *dst, struct scatterlist *src,
-		unsigned int nbytes)
+static int xts_fallback_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			       unsigned int len)
 {
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(tfm);
-	SYNC_SKCIPHER_REQUEST_ON_STACK(req, xts_ctx->fallback);
-	unsigned int ret;
-
-	skcipher_request_set_sync_tfm(req, xts_ctx->fallback);
-	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
-	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
-
-	ret = crypto_skcipher_encrypt(req);
+	struct s390_xts_ctx *xts_ctx = crypto_skcipher_ctx(tfm);
+	int ret;
 
-	skcipher_request_zero(req);
+	crypto_skcipher_clear_flags(xts_ctx->fallback, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(xts_ctx->fallback,
+				  crypto_skcipher_get_flags(tfm) &
+				  CRYPTO_TFM_REQ_MASK);
+	ret = crypto_skcipher_setkey(xts_ctx->fallback, key, len);
+	crypto_skcipher_set_flags(tfm,
+				  crypto_skcipher_get_flags(xts_ctx->fallback) &
+				  CRYPTO_TFM_RES_MASK);
 	return ret;
 }
 
-static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+static int xts_aes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 			   unsigned int key_len)
 {
-	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
+	struct s390_xts_ctx *xts_ctx = crypto_skcipher_ctx(tfm);
 	unsigned long fc;
 	int err;
 
@@ -518,7 +415,7 @@ static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 
 	/* In fips mode only 128 bit or 256 bit keys are valid */
 	if (fips_enabled && key_len != 32 && key_len != 64) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
@@ -539,10 +436,11 @@ static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return 0;
 }
 
-static int xts_aes_crypt(struct blkcipher_desc *desc, unsigned long modifier,
-			 struct blkcipher_walk *walk)
+static int xts_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 {
-	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct s390_xts_ctx *xts_ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
 	unsigned int offset, nbytes, n;
 	int ret;
 	struct {
@@ -557,113 +455,100 @@ static int xts_aes_crypt(struct blkcipher_desc *desc, unsigned long modifier,
 		u8 init[16];
 	} xts_param;
 
-	ret = blkcipher_walk_virt(desc, walk);
+	if (req->cryptlen < AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (unlikely(!xts_ctx->fc || (req->cryptlen % AES_BLOCK_SIZE) != 0)) {
+		struct skcipher_request *subreq = skcipher_request_ctx(req);
+
+		*subreq = *req;
+		skcipher_request_set_tfm(subreq, xts_ctx->fallback);
+		return (modifier & CPACF_DECRYPT) ?
+			crypto_skcipher_decrypt(subreq) :
+			crypto_skcipher_encrypt(subreq);
+	}
+
+	ret = skcipher_walk_virt(&walk, req, false);
+	if (ret)
+		return ret;
 	offset = xts_ctx->key_len & 0x10;
 	memset(pcc_param.block, 0, sizeof(pcc_param.block));
 	memset(pcc_param.bit, 0, sizeof(pcc_param.bit));
 	memset(pcc_param.xts, 0, sizeof(pcc_param.xts));
-	memcpy(pcc_param.tweak, walk->iv, sizeof(pcc_param.tweak));
+	memcpy(pcc_param.tweak, walk.iv, sizeof(pcc_param.tweak));
 	memcpy(pcc_param.key + offset, xts_ctx->pcc_key, xts_ctx->key_len);
 	cpacf_pcc(xts_ctx->fc, pcc_param.key + offset);
 
 	memcpy(xts_param.key + offset, xts_ctx->key, xts_ctx->key_len);
 	memcpy(xts_param.init, pcc_param.xts, 16);
 
-	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
+	while ((nbytes = walk.nbytes) != 0) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_km(xts_ctx->fc | modifier, xts_param.key + offset,
-			 walk->dst.virt.addr, walk->src.virt.addr, n);
-		ret = blkcipher_walk_done(desc, walk, nbytes - n);
+			 walk.dst.virt.addr, walk.src.virt.addr, n);
+		ret = skcipher_walk_done(&walk, nbytes - n);
 	}
 	return ret;
 }
 
-static int xts_aes_encrypt(struct blkcipher_desc *desc,
-			   struct scatterlist *dst, struct scatterlist *src,
-			   unsigned int nbytes)
+static int xts_aes_encrypt(struct skcipher_request *req)
 {
-	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-
-	if (!nbytes)
-		return -EINVAL;
-
-	if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCK_SIZE) != 0))
-		return xts_fallback_encrypt(desc, dst, src, nbytes);
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return xts_aes_crypt(desc, 0, &walk);
+	return xts_aes_crypt(req, 0);
 }
 
-static int xts_aes_decrypt(struct blkcipher_desc *desc,
-			   struct scatterlist *dst, struct scatterlist *src,
-			   unsigned int nbytes)
+static int xts_aes_decrypt(struct skcipher_request *req)
 {
-	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-
-	if (!nbytes)
-		return -EINVAL;
-
-	if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCK_SIZE) != 0))
-		return xts_fallback_decrypt(desc, dst, src, nbytes);
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return xts_aes_crypt(desc, CPACF_DECRYPT, &walk);
+	return xts_aes_crypt(req, CPACF_DECRYPT);
 }
 
-static int xts_fallback_init(struct crypto_tfm *tfm)
+static int xts_fallback_init(struct crypto_skcipher *tfm)
 {
-	const char *name = tfm->__crt_alg->cra_name;
-	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
+	const char *name = crypto_tfm_alg_name(&tfm->base);
+	struct s390_xts_ctx *xts_ctx = crypto_skcipher_ctx(tfm);
 
-	xts_ctx->fallback = crypto_alloc_sync_skcipher(name, 0,
-						  CRYPTO_ALG_NEED_FALLBACK);
+	xts_ctx->fallback = crypto_alloc_skcipher(name, 0,
+				CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(xts_ctx->fallback)) {
 		pr_err("Allocating XTS fallback algorithm %s failed\n",
 		       name);
 		return PTR_ERR(xts_ctx->fallback);
 	}
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct skcipher_request) +
+				    crypto_skcipher_reqsize(xts_ctx->fallback));
 	return 0;
 }
 
-static void xts_fallback_exit(struct crypto_tfm *tfm)
+static void xts_fallback_exit(struct crypto_skcipher *tfm)
 {
-	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
+	struct s390_xts_ctx *xts_ctx = crypto_skcipher_ctx(tfm);
 
-	crypto_free_sync_skcipher(xts_ctx->fallback);
+	crypto_free_skcipher(xts_ctx->fallback);
 }
 
-static struct crypto_alg xts_aes_alg = {
-	.cra_name		=	"xts(aes)",
-	.cra_driver_name	=	"xts-aes-s390",
-	.cra_priority		=	402,	/* ecb-aes-s390 + 1 */
-	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
-					CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct s390_xts_ctx),
-	.cra_type		=	&crypto_blkcipher_type,
-	.cra_module		=	THIS_MODULE,
-	.cra_init		=	xts_fallback_init,
-	.cra_exit		=	xts_fallback_exit,
-	.cra_u			=	{
-		.blkcipher = {
-			.min_keysize		=	2 * AES_MIN_KEY_SIZE,
-			.max_keysize		=	2 * AES_MAX_KEY_SIZE,
-			.ivsize			=	AES_BLOCK_SIZE,
-			.setkey			=	xts_aes_set_key,
-			.encrypt		=	xts_aes_encrypt,
-			.decrypt		=	xts_aes_decrypt,
-		}
-	}
+static struct skcipher_alg xts_aes_alg = {
+	.base.cra_name		=	"xts(aes)",
+	.base.cra_driver_name	=	"xts-aes-s390",
+	.base.cra_priority	=	402,	/* ecb-aes-s390 + 1 */
+	.base.cra_flags		=	CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_blocksize	=	AES_BLOCK_SIZE,
+	.base.cra_ctxsize	=	sizeof(struct s390_xts_ctx),
+	.base.cra_module	=	THIS_MODULE,
+	.init			=	xts_fallback_init,
+	.exit			=	xts_fallback_exit,
+	.min_keysize		=	2 * AES_MIN_KEY_SIZE,
+	.max_keysize		=	2 * AES_MAX_KEY_SIZE,
+	.ivsize			=	AES_BLOCK_SIZE,
+	.setkey			=	xts_aes_set_key,
+	.encrypt		=	xts_aes_encrypt,
+	.decrypt		=	xts_aes_decrypt,
 };
 
-static int ctr_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+static int ctr_aes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 			   unsigned int key_len)
 {
-	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct s390_aes_ctx *sctx = crypto_skcipher_ctx(tfm);
 	unsigned long fc;
 
 	/* Pick the correct function code based on the key length */
@@ -674,7 +559,7 @@ static int ctr_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	/* Check if the function code is available */
 	sctx->fc = (fc && cpacf_test_func(&kmctr_functions, fc)) ? fc : 0;
 	if (!sctx->fc)
-		return setkey_fallback_blk(tfm, in_key, key_len);
+		return setkey_fallback_skcipher(tfm, in_key, key_len);
 
 	sctx->key_len = key_len;
 	memcpy(sctx->key, in_key, key_len);
@@ -696,30 +581,34 @@ static unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes)
 	return n;
 }
 
-static int ctr_aes_crypt(struct blkcipher_desc *desc, unsigned long modifier,
-			 struct blkcipher_walk *walk)
+static int ctr_aes_crypt(struct skcipher_request *req)
 {
-	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct s390_aes_ctx *sctx = crypto_skcipher_ctx(tfm);
 	u8 buf[AES_BLOCK_SIZE], *ctrptr;
+	struct skcipher_walk walk;
 	unsigned int n, nbytes;
 	int ret, locked;
 
+	if (unlikely(!sctx->fc))
+		return fallback_skcipher_crypt(sctx, req, 0);
+
 	locked = mutex_trylock(&ctrblk_lock);
 
-	ret = blkcipher_walk_virt_block(desc, walk, AES_BLOCK_SIZE);
-	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
+	ret = skcipher_walk_virt(&walk, req, false);
+	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
 		n = AES_BLOCK_SIZE;
+
 		if (nbytes >= 2*AES_BLOCK_SIZE && locked)
-			n = __ctrblk_init(ctrblk, walk->iv, nbytes);
-		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk->iv;
-		cpacf_kmctr(sctx->fc | modifier, sctx->key,
-			    walk->dst.virt.addr, walk->src.virt.addr,
-			    n, ctrptr);
+			n = __ctrblk_init(ctrblk, walk.iv, nbytes);
+		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk.iv;
+		cpacf_kmctr(sctx->fc, sctx->key, walk.dst.virt.addr,
+			    walk.src.virt.addr, n, ctrptr);
 		if (ctrptr == ctrblk)
-			memcpy(walk->iv, ctrptr + n - AES_BLOCK_SIZE,
+			memcpy(walk.iv, ctrptr + n - AES_BLOCK_SIZE,
 			       AES_BLOCK_SIZE);
-		crypto_inc(walk->iv, AES_BLOCK_SIZE);
-		ret = blkcipher_walk_done(desc, walk, nbytes - n);
+		crypto_inc(walk.iv, AES_BLOCK_SIZE);
+		ret = skcipher_walk_done(&walk, nbytes - n);
 	}
 	if (locked)
 		mutex_unlock(&ctrblk_lock);
@@ -727,67 +616,33 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, unsigned long modifier,
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
 	if (nbytes) {
-		cpacf_kmctr(sctx->fc | modifier, sctx->key,
-			    buf, walk->src.virt.addr,
-			    AES_BLOCK_SIZE, walk->iv);
-		memcpy(walk->dst.virt.addr, buf, nbytes);
-		crypto_inc(walk->iv, AES_BLOCK_SIZE);
-		ret = blkcipher_walk_done(desc, walk, 0);
+		cpacf_kmctr(sctx->fc, sctx->key, buf, walk.src.virt.addr,
+			    AES_BLOCK_SIZE, walk.iv);
+		memcpy(walk.dst.virt.addr, buf, nbytes);
+		crypto_inc(walk.iv, AES_BLOCK_SIZE);
+		ret = skcipher_walk_done(&walk, 0);
 	}
 
 	return ret;
 }
 
-static int ctr_aes_encrypt(struct blkcipher_desc *desc,
-			   struct scatterlist *dst, struct scatterlist *src,
-			   unsigned int nbytes)
-{
-	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-
-	if (unlikely(!sctx->fc))
-		return fallback_blk_enc(desc, dst, src, nbytes);
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ctr_aes_crypt(desc, 0, &walk);
-}
-
-static int ctr_aes_decrypt(struct blkcipher_desc *desc,
-			   struct scatterlist *dst, struct scatterlist *src,
-			   unsigned int nbytes)
-{
-	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-
-	if (unlikely(!sctx->fc))
-		return fallback_blk_dec(desc, dst, src, nbytes);
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ctr_aes_crypt(desc, CPACF_DECRYPT, &walk);
-}
-
-static struct crypto_alg ctr_aes_alg = {
-	.cra_name		=	"ctr(aes)",
-	.cra_driver_name	=	"ctr-aes-s390",
-	.cra_priority		=	402,	/* ecb-aes-s390 + 1 */
-	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
-					CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize		=	1,
-	.cra_ctxsize		=	sizeof(struct s390_aes_ctx),
-	.cra_type		=	&crypto_blkcipher_type,
-	.cra_module		=	THIS_MODULE,
-	.cra_init		=	fallback_init_blk,
-	.cra_exit		=	fallback_exit_blk,
-	.cra_u			=	{
-		.blkcipher = {
-			.min_keysize		=	AES_MIN_KEY_SIZE,
-			.max_keysize		=	AES_MAX_KEY_SIZE,
-			.ivsize			=	AES_BLOCK_SIZE,
-			.setkey			=	ctr_aes_set_key,
-			.encrypt		=	ctr_aes_encrypt,
-			.decrypt		=	ctr_aes_decrypt,
-		}
-	}
+static struct skcipher_alg ctr_aes_alg = {
+	.base.cra_name		=	"ctr(aes)",
+	.base.cra_driver_name	=	"ctr-aes-s390",
+	.base.cra_priority	=	402,	/* ecb-aes-s390 + 1 */
+	.base.cra_flags		=	CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_blocksize	=	1,
+	.base.cra_ctxsize	=	sizeof(struct s390_aes_ctx),
+	.base.cra_module	=	THIS_MODULE,
+	.init			=	fallback_init_skcipher,
+	.exit			=	fallback_exit_skcipher,
+	.min_keysize		=	AES_MIN_KEY_SIZE,
+	.max_keysize		=	AES_MAX_KEY_SIZE,
+	.ivsize			=	AES_BLOCK_SIZE,
+	.setkey			=	ctr_aes_set_key,
+	.encrypt		=	ctr_aes_crypt,
+	.decrypt		=	ctr_aes_crypt,
+	.chunksize		=	AES_BLOCK_SIZE,
 };
 
 static int gcm_aes_setkey(struct crypto_aead *tfm, const u8 *key,
@@ -1116,24 +971,27 @@ static struct aead_alg gcm_aes_aead = {
 	},
 };
 
-static struct crypto_alg *aes_s390_algs_ptr[5];
-static int aes_s390_algs_num;
+static struct crypto_alg *aes_s390_alg;
+static struct skcipher_alg *aes_s390_skcipher_algs[4];
+static int aes_s390_skciphers_num;
 static struct aead_alg *aes_s390_aead_alg;
 
-static int aes_s390_register_alg(struct crypto_alg *alg)
+static int aes_s390_register_skcipher(struct skcipher_alg *alg)
 {
 	int ret;
 
-	ret = crypto_register_alg(alg);
+	ret = crypto_register_skcipher(alg);
 	if (!ret)
-		aes_s390_algs_ptr[aes_s390_algs_num++] = alg;
+		aes_s390_skcipher_algs[aes_s390_skciphers_num++] = alg;
 	return ret;
 }
 
 static void aes_s390_fini(void)
 {
-	while (aes_s390_algs_num--)
-		crypto_unregister_alg(aes_s390_algs_ptr[aes_s390_algs_num]);
+	if (aes_s390_alg)
+		crypto_unregister_alg(aes_s390_alg);
+	while (aes_s390_skciphers_num--)
+		crypto_unregister_skcipher(aes_s390_skcipher_algs[aes_s390_skciphers_num]);
 	if (ctrblk)
 		free_page((unsigned long) ctrblk);
 
@@ -1154,10 +1012,11 @@ static int __init aes_s390_init(void)
 	if (cpacf_test_func(&km_functions, CPACF_KM_AES_128) ||
 	    cpacf_test_func(&km_functions, CPACF_KM_AES_192) ||
 	    cpacf_test_func(&km_functions, CPACF_KM_AES_256)) {
-		ret = aes_s390_register_alg(&aes_alg);
+		ret = crypto_register_alg(&aes_alg);
 		if (ret)
 			goto out_err;
-		ret = aes_s390_register_alg(&ecb_aes_alg);
+		aes_s390_alg = &aes_alg;
+		ret = aes_s390_register_skcipher(&ecb_aes_alg);
 		if (ret)
 			goto out_err;
 	}
@@ -1165,14 +1024,14 @@ static int __init aes_s390_init(void)
 	if (cpacf_test_func(&kmc_functions, CPACF_KMC_AES_128) ||
 	    cpacf_test_func(&kmc_functions, CPACF_KMC_AES_192) ||
 	    cpacf_test_func(&kmc_functions, CPACF_KMC_AES_256)) {
-		ret = aes_s390_register_alg(&cbc_aes_alg);
+		ret = aes_s390_register_skcipher(&cbc_aes_alg);
 		if (ret)
 			goto out_err;
 	}
 
 	if (cpacf_test_func(&km_functions, CPACF_KM_XTS_128) ||
 	    cpacf_test_func(&km_functions, CPACF_KM_XTS_256)) {
-		ret = aes_s390_register_alg(&xts_aes_alg);
+		ret = aes_s390_register_skcipher(&xts_aes_alg);
 		if (ret)
 			goto out_err;
 	}
@@ -1185,7 +1044,7 @@ static int __init aes_s390_init(void)
 			ret = -ENOMEM;
 			goto out_err;
 		}
-		ret = aes_s390_register_alg(&ctr_aes_alg);
+		ret = aes_s390_register_skcipher(&ctr_aes_alg);
 		if (ret)
 			goto out_err;
 	}
-- 
2.23.0

