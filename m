From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 16/16] crypto: AF_ALG - consolidate poll syscall handler
Date: Mon, 31 Jul 2017 14:11:13 +0200
Message-ID: <4962248.kL35ls7QWF@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60844 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752020AbdGaMLf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:35 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consoliate aead_poll, skcipher_poll ==> af_alg_poll

The POLLIN / POLLRDNORM is now set when either not more data is given or
the kernel is supplied with data. This is consistent to the wakeup from
sleep when the kernel waits for data.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 24 ++++++++++++++++++++++++
 crypto/algif_aead.c     | 24 ++----------------------
 crypto/algif_skcipher.c | 23 ++---------------------
 include/crypto/if_alg.h |  2 ++
 4 files changed, 30 insertions(+), 43 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index ef37fc3a9015..ae0e93103c76 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1080,6 +1080,30 @@ void af_alg_async_cb(struct crypto_async_request *_req, int err)
 }
 EXPORT_SYMBOL_GPL(af_alg_async_cb);
 
+/**
+ * af_alg_poll - poll system call handler
+ */
+unsigned int af_alg_poll(struct file *file, struct socket *sock,
+			 poll_table *wait)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+	unsigned int mask;
+
+	sock_poll_wait(file, sk_sleep(sk), wait);
+	mask = 0;
+
+	if (!ctx->more || ctx->used)
+		mask |= POLLIN | POLLRDNORM;
+
+	if (af_alg_writable(sk))
+		mask |= POLLOUT | POLLWRNORM | POLLWRBAND;
+
+	return mask;
+}
+EXPORT_SYMBOL_GPL(af_alg_poll);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 8add641cc667..478bacf30079 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -385,26 +385,6 @@ static int aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	return ret;
 }
 
-static unsigned int aead_poll(struct file *file, struct socket *sock,
-			      poll_table *wait)
-{
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	unsigned int mask;
-
-	sock_poll_wait(file, sk_sleep(sk), wait);
-	mask = 0;
-
-	if (!ctx->more)
-		mask |= POLLIN | POLLRDNORM;
-
-	if (af_alg_writable(sk))
-		mask |= POLLOUT | POLLWRNORM | POLLWRBAND;
-
-	return mask;
-}
-
 static struct proto_ops algif_aead_ops = {
 	.family		=	PF_ALG,
 
@@ -424,7 +404,7 @@ static struct proto_ops algif_aead_ops = {
 	.sendmsg	=	aead_sendmsg,
 	.sendpage	=	af_alg_sendpage,
 	.recvmsg	=	aead_recvmsg,
-	.poll		=	aead_poll,
+	.poll		=	af_alg_poll,
 };
 
 static int aead_check_key(struct socket *sock)
@@ -520,7 +500,7 @@ static struct proto_ops algif_aead_ops_nokey = {
 	.sendmsg	=	aead_sendmsg_nokey,
 	.sendpage	=	aead_sendpage_nokey,
 	.recvmsg	=	aead_recvmsg_nokey,
-	.poll		=	aead_poll,
+	.poll		=	af_alg_poll,
 };
 
 static void *aead_bind(const char *name, u32 type, u32 mask)
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 5134df529833..5bd85c1dd188 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -236,25 +236,6 @@ static int skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	return ret;
 }
 
-static unsigned int skcipher_poll(struct file *file, struct socket *sock,
-				  poll_table *wait)
-{
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	unsigned int mask;
-
-	sock_poll_wait(file, sk_sleep(sk), wait);
-	mask = 0;
-
-	if (ctx->used)
-		mask |= POLLIN | POLLRDNORM;
-
-	if (af_alg_writable(sk))
-		mask |= POLLOUT | POLLWRNORM | POLLWRBAND;
-
-	return mask;
-}
 
 static struct proto_ops algif_skcipher_ops = {
 	.family		=	PF_ALG,
@@ -275,7 +256,7 @@ static struct proto_ops algif_skcipher_ops = {
 	.sendmsg	=	skcipher_sendmsg,
 	.sendpage	=	af_alg_sendpage,
 	.recvmsg	=	skcipher_recvmsg,
-	.poll		=	skcipher_poll,
+	.poll		=	af_alg_poll,
 };
 
 static int skcipher_check_key(struct socket *sock)
@@ -371,7 +352,7 @@ static struct proto_ops algif_skcipher_ops_nokey = {
 	.sendmsg	=	skcipher_sendmsg_nokey,
 	.sendpage	=	skcipher_sendpage_nokey,
 	.recvmsg	=	skcipher_recvmsg_nokey,
-	.poll		=	skcipher_poll,
+	.poll		=	af_alg_poll,
 };
 
 static void *skcipher_bind(const char *name, u32 type, u32 mask)
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index ef08fb4a599e..7bac3fee6061 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -254,5 +254,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 			int offset, size_t size, int flags);
 void af_alg_async_cb(struct crypto_async_request *_req, int err);
+unsigned int af_alg_poll(struct file *file, struct socket *sock,
+			 poll_table *wait);
 
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
