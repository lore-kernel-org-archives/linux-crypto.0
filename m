Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417BC28A1E5;
	Wed,  7 May 2025 15:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630970; cv=none; b=tuJ2uprYPkn4ugLSv53pP9Tdqq2yB85mITAqyTZzW9iRLdS1VdquF+Bl/T/dWsLTisQTMQP1I5JKNO0jEK3QMhKd40oglT2gVQNVPSaC8A8e144aaVm95MPqaQv6kVfUnKCYRz5YpsxrB38zEGLUcAThcRfIcQRNKVltZsOaAeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630970; c=relaxed/simple;
	bh=vGl7z/0hAJxZVITyTBo8mdWr5fur5CvfJsq3P5JaoG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jK5XrotzzNMSnXhpVNm4M0und1y48daqsXNxkEYR3BE6E9ZbihmISRYf3DPoAfjFtuNVqDqtXHaiURIujb3NO+eRoUuyZSYqe2wgmY21LuhDeFrgVwNi5OOkai+OhrZU/iu7cxkemfmqsaGXkpJ8pGDllb19/1iWxA88Xg3d+/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JDQZFRkb; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JDQZFRkb"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43edb40f357so37722045e9.0;
        Wed, 07 May 2025 08:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746630966; x=1747235766; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5rRU/MbHVQgEmIdkY6Kg7TY7cEybas9Wx38q8KYLNeo=;
        b=JDQZFRkbvql4g35r+mazcOlX3QYbzF8iP6JmMnU/nJ6/gttRFV5nUJjAQp10iWnG8X
         UQjz1uNDVVahQXeF6Ji4TaMyPSTQlv4A6w7CDR2WHxlAQh5nUzRBIAnE3FWaP7nEXlvG
         Yy0E5tIQMQh4qg1hT/RjWDl6f8rARg2eoILLJPyjVu2MYSnicsfHJ6QiT+nEuGc+koJR
         lY7mnfWVAKSRs4HwcJpp8ZRrtZbkllQ5e1iWwqayt26iOriOb1Y1byWs7/MJSX4p6Btw
         y3iFUgczGmEc/dPrlAlWcs+iZIMPdgVAQwCe3JnxmNLr76MT9eqYWJu8shdQBHYmGyVN
         cjhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746630966; x=1747235766;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5rRU/MbHVQgEmIdkY6Kg7TY7cEybas9Wx38q8KYLNeo=;
        b=U+agSeT1sXBmasw8wW63kox0Ah5SuA9cqwFWidl88oBlFXKTLozUur/xdDLdf2FDn1
         +5/eTcntc3pNJ2trbmPM35U0OdzqIs5KDumGWNI2NmotEIdLndVhsz9LAhqIVuMnWILY
         RU7JyIMv2bdZomlPberRT9ncWTcAuvbzghfwEUNlYTX56qfKQNxXOR8rHz7zEGKOC8cE
         694Sk2+aFBHW83kC86esm26K/KSvtElJ9kub5i+UpVJXnTtI8hE9se1ok5Qu+D0H+T7d
         30j/6M7ouaLA4Ht8cShC90Ptl7T+vkmiNa3VvrT5wsUC/qM35h6gUWbstQs6TKY7M4uI
         UDVg==
X-Forwarded-Encrypted: i=1; AJvYcCUmVyWS23YE7FB4VZxn6HlJCXkWS3byUpx/zxokseVHVzoLoSzSxjy4E7wzYbwSBy0NkoBihjS3haXEl1fv@vger.kernel.org, AJvYcCWayxv2GFQuCbOOix6xSFaS0aSUMfQ1TWix7kjJrlAEKMCa4TMW21I1dGSVSUB5mY0soFzgH+O+jvnZIcY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo+oFYuVjJyHiic5aG1YWibA0crsfbes0EBtAA6+ymlAdpfLRb
	79TLwkrWFLCceVmaKFPjSMuUtmedl61ygu38C86AMuQ4AVdw4kt6
