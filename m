Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E4A199E88
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 06:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741241278; cv=none; b=cp0ytd90BfCGJKsmpXbbyxdT8S47aZu0CkIggMgA4gboc6fuuMlzAZxsUZIYqupQJyc4A7w3MAPmPHOUypdNv9an8+xu+h/FIR1kgNb6cJlBuJgno2PsnLg4SQkE3t0HzhmD7NKFrl1oJLeWv/ehQjz9qz887+nPij+Fv3OH+YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741241278; c=relaxed/simple;
	bh=DkhfeFLHsV8fbjSZHedkDY98bbqzTOiXHxWB3YLTSjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ePSfZ8yCOyWlWsg7xOpfiL3uTp6e2VNEBxx3lWxD46U8MJV/H0Y1qjLpkUBUC/bChT23B+Lx/hE5TM3GHSZ9ZGFvMzYYSV9uE4C2YOqDAjfmp5w+eQbUBqcuVrhYvIDdXoFuYEc6FQ4HYhX3yxH5blGl6hCweYshy+CA0uFbVGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HHZ8Xw+6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HHZ8Xw+6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1sehrQsheJ8zaitYN+gmeL6uVPU0ZvErNNK57LYQ8Rg=; b=HHZ8Xw+61QHnWO8UztIUl0Y+qY
	L7Soj5Ls07MGL+H1tTShMF80tgsg2pkTkBK9VxC/NlYC3QofgW1z9DETtBRIkreQqGTMisNWKibg5
	g8lPHAu1cs0zvycyR2tKUMuIO+RIcMQe/K1zpI9GnNRpwl/TV+wfRVSqviVWzAdRBEFNOJjUYKA4f
	EC7isK1/E1LgBs5QJPtQ+G9MhmOWXNWXiY+foVykTBmL/1pxNEM3emLnkx96hw15KiuV+8Tbr/5LR
	LrVu5eqmgNV6LSdGO/8p6HJShDSwd5urZ0ZIpi/gejkJwRBbToYSM46mbMdbf+Z5LqpFYQPIaaGJ0
	s/AYj+Tg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tq4Od-004BjW-00;
	Thu, 06 Mar 2025 14:07:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Mar 2025 14:07:50 +0800
Date: Thu, 6 Mar 2025 14:07:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: skcipher - Elinimate duplicate virt.addr field
Message-ID: <Z8k7ttZ7PwjBC-AS@gondor.apana.org.au>
References: <Z8kOABHrceBW7EiK@gondor.apana.org.au>
 <20250306031005.GB1592@sol.localdomain>
 <Z8kT90qXaTo15271@gondor.apana.org.au>
 <20250306033658.GD1592@sol.localdomain>
 <Z8kZL2WlWX-KhkqR@gondor.apana.org.au>
 <20250306035937.GA1153@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306035937.GA1153@sol.localdomain>

On Wed, Mar 05, 2025 at 07:59:37PM -0800, Eric Biggers wrote:
>
> I don't think it will be quite that simple, since the skcipher_walk code relies
> on the different parts being split up so that it can do things like calculate
> the length before it starts mapping anything.  If you can make it work, we can
> do that.  But until that additional patch is ready I don't think it makes sense
> to merge this one, as it leaves things half-baked with the redundant pointers.

Sure, fixing it might not be easy, partly because the new interface
wasn't designed for its needs.

But getting rid of the duplicate field isn't hard, because we're
already assuming that the user does not modify walk->XXX.virt.addr,
at least not far enough to break the unmap (see the WALK_DIFF
clause).  In fact, grepping through the arch code seems to show
that nobody actually modifies them at all.  So we could even
simplify the WALK_SLOW done path.

---8<---
Reuse the addr field from struct scatter_walk for skcipher_walk.
In order to maintain backwards compatibility with existing users,
retain the original virt.addr fields through unions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/skcipher.c                  | 25 ++++++++++---------------
 include/crypto/algapi.h            |  3 ++-
 include/crypto/internal/skcipher.h | 20 +++++++++++++++-----
 3 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index d321c8746950..f770307abb8e 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -43,14 +43,12 @@ static inline void skcipher_map_src(struct skcipher_walk *walk)
 {
 	/* XXX */
 	walk->in.addr = scatterwalk_map(&walk->in);
-	walk->src.virt.addr = walk->in.addr;
 }
 
 static inline void skcipher_map_dst(struct skcipher_walk *walk)
 {
 	/* XXX */
 	walk->out.addr = scatterwalk_map(&walk->out);
-	walk->dst.virt.addr = walk->out.addr;
 }
 
 static inline gfp_t skcipher_walk_gfp(struct skcipher_walk *walk)
