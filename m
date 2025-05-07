Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEE672610;
	Wed,  7 May 2025 08:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746607444; cv=none; b=Y43XFMyq3fGnbLlp1P4IJNpsVd/lxORq9hQt0S1/8k6KvB0ybrzWG+X5eEjHkyB6BJN8++PSME16G3azFo/3fpa7rPfHRiEabyavOJSrEsU1PgNzk03RLcg+zrnseGieSeNU4TSTTo++3IIpu65AUi9Cyx6slXjfDT8BaDEsvMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746607444; c=relaxed/simple;
	bh=u3Fb8+gokSMQzhf+2mR0lZJLnZv3ZY4xGY2UaMpzyVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dIvuQ5ntDLZKeljdDbFM0tyR2YiXE9P5+2U13uBMSwEGK0l2TZPiroeSZL6gXTuMwI4Jg98Uslyw3vQ/m0R6v0H+icXG/UZiwAi1KNzsGAr7kSl0N3VfLgUapTKkKBOqlIG0cF+v3YvwJZgN7dmrdsFT1ZUZJ1HzkgO01HHQBIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ojHfJixQ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ojHfJixQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WUKmBmR4aG6kGIrfVbpySDx42tAvNoBV6Fg6tQriHps=; b=ojHfJixQLHaHVmpsVsNMFE7Os7
	LIntKZ6xdR89Sdd7977O+VMgBWU+SqadN1J/VRabJ6GFemLvyQE6EkrD+4CoNn655Wl4UX/SOSQLZ
	ouj7XKAP4LmvWKUGlU/SxtTkCFHTEtTTWsGLprrelyn5OS/ok0VpVnuI4s1gW6s/t7wjj4AiEubzV
	FNMFAj4Hkq0Y+DcKqF8E0UKgv8s9M8qiTFnQ2lW+ULRQQHEG/AtDQkyoJ53grdKOTx7UFc117AiqB
	5L0USZ3jHVGJgFvWz8JsAM86ydLjxBKK5vhIKZQ17NoykBC8+1FiTuEMGzRUA/Vm27y3GGYbG8WzR
	swoLyiYA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uCaNg-004CNi-1U;
	Wed, 07 May 2025 16:43:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 May 2025 16:43:56 +0800
Date: Wed, 7 May 2025 16:43:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PATCH] crypto: marvell/cesa - Do not chain submitted requests
Message-ID: <aBsdTJUAcQgW4ink@gondor.apana.org.au>
References: <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>
 <ZwZAExmK52txvHE8@gondor.apana.org.au>
 <7e38e34adddb14d0a23a13cf738b6b7cccbfce6f.camel@gmail.com>
 <ZwduxHxQtHdzz-kl@gondor.apana.org.au>
 <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
 <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>
 <Zw31JIEyh28vK9q7@gondor.apana.org.au>
 <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBoMSHEMYj6FbH8o@gondor.apana.org.au>

On Tue, May 06, 2025 at 09:19:04PM +0800, Herbert Xu wrote:
>
> I haven't figured out exactly what's wrong with tdma, although
> the chaining IRQ completion handling looks a bit fragile in that
> if something goes wrong it'll simply mark all queued requests as
> complete, corrupting any requests that have not yet been sent to
> the hardware.

I'm fairly confident that I've found the culprit.  Please try this
patch and see if it makes tdma work again:

---8<---
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
---
 drivers/crypto/marvell/cesa/cesa.c |  2 +-
 drivers/crypto/marvell/cesa/cesa.h |  9 +++--
 drivers/crypto/marvell/cesa/tdma.c | 54 ++++++++++++++++++------------
 3 files changed, 40 insertions(+), 25 deletions(-)

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
index 388a06e180d6..40fcc852adfa 100644
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
@@ -96,25 +105,28 @@ void mv_cesa_dma_prepare(struct mv_cesa_req *dreq,
 void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
 			struct mv_cesa_req *dreq)
 {
-	if (engine->chain.first == NULL && engine->chain.last == NULL) {
-		engine->chain.first = dreq->chain.first;
-		engine->chain.last  = dreq->chain.last;
+	struct mv_cesa_tdma_desc *last = engine->chain_sw.last;
+
+	/*
+	 * Break the DMA chain if the request being queued needs the IV
+	 * regs to be set before lauching the request.
+	 */
+	if (!last || dreq->chain.first->flags & CESA_TDMA_SET_STATE) {
+		engine->chain_sw.first = dreq->chain.first;
+		engine->chain_sw.last  = dreq->chain.last;
 	} else {
-		struct mv_cesa_tdma_desc *last;
-
-		last = engine->chain.last;
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
+		last = dreq->chain.last;
+		engine->chain_sw.last = last;
+	}
+	/*
+	 * Break the DMA chain if the CESA_TDMA_BREAK_CHAIN is set on
+	 * the last element of the current chain.
+	 */
+	if (last->flags & CESA_TDMA_BREAK_CHAIN) {
+		engine->chain_sw.first = NULL;
+		engine->chain_sw.last = NULL;
 	}
 }
 
@@ -127,7 +139,7 @@ int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)
 
 	tdma_cur = readl(engine->regs + CESA_TDMA_CUR);
 
-	for (tdma = engine->chain.first; tdma; tdma = next) {
+	for (tdma = engine->chain_hw.first; tdma; tdma = next) {
 		spin_lock_bh(&engine->lock);
 		next = tdma->next;
 		spin_unlock_bh(&engine->lock);
@@ -149,12 +161,12 @@ int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)
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
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
