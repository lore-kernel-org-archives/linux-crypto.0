From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v4 2/2] crypto: aead AF_ALG - overhaul memory management
Date: Thu, 16 Feb 2017 22:22:18 +0100
Message-ID: <3674339.gfZmpKFpdb@positron.chronox.de>
References: <1781086.PMKVUsvYzT@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59674 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932975AbdBPVbI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2017 16:31:08 -0500
In-Reply-To: <1781086.PMKVUsvYzT@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The updated memory management is described in the top part of the code.
As one benefit of the changed memory management, the AIO and synchronous
operation is now implemented in one common function. The AF_ALG
operation uses the async kernel crypto API interface for each cipher
operation. Thus, the only difference between the AIO and sync operation
types visible from user space is:

1. the callback function to be invoked when the asynchronous operation
   is completed

2. whether to wait for the completion of the kernel crypto API operation
   or not

The change includes the overhaul of the TX and RX SGL handling. The TX
SGL holding the data sent from user space to the kernel is now dynamic
similar to algif_skcipher. This dynamic nature allows a continuous
operation of a thread sending data and a second thread receiving the
data. These threads do not need to synchronize as the kernel processes
as much data from the TX SGL to fill the RX SGL.

The caller reading the data from the kernel defines the amount of data
to be processed. Considering that the interface covers AEAD
authenticating ciphers, the reader must provide the buffer in the
correct size. Thus the reader defines the encryption size.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c | 705 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 389 insertions(+), 316 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 533265f..0a00639 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -5,12 +5,26 @@
  *
  * This file provides the user-space API for AEAD ciphers.
  *
- * This file is derived from algif_skcipher.c.
- *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
+ *
+ * The following concept of the memory management is used:
+ *
+ * The kernel maintains two SGLs, the TX SGL and the RX SGL. The TX SGL is
+ * filled by user space with the data submitted via sendpage/sendmsg. Filling
+ * up the TX SGL does not cause a crypto operation -- the data will only be
+ * tracked by the kernel. Upon receipt of one recvmsg call, the caller must
+ * provide a buffer which is tracked with the RX SGL.
+ *
+ * During the processing of the recvmsg operation, the cipher request is
+ * allocated and prepared. As part of the recvmsg operation, the processed
+ * TX buffers are extracted from the TX SGL into a separate SGL.
+ *
+ * After the completion of the crypto operation, the RX SGL and the cipher
+ * request is released. The extracted TX SGL parts are released together with
+ * the RX SGL release.
  */
 
 #include <crypto/internal/aead.h>
@@ -24,45 +38,57 @@
 #include <linux/net.h>
 #include <net/sock.h>
 
