From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 1/4]     crypto: algif_skcipher - Require setkey before accept(2)
Date: Fri, 26 Feb 2016 12:44:08 +0100
Message-ID: <1456487051-14652-1-git-send-email-gmazyland@gmail.com>
References: <56D0361B.8040301@gmail.com>
Cc: stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <56D0361B.8040301@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

    commit dd504589577d8e8e70f51f997ad487a4cb6c026f upstream.

    Some cipher implementations will crash if you try to use them
    without calling setkey first.  This patch adds a check so that
    the accept(2) call will fail with -ENOKEY if setkey hasn't been
    done on the socket yet.

    Cc: stable@vger.kernel.org
    Reported-by: Dmitry Vyukov <dvyukov@google.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
    Tested-by: Dmitry Vyukov <dvyukov@google.com>
    [backported to 4.1 by Milan Broz <gmazyland@gmail.com>]
---
 crypto/algif_skcipher.c | 48 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 5bc42f9..1c9879d 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -31,6 +31,11 @@ struct skcipher_sg_list {
 	struct scatterlist sg[0];
 };
 
+struct skcipher_tfm {
+	struct crypto_ablkcipher *skcipher;
+	bool has_key;
+};
+
 struct skcipher_ctx {
 	struct list_head tsgl;
 	struct af_alg_sgl rsgl;
@@ -752,17 +757,41 @@ static struct proto_ops algif_skcipher_ops = {
 
 static void *skcipher_bind(const char *name, u32 type, u32 mask)
 {
-	return crypto_alloc_ablkcipher(name, type, mask);
+	struct skcipher_tfm *tfm;
+	struct crypto_ablkcipher *skcipher;
+
+	tfm = kzalloc(sizeof(*tfm), GFP_KERNEL);
+	if (!tfm)
+		return ERR_PTR(-ENOMEM);
+
+	skcipher = crypto_alloc_ablkcipher(name, type, mask);
+	if (IS_ERR(skcipher)) {
+		kfree(tfm);
+		return ERR_CAST(skcipher);
+	}
+
+	tfm->skcipher = skcipher;
+
+	return tfm;
 }
 
 static void skcipher_release(void *private)
 {
-	crypto_free_ablkcipher(private);
+	struct skcipher_tfm *tfm = private;
+
+	crypto_free_ablkcipher(tfm->skcipher);
+	kfree(tfm);
 }
 
 static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
 {
-	return crypto_ablkcipher_setkey(private, key, keylen);
+	struct skcipher_tfm *tfm = private;
+	int err;
+
+	err = crypto_ablkcipher_setkey(tfm->skcipher, key, keylen);
+	tfm->has_key = !err;
+
+	return err;
 }
 
 static void skcipher_wait(struct sock *sk)
@@ -794,20 +823,25 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 {
 	struct skcipher_ctx *ctx;
 	struct alg_sock *ask = alg_sk(sk);
-	unsigned int len = sizeof(*ctx) + crypto_ablkcipher_reqsize(private);
+	struct skcipher_tfm *tfm = private;
+	struct crypto_ablkcipher *skcipher = tfm->skcipher;
+	unsigned int len = sizeof(*ctx) + crypto_ablkcipher_reqsize(skcipher);
+
+	if (!tfm->has_key)
+		return -ENOKEY;
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	ctx->iv = sock_kmalloc(sk, crypto_ablkcipher_ivsize(private),
+	ctx->iv = sock_kmalloc(sk, crypto_ablkcipher_ivsize(skcipher),
 			       GFP_KERNEL);
 	if (!ctx->iv) {
 		sock_kfree_s(sk, ctx, len);
 		return -ENOMEM;
 	}
 
-	memset(ctx->iv, 0, crypto_ablkcipher_ivsize(private));
+	memset(ctx->iv, 0, crypto_ablkcipher_ivsize(skcipher));
 
 	INIT_LIST_HEAD(&ctx->tsgl);
 	ctx->len = len;
@@ -820,7 +854,7 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 
 	ask->private = ctx;
 
-	ablkcipher_request_set_tfm(&ctx->req, private);
+	ablkcipher_request_set_tfm(&ctx->req, skcipher);
 	ablkcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 					af_alg_complete, &ctx->completion);
 
-- 
2.7.0
