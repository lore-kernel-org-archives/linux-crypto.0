From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v3] crypto: AF_ALG - remove locking in async callback
Date: Fri, 10 Nov 2017 13:20:55 +0100
Message-ID: <1966139.WIlnTlQG5u@positron.chronox.de>
References: <CAGkQfmNKbSwue13zPh2K1F_kLkpm1_AhsAHK4spRFA0xMvU5PA@mail.gmail.com> <2510520.gYBNS8MAsP@positron.chronox.de> <20171110111058.GA25914@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Romain Izard <romain.izard.pro@gmail.com>,
        linux-crypto@vger.kernel.org,
        Cyrille Pitchen <cyrille.pitchen@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42236 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752257AbdKJMU6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Nov 2017 07:20:58 -0500
In-Reply-To: <20171110111058.GA25914@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The code paths protected by the socket-lock do not use or modify the
socket in a non-atomic fashion. The actions pertaining the socket do not
even need to be handled as an atomic operation. Thus, the socket-lock
can be safely ignored.

This fixes a bug regarding scheduling in atomic as the callback function
may be invoked in interrupt context.

In addition, the sock_hold is moved before the AIO encrypt/decrypt
operation to ensure that the socket is always present. This avoids a
tiny race window where the socket is unprotected and yet used by the AIO
operation.

Finally, the release of resources for a crypto operation is moved into a
common function of af_alg_free_resources.

Fixes: e870456d8e7c8 ("crypto: algif_skcipher - overhaul memory management")
Fixes: d887c52d6ae43 ("crypto: algif_aead - overhaul memory management")
Reported-by: Romain Izard <romain.izard.pro@gmail.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 21 ++++++++++++++-------
 crypto/algif_aead.c     | 23 ++++++++++++-----------
 crypto/algif_skcipher.c | 23 ++++++++++++-----------
 include/crypto/if_alg.h |  1 +
 4 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 85cea9de324a..358749c38894 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1021,6 +1021,18 @@ ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 EXPORT_SYMBOL_GPL(af_alg_sendpage);
 
 /**
+ * af_alg_free_resources - release resources required for crypto request
+ */
+void af_alg_free_resources(struct af_alg_async_req *areq)
+{
+	struct sock *sk = areq->sk;
+
+	af_alg_free_areq_sgls(areq);
+	sock_kfree_s(sk, areq, areq->areqlen);
+}
+EXPORT_SYMBOL_GPL(af_alg_free_resources);
+
+/**
  * af_alg_async_cb - AIO callback handler
  *
  * This handler cleans up the struct af_alg_async_req upon completion of the
@@ -1036,18 +1048,13 @@ void af_alg_async_cb(struct crypto_async_request *_req, int err)
 	struct kiocb *iocb = areq->iocb;
 	unsigned int resultlen;
 
-	lock_sock(sk);
-
 	/* Buffer size written by crypto operation. */
 	resultlen = areq->outlen;
 
-	af_alg_free_areq_sgls(areq);
-	sock_kfree_s(sk, areq, areq->areqlen);
-	__sock_put(sk);
+	af_alg_free_resources(areq);
+	sock_put(sk);
 
 	iocb->ki_complete(iocb, err ? err : resultlen, 0);
-
-	release_sock(sk);
 }
 EXPORT_SYMBOL_GPL(af_alg_async_cb);
 
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index aacae0837aff..db9378a45296 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -268,12 +268,23 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
 		/* AIO operation */
+		sock_hold(sk);
 		areq->iocb = msg->msg_iocb;
 		aead_request_set_callback(&areq->cra_u.aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
 					  af_alg_async_cb, areq);
 		err = ctx->enc ? crypto_aead_encrypt(&areq->cra_u.aead_req) :
 				 crypto_aead_decrypt(&areq->cra_u.aead_req);
+
+		/* AIO operation in progress */
+		if (err == -EINPROGRESS || err == -EBUSY) {
+			/* Remember output size that will be generated. */
+			areq->outlen = outlen;
+
+			return -EIOCBQUEUED;
+		}
+
+		sock_put(sk);
 	} else {
 		/* Synchronous operation */
 		aead_request_set_callback(&areq->cra_u.aead_req,
@@ -285,19 +296,9 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 				&ctx->wait);
 	}
 
-	/* AIO operation in progress */
-	if (err == -EINPROGRESS) {
-		sock_hold(sk);
-
-		/* Remember output size that will be generated. */
-		areq->outlen = outlen;
-
-		return -EIOCBQUEUED;
-	}
 
 free:
-	af_alg_free_areq_sgls(areq);
-	sock_kfree_s(sk, areq, areq->areqlen);
+	af_alg_free_resources(areq);
 
 	return err ? err : outlen;
 }
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 9954b078f0b9..30cff827dd8f 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -117,6 +117,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
 		/* AIO operation */
+		sock_hold(sk);
 		areq->iocb = msg->msg_iocb;
 		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
 					      CRYPTO_TFM_REQ_MAY_SLEEP,
@@ -124,6 +125,16 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		err = ctx->enc ?
 			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
 			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
+
+		/* AIO operation in progress */
+		if (err == -EINPROGRESS || err == -EBUSY) {
+			/* Remember output size that will be generated. */
+			areq->outlen = len;
+
+			return -EIOCBQUEUED;
+		}
+
+		sock_put(sk);
 	} else {
 		/* Synchronous operation */
 		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
@@ -136,19 +147,9 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 						 &ctx->wait);
 	}
 
-	/* AIO operation in progress */
-	if (err == -EINPROGRESS) {
-		sock_hold(sk);
-
-		/* Remember output size that will be generated. */
-		areq->outlen = len;
-
-		return -EIOCBQUEUED;
-	}
 
 free:
-	af_alg_free_areq_sgls(areq);
-	sock_kfree_s(sk, areq, areq->areqlen);
+	af_alg_free_resources(areq);
 
 	return err ? err : len;
 }
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 6abf0a3604dc..38d9c5861ed8 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -242,6 +242,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		   unsigned int ivsize);
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 			int offset, size_t size, int flags);
+void af_alg_free_resources(struct af_alg_async_req *areq);
 void af_alg_async_cb(struct crypto_async_request *_req, int err);
 unsigned int af_alg_poll(struct file *file, struct socket *sock,
 			 poll_table *wait);
-- 
2.13.6
