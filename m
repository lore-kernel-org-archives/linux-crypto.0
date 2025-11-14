Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8BF2FB622;
	Fri, 14 Nov 2025 22:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763161192; cv=none; b=QTFhULGv9ctWs2IZFaawyqctM/VU6OpKIH5cbwZvHPk1LlEpoOGt3PagSSPgwHgKPfxuY9ljfcqrq2ORZrdxCtSKFrjQABugKP9RXt3RDlkPJsOkjrMKn69gY8lrTxwweKuNaGXkXIxQ2viay923Rfl+dKfHfRnuJIVBIktGEic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763161192; c=relaxed/simple;
	bh=xyqlJhrmdH/19s66Uc9RvAWqrLSELkZ0GQwYbHazZgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6OcDRyMWD0wGGLHLH/Ux1VW2Hn1P/k9Mfza7NvHUmm6O8AUVV5/ALHVIQlbhqaF9t/eOrfEL1FbuQzdyR3mZnhwTp3mKIpzJ8uzP4+EH1S9jbvOnyk32QEF/Kk9TfyUzIcFRlYVzQMB2SmMc63IRN0qDxdm60MoPE1Xk7eCVM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tqA0qV41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tqA0qV41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8900C116D0;
	Fri, 14 Nov 2025 22:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763161191;
	bh=xyqlJhrmdH/19s66Uc9RvAWqrLSELkZ0GQwYbHazZgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqA0qV41NkYI9yu+vQnXSxgWgDD4H//KHZKp9cPh/ctnD6v4wIPbpmq5lNuRNl6B6
	 d//QUNohRmZBBd3VHb5DEO5r1MEm6oraVF5HxenEu9IUYKXZDhrm0aBEE5BponoBDO
	 2j89r/ZwXXxhElSHffQm8Ips2zwCIPr5NhEHsv3CSKoW1L6FoxK7YY4hd5iwONdwP7
	 CRydf3KAkpcECQAfs0EB6WXhoWdOI1yGMh6CnInpWaUzq+Z3zzrOh078oPaeEgf7h3
	 jbNVu8WO4bePwPqPIywHfemLhLWSgOMNQwJJHM/LoTx6zkg6zmZFiwG0K5HWArqbxG
	 G2AiDC+MpYLBA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Colin Ian King <coking@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] crypto: scatterwalk - Fix memcpy_sglist() to always succeed
Date: Fri, 14 Nov 2025 14:58:50 -0800
Message-ID: <20251114225851.324143-2-ebiggers@kernel.org>
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

The original implementation of memcpy_sglist() was broken because it
didn't handle overlapping scatterlists.  The current implementation is
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
 crypto/scatterwalk.c         | 103 ++++++++++++++++++++++++++++++-----
 include/crypto/scatterwalk.h |  52 +++++++++++-------
 2 files changed, 121 insertions(+), 34 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 1d010e2a1b1a..af6c17bfcadb 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -99,30 +99,107 @@ void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
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
+ * The scatterlists can overlap.  Hence this really acts like memmove(), not
+ * memcpy().
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
+				/*
+				 * Copy between different pages.
+				 * No need for memmove(), as the pages differ.
+				 */
+				src_virt = kmap_local_page(src_page);
+				dst_virt = kmap_local_page(dst_page);
+				memcpy(dst_virt + dst_oip, src_virt + src_oip,
+				       len);
+				flush_dcache_page(dst_page);
+				kunmap_local(dst_virt);
+				kunmap_local(src_virt);
+			} else if (src_oip != dst_oip) {
+				/* Copy between different parts of same page */
+				dst_virt = kmap_local_page(dst_page);
+				memmove(dst_virt + dst_oip, dst_virt + src_oip,
+					len);
+				flush_dcache_page(dst_page);
+				kunmap_local(dst_virt);
+			} /* Exact overlap.  No action needed. */
+		} else {
+			/*
+			 * !HIGHMEM: no mapping needed.  Just work in the linear
+			 * buffer of each sg entry.
+			 */
+			src_virt = page_address(src_page) + src_offset;
+			dst_virt = page_address(dst_page) + dst_offset;
+			if (src_virt != dst_virt) {
+				memmove(dst_virt, src_virt, len);
+				if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
+					__scatterwalk_flush_dcache_pages(
+						dst_page, dst_offset, len);
+			}
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

