Return-Path: <SRS0=99oU=AW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0993AC433E1
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jul 2020 03:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D11B720767
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jul 2020 03:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594438616;
	bh=JmMqwKjXzN6c2NsxNfbQlwWLGVTWzEGwm9nF1N/Fz7g=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=i29fx1gBNdKAXaonDZOE3ccOjq8/HmHyPR0PZ+dN0MJZuQYts5qYOg7FPzSYo6kyI
	 Ic7YN7nCE+i9OSb0+h5soVv1z30zyRIUEEPK5lEwaS2jgXRp80cO6dNNI5YdyciX3Q
	 J5Pjv8lGfP5CFsUhtW/PQOdb7BnL//rZmUoL96/Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgGKDg4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 23:36:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbgGKDg4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 23:36:56 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F57A206F0;
        Sat, 11 Jul 2020 03:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594438614;
        bh=JmMqwKjXzN6c2NsxNfbQlwWLGVTWzEGwm9nF1N/Fz7g=;
        h=From:To:Cc:Subject:Date:From;
        b=i79I+EJrMPq7qykxYNYVDibxHKsFfwizNgl12IC2+YQdNFK5wbno8EYDQytyham3p
         jaUyURRRqszRQQzDvA4jKLCYoiDcr+BTgZB+bkRG5xo1quxnKO83dMpxTTZ8uVQhjg
         BqRHe41DSCocH4NdXtNqcoOv4bFz9FJIBXc1a0H4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: lrw - prefix function and struct names with "lrw"
Date:   Fri, 10 Jul 2020 20:36:49 -0700
Message-Id: <20200711033649.144903-1-ebiggers@kernel.org>
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

Clean this up for the lrw template by prefixing the names with "lrw_".

