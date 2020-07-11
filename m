Return-Path: <SRS0=99oU=AW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12228C433DF
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jul 2020 03:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D11A020767
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jul 2020 03:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594438607;
	bh=RvqC4/XHgD2elU+2iU8/tcelSOMaLT7+oK2PEqKUMW0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=a+7E/Iaq2vPs8ME5FE0a1lxv+gLz8nWpY4M85GhmO9RbfZuYRfgbY3HQy6tr+Z7s2
	 3gJ/Znd9UjpsEKOhu4L1wrShtFwLR4u9V3QGzuNuQd+ct3fbt6t8Shx46moWYUUnv8
	 z0xRM/Xb5TUYVOnSIiGNCMH9jPi6+qLv7IXhk8oE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgGKDgr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 23:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbgGKDgr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 23:36:47 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2E05206F0;
        Sat, 11 Jul 2020 03:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594438606;
        bh=RvqC4/XHgD2elU+2iU8/tcelSOMaLT7+oK2PEqKUMW0=;
        h=From:To:Cc:Subject:Date:From;
        b=Qc4IdFN1IO5wKzzVRFBGTnuW/W27UOtROSbR07+ATjMWAZyAUlY+BSxN05df6uAFC
         0+BT1GCCFGclyE/mZQHmLDMVh8k2sAbbBfIbB8GshQkba7pwGTRH4UCfTth3Z6Ko+3
         uo13lynZisoFU5MUjEU7KA2IQmOL3eQlr9uWgYD4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: xts - prefix function and struct names with "xts"
Date:   Fri, 10 Jul 2020 20:34:28 -0700
Message-Id: <20200711033428.134567-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Overly-generic names can cause problems like naming collisions,
confusing crash reports, and reduced grep-ability.  E.g. see
commit d099ea6e6fde ("crypto - Avoid free() namespace collision").

Clean this up for the xts template by prefixing the names with "xts_".

