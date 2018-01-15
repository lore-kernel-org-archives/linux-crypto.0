From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: AF_ALG - inline IV support
Date: Mon, 15 Jan 2018 10:35:34 +0100
Message-ID: <1972650.zFSS3VNpIS@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, harsh@chelsio.com,
        jonathan.cameron@huawei.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58268 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751768AbeAOJfg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 04:35:36 -0500
In-Reply-To: <2118226.LQArbCsRu5@tauon.chronox.de>
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

In case of an AIO operation, the cipher operation invocation returns
immediately, queuing the request to the hardware. While the AIO request
is processed by the hardware, recvmsg processes the next IOVEC for
which another request is created. Again, the IV buffer from the AF_ALG
socket context is registered with the new request and the cipher
operation is invoked.

You may now see that there is a potential race condition regarding the
IV handling, because there is *no* separate IV buffer for the different
requests. This is nicely demonstrated with libkcapi using the following
command which creates an AIO request with two IOCBs each encrypting one
AES block in CBC mode:

kcapi  -d 2 -x 9  -e -c "cbc(aes)" -k
8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -i
7fbc02ebf5b93322329df9bfccb635af -p 48981da18e4bb9ef7e2e3162d16b1910

When the first AIO request finishes before the 2nd AIO request is
processed, the returned value is:

8b19050f66582cb7f7e4b6c873819b7108afa0eaa7de29bac7d903576b674c32

I.e. two blocks where the IV output from the first request is the IV input
to the 2nd block.

In case the first AIO request is not completed before the 2nd request
commences, the result is two identical AES blocks (i.e. both use the
same IV):

8b19050f66582cb7f7e4b6c873819b718b19050f66582cb7f7e4b6c873819b71

This inconsistent result may even lead to the conclusion that there can
be a memory corruption in the IV buffer if both AIO requests write to
the IV buffer at the same time.

The solution is to allow providing the IV data supplied as part of the
plaintext/ciphertext. To do so, the AF_ALG interface treats the
ALG_SET_OP flag usable with sendmsg as a bit-array allowing to set the
cipher operation together with the flag whether the operation should
enable support for inline IV handling.

If inline IV handling is enabled, the IV is expected to be the first
part of the input plaintext/ciphertext. This IV is only used for one
cipher operation and will not retained in the kernel for subsequent
cipher operations.

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
 crypto/af_alg.c             | 79 ++++++++++++++++++++++++++++++++++++++++++++-
 crypto/algif_aead.c         | 54 ++++++++++++++-----------------
 crypto/algif_skcipher.c     | 14 +++++---
 include/crypto/if_alg.h     | 17 ++++++++++
 include/uapi/linux/if_alg.h |  6 ++--
 5 files changed, 133 insertions(+), 37 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 5231f421ad00..87394dc90ac0 100644
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
+	bool iiv = 0;
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
+			iiv = 1;
+
 		if (con.iv && con.iv->ivlen != ivsize)
 			return -EINVAL;
 	}
@@ -866,6 +871,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 	if (init) {
 		ctx->enc = enc;
+		ctx->iiv = iiv;
 		if (con.iv)
 			memcpy(ctx->iv, con.iv->iv, ivsize);
 
@@ -1031,6 +1037,8 @@ void af_alg_free_resources(struct af_alg_async_req *areq)
 	struct sock *sk = areq->sk;
 
 	af_alg_free_areq_sgls(areq);
+	if (areq->ivlen)
+		sock_kfree_s(sk, areq->iv, areq->ivlen);
 	sock_kfree_s(sk, areq, areq->areqlen);
 }
 EXPORT_SYMBOL_GPL(af_alg_free_resources);
@@ -1175,6 +1183,75 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 }
 EXPORT_SYMBOL_GPL(af_alg_get_rsgl);
 
+/**
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
+ *
+ * @sk [in] AF_ALG socket
+ * @areq [in/out] request buffer that will receive the IV
+ *       to be used for the cipher
+ * @return 0 on success, < 0 on error
+ */
+int af_alg_get_iv(struct sock *sk, struct af_alg_async_req *areq)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+	struct scatterlist *sg;
+
+	/* No inline IV or cipher has no IV, use ctx IV buffer. */
+	if (!ctx->iiv || !ctx->ivlen) {
+		areq->iv = ctx->iv;
+		areq->ivlen = 0;	// areq->iv will not be freed
+		return 0;
+	}
+
+	/* There must be the IV data present. */
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
+}
+EXPORT_SYMBOL_GPL(af_alg_get_iv);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 4b07edd5a9ff..7eb7cb132c09 100644
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
@@ -153,12 +163,6 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	 */
 	used -= ctx->aead_assoclen;
 
