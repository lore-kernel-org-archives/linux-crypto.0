From: David Miller <davem@davemloft.net>
Subject: [PATCH 5/6] crypto: Add ablkcipher_walk interfaces.
Date: Mon, 17 May 2010 22:22:49 -0700 (PDT)
Message-ID: <20100517.222249.124005323.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50957
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579Ab0ERFWk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 May 2010 01:22:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


These are akin to the blkcipher_walk helpers.

The main differences in the async variant are:

1) Only physical walking is supported.  We can't hold on to
   kmap mappings across the async operation to support virtual
   ablkcipher_walk operations anyways.

2) Bounce buffers used for async more need to be persistent and
   freed at a later point in time when the async op completes.
   Therefore we maintain a list of writeback buffers and require
   that the ablkcipher_walk user call the 'complete' operation
   so we can copy the bounce buffers out to the real buffers and
   free up the bounce buffer chunks.

These interfaces will be used by the new Niagara2 crypto driver.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 crypto/ablkcipher.c     |  277 +++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/algapi.h |   40 +++++++
 2 files changed, 317 insertions(+), 0 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index fe980da..98a6610 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -24,10 +24,287 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 
+#include <crypto/scatterwalk.h>
+
 #include "internal.h"
 
 static const char *skcipher_default_geniv __read_mostly;
 
