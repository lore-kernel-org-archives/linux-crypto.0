From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 3/4]     crypto: algif_skcipher - Remove custom release parent function
Date: Fri, 26 Feb 2016 12:44:10 +0100
Message-ID: <1456487051-14652-3-git-send-email-gmazyland@gmail.com>
References: <56D0361B.8040301@gmail.com>
 <1456487051-14652-1-git-send-email-gmazyland@gmail.com>
Cc: stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34739 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbcBZLo0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Feb 2016 06:44:26 -0500
In-Reply-To: <1456487051-14652-1-git-send-email-gmazyland@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>

    commit d7b65aee1e7b4c87922b0232eaba56a8a143a4a0 upstream.

    This patch removes the custom release parent function as the
    generic af_alg_release_parent now works for nokey sockets too.

    Cc: stable@vger.kernel.org
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algif_skcipher.c | 43 +++----------------------------------------
 1 file changed, 3 insertions(+), 40 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 566df2c..83bcf75 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -897,7 +897,7 @@ static void skcipher_wait(struct sock *sk)
 		msleep(100);
 }
 
-static void skcipher_sock_destruct_common(struct sock *sk)
+static void skcipher_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
@@ -909,33 +909,10 @@ static void skcipher_sock_destruct_common(struct sock *sk)
 	skcipher_free_sgl(sk);
 	sock_kzfree_s(sk, ctx->iv, crypto_ablkcipher_ivsize(tfm));
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
@@ -983,21 +960,7 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 	if (!tfm->has_key)
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
2.7.0