-	/* Allocate cipher request for current operation. */
-	areq = af_alg_alloc_areq(sk, sizeof(struct af_alg_async_req) +
-				     crypto_aead_reqsize(tfm));
-	if (IS_ERR(areq))
-		return PTR_ERR(areq);
-
 	/* convert iovecs of output buffers into RX SGL */
 	err = af_alg_get_rsgl(sk, msg, flags, areq, outlen, &usedpages);
 	if (err)
@@ -183,18 +187,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
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
 		goto free;
@@ -282,7 +275,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	/* Initialize the crypto operation */
 	aead_request_set_crypt(&areq->cra_u.aead_req, rsgl_src,
-			       areq->first_rsgl.sgl.sg, used, ctx->iv);
+			       areq->first_rsgl.sgl.sg, used, areq->iv);
 	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
 	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
 
@@ -549,19 +542,19 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
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
 
 	INIT_LIST_HEAD(&ctx->tsgl_list);
 	ctx->len = len;
@@ -570,6 +563,7 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
 	ctx->more = 0;
 	ctx->merge = 0;
 	ctx->enc = 0;
+	ctx->iiv = 0;
 	ctx->aead_assoclen = 0;
 	crypto_init_wait(&ctx->wait);
 
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index c88e5e4cd6a6..d40e1d6797d8 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -77,6 +77,11 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (IS_ERR(areq))
 		return PTR_ERR(areq);
 
+	/* Set areq->iv */
+	err = af_alg_get_iv(sk, areq);
+	if (err)
+		goto free;
+
 	/* convert iovecs of output buffers into RX SGL */
 	err = af_alg_get_rsgl(sk, msg, flags, areq, -1, &len);
 	if (err)
@@ -112,7 +117,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	/* Initialize the crypto operation */
 	skcipher_request_set_tfm(&areq->cra_u.skcipher_req, tfm);
 	skcipher_request_set_crypt(&areq->cra_u.skcipher_req, areq->tsgl,
-				   areq->first_rsgl.sgl.sg, len, ctx->iv);
+				   areq->first_rsgl.sgl.sg, len, areq->iv);
 
 	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
 		/* AIO operation */
@@ -345,14 +350,14 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
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
 
 	INIT_LIST_HEAD(&ctx->tsgl_list);
 	ctx->len = len;
@@ -361,6 +366,7 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 	ctx->more = 0;
 	ctx->merge = 0;
 	ctx->enc = 0;
+	ctx->iiv = 0;
 	crypto_init_wait(&ctx->wait);
 
 	ask->private = ctx;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index f38227a78eae..ebc651ceb54a 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -95,6 +95,14 @@ struct af_alg_rsgl {
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
@@ -111,6 +119,9 @@ struct af_alg_async_req {
 	unsigned int outlen;
 	unsigned int areqlen;
 
+	void *iv;
+	unsigned int ivlen;
+
 	union {
 		struct aead_request aead_req;
 		struct skcipher_request skcipher_req;
@@ -127,6 +138,7 @@ struct af_alg_async_req {
  *
  * @tsgl_list:		Link to TX SGL
  * @iv:			IV for cipher operation
+ * @ivlen:		IV size
  * @aead_assoclen:	Length of AAD for AEAD cipher operations
  * @completion:		Work queue for synchronous operation
  * @used:		TX bytes sent to kernel. This variable is used to
@@ -140,12 +152,14 @@ struct af_alg_async_req {
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
 	size_t aead_assoclen;
 
 	struct crypto_wait wait;
@@ -156,6 +170,7 @@ struct af_alg_ctx {
 	bool more;
 	bool merge;
 	bool enc;
+	bool iiv;
 
 	unsigned int len;
 };
@@ -252,5 +267,7 @@ struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
 int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 		    struct af_alg_async_req *areq, size_t maxsize,
 		    size_t *outlen);
+int af_alg_get_iv(struct sock *sk, struct af_alg_async_req *areq);
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
