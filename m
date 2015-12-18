From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: WARNING in crypto_wait_for_test
Date: Fri, 18 Dec 2015 19:16:57 +0800
Message-ID: <20151218111657.GA21126@gondor.apana.org.au>
References: <CACT4Y+bws9Scv7o3AB2wPM0ZJAeDvO+kZ45h-p5viDk9ZAe9KQ@mail.gmail.com>
 <6672511.rbcxt2K4Lk@tauon.atsec.com>
 <20151214125219.GA1514@gondor.apana.org.au>
 <3121405.vKidzTde2R@tauon.atsec.com>
 <20151218084917.GA20345@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Vyukov <dvyukov@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39747 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbLRLRP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Dec 2015 06:17:15 -0500
Content-Disposition: inline
In-Reply-To: <20151218084917.GA20345@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 18, 2015 at 04:49:17PM +0800, Herbert Xu wrote:
> 
> OK turns out I was looking at the wrong WARN_ON line.
> 
> This particular bug is a legacy of the geniv construct we have
> for ablkcipher.
> 
> It should disappear once we remove geniv which I will do as part
> of the skcipher conversion.

This patch should fix the problem.

---8<---
Subject: crypto: algif_skcipher - Use new skcipher interface
    
This patch replaces uses of ablkcipher with the new skcipher
interface.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index bbb1b66..5c877d4 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -47,7 +47,7 @@ struct skcipher_ctx {
 	bool merge;
 	bool enc;
 
-	struct ablkcipher_request req;
+	struct skcipher_request req;
 };
 
 struct skcipher_async_rsgl {
@@ -64,13 +64,13 @@ struct skcipher_async_req {
 };
 
 #define GET_SREQ(areq, ctx) (struct skcipher_async_req *)((char *)areq + \
-	crypto_ablkcipher_reqsize(crypto_ablkcipher_reqtfm(&ctx->req)))
+	crypto_skcipher_reqsize(crypto_skcipher_reqtfm(&ctx->req)))
 
 #define GET_REQ_SIZE(ctx) \
-	crypto_ablkcipher_reqsize(crypto_ablkcipher_reqtfm(&ctx->req))
+	crypto_skcipher_reqsize(crypto_skcipher_reqtfm(&ctx->req))
 
 #define GET_IV_SIZE(ctx) \
-	crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(&ctx->req))
+	crypto_skcipher_ivsize(crypto_skcipher_reqtfm(&ctx->req))
 
 #define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
 		      sizeof(struct scatterlist) - 1)
@@ -302,8 +302,8 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(&ctx->req);
-	unsigned ivsize = crypto_ablkcipher_ivsize(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(&ctx->req);
+	unsigned ivsize = crypto_skcipher_ivsize(tfm);
 	struct skcipher_sg_list *sgl;
 	struct af_alg_control con = {};
 	long copied = 0;
@@ -507,7 +507,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	struct skcipher_sg_list *sgl;
 	struct scatterlist *sg;
 	struct skcipher_async_req *sreq;
-	struct ablkcipher_request *req;
+	struct skcipher_request *req;
 	struct skcipher_async_rsgl *last_rsgl = NULL;
 	unsigned int txbufs = 0, len = 0, tx_nents = skcipher_all_sg_nents(ctx);
 	unsigned int reqlen = sizeof(struct skcipher_async_req) +
@@ -531,9 +531,9 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	}
 	sg_init_table(sreq->tsg, tx_nents);
 	memcpy(sreq->iv, ctx->iv, GET_IV_SIZE(ctx));
