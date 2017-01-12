From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [RFC PATCH 1/6] crypto: skcipher - Add bulk request processing API
Date: Thu, 12 Jan 2017 13:59:53 +0100
Message-ID: <8ab9f8a0c5faf04c11e455dfa8c79d59213b89ab.1484215956.git.omosnacek@gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36711 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750960AbdALNAs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 08:00:48 -0500
Received: by mail-wm0-f68.google.com with SMTP id r126so3507465wmr.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2017 05:00:47 -0800 (PST)
In-Reply-To: <cover.1484215956.git.omosnacek@gmail.com>
In-Reply-To: <cover.1484215956.git.omosnacek@gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds bulk request processing to the skcipher interface.
Specifically, it adds a new type of request ('skcipher_bulk_request'), which
allows passing multiple independent messages to the skcipher driver.

The buffers for the message data are passed via just two sg lists (one for src
buffer, one for dst buffer). The IVs are passed via a single buffer, where they
are stored sequentially. The interface allows specifying either a fixed length
for all messages or a pointer to an array of message lengths.

A skcipher implementation that wants to provide support for bulk requests may
set the appropriate fields of its skcipher_alg struct. If these fields are not
provided (or the skcipher is created from an (a)blkcipher), the crypto API
automatically sets these fields to a fallback implementation, which just splits
the bulk request into a series of regular skcipher requests on the same tfm.

This means that the new type of request can be used with all skciphers, even if
they do not support bulk requests natively.

Note that when allocating a skcipher_bulk_request, the user must specify the
maximum number of messages that they are going to submit via the request. This
is necessary for the fallback implementation, which has to allocate space for
the appropriate number of subrequests so that they can be processed in
parallel. If the skcipher is synchronous, then the fallback implementation
only allocates space for one subrequest and processes the patrial requests
sequentially.

Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
---
 crypto/Makefile                    |   1 +
 crypto/skcipher.c                  |  15 ++
 crypto/skcipher_bulk.c             | 312 +++++++++++++++++++++++++++++++++++++
 include/crypto/internal/skcipher.h |  32 ++++
 include/crypto/skcipher.h          | 299 ++++++++++++++++++++++++++++++++++-
 5 files changed, 658 insertions(+), 1 deletion(-)
 create mode 100644 crypto/skcipher_bulk.c

diff --git a/crypto/Makefile b/crypto/Makefile
index b8f0e3e..cd1cf57 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_CRYPTO_AEAD2) += aead.o
 crypto_blkcipher-y := ablkcipher.o
 crypto_blkcipher-y += blkcipher.o
 crypto_blkcipher-y += skcipher.o
+crypto_blkcipher-y += skcipher_bulk.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER2) += crypto_blkcipher.o
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 obj-$(CONFIG_CRYPTO_ECHAINIV) += echainiv.o
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 6ee6a15..8b6d684 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -667,6 +667,8 @@ static int crypto_init_skcipher_ops_blkcipher(struct crypto_tfm *tfm)
 	skcipher->ivsize = crypto_blkcipher_ivsize(blkcipher);
 	skcipher->keysize = calg->cra_blkcipher.max_keysize;
 
+	crypto_skcipher_bulk_set_fallback(skcipher);
+
 	return 0;
 }
 
@@ -760,6 +762,8 @@ static int crypto_init_skcipher_ops_ablkcipher(struct crypto_tfm *tfm)
 			    sizeof(struct ablkcipher_request);
 	skcipher->keysize = calg->cra_ablkcipher.max_keysize;
 
+	crypto_skcipher_bulk_set_fallback(skcipher);
+
 	return 0;
 }
 
@@ -789,6 +793,14 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 	skcipher->ivsize = alg->ivsize;
 	skcipher->keysize = alg->max_keysize;
 
+	if (!alg->encrypt_bulk || !alg->decrypt_bulk || !alg->reqsize_bulk)
+		crypto_skcipher_bulk_set_fallback(skcipher);
+	else {
+		skcipher->encrypt_bulk = alg->encrypt_bulk;
+		skcipher->decrypt_bulk = alg->decrypt_bulk;
+		skcipher->reqsize_bulk = alg->reqsize_bulk;
+	}
+
 	if (alg->exit)
 		skcipher->base.exit = crypto_skcipher_exit_tfm;
 
