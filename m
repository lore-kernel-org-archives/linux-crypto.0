From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [RFC PATCH 2/6] crypto: skcipher - Add bulk request support to walk
Date: Thu, 12 Jan 2017 13:59:54 +0100
Message-ID: <027b294ae1d34f8a73083bdcc722d84d3c342552.1484215956.git.omosnacek@gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:34336 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750960AbdALNAu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 08:00:50 -0500
Received: by mail-wj0-f196.google.com with SMTP id qs7so1787426wjc.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2017 05:00:48 -0800 (PST)
In-Reply-To: <cover.1484215956.git.omosnacek@gmail.com>
In-Reply-To: <cover.1484215956.git.omosnacek@gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch tweaks skcipher_walk so it can be used with the new bulk requests.

The new skipher_walk can be initialized either from a skcipher_request (in
which case its behavior is equivalent to the old code) or from a
skcipher_bulk_request, in which case the usage is almost identical, the most
significant exception being that skciphers which somehow tweak the IV
(e.g. XTS) must check the new nextmsg flag before processing each chunk and
re-tweak the IV if it is set. For other ciphers skcipher_walk automatically
switches to the next IV at message boundaries.

Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
---
 crypto/skcipher.c                  | 192 +++++++++++++++++++++++++++----------
 include/crypto/internal/skcipher.h |  10 +-
 2 files changed, 153 insertions(+), 49 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 8b6d684..b810e90 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -33,6 +33,7 @@ enum {
 	SKCIPHER_WALK_COPY = 1 << 2,
 	SKCIPHER_WALK_DIFF = 1 << 3,
 	SKCIPHER_WALK_SLEEP = 1 << 4,
+	SKCIPHER_WALK_HETEROGENOUS = 1 << 5,
 };
 
 struct skcipher_walk_buffer {
@@ -94,6 +95,41 @@ static inline u8 *skcipher_get_spot(u8 *start, unsigned int len)
 	return max(start, end_page);
 }
 
