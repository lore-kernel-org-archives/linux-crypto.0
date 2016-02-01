From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 1/3] crypto: algif_skcipher - Do not assume that req is unchanged
Date: Mon, 01 Feb 2016 21:08:01 +0800
Message-ID: <E1aQED3-00022H-5o@gondolin.me.apana.org.au>
References: <20160201130644.GA6904@gondor.apana.org.au>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57907 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505AbcBANIE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 08:08:04 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The async path in algif_skcipher assumes that the crypto completion
function will be called with the original request.  This is not
necessarily the case.  In fact there is no need for this anyway
since we already embed information into the request with struct
skcipher_async_req.

This patch adds a pointer to that struct and then passes it as
the data to the callback function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algif_skcipher.c |   59 +++++++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 38c1aa8..a692e06 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -65,18 +65,10 @@ struct skcipher_async_req {
 	struct skcipher_async_rsgl first_sgl;
 	struct list_head list;
 	struct scatterlist *tsg;
-	char iv[];
+	atomic_t *inflight;
+	struct skcipher_request req;
 };
 
-#define GET_SREQ(areq, ctx) (struct skcipher_async_req *)((char *)areq + \
-	crypto_skcipher_reqsize(crypto_skcipher_reqtfm(&ctx->req)))
-
-#define GET_REQ_SIZE(ctx) \
-	crypto_skcipher_reqsize(crypto_skcipher_reqtfm(&ctx->req))
-
-#define GET_IV_SIZE(ctx) \
-	crypto_skcipher_ivsize(crypto_skcipher_reqtfm(&ctx->req))
-
 #define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
 		      sizeof(struct scatterlist) - 1)
 
@@ -102,15 +94,12 @@ static void skcipher_free_async_sgls(struct skcipher_async_req *sreq)
 
 static void skcipher_async_cb(struct crypto_async_request *req, int err)
 {
-	struct sock *sk = req->data;
-	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
-	struct skcipher_async_req *sreq = GET_SREQ(req, ctx);
+	struct skcipher_async_req *sreq = req->data;
 	struct kiocb *iocb = sreq->iocb;
 
-	atomic_dec(&ctx->inflight);
+	atomic_dec(sreq->inflight);
 	skcipher_free_async_sgls(sreq);
-	kfree(req);
+	kzfree(sreq);
 	iocb->ki_complete(iocb, err, err);
 }
 
@@ -509,37 +498,42 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
+	struct sock *psk = ask->parent;
+	struct alg_sock *pask = alg_sk(psk);
 	struct skcipher_ctx *ctx = ask->private;
+	struct skcipher_tfm *skc = pask->private;
+	struct crypto_skcipher *tfm = skc->skcipher;
 	struct skcipher_sg_list *sgl;
 	struct scatterlist *sg;
 	struct skcipher_async_req *sreq;
 	struct skcipher_request *req;
 	struct skcipher_async_rsgl *last_rsgl = NULL;
 	unsigned int txbufs = 0, len = 0, tx_nents = skcipher_all_sg_nents(ctx);
-	unsigned int reqlen = sizeof(struct skcipher_async_req) +
-				GET_REQ_SIZE(ctx) + GET_IV_SIZE(ctx);
+	unsigned int reqsize = crypto_skcipher_reqsize(tfm);
+	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	int err = -ENOMEM;
 	bool mark = false;
+	char *iv;
 
-	lock_sock(sk);
-	req = kmalloc(reqlen, GFP_KERNEL);
-	if (unlikely(!req))
-		goto unlock;
+	sreq = kzalloc(sizeof(*req) + reqsize + ivsize, GFP_KERNEL);
+	if (unlikely(!sreq))
+		goto out;
 
-	sreq = GET_SREQ(req, ctx);
+	req = &sreq->req;
+	iv = (char *)(req + 1) + reqsize;
 	sreq->iocb = msg->msg_iocb;
-	memset(&sreq->first_sgl, '\0', sizeof(struct skcipher_async_rsgl));
 	INIT_LIST_HEAD(&sreq->list);
+	sreq->inflight = &ctx->inflight;
+
+	lock_sock(sk);
 	sreq->tsg = kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);
-	if (unlikely(!sreq->tsg)) {
-		kfree(req);
+	if (unlikely(!sreq->tsg))
 		goto unlock;
-	}
 	sg_init_table(sreq->tsg, tx_nents);
-	memcpy(sreq->iv, ctx->iv, GET_IV_SIZE(ctx));
-	skcipher_request_set_tfm(req, crypto_skcipher_reqtfm(&ctx->req));
+	memcpy(iv, ctx->iv, ivsize);
+	skcipher_request_set_tfm(req, tfm);
 	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				      skcipher_async_cb, sk);
+				      skcipher_async_cb, sreq);
 
 	while (iov_iter_count(&msg->msg_iter)) {
 		struct skcipher_async_rsgl *rsgl;
@@ -615,7 +609,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 		sg_mark_end(sreq->tsg + txbufs - 1);
 
 	skcipher_request_set_crypt(req, sreq->tsg, sreq->first_sgl.sgl.sg,
-				   len, sreq->iv);
+				   len, iv);
 	err = ctx->enc ? crypto_skcipher_encrypt(req) :
 			 crypto_skcipher_decrypt(req);
 	if (err == -EINPROGRESS) {
@@ -625,10 +619,11 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	}
 free:
 	skcipher_free_async_sgls(sreq);
-	kfree(req);
 unlock:
 	skcipher_wmem_wakeup(sk);
 	release_sock(sk);
+	kzfree(sreq);
+out:
 	return err;
 }
 
