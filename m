Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399C719882F;
	Mon, 30 Dec 2024 00:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517763; cv=none; b=j77ioStkYkWm2d35FJr6R2BJ36C6DDhWhMk34tSg1A8jpoUthV4f5GuBW+VtpNkk5Ls819h7UisqY/uUjUK4w4dJpys0nVRseGrMDnzQdCDxIm7SOkHkgukAoPEUv74UL9x6QI2FMiZsjzjZWBpyoLl7iy+kL0j4jryDmJCrWgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517763; c=relaxed/simple;
	bh=Aca6uPsUCVLdX4GRY5oc+9eRqWCqEIgCJje21Fl6qos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAmDrLfs79xjxS97qe8R8h345NV+M/V2hGrshgwSb1UJwteoG4xnmJnccJh+SAxAFOJiVwb2pw+BlycJWwmyzIYk4GvDw8CUlkromPpmCmrqVZr7YqkVViQFwByUiPWmUI8kaRiQQVuCUYePOpirg9V75V4nDTzFBoLvduOxYPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IaqQTqpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IaqQTqpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B224CC4CED7;
	Mon, 30 Dec 2024 00:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517762;
	bh=Aca6uPsUCVLdX4GRY5oc+9eRqWCqEIgCJje21Fl6qos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaqQTqprjEebzD3/APWUfCv730v52GNpEKc3mhF1u2/UbChVtIT3twHh5P+t8zDVI
	 nk5lCqsKkOxkxvrIDUDsDK3MRuwchANaeymOiIFYGcebqYDCS5UwNkaZAcH1x4Anvw
	 owynb3sn7ml9iLVL8FydhgWL8AFLPAvv7TmroPwRaDChh6kRhP25514uIn/kNubFBc
	 VzFPfOdubPh7brwHWto3LPUHizBH70XlcQv4R9n4SLzBtX3XJU+00PS6Nxb6FwIdWl
	 KPhqu4RL5LLq0w84CvcSHVbfki6lt+RXRlAPuYyAlgVOwQchtItNKG4YUedWLN/WLe
	 zRta/MpzNMuOQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/29] crypto: scatterwalk - add new functions for skipping data
Date: Sun, 29 Dec 2024 16:14:01 -0800
Message-ID: <20241230001418.74739-13-ebiggers@kernel.org>
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

Add scatterwalk_skip() to skip the given number of bytes in a
scatter_walk.  Previously support for skipping was provided through
scatterwalk_copychunks(..., 2) followed by scatterwalk_done(), which was
confusing and less efficient.

Also add scatterwalk_start_at_pos() which starts a scatter_walk at the
given position, equivalent to scatterwalk_start() + scatterwalk_skip().
This addresses another common need in a more streamlined way.

Later patches will convert various users to use these functions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/scatterwalk.c         | 15 +++++++++++++++
 include/crypto/scatterwalk.h | 18 ++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 16f6ba896fb6..af436ad02e3f 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -13,10 +13,25 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 
+void scatterwalk_skip(struct scatter_walk *walk, unsigned int nbytes)
+{
+	struct scatterlist *sg = walk->sg;
+
+	nbytes += walk->offset - sg->offset;
+
+	while (nbytes > sg->length) {
+		nbytes -= sg->length;
+		sg = sg_next(sg);
+	}
+	walk->sg = sg;
+	walk->offset = sg->offset + nbytes;
+}
+EXPORT_SYMBOL_GPL(scatterwalk_skip);
+
 static inline void memcpy_dir(void *buf, void *sgdata, size_t nbytes, int out)
 {
 	void *src = out ? buf : sgdata;
 	void *dst = out ? sgdata : buf;
 
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 924efbaefe67..5c7765f601e0 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -31,10 +31,26 @@ static inline void scatterwalk_start(struct scatter_walk *walk,
 {
 	walk->sg = sg;
 	walk->offset = sg->offset;
 }
 
+/*
+ * This is equivalent to scatterwalk_start(walk, sg) followed by
+ * scatterwalk_skip(walk, pos).
+ */
+static inline void scatterwalk_start_at_pos(struct scatter_walk *walk,
+					    struct scatterlist *sg,
+					    unsigned int pos)
+{
+	while (pos > sg->length) {
+		pos -= sg->length;
+		sg = sg_next(sg);
+	}
+	walk->sg = sg;
+	walk->offset = sg->offset + pos;
+}
+
 static inline unsigned int scatterwalk_pagelen(struct scatter_walk *walk)
 {
 	unsigned int len = walk->sg->offset + walk->sg->length - walk->offset;
 	unsigned int len_this_page = offset_in_page(~walk->offset) + 1;
 	return len_this_page > len ? len : len_this_page;
@@ -90,10 +106,12 @@ static inline void scatterwalk_done(struct scatter_walk *walk, int out,
 	if (!more || walk->offset >= walk->sg->offset + walk->sg->length ||
 	    !(walk->offset & (PAGE_SIZE - 1)))
 		scatterwalk_pagedone(walk, out, more);
 }
 
+void scatterwalk_skip(struct scatter_walk *walk, unsigned int nbytes);
+
 void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 			    size_t nbytes, int out);
 
 void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 			      unsigned int start, unsigned int nbytes, int out);
-- 
2.47.1

