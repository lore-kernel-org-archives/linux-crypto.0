From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/4] crypto: algif_hash - Remove custom release parent
 function
Date: Wed, 13 Jan 2016 15:00:36 +0800
Message-ID: <20160113070036.GB8169@gondor.apana.org.au>
References: <CACT4Y+YP0Ppj41P9mX1SPSEXkV=ffe0vuK1Ap7r0Ub8GROD5nQ@mail.gmail.com>
 <20160113065729.GA8123@gondor.apana.org.au>
 <20160113065903.GA8169@gondor.apana.org.au>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39015 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbcAMHAj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2016 02:00:39 -0500
Content-Disposition: inline
In-Reply-To: <20160113065903.GA8169@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes the custom release parent function as the
generic af_alg_release_parent now works for nokey sockets too.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 46637be..3653ab6 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -384,7 +384,7 @@ static int hash_setkey(void *private, const u8 *key, unsigned int keylen)
 	return err;
 }
 
-static void hash_sock_destruct_common(struct sock *sk)
+static void hash_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct hash_ctx *ctx = ask->private;
@@ -392,33 +392,10 @@ static void hash_sock_destruct_common(struct sock *sk)
 	sock_kzfree_s(sk, ctx->result,
 		      crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req)));
 	sock_kfree_s(sk, ctx, ctx->len);
-}
-
-static void hash_sock_destruct(struct sock *sk)
-{
-	hash_sock_destruct_common(sk);
-	af_alg_release_parent(sk);
-}
-
-static void hash_release_parent_nokey(struct sock *sk)
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
 
-static void hash_sock_destruct_nokey(struct sock *sk)
-{
-	hash_sock_destruct_common(sk);
-	hash_release_parent_nokey(sk);
-}
-
-static int hash_accept_parent_common(void *private, struct sock *sk)
+static int hash_accept_parent_nokey(void *private, struct sock *sk)
 {
 	struct hash_ctx *ctx;
 	struct alg_sock *ask = alg_sk(sk);
@@ -461,21 +438,7 @@ static int hash_accept_parent(void *private, struct sock *sk)
 	if (!tfm->has_key && crypto_ahash_has_setkey(tfm->hash))
 		return -ENOKEY;
 
-	return hash_accept_parent_common(private, sk);
-}
-
-static int hash_accept_parent_nokey(void *private, struct sock *sk)
-{
-	int err;
-
-	err = hash_accept_parent_common(private, sk);
-	if (err)
-		goto out;
-
-	sk->sk_destruct = hash_sock_destruct_nokey;
-
-out:
-	return err;
+	return hash_accept_parent_nokey(private, sk);
 }
 
 static const struct af_alg_type algif_type_hash = {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
