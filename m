Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B461DFF0
	for <linux-crypto@vger.kernel.org>; Sun, 27 Apr 2025 00:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745714581; cv=none; b=VRuNYAjQFvO/ecUYwH8WX9uiV2cjOB5p77eIp8wCN0Iuv9pJUG6SYaWtRMblV6yTSyQRgaUwq4o6onskqHfD0GMrCQNVuzCpMdrYoFXGr2DiAVUeBK/g77ZOvfMMYDi74G7rxd+OidB0Fop6Pd7glk8kSnjtiRuH7q5CIarp2w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745714581; c=relaxed/simple;
	bh=nANxxtjbTasUYqfMReLgRSx6bgmFWJf4hgqCqC/oiPo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=jZTIMSe07ZK+angvu7MnPBRqS98doxfVpbBmzFpZfsIKYWmwLw1rkv7X3oPDJszYfQSKtmaOnE59o4+U3lgQCGiqMZWe7uG3Q8b59+x28uH/em6FP4xikXc8x0Q1LnTZfB+3REdYkZhJs7TvTUNwh79dQjQVu4FlsNNM79UPVLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TyN5sNKZ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TyN5sNKZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8sya0Am5bKVydYVOjDe4leDb/b7LcWLahJGiL9euqWw=; b=TyN5sNKZJhkhyZXFxL8QPGLrgE
	0rnAUBzgOBQO85KoFEiDsPP2aDZlY4Vk38n0lO9ofx2EUXaWLU3Ei/glg5EMosogHZPehflQQIP0j
	nq2ab2ppaWc5zwv5igmGz5oIP3YzVyTvoLyt2r7kMmg1luJVy2ZK+uctYyZiXXD1JYKuQ0oodSeiH
	B6bgxSvCJ+noKSEXQoV4Dgzwf12bDtkIY9yDddr4trp6o4BJ389mXjUk+aKDRPrxBNY7Mj5KB9DDQ
	lYM5vaHPVunveZM6Dfq/wPRBuLhi7ZmoFTvPMSds34dRZLSqrop5YTgVKT2oTIs4efZjv2HJZilwh
	GvwKwpbg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8q6g-001J9e-0r;
	Sun, 27 Apr 2025 08:42:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Apr 2025 08:42:54 +0800
Date: Sun, 27 Apr 2025 08:42:54 +0800
Message-Id: <8a564443ba01b29418291a4e3045e2546cd9e3a8.1745714222.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745714222.git.herbert@gondor.apana.org.au>
References: <cover.1745714222.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: scatterwalk - Move skcipher walk and use it for
 memcpy_sglist
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Move the generic part of skcipher walk into scatterwalk, and use
it to implement memcpy_sglist.

This makes memcpy_sglist do the right thing when two distinct SG
lists contain identical subsets (e.g., the AD part of AEAD).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scatterwalk.c               | 274 +++++++++++++++++++++++++++--
 crypto/skcipher.c                  | 261 +--------------------------
 include/crypto/algapi.h            |  12 --
 include/crypto/internal/skcipher.h |  48 +----
 include/crypto/scatterwalk.h       |  65 ++++++-
 5 files changed, 329 insertions(+), 331 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 8225801488d5..1d010e2a1b1a 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -10,10 +10,25 @@
  */
 
 #include <crypto/scatterwalk.h>
