Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CFE22D799
	for <linux-crypto@vger.kernel.org>; Mon, 10 Mar 2025 17:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627259; cv=none; b=mz1+hUxbotF+5R+WRvr2f2V0L/OPpqB9Wyu06rmNGxufTG515wZdMvEc25jFchHTxLrbDGFCY5Uy3zVCIo0yAYno6uCI2dZjQ0cJon06q6DKT3xPNqtjSjEAz6mdu2X22nywT9fPwtzutNKwVlKwAB0GB7X2dSzwK1zn0TpjdNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627259; c=relaxed/simple;
	bh=ck2Zs9k6retj01HzdPrax2O4vutIxjN7DwB62FYyLqY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=O0mi6CbwL2AmYcgXGQ+VmQUkQa90OkRUbivtFgFbyFoY2Hhkb8xPhKdlnIQUU0j+3A9u4uQKVadNKX3z3rrYS6+XMX7aGnH3JRgsbR4CZ+ZKXxqu4xedfxTxgHjK4EXxq+PQWeAUJRY++bxu+In4HnhhBnavYbUNZq3TEeP/Yl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rTUsXzmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rTUsXzmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D46BC4CEE5
	for <linux-crypto@vger.kernel.org>; Mon, 10 Mar 2025 17:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741627259;
	bh=ck2Zs9k6retj01HzdPrax2O4vutIxjN7DwB62FYyLqY=;
	h=From:To:Subject:Date:From;
	b=rTUsXzmqZzJAG6U8ewkTB1A99glJpxTW94IbPIF4iuM/VhPGtC5JqBM50RZp628cb
	 WBeFYimU9Z5jjio8YAfJZFbPZouD004Cxe9iuIrMrjojAwnIJ4SoxDsnktrqH1HOLT
	 1ky5xdAfN7ChcOgwP7CvYUcHBSszmcUJa1aavWhpqAmi6EirJDjRfnahY2T27Hlisp
	 5C1fkWNIlXvZBC/7cmbUKmqKaXAIfLmA5mj8aPCoc+NN3fW2Ds7fIWl8gjjr7qTzx9
	 myxLe5TgPXn5F8UbUFoLNffROPMhGLelv+vkMw7BAntqFK9yEG/gX+d4cad+9a9AiO
	 JcPzA6hlB9cqQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: scatterwalk - simplify map and unmap calling convention
Date: Mon, 10 Mar 2025 10:20:16 -0700
Message-ID: <20250310172016.153423-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Now that the address returned by scatterwalk_map() is always being
stored into the same struct scatter_walk that is passed in, make
scatterwalk_map() do so itself and return void.

Similarly, now that scatterwalk_unmap() is always being passed the
address field within a struct scatter_walk, make scatterwalk_unmap()
take a pointer to struct scatter_walk instead of the address directly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/s390/crypto/aes_s390.c  |  3 +--
 crypto/skcipher.c            | 28 +++++++----------------
 include/crypto/scatterwalk.h | 43 ++++++++++++++++++++----------------
 3 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index ed85bd6e298f5..5d36f4020dfa3 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -869,12 +869,11 @@ static int gcm_out_walk_go(struct gcm_sg_walk *gw, unsigned int minbytesneeded)
 		gw->ptr = gw->walk.addr;
 		gw->nbytes = gw->walk_bytes;
 		goto out;
 	}
 
-	/* XXX */
-	scatterwalk_unmap(gw->walk.addr);
+	scatterwalk_unmap(&gw->walk);
 
 	gw->ptr = gw->buf;
 	gw->nbytes = sizeof(gw->buf);
 
 out:
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index ab5d852febcde..132075a905d99 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -37,22 +37,10 @@ enum {
 
 static const struct crypto_type crypto_skcipher_type;
 
 static int skcipher_walk_next(struct skcipher_walk *walk);
 
-static inline void skcipher_map_src(struct skcipher_walk *walk)
-{
-	/* XXX */
-	walk->in.__addr = scatterwalk_map(&walk->in);
-}
-
-static inline void skcipher_map_dst(struct skcipher_walk *walk)
-{
-	/* XXX */
-	walk->out.__addr = scatterwalk_map(&walk->out);
-}
-
 static inline gfp_t skcipher_walk_gfp(struct skcipher_walk *walk)
 {
 	return walk->flags & SKCIPHER_WALK_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 }
 
@@ -99,12 +87,12 @@ int skcipher_walk_done(struct skcipher_walk *walk, int res)
 		scatterwalk_advance(&walk->in, n);
 	} else if (walk->flags & SKCIPHER_WALK_DIFF) {
 		scatterwalk_done_src(&walk->in, n);
 	} else if (walk->flags & SKCIPHER_WALK_COPY) {
 		scatterwalk_advance(&walk->in, n);
-		skcipher_map_dst(walk);
-		memcpy(walk->dst.virt.addr, walk->page, n);
+		scatterwalk_map(&walk->out);
+		memcpy(walk->out.addr, walk->page, n);
 	} else { /* SKCIPHER_WALK_SLOW */
 		if (res > 0) {
 			/*
 			 * Didn't process all bytes.  Either the algorithm is
 			 * broken, or this was the last step and it turned out
@@ -184,13 +172,13 @@ static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
 
 static int skcipher_next_copy(struct skcipher_walk *walk)
 {
 	void *tmp = walk->page;
 
-	skcipher_map_src(walk);
-	memcpy(tmp, walk->src.virt.addr, walk->nbytes);
-	scatterwalk_unmap(walk->src.virt.addr);
+	scatterwalk_map(&walk->in);
+	memcpy(tmp, walk->in.addr, walk->nbytes);
+	scatterwalk_unmap(&walk->in);
 	/*
 	 * walk->in is advanced later when the number of bytes actually
 	 * processed (which might be less than walk->nbytes) is known.
 	 */
 
@@ -206,16 +194,16 @@ static int skcipher_next_fast(struct skcipher_walk *walk)
 	diff = offset_in_page(walk->in.offset) -
 	       offset_in_page(walk->out.offset);
 	diff |= (u8 *)(sg_page(walk->in.sg) + (walk->in.offset >> PAGE_SHIFT)) -
 		(u8 *)(sg_page(walk->out.sg) + (walk->out.offset >> PAGE_SHIFT));
 
-	skcipher_map_dst(walk);
-	walk->in.__addr = walk->dst.virt.addr;
+	scatterwalk_map(&walk->out);
+	walk->in.__addr = walk->out.__addr;
 
 	if (diff) {
 		walk->flags |= SKCIPHER_WALK_DIFF;
-		skcipher_map_src(walk);
+		scatterwalk_map(&walk->in);
 	}
 
 	return 0;
 }
 
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index c62f47d04eb10..b7e617ae44427 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -95,27 +95,32 @@ static inline void scatterwalk_get_sglist(struct scatter_walk *walk,
 		    walk->sg->offset + walk->sg->length - walk->offset,
 		    walk->offset);
 	scatterwalk_crypto_chain(sg_out, sg_next(walk->sg), 2);
 }
 
