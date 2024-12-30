Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50701A840C;
	Mon, 30 Dec 2024 00:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517769; cv=none; b=F4u3dZnqfM/paerTQCcyKGCAe3qHCCM4nVq72/cLnL3MXMmsn01uq3F/qr4Vq5we4JHWfLzp2vhVyp6NutQUMCifXWdYY7WXuD/ljOub/JnJnIrH5X9yvbXPHCtqUG2jfiCja1mJ2E5QMRBVIuCrpv1yyOi4+OmD+fI+GEYpNns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517769; c=relaxed/simple;
	bh=9+aJ/7IU1xoI3FM4cnTH4BXwVQl9uMeigli+J8RUP4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i62b0seDsoi8cy9cqc9QNchpJ8yqo4fVb+JI1CfFYFo+UbyoO4KDOFIhJ4LtHw0R/XafXC2Y8crThitzgHyEqsBMiYdo+u2Yaj8+X6z2LX0H0WBuKKTjk+2f5q/so61Q9LRS1ulzawWB3t59UEysboWkImxHPIU3b+3jwBYsaVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p/oa3Z9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p/oa3Z9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769EFC4CED1;
	Mon, 30 Dec 2024 00:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517768;
	bh=9+aJ/7IU1xoI3FM4cnTH4BXwVQl9uMeigli+J8RUP4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/oa3Z9Et7ds2XrJW44o0AsYO6FdUgAqMWzZTTNEUqMlALdh71a5+Ol4b6JbuRlu6
	 AvNEbDQzhAWASmt9vnzAWq7bmGrOv2BM6cOv4b3PsgIFLGTs4wQ3249oLfSay4qw/M
	 vUpqj9Wr5gaCSISTv1pkIBQgAvxNTP+TLoAb6kyovWk8B4erX2r29V2S19b6FE33Gx
	 ExUawssLiX5oHZ+DugMEos1gRBttlOrvdcbGf9UX1lwbYVnyT5goUxY0q+FHTPbHyO
	 xEEBYOAnIN56Nenkb9SNjPkjFf/WjagN1VzXW09c276Y4wQr4pkZIFFxsF2/OFKVlY
	 HIL6hObTgePxw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 27/29] crypto: skcipher - use the new scatterwalk functions
Date: Sun, 29 Dec 2024 16:14:16 -0800
Message-ID: <20241230001418.74739-28-ebiggers@kernel.org>
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

