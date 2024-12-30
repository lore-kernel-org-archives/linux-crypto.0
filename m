Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029AB18991E;
	Mon, 30 Dec 2024 00:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517763; cv=none; b=TEF1y2mDinncO7jr0ZUKGEKx4ilqMg56h0mSQBmBGMYEZXy7x52htaX1TpePqiwtQ6RgvHuM9Qlqyr7dGSaIzHV8ACb5SC2pybiYDvIR8R64JtybqnSWqGiR1yy7mBed08QVr0yQKbzTRYvpPPy7+lpzIFjm69Tu5kGcTbMOObo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517763; c=relaxed/simple;
	bh=IpLvn2XtgphqyEr3C9o4IvzLjuZxaBrxGrUoOcvifmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMgi4DYSRVbEM99G4gDt47BS5pKKeSqNnUajltlNo3yRiJM34AtvxaNmCi6FDtXEacUSQj6XsyY/Lvcf+yPw5M0RzjvFAvD74ykjtkoRRPo2LuNeW6hcy/LRrf9Ix3U2fO2/KdOL7LZabrY3n7ri+z0+yLlGH9JHSLh+IHv6PxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JGKclWey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JGKclWey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72356C4CEE5;
	Mon, 30 Dec 2024 00:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517762;
	bh=IpLvn2XtgphqyEr3C9o4IvzLjuZxaBrxGrUoOcvifmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGKclWeygDuiTSJhXU6d/wBYsCbxpUiMSCrVqgigcPIyzmlqEImT78huP0qfJ6gWM
	 aVlg2a/aqw/a8eqW5vkWod7VxLsN+GEGj+VQbK72d7Q7oqbNn6RaesM545RZDZK3Or
	 T2dyyon1XLidW7e0VunKESBOePbl+Y2CI21uXkGT2r/UK5MlhIk0u/NzZ8HavvnSs5
	 Ah2EwAJmmlDh4eibTzN9dqX2HKUegN/hHWBlpt1ygRbFv7RSdvfAMDi0Sv2E7P+SQ4
	 EA0F/3vLftFgv0T6Q0gFjXTKOAIon3UmLEllJjpBtDRDTS0Af8MEOO5uK1YYkpXVrm
	 UaevCQEGAcwtw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/29] crypto: scatterwalk - move to next sg entry just in time
Date: Sun, 29 Dec 2024 16:14:00 -0800
Message-ID: <20241230001418.74739-12-ebiggers@kernel.org>
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

The scatterwalk_* functions are designed to advance to the next sg entry
only when there is more data from the request to process.  Compared to
the alternative of advancing after each step if !sg_is_last(sg), this
has the advantage that it doesn't cause problems if users accidentally
don't terminate their scatterlist with the end marker (which is an easy
mistake to make, and there are examples of this).

Currently, the advance to the next sg entry happens in
scatterwalk_done(), which is called after each "step" of the walk.  It
requires the caller to pass in a boolean 'more' that indicates whether
there is more data.  This works when the caller immediately knows
whether there is more data, though it adds some complexity.  However in
the case of scatterwalk_copychunks() it's not immediately known whether
there is more data, so the call to scatterwalk_done() has to happen
higher up the stack.  This is error-prone, and indeed the needed call to
scatterwalk_done() is not always made, e.g. scatterwalk_copychunks() is
sometimes called multiple times in a row.  This causes a zero-length
step to get added in some cases, which is unexpected and seems to work
only by accident.

This patch begins the switch to a less error-prone approach where the
advance to the next sg entry happens just in time instead.  For now,
that means just doing the advance in scatterwalk_clamp() if it's needed
there.  Initially this is redundant, but it's needed to keep the tree in
a working state as later patches change things to the final state.

Later patches will similarly move the dcache flushing logic out of
scatterwalk_done() and then remove scatterwalk_done() entirely.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/scatterwalk.h | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 32fc4473175b..924efbaefe67 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -24,22 +24,30 @@ static inline void scatterwalk_crypto_chain(struct scatterlist *head,
 		sg_chain(head, num, sg);
 	else
 		sg_mark_end(head);
 }
 
+static inline void scatterwalk_start(struct scatter_walk *walk,
+				     struct scatterlist *sg)
+{
+	walk->sg = sg;
+	walk->offset = sg->offset;
+}
+
 static inline unsigned int scatterwalk_pagelen(struct scatter_walk *walk)
 {
 	unsigned int len = walk->sg->offset + walk->sg->length - walk->offset;
 	unsigned int len_this_page = offset_in_page(~walk->offset) + 1;
 	return len_this_page > len ? len : len_this_page;
 }
 
 static inline unsigned int scatterwalk_clamp(struct scatter_walk *walk,
 					     unsigned int nbytes)
 {
-	unsigned int len_this_page = scatterwalk_pagelen(walk);
-	return nbytes > len_this_page ? len_this_page : nbytes;
+	if (walk->offset >= walk->sg->offset + walk->sg->length)
+		scatterwalk_start(walk, sg_next(walk->sg));
+	return min(nbytes, scatterwalk_pagelen(walk));
 }
 
 static inline void scatterwalk_advance(struct scatter_walk *walk,
 				       unsigned int nbytes)
 {
@@ -54,17 +62,10 @@ static inline struct page *scatterwalk_page(struct scatter_walk *walk)
 static inline void scatterwalk_unmap(void *vaddr)
 {
 	kunmap_local(vaddr);
 }
 
-static inline void scatterwalk_start(struct scatter_walk *walk,
-				     struct scatterlist *sg)
-{
-	walk->sg = sg;
-	walk->offset = sg->offset;
-}
-
 static inline void *scatterwalk_map(struct scatter_walk *walk)
 {
 	return kmap_local_page(scatterwalk_page(walk)) +
 	       offset_in_page(walk->offset);
 }
-- 
2.47.1

