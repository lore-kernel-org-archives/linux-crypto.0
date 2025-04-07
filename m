Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6C623AD
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020333; cv=none; b=MYdx2NwEExoS015g6kCSrkz07blR12b7bJTFN7rx+Dx4wNki2N+wh5pMO6b16EMRV8ovG3Ss3jLw8PU9VqT6XI9wI5u8rUkpRyucCjbCG6tTH0jw7XCFcApyeVoCTSV/mJflQqONNsYMD58pvJkHtIq8cxTqO0qZM5B4FTrhbKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020333; c=relaxed/simple;
	bh=gunsIaSvMZPXn00bARxUDU9N39PxjwYeezN7vw5UTBk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=M/5O+Gjq5RHF1vesRKPbPCDR7h5qxO/e7N/lzRYqM1nnlVjr4eYp6eBhH0GETFe9FO7nF6M0/VaFo7N67xOsJxgakXfMWkboYRLgdzayFITS3s54jfIFiOO56fiHj8xbRSOqgLOTMnV+fq4fE9K5rLWj/GBge6BXIUUuQZvnp8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bL617czy; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bL617czy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZtCtL9V32uw51F0cXfccquou0KkrTJv8R6PjQ0MDpAs=; b=bL617czyxxeHz1D4EwU+NvNsjM
	GioN9Mwop3IMicwXQpixLZWIqSmPU3HkhZvhLRMDe2GQcsA0ZSB1k7/ze6CaZBB//7ihrI98p1I7m
	gOqQEl7uSFc1hfhWoE6PGsa9TShZ2Xd7udRDXmXrPKelTsa/UHuW21gTiJE9unAbCwpfFq48DY15P
	MAdgOrFsOpMAMQLQuMqvu6648Mkli0ToMACT7SRdWgv9JAPMnxWiTsJ3zXXw2hhWyY6YBqLRZn+fz
	D+z2mDJTsQO7ratFZXTX2J1dbZezBKWY8eiFRvVLIFeO0eXx+zVTVPnNMa4h9c/VDnSeLMY5aIvx+
	DTf8X1Jg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jM7-00DTK5-1f;
	Mon, 07 Apr 2025 18:05:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:05:27 +0800
Date: Mon, 7 Apr 2025 18:05:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: acomp - Simplify folio handling
Message-ID: <Z_OjZwSofAa0TU7P@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch is based on top of

https://lore.kernel.org/linux-crypto/cover.1744019630.git.herbert@gondor.apana.org.au

---8<---
Rather than storing the folio as is and handling it later, convert
it to a scatterlist right away.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  | 42 ++-------------------------
 crypto/scompress.c                  | 10 ++-----
 include/crypto/acompress.h          | 45 +++++------------------------
 include/crypto/internal/acompress.h | 16 +---------
 4 files changed, 12 insertions(+), 101 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 9eed20ad0f24..869c926d3986 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -33,9 +33,7 @@ struct crypto_scomp;
 enum {
 	ACOMP_WALK_SLEEP = 1 << 0,
 	ACOMP_WALK_SRC_LINEAR = 1 << 1,
-	ACOMP_WALK_SRC_FOLIO = 1 << 2,
-	ACOMP_WALK_DST_LINEAR = 1 << 3,
-	ACOMP_WALK_DST_FOLIO = 1 << 4,
+	ACOMP_WALK_DST_LINEAR = 1 << 2,
 };
 
 static const struct crypto_type crypto_acomp_type;
@@ -195,12 +193,8 @@ static void acomp_reqchain_virt(struct acomp_req *req)
 
 	if (state->flags & CRYPTO_ACOMP_REQ_SRC_VIRT)
 		acomp_request_set_src_dma(req, state->src, slen);
-	else if (state->flags & CRYPTO_ACOMP_REQ_SRC_FOLIO)
-		acomp_request_set_src_folio(req, state->sfolio, req->soff, slen);
 	if (state->flags & CRYPTO_ACOMP_REQ_DST_VIRT)
 		acomp_request_set_dst_dma(req, state->dst, dlen);
