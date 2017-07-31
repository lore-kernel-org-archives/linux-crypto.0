From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 04/16] crypto: AF_ALG - consolidate RX buffer service  functions
Date: Mon, 31 Jul 2017 14:06:50 +0200
Message-ID: <2741770.xU8IAUYmGv@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60878 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752192AbdGaMLh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:37 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consolidate the common functions verifying the RX buffers:

 * skcipher_rcvbuf, aead_rcvbuf ==> af_alg_rcvbuf

 * skcipher_readable, aead_readable ==> af_alg_readable

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c     | 16 +---------------
 crypto/algif_skcipher.c | 16 +---------------
 include/crypto/if_alg.h | 26 ++++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index c923ce29bfe3..cdcf186296bd 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -47,20 +47,6 @@ struct aead_tfm {
 	struct crypto_skcipher *null_tfm;
 };
 
-static inline int aead_rcvbuf(struct sock *sk)
-{
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-
-	return max_t(int, max_t(int, sk->sk_rcvbuf & PAGE_MASK, PAGE_SIZE) -
-			  ctx->rcvused, 0);
-}
-
-static inline bool aead_readable(struct sock *sk)
-{
-	return PAGE_SIZE <= aead_rcvbuf(sk);
-}
-
 static inline bool aead_sufficient_data(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -655,7 +641,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		size_t seglen;
 
 		/* limit the amount of readable buffers */
-		if (!aead_readable(sk))
+		if (!af_alg_readable(sk))
 			break;
 
 		if (!ctx->used) {
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a5c6643f2abe..081df927fb8b 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -44,20 +44,6 @@ struct skcipher_tfm {
 	bool has_key;
 };
 
-static inline int skcipher_rcvbuf(struct sock *sk)
-{
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-
-	return max_t(int, max_t(int, sk->sk_rcvbuf & PAGE_MASK, PAGE_SIZE) -
-			  ctx->rcvused, 0);
-}
-
-static inline bool skcipher_readable(struct sock *sk)
-{
-	return PAGE_SIZE <= skcipher_rcvbuf(sk);
-}
-
 static int skcipher_alloc_tsgl(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -532,7 +518,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		size_t seglen;
 
 		/* limit the amount of readable buffers */
-		if (!skcipher_readable(sk))
+		if (!af_alg_readable(sk))
 			break;
 
 		if (!ctx->used) {
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 79d215f65acf..e1ac57c32d85 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -214,4 +214,30 @@ static inline bool af_alg_writable(struct sock *sk)
 	return PAGE_SIZE <= af_alg_sndbuf(sk);
 }
 
+/**
+ * Size of available buffer used by kernel for the RX user space operation.
+ *
+ * @sk socket of connection to user space
+ * @return number of bytes still available
+ */
+static inline int af_alg_rcvbuf(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+
+	return max_t(int, max_t(int, sk->sk_rcvbuf & PAGE_MASK, PAGE_SIZE) -
+			  ctx->rcvused, 0);
+}
+
+/**
+ * Can the RX buffer still be written to?
+ *
+ * @sk socket of connection to user space
+ * @return true => writable, false => not writable
+ */
+static inline bool af_alg_readable(struct sock *sk)
+{
+	return PAGE_SIZE <= af_alg_rcvbuf(sk);
+}
+
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