-struct aead_sg_list {
-	unsigned int cur;
-	struct scatterlist sg[ALG_MAX_PAGES];
+struct aead_tsgl {
+	struct list_head list;
+	unsigned int cur;		/* Last processed SG entry */
+	struct scatterlist sg[0];	/* Array of SGs forming the SGL */
 };
 
-struct aead_async_rsgl {
+struct aead_rsgl {
 	struct af_alg_sgl sgl;
 	struct list_head list;
 };
 
 struct aead_async_req {
-	struct scatterlist *tsgl;
-	struct aead_async_rsgl first_rsgl;
-	struct list_head list;
 	struct kiocb *iocb;
-	unsigned int tsgls;
-	char iv[];
+	struct sock *sk;
+
+	struct aead_rsgl first_rsgl;	/* First RX SG */
+	struct list_head rsgl_list;	/* Track RX SGs */
+
+	struct scatterlist *tsgl;	/* priv. TX SGL of buffers to process */
+	unsigned int tsgl_entries;	/* number of entries in priv. TX SGL */
+
+	unsigned int outlen;		/* Filled output buf length */
+
+	unsigned int areqlen;		/* Length of this data struct */
+	struct aead_request aead_req;	/* req ctx trails this struct */
 };
 
 struct aead_ctx {
-	struct aead_sg_list tsgl;
-	struct aead_async_rsgl first_rsgl;
-	struct list_head list;
+	struct list_head tsgl_list;	/* Link to TX SGL */
 
 	void *iv;
+	size_t aead_assoclen;
 
-	struct af_alg_completion completion;
+	struct af_alg_completion completion;	/* sync work queue */
 
-	unsigned long used;
+	unsigned int inflight;	/* Outstanding AIO ops */
+	size_t used;		/* TX bytes sent to kernel */
 
-	unsigned int len;
-	bool more;
-	bool merge;
-	bool enc;
+	bool more;		/* More data to be expected? */
+	bool merge;		/* Merge new data into existing SG */
+	bool enc;		/* Crypto operation: enc, dec */
 
-	size_t aead_assoclen;
-	struct aead_request aead_req;
+	unsigned int len;	/* Length of allocated memory for this struct */
+	struct crypto_aead *aead_tfm;
 };
 
+static DECLARE_WAIT_QUEUE_HEAD(aead_aio_finish_wait);
+
+#define MAX_SGL_ENTS ((4096 - sizeof(struct aead_tsgl)) / \
+		      sizeof(struct scatterlist) - 1)
+
 static inline int aead_sndbuf(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -79,7 +105,7 @@ static inline bool aead_writable(struct sock *sk)
 
 static inline bool aead_sufficient_data(struct aead_ctx *ctx)
 {
-	unsigned as = crypto_aead_authsize(crypto_aead_reqtfm(&ctx->aead_req));
+	unsigned int as = crypto_aead_authsize(ctx->aead_tfm);
 
 	/*
 	 * The minimum amount of memory needed for an AEAD cipher is
@@ -88,33 +114,166 @@ static inline bool aead_sufficient_data(struct aead_ctx *ctx)
 	return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as);
 }
 
-static void aead_reset_ctx(struct aead_ctx *ctx)
+static int aead_alloc_tsgl(struct sock *sk)
 {
-	struct aead_sg_list *sgl = &ctx->tsgl;
+	struct alg_sock *ask = alg_sk(sk);
+	struct aead_ctx *ctx = ask->private;
+	struct aead_tsgl *sgl;
+	struct scatterlist *sg = NULL;
 
-	sg_init_table(sgl->sg, ALG_MAX_PAGES);
-	sgl->cur = 0;
-	ctx->used = 0;
-	ctx->more = 0;
-	ctx->merge = 0;
+	sgl = list_entry(ctx->tsgl_list.prev, struct aead_tsgl, list);
+	if (!list_empty(&ctx->tsgl_list))
+		sg = sgl->sg;
+
+	if (!sg || sgl->cur >= MAX_SGL_ENTS) {
+		sgl = sock_kmalloc(sk, sizeof(*sgl) +
+				       sizeof(sgl->sg[0]) * (MAX_SGL_ENTS + 1),
+				   GFP_KERNEL);
+		if (!sgl)
+			return -ENOMEM;
+
+		sg_init_table(sgl->sg, MAX_SGL_ENTS + 1);
+		sgl->cur = 0;
+
+		if (sg)
+			sg_chain(sg, MAX_SGL_ENTS + 1, sgl->sg);
+
+		list_add_tail(&sgl->list, &ctx->tsgl_list);
+	}
+
+	return 0;
+}
+
+static unsigned int aead_count_tsgl(struct sock *sk, size_t bytes)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct aead_ctx *ctx = ask->private;
+	struct aead_tsgl *sgl;
+	struct scatterlist *sg;
+	unsigned int i;
+	unsigned int sgl_count = 0;
+
+	if (!bytes)
+		return 0;
+
+	while (!list_empty(&ctx->tsgl_list)) {
+		sgl = list_first_entry(&ctx->tsgl_list, struct aead_tsgl,
+				       list);
+		sg = sgl->sg;
+
+		for (i = 0; i < sgl->cur; i++) {
+			sgl_count++;
+			if (sg[i].length >= bytes)
+				return sgl_count;
+
+			bytes -= sg[i].length;
+		}
+	}
+
+	return sgl_count;
 }
 
-static void aead_put_sgl(struct sock *sk)
+static void aead_pull_tsgl(struct sock *sk, size_t used,
+			   struct scatterlist *dst)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	struct aead_sg_list *sgl = &ctx->tsgl;
-	struct scatterlist *sg = sgl->sg;
+	struct aead_tsgl *sgl;
+	struct scatterlist *sg;
 	unsigned int i;
 
-	for (i = 0; i < sgl->cur; i++) {
-		if (!sg_page(sg + i))
+	while (!list_empty(&ctx->tsgl_list)) {
+		sgl = list_first_entry(&ctx->tsgl_list, struct aead_tsgl,
+				       list);
+		sg = sgl->sg;
+
+		for (i = 0; i < sgl->cur; i++) {
+			size_t plen = min_t(size_t, used, sg[i].length);
+			struct page *page = sg_page(sg + i);
+
+			if (!page)
+				continue;
+
+			/*
+			 * Assumption: caller created aead_count_tsgl(len)
+			 * SG entries in dst.
+			 */
+			if (dst)
+				sg_set_page(dst + i, page, plen, sg[i].offset);
+
+			sg[i].length -= plen;
+			sg[i].offset += plen;
+
+			used -= plen;
+			ctx->used -= plen;
+
+			if (sg[i].length)
+				return;
+
+			if (!dst)
+				put_page(page);
+			sg_assign_page(sg + i, NULL);
+		}
+
+		list_del(&sgl->list);
+		sock_kfree_s(sk, sgl, sizeof(*sgl) + sizeof(sgl->sg[0]) *
+						     (MAX_SGL_ENTS + 1));
+	}
+
+	if (!ctx->used)
+		ctx->merge = 0;
+}
+
+static void aead_free_areq_sgls(struct aead_async_req *areq)
+{
+	struct sock *sk = areq->sk;
+	struct aead_rsgl *rsgl, *tmp;
+	struct scatterlist *tsgl;
+	struct scatterlist *sg;
+	unsigned int i;
+
+	list_for_each_entry_safe(rsgl, tmp, &areq->rsgl_list, list) {
+		af_alg_free_sg(&rsgl->sgl);
+		list_del(&rsgl->list);
+		if (rsgl != &areq->first_rsgl)
+			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
+	}
+
+	tsgl = areq->tsgl;
+	for_each_sg(tsgl, sg, areq->tsgl_entries, i) {
+		if (!sg_page(sg))
 			continue;
+		put_page(sg_page(sg));
+	}
+
+	if (areq->tsgl && areq->tsgl_entries)
+		sock_kfree_s(sk, tsgl, areq->tsgl_entries * sizeof(*tsgl));
+}
 
