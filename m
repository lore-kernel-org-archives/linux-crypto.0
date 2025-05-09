Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13137270ED8;
	Fri,  9 May 2025 08:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746778277; cv=none; b=j1zHOI0TyiyR4P/0d//CDKByT+UuEkg8PjshHeGMcq19+O85bTgmN6Wm2PZS4yTdjAw0qMO2TzpPrktu5H1xSkLr7TXUkrAVgaCv2HeV1eVwwftzIGSZ1sYMKFI9m8mcwLeJN3ISqqxyGbSKS8Iz1Zkm10a8tDCp2xnUPeYD0FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746778277; c=relaxed/simple;
	bh=/D1j1FulXltAJ6dR1CwFoss0u9Oktc/Tfilx73RBeTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCb2zWoI4kc6ABCS/nUlOwoN67uF2+J278abnwC5xdwAHHewxd/Yyohs2270bCDpG3bgtksmMSnXtb9hiu1g7XCB29PtAAPBbmaywk4irOycGFvMQxDV+gk7iw8NamRYuGc5HaPjI4bw47Pm45kIDdef3n31vPwCNtLpQYlw31w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sB5f/WMH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sB5f/WMH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4ztbB3GVPURMb4MWLj2zH5id4hQeuCZDTfvYyqfarYQ=; b=sB5f/WMHHweKSWUoPKbSJ7T2A4
	oGNBGLqee8ArSGjQ2oBjySBYhCEefnBnprIPz9vGwwkNK+sh1eagIV7LvLoLQaJ0Eew35inqT9Nez
	a1R3Z/6mT1D/FhF1ulfY9a2WJVdNUV/cNP+uljFCULgWQGXUovFmOhbTFO1W9ymrYsiEPfTcBeTTK
	tK5D/ZHoySwY1wMWqjd3WT4D5P7rTtkmENxZVR13gyWERUmiviNPg0S/JrFsoInaqCDOJQdbCrL/c
	Wy6XOY5vt0temtWD9RTuEYsMJXZJFL+zjyVZCTWSpvDuIf5ANrz2IehR7MO+VGLs80pw+In5NQloT
	SSOdJ2ig==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uDIp3-004nKk-1D;
	Fri, 09 May 2025 16:11:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 May 2025 16:11:09 +0800
Date: Fri, 9 May 2025 16:11:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [v3 PATCH] crypto: marvell/cesa - Do not chain submitted requests
Message-ID: <aB24nSeEJKtP1bO_@gondor.apana.org.au>
References: <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <aBypVwhHHzmqqN5K@Red>
 <aBytNdRyd5Ywh1Pq@gondor.apana.org.au>
 <aBy06xyzh5kKC48a@Red>
 <aB10PqZNk0L-ly70@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aB10PqZNk0L-ly70@gondor.apana.org.au>

On Fri, May 09, 2025 at 11:19:26AM +0800, Herbert Xu wrote:
>
> I wonder if the skcipher code is corrupting the ahash state when
> run concurrently (and chained together).

