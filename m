Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A46522094;
	Thu, 22 May 2025 07:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747899510; cv=none; b=AjRHsSX4htNKTDsyyn4seQzI4mlc0gkdQpMzrbEew6MUWCGzGu5SA1gvleq8X87lI5SaMu4bb+alWEztTRd5ix7SBf+aT7x8U6/EXVzi+m7lDBdbYQjCugy/pyV5kNSIoM3ZtDpVhXl/CstHfadwWjI9UTDwTMqa0NyXmJfcL+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747899510; c=relaxed/simple;
	bh=8OhPGt/jydEbBY/zZDynjRZuDAOxGolGqhFzAXz+BAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KeBnvTdsydjNtspjGtMocMFGH/A3FB7rod5tDIPsh11SBUv/LDtSPYSt1GhoMIEM/t2+1yQylCubXeScIyGDglhE82rhEiARRfA5qHw7uD8a+Q59W6iXZP8nV2QJUDsMh2OlF+5MfuZGJlJjj7KIf+oDZhCKEMTvg6ClCLIe9BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Az96nyol; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Az96nyol"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4AslYNqCOhzeQ5TnT+S2AenfLhGHOz9s1B4iCroiOjM=; b=Az96nyoll3MrD/bS+CYf1P+rXv
	8Ehfg1HzewOqOu7OZH5wmwJd5gd+E7uh9+PXJDm01hjvDqFUNmnFDgh2QPoX+Nq8VJaxEs1mTXFan
	Zg/2ydw2Idj9GDLt/6xC4NuafzAyFJvkxwjGBQueiVe7SEWdqaYbwBH4IeMQiWI+ZZLOy3HUULcpt
	xI5taZh2k9obh9MlsFMXFrHopRT/Ko5HEY2rUuFtD4sc0WnO7GLZ71xXUt0NVRe1B1s+Bx0nX3XcY
	q0vHETBz2IfC73YXg8ot8RpIHS/9NQRjXKZJMgc9QbFLjSz929ao1IqUIImPDTITvY8WA0ZCY6esc
	3y+6pesw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uI0VQ-0081PY-0T;
	Thu, 22 May 2025 15:38:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 May 2025 15:38:20 +0800
Date: Thu, 22 May 2025 15:38:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Gregory Clement <gregory.clement@bootlin.com>,
	Christoph Hellwig <hch@infradead.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: crypto: marvell/cesa - dma_alloc_coherent broken but kmalloc +
 dma_map_single works
Message-ID: <aC7UbAIDA46olNJL@gondor.apana.org.au>
References: <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au>
 <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
 <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
 <aC2uvvzlR89iVFGW@Red>
 <aC2xTI1ZuXoZjgjX@gondor.apana.org.au>
 <aC3cF0-bWb-Jiz4i@Red>
 <aC6TkPM6mOuFwvkD@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC6TkPM6mOuFwvkD@gondor.apana.org.au>

On Thu, May 22, 2025 at 11:01:36AM +0800, Herbert Xu wrote:
> 
> So here is the latest debugging patch with dma_map_single on top
> of cryptodev.  Note that the partial hash mismatch code is buggy
> but it doesn't matter because it still prints enough info for us
> to interpret.

Oops, I screwed up that patch.  Here is the corrected version.

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
diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 9c21f5d835d2..fd7f43575cb2 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -127,6 +127,8 @@ static irqreturn_t mv_cesa_int(int irq, void *priv)
 		if (!(status & mask))
 			break;
 
