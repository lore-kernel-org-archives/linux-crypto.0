Return-Path: <SRS0=mRc+=YG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EBBC4360C
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 04:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 567C6207FF
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 04:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570940374;
	bh=F/KDD5iY6nsFVZXckmCc0ez09QsHM1FsbezhS1ZmLcA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=t56mXuG4iCdN0Il9MUlo4eXJYoNf3suwhWQRhLh8kncPefeFYi6dcAnwGwAiuMQ61
	 oR2k4bOyTsOxBoC2syN87lj47krnGkzi2TFgPnc+6WQknERqrPaaHMqgYtVChpXEf+
	 b39UpOrMTrBzstL8QCFb5bq4nhukeQ0mdgGo4JsM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfJMETd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 00:19:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbfJMETc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 00:19:32 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3176020700;
        Sun, 13 Oct 2019 04:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570940371;
        bh=F/KDD5iY6nsFVZXckmCc0ez09QsHM1FsbezhS1ZmLcA=;
        h=From:To:Cc:Subject:Date:From;
        b=Wjx3r3wJrXKnFuVdenUdQV8bu+pc79kGYSIM5y/93RCkHP1wACG3lUCvrWdKZ75bl
         CpGCqHVSb2SzLeIqOZIiWcjXZMLDwx/n324dzXt+waNXUPzJyvIdXUNLMCswOMAXmB
         fQgsgFIyrR/Ccz1GmwR9hC7ovtOt0qp/yw0NF1bs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Jamie Heilman <jamie@audible.transient.net>
Subject: [PATCH] crypto: padlock-aes - convert to skcipher API
Date:   Sat, 12 Oct 2019 21:17:41 -0700
Message-Id: <20191013041741.265150-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert the VIA PadLock implementations of AES-ECB and AES-CBC from the
deprecated "blkcipher" API to the "skcipher" API.  This is needed in
order for the blkcipher API to be removed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This is compile-tested only, as I don't have this hardware.
If anyone has this hardware, please test it with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.

 drivers/crypto/padlock-aes.c | 157 +++++++++++++++++------------------
 1 file changed, 74 insertions(+), 83 deletions(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 8a0661250078..c5b60f50e1b5 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -10,6 +10,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/padlock.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -97,9 +98,9 @@ static inline struct aes_ctx *aes_ctx(struct crypto_tfm *tfm)
 	return aes_ctx_common(crypto_tfm_ctx(tfm));
 }
 
-static inline struct aes_ctx *blk_aes_ctx(struct crypto_blkcipher *tfm)
+static inline struct aes_ctx *skcipher_aes_ctx(struct crypto_skcipher *tfm)
 {
-	return aes_ctx_common(crypto_blkcipher_ctx(tfm));
+	return aes_ctx_common(crypto_skcipher_ctx(tfm));
 }
 
 static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
@@ -162,6 +163,12 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return 0;
 }
 
+static int aes_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
+				unsigned int key_len)
+{
+	return aes_set_key(crypto_skcipher_tfm(tfm), in_key, key_len);
+}
+
 /* ====== Encryption/decryption routines ====== */
 
 /* These are the real call to PadLock. */
@@ -338,25 +345,24 @@ static struct crypto_alg aes_alg = {
 	}
 };
 
