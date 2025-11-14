Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D76830C374;
	Fri, 14 Nov 2025 22:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763161192; cv=none; b=rQ2vXLUP7tkp+7XQ+v2DS7iypDNDYncxrgWZ3kVeYvwHQVJc6dNtXdaqk4i15ZgLxwxKFugqf/E7RaM6jf4VGC5hRO1SxSYzRUfLUxIgj8LZRd+d3M1O4w4w1wpcA8nlyqOdOu3lYW31q/4Kslvvk2vZqhAdEVNBmPQhHwArgjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763161192; c=relaxed/simple;
	bh=wwAohr7wLaanSe9459HQ1cyfZrjLA9Nw1SJUIiBB7uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2wkYIU42fMUffMBG2/5I5NKPCd5haSFM17UAn59X5U8YrZ6B9HN0glbADwt7T5KPTLoJoBmOAlJtV7slMRHh/0ewT2VWAX7tdGCDE32DGe1IEBl24FfDCKileQZv/g9hk927bGbZpaj6Wk37ZsUVC1eeP/FmAo9e06E8UYzxoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OTb6ffHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OTb6ffHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10336C2BC87;
	Fri, 14 Nov 2025 22:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763161192;
	bh=wwAohr7wLaanSe9459HQ1cyfZrjLA9Nw1SJUIiBB7uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTb6ffHbkvpNNNvEHR3hSH1XAZ9P9ye6hvfplOCfgEJErG2FALUBshV+Lb4Q3mhb3
	 Yb2sk4SdHi41IcL4TFpomo2AiJ/428miyGZsf/QSoFdxeGWKppONOxN1nMfjgbmdL1
	 ymEWO2h99F4/NF+MVmyGGnolVl4nDg6Sj1gjHe/RmZ2QEZF3ykrPS80seHyvO1Aghq
	 a/vIy4wYr0daOLqNS0GIiD4DTSUFm7uZyuyEWo+1raGUJgkA7Gj+NAhX9OqJibmYsU
	 KgprYzYhIkIUGcRY4Tw9TTupYp6ig/7rbk4niprmJozWdf0zpreRQ2lRBulSi2Lo9a
	 /9qRkjmAWyQ+A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Colin Ian King <coking@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/2] Revert "crypto: scatterwalk - Move skcipher walk and use it for memcpy_sglist"
Date: Fri, 14 Nov 2025 14:58:51 -0800
Message-ID: <20251114225851.324143-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114225851.324143-1-ebiggers@kernel.org>
References: <20251114225851.324143-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 0f8d42bf128d349ad490e87d5574d211245e40f1, with the
memcpy_sglist() part dropped.

Now that memcpy_sglist() no longer uses the skcipher_walk code, the
skcipher_walk code can be moved back where it belongs.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/scatterwalk.c               | 248 ---------------------------
 crypto/skcipher.c                  | 261 ++++++++++++++++++++++++++++-
 include/crypto/algapi.h            |  12 ++
 include/crypto/internal/skcipher.h |  48 +++++-
 include/crypto/scatterwalk.h       |  65 +------
 5 files changed, 316 insertions(+), 318 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index af6c17bfcadb..bf120edfa3ac 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -8,29 +8,14 @@
  *               2002 Adam J. Richter <adam@yggdrasil.com>
  *               2004 Jean-Luc Cooke <jlcooke@certainkey.com>
  */
 
 #include <crypto/scatterwalk.h>
