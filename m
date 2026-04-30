Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D92A2BE7AB;
	Thu, 30 Apr 2026 06:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777531074; cv=none; b=ltDVBqJUd0kFf9OW1HCz0yPM6Pa31u/1eE/2QAkiHqUK1cqAyTAiSbxsfNga6QsVPDOaOuPJSq+xEmX4/m72EpqmHCUDDrzxn++/VjaMCyu+KzQoj8Cus3th3KiEnzFEtbWjvMMQiQSn0Yldbdq7FKnu4rI6fjELcAcZ73Mu5XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777531074; c=relaxed/simple;
	bh=j5ejUsBHvRK1mLuGTFfQBdL5nlz102vlgTFY/vjdk5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNHQyeYoOpnV1hRDzDn6QVWs9PYbCvgXDD2jP6+cD1DOcIahKwkgBLJ3gAu09b0sJILJ7lWeT2rk3aMzqo6GSWpQzVzVkILibyGNYZtxL1ot4C27jJG7QHKK2nujMsOOWxtVzgwh2+nNRgvcv/iovQDQE1O6wOXW5ysOwXYH+SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8koKur6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8koKur6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73B7C2BCC4;
	Thu, 30 Apr 2026 06:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777531074;
	bh=j5ejUsBHvRK1mLuGTFfQBdL5nlz102vlgTFY/vjdk5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8koKur6XsmyHnQ65Evi87IwZql6TM676J/uWTk86RHfO+VAXBT9WGEgoh6XeqIo2
	 UUJjzmvtQ/qsHE6moRRR3E1oGwLyiN6KMZ97eNb2ek99Dyy5u36vC6+PjUjDqNNNbx
	 0rzNdncTxum77sPc1cTVvOlMaP1Zc+y4s8wEXn9vttNySE7RiwX+o9dFcDrgdcwkzn
	 BGqQ4NB2gmNs0NFOJd8pH9Jz2KjdMhkhq8+TuJxgiBvwPwlN6Gmw9x8lXcmVGbeKOR
	 VFkl8oUERtI4EqSNkqHFRyLViXtAx/StWFGi0Os70dfvL5UkIxn7Wp6QkR6QVCQCRZ
	 RW5x4CR2L4AlQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15 1/9] crypto: scatterwalk - Backport memcpy_sglist()
Date: Wed, 29 Apr 2026 23:35:56 -0700
Message-ID: <20260430063604.173525-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430063604.173525-1-ebiggers@kernel.org>
References: <20260430063604.173525-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This backports the current implementation of memcpy_sglist() from
upstream commit 4dffc9bbffb9ccfcda730d899c97c553599e7ca8.

This function was rewritten twice.  The earlier implementations had many
prerequisite commits, while the latest implementation is standalone.
It's much easier to just backport the latest code directly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/scatterwalk.c         | 94 ++++++++++++++++++++++++++++++++++++
 include/crypto/scatterwalk.h | 32 ++++++++++++
 2 files changed, 126 insertions(+)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 16f6ba896fb6..9f0b27005166 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -67,10 +67,104 @@ void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 	scatterwalk_copychunks(buf, &walk, nbytes, out);
 	scatterwalk_done(&walk, out, 0);
 }
 EXPORT_SYMBOL_GPL(scatterwalk_map_and_copy);
 
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
+void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
+		   unsigned int nbytes)
+{
+	unsigned int src_offset, dst_offset;
+
+	if (unlikely(nbytes == 0)) /* in case src and/or dst is NULL */
+		return;
+
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
+
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
+}
+EXPORT_SYMBOL_GPL(memcpy_sglist);
+
 struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 				     struct scatterlist *src,
 				     unsigned int len)
 {
 	for (;;) {
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 7af08174a721..df9c1ba3bd5c 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -86,10 +86,39 @@ static inline void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 
 	if (more && walk->offset >= walk->sg->offset + walk->sg->length)
 		scatterwalk_start(walk, sg_next(walk->sg));
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
+	unsigned int i;
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
+	for (i = 0; i < num_pages; i++)
+		flush_dcache_page(base_page + i);
+}
+
 static inline void scatterwalk_done(struct scatter_walk *walk, int out,
 				    int more)
 {
 	if (!more || walk->offset >= walk->sg->offset + walk->sg->length ||
 	    !(walk->offset & (PAGE_SIZE - 1)))
@@ -98,10 +127,13 @@ static inline void scatterwalk_done(struct scatter_walk *walk, int out,
 
 void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 			    size_t nbytes, int out);
 void *scatterwalk_map(struct scatter_walk *walk);
 
+void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
+		   unsigned int nbytes);
+
 void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 			      unsigned int start, unsigned int nbytes, int out);
 
 struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 				     struct scatterlist *src,
-- 
2.54.0

