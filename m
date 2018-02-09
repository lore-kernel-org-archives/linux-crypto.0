From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v3 2/4] crypto: AF_ALG - inline IV support
Date: Fri, 09 Feb 2018 23:03:36 +0100
Message-ID: <2183589.yKIUygMUCu@positron.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <1842104.0gXuQuQB9D@positron.chronox.de> <2808558.OTeCt0oKkL@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Harsh Jain <harsh@chelsio.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:23450 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbeBIWOd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Feb 2018 17:14:33 -0500
In-Reply-To: <2808558.OTeCt0oKkL@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The kernel crypto API requires the caller to set an IV in the request
data structure. That request data structure shall define one particular
cipher operation. During the cipher operation, the IV is read by the
cipher implementation and eventually the potentially updated IV (e.g.
in case of CBC) is written back to the memory location the request data
structure points to.

AF_ALG allows setting the IV with a sendmsg request, where the IV is
stored in the AF_ALG context that is unique to one particular AF_ALG
socket. Note the analogy: an AF_ALG socket is like a TFM where one
recvmsg operation uses one request with the TFM from the socket.

AF_ALG these days supports AIO operations with multiple IOCBs. I.e.
with one recvmsg call, multiple IOVECs can be specified. Each
individual IOCB (derived from one IOVEC) implies that one request data
structure is created with the data to be processed by the cipher
implementation. The IV that was set with the sendmsg call is registered
with the request data structure before the cipher operation.

As of now, the individual IOCBs are serialized with respect to the IV
handling. This implies that the kernel does not perform a truly parallel
invocation of the cipher implementations. However, if the user wants to
perform cryptographic operations on multiple IOCBs where each IOCB is
truly independent from the other, parallel invocations are possible.
This would require that each IOCB provides its own IV to ensure true
separation of the IOCBs.

The solution is to allow providing the IV data supplied as part of the
plaintext/ciphertext. To do so, the AF_ALG interface treats the
ALG_SET_OP flag usable with sendmsg as a bit-array allowing to set the
cipher operation together with the flag whether the operation should
enable support for inline IV handling.

If inline IV handling is enabled, the IV is expected to be the first
part of the input plaintext/ciphertext. This IV is only used for one
cipher operation and will not retained in the kernel for subsequent
cipher operations.

The inline IV handling support is only allowed to be enabled during
the first sendmsg call for a context. Any subsequent sendmsg calls are
not allowed to change the setting of the inline IV handling (either
enable or disable it) as this would open up a race condition with the
locking and unlocking of the ctx->ivlock mutex.

The AEAD support required a slight re-arragning of the code, because
obtaining the IV implies that ctx->used is updated. Thus, the ctx->used
access in _aead_recvmsg must be moved below the IV gathering.

The AEAD code to find the first SG with data in the TX SGL is moved to a
common function as it is required by the IV gathering function as well.

This patch does not change the existing interface where user space is
allowed to provide an IV via sendmsg. It only extends the interface by
giving the user the choice to provide the IV either via sendmsg (the
current approach) or as part of the data (the additional approach).

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c             | 93 ++++++++++++++++++++++++++++++++++++++++++---
 crypto/algif_aead.c         | 58 ++++++++++++----------------
 crypto/algif_skcipher.c     | 12 +++---
 include/crypto/if_alg.h     | 21 +++++++++-
 include/uapi/linux/if_alg.h |  6 ++-
 5 files changed, 143 insertions(+), 47 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index e7887621aa44..7f80dcfc12a6 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -14,6 +14,7 @@
 
 #include <linux/atomic.h>
 #include <crypto/if_alg.h>
+#include <crypto/scatterwalk.h>
 #include <linux/crypto.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -834,6 +835,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	struct af_alg_control con = {};
 	long copied = 0;
 	bool enc = 0;
+	int iiv = ALG_IV_SERIAL_PROCESSING;
 	bool init = 0;
 	int err = 0;
 
@@ -843,7 +845,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			return err;
 
 		init = 1;
-		switch (con.op) {
+		switch (con.op & ALG_OP_CIPHER_MASK) {
 		case ALG_OP_ENCRYPT:
 			enc = 1;
 			break;
@@ -854,6 +856,9 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			return -EINVAL;
 		}
 
+		if (con.op & ALG_OP_INLINE_IV)
+			iiv = ALG_IV_PARALLEL_PROCESSING;
+
 		if (con.iv && con.iv->ivlen != ivsize)
 			return -EINVAL;
 	}
