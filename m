From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: AF_ALG AIO - lock context IV
Date: Tue, 30 Jan 2018 09:27:04 +0100
Message-ID: <11410454.xUfCo2NHDh@positron.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <2165621.DHQGk8sIp3@positron.chronox.de> <51c57076-4a01-308c-583b-8c34afc3b2e4@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        jonathan.cameron@huawei.com
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58958 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751511AbeA3I1y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jan 2018 03:27:54 -0500
In-Reply-To: <51c57076-4a01-308c-583b-8c34afc3b2e4@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Harsh,

may I as you to try the attached patch on your Chelsio driver? Please invoke 
the following command from libkcapi:

kcapi  -d 2 -x 9  -e -c "cbc(aes)" -k 
8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -i 
7fbc02ebf5b93322329df9bfccb635af -p 48981da18e4bb9ef7e2e3162d16b1910

The result should now be a fully block-chained result.

Note, the patch goes on top of the inline IV patch.

Thanks

---8<---

In case of AIO where multiple IOCBs are sent to the kernel and inline IV
is not used, the ctx->iv is used for each IOCB. The ctx->iv is read for
the crypto operation and written back after the crypto operation. Thus,
processing of multiple IOCBs must be serialized.

As the AF_ALG interface is used by user space, a mutex provides the
serialization which puts the caller to sleep in case a previous IOCB
processing is not yet finished.

If multiple IOCBs arrive that all are blocked, the mutex' FIFO operation
of processing arriving requests ensures that the blocked IOCBs are
unblocked in the right order.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 22 ++++++++++++++++++++++
 crypto/algif_aead.c     |  2 ++
 crypto/algif_skcipher.c |  2 ++
 include/crypto/if_alg.h |  3 +++
 4 files changed, 29 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 87394dc90ac0..3007c9d899da 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1059,6 +1059,8 @@ void af_alg_async_cb(struct crypto_async_request *_req, 
int err)
 	struct kiocb *iocb = areq->iocb;
 	unsigned int resultlen;
 
+	af_alg_put_iv(sk);
+
 	/* Buffer size written by crypto operation. */
 	resultlen = areq->outlen;
 
@@ -1227,6 +1229,11 @@ int af_alg_get_iv(struct sock *sk, struct 
af_alg_async_req *areq)
 
 	/* No inline IV or cipher has no IV, use ctx IV buffer. */
 	if (!ctx->iiv || !ctx->ivlen) {
+		int ret = mutex_lock_interruptible(&ctx->ivlock);
+
+		if (ret)
+			return ret;
+
 		areq->iv = ctx->iv;
 		areq->ivlen = 0;	// areq->iv will not be freed
 		return 0;
@@ -1252,6 +1259,21 @@ int af_alg_get_iv(struct sock *sk, struct 
af_alg_async_req *areq)
 }
 EXPORT_SYMBOL_GPL(af_alg_get_iv);
 
+/**
+ * af_alg_put_iv - release lock on IV in case CTX IV is used
+ *
+ * @sk [in] AF_ALG socket
+ */
+void af_alg_put_iv(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+
+	if (!ctx->iiv || !ctx->ivlen)
+		mutex_unlock(&ctx->ivlock);
+}
+EXPORT_SYMBOL_GPL(af_alg_put_iv);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 7eb7cb132c09..165b2ca82e51 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -309,6 +309,7 @@ static int _aead_recvmsg(struct socket *sock, struct 
msghdr *msg,
 				&ctx->wait);
 	}
 
+	af_alg_put_iv(sk);
 
 free:
 	af_alg_free_resources(areq);
@@ -555,6 +556,7 @@ static int aead_accept_parent_nokey(void *private, struct 
sock *sk)
 		return -ENOMEM;
 	}
 	memset(ctx->iv, 0, ctx->ivlen);
+	mutex_init(&ctx->ivlock);
 
 	INIT_LIST_HEAD(&ctx->tsgl_list);
 	ctx->len = len;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index d40e1d6797d8..a759cec446b4 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -151,6 +151,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct 
msghdr *msg,
 						 &ctx->wait);
 	}
+	af_alg_put_iv(sk);
 
 free:
 	af_alg_free_resources(areq);
@@ -358,6 +359,7 @@ static int skcipher_accept_parent_nokey(void *private, 
struct sock *sk)
 	}
 	memset(ctx->iv, 0, ctx->ivlen);
+	mutex_init(&ctx->ivlock);
 
 	INIT_LIST_HEAD(&ctx->tsgl_list);
 	ctx->len = len;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index ebc651ceb54a..666be8ac683c 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -19,6 +19,7 @@
 #include <linux/scatterlist.h>
 #include <linux/types.h>
 #include <linux/atomic.h>
+#include <linux/mutex.h>
 #include <net/sock.h>
 
 #include <crypto/aead.h>
@@ -160,6 +161,7 @@ struct af_alg_ctx {
 
 	void *iv;
 	unsigned int ivlen;
+	struct mutex ivlock;
 	size_t aead_assoclen;
 
 	struct crypto_wait wait;
@@ -268,6 +270,7 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, 
int flags,
 		    struct af_alg_async_req *areq, size_t maxsize,
 		    size_t *outlen);
 int af_alg_get_iv(struct sock *sk, struct af_alg_async_req *areq);
+void af_alg_put_iv(struct sock *sk);
 struct scatterlist *af_alg_get_tsgl_sg(struct af_alg_ctx *ctx);
 
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