+#include <linux/crypto.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
+
+enum {
+	SKCIPHER_WALK_SLOW = 1 << 0,
+	SKCIPHER_WALK_COPY = 1 << 1,
+	SKCIPHER_WALK_DIFF = 1 << 2,
+	SKCIPHER_WALK_SLEEP = 1 << 3,
+};
+
+static inline gfp_t skcipher_walk_gfp(struct skcipher_walk *walk)
+{
+	return walk->flags & SKCIPHER_WALK_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
+}
 
 void scatterwalk_skip(struct scatter_walk *walk, unsigned int nbytes)
 {
@@ -89,27 +104,23 @@ EXPORT_SYMBOL_GPL(memcpy_to_sglist);
 void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
 		   unsigned int nbytes)
 {
-	struct scatter_walk swalk;
-	struct scatter_walk dwalk;
+	struct skcipher_walk walk = {};
 
 	if (unlikely(nbytes == 0)) /* in case sg == NULL */
 		return;
 
-	scatterwalk_start(&swalk, src);
-	scatterwalk_start(&dwalk, dst);
+	walk.total = nbytes;
 
+	scatterwalk_start(&walk.in, src);
+	scatterwalk_start(&walk.out, dst);
+
+	skcipher_walk_first(&walk, true);
 	do {
-		unsigned int slen, dlen;
-		unsigned int len;
-
-		slen = scatterwalk_next(&swalk, nbytes);
-		dlen = scatterwalk_next(&dwalk, nbytes);
-		len = min(slen, dlen);
-		memcpy(dwalk.addr, swalk.addr, len);
-		scatterwalk_done_dst(&dwalk, len);
-		scatterwalk_done_src(&swalk, len);
-		nbytes -= len;
-	} while (nbytes);
+		if (walk.src.virt.addr != walk.dst.virt.addr)
+			memcpy(walk.dst.virt.addr, walk.src.virt.addr,
+			       walk.nbytes);
+		skcipher_walk_done(&walk, 0);
+	} while (walk.nbytes);
 }
 EXPORT_SYMBOL_GPL(memcpy_sglist);
 
@@ -135,3 +146,236 @@ struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 	return dst;
 }
 EXPORT_SYMBOL_GPL(scatterwalk_ffwd);
