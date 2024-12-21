Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D601F2C48
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772297; cv=none; b=NjcInJrAtajGhKiTVGr6DQ5GJkBEQF08WeBYQlJeuTED+nFK1mCl9I/hjy2y/rnQIVaEOrrdmzwEv/jLCgNyvGli4plB5D4qXEySWwdkxXW0NdQuP7Sk8Nn2r9q5mW4A/pGh6Gh5p9w6zHxZLO8/p1c0eYWrGNh/8BZrc/WX+wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772297; c=relaxed/simple;
	bh=hzp1ie+wDuon/4DJgKw5g8w6X6lFOVe2M3urTd/ukOk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+OTeDl9PB93esDxWJRb1E++WgJZ6jqdfDGCOlIccyR63RNzDlbCve/CDMacR8EEPFFG03I47kEAtc8UAtd0psL/HH7SkkXvNJzWYLNgkxg70wz0YEu8tqOXov2c7TE8Ipx1W7dg/5wfB7XElXJl7yLkxpGWkhNOOWczHskv86U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zj46DLaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zj46DLaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB006C4CEDD
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772296;
	bh=hzp1ie+wDuon/4DJgKw5g8w6X6lFOVe2M3urTd/ukOk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Zj46DLaqO+tsyB/yLtciLFmAeh0B8I38tRKncHTXwUNzxoQyajpkpSCZENfcKRuOD
	 5fYTGpjgsdIx22mw8kRY9uAhRKYpSMIC/NWhOlj2ku75XKgMvkvU+pILiVKEnyOT8a
	 R+1vzgOX7F7SPnxzOspLR3KrUKqHK9MUhR103G/6xmStF6UeeuleXa22AWRUOuOild
	 9QUVk/RpAuLr/Z+A3fGdsZe6fo6ReZ9wcxU2TqceRL5+Zkd6z+UHWBuHKYg+v2dSB9
	 XSlRfARhfZm7V+HBDiFSzpU7iB5iywjoe1WUZTlzSnj4xX5PqvwcKGoLX0gVIQbqBD
	 XzYNsOzNRrjoQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 28/29] crypto: scatterwalk - remove obsolete functions
Date: Sat, 21 Dec 2024 01:10:55 -0800
Message-ID: <20241221091056.282098-29-ebiggers@kernel.org>
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

Remove various functions that are no longer used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/scatterwalk.c         | 37 ------------------------------------
 include/crypto/scatterwalk.h | 25 ------------------------
 2 files changed, 62 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 2e7a532152d6..87c080f565d4 100644
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
index 5e12c07be89b..b542ce69d0bb 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -96,32 +96,10 @@ static inline void *scatterwalk_next(struct scatter_walk *walk,
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
@@ -160,13 +138,10 @@ static inline void scatterwalk_done_dst(struct scatter_walk *walk,
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
2.47.1

