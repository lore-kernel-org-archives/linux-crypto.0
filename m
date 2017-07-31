From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 12/16] crypto: AF_ALG - consolidate waking up caller for TX  data
Date: Mon, 31 Jul 2017 14:09:36 +0200
Message-ID: <88330497.9LFqfa9Pi9@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60862 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752077AbdGaMLf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:35 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consoliate aead_data_wakeup, skcipher_data_wakeup
==> af_alg_data_wakeup

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 26 ++++++++++++++++++++++++++
 crypto/algif_aead.c     | 24 ++----------------------
 crypto/algif_skcipher.c | 24 ++----------------------
 include/crypto/if_alg.h |  1 +
 4 files changed, 31 insertions(+), 44 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index c1fe7c5f1b2e..d1e0c176495f 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -808,6 +808,32 @@ int af_alg_wait_for_data(struct sock *sk, unsigned flags)
 }
 EXPORT_SYMBOL_GPL(af_alg_wait_for_data);
 
+/**
+ * af_alg_data_wakeup - wakeup caller when new data can be sent to kernel
+ *
+ * @sk socket of connection to user space
+ */
+
+void af_alg_data_wakeup(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+	struct socket_wq *wq;
+
+	if (!ctx->used)
+		return;
+
+	rcu_read_lock();
+	wq = rcu_dereference(sk->sk_wq);
+	if (skwq_has_sleeper(wq))
+		wake_up_interruptible_sync_poll(&wq->wait, POLLOUT |
+							   POLLRDNORM |
+							   POLLRDBAND);
+	sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(af_alg_data_wakeup);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 8db8c10401d6..7a3b81545363 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -35,7 +35,6 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
-#include <linux/sched/signal.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/net.h>
@@ -64,25 +63,6 @@ static inline bool aead_sufficient_data(struct sock *sk)
 	return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as);
 }
 
-static void aead_data_wakeup(struct sock *sk)
-{
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct socket_wq *wq;
-
-	if (!ctx->used)
-		return;
-
-	rcu_read_lock();
-	wq = rcu_dereference(sk->sk_wq);
-	if (skwq_has_sleeper(wq))
-		wake_up_interruptible_sync_poll(&wq->wait, POLLOUT |
-							   POLLRDNORM |
-							   POLLRDBAND);
-	sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
-	rcu_read_unlock();
-}
-
 static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
@@ -220,7 +200,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	ctx->more = msg->msg_flags & MSG_MORE;
 
 unlock:
-	aead_data_wakeup(sk);
+	af_alg_data_wakeup(sk);
 	release_sock(sk);
 
 	return err ?: copied;
@@ -273,7 +253,7 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 done:
 	ctx->more = flags & MSG_MORE;
 unlock:
-	aead_data_wakeup(sk);
+	af_alg_data_wakeup(sk);
 	release_sock(sk);
 
 	return err ?: size;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 572a5a632ea1..1b16fb1161b9 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -33,7 +33,6 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
-#include <linux/sched/signal.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/net.h>
@@ -44,25 +43,6 @@ struct skcipher_tfm {
 	bool has_key;
 };
 
-static void skcipher_data_wakeup(struct sock *sk)
-{
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct socket_wq *wq;
-
-	if (!ctx->used)
-		return;
-
-	rcu_read_lock();
-	wq = rcu_dereference(sk->sk_wq);
-	if (skwq_has_sleeper(wq))
-		wake_up_interruptible_sync_poll(&wq->wait, POLLOUT |
-							   POLLRDNORM |
-							   POLLRDBAND);
-	sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
-	rcu_read_unlock();
-}
-
 static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 			    size_t size)
 {
@@ -196,7 +176,7 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 	ctx->more = msg->msg_flags & MSG_MORE;
 
 unlock:
-	skcipher_data_wakeup(sk);
+	af_alg_data_wakeup(sk);
 	release_sock(sk);
 
 	return copied ?: err;
@@ -247,7 +227,7 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 	ctx->more = flags & MSG_MORE;
 
 unlock:
-	skcipher_data_wakeup(sk);
+	af_alg_data_wakeup(sk);
 	release_sock(sk);
 
 	return err ?: size;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index c3b02276f38f..dae18aec9792 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -248,5 +248,6 @@ void af_alg_free_areq_sgls(struct af_alg_async_req *areq);
 int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags);
 void af_alg_wmem_wakeup(struct sock *sk);
 int af_alg_wait_for_data(struct sock *sk, unsigned flags);
+void af_alg_data_wakeup(struct sock *sk);
 
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
