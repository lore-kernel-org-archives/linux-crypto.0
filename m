From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 03/16] crypto: AF_ALG - consolidate send buffer service  functions
Date: Mon, 31 Jul 2017 14:06:21 +0200
Message-ID: <1931796.yVYp7cYHXy@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60880 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752194AbdGaMLi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:38 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consolidate the common functions verifying the send buffers:

 * skcipher_sndbuf, aead_sndbuf ==> af_alg_sndbuf

 * skcipher_writable, aead_writable ==> af_alg_writable

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c     | 26 ++++++--------------------
 crypto/algif_skcipher.c | 26 ++++++--------------------
 include/crypto/if_alg.h | 26 ++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index adbf87a0eeee..c923ce29bfe3 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -47,20 +47,6 @@ struct aead_tfm {
 	struct crypto_skcipher *null_tfm;
 };
 
-static inline int aead_sndbuf(struct sock *sk)
-{
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-
-	return max_t(int, max_t(int, sk->sk_sndbuf & PAGE_MASK, PAGE_SIZE) -
-			  ctx->used, 0);
-}
-
-static inline bool aead_writable(struct sock *sk)
-{
-	return PAGE_SIZE <= aead_sndbuf(sk);
-}
-
 static inline int aead_rcvbuf(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -285,7 +271,7 @@ static int aead_wait_for_wmem(struct sock *sk, unsigned int flags)
 		if (signal_pending(current))
 			break;
 		timeout = MAX_SCHEDULE_TIMEOUT;
-		if (sk_wait_event(sk, &timeout, aead_writable(sk), &wait)) {
+		if (sk_wait_event(sk, &timeout, af_alg_writable(sk), &wait)) {
 			err = 0;
 			break;
 		}
@@ -299,7 +285,7 @@ static void aead_wmem_wakeup(struct sock *sk)
 {
 	struct socket_wq *wq;
 
-	if (!aead_writable(sk))
+	if (!af_alg_writable(sk))
 		return;
 
 	rcu_read_lock();
@@ -441,14 +427,14 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			continue;
 		}
 
-		if (!aead_writable(sk)) {
+		if (!af_alg_writable(sk)) {
 			err = aead_wait_for_wmem(sk, msg->msg_flags);
 			if (err)
 				goto unlock;
 		}
 
 		/* allocate a new page */
-		len = min_t(unsigned long, size, aead_sndbuf(sk));
+		len = min_t(unsigned long, size, af_alg_sndbuf(sk));
 
 		err = aead_alloc_tsgl(sk);
 		if (err)
@@ -523,7 +509,7 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 	if (!size)
 		goto done;
 
-	if (!aead_writable(sk)) {
+	if (!af_alg_writable(sk)) {
 		err = aead_wait_for_wmem(sk, flags);
 		if (err)
 			goto unlock;
@@ -901,7 +887,7 @@ static unsigned int aead_poll(struct file *file, struct socket *sock,
 	if (!ctx->more)
 		mask |= POLLIN | POLLRDNORM;
 
-	if (aead_writable(sk))
+	if (af_alg_writable(sk))
 		mask |= POLLOUT | POLLWRNORM | POLLWRBAND;
 
 	return mask;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 0256959b0925..a5c6643f2abe 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -44,20 +44,6 @@ struct skcipher_tfm {
 	bool has_key;
 };
 
-static inline int skcipher_sndbuf(struct sock *sk)
-{
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-
-	return max_t(int, max_t(int, sk->sk_sndbuf & PAGE_MASK, PAGE_SIZE) -
-			  ctx->used, 0);
-}
-
-static inline bool skcipher_writable(struct sock *sk)
-{
-	return PAGE_SIZE <= skcipher_sndbuf(sk);
-}
-
 static inline int skcipher_rcvbuf(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -224,7 +210,7 @@ static int skcipher_wait_for_wmem(struct sock *sk, unsigned flags)
 		if (signal_pending(current))
 			break;
 		timeout = MAX_SCHEDULE_TIMEOUT;
-		if (sk_wait_event(sk, &timeout, skcipher_writable(sk), &wait)) {
+		if (sk_wait_event(sk, &timeout, af_alg_writable(sk), &wait)) {
 			err = 0;
 			break;
 		}
@@ -238,7 +224,7 @@ static void skcipher_wmem_wakeup(struct sock *sk)
 {
 	struct socket_wq *wq;
 
-	if (!skcipher_writable(sk))
+	if (!af_alg_writable(sk))
 		return;
 
 	rcu_read_lock();
@@ -381,13 +367,13 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 			continue;
 		}
 
-		if (!skcipher_writable(sk)) {
+		if (!af_alg_writable(sk)) {
 			err = skcipher_wait_for_wmem(sk, msg->msg_flags);
 			if (err)
 				goto unlock;
 		}
 
-		len = min_t(unsigned long, len, skcipher_sndbuf(sk));
+		len = min_t(unsigned long, len, af_alg_sndbuf(sk));
 
 		err = skcipher_alloc_tsgl(sk);
 		if (err)
@@ -459,7 +445,7 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 	if (!size)
 		goto done;
 
-	if (!skcipher_writable(sk)) {
+	if (!af_alg_writable(sk)) {
 		err = skcipher_wait_for_wmem(sk, flags);
 		if (err)
 			goto unlock;
@@ -701,7 +687,7 @@ static unsigned int skcipher_poll(struct file *file, struct socket *sock,
 	if (ctx->used)
 		mask |= POLLIN | POLLRDNORM;
 
-	if (skcipher_writable(sk))
+	if (af_alg_writable(sk))
 		mask |= POLLOUT | POLLWRNORM | POLLWRBAND;
 
 	return mask;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index b3ab34ff9d35..79d215f65acf 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -188,4 +188,30 @@ static inline void af_alg_init_completion(struct af_alg_completion *completion)
 	init_completion(&completion->completion);
 }
 
+/**
+ * Size of available buffer for sending data from user space to kernel.
+ *
+ * @sk socket of connection to user space
+ * @return number of bytes still available
+ */
+static inline int af_alg_sndbuf(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+
+	return max_t(int, max_t(int, sk->sk_sndbuf & PAGE_MASK, PAGE_SIZE) -
+			  ctx->used, 0);
+}
+
+/**
+ * Can the send buffer still be written to?
+ *
+ * @sk socket of connection to user space
+ * @return true => writable, false => not writable
+ */
+static inline bool af_alg_writable(struct sock *sk)
+{
+	return PAGE_SIZE <= af_alg_sndbuf(sk);
+}
+
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
