Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2958214A6F;
	Wed, 19 Feb 2025 18:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989467; cv=none; b=kJiDbDRBLZj7ZtLrqtcyrtl2B/FXbmlva/StF1xHFBpkm3cEUbPN4se4f3kfbvjnsyEFcSC+jpbmNKzGfl3yPNT+vX3OoILr7InADlq1ZJPtWWpDrjgNN8HBQUBn8lIaymSaXSRx4I5jD74g5GzMUB4Vis99wcowjQXdhoLn1yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989467; c=relaxed/simple;
	bh=HO2nS9e5yumnBiRIcG2Rxrl7IXs3SEM+FOvSNOffi1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGiJF/LJr8fp7Ct+OBE5+S74BhM8iFnxET72YmCIhqMGA7LLB6Kd3Qt8mAmEFScrmimFyVZ5nC6xzC8Xpu19pT/TRpWppGJPJc/Oexp4OaFjwredJEWX1DLwBTusY6bI8lhcWG+9ipMmllmwp7mVAoVB+ETBEgURmEkBz94Zqyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CSu2xVkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CSu2xVkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410C9C4CEE0;
	Wed, 19 Feb 2025 18:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989467;
	bh=HO2nS9e5yumnBiRIcG2Rxrl7IXs3SEM+FOvSNOffi1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSu2xVkcybgK7UX+OY08miKmSSTEajE0z2mWORv/90c59mgDQVOvN8fnWIpDRvgLV
	 Nl0AjxuPq68dKK2DNjb1GHiDL7ujKsZ7E+d5qxqnZhn+R5ar6woyj1I5zPtlf/+S0w
	 9AlSS3mlVUZ0MzfAl/JyJvX9PAarjtPmI6k68m7RMR97gCQHHgyqKg5XpVeM7IqU63
	 j4d7fSR59bc5i5aDZSEslV4DHXuFpkw9KVm7mDwLNOGAR4BYfjOkPFLti6WTj3mDPi
	 WtZ17QKfSupObXw1Jm1dJZIOlBydGSexOKoCckmRmjHrJTOEIC2HLUUUfRWULmnKw6
	 /OFpGnWnAwuRg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v3 01/19] crypto: scatterwalk - move to next sg entry just in time
Date: Wed, 19 Feb 2025 10:23:23 -0800
Message-ID: <20250219182341.43961-2-ebiggers@kernel.org>
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
index 32fc4473175b1..924efbaefe67a 100644
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
2.48.1