-	else if (state->flags & CRYPTO_ACOMP_REQ_DST_FOLIO)
-		acomp_request_set_dst_folio(req, state->dfolio, req->doff, dlen);
 }
 
 static void acomp_virt_to_sg(struct acomp_req *req)
@@ -208,9 +202,7 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 	struct acomp_req_chain *state = &req->chain;
 
 	state->flags = req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
-					  CRYPTO_ACOMP_REQ_DST_VIRT |
-					  CRYPTO_ACOMP_REQ_SRC_FOLIO |
-					  CRYPTO_ACOMP_REQ_DST_FOLIO);
+					  CRYPTO_ACOMP_REQ_DST_VIRT);
 
 	if (acomp_request_src_isvirt(req)) {
 		unsigned int slen = req->slen;
@@ -219,16 +211,6 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 		state->src = svirt;
 		sg_init_one(&state->ssg, svirt, slen);
 		acomp_request_set_src_sg(req, &state->ssg, slen);
-	} else if (acomp_request_src_isfolio(req)) {
-		struct folio *folio = req->sfolio;
-		unsigned int slen = req->slen;
-		size_t off = req->soff;
-
-		state->sfolio = folio;
-		sg_init_table(&state->ssg, 1);
-		sg_set_page(&state->ssg, folio_page(folio, off / PAGE_SIZE),
-			    slen, off % PAGE_SIZE);
-		acomp_request_set_src_sg(req, &state->ssg, slen);
 	}
 
 	if (acomp_request_dst_isvirt(req)) {
@@ -238,16 +220,6 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 		state->dst = dvirt;
 		sg_init_one(&state->dsg, dvirt, dlen);
 		acomp_request_set_dst_sg(req, &state->dsg, dlen);
-	} else if (acomp_request_dst_isfolio(req)) {
-		struct folio *folio = req->dfolio;
-		unsigned int dlen = req->dlen;
-		size_t off = req->doff;
-
-		state->dfolio = folio;
-		sg_init_table(&state->dsg, 1);
-		sg_set_page(&state->dsg, folio_page(folio, off / PAGE_SIZE),
-			    dlen, off % PAGE_SIZE);
-		acomp_request_set_src_sg(req, &state->dsg, dlen);
 	}
 }
 
