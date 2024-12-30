Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA86259481;
	Mon, 30 Dec 2024 00:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517760; cv=none; b=r4Uwxtc4AqKgA8PG681+/fL3bGpKI0Q8bxl/QVtcRlOdqAAR934yjYEXC0fe75u/WgAabIixz+KIoPunIno8J4rYmpF6rD+RGzDNX1Dunq91eksbceuEiKedT/q3+obZe5ygIVRDTgrJ1CwTZARTQCdKLz4YG+LPi+Zipsosjs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517760; c=relaxed/simple;
	bh=J5FzviwCD+n8p+5rLyvIFWAP97F/jKX49Nuk3AnfzpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqDufiVMlPtNtSz2B/9DMIAUET0RAvEywqMrYiqU0kr79KwMFWRdagk/ckj7LxxNupXA+urray4fiL2V7uij+kA7zQfqC28m5J0CtZHHTV559MkeYWNfSr9PNS8qB7QMnTl1DU+hnkUSFNGpcyP22jr9wRFiGI26kQfun/aLVPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n/HpaXI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/HpaXI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E2CC4CED4;
	Mon, 30 Dec 2024 00:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517759;
	bh=J5FzviwCD+n8p+5rLyvIFWAP97F/jKX49Nuk3AnfzpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/HpaXI5IGM2bT2b3rlNIJtS96jx+szt27vQd/3l1Vm3/4Nm85/XQsNY1RDbdtv8z
	 9M4alsvzIy89ecSly9DTTsgc+2crthiG1KsIEKJl3+/XZoOLw3FK8toGbXFvT2DSh8
	 /7uoqlCaw39PKwt50yEzep3KC3LomwCc8+61kwRL2aO+a0DURUTvu8gSXC2LWB/KjR
	 S+AIMSzVI9c/1kuTPXb3rzlMoIqRx17BwGfg3rwdi4pfD1gJBtAxBYOk4lrTce53um
	 98580FImzduySG8GJypA6eciUewgJPi5vuaKvaCx/7OPKulnzYSQKvCkXCBAYG7C/H
	 kdcVv6lMjrX8A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/29] crypto: skcipher - remove unnecessary page alignment of bounce buffer
Date: Sun, 29 Dec 2024 16:13:51 -0800
Message-ID: <20241230001418.74739-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230001418.74739-1-ebiggers@kernel.org>
References: <20241230001418.74739-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

In the slow path of skcipher_walk where it uses a slab bounce buffer for
the data and/or IV, do not bother to avoid crossing a page boundary in
the part(s) of this buffer that are used, and do not bother to allocate
extra space in the buffer for that purpose.  The buffer is accessed only
by virtual address, so pages are irrelevant for it.

This logic may have been present due to the physical address support in
skcipher_walk, but that has now been removed.  Or it may have been
present to be consistent with the fast path that currently does not hand
back addresses that span pages, but that behavior is a side effect of
the pages being "mapped" one by one and is not actually a requirement.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 62 ++++++++++++-----------------------------------
 1 file changed, 15 insertions(+), 47 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 8749c44f98a2..887cbce8f78d 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -61,32 +61,20 @@ static inline void skcipher_unmap_dst(struct skcipher_walk *walk)
 static inline gfp_t skcipher_walk_gfp(struct skcipher_walk *walk)
 {
 	return walk->flags & SKCIPHER_WALK_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 }
 
-/* Get a spot of the specified length that does not straddle a page.
- * The caller needs to ensure that there is enough space for this operation.
- */
-static inline u8 *skcipher_get_spot(u8 *start, unsigned int len)
-{
-	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
-
-	return max(start, end_page);
-}
-
 static inline struct skcipher_alg *__crypto_skcipher_alg(
 	struct crypto_alg *alg)
 {
 	return container_of(alg, struct skcipher_alg, base);
 }
 
 static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
 {
-	u8 *addr;
+	u8 *addr = PTR_ALIGN(walk->buffer, walk->alignmask + 1);
 
-	addr = (u8 *)ALIGN((unsigned long)walk->buffer, walk->alignmask + 1);
-	addr = skcipher_get_spot(addr, bsize);
 	scatterwalk_copychunks(addr, &walk->out, bsize, 1);
 	return 0;
 }
 
 /**
@@ -181,37 +169,26 @@ int skcipher_walk_done(struct skcipher_walk *walk, int res)
 EXPORT_SYMBOL_GPL(skcipher_walk_done);
 
 static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
 {
 	unsigned alignmask = walk->alignmask;
-	unsigned a;
 	unsigned n;
 	u8 *buffer;
 
 	if (!walk->buffer)
 		walk->buffer = walk->page;
 	buffer = walk->buffer;
-	if (buffer)
-		goto ok;
-
-	/* Start with the minimum alignment of kmalloc. */
-	a = crypto_tfm_ctx_alignment() - 1;
-	n = bsize;
-
-	/* Minimum size to align buffer by alignmask. */
-	n += alignmask & ~a;
-
-	/* Minimum size to ensure buffer does not straddle a page. */
-	n += (bsize - 1) & ~(alignmask | a);
-
-	buffer = kzalloc(n, skcipher_walk_gfp(walk));
-	if (!buffer)
-		return skcipher_walk_done(walk, -ENOMEM);
-	walk->buffer = buffer;
-ok:
+	if (!buffer) {
+		/* Min size for a buffer of bsize bytes aligned to alignmask */
+		n = bsize + (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
+
+		buffer = kzalloc(n, skcipher_walk_gfp(walk));
+		if (!buffer)
+			return skcipher_walk_done(walk, -ENOMEM);
+		walk->buffer = buffer;
+	}
 	walk->dst.virt.addr = PTR_ALIGN(buffer, alignmask + 1);
-	walk->dst.virt.addr = skcipher_get_spot(walk->dst.virt.addr, bsize);
 	walk->src.virt.addr = walk->dst.virt.addr;
 
 	scatterwalk_copychunks(walk->src.virt.addr, &walk->in, bsize, 0);
 
 	walk->nbytes = bsize;
@@ -294,34 +271,25 @@ static int skcipher_walk_next(struct skcipher_walk *walk)
 	return skcipher_next_fast(walk);
 }
 
 static int skcipher_copy_iv(struct skcipher_walk *walk)
 {
-	unsigned a = crypto_tfm_ctx_alignment() - 1;
 	unsigned alignmask = walk->alignmask;
 	unsigned ivsize = walk->ivsize;
-	unsigned bs = walk->stride;
-	unsigned aligned_bs;
+	unsigned aligned_stride = ALIGN(walk->stride, alignmask + 1);
 	unsigned size;
 	u8 *iv;
 
-	aligned_bs = ALIGN(bs, alignmask + 1);
-
-	/* Minimum size to align buffer by alignmask. */
-	size = alignmask & ~a;
-
-	size += aligned_bs + ivsize;
-
-	/* Minimum size to ensure buffer does not straddle a page. */
-	size += (bs - 1) & ~(alignmask | a);
+	/* Min size for a buffer of stride + ivsize, aligned to alignmask */
+	size = aligned_stride + ivsize +
+	       (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
 
 	walk->buffer = kmalloc(size, skcipher_walk_gfp(walk));
 	if (!walk->buffer)
 		return -ENOMEM;
 
-	iv = PTR_ALIGN(walk->buffer, alignmask + 1);
-	iv = skcipher_get_spot(iv, bs) + aligned_bs;
+	iv = PTR_ALIGN(walk->buffer, alignmask + 1) + aligned_stride;
 
 	walk->iv = memcpy(iv, walk->iv, walk->ivsize);
 	return 0;
 }
 
-- 
2.47.1

