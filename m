Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4ED1F2C44
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772296; cv=none; b=VuG4Amjgs1TR0XlCNYHlpbK2GqBcaXY+cWPuCj9zxx+N0NtqHUYWNwhmA+EWDqQ2Hv4YgLYINA/4B8IIbEPDqPUV4bcZI5nrZV1pKZZIdy7I/kRKRiSjHuDPwBgrTtII9u8LMLmg8anc11mZA43Vyj8q1h0YoPGNzd/XD4OBNIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772296; c=relaxed/simple;
	bh=9+aJ/7IU1xoI3FM4cnTH4BXwVQl9uMeigli+J8RUP4E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQvUMegogU4APHbzLjeN/x2RdfFMxk3DJs005bYxLEURdPKZwPFwgm6qyOCSLFIwGPrPkjlai6YQvZm5Nv+7FYJhOdqwB4FaZi5p2N14dmYAM9EZhfoJPJW2PZps/0s2qP3lkoCTxLOCWMxLF5qSMFHth17/X416d9M9qCNNmHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lhBoTlRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhBoTlRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC64C4CED6
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772296;
	bh=9+aJ/7IU1xoI3FM4cnTH4BXwVQl9uMeigli+J8RUP4E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lhBoTlRP9jpOHUstQWB5i0+2vxFrOn03vMLOskm2M53BK1wSNr6Hsn4kciTV2aQGh
	 NVsejg5LnaT2mberCS30mt1NOEkjIwR3I0vLn1kgqjeMjcfp5P9J63TNN1BhBw30No
	 gt1RvGR+grDCNWFOP8et/4ivOfn/RAwITGhsFx+qqxwVYAnk0H3dxmAFaSR+Bs5Mu0
	 /E53M00H2gYlhjQoEScCHlpuYsUi8gvKy6v4GjdxyHPDp0xYxRoZJCCNbL2unTZgy0
	 P27ZJIsvrjGPa6sg/L6UbBmydXFX04GM/EW/qmO3IMBLrG4kQBG0iBP9WCLTJGpv02
	 lCqXgjK9urxbQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 27/29] crypto: skcipher - use the new scatterwalk functions
Date: Sat, 21 Dec 2024 01:10:54 -0800
Message-ID: <20241221091056.282098-28-ebiggers@kernel.org>
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

Convert skcipher_walk to use the new scatterwalk functions.

This includes a few changes to exactly where the different parts of the
iteration happen.  For example the dcache flush that previously happened
in scatterwalk_done() now happens in scatterwalk_dst_done() or in
memcpy_to_scatterwalk().  Advancing to the next sg entry now happens
just-in-time in scatterwalk_clamp() instead of in scatterwalk_done().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 51 ++++++++++++++++++-----------------------------
 1 file changed, 19 insertions(+), 32 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 7abafe385fd5..8f6b09377368 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -46,20 +46,10 @@ static inline void skcipher_map_src(struct skcipher_walk *walk)
 static inline void skcipher_map_dst(struct skcipher_walk *walk)
 {
 	walk->dst.virt.addr = scatterwalk_map(&walk->out);
 }
 
-static inline void skcipher_unmap_src(struct skcipher_walk *walk)
-{
-	scatterwalk_unmap(walk->src.virt.addr);
-}
-
-static inline void skcipher_unmap_dst(struct skcipher_walk *walk)
-{
-	scatterwalk_unmap(walk->dst.virt.addr);
-}
-
 static inline gfp_t skcipher_walk_gfp(struct skcipher_walk *walk)
 {
 	return walk->flags & SKCIPHER_WALK_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 }
 
@@ -67,18 +57,10 @@ static inline struct skcipher_alg *__crypto_skcipher_alg(
 	struct crypto_alg *alg)
 {
 	return container_of(alg, struct skcipher_alg, base);
 }
 
