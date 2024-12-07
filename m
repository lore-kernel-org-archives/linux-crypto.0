Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF78154426;
	Sat,  7 Dec 2024 19:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733598328; cv=none; b=u3H6Yp8mCLDB5lNKjTeGMiuXIGlN8ZhwWXFJ1jllNy14+ZPgX95pOj2pdFIJm7O3bk+sQupu/FOUnD7gW8FVYPxRHwFvOLnmpr2YqRH7J9Lb4cXSNM6fwGbDMtTQruTqFilaN7mbEKNeXq2yyBQKuTlUDMI874MhJ7C9IwbJJrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733598328; c=relaxed/simple;
	bh=5ssa9cst49CNTwonWO6JXDKJ1HW1KA0vD8cdU0CXvn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJPBc8VgMjDi4y26HJWyCfqUM/hCyLcBlp9kwh2dTdDUZdiX/aeTMuyWYaASSOvubuCk9gpFRFhrztYh5UHc5zavp3ca9ZFGF/lWHqzJwfNETOmds+qRVglhiLr7PbN0Z8SoTN2hAH0BwtIbV3RHOaAfYBZxWmqo+7GZCuyTENg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z2hNn+7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z2hNn+7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BEDC4CEDD;
	Sat,  7 Dec 2024 19:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733598327;
	bh=5ssa9cst49CNTwonWO6JXDKJ1HW1KA0vD8cdU0CXvn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2hNn+7njsbokViVaNmo4oQw0gm6MHC/ruMXa2FeGADb7ZBJPWo25eBEpc/q3AlYF
	 zKHMWfHQG+UIr3vSpP5XjAFnQHlrmAcL6JyRRt8pCg9dB0iiJzSAHc6rn8ZY6OzwNO
	 MLQ6beclrT24sfx3/g5AWUud70mwWPeCVl/oAbs6Te/l0tyYv3vDvqS54TsmKkxbGP
	 maVyvhYsIhLc6GvbBQDydXWRnSTV1Xc0i2T6HdQkG99PJflgujMVc49iSk3B6Nd1yW
	 /+VTwgEQmdEuW6kNvLb8vUwnVo531VanAiMR+7jQzSWUkPw8+pSl/H6JMcjVM0dVfZ
	 HBgGvUBpwyZtA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: skcipher - remove support for physical address walks
Date: Sat,  7 Dec 2024 11:05:03 -0800
Message-ID: <20241207190503.53440-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241207190503.53440-1-ebiggers@kernel.org>
References: <20241207190503.53440-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since the physical address support in skcipher_walk is not used anymore,
remove all the code associated with it.  This includes:

- The skcipher_walk_async() and skcipher_walk_complete() functions;

- The SKCIPHER_WALK_PHYS flag and everything conditional on it;

- The buffers, phys, and virt.page fields in struct skcipher_walk;

- struct skcipher_walk_buffer.

As a result, skcipher_walk now just supports virtual addresses.
Physical address support in skcipher_walk is unneeded because drivers
that need physical addresses just use the scatterlists directly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c                  | 187 ++++-------------------------
 include/crypto/internal/skcipher.h |  12 --
 2 files changed, 26 insertions(+), 173 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index f74e4d0d87a22..d5fe0eca38260 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -15,11 +15,10 @@
 #include <crypto/scatterwalk.h>
 #include <linux/bug.h>
 #include <linux/cryptouser.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
-#include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -27,23 +26,14 @@
 #include "skcipher.h"
 
 #define CRYPTO_ALG_TYPE_SKCIPHER_MASK	0x0000000e
 
 enum {
-	SKCIPHER_WALK_PHYS = 1 << 0,
-	SKCIPHER_WALK_SLOW = 1 << 1,
-	SKCIPHER_WALK_COPY = 1 << 2,
-	SKCIPHER_WALK_DIFF = 1 << 3,
-	SKCIPHER_WALK_SLEEP = 1 << 4,
-};
-
-struct skcipher_walk_buffer {
-	struct list_head entry;
-	struct scatter_walk dst;
-	unsigned int len;
-	u8 *data;
-	u8 buffer[];
+	SKCIPHER_WALK_SLOW = 1 << 0,
+	SKCIPHER_WALK_COPY = 1 << 1,
+	SKCIPHER_WALK_DIFF = 1 << 2,
+	SKCIPHER_WALK_SLEEP = 1 << 3,
 };
 
 static const struct crypto_type crypto_skcipher_type;
 
 static int skcipher_walk_next(struct skcipher_walk *walk);