-	ablkcipher_request_set_tfm(req, crypto_ablkcipher_reqtfm(&ctx->req));
-	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					skcipher_async_cb, sk);
+	skcipher_request_set_tfm(req, crypto_skcipher_reqtfm(&ctx->req));
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      skcipher_async_cb, sk);
 
 	while (iov_iter_count(&msg->msg_iter)) {
 		struct skcipher_async_rsgl *rsgl;
@@ -608,10 +608,10 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	if (mark)
 		sg_mark_end(sreq->tsg + txbufs - 1);
 
-	ablkcipher_request_set_crypt(req, sreq->tsg, sreq->first_sgl.sgl.sg,
-				     len, sreq->iv);
-	err = ctx->enc ? crypto_ablkcipher_encrypt(req) :
-			 crypto_ablkcipher_decrypt(req);
+	skcipher_request_set_crypt(req, sreq->tsg, sreq->first_sgl.sgl.sg,
+				   len, sreq->iv);
+	err = ctx->enc ? crypto_skcipher_encrypt(req) :
+			 crypto_skcipher_decrypt(req);
 	if (err == -EINPROGRESS) {
 		atomic_inc(&ctx->inflight);
 		err = -EIOCBQUEUED;
@@ -632,7 +632,7 @@ static int skcipher_recvmsg_sync(struct socket *sock, struct msghdr *msg,
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
-	unsigned bs = crypto_ablkcipher_blocksize(crypto_ablkcipher_reqtfm(
+	unsigned bs = crypto_skcipher_blocksize(crypto_skcipher_reqtfm(
 		&ctx->req));
 	struct skcipher_sg_list *sgl;
 	struct scatterlist *sg;
@@ -669,14 +669,13 @@ static int skcipher_recvmsg_sync(struct socket *sock, struct msghdr *msg,
 		if (!used)
 			goto free;
 
-		ablkcipher_request_set_crypt(&ctx->req, sg,
-					     ctx->rsgl.sg, used,
-					     ctx->iv);
+		skcipher_request_set_crypt(&ctx->req, sg, ctx->rsgl.sg, used,
+					   ctx->iv);
 
 		err = af_alg_wait_for_completion(
 				ctx->enc ?
-					crypto_ablkcipher_encrypt(&ctx->req) :
-					crypto_ablkcipher_decrypt(&ctx->req),
+					crypto_skcipher_encrypt(&ctx->req) :
+					crypto_skcipher_decrypt(&ctx->req),
 				&ctx->completion);
 
 free:
@@ -751,17 +750,17 @@ static struct proto_ops algif_skcipher_ops = {
 
 static void *skcipher_bind(const char *name, u32 type, u32 mask)
 {
-	return crypto_alloc_ablkcipher(name, type, mask);
+	return crypto_alloc_skcipher(name, type, mask);
 }
 
 static void skcipher_release(void *private)
 {
-	crypto_free_ablkcipher(private);
+	crypto_free_skcipher(private);
 }
 
 static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
 {
-	return crypto_ablkcipher_setkey(private, key, keylen);
+	return crypto_skcipher_setkey(private, key, keylen);
 }
 
 static void skcipher_wait(struct sock *sk)
@@ -778,13 +777,13 @@ static void skcipher_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(&ctx->req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(&ctx->req);
 
 	if (atomic_read(&ctx->inflight))
 		skcipher_wait(sk);
 
 	skcipher_free_sgl(sk);
-	sock_kzfree_s(sk, ctx->iv, crypto_ablkcipher_ivsize(tfm));
+	sock_kzfree_s(sk, ctx->iv, crypto_skcipher_ivsize(tfm));
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
 }
@@ -793,20 +792,20 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 {
 	struct skcipher_ctx *ctx;
 	struct alg_sock *ask = alg_sk(sk);
-	unsigned int len = sizeof(*ctx) + crypto_ablkcipher_reqsize(private);
+	unsigned int len = sizeof(*ctx) + crypto_skcipher_reqsize(private);
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	ctx->iv = sock_kmalloc(sk, crypto_ablkcipher_ivsize(private),
+	ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(private),
 			       GFP_KERNEL);
 	if (!ctx->iv) {
 		sock_kfree_s(sk, ctx, len);
 		return -ENOMEM;
 	}
 
-	memset(ctx->iv, 0, crypto_ablkcipher_ivsize(private));
+	memset(ctx->iv, 0, crypto_skcipher_ivsize(private));
 
 	INIT_LIST_HEAD(&ctx->tsgl);
 	ctx->len = len;
@@ -819,9 +818,9 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 
 	ask->private = ctx;
 
-	ablkcipher_request_set_tfm(&ctx->req, private);
-	ablkcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					af_alg_complete, &ctx->completion);
+	skcipher_request_set_tfm(&ctx->req, private);
+	skcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      af_alg_complete, &ctx->completion);
 
 	sk->sk_destruct = skcipher_sock_destruct;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