@@ -822,6 +834,9 @@ static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "ivsize       : %u\n", skcipher->ivsize);
 	seq_printf(m, "chunksize    : %u\n", skcipher->chunksize);
 	seq_printf(m, "walksize     : %u\n", skcipher->walksize);
+	seq_printf(m, "bulk         : %s\n",
+		   (skcipher->encrypt_bulk && skcipher->decrypt_bulk &&
+		    skcipher->reqsize_bulk) ?  "yes" : "no");
 }
 
 #ifdef CONFIG_NET
diff --git a/crypto/skcipher_bulk.c b/crypto/skcipher_bulk.c
new file mode 100644
index 0000000..9630122
--- /dev/null
+++ b/crypto/skcipher_bulk.c
@@ -0,0 +1,312 @@
+/*
+ * Bulk IV fallback for skcipher.
+ *
+ * Copyright (C) 2016-2017 Red Hat, Inc. All rights reserved.
+ * Copyright (c) 2016-2017 Ondrej Mosnacek <omosnacek@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/atomic.h>
+
+struct skcipher_bulk_subreqctx {
+	struct scatterlist sg_src[2];
+	struct scatterlist sg_dst[2];
+
+	struct skcipher_request subreq;
+};
+
+struct skcipher_bulk_reqctx {
+	int (*crypt)(struct skcipher_request *req);
+
+	unsigned int next_slot;
+	atomic_t unfinished;
+	atomic_t busy_counter;
+	atomic_t err_unset;
+
+	int first_error;
+
+	struct skcipher_bulk_subreqctx slots[];
+};
+
+static void skcipher_bulk_continue(struct crypto_async_request *areq, int err);
+
+static int skcipher_bulk_spawn(struct skcipher_bulk_request *req,
+			       struct skcipher_bulk_subreqctx *slot, u32 flags)
+{
+	struct skcipher_bulk_reqctx *rctx = skcipher_bulk_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	unsigned int i, offset, size;
+	struct scatterlist *src, *dst;
+	int err;
+
+	skcipher_request_set_tfm(&slot->subreq, tfm);
+	skcipher_request_set_callback(&slot->subreq, flags,
+				      skcipher_bulk_continue, req);
+	if (req->msgsizes) {
+		offset = 0;
+		for (i = 0; i < rctx->next_slot; i++)
+			offset += req->msgsizes[i];
+		size = req->msgsizes[rctx->next_slot];
+	} else {
+		offset = rctx->next_slot * req->msgsize;
+		size = req->msgsize;
+	}
+
+	/* perform the subrequest: */
+	src = scatterwalk_ffwd(slot->sg_src, req->src, offset);
+	dst = src;
+	if (req->src != req->dst)
+		dst = scatterwalk_ffwd(slot->sg_dst, req->dst, offset);
+
+	skcipher_request_set_crypt(&slot->subreq, src, dst, size,
+				   req->ivs + rctx->next_slot * ivsize);
+	err = rctx->crypt(&slot->subreq);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		return err; /* successfully submitted */
+
+	if (err && atomic_dec_and_test(&rctx->err_unset))
+		rctx->first_error = err;
+
+	return atomic_dec_and_test(&rctx->unfinished) ? 0 : -EINPROGRESS;
+}
+
+static int skcipher_bulk_spawn_unstarted(struct skcipher_bulk_request *req,
+					 u32 flags)
+{
+	struct skcipher_bulk_reqctx *rctx = skcipher_bulk_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	unsigned int slot_size =
+			sizeof(struct skcipher_bulk_subreqctx) + tfm->reqsize;
+	u8 *slot_pos;
+	struct skcipher_bulk_subreqctx *slot;
+	int ret;
+	while (rctx->next_slot < req->nmsgs) {
+		slot_pos = (u8 *)rctx->slots + rctx->next_slot * slot_size;
+		slot = (struct skcipher_bulk_subreqctx *)slot_pos;
+
+		/* try to spawn request on the slot: */
+		ret = skcipher_bulk_spawn(req, slot, flags);
+		++rctx->next_slot;
+		if (ret == 0)
+			return 0; /* all finished */
+		if (ret == -EBUSY && !atomic_inc_and_test(&rctx->busy_counter))
+			return -EBUSY; /* EBUSY, don't spawn until notified */
+	}
+	return -EINPROGRESS;
+}
+
+static void skcipher_bulk_continue(struct crypto_async_request *areq, int err)
+{
+	struct skcipher_bulk_request *req = areq->data;
+	struct skcipher_bulk_reqctx *rctx = skcipher_bulk_request_ctx(req);
+
+	if (err == -EINPROGRESS) {
+		/* -EINPROGRESS after -EBUSY returned earlier */
+
+		if (!atomic_dec_and_test(&rctx->busy_counter))
+			return; /* -EBUSY not yet registered by caller */
+
+		/* let's continue spawning: */
+		err = skcipher_bulk_spawn_unstarted(req, 0);
+		BUG_ON(err == 0); /* this request couldn't yet be finished */
+		if (err == -EINPROGRESS)
+			skcipher_bulk_request_complete(req, -EINPROGRESS);
+		else if (err != -EBUSY && atomic_dec_and_test(&rctx->err_unset))
+			rctx->first_error = err;
+	} else {
+		/* request is finished, possibly with error */
+
+		if (err && atomic_dec_and_test(&rctx->err_unset))
+			rctx->first_error = err;
+
+		if (atomic_dec_and_test(&rctx->unfinished))
+			skcipher_bulk_request_complete(req, rctx->first_error);
+	}
+}
+
+static int skcipher_bulk_do_async(struct skcipher_bulk_request *req)
+{
+	struct skcipher_bulk_reqctx *rctx = skcipher_bulk_request_ctx(req);
+	u32 flags = skcipher_bulk_request_flags(req);
+
+	/* you never know... */
+	if (req->nmsgs > (unsigned int)INT_MAX)
+		return -EINVAL;
+
+	if (req->nmsgs == 0)
+		return 0;
+
+	/* initialize context variables: */
+	rctx->first_error = 0;
+	rctx->next_slot = 0;
+	rctx->busy_counter = (atomic_t)ATOMIC_INIT(0);
+	rctx->unfinished = (atomic_t)ATOMIC_INIT((int)req->nmsgs);
+	rctx->err_unset = (atomic_t)ATOMIC_INIT(1);
+
+	return skcipher_bulk_spawn_unstarted(req, flags);
+}
+
+static int skcipher_bulk_encrypt_async_many(struct skcipher_bulk_request *req)
+{
+	struct skcipher_bulk_reqctx *rctx = skcipher_bulk_request_ctx(req);
+
+	rctx->crypt = crypto_skcipher_encrypt;
+	return skcipher_bulk_do_async(req);
+}
+
+static int skcipher_bulk_decrypt_async_many(struct skcipher_bulk_request *req)
+{
+	struct skcipher_bulk_reqctx *rctx = skcipher_bulk_request_ctx(req);
+
+	rctx->crypt = crypto_skcipher_decrypt;
+	return skcipher_bulk_do_async(req);
+}
+
+static int skcipher_bulk_encrypt_async_one(struct skcipher_bulk_request *req)
+{
+	struct skcipher_request *subreq = skcipher_bulk_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	unsigned int cryptlen = req->msgsizes ? req->msgsizes[0] : req->msgsize;
+
+	skcipher_request_set_tfm(subreq, tfm);
+	skcipher_request_set_callback(subreq, req->base.flags,
+				      req->base.complete, req->base.data);
+	skcipher_request_set_crypt(subreq, req->src, req->dst, cryptlen,
+				   req->ivs);
+	return crypto_skcipher_encrypt(subreq);
+}
+
+static int skcipher_bulk_decrypt_async_one(struct skcipher_bulk_request *req)
+{
+	struct skcipher_request *subreq = skcipher_bulk_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	unsigned int cryptlen = req->msgsizes ? req->msgsizes[0] : req->msgsize;
+
+	skcipher_request_set_tfm(subreq, tfm);
+	skcipher_request_set_callback(subreq, req->base.flags,
+				      req->base.complete, req->base.data);
+	skcipher_request_set_crypt(subreq, req->src, req->dst, cryptlen,
+				   req->ivs);
+	return crypto_skcipher_decrypt(subreq);
+}
+
+static int skcipher_bulk_encrypt_async(struct skcipher_bulk_request *req)
+{
+	if (req->nmsgs == 0)
+		return 0;
+
+	if (req->maxmsgs == 1)
+		return skcipher_bulk_encrypt_async_one(req);
+
+	return skcipher_bulk_encrypt_async_many(req);
+}
+
+static int skcipher_bulk_decrypt_async(struct skcipher_bulk_request *req)
+{
+	if (req->nmsgs == 0)
+		return 0;
+
+	if (req->maxmsgs == 1)
+		return skcipher_bulk_decrypt_async_one(req);
+
+	return skcipher_bulk_decrypt_async_many(req);
+}
+
+static unsigned int skcipher_bulk_reqsize_async(struct crypto_skcipher *tfm,
+						unsigned int maxmsgs)
+{
+	unsigned int per_message;
+
+	/* special case for no message: */
+	if (maxmsgs == 0)
+		return 0;
+
+	/* special case for just one message: */
+	if (maxmsgs == 1)
+		return sizeof(struct skcipher_request) + tfm->reqsize;
+
+	per_message = sizeof(struct skcipher_bulk_subreqctx) + tfm->reqsize;
+	return sizeof(struct skcipher_bulk_reqctx) + maxmsgs * per_message;
+}
+
+static int skcipher_bulk_do_sync(struct skcipher_bulk_request *req,
+				 int (*crypt)(struct skcipher_request *))
+{
+	struct skcipher_request *subreq = skcipher_bulk_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	u32 flags = skcipher_bulk_request_flags(req);
+	unsigned int msg_idx, offset, ivsize = crypto_skcipher_ivsize(tfm);
+	const unsigned int *msgsize = req->msgsizes ?: &req->msgsize;
+	struct scatterlist *src, *dst;
+	struct scatterlist sg_src[2];
+	struct scatterlist sg_dst[2];
+	u8 *iv;
+	int err;
+
+	skcipher_request_set_tfm(subreq, tfm);
+	skcipher_request_set_callback(subreq, flags, NULL, NULL);
+
+	iv = req->ivs;
+	offset = 0;
+
+	for (msg_idx = 0; msg_idx < req->nmsgs; msg_idx++) {
+		src = scatterwalk_ffwd(sg_src, req->src, offset);
+		dst = src;
+		if (req->src != req->dst)
+			dst = scatterwalk_ffwd(sg_dst, req->dst, offset);
+
+		skcipher_request_set_crypt(subreq, src, dst, *msgsize, iv);
+		err = crypt(subreq);
+		if (err)
+			return err;
+
+		iv += ivsize;
+		offset += *msgsize;
+		if (req->msgsizes)
+			msgsize++;
+	}
+	return 0;
+}
+
+static int skcipher_bulk_encrypt_sync(struct skcipher_bulk_request *req)
+{
+	return skcipher_bulk_do_sync(req, crypto_skcipher_encrypt);
+}
+
+static int skcipher_bulk_decrypt_sync(struct skcipher_bulk_request *req)
+{
+	return skcipher_bulk_do_sync(req, crypto_skcipher_decrypt);
+}
+
+static unsigned int skcipher_bulk_reqsize_sync(struct crypto_skcipher *tfm,
+					       unsigned int maxmsgs)
+{
+	return sizeof(struct skcipher_request) + tfm->reqsize;
+}
+
+void crypto_skcipher_bulk_set_fallback(struct crypto_skcipher *skcipher)
+{
+	if (crypto_skcipher_get_flags(skcipher) & CRYPTO_ALG_ASYNC) {
+		skcipher->encrypt_bulk = skcipher_bulk_encrypt_async;
+		skcipher->decrypt_bulk = skcipher_bulk_decrypt_async;
+		skcipher->reqsize_bulk = skcipher_bulk_reqsize_async;
+	} else {
+		skcipher->encrypt_bulk = skcipher_bulk_encrypt_sync;
+		skcipher->decrypt_bulk = skcipher_bulk_decrypt_sync;
+		skcipher->reqsize_bulk = skcipher_bulk_reqsize_sync;
+	}
+}
+EXPORT_SYMBOL_GPL(crypto_skcipher_bulk_set_fallback);
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index e42f706..f536b57 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -95,6 +95,12 @@ static inline void skcipher_request_complete(struct skcipher_request *req, int e
 	req->base.complete(&req->base, err);
 }
 