X-Gm-Gg: ASbGncs4GhfdbJrBJ9SiN096Fzi+seRG9NVp4wByOdlhAkoZ5mJyS14ORFOK4xQBSdV
	Pr/BCIvL9sfYnGa//EK4DIfI/3wB81eH5+5d8NfMCP4gU6CdVPex5ukWYU+w21rWker4M4kedPD
	Ogu5RzWiz6s4hZQDYn8993LlPsgguknQMQTm+K8HSkHgsFNkrdndtwfN2CfQJHcGWztV3/0J2bP
	mC0qkWFSmXi5okE2LO98nLazVPowYARNh8NutwIsV6ya5iuMUG703RAyj34KQX0o6lLDMMvjdZD
	iOenkI7SMyoO6Rh4QAREKmV38K8Sd47onBvMSwGWLw==
X-Google-Smtp-Source: AGHT+IGy0MgSd6cQKbFr56QTAdG746gPsraD8VsfdwRUEIFZA+ubNqIMC+h3c7SWcfDJiTm0pS2w9A==
X-Received: by 2002:a05:600c:348b:b0:43c:ec4c:25b1 with SMTP id 5b1f17b1804b1-441d44dc012mr31629855e9.23.1746630966033;
        Wed, 07 May 2025 08:16:06 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-442cd3b7dd5sm3919035e9.35.2025.05.07.08.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 08:16:05 -0700 (PDT)
Date: Wed, 7 May 2025 17:16:03 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Do not chain submitted requests
Message-ID: <aBt5Mxq1MeefwXGJ@Red>
References: <ZwZAExmK52txvHE8@gondor.apana.org.au>
 <7e38e34adddb14d0a23a13cf738b6b7cccbfce6f.camel@gmail.com>
 <ZwduxHxQtHdzz-kl@gondor.apana.org.au>
 <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
 <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>
 <Zw31JIEyh28vK9q7@gondor.apana.org.au>
 <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aBsdTJUAcQgW4ink@gondor.apana.org.au>

