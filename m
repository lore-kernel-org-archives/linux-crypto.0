Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE90E12E5B;
	Thu, 22 May 2025 03:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747882911; cv=none; b=px+Bl6lQ+77srGWkmVNFh2nknie65a65DLAIPGYkmj7+mTbtM5iHhnW3+fFDxoTd1yGDv2xjiDpmbtNqVE0sARx1h/e1eyGxOdTGluLHub9/jbU6um+nyWxhgcQ2gKgaGj1gObaIUDBfMt2REsk68c26HFZxTE2zoW8fN51fohc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747882911; c=relaxed/simple;
	bh=mP8Rq8LYYQkE7RCpC5t2aTsDZYSe0ZiRwVXON627kKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VUA7MxFd7NqbxkW2jJ0/2A5UeOasJkbos4fXDWqhuu3X8TDdnO4J3e+QqXVFQYQXabOkXxZpnwvMw33ICqnB2kXfS5xO+HUrlVoF1naRjh4gO6upcSQFQjEri0jlVorluifk/VYfCLu12C+1iZkdnGDphlL8x26szdyfvKOjj8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ck18dJJQ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ck18dJJQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=h4wWGDHVNVnrrWZaoaqhZ+JfMhiABsm2IeLni4flY1U=; b=ck18dJJQbowjd/0MQ9lMyMvlOl
	AjtXnSCNqshyZlg/W74QOR9NagrKTMvacfRSdOR4xS9+BYP87KQhQ7NdBnJKU1PQvT9x6+qSwRcZF
	Mt38Q1VR8U1JQb+uHRMI73CEDr7///IqeLdR/CYtO9fFqD5G9BDqj7PMfbd2fZwEDiXRssLNyuLsM
	S1x3JoisAy/Z4IMPMzh0p90llUXuRJqQbvqRzRUnRuZOsmlYZeiAA8ktzKbSXz6NwlblRw/12crCQ
	NuwGNoX0ikYYnq8B8OPBMXD7Undv86GCyTWNrjV0g69clYEoZnSode6gj985T640Avz3TYBDtm0E0
	XvL+GwfA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uHwBc-007ypu-1i;
	Thu, 22 May 2025 11:01:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 May 2025 11:01:36 +0800
Date: Thu, 22 May 2025 11:01:36 +0800
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
Subject: crypto: marvell/cesa - dma_alloc_coherent broken but kmalloc +
 dma_map_single works
Message-ID: <aC6TkPM6mOuFwvkD@gondor.apana.org.au>
References: <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>
 <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au>
 <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
 <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
 <aC2uvvzlR89iVFGW@Red>
 <aC2xTI1ZuXoZjgjX@gondor.apana.org.au>
 <aC3cF0-bWb-Jiz4i@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC3cF0-bWb-Jiz4i@Red>

On Wed, May 21, 2025 at 03:58:47PM +0200, Corentin Labbe wrote:
>
> It still fail:
> http://kernel.montjoie.ovh/479319.log

I think we've made progress.  All the simple hashes have passed
and now we're only failing on hmac.  So it looks it was the
coherent memory being incoherent.

Adding the mvebu maintainers to see if they can shed any light
on why memory returned by dma_alloc_coherent results in DMA
corruption but kmalloc + dma_map_single works correctly.

Also adding Christophe Hellwig as he was the last person to touch
mach-mvebu/coherency.c.

The code in question is in drivers/crypto/marvell/cesa/hash.c
mv_cesa_ahash_dma_add_cache:

	/* This just calls dma_pool_alloc. */
	ret = mv_cesa_ahash_dma_alloc_cache(ahashdreq, flags);
	if (ret)
		return ret;

	memcpy(ahashdreq->cache, creq->cache, creq->cache_ptr);
	/* Pass ahashdreq->cache_dma to hardware. */

At this point it appears that the DMA memory is corrupted and the
hardware returns a bogus hash.  We have tried replacing dma_pool_alloc
with kmalloc + dma_map_single and it works correctly.

Corentin, could you also try the wmb patch and see if that works
without the dma_map_single patch?

https://lore.kernel.org/linux-crypto/aC1fY6IP-8MzVIbx@gondor.apana.org.au/

> but I have still all old patch of you stacked, perhaps could you do a branch somewhere to be sure ?
> current state is: http://kernel.montjoie.ovh/cesa.diff

You can drop everything except the last patch + the printk
patches.

So here is the latest debugging patch with dma_map_single on top
of cryptodev.  Note that the partial hash mismatch code is buggy
but it doesn't matter because it still prints enough info for us
to interpret.

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
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index f0d4ff3c20a8..53f71391a2c5 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -23,9 +23,7 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 			struct pkcs7_signed_info *sinfo)
 {
 	struct public_key_signature *sig = sinfo->sig;
-	struct crypto_shash *tfm;
-	struct shash_desc *desc;
-	size_t desc_size;
+	struct crypto_ahash *tfm;
 	int ret;
 
 	kenter(",%u,%s", sinfo->index, sinfo->sig->hash_algo);
@@ -40,27 +38,23 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 	/* Allocate the hashing algorithm we're going to need and find out how
 	 * big the hash operational data will be.
 	 */
-	tfm = crypto_alloc_shash(sinfo->sig->hash_algo, 0, 0);
+	tfm = crypto_alloc_ahash(sinfo->sig->hash_algo, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm))
 		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
 
-	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
-	sig->digest_size = crypto_shash_digestsize(tfm);
+	sig->digest_size = crypto_ahash_digestsize(tfm);
 
 	ret = -ENOMEM;
 	sig->digest = kmalloc(sig->digest_size, GFP_KERNEL);
 	if (!sig->digest)
 		goto error_no_desc;
 
-	desc = kzalloc(desc_size, GFP_KERNEL);
-	if (!desc)
-		goto error_no_desc;
-
-	desc->tfm   = tfm;
+	HASH_REQUEST_ON_STACK(req, tfm);
+	ahash_request_set_flags(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
 
 	/* Digest the message [RFC2315 9.3] */
-	ret = crypto_shash_digest(desc, pkcs7->data, pkcs7->data_len,
-				  sig->digest);
+	ahash_request_set_virt(req, pkcs7->data, sig->digest, pkcs7->data_len);
+	ret = crypto_ahash_digest(req);
 	if (ret < 0)
 		goto error;
 	pr_devel("MsgDigest = [%*ph]\n", 8, sig->digest);
@@ -100,24 +94,26 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 		 */
 		memset(sig->digest, 0, sig->digest_size);
 
-		ret = crypto_shash_init(desc);
+		ret = crypto_ahash_init(req);
 		if (ret < 0)
 			goto error;
 		tag = ASN1_CONS_BIT | ASN1_SET;
-		ret = crypto_shash_update(desc, &tag, 1);
+		ahash_request_set_virt(req, &tag, NULL, 1);
+		ret = crypto_ahash_update(req);
 		if (ret < 0)
 			goto error;
-		ret = crypto_shash_finup(desc, sinfo->authattrs,
-					 sinfo->authattrs_len, sig->digest);
+		ahash_request_set_virt(req, sinfo->authattrs, sig->digest,
+				       sinfo->authattrs_len);
+		ret = crypto_ahash_finup(req);
 		if (ret < 0)
 			goto error;
 		pr_devel("AADigest = [%*ph]\n", 8, sig->digest);
 	}
 
 error:
-	kfree(desc);
+	ahash_request_free(req);
 error_no_desc:
-	crypto_free_shash(tfm);
+	crypto_free_ahash(tfm);
 	kleave(" = %d", ret);
 	return ret;
 }