-		put_page(sg_page(sg + i));
-		sg_assign_page(sg + i, NULL);
+static int aead_wait_for_wmem(struct sock *sk, unsigned flags)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	int err = -ERESTARTSYS;
+	long timeout;
+
+	if (flags & MSG_DONTWAIT)
+		return -EAGAIN;
+
+	sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	for (;;) {
+		if (signal_pending(current))
+			break;
+		timeout = MAX_SCHEDULE_TIMEOUT;
+		if (sk_wait_event(sk, &timeout, aead_writable(sk), &wait)) {
+			err = 0;
+			break;
+		}
 	}
-	aead_reset_ctx(ctx);
+	remove_wait_queue(sk_sleep(sk), &wait);
+
+	return err;
 }
 
 static void aead_wmem_wakeup(struct sock *sk)
@@ -146,6 +305,7 @@ static int aead_wait_for_data(struct sock *sk, unsigned flags)
 		return -EAGAIN;
 
 	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+
 	add_wait_queue(sk_sleep(sk), &wait);
 	for (;;) {
 		if (signal_pending(current))
@@ -169,8 +329,6 @@ static void aead_data_wakeup(struct sock *sk)
 	struct aead_ctx *ctx = ask->private;
 	struct socket_wq *wq;
 
-	if (ctx->more)
-		return;
 	if (!ctx->used)
 		return;
 
@@ -189,14 +347,13 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	unsigned ivsize =
-		crypto_aead_ivsize(crypto_aead_reqtfm(&ctx->aead_req));
-	struct aead_sg_list *sgl = &ctx->tsgl;
+	unsigned int ivsize = crypto_aead_ivsize(ctx->aead_tfm);
+	struct aead_tsgl *sgl;
 	struct af_alg_control con = {};
 	long copied = 0;
 	bool enc = 0;
 	bool init = 0;
-	int err = -EINVAL;
+	int err = 0;
 
 	if (msg->msg_controllen) {
 		err = af_alg_cmsg_send(msg, &con);
@@ -220,8 +377,10 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	}
 
 	lock_sock(sk);
-	if (!ctx->more && ctx->used)
+	if (!ctx->more && ctx->used) {
+		err = -EINVAL;
 		goto unlock;
+	}
 
 	if (init) {
 		ctx->enc = enc;
@@ -232,11 +391,14 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	}
 
 	while (size) {
+		struct scatterlist *sg;
 		size_t len = size;
-		struct scatterlist *sg = NULL;
+		size_t plen;
 
 		/* use the existing memory in an allocated page */
 		if (ctx->merge) {
+			sgl = list_entry(ctx->tsgl_list.prev,
+					 struct aead_tsgl, list);
 			sg = sgl->sg + sgl->cur - 1;
 			len = min_t(unsigned long, len,
 				    PAGE_SIZE - sg->offset - sg->length);
@@ -257,57 +419,60 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		}
 
 		if (!aead_writable(sk)) {
-			/* user space sent too much data */
-			aead_put_sgl(sk);
-			err = -EMSGSIZE;
-			goto unlock;
+			err = aead_wait_for_wmem(sk, msg->msg_flags);
+			if (err)
+				goto unlock;
 		}
 
 		/* allocate a new page */
 		len = min_t(unsigned long, size, aead_sndbuf(sk));
-		while (len) {
-			size_t plen = 0;
 
-			if (sgl->cur >= ALG_MAX_PAGES) {
-				aead_put_sgl(sk);
-				err = -E2BIG;
-				goto unlock;
-			}
+		err = aead_alloc_tsgl(sk);
+		if (err)
+			goto unlock;
+
+		sgl = list_entry(ctx->tsgl_list.prev, struct aead_tsgl,
+				 list);
+		sg = sgl->sg;
+		if (sgl->cur)
+			sg_unmark_end(sg + sgl->cur - 1);
+
+		do {
+			unsigned int i = sgl->cur;
 
-			sg = sgl->sg + sgl->cur;
 			plen = min_t(size_t, len, PAGE_SIZE);
 
-			sg_assign_page(sg, alloc_page(GFP_KERNEL));
-			err = -ENOMEM;
-			if (!sg_page(sg))
+			sg_assign_page(sg + i, alloc_page(GFP_KERNEL));
+			if (!sg_page(sg + i)) {
+				err = -ENOMEM;
 				goto unlock;
+			}
 
-			err = memcpy_from_msg(page_address(sg_page(sg)),
+			err = memcpy_from_msg(page_address(sg_page(sg + i)),
 					      msg, plen);
 			if (err) {
-				__free_page(sg_page(sg));
-				sg_assign_page(sg, NULL);
+				__free_page(sg_page(sg + i));
+				sg_assign_page(sg + i, NULL);
 				goto unlock;
 			}
 
-			sg->offset = 0;
-			sg->length = plen;
+			sg[i].length = plen;
 			len -= plen;
 			ctx->used += plen;
 			copied += plen;
-			sgl->cur++;
 			size -= plen;
-			ctx->merge = plen & (PAGE_SIZE - 1);
-		}
+			sgl->cur++;
+		} while (len && sgl->cur < MAX_SGL_ENTS);
+
+		if (!size)
+			sg_mark_end(sg + sgl->cur - 1);
+
+		ctx->merge = plen & (PAGE_SIZE - 1);
 	}
 
 	err = 0;
 
 	ctx->more = msg->msg_flags & MSG_MORE;
-	if (!ctx->more && !aead_sufficient_data(ctx)) {
-		aead_put_sgl(sk);
-		err = -EMSGSIZE;
-	}
 
 unlock:
 	aead_data_wakeup(sk);
@@ -322,15 +487,12 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	struct aead_sg_list *sgl = &ctx->tsgl;
+	struct aead_tsgl *sgl;
 	int err = -EINVAL;
 
 	if (flags & MSG_SENDPAGE_NOTLAST)
 		flags |= MSG_MORE;
 
-	if (sgl->cur >= ALG_MAX_PAGES)
-		return -E2BIG;
-
 	lock_sock(sk);
 	if (!ctx->more && ctx->used)
 		goto unlock;
@@ -339,13 +501,22 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 		goto done;
 
 	if (!aead_writable(sk)) {
-		/* user space sent too much data */
-		aead_put_sgl(sk);
-		err = -EMSGSIZE;
-		goto unlock;
+		err = aead_wait_for_wmem(sk, flags);
+		if (err)
+			goto unlock;
 	}
 
+	err = aead_alloc_tsgl(sk);
+	if (err)
+		goto unlock;
+
 	ctx->merge = 0;
+	sgl = list_entry(ctx->tsgl_list.prev, struct aead_tsgl, list);
+
+	if (sgl->cur)
+		sg_unmark_end(sgl->sg + sgl->cur - 1);
+
+	sg_mark_end(sgl->sg + sgl->cur);
 
 	get_page(page);
 	sg_set_page(sgl->sg + sgl->cur, page, size, offset);
@@ -356,11 +527,6 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 
 done:
 	ctx->more = flags & MSG_MORE;
-	if (!ctx->more && !aead_sufficient_data(ctx)) {
-		aead_put_sgl(sk);
-		err = -EMSGSIZE;
-	}
-
 unlock:
 	aead_data_wakeup(sk);
 	release_sock(sk);
@@ -368,205 +534,58 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 	return err ?: size;
 }
 
-#define GET_ASYM_REQ(req, tfm) (struct aead_async_req *) \
-		((char *)req + sizeof(struct aead_request) + \
-		 crypto_aead_reqsize(tfm))
-
- #define GET_REQ_SIZE(tfm) sizeof(struct aead_async_req) + \
-	crypto_aead_reqsize(tfm) + crypto_aead_ivsize(tfm) + \
-	sizeof(struct aead_request)
-
 static void aead_async_cb(struct crypto_async_request *_req, int err)
 {
-	struct sock *sk = _req->data;
+	struct aead_async_req *areq = _req->data;
+	struct sock *sk = areq->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(&ctx->aead_req);
-	struct aead_request *req = aead_request_cast(_req);
-	struct aead_async_req *areq = GET_ASYM_REQ(req, tfm);
-	struct scatterlist *sg = areq->tsgl;
-	struct aead_async_rsgl *rsgl;
 	struct kiocb *iocb = areq->iocb;
-	unsigned int i, reqlen = GET_REQ_SIZE(tfm);
-
-	list_for_each_entry(rsgl, &areq->list, list) {
-		af_alg_free_sg(&rsgl->sgl);
-		if (rsgl != &areq->first_rsgl)
-			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
-	}
-
-	for (i = 0; i < areq->tsgls; i++)
-		put_page(sg_page(sg + i));
-
-	sock_kfree_s(sk, areq->tsgl, sizeof(*areq->tsgl) * areq->tsgls);
-	sock_kfree_s(sk, req, reqlen);
-	__sock_put(sk);
-	iocb->ki_complete(iocb, err, err);
-}
-
-static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
-			      int flags)
-{
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(&ctx->aead_req);
-	struct aead_async_req *areq;
-	struct aead_request *req = NULL;
-	struct aead_sg_list *sgl = &ctx->tsgl;
-	struct aead_async_rsgl *last_rsgl = NULL, *rsgl;
-	unsigned int as = crypto_aead_authsize(tfm);
-	unsigned int i, reqlen = GET_REQ_SIZE(tfm);
-	int err = -ENOMEM;
-	unsigned long used;
-	size_t outlen = 0;
-	size_t usedpages = 0;
+	unsigned int resultlen;
 
 	lock_sock(sk);
-	if (ctx->more) {
-		err = aead_wait_for_data(sk, flags);
-		if (err)
-			goto unlock;
-	}
-
-	if (!aead_sufficient_data(ctx))
-		goto unlock;
-
-	used = ctx->used;
-	if (ctx->enc)
-		outlen = used + as;
-	else
-		outlen = used - as;
-
-	req = sock_kmalloc(sk, reqlen, GFP_KERNEL);
-	if (unlikely(!req))
-		goto unlock;
-
-	areq = GET_ASYM_REQ(req, tfm);
-	memset(&areq->first_rsgl, '\0', sizeof(areq->first_rsgl));
-	INIT_LIST_HEAD(&areq->list);
-	areq->iocb = msg->msg_iocb;
-	memcpy(areq->iv, ctx->iv, crypto_aead_ivsize(tfm));
-	aead_request_set_tfm(req, tfm);
-	aead_request_set_ad(req, ctx->aead_assoclen);
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  aead_async_cb, sk);
-	used -= ctx->aead_assoclen;
-
-	/* take over all tx sgls from ctx */
-	areq->tsgl = sock_kmalloc(sk,
-				  sizeof(*areq->tsgl) * max_t(u32, sgl->cur, 1),
-				  GFP_KERNEL);
-	if (unlikely(!areq->tsgl))
-		goto free;
-
-	sg_init_table(areq->tsgl, max_t(u32, sgl->cur, 1));
-	for (i = 0; i < sgl->cur; i++)
-		sg_set_page(&areq->tsgl[i], sg_page(&sgl->sg[i]),
-			    sgl->sg[i].length, sgl->sg[i].offset);
-
-	areq->tsgls = sgl->cur;
-
-	/* create rx sgls */
-	while (outlen > usedpages && iov_iter_count(&msg->msg_iter)) {
-		size_t seglen = min_t(size_t, iov_iter_count(&msg->msg_iter),
-				      (outlen - usedpages));
-
-		if (list_empty(&areq->list)) {
-			rsgl = &areq->first_rsgl;
 
-		} else {
-			rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
-			if (unlikely(!rsgl)) {
-				err = -ENOMEM;
-				goto free;
-			}
-		}
-		rsgl->sgl.npages = 0;
-		list_add_tail(&rsgl->list, &areq->list);
+	BUG_ON(!ctx->inflight);
 
-		/* make one iovec available as scatterlist */
-		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
-		if (err < 0)
-			goto free;
-
-		usedpages += err;
+	/* Buffer size written by crypto operation. */
+	resultlen = areq->outlen;
 
-		/* chain the new scatterlist with previous one */
-		if (last_rsgl)
-			af_alg_link_sg(&last_rsgl->sgl, &rsgl->sgl);
-
-		last_rsgl = rsgl;
-
-		iov_iter_advance(&msg->msg_iter, err);
-	}
-
-	/* ensure output buffer is sufficiently large */
-	if (usedpages < outlen) {
-		err = -EINVAL;
-		goto unlock;
-	}
+	aead_free_areq_sgls(areq);
+	sock_kfree_s(sk, areq, areq->areqlen);
+	__sock_put(sk);
+	ctx->inflight--;
 
