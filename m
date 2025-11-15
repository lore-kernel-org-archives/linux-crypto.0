Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B351239E8D;
	Sat, 15 Nov 2025 23:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763248178; cv=none; b=jj+TPXb1tQEF88bv5DcuTKxeJ0ilEcYK0/VDs0RUwOQXwrcftu0W18kf4Ofhh+OMn43szogGJ66UuE6ZOnBT3UEcO6P/ZtJpCpVtTakKm+UGTK4X/Vq7X98m7eENZKGHOiOgGdDAtmb0KlUFDV7l64HMaVblCcl/bnNf9N+cVD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763248178; c=relaxed/simple;
	bh=NpOdqjDBxL5abs/oBB2EGO3MLF09j5tG2jpPmvZHEcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9vpM/B1AHCeUXGFo/VHHCqtyYANpHmucYQLpaNkcx4Anzi98bbSSIdfZ8XDjfRKiISF8nRaEZJ+QZJKPvEIUW9miu/MeZrvAe0Hzk0WPj1F5EmKLjGAUPwxYC45rk8KuY6f/VD9t+j3EvMZUlgyLiIFjPgWBwCpXdZytvQW6WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J8J/HFrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8J/HFrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A5BC116B1;
	Sat, 15 Nov 2025 23:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763248177;
	bh=NpOdqjDBxL5abs/oBB2EGO3MLF09j5tG2jpPmvZHEcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8J/HFrDX7VdJK+40cmSSv9Ayn+aZd0VlzF7tvWriyD0QMh4OyeCONQHg75SsqB0k
	 U27Mbmf9bCY0CbKwqYOzkKIraMXw4DZKUL+Kw+bCv3YstC+H+8wgEcBYGqgD9kGmTv
	 3a50twwT3sHEDxZrfdYVAwq4wWgjDn03NhO5IdhqYrCTnAmPBc+SQuHWPMIFCbaVPM
	 0GHprq9uPIDZiH2EZjnPXEMjJK7u2Gf+m56wNTIFSkwEghmeD41SJWz9LV96H9D5sR
	 Y8yrj1P/eHT47WQDW4MRDI0xdnvtqA0Wqu5XGoRm3LtIrWo1r1KrDjDtm7L8eHOOV5
	 LTZgqMCnYxdTg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Colin Ian King <coking@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] crypto: scatterwalk - Fix memcpy_sglist() to always succeed
Date: Sat, 15 Nov 2025 15:08:16 -0800
Message-ID: <20251115230817.26070-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251115230817.26070-1-ebiggers@kernel.org>
References: <20251115230817.26070-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The original implementation of memcpy_sglist() was broken because it
didn't handle scatterlists that describe exactly the same memory, which
is a case that many callers rely on.  The current implementation is
broken too because it calls the skcipher_walk functions which can fail.
It ignores any errors from those functions.

Fix it by replacing it with a new implementation written from scratch.
It always succeeds.  It's also a bit faster, since it avoids the
overhead of skcipher_walk.  skcipher_walk includes a lot of
functionality (such as alignmask handling) that's irrelevant here.

Reported-by: Colin Ian King <coking@nvidia.com>
Closes: https://lore.kernel.org/r/20251114122620.111623-1-coking@nvidia.com
Fixes: 131bdceca1f0 ("crypto: scatterwalk - Add memcpy_sglist")
Fixes: 0f8d42bf128d ("crypto: scatterwalk - Move skcipher walk and use it for memcpy_sglist")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/scatterwalk.c         | 97 +++++++++++++++++++++++++++++++-----
 include/crypto/scatterwalk.h | 52 +++++++++++--------
 2 files changed, 115 insertions(+), 34 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 1d010e2a1b1a..b95e5974e327 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -99,30 +99,101 @@ void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
 	scatterwalk_start_at_pos(&walk, sg, start);
 	memcpy_to_scatterwalk(&walk, buf, nbytes);
 }
 EXPORT_SYMBOL_GPL(memcpy_to_sglist);
 
