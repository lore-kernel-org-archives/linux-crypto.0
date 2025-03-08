Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F092744E
	for <linux-crypto@vger.kernel.org>; Sat,  8 Mar 2025 12:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741437932; cv=none; b=bpUvhbLhgb2bredxQHfOYPW+AXWOwlHwrJMFJs+wKOsEJeP3RtGTzc5mVWF1PqWhz8aoGySVd9VerAP6krtZMGaXwHS3GTh7RgMUMAKTdQarDJNEVQCPFofSdr+BRda+JPZYKpOOn+J/4UgVLHkrw9f1iUlB1ZlFlUaDSFhpmWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741437932; c=relaxed/simple;
	bh=xRshCf8PFBCO3ICdDD2AsCHtTzpqNbuTyYBGBytJCwg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=TyVkSSJMJxv2wVggtGeRb6jW5rSxJAm0+3I6fd7KTMlYo44QKLV0x2E4kB+ASJUsGPjlVI1Znmh42e8gRfhZa5jKB3IWBcfmNT+T0FCIbHIBJ6UzmD8j1vlcGfl49RVVTvTaAsjSRHR0VUzX9qSk6dyqDlfAFaPh4EA1HYCxB+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mmI/rDDi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mmI/rDDi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gASeNtoVmJKfH5nKl9sImiPVqn7xXssmbul7QTdgQ5s=; b=mmI/rDDiDoQWr8iIzEBNLxRra/
	8Sc/dwEMEYh5D66pclLvNu7lM5C1C5HKLso5kxGozl+qQPdepoetEFUMnuJ6WCQ3Ct22DlgDgthlc
	n80V/VlDNFVvrjGQirupwT2wAMV6+lPX9I4TI4VOy5/WPiYgTD4buVW6vVNNJ9fGdH89ns2TEPtwk
	GUJWamkv2V0Vbt404JTZK6b9KiX0lS38Rmg39HueMVZxpOyxw8fF9ObfdUXdeiUYzejVagrNAQdA/
	enBLz0ps5ZTEOHE2OHdSGGJSQCN54RdJsz0YXnOBn4/QAWv+jUF+Db3Is+05e+ft9kfs0gYcpUR4p
	x58M7enw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqtYT-004r9S-2r;
	Sat, 08 Mar 2025 20:45:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 08 Mar 2025 20:45:25 +0800
Date: Sat, 08 Mar 2025 20:45:25 +0800
Message-Id: <3fd9a16e66e9c708b9b75019251b8bb241597ccd.1741437826.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741437826.git.herbert@gondor.apana.org.au>
References: <cover.1741437826.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 3/3] crypto: skcipher - Eliminate duplicate virt.addr field
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
index 0c6911154241..ab5d852febcd 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -43,14 +43,12 @@ static inline void skcipher_map_src(struct skcipher_walk *walk)
 {
 	/* XXX */
 	walk->in.__addr = scatterwalk_map(&walk->in);
-	walk->src.virt.addr = walk->in.addr;
 }
 
 static inline void skcipher_map_dst(struct skcipher_walk *walk)
 {
 	/* XXX */
 	walk->out.__addr = scatterwalk_map(&walk->out);
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
+	walk->out.__addr = buffer;
+	walk->in.__addr = walk->out.addr;
 
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
+	walk->in.__addr = tmp;
+	walk->out.__addr = tmp;
 	return 0;
 }
 
@@ -214,7 +209,7 @@ static int skcipher_next_fast(struct skcipher_walk *walk)
 		(u8 *)(sg_page(walk->out.sg) + (walk->out.offset >> PAGE_SHIFT));
 
 	skcipher_map_dst(walk);
-	walk->src.virt.addr = walk->dst.virt.addr;
+	walk->in.__addr = walk->dst.virt.addr;
 
 	if (diff) {
 		walk->flags |= SKCIPHER_WALK_DIFF;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index f92e22686a68..6e07bbc04089 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -107,14 +107,15 @@ struct crypto_queue {
 };
 
 struct scatter_walk {
-	struct scatterlist *sg;
-	unsigned int offset;
+	/* Must be the first member, see struct skcipher_walk. */
 	union {
 		void *const addr;
 
 		/* Private API field, do not touch. */
 		union crypto_no_such_thing *__addr;
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