(I didn't use "crypto_lrw_" instead because that seems overkill.)

Also constify the tfm context in a couple places.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/lrw.c | 119 ++++++++++++++++++++++++++-------------------------
 1 file changed, 61 insertions(+), 58 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index a709c801ee45..3f90a5ec28f7 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -27,7 +27,7 @@
 
 #define LRW_BLOCK_SIZE 16
 
-struct priv {
+struct lrw_tfm_ctx {
 	struct crypto_skcipher *child;
 
 	/*
@@ -49,12 +49,12 @@ struct priv {
 	be128 mulinc[128];
 };
 
-struct rctx {
+struct lrw_request_ctx {
 	be128 t;
 	struct skcipher_request subreq;
 };
 
-static inline void setbit128_bbe(void *b, int bit)
+static inline void lrw_setbit128_bbe(void *b, int bit)
 {
 	__set_bit(bit ^ (0x80 -
 #ifdef __BIG_ENDIAN
@@ -65,10 +65,10 @@ static inline void setbit128_bbe(void *b, int bit)
 			), b);
 }
 
-static int setkey(struct crypto_skcipher *parent, const u8 *key,
-		  unsigned int keylen)
+static int lrw_setkey(struct crypto_skcipher *parent, const u8 *key,
+		      unsigned int keylen)
 {
-	struct priv *ctx = crypto_skcipher_ctx(parent);
+	struct lrw_tfm_ctx *ctx = crypto_skcipher_ctx(parent);
 	struct crypto_skcipher *child = ctx->child;
 	int err, bsize = LRW_BLOCK_SIZE;
 	const u8 *tweak = key + keylen - bsize;
@@ -92,7 +92,7 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
 
 	/* initialize optimization table */
 	for (i = 0; i < 128; i++) {
-		setbit128_bbe(&tmp, i);
+		lrw_setbit128_bbe(&tmp, i);
 		ctx->mulinc[i] = tmp;
 		gf128mul_64k_bbe(&ctx->mulinc[i], ctx->table);
 	}
@@ -108,10 +108,10 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
  * For example:
  *
  * u32 counter[4] = { 0xFFFFFFFF, 0x1, 0x0, 0x0 };
- * int i = next_index(&counter);
+ * int i = lrw_next_index(&counter);
  * // i == 33, counter == { 0x0, 0x2, 0x0, 0x0 }
  */
-static int next_index(u32 *counter)
+static int lrw_next_index(u32 *counter)
 {
 	int i, res = 0;
 
@@ -135,14 +135,14 @@ static int next_index(u32 *counter)
  * We compute the tweak masks twice (both before and after the ECB encryption or
  * decryption) to avoid having to allocate a temporary buffer and/or make
  * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
- * just doing the next_index() calls again.
+ * just doing the lrw_next_index() calls again.
  */
-static int xor_tweak(struct skcipher_request *req, bool second_pass)
+static int lrw_xor_tweak(struct skcipher_request *req, bool second_pass)
 {
 	const int bs = LRW_BLOCK_SIZE;
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct priv *ctx = crypto_skcipher_ctx(tfm);
-	struct rctx *rctx = skcipher_request_ctx(req);
+	const struct lrw_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct lrw_request_ctx *rctx = skcipher_request_ctx(req);
 	be128 t = rctx->t;
 	struct skcipher_walk w;
 	__be32 *iv;
@@ -178,7 +178,8 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 
 			/* T <- I*Key2, using the optimization
 			 * discussed in the specification */
-			be128_xor(&t, &t, &ctx->mulinc[next_index(counter)]);
+			be128_xor(&t, &t,
+				  &ctx->mulinc[lrw_next_index(counter)]);
 		} while ((avail -= bs) >= bs);
 
 		if (second_pass && w.nbytes == w.total) {
@@ -194,38 +195,40 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 	return err;
 }
 
-static int xor_tweak_pre(struct skcipher_request *req)
+static int lrw_xor_tweak_pre(struct skcipher_request *req)
 {
-	return xor_tweak(req, false);
+	return lrw_xor_tweak(req, false);
 }
 
-static int xor_tweak_post(struct skcipher_request *req)
+static int lrw_xor_tweak_post(struct skcipher_request *req)
 {
-	return xor_tweak(req, true);
+	return lrw_xor_tweak(req, true);
 }
 
-static void crypt_done(struct crypto_async_request *areq, int err)
+static void lrw_crypt_done(struct crypto_async_request *areq, int err)
 {
 	struct skcipher_request *req = areq->data;
 
 	if (!err) {
-		struct rctx *rctx = skcipher_request_ctx(req);
+		struct lrw_request_ctx *rctx = skcipher_request_ctx(req);
 
 		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-		err = xor_tweak_post(req);
+		err = lrw_xor_tweak_post(req);
 	}
 
 	skcipher_request_complete(req, err);
 }
 
-static void init_crypt(struct skcipher_request *req)
+static void lrw_init_crypt(struct skcipher_request *req)
 {
-	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct rctx *rctx = skcipher_request_ctx(req);
+	const struct lrw_tfm_ctx *ctx =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	struct lrw_request_ctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 
 	skcipher_request_set_tfm(subreq, ctx->child);
-	skcipher_request_set_callback(subreq, req->base.flags, crypt_done, req);
+	skcipher_request_set_callback(subreq, req->base.flags, lrw_crypt_done,
+				      req);
 	/* pass req->iv as IV (will be used by xor_tweak, ECB will ignore it) */
 	skcipher_request_set_crypt(subreq, req->dst, req->dst,
 				   req->cryptlen, req->iv);
@@ -237,33 +240,33 @@ static void init_crypt(struct skcipher_request *req)
 	gf128mul_64k_bbe(&rctx->t, ctx->table);
 }
 
-static int encrypt(struct skcipher_request *req)
+static int lrw_encrypt(struct skcipher_request *req)
 {
-	struct rctx *rctx = skcipher_request_ctx(req);
+	struct lrw_request_ctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 
-	init_crypt(req);
-	return xor_tweak_pre(req) ?:
+	lrw_init_crypt(req);
+	return lrw_xor_tweak_pre(req) ?:
 		crypto_skcipher_encrypt(subreq) ?:
-		xor_tweak_post(req);
+		lrw_xor_tweak_post(req);
 }
 
-static int decrypt(struct skcipher_request *req)
+static int lrw_decrypt(struct skcipher_request *req)
 {
-	struct rctx *rctx = skcipher_request_ctx(req);
+	struct lrw_request_ctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 
-	init_crypt(req);
-	return xor_tweak_pre(req) ?:
+	lrw_init_crypt(req);
+	return lrw_xor_tweak_pre(req) ?:
 		crypto_skcipher_decrypt(subreq) ?:
-		xor_tweak_post(req);
+		lrw_xor_tweak_post(req);
 }
 
-static int init_tfm(struct crypto_skcipher *tfm)
+static int lrw_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
 	struct crypto_skcipher_spawn *spawn = skcipher_instance_ctx(inst);
-	struct priv *ctx = crypto_skcipher_ctx(tfm);
+	struct lrw_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *cipher;
 
 	cipher = crypto_spawn_skcipher(spawn);
@@ -273,27 +276,27 @@ static int init_tfm(struct crypto_skcipher *tfm)
 	ctx->child = cipher;
 
 	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(cipher) +
-					 sizeof(struct rctx));
+					 sizeof(struct lrw_request_ctx));
 
 	return 0;
 }
 
-static void exit_tfm(struct crypto_skcipher *tfm)
+static void lrw_exit_tfm(struct crypto_skcipher *tfm)
 {
-	struct priv *ctx = crypto_skcipher_ctx(tfm);
+	struct lrw_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	if (ctx->table)
 		gf128mul_free_64k(ctx->table);
 	crypto_free_skcipher(ctx->child);
 }
 
-static void crypto_lrw_free(struct skcipher_instance *inst)
+static void lrw_free_instance(struct skcipher_instance *inst)
 {
 	crypto_drop_skcipher(skcipher_instance_ctx(inst));
 	kfree(inst);
 }
 
-static int create(struct crypto_template *tmpl, struct rtattr **tb)
+static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct crypto_skcipher_spawn *spawn;
 	struct skcipher_instance *inst;
@@ -384,43 +387,43 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg) +
 				LRW_BLOCK_SIZE;
 
