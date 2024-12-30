Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4369C1A9B4A;
	Mon, 30 Dec 2024 00:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517769; cv=none; b=cLnrWlNMonarbDLXPbdrS+C540FBEGP7DMiao4FCiy2NwrYSDFomCLXXDn6G05y94To00O0iO5KJqHAPE5K28vJESTz6TPVZbWaOM3ViOIDZOGnT3Xqlbh7vXL0Z/8bkjBm8Ts8U0jizNCXrK5h9WP1T+5GfhInzCyKdEWiJUcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517769; c=relaxed/simple;
	bh=h7JvPT5ldnzaJjp9xBtbjrtty6vLenGC6gV46dAS22E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMtkK3drU4olaQXaWrFOPjQXFrGv528i2VLl0lsgSzg1dtHrguQNPBmcRy0sdtlOgbu6LglZ/M4jD/uX0qrx26sT/YYWrkg0sjcJbrKsXjCqmyWH9Vl35kqEEpcclHeaYsVcu8LI3paMF3a+Z6DW9/DKEO5+bBRJtX2jCYpdn+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KWEx5RBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KWEx5RBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04626C4CEDD;
	Mon, 30 Dec 2024 00:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517769;
	bh=h7JvPT5ldnzaJjp9xBtbjrtty6vLenGC6gV46dAS22E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWEx5RBDard8qO0nqmNDkTszFv9IUAeJCqmRE9vkVhAtuWdEDnF8/VUq24foLco0w
	 VqeIZr1ITUNh0RTKl1/FFN+ufwW72YnLPDtUMV6c6Y5c+cCG54k9xftTJ2tTfPTQnr
	 RSqNhxxLzXB6+w5RUhcYZdOo/Rkb8unTry/uHnVBNsqDJN10+iPJpUmfuZt3x16MXH
	 VNLKtNytgjIxOOwzxF+KAZ9Er2Qw9pza2Q4gnbNln0IA6DOeGxj5dZBFMIqgUS6m/D
	 L3gpukT656pnPBYJ8Kmr3Iqzz4DUuLyXAbwtdWO64Yw335pJcIMGYWB1rhcj3Cg1FI
	 EJwRn5aMqieQw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 29/29] crypto: scatterwalk - don't split at page boundaries when !HIGHMEM
Date: Sun, 29 Dec 2024 16:14:18 -0800
Message-ID: <20241230001418.74739-30-ebiggers@kernel.org>
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

When !HIGHMEM, the kmap_local_page() in the scatterlist walker does not
actually map anything, and the address it returns is just the address
from the kernel's direct map, where each sg entry's data is virtually
contiguous.  To improve performance, stop unnecessarily clamping data
segments to page boundaries in this case.

For now, still limit segments to PAGE_SIZE.  This is needed to prevent
preemption from being disabled for too long when SIMD is used, and to
support the alignmask case which still uses a page-sized bounce buffer.

