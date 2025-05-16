Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF433E47B;
	Fri, 16 May 2025 12:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747399518; cv=none; b=OaDVscRSY3EnMpq4cEVL/BgFn1HUoe3XkvlZxYLLrimh+GSOW7m/VSvf3AtnJ7BcqvuvDqZwZlbvkyvsPqp5WKvS7faOmb679C0I6UjcUk7ivVi10BRecwvyH4GK3D3m+EsTmoa4jl+y/PKIO2QJf+jhQeWd1Q5KW56TlRuEu/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747399518; c=relaxed/simple;
	bh=b+bZp3LtXEbGrStCGaZgWDnVpgEug9b43ERZEzO1k5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQnQxVCZg8oNkSrWwUQr53jHICsnL17Z9FeZY2kSn/bIu4n9GekwGNBxj/8RlYF969ZSZn/pa+kvHCqyHY3jOIVRN/Nfm7peHOcYWzkyCZXTcmVpYE6J+5EiVRKTVf6WlS+eWesjwDxYk8J8NkR6jGHZUICrBG09KaZ6PKkwDVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kPO54So2; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kPO54So2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ruHbUrkCXkXLA4qCA0A9JMZjYSazW9Ft9mg99twBNTw=; b=kPO54So2xmjffePJvuKbIJUnVT
	Ry+HFRtDLDQ6AxgECgfEHLFlWosv+5OENQ7plxnNByZIzh4TciiPmsAL9Yf7aArzniV7rDbCFFJbM
	83bQYfQR+NoAy88ZeiK5bAxgEPMRk97YKEp3TBWixwrD8vJp3xvdDTIV/ByWK9RkrTXm8lwp+p/Ib
	F1d2OhZENhrzA74niIjywW2hNBroHxEYQwZsFIvfzaI9J7Qt6MSvXGznkS6ELmQwaT6WRJvkil9kT
	0PiekLR9AuDpY+un7/nzHxBe8HGCB9/TXjOmJO71Nmq3NR+7MvpeZXM5sJzj8zb1LvHI6FMUj+kMV
	ZzQbbbBg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFuR5-006afF-0g;
	Fri, 16 May 2025 20:45:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 May 2025 20:45:11 +0800
Date: Fri, 16 May 2025 20:45:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aCczV6MF6xk5rRA3@gondor.apana.org.au>
References: <aCAX8rj2ie4QMnTo@gondor.apana.org.au>
 <28184fb96e2de8a0af32816f5ff1b3d776b57217.camel@gmail.com>
 <aCMOyWVte4tw85_F@gondor.apana.org.au>
 <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>
 <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
 <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>
 <20250515182131.GC1411@quark>
 <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>
 <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>
 <aCcyXkeBvHQYvf2d@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCcyXkeBvHQYvf2d@Red>

On Fri, May 16, 2025 at 02:41:02PM +0200, Corentin Labbe wrote:
>
> Yes I have still errors:

Great! Please apply my debugging patch and see if it shines any
light on the problem.

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
 
