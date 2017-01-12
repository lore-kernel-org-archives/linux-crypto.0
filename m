From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [RFC PATCH 3/6] crypto: cryptd - Add skcipher bulk request support
Date: Thu, 12 Jan 2017 13:59:55 +0100
Message-ID: <f51bbe0b147af37b4c3625d0e5b468e117e1041a.1484215956.git.omosnacek@gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35794 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbdALNAu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 08:00:50 -0500
Received: by mail-wm0-f67.google.com with SMTP id l2so3529536wml.2
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2017 05:00:50 -0800 (PST)
In-Reply-To: <cover.1484215956.git.omosnacek@gmail.com>
In-Reply-To: <cover.1484215956.git.omosnacek@gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds proper support for the new bulk requests to cryptd.

Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
---
 crypto/cryptd.c | 111 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 0508c48..b7d6e13 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -555,6 +555,114 @@ static int cryptd_skcipher_decrypt_enqueue(struct skcipher_request *req)
 	return cryptd_skcipher_enqueue(req, cryptd_skcipher_decrypt);
 }
 
+static void cryptd_skcipher_bulk_complete(struct skcipher_bulk_request *req,
+					  int err)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct cryptd_skcipher_request_ctx *rctx =
+			skcipher_bulk_request_ctx(req);
+	int refcnt = atomic_read(&ctx->refcnt);
+
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+
+	if (err != -EINPROGRESS && refcnt && atomic_dec_and_test(&ctx->refcnt))
+		crypto_free_skcipher(tfm);
+}
+
+static void cryptd_skcipher_bulk_encrypt(struct crypto_async_request *base,
+					 int err)
+{
+	struct skcipher_bulk_request *req = skcipher_bulk_request_cast(base);
+	struct cryptd_skcipher_request_ctx *rctx =
+			skcipher_bulk_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child = ctx->child;
+	SKCIPHER_BULK_REQUEST_ON_STACK(subreq, req->maxmsgs, child);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	skcipher_bulk_request_set_tfm(subreq, child);
+	skcipher_bulk_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
+					   NULL, NULL);
+	skcipher_bulk_request_set_crypt(subreq, req->src, req->dst, req->nmsgs,
+					req->msgsize, req->msgsizes, req->ivs);
+
+	err = crypto_skcipher_encrypt_bulk(subreq);
+	skcipher_bulk_request_zero(subreq);
+
+	req->base.complete = rctx->complete;
+
+out:
+	cryptd_skcipher_bulk_complete(req, err);
+}
+
+static void cryptd_skcipher_bulk_decrypt(struct crypto_async_request *base,
+					 int err)
+{
+	struct skcipher_bulk_request *req = skcipher_bulk_request_cast(base);
+	struct cryptd_skcipher_request_ctx *rctx =
+			skcipher_bulk_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child = ctx->child;
+	SKCIPHER_BULK_REQUEST_ON_STACK(subreq, req->maxmsgs, child);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	skcipher_bulk_request_set_tfm(subreq, child);
+	skcipher_bulk_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
+					   NULL, NULL);
+	skcipher_bulk_request_set_crypt(subreq, req->src, req->dst, req->nmsgs,
+					req->msgsize, req->msgsizes, req->ivs);
+
+	err = crypto_skcipher_decrypt_bulk(subreq);
+	skcipher_bulk_request_zero(subreq);
+
+	req->base.complete = rctx->complete;
+
+out:
+	cryptd_skcipher_bulk_complete(req, err);
+}
+
+static int cryptd_skcipher_bulk_enqueue(struct skcipher_bulk_request *req,
+					crypto_completion_t compl)
+{
+	struct cryptd_skcipher_request_ctx *rctx =
+			skcipher_bulk_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	struct cryptd_queue *queue;
+
+	queue = cryptd_get_queue(crypto_skcipher_tfm(tfm));
+	rctx->complete = req->base.complete;
+	req->base.complete = compl;
+
+	return cryptd_enqueue_request(queue, &req->base);
+}
+
+static int cryptd_skcipher_bulk_encrypt_enqueue(
+		struct skcipher_bulk_request *req)
+{
+	return cryptd_skcipher_bulk_enqueue(req, cryptd_skcipher_bulk_encrypt);
+}
+
+static int cryptd_skcipher_bulk_decrypt_enqueue(
+		struct skcipher_bulk_request *req)
+{
+	return cryptd_skcipher_bulk_enqueue(req, cryptd_skcipher_bulk_decrypt);
+}
+
+static unsigned int cryptd_skcipher_bulk_reqsize(struct crypto_skcipher *tfm,
+						 unsigned int maxmsgs)
+{
+	return sizeof(struct cryptd_skcipher_request_ctx);
+}
+
 static int cryptd_skcipher_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
@@ -641,6 +749,9 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 	inst->alg.setkey = cryptd_skcipher_setkey;
 	inst->alg.encrypt = cryptd_skcipher_encrypt_enqueue;
 	inst->alg.decrypt = cryptd_skcipher_decrypt_enqueue;
+	inst->alg.encrypt_bulk = cryptd_skcipher_bulk_encrypt_enqueue;
+	inst->alg.decrypt_bulk = cryptd_skcipher_bulk_decrypt_enqueue;
+	inst->alg.reqsize_bulk = cryptd_skcipher_bulk_reqsize;
 
 	inst->free = cryptd_skcipher_free;
 
-- 
2.9.3
