From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 13/16] crypto: AF_ALG - consolidate sendmsg implementation
Date: Mon, 31 Jul 2017 14:09:53 +0200
Message-ID: <5350220.yqx0MdtueE@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60858 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752074AbdGaMLf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:35 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consoliate aead_sendmsg, skcipher_sendmsg
==> af_alg_sendmsg

The following changes to the sendmsg implementation aead_sendmsg have
been applied:

* uses size_t in min_t calculation for obtaining len

* switch the use of the variable size to variable len to determine the
  sndbuf size (both variables have the same content here, consolidate
  implementation with skcipher_sendmsg)

* return code determination is changed to be identical to
  skcipher_sendmsg

The following changes to the sendmsg implementation skcipher_sendmsg
have been applied:

* use of size_t instead of unsigned long for calculating the available
  memory size in the page storing the user data

* scope of variable i is reduced to be compliant with aead_sendmsg

* type of variable is switched from int to unsigned int to be compliant
with aead_sendmsg

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 157 ++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/algif_aead.c     | 132 +---------------------------------------
 crypto/algif_skcipher.c | 127 +--------------------------------------
 include/crypto/if_alg.h |   2 +
 4 files changed, 161 insertions(+), 257 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index d1e0c176495f..716a73ff5309 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -834,6 +834,163 @@ void af_alg_data_wakeup(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(af_alg_data_wakeup);
 
+/**
+ * af_alg_sendmsg - implementation of sendmsg system call handler
+ *
+ * The sendmsg system call handler obtains the user data and stores it
+ * in ctx->tsgl_list. This implies allocation of the required numbers of
+ * struct af_alg_tsgl.
+ *
+ * In addition, the ctx is filled with the information sent via CMSG.
+ *
+ * @sock socket of connection to user space
+ * @msg message from user space
+ * @size size of message from user space
+ * @ivsize the size of the IV for the cipher operation to verify that the
+ *	   user-space-provided IV has the right size
+ * @return the number of copied data upon success, < 0 upon error
+ */
+int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
+		   unsigned int ivsize)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+	struct af_alg_tsgl *sgl;
+	struct af_alg_control con = {};
+	long copied = 0;
+	bool enc = 0;
+	bool init = 0;
+	int err = 0;
+
+	if (msg->msg_controllen) {
+		err = af_alg_cmsg_send(msg, &con);
+		if (err)
+			return err;
+
+		init = 1;
+		switch (con.op) {
+		case ALG_OP_ENCRYPT:
+			enc = 1;
+			break;
+		case ALG_OP_DECRYPT:
+			enc = 0;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		if (con.iv && con.iv->ivlen != ivsize)
+			return -EINVAL;
+	}
+
+	lock_sock(sk);
+	if (!ctx->more && ctx->used) {
+		err = -EINVAL;
+		goto unlock;
+	}
+
+	if (init) {
+		ctx->enc = enc;
+		if (con.iv)
+			memcpy(ctx->iv, con.iv->iv, ivsize);
+
+		ctx->aead_assoclen = con.aead_assoclen;
+	}
+
+	while (size) {
+		struct scatterlist *sg;
+		size_t len = size;
+		size_t plen;
+
+		/* use the existing memory in an allocated page */
+		if (ctx->merge) {
+			sgl = list_entry(ctx->tsgl_list.prev,
+					 struct af_alg_tsgl, list);
+			sg = sgl->sg + sgl->cur - 1;
+			len = min_t(size_t, len,
+				    PAGE_SIZE - sg->offset - sg->length);
+
+			err = memcpy_from_msg(page_address(sg_page(sg)) +
+					      sg->offset + sg->length,
+					      msg, len);
+			if (err)
+				goto unlock;
+
+			sg->length += len;
+			ctx->merge = (sg->offset + sg->length) &
+				     (PAGE_SIZE - 1);
+
+			ctx->used += len;
+			copied += len;
+			size -= len;
+			continue;
+		}
+
+		if (!af_alg_writable(sk)) {
+			err = af_alg_wait_for_wmem(sk, msg->msg_flags);
+			if (err)
+				goto unlock;
+		}
+
+		/* allocate a new page */
+		len = min_t(unsigned long, len, af_alg_sndbuf(sk));
+
+		err = af_alg_alloc_tsgl(sk);
+		if (err)
+			goto unlock;
+
+		sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl,
+				 list);
+		sg = sgl->sg;
+		if (sgl->cur)
+			sg_unmark_end(sg + sgl->cur - 1);
+
+		do {
+			unsigned int i = sgl->cur;
+
+			plen = min_t(size_t, len, PAGE_SIZE);
+
+			sg_assign_page(sg + i, alloc_page(GFP_KERNEL));
+			if (!sg_page(sg + i)) {
+				err = -ENOMEM;
+				goto unlock;
+			}
+
+			err = memcpy_from_msg(page_address(sg_page(sg + i)),
+					      msg, plen);
+			if (err) {
+				__free_page(sg_page(sg + i));
+				sg_assign_page(sg + i, NULL);
+				goto unlock;
+			}
+
+			sg[i].length = plen;
+			len -= plen;
+			ctx->used += plen;
+			copied += plen;
+			size -= plen;
+			sgl->cur++;
+		} while (len && sgl->cur < MAX_SGL_ENTS);
+
+		if (!size)
+			sg_mark_end(sg + sgl->cur - 1);
+
+		ctx->merge = plen & (PAGE_SIZE - 1);
+	}
+
+	err = 0;
+
+	ctx->more = msg->msg_flags & MSG_MORE;
+
+unlock:
+	af_alg_data_wakeup(sk);
+	release_sock(sk);
+
+	return copied ?: err;
+}
+EXPORT_SYMBOL_GPL(af_alg_sendmsg);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 7a3b81545363..9cb934b3175a 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -69,141 +69,11 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct alg_sock *ask = alg_sk(sk);
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
-	struct af_alg_ctx *ctx = ask->private;
 	struct aead_tfm *aeadc = pask->private;
 	struct crypto_aead *tfm = aeadc->aead;
 	unsigned int ivsize = crypto_aead_ivsize(tfm);
