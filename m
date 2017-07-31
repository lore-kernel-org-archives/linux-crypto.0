From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 09/16] crypto: AF_ALG - consolidate waiting for wmem
Date: Mon, 31 Jul 2017 14:08:36 +0200
Message-ID: <6478788.fUnUEEiBrR@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60868 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752188AbdGaMLh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:37 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consoliate aead_wait_for_wmem, skcipher_wait_for_wmem
==> af_alg_wait_for_wmem

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 35 +++++++++++++++++++++++++++++++++++
 crypto/algif_aead.c     | 30 ++----------------------------
 crypto/algif_skcipher.c | 30 ++----------------------------
 include/crypto/if_alg.h |  1 +
 4 files changed, 40 insertions(+), 56 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 07c0e965c336..518c9de4bb6e 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/rwsem.h>
+#include <linux/sched/signal.h>
 #include <linux/security.h>
 
 struct alg_type_list {
@@ -711,6 +712,40 @@ void af_alg_free_areq_sgls(struct af_alg_async_req *areq)
 }
 EXPORT_SYMBOL_GPL(af_alg_free_areq_sgls);
 
+/**
+ * af_alg_wait_for_wmem - wait for availability of writable memory
+ *
+ * @sk socket of connection to user space
+ * @flags If MSG_DONTWAIT is set, then only report if function would sleep
+ * @return 0 when writable memory is available, < 0 upon error
+ */
+int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	int err = -ERESTARTSYS;
+	long timeout;
+
+	if (flags & MSG_DONTWAIT)
+		return -EAGAIN;
+
+	sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	for (;;) {
+		if (signal_pending(current))
+			break;
+		timeout = MAX_SCHEDULE_TIMEOUT;
+		if (sk_wait_event(sk, &timeout, af_alg_writable(sk), &wait)) {
+			err = 0;
+			break;
+		}
+	}
+	remove_wait_queue(sk_sleep(sk), &wait);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(af_alg_wait_for_wmem);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 5ccac7f0047e..5474fec42fe3 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -64,32 +64,6 @@ static inline bool aead_sufficient_data(struct sock *sk)
 	return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as);
 }
 
-static int aead_wait_for_wmem(struct sock *sk, unsigned int flags)
-{
-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	int err = -ERESTARTSYS;
-	long timeout;
-
-	if (flags & MSG_DONTWAIT)
-		return -EAGAIN;
-
-	sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
-
-	add_wait_queue(sk_sleep(sk), &wait);
-	for (;;) {
-		if (signal_pending(current))
-			break;
-		timeout = MAX_SCHEDULE_TIMEOUT;
-		if (sk_wait_event(sk, &timeout, af_alg_writable(sk), &wait)) {
-			err = 0;
-			break;
-		}
-	}
-	remove_wait_queue(sk_sleep(sk), &wait);
-
-	return err;
-}
-
 static void aead_wmem_wakeup(struct sock *sk)
 {
 	struct socket_wq *wq;
@@ -237,7 +211,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		}
 
 		if (!af_alg_writable(sk)) {
-			err = aead_wait_for_wmem(sk, msg->msg_flags);
+			err = af_alg_wait_for_wmem(sk, msg->msg_flags);
 			if (err)
 				goto unlock;
 		}
@@ -319,7 +293,7 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 		goto done;
 
 	if (!af_alg_writable(sk)) {
-		err = aead_wait_for_wmem(sk, flags);
+		err = af_alg_wait_for_wmem(sk, flags);
 		if (err)
 			goto unlock;
 	}
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ea7cfe7c1971..10d3c6f477ac 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -44,32 +44,6 @@ struct skcipher_tfm {
 	bool has_key;
 };
 
-static int skcipher_wait_for_wmem(struct sock *sk, unsigned flags)
-{
-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	int err = -ERESTARTSYS;
-	long timeout;
-
-	if (flags & MSG_DONTWAIT)
-		return -EAGAIN;
-
-	sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
-
-	add_wait_queue(sk_sleep(sk), &wait);
-	for (;;) {
-		if (signal_pending(current))
-			break;
-		timeout = MAX_SCHEDULE_TIMEOUT;
-		if (sk_wait_event(sk, &timeout, af_alg_writable(sk), &wait)) {
-			err = 0;
-			break;
-		}
-	}
-	remove_wait_queue(sk_sleep(sk), &wait);
-
-	return err;
-}
-
 static void skcipher_wmem_wakeup(struct sock *sk)
 {
 	struct socket_wq *wq;
@@ -218,7 +192,7 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 		}
 
 		if (!af_alg_writable(sk)) {
-			err = skcipher_wait_for_wmem(sk, msg->msg_flags);
+			err = af_alg_wait_for_wmem(sk, msg->msg_flags);
 			if (err)
 				goto unlock;
 		}
@@ -296,7 +270,7 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 		goto done;
 
 	if (!af_alg_writable(sk)) {
-		err = skcipher_wait_for_wmem(sk, flags);
+		err = af_alg_wait_for_wmem(sk, flags);
 		if (err)
 			goto unlock;
 	}
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 93379804a0ee..1008fab90eab 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -245,5 +245,6 @@ unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset);
 void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 		      size_t dst_offset);
 void af_alg_free_areq_sgls(struct af_alg_async_req *areq);
+int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags);
 
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