+
+static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
+{
+	unsigned alignmask = walk->alignmask;
+	unsigned n;
+	void *buffer;
+
+	if (!walk->buffer)
+		walk->buffer = walk->page;
+	buffer = walk->buffer;
+	if (!buffer) {
+		/* Min size for a buffer of bsize bytes aligned to alignmask */
+		n = bsize + (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
+
+		buffer = kzalloc(n, skcipher_walk_gfp(walk));
+		if (!buffer)
+			return skcipher_walk_done(walk, -ENOMEM);
+		walk->buffer = buffer;
+	}
+
+	buffer = PTR_ALIGN(buffer, alignmask + 1);
+	memcpy_from_scatterwalk(buffer, &walk->in, bsize);
+	walk->out.__addr = buffer;
+	walk->in.__addr = walk->out.addr;
+
+	walk->nbytes = bsize;
+	walk->flags |= SKCIPHER_WALK_SLOW;
+
+	return 0;
+}
+
+static int skcipher_next_copy(struct skcipher_walk *walk)
+{
+	void *tmp = walk->page;
+
+	scatterwalk_map(&walk->in);
+	memcpy(tmp, walk->in.addr, walk->nbytes);
+	scatterwalk_unmap(&walk->in);
+	/*
+	 * walk->in is advanced later when the number of bytes actually
+	 * processed (which might be less than walk->nbytes) is known.
+	 */
+
+	walk->in.__addr = tmp;
+	walk->out.__addr = tmp;
+	return 0;
+}
+
+static int skcipher_next_fast(struct skcipher_walk *walk)
+{
+	unsigned long diff;
+
+	diff = offset_in_page(walk->in.offset) -
+	       offset_in_page(walk->out.offset);
+	diff |= (u8 *)(sg_page(walk->in.sg) + (walk->in.offset >> PAGE_SHIFT)) -
+		(u8 *)(sg_page(walk->out.sg) + (walk->out.offset >> PAGE_SHIFT));
+
+	scatterwalk_map(&walk->out);
+	walk->in.__addr = walk->out.__addr;
+
+	if (diff) {
+		walk->flags |= SKCIPHER_WALK_DIFF;
+		scatterwalk_map(&walk->in);
+	}
+
+	return 0;
+}
+
+static int skcipher_walk_next(struct skcipher_walk *walk)
+{
+	unsigned int bsize;
+	unsigned int n;
+
+	n = walk->total;
+	bsize = min(walk->stride, max(n, walk->blocksize));
+	n = scatterwalk_clamp(&walk->in, n);
+	n = scatterwalk_clamp(&walk->out, n);
+
+	if (unlikely(n < bsize)) {
+		if (unlikely(walk->total < walk->blocksize))
+			return skcipher_walk_done(walk, -EINVAL);
+
+slow_path:
+		return skcipher_next_slow(walk, bsize);
+	}
+	walk->nbytes = n;
+
+	if (unlikely((walk->in.offset | walk->out.offset) & walk->alignmask)) {
+		if (!walk->page) {
+			gfp_t gfp = skcipher_walk_gfp(walk);
+
+			walk->page = (void *)__get_free_page(gfp);
+			if (!walk->page)
+				goto slow_path;
+		}
+		walk->flags |= SKCIPHER_WALK_COPY;
+		return skcipher_next_copy(walk);
+	}
+
+	return skcipher_next_fast(walk);
+}
+
+static int skcipher_copy_iv(struct skcipher_walk *walk)
+{
+	unsigned alignmask = walk->alignmask;
+	unsigned ivsize = walk->ivsize;
+	unsigned aligned_stride = ALIGN(walk->stride, alignmask + 1);
+	unsigned size;
+	u8 *iv;
+
+	/* Min size for a buffer of stride + ivsize, aligned to alignmask */
+	size = aligned_stride + ivsize +
+	       (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
+
+	walk->buffer = kmalloc(size, skcipher_walk_gfp(walk));
+	if (!walk->buffer)
+		return -ENOMEM;
+
+	iv = PTR_ALIGN(walk->buffer, alignmask + 1) + aligned_stride;
+
+	walk->iv = memcpy(iv, walk->iv, walk->ivsize);
+	return 0;
+}
+
+int skcipher_walk_first(struct skcipher_walk *walk, bool atomic)
+{
+	if (WARN_ON_ONCE(in_hardirq()))
+		return -EDEADLK;
+
+	walk->flags = atomic ? 0 : SKCIPHER_WALK_SLEEP;
+
+	walk->buffer = NULL;
+	if (unlikely(((unsigned long)walk->iv & walk->alignmask))) {
+		int err = skcipher_copy_iv(walk);
+		if (err)
+			return err;
+	}
+
+	walk->page = NULL;
+
+	return skcipher_walk_next(walk);
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_first);
+
+/**
+ * skcipher_walk_done() - finish one step of a skcipher_walk
+ * @walk: the skcipher_walk
+ * @res: number of bytes *not* processed (>= 0) from walk->nbytes,
+ *	 or a -errno value to terminate the walk due to an error
+ *
+ * This function cleans up after one step of walking through the source and
+ * destination scatterlists, and advances to the next step if applicable.
+ * walk->nbytes is set to the number of bytes available in the next step,
+ * walk->total is set to the new total number of bytes remaining, and
+ * walk->{src,dst}.virt.addr is set to the next pair of data pointers.  If there
+ * is no more data, or if an error occurred (i.e. -errno return), then
+ * walk->nbytes and walk->total are set to 0 and all resources owned by the
+ * skcipher_walk are freed.
+ *
+ * Return: 0 or a -errno value.  If @res was a -errno value then it will be
+ *	   returned, but other errors may occur too.
+ */
+int skcipher_walk_done(struct skcipher_walk *walk, int res)
+{
+	unsigned int n = walk->nbytes; /* num bytes processed this step */
+	unsigned int total = 0; /* new total remaining */
+
+	if (!n)
+		goto finish;
+
+	if (likely(res >= 0)) {
+		n -= res; /* subtract num bytes *not* processed */
+		total = walk->total - n;
+	}
+
+	if (likely(!(walk->flags & (SKCIPHER_WALK_SLOW |
+				    SKCIPHER_WALK_COPY |
+				    SKCIPHER_WALK_DIFF)))) {
+		scatterwalk_advance(&walk->in, n);
+	} else if (walk->flags & SKCIPHER_WALK_DIFF) {
+		scatterwalk_done_src(&walk->in, n);
+	} else if (walk->flags & SKCIPHER_WALK_COPY) {
+		scatterwalk_advance(&walk->in, n);
+		scatterwalk_map(&walk->out);
+		memcpy(walk->out.addr, walk->page, n);
+	} else { /* SKCIPHER_WALK_SLOW */
+		if (res > 0) {
+			/*
+			 * Didn't process all bytes.  Either the algorithm is
+			 * broken, or this was the last step and it turned out
+			 * the message wasn't evenly divisible into blocks but
+			 * the algorithm requires it.
+			 */
+			res = -EINVAL;
+			total = 0;
+		} else
+			memcpy_to_scatterwalk(&walk->out, walk->out.addr, n);
+		goto dst_done;
+	}
+
+	scatterwalk_done_dst(&walk->out, n);
+dst_done:
+
+	if (res > 0)
+		res = 0;
+
+	walk->total = total;
+	walk->nbytes = 0;
+
+	if (total) {
+		if (walk->flags & SKCIPHER_WALK_SLEEP)
+			cond_resched();
+		walk->flags &= ~(SKCIPHER_WALK_SLOW | SKCIPHER_WALK_COPY |
+				 SKCIPHER_WALK_DIFF);
+		return skcipher_walk_next(walk);
+	}
+
+finish:
+	/* Short-circuit for the common/fast path. */
+	if (!((unsigned long)walk->buffer | (unsigned long)walk->page))
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
+	return res;
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_done);
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 319215cfded5..de5fc91bba26 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -17,7 +17,6 @@
 #include <linux/cryptouser.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -28,258 +27,14 @@
 
 #define CRYPTO_ALG_TYPE_SKCIPHER_MASK	0x0000000e
 
-enum {
-	SKCIPHER_WALK_SLOW = 1 << 0,
-	SKCIPHER_WALK_COPY = 1 << 1,
-	SKCIPHER_WALK_DIFF = 1 << 2,
-	SKCIPHER_WALK_SLEEP = 1 << 3,
-};
-
 static const struct crypto_type crypto_skcipher_type;
 
-static int skcipher_walk_next(struct skcipher_walk *walk);
-
-static inline gfp_t skcipher_walk_gfp(struct skcipher_walk *walk)
-{
-	return walk->flags & SKCIPHER_WALK_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
-}
-
 static inline struct skcipher_alg *__crypto_skcipher_alg(
 	struct crypto_alg *alg)
 {
 	return container_of(alg, struct skcipher_alg, base);
 }
 
-/**
- * skcipher_walk_done() - finish one step of a skcipher_walk
- * @walk: the skcipher_walk
- * @res: number of bytes *not* processed (>= 0) from walk->nbytes,
- *	 or a -errno value to terminate the walk due to an error
- *
- * This function cleans up after one step of walking through the source and
- * destination scatterlists, and advances to the next step if applicable.
- * walk->nbytes is set to the number of bytes available in the next step,
- * walk->total is set to the new total number of bytes remaining, and
- * walk->{src,dst}.virt.addr is set to the next pair of data pointers.  If there
- * is no more data, or if an error occurred (i.e. -errno return), then
- * walk->nbytes and walk->total are set to 0 and all resources owned by the
- * skcipher_walk are freed.
- *
- * Return: 0 or a -errno value.  If @res was a -errno value then it will be
- *	   returned, but other errors may occur too.
- */
-int skcipher_walk_done(struct skcipher_walk *walk, int res)
-{
-	unsigned int n = walk->nbytes; /* num bytes processed this step */
-	unsigned int total = 0; /* new total remaining */
-
-	if (!n)
-		goto finish;
-
-	if (likely(res >= 0)) {
-		n -= res; /* subtract num bytes *not* processed */
-		total = walk->total - n;
-	}
-
-	if (likely(!(walk->flags & (SKCIPHER_WALK_SLOW |
-				    SKCIPHER_WALK_COPY |
-				    SKCIPHER_WALK_DIFF)))) {
-		scatterwalk_advance(&walk->in, n);
-	} else if (walk->flags & SKCIPHER_WALK_DIFF) {
-		scatterwalk_done_src(&walk->in, n);
-	} else if (walk->flags & SKCIPHER_WALK_COPY) {
-		scatterwalk_advance(&walk->in, n);
-		scatterwalk_map(&walk->out);
-		memcpy(walk->out.addr, walk->page, n);
-	} else { /* SKCIPHER_WALK_SLOW */
-		if (res > 0) {
-			/*
-			 * Didn't process all bytes.  Either the algorithm is
-			 * broken, or this was the last step and it turned out
-			 * the message wasn't evenly divisible into blocks but
-			 * the algorithm requires it.
-			 */
-			res = -EINVAL;
-			total = 0;
-		} else
-			memcpy_to_scatterwalk(&walk->out, walk->out.addr, n);
-		goto dst_done;
-	}
-
-	scatterwalk_done_dst(&walk->out, n);
-dst_done:
-
-	if (res > 0)
-		res = 0;
-
-	walk->total = total;
-	walk->nbytes = 0;
-
-	if (total) {
-		if (walk->flags & SKCIPHER_WALK_SLEEP)
-			cond_resched();
-		walk->flags &= ~(SKCIPHER_WALK_SLOW | SKCIPHER_WALK_COPY |
-				 SKCIPHER_WALK_DIFF);
-		return skcipher_walk_next(walk);
-	}
-
-finish:
-	/* Short-circuit for the common/fast path. */
-	if (!((unsigned long)walk->buffer | (unsigned long)walk->page))
-		goto out;
-
-	if (walk->iv != walk->oiv)
-		memcpy(walk->oiv, walk->iv, walk->ivsize);
-	if (walk->buffer != walk->page)
-		kfree(walk->buffer);
-	if (walk->page)
-		free_page((unsigned long)walk->page);
-
-out:
-	return res;
-}
-EXPORT_SYMBOL_GPL(skcipher_walk_done);
-
-static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
-{
-	unsigned alignmask = walk->alignmask;
-	unsigned n;
-	void *buffer;
-
-	if (!walk->buffer)
-		walk->buffer = walk->page;
-	buffer = walk->buffer;
-	if (!buffer) {
-		/* Min size for a buffer of bsize bytes aligned to alignmask */
-		n = bsize + (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
-
-		buffer = kzalloc(n, skcipher_walk_gfp(walk));
-		if (!buffer)
-			return skcipher_walk_done(walk, -ENOMEM);
-		walk->buffer = buffer;
-	}
-
-	buffer = PTR_ALIGN(buffer, alignmask + 1);
-	memcpy_from_scatterwalk(buffer, &walk->in, bsize);
-	walk->out.__addr = buffer;
-	walk->in.__addr = walk->out.addr;
-
-	walk->nbytes = bsize;
-	walk->flags |= SKCIPHER_WALK_SLOW;
-
-	return 0;
-}
-
-static int skcipher_next_copy(struct skcipher_walk *walk)
-{
-	void *tmp = walk->page;
-
-	scatterwalk_map(&walk->in);
-	memcpy(tmp, walk->in.addr, walk->nbytes);
-	scatterwalk_unmap(&walk->in);
-	/*
-	 * walk->in is advanced later when the number of bytes actually
-	 * processed (which might be less than walk->nbytes) is known.
-	 */
-
-	walk->in.__addr = tmp;
-	walk->out.__addr = tmp;
-	return 0;
-}
-
-static int skcipher_next_fast(struct skcipher_walk *walk)
-{
-	unsigned long diff;
-
-	diff = offset_in_page(walk->in.offset) -
-	       offset_in_page(walk->out.offset);
-	diff |= (u8 *)(sg_page(walk->in.sg) + (walk->in.offset >> PAGE_SHIFT)) -
-		(u8 *)(sg_page(walk->out.sg) + (walk->out.offset >> PAGE_SHIFT));
-
-	scatterwalk_map(&walk->out);
-	walk->in.__addr = walk->out.__addr;
-
-	if (diff) {
-		walk->flags |= SKCIPHER_WALK_DIFF;
-		scatterwalk_map(&walk->in);
-	}
-
-	return 0;
-}
-
-static int skcipher_walk_next(struct skcipher_walk *walk)
-{
-	unsigned int bsize;
-	unsigned int n;
-
-	n = walk->total;
-	bsize = min(walk->stride, max(n, walk->blocksize));
-	n = scatterwalk_clamp(&walk->in, n);
-	n = scatterwalk_clamp(&walk->out, n);
-
-	if (unlikely(n < bsize)) {
-		if (unlikely(walk->total < walk->blocksize))
-			return skcipher_walk_done(walk, -EINVAL);
-
-slow_path:
-		return skcipher_next_slow(walk, bsize);
-	}
-	walk->nbytes = n;
-
-	if (unlikely((walk->in.offset | walk->out.offset) & walk->alignmask)) {
-		if (!walk->page) {
-			gfp_t gfp = skcipher_walk_gfp(walk);
-
-			walk->page = (void *)__get_free_page(gfp);
-			if (!walk->page)
-				goto slow_path;
-		}
-		walk->flags |= SKCIPHER_WALK_COPY;
-		return skcipher_next_copy(walk);
-	}
-
-	return skcipher_next_fast(walk);
-}
-
-static int skcipher_copy_iv(struct skcipher_walk *walk)
-{
-	unsigned alignmask = walk->alignmask;
-	unsigned ivsize = walk->ivsize;
-	unsigned aligned_stride = ALIGN(walk->stride, alignmask + 1);
-	unsigned size;
-	u8 *iv;
-
-	/* Min size for a buffer of stride + ivsize, aligned to alignmask */
-	size = aligned_stride + ivsize +
-	       (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
-
-	walk->buffer = kmalloc(size, skcipher_walk_gfp(walk));
-	if (!walk->buffer)
-		return -ENOMEM;
-
-	iv = PTR_ALIGN(walk->buffer, alignmask + 1) + aligned_stride;
-
-	walk->iv = memcpy(iv, walk->iv, walk->ivsize);
-	return 0;
-}
-
-static int skcipher_walk_first(struct skcipher_walk *walk)
-{
-	if (WARN_ON_ONCE(in_hardirq()))
-		return -EDEADLK;
-
-	walk->buffer = NULL;
-	if (unlikely(((unsigned long)walk->iv & walk->alignmask))) {
-		int err = skcipher_copy_iv(walk);
-		if (err)
-			return err;
-	}
-
-	walk->page = NULL;
-
-	return skcipher_walk_next(walk);
-}
-
 int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
 		       struct skcipher_request *__restrict req, bool atomic)
 {
@@ -294,10 +49,8 @@ int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
 	walk->nbytes = 0;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
-	if ((req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) && !atomic)
-		walk->flags = SKCIPHER_WALK_SLEEP;
-	else
-		walk->flags = 0;
+	if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP))
+		atomic = true;
 
 	if (unlikely(!walk->total))
 		return 0;
@@ -314,7 +67,7 @@ int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
 	else
 		walk->stride = alg->walksize;
 
-	return skcipher_walk_first(walk);
+	return skcipher_walk_first(walk, atomic);
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_virt);
 
@@ -327,10 +80,8 @@ static int skcipher_walk_aead_common(struct skcipher_walk *__restrict walk,
 	walk->nbytes = 0;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
-	if ((req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) && !atomic)
-		walk->flags = SKCIPHER_WALK_SLEEP;
-	else
-		walk->flags = 0;
+	if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP))
+		atomic = true;
 
 	if (unlikely(!walk->total))
 		return 0;