+static int skcipher_copy_iv(struct skcipher_walk *walk)
+{
+	unsigned a = crypto_tfm_ctx_alignment() - 1;
+	unsigned alignmask = walk->alignmask;
+	unsigned ivsize = walk->ivsize;
+	unsigned bs = walk->stride;
+	unsigned aligned_bs;
+	unsigned size;
+	u8 *iv;
+
+	aligned_bs = ALIGN(bs, alignmask);
+
+	/* Minimum size to align buffer by alignmask. */
+	size = alignmask & ~a;
+
+	if (walk->flags & SKCIPHER_WALK_PHYS)
+		size += ivsize;
+	else {
+		size += aligned_bs + ivsize;
+
+		/* Minimum size to ensure buffer does not straddle a page. */
+		size += (bs - 1) & ~(alignmask | a);
+	}
+
+	walk->buffer = kmalloc(size, skcipher_walk_gfp(walk));
+	if (!walk->buffer)
+		return -ENOMEM;
+
+	iv = PTR_ALIGN(walk->buffer, alignmask + 1);
+	iv = skcipher_get_spot(iv, bs) + aligned_bs;
+
+	walk->iv = memcpy(iv, walk->iv, walk->ivsize);
+	return 0;
+}
+
 static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
 {
 	u8 *addr;
@@ -108,9 +144,12 @@ static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
 int skcipher_walk_done(struct skcipher_walk *walk, int err)
 {
 	unsigned int n = walk->nbytes - err;
-	unsigned int nbytes;
+	unsigned int nbytes, nbytes_msg;
+
+	walk->nextmsg = false; /* reset the nextmsg flag */
 
 	nbytes = walk->total - n;
+	nbytes_msg = walk->total_msg - n;
 
 	if (unlikely(err < 0)) {
 		nbytes = 0;
@@ -139,8 +178,31 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
 	if (err > 0)
 		err = 0;
 
+	if (nbytes && !nbytes_msg) {
+		walk->nextmsg = true;
+
+		/* write the output IV: */
+		if (walk->iv != walk->oiv)
+			memcpy(walk->oiv, walk->iv, walk->ivsize);
+
+		/* advance to the IV of next message: */
+		walk->oiv += walk->ivsize;
+		walk->iv = walk->oiv;
+
+		if (unlikely(((unsigned long)walk->iv & walk->alignmask))) {
+			err = skcipher_copy_iv(walk);
+			if (err)
+				return err;
+		}
+
+		nbytes_msg = *walk->nextmsgsize;
+		if (walk->flags & SKCIPHER_WALK_HETEROGENOUS)
+			++walk->nextmsgsize;
+	}
+
+	walk->nbytes = nbytes_msg;
+	walk->total_msg = nbytes_msg;
 	walk->total = nbytes;
-	walk->nbytes = nbytes;
 
 	scatterwalk_advance(&walk->in, n);
 	scatterwalk_advance(&walk->out, n);
@@ -343,13 +405,13 @@ static int skcipher_walk_next(struct skcipher_walk *walk)
 	walk->flags &= ~(SKCIPHER_WALK_SLOW | SKCIPHER_WALK_COPY |
 			 SKCIPHER_WALK_DIFF);
 
-	n = walk->total;
+	n = walk->total_msg;
 	bsize = min(walk->stride, max(n, walk->blocksize));
 	n = scatterwalk_clamp(&walk->in, n);
 	n = scatterwalk_clamp(&walk->out, n);
 
 	if (unlikely(n < bsize)) {
-		if (unlikely(walk->total < walk->blocksize))
+		if (unlikely(walk->total_msg < walk->blocksize))
 			return skcipher_walk_done(walk, -EINVAL);
 
 slow_path:
@@ -388,41 +450,6 @@ static int skcipher_walk_next(struct skcipher_walk *walk)
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_next);
 
-static int skcipher_copy_iv(struct skcipher_walk *walk)
-{
-	unsigned a = crypto_tfm_ctx_alignment() - 1;
-	unsigned alignmask = walk->alignmask;
-	unsigned ivsize = walk->ivsize;
-	unsigned bs = walk->stride;
-	unsigned aligned_bs;
-	unsigned size;
-	u8 *iv;
-
-	aligned_bs = ALIGN(bs, alignmask);
-
-	/* Minimum size to align buffer by alignmask. */
-	size = alignmask & ~a;
-
-	if (walk->flags & SKCIPHER_WALK_PHYS)
-		size += ivsize;
-	else {
-		size += aligned_bs + ivsize;
-
-		/* Minimum size to ensure buffer does not straddle a page. */
-		size += (bs - 1) & ~(alignmask | a);
-	}
-
-	walk->buffer = kmalloc(size, skcipher_walk_gfp(walk));
-	if (!walk->buffer)
-		return -ENOMEM;
-
-	iv = PTR_ALIGN(walk->buffer, alignmask + 1);
-	iv = skcipher_get_spot(iv, bs) + aligned_bs;
-
-	walk->iv = memcpy(iv, walk->iv, walk->ivsize);
-	return 0;
-}
-
 static int skcipher_walk_first(struct skcipher_walk *walk)
 {
 	walk->nbytes = 0;
@@ -441,11 +468,28 @@ static int skcipher_walk_first(struct skcipher_walk *walk)
 	}
 
 	walk->page = NULL;
-	walk->nbytes = walk->total;
+	walk->nbytes = walk->total_msg;
 
 	return skcipher_walk_next(walk);
 }
 
+static int skcipher_walk_skcipher_common(struct skcipher_walk *walk,
+					 struct crypto_skcipher *tfm,
+					 u32 req_flags)
+{
+	walk->flags &= ~SKCIPHER_WALK_SLEEP;
+	walk->flags |= req_flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+		       SKCIPHER_WALK_SLEEP : 0;
+
+	walk->nextmsg = true;
+	walk->blocksize = crypto_skcipher_blocksize(tfm);
+	walk->stride = crypto_skcipher_walksize(tfm);
+	walk->ivsize = crypto_skcipher_ivsize(tfm);
+	walk->alignmask = crypto_skcipher_alignmask(tfm);
+
+	return skcipher_walk_first(walk);
+}
+
 static int skcipher_walk_skcipher(struct skcipher_walk *walk,
 				  struct skcipher_request *req)
 {
@@ -454,20 +498,45 @@ static int skcipher_walk_skcipher(struct skcipher_walk *walk,
 	scatterwalk_start(&walk->in, req->src);
 	scatterwalk_start(&walk->out, req->dst);
 
+	walk->nextmsgsize = NULL;
+	walk->total_msg = req->cryptlen;
 	walk->total = req->cryptlen;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
+	walk->flags &= ~SKCIPHER_WALK_HETEROGENOUS;
 
-	walk->flags &= ~SKCIPHER_WALK_SLEEP;
-	walk->flags |= req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
-		       SKCIPHER_WALK_SLEEP : 0;
+	return skcipher_walk_skcipher_common(walk, tfm, req->base.flags);
+}
 
-	walk->blocksize = crypto_skcipher_blocksize(tfm);
-	walk->stride = crypto_skcipher_walksize(tfm);
-	walk->ivsize = crypto_skcipher_ivsize(tfm);
-	walk->alignmask = crypto_skcipher_alignmask(tfm);
+static int skcipher_walk_skcipher_bulk(struct skcipher_walk *walk,
+				       struct skcipher_bulk_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	unsigned int total, i;
 
-	return skcipher_walk_first(walk);
+	scatterwalk_start(&walk->in, req->src);
+	scatterwalk_start(&walk->out, req->dst);
+
+	if (req->msgsizes) {
+		total = 0;
+		for (i = 0; i < req->nmsgs; i++)
+			total += req->msgsizes[i];
+
+		walk->nextmsgsize = req->msgsizes;
+		walk->total_msg = *walk->nextmsgsize++;
+		walk->total = total;
+		walk->flags |= SKCIPHER_WALK_HETEROGENOUS;
+	} else {
+		walk->nextmsgsize = &req->msgsize;
+		walk->total_msg = req->msgsize;
+		walk->total = req->nmsgs * req->msgsize;
+		walk->flags &= ~SKCIPHER_WALK_HETEROGENOUS;
+	}
+
+	walk->iv = req->ivs;
+	walk->oiv = req->ivs;
+
+	return skcipher_walk_skcipher_common(walk, tfm, req->base.flags);
 }
 
 int skcipher_walk_virt(struct skcipher_walk *walk,
@@ -485,6 +554,21 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_virt);
 
+int skcipher_walk_virt_bulk(struct skcipher_walk *walk,
+			    struct skcipher_bulk_request *req, bool atomic)
+{
+	int err;
+
+	walk->flags &= ~SKCIPHER_WALK_PHYS;
+
+	err = skcipher_walk_skcipher_bulk(walk, req);
+
+	walk->flags &= atomic ? ~SKCIPHER_WALK_SLEEP : ~0;
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_virt_bulk);
+
 void skcipher_walk_atomise(struct skcipher_walk *walk)
 {
 	walk->flags &= ~SKCIPHER_WALK_SLEEP;
@@ -502,6 +586,17 @@ int skcipher_walk_async(struct skcipher_walk *walk,
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_async);
 
+int skcipher_walk_async_bulk(struct skcipher_walk *walk,
+			     struct skcipher_bulk_request *req)
+{
+	walk->flags |= SKCIPHER_WALK_PHYS;
+
+	INIT_LIST_HEAD(&walk->buffers);
+
+	return skcipher_walk_skcipher_bulk(walk, req);
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_async_bulk);
+
 static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 				     struct aead_request *req, bool atomic)
 {
@@ -509,6 +604,7 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 	int err;
 
 	walk->flags &= ~SKCIPHER_WALK_PHYS;
+	walk->flags &= ~SKCIPHER_WALK_HETEROGENOUS;
 
 	scatterwalk_start(&walk->in, req->src);
 	scatterwalk_start(&walk->out, req->dst);
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index f536b57..1f789df 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -50,9 +50,12 @@ struct skcipher_walk {
 	} src, dst;
 
 	struct scatter_walk in;
+	struct scatter_walk out;
 	unsigned int nbytes;
 
-	struct scatter_walk out;
+	bool nextmsg;
+	const unsigned int *nextmsgsize;
+	unsigned int total_msg;
 	unsigned int total;
 
 	struct list_head buffers;
@@ -150,9 +153,14 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err);
 int skcipher_walk_virt(struct skcipher_walk *walk,
 		       struct skcipher_request *req,
 		       bool atomic);
+int skcipher_walk_virt_bulk(struct skcipher_walk *walk,
+			    struct skcipher_bulk_request *req,
+			    bool atomic);
 void skcipher_walk_atomise(struct skcipher_walk *walk);
 int skcipher_walk_async(struct skcipher_walk *walk,
 			struct skcipher_request *req);
+int skcipher_walk_async_bulk(struct skcipher_walk *walk,
+			     struct skcipher_bulk_request *req);
 int skcipher_walk_aead(struct skcipher_walk *walk, struct aead_request *req,
 		       bool atomic);
 int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
-- 
2.9.3
