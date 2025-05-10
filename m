Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA941D7E42;
	Sat, 10 May 2025 10:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746872384; cv=none; b=R6g5U4ULHAzcHGAYHiwC6UCD7TptU/tVuwjBr7F3wwKfSdpfjJcaqkF0Rkql5XEzFgMQfFJucpyo6SIBvZT3D9ycAhrkB3ug58hhZ/5y0EiDMdzVjJikN8TRPYUEi+BjjBPtzIs/yKNQRKZTjzp3NrUkbJEladMSzZ9z89Pgwro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746872384; c=relaxed/simple;
	bh=CLiOzy1L0qAdfOLj/pcxMMRzv6rN27Y5yfqCVDpA2Iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YuEeWm2rqNs4Zxq2OvHktKdMZrQ+iC05+Pg5DAqTWSJ6e7V21IerLVNel9B2n7rOAc3+GV/1+GTDvaeJ9ec6nuOyzcpIXtIPdPiXQnc0pVIwRqqQPCxSkb+5Vy1M8yuTbx2YtvGmxxcuz+WrkhccLo42aK/Ogji1/Mm5Sx8sojw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=a1rmvyyF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="a1rmvyyF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2CQLABHTiUCYQ/8Ab3/WMbbIvz0wpE+iyASKnTKQO5Y=; b=a1rmvyyFUrr5uFyKgQXdXQ8YJ6
	EAld8qc8oJ6THihyd6LQ1BdzqksdwpWL7+PWtB3VZy1MO3SGcO2moBKbVg82f4QeLBE2hIYTwLkkO
	AwTyii7Q+XOpErjkS/7aa8PKz1NEH+kogEzhG9kmNoaptb06ujwYRHNuWTZ5SflFJTsmzExwWlatp
	WApVwZxZC7gMFyJw5lFd8FBdNC3lWMSuZrXzha+EPE4/XhQtJRMY2AZx0ZcBtPCosOe0UPdtDgiwb
	LqBy4IzoELLn1Y+anOINKkSaSr0K5a1k82+WYobGEjpUIQTsOjrpeg7Jzfiyll6MWUkypEcXb8nJV
	cRvE0p6A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uDhIv-00538x-0J;
	Sat, 10 May 2025 18:19:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 May 2025 18:19:37 +0800
Date: Sat, 10 May 2025 18:19:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [v3 PATCH] crypto: marvell/cesa - Do not chain submitted requests
Message-ID: <aB8oOVLJ_k2YYMzP@gondor.apana.org.au>
References: <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <dd55ba91a5aebce0e643cab5d57e4c87a006600f.camel@gmail.com>
 <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
 <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>

On Sat, May 10, 2025 at 11:38:16AM +0200, Klaus Kudielka wrote:
>
> Patch applied on top.
> On the first attempt all self-tests passed, but on the second and third unfortunately not.

OK, you can get more consistent errors by enabling extra testing with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.

In any case, let's go back to the printk approach and see what's
going on.  This patch could either go on top of the previous ones
or be applied by itself.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
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
index a46ae868110a..cc7efd9a099a 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -396,6 +396,8 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 	}
 
 	atomic_sub(ahashreq->nbytes, &engine->load);
+
+	pr_err("mv_cesa_ahash_complete: %d 0x%lx\n", engine->id, (unsigned long)ahashreq);
 }
 
 static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
@@ -417,6 +419,8 @@ static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req)
 	struct ahash_request *ahashreq = ahash_request_cast(req);
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
 
+	pr_err("mv_cesa_ahash_req_cleanup: %d 0x%lx\n", creq->base.engine->id, (unsigned long)ahashreq);
+
 	if (creq->last_req)
 		mv_cesa_ahash_last_cleanup(ahashreq);
 
@@ -783,6 +787,7 @@ static int mv_cesa_ahash_queue_req(struct ahash_request *req)
 	engine = mv_cesa_select_engine(req->nbytes);
 	mv_cesa_ahash_prepare(&req->base, engine);
 
+	pr_err("mv_cesa_ahash_queue_req: %d 0x%lx\n", engine->id, (unsigned long)req);
 	ret = mv_cesa_queue_req(&req->base, &creq->base);
 
 	if (mv_cesa_req_needs_cleanup(&req->base, ret))
diff --git a/drivers/crypto/marvell/cesa/tdma.c b/drivers/crypto/marvell/cesa/tdma.c
index 9b5fd957dde2..59be742c5a1c 100644
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