-	struct af_alg_tsgl *sgl;
-	struct af_alg_control con = {};
-	long copied = 0;
-	bool enc = 0;
-	bool init = 0;
-	int err = 0;
-
-	if (msg->msg_controllen) {
-		err = af_alg_cmsg_send(msg, &con);
-		if (err)
-			return err;
-
-		init = 1;
-		switch (con.op) {
-		case ALG_OP_ENCRYPT:
-			enc = 1;
-			break;
-		case ALG_OP_DECRYPT:
-			enc = 0;
-			break;
-		default:
-			return -EINVAL;
-		}
-
-		if (con.iv && con.iv->ivlen != ivsize)
-			return -EINVAL;
-	}
-
-	lock_sock(sk);
-	if (!ctx->more && ctx->used) {
-		err = -EINVAL;
-		goto unlock;
-	}
-
-	if (init) {
-		ctx->enc = enc;
-		if (con.iv)
-			memcpy(ctx->iv, con.iv->iv, ivsize);
-
-		ctx->aead_assoclen = con.aead_assoclen;
-	}
-
-	while (size) {
-		struct scatterlist *sg;
-		size_t len = size;
-		size_t plen;
-
-		/* use the existing memory in an allocated page */
-		if (ctx->merge) {
-			sgl = list_entry(ctx->tsgl_list.prev,
-					 struct af_alg_tsgl, list);
-			sg = sgl->sg + sgl->cur - 1;
-			len = min_t(unsigned long, len,
-				    PAGE_SIZE - sg->offset - sg->length);
-			err = memcpy_from_msg(page_address(sg_page(sg)) +
-					      sg->offset + sg->length,
-					      msg, len);
-			if (err)
-				goto unlock;
-
-			sg->length += len;
-			ctx->merge = (sg->offset + sg->length) &
-				     (PAGE_SIZE - 1);
-
-			ctx->used += len;
-			copied += len;
-			size -= len;
-			continue;
-		}
-
-		if (!af_alg_writable(sk)) {
-			err = af_alg_wait_for_wmem(sk, msg->msg_flags);
-			if (err)
-				goto unlock;
-		}
-
-		/* allocate a new page */
-		len = min_t(unsigned long, size, af_alg_sndbuf(sk));
-
-		err = af_alg_alloc_tsgl(sk);
-		if (err)
-			goto unlock;
-
-		sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl,
-				 list);
-		sg = sgl->sg;
-		if (sgl->cur)
-			sg_unmark_end(sg + sgl->cur - 1);
-
-		do {
-			unsigned int i = sgl->cur;
-
-			plen = min_t(size_t, len, PAGE_SIZE);
-
-			sg_assign_page(sg + i, alloc_page(GFP_KERNEL));
-			if (!sg_page(sg + i)) {
-				err = -ENOMEM;
-				goto unlock;
-			}
-
-			err = memcpy_from_msg(page_address(sg_page(sg + i)),
-					      msg, plen);
-			if (err) {
-				__free_page(sg_page(sg + i));
-				sg_assign_page(sg + i, NULL);
-				goto unlock;
-			}
-
-			sg[i].length = plen;
-			len -= plen;
-			ctx->used += plen;
-			copied += plen;
-			size -= plen;
-			sgl->cur++;
-		} while (len && sgl->cur < MAX_SGL_ENTS);
-
-		if (!size)
-			sg_mark_end(sg + sgl->cur - 1);
-
-		ctx->merge = plen & (PAGE_SIZE - 1);
-	}
-
-	err = 0;
-
-	ctx->more = msg->msg_flags & MSG_MORE;
-
-unlock:
-	af_alg_data_wakeup(sk);
-	release_sock(sk);
 