@@ -866,6 +871,19 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 	if (init) {
 		ctx->enc = enc;
+
+		/*
+		 * IIV can only be enabled once with the first sendmsg call.
+		 * This prevents a race in locking and unlocking the
+		 * ctx->ivlock mutex.
+		 */
+		if (ctx->iiv == ALG_IV_PROCESSING_UNDEF) {
+			ctx->iiv = iiv;
+		} else if (ctx->iiv != iiv) {
+			err = -EINVAL;
+			goto unlock;
+		}
+
 		if (con.iv)
 			memcpy(ctx->iv, con.iv->iv, ivsize);
 
@@ -1031,6 +1049,8 @@ void af_alg_free_resources(struct af_alg_async_req *areq)
 	struct sock *sk = areq->sk;
 
 	af_alg_free_areq_sgls(areq);
+	if (areq->ivlen)
+		sock_kfree_s(sk, areq->iv, areq->ivlen);
 	sock_kfree_s(sk, areq, areq->areqlen);
 }
 EXPORT_SYMBOL_GPL(af_alg_free_resources);
@@ -1178,17 +1198,75 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 EXPORT_SYMBOL_GPL(af_alg_get_rsgl);
 
 /**
- * af_alg_get_iv
+ * af_alg_get_tsgl_sg - get first SG entry with data from TX SGL
+ * @ctx [in] AF_ALG context with TX sgl
+ * @return pointer to SG with data or NULL if none found
+ */
+struct scatterlist *af_alg_get_tsgl_sg(struct af_alg_ctx *ctx)
+{
+	struct af_alg_tsgl *sgl, *tmp;
+	struct scatterlist *sg = NULL;
+	unsigned int i;
+
+	list_for_each_entry_safe(sgl, tmp, &ctx->tsgl_list, list) {
+		for (i = 0; i < sgl->cur; i++) {
+			struct scatterlist *process_sg = sgl->sg + i;
+
+			if (!(process_sg->length) || !sg_page(process_sg))
+				continue;
+			sg = process_sg;
+			break;
+		}
+		if (sg)
+			break;
+	}
+
+	return sg;
+}
+EXPORT_SYMBOL_GPL(af_alg_get_tsgl_sg);
+
+/**
+ * af_alg_get_iv - get IV from either TX inline IV data or from IV set at CTX
  *
  * @sk [in] AF_ALG socket
+ * @areq [in/out] request buffer that will receive the IV
+ *       to be used for the cipher
  * @return 0 on success, < 0 on error
  */
-int af_alg_get_iv(struct sock *sk)
+int af_alg_get_iv(struct sock *sk, struct af_alg_async_req *areq)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct af_alg_ctx *ctx = ask->private;
+	struct scatterlist *sg;
+
+	areq->iv = ctx->iv;
+	areq->ivlen = 0;		// areq->iv will not be freed
+
+	/* If cipher has no IV, no need to lock it or do IIV processing */
+	if (!ctx->ivlen)
+		return 0;
 
-	return mutex_lock_interruptible(&ctx->ivlock);
+	/* No inline IV, use ctx IV buffer and lock it */
+	if (ctx->iiv == ALG_IV_SERIAL_PROCESSING)
+		return mutex_lock_interruptible(&ctx->ivlock);
+
+	/* Inline IV handling: There must be the IV data present. */
+	if (ctx->used < ctx->ivlen || list_empty(&ctx->tsgl_list))
+		return -EINVAL;
+
+	areq->iv = sock_kmalloc(sk, ctx->ivlen, GFP_KERNEL);
+	if (unlikely(!areq->iv))
+		return -ENOMEM;
+	areq->ivlen = ctx->ivlen;	// areq->iv will be freed
+
+	/* Get ivlen data from TX SGL and copy it into areq->iv. */
+	sg = af_alg_get_tsgl_sg(ctx);
+	if (!sg)
+		return -EFAULT;
+	scatterwalk_map_and_copy(areq->iv, sg, 0, ctx->ivlen, 0);
+	af_alg_pull_tsgl(sk, ctx->ivlen, NULL, 0);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(af_alg_get_iv);
 
@@ -1202,7 +1280,12 @@ void af_alg_put_iv(struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	struct af_alg_ctx *ctx = ask->private;
 
-	mutex_unlock(&ctx->ivlock);
+	/* To resemble af_alg_get_iv, do not merge the two branches. */
+	if (!ctx->ivlen)
+		return;
+
+	if (ctx->iiv == ALG_IV_SERIAL_PROCESSING)
+		mutex_unlock(&ctx->ivlock);
 }
 EXPORT_SYMBOL_GPL(af_alg_put_iv);
 
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 402de50d4a58..4c425effc5a5 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -100,9 +100,8 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct aead_tfm *aeadc = pask->private;
 	struct crypto_aead *tfm = aeadc->aead;
 	struct crypto_skcipher *null_tfm = aeadc->null_tfm;
-	unsigned int i, as = crypto_aead_authsize(tfm);
+	unsigned int as = crypto_aead_authsize(tfm);
 	struct af_alg_async_req *areq;
