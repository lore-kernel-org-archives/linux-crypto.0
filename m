Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2948A1F2C58
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772297; cv=none; b=JRRfXU2tRMCU15FS7e41mB/jEl66jzXJ54b5GqYWi3b+ZwHTMN2bvzfALaaDX1OxEwoDnY3Ftk/HmMopSBhiBI2jn366jIuokcTXYkfMgXa+NvJ+k/emphy6MHmLab7lwYyfNlExRRsXD7/tfjcwPAMSwfI8AFsv2qC0E3X3YtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772297; c=relaxed/simple;
	bh=NZzDEBd60cjX713tMZLABarMJgnPJcruN1LWg55Hmro=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o44nky+43IF3FsukjhfGjeNb23CZouclje/fdjR9NSnf6F/Rv5x1u1//6Ffy6ZIzriobw1yIQwUf4C9Vw3Bp1U3fLBzivZXibnj4t/4k9+SzPzPM1F/cdGuNoAZ/zjV0ZR6JjyPIQt++txs6Tie8oqtGgSewffXC/KW7mFjJh2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PsFV1gkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PsFV1gkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94C8C4CED4
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772297;
	bh=NZzDEBd60cjX713tMZLABarMJgnPJcruN1LWg55Hmro=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=PsFV1gkEjnqhv5SIiUFfBfqpnF4jFvUfixXKoRvuFXlS6hyC+j1hM4adjbipVg1fw
	 VNWKk/sMTQhFlJfg8s9repT+ZzF/o5oN0nHzqd5CkXhuP7PHWSu0lLfiwiJxm64jN8
	 XAQp3MikxoMVPvFP2jcxi9F13qbt4GJq2cjxt+9RXUTGqSwtHPRBbP0TtSZy6I+Qy/
	 /TcuC/l1hH55bMaenze3uJJPHBcJau/mM6qlCvBevnBpyl032FTcsH4rjznJhqA+Ib
	 ru5nTthdxdVQuLZ+AWGGwYgPxXh0hs8uyRpaB4j6Ow3N3pywyUKWz6HGkFJ0edNrMv
	 3BA9UvHfjPdYw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 29/29] crypto: scatterwalk - don't split at page boundaries when !HIGHMEM
Date: Sat, 21 Dec 2024 01:10:56 -0800
Message-ID: <20241221091056.282098-30-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
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

For now the segments are still limited to PAGE_SIZE to prevent
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
 include/crypto/scatterwalk.h | 77 +++++++++++++++++++++++++-----------
 2 files changed, 57 insertions(+), 24 deletions(-)

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
index b542ce69d0bb..fbb5867545a6 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -47,39 +47,58 @@ static inline void scatterwalk_start_at_pos(struct scatter_walk *walk,
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
-
-static inline struct page *scatterwalk_page(struct scatter_walk *walk)
-{
-	return sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
-}
+	len_this_sg = walk->sg->offset + walk->sg->length - walk->offset;
+
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
 
-static inline void scatterwalk_unmap(void *vaddr)
-{
-	kunmap_local(vaddr);
+	return min3(nbytes, len_this_sg, limit);
 }
 
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
@@ -96,10 +115,16 @@ static inline void *scatterwalk_next(struct scatter_walk *walk,
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
@@ -114,11 +139,11 @@ static inline void scatterwalk_advance(struct scatter_walk *walk,
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
@@ -131,12 +156,20 @@ static inline void scatterwalk_done_src(struct scatter_walk *walk,
  */
 static inline void scatterwalk_done_dst(struct scatter_walk *walk,
 					void *vaddr, unsigned int nbytes)
 {
 	scatterwalk_unmap(vaddr);
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

