From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 8/8] crypto: AF_ALG - add KPP support
Date: Wed, 19 Apr 2017 01:07:42 +0200
Message-ID: <22964427.MDHKr9fs2H@positron.chronox.de>
References: <2715753.J0rCo2lbig@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: keyrings@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58992 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758132AbdDRXKF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 19:10:05 -0400
In-Reply-To: <2715753.J0rCo2lbig@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The patch externalizes the KPP kernel crypto API to user space. This
allows user space to make use of Diffie-Hellman and EC Diffie-Hellman
operations.

The following operations are supported:

 * DH parameters formatted in PKCS#3 with ALG_SET_DH_PARAMETERS
   setsockopt. The call returns the buffer length user space must
   allocate for the shared secret / public key operation.

 * ECDH curve selection via ALG_SET_ECDH_CURVE setsockopt. The call
   returns the buffer length user space must allocate for the shared
   secret / public key operation.

 * The private key can be set with the ALG_SET_KEY setsockopt. It is
   permissible to provide a NULL key. In this case, the kernel uses the
   stdrng to generate a private key of appropriate size and sets the key
   with the TFM. The idea is that the caller can obtain the public key
   from the private key, exchange it with the peer, inject the peer's
   public key into the kernel and derive the shared secret. This way,
   the private key does not leave the kernel realm. The call returns the
   buffer length user space must allocate for the shared secret / public
   key operation.

 * The public key is obtained from the private key via the recvmsg
   operation. For this operation, no data sent to the kernel via sendmsg
   or sendpage is required.

 * The shared secret is obtained by providing the peer's public key via
   sendmsg / sendpage and reading the shared secret via recvmsg.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig     |   10 +
 crypto/Makefile    |    1 +
 crypto/algif_kpp.c | 1230 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1241 insertions(+)
 create mode 100644 crypto/algif_kpp.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index aac4bc9..cf59f76 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1757,6 +1757,16 @@ config CRYPTO_USER_API_AEAD
 	  This option enables the user-spaces interface for AEAD
 	  cipher algorithms.
 
+config CRYPTO_USER_API_KPP
+	tristate "User-space interface for key protocol primitives algorithms"
+	depends on NET
+	select CRYPTO_KPP2
+	select CRYPTO_USER_API
+	help
+	  This option enables the user-spaces interface for key protocol
+	  primitives algorithms. This covers Diffie-Hellman and EC
+	  Diffie-Hellman
+
 config CRYPTO_HASH_INFO
 	bool
 
diff --git a/crypto/Makefile b/crypto/Makefile
index a25cfdd..45d861b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -142,6 +142,7 @@ obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
+obj-$(CONFIG_CRYPTO_USER_API_KPP) += algif_kpp.o
 
 #
 # generic algorithms and the async_tx api