+struct ablkcipher_buffer {
+	struct list_head	entry;
+	struct scatter_walk	dst;
+	unsigned int		len;
+	void			*data;
+};
+
+enum {
+	ABLKCIPHER_WALK_SLOW = 1 << 0,
+};
+
+static inline void ablkcipher_buffer_write(struct ablkcipher_buffer *p)
+{
+	scatterwalk_copychunks(p->data, &p->dst, p->len, 1);
+}
+
+void __ablkcipher_walk_complete(struct ablkcipher_walk *walk)
+{
+	struct ablkcipher_buffer *p, *tmp;
+
+	list_for_each_entry_safe(p, tmp, &walk->buffers, entry) {
+		ablkcipher_buffer_write(p);
+		list_del(&p->entry);
+		kfree(p);
+	}
+}
+EXPORT_SYMBOL_GPL(__ablkcipher_walk_complete);
+
+static inline void ablkcipher_queue_write(struct ablkcipher_walk *walk,
+					  struct ablkcipher_buffer *p)
+{
+	p->dst = walk->out;
+	list_add_tail(&p->entry, &walk->buffers);
+}
+
+/* Get a spot of the specified length that does not straddle a page.
+ * The caller needs to ensure that there is enough space for this operation.
+ */
+static inline u8 *ablkcipher_get_spot(u8 *start, unsigned int len)
+{
+	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
+	return max(start, end_page);
+}
+
+static inline unsigned int ablkcipher_done_slow(struct ablkcipher_walk *walk,
+						unsigned int bsize)
+{
+	unsigned int n = bsize;
+
+	for (;;) {
+		unsigned int len_this_page = scatterwalk_pagelen(&walk->out);
+
+		if (len_this_page > n)
+			len_this_page = n;
+		scatterwalk_advance(&walk->out, n);
+		if (n == len_this_page)
+			break;
+		n -= len_this_page;
+		scatterwalk_start(&walk->out, scatterwalk_sg_next(walk->out.sg));
+	}
+
+	return bsize;
+}
+
+static inline unsigned int ablkcipher_done_fast(struct ablkcipher_walk *walk,
+						unsigned int n)
+{
+	scatterwalk_advance(&walk->in, n);
+	scatterwalk_advance(&walk->out, n);
+
+	return n;
+}
+
+static int ablkcipher_walk_next(struct ablkcipher_request *req,
+				struct ablkcipher_walk *walk);
+
+int ablkcipher_walk_done(struct ablkcipher_request *req,
+			 struct ablkcipher_walk *walk, int err)
+{
+	struct crypto_tfm *tfm = req->base.tfm;
+	unsigned int nbytes = 0;
+
+	if (likely(err >= 0)) {
+		unsigned int n = walk->nbytes - err;
+
+		if (likely(!(walk->flags & ABLKCIPHER_WALK_SLOW)))
+			n = ablkcipher_done_fast(walk, n);
+		else if (WARN_ON(err)) {
+			err = -EINVAL;
+			goto err;
+		} else
+			n = ablkcipher_done_slow(walk, n);
+
+		nbytes = walk->total - n;
+		err = 0;
+	}
+
+	scatterwalk_done(&walk->in, 0, nbytes);
+	scatterwalk_done(&walk->out, 1, nbytes);
+
+err:
+	walk->total = nbytes;
+	walk->nbytes = nbytes;
+
+	if (nbytes) {
+		crypto_yield(req->base.flags);
+		return ablkcipher_walk_next(req, walk);
+	}
+
+	if (walk->iv != req->info)
+		memcpy(req->info, walk->iv, tfm->crt_ablkcipher.ivsize);
+	if (walk->iv_buffer)
+		kfree(walk->iv_buffer);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(ablkcipher_walk_done);
+
+static inline int ablkcipher_next_slow(struct ablkcipher_request *req,
+				       struct ablkcipher_walk *walk,
+				       unsigned int bsize,
+				       unsigned int alignmask,
+				       void **src_p, void **dst_p)
+{
+	unsigned aligned_bsize = ALIGN(bsize, alignmask + 1);
+	struct ablkcipher_buffer *p;
+	void *src, *dst, *base;
+	unsigned int n;
+
+	n = ALIGN(sizeof(struct ablkcipher_buffer), alignmask + 1);
+	n += (aligned_bsize * 3 - (alignmask + 1) +
+	      (alignmask & ~(crypto_tfm_ctx_alignment() - 1)));
+
+	p = kmalloc(n, GFP_ATOMIC);
+	if (!p)
+		ablkcipher_walk_done(req, walk, -ENOMEM);
+
+	base = p + 1;
+
+	dst = (u8 *)ALIGN((unsigned long)base, alignmask + 1);
+	src = dst = ablkcipher_get_spot(dst, bsize);
+
+	p->len = bsize;
+	p->data = dst;
+
+	scatterwalk_copychunks(src, &walk->in, bsize, 0);
+
+	ablkcipher_queue_write(walk, p);
+
+	walk->nbytes = bsize;
+	walk->flags |= ABLKCIPHER_WALK_SLOW;
+
+	*src_p = src;
+	*dst_p = dst;
+
+	return 0;
+}
+
+static inline int ablkcipher_copy_iv(struct ablkcipher_walk *walk,
+				     struct crypto_tfm *tfm,
+				     unsigned int alignmask)
+{
+	unsigned bs = walk->blocksize;
+	unsigned int ivsize = tfm->crt_ablkcipher.ivsize;
+	unsigned aligned_bs = ALIGN(bs, alignmask + 1);
+	unsigned int size = aligned_bs * 2 + ivsize + max(aligned_bs, ivsize) -
+			    (alignmask + 1);
+	u8 *iv;
+
+	size += alignmask & ~(crypto_tfm_ctx_alignment() - 1);
+	walk->iv_buffer = kmalloc(size, GFP_ATOMIC);
+	if (!walk->iv_buffer)
+		return -ENOMEM;
+
+	iv = (u8 *)ALIGN((unsigned long)walk->iv_buffer, alignmask + 1);
+	iv = ablkcipher_get_spot(iv, bs) + aligned_bs;
+	iv = ablkcipher_get_spot(iv, bs) + aligned_bs;
+	iv = ablkcipher_get_spot(iv, ivsize);
+
+	walk->iv = memcpy(iv, walk->iv, ivsize);
+	return 0;
+}
+
+static inline int ablkcipher_next_fast(struct ablkcipher_request *req,
+				       struct ablkcipher_walk *walk)
+{
+	walk->src.page = scatterwalk_page(&walk->in);
+	walk->src.offset = offset_in_page(walk->in.offset);
+	walk->dst.page = scatterwalk_page(&walk->out);
+	walk->dst.offset = offset_in_page(walk->out.offset);
+
+	return 0;
+}
+
+static int ablkcipher_walk_next(struct ablkcipher_request *req,
+				struct ablkcipher_walk *walk)
+{
+	struct crypto_tfm *tfm = req->base.tfm;
+	unsigned int alignmask, bsize, n;
+	void *src, *dst;
+	int err;
+
+	alignmask = crypto_tfm_alg_alignmask(tfm);
+	n = walk->total;
+	if (unlikely(n < crypto_tfm_alg_blocksize(tfm))) {
+		req->base.flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
+		return ablkcipher_walk_done(req, walk, -EINVAL);
+	}
+
+	walk->flags &= ~ABLKCIPHER_WALK_SLOW;
+	src = dst = NULL;
+
+	bsize = min(walk->blocksize, n);
+	n = scatterwalk_clamp(&walk->in, n);
+	n = scatterwalk_clamp(&walk->out, n);
+
+	if (n < bsize ||
+	    !scatterwalk_aligned(&walk->in, alignmask) ||
+	    !scatterwalk_aligned(&walk->out, alignmask)) {
+		err = ablkcipher_next_slow(req, walk, bsize, alignmask,
+					   &src, &dst);
+		goto set_phys_lowmem;
+	}
+
+	walk->nbytes = n;
+
+	return ablkcipher_next_fast(req, walk);
+
+set_phys_lowmem:
+	if (err >= 0) {
+		walk->src.page = virt_to_page(src);
+		walk->dst.page = virt_to_page(dst);
+		walk->src.offset = ((unsigned long)src & (PAGE_SIZE - 1));
+		walk->dst.offset = ((unsigned long)dst & (PAGE_SIZE - 1));
+	}
+
+	return err;
+}
+
+static int ablkcipher_walk_first(struct ablkcipher_request *req,
+				 struct ablkcipher_walk *walk)
+{
+	struct crypto_tfm *tfm = req->base.tfm;
+	unsigned int alignmask;
+
+	alignmask = crypto_tfm_alg_alignmask(tfm);
+	if (WARN_ON_ONCE(in_irq()))
+		return -EDEADLK;
+
+	walk->nbytes = walk->total;
+	if (unlikely(!walk->total))
+		return 0;
+
+	walk->iv_buffer = NULL;
+	walk->iv = req->info;
+	if (unlikely(((unsigned long)walk->iv & alignmask))) {
+		int err = ablkcipher_copy_iv(walk, tfm, alignmask);
+		if (err)
+			return err;
+	}
+
+	scatterwalk_start(&walk->in, walk->in.sg);
+	scatterwalk_start(&walk->out, walk->out.sg);
+
+	return ablkcipher_walk_next(req, walk);
+}
+
+int ablkcipher_walk_phys(struct ablkcipher_request *req,
+			 struct ablkcipher_walk *walk)
+{
+	walk->blocksize = crypto_tfm_alg_blocksize(req->base.tfm);
+	return ablkcipher_walk_first(req, walk);
+}
+EXPORT_SYMBOL_GPL(ablkcipher_walk_phys);
+
 static int setkey_unaligned(struct crypto_ablkcipher *tfm, const u8 *key,
 			    unsigned int keylen)
 {
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index fc0d575..59c3e5b 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -103,6 +103,23 @@ struct blkcipher_walk {
 	unsigned int blocksize;
 };
 
+struct ablkcipher_walk {
+	struct {
+		struct page *page;
+		unsigned int offset;
+	} src, dst;
+
+	struct scatter_walk	in;
+	unsigned int		nbytes;
+	struct scatter_walk	out;
+	unsigned int		total;
+	struct list_head	buffers;
+	u8			*iv_buffer;
+	u8			*iv;
+	int			flags;
+	unsigned int		blocksize;
+};
+
 extern const struct crypto_type crypto_ablkcipher_type;
 extern const struct crypto_type crypto_aead_type;
 extern const struct crypto_type crypto_blkcipher_type;
@@ -173,6 +190,12 @@ int blkcipher_walk_virt_block(struct blkcipher_desc *desc,
 			      struct blkcipher_walk *walk,
 			      unsigned int blocksize);
 
+int ablkcipher_walk_done(struct ablkcipher_request *req,
+			 struct ablkcipher_walk *walk, int err);
+int ablkcipher_walk_phys(struct ablkcipher_request *req,
+			 struct ablkcipher_walk *walk);
+void __ablkcipher_walk_complete(struct ablkcipher_walk *walk);
+
 static inline void *crypto_tfm_ctx_aligned(struct crypto_tfm *tfm)
 {
 	return PTR_ALIGN(crypto_tfm_ctx(tfm),
@@ -283,6 +306,23 @@ static inline void blkcipher_walk_init(struct blkcipher_walk *walk,
 	walk->total = nbytes;
 }
 
+static inline void ablkcipher_walk_init(struct ablkcipher_walk *walk,
+					struct scatterlist *dst,
+					struct scatterlist *src,
+					unsigned int nbytes)
+{
+	walk->in.sg = src;
+	walk->out.sg = dst;
+	walk->total = nbytes;
+	INIT_LIST_HEAD(&walk->buffers);
+}
+
+static inline void ablkcipher_walk_complete(struct ablkcipher_walk *walk)
+{
+	if (unlikely(!list_empty(&walk->buffers)))
+		__ablkcipher_walk_complete(walk);
+}
+
 static inline struct crypto_async_request *crypto_get_backlog(
 	struct crypto_queue *queue)
 {
-- 
1.7.0.4
