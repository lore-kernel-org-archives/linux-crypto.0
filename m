From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: GPF in lrw_crypt
Date: Thu, 24 Dec 2015 17:39:02 +0800
Message-ID: <20151224093902.GA8235@gondor.apana.org.au>
References: <CACT4Y+aE-pNUnCLbDQkFQ9Y7QivN_g6hEuS7t1RpknPHFmHg+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Kees Cook <keescook@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42855 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbbLXJjO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Dec 2015 04:39:14 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+aE-pNUnCLbDQkFQ9Y7QivN_g6hEuS7t1RpknPHFmHg+g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 17, 2015 at 01:59:11PM +0100, Dmitry Vyukov wrote:
> 
> The following program causes GPF in lrw_crypt:

OK, this is a result of certain implementations (such as lrw)
not coping with there being no key gracefully.

I think the easiest way is probably to check this in algif_skcipher.

---8<---
Subject: crypto: algif_skcipher - Require setkey before accept(2)

Some cipher implementations will crash if you try to use them
without calling setkey first.  This patch adds a check so that
the accept(2) call will fail with -ENOKEY if setkey hasn't been
done on the socket yet.

Cc: stable@vger.kernel.org
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 5c756b3..b62c973 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -31,6 +31,11 @@ struct skcipher_sg_list {
 	struct scatterlist sg[0];
 };
 
+struct skcipher_tfm {
+	struct crypto_skcipher *skcipher;
+	bool has_key;
+};
+
 struct skcipher_ctx {
 	struct list_head tsgl;
 	struct af_alg_sgl rsgl;
@@ -750,17 +755,38 @@ static struct proto_ops algif_skcipher_ops = {
 
 static void *skcipher_bind(const char *name, u32 type, u32 mask)
 {
-	return crypto_alloc_skcipher(name, type, mask);
+	struct skcipher_tfm *tfm;
+
+	tfm = kzalloc(sizeof(*tfm), GFP_KERNEL);
+	if (!tfm)
+		return ERR_PTR(-ENOMEM);
+
+	tfm->skcipher = crypto_alloc_skcipher(name, type, mask);
+	if (IS_ERR(tfm->skcipher)) {
+		kfree(tfm);
+		return ERR_CAST(tfm->skcipher);
+	}
+
+	return tfm;
 }
 
 static void skcipher_release(void *private)
 {
-	crypto_free_skcipher(private);
+	struct skcipher_tfm *tfm = private;
+
+	crypto_free_skcipher(tfm->skcipher);
+	kfree(tfm);
 }
 
 static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
 {
-	return crypto_skcipher_setkey(private, key, keylen);
+	struct skcipher_tfm *tfm = private;
+	int err;
+
+	err = crypto_skcipher_setkey(tfm->skcipher, key, keylen);
+	tfm->has_key = !err;
+
+	return err;
 }
 
 static void skcipher_wait(struct sock *sk)
@@ -792,20 +818,25 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 {
 	struct skcipher_ctx *ctx;
 	struct alg_sock *ask = alg_sk(sk);
-	unsigned int len = sizeof(*ctx) + crypto_skcipher_reqsize(private);
+	struct skcipher_tfm *tfm = private;
+	struct crypto_skcipher *skcipher = tfm->skcipher;
+	unsigned int len = sizeof(*ctx) + crypto_skcipher_reqsize(skcipher);
+
+	if (!tfm->has_key)
+		return -ENOKEY;
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(private),
+	ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(skcipher),
 			       GFP_KERNEL);
 	if (!ctx->iv) {
 		sock_kfree_s(sk, ctx, len);
 		return -ENOMEM;
 	}
 
-	memset(ctx->iv, 0, crypto_skcipher_ivsize(private));
+	memset(ctx->iv, 0, crypto_skcipher_ivsize(skcipher));
 
 	INIT_LIST_HEAD(&ctx->tsgl);
 	ctx->len = len;
@@ -818,7 +849,7 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 
 	ask->private = ctx;
 
-	skcipher_request_set_tfm(&ctx->req, private);
+	skcipher_request_set_tfm(&ctx->req, skcipher);
 	skcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      af_alg_complete, &ctx->completion);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