@@ -93,12 +83,11 @@ static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
 {
 	u8 *addr;
 
 	addr = (u8 *)ALIGN((unsigned long)walk->buffer, walk->alignmask + 1);
 	addr = skcipher_get_spot(addr, bsize);
-	scatterwalk_copychunks(addr, &walk->out, bsize,
-			       (walk->flags & SKCIPHER_WALK_PHYS) ? 2 : 1);
+	scatterwalk_copychunks(addr, &walk->out, bsize, 1);
 	return 0;
 }
 
 int skcipher_walk_done(struct skcipher_walk *walk, int err)
 {
@@ -111,12 +100,11 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
 	if (likely(err >= 0)) {
 		n -= err;
 		nbytes = walk->total - n;
 	}
 
-	if (likely(!(walk->flags & (SKCIPHER_WALK_PHYS |
-				    SKCIPHER_WALK_SLOW |
+	if (likely(!(walk->flags & (SKCIPHER_WALK_SLOW |
 				    SKCIPHER_WALK_COPY |
 				    SKCIPHER_WALK_DIFF)))) {
 unmap_src:
 		skcipher_unmap_src(walk);
 	} else if (walk->flags & SKCIPHER_WALK_DIFF) {
@@ -160,13 +148,10 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
 finish:
 	/* Short-circuit for the common/fast path. */
 	if (!((unsigned long)walk->buffer | (unsigned long)walk->page))
 		goto out;
 
-	if (walk->flags & SKCIPHER_WALK_PHYS)
-		goto out;
-
 	if (walk->iv != walk->oiv)
 		memcpy(walk->oiv, walk->iv, walk->ivsize);
 	if (walk->buffer != walk->page)
 		kfree(walk->buffer);
 	if (walk->page)
@@ -175,101 +160,37 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
 out:
 	return err;
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_done);
 
-void skcipher_walk_complete(struct skcipher_walk *walk, int err)
-{
-	struct skcipher_walk_buffer *p, *tmp;
-
-	list_for_each_entry_safe(p, tmp, &walk->buffers, entry) {
-		u8 *data;
-
-		if (err)
-			goto done;
-
-		data = p->data;
-		if (!data) {
-			data = PTR_ALIGN(&p->buffer[0], walk->alignmask + 1);
-			data = skcipher_get_spot(data, walk->stride);
-		}
-
-		scatterwalk_copychunks(data, &p->dst, p->len, 1);
-
-		if (offset_in_page(p->data) + p->len + walk->stride >
-		    PAGE_SIZE)
-			free_page((unsigned long)p->data);
-
-done:
-		list_del(&p->entry);
-		kfree(p);
-	}
-
-	if (!err && walk->iv != walk->oiv)
-		memcpy(walk->oiv, walk->iv, walk->ivsize);
-	if (walk->buffer != walk->page)
-		kfree(walk->buffer);
-	if (walk->page)
-		free_page((unsigned long)walk->page);
-}
-EXPORT_SYMBOL_GPL(skcipher_walk_complete);
-
-static void skcipher_queue_write(struct skcipher_walk *walk,
-				 struct skcipher_walk_buffer *p)
-{
-	p->dst = walk->out;
-	list_add_tail(&p->entry, &walk->buffers);
-}
-
 static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
 {
-	bool phys = walk->flags & SKCIPHER_WALK_PHYS;
 	unsigned alignmask = walk->alignmask;
-	struct skcipher_walk_buffer *p;
 	unsigned a;
 	unsigned n;
 	u8 *buffer;
-	void *v;
-
-	if (!phys) {
-		if (!walk->buffer)
-			walk->buffer = walk->page;
-		buffer = walk->buffer;
-		if (buffer)
-			goto ok;
-	}
+
+	if (!walk->buffer)
+		walk->buffer = walk->page;
+	buffer = walk->buffer;
+	if (buffer)
+		goto ok;
 
 	/* Start with the minimum alignment of kmalloc. */
 	a = crypto_tfm_ctx_alignment() - 1;
 	n = bsize;
 
-	if (phys) {
-		/* Calculate the minimum alignment of p->buffer. */
-		a &= (sizeof(*p) ^ (sizeof(*p) - 1)) >> 1;
-		n += sizeof(*p);
-	}
-
-	/* Minimum size to align p->buffer by alignmask. */
+	/* Minimum size to align buffer by alignmask. */
 	n += alignmask & ~a;
 
-	/* Minimum size to ensure p->buffer does not straddle a page. */
+	/* Minimum size to ensure buffer does not straddle a page. */
 	n += (bsize - 1) & ~(alignmask | a);
 
-	v = kzalloc(n, skcipher_walk_gfp(walk));
-	if (!v)
+	buffer = kzalloc(n, skcipher_walk_gfp(walk));
+	if (!buffer)
 		return skcipher_walk_done(walk, -ENOMEM);
-
-	if (phys) {
-		p = v;
-		p->len = bsize;
-		skcipher_queue_write(walk, p);
-		buffer = p->buffer;
-	} else {
-		walk->buffer = v;
-		buffer = v;
-	}
-
+	walk->buffer = buffer;
 ok:
 	walk->dst.virt.addr = PTR_ALIGN(buffer, alignmask + 1);
 	walk->dst.virt.addr = skcipher_get_spot(walk->dst.virt.addr, bsize);
 	walk->src.virt.addr = walk->dst.virt.addr;
 
@@ -281,54 +202,29 @@ static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
 	return 0;
 }
 
 static int skcipher_next_copy(struct skcipher_walk *walk)
 {
-	struct skcipher_walk_buffer *p;
 	u8 *tmp = walk->page;
 
 	skcipher_map_src(walk);
 	memcpy(tmp, walk->src.virt.addr, walk->nbytes);
 	skcipher_unmap_src(walk);
 
 	walk->src.virt.addr = tmp;
 	walk->dst.virt.addr = tmp;
-
-	if (!(walk->flags & SKCIPHER_WALK_PHYS))
-		return 0;
-
-	p = kmalloc(sizeof(*p), skcipher_walk_gfp(walk));
-	if (!p)
-		return -ENOMEM;
-
-	p->data = walk->page;
-	p->len = walk->nbytes;
-	skcipher_queue_write(walk, p);
-
-	if (offset_in_page(walk->page) + walk->nbytes + walk->stride >
-	    PAGE_SIZE)
-		walk->page = NULL;
-	else
-		walk->page += walk->nbytes;
-
 	return 0;
 }
 
 static int skcipher_next_fast(struct skcipher_walk *walk)
 {
 	unsigned long diff;
 
-	walk->src.phys.page = scatterwalk_page(&walk->in);
-	walk->src.phys.offset = offset_in_page(walk->in.offset);
-	walk->dst.phys.page = scatterwalk_page(&walk->out);
-	walk->dst.phys.offset = offset_in_page(walk->out.offset);
-
-	if (walk->flags & SKCIPHER_WALK_PHYS)
-		return 0;
-
-	diff = walk->src.phys.offset - walk->dst.phys.offset;
-	diff |= walk->src.virt.page - walk->dst.virt.page;
+	diff = offset_in_page(walk->in.offset) -
+	       offset_in_page(walk->out.offset);
+	diff |= (u8 *)scatterwalk_page(&walk->in) -
+		(u8 *)scatterwalk_page(&walk->out);
 
 	skcipher_map_src(walk);
 	walk->dst.virt.addr = walk->src.virt.addr;
 
 	if (diff) {
@@ -341,11 +237,10 @@ static int skcipher_next_fast(struct skcipher_walk *walk)
 
 static int skcipher_walk_next(struct skcipher_walk *walk)
 {
 	unsigned int bsize;
 	unsigned int n;
-	int err;
 
 	walk->flags &= ~(SKCIPHER_WALK_SLOW | SKCIPHER_WALK_COPY |
 			 SKCIPHER_WALK_DIFF);
 
 	n = walk->total;
@@ -356,12 +251,11 @@ static int skcipher_walk_next(struct skcipher_walk *walk)
 	if (unlikely(n < bsize)) {
 		if (unlikely(walk->total < walk->blocksize))
 			return skcipher_walk_done(walk, -EINVAL);
 
 slow_path:
-		err = skcipher_next_slow(walk, bsize);
-		goto set_phys_lowmem;
+		return skcipher_next_slow(walk, bsize);
 	}
 
 	if (unlikely((walk->in.offset | walk->out.offset) & walk->alignmask)) {
 		if (!walk->page) {
 			gfp_t gfp = skcipher_walk_gfp(walk);
@@ -372,26 +266,16 @@ static int skcipher_walk_next(struct skcipher_walk *walk)
 		}
 
 		walk->nbytes = min_t(unsigned, n,
 				     PAGE_SIZE - offset_in_page(walk->page));
 		walk->flags |= SKCIPHER_WALK_COPY;
-		err = skcipher_next_copy(walk);
-		goto set_phys_lowmem;
+		return skcipher_next_copy(walk);
 	}
 
 	walk->nbytes = n;
 
 	return skcipher_next_fast(walk);
-
-set_phys_lowmem:
-	if (!err && (walk->flags & SKCIPHER_WALK_PHYS)) {
-		walk->src.phys.page = virt_to_page(walk->src.virt.addr);
-		walk->dst.phys.page = virt_to_page(walk->dst.virt.addr);
-		walk->src.phys.offset &= PAGE_SIZE - 1;
-		walk->dst.phys.offset &= PAGE_SIZE - 1;
-	}
-	return err;
 }
 
 static int skcipher_copy_iv(struct skcipher_walk *walk)
 {
 	unsigned a = crypto_tfm_ctx_alignment() - 1;
@@ -405,18 +289,14 @@ static int skcipher_copy_iv(struct skcipher_walk *walk)
 	aligned_bs = ALIGN(bs, alignmask + 1);
 
 	/* Minimum size to align buffer by alignmask. */
 	size = alignmask & ~a;
 
-	if (walk->flags & SKCIPHER_WALK_PHYS)
-		size += ivsize;
-	else {
-		size += aligned_bs + ivsize;
+	size += aligned_bs + ivsize;
 
-		/* Minimum size to ensure buffer does not straddle a page. */
-		size += (bs - 1) & ~(alignmask | a);
-	}
+	/* Minimum size to ensure buffer does not straddle a page. */
+	size += (bs - 1) & ~(alignmask | a);
 
 	walk->buffer = kmalloc(size, skcipher_walk_gfp(walk));
 	if (!walk->buffer)
 		return -ENOMEM;
 
@@ -482,31 +362,18 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
 {
 	int err;
 
 	might_sleep_if(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 
-	walk->flags &= ~SKCIPHER_WALK_PHYS;
-
 	err = skcipher_walk_skcipher(walk, req);
 
 	walk->flags &= atomic ? ~SKCIPHER_WALK_SLEEP : ~0;
 
 	return err;
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_virt);
 
-int skcipher_walk_async(struct skcipher_walk *walk,
-			struct skcipher_request *req)
-{
-	walk->flags |= SKCIPHER_WALK_PHYS;
-
-	INIT_LIST_HEAD(&walk->buffers);
-
-	return skcipher_walk_skcipher(walk, req);
-}
-EXPORT_SYMBOL_GPL(skcipher_walk_async);
-
 static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 				     struct aead_request *req, bool atomic)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	int err;
@@ -516,12 +383,10 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 	walk->oiv = req->iv;
 
 	if (unlikely(!walk->total))
 		return 0;
 
-	walk->flags &= ~SKCIPHER_WALK_PHYS;
-
 	scatterwalk_start(&walk->in, req->src);
 	scatterwalk_start(&walk->out, req->dst);
 
 	scatterwalk_copychunks(NULL, &walk->in, req->assoclen, 2);
 	scatterwalk_copychunks(NULL, &walk->out, req->assoclen, 2);
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 7ae42afdcf3ed..08d1e8c63afc8 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -9,11 +9,10 @@
 #define _CRYPTO_INTERNAL_SKCIPHER_H
 
 #include <crypto/algapi.h>
 #include <crypto/internal/cipher.h>
 #include <crypto/skcipher.h>
-#include <linux/list.h>
 #include <linux/types.h>
 
 /*
  * Set this if your algorithm is sync but needs a reqsize larger
  * than MAX_SYNC_SKCIPHER_REQSIZE.
@@ -56,28 +55,20 @@ struct crypto_lskcipher_spawn {
 };
 
 struct skcipher_walk {
 	union {
 		struct {
-			struct page *page;
-			unsigned long offset;
-		} phys;
-
-		struct {
-			u8 *page;
 			void *addr;
 		} virt;
 	} src, dst;
 
 	struct scatter_walk in;
 	unsigned int nbytes;
 
 	struct scatter_walk out;
 	unsigned int total;
 
-	struct list_head buffers;
-
 	u8 *page;
 	u8 *buffer;
 	u8 *oiv;
 	void *iv;
 
@@ -207,17 +198,14 @@ int lskcipher_register_instance(struct crypto_template *tmpl,
 
 int skcipher_walk_done(struct skcipher_walk *walk, int err);
 int skcipher_walk_virt(struct skcipher_walk *walk,
 		       struct skcipher_request *req,
 		       bool atomic);
-int skcipher_walk_async(struct skcipher_walk *walk,
-			struct skcipher_request *req);
 int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
 			       struct aead_request *req, bool atomic);
 int skcipher_walk_aead_decrypt(struct skcipher_walk *walk,
 			       struct aead_request *req, bool atomic);
-void skcipher_walk_complete(struct skcipher_walk *walk, int err);
 
 static inline void skcipher_walk_abort(struct skcipher_walk *walk)
 {
 	skcipher_walk_done(walk, -ECANCELED);
 }
-- 
2.47.1