+static inline void skcipher_bulk_request_complete(
+		struct skcipher_bulk_request *req, int err)
+{
+	req->base.complete(&req->base, err);
+}
+
 static inline void crypto_set_skcipher_spawn(
 	struct crypto_skcipher_spawn *spawn, struct crypto_instance *inst)
 {
@@ -181,6 +187,30 @@ static inline u32 skcipher_request_flags(struct skcipher_request *req)
 	return req->base.flags;
 }
 
+static inline void *skcipher_bulk_request_ctx(struct skcipher_bulk_request *req)
+{
+	return req->__ctx;
+}
+
+static inline u32 skcipher_bulk_request_flags(struct skcipher_bulk_request *req)
+{
+	return req->base.flags;
+}
+
+static inline unsigned int skcipher_bulk_request_totalsize(
+		struct skcipher_bulk_request *req)
+{
+	unsigned int totalsize, msg_idx;
+
+	if (!req->msgsizes)
+		return req->nmsgs * req->msgsize;
+
+	totalsize = 0;
+	for (msg_idx = 0; msg_idx < req->nmsgs; msg_idx++)
+		totalsize += req->msgsizes[msg_idx];
+	return totalsize;
+}
+
 static inline unsigned int crypto_skcipher_alg_min_keysize(
 	struct skcipher_alg *alg)
 {
@@ -207,5 +237,7 @@ static inline unsigned int crypto_skcipher_alg_max_keysize(
 	return alg->max_keysize;
 }
 
+void crypto_skcipher_bulk_set_fallback(struct crypto_skcipher *skcipher);
+
 #endif	/* _CRYPTO_INTERNAL_SKCIPHER_H */
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 562001c..e229546 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -52,11 +52,46 @@ struct skcipher_givcrypt_request {
 	struct ablkcipher_request creq;
 };
 
+/**
+ *	struct skcipher_bulk_request - Bulk symmetric key cipher request
+ *	@maxmsgs: Maximum number of messages, as specified on allocation
+ *	@nmsgs: Number of messages in plaintext/ciphertext
+ *	@msgsize: Size of plaintext/ciphertext message
+ *	@msgsizes: If not NULL, points to an array of @nmsgs unsigned
+ *	           integers specifying the size of each message (in such case
+ *	           the value of @msgsize is ignored)
+ *	@ivs: Initialisation vectors for all messages
+ *	@src: Source SG list
+ *	@dst: Destination SG list
+ *	@base: Underlying async request request
+ *	@__ctx: Start of private context data
+ */
+struct skcipher_bulk_request {
+	unsigned int maxmsgs;
+
+	unsigned int nmsgs;
+	unsigned int msgsize;
+	const unsigned int *msgsizes;
+
+	u8 *ivs;
+
+	struct scatterlist *src;
+	struct scatterlist *dst;
+
+	struct crypto_async_request base;
+
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
 struct crypto_skcipher {
 	int (*setkey)(struct crypto_skcipher *tfm, const u8 *key,
 	              unsigned int keylen);
 	int (*encrypt)(struct skcipher_request *req);
 	int (*decrypt)(struct skcipher_request *req);
+	int (*encrypt_bulk)(struct skcipher_bulk_request *req);
+	int (*decrypt_bulk)(struct skcipher_bulk_request *req);
+	unsigned int (*reqsize_bulk)(struct crypto_skcipher *tfm,
+				     unsigned int maxmsgs);
 
 	unsigned int ivsize;
 	unsigned int reqsize;
@@ -100,6 +135,19 @@ struct crypto_skcipher {
  *	     be called in parallel with the same transformation object.
  * @decrypt: Decrypt a single block. This is a reverse counterpart to @encrypt
  *	     and the conditions are exactly the same.
+ * @encrypt_bulk: Similar to @encrypt, but operates in bulk mode, where
+ *                the plaintext/cryptotext consists of several messages, each
+ *                of which is transformed using a separate IV (all IVs are
+ *                passed concatenated via the request structure). This field
+ *                may be NULL if the algorithm does not natively support bulk
+ *                requests.
+ * @decrypt_bulk: Decrypt multiple messages. This is a reverse counterpart
+ *                to @encrypt_bulk and the conditions are exactly the same.
+ *                This field may be NULL if the algorithm does not natively
+ *                support bulk requests.
+ * @reqsize_bulk: Compute the bulk request size for the given tfm and maximum
+ *                message size. This field may be NULL if the algorithm does
+ *                not natively support bulk requests.
  * @init: Initialize the cryptographic transformation object. This function
  *	  is used to initialize the cryptographic transformation object.
  *	  This function is called only once at the instantiation time, right
@@ -120,13 +168,18 @@ struct crypto_skcipher {
  * 	      in parallel. Should be a multiple of chunksize.
  * @base: Definition of a generic crypto algorithm.
  *
- * All fields except @ivsize are mandatory and must be filled.
+ * All fields except @ivsize, @encrypt_bulk, @decrypt_bulk and @reqsize_bulk
+ * are mandatory and must be filled.
  */
 struct skcipher_alg {
 	int (*setkey)(struct crypto_skcipher *tfm, const u8 *key,
 	              unsigned int keylen);
 	int (*encrypt)(struct skcipher_request *req);
 	int (*decrypt)(struct skcipher_request *req);
+	int (*encrypt_bulk)(struct skcipher_bulk_request *req);
+	int (*decrypt_bulk)(struct skcipher_bulk_request *req);
+	unsigned int (*reqsize_bulk)(struct crypto_skcipher *tfm,
+				     unsigned int maxmsgs);
 	int (*init)(struct crypto_skcipher *tfm);
 	void (*exit)(struct crypto_skcipher *tfm);
 
@@ -428,6 +481,21 @@ static inline struct crypto_skcipher *crypto_skcipher_reqtfm(
 }
 
 /**
+ * crypto_skcipher_bulk_reqtfm() - obtain cipher handle from bulk request
+ * @req: skcipher_bulk_request out of which the cipher handle is to be obtained
+ *
+ * Return the crypto_skcipher handle when furnishing an skcipher_bulk_request
+ * data structure.
+ *
+ * Return: crypto_skcipher handle
+ */
+static inline struct crypto_skcipher *crypto_skcipher_bulk_reqtfm(
+	struct skcipher_bulk_request *req)
+{
+	return __crypto_skcipher_cast(req->base.tfm);
+}
+
+/**
  * crypto_skcipher_encrypt() - encrypt plaintext
  * @req: reference to the skcipher_request handle that holds all information
  *	 needed to perform the cipher operation
@@ -464,6 +532,44 @@ static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
 }
 
 /**
+ * crypto_skcipher_encrypt_bulk() - encrypt plaintext in bulk mode
+ * @req: reference to the skcipher_bulk_request handle that holds all
+ *	 information needed to perform the cipher operation
+ *
+ * Encrypt plaintext data using the skcipher_bulk_request handle. That data
+ * structure and how it is filled with data is discussed with the
+ * skcipher_bulk_request_* functions.
+ *
+ * Return: 0 if the cipher operation was successful; < 0 if an error occurred
+ */
+static inline int crypto_skcipher_encrypt_bulk(
+		struct skcipher_bulk_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+
+	return tfm->encrypt_bulk(req);
+}
+
+/**
+ * crypto_skcipher_decrypt_bulk() - decrypt ciphertext in bulk mode
+ * @req: reference to the skcipher_bulk_request handle that holds all
+ *	 information needed to perform the cipher operation
+ *
+ * Decrypt ciphertext data using the skcipher_bulk_request handle. That data
+ * structure and how it is filled with data is discussed with the
+ * skcipher_bulk_request_* functions.
+ *
+ * Return: 0 if the cipher operation was successful; < 0 if an error occurred
+ */
+static inline int crypto_skcipher_decrypt_bulk(
+		struct skcipher_bulk_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+
+	return tfm->decrypt_bulk(req);
+}
+
+/**
  * DOC: Symmetric Key Cipher Request Handle
  *
  * The skcipher_request data structure contains all pointers to data
@@ -608,5 +714,196 @@ static inline void skcipher_request_set_crypt(
 	req->iv = iv;
 }
 
+/**
+ * DOC: Bulk Symmetric Key Cipher Request Handle
+ *
+ * The skcipher_bulk_request data structure contains all pointers to data
+ * required for the bulk symmetric key cipher operation. This includes the
+ * cipher handle (which can be used by multiple skcipher_bulk_request
+ * instances), pointer to plaintext and ciphertext, asynchronous callback
+ * function, etc. It acts as a handle to the skcipher_bulk_request_* API
+ * calls in a similar way as skcipher handle to the crypto_skcipher_* API calls.
+ */
+
+#define SKCIPHER_BULK_REQUEST_ON_STACK(name, max_messages, tfm) \
+	char __##name##_desc[sizeof(struct skcipher_bulk_request) + \
+		crypto_skcipher_bulk_reqsize(tfm, max_messages)] \
+		CRYPTO_MINALIGN_ATTR; \
+	struct skcipher_bulk_request *name = (void *)__##name##_desc; \
+	skcipher_bulk_request_set_maxmsgs(name, max_messages);
+
+/**
+ * crypto_skcipher_bulk_reqsize() - obtain size of the request data structure
+ * @tfm: cipher handle
+ * @maxmsgs: maximum number of messages that can be submitted in bulk
+ *
+ * Return: number of bytes
+ */
+static inline unsigned int crypto_skcipher_bulk_reqsize(
+		struct crypto_skcipher *tfm, unsigned int maxmsgs)
+{
+	return tfm->reqsize_bulk(tfm, maxmsgs);
+}
+
+/**
+ * skcipher_bulk_request_set_maxmsgs() - set the maxmsgs attribute in request
+ * @req: request handle to be modified
+ * @tfm: cipher handle that shall be added to the request handle
+ *
+ * This function must be called on skcipher_bulk_requests that have been
+ * allocated manually (not using @skcipher_bulk_request_alloc or
+ * SKCIPHER_BULK_REQUEST_ON_STACK). The context size of the request must be
+ * at least the value returned by the correspnding call to
+ * crypto_skcipher_bulk_reqsize (with the same value of @maxmsgs).
+ */
+static inline void skcipher_bulk_request_set_maxmsgs(
+		struct skcipher_bulk_request *req, unsigned int maxmsgs)
+{
+	req->maxmsgs = maxmsgs;
+}
+
+/**
+ * skcipher_bulk_request_set_tfm() - update cipher handle reference in request
+ * @req: request handle to be modified
+ * @tfm: cipher handle that shall be added to the request handle
+ *
+ * Allow the caller to replace the existing skcipher handle in the request
+ * data structure with a different one.
+ */
+static inline void skcipher_bulk_request_set_tfm(
+		struct skcipher_bulk_request *req,
+		struct crypto_skcipher *tfm)
+{
+	req->base.tfm = crypto_skcipher_tfm(tfm);
+}
+
+static inline struct skcipher_bulk_request *skcipher_bulk_request_cast(
+	struct crypto_async_request *req)
+{
+	return container_of(req, struct skcipher_bulk_request, base);
+}
+
+/**
+ * skcipher_bulk_request_alloc() - allocate request data structure
+ * @tfm: cipher handle to be registered with the request
+ * @maxmsgs: maximum number of messages
+ * @gfp: memory allocation flag that is handed to kmalloc by the API call.
+ *
+ * Allocate the bulk IV request data structure that must be used with the
+ * skcipher encrypt_bulk and decrypt_bulk API calls. During the allocation,
+ * the provided skcipher handle is registered in the request data structure.
+ *
+ * The @maxmsgs parameter should specify the maximum number of messages that
+ * will be submitted via the allocated request. It is mainly used by
+ * the fallback implementation to figure out how many subrequests it needs
+ * to allocate so that they can be executed in parallel. However, other drivers
+ * may also make use of it. The implementation may reject requests with higher
+ * number of messagess than @maxmsgs.
+ *
+ * Return: allocated request handle in case of success, or NULL if out of memory
+ */
+static inline struct skcipher_bulk_request *skcipher_bulk_request_alloc(
+	struct crypto_skcipher *tfm, unsigned int maxmsgs, gfp_t gfp)
+{
+	struct skcipher_bulk_request *req;
+
+	req = kmalloc(sizeof(struct skcipher_bulk_request) +
+		      crypto_skcipher_bulk_reqsize(tfm, maxmsgs), gfp);
+
+	if (likely(req)) {
+		skcipher_bulk_request_set_maxmsgs(req, maxmsgs);
+		skcipher_bulk_request_set_tfm(req, tfm);
+	}
+
+	return req;
+}
+
+/**
+ * skcipher_bulk_request_free() - zeroize and free request data structure
+ * @req: request data structure cipher handle to be freed
+ */
+static inline void skcipher_bulk_request_free(struct skcipher_bulk_request *req)
+{
+	kzfree(req);
+}
+
+static inline void skcipher_bulk_request_zero(struct skcipher_bulk_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+
+	memzero_explicit(req, sizeof(*req) +
+			 crypto_skcipher_bulk_reqsize(tfm, req->maxmsgs));
+}
+
+/**
+ * skcipher_bulk_request_set_callback() - set asynchronous callback function
+ * @req: request handle
+ * @flags: specify zero or an ORing of the flags
+ *         CRYPTO_TFM_REQ_MAY_BACKLOG the request queue may back log and
+ *	   increase the wait queue beyond the initial maximum size;
+ *	   CRYPTO_TFM_REQ_MAY_SLEEP the request processing may sleep
+ * @compl: callback function pointer to be registered with the request handle
+ * @data: The data pointer refers to memory that is not used by the kernel
+ *	  crypto API, but provided to the callback function for it to use. Here,
+ *	  the caller can provide a reference to memory the callback function can
+ *	  operate on. As the callback function is invoked asynchronously to the
+ *	  related functionality, it may need to access data structures of the
+ *	  related functionality which can be referenced using this pointer. The
+ *	  callback function can access the memory via the "data" field in the
+ *	  crypto_async_request data structure provided to the callback function.
+ *
+ * This function allows setting the callback function that is triggered once the
+ * cipher operation completes.
+ *
+ * The callback function is registered with the skcipher_bulk_request handle
+ * and must comply with the following template
+ *
+ *	void callback_function(struct crypto_async_request *req, int error)
+ */
+static inline void skcipher_bulk_request_set_callback(
+		struct skcipher_bulk_request *req, u32 flags,
+		crypto_completion_t compl, void *data)
+{
+	req->base.complete = compl;
+	req->base.data = data;
+	req->base.flags = flags;
+}
+
+/**
+ * skcipher_bulk_request_set_crypt() - set data buffers
+ * @req: request handle
+ * @src: source scatter / gather list
+ * @dst: destination scatter / gather list
+ * @msgsize: number of bytes per message (if @msgsizes is not NULL)
+ * @msgsizes: array of message sizes (if NULL, size of all messages is @msgsize)
+ * @nmsgs: number of messages in @src and @dst
+ * @iv: IVs for the cipher operations which must comply with the IV size defined
+ *      by crypto_skcipher_ivsize (i.e. there must be @nmsgs * IV size bytes
+ *      of data)
+ *
+ * This function allows setting of the source data and destination data
+ * scatter / gather lists.
+ *
+ * For encryption, the source is treated as the plaintext and the
+ * destination is the ciphertext. For a decryption operation, the use is
+ * reversed - the source is the ciphertext and the destination is the plaintext.
+ *
+ * The plaintext/ciphertext must consist of @nmsgs messages, each @msgsize
+ * bytes long. Each message is encrypted/decrypted with its own IV extracted
+ * from the @ivs buffer.
+ */
+static inline void skcipher_bulk_request_set_crypt(
+	struct skcipher_bulk_request *req,
+	struct scatterlist *src, struct scatterlist *dst, unsigned int nmsgs,
+	unsigned int msgsize, const unsigned int *msgsizes, void *ivs)
+{
+	req->src = src;
+	req->dst = dst;
+	req->msgsize = msgsize;
+	req->msgsizes = msgsizes;
+	req->nmsgs = nmsgs;
+	req->ivs = ivs;
+}
+
 #endif	/* _CRYPTO_SKCIPHER_H */
 
-- 
2.9.3
