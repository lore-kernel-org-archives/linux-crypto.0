Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6144B184;
	Sun, 11 May 2025 03:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746933755; cv=none; b=o6BPb8nqn/uGl1/SPdr5gQkYp83eHpn18X4EW8BzEys1XtFgh+XaGn/+DrJui7uflFk80hDN5jrWwzzVm6jQAc7NIbLOo+ZiT3EUYRaN2Luxnyc6LqR6abcyWZA/f1m6RPT2jY/VfGbgFVnZLOXZbGkPUtL4PuldzNciHCMecIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746933755; c=relaxed/simple;
	bh=YeoZRWRANmCUNbk4l2pyx/MrQB0OC5+emslCayfyyMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ocDvg0vZiDR3RdUX3BY8ENAhXzMMoRb4QaJbWBFeiJsKqE8RXE7nL7z+++b6gpW+LxJ1YlUMwZI6HMvuC4OjLeNtQK+2iw/ncwVqLSCe7v0Xn/+N7lPCHiObUhAZCHFpdr2w+f3ocMVDgbukqHVkEgoANjf+K47P36Du8jcV+c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sloy2zEf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sloy2zEf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Y6MvY04rIvQC/jfLGWMBxjlXcQaD/D9jyPK+/bNE2uw=; b=sloy2zEf8jsRrBXH4m80u8EUSc
	u63jtqcqATV9APkOptDJ77b9hnyjDFZun1D3AT8nry2hU3ZC5wZAYpXnQ8bdEdBJPY8+1qWd9o+qV
	AfGAK75xCiYaa4qXejnEHfo3WnUtG268UUoZIGbDyscZjYOoq7T+aIeZ7F9KvwlN6dZY31H6ZMy+e
	jbaV/SgZOsIoj4NOfXKjoem6FHQWWasHLh2uXpWTw9NAS935KgwjNCPmkcvGjPOuZ3F4fjQ9z3Rz8
	WhEJ/YVvJP3bdTERqOBxO4iizx3dAOzv2SBqhaxI1+1wdkxJvlLO5P3gDIUSAxyWsgmiRkWT5z+gO
	Qloq2c3Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uDxGk-005AGy-24;
	Sun, 11 May 2025 11:22:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 11 May 2025 11:22:26 +0800
Date: Sun, 11 May 2025 11:22:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aCAX8rj2ie4QMnTo@gondor.apana.org.au>
References: <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <dd55ba91a5aebce0e643cab5d57e4c87a006600f.camel@gmail.com>
 <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
 <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>
 <aB8t1ZTVBexqGlcm@gondor.apana.org.au>
 <dcb0b04e479d6f3cfed87795d100ea09e4fbcf53.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcb0b04e479d6f3cfed87795d100ea09e4fbcf53.camel@gmail.com>

On Sat, May 10, 2025 at 05:07:22PM +0200, Klaus Kudielka wrote:
>
> Here a result with the printk patch and the other two small fixes on top.

Thanks.  So it's clearly not the chaining that's causing the
corruption.  The requests seem to bouncing between the two engines,
but it's not clear whether that's relevant.

Please replace the previous printk patch with this that adds some
info on the request being processed so I can see which request is
which.

Cheers,
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
index 2200bc6a034f..be8471a8ab22 100644
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
 
+	pr_err("mv_cesa_ahash_queue_req: %d 0x%lx %d %d\n", engine->id, (unsigned long)req, req->nbytes, creq->last_req);
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
