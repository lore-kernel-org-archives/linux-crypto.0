From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH crypto-next] crypto: algif - add and use sock_kzfree_s() instead of memzero_explicit()
Date: Wed, 19 Nov 2014 17:13:11 +0100
Message-ID: <1416413591-30146-1-git-send-email-dborkman@redhat.com>
Cc: smueller@chronox.de, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343AbaKSQNV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2014 11:13:21 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit e1bd95bf7c25 ("crypto: algif - zeroize IV buffer") and
2a6af25befd0 ("crypto: algif - zeroize message digest buffer")
added memzero_explicit() calls on buffers that are later on
passed back to sock_kfree_s().

This is a discussed follow-up that, instead, extends the sock
API and adds sock_kzfree_s(), which internally uses kzfree()
instead of kfree() for passing the buffers back to slab.

Having sock_kzfree_s() allows to keep the changes more minimal
by just having a drop-in replacement instead of adding
memzero_explicit() calls everywhere before sock_kfree_s().

In kzfree(), the compiler is not allowed to optimize the memset()
away and thus there's no need for memzero_explicit(). Both,
sock_kfree_s() and sock_kzfree_s() are wrappers for
__sock_kfree_s() and call into kfree() resp. kzfree(); here,
__sock_kfree_s() needs to be explicitly inlined as we want the
compiler to optimize the call and condition away and thus it
produces e.g. on x86_64 the _same_ assembler output for
sock_kfree_s() before and after, and thus also allows for
avoiding code duplication.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 crypto/algif_hash.c     |  6 ++----
 crypto/algif_skcipher.c |  3 +--
 include/net/sock.h      |  1 +
 net/core/sock.c         | 24 ++++++++++++++++++++----
 4 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index f75db4c..e605039 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -258,10 +258,8 @@ static void hash_sock_destruct(struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	struct hash_ctx *ctx = ask->private;
 
-	memzero_explicit(ctx->result,
-		     crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req)));
-	sock_kfree_s(sk, ctx->result,
-		     crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req)));
+	sock_kzfree_s(sk, ctx->result,
+		      crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req)));
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
 }
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 85e3bdb..3438996 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -566,8 +566,7 @@ static void skcipher_sock_destruct(struct sock *sk)
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(&ctx->req);
 
 	skcipher_free_sgl(sk);
-	memzero_explicit(ctx->iv, crypto_ablkcipher_ivsize(tfm));
-	sock_kfree_s(sk, ctx->iv, crypto_ablkcipher_ivsize(tfm));
+	sock_kzfree_s(sk, ctx->iv, crypto_ablkcipher_ivsize(tfm));
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
 }
diff --git a/include/net/sock.h b/include/net/sock.h
index 7db3db1..37d6cc5 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1588,6 +1588,7 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 				     int *errcode, int max_page_order);
 void *sock_kmalloc(struct sock *sk, int size, gfp_t priority);
 void sock_kfree_s(struct sock *sk, void *mem, int size);
+void sock_kzfree_s(struct sock *sk, void *mem, int size);
 void sk_send_sigurg(struct sock *sk);
 
 /*
diff --git a/net/core/sock.c b/net/core/sock.c
index 15e0c67..04ce26a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1713,18 +1713,34 @@ void *sock_kmalloc(struct sock *sk, int size, gfp_t priority)
 }
 EXPORT_SYMBOL(sock_kmalloc);
 
-/*
- * Free an option memory block.
+/* Free an option memory block. Note, we actually want the inline
+ * here as this allows gcc to detect the nullify and fold away the
+ * condition entirely.
  */
-void sock_kfree_s(struct sock *sk, void *mem, int size)
+static inline void __sock_kfree_s(struct sock *sk, void *mem, int size,
+				  const bool nullify)
 {
 	if (WARN_ON_ONCE(!mem))
 		return;
-	kfree(mem);
+	if (nullify)
+		kzfree(mem);
+	else
+		kfree(mem);
 	atomic_sub(size, &sk->sk_omem_alloc);
 }
+
+void sock_kfree_s(struct sock *sk, void *mem, int size)
+{
+	__sock_kfree_s(sk, mem, size, false);
+}
 EXPORT_SYMBOL(sock_kfree_s);
 
+void sock_kzfree_s(struct sock *sk, void *mem, int size)
+{
+	__sock_kfree_s(sk, mem, size, true);
+}
+EXPORT_SYMBOL(sock_kzfree_s);
+
 /* It is almost wait_for_tcp_memory minus release_sock/lock_sock.
    I think, these locks should be removed for datagram sockets.
  */
-- 
1.9.3
