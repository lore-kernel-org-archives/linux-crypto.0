Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E591E1F193C
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772294; cv=none; b=eeeHoHCRTJTmjjT/O49IlmC72Jx0AbAMzXN5LTjDCkxGYkeuhLOcsg41hHvNpa36BLINi6fWEEgwJiMQ7hpoSk4stobLfoBSfp2woDBSzleogFTQd1UMo7VkDgFpBlOYZJ2/cTHGDgvQge/WEA9/bopr8HNVlnQYr5CxhKPNSA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772294; c=relaxed/simple;
	bh=Lc+Uvnjuqp7QZEEtyq89hKiokD0nKYE9KNHIW02xcyM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebXPpbGX9moASDRhumX41GGWxfaHbAY2oFMsS/WnCrWStdImuui2sOANkVP+7Ns+gaxslUhj/57AawBuTmXSjPEud7MtcFqIWlUNwrmj+UnfSmdlvzWsD5IYpy0N+z4YR63KTV2edvlu+qRufdrFDaNBRd7LrOiYe12zyq+heI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VbXv7+Lr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VbXv7+Lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA06C4CECE
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772293;
	bh=Lc+Uvnjuqp7QZEEtyq89hKiokD0nKYE9KNHIW02xcyM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=VbXv7+LrfwawF8V++KL8u82MGaMbUP9Y0b4bV4ThXnXMKzln5rMPtor/vdDmXXNZW
	 anbJGzjbTisQgaHF/JU7TsufnzAEehyqgr/xBhWae41Yx0W05Q94gG2s/AXmMh2XBN
	 1khtGSkNZQsM505toyxTMDVw4E5Zk/mUnA41ky7++n4poTxg56/yaKG809iTwNae82
	 Q1uWcqJgg6cFDapQm5wYA7vp3yP4NXmCpFOM5Fa2Sk7rySrCOw9s7HgoWidnILFEpS
	 1XszZWL4KgAJJ/5E+dwaQjQH/CnUC7OTWaMjtpy4QaadHKd6fPbgbp9+js/A+p/TYy
	 3phaY16SxuZbw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 13/29] crypto: scatterwalk - add new functions for iterating through data
Date: Sat, 21 Dec 2024 01:10:40 -0800
Message-ID: <20241221091056.282098-14-ebiggers@kernel.org>
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

Add scatterwalk_next() which consolidates scatterwalk_clamp() and
scatterwalk_map().  Also add scatterwalk_done_src() and
scatterwalk_done_dst() which consolidate scatterwalk_unmap(),
scatterwalk_advance(), and scatterwalk_done() or scatterwalk_pagedone().
A later patch will remove scatterwalk_done() and scatterwalk_pagedone().

The new code eliminates the error-prone 'more' parameter.  Advancing to
the next sg entry now only happens just-in-time in scatterwalk_next().

The new code also pairs the dcache flush more closely with the actual
write, similar to memcpy_to_page().  Previously it was paired with
advancing to the next page.  This is currently causing bugs where the
dcache flush is incorrectly being skipped, usually due to
scatterwalk_copychunks() being called without a following
scatterwalk_done().  The dcache flush may have been placed where it was
in order to not call flush_dcache_page() redundantly when visiting a
page more than once.  However, that case is rare in practice, and most
architectures either do not implement flush_dcache_page() anyway or
implement it lazily where it just clears a page flag.

Another limitation of the old code was that by the time the flush
happened, there was no way to tell if more than one page needed to be
flushed.  That has been sufficient because the code goes page by page,
but I would like to optimize that on !HIGHMEM platforms.  The new code
makes this possible, and a later patch will implement this optimization.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/scatterwalk.h | 64 ++++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 6 deletions(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 5c7765f601e0..8108478d6fbf 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -62,16 +62,10 @@ static inline unsigned int scatterwalk_clamp(struct scatter_walk *walk,
 	if (walk->offset >= walk->sg->offset + walk->sg->length)
 		scatterwalk_start(walk, sg_next(walk->sg));
 	return min(nbytes, scatterwalk_pagelen(walk));
 }
 
-static inline void scatterwalk_advance(struct scatter_walk *walk,
-				       unsigned int nbytes)
-{
-	walk->offset += nbytes;
-}
-
 static inline struct page *scatterwalk_page(struct scatter_walk *walk)
 {
 	return sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
 }
 
@@ -84,10 +78,28 @@ static inline void *scatterwalk_map(struct scatter_walk *walk)
 {
 	return kmap_local_page(scatterwalk_page(walk)) +
 	       offset_in_page(walk->offset);
 }
 
+/**
+ * scatterwalk_next() - Get the next data buffer in a scatterlist walk
+ * @walk: the scatter_walk
+ * @total: the total number of bytes remaining, > 0
+ * @nbytes_ret: (out) the next number of bytes available, <= @total
+ *
+ * Return: A virtual address for the next segment of data from the scatterlist.
+ *	   The caller must call scatterwalk_done_src() or scatterwalk_done_dst()
+ *	   when it is done using this virtual address.
+ */
+static inline void *scatterwalk_next(struct scatter_walk *walk,
+				     unsigned int total,
+				     unsigned int *nbytes_ret)
+{
+	*nbytes_ret = scatterwalk_clamp(walk, total);
+	return scatterwalk_map(walk);
+}
+
 static inline void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 					unsigned int more)
 {
 	if (out) {
 		struct page *page;
@@ -106,10 +118,50 @@ static inline void scatterwalk_done(struct scatter_walk *walk, int out,
 	if (!more || walk->offset >= walk->sg->offset + walk->sg->length ||
 	    !(walk->offset & (PAGE_SIZE - 1)))
 		scatterwalk_pagedone(walk, out, more);
 }
 
+static inline void scatterwalk_advance(struct scatter_walk *walk,
+				       unsigned int nbytes)
+{
+	walk->offset += nbytes;
+}
+
+/**
+ * scatterwalk_done_src() - Finish one step of a walk of source scatterlist
+ * @walk: the scatter_walk
+ * @vaddr: the address returned by scatterwalk_next()
+ * @nbytes: the number of bytes processed this step, less than or equal to the
+ *	    number of bytes that scatterwalk_next() returned.
+ *
+ * Use this if the @vaddr was not written to, i.e. it is source data.
+ */
+static inline void scatterwalk_done_src(struct scatter_walk *walk,
+					const void *vaddr, unsigned int nbytes)
+{
+	scatterwalk_unmap((void *)vaddr);
+	scatterwalk_advance(walk, nbytes);
+}
+
+/**
+ * scatterwalk_done_dst() - Finish one step of a walk of destination scatterlist
+ * @walk: the scatter_walk
+ * @vaddr: the address returned by scatterwalk_next()
+ * @nbytes: the number of bytes processed this step, less than or equal to the
+ *	    number of bytes that scatterwalk_next() returned.
+ *
+ * Use this if the @vaddr may have been written to, i.e. it is destination data.
+ */
+static inline void scatterwalk_done_dst(struct scatter_walk *walk,
+					void *vaddr, unsigned int nbytes)
+{
+	scatterwalk_unmap(vaddr);
+	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
+		flush_dcache_page(scatterwalk_page(walk));
+	scatterwalk_advance(walk, nbytes);
+}
+
 void scatterwalk_skip(struct scatter_walk *walk, unsigned int nbytes);
 
 void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 			    size_t nbytes, int out);
 
-- 
2.47.1