-	aead_request_set_crypt(req, areq->tsgl, areq->first_rsgl.sgl.sg, used,
-			       areq->iv);
-	err = ctx->enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
-	if (err) {
-		if (err == -EINPROGRESS) {
-			sock_hold(sk);
-			err = -EIOCBQUEUED;
-			aead_reset_ctx(ctx);
-			goto unlock;
-		} else if (err == -EBADMSG) {
-			aead_put_sgl(sk);
-		}
-		goto free;
-	}
-	aead_put_sgl(sk);
+	iocb->ki_complete(iocb, err ? err : resultlen, 0);
 
-free:
-	list_for_each_entry(rsgl, &areq->list, list) {
-		af_alg_free_sg(&rsgl->sgl);
-		if (rsgl != &areq->first_rsgl)
-			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
-	}
-	if (areq->tsgl)
-		sock_kfree_s(sk, areq->tsgl, sizeof(*areq->tsgl) * areq->tsgls);
-	if (req)
-		sock_kfree_s(sk, req, reqlen);
-unlock:
-	aead_wmem_wakeup(sk);
 	release_sock(sk);
-	return err ? err : outlen;
+
+	wake_up_interruptible(&aead_aio_finish_wait);
 }
 
-static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
+static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t ignored,
+			int flags)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	unsigned as = crypto_aead_authsize(crypto_aead_reqtfm(&ctx->aead_req));
-	struct aead_sg_list *sgl = &ctx->tsgl;
-	struct aead_async_rsgl *last_rsgl = NULL;
-	struct aead_async_rsgl *rsgl, *tmp;
+	struct crypto_aead *tfm = ctx->aead_tfm;
+	unsigned int as = crypto_aead_authsize(tfm);
+	unsigned int areqlen =
+		sizeof(struct aead_async_req) + crypto_aead_reqsize(tfm);
+	struct aead_async_req *areq;
+	struct aead_rsgl *last_rsgl = NULL;
 	int err = -EINVAL;
