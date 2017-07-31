From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 15/16] crypto: AF_ALG - consolidate AIO callback handler
Date: Mon, 31 Jul 2017 14:10:36 +0200
Message-ID: <3121944.yyITU6Zhgv@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60846 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751825AbdGaMLf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:35 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consoliate aead_async_cb, skcipher_async_cb ==> af_alg_async_cb

algif_skcipher has been changed to store the number of output bytes in
areq->outlen before the AIO callback is triggered.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 31 +++++++++++++++++++++++++++++++
 crypto/algif_aead.c     | 23 +----------------------
 crypto/algif_skcipher.c | 27 +++++----------------------
 include/crypto/if_alg.h |  1 +
 4 files changed, 38 insertions(+), 44 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 5a33d6629a67..ef37fc3a9015 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1049,6 +1049,37 @@ ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 }
 EXPORT_SYMBOL_GPL(af_alg_sendpage);
 
+/**
+ * af_alg_async_cb - AIO callback handler
+ *
+ * This handler cleans up the struct af_alg_async_req upon completion of the
+ * AIO operation.
+ *
+ * The number of bytes to be generated with the AIO operation must be set
+ * in areq->outlen before the AIO callback handler is invoked.
+ */
+void af_alg_async_cb(struct crypto_async_request *_req, int err)
+{
+	struct af_alg_async_req *areq = _req->data;
+	struct sock *sk = areq->sk;
+	struct kiocb *iocb = areq->iocb;
+	unsigned int resultlen;
+
+	lock_sock(sk);
+
+	/* Buffer size written by crypto operation. */
+	resultlen = areq->outlen;
+
+	af_alg_free_areq_sgls(areq);
+	sock_kfree_s(sk, areq, areq->areqlen);
+	__sock_put(sk);
+
+	iocb->ki_complete(iocb, err ? err : resultlen, 0);
+
+	release_sock(sk);
+}
+EXPORT_SYMBOL_GPL(af_alg_async_cb);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index f655fadb9075..8add641cc667 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -76,27 +76,6 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	return af_alg_sendmsg(sock, msg, size, ivsize);
 }
 
-static void aead_async_cb(struct crypto_async_request *_req, int err)
-{
-	struct af_alg_async_req *areq = _req->data;
-	struct sock *sk = areq->sk;
-	struct kiocb *iocb = areq->iocb;
-	unsigned int resultlen;
-
-	lock_sock(sk);
-
-	/* Buffer size written by crypto operation. */
-	resultlen = areq->outlen;
-
-	af_alg_free_areq_sgls(areq);
-	sock_kfree_s(sk, areq, areq->areqlen);
-	__sock_put(sk);
-
-	iocb->ki_complete(iocb, err ? err : resultlen, 0);
-
-	release_sock(sk);
-}
-
 static int crypto_aead_copy_sgl(struct crypto_skcipher *null_tfm,
 				struct scatterlist *src,
 				struct scatterlist *dst, unsigned int len)
@@ -341,7 +320,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		areq->iocb = msg->msg_iocb;
 		aead_request_set_callback(&areq->cra_u.aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
-					  aead_async_cb, areq);
+					  af_alg_async_cb, areq);
 		err = ctx->enc ? crypto_aead_encrypt(&areq->cra_u.aead_req) :
 				 crypto_aead_decrypt(&areq->cra_u.aead_req);
 	} else {
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index c577aaaa9fd8..5134df529833 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -57,27 +57,6 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 	return af_alg_sendmsg(sock, msg, size, ivsize);
 }
 
-static void skcipher_async_cb(struct crypto_async_request *req, int err)
-{
-	struct af_alg_async_req *areq = req->data;
-	struct sock *sk = areq->sk;
-	struct kiocb *iocb = areq->iocb;
-	unsigned int resultlen;
-
-	lock_sock(sk);
-
-	/* Buffer size written by crypto operation. */
-	resultlen = areq->cra_u.skcipher_req.cryptlen;
-
-	af_alg_free_areq_sgls(areq);
-	sock_kfree_s(sk, areq, areq->areqlen);
-	__sock_put(sk);
-
-	iocb->ki_complete(iocb, err ? err : resultlen, 0);
-
-	release_sock(sk);
-}
-
 static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 			     size_t ignored, int flags)
 {
@@ -189,7 +168,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		areq->iocb = msg->msg_iocb;
 		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
 					      CRYPTO_TFM_REQ_MAY_SLEEP,
-					      skcipher_async_cb, areq);
+					      af_alg_async_cb, areq);
 		err = ctx->enc ?
 			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
 			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
@@ -209,6 +188,10 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	/* AIO operation in progress */
 	if (err == -EINPROGRESS) {
 		sock_hold(sk);
+
+		/* Remember output size that will be generated. */
+		areq->outlen = len;
+
 		return -EIOCBQUEUED;
 	}
 
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index d271af60bfaf..ef08fb4a599e 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -253,5 +253,6 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		   unsigned int ivsize);
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 			int offset, size_t size, int flags);
+void af_alg_async_cb(struct crypto_async_request *_req, int err);
 
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
