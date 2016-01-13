From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/4] crypto: algif_skcipher - Remove custom release parent
 function
Date: Wed, 13 Jan 2016 15:01:06 +0800
Message-ID: <20160113070106.GC8169@gondor.apana.org.au>
References: <CACT4Y+YP0Ppj41P9mX1SPSEXkV=ffe0vuK1Ap7r0Ub8GROD5nQ@mail.gmail.com>
 <20160113065729.GA8123@gondor.apana.org.au>
 <20160113065903.GA8169@gondor.apana.org.au>
 <20160113070036.GB8169@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160113070036.GB8169@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch removes the custom release parent function as the
generic af_alg_release_parent now works for nokey sockets too.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 4a5bdb6..1f99d2d 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -895,7 +895,7 @@ static void skcipher_wait(struct sock *sk)
 		msleep(100);
 }
 
-static void skcipher_sock_destruct_common(struct sock *sk)
+static void skcipher_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
@@ -907,33 +907,10 @@ static void skcipher_sock_destruct_common(struct sock *sk)
 	skcipher_free_sgl(sk);
 	sock_kzfree_s(sk, ctx->iv, crypto_skcipher_ivsize(tfm));
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
@@ -981,21 +958,7 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 	if (!tfm->has_key && crypto_skcipher_has_setkey(tfm->skcipher))
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
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
