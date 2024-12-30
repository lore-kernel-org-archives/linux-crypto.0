Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF441A8411;
	Mon, 30 Dec 2024 00:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517769; cv=none; b=rILCd4lJHG1eNmxu96LP/CuhA6UxZaDF2x5EDEBLoIRZh9JSfFnsbkaBqfe4d1FGwB/DFq9Rmn7Sm6DxPNlOTnTw/cNz0v9pFJJUFnqs1ICaboCNsR7GNW6+hguFWkG8c7T8qX0d+dEIFH85nGytjds3BXadx59R03Lsoe0YHn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517769; c=relaxed/simple;
	bh=pMrTGKnRhvoJeyHAUlKFSPsItxe+R2jmbyf6RObZplM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPcLkGwZw47F/dPbJqPykL5DMqkSbplYPp1/ZJo1UDyCJotb7SDwX1txsQIHcSqeKrIpzvJmqDMUviXDHY74Ij95Pj+ORxMASxlNgXZ2PeE6yhgZNeeugVV6LVQ6FwXBwkcw5DNe+7A3YU0lJwx2OpwA+KcvyEVdWN0vy9ezt+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j43P1jYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j43P1jYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62FDC4CEDC;
	Mon, 30 Dec 2024 00:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517768;
	bh=pMrTGKnRhvoJeyHAUlKFSPsItxe+R2jmbyf6RObZplM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j43P1jYLNwozTAxRKkOgNrcVDZOpRlOgVajvZusCTpMbHeUq1irw/uz8v6ENkXYC4
	 8c1s4cvnItiCoA1dRuG7UaQl05bzs4AELaX312Bpeyg0esmTtGaoKbCnxvfAPL4pPz
	 J/oWgmQDfFBN02jdyHtgCWFI9p+rwMEHuwzFCub+ih4KLuMAIYhfVseIPK704VYJ1K
	 SruQxkn9rE/0vFy7i55ZU3Ndddv9kcNUKHIEsh/0J6oQQIfULPyUGCWVzcPw9RlyoN
	 YS1b5NN60T+rfHozm8xPjQbNiMrGeA0jMwDx+N5euiX3bhSdxdKgJgLxzxG+1EIPyc
	 NcTzzu1K+h/Zg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 28/29] crypto: scatterwalk - remove obsolete functions
Date: Sun, 29 Dec 2024 16:14:17 -0800
Message-ID: <20241230001418.74739-29-ebiggers@kernel.org>
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
index f6262d05a3c7..ac03fdf88b2a 100644
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
2.47.1

