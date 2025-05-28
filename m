Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA78748D;
	Wed, 28 May 2025 09:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748426307; cv=none; b=gA9kpFkCO+jY198RaQ9xdoRPYlwuwA3ZnWNUBJdrUJom5VF1DCwMpTX4QPnzs7mrYOYXxuhxeSjnbcB+CppQ/llcchiHgkYUICJovNLmam6YBsiwZNWtzIH9gie2dqc7sV1W+PvDlKhhBnIKhKHjdNP3EOVF/igx0jgn203NF5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748426307; c=relaxed/simple;
	bh=NRGd1298YR6eHTCIZ4sKS4iKFIP8ajc1FwHkQHVUEcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRuX2JUcOd6Nl1Y9A8/3KjcUxj9kbSycEXoXF75UfDdsSjfY9Ls2E+JdLxqmoh3J1oYD8P8H2uzIWS/BKket4qqokhY427etf7vvVfSYPrYDL21lgcbuSdg/QEEUpgja1AYcQxeT4U7IpyT3bvuexwTaKBXV2Dy9/mFXixPVjzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JFt6cr3U; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JFt6cr3U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1xRm8xDdj9ygUcINq3+7tEJK7XUVkovysG+3uSP4mK0=; b=JFt6cr3UZnexdU5Br0jFmmk949
	XhyX/5vqmpk8anwlGiS7pymGWJXajA8GSPgjqhyF4r1bZpN1/OJ53PW/0fLE2gthja7QMm4O3Med+
	vDvX/Hrp5YT63Qzc6JexQeCfq2VlmKmHub9tcdi7ujzqBFvBGYqQDCm6WwTMqbBi9VUpRerm14/ZG
	ShMYUX/359/JWzzW1iZMyMBmevjnvhUHJxxuKHdyaelhCCin3owVgF9nKNJ1MfT4Z9haO4MzzoELB
	GQ6LTExaHirxE3KkHHB2hRyX3cuSu3X393aXQN+RYEcztxfK0qnkD9fzMdDzj27b6oQTuR1e66cRS
	j8KQVTLQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uKDY5-009PDi-1w;
	Wed, 28 May 2025 17:58:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 28 May 2025 17:58:13 +0800
Date: Wed, 28 May 2025 17:58:13 +0800
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
Message-ID: <aDbeNYbwhmG6fzUh@gondor.apana.org.au>
References: <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
 <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
 <aC2uvvzlR89iVFGW@Red>
 <aC2xTI1ZuXoZjgjX@gondor.apana.org.au>
 <aC3cF0-bWb-Jiz4i@Red>
 <aC6TkPM6mOuFwvkD@gondor.apana.org.au>
 <aC7UbAIDA46olNJL@gondor.apana.org.au>
 <aC-EGr50MIVJqwVn@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC-EGr50MIVJqwVn@Red>

On Thu, May 22, 2025 at 10:07:54PM +0200, Corentin Labbe wrote:
>
> Here is the result:
> http://kernel.montjoie.ovh/479404.log
> 
> I have built by adding also your "crypto: marvell/cesa - Fix engine load inaccuracy"

Please try this patch on top of the current mainline tree.

I've force-enabled the software finalisation code and switched it
over to kmalloc + dma_map_single.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 6815eddc9068..e5b1d6a9add5 100644
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
 
@@ -63,18 +62,14 @@ mv_cesa_ahash_dma_free_cache(struct mv_cesa_ahash_dma_req *req)
 	if (!req->cache)
 		return;
 
-	dma_pool_free(cesa_dev->dma->cache_pool, req->cache,
-		      req->cache_dma);
+	dma_unmap_single(cesa_dev->dev, req->cache_dma, CESA_MAX_HASH_BLOCK_SIZE, DMA_TO_DEVICE);
+	kfree(req->cache);
 }
 
 static int mv_cesa_ahash_dma_alloc_padding(struct mv_cesa_ahash_dma_req *req,
 					   gfp_t flags)
 {
-	if (req->padding)
-		return 0;
-
-	req->padding = dma_pool_alloc(cesa_dev->dma->padding_pool, flags,
-				      &req->padding_dma);
+	req->padding = kmalloc(72, flags);
 	if (!req->padding)
 		return -ENOMEM;
 
@@ -86,9 +81,8 @@ static void mv_cesa_ahash_dma_free_padding(struct mv_cesa_ahash_dma_req *req)
 	if (!req->padding)
 		return;
 
-	dma_pool_free(cesa_dev->dma->padding_pool, req->padding,
-		      req->padding_dma);
-	req->padding = NULL;
+	dma_unmap_single(cesa_dev->dev, req->padding_dma, 72, DMA_TO_DEVICE);
+	kfree(req->padding);
 }
 
 static inline void mv_cesa_ahash_dma_last_cleanup(struct ahash_request *req)
@@ -533,6 +527,13 @@ mv_cesa_ahash_dma_add_cache(struct mv_cesa_tdma_chain *chain,
 
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
@@ -556,7 +557,7 @@ mv_cesa_ahash_dma_last_req(struct mv_cesa_tdma_chain *chain,
 	 * If the transfer is smaller than our maximum length, and we have
 	 * some data outstanding, we can ask the engine to finish the hash.
 	 */
-	if (creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX && frag_len) {
+	if (0 && creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX && frag_len) {
 		op = mv_cesa_dma_add_frag(chain, &creq->op_tmpl, frag_len,
 					  flags);
 		if (IS_ERR(op))
@@ -588,6 +589,13 @@ mv_cesa_ahash_dma_last_req(struct mv_cesa_tdma_chain *chain,
 
 	trailerlen = mv_cesa_ahash_pad_req(creq, ahashdreq->padding);
 
+	ahashdreq->padding_dma = dma_map_single(cesa_dev->dev, ahashdreq->padding, 72, DMA_TO_DEVICE);
+	if (dma_mapping_error(cesa_dev->dev, ahashdreq->padding_dma)) {
+		dev_err(cesa_dev->dev, "dma_map_single failed\n");
+		kfree(ahashdreq->padding);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	len = min(CESA_SA_SRAM_PAYLOAD_SIZE - frag_len, trailerlen);
 	if (len) {
 		ret = mv_cesa_dma_add_data_transfer(chain,
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