-	struct af_alg_tsgl *tsgl, *tmp;
 	struct scatterlist *rsgl_src, *tsgl_src = NULL;
 	int err = 0;
 	size_t used = 0;		/* [in]  TX bufs to be en/decrypted */
@@ -116,12 +115,6 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 			return err;
 	}
 
-	/*
-	 * Data length provided by caller via sendmsg/sendpage that has not
-	 * yet been processed.
-	 */
-	used = ctx->used;
-
 	/*
 	 * Make sure sufficient data is present -- note, the same check is
 	 * is also present in sendmsg/sendpage. The checks in sendpage/sendmsg
@@ -134,6 +127,23 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (!aead_sufficient_data(sk))
 		return -EINVAL;
 
+	/* Allocate cipher request for current operation. */
+	areq = af_alg_alloc_areq(sk, sizeof(struct af_alg_async_req) +
+				     crypto_aead_reqsize(tfm));
+	if (IS_ERR(areq))
+		return PTR_ERR(areq);
+
+	/* Set areq->iv. */
+	err = af_alg_get_iv(sk, areq);
+	if (err)
+		goto free;
+
+	/*
+	 * Data length provided by caller via sendmsg/sendpage that has not
+	 * yet been processed.
+	 */
+	used = ctx->used;
+
 	/*
 	 * Calculate the minimum output buffer size holding the result of the
 	 * cipher operation. When encrypting data, the receiving buffer is
@@ -153,16 +163,6 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	 */
 	used -= ctx->aead_assoclen;
 
-	/* Allocate cipher request for current operation. */
-	areq = af_alg_alloc_areq(sk, sizeof(struct af_alg_async_req) +
-				     crypto_aead_reqsize(tfm));
-	if (IS_ERR(areq))
-		return PTR_ERR(areq);
-
-	err = af_alg_get_iv(sk);
-	if (err)
-		goto free;
-
 	/* convert iovecs of output buffers into RX SGL */
 	err = af_alg_get_rsgl(sk, msg, flags, areq, outlen, &usedpages);
 	if (err)
@@ -187,18 +187,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 	processed = used + ctx->aead_assoclen;
-	list_for_each_entry_safe(tsgl, tmp, &ctx->tsgl_list, list) {
-		for (i = 0; i < tsgl->cur; i++) {
-			struct scatterlist *process_sg = tsgl->sg + i;
-
-			if (!(process_sg->length) || !sg_page(process_sg))
-				continue;
-			tsgl_src = process_sg;
-			break;
-		}
-		if (tsgl_src)
-			break;
-	}
+	tsgl_src = af_alg_get_tsgl_sg(ctx);
 	if (processed && !tsgl_src) {
 		err = -EFAULT;
 		goto unlock;
@@ -286,7 +275,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	/* Initialize the crypto operation */
 	aead_request_set_crypt(&areq->cra_u.aead_req, rsgl_src,
-			       areq->first_rsgl.sgl.sg, used, ctx->iv);
+			       areq->first_rsgl.sgl.sg, used, areq->iv);
 	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
 	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
 
@@ -554,19 +543,19 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
 	struct aead_tfm *tfm = private;
 	struct crypto_aead *aead = tfm->aead;
 	unsigned int len = sizeof(*ctx);
-	unsigned int ivlen = crypto_aead_ivsize(aead);
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 	memset(ctx, 0, len);
 
-	ctx->iv = sock_kmalloc(sk, ivlen, GFP_KERNEL);
+	ctx->ivlen = crypto_aead_ivsize(aead);
+	ctx->iv = sock_kmalloc(sk, ctx->ivlen, GFP_KERNEL);
 	if (!ctx->iv) {
 		sock_kfree_s(sk, ctx, len);
 		return -ENOMEM;
 	}
-	memset(ctx->iv, 0, ivlen);
+	memset(ctx->iv, 0, ctx->ivlen);
 	mutex_init(&ctx->ivlock);
 
 	INIT_LIST_HEAD(&ctx->tsgl_list);
@@ -576,6 +565,7 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
 	ctx->more = 0;
 	ctx->merge = 0;
 	ctx->enc = 0;
+	ctx->iiv = ALG_IV_PROCESSING_UNDEF;
 	ctx->aead_assoclen = 0;
 	crypto_init_wait(&ctx->wait);
 
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index b65b9a89d6bb..f2a671b6ddf3 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -77,7 +77,8 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (IS_ERR(areq))
 		return PTR_ERR(areq);
 
-	err = af_alg_get_iv(sk);
+	/* Set areq->iv */
+	err = af_alg_get_iv(sk, areq);
 	if (err)
 		goto free;
 
@@ -116,7 +117,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	/* Initialize the crypto operation */
 	skcipher_request_set_tfm(&areq->cra_u.skcipher_req, tfm);
 	skcipher_request_set_crypt(&areq->cra_u.skcipher_req, areq->tsgl,
-				   areq->first_rsgl.sgl.sg, len, ctx->iv);
+				   areq->first_rsgl.sgl.sg, len, areq->iv);
 
 	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
 		/* AIO operation */
