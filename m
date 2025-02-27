Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A489E1E1E01
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 10:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740651315; cv=none; b=Y3br+hoeNYPG+T9KWjfFaiLsj7GNndLOKsZHLrqPC7zeqVrSPyzC6RqjgJ/3IB5Q7Rn+31SqjQJiDfQkW7YuGR62V2zQDB6cvpJpA5Mrs2k8yyvm3VXdgM4NLr+V7OLQuSu8h6bK3h51EQ/wmUgeS2hPcwz68ZuKTiK55MhVrpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740651315; c=relaxed/simple;
	bh=3Hi/AbFrNA5O6i2dQMMc/ck14Tw+KZLqX3ywTJA6zk4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=sV8eW7FOS9izero3VDUESa1cAEfqXbwwmS5WKRt4DxVp1lrFvExQTA00N7i5pX4NL0+XHrNQtTZUgE2EgWXy7xaEWepP/OWeDaMMsovHyZa27EtUGZW2VpGmeDF2lHLqQBAtSbNhpGAioeM+Xjinpi8wJpw2AJfk4cUVDUZoYbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Z7sMw0fg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Z7sMw0fg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=X/COYPSBnxqacFq0opJtS5fN0VNbCBV4FqPa/0g+uW0=; b=Z7sMw0fg2Or5wgGuT/y40ULroe
	f60K2ja10VqUBJI2JgbgCgl+Q9xr7sYFCxC6GRDXcgjsqIgW8fvzIFHAIDsGhxLsj6hYJ/R1fLgrD
	hJkSqj2zDvxgZqs6c9Zw5Y8a2S0pEzMpy3+vOUu7mWHUx0fyadmf27RPg2x/XnFrb5twOq9CYPLxO
	l2Uoh2nG93hM2JulS2hbFYw9dFxJf3o4WDAxsThLOV7PHAuFplNHm01Ci06fgc3OrEKpIBj+9U4xH
	EWAg9SZ7cYAAustIzKjGxTXvUgITXSjt0ryklqVuh/wnk784rD/xJeEWM+NVdWswOK4oosMNgF8UU
	LocAv05A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnav7-002Drs-1X;
	Thu, 27 Feb 2025 18:15:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Feb 2025 18:15:09 +0800
Date: Thu, 27 Feb 2025 18:15:09 +0800
Message-Id: <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1740651138.git.herbert@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the acomp virtual address interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 mm/zswap.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 6504174fbc6a..2b5a2398a9be 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -925,27 +925,20 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 			   struct zswap_pool *pool)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
-	struct scatterlist input, output;
 	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
 	unsigned long handle;
 	struct zpool *zpool;
+	const u8 *src;
 	char *buf;
 	gfp_t gfp;
 	u8 *dst;
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
+	src = kmap_local_page(page);
 	dst = acomp_ctx->buffer;
-	sg_init_table(&input, 1);
-	sg_set_page(&input, page, PAGE_SIZE, 0);
 
-	/*
-	 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
-	 * and hardware-accelerators may won't check the dst buffer size, so
-	 * giving the dst buffer with enough length to avoid buffer overflow.
-	 */
-	sg_init_one(&output, dst, PAGE_SIZE * 2);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	acomp_request_set_virt(acomp_ctx->req, src, dst, PAGE_SIZE, dlen);
 
 	/*
 	 * it maybe looks a little bit silly that we send an asynchronous request,
@@ -960,6 +953,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * acomp instance, so multiple threads can do (de)compression in parallel.
 	 */
 	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
+	kunmap_local(src);
 	dlen = acomp_ctx->req->dlen;
 	if (comp_ret)
 		goto unlock;
@@ -994,9 +988,9 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 {
 	struct zpool *zpool = entry->pool->zpool;
-	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
 	u8 *src;
+	u8 *dst;
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
 	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
@@ -1016,11 +1010,10 @@ static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 		zpool_unmap_handle(zpool, entry->handle);
 	}
 
-	sg_init_one(&input, src, entry->length);
-	sg_init_table(&output, 1);
-	sg_set_folio(&output, folio, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
+	dst = kmap_local_folio(folio, 0);
+	acomp_request_set_virt(acomp_ctx->req, src, dst, entry->length, PAGE_SIZE);
 	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
+	kunmap_local(dst);
 	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
 
 	if (src != acomp_ctx->buffer)
-- 
2.39.5