diff --git a/crypto/algif_kpp.c b/crypto/algif_kpp.c
new file mode 100644
index 0000000..664b517
--- /dev/null
+++ b/crypto/algif_kpp.c
@@ -0,0 +1,1230 @@
+/*
+ * algif_kpp: User-space interface for key protocol primitives algorithms
+ *
+ * Copyright (C) 2017, Stephan Mueller <smueller@chronox.de>
+ *
+ * This file provides the user-space API for key protocol primitives.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
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
+ */
+
+#include <crypto/kpp.h>
+#include <crypto/dh.h>
+#include <crypto/ecdh.h>
+#include <crypto/rng.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/if_alg.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/kernel.h>
+#include <linux/sched/signal.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/net.h>
+#include <net/sock.h>
+
+struct kpp_tsgl {
+	struct list_head list;
+	unsigned int cur;		/* Last processed SG entry */
+	struct scatterlist sg[0];	/* Array of SGs forming the SGL */
+};
+
+struct kpp_rsgl {
+	struct af_alg_sgl sgl;
+	struct list_head list;
+	size_t sg_num_bytes;		/* Bytes of data in that SGL */
+};
+
+struct kpp_async_req {
+	struct kiocb *iocb;
+	struct sock *sk;
+
+	struct kpp_rsgl first_rsgl;	/* First RX SG */
+	struct list_head rsgl_list;	/* Track RX SGs */
+
+	struct scatterlist *tsgl;	/* priv. TX SGL of buffers to process */
+	unsigned int tsgl_entries;	/* number of entries in priv. TX SGL */
+
+	unsigned int areqlen;		/* Length of this data struct */
+	struct kpp_request req;		/* req ctx trails this struct */
+};
+
+struct kpp_tfm {
+	struct crypto_kpp *kpp;
+	bool has_key;
+
+#define KPP_NO_PARAMS	0
+#define KPP_DH_PARAMS	1
+#define KPP_ECDH_PARAMS	2
+	int has_params;		/* Type of KPP mechanism */
+};
+
+struct kpp_ctx {
+	struct list_head tsgl_list;	/* Link to TX SGL */
+
+	struct af_alg_completion completion;	/* sync work queue */
+
+	unsigned int inflight;	/* Outstanding AIO ops */
+	size_t used;		/* TX bytes sent to kernel */
+	size_t rcvused;		/* total RX bytes to be processed by kernel */
+
+	bool more;		/* More data to be expected? */
+	bool merge;		/* Merge new data into existing SG */
+	int op;			/* Crypto operation: enc, dec, sign, verify */
+
+	unsigned int len;	/* Length of allocated memory for this struct */
+};
+
+static DECLARE_WAIT_QUEUE_HEAD(kpp_aio_finish_wait);
+
+#define MAX_SGL_ENTS ((4096 - sizeof(struct kpp_tsgl)) / \
+		      sizeof(struct scatterlist) - 1)
+
+static inline int kpp_sndbuf(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct kpp_ctx *ctx = ask->private;
+
+	return max_t(int, max_t(int, sk->sk_sndbuf & PAGE_MASK, PAGE_SIZE) -
+			  ctx->used, 0);
+}
+
+static inline bool kpp_writable(struct sock *sk)
+{
+	return PAGE_SIZE <= kpp_sndbuf(sk);
+}
+
+static inline int kpp_rcvbuf(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct kpp_ctx *ctx = ask->private;
+
+	return max_t(int, max_t(int, sk->sk_rcvbuf & PAGE_MASK, PAGE_SIZE) -
+			  ctx->rcvused, 0);
+}
+
+static inline bool kpp_readable(struct sock *sk)
+{
+	return PAGE_SIZE <= kpp_rcvbuf(sk);
+}
+
+static int kpp_alloc_tsgl(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct kpp_ctx *ctx = ask->private;
+	struct kpp_tsgl *sgl;
+	struct scatterlist *sg = NULL;
+
+	sgl = list_entry(ctx->tsgl_list.prev, struct kpp_tsgl, list);
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
+static unsigned int kpp_count_tsgl(struct sock *sk, size_t bytes)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct kpp_ctx *ctx = ask->private;
+	struct kpp_tsgl *sgl, *tmp;
+	unsigned int i;
+	unsigned int sgl_count = 0;
+
+	if (!bytes)
+		return 0;
+
+	list_for_each_entry_safe(sgl, tmp, &ctx->tsgl_list, list) {
+		struct scatterlist *sg = sgl->sg;
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
+}
+
+static void kpp_pull_tsgl(struct sock *sk, size_t used,
+			       struct scatterlist *dst)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct kpp_ctx *ctx = ask->private;
+	struct kpp_tsgl *sgl;
+	struct scatterlist *sg;
+	unsigned int i;
+
+	while (!list_empty(&ctx->tsgl_list)) {
+		sgl = list_first_entry(&ctx->tsgl_list, struct kpp_tsgl,
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
+			 * Assumption: caller created kpp_count_tsgl(len)
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
+static void kpp_free_areq_sgl(struct kpp_async_req *areq)
+{
+	struct sock *sk = areq->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct kpp_ctx *ctx = ask->private;
+	struct kpp_rsgl *rsgl, *tmp;
+	struct scatterlist *tsgl;
+	struct scatterlist *sg;
+	unsigned int i;
+
+	list_for_each_entry_safe(rsgl, tmp, &areq->rsgl_list, list) {
+		ctx->rcvused -= rsgl->sg_num_bytes;
+		af_alg_free_sg(&rsgl->sgl);
+		list_del(&rsgl->list);
+		if (rsgl != &areq->first_rsgl)
+			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
+	}
+
+	tsgl = areq->tsgl;
+	for_each_sg(tsgl, sg, areq->tsgl_entries, i) {
+		if (!sg_page(sg))
+			continue;
+		put_page(sg_page(sg));
+	}
+
+	if (areq->tsgl && areq->tsgl_entries)
+		sock_kfree_s(sk, tsgl, areq->tsgl_entries * sizeof(*tsgl));
+}
+
+static int kpp_wait_for_wmem(struct sock *sk, unsigned flags)
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
+		if (sk_wait_event(sk, &timeout, kpp_writable(sk), &wait)) {
+			err = 0;
+			break;
+		}
+	}
+	remove_wait_queue(sk_sleep(sk), &wait);
+
+	return err;
+}
+
+static void kpp_wmem_wakeup(struct sock *sk)
+{
+	struct socket_wq *wq;
+
+	if (!kpp_writable(sk))
+		return;
+
+	rcu_read_lock();
+	wq = rcu_dereference(sk->sk_wq);
+	if (skwq_has_sleeper(wq))
+		wake_up_interruptible_sync_poll(&wq->wait, POLLIN |
+							   POLLRDNORM |
+							   POLLRDBAND);
+	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
+	rcu_read_unlock();
+}
+
+static int kpp_wait_for_data(struct sock *sk, unsigned flags)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	struct alg_sock *ask = alg_sk(sk);
+	struct kpp_ctx *ctx = ask->private;
+	long timeout;
+	int err = -ERESTARTSYS;
+
+	if (flags & MSG_DONTWAIT) {
+		return -EAGAIN;
+	}
+
+	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	for (;;) {
+		if (signal_pending(current))
+			break;
+		timeout = MAX_SCHEDULE_TIMEOUT;
+		if (sk_wait_event(sk, &timeout, ctx->used, &wait)) {
+			err = 0;
+			break;
+		}
+	}
+	remove_wait_queue(sk_sleep(sk), &wait);
+
+	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+
+	return err;
+}
+
+static void kpp_data_wakeup(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct kpp_ctx *ctx = ask->private;
+	struct socket_wq *wq;
+
+	if (!ctx->used)
+		return;
+
+	rcu_read_lock();
+	wq = rcu_dereference(sk->sk_wq);
+	if (skwq_has_sleeper(wq))
+		wake_up_interruptible_sync_poll(&wq->wait, POLLOUT |
+							   POLLRDNORM |
+							   POLLRDBAND);
+	sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
+	rcu_read_unlock();
+}
+
+static int kpp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct kpp_ctx *ctx = ask->private;
+	struct kpp_tsgl *sgl;
+	struct af_alg_control con = {};
+	int copied = 0;
+	int op = 0;
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
+		case ALG_OP_KEYGEN:
+		case ALG_OP_SSGEN:
+			op = con.op;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	lock_sock(sk);
+	if (!ctx->more && ctx->used) {
+		err =  -EINVAL;
+		goto unlock;
+	}
+
+	if (init)
+		ctx->op = op;
+
+	while (size) {
+		struct scatterlist *sg;
+		size_t len = size;
+		size_t plen;
+
+		/* use the existing memory in an allocated page */
+		if (ctx->merge) {
+			sgl = list_entry(ctx->tsgl_list.prev,
+					 struct kpp_tsgl, list);
+			sg = sgl->sg + sgl->cur - 1;
+			len = min_t(size_t, len,
+				    PAGE_SIZE - sg->offset - sg->length);
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
+		if (!kpp_writable(sk)) {
+			err = kpp_wait_for_wmem(sk, msg->msg_flags);
+			if (err)
+				goto unlock;
+		}
+
+		/* allocate a new page */
+		len = min_t(size_t, size, kpp_sndbuf(sk));
+
+		err = kpp_alloc_tsgl(sk);
+		if (err)
+			goto unlock;
+
+		sgl = list_entry(ctx->tsgl_list.prev, struct kpp_tsgl,
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
+	kpp_data_wakeup(sk);
+	release_sock(sk);
+
+	return copied ?: err;
+}
+
+static ssize_t kpp_sendpage(struct socket *sock, struct page *page,
+			    int offset, size_t size, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct kpp_ctx *ctx = ask->private;
+	struct kpp_tsgl *sgl;
+	int err = -EINVAL;
+
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
+	lock_sock(sk);
+	if (!ctx->more && ctx->used)
+		goto unlock;
+
+	if (!size)
+		goto done;
+
+	if (!kpp_writable(sk)) {
+		err = kpp_wait_for_wmem(sk, flags);
+		if (err)
+			goto unlock;
+	}
+
+	err = kpp_alloc_tsgl(sk);
+	if (err)
+		goto unlock;
+
+	ctx->merge = 0;
+	sgl = list_entry(ctx->tsgl_list.prev, struct kpp_tsgl, list);
+
+	if (sgl->cur)
+		sg_unmark_end(sgl->sg + sgl->cur - 1);
+
+	sg_mark_end(sgl->sg + sgl->cur);
+
+	get_page(page);
+	sg_set_page(sgl->sg + sgl->cur, page, size, offset);
+	sgl->cur++;
+	ctx->used += size;
+
+done:
+	ctx->more = flags & MSG_MORE;
+unlock:
+	kpp_data_wakeup(sk);
+	release_sock(sk);
+
+	return err ?: size;
+}
+
+static void kpp_async_cb(struct crypto_async_request *_req, int err)
+{
+	struct kpp_async_req *areq = _req->data;
+	struct sock *sk = areq->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct kpp_ctx *ctx = ask->private;
+	struct kiocb *iocb = areq->iocb;
+	unsigned int resultlen;
+
+	lock_sock(sk);
+
+	BUG_ON(!ctx->inflight);
+
+	/* Buffer size written by crypto operation. */
+	resultlen = areq->req.dst_len;
+
+	kpp_free_areq_sgl(areq);
+	sock_kfree_s(sk, areq, areq->areqlen);
+	__sock_put(sk);
+	ctx->inflight--;
+
+	iocb->ki_complete(iocb, err ? err : resultlen, 0);
+
+	release_sock(sk);
+
+	wake_up_interruptible(&kpp_aio_finish_wait);
+}
+
+static int _kpp_recvmsg(struct socket *sock, struct msghdr *msg,
+			     size_t ignored, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct sock *psk = ask->parent;
+	struct alg_sock *pask = alg_sk(psk);
+	struct kpp_ctx *ctx = ask->private;
+	struct kpp_tfm *kpp = pask->private;
+	struct crypto_kpp *tfm = kpp->kpp;
+
+	unsigned int areqlen = sizeof(struct kpp_async_req) +
+			       crypto_kpp_reqsize(tfm);
+	struct kpp_async_req *areq;
+	struct kpp_rsgl *last_rsgl = NULL;
+	int err = 0;
+	int maxsize;
+	size_t len = 0;
+	size_t used = 0;
+	unsigned int resultlen = 0;
+
+	maxsize = crypto_kpp_maxsize(tfm);
+	if (maxsize < 0)
+		return maxsize;
+
+	/* Allocate cipher request for current operation. */
+	areq = sock_kmalloc(sk, areqlen, GFP_KERNEL);
+	if (unlikely(!areq))
+		return -ENOMEM;
+	areq->areqlen = areqlen;
+	areq->sk = sk;
+	INIT_LIST_HEAD(&areq->rsgl_list);
+	areq->tsgl = NULL;
+	areq->tsgl_entries = 0;
+
+	/* convert iovecs of output buffers into RX SGL */
+	while ((len < maxsize) && msg_data_left(msg)) {
+		struct kpp_rsgl *rsgl;
+		size_t seglen;
+
+		/* limit the amount of readable buffers */
+		if (!kpp_readable(sk))
+			break;
+
+		if ((ctx->op == ALG_OP_SSGEN) && !ctx->used) {
+			err = kpp_wait_for_data(sk, flags);
+			if (err)
+				goto free;
+		}
+
+		seglen = min_t(size_t, (maxsize - len), msg_data_left(msg));
+
+		if (list_empty(&areq->rsgl_list)) {
+			rsgl = &areq->first_rsgl;
+		} else {
+			rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
+			if (!rsgl) {
+				err = -ENOMEM;
+				goto free;
+			}
+		}
+
+		rsgl->sgl.npages = 0;
+		list_add_tail(&rsgl->list, &areq->rsgl_list);
+
+		/* make one iovec available as scatterlist */
+		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
+		if (err < 0)
+			goto free;
+
+		/* chain the new scatterlist with previous one */
+		if (last_rsgl)
+			af_alg_link_sg(&last_rsgl->sgl, &rsgl->sgl);
+
+		last_rsgl = rsgl;
+		len += err;
+		ctx->rcvused += err;
+		rsgl->sg_num_bytes = err;
+		iov_iter_advance(&msg->msg_iter, err);
+	}
+
+	/* ensure output buffer is sufficiently large */
+	if (len < maxsize) {
+		err = -EMSGSIZE;
+		goto free;
+	}
+
+	/*
+	 * Create a per request TX SGL for this request which tracks the
+	 * SG entries from the global TX SGL.
+	 */
+	if (ctx->op == ALG_OP_SSGEN) {
+		used = ctx->used;
+
+		areq->tsgl_entries = kpp_count_tsgl(sk, used);
+		if (!areq->tsgl_entries)
+			areq->tsgl_entries = 1;
+		areq->tsgl = sock_kmalloc(
+				sk, sizeof(*areq->tsgl) * areq->tsgl_entries,
+				GFP_KERNEL);
+		if (!areq->tsgl) {
+			err = -ENOMEM;
+			goto free;
+		}
+		sg_init_table(areq->tsgl, areq->tsgl_entries);
+		kpp_pull_tsgl(sk, used, areq->tsgl);
+	}
+
+	/* Initialize the crypto operation */
+	kpp_request_set_input(&areq->req, areq->tsgl, used);
+	kpp_request_set_output(&areq->req, areq->first_rsgl.sgl.sg, len);
+	kpp_request_set_tfm(&areq->req, tfm);
+
+	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
+		/* AIO operation */
+		areq->iocb = msg->msg_iocb;
+		kpp_request_set_callback(&areq->req,
+					      CRYPTO_TFM_REQ_MAY_SLEEP,
+					      kpp_async_cb, areq);
+	} else
+		/* Synchronous operation */
+		kpp_request_set_callback(&areq->req,
+					      CRYPTO_TFM_REQ_MAY_SLEEP |
+					      CRYPTO_TFM_REQ_MAY_BACKLOG,
+					      af_alg_complete,
+					      &ctx->completion);
+
+	switch (ctx->op) {
+	case ALG_OP_KEYGEN:
+		err = crypto_kpp_generate_public_key(&areq->req);
+		break;
+	case ALG_OP_SSGEN:
+		err = crypto_kpp_compute_shared_secret(&areq->req);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		goto free;
+	}
+
+	/* Wait for synchronous operation completion */
+	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb))
+		err = af_alg_wait_for_completion(err, &ctx->completion);
+
+	/* AIO operation in progress */
+	if (err == -EINPROGRESS) {
+		sock_hold(sk);
+		ctx->inflight++;
+		return -EIOCBQUEUED;
+	}
+
+	resultlen = areq->req.dst_len;
+
+free:
+	kpp_free_areq_sgl(areq);
+	if (areq)
+		sock_kfree_s(sk, areq, areqlen);
+
+	return err ? err : resultlen;
+}
+
+static int kpp_recvmsg(struct socket *sock, struct msghdr *msg,
+			    size_t ignored, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct sock *psk = ask->parent;
+	struct alg_sock *pask = alg_sk(psk);
+	struct kpp_tfm *kpp = pask->private;
+	struct crypto_kpp *tfm = kpp->kpp;
+
+	int ret = 0;
+
+	lock_sock(sk);
+
+	while (msg_data_left(msg)) {
+		int err = _kpp_recvmsg(sock, msg, ignored, flags);
+
+		/*
+		 * This error covers -EIOCBQUEUED which implies that we can
+		 * only handle one AIO request. If the caller wants to have
+		 * multiple AIO requests in parallel, he must make multiple
+		 * separate AIO calls.
+		 */
+		if (err < 0) {
+			ret = err;
+			goto out;
+		}
+		if (!err)
+			goto out;
+
+		ret += err;
+
+		/*
+		 * The caller must provide crypto_kpp_maxsize per request.
+		 * If he provides more, we conclude that multiple kpp
+		 * operations are requested.
+		 */
+		iov_iter_advance(&msg->msg_iter,
+				 crypto_kpp_maxsize(tfm) - err);
+	}
+
+out:
+
+	kpp_wmem_wakeup(sk);
+	release_sock(sk);
+	return ret;
+}
+
+static unsigned int kpp_poll(struct file *file, struct socket *sock,
+				  poll_table *wait)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct kpp_ctx *ctx = ask->private;
+	unsigned int mask = 0;
+
+	sock_poll_wait(file, sk_sleep(sk), wait);
+
+	if (ctx->used)
+		mask |= POLLIN | POLLRDNORM;
+
+	if (kpp_writable(sk))
+		mask |= POLLOUT | POLLWRNORM | POLLWRBAND;
+
+	return mask;
+}
+
+static struct proto_ops algif_kpp_ops = {
+	.family		=	PF_ALG,
+
+	.connect	=	sock_no_connect,
+	.socketpair	=	sock_no_socketpair,
+	.getname	=	sock_no_getname,
+	.ioctl		=	sock_no_ioctl,
+	.listen		=	sock_no_listen,
+	.shutdown	=	sock_no_shutdown,
+	.getsockopt	=	sock_no_getsockopt,
+	.mmap		=	sock_no_mmap,
+	.bind		=	sock_no_bind,
+	.accept		=	sock_no_accept,
+	.setsockopt	=	sock_no_setsockopt,
+
+	.release	=	af_alg_release,
+	.sendmsg	=	kpp_sendmsg,
+	.sendpage	=	kpp_sendpage,
+	.recvmsg	=	kpp_recvmsg,
+	.poll		=	kpp_poll,
+};
+
+static int kpp_check_key(struct socket *sock)
+{
+	int err = 0;
+	struct sock *psk;
+	struct alg_sock *pask;
+	struct kpp_tfm *tfm;
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+
+	lock_sock(sk);
+	if (ask->refcnt)
+		goto unlock_child;
+
+	psk = ask->parent;
+	pask = alg_sk(ask->parent);
+	tfm = pask->private;
+
+	err = -ENOKEY;
+	lock_sock_nested(psk, SINGLE_DEPTH_NESTING);
+	if (!tfm->has_key || (tfm->has_params == KPP_NO_PARAMS))
+		goto unlock;
+
+	if (!pask->refcnt++)
+		sock_hold(psk);
+
+	ask->refcnt = 1;
+	sock_put(psk);
+
+	err = 0;
+
+unlock:
+	release_sock(psk);
+unlock_child:
+	release_sock(sk);
+
+	return err;
+}
+
+static int kpp_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
+				  size_t size)
+{
+	int err;
+
+	err = kpp_check_key(sock);
+	if (err)
+		return err;
+
+	return kpp_sendmsg(sock, msg, size);
+}
+
+static ssize_t kpp_sendpage_nokey(struct socket *sock, struct page *page,
+				       int offset, size_t size, int flags)
+{
+	int err;
+
+	err = kpp_check_key(sock);
+	if (err)
+		return err;
+
+	return kpp_sendpage(sock, page, offset, size, flags);
+}
+
+static int kpp_recvmsg_nokey(struct socket *sock, struct msghdr *msg,
+				  size_t ignored, int flags)
+{
+	int err;
+
+	err = kpp_check_key(sock);
+	if (err)
+		return err;
+
+	return kpp_recvmsg(sock, msg, ignored, flags);
+}
+
+static struct proto_ops algif_kpp_ops_nokey = {
+	.family		=	PF_ALG,
+
+	.connect	=	sock_no_connect,
+	.socketpair	=	sock_no_socketpair,
+	.getname	=	sock_no_getname,
+	.ioctl		=	sock_no_ioctl,
+	.listen		=	sock_no_listen,
+	.shutdown	=	sock_no_shutdown,
+	.getsockopt	=	sock_no_getsockopt,
+	.mmap		=	sock_no_mmap,
+	.bind		=	sock_no_bind,
+	.accept		=	sock_no_accept,
+	.setsockopt	=	sock_no_setsockopt,
+
+	.release	=	af_alg_release,
+	.sendmsg	=	kpp_sendmsg_nokey,
+	.sendpage	=	kpp_sendpage_nokey,
+	.recvmsg	=	kpp_recvmsg_nokey,
+	.poll		=	kpp_poll,
+};
+
+static void *kpp_bind(const char *name, u32 type, u32 mask)
+{
+	struct kpp_tfm *tfm;
+	struct crypto_kpp *kpp;
+
+	tfm = kzalloc(sizeof(*tfm), GFP_KERNEL);
+	if (!tfm)
+		return ERR_PTR(-ENOMEM);
+
+	kpp = crypto_alloc_kpp(name, type, mask);
+	if (IS_ERR(kpp)) {
+		kfree(tfm);
+		return ERR_CAST(kpp);
+	}
+
+	tfm->kpp = kpp;
+
+	return tfm;
+}
+
+static void kpp_release(void *private)
+{
+	struct kpp_tfm *tfm = private;
+	struct crypto_kpp *kpp = tfm->kpp;
+
+	crypto_free_kpp(kpp);
+	kfree(tfm);
+}
+
+static int kpp_dh_set_secret(struct crypto_kpp *tfm, struct dh *params)
+{
+	char *packed_key = NULL;
+	unsigned int packed_key_len;
+	int ret;
+
+	packed_key_len = crypto_dh_key_len(params);
+	packed_key = kmalloc(packed_key_len, GFP_KERNEL);
+	if (!packed_key)
+		return -ENOMEM;
+
+	ret = crypto_dh_encode_key(packed_key, packed_key_len, params);
+	if (ret)
+		goto out;
+
+	ret = crypto_kpp_set_secret(tfm, packed_key, packed_key_len);
+
+out:
+	kfree(packed_key);
+	return ret;
+}
+
+static int kpp_dh_set_privkey(struct crypto_kpp *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct dh params = {
+		.key = key,
+		.key_size = keylen,
+		.p = NULL,
+		.p_size = 0,
+		.g = NULL,
+		.g_size = 0,
+	};
+
+	return kpp_dh_set_secret(tfm, &params);
+}
+
+static int kpp_ecdh_set_secret(struct crypto_kpp *tfm, struct ecdh *params)
+{
+	char *packed_key = NULL;
+	unsigned int packed_key_len;
+	int ret;
+
+	packed_key_len = crypto_ecdh_key_len(params);
+	packed_key = kmalloc(packed_key_len, GFP_KERNEL);
+	if (!packed_key)
+		return -ENOMEM;
+
+	ret = crypto_ecdh_encode_key(packed_key, packed_key_len, params);
+	if (ret)
+		goto out;
+
+	ret = crypto_kpp_set_secret(tfm, packed_key, packed_key_len);
+
+out:
+	kfree(packed_key);
+	return ret;
+}
+
+static int kpp_ecdh_set_privkey(struct crypto_kpp *tfm, const u8 *key,
+				unsigned int keylen)
+{
+	struct ecdh params = {
+		.curve_id = 0,
+		.key = key,
+		.key_size = keylen,
+	};
+
+	return kpp_ecdh_set_secret(tfm, &params);
+}
+
+static int kpp_genkey(struct crypto_kpp *tfm, int (*set_secret)
+		(struct crypto_kpp *tfm, const u8 *key, unsigned int keylen))
+{
+	int err;
+	u8 *rndbuf = NULL;
+	int maxsize;
+
+	maxsize = crypto_kpp_maxsize(tfm);
+	if (maxsize < 0)
+		return maxsize;
+
+	/* Hard limit size to prevent caller to allocate arbitrary memory. */
+	if (maxsize > (16384 >> 3))
+		return -E2BIG;
+
+	rndbuf = kmalloc(maxsize, GFP_KERNEL);
+	if (!rndbuf)
+		return -ENOMEM;
+
+	if (crypto_get_default_rng()) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	err = crypto_rng_get_bytes(crypto_default_rng, rndbuf, maxsize);
+	crypto_put_default_rng();
+	if (err)
+		goto out;
+
+	err = set_secret(tfm, rndbuf, maxsize);
+
+out:
+	kzfree(rndbuf);
+	return err;
+}
+
+static int kpp_setprivkey(void *private, const u8 *key, unsigned int keylen)
+{
+	struct kpp_tfm *kpp = private;
+	struct crypto_kpp *tfm = kpp->kpp;
+	int err;
+
+	if (kpp->has_params == KPP_NO_PARAMS)
+		return -ENOKEY;
+
+	if (!key || !keylen) {
+		/* Let kernel generate private key. */
+		switch (kpp->has_params) {
+		case KPP_DH_PARAMS:
+			err = kpp_genkey(tfm, kpp_dh_set_privkey);
+			break;
+		case KPP_ECDH_PARAMS:
+			err = kpp_genkey(tfm, kpp_ecdh_set_privkey);
+			break;
+		default:
+			err = -EFAULT;
+		}
+	} else {
+		/* Take user-provided private key. */
+		switch (kpp->has_params) {
+		case KPP_DH_PARAMS:
+			err = kpp_dh_set_privkey(tfm, key, keylen);
+			break;
+		case KPP_ECDH_PARAMS:
+			err = kpp_ecdh_set_privkey(tfm, key, keylen);
+			break;
+		default:
+			err = -EFAULT;
+		}
+	}
+
+	/* Return the maximum size of the kpp operation. */
+	if (!err) {
+		kpp->has_key = true;
+		err = crypto_kpp_maxsize(tfm);
+	} else
+		kpp->has_key = false;
+
+	return err;
+}
+
+static int kpp_dh_setparams_pkcs3(void *private, const u8 *params,
+				  unsigned int paramslen)
+{
+	struct kpp_tfm *kpp = private;
+	struct crypto_kpp *tfm = kpp->kpp;
+	int err;
+
+	/* If parameters were already set, disallow setting them again. */
+	if (kpp->has_params != KPP_NO_PARAMS)
+		return -EINVAL;
+
+	err = crypto_kpp_set_params(tfm, params, paramslen);
+	if (!err) {
+		kpp->has_params = KPP_DH_PARAMS;
+		/* Return the maximum size of the kpp operation. */
+		err = crypto_kpp_maxsize(tfm);
+	} else
+		kpp->has_params = KPP_NO_PARAMS;
+
+	return err;
+}
+
+static int kpp_ecdh_setcurve(void *private, const u8 *curveid,
+			     unsigned int curveidlen)
+{
+	struct kpp_tfm *kpp = private;
+	struct crypto_kpp *tfm = kpp->kpp;
+	int err;
+	struct ecdh params = {
+		.key = NULL,
+		.key_size = 0,
+	};
+
+	/* If parameters were already set, disallow setting them again. */
+	if (kpp->has_params != KPP_NO_PARAMS)
+		return -EINVAL;
+
+	if (curveidlen != sizeof(unsigned long))
+		return -EINVAL;
+
+	err = kstrtou16(curveid, 10, &params.curve_id);
+	if (err)
+		return err;
+
+	err = kpp_ecdh_set_secret(tfm, &params);
+	if (!err) {
+		kpp->has_params = KPP_ECDH_PARAMS;
+		/* Return the maximum size of the kpp operation. */
+		err = crypto_kpp_maxsize(tfm);
+	} else
+		kpp->has_params = KPP_NO_PARAMS;
+
+	return err;
+}
+
+static void kpp_sock_destruct(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct kpp_ctx *ctx = ask->private;
+
+	/* Suspend caller if AIO operations are in flight. */
+	wait_event_interruptible(kpp_aio_finish_wait,
+				 (ctx->inflight == 0));
+
+	kpp_pull_tsgl(sk, ctx->used, NULL);
+	sock_kfree_s(sk, ctx, ctx->len);
+	af_alg_release_parent(sk);
+}
+
+static int kpp_accept_parent_nokey(void *private, struct sock *sk)
+{
+	struct kpp_ctx *ctx;
+	struct alg_sock *ask = alg_sk(sk);
+	unsigned int len = sizeof(*ctx);
+
+	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	memset(ctx, 0, len);
+
+	INIT_LIST_HEAD(&ctx->tsgl_list);
+	ctx->len = len;
+	ctx->used = 0;
+	ctx->rcvused = 0;
+	ctx->more = 0;
+	ctx->merge = 0;
+	ctx->op = 0;
+	ctx->inflight = 0;
+	af_alg_init_completion(&ctx->completion);
+
+	ask->private = ctx;
+
+	sk->sk_destruct = kpp_sock_destruct;
+
+	return 0;
+}
+
+static int kpp_accept_parent(void *private, struct sock *sk)
+{
+	struct kpp_tfm *tfm = private;
+
+	if (!tfm->has_key || (tfm->has_params == KPP_NO_PARAMS))
+		return -ENOKEY;
+
+	return kpp_accept_parent_nokey(private, sk);
+}
+
+static const struct af_alg_type algif_type_kpp = {
+	.bind		=	kpp_bind,
+	.release	=	kpp_release,
+	.setkey		=	kpp_setprivkey,
+	.setpubkey	=	NULL,
+	.dhparams	=	kpp_dh_setparams_pkcs3,
+	.ecdhcurve	=	kpp_ecdh_setcurve,
+	.setauthsize	=	NULL,
+	.accept		=	kpp_accept_parent,
+	.accept_nokey	=	kpp_accept_parent_nokey,
+	.ops		=	&algif_kpp_ops,
+	.ops_nokey	=	&algif_kpp_ops_nokey,
+	.name		=	"kpp",
+	.owner		=	THIS_MODULE
+};
+
+static int __init algif_kpp_init(void)
+{
+	return af_alg_register_type(&algif_type_kpp);
+}
+
+static void __exit algif_kpp_exit(void)
+{
+	int err = af_alg_unregister_type(&algif_type_kpp);
+	BUG_ON(err);
+}
+
+module_init(algif_kpp_init);
+module_exit(algif_kpp_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
+MODULE_DESCRIPTION("Key protocol primitives kernel crypto API user space interface");
-- 
2.9.3