(I didn't use "crypto_xts_" instead because that seems overkill.)

Also constify the tfm context in a couple places, and make
xts_free_instance() use the instance context structure so that it
doesn't just assume the crypto_skcipher_spawn is at the beginning.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/xts.c | 137 +++++++++++++++++++++++++++------------------------
 1 file changed, 72 insertions(+), 65 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 9a7adab6c3e1..3c3ed02c7663 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -20,7 +20,7 @@
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
 
-struct priv {
+struct xts_tfm_ctx {
 	struct crypto_skcipher *child;
 	struct crypto_cipher *tweak;
 };
@@ -30,17 +30,17 @@ struct xts_instance_ctx {
 	char name[CRYPTO_MAX_ALG_NAME];
 };
 
-struct rctx {
+struct xts_request_ctx {
 	le128 t;
 	struct scatterlist *tail;
 	struct scatterlist sg[2];
 	struct skcipher_request subreq;
 };
 
-static int setkey(struct crypto_skcipher *parent, const u8 *key,
-		  unsigned int keylen)
+static int xts_setkey(struct crypto_skcipher *parent, const u8 *key,
+		      unsigned int keylen)
 {
-	struct priv *ctx = crypto_skcipher_ctx(parent);
+	struct xts_tfm_ctx *ctx = crypto_skcipher_ctx(parent);
 	struct crypto_skcipher *child;
 	struct crypto_cipher *tweak;
 	int err;
@@ -78,9 +78,10 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
  * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
  * just doing the gf128mul_x_ble() calls again.
  */
-static int xor_tweak(struct skcipher_request *req, bool second_pass, bool enc)
+static int xts_xor_tweak(struct skcipher_request *req, bool second_pass,
+			 bool enc)
 {
-	struct rctx *rctx = skcipher_request_ctx(req);
+	struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const bool cts = (req->cryptlen % XTS_BLOCK_SIZE);
 	const int bs = XTS_BLOCK_SIZE;
@@ -128,23 +129,23 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass, bool enc)
 	return err;
 }
 
-static int xor_tweak_pre(struct skcipher_request *req, bool enc)
+static int xts_xor_tweak_pre(struct skcipher_request *req, bool enc)
 {
-	return xor_tweak(req, false, enc);
+	return xts_xor_tweak(req, false, enc);
 }
 
-static int xor_tweak_post(struct skcipher_request *req, bool enc)
+static int xts_xor_tweak_post(struct skcipher_request *req, bool enc)
 {
-	return xor_tweak(req, true, enc);
+	return xts_xor_tweak(req, true, enc);
 }
 
-static void cts_done(struct crypto_async_request *areq, int err)
+static void xts_cts_done(struct crypto_async_request *areq, int err)
 {
 	struct skcipher_request *req = areq->data;
 	le128 b;
 
 	if (!err) {
-		struct rctx *rctx = skcipher_request_ctx(req);
+		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 
 		scatterwalk_map_and_copy(&b, rctx->tail, 0, XTS_BLOCK_SIZE, 0);
 		le128_xor(&b, &rctx->t, &b);
@@ -154,12 +155,13 @@ static void cts_done(struct crypto_async_request *areq, int err)
 	skcipher_request_complete(req, err);
 }
 
-static int cts_final(struct skcipher_request *req,
-		     int (*crypt)(struct skcipher_request *req))
+static int xts_cts_final(struct skcipher_request *req,
+			 int (*crypt)(struct skcipher_request *req))
 {
-	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	const struct xts_tfm_ctx *ctx =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
 	int offset = req->cryptlen & ~(XTS_BLOCK_SIZE - 1);
-	struct rctx *rctx = skcipher_request_ctx(req);
+	struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 	int tail = req->cryptlen % XTS_BLOCK_SIZE;
 	le128 b[2];
@@ -177,7 +179,8 @@ static int cts_final(struct skcipher_request *req,
 	scatterwalk_map_and_copy(b, rctx->tail, 0, XTS_BLOCK_SIZE + tail, 1);
 
 	skcipher_request_set_tfm(subreq, ctx->child);
-	skcipher_request_set_callback(subreq, req->base.flags, cts_done, req);
+	skcipher_request_set_callback(subreq, req->base.flags, xts_cts_done,
+				      req);
 	skcipher_request_set_crypt(subreq, rctx->tail, rctx->tail,
 				   XTS_BLOCK_SIZE, NULL);
 
@@ -192,18 +195,18 @@ static int cts_final(struct skcipher_request *req,
 	return 0;
 }
 
-static void encrypt_done(struct crypto_async_request *areq, int err)
+static void xts_encrypt_done(struct crypto_async_request *areq, int err)
 {
 	struct skcipher_request *req = areq->data;
 
 	if (!err) {
-		struct rctx *rctx = skcipher_request_ctx(req);
+		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 
 		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-		err = xor_tweak_post(req, true);
+		err = xts_xor_tweak_post(req, true);
 
 		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
-			err = cts_final(req, crypto_skcipher_encrypt);
+			err = xts_cts_final(req, crypto_skcipher_encrypt);
 			if (err == -EINPROGRESS)
 				return;
 		}
@@ -212,18 +215,18 @@ static void encrypt_done(struct crypto_async_request *areq, int err)
 	skcipher_request_complete(req, err);
 }
 
-static void decrypt_done(struct crypto_async_request *areq, int err)
+static void xts_decrypt_done(struct crypto_async_request *areq, int err)
 {
 	struct skcipher_request *req = areq->data;
 
 	if (!err) {
-		struct rctx *rctx = skcipher_request_ctx(req);
+		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 
 		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-		err = xor_tweak_post(req, false);
+		err = xts_xor_tweak_post(req, false);
 
 		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
-			err = cts_final(req, crypto_skcipher_decrypt);
+			err = xts_cts_final(req, crypto_skcipher_decrypt);
 			if (err == -EINPROGRESS)
 				return;
 		}
@@ -232,10 +235,12 @@ static void decrypt_done(struct crypto_async_request *areq, int err)
 	skcipher_request_complete(req, err);
 }
 
-static int init_crypt(struct skcipher_request *req, crypto_completion_t compl)
+static int xts_init_crypt(struct skcipher_request *req,
+			  crypto_completion_t compl)
 {
-	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct rctx *rctx = skcipher_request_ctx(req);
+	const struct xts_tfm_ctx *ctx =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 
 	if (req->cryptlen < XTS_BLOCK_SIZE)
@@ -252,45 +257,45 @@ static int init_crypt(struct skcipher_request *req, crypto_completion_t compl)
 	return 0;
 }
 
-static int encrypt(struct skcipher_request *req)
+static int xts_encrypt(struct skcipher_request *req)
 {
-	struct rctx *rctx = skcipher_request_ctx(req);
+	struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 	int err;
 
-	err = init_crypt(req, encrypt_done) ?:
-	      xor_tweak_pre(req, true) ?:
+	err = xts_init_crypt(req, xts_encrypt_done) ?:
+	      xts_xor_tweak_pre(req, true) ?:
 	      crypto_skcipher_encrypt(subreq) ?:
-	      xor_tweak_post(req, true);
+	      xts_xor_tweak_post(req, true);
 
 	if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) == 0))
 		return err;
 
-	return cts_final(req, crypto_skcipher_encrypt);
+	return xts_cts_final(req, crypto_skcipher_encrypt);
 }
 
-static int decrypt(struct skcipher_request *req)
+static int xts_decrypt(struct skcipher_request *req)
 {
-	struct rctx *rctx = skcipher_request_ctx(req);
+	struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 	int err;
 
-	err = init_crypt(req, decrypt_done) ?:
-	      xor_tweak_pre(req, false) ?:
+	err = xts_init_crypt(req, xts_decrypt_done) ?:
+	      xts_xor_tweak_pre(req, false) ?:
 	      crypto_skcipher_decrypt(subreq) ?:
-	      xor_tweak_post(req, false);
+	      xts_xor_tweak_post(req, false);
 
 	if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) == 0))
 		return err;
 
-	return cts_final(req, crypto_skcipher_decrypt);
+	return xts_cts_final(req, crypto_skcipher_decrypt);
 }
 