+		pr_err("mv_cesa_int: %d 0x%x 0x%x\n", engine->id, status, mask);
+
 		/*
 		 * TODO: avoid clearing the FPGA_INT_STATUS if this not
 		 * relevant on some platforms.
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 6815eddc9068..ff0735aaed7d 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -397,6 +397,8 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 	}
 
 	atomic_sub(ahashreq->nbytes, &engine->load);
+
+	pr_err("mv_cesa_ahash_complete: %d 0x%lx\n", engine->id, (unsigned long)ahashreq);
 }
 
 static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
@@ -418,6 +420,8 @@ static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req)
 	struct ahash_request *ahashreq = ahash_request_cast(req);
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
 
+	pr_err("mv_cesa_ahash_req_cleanup: %d 0x%lx\n", creq->base.engine->id, (unsigned long)ahashreq);
+
 	if (creq->last_req)
 		mv_cesa_ahash_last_cleanup(ahashreq);
 
@@ -796,6 +800,7 @@ static int mv_cesa_ahash_queue_req(struct ahash_request *req)
 	engine = mv_cesa_select_engine(req->nbytes);
 	mv_cesa_ahash_prepare(&req->base, engine);
 
+	pr_err("mv_cesa_ahash_queue_req: %d 0x%lx %d %d\n", engine->id, (unsigned long)req, req->nbytes, creq->last_req);
 	ret = mv_cesa_queue_req(&req->base, &creq->base);
 
 	if (mv_cesa_req_needs_cleanup(&req->base, ret))
diff --git a/drivers/crypto/marvell/cesa/tdma.c b/drivers/crypto/marvell/cesa/tdma.c
index 243305354420..55860b480dd6 100644
--- a/drivers/crypto/marvell/cesa/tdma.c
+++ b/drivers/crypto/marvell/cesa/tdma.c
@@ -47,6 +47,8 @@ void mv_cesa_dma_step(struct mv_cesa_req *dreq)
 	engine->chain_hw.last = dreq->chain.last;
 	spin_unlock_bh(&engine->lock);
 
+	pr_err("mv_cesa_dma_step: %d 0x%lx 0x%lx 0x%lx\n", engine->id, (unsigned long)dreq, (unsigned long)dreq->chain.first->cur_dma, (unsigned long)dreq->chain.last->cur_dma);
+
 	writel_relaxed(0, engine->regs + CESA_SA_CFG);
 
 	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACC0_IDMA_DONE);
@@ -137,6 +139,7 @@ int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)
 	int res = 0;
 
 	tdma_cur = readl(engine->regs + CESA_TDMA_CUR);
+	pr_err("mv_cesa_tdma_process: %d 0x%lx\n", engine->id, (unsigned long)tdma_cur);
 
 	for (tdma = engine->chain_hw.first; tdma; tdma = next) {
 		spin_lock_bh(&engine->lock);
@@ -186,6 +189,8 @@ int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)
 			break;
 	}
 
+	pr_err("mv_cesa_tdma_process: %d %d 0x%lx\n", engine->id, res, (unsigned long)req);
+
 	/*
 	 * Save the last request in error to engine->req, so that the core
 	 * knows which request was faulty
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 6815eddc9068..230501fe843b 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -374,6 +374,12 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 
 		memcpy(ahashreq->result, data, digsize);
 	} else {
+		struct {
+			u32 digest[8];
+			u64 len;
+		} state;
+
+		memcpy(state.digest, creq->state, digsize);
 		for (i = 0; i < digsize / 4; i++)
 			creq->state[i] = readl_relaxed(engine->regs +
 						       CESA_IVDIG(i));
@@ -393,6 +399,21 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 				for (i = 0; i < digsize / 4; i++)
 					result[i] = cpu_to_be32(creq->state[i]);
 			}
+		} else {
+			HASH_FBREQ_ON_STACK(fbreq, ahashreq);
+
+			crypto_ahash_import_core(fbreq, &state);
+			crypto_ahash_update(fbreq);
+			crypto_ahash_export_core(fbreq, &state);
+			if (memcmp(state.digest, creq->state, digsize)) {
+				pr_err("mv_cesa_ahash_complete partial hash mismatch\n");
+				print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET,
+						16, 1,
+						state.digest, digsize, false);
+				print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET,
+						16, 1,
+						creq->state, digsize, false);
+			}
 		}
 	}
 