@@ -350,14 +351,14 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 	if (!ctx)
 		return -ENOMEM;
 
-	ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(tfm),
-			       GFP_KERNEL);
+	ctx->ivlen = crypto_skcipher_ivsize(tfm);
+	ctx->iv = sock_kmalloc(sk, ctx->ivlen, GFP_KERNEL);
 	if (!ctx->iv) {
 		sock_kfree_s(sk, ctx, len);
 		return -ENOMEM;
 	}
 
-	memset(ctx->iv, 0, crypto_skcipher_ivsize(tfm));
+	memset(ctx->iv, 0, ctx->ivlen);
 	mutex_init(&ctx->ivlock);
 
 	INIT_LIST_HEAD(&ctx->tsgl_list);
@@ -367,6 +368,7 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 	ctx->more = 0;
 	ctx->merge = 0;
 	ctx->enc = 0;
+	ctx->iiv = ALG_IV_PROCESSING_UNDEF;
 	crypto_init_wait(&ctx->wait);
 
 	ask->private = ctx;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index c48eff27e5a9..ef114b72813a 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -96,6 +96,14 @@ struct af_alg_rsgl {
  * @tsgl_entries:	Number of entries in priv. TX SGL
  * @outlen:		Number of output bytes generated by crypto op
  * @areqlen:		Length of this data structure
+ * @iv:			Buffer holding the IV for the cipher operation (this
+ *			is either ctx->iv where ivlen is set to 0 or a newly
+ *			allocated buffer where ivlen represents the size of
+ *			this buffer).
+ * @ivlen:		IV size -- if the IV buffer is to be freed during
+ *			releasing of this data structure, ivlen is non-zero.
+ *			If ivlen is zero, but iv is non-NULL, the iv buffer is
+ *			not freed.
  * @cra_u:		Cipher request
  */
 struct af_alg_async_req {
@@ -112,6 +120,9 @@ struct af_alg_async_req {
 	unsigned int outlen;
 	unsigned int areqlen;
 
+	void *iv;
+	unsigned int ivlen;
+
 	union {
 		struct aead_request aead_req;
 		struct skcipher_request skcipher_req;
@@ -128,6 +139,7 @@ struct af_alg_async_req {
  *
  * @tsgl_list:		Link to TX SGL
  * @iv:			IV for cipher operation
+ * @ivlen:		IV size
  * @ivlock:		Mutex to serialize access to the IV
  * @aead_assoclen:	Length of AAD for AEAD cipher operations
  * @completion:		Work queue for synchronous operation
@@ -142,12 +154,14 @@ struct af_alg_async_req {
  *			SG?
  * @enc:		Cryptographic operation to be performed when
  *			recvmsg is invoked.
+ * @iiv:		Use inline IV: first part of TX data is IV
  * @len:		Length of memory allocated for this data structure.
  */
 struct af_alg_ctx {
 	struct list_head tsgl_list;
 
 	void *iv;
+	unsigned int ivlen;
 	struct mutex ivlock;
 	size_t aead_assoclen;
 
@@ -159,9 +173,13 @@ struct af_alg_ctx {
 	bool more;
 	bool merge;
 	bool enc;
+	int iiv;
 
 	unsigned int len;
 };
+#define ALG_IV_PROCESSING_UNDEF	(-1)
+#define ALG_IV_SERIAL_PROCESSING	(0)
+#define ALG_IV_PARALLEL_PROCESSING	(1)
 
 int af_alg_register_type(const struct af_alg_type *type);
 int af_alg_unregister_type(const struct af_alg_type *type);
@@ -255,7 +273,8 @@ struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
 int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 		    struct af_alg_async_req *areq, size_t maxsize,
 		    size_t *outlen);
-int af_alg_get_iv(struct sock *sk);
+int af_alg_get_iv(struct sock *sk, struct af_alg_async_req *areq);
 void af_alg_put_iv(struct sock *sk);
+struct scatterlist *af_alg_get_tsgl_sg(struct af_alg_ctx *ctx);
 
 #endif	/* _CRYPTO_IF_ALG_H */
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index bc2bcdec377b..76a4db392cb6 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -37,7 +37,9 @@ struct af_alg_iv {
 #define ALG_SET_AEAD_AUTHSIZE		5
 
 /* Operations */
-#define ALG_OP_DECRYPT			0
-#define ALG_OP_ENCRYPT			1
+#define ALG_OP_DECRYPT			0x0
+#define ALG_OP_ENCRYPT			0x1
+#define ALG_OP_CIPHER_MASK		0xf
+#define ALG_OP_INLINE_IV		0x10
 
 #endif	/* _LINUX_IF_ALG_H */
-- 
2.14.3