-static int init_tfm(struct crypto_skcipher *tfm)
+static int xts_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
 	struct xts_instance_ctx *ictx = skcipher_instance_ctx(inst);
-	struct priv *ctx = crypto_skcipher_ctx(tfm);
+	struct xts_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *child;
 	struct crypto_cipher *tweak;
 
@@ -309,26 +314,28 @@ static int init_tfm(struct crypto_skcipher *tfm)
 	ctx->tweak = tweak;
 
 	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(child) +
-					 sizeof(struct rctx));
+					 sizeof(struct xts_request_ctx));
 
 	return 0;
 }
 
-static void exit_tfm(struct crypto_skcipher *tfm)
+static void xts_exit_tfm(struct crypto_skcipher *tfm)
 {
-	struct priv *ctx = crypto_skcipher_ctx(tfm);
+	struct xts_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_skcipher(ctx->child);
 	crypto_free_cipher(ctx->tweak);
 }
 
-static void crypto_xts_free(struct skcipher_instance *inst)
+static void xts_free_instance(struct skcipher_instance *inst)
 {
-	crypto_drop_skcipher(skcipher_instance_ctx(inst));
+	struct xts_instance_ctx *ictx = skcipher_instance_ctx(inst);
+
+	crypto_drop_skcipher(&ictx->spawn);
 	kfree(inst);
 }
 
-static int create(struct crypto_template *tmpl, struct rtattr **tb)
+static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct skcipher_instance *inst;
 	struct xts_instance_ctx *ctx;
@@ -416,43 +423,43 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) * 2;
 	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg) * 2;
 
-	inst->alg.base.cra_ctxsize = sizeof(struct priv);
+	inst->alg.base.cra_ctxsize = sizeof(struct xts_tfm_ctx);
 
-	inst->alg.init = init_tfm;
-	inst->alg.exit = exit_tfm;
+	inst->alg.init = xts_init_tfm;
+	inst->alg.exit = xts_exit_tfm;
 
-	inst->alg.setkey = setkey;
-	inst->alg.encrypt = encrypt;
-	inst->alg.decrypt = decrypt;
+	inst->alg.setkey = xts_setkey;
+	inst->alg.encrypt = xts_encrypt;
+	inst->alg.decrypt = xts_decrypt;
 
-	inst->free = crypto_xts_free;
+	inst->free = xts_free_instance;
 
 	err = skcipher_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		crypto_xts_free(inst);
+		xts_free_instance(inst);
 	}
 	return err;
 }
 
-static struct crypto_template crypto_tmpl = {
+static struct crypto_template xts_tmpl = {
 	.name = "xts",
-	.create = create,
+	.create = xts_create,
 	.module = THIS_MODULE,
 };
 
-static int __init crypto_module_init(void)
+static int __init xts_module_init(void)
 {
-	return crypto_register_template(&crypto_tmpl);
+	return crypto_register_template(&xts_tmpl);
 }
 
-static void __exit crypto_module_exit(void)
+static void __exit xts_module_exit(void)
 {
-	crypto_unregister_template(&crypto_tmpl);
+	crypto_unregister_template(&xts_tmpl);
 }
 
-subsys_initcall(crypto_module_init);
-module_exit(crypto_module_exit);
+subsys_initcall(xts_module_init);
+module_exit(xts_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("XTS block cipher mode");
-- 
2.27.0