@@ -575,18 +547,8 @@ int acomp_walk_virt(struct acomp_walk *__restrict walk,
 		walk->flags |= ACOMP_WALK_SLEEP;
 	if ((req->base.flags & CRYPTO_ACOMP_REQ_SRC_VIRT))
 		walk->flags |= ACOMP_WALK_SRC_LINEAR;
-	else if ((req->base.flags & CRYPTO_ACOMP_REQ_SRC_FOLIO)) {
-		src = &req->chain.ssg;
-		sg_init_table(src, 1);
-		sg_set_folio(src, req->sfolio, walk->slen, req->soff);
-	}
 	if ((req->base.flags & CRYPTO_ACOMP_REQ_DST_VIRT))
 		walk->flags |= ACOMP_WALK_DST_LINEAR;
-	else if ((req->base.flags & CRYPTO_ACOMP_REQ_DST_FOLIO)) {
-		dst = &req->chain.dsg;
-		sg_init_table(dst, 1);
-		sg_set_folio(dst, req->dfolio, walk->dlen, req->doff);
-	}
 
 	if ((walk->flags & ACOMP_WALK_SRC_LINEAR)) {
 		walk->in.sg = (void *)req->svirt;
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 7ade3f2fee7e..c330b81bc5a6 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -193,10 +193,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (dst_isvirt)
 		dst = req->dvirt;
 	else {
-		if (acomp_request_dst_isfolio(req)) {
-			dpage = folio_page(req->dfolio, 0);
-			doff = req->doff;
-		} else if (dlen <= req->dst->length) {
+		if (dlen <= req->dst->length) {
 			dpage = sg_page(req->dst);
 			doff = req->dst->offset;
 		} else
@@ -218,10 +215,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	else {
 		src = NULL;
 		do {
-			if (acomp_request_src_isfolio(req)) {
-				spage = folio_page(req->sfolio, 0);
-				soff = req->soff;
-			} else if (slen <= req->src->length) {
+			if (slen <= req->src->length) {
 				spage = sg_page(req->src);
 				soff = req->src->offset;
 			} else
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 96ec0090a855..1b30290d6380 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -32,17 +32,10 @@
 /* Set this bit for if virtual address destination cannot be used for DMA. */
 #define CRYPTO_ACOMP_REQ_DST_NONDMA	0x00000010
 
-/* Set this bit if source is a folio. */
-#define CRYPTO_ACOMP_REQ_SRC_FOLIO	0x00000020
-
-/* Set this bit if destination is a folio. */
-#define CRYPTO_ACOMP_REQ_DST_FOLIO	0x00000040
-
 /* Private flags that should not be touched by the user. */
 #define CRYPTO_ACOMP_REQ_PRIVATE \
 	(CRYPTO_ACOMP_REQ_SRC_VIRT | CRYPTO_ACOMP_REQ_SRC_NONDMA | \
-	 CRYPTO_ACOMP_REQ_DST_VIRT | CRYPTO_ACOMP_REQ_DST_NONDMA | \
-	 CRYPTO_ACOMP_REQ_SRC_FOLIO | CRYPTO_ACOMP_REQ_DST_FOLIO)
+	 CRYPTO_ACOMP_REQ_DST_VIRT | CRYPTO_ACOMP_REQ_DST_NONDMA)
 
 #define CRYPTO_ACOMP_DST_MAX		131072
 
@@ -84,10 +77,6 @@ struct acomp_req_chain {
  * @dst:	Destination scatterlist
  * @svirt:	Source virtual address
  * @dvirt:	Destination virtual address
- * @sfolio:	Source folio
- * @soff:	Source folio offset
- * @dfolio:	Destination folio
- * @doff:	Destination folio offset
  * @slen:	Size of the input buffer
  * @dlen:	Size of the output buffer and number of bytes produced
  * @chain:	Private API code data, do not use
@@ -98,15 +87,11 @@ struct acomp_req {
 	union {
 		struct scatterlist *src;
 		const u8 *svirt;
-		struct folio *sfolio;
 	};
 	union {
 		struct scatterlist *dst;
 		u8 *dvirt;
-		struct folio *dfolio;
 	};
-	size_t soff;
-	size_t doff;
 	unsigned int slen;
 	unsigned int dlen;
 
@@ -373,8 +358,6 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 
 	req->base.flags &= ~(CRYPTO_ACOMP_REQ_SRC_VIRT |
 			     CRYPTO_ACOMP_REQ_SRC_NONDMA |
-			     CRYPTO_ACOMP_REQ_SRC_FOLIO |
-			     CRYPTO_ACOMP_REQ_DST_FOLIO |
 			     CRYPTO_ACOMP_REQ_DST_VIRT |
 			     CRYPTO_ACOMP_REQ_DST_NONDMA);
 }
@@ -397,7 +380,6 @@ static inline void acomp_request_set_src_sg(struct acomp_req *req,
 
 	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_NONDMA;
 	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_VIRT;
-	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_FOLIO;
 }
 
 /**
@@ -417,7 +399,6 @@ static inline void acomp_request_set_src_dma(struct acomp_req *req,
 	req->slen = slen;
 
 	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_NONDMA;
-	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_FOLIO;
 	req->base.flags |= CRYPTO_ACOMP_REQ_SRC_VIRT;
 }
 
@@ -438,7 +419,6 @@ static inline void acomp_request_set_src_nondma(struct acomp_req *req,
 	req->svirt = src;
 	req->slen = slen;
 
-	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_FOLIO;
 	req->base.flags |= CRYPTO_ACOMP_REQ_SRC_NONDMA;
 	req->base.flags |= CRYPTO_ACOMP_REQ_SRC_VIRT;
 }
@@ -457,13 +437,9 @@ static inline void acomp_request_set_src_folio(struct acomp_req *req,
 					       struct folio *folio, size_t off,
 					       unsigned int len)
 {
-	req->sfolio = folio;
-	req->soff = off;
-	req->slen = len;
-
-	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_NONDMA;
-	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_VIRT;
-	req->base.flags |= CRYPTO_ACOMP_REQ_SRC_FOLIO;
+	sg_init_table(&req->chain.ssg, 1);
+	sg_set_folio(&req->chain.ssg, folio, len, off);
+	acomp_request_set_src_sg(req, &req->chain.ssg, len);
 }
 
 /**
@@ -484,7 +460,6 @@ static inline void acomp_request_set_dst_sg(struct acomp_req *req,
 
 	req->base.flags &= ~CRYPTO_ACOMP_REQ_DST_NONDMA;
 	req->base.flags &= ~CRYPTO_ACOMP_REQ_DST_VIRT;
-	req->base.flags &= ~CRYPTO_ACOMP_REQ_DST_FOLIO;
 }
 
 /**
@@ -504,7 +479,6 @@ static inline void acomp_request_set_dst_dma(struct acomp_req *req,
 	req->dlen = dlen;
 
 	req->base.flags &= ~CRYPTO_ACOMP_REQ_DST_NONDMA;
-	req->base.flags &= ~CRYPTO_ACOMP_REQ_DST_FOLIO;
 	req->base.flags |= CRYPTO_ACOMP_REQ_DST_VIRT;
 }
 
@@ -524,7 +498,6 @@ static inline void acomp_request_set_dst_nondma(struct acomp_req *req,
 	req->dvirt = dst;
 	req->dlen = dlen;
 
-	req->base.flags &= ~CRYPTO_ACOMP_REQ_DST_FOLIO;
 	req->base.flags |= CRYPTO_ACOMP_REQ_DST_NONDMA;
 	req->base.flags |= CRYPTO_ACOMP_REQ_DST_VIRT;
 }
@@ -543,13 +516,9 @@ static inline void acomp_request_set_dst_folio(struct acomp_req *req,
 					       struct folio *folio, size_t off,
 					       unsigned int len)
 {
-	req->dfolio = folio;
-	req->doff = off;
-	req->dlen = len;
-
-	req->base.flags &= ~CRYPTO_ACOMP_REQ_DST_NONDMA;
-	req->base.flags &= ~CRYPTO_ACOMP_REQ_DST_VIRT;
-	req->base.flags |= CRYPTO_ACOMP_REQ_DST_FOLIO;
+	sg_init_table(&req->chain.dsg, 1);
+	sg_set_folio(&req->chain.dsg, folio, len, off);
+	acomp_request_set_dst_sg(req, &req->chain.dsg, len);
 }
 
 /**
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index b51d66633935..d6d53c7696fd 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -154,9 +154,7 @@ void crypto_unregister_acomps(struct acomp_alg *algs, int count);
 static inline bool acomp_request_issg(struct acomp_req *req)
 {
 	return !(req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
-				    CRYPTO_ACOMP_REQ_DST_VIRT |
-				    CRYPTO_ACOMP_REQ_SRC_FOLIO |
-				    CRYPTO_ACOMP_REQ_DST_FOLIO));
+				    CRYPTO_ACOMP_REQ_DST_VIRT));
 }
 
 static inline bool acomp_request_src_isvirt(struct acomp_req *req)
@@ -191,16 +189,6 @@ static inline bool acomp_request_isnondma(struct acomp_req *req)
 				  CRYPTO_ACOMP_REQ_DST_NONDMA);
 }
 
-static inline bool acomp_request_src_isfolio(struct acomp_req *req)
-{
-	return req->base.flags & CRYPTO_ACOMP_REQ_SRC_FOLIO;
-}
-
-static inline bool acomp_request_dst_isfolio(struct acomp_req *req)
-{
-	return req->base.flags & CRYPTO_ACOMP_REQ_DST_FOLIO;
-}
-
 static inline bool crypto_acomp_req_chain(struct crypto_acomp *tfm)
 {
 	return crypto_tfm_req_chain(&tfm->base);
@@ -250,8 +238,6 @@ static inline struct acomp_req *acomp_fbreq_on_stack_init(
 	req->dst = old->dst;
 	req->slen = old->slen;
 	req->dlen = old->dlen;
-	req->soff = old->soff;
-	req->doff = old->doff;
 
 	return req;
 }
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