@@ -100,8 +98,7 @@ int skcipher_walk_done(struct skcipher_walk *walk, int res)
 				    SKCIPHER_WALK_DIFF)))) {
 		scatterwalk_advance(&walk->in, n);
 	} else if (walk->flags & SKCIPHER_WALK_DIFF) {
-		scatterwalk_unmap(walk->src.virt.addr);
-		scatterwalk_advance(&walk->in, n);
+		scatterwalk_done_src(&walk->in, n);
 	} else if (walk->flags & SKCIPHER_WALK_COPY) {
 		scatterwalk_advance(&walk->in, n);
 		skcipher_map_dst(walk);
@@ -116,11 +113,8 @@ int skcipher_walk_done(struct skcipher_walk *walk, int res)
 			 */
 			res = -EINVAL;
 			total = 0;
-		} else {
-			u8 *buf = PTR_ALIGN(walk->buffer, walk->alignmask + 1);
-
-			memcpy_to_scatterwalk(&walk->out, buf, n);
-		}
+		} else
+			memcpy_to_scatterwalk(&walk->out, walk->out.addr, n);
 		goto dst_done;
 	}
 
@@ -176,10 +170,11 @@ static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
 			return skcipher_walk_done(walk, -ENOMEM);
 		walk->buffer = buffer;
 	}
-	walk->dst.virt.addr = PTR_ALIGN(buffer, alignmask + 1);
-	walk->src.virt.addr = walk->dst.virt.addr;
 
-	memcpy_from_scatterwalk(walk->src.virt.addr, &walk->in, bsize);
+	buffer = PTR_ALIGN(buffer, alignmask + 1);
+	memcpy_from_scatterwalk(buffer, &walk->in, bsize);
+	walk->out.addr = buffer;
+	walk->in.addr = walk->out.addr;
 
 	walk->nbytes = bsize;
 	walk->flags |= SKCIPHER_WALK_SLOW;
@@ -199,8 +194,8 @@ static int skcipher_next_copy(struct skcipher_walk *walk)
 	 * processed (which might be less than walk->nbytes) is known.
 	 */
 
-	walk->src.virt.addr = tmp;
-	walk->dst.virt.addr = tmp;
+	walk->in.addr = tmp;
+	walk->out.addr = tmp;
 	return 0;
 }
 
@@ -214,7 +209,7 @@ static int skcipher_next_fast(struct skcipher_walk *walk)
 		(u8 *)(sg_page(walk->out.sg) + (walk->out.offset >> PAGE_SHIFT));
 
 	skcipher_map_src(walk);
-	walk->dst.virt.addr = walk->src.virt.addr;
+	walk->out.addr = walk->in.addr;
 
 	if (diff) {
 		walk->flags |= SKCIPHER_WALK_DIFF;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 41733a0b45dd..94147ea8c14d 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -120,9 +120,10 @@ struct crypto_queue {
 };
 
 struct scatter_walk {
+	/* Must be the first member, see struct skcipher_walk. */
+	void *addr;
 	struct scatterlist *sg;
 	unsigned int offset;
-	void *addr;
 };
 
 struct crypto_attr_alg {
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index d6ae7a86fed2..357441b56c1e 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -57,14 +57,24 @@ struct crypto_lskcipher_spawn {
 struct skcipher_walk {
 	union {
 		struct {
-			void *addr;
-		} virt;
-	} src, dst;
+			struct {
+				void *const addr;
+			} virt;
+		} src;
+		struct scatter_walk in;
+	};
 
-	struct scatter_walk in;
 	unsigned int nbytes;
 
-	struct scatter_walk out;
+	union {
+		struct {
+			struct {
+				void *const addr;
+			} virt;
+		} dst;
+		struct scatter_walk out;
+	};
+
 	unsigned int total;
 
 	u8 *page;
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