-	unsigned long used = 0;
-	size_t outlen = 0;
-	size_t usedpages = 0;
+	size_t used = 0;		/* [in]  TX bufs to be en/decrypted */
+	size_t outlen = 0;		/* [out] RX bufs produced by kernel */
+	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
+	size_t processed = 0;		/* [in]  TX bufs to be consumed */
 
 	lock_sock(sk);
 
 	/*
-	 * Please see documentation of aead_request_set_crypt for the
-	 * description of the AEAD memory structure expected from the caller.
+	 * Data length provided by caller via sendmsg/sendpage that has not
+	 * yet been processed.
 	 */
-
-	if (ctx->more) {
-		err = aead_wait_for_data(sk, flags);
-		if (err)
-			goto unlock;
-	}
-
-	/* data length provided by caller via sendmsg/sendpage */
 	used = ctx->used;
 
 	/*
@@ -600,96 +619,151 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 	 */
 	used -= ctx->aead_assoclen;
 
-	/* convert iovecs of output buffers into scatterlists */
+	/* Allocate cipher request for current operation. */
+	areq = sock_kmalloc(sk, areqlen, GFP_KERNEL);
+	if (unlikely(!areq)) {
+		err = -ENOMEM;
+		goto unlock;
+	}
+	areq->areqlen = areqlen;
+	areq->sk = sk;
+	INIT_LIST_HEAD(&areq->rsgl_list);
+	areq->tsgl = NULL;
+	areq->tsgl_entries = 0;
+
+	/* convert iovecs of output buffers into RX SGL */
 	while (outlen > usedpages && iov_iter_count(&msg->msg_iter)) {
-		size_t seglen = min_t(size_t, iov_iter_count(&msg->msg_iter),
-				      (outlen - usedpages));
+		struct aead_rsgl *rsgl;
+		size_t seglen;
+
+		if (!ctx->used) {
+			err = aead_wait_for_data(sk, flags);
+			if (err)
+				goto free;
+		}
+
+		seglen = min_t(size_t, (outlen - usedpages),
+			       iov_iter_count(&msg->msg_iter));
 
-		if (list_empty(&ctx->list)) {
-			rsgl = &ctx->first_rsgl;
+		if (list_empty(&areq->rsgl_list)) {
+			rsgl = &areq->first_rsgl;
 		} else {
 			rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
 			if (unlikely(!rsgl)) {
 				err = -ENOMEM;
-				goto unlock;
+				goto free;
 			}
 		}
+
 		rsgl->sgl.npages = 0;
-		list_add_tail(&rsgl->list, &ctx->list);
+		list_add_tail(&rsgl->list, &areq->rsgl_list);
 
 		/* make one iovec available as scatterlist */
 		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
 		if (err < 0)
-			goto unlock;
-		usedpages += err;
+			goto free;
+
 		/* chain the new scatterlist with previous one */
 		if (last_rsgl)
 			af_alg_link_sg(&last_rsgl->sgl, &rsgl->sgl);
 
 		last_rsgl = rsgl;
-
+		usedpages += err;
 		iov_iter_advance(&msg->msg_iter, err);
 	}
 
-	/* ensure output buffer is sufficiently large */
+	/*
+	 * Ensure output buffer is sufficiently large. If the caller provides
+	 * less buffer space, only use the relative required input size. This
+	 * allows AIO operation where the caller sent all data to be processed
+	 * and the AIO operation performs the operation on the different chunks
+	 * of the input data.
+	 */
 	if (usedpages < outlen) {
-		err = -EINVAL;
-		goto unlock;
-	}
+		size_t less = outlen - usedpages;
 
-	sg_mark_end(sgl->sg + sgl->cur - 1);
-	aead_request_set_crypt(&ctx->aead_req, sgl->sg, ctx->first_rsgl.sgl.sg,
-			       used, ctx->iv);
-	aead_request_set_ad(&ctx->aead_req, ctx->aead_assoclen);
+		if (used < less) {
+			err = -EINVAL;
+			goto free;
+		}
+		used -= less;
+		outlen -= less;
+	}
 