Le Wed, May 07, 2025 at 04:43:56PM +0800, Herbert Xu a écrit :
> On Tue, May 06, 2025 at 09:19:04PM +0800, Herbert Xu wrote:
> >
> > I haven't figured out exactly what's wrong with tdma, although
> > the chaining IRQ completion handling looks a bit fragile in that
> > if something goes wrong it'll simply mark all queued requests as
> > complete, corrupting any requests that have not yet been sent to
> > the hardware.
> 
> I'm fairly confident that I've found the culprit.  Please try this
> patch and see if it makes tdma work again:
> 
> ---8<---
> This driver tries to chain requests together before submitting them
> to hardware in order to reduce completion interrupts.
> 
> However, it even extends chains that have already been submitted
> to hardware.  This is dangerous because there is no way of knowing
> whether the hardware has already read the DMA memory in question
> or not.
> 
> Fix this by splitting the chain list into two.  One for submitted
> requests and one for requests that have not yet been submitted.
> Only extend the latter.
> 
> Reported-by: Klaus Kudielka <klaus.kudielka@gmail.com>
> Fixes: 85030c5168f1 ("crypto: marvell - Add support for chaining crypto requests in TDMA mode")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/crypto/marvell/cesa/cesa.c |  2 +-
>  drivers/crypto/marvell/cesa/cesa.h |  9 +++--
>  drivers/crypto/marvell/cesa/tdma.c | 54 ++++++++++++++++++------------
>  3 files changed, 40 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
> index fa08f10e6f3f..9c21f5d835d2 100644
> --- a/drivers/crypto/marvell/cesa/cesa.c
> +++ b/drivers/crypto/marvell/cesa/cesa.c
> @@ -94,7 +94,7 @@ static int mv_cesa_std_process(struct mv_cesa_engine *engine, u32 status)
>  
>  static int mv_cesa_int_process(struct mv_cesa_engine *engine, u32 status)
>  {
> -	if (engine->chain.first && engine->chain.last)
> +	if (engine->chain_hw.first && engine->chain_hw.last)
>  		return mv_cesa_tdma_process(engine, status);
>  
>  	return mv_cesa_std_process(engine, status);
> diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
> index d215a6bed6bc..50ca1039fdaa 100644
> --- a/drivers/crypto/marvell/cesa/cesa.h
> +++ b/drivers/crypto/marvell/cesa/cesa.h
> @@ -440,8 +440,10 @@ struct mv_cesa_dev {
>   *			SRAM
>   * @queue:		fifo of the pending crypto requests
>   * @load:		engine load counter, useful for load balancing
> - * @chain:		list of the current tdma descriptors being processed
> - *			by this engine.
> + * @chain_hw:		list of the current tdma descriptors being processed
> + *			by the hardware.
> + * @chain_sw:		list of the current tdma descriptors that will be
> + *			submitted to the hardware.
>   * @complete_queue:	fifo of the processed requests by the engine
>   *
>   * Structure storing CESA engine information.
> @@ -463,7 +465,8 @@ struct mv_cesa_engine {
>  	struct gen_pool *pool;
>  	struct crypto_queue queue;
>  	atomic_t load;
> -	struct mv_cesa_tdma_chain chain;
> +	struct mv_cesa_tdma_chain chain_hw;
> +	struct mv_cesa_tdma_chain chain_sw;
>  	struct list_head complete_queue;
>  	int irq;
>  };
> diff --git a/drivers/crypto/marvell/cesa/tdma.c b/drivers/crypto/marvell/cesa/tdma.c
> index 388a06e180d6..40fcc852adfa 100644
> --- a/drivers/crypto/marvell/cesa/tdma.c
> +++ b/drivers/crypto/marvell/cesa/tdma.c
> @@ -38,6 +38,15 @@ void mv_cesa_dma_step(struct mv_cesa_req *dreq)
>  {
>  	struct mv_cesa_engine *engine = dreq->engine;
>  
> +	spin_lock_bh(&engine->lock);
> +	if (engine->chain_sw.first == dreq->chain.first) {
> +		engine->chain_sw.first = NULL;
> +		engine->chain_sw.last = NULL;
> +	}
> +	engine->chain_hw.first = dreq->chain.first;
> +	engine->chain_hw.last = dreq->chain.last;
> +	spin_unlock_bh(&engine->lock);
> +
>  	writel_relaxed(0, engine->regs + CESA_SA_CFG);
>  
>  	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACC0_IDMA_DONE);
> @@ -96,25 +105,28 @@ void mv_cesa_dma_prepare(struct mv_cesa_req *dreq,
>  void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
>  			struct mv_cesa_req *dreq)
>  {
> -	if (engine->chain.first == NULL && engine->chain.last == NULL) {
> -		engine->chain.first = dreq->chain.first;
> -		engine->chain.last  = dreq->chain.last;
> +	struct mv_cesa_tdma_desc *last = engine->chain_sw.last;
> +
> +	/*
> +	 * Break the DMA chain if the request being queued needs the IV
> +	 * regs to be set before lauching the request.
> +	 */
> +	if (!last || dreq->chain.first->flags & CESA_TDMA_SET_STATE) {
> +		engine->chain_sw.first = dreq->chain.first;
> +		engine->chain_sw.last  = dreq->chain.last;
>  	} else {
> -		struct mv_cesa_tdma_desc *last;
> -
> -		last = engine->chain.last;
>  		last->next = dreq->chain.first;
> -		engine->chain.last = dreq->chain.last;
> -
> -		/*
> -		 * Break the DMA chain if the CESA_TDMA_BREAK_CHAIN is set on
> -		 * the last element of the current chain, or if the request
> -		 * being queued needs the IV regs to be set before lauching
> -		 * the request.
> -		 */
> -		if (!(last->flags & CESA_TDMA_BREAK_CHAIN) &&
> -		    !(dreq->chain.first->flags & CESA_TDMA_SET_STATE))
> -			last->next_dma = cpu_to_le32(dreq->chain.first->cur_dma);
> +		last->next_dma = cpu_to_le32(dreq->chain.first->cur_dma);
> +		last = dreq->chain.last;
> +		engine->chain_sw.last = last;
> +	}
> +	/*
> +	 * Break the DMA chain if the CESA_TDMA_BREAK_CHAIN is set on
> +	 * the last element of the current chain.
> +	 */
> +	if (last->flags & CESA_TDMA_BREAK_CHAIN) {
> +		engine->chain_sw.first = NULL;
> +		engine->chain_sw.last = NULL;
>  	}
>  }
>  
> @@ -127,7 +139,7 @@ int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)
>  
>  	tdma_cur = readl(engine->regs + CESA_TDMA_CUR);
>  
> -	for (tdma = engine->chain.first; tdma; tdma = next) {
> +	for (tdma = engine->chain_hw.first; tdma; tdma = next) {
>  		spin_lock_bh(&engine->lock);
>  		next = tdma->next;
>  		spin_unlock_bh(&engine->lock);
> @@ -149,12 +161,12 @@ int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)
>  								 &backlog);
>  
>  			/* Re-chaining to the next request */
> -			engine->chain.first = tdma->next;
> +			engine->chain_hw.first = tdma->next;
>  			tdma->next = NULL;
>  
>  			/* If this is the last request, clear the chain */
> -			if (engine->chain.first == NULL)
> -				engine->chain.last  = NULL;
> +			if (engine->chain_hw.first == NULL)
> +				engine->chain_hw.last  = NULL;
>  			spin_unlock_bh(&engine->lock);
>  
>  			ctx = crypto_tfm_ctx(req->tfm);
> -- 
> 2.39.5
> 
> -- 

I tested this patch and my armada-388-clearfog-pro panic with:
[   16.571926] 8<--- cut here ---
[   16.575013] Unable to handle kernel NULL pointer dereference at virtual address 0000001c when read
[   16.584014] [0000001c] *pgd=00000000
[   16.587614] Internal error: Oops: 17 [#1] SMP ARM
[   16.592334] Modules linked in: marvell_cesa(+) libdes sfp mdio_i2c
[   16.598543] CPU: 1 UID: 0 PID: 145 Comm: cryptomgr_test Not tainted 6.15.0-rc5-g1362bea77314 #80 NONE 
[   16.607878] Hardware name: Marvell Armada 380/385 (Device Tree)
[   16.613812] PC is at mv_cesa_tdma_chain+0x28/0x58 [marvell_cesa]
[   16.619859] LR is at mv_cesa_queue_req+0x60/0x84 [marvell_cesa]
[   16.625803] pc : [<bf01dfc8>]    lr : [<bf01abec>]    psr: 60000013
[   16.632091] sp : f0afd8e8  ip : c8ee3d6c  fp : 00000000
[   16.637335] r10: 00000001  r9 : c8ec67c0  r8 : 00000820
[   16.642572] r7 : c8ee3d50  r6 : c8ee3d40  r5 : c8ee3840  r4 : ffffff8d
[   16.649116] r3 : 00000000  r2 : c681c080  r1 : c8ee3840  r0 : c8ee3d40
[   16.655660] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   16.662806] Control: 10c5387d  Table: 069a804a  DAC: 00000051
[   16.668565] Register r0 information: slab kmalloc-256 start c8ee3d00 pointer offset 64 size 256
[   16.677297] Register r1 information: slab kmalloc-256 start c8ee3800 pointer offset 64 size 256
[   16.686026] Register r2 information: non-slab/vmalloc memory
[   16.691701] Register r3 information: NULL pointer
[   16.696419] Register r4 information: non-paged memory
[   16.701483] Register r5 information: slab kmalloc-256 start c8ee3800 pointer offset 64 size 256
[   16.710211] Register r6 information: slab kmalloc-256 start c8ee3d00 pointer offset 64 size 256
[   16.718938] Register r7 information: slab kmalloc-256 start c8ee3d00 pointer offset 80 size 256
[   16.727670] Register r8 information: non-paged memory
[   16.732744] Register r9 information: slab kmalloc-128 start c8ec6780 pointer offset 64 size 128
[   16.741479] Register r10 information: non-paged memory
[   16.746637] Register r11 information: NULL pointer
[   16.751440] Register r12 information: slab kmalloc-256 start c8ee3d00 pointer offset 108 size 256
[   16.760343] Process cryptomgr_test (pid: 145, stack limit = 0x592e8429)
[   16.766977] Stack: (0xf0afd8e8 to 0xf0afe000)
[   16.771346] d8e0:                   c8ee3810 c8ee3800 bf020000 c8ee3840 00000820 bf01b1d4
[   16.779552] d900: 00000820 00000001 00000008 00000008 00000000 00000001 c6977020 00000008
[   16.787763] d920: 00000000 00000002 c6977020 00000008 00000000 ae05d94e c8ee3800 00000001
[   16.795971] d940: c134260c c8ee3800 c0756adc c6977000 f0afda28 bf01bc80 00000000 00000101
[   16.796732] 8<--- cut here ---
[   16.804173] d960: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 67452301
[   16.807243] Unable to handle kernel NULL pointer dereference at virtual address 0000001c when read
[   16.815426] d980: efcdab89 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.824411] [0000001c] *pgd=00000000
[   16.832595] d9a0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.832601] d9c0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 ae05d94e
[   16.836177] 
[   16.844372] d9e0: c13686e8 c07663ec 00000008 f0afda20 00000001 00000000 00000001 00000000
[   16.844378] da00: 00000400 00000000 c89b4b40 bf020c2c f0afdd84 c1836fcc 00000000 c184da44
[   16.870447] da20: c184e598 00000008 00000000 00000000 f0afda30 f0afda30 00000000 00000000
[   16.878645] da40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.886843] da60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.895041] da80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.903239] daa0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.911437] dac0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.919635] dae0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.927833] db00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.936031] db20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.944229] db40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.952426] db60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.960624] db80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.968822] dba0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   16.977020] dbc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 ae05d94e
[   16.985219] dbe0: c6977000 c134260c c1344c0c 00000001 c13686e8 c8ee3800 c6977000 c134326c
[   16.993417] dc00: 000000a1 c0766860 c8ee3800 c6977000 00000000 00000000 ef8cb4c0 00000002
[   17.001615] dc20: fffffffe c04ed770 00000000 00000000 00000000 00000000 00000000 00000801
[   17.009813] dc40: ef7e0534 00000000 0000000f 00000000 00000000 00000000 00000000 00000000
[   17.018012] dc60: 0000000f 00000034 c1f6c7b4 c1f75520 00000000 60000013 ef7e0500 c1f6c9f4
[   17.026210] dc80: c1faef98 c8c5cec0 00000000 ae05d94e 00000000 c1c72500 2db6e000 ef7e0500
[   17.034408] dca0: 00000000 00000800 c1f6c700 00000801 00000001 c04eec18 ef7e0500 ef7e0534
[   17.042606] dcc0: 00000000 00000000 00000000 00000000 00000801 00000000 00000000 00000000
[   17.050804] dce0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   17.059002] dd00: 00000000 00000000 00000000 f0afdde0 00000cc0 00000000 c1f6d508 00000000
[   17.067201] dd20: 00000000 00000000 c1f75520 00000034 00000000 c8c5cec0 c1f6c9f0 00000000
[   17.075399] dd40: 00000000 000000cc 00000001 000000d4 b6db6db7 00000003 00000000 ae05d94e
[   17.083597] dd60: 00000000 00000007 00000001 00000001 00000000 c1343ecc 00000001 c89b4b80
[   17.091795] dd80: c8c5cec0 00000030 00000000 00000000 00000000 00000000 00000cc0 c1d05340
[   17.099993] dda0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   17.108191] ddc0: 00000000 00000000 bf020b80 c1e065b4 f0afddd8 c04f94fc c8c5cec1 00011085
[   17.116390] dde0: c1f6d500 00000000 c1f6d508 00000000 00000001 00000000 00000cc0 bf020b80
[   17.124588] de00: 00000040 c6a02400 c1fbb1b0 00000000 000000a1 c0756abc c1341d48 ae05d94e
[   17.132786] de20: c1341d48 00000007 c6977180 00000001 c6977168 c1343ecc 00000007 c6977180
[   17.140984] de40: 00000001 c6977168 c1343ecc c0762ac8 c6977000 ae05d94e 00000000 c1344c0c
[   17.149183] de60: c6977000 c8ee3800 00000028 c89b4b40 c89b4b80 c07670a8 c6977000 dbc252ec
[   17.157381] de80: 00000001 c0766ff0 ffffffff c6a02400 00011085 c1343ecc c1fbb1b0 00000000
[   17.165580] dea0: 000000a1 c0767334 ef7dce00 ef7dce00 c1d0b054 ffffffff 00000000 c6a02480
[   17.173778] dec0: 00000400 00000005 00000000 0000006a 00000000 c8c5f1c0 c298cec0 c298cec0
[   17.181976] dee0: c8c5cec0 ef7dce00 c8c5cec0 c2a273c0 c2a273c0 00000001 f0afdf6c c12d0dd0
[   17.190175] df00: f0afdf34 c0399fb8 ef7dce00 c8c5cec0 00000000 c12d1484 2db6e000 c1c6ee00
[   17.198373] df20: c1d052c4 00000000 00000002 c1f736e0 00000000 00000004 c1306950 00000000
[   17.206571] df40: 00000002 ae05d94e 00000004 c8c5cec0 c681b080 ae05d94e f113dc10 c6a02400
[   17.214769] df60: c681b080 c8c5cec0 c681b080 c0762528 c6a02400 00000000 00000000 c0762540
[   17.222967] df80: 00000001 c03844c0 00000000 ae05d94e c6819b80 c03843b8 00000000 00000000
[   17.231165] dfa0: 00000000 00000000 00000000 c03001ac 00000000 00000000 00000000 00000000
[   17.239363] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   17.247561] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[   17.255757] Call trace: 
[   17.255763]  mv_cesa_tdma_chain [marvell_cesa] from mv_cesa_queue_req+0x60/0x84 [marvell_cesa]
[   17.266962]  mv_cesa_queue_req [marvell_cesa] from mv_cesa_skcipher_queue_req+0x14c/0x4b8 [marvell_cesa]
[   17.276483]  mv_cesa_skcipher_queue_req [marvell_cesa] from mv_cesa_ecb_des_encrypt+0x54/0x78 [marvell_cesa]
[   17.286352]  mv_cesa_ecb_des_encrypt [marvell_cesa] from test_skcipher_vec_cfg+0x2f4/0x6f8
[   17.294653]  test_skcipher_vec_cfg from test_skcipher_vec+0x70/0x1b4
[   17.301026]  test_skcipher_vec from alg_test_skcipher+0xb8/0x1f4
[   17.307051]  alg_test_skcipher from alg_test+0x150/0x658
[   17.312380]  alg_test from cryptomgr_test+0x18/0x38
[   17.317273]  cryptomgr_test from kthread+0x108/0x234
[   17.322259]  kthread from ret_from_fork+0x14/0x28
[   17.326981] Exception stack(0xf0afdfb0 to 0xf0afdff8)
[   17.332045] dfa0:                                     00000000 00000000 00000000 00000000
[   17.340244] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   17.348441] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   17.355074] Code: 0a000008 e580204c e5912008 e5802050 (e593301c) 
[   17.361183] Internal error: Oops: 17 [#2] SMP ARM
[   17.361209] ---[ end trace 0000000000000000 ]---
[   17.365900] Modules linked in: marvell_cesa(+)
[   17.370530] Kernel panic - not syncing: Fatal exception in interrupt
