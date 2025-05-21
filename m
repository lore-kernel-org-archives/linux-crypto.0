Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976792135CB;
	Wed, 21 May 2025 10:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747824980; cv=none; b=kq89NlBH4dQQkeARlpyYccmPcEkEpMfX9EGbeKuHSaOJGaF81v49PI4gPRxWlFcIVJg5z577M2vJfEP/rWRKiW4t4JJRL28fyolv8OFM7EGFroG+AlPeHIgSijC9Iy2LQLB7tscDL6GqxbAyt3xmwWMBLyGDawsWebLN6tXHPi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747824980; c=relaxed/simple;
	bh=2Pb3VUXgfgwT7XK9AsAPH5WUyMYo3ubnGvEPxObWDQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ALHW6EcfVoL29NgwZMlUpAncBVsDSZuebyDyNwMVSjlkAdB9N8j3bRHxV+unicVl+vgy9qklOcePt4lvDE1hfOfmetYJTl+Z1oA9w1ZFLu0KLkyH5yWS7nQ98w4bcax1roUSqfmmIY7P+a3b6K/f3zCfLWC6mnc3wYLyyxNu2vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=o/vlg+aX; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="o/vlg+aX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/YKEH6sMpRL2/1KPRrXkYrVw2SPr5B/luLjqxM5fH4M=; b=o/vlg+aXqJl85gJmk9Nm7xIrn1
	++Tg8cik8Zi0GmJNSgFC5DdnGbN9BCgxodwDf+RYNhdranuLeWpFAqL/B9hQS48NBtReHPKri24tO
	+sKTRBbxxR2kkLNgbFRidwrtDQFqNQLtDGkKaeyX/ZzwMbSIQ0GZF8kjX5HuDMHnJyKkxXormkgMH
	QUt1nzTM+PVyNOZvDkpYpI4f4R0JjPRuQibikI+Ojd1cP+RFl78myUzu61iv6obCwh8blQdEbBZrD
	RIaa1lagTrrvoc3YrnndZbmMBS2nhZCG+3U10/LPXvwlqneftKwuVdm4V3z6m/Dh7225s8ekUjdSR
	AJD5Z1QQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uHh7M-007n9o-27;
	Wed, 21 May 2025 18:56:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 21 May 2025 18:56:12 +0800
Date: Wed, 21 May 2025 18:56:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aC2xTI1ZuXoZjgjX@gondor.apana.org.au>
References: <20250515182131.GC1411@quark>
 <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>
 <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>
 <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au>
 <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
 <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
 <aC2uvvzlR89iVFGW@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC2uvvzlR89iVFGW@Red>

On Wed, May 21, 2025 at 12:45:18PM +0200, Corentin Labbe wrote:
>
> It fails to build with:
> ERROR: modpost: "arch_sync_dma_for_device" [drivers/crypto/marvell/cesa/marvell-cesa.ko] undefined!

OK, what about this patch?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 6815eddc9068..5c46cd267789 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -49,8 +49,7 @@ mv_cesa_ahash_req_iter_next_op(struct mv_cesa_ahash_dma_iter *iter)
 static inline int
 mv_cesa_ahash_dma_alloc_cache(struct mv_cesa_ahash_dma_req *req, gfp_t flags)
 {
-	req->cache = dma_pool_alloc(cesa_dev->dma->cache_pool, flags,
-				    &req->cache_dma);
+	req->cache = kmalloc(CESA_MAX_HASH_BLOCK_SIZE, flags);
 	if (!req->cache)
 		return -ENOMEM;
 
@@ -63,8 +62,8 @@ mv_cesa_ahash_dma_free_cache(struct mv_cesa_ahash_dma_req *req)
 	if (!req->cache)
 		return;
 
-	dma_pool_free(cesa_dev->dma->cache_pool, req->cache,
-		      req->cache_dma);
+	dma_unmap_single(cesa_dev->dev, req->cache_dma, CESA_MAX_HASH_BLOCK_SIZE, DMA_TO_DEVICE);
+	kfree(req->cache);
 }
 
 static int mv_cesa_ahash_dma_alloc_padding(struct mv_cesa_ahash_dma_req *req,
@@ -533,6 +532,13 @@ mv_cesa_ahash_dma_add_cache(struct mv_cesa_tdma_chain *chain,
 
 	memcpy(ahashdreq->cache, creq->cache, creq->cache_ptr);
 
+	ahashdreq->cache_dma = dma_map_single(cesa_dev->dev, ahashdreq->cache, CESA_MAX_HASH_BLOCK_SIZE, DMA_TO_DEVICE);
+	if (dma_mapping_error(cesa_dev->dev, ahashdreq->cache_dma)) {
+		dev_err(cesa_dev->dev, "dma_map_single failed\n");
+		kfree(ahashdreq->cache);
+		return -ENOMEM;
+	}
+
 	return mv_cesa_dma_add_data_transfer(chain,
 					     CESA_SA_DATA_SRAM_OFFSET,
 					     ahashdreq->cache_dma,