-	err = af_alg_wait_for_completion(ctx->enc ?
-					 crypto_aead_encrypt(&ctx->aead_req) :
-					 crypto_aead_decrypt(&ctx->aead_req),
+	/*
+	 * Create a per request TX SGL for this request which tracks the
+	 * SG entries from the global TX SGL.
+	 */
+	processed = used + ctx->aead_assoclen;
+	areq->tsgl_entries = aead_count_tsgl(sk, processed);
+	if (!areq->tsgl_entries)
+		areq->tsgl_entries = 1;
+	areq->tsgl = sock_kmalloc(sk, sizeof(*areq->tsgl) * areq->tsgl_entries,
+				  GFP_KERNEL);
+	if (!areq->tsgl) {
+		err = -ENOMEM;
+		goto free;
+	}
+	sg_init_table(areq->tsgl, areq->tsgl_entries);
+	aead_pull_tsgl(sk, processed, areq->tsgl);
+
+	/* Initialize the crypto operation */
+	aead_request_set_crypt(&areq->aead_req, areq->tsgl,
+			       areq->first_rsgl.sgl.sg, used, ctx->iv);
+	aead_request_set_ad(&areq->aead_req, ctx->aead_assoclen);
+	aead_request_set_tfm(&areq->aead_req, tfm);
+
+	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
+		/* AIO operation */
+		areq->iocb = msg->msg_iocb;
+		aead_request_set_callback(&areq->aead_req,
+					  CRYPTO_TFM_REQ_MAY_BACKLOG,
+					  aead_async_cb, areq);
+		err = ctx->enc ? crypto_aead_encrypt(&areq->aead_req) :
+				 crypto_aead_decrypt(&areq->aead_req);
+	} else {
+		/* Synchronous operation */
+		aead_request_set_callback(&areq->aead_req,
+					  CRYPTO_TFM_REQ_MAY_BACKLOG,
+					  af_alg_complete, &ctx->completion);
+		err = af_alg_wait_for_completion(ctx->enc ?
+					 crypto_aead_encrypt(&areq->aead_req) :
+					 crypto_aead_decrypt(&areq->aead_req),
 					 &ctx->completion);
+	}
 
