Return-Path: <SRS0=4IwG=SP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E08C10F11
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Apr 2019 04:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E561821721
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Apr 2019 04:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555129478;
	bh=SsXLDG4GNr+G1X2vfHYwg2L1Symejmx9zNtFT5KqKtc=;
	h=From:To:Subject:Date:List-ID:From;
	b=aPEZHDG6xLu/QkIa5WOa9ud0VAicI4EluIyUPv54shU3BFTz/Q/HENLf6WK6L81qu
	 2hNh3nvWCiZ9EQkiTcIKiAZ/Un+u73hRI6ImCzizY36+Zx72uV5CUo55R+fLpknqXF
	 VRv+X/jHqT3nt54w0nA01n6Fq5lhexeUIFOdv4OE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfDMEYg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Apr 2019 00:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfDMEYg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Apr 2019 00:24:36 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBFC620848;
        Sat, 13 Apr 2019 04:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555129475;
        bh=SsXLDG4GNr+G1X2vfHYwg2L1Symejmx9zNtFT5KqKtc=;
        h=From:To:Subject:Date:From;
        b=l6R2RH/k2zxenJXBZOPebONVlnjSqNUNbT204PVN9wqgc3qIJGWafv3ODU9ELJe0Y
         0uJIc/VnnlzJFCYP25ghezCl8DBe5Q8ly7z9ULASPm/t8CCSwG8/J/mvcjQ/71/q9u
         xUczf/aYn1aUNdbtgbkrLs71PBR8XeaY20P+83K8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: cryptd - remove ability to instantiate ablkciphers
Date:   Fri, 12 Apr 2019 21:23:52 -0700
Message-Id: <20190413042352.16063-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Remove cryptd_alloc_ablkcipher() and the ability of cryptd to create
algorithms with the deprecated "ablkcipher" type.