-#include <linux/crypto.h>
-#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
-#include <linux/slab.h>
-
-enum {
-	SKCIPHER_WALK_SLOW = 1 << 0,
-	SKCIPHER_WALK_COPY = 1 << 1,
-	SKCIPHER_WALK_DIFF = 1 << 2,
-	SKCIPHER_WALK_SLEEP = 1 << 3,
-};
-
-static inline gfp_t skcipher_walk_gfp(struct skcipher_walk *walk)
-{
-	return walk->flags & SKCIPHER_WALK_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
-}
 
 void scatterwalk_skip(struct scatter_walk *walk, unsigned int nbytes)
 {
 	struct scatterlist *sg = walk->sg;
 
@@ -221,238 +206,5 @@ struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 	scatterwalk_crypto_chain(dst, sg_next(src), 2);
 
 	return dst;
 }
 EXPORT_SYMBOL_GPL(scatterwalk_ffwd);
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
-int skcipher_walk_first(struct skcipher_walk *walk, bool atomic)
-{
-	if (WARN_ON_ONCE(in_hardirq()))
-		return -EDEADLK;
-
-	walk->flags = atomic ? 0 : SKCIPHER_WALK_SLEEP;
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
-EXPORT_SYMBOL_GPL(skcipher_walk_first);
-
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
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 8fa5d9686d08..14a820cb06c7 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -15,28 +15,273 @@
 #include <crypto/scatterwalk.h>
 #include <linux/bug.h>
 #include <linux/cryptouser.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/string_choices.h>
 #include <net/netlink.h>
 #include "skcipher.h"
 
 #define CRYPTO_ALG_TYPE_SKCIPHER_MASK	0x0000000e
 
+enum {
+	SKCIPHER_WALK_SLOW = 1 << 0,
+	SKCIPHER_WALK_COPY = 1 << 1,
+	SKCIPHER_WALK_DIFF = 1 << 2,
+	SKCIPHER_WALK_SLEEP = 1 << 3,
+};
+
 static const struct crypto_type crypto_skcipher_type;
 
+static int skcipher_walk_next(struct skcipher_walk *walk);
+
+static inline gfp_t skcipher_walk_gfp(struct skcipher_walk *walk)
+{
+	return walk->flags & SKCIPHER_WALK_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
+}
+
 static inline struct skcipher_alg *__crypto_skcipher_alg(
 	struct crypto_alg *alg)
 {
 	return container_of(alg, struct skcipher_alg, base);
 }
 
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
+static int skcipher_walk_first(struct skcipher_walk *walk)
+{
+	if (WARN_ON_ONCE(in_hardirq()))
+		return -EDEADLK;
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
+
 int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
 		       struct skcipher_request *__restrict req, bool atomic)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_alg *alg;
@@ -47,12 +292,14 @@ int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
 
 	walk->total = req->cryptlen;
 	walk->nbytes = 0;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
-	if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP))
-		atomic = true;
+	if ((req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) && !atomic)
+		walk->flags = SKCIPHER_WALK_SLEEP;
+	else
+		walk->flags = 0;
 
 	if (unlikely(!walk->total))
 		return 0;
 
 	scatterwalk_start(&walk->in, req->src);
@@ -65,11 +312,11 @@ int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		walk->stride = alg->co.chunksize;
 	else
 		walk->stride = alg->walksize;
 
-	return skcipher_walk_first(walk, atomic);
+	return skcipher_walk_first(walk);
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_virt);
 
 static int skcipher_walk_aead_common(struct skcipher_walk *__restrict walk,
 				     struct aead_request *__restrict req,
@@ -78,12 +325,14 @@ static int skcipher_walk_aead_common(struct skcipher_walk *__restrict walk,
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 
 	walk->nbytes = 0;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
-	if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP))
-		atomic = true;
+	if ((req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) && !atomic)
+		walk->flags = SKCIPHER_WALK_SLEEP;
+	else
+		walk->flags = 0;
 
 	if (unlikely(!walk->total))
 		return 0;
 
 	scatterwalk_start_at_pos(&walk->in, req->src, req->assoclen);
