From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 2/3] crypto: algif_skcipher - Do not dereference ctx without socket lock
Date: Mon, 01 Feb 2016 21:08:02 +0800
Message-ID: <E1aQED4-00022Y-8F@gondolin.me.apana.org.au>
References: <20160201130644.GA6904@gondor.apana.org.au>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42868 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbcBANIF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 08:08:05 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Any access to non-constant bits of the private context must be
done under the socket lock, in particular, this includes ctx->req.

This patch moves such accesses under the lock, and fetches the
tfm from the parent socket which is guaranteed to be constant,
rather than from ctx->req.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algif_skcipher.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a692e06..2d549aa 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -295,8 +295,11 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
+	struct sock *psk = ask->parent;
+	struct alg_sock *pask = alg_sk(psk);
 	struct skcipher_ctx *ctx = ask->private;
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(&ctx->req);
+	struct skcipher_tfm *skc = pask->private;
+	struct crypto_skcipher *tfm = skc->skcipher;
 	unsigned ivsize = crypto_skcipher_ivsize(tfm);
 	struct skcipher_sg_list *sgl;
 	struct af_alg_control con = {};
@@ -508,7 +511,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	struct skcipher_async_req *sreq;
 	struct skcipher_request *req;
 	struct skcipher_async_rsgl *last_rsgl = NULL;
-	unsigned int txbufs = 0, len = 0, tx_nents = skcipher_all_sg_nents(ctx);
+	unsigned int txbufs = 0, len = 0, tx_nents;
 	unsigned int reqsize = crypto_skcipher_reqsize(tfm);
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	int err = -ENOMEM;
@@ -526,6 +529,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	sreq->inflight = &ctx->inflight;
 
 	lock_sock(sk);
+	tx_nents = skcipher_all_sg_nents(ctx);
 	sreq->tsg = kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);
 	if (unlikely(!sreq->tsg))
 		goto unlock;
@@ -632,9 +636,12 @@ static int skcipher_recvmsg_sync(struct socket *sock, struct msghdr *msg,
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
+	struct sock *psk = ask->parent;
+	struct alg_sock *pask = alg_sk(psk);
 	struct skcipher_ctx *ctx = ask->private;
-	unsigned bs = crypto_skcipher_blocksize(crypto_skcipher_reqtfm(
-		&ctx->req));
+	struct skcipher_tfm *skc = pask->private;
+	struct crypto_skcipher *tfm = skc->skcipher;
+	unsigned bs = crypto_skcipher_blocksize(tfm);
 	struct skcipher_sg_list *sgl;
 	struct scatterlist *sg;
 	int err = -EAGAIN;