This has been unused since commit 0e145b477dea ("crypto: ablk_helper -
remove ablk_helper").  Instead, cryptd_alloc_skcipher() is used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cryptd.c         | 249 ----------------------------------------
 include/crypto/cryptd.h |  18 +--
 2 files changed, 1 insertion(+), 266 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 5640e5db7bdbf..42533cf80accf 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -65,15 +65,6 @@ struct aead_instance_ctx {
 	struct cryptd_queue *queue;
 };
 
-struct cryptd_blkcipher_ctx {
-	atomic_t refcnt;
-	struct crypto_blkcipher *child;
-};
-
-struct cryptd_blkcipher_request_ctx {
-	crypto_completion_t complete;
-};
-
 struct cryptd_skcipher_ctx {
 	atomic_t refcnt;
 	struct crypto_sync_skcipher *child;
@@ -216,129 +207,6 @@ static inline void cryptd_check_internal(struct rtattr **tb, u32 *type,
 	*mask |= algt->mask & CRYPTO_ALG_INTERNAL;
 }
 
-static int cryptd_blkcipher_setkey(struct crypto_ablkcipher *parent,
-				   const u8 *key, unsigned int keylen)
-{
-	struct cryptd_blkcipher_ctx *ctx = crypto_ablkcipher_ctx(parent);
-	struct crypto_blkcipher *child = ctx->child;
-	int err;
-
-	crypto_blkcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_blkcipher_set_flags(child, crypto_ablkcipher_get_flags(parent) &
-					  CRYPTO_TFM_REQ_MASK);
-	err = crypto_blkcipher_setkey(child, key, keylen);
-	crypto_ablkcipher_set_flags(parent, crypto_blkcipher_get_flags(child) &
-					    CRYPTO_TFM_RES_MASK);
-	return err;
-}
-
-static void cryptd_blkcipher_crypt(struct ablkcipher_request *req,
-				   struct crypto_blkcipher *child,
-				   int err,
-				   int (*crypt)(struct blkcipher_desc *desc,
-						struct scatterlist *dst,
-						struct scatterlist *src,
-						unsigned int len))
-{
-	struct cryptd_blkcipher_request_ctx *rctx;
-	struct cryptd_blkcipher_ctx *ctx;
-	struct crypto_ablkcipher *tfm;
-	struct blkcipher_desc desc;
-	int refcnt;
-
-	rctx = ablkcipher_request_ctx(req);
-
-	if (unlikely(err == -EINPROGRESS))
-		goto out;
-
-	desc.tfm = child;
-	desc.info = req->info;
-	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	err = crypt(&desc, req->dst, req->src, req->nbytes);
-
-	req->base.complete = rctx->complete;
-
-out:
-	tfm = crypto_ablkcipher_reqtfm(req);
-	ctx = crypto_ablkcipher_ctx(tfm);
-	refcnt = atomic_read(&ctx->refcnt);
-
-	local_bh_disable();
-	rctx->complete(&req->base, err);
-	local_bh_enable();
-
-	if (err != -EINPROGRESS && refcnt && atomic_dec_and_test(&ctx->refcnt))
-		crypto_free_ablkcipher(tfm);
-}
-
-static void cryptd_blkcipher_encrypt(struct crypto_async_request *req, int err)
-{
-	struct cryptd_blkcipher_ctx *ctx = crypto_tfm_ctx(req->tfm);
-	struct crypto_blkcipher *child = ctx->child;
-
-	cryptd_blkcipher_crypt(ablkcipher_request_cast(req), child, err,
-			       crypto_blkcipher_crt(child)->encrypt);
-}
-
-static void cryptd_blkcipher_decrypt(struct crypto_async_request *req, int err)
-{
-	struct cryptd_blkcipher_ctx *ctx = crypto_tfm_ctx(req->tfm);
-	struct crypto_blkcipher *child = ctx->child;
-
-	cryptd_blkcipher_crypt(ablkcipher_request_cast(req), child, err,
-			       crypto_blkcipher_crt(child)->decrypt);
-}
-
-static int cryptd_blkcipher_enqueue(struct ablkcipher_request *req,
-				    crypto_completion_t compl)
-{
-	struct cryptd_blkcipher_request_ctx *rctx = ablkcipher_request_ctx(req);
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct cryptd_queue *queue;
-
-	queue = cryptd_get_queue(crypto_ablkcipher_tfm(tfm));
-	rctx->complete = req->base.complete;
-	req->base.complete = compl;
-
-	return cryptd_enqueue_request(queue, &req->base);
-}
-
-static int cryptd_blkcipher_encrypt_enqueue(struct ablkcipher_request *req)
-{
-	return cryptd_blkcipher_enqueue(req, cryptd_blkcipher_encrypt);
-}
-
-static int cryptd_blkcipher_decrypt_enqueue(struct ablkcipher_request *req)
-{
-	return cryptd_blkcipher_enqueue(req, cryptd_blkcipher_decrypt);
-}
-
-static int cryptd_blkcipher_init_tfm(struct crypto_tfm *tfm)
-{
-	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct cryptd_instance_ctx *ictx = crypto_instance_ctx(inst);
-	struct crypto_spawn *spawn = &ictx->spawn;
-	struct cryptd_blkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_blkcipher *cipher;
-
-	cipher = crypto_spawn_blkcipher(spawn);
-	if (IS_ERR(cipher))
-		return PTR_ERR(cipher);
-
-	ctx->child = cipher;
-	tfm->crt_ablkcipher.reqsize =
-		sizeof(struct cryptd_blkcipher_request_ctx);
-	return 0;
-}
-
-static void cryptd_blkcipher_exit_tfm(struct crypto_tfm *tfm)
-{
-	struct cryptd_blkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	crypto_free_blkcipher(ctx->child);
-}
-
 static int cryptd_init_instance(struct crypto_instance *inst,
 				struct crypto_alg *alg)
 {
@@ -382,67 +250,6 @@ static void *cryptd_alloc_instance(struct crypto_alg *alg, unsigned int head,
 	goto out;
 }
 
-static int cryptd_create_blkcipher(struct crypto_template *tmpl,
-				   struct rtattr **tb,
-				   struct cryptd_queue *queue)
-{
-	struct cryptd_instance_ctx *ctx;
-	struct crypto_instance *inst;
-	struct crypto_alg *alg;
-	u32 type = CRYPTO_ALG_TYPE_BLKCIPHER;
-	u32 mask = CRYPTO_ALG_TYPE_MASK;
-	int err;
-
-	cryptd_check_internal(tb, &type, &mask);
-
-	alg = crypto_get_attr_alg(tb, type, mask);
-	if (IS_ERR(alg))
-		return PTR_ERR(alg);
-
-	inst = cryptd_alloc_instance(alg, 0, sizeof(*ctx));
-	err = PTR_ERR(inst);
-	if (IS_ERR(inst))
-		goto out_put_alg;
-
-	ctx = crypto_instance_ctx(inst);
-	ctx->queue = queue;
-
-	err = crypto_init_spawn(&ctx->spawn, alg, inst,
-				CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
-	if (err)
-		goto out_free_inst;
-
-	type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
-	if (alg->cra_flags & CRYPTO_ALG_INTERNAL)
-		type |= CRYPTO_ALG_INTERNAL;
-	inst->alg.cra_flags = type;
-	inst->alg.cra_type = &crypto_ablkcipher_type;
-
-	inst->alg.cra_ablkcipher.ivsize = alg->cra_blkcipher.ivsize;
-	inst->alg.cra_ablkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
-	inst->alg.cra_ablkcipher.max_keysize = alg->cra_blkcipher.max_keysize;
-
-	inst->alg.cra_ctxsize = sizeof(struct cryptd_blkcipher_ctx);
-
-	inst->alg.cra_init = cryptd_blkcipher_init_tfm;
-	inst->alg.cra_exit = cryptd_blkcipher_exit_tfm;
-
-	inst->alg.cra_ablkcipher.setkey = cryptd_blkcipher_setkey;
-	inst->alg.cra_ablkcipher.encrypt = cryptd_blkcipher_encrypt_enqueue;
-	inst->alg.cra_ablkcipher.decrypt = cryptd_blkcipher_decrypt_enqueue;
-
-	err = crypto_register_instance(tmpl, inst);
-	if (err) {
-		crypto_drop_spawn(&ctx->spawn);
-out_free_inst:
-		kfree(inst);
-	}
-
-out_put_alg:
-	crypto_mod_put(alg);
-	return err;
-}
-
 static int cryptd_skcipher_setkey(struct crypto_skcipher *parent,
 				  const u8 *key, unsigned int keylen)
 {
@@ -1118,10 +925,6 @@ static int cryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_BLKCIPHER:
-		if ((algt->type & CRYPTO_ALG_TYPE_MASK) ==
-		    CRYPTO_ALG_TYPE_BLKCIPHER)
-			return cryptd_create_blkcipher(tmpl, tb, &queue);
-
 		return cryptd_create_skcipher(tmpl, tb, &queue);
 	case CRYPTO_ALG_TYPE_DIGEST:
 		return cryptd_create_hash(tmpl, tb, &queue);
@@ -1160,58 +963,6 @@ static struct crypto_template cryptd_tmpl = {
 	.module = THIS_MODULE,
 };
 
-struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
-						  u32 type, u32 mask)
-{
-	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
-	struct cryptd_blkcipher_ctx *ctx;
-	struct crypto_tfm *tfm;
-
-	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
-		     "cryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
-		return ERR_PTR(-EINVAL);
-	type = crypto_skcipher_type(type);
-	mask &= ~CRYPTO_ALG_TYPE_MASK;
-	mask |= CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
-	tfm = crypto_alloc_base(cryptd_alg_name, type, mask);
-	if (IS_ERR(tfm))
-		return ERR_CAST(tfm);
-	if (tfm->__crt_alg->cra_module != THIS_MODULE) {
-		crypto_free_tfm(tfm);
-		return ERR_PTR(-EINVAL);
-	}
-
-	ctx = crypto_tfm_ctx(tfm);
-	atomic_set(&ctx->refcnt, 1);
-
-	return __cryptd_ablkcipher_cast(__crypto_ablkcipher_cast(tfm));
-}
-EXPORT_SYMBOL_GPL(cryptd_alloc_ablkcipher);
-
-struct crypto_blkcipher *cryptd_ablkcipher_child(struct cryptd_ablkcipher *tfm)
-{
-	struct cryptd_blkcipher_ctx *ctx = crypto_ablkcipher_ctx(&tfm->base);
-	return ctx->child;
-}
-EXPORT_SYMBOL_GPL(cryptd_ablkcipher_child);
-
-bool cryptd_ablkcipher_queued(struct cryptd_ablkcipher *tfm)
-{
-	struct cryptd_blkcipher_ctx *ctx = crypto_ablkcipher_ctx(&tfm->base);
-
-	return atomic_read(&ctx->refcnt) - 1;
-}
-EXPORT_SYMBOL_GPL(cryptd_ablkcipher_queued);
-
-void cryptd_free_ablkcipher(struct cryptd_ablkcipher *tfm)
-{
-	struct cryptd_blkcipher_ctx *ctx = crypto_ablkcipher_ctx(&tfm->base);
-
-	if (atomic_dec_and_test(&ctx->refcnt))
-		crypto_free_ablkcipher(&tfm->base);
-}
-EXPORT_SYMBOL_GPL(cryptd_free_ablkcipher);
-
 struct cryptd_skcipher *cryptd_alloc_skcipher(const char *alg_name,
 					      u32 type, u32 mask)
 {
diff --git a/include/crypto/cryptd.h b/include/crypto/cryptd.h
index 1e64f354c2b83..23169f4d87e63 100644
--- a/include/crypto/cryptd.h
+++ b/include/crypto/cryptd.h
@@ -18,27 +18,11 @@
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
 
-struct cryptd_ablkcipher {
-	struct crypto_ablkcipher base;
-};
-
-static inline struct cryptd_ablkcipher *__cryptd_ablkcipher_cast(
-	struct crypto_ablkcipher *tfm)
-{
-	return (struct cryptd_ablkcipher *)tfm;
-}
-
-/* alg_name should be algorithm to be cryptd-ed */
-struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
-						  u32 type, u32 mask);
-struct crypto_blkcipher *cryptd_ablkcipher_child(struct cryptd_ablkcipher *tfm);
-bool cryptd_ablkcipher_queued(struct cryptd_ablkcipher *tfm);
-void cryptd_free_ablkcipher(struct cryptd_ablkcipher *tfm);
-
 struct cryptd_skcipher {
 	struct crypto_skcipher base;
 };
 
+/* alg_name should be algorithm to be cryptd-ed */
 struct cryptd_skcipher *cryptd_alloc_skcipher(const char *alg_name,
 					      u32 type, u32 mask);
 struct crypto_skcipher *cryptd_skcipher_child(struct cryptd_skcipher *tfm);
-- 
2.21.0