-	if (err) {
-		/* EBADMSG implies a valid cipher operation took place */
-		if (err == -EBADMSG)
-			aead_put_sgl(sk);
+	/* AIO operation in progress */
+	if (err == -EINPROGRESS) {
+		sock_hold(sk);
+		err = -EIOCBQUEUED;
+		ctx->inflight++;
+
+		/* Remember output size that will be generated. */
+		areq->outlen = outlen;
 
 		goto unlock;
 	}
 
-	aead_put_sgl(sk);
-	err = 0;
+free:
+	aead_free_areq_sgls(areq);
+	if (areq)
+		sock_kfree_s(sk, areq, areqlen);
 
 unlock:
-	list_for_each_entry_safe(rsgl, tmp, &ctx->list, list) {
-		af_alg_free_sg(&rsgl->sgl);
-		list_del(&rsgl->list);
-		if (rsgl != &ctx->first_rsgl)
-			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
-	}
-	INIT_LIST_HEAD(&ctx->list);
 	aead_wmem_wakeup(sk);
 	release_sock(sk);
-
 	return err ? err : outlen;
 }
 
-static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t ignored,
-			int flags)
-{
-	return (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) ?
-		aead_recvmsg_async(sock, msg, flags) :
-		aead_recvmsg_sync(sock, msg, flags);
-}
-
 static unsigned int aead_poll(struct file *file, struct socket *sock,
 			      poll_table *wait)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	unsigned int mask;
