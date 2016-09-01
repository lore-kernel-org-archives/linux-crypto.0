From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AF_ALG zero-size hash fails
Date: Thu, 1 Sep 2016 17:16:44 +0800
Message-ID: <20160901091644.GA2784@gondor.apana.org.au>
References: <20160809091834.GH1041@n2100.armlinux.org.uk>
 <20160809094525.GA6529@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: noloader@gmail.com, linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49728 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbcIAJQy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2016 05:16:54 -0400
Content-Disposition: inline
In-Reply-To: <20160809094525.GA6529@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 09, 2016 at 05:45:25PM +0800, Herbert Xu wrote:
>
> > tested with the Freescale CAAM driver with SHA1 and MD5 hashes, and
> > the ARM SHA1 shash implementation.  Should there at least be a single
> > write to the socket (of zero size) in this case, or should the kernel
> > return the correct hash on the first read without a preceding
> > write/send?
> 
> It's an oversight in the algif_hash code.  I'll get it fixed.

---8<---
Subject: crypto: algif_hash - Handle NULL hashes correctly

Right now attempting to read an empty hash simply returns zeroed
bytes, this patch corrects this by calling the digest function
using an empty input.

Reported-by: Russell King - ARM Linux <linux@armlinux.org.uk>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 68a5cea..2d8466f 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -39,6 +39,37 @@ struct algif_hash_tfm {
 	bool has_key;
 };
 
+static int hash_alloc_result(struct sock *sk, struct hash_ctx *ctx)
+{
+	unsigned ds;
+
+	if (ctx->result)
+		return 0;
+
+	ds = crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req));
+
+	ctx->result = sock_kmalloc(sk, ds, GFP_KERNEL);
+	if (!ctx->result)
+		return -ENOMEM;
+
+	memset(ctx->result, 0, ds);
+
+	return 0;
+}
+
+static void hash_free_result(struct sock *sk, struct hash_ctx *ctx)
+{
+	unsigned ds;
+
+	if (!ctx->result)
+		return;
+
+	ds = crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req));
+
+	sock_kzfree_s(sk, ctx->result, ds);
+	ctx->result = NULL;
+}
+
 static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 			size_t ignored)
 {
@@ -54,6 +85,9 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	lock_sock(sk);
 	if (!ctx->more) {
+		if ((msg->msg_flags & MSG_MORE))
+			hash_free_result(sk, ctx);
+
 		err = af_alg_wait_for_completion(crypto_ahash_init(&ctx->req),
 						&ctx->completion);
 		if (err)
@@ -90,6 +124,10 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	ctx->more = msg->msg_flags & MSG_MORE;
 	if (!ctx->more) {
+		err = hash_alloc_result(sk, ctx);
+		if (err)
+			goto unlock;
+
 		ahash_request_set_crypt(&ctx->req, NULL, ctx->result, 0);
 		err = af_alg_wait_for_completion(crypto_ahash_final(&ctx->req),
 						 &ctx->completion);
@@ -116,6 +154,13 @@ static ssize_t hash_sendpage(struct socket *sock, struct page *page,
 	sg_init_table(ctx->sgl.sg, 1);
 	sg_set_page(ctx->sgl.sg, page, size, offset);
 
+	if (!(flags & MSG_MORE)) {
+		err = hash_alloc_result(sk, ctx);
+		if (err)
+			goto unlock;
+	} else if (!ctx->more)
+		hash_free_result(sk, ctx);
+
 	ahash_request_set_crypt(&ctx->req, ctx->sgl.sg, ctx->result, size);
 
 	if (!(flags & MSG_MORE)) {
@@ -153,6 +198,7 @@ static int hash_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	struct alg_sock *ask = alg_sk(sk);
 	struct hash_ctx *ctx = ask->private;
 	unsigned ds = crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req));
+	bool result;
 	int err;
 
 	if (len > ds)
@@ -161,17 +207,29 @@ static int hash_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		msg->msg_flags |= MSG_TRUNC;
 
 	lock_sock(sk);
+	result = ctx->result;
+	err = hash_alloc_result(sk, ctx);
+	if (err)
+		goto unlock;
+
+	ahash_request_set_crypt(&ctx->req, NULL, ctx->result, 0);
+
 	if (ctx->more) {
 		ctx->more = 0;
-		ahash_request_set_crypt(&ctx->req, NULL, ctx->result, 0);
 		err = af_alg_wait_for_completion(crypto_ahash_final(&ctx->req),
 						 &ctx->completion);
 		if (err)
 			goto unlock;
+	} else if (!result) {
+		err = af_alg_wait_for_completion(
+				crypto_ahash_digest(&ctx->req),
+				&ctx->completion);
 	}
 
 	err = memcpy_to_msg(msg, ctx->result, len);
 
+	hash_free_result(sk, ctx);
+
 unlock:
 	release_sock(sk);
 
@@ -394,8 +452,7 @@ static void hash_sock_destruct(struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	struct hash_ctx *ctx = ask->private;
 
-	sock_kzfree_s(sk, ctx->result,
-		      crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req)));
+	hash_free_result(sk, ctx);
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
 }
@@ -407,20 +464,12 @@ static int hash_accept_parent_nokey(void *private, struct sock *sk)
 	struct algif_hash_tfm *tfm = private;
 	struct crypto_ahash *hash = tfm->hash;
 	unsigned len = sizeof(*ctx) + crypto_ahash_reqsize(hash);
-	unsigned ds = crypto_ahash_digestsize(hash);
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	ctx->result = sock_kmalloc(sk, ds, GFP_KERNEL);
-	if (!ctx->result) {
-		sock_kfree_s(sk, ctx, len);
-		return -ENOMEM;
-	}
-
-	memset(ctx->result, 0, ds);
-
+	ctx->result = NULL;
 	ctx->len = len;
 	ctx->more = 0;
 	af_alg_init_completion(&ctx->completion);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