Please try this patch to see if the hashes can work without
the skciphers.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
commit 5407a2b5cb14526fb3ee95929ede1ef11743ad42
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed May 7 16:06:18 2025 +0800

    crypto: marvell/cesa - Do not chain submitted requests
    
    This driver tries to chain requests together before submitting them
    to hardware in order to reduce completion interrupts.
    
    However, it even extends chains that have already been submitted
    to hardware.  This is dangerous because there is no way of knowing
    whether the hardware has already read the DMA memory in question
    or not.
    
    Fix this by splitting the chain list into two.  One for submitted
    requests and one for requests that have not yet been submitted.
    Only extend the latter.
    
    Reported-by: Klaus Kudielka <klaus.kudielka@gmail.com>
    Fixes: 85030c5168f1 ("crypto: marvell - Add support for chaining crypto requests in TDMA mode")
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index fa08f10e6f3f..9c21f5d835d2 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -94,7 +94,7 @@ static int mv_cesa_std_process(struct mv_cesa_engine *engine, u32 status)
 
 static int mv_cesa_int_process(struct mv_cesa_engine *engine, u32 status)
 {
-	if (engine->chain.first && engine->chain.last)
+	if (engine->chain_hw.first && engine->chain_hw.last)
 		return mv_cesa_tdma_process(engine, status);
 
 	return mv_cesa_std_process(engine, status);
diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
index d215a6bed6bc..50ca1039fdaa 100644
--- a/drivers/crypto/marvell/cesa/cesa.h
+++ b/drivers/crypto/marvell/cesa/cesa.h
@@ -440,8 +440,10 @@ struct mv_cesa_dev {
  *			SRAM
  * @queue:		fifo of the pending crypto requests
  * @load:		engine load counter, useful for load balancing
- * @chain:		list of the current tdma descriptors being processed
- *			by this engine.
+ * @chain_hw:		list of the current tdma descriptors being processed
+ *			by the hardware.
+ * @chain_sw:		list of the current tdma descriptors that will be
+ *			submitted to the hardware.
  * @complete_queue:	fifo of the processed requests by the engine
  *
  * Structure storing CESA engine information.
@@ -463,7 +465,8 @@ struct mv_cesa_engine {
 	struct gen_pool *pool;
 	struct crypto_queue queue;
 	atomic_t load;
-	struct mv_cesa_tdma_chain chain;
+	struct mv_cesa_tdma_chain chain_hw;
+	struct mv_cesa_tdma_chain chain_sw;
 	struct list_head complete_queue;
 	int irq;
 };
diff --git a/drivers/crypto/marvell/cesa/tdma.c b/drivers/crypto/marvell/cesa/tdma.c
index 388a06e180d6..243305354420 100644
--- a/drivers/crypto/marvell/cesa/tdma.c
+++ b/drivers/crypto/marvell/cesa/tdma.c
@@ -38,6 +38,15 @@ void mv_cesa_dma_step(struct mv_cesa_req *dreq)
 {
 	struct mv_cesa_engine *engine = dreq->engine;
 
+	spin_lock_bh(&engine->lock);
+	if (engine->chain_sw.first == dreq->chain.first) {
+		engine->chain_sw.first = NULL;
+		engine->chain_sw.last = NULL;
+	}
+	engine->chain_hw.first = dreq->chain.first;
+	engine->chain_hw.last = dreq->chain.last;
+	spin_unlock_bh(&engine->lock);
+
 	writel_relaxed(0, engine->regs + CESA_SA_CFG);
 
 	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACC0_IDMA_DONE);
@@ -96,25 +105,27 @@ void mv_cesa_dma_prepare(struct mv_cesa_req *dreq,
 void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
 			struct mv_cesa_req *dreq)
 {
-	if (engine->chain.first == NULL && engine->chain.last == NULL) {
-		engine->chain.first = dreq->chain.first;
-		engine->chain.last  = dreq->chain.last;
-	} else {
-		struct mv_cesa_tdma_desc *last;
+	struct mv_cesa_tdma_desc *last = engine->chain_sw.last;
 
-		last = engine->chain.last;
+	/*
+	 * Break the DMA chain if the request being queued needs the IV
+	 * regs to be set before lauching the request.
+	 */
+	if (!last || dreq->chain.first->flags & CESA_TDMA_SET_STATE)
+		engine->chain_sw.first = dreq->chain.first;
+	else {
 		last->next = dreq->chain.first;
-		engine->chain.last = dreq->chain.last;
-
-		/*
-		 * Break the DMA chain if the CESA_TDMA_BREAK_CHAIN is set on
-		 * the last element of the current chain, or if the request
-		 * being queued needs the IV regs to be set before lauching
-		 * the request.
-		 */
-		if (!(last->flags & CESA_TDMA_BREAK_CHAIN) &&
-		    !(dreq->chain.first->flags & CESA_TDMA_SET_STATE))
-			last->next_dma = cpu_to_le32(dreq->chain.first->cur_dma);
+		last->next_dma = cpu_to_le32(dreq->chain.first->cur_dma);
+	}
+	last = dreq->chain.last;
+	engine->chain_sw.last = last;
+	/*
+	 * Break the DMA chain if the CESA_TDMA_BREAK_CHAIN is set on
+	 * the last element of the current chain.
+	 */
+	if (last->flags & CESA_TDMA_BREAK_CHAIN) {
+		engine->chain_sw.first = NULL;
+		engine->chain_sw.last = NULL;
 	}
 }
 
@@ -127,7 +138,7 @@ int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)
 
 	tdma_cur = readl(engine->regs + CESA_TDMA_CUR);
 
-	for (tdma = engine->chain.first; tdma; tdma = next) {
+	for (tdma = engine->chain_hw.first; tdma; tdma = next) {
 		spin_lock_bh(&engine->lock);
 		next = tdma->next;
 		spin_unlock_bh(&engine->lock);
@@ -149,12 +160,12 @@ int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)
 								 &backlog);
 
 			/* Re-chaining to the next request */
-			engine->chain.first = tdma->next;
+			engine->chain_hw.first = tdma->next;
 			tdma->next = NULL;
 
 			/* If this is the last request, clear the chain */
-			if (engine->chain.first == NULL)
-				engine->chain.last  = NULL;
+			if (engine->chain_hw.first == NULL)
+				engine->chain_hw.last  = NULL;
 			spin_unlock_bh(&engine->lock);
 
 			ctx = crypto_tfm_ctx(req->tfm);
diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 9c21f5d835d2..b9581c21697a 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -192,11 +192,13 @@ static int mv_cesa_add_algs(struct mv_cesa_dev *cesa)
 	int ret;
 	int i, j;
 
+#if 0
 	for (i = 0; i < cesa->caps->ncipher_algs; i++) {
 		ret = crypto_register_skcipher(cesa->caps->cipher_algs[i]);
 		if (ret)
 			goto err_unregister_crypto;
 	}
+#endif
 
 	for (i = 0; i < cesa->caps->nahash_algs; i++) {
 		ret = crypto_register_ahash(cesa->caps->ahash_algs[i]);
@@ -211,9 +213,11 @@ static int mv_cesa_add_algs(struct mv_cesa_dev *cesa)
 		crypto_unregister_ahash(cesa->caps->ahash_algs[j]);
 	i = cesa->caps->ncipher_algs;
 
+#if 0
 err_unregister_crypto:
 	for (j = 0; j < i; j++)
 		crypto_unregister_skcipher(cesa->caps->cipher_algs[j]);
+#endif
 
 	return ret;
 }
@@ -225,8 +229,10 @@ static void mv_cesa_remove_algs(struct mv_cesa_dev *cesa)
 	for (i = 0; i < cesa->caps->nahash_algs; i++)
 		crypto_unregister_ahash(cesa->caps->ahash_algs[i]);
 
+#if 0
 	for (i = 0; i < cesa->caps->ncipher_algs; i++)
 		crypto_unregister_skcipher(cesa->caps->cipher_algs[i]);
+#endif
 }
 
 static struct skcipher_alg *orion_cipher_algs[] = {