+	unsigned int mask = 0;
 
 	sock_poll_wait(file, sk_sleep(sk), wait);
-	mask = 0;
 
 	if (!ctx->more)
 		mask |= POLLIN | POLLRDNORM;
@@ -746,11 +820,14 @@ static void aead_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	unsigned int ivlen = crypto_aead_ivsize(
-				crypto_aead_reqtfm(&ctx->aead_req));
+	unsigned int ivlen = crypto_aead_ivsize(ctx->aead_tfm);
 
 	WARN_ON(atomic_read(&sk->sk_refcnt) != 0);
-	aead_put_sgl(sk);
+
+	/* Suspend caller if AIO operations are in flight. */
+	wait_event_interruptible(aead_aio_finish_wait, (ctx->inflight == 0));
+
+	aead_pull_tsgl(sk, ctx->used, NULL);
 	sock_kzfree_s(sk, ctx->iv, ivlen);
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
@@ -760,7 +837,7 @@ static int aead_accept_parent(void *private, struct sock *sk)
 {
 	struct aead_ctx *ctx;
 	struct alg_sock *ask = alg_sk(sk);
-	unsigned int len = sizeof(*ctx) + crypto_aead_reqsize(private);
+	unsigned int len = sizeof(*ctx);
 	unsigned int ivlen = crypto_aead_ivsize(private);
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
@@ -775,23 +852,19 @@ static int aead_accept_parent(void *private, struct sock *sk)
 	}
 	memset(ctx->iv, 0, ivlen);
 
+	INIT_LIST_HEAD(&ctx->tsgl_list);
 	ctx->len = len;
 	ctx->used = 0;
 	ctx->more = 0;
 	ctx->merge = 0;
 	ctx->enc = 0;
-	ctx->tsgl.cur = 0;
+	ctx->inflight = 0;
 	ctx->aead_assoclen = 0;
 	af_alg_init_completion(&ctx->completion);
-	sg_init_table(ctx->tsgl.sg, ALG_MAX_PAGES);
-	INIT_LIST_HEAD(&ctx->list);
 
+	ctx->aead_tfm = private;
 	ask->private = ctx;
 
-	aead_request_set_tfm(&ctx->aead_req, private);
-	aead_request_set_callback(&ctx->aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  af_alg_complete, &ctx->completion);
-
 	sk->sk_destruct = aead_sock_destruct;
 
 	return 0;
-- 
2.9.3