-	return err ?: copied;
+	return af_alg_sendmsg(sock, msg, size, ivsize);
 }
 
 static ssize_t aead_sendpage(struct socket *sock, struct page *page,
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 1b16fb1161b9..d5bc5de7a8a1 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -50,136 +50,11 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct alg_sock *ask = alg_sk(sk);
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
-	struct af_alg_ctx *ctx = ask->private;
 	struct skcipher_tfm *skc = pask->private;
 	struct crypto_skcipher *tfm = skc->skcipher;
 	unsigned ivsize = crypto_skcipher_ivsize(tfm);
-	struct af_alg_tsgl *sgl;
-	struct af_alg_control con = {};
-	long copied = 0;
-	bool enc = 0;
-	bool init = 0;
-	int err;
-	int i;
-
-	if (msg->msg_controllen) {
-		err = af_alg_cmsg_send(msg, &con);
-		if (err)
-			return err;
-
-		init = 1;
-		switch (con.op) {
-		case ALG_OP_ENCRYPT:
-			enc = 1;
-			break;
-		case ALG_OP_DECRYPT:
-			enc = 0;
-			break;
-		default:
-			return -EINVAL;
-		}
-
-		if (con.iv && con.iv->ivlen != ivsize)
-			return -EINVAL;
-	}
-
-	err = -EINVAL;
-
-	lock_sock(sk);
-	if (!ctx->more && ctx->used)
-		goto unlock;
-
-	if (init) {
-		ctx->enc = enc;
-		if (con.iv)
-			memcpy(ctx->iv, con.iv->iv, ivsize);
-	}
-
-	while (size) {
-		struct scatterlist *sg;
-		unsigned long len = size;
-		size_t plen;
-
-		if (ctx->merge) {
-			sgl = list_entry(ctx->tsgl_list.prev,
-					 struct af_alg_tsgl, list);
-			sg = sgl->sg + sgl->cur - 1;
-			len = min_t(unsigned long, len,
-				    PAGE_SIZE - sg->offset - sg->length);
-
-			err = memcpy_from_msg(page_address(sg_page(sg)) +
-					      sg->offset + sg->length,
-					      msg, len);
-			if (err)
-				goto unlock;
-
-			sg->length += len;
-			ctx->merge = (sg->offset + sg->length) &
-				     (PAGE_SIZE - 1);
-
-			ctx->used += len;
-			copied += len;
-			size -= len;
-			continue;
-		}
-
-		if (!af_alg_writable(sk)) {
-			err = af_alg_wait_for_wmem(sk, msg->msg_flags);
-			if (err)
-				goto unlock;
-		}
-
-		len = min_t(unsigned long, len, af_alg_sndbuf(sk));
-
-		err = af_alg_alloc_tsgl(sk);
-		if (err)
-			goto unlock;
-
-		sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl,
-				 list);
-		sg = sgl->sg;
-		if (sgl->cur)
-			sg_unmark_end(sg + sgl->cur - 1);
-		do {
-			i = sgl->cur;
-			plen = min_t(size_t, len, PAGE_SIZE);
-
-			sg_assign_page(sg + i, alloc_page(GFP_KERNEL));
-			err = -ENOMEM;
-			if (!sg_page(sg + i))
-				goto unlock;
-
-			err = memcpy_from_msg(page_address(sg_page(sg + i)),
-					      msg, plen);
-			if (err) {
-				__free_page(sg_page(sg + i));
-				sg_assign_page(sg + i, NULL);
-				goto unlock;
-			}
-
-			sg[i].length = plen;
-			len -= plen;
-			ctx->used += plen;
-			copied += plen;
-			size -= plen;
-			sgl->cur++;
-		} while (len && sgl->cur < MAX_SGL_ENTS);
-
-		if (!size)
-			sg_mark_end(sg + sgl->cur - 1);
-
-		ctx->merge = plen & (PAGE_SIZE - 1);
-	}
-
-	err = 0;
-
-	ctx->more = msg->msg_flags & MSG_MORE;
-
-unlock:
-	af_alg_data_wakeup(sk);
-	release_sock(sk);
 
-	return copied ?: err;
+	return af_alg_sendmsg(sock, msg, size, ivsize);
 }
 
 static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index dae18aec9792..c67d9a35ffd3 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -249,5 +249,7 @@ int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags);
 void af_alg_wmem_wakeup(struct sock *sk);
 int af_alg_wait_for_data(struct sock *sk, unsigned flags);
 void af_alg_data_wakeup(struct sock *sk);
+int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
+		   unsigned int ivsize);
 
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