-static inline void *scatterwalk_map(struct scatter_walk *walk)
+static inline void scatterwalk_map(struct scatter_walk *walk)
 {
 	struct page *base_page = sg_page(walk->sg);
 
-	if (IS_ENABLED(CONFIG_HIGHMEM))
-		return kmap_local_page(base_page + (walk->offset >> PAGE_SHIFT)) +
-		       offset_in_page(walk->offset);
-	/*
-	 * When !HIGHMEM we allow the walker to return segments that span a page
-	 * boundary; see scatterwalk_clamp().  To make it clear that in this
-	 * case we're working in the linear buffer of the whole sg entry in the
-	 * kernel's direct map rather than within the mapped buffer of a single
-	 * page, compute the address as an offset from the page_address() of the
-	 * first page of the sg entry.  Either way the result is the address in
-	 * the direct map, but this makes it clearer what is really going on.
-	 */
-	return page_address(base_page) + walk->offset;
+	if (IS_ENABLED(CONFIG_HIGHMEM)) {
+		walk->__addr = kmap_local_page(base_page +
+					       (walk->offset >> PAGE_SHIFT)) +
+			       offset_in_page(walk->offset);
+	} else {
+		/*
+		 * When !HIGHMEM we allow the walker to return segments that
+		 * span a page boundary; see scatterwalk_clamp().  To make it
+		 * clear that in this case we're working in the linear buffer of
+		 * the whole sg entry in the kernel's direct map rather than
+		 * within the mapped buffer of a single page, compute the
+		 * address as an offset from the page_address() of the first
+		 * page of the sg entry.  Either way the result is the address
+		 * in the direct map, but this makes it clearer what is really
+		 * going on.
+		 */
+		walk->__addr = page_address(base_page) + walk->offset;
+	}
 }
 
 /**
  * scatterwalk_next() - Get the next data buffer in a scatterlist walk
  * @walk: the scatter_walk
@@ -130,18 +135,18 @@ static inline void *scatterwalk_map(struct scatter_walk *walk)
 static inline unsigned int scatterwalk_next(struct scatter_walk *walk,
 					    unsigned int total)
 {
 	unsigned int nbytes = scatterwalk_clamp(walk, total);
 
-	walk->__addr = scatterwalk_map(walk);
+	scatterwalk_map(walk);
 	return nbytes;
 }
 
-static inline void scatterwalk_unmap(const void *vaddr)
+static inline void scatterwalk_unmap(struct scatter_walk *walk)
 {
 	if (IS_ENABLED(CONFIG_HIGHMEM))
-		kunmap_local(vaddr);
+		kunmap_local(walk->__addr);
 }
 
 static inline void scatterwalk_advance(struct scatter_walk *walk,
 				       unsigned int nbytes)
 {
@@ -157,11 +162,11 @@ static inline void scatterwalk_advance(struct scatter_walk *walk,
  * Use this if the mapped address was not written to, i.e. it is source data.
  */
 static inline void scatterwalk_done_src(struct scatter_walk *walk,
 					unsigned int nbytes)
 {
-	scatterwalk_unmap(walk->addr);
+	scatterwalk_unmap(walk);
 	scatterwalk_advance(walk, nbytes);
 }
 
 /**
  * scatterwalk_done_dst() - Finish one step of a walk of destination scatterlist
@@ -173,11 +178,11 @@ static inline void scatterwalk_done_src(struct scatter_walk *walk,
  * destination data.
  */
 static inline void scatterwalk_done_dst(struct scatter_walk *walk,
 					unsigned int nbytes)
 {
-	scatterwalk_unmap(walk->addr);
+	scatterwalk_unmap(walk);
 	/*
 	 * Explicitly check ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE instead of just
 	 * relying on flush_dcache_page() being a no-op when not implemented,
 	 * since otherwise the BUG_ON in sg_page() does not get optimized out.
 	 * This also avoids having to consider whether the loop would get

base-commit: eca6828403b80343647de39d4782ee56cc9e36dd
prerequisite-patch-id: 2ea677b85c3108d6431e6b873b161c2c119071ad
prerequisite-patch-id: 53dd3a1a8327e9f4301e21502f2cba5ef4808b4a
prerequisite-patch-id: 45b81fdd96514ba844b8b3fec2130bd287540f99
-- 
2.48.1

