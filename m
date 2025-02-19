Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5268621C9FA;
	Wed, 19 Feb 2025 18:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989472; cv=none; b=U42j79IASLxAxZltGBVf5OxyAoGSz7tL+IkNIwkq0OXBOyn6eFpftHFI8Gx686Pv7Oxdri0K55Qd9crXlZfoifiAyVpYXeAzU/+DtQ/Kj+veUIHziP53yLgbQtNnS3I6RGF46G0nH0ROrhjOMoRptDc+TqNTbY9k6n6AXzpoVXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989472; c=relaxed/simple;
	bh=4lMjZPPR5tAt3RCT7E5nLuW/hwq2SL9e/KRXA8qjeXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDNkbwiAW4HaSQzdShZkmL+IdEoRp1W2ajDJudVqb9/a0Zv7LbXIIlTMSi38aKl02JJzjfrxAOt40SkbU+xju/bH2UIGKAa5xhS2zFQVIeSdHqtD51rZdiqyMbWH625+NN0ceBSeERQmfIU+mKn5C4SKRPVlj3CtzMcq02OkliU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bl9Z7AZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bl9Z7AZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EB5C4CEEB;
	Wed, 19 Feb 2025 18:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989472;
	bh=4lMjZPPR5tAt3RCT7E5nLuW/hwq2SL9e/KRXA8qjeXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bl9Z7AZM1wlXC9fPoO45VIQY87igC9vxRgXSke8uCaQeZYNTiTzqp2+WWyXogYmdq
	 2QHv7M4z+VAvoW4lgPcW5B6Ejw5ydbKYWrunmuZTDq/srEW6AVzvFl4Kjg2008gNkr
	 QBc7mUnkW/aw6Cnu/k98SCi1BjW7m5JhCY37A9jNNjKqiL2+BsvXxJ/jmWrOsx7Fys
	 qwUPOZfN/WhAjwpnvOI+PLhtJS5YEehiGG7wlxFWTIvOBtewyPgwZVoJlXpPK+Lnth
	 gLFOaCA8vYTx53EHEgKy0W0U1ZcCaOQcsRU1pffLufUX1wGhgvpybQ5xawDpCJWriX
	 wJ2FTSNJxPRBA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v3 18/19] crypto: scatterwalk - remove obsolete functions
Date: Wed, 19 Feb 2025 10:23:40 -0800
Message-ID: <20250219182341.43961-19-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219182341.43961-1-ebiggers@kernel.org>
References: <20250219182341.43961-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Remove various functions that are no longer used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/scatterwalk.c         | 37 ------------------------------------
 include/crypto/scatterwalk.h | 25 ------------------------
 2 files changed, 62 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 2e7a532152d61..87c080f565d45 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -28,47 +28,10 @@ void scatterwalk_skip(struct scatter_walk *walk, unsigned int nbytes)
 	walk->sg = sg;
 	walk->offset = sg->offset + nbytes;
 }
 EXPORT_SYMBOL_GPL(scatterwalk_skip);
 
-static inline void memcpy_dir(void *buf, void *sgdata, size_t nbytes, int out)
-{
-	void *src = out ? buf : sgdata;
-	void *dst = out ? sgdata : buf;
-
-	memcpy(dst, src, nbytes);
-}
-
-void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
-			    size_t nbytes, int out)
-{
-	for (;;) {
-		unsigned int len_this_page = scatterwalk_pagelen(walk);
-		u8 *vaddr;
-
-		if (len_this_page > nbytes)
-			len_this_page = nbytes;
-
-		if (out != 2) {
-			vaddr = scatterwalk_map(walk);
-			memcpy_dir(buf, vaddr, len_this_page, out);
-			scatterwalk_unmap(vaddr);
-		}
-
-		scatterwalk_advance(walk, len_this_page);
-
-		if (nbytes == len_this_page)
-			break;
-
-		buf += len_this_page;
-		nbytes -= len_this_page;
-
-		scatterwalk_pagedone(walk, out & 1, 1);
-	}
-}
-EXPORT_SYMBOL_GPL(scatterwalk_copychunks);
-
 inline void memcpy_from_scatterwalk(void *buf, struct scatter_walk *walk,
 				    unsigned int nbytes)
 {
 	do {
 		const void *src_addr;
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index f6262d05a3c75..ac03fdf88b2a0 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -113,32 +113,10 @@ static inline void *scatterwalk_next(struct scatter_walk *walk,
 {
 	*nbytes_ret = scatterwalk_clamp(walk, total);
 	return scatterwalk_map(walk);
 }
 
-static inline void scatterwalk_pagedone(struct scatter_walk *walk, int out,
-					unsigned int more)
-{
-	if (out) {
-		struct page *page;
-
-		page = sg_page(walk->sg) + ((walk->offset - 1) >> PAGE_SHIFT);
-		flush_dcache_page(page);
-	}
-
-	if (more && walk->offset >= walk->sg->offset + walk->sg->length)
-		scatterwalk_start(walk, sg_next(walk->sg));
-}
-
-static inline void scatterwalk_done(struct scatter_walk *walk, int out,
-				    int more)
-{
-	if (!more || walk->offset >= walk->sg->offset + walk->sg->length ||
-	    !(walk->offset & (PAGE_SIZE - 1)))
-		scatterwalk_pagedone(walk, out, more);
-}
-
 static inline void scatterwalk_advance(struct scatter_walk *walk,
 				       unsigned int nbytes)
 {
 	walk->offset += nbytes;
 }
@@ -182,13 +160,10 @@ static inline void scatterwalk_done_dst(struct scatter_walk *walk,
 	scatterwalk_advance(walk, nbytes);
 }
 
 void scatterwalk_skip(struct scatter_walk *walk, unsigned int nbytes);
 
-void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
-			    size_t nbytes, int out);
-
 void memcpy_from_scatterwalk(void *buf, struct scatter_walk *walk,
 			     unsigned int nbytes);
 
 void memcpy_to_scatterwalk(struct scatter_walk *walk, const void *buf,
 			   unsigned int nbytes);
-- 
2.48.1