-	inst->alg.base.cra_ctxsize = sizeof(struct priv);
+	inst->alg.base.cra_ctxsize = sizeof(struct lrw_tfm_ctx);
 
-	inst->alg.init = init_tfm;
-	inst->alg.exit = exit_tfm;
+	inst->alg.init = lrw_init_tfm;
+	inst->alg.exit = lrw_exit_tfm;
 
-	inst->alg.setkey = setkey;
-	inst->alg.encrypt = encrypt;
-	inst->alg.decrypt = decrypt;
+	inst->alg.setkey = lrw_setkey;
+	inst->alg.encrypt = lrw_encrypt;
+	inst->alg.decrypt = lrw_decrypt;
 
-	inst->free = crypto_lrw_free;
+	inst->free = lrw_free_instance;
 
 	err = skcipher_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		crypto_lrw_free(inst);
+		lrw_free_instance(inst);
 	}
 	return err;
 }
 
-static struct crypto_template crypto_tmpl = {
+static struct crypto_template lrw_tmpl = {
 	.name = "lrw",
-	.create = create,
+	.create = lrw_create,
 	.module = THIS_MODULE,
 };
 
-static int __init crypto_module_init(void)
+static int __init lrw_module_init(void)
 {
-	return crypto_register_template(&crypto_tmpl);
+	return crypto_register_template(&lrw_tmpl);
 }
 
-static void __exit crypto_module_exit(void)
+static void __exit lrw_module_exit(void)
 {
-	crypto_unregister_template(&crypto_tmpl);
+	crypto_unregister_template(&lrw_tmpl);
 }
 
-subsys_initcall(crypto_module_init);
-module_exit(crypto_module_exit);
+subsys_initcall(lrw_module_init);
+module_exit(lrw_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("LRW block cipher mode");
-- 
2.27.0