-static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
-{
-	u8 *addr = PTR_ALIGN(walk->buffer, walk->alignmask + 1);
-
-	scatterwalk_copychunks(addr, &walk->out, bsize, 1);
-	return 0;
-}
-
 /**
  * skcipher_walk_done() - finish one step of a skcipher_walk
  * @walk: the skcipher_walk
  * @res: number of bytes *not* processed (>= 0) from walk->nbytes,
  *	 or a -errno value to terminate the walk due to an error
@@ -109,44 +91,45 @@ int skcipher_walk_done(struct skcipher_walk *walk, int res)
 	}
 
 	if (likely(!(walk->flags & (SKCIPHER_WALK_SLOW |
 				    SKCIPHER_WALK_COPY |
 				    SKCIPHER_WALK_DIFF)))) {
-unmap_src:
-		skcipher_unmap_src(walk);
+		scatterwalk_advance(&walk->in, n);
 	} else if (walk->flags & SKCIPHER_WALK_DIFF) {
-		skcipher_unmap_dst(walk);
-		goto unmap_src;
+		scatterwalk_unmap(walk->src.virt.addr);
+		scatterwalk_advance(&walk->in, n);
 	} else if (walk->flags & SKCIPHER_WALK_COPY) {
+		scatterwalk_advance(&walk->in, n);
 		skcipher_map_dst(walk);
 		memcpy(walk->dst.virt.addr, walk->page, n);
-		skcipher_unmap_dst(walk);
 	} else { /* SKCIPHER_WALK_SLOW */
 		if (res > 0) {
 			/*
 			 * Didn't process all bytes.  Either the algorithm is
 			 * broken, or this was the last step and it turned out
 			 * the message wasn't evenly divisible into blocks but
 			 * the algorithm requires it.
 			 */
 			res = -EINVAL;
 			total = 0;
-		} else
-			n = skcipher_done_slow(walk, n);
+		} else {
+			u8 *buf = PTR_ALIGN(walk->buffer, walk->alignmask + 1);
+
+			memcpy_to_scatterwalk(&walk->out, buf, n);
+		}
+		goto dst_done;
 	}
 
+	scatterwalk_done_dst(&walk->out, walk->dst.virt.addr, n);
+dst_done:
+
 	if (res > 0)
 		res = 0;
 
 	walk->total = total;
 	walk->nbytes = 0;
 
-	scatterwalk_advance(&walk->in, n);
-	scatterwalk_advance(&walk->out, n);
-	scatterwalk_done(&walk->in, 0, total);
-	scatterwalk_done(&walk->out, 1, total);
-
 	if (total) {
 		if (walk->flags & SKCIPHER_WALK_SLEEP)
 			cond_resched();
 		walk->flags &= ~(SKCIPHER_WALK_SLOW | SKCIPHER_WALK_COPY |
 				 SKCIPHER_WALK_DIFF);
@@ -189,11 +172,11 @@ static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
 		walk->buffer = buffer;
 	}
 	walk->dst.virt.addr = PTR_ALIGN(buffer, alignmask + 1);
 	walk->src.virt.addr = walk->dst.virt.addr;
 
-	scatterwalk_copychunks(walk->src.virt.addr, &walk->in, bsize, 0);
+	memcpy_from_scatterwalk(walk->src.virt.addr, &walk->in, bsize);
 
 	walk->nbytes = bsize;
 	walk->flags |= SKCIPHER_WALK_SLOW;
 
 	return 0;
@@ -203,11 +186,15 @@ static int skcipher_next_copy(struct skcipher_walk *walk)
 {
 	u8 *tmp = walk->page;
 
 	skcipher_map_src(walk);
 	memcpy(tmp, walk->src.virt.addr, walk->nbytes);
-	skcipher_unmap_src(walk);
+	scatterwalk_unmap(walk->src.virt.addr);
+	/*
+	 * walk->in is advanced later when the number of bytes actually
+	 * processed (which might be less than walk->nbytes) is known.
+	 */
 
 	walk->src.virt.addr = tmp;
 	walk->dst.virt.addr = tmp;
 	return 0;
 }
-- 
2.47.1