+/**
+ * memcpy_sglist() - Copy data from one scatterlist to another
+ * @dst: The destination scatterlist.  Can be NULL if @nbytes == 0.
+ * @src: The source scatterlist.  Can be NULL if @nbytes == 0.
+ * @nbytes: Number of bytes to copy
+ *
+ * The scatterlists can describe exactly the same memory, in which case this
+ * function is a no-op.  No other overlaps are supported.
+ *
+ * Context: Any context
+ */
 void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
 		   unsigned int nbytes)
 {
-	struct skcipher_walk walk = {};
+	unsigned int src_offset, dst_offset;
 
-	if (unlikely(nbytes == 0)) /* in case sg == NULL */
+	if (unlikely(nbytes == 0)) /* in case src and/or dst is NULL */
 		return;
 
-	walk.total = nbytes;
-
-	scatterwalk_start(&walk.in, src);
-	scatterwalk_start(&walk.out, dst);
+	src_offset = src->offset;
+	dst_offset = dst->offset;
+	for (;;) {
+		/* Compute the length to copy this step. */
+		unsigned int len = min3(src->offset + src->length - src_offset,
+					dst->offset + dst->length - dst_offset,
+					nbytes);
+		struct page *src_page = sg_page(src);
+		struct page *dst_page = sg_page(dst);
+		const void *src_virt;
+		void *dst_virt;
+
+		if (IS_ENABLED(CONFIG_HIGHMEM)) {
+			/* HIGHMEM: we may have to actually map the pages. */
+			const unsigned int src_oip = offset_in_page(src_offset);
+			const unsigned int dst_oip = offset_in_page(dst_offset);
+			const unsigned int limit = PAGE_SIZE;
+
+			/* Further limit len to not cross a page boundary. */
+			len = min3(len, limit - src_oip, limit - dst_oip);
+
+			/* Compute the source and destination pages. */
+			src_page += src_offset / PAGE_SIZE;
+			dst_page += dst_offset / PAGE_SIZE;
+
+			if (src_page != dst_page) {
+				/* Copy between different pages. */
+				memcpy_page(dst_page, dst_oip,
+					    src_page, src_oip, len);
+				flush_dcache_page(dst_page);
+			} else if (src_oip != dst_oip) {
+				/* Copy between different parts of same page. */
+				dst_virt = kmap_local_page(dst_page);
+				memcpy(dst_virt + dst_oip, dst_virt + src_oip,
+				       len);
+				kunmap_local(dst_virt);
+				flush_dcache_page(dst_page);
+			} /* Else, it's the same memory.  No action needed. */
+		} else {
+			/*
+			 * !HIGHMEM: no mapping needed.  Just work in the linear
+			 * buffer of each sg entry.  Note that we can cross page
+			 * boundaries, as they are not significant in this case.
+			 */
+			src_virt = page_address(src_page) + src_offset;
+			dst_virt = page_address(dst_page) + dst_offset;
+			if (src_virt != dst_virt) {
+				memcpy(dst_virt, src_virt, len);
+				if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
+					__scatterwalk_flush_dcache_pages(
+						dst_page, dst_offset, len);
+			} /* Else, it's the same memory.  No action needed. */
+		}
+		nbytes -= len;
+		if (nbytes == 0) /* No more to copy? */
+			break;
 
-	skcipher_walk_first(&walk, true);
-	do {
-		if (walk.src.virt.addr != walk.dst.virt.addr)
-			memcpy(walk.dst.virt.addr, walk.src.virt.addr,
-			       walk.nbytes);
-		skcipher_walk_done(&walk, 0);
-	} while (walk.nbytes);
+		/*
+		 * There's more to copy.  Advance the offsets by the length
+		 * copied this step, and advance the sg entries as needed.
+		 */
+		src_offset += len;
+		if (src_offset >= src->offset + src->length) {
+			src = sg_next(src);
+			src_offset = src->offset;
+		}
+		dst_offset += len;
+		if (dst_offset >= dst->offset + dst->length) {
+			dst = sg_next(dst);
+			dst_offset = dst->offset;
+		}
+	}
 }
 EXPORT_SYMBOL_GPL(memcpy_sglist);
 
 struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 				     struct scatterlist *src,
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 83d14376ff2b..f485454e3955 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -225,10 +225,38 @@ static inline void scatterwalk_done_src(struct scatter_walk *walk,
 {
 	scatterwalk_unmap(walk);
 	scatterwalk_advance(walk, nbytes);
 }
 
+/*
+ * Flush the dcache of any pages that overlap the region
+ * [offset, offset + nbytes) relative to base_page.
+ *
+ * This should be called only when ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE, to ensure
+ * that all relevant code (including the call to sg_page() in the caller, if
+ * applicable) gets fully optimized out when !ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE.
+ */
+static inline void __scatterwalk_flush_dcache_pages(struct page *base_page,
+						    unsigned int offset,
+						    unsigned int nbytes)
+{
+	unsigned int num_pages;
+
+	base_page += offset / PAGE_SIZE;
+	offset %= PAGE_SIZE;
+
+	/*
+	 * This is an overflow-safe version of
+	 * num_pages = DIV_ROUND_UP(offset + nbytes, PAGE_SIZE).
+	 */
+	num_pages = nbytes / PAGE_SIZE;
+	num_pages += DIV_ROUND_UP(offset + (nbytes % PAGE_SIZE), PAGE_SIZE);
+
+	for (unsigned int i = 0; i < num_pages; i++)
+		flush_dcache_page(base_page + i);
+}
+
 /**
  * scatterwalk_done_dst() - Finish one step of a walk of destination scatterlist
  * @walk: the scatter_walk
  * @nbytes: the number of bytes processed this step, less than or equal to the
  *	    number of bytes that scatterwalk_next() returned.
@@ -238,31 +266,13 @@ static inline void scatterwalk_done_src(struct scatter_walk *walk,
  */
 static inline void scatterwalk_done_dst(struct scatter_walk *walk,
 					unsigned int nbytes)
 {
 	scatterwalk_unmap(walk);
-	/*
-	 * Explicitly check ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE instead of just
-	 * relying on flush_dcache_page() being a no-op when not implemented,
-	 * since otherwise the BUG_ON in sg_page() does not get optimized out.
-	 * This also avoids having to consider whether the loop would get
-	 * reliably optimized out or not.
-	 */
-	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE) {
-		struct page *base_page;
-		unsigned int offset;
-		int start, end, i;
-
-		base_page = sg_page(walk->sg);
-		offset = walk->offset;
-		start = offset >> PAGE_SHIFT;
-		end = start + (nbytes >> PAGE_SHIFT);
-		end += (offset_in_page(offset) + offset_in_page(nbytes) +
-			PAGE_SIZE - 1) >> PAGE_SHIFT;
-		for (i = start; i < end; i++)
-			flush_dcache_page(base_page + i);
-	}
+	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
+		__scatterwalk_flush_dcache_pages(sg_page(walk->sg),
+						 walk->offset, nbytes);
 	scatterwalk_advance(walk, nbytes);
 }
 
 void scatterwalk_skip(struct scatter_walk *walk, unsigned int nbytes);
 
-- 
2.51.2

