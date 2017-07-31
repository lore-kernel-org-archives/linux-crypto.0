From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 11/16] crypto: AF_ALG - consolidate waiting for TX data
Date: Mon, 31 Jul 2017 14:09:15 +0200
Message-ID: <11381815.0UHCGY9zCf@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60864 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752088AbdGaMLh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:37 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consoliate aead_wait_for_data, skcipher_wait_for_data
==> af_alg_wait_for_data

The wakeup is triggered when either more data is received or the
indicator that more data is to be expected is released. The first is
triggered by user space, the second is triggered by the kernel upon
finishing the processing of data (i.e. the kernel is ready for more).

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 39 +++++++++++++++++++++++++++++++++++++++
 crypto/algif_aead.c     | 32 +-------------------------------
 crypto/algif_skcipher.c | 33 +--------------------------------
 include/crypto/if_alg.h |  1 +
 4 files changed, 42 insertions(+), 63 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 6645454bc445..c1fe7c5f1b2e 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -769,6 +769,45 @@ void af_alg_wmem_wakeup(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(af_alg_wmem_wakeup);
 
+/**
+ * af_alg_wait_for_data - wait for availability of TX data
+ *
+ * @sk socket of connection to user space
+ * @flags If MSG_DONTWAIT is set, then only report if function would sleep
+ * @return 0 when writable memory is available, < 0 upon error
+ */
+int af_alg_wait_for_data(struct sock *sk, unsigned flags)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+	long timeout;
+	int err = -ERESTARTSYS;
+
+	if (flags & MSG_DONTWAIT)
+		return -EAGAIN;
+
+	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	for (;;) {
+		if (signal_pending(current))
+			break;
+		timeout = MAX_SCHEDULE_TIMEOUT;
+		if (sk_wait_event(sk, &timeout, (ctx->used || !ctx->more),
+				  &wait)) {
+			err = 0;
+			break;
+		}
+	}
+	remove_wait_queue(sk_sleep(sk), &wait);
+
+	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(af_alg_wait_for_data);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 8c7fac1053f0..8db8c10401d6 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -64,36 +64,6 @@ static inline bool aead_sufficient_data(struct sock *sk)
 	return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as);
 }
 
-static int aead_wait_for_data(struct sock *sk, unsigned flags)
-{
-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	long timeout;
-	int err = -ERESTARTSYS;
-
-	if (flags & MSG_DONTWAIT)
-		return -EAGAIN;
-
-	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
-
-	add_wait_queue(sk_sleep(sk), &wait);
-	for (;;) {
-		if (signal_pending(current))
-			break;
-		timeout = MAX_SCHEDULE_TIMEOUT;
-		if (sk_wait_event(sk, &timeout, !ctx->more, &wait)) {
-			err = 0;
-			break;
-		}
-	}
-	remove_wait_queue(sk_sleep(sk), &wait);
-
-	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
-
-	return err;
-}
-
 static void aead_data_wakeup(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -425,7 +395,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 			break;
 
 		if (!ctx->used) {
-			err = aead_wait_for_data(sk, flags);
+			err = af_alg_wait_for_data(sk, flags);
 			if (err)
 				goto free;
 		}
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 258a27d0f553..572a5a632ea1 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -44,37 +44,6 @@ struct skcipher_tfm {
 	bool has_key;
 };
 
-static int skcipher_wait_for_data(struct sock *sk, unsigned flags)
-{
-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	long timeout;
-	int err = -ERESTARTSYS;
-
-	if (flags & MSG_DONTWAIT) {
-		return -EAGAIN;
-	}
-
-	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
-
-	add_wait_queue(sk_sleep(sk), &wait);
-	for (;;) {
-		if (signal_pending(current))
-			break;
-		timeout = MAX_SCHEDULE_TIMEOUT;
-		if (sk_wait_event(sk, &timeout, ctx->used, &wait)) {
-			err = 0;
-			break;
-		}
-	}
-	remove_wait_queue(sk_sleep(sk), &wait);
-
-	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
-
-	return err;
-}
-
 static void skcipher_data_wakeup(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -343,7 +312,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 			break;
 
 		if (!ctx->used) {
-			err = skcipher_wait_for_data(sk, flags);
+			err = af_alg_wait_for_data(sk, flags);
 			if (err)
 				goto free;
 		}
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 88eda219b90f..c3b02276f38f 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -247,5 +247,6 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 void af_alg_free_areq_sgls(struct af_alg_async_req *areq);
 int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags);
 void af_alg_wmem_wakeup(struct sock *sk);
+int af_alg_wait_for_data(struct sock *sk, unsigned flags);
 
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