@@ -343,7 +94,7 @@ static int skcipher_walk_aead_common(struct skcipher_walk *__restrict walk,
 	walk->ivsize = crypto_aead_ivsize(tfm);
 	walk->alignmask = crypto_aead_alignmask(tfm);
 
-	return skcipher_walk_first(walk);
+	return skcipher_walk_first(walk, atomic);
 }
 
 int skcipher_walk_aead_encrypt(struct skcipher_walk *__restrict walk,
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 6999e10ea09e..f5f730969d72 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -107,18 +107,6 @@ struct crypto_queue {
 	unsigned int max_qlen;
 };
 
-struct scatter_walk {
-	/* Must be the first member, see struct skcipher_walk. */
-	union {
-		void *const addr;
-
-		/* Private API field, do not touch. */
-		union crypto_no_such_thing *__addr;
-	};
-	struct scatterlist *sg;
-	unsigned int offset;
-};
-
 struct crypto_attr_alg {
 	char name[CRYPTO_MAX_ALG_NAME];
 };
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 0cad8e7364c8..d5aa535263f6 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -10,6 +10,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/internal/cipher.h>
+#include <crypto/scatterwalk.h>
 #include <crypto/skcipher.h>
 #include <linux/types.h>
 
@@ -54,47 +55,6 @@ struct crypto_lskcipher_spawn {
 	struct crypto_spawn base;
 };
 
-struct skcipher_walk {
-	union {
-		/* Virtual address of the source. */
-		struct {
-			struct {
-				const void *const addr;
-			} virt;
-		} src;
-
-		/* Private field for the API, do not use. */
-		struct scatter_walk in;
-	};
-
-	union {
-		/* Virtual address of the destination. */
-		struct {
-			struct {
-				void *const addr;
-			} virt;
-		} dst;
-
-		/* Private field for the API, do not use. */
-		struct scatter_walk out;
-	};
-
-	unsigned int nbytes;
-	unsigned int total;
-
-	u8 *page;
-	u8 *buffer;
-	u8 *oiv;
-	void *iv;
-
-	unsigned int ivsize;
-
-	int flags;
-	unsigned int blocksize;
-	unsigned int stride;
-	unsigned int alignmask;
-};
-
 static inline struct crypto_instance *skcipher_crypto_instance(
 	struct skcipher_instance *inst)
 {
@@ -211,7 +171,6 @@ void crypto_unregister_lskciphers(struct lskcipher_alg *algs, int count);
 int lskcipher_register_instance(struct crypto_template *tmpl,
 				struct lskcipher_instance *inst);
 
-int skcipher_walk_done(struct skcipher_walk *walk, int res);
 int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
 		       struct skcipher_request *__restrict req,
 		       bool atomic);
@@ -222,11 +181,6 @@ int skcipher_walk_aead_decrypt(struct skcipher_walk *__restrict walk,
 			       struct aead_request *__restrict req,
 			       bool atomic);
 
-static inline void skcipher_walk_abort(struct skcipher_walk *walk)
-{
-	skcipher_walk_done(walk, -ECANCELED);
-}
-
 static inline void *crypto_skcipher_ctx(struct crypto_skcipher *tfm)
 {
 	return crypto_tfm_ctx(&tfm->base);
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 94a8585f26b2..15ab743f68c8 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -11,11 +11,64 @@
 #ifndef _CRYPTO_SCATTERWALK_H
 #define _CRYPTO_SCATTERWALK_H
 
-#include <crypto/algapi.h>
-
+#include <linux/errno.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
+#include <linux/types.h>
+
+struct scatter_walk {
+	/* Must be the first member, see struct skcipher_walk. */
+	union {
+		void *const addr;
+
+		/* Private API field, do not touch. */
+		union crypto_no_such_thing *__addr;
+	};
+	struct scatterlist *sg;
+	unsigned int offset;
+};
+
+struct skcipher_walk {
+	union {
+		/* Virtual address of the source. */
+		struct {
+			struct {
+				const void *const addr;
+			} virt;
+		} src;
+
+		/* Private field for the API, do not use. */
+		struct scatter_walk in;
+	};
+
+	union {
+		/* Virtual address of the destination. */
+		struct {
+			struct {
+				void *const addr;
+			} virt;
+		} dst;
+
+		/* Private field for the API, do not use. */
+		struct scatter_walk out;
+	};
+
+	unsigned int nbytes;
+	unsigned int total;
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
+	unsigned int stride;
+	unsigned int alignmask;
+};
 
 static inline void scatterwalk_crypto_chain(struct scatterlist *head,
 					    struct scatterlist *sg, int num)
@@ -243,4 +296,12 @@ struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 				     struct scatterlist *src,
 				     unsigned int len);
 
+int skcipher_walk_first(struct skcipher_walk *walk, bool atomic);
+int skcipher_walk_done(struct skcipher_walk *walk, int res);
+
+static inline void skcipher_walk_abort(struct skcipher_walk *walk)
+{
+	skcipher_walk_done(walk, -ECANCELED);
+}
+
 #endif  /* _CRYPTO_SCATTERWALK_H */
-- 
2.39.5

