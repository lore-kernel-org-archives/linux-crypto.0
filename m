From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 10/16] crypto: AF_ALG - consolidate waking up on writable memory
Date: Mon, 31 Jul 2017 14:08:57 +0200
Message-ID: <2356562.5FVP7Ma60p@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60866 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752105AbdGaMLh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:37 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consoliate aead_wmem_wakeup, skcipher_wmem_wakeup
    ==> af_alg_wmem_wakeup

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 23 +++++++++++++++++++++++
 crypto/algif_aead.c     | 19 +------------------
 crypto/algif_skcipher.c | 19 +------------------
 include/crypto/if_alg.h |  1 +
 4 files changed, 26 insertions(+), 36 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 518c9de4bb6e..6645454bc445 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -746,6 +746,29 @@ int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags)
 }
 EXPORT_SYMBOL_GPL(af_alg_wait_for_wmem);
 
+/**
+ * af_alg_wmem_wakeup - wakeup caller when writable memory is available
+ *
+ * @sk socket of connection to user space
+ */
+void af_alg_wmem_wakeup(struct sock *sk)
+{
+	struct socket_wq *wq;
+
+	if (!af_alg_writable(sk))
+		return;
+
+	rcu_read_lock();
+	wq = rcu_dereference(sk->sk_wq);
+	if (skwq_has_sleeper(wq))
+		wake_up_interruptible_sync_poll(&wq->wait, POLLIN |
+							   POLLRDNORM |
+							   POLLRDBAND);
+	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(af_alg_wmem_wakeup);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 5474fec42fe3..8c7fac1053f0 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -64,23 +64,6 @@ static inline bool aead_sufficient_data(struct sock *sk)
 	return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as);
 }
 
-static void aead_wmem_wakeup(struct sock *sk)
-{
-	struct socket_wq *wq;
-
-	if (!af_alg_writable(sk))
-		return;
-
-	rcu_read_lock();
-	wq = rcu_dereference(sk->sk_wq);
-	if (skwq_has_sleeper(wq))
-		wake_up_interruptible_sync_poll(&wq->wait, POLLIN |
-							   POLLRDNORM |
-							   POLLRDBAND);
-	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
-	rcu_read_unlock();
-}
-
 static int aead_wait_for_data(struct sock *sk, unsigned flags)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
@@ -651,7 +634,7 @@ static int aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 out:
-	aead_wmem_wakeup(sk);
+	af_alg_wmem_wakeup(sk);
 	release_sock(sk);
 	return ret;
 }
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 10d3c6f477ac..258a27d0f553 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -44,23 +44,6 @@ struct skcipher_tfm {
 	bool has_key;
 };
 
-static void skcipher_wmem_wakeup(struct sock *sk)
-{
-	struct socket_wq *wq;
-
-	if (!af_alg_writable(sk))
-		return;
-
-	rcu_read_lock();
-	wq = rcu_dereference(sk->sk_wq);
-	if (skwq_has_sleeper(wq))
-		wake_up_interruptible_sync_poll(&wq->wait, POLLIN |
-							   POLLRDNORM |
-							   POLLRDBAND);
-	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
-	rcu_read_unlock();
-}
-
 static int skcipher_wait_for_data(struct sock *sk, unsigned flags)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
@@ -492,7 +475,7 @@ static int skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 out:
-	skcipher_wmem_wakeup(sk);
+	af_alg_wmem_wakeup(sk);
 	release_sock(sk);
 	return ret;
 }
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 1008fab90eab..88eda219b90f 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -246,5 +246,6 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 		      size_t dst_offset);
 void af_alg_free_areq_sgls(struct af_alg_async_req *areq);
 int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags);
+void af_alg_wmem_wakeup(struct sock *sk);
 
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