Even so, this change still helps a lot in cases where messages cross a
page boundary.  For example, testing IPsec with AES-GCM on x86_64, the
messages are 1424 bytes which is less than PAGE_SIZE, but on the Rx side
over a third cross a page boundary.  These ended up being processed in
three parts, with the middle part going through skcipher_next_slow which
uses a 16-byte bounce buffer.  That was causing a significant amount of
overhead which unnecessarily reduced the performance benefit of the new
x86_64 AES-GCM assembly code.  This change solves the problem; all these
messages now get passed to the assembly code in one part.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c            |  4 +-
 include/crypto/scatterwalk.h | 79 ++++++++++++++++++++++++++----------
 2 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 8f6b09377368..16db19663c3d 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -203,12 +203,12 @@ static int skcipher_next_fast(struct skcipher_walk *walk)
 {
 	unsigned long diff;
 
 	diff = offset_in_page(walk->in.offset) -
 	       offset_in_page(walk->out.offset);
-	diff |= (u8 *)scatterwalk_page(&walk->in) -
-		(u8 *)scatterwalk_page(&walk->out);
+	diff |= (u8 *)(sg_page(walk->in.sg) + (walk->in.offset >> PAGE_SHIFT)) -
+		(u8 *)(sg_page(walk->out.sg) + (walk->out.offset >> PAGE_SHIFT));
 
 	skcipher_map_src(walk);
 	walk->dst.virt.addr = walk->src.virt.addr;
 
 	if (diff) {
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index ac03fdf88b2a..3024adbdd443 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -47,28 +47,39 @@ static inline void scatterwalk_start_at_pos(struct scatter_walk *walk,
 	}
 	walk->sg = sg;
 	walk->offset = sg->offset + pos;
 }
 
-static inline unsigned int scatterwalk_pagelen(struct scatter_walk *walk)
-{
-	unsigned int len = walk->sg->offset + walk->sg->length - walk->offset;
-	unsigned int len_this_page = offset_in_page(~walk->offset) + 1;
-	return len_this_page > len ? len : len_this_page;
-}
-
 static inline unsigned int scatterwalk_clamp(struct scatter_walk *walk,
 					     unsigned int nbytes)
 {
+	unsigned int len_this_sg;
+	unsigned int limit;
+
 	if (walk->offset >= walk->sg->offset + walk->sg->length)
 		scatterwalk_start(walk, sg_next(walk->sg));
-	return min(nbytes, scatterwalk_pagelen(walk));
-}
+	len_this_sg = walk->sg->offset + walk->sg->length - walk->offset;
 
-static inline struct page *scatterwalk_page(struct scatter_walk *walk)
-{
-	return sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
+	/*
+	 * HIGHMEM case: the page may have to be mapped into memory.  To avoid
+	 * the complexity of having to map multiple pages at once per sg entry,
+	 * clamp the returned length to not cross a page boundary.
+	 *
+	 * !HIGHMEM case: no mapping is needed; all pages of the sg entry are
+	 * already mapped contiguously in the kernel's direct map.  For improved
+	 * performance, allow the walker to return data segments that cross a
+	 * page boundary.  Do still cap the length to PAGE_SIZE, since some
+	 * users rely on that to avoid disabling preemption for too long when
+	 * using SIMD.  It's also needed for when skcipher_walk uses a bounce
+	 * page due to the data not being aligned to the algorithm's alignmask.
+	 */
+	if (IS_ENABLED(CONFIG_HIGHMEM))
+		limit = PAGE_SIZE - offset_in_page(walk->offset);
+	else
+		limit = PAGE_SIZE;
+
+	return min3(nbytes, len_this_sg, limit);
 }
 
 /*
  * Create a scatterlist that represents the remaining data in a walk.  Uses
  * chaining to reference the original scatterlist, so this uses at most two
@@ -84,19 +95,27 @@ static inline void scatterwalk_get_sglist(struct scatter_walk *walk,
 		    walk->sg->offset + walk->sg->length - walk->offset,
 		    walk->offset);
 	scatterwalk_crypto_chain(sg_out, sg_next(walk->sg), 2);
 }
 
-static inline void scatterwalk_unmap(void *vaddr)
-{
-	kunmap_local(vaddr);
-}
-
 static inline void *scatterwalk_map(struct scatter_walk *walk)
 {
-	return kmap_local_page(scatterwalk_page(walk)) +
-	       offset_in_page(walk->offset);
+	struct page *base_page = sg_page(walk->sg);
+
+	if (IS_ENABLED(CONFIG_HIGHMEM))
+		return kmap_local_page(base_page + (walk->offset >> PAGE_SHIFT)) +
+		       offset_in_page(walk->offset);
+	/*
+	 * When !HIGHMEM we allow the walker to return segments that span a page
+	 * boundary; see scatterwalk_clamp().  To make it clear that in this
+	 * case we're working in the linear buffer of the whole sg entry in the
+	 * kernel's direct map rather than within the mapped buffer of a single
+	 * page, compute the address as an offset from the page_address() of the
+	 * first page of the sg entry.  Either way the result is the address in
+	 * the direct map, but this makes it clearer what is really going on.
+	 */
+	return page_address(base_page) + walk->offset;
 }
 
 /**
  * scatterwalk_next() - Get the next data buffer in a scatterlist walk
  * @walk: the scatter_walk
@@ -113,10 +132,16 @@ static inline void *scatterwalk_next(struct scatter_walk *walk,
 {
 	*nbytes_ret = scatterwalk_clamp(walk, total);
 	return scatterwalk_map(walk);
 }
 
+static inline void scatterwalk_unmap(const void *vaddr)
+{
+	if (IS_ENABLED(CONFIG_HIGHMEM))
+		kunmap_local(vaddr);
+}
+
 static inline void scatterwalk_advance(struct scatter_walk *walk,
 				       unsigned int nbytes)
 {
 	walk->offset += nbytes;
 }
@@ -131,11 +156,11 @@ static inline void scatterwalk_advance(struct scatter_walk *walk,
  * Use this if the @vaddr was not written to, i.e. it is source data.
  */
 static inline void scatterwalk_done_src(struct scatter_walk *walk,
 					const void *vaddr, unsigned int nbytes)
 {
-	scatterwalk_unmap((void *)vaddr);
+	scatterwalk_unmap(vaddr);
 	scatterwalk_advance(walk, nbytes);
 }
 
 /**
  * scatterwalk_done_dst() - Finish one step of a walk of destination scatterlist
@@ -152,13 +177,23 @@ static inline void scatterwalk_done_dst(struct scatter_walk *walk,
 	scatterwalk_unmap(vaddr);
 	/*
 	 * Explicitly check ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE instead of just
 	 * relying on flush_dcache_page() being a no-op when not implemented,
 	 * since otherwise the BUG_ON in sg_page() does not get optimized out.
+	 * This also avoids having to consider whether the loop would get
+	 * reliably optimized out or not.
 	 */
-	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
-		flush_dcache_page(scatterwalk_page(walk));
+	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE) {
+		struct page *base_page, *start_page, *end_page, *page;
+
+		base_page = sg_page(walk->sg);
+		start_page = base_page + (walk->offset >> PAGE_SHIFT);
+		end_page = base_page + ((walk->offset + nbytes +
+					 PAGE_SIZE - 1) >> PAGE_SHIFT);
+		for (page = start_page; page < end_page; page++)
+			flush_dcache_page(page);
+	}
 	scatterwalk_advance(walk, nbytes);
 }
 
 void scatterwalk_skip(struct scatter_walk *walk, unsigned int nbytes);
 
-- 
2.47.1