@@ -92,11 +341,11 @@ static int skcipher_walk_aead_common(struct skcipher_walk *__restrict walk,
 	walk->blocksize = crypto_aead_blocksize(tfm);
 	walk->stride = crypto_aead_chunksize(tfm);
 	walk->ivsize = crypto_aead_ivsize(tfm);
 	walk->alignmask = crypto_aead_alignmask(tfm);
 
-	return skcipher_walk_first(walk, atomic);
+	return skcipher_walk_first(walk);
 }
 
 int skcipher_walk_aead_encrypt(struct skcipher_walk *__restrict walk,
 			       struct aead_request *__restrict req,
 			       bool atomic)
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index fc4574940636..05deea9dac5e 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -105,10 +105,22 @@ struct crypto_queue {
 
 	unsigned int qlen;
 	unsigned int max_qlen;
 };
 
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
 struct crypto_attr_alg {
 	char name[CRYPTO_MAX_ALG_NAME];
 };
 
 struct crypto_attr_type {
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index d5aa535263f6..0cad8e7364c8 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -8,11 +8,10 @@
 #ifndef _CRYPTO_INTERNAL_SKCIPHER_H
 #define _CRYPTO_INTERNAL_SKCIPHER_H
 
 #include <crypto/algapi.h>
 #include <crypto/internal/cipher.h>
-#include <crypto/scatterwalk.h>
 #include <crypto/skcipher.h>
 #include <linux/types.h>
 
 /*
  * Set this if your algorithm is sync but needs a reqsize larger
@@ -53,10 +52,51 @@ struct crypto_skcipher_spawn {
 
 struct crypto_lskcipher_spawn {
 	struct crypto_spawn base;
 };
 
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
+
 static inline struct crypto_instance *skcipher_crypto_instance(
 	struct skcipher_instance *inst)
 {
 	return &inst->s.base;
 }
@@ -169,20 +209,26 @@ void crypto_unregister_lskcipher(struct lskcipher_alg *alg);
 int crypto_register_lskciphers(struct lskcipher_alg *algs, int count);
 void crypto_unregister_lskciphers(struct lskcipher_alg *algs, int count);
 int lskcipher_register_instance(struct crypto_template *tmpl,
 				struct lskcipher_instance *inst);
 
+int skcipher_walk_done(struct skcipher_walk *walk, int res);
 int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
 		       struct skcipher_request *__restrict req,
 		       bool atomic);
 int skcipher_walk_aead_encrypt(struct skcipher_walk *__restrict walk,
 			       struct aead_request *__restrict req,
 			       bool atomic);
 int skcipher_walk_aead_decrypt(struct skcipher_walk *__restrict walk,
 			       struct aead_request *__restrict req,
 			       bool atomic);
 
+static inline void skcipher_walk_abort(struct skcipher_walk *walk)
+{
+	skcipher_walk_done(walk, -ECANCELED);
+}
+
 static inline void *crypto_skcipher_ctx(struct crypto_skcipher *tfm)
 {
 	return crypto_tfm_ctx(&tfm->base);
 }
 
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index f485454e3955..624fab589c2c 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -9,68 +9,15 @@
  */
 
 #ifndef _CRYPTO_SCATTERWALK_H
 #define _CRYPTO_SCATTERWALK_H
 
-#include <linux/errno.h>
+#include <crypto/algapi.h>
+
 #include <linux/highmem.h>
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
-#include <linux/types.h>
-
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
 
 static inline void scatterwalk_crypto_chain(struct scatterlist *head,
 					    struct scatterlist *sg, int num)
 {
 	if (sg)
@@ -304,14 +251,6 @@ static inline void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 
 struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 				     struct scatterlist *src,
 				     unsigned int len);
 
-int skcipher_walk_first(struct skcipher_walk *walk, bool atomic);
-int skcipher_walk_done(struct skcipher_walk *walk, int res);
-
-static inline void skcipher_walk_abort(struct skcipher_walk *walk)
-{
-	skcipher_walk_done(walk, -ECANCELED);
-}
-
 #endif  /* _CRYPTO_SCATTERWALK_H */
-- 
2.51.2

