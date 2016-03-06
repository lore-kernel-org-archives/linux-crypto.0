From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 3/3] crypto: algif_aead - modify algif aead interface to
 work with encauth
Date: Sat, 05 Mar 2016 17:21:01 -0800
Message-ID: <20160306012101.6369.53273.stgit@tstruk-mobl1>
References: <20160306012044.6369.63924.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56825 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbcCFBZf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Mar 2016 20:25:35 -0500
In-Reply-To: <20160306012044.6369.63924.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Updates to algif_aead to allow it to work with the new TLS authentication
mode. This patch is generated on top of the algif_aead async patch:
https://patchwork.kernel.org/patch/8182971/

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/algif_aead.c |   93 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 79 insertions(+), 14 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 47d4f71..2d53054 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -26,7 +26,7 @@
 
 struct aead_sg_list {
 	unsigned int cur;
-	struct scatterlist sg[ALG_MAX_PAGES];
+	struct scatterlist sg[ALG_MAX_PAGES + 1];
 };
 
 struct aead_async_rsgl {
@@ -40,6 +40,7 @@ struct aead_async_req {
 	struct list_head list;
 	struct kiocb *iocb;
 	unsigned int tsgls;
+	bool padded;
 	char iv[];
 };
 
@@ -49,6 +50,7 @@ struct aead_ctx {
 	struct list_head list;
 
 	void *iv;
+	void *padd;
 
 	struct af_alg_completion completion;
 
@@ -58,6 +60,7 @@ struct aead_ctx {
 	bool more;
 	bool merge;
 	bool enc;
+	bool type;
 
 	size_t aead_assoclen;
 	struct aead_request aead_req;
@@ -88,7 +91,7 @@ static void aead_reset_ctx(struct aead_ctx *ctx)
 {
 	struct aead_sg_list *sgl = &ctx->tsgl;
 
-	sg_init_table(sgl->sg, ALG_MAX_PAGES);
+	sg_init_table(sgl->sg, ALG_MAX_PAGES + 1);
 	sgl->cur = 0;
 	ctx->used = 0;
 	ctx->more = 0;
@@ -191,6 +194,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct af_alg_control con = {};
 	long copied = 0;
 	bool enc = 0;
+	bool type = 0;
 	bool init = 0;
 	int err = -EINVAL;
 
@@ -211,6 +215,15 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			return -EINVAL;
 		}
 
+		switch (con.op_type) {
+		case ALG_AEAD_IPSEC:
+		case ALG_AEAD_TLS:
+			type = con.op_type;
+			break;
+		default:
+			return -EINVAL;
+		}
+
 		if (con.iv && con.iv->ivlen != ivsize)
 			return -EINVAL;
 	}
@@ -221,6 +234,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	if (init) {
 		ctx->enc = enc;
+		ctx->type = type;
 		if (con.iv)
 			memcpy(ctx->iv, con.iv->iv, ivsize);
 
@@ -399,7 +413,8 @@ static void aead_async_cb(struct crypto_async_request *_req, int err)
 	for (i = 0; i < areq->tsgls; i++)
 		put_page(sg_page(sg + i));
 
-	sock_kfree_s(sk, areq->tsgl, sizeof(*areq->tsgl) * areq->tsgls);
+	sock_kfree_s(sk, areq->tsgl, sizeof(*areq->tsgl) *
+		     (areq->tsgls + areq->padded));
 	sock_kfree_s(sk, req, reqlen);
 	__sock_put(sk);
 	iocb->ki_complete(iocb, err, err);
@@ -417,11 +432,14 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	struct aead_sg_list *sgl = &ctx->tsgl;
 	struct aead_async_rsgl *last_rsgl = NULL, *rsgl;
 	unsigned int as = crypto_aead_authsize(tfm);
+	unsigned int bs = crypto_aead_blocksize(tfm);
 	unsigned int i, reqlen = GET_REQ_SIZE(tfm);
 	int err = -ENOMEM;
 	unsigned long used;
 	size_t outlen;
 	size_t usedpages = 0;
+	size_t paddlen = 0;
+	char *paddbuf;
 
 	lock_sock(sk);
 	if (ctx->more) {
@@ -451,17 +469,28 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 				  aead_async_cb, sk);
 	used -= ctx->aead_assoclen + (ctx->enc ? as : 0);
 
+	if (ctx->enc && ctx->type == ALG_AEAD_TLS)
+		paddlen = bs - ((used + as) % bs);
+
+	outlen += paddlen;
+	areq->padded = !!paddlen;
+
 	/* take over all tx sgls from ctx */
-	areq->tsgl = sock_kmalloc(sk, sizeof(*areq->tsgl) * sgl->cur,
-				  GFP_KERNEL);
+	areq->tsgl = sock_kmalloc(sk, sizeof(*areq->tsgl) *
+				  (sgl->cur + !!paddlen), GFP_KERNEL);
 	if (unlikely(!areq->tsgl))
 		goto free;
 
-	sg_init_table(areq->tsgl, sgl->cur);
+	sg_init_table(areq->tsgl, sgl->cur + !!paddlen);
 	for (i = 0; i < sgl->cur; i++)
 		sg_set_page(&areq->tsgl[i], sg_page(&sgl->sg[i]),
 			    sgl->sg[i].length, sgl->sg[i].offset);
 
+	if (paddlen) {
+		paddbuf = areq->iv + crypto_aead_ivsize(tfm);
+		sg_set_buf(&areq->tsgl[sgl->cur], paddbuf, paddlen);
+	}
+
 	areq->tsgls = sgl->cur;
 
 	/* create rx sgls */
@@ -530,7 +559,8 @@ free:
 			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
 	}
 	if (areq->tsgl)
-		sock_kfree_s(sk, areq->tsgl, sizeof(*areq->tsgl) * areq->tsgls);
+		sock_kfree_s(sk, areq->tsgl, sizeof(*areq->tsgl) *
+			     (areq->tsgls + !!paddlen));
 	if (req)
 		sock_kfree_s(sk, req, reqlen);
 unlock:
@@ -544,7 +574,9 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	unsigned as = crypto_aead_authsize(crypto_aead_reqtfm(&ctx->aead_req));
+	struct crypto_aead *tfm = crypto_aead_reqtfm(&ctx->aead_req);
+	unsigned as = crypto_aead_authsize(tfm);
+	unsigned bs = crypto_aead_blocksize(tfm);
 	struct aead_sg_list *sgl = &ctx->tsgl;
 	struct aead_async_rsgl *last_rsgl = NULL;
 	struct aead_async_rsgl *rsgl, *tmp;
@@ -552,6 +584,7 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 	unsigned long used = 0;
 	size_t outlen = 0;
 	size_t usedpages = 0;
+	size_t paddlen = 0;
 
 	lock_sock(sk);
 
@@ -564,10 +597,19 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 	 *
 	 * The memory structure for cipher operation has the following
 	 * structure:
+	 *
+	 * For IPSec type (authenc):
 	 *	AEAD encryption input:  assoc data || plaintext
 	 *	AEAD encryption output: cipherntext || auth tag
 	 *	AEAD decryption input:  assoc data || ciphertext || auth tag
 	 *	AEAD decryption output: plaintext
+	 *
+	 * For TLS type (encauth):
+	 *	AEAD encryption input:  assoc data || plaintext
+	 *	AEAD encryption output: ciphertext, consisting of:
+	 *				enc(plaintext || auth tag || padding)
+	 *	AEAD decryption input:  assoc data || ciphertext
+	 *	AEAD decryption output: plaintext
 	 */
 
 	if (ctx->more) {
@@ -598,6 +640,11 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 	 */
 	used -= ctx->aead_assoclen + (ctx->enc ? as : 0);
 
+	if (ctx->enc && ctx->type == ALG_AEAD_TLS)
+		paddlen = bs - ((used + as) % bs);
+
+	outlen += paddlen;
+
 	/* convert iovecs of output buffers into scatterlists */
 	while (iov_iter_count(&msg->msg_iter)) {
 		size_t seglen = min_t(size_t, iov_iter_count(&msg->msg_iter),
@@ -637,7 +684,14 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 	if (usedpages < outlen)
 		goto unlock;
 
-	sg_mark_end(sgl->sg + sgl->cur - 1);
+	if (paddlen) {
+		struct scatterlist *padd = sgl->sg + sgl->cur;
+
+		sg_set_buf(padd, ctx->padd, paddlen);
+		sg_mark_end(sgl->sg + sgl->cur);
+	} else {
+		sg_mark_end(sgl->sg + sgl->cur - 1);
+	}
 	aead_request_set_crypt(&ctx->aead_req, sgl->sg, ctx->first_rsgl.sgl.sg,
 			       used, ctx->iv);
 	aead_request_set_ad(&ctx->aead_req, ctx->aead_assoclen);
@@ -759,6 +813,7 @@ static void aead_sock_destruct(struct sock *sk)
 	WARN_ON(atomic_read(&sk->sk_refcnt) != 0);
 	aead_put_sgl(sk);
 	sock_kzfree_s(sk, ctx->iv, ivlen);
+	sock_kfree_s(sk, ctx->padd, ivlen);
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
 }
@@ -776,12 +831,16 @@ static int aead_accept_parent(void *private, struct sock *sk)
 	memset(ctx, 0, len);
 
 	ctx->iv = sock_kmalloc(sk, ivlen, GFP_KERNEL);
-	if (!ctx->iv) {
-		sock_kfree_s(sk, ctx, len);
-		return -ENOMEM;
-	}
+	if (!ctx->iv)
+		goto err_free_ctx;
+
 	memset(ctx->iv, 0, ivlen);
 
+	ctx->padd = sock_kmalloc(sk, crypto_aead_blocksize(private),
+				 GFP_KERNEL);
+	if (!ctx->padd)
+		goto err_free_iv;
+
 	ctx->len = len;
 	ctx->used = 0;
 	ctx->more = 0;
@@ -790,7 +849,7 @@ static int aead_accept_parent(void *private, struct sock *sk)
 	ctx->tsgl.cur = 0;
 	ctx->aead_assoclen = 0;
 	af_alg_init_completion(&ctx->completion);
-	sg_init_table(ctx->tsgl.sg, ALG_MAX_PAGES);
+	sg_init_table(ctx->tsgl.sg, ALG_MAX_PAGES + 1);
 	INIT_LIST_HEAD(&ctx->list);
 
 	ask->private = ctx;
@@ -802,6 +861,12 @@ static int aead_accept_parent(void *private, struct sock *sk)
 	sk->sk_destruct = aead_sock_destruct;
 
 	return 0;
+
+err_free_iv:
+	sock_kfree_s(sk, ctx->iv, len);
+err_free_ctx:
+	sock_kfree_s(sk, ctx, len);
+	return -ENOMEM;
 }
 
 static const struct af_alg_type algif_type_aead = {