-static int ecb_aes_encrypt(struct blkcipher_desc *desc,
-			   struct scatterlist *dst, struct scatterlist *src,
-			   unsigned int nbytes)
+static int ecb_aes_encrypt(struct skcipher_request *req)
 {
-	struct aes_ctx *ctx = blk_aes_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aes_ctx *ctx = skcipher_aes_ctx(tfm);
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
 	padlock_reset_key(&ctx->cword.encrypt);
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	while ((nbytes = walk.nbytes)) {
+	while ((nbytes = walk.nbytes) != 0) {
 		padlock_xcrypt_ecb(walk.src.virt.addr, walk.dst.virt.addr,
 				   ctx->E, &ctx->cword.encrypt,
 				   nbytes / AES_BLOCK_SIZE);
 		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 
 	padlock_store_cword(&ctx->cword.encrypt);
@@ -364,25 +370,24 @@ static int ecb_aes_encrypt(struct blkcipher_desc *desc,
 	return err;
 }
 
-static int ecb_aes_decrypt(struct blkcipher_desc *desc,
-			   struct scatterlist *dst, struct scatterlist *src,
-			   unsigned int nbytes)
+static int ecb_aes_decrypt(struct skcipher_request *req)
 {
-	struct aes_ctx *ctx = blk_aes_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aes_ctx *ctx = skcipher_aes_ctx(tfm);
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
 	padlock_reset_key(&ctx->cword.decrypt);
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	while ((nbytes = walk.nbytes)) {
+	while ((nbytes = walk.nbytes) != 0) {
 		padlock_xcrypt_ecb(walk.src.virt.addr, walk.dst.virt.addr,
 				   ctx->D, &ctx->cword.decrypt,
 				   nbytes / AES_BLOCK_SIZE);
 		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 
 	padlock_store_cword(&ctx->cword.encrypt);
@@ -390,48 +395,41 @@ static int ecb_aes_decrypt(struct blkcipher_desc *desc,
 	return err;
 }
 
-static struct crypto_alg ecb_aes_alg = {
-	.cra_name		=	"ecb(aes)",
-	.cra_driver_name	=	"ecb-aes-padlock",
-	.cra_priority		=	PADLOCK_COMPOSITE_PRIORITY,
-	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct aes_ctx),
-	.cra_alignmask		=	PADLOCK_ALIGNMENT - 1,
-	.cra_type		=	&crypto_blkcipher_type,
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{
-		.blkcipher = {
-			.min_keysize		=	AES_MIN_KEY_SIZE,
-			.max_keysize		=	AES_MAX_KEY_SIZE,
-			.setkey	   		= 	aes_set_key,
-			.encrypt		=	ecb_aes_encrypt,
-			.decrypt		=	ecb_aes_decrypt,
-		}
-	}
+static struct skcipher_alg ecb_aes_alg = {
+	.base.cra_name		=	"ecb(aes)",
+	.base.cra_driver_name	=	"ecb-aes-padlock",
+	.base.cra_priority	=	PADLOCK_COMPOSITE_PRIORITY,
+	.base.cra_blocksize	=	AES_BLOCK_SIZE,
+	.base.cra_ctxsize	=	sizeof(struct aes_ctx),
+	.base.cra_alignmask	=	PADLOCK_ALIGNMENT - 1,
+	.base.cra_module	=	THIS_MODULE,
+	.min_keysize		=	AES_MIN_KEY_SIZE,
+	.max_keysize		=	AES_MAX_KEY_SIZE,
+	.setkey			=	aes_set_key_skcipher,
+	.encrypt		=	ecb_aes_encrypt,
+	.decrypt		=	ecb_aes_decrypt,
 };
 
-static int cbc_aes_encrypt(struct blkcipher_desc *desc,
-			   struct scatterlist *dst, struct scatterlist *src,
-			   unsigned int nbytes)
+static int cbc_aes_encrypt(struct skcipher_request *req)
 {
-	struct aes_ctx *ctx = blk_aes_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aes_ctx *ctx = skcipher_aes_ctx(tfm);
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
 	padlock_reset_key(&ctx->cword.encrypt);
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	while ((nbytes = walk.nbytes)) {
+	while ((nbytes = walk.nbytes) != 0) {
 		u8 *iv = padlock_xcrypt_cbc(walk.src.virt.addr,
 					    walk.dst.virt.addr, ctx->E,
 					    walk.iv, &ctx->cword.encrypt,
 					    nbytes / AES_BLOCK_SIZE);
 		memcpy(walk.iv, iv, AES_BLOCK_SIZE);
 		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 
 	padlock_store_cword(&ctx->cword.decrypt);
@@ -439,25 +437,24 @@ static int cbc_aes_encrypt(struct blkcipher_desc *desc,
 	return err;
 }
 
-static int cbc_aes_decrypt(struct blkcipher_desc *desc,
-			   struct scatterlist *dst, struct scatterlist *src,
-			   unsigned int nbytes)
+static int cbc_aes_decrypt(struct skcipher_request *req)
 {
-	struct aes_ctx *ctx = blk_aes_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aes_ctx *ctx = skcipher_aes_ctx(tfm);
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
 	padlock_reset_key(&ctx->cword.encrypt);
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	while ((nbytes = walk.nbytes)) {
+	while ((nbytes = walk.nbytes) != 0) {
 		padlock_xcrypt_cbc(walk.src.virt.addr, walk.dst.virt.addr,
 				   ctx->D, walk.iv, &ctx->cword.decrypt,
 				   nbytes / AES_BLOCK_SIZE);
 		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 
 	padlock_store_cword(&ctx->cword.encrypt);
@@ -465,26 +462,20 @@ static int cbc_aes_decrypt(struct blkcipher_desc *desc,
 	return err;
 }
 
-static struct crypto_alg cbc_aes_alg = {
-	.cra_name		=	"cbc(aes)",
-	.cra_driver_name	=	"cbc-aes-padlock",
-	.cra_priority		=	PADLOCK_COMPOSITE_PRIORITY,
-	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct aes_ctx),
-	.cra_alignmask		=	PADLOCK_ALIGNMENT - 1,
-	.cra_type		=	&crypto_blkcipher_type,
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{
-		.blkcipher = {
-			.min_keysize		=	AES_MIN_KEY_SIZE,
-			.max_keysize		=	AES_MAX_KEY_SIZE,
-			.ivsize			=	AES_BLOCK_SIZE,
-			.setkey	   		= 	aes_set_key,
-			.encrypt		=	cbc_aes_encrypt,
-			.decrypt		=	cbc_aes_decrypt,
-		}
-	}
+static struct skcipher_alg cbc_aes_alg = {
+	.base.cra_name		=	"cbc(aes)",
+	.base.cra_driver_name	=	"cbc-aes-padlock",
+	.base.cra_priority	=	PADLOCK_COMPOSITE_PRIORITY,
+	.base.cra_blocksize	=	AES_BLOCK_SIZE,
+	.base.cra_ctxsize	=	sizeof(struct aes_ctx),
+	.base.cra_alignmask	=	PADLOCK_ALIGNMENT - 1,
+	.base.cra_module	=	THIS_MODULE,
+	.min_keysize		=	AES_MIN_KEY_SIZE,
+	.max_keysize		=	AES_MAX_KEY_SIZE,
+	.ivsize			=	AES_BLOCK_SIZE,
+	.setkey			=	aes_set_key_skcipher,
+	.encrypt		=	cbc_aes_encrypt,
+	.decrypt		=	cbc_aes_decrypt,
 };
 
 static const struct x86_cpu_id padlock_cpu_id[] = {
@@ -506,13 +497,13 @@ static int __init padlock_init(void)
 		return -ENODEV;
 	}
 
-	if ((ret = crypto_register_alg(&aes_alg)))
+	if ((ret = crypto_register_alg(&aes_alg)) != 0)
 		goto aes_err;
 
-	if ((ret = crypto_register_alg(&ecb_aes_alg)))
+	if ((ret = crypto_register_skcipher(&ecb_aes_alg)) != 0)
 		goto ecb_aes_err;
 
-	if ((ret = crypto_register_alg(&cbc_aes_alg)))
+	if ((ret = crypto_register_skcipher(&cbc_aes_alg)) != 0)
 		goto cbc_aes_err;
 
 	printk(KERN_NOTICE PFX "Using VIA PadLock ACE for AES algorithm.\n");
@@ -527,7 +518,7 @@ static int __init padlock_init(void)
 	return ret;
 
 cbc_aes_err:
-	crypto_unregister_alg(&ecb_aes_alg);
+	crypto_unregister_skcipher(&ecb_aes_alg);
 ecb_aes_err:
 	crypto_unregister_alg(&aes_alg);
 aes_err:
@@ -537,8 +528,8 @@ static int __init padlock_init(void)
 
 static void __exit padlock_fini(void)
 {
-	crypto_unregister_alg(&cbc_aes_alg);
-	crypto_unregister_alg(&ecb_aes_alg);
+	crypto_unregister_skcipher(&cbc_aes_alg);
+	crypto_unregister_skcipher(&ecb_aes_alg);
 	crypto_unregister_alg(&aes_alg);
 }
 
-- 
2.23.0

