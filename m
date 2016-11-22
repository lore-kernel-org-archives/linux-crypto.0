From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 1/16] crypto: skcipher - Add skcipher walk interface
Date: Tue, 22 Nov 2016 20:08:12 +0800
Message-ID: <E1c99rw-000370-6g@gondobar>
References: <20161122120703.GA11911@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59796 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932716AbcKVMIZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2016 07:08:25 -0500
Received: from [192.168.128.4] (helo=gondobar)
        by fornost.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c99s2-0005zt-S9
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2016 23:08:20 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the skcipher walk interface which replaces both
blkcipher walk and ablkcipher walk.  Just like blkcipher walk it
can also be used for AEAD algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/skcipher.c                  |  511 +++++++++++++++++++++++++++++++++++++
 include/crypto/internal/skcipher.h |   47 +++
 2 files changed, 558 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index f7d0018..0f30719 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -14,9 +14,12 @@
  *
  */
 
+#include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <linux/bug.h>
 #include <linux/cryptouser.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
 #include <linux/seq_file.h>
@@ -24,6 +27,514 @@
 
 #include "internal.h"
 
+enum {
+	SKCIPHER_WALK_PHYS = 1 << 0,
+	SKCIPHER_WALK_SLOW = 1 << 1,
+	SKCIPHER_WALK_COPY = 1 << 2,
+	SKCIPHER_WALK_DIFF = 1 << 3,
+	SKCIPHER_WALK_SLEEP = 1 << 4,
+};
+
+struct skcipher_walk_buffer {
+	struct list_head entry;
+	struct scatter_walk dst;
+	unsigned int len;
+	u8 *data;
+	u8 buffer[];
+};
+
+static int skcipher_walk_next(struct skcipher_walk *walk);
+
+static inline void skcipher_unmap(struct scatter_walk *walk, void *vaddr)
+{
+	if (PageHighMem(scatterwalk_page(walk)))
+		kunmap_atomic(vaddr);
+}
+
+static inline void *skcipher_map(struct scatter_walk *walk)
+{
+	struct page *page = scatterwalk_page(walk);
+
+	return (PageHighMem(page) ? kmap_atomic(page) : page_address(page)) +
+	       offset_in_page(walk->offset);
+}
+
+static inline void skcipher_map_src(struct skcipher_walk *walk)
+{
+	walk->src.virt.addr = skcipher_map(&walk->in);
+}
+
+static inline void skcipher_map_dst(struct skcipher_walk *walk)
+{
+	walk->dst.virt.addr = skcipher_map(&walk->out);
+}
+
+static inline void skcipher_unmap_src(struct skcipher_walk *walk)
+{
+	skcipher_unmap(&walk->in, walk->src.virt.addr);
+}
+
+static inline void skcipher_unmap_dst(struct skcipher_walk *walk)
+{
+	skcipher_unmap(&walk->out, walk->dst.virt.addr);
+}
+
+static inline gfp_t skcipher_walk_gfp(struct skcipher_walk *walk)
+{
+	return walk->flags & SKCIPHER_WALK_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
+}
+
+/* Get a spot of the specified length that does not straddle a page.
+ * The caller needs to ensure that there is enough space for this operation.
+ */
+static inline u8 *skcipher_get_spot(u8 *start, unsigned int len)
+{
+	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
+
+	return max(start, end_page);
+}
+
+static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
+{
+	u8 *addr;
+
+	addr = (u8 *)ALIGN((unsigned long)walk->buffer, walk->alignmask + 1);
+	addr = skcipher_get_spot(addr, bsize);
+	scatterwalk_copychunks(addr, &walk->out, bsize,
+			       (walk->flags & SKCIPHER_WALK_PHYS) ? 2 : 1);
+	return 0;
+}
+
+int skcipher_walk_done(struct skcipher_walk *walk, int err)
+{
+	unsigned int n = walk->nbytes - err;
+	unsigned int nbytes;
+
+	nbytes = walk->total - n;
+
+	if (unlikely(err < 0)) {
+		nbytes = 0;
+		n = 0;
+	} else if (likely(!(walk->flags & (SKCIPHER_WALK_PHYS |
+					   SKCIPHER_WALK_SLOW |
+					   SKCIPHER_WALK_COPY |
+					   SKCIPHER_WALK_DIFF)))) {
+unmap_src:
+		skcipher_unmap_src(walk);
+	} else if (walk->flags & SKCIPHER_WALK_DIFF) {
+		skcipher_unmap_dst(walk);
+		goto unmap_src;
+	} else if (walk->flags & SKCIPHER_WALK_COPY) {
+		skcipher_map_dst(walk);
+		memcpy(walk->dst.virt.addr, walk->page, n);
+		skcipher_unmap_dst(walk);
+	} else if (unlikely(walk->flags & SKCIPHER_WALK_SLOW)) {
+		if (WARN_ON(err)) {
+			err = -EINVAL;
+			nbytes = 0;
+		} else
+			n = skcipher_done_slow(walk, n);
+	}
+
+	if (err > 0)
+		err = 0;
+
+	walk->total = nbytes;
+	walk->nbytes = nbytes;
+
+	scatterwalk_advance(&walk->in, n);
+	scatterwalk_advance(&walk->out, n);
+	scatterwalk_done(&walk->in, 0, nbytes);
+	scatterwalk_done(&walk->out, 1, nbytes);
+
+	if (nbytes) {
+		crypto_yield(walk->flags & SKCIPHER_WALK_SLEEP ?
+			     CRYPTO_TFM_REQ_MAY_SLEEP : 0);
+		return skcipher_walk_next(walk);
+	}
+
+	/* Short-circuit for the common/fast path. */
+	if (!((unsigned long)walk->buffer | (unsigned long)walk->page))
+		goto out;
+
+	if (walk->flags & SKCIPHER_WALK_PHYS)
+		goto out;
+
+	if (walk->iv != walk->oiv)
+		memcpy(walk->oiv, walk->iv, walk->ivsize);
+	if (walk->buffer != walk->page)
+		kfree(walk->buffer);
+	if (walk->page)
+		free_page((unsigned long)walk->page);
+
+out:
+	return err;
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_done);
+
+void skcipher_walk_complete(struct skcipher_walk *walk, int err)
+{
+	struct skcipher_walk_buffer *p, *tmp;
+
+	list_for_each_entry_safe(p, tmp, &walk->buffers, entry) {
+		u8 *data;
+
+		if (err)
+			goto done;
+
+		data = p->data;
+		if (!data) {
+			data = PTR_ALIGN(&p->buffer[0], walk->alignmask + 1);
+			data = skcipher_get_spot(data, walk->chunksize);
+		}
+
+		scatterwalk_copychunks(data, &p->dst, p->len, 1);
+
+		if (offset_in_page(p->data) + p->len + walk->chunksize >
+		    PAGE_SIZE)
+			free_page((unsigned long)p->data);
+
+done:
+		list_del(&p->entry);
+		kfree(p);
+	}
+
+	if (!err && walk->iv != walk->oiv)
+		memcpy(walk->oiv, walk->iv, walk->ivsize);
+	if (walk->buffer != walk->page)
+		kfree(walk->buffer);
+	if (walk->page)
+		free_page((unsigned long)walk->page);
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_complete);
+
+static void skcipher_queue_write(struct skcipher_walk *walk,
+				 struct skcipher_walk_buffer *p)
+{
+	p->dst = walk->out;
+	list_add_tail(&p->entry, &walk->buffers);
+}
+
+static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
+{
+	bool phys = walk->flags & SKCIPHER_WALK_PHYS;
+	unsigned alignmask = walk->alignmask;
+	struct skcipher_walk_buffer *p;
+	unsigned a;
+	unsigned n;
+	u8 *buffer;
+	void *v;
+
+	if (!phys) {
+		buffer = walk->buffer ?: walk->page;
+		if (buffer)
+			goto ok;
+	}
+
+	/* Start with the minimum alignment of kmalloc. */
+	a = crypto_tfm_ctx_alignment() - 1;
+	n = bsize;
+
+	if (phys) {
+		/* Calculate the minimum alignment of p->buffer. */
+		a &= (sizeof(*p) ^ (sizeof(*p) - 1)) >> 1;
+		n += sizeof(*p);
+	}
+
+	/* Minimum size to align p->buffer by alignmask. */
+	n += alignmask & ~a;
+
+	/* Minimum size to ensure p->buffer does not straddle a page. */
+	n += (bsize - 1) & ~(alignmask | a);
+
+	v = kzalloc(n, skcipher_walk_gfp(walk));
+	if (!v)
+		return skcipher_walk_done(walk, -ENOMEM);
+
+	if (phys) {
+		p = v;
+		p->len = bsize;
+		skcipher_queue_write(walk, p);
+		buffer = p->buffer;
+	} else {
+		walk->buffer = v;
+		buffer = v;
+	}
+
+ok:
+	walk->dst.virt.addr = PTR_ALIGN(buffer, alignmask + 1);
+	walk->dst.virt.addr = skcipher_get_spot(walk->dst.virt.addr, bsize);
+	walk->src.virt.addr = walk->dst.virt.addr;
+
+	scatterwalk_copychunks(walk->src.virt.addr, &walk->in, bsize, 0);
+
+	walk->nbytes = bsize;
+	walk->flags |= SKCIPHER_WALK_SLOW;
+
+	return 0;
+}
+
+static int skcipher_next_copy(struct skcipher_walk *walk)
+{
+	struct skcipher_walk_buffer *p;
+	u8 *tmp = walk->page;
+
+	skcipher_map_src(walk);
+	memcpy(tmp, walk->src.virt.addr, walk->nbytes);
+	skcipher_unmap_src(walk);
+
+	walk->src.virt.addr = tmp;
+	walk->dst.virt.addr = tmp;
+
+	if (!(walk->flags & SKCIPHER_WALK_PHYS))
+		return 0;
+
+	p = kmalloc(sizeof(*p), skcipher_walk_gfp(walk));
+	if (!p)
+		return -ENOMEM;
+
+	p->data = walk->page;
+	p->len = walk->nbytes;
+	skcipher_queue_write(walk, p);
+
+	if (offset_in_page(walk->page) + walk->nbytes + walk->chunksize >
+	    PAGE_SIZE)
+		walk->page = NULL;
+	else
+		walk->page += walk->nbytes;
+
+	return 0;
+}
+
+static int skcipher_next_fast(struct skcipher_walk *walk)
+{
+	unsigned long diff;
+
+	walk->src.phys.page = scatterwalk_page(&walk->in);
+	walk->src.phys.offset = offset_in_page(walk->in.offset);
+	walk->dst.phys.page = scatterwalk_page(&walk->out);
+	walk->dst.phys.offset = offset_in_page(walk->out.offset);
+
+	if (walk->flags & SKCIPHER_WALK_PHYS)
+		return 0;
+
+	diff = walk->src.phys.offset - walk->dst.phys.offset;
+	diff |= walk->src.virt.page - walk->dst.virt.page;
+
+	skcipher_map_src(walk);
+	walk->dst.virt.addr = walk->src.virt.addr;
+
+	if (diff) {
+		walk->flags |= SKCIPHER_WALK_DIFF;
+		skcipher_map_dst(walk);
+	}
+
+	return 0;
+}
+
+static int skcipher_walk_next(struct skcipher_walk *walk)
+{
+	unsigned int bsize;
+	unsigned int n;
+	int err;
+
+	walk->flags &= ~(SKCIPHER_WALK_SLOW | SKCIPHER_WALK_COPY |
+			 SKCIPHER_WALK_DIFF);
+
+	n = walk->total;
+	bsize = min(walk->chunksize, max(n, walk->blocksize));
+	n = scatterwalk_clamp(&walk->in, n);
+	n = scatterwalk_clamp(&walk->out, n);
+
+	if (unlikely(n < bsize)) {
+		if (unlikely(walk->total < walk->blocksize))
+			return skcipher_walk_done(walk, -EINVAL);
+
+slow_path:
+		err = skcipher_next_slow(walk, bsize);
+		goto set_phys_lowmem;
+	}
+
+	if (unlikely((walk->in.offset | walk->out.offset) & walk->alignmask)) {
+		if (!walk->page) {
+			gfp_t gfp = skcipher_walk_gfp(walk);
+
+			walk->page = (void *)__get_free_page(gfp);
+			if (!walk->page)
+				goto slow_path;
+		}
+
+		walk->nbytes = min_t(unsigned, n,
+				     PAGE_SIZE - offset_in_page(walk->page));
+		walk->flags |= SKCIPHER_WALK_COPY;
+		err = skcipher_next_copy(walk);
+		goto set_phys_lowmem;
+	}
+
+	walk->nbytes = n;
+
+	return skcipher_next_fast(walk);
+
+set_phys_lowmem:
+	if (!err && (walk->flags & SKCIPHER_WALK_PHYS)) {
+		walk->src.phys.page = virt_to_page(walk->src.virt.addr);
+		walk->dst.phys.page = virt_to_page(walk->dst.virt.addr);
+		walk->src.phys.offset &= PAGE_SIZE - 1;
+		walk->dst.phys.offset &= PAGE_SIZE - 1;
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_next);
+
+static int skcipher_copy_iv(struct skcipher_walk *walk)
+{
+	unsigned a = crypto_tfm_ctx_alignment() - 1;
+	unsigned alignmask = walk->alignmask;
+	unsigned ivsize = walk->ivsize;
+	unsigned bs = walk->chunksize;
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
+static int skcipher_walk_first(struct skcipher_walk *walk)
+{
+	walk->nbytes = 0;
+
+	if (WARN_ON_ONCE(in_irq()))
+		return -EDEADLK;
+
+	if (unlikely(!walk->total))
+		return 0;
+
+	walk->buffer = NULL;
+	if (unlikely(((unsigned long)walk->iv & walk->alignmask))) {
+		int err = skcipher_copy_iv(walk);
+		if (err)
+			return err;
+	}
+
+	walk->page = NULL;
+	walk->nbytes = walk->total;
+
+	return skcipher_walk_next(walk);
+}
+
+static int skcipher_walk_skcipher(struct skcipher_walk *walk,
+				  struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	scatterwalk_start(&walk->in, req->src);
+	scatterwalk_start(&walk->out, req->dst);
+
+	walk->total = req->cryptlen;
+	walk->iv = req->iv;
+	walk->oiv = req->iv;
+
+	walk->flags &= ~SKCIPHER_WALK_SLEEP;
+	walk->flags |= req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+		       SKCIPHER_WALK_SLEEP : 0;
+
+	walk->blocksize = crypto_skcipher_blocksize(tfm);
+	walk->chunksize = crypto_skcipher_chunksize(tfm);
+	walk->ivsize = crypto_skcipher_ivsize(tfm);
+	walk->alignmask = crypto_skcipher_alignmask(tfm);
+
+	return skcipher_walk_first(walk);
+}
+
+int skcipher_walk_virt(struct skcipher_walk *walk,
+		       struct skcipher_request *req, bool atomic)
+{
+	int err;
+
+	walk->flags &= ~SKCIPHER_WALK_PHYS;
+
+	err = skcipher_walk_skcipher(walk, req);
+
+	walk->flags &= atomic ? ~SKCIPHER_WALK_SLEEP : ~0;
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_virt);
+
+void skcipher_walk_atomise(struct skcipher_walk *walk)
+{
+	walk->flags &= ~SKCIPHER_WALK_SLEEP;
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_atomise);
+
+int skcipher_walk_async(struct skcipher_walk *walk,
+			struct skcipher_request *req)
+{
+	walk->flags |= SKCIPHER_WALK_PHYS;
+
+	INIT_LIST_HEAD(&walk->buffers);
+
+	return skcipher_walk_skcipher(walk, req);
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_async);
+
+int skcipher_walk_aead(struct skcipher_walk *walk, struct aead_request *req,
+		       bool atomic)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	int err;
+
+	scatterwalk_start(&walk->in, req->src);
+	scatterwalk_start(&walk->out, req->dst);
+
+	scatterwalk_copychunks(NULL, &walk->in, req->assoclen, 2);
+	scatterwalk_copychunks(NULL, &walk->out, req->assoclen, 2);
+
+	walk->total = req->cryptlen;
+	walk->iv = req->iv;
+	walk->oiv = req->iv;
+
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP)
+		walk->flags |= SKCIPHER_WALK_SLEEP;
+	else
+		walk->flags &= ~SKCIPHER_WALK_SLEEP;
+
+	walk->blocksize = crypto_aead_blocksize(tfm);
+	walk->chunksize = crypto_aead_chunksize(tfm);
+	walk->ivsize = crypto_aead_ivsize(tfm);
+	walk->alignmask = crypto_aead_alignmask(tfm);
+
+	err = skcipher_walk_first(walk);
+
+	if (atomic)
+		walk->flags &= ~SKCIPHER_WALK_SLEEP;
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_aead);
+
 static unsigned int crypto_skcipher_extsize(struct crypto_alg *alg)
 {
 	if (alg->cra_type == &crypto_blkcipher_type)
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 7a7e815..d55041f 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -15,8 +15,10 @@
 
 #include <crypto/algapi.h>
 #include <crypto/skcipher.h>
+#include <linux/list.h>
 #include <linux/types.h>
 
+struct aead_request;
 struct rtattr;
 
 struct skcipher_instance {
@@ -34,6 +36,40 @@ struct crypto_skcipher_spawn {
 	struct crypto_spawn base;
 };
 
+struct skcipher_walk {
+	union {
+		struct {
+			struct page *page;
+			unsigned long offset;
+		} phys;
+
+		struct {
+			u8 *page;
+			void *addr;
+		} virt;
+	} src, dst;
+
+	struct scatter_walk in;
+	unsigned int nbytes;
+
+	struct scatter_walk out;
+	unsigned int total;
+
+	struct list_head buffers;
+
+	u8 *page;
+	u8 *buffer;
+	u8 *oiv;
+	void *iv;
+
+	unsigned int ivsize;
+
+	int flags;
+	unsigned int blocksize;
+	unsigned int chunksize;
+	unsigned int alignmask;
+};
+
 extern const struct crypto_type crypto_givcipher_type;
 
 static inline struct crypto_instance *skcipher_crypto_instance(
@@ -104,6 +140,17 @@ static inline void crypto_skcipher_set_reqsize(
 int skcipher_register_instance(struct crypto_template *tmpl,
 			       struct skcipher_instance *inst);
 
+int skcipher_walk_done(struct skcipher_walk *walk, int err);
+int skcipher_walk_virt(struct skcipher_walk *walk,
+		       struct skcipher_request *req,
+		       bool atomic);
+void skcipher_walk_atomise(struct skcipher_walk *walk);
+int skcipher_walk_async(struct skcipher_walk *walk,
+			struct skcipher_request *req);
+int skcipher_walk_aead(struct skcipher_walk *walk, struct aead_request *req,
+		       bool atomic);
+void skcipher_walk_complete(struct skcipher_walk *walk, int err);
+
 static inline void ablkcipher_request_complete(struct ablkcipher_request *req,
 					       int err)
 {
