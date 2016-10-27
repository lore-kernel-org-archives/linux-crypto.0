From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 10/18] crypto: algif_hash - Remove custom release parent function
Date: Thu, 27 Oct 2016 17:29:43 +0300
Message-ID: <1477578591-28924-11-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0131.outbound.protection.outlook.com ([104.47.1.131]:40799
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933758AbcJ0SDa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 14:03:30 -0400
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>

commit f1d84af1835846a5a2b827382c5848faf2bb0e75 upstream.

This patch removes the custom release parent function as the
generic af_alg_release_parent now works for nokey sockets too.

Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/algif_hash.c | 43 +++----------------------------------------
 1 file changed, 3 insertions(+), 40 deletions(-)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 7bc3f89..512aa36 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -397,7 +397,7 @@ static int hash_setkey(void *private, const u8 *key, unsigned int keylen)
 	return err;
 }
 
-static void hash_sock_destruct_common(struct sock *sk)
+static void hash_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct hash_ctx *ctx = ask->private;
@@ -405,33 +405,10 @@ static void hash_sock_destruct_common(struct sock *sk)
 	sock_kfree_s(sk, ctx->result,
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
@@ -474,21 +451,7 @@ static int hash_accept_parent(void *private, struct sock *sk)
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
2.7.3
