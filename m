Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1266F21B9DE;
	Wed, 19 Feb 2025 18:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989472; cv=none; b=lAAGTYsFo35m7+EqhsgaFz8VmwEAaxOTT75DotCcaQEtDHmv/FPrt1c/oSnj/TLPPtPwRS+PybCeHz+BPUA5s4r4ulPj1F65L4ev1y13FOqcKZdOqQ1lj+EJafLtp/XSPCeL4VFzAHZpc31mYkzkoCW3FXoJjozfpIuZznx7bic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989472; c=relaxed/simple;
	bh=O7RPYfjnYfLaOxt45Eob56Z/zyh6ZSMPzVlUtammgZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1H75hAhY27FiU6ARb0fmkTcjXz2SuF/WKmgHoKtK63oblDfu4XpBNa5mea8zO3LcS4nP+YMYVAYqx4wbjP/tJ/vRhFbMBsaJ4i5HFLwvKNUohXLPG5krAw4eeSzEp6x6sxnDDmFyQs0B0Xy21tjKWzOYWWu5+pB0hwD5KoWFy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9UEEboq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9UEEboq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE845C4CEE0;
	Wed, 19 Feb 2025 18:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989471;
	bh=O7RPYfjnYfLaOxt45Eob56Z/zyh6ZSMPzVlUtammgZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9UEEboq4ARdzWf1aAgGNsYR0NOLiOiwrmEv50htPRV1RE+WhWZJsoJAtFG1cAYZ5
	 6vde5N4B/P0tUwgAv1RQ98ORJMVBaS4S7oHG7OyXHsDXHRjbK0cL8owJ+g9GS3H8zP
	 fRSI0JOuURqk37CdqSJ5A+0TfZYIn4bPtVfWWI5xq5abogtvemgp+rIyFyr4l9HPbI
	 +QfJi4169ZZd0Jhr7uYZeJlcpk4OLCwQdXqRTHFyw8zpEzRUwvf5OcUBVqR7TOipPS
	 A8W5I8bu+y7wtsxkVcc1CNnY2G2TtN7zYxJkMBCikdlcu60ywnvtnLzpYAvNSMc7QA
	 9ccan5zgiIT6A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v3 17/19] crypto: skcipher - use the new scatterwalk functions
Date: Wed, 19 Feb 2025 10:23:39 -0800
Message-ID: <20250219182341.43961-18-ebiggers@kernel.org>
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
index 33508d001f361..0a78a96d8583d 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -47,20 +47,10 @@ static inline void skcipher_map_src(struct skcipher_walk *walk)
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
 
@@ -68,18 +58,10 @@ static inline struct skcipher_alg *__crypto_skcipher_alg(
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
@@ -110,44 +92,45 @@ int skcipher_walk_done(struct skcipher_walk *walk, int res)
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
@@ -190,11 +173,11 @@ static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
 		walk->buffer = buffer;
 	}
 	walk->dst.virt.addr = PTR_ALIGN(buffer, alignmask + 1);
 	walk->src.virt.addr = walk->dst.virt.addr;
 
-	scatterwalk_copychunks(walk->src.virt.addr, &walk->in, bsize, 0);
+	memcpy_from_scatterwalk(walk->src.virt.addr, &walk->in, bsize);
 
 	walk->nbytes = bsize;
 	walk->flags |= SKCIPHER_WALK_SLOW;
 
 	return 0;
@@ -204,11 +187,15 @@ static int skcipher_next_copy(struct skcipher_walk *walk)
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
2.48.1

