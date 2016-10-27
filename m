From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 11/18] crypto: algif_skcipher - Remove custom release parent function
Date: Thu, 27 Oct 2016 17:29:44 +0300
Message-ID: <1477578591-28924-12-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit d7b65aee1e7b4c87922b0232eaba56a8a143a4a0 upstream.

This patch removes the custom release parent function as the
generic af_alg_release_parent now works for nokey sockets too.

Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/algif_skcipher.c | 43 +++----------------------------------------
 1 file changed, 3 insertions(+), 40 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 4677a45..a7800b7 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -681,7 +681,7 @@ static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
 	return err;
 }
 
-static void skcipher_sock_destruct_common(struct sock *sk)
+static void skcipher_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
@@ -690,33 +690,10 @@ static void skcipher_sock_destruct_common(struct sock *sk)
 	skcipher_free_sgl(sk);
 	sock_kfree_s(sk, ctx->iv, crypto_ablkcipher_ivsize(tfm));
 	sock_kfree_s(sk, ctx, ctx->len);
-}
-
-static void skcipher_sock_destruct(struct sock *sk)
-{
-	skcipher_sock_destruct_common(sk);
-	af_alg_release_parent(sk);
-}
-
-static void skcipher_release_parent_nokey(struct sock *sk)
-{
-	struct alg_sock *ask = alg_sk(sk);
-
-	if (!ask->refcnt) {
-		sock_put(ask->parent);
-		return;
-	}
-
 	af_alg_release_parent(sk);
 }
 
-static void skcipher_sock_destruct_nokey(struct sock *sk)
-{
-	skcipher_sock_destruct_common(sk);
-	skcipher_release_parent_nokey(sk);
-}
-
-static int skcipher_accept_parent_common(void *private, struct sock *sk)
+static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 {
 	struct skcipher_ctx *ctx;
 	struct alg_sock *ask = alg_sk(sk);
@@ -762,21 +739,7 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 	if (!tfm->has_key && crypto_ablkcipher_has_setkey(tfm->skcipher))
 		return -ENOKEY;
 
-	return skcipher_accept_parent_common(private, sk);
-}
-
-static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
-{
-	int err;
-
-	err = skcipher_accept_parent_common(private, sk);
-	if (err)
-		goto out;
-
-	sk->sk_destruct = skcipher_sock_destruct_nokey;
-
-out:
-	return err;
+	return skcipher_accept_parent_nokey(private, sk);
 }
 
 static const struct af_alg_type algif_type_skcipher = {
-- 
2.7.3
