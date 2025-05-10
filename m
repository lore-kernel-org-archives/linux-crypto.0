Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66D7433A0;
	Sat, 10 May 2025 13:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746882159; cv=none; b=JbwbUYru346QNfAHWu1c05Y73+gYLfw/UNsXyL4g2jCfqAN5dJ6v6Qa6zGnrAfVn9TanfLR0mzWn4SyNraxHx7T4FIaKuiQnjLbvProXGQMSPe73U4kcYt3ZggEhB6D71B7Es7I3dmwIR/w2R6jsPwQGGrl6k/21dD/nEn/KjZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746882159; c=relaxed/simple;
	bh=AGotIOjyctdgWJl+vRsrP4myEF3l6ZWOvNC/EvcWNoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tl+qFvKk0qy1xtRqc2XDiywsstaz5/Kbdo1XnwdfUeunMGnJzbpG5nrwvUmlRy2zbD/3fUmBPoqxZiYM4GbkauuzmEy1bEcX82aJUZG+ubdnNCmT17n6yUxo1QnoXxM9WAsMFCHPEYpqR5UGA56AUEVh+Q3BbXjxstlKguARSGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Kv+3LNNo; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Kv+3LNNo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=w6Xdm3r9Ig20fiKWtfUtVfC9W8Fv2ksMY5XhnUtkK48=; b=Kv+3LNNopB0X/L62a4KWMo6SWm
	fr71KiXznRuDt+G12izMszhk2XfAXdQz+fPyF5t0pFRKUvmvtQHTjBYhBoZJUzGcxVNG8C8M2W4F5
	zeYbnqY9IXZSU2UDOz+OLj84bDiisewSH5AWx5e/gFfMVKmJckIvbjPi00Q7XGG3R8CRtkmezH85K
	sKrp77NQm2LtR+mLPHNgW2OaWgU9okFKg8xMov6A/IlVjhg6LtB/zUgxehDFtolkCmm8ca/VxUr4m
	AlBc+B7YhzYJKsFdQ3tv1ald6jMUtx74zid6P/NfkPtJbppvfPUwe83qm3DxJ/DeDgng/XBE2NYHv
	yUPX4cKw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uDjqS-0054Kt-1I;
	Sat, 10 May 2025 21:02:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 May 2025 21:02:24 +0800
Date: Sat, 10 May 2025 21:02:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aB9OYP5ETtu-J9yA@gondor.apana.org.au>
References: <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <dd55ba91a5aebce0e643cab5d57e4c87a006600f.camel@gmail.com>
 <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
 <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>
 <aB8t1ZTVBexqGlcm@gondor.apana.org.au>
 <aB81Dh83fZoKa2st@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aB81Dh83fZoKa2st@Red>

On Sat, May 10, 2025 at 01:14:22PM +0200, Corentin Labbe wrote:
>
> I have tried all your cumulated patchs and got: http://kernel.montjoie.ovh/478197.log

Please try this patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/marvell/cesa/tdma.c b/drivers/crypto/marvell/cesa/tdma.c
index 9b5fd957dde2..12169d5d22f7 100644
--- a/drivers/crypto/marvell/cesa/tdma.c
+++ b/drivers/crypto/marvell/cesa/tdma.c
@@ -50,6 +50,8 @@ void mv_cesa_dma_step(struct mv_cesa_req *dreq)
 	writel_relaxed(0, engine->regs + CESA_SA_CFG);
 
 	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACC0_IDMA_DONE);
+	writel_relaxed(dreq->chain.first->cur_dma,
+		       engine->regs + CESA_TDMA_NEXT_ADDR);
 	writel_relaxed(CESA_TDMA_DST_BURST_128B | CESA_TDMA_SRC_BURST_128B |
 		       CESA_TDMA_NO_BYTE_SWAP | CESA_TDMA_EN,
 		       engine->regs + CESA_TDMA_CONTROL);
@@ -57,8 +59,6 @@ void mv_cesa_dma_step(struct mv_cesa_req *dreq)
 	writel_relaxed(CESA_SA_CFG_ACT_CH0_IDMA | CESA_SA_CFG_MULTI_PKT |
 		       CESA_SA_CFG_CH0_W_IDMA | CESA_SA_CFG_PARA_DIS,
 		       engine->regs + CESA_SA_CFG);
-	writel_relaxed(dreq->chain.first->cur_dma,
-		       engine->regs + CESA_TDMA_NEXT_ADDR);
 	WARN_ON(readl(engine->regs + CESA_SA_CMD) &
 		CESA_SA_CMD_EN_CESA_SA_ACCL0);
 	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
