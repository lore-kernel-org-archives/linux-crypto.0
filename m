Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A375192B60
	for <linux-crypto@vger.kernel.org>; Fri,  7 Mar 2025 03:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741318587; cv=none; b=oWxQ660Ro/1qONwJ0alYHIV6UaC0RBKD0M9Wh5JQ0ISSxnOLYbZdZcNEc+hnqsuu9RIU+QhIs32w3zhIja950pidUO1TgMCWzzRV4FSLxG/9y5sSJduVFkYU8sgaQDjpOION76jbi0013fq3+8w9dIj0g4DTZT7XuKeo5XjopXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741318587; c=relaxed/simple;
	bh=Bxz6Lk1accf+fgMLxoy5JA0V7i27laJsU2ir22hL54E=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=TRaVtL/Q1l4DTzk0ZvwFo+kXKfw1BIDLZUWF6zFQ7S1sVhFdiaHFZ+IqjgUu6yMKG/wPqJRTer6LaHYbEPgslPpFLLXuTmZYlttxwDzJrVJjpwSHEDXo957AbTmTPAHK2lnagoa7z91BPY0+/SqQrPQgtX1irMhKHxb9382mhOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AENZBFUp; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AENZBFUp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Jnt2paqYhXchPjRd7hzdBLj3yLcx7WZNFT7q3okyL60=; b=AENZBFUpiG0tFqOtZf70Y/UG6A
	c1RaVX2tnEO0ejNJYiy0EF4rW+52oMv5MQild6dxQpKWmU6wbN9ewuDzuIhQ/lrZ+W7yS5iBIlMS9
	Z4JmFbyCLrVk7ROUU8uFH0tOWlbB/x1TJW2+QqYxbptE1f26iT+HqsVzASOlCSv0c1xCgQUaT/EZg
	X/JROQbnZn3Ezjypp6qBBh3eeVWiAp5qsDOtE/gu/RzB46IkHz99yMpyU2l6MtsE7DhI+ItvojIdV
	Li8YxbJESvKllLTxl7vSQJ6PoRYRxVcgNE1oynz/wNiv+9GyViMalnxhrfVuEpbtH5UgMTVY3e6Lt
	c+W7D1DQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqOVZ-004Uag-1H;
	Fri, 07 Mar 2025 11:36:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Mar 2025 11:36:21 +0800
Date: Fri, 07 Mar 2025 11:36:21 +0800
Message-Id: <2234a3dc7c2765c6067824288961f9d6841a5b0a.1741318360.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741318360.git.herbert@gondor.apana.org.au>
References: <cover.1741318360.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 3/3] crypto: skcipher - Eliminate duplicate virt.addr field
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Reuse the addr field from struct scatter_walk for skcipher_walk.

Keep the existing virt.addr fields but make them const for the
user to access the mapped address.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/skcipher.c                  | 29 ++++++++++++-----------------
 include/crypto/algapi.h            |  5 +++--
 include/crypto/internal/skcipher.h | 26 +++++++++++++++++++++-----
 3 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 92def074374a..24bb78f45bfb 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -43,14 +43,12 @@ static inline void skcipher_map_src(struct skcipher_walk *walk)
 {
 	/* XXX */
 	walk->in.maddr = scatterwalk_map(&walk->in);
-	walk->src.virt.addr = walk->in.addr;
 }
 
 static inline void skcipher_map_dst(struct skcipher_walk *walk)
 {
 	/* XXX */
 	walk->out.maddr = scatterwalk_map(&walk->out);
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
 
@@ -162,7 +156,7 @@ static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
 {
 	unsigned alignmask = walk->alignmask;
 	unsigned n;
-	u8 *buffer;
+	void *buffer;
 
 	if (!walk->buffer)
 		walk->buffer = walk->page;
@@ -176,10 +170,11 @@ static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
 			return skcipher_walk_done(walk, -ENOMEM);
 		walk->buffer = buffer;
 	}
-	walk->dst.virt.addr = PTR_ALIGN(buffer, alignmask + 1);
-	walk->src.virt.addr = walk->dst.virt.addr;
 
-	memcpy_from_scatterwalk(walk->src.virt.addr, &walk->in, bsize);
+	buffer = PTR_ALIGN(buffer, alignmask + 1);
+	memcpy_from_scatterwalk(buffer, &walk->in, bsize);
+	walk->out.maddr = buffer;
+	walk->in.maddr = walk->out.maddr;
 
 	walk->nbytes = bsize;
 	walk->flags |= SKCIPHER_WALK_SLOW;
@@ -189,7 +184,7 @@ static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
 
 static int skcipher_next_copy(struct skcipher_walk *walk)
 {
-	u8 *tmp = walk->page;
+	void *tmp = walk->page;
 
 	skcipher_map_src(walk);
 	memcpy(tmp, walk->src.virt.addr, walk->nbytes);
@@ -199,8 +194,8 @@ static int skcipher_next_copy(struct skcipher_walk *walk)
 	 * processed (which might be less than walk->nbytes) is known.
 	 */
 
-	walk->src.virt.addr = tmp;
-	walk->dst.virt.addr = tmp;
+	walk->in.maddr = tmp;
+	walk->out.maddr = tmp;
 	return 0;
 }
 
@@ -214,7 +209,7 @@ static int skcipher_next_fast(struct skcipher_walk *walk)
 		(u8 *)(sg_page(walk->out.sg) + (walk->out.offset >> PAGE_SHIFT));
 
 	skcipher_map_src(walk);
-	walk->dst.virt.addr = walk->src.virt.addr;
+	walk->out.maddr = walk->in.maddr;
 
 	if (diff) {
 		walk->flags |= SKCIPHER_WALK_DIFF;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 8f1dfb758ced..79ccd8ab287a 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -121,14 +121,15 @@ struct crypto_queue {
 };
 
 struct scatter_walk {
-	struct scatterlist *sg;
-	unsigned int offset;
+	/* Must be the first member, see struct skcipher_walk. */
 	union {
 		void *const addr;
 
 		/* Private API field, do not touch. */
 		union crypto_no_such_thing *maddr;
 	};
+	struct scatterlist *sg;
+	unsigned int offset;
 };
 
 struct crypto_attr_alg {
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index d6ae7a86fed2..c705124432c5 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -56,15 +56,31 @@ struct crypto_lskcipher_spawn {
 
 struct skcipher_walk {
 	union {
+		/* Virtual address of the source. */
 		struct {
-			void *addr;
-		} virt;
-	} src, dst;
+			struct {
+				void *const addr;
+			} virt;
+		} src;
+
+		/* Private field for the API, do not use. */
+		struct scatter_walk in;
+	};
 
-	struct scatter_walk in;
 	unsigned int nbytes;
 
-	struct scatter_walk out;
+	union {
+		/* Virtual address of the destination. */
+		struct {
+			struct {
+				void *const addr;
+			} virt;
+		} dst;
+
+		/* Private field for the API, do not use. */
+		struct scatter_walk out;
+	};
+
 	unsigned int total;
 
 	u8 *page;
-- 
2.39.5

