Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6866A25DB1A;
	Mon,  1 Jun 2026 05:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780293124; cv=none; b=iI5QEwZV2cn+nzQ78D60SAekr5OBHP2R4hw7iwIdob+qAgrruXsqpoZTxsjgTOEdVgwA+ZtxrC2GuO2oGKDBDHgz3+x5qlJcFmkS/NruFYq+t94cMPzsUDY8YmTyfldMFQ+YamnJErrxeMLtPvlMPla3YR878KNe4c9YGxKKJwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780293124; c=relaxed/simple;
	bh=xhwsKB8/Psutoq0cO62/LPM7HEXvUGkVC2dNfvSjJEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZWv+nONT5WU9QNrVAwL1bxz7ywDj5/E/Vbr73UYS54n1CIz2Po/p1iSIcM7dwnfgZPVQamwUC+Uh2obVgHgt0T2IMNF23AviwTa6Hge8t2lITPo+XSbPC8VIglmLsXfsoevDZLwGwJFimzzSVdc25SMtK09+xnpae3WJRSK1k5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jpNkQnxf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jpNkQnxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FDD1F00893;
	Mon,  1 Jun 2026 05:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780293122;
	bh=dexSvds61LnfQO88Uko2yPN5+bizNdItqN7ihyL0Fyw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jpNkQnxfIY606jqnwtCkSrNJiJAETm7S04GeGb5GzKoAZRyRKpWJoXtLcQCD0Pzq6
	 AW7LA1XRq0ojA29JTYidsLLLlI1W6f49u5CEqPobwVLM8jhvA3iIv3ht+Nw5eA0zq3
	 Y65hkbHA8gQhm8LTi7GXe7O3aIX1+moQV9Yv4e2P6I7iL1aLj81bn1AR8/Xlfm5ozG
	 4w2eE+G4G8Y5dXTqPXGzxqcEkS3QgxCIUaxtGEd1SB8/nAgLATBMX+TGahiXSgIrFf
	 X92qWBIPy4AF3MhAualM4nBj7s2Hb9Ecnbt/2nZsYwDnFxQVTgRZsm3G48B/TopmIt
	 itUDWCv6pqvvQ==
Message-ID: <a3494787-b508-46ee-921c-b7e34d38cf59@kernel.org>
Date: Mon, 1 Jun 2026 07:51:58 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/29] crypto: talitos - Split SEC1/SEC2 code into
 separate function variants
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-18-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-18-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Split the functions that have SEC1/SEC2-specific behavior into
> separate sec1_ and sec2_ function variants, removing the runtime
> is_sec1 checks from within each function body.
> 
> The callers still dispatch between the two variants using local
> is_sec1 variables and if/else checks.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>

Build fails:

   DESCEND objtool
   INSTALL libsubcmd_headers
   CC      drivers/crypto/talitos/talitos.o
drivers/crypto/talitos/talitos.c: In function 'sec1_talitos_handle_error':
drivers/crypto/talitos/talitos.c:752:21: error: 'struct talitos_private' 
has no member named 'ops'
   752 |                 priv->ops->reset_channel(dev, ch);
       |                     ^~
drivers/crypto/talitos/talitos.c: In function 'sec2_talitos_handle_error':
drivers/crypto/talitos/talitos.c:811:29: error: 'struct talitos_private' 
has no member named 'ops'
   811 |                         priv->ops->reset_channel(dev, ch);
       |                             ^~
make[5]: *** [scripts/Makefile.build:289: 
drivers/crypto/talitos/talitos.o] Error 1
   CC      drivers/crypto/talitos/talitos-rng.o
   CC      drivers/crypto/talitos/talitos-hash.o
   CC      drivers/crypto/talitos/talitos-skcipher.o
   CC      drivers/crypto/talitos/talitos-aead.o
make[5]: Target 'drivers/crypto/talitos/' not remade because of errors.
make[4]: *** [scripts/Makefile.build:548: drivers/crypto/talitos] Error 2
make[4]: Target 'drivers/crypto/talitos/' not remade because of errors.
make[3]: *** [scripts/Makefile.build:548: drivers/crypto] Error 2
make[3]: Target 'drivers/crypto/talitos/' not remade because of errors.
make[2]: *** [scripts/Makefile.build:548: drivers] Error 2
make[2]: Target 'drivers/crypto/talitos/' not remade because of errors.
make[1]: *** [/home/chleroy/linux-powerpc/Makefile:2141: .] Error 2
make[1]: Target 'drivers/crypto/talitos/' not remade because of errors.
make: *** [Makefile:248: __sub-make] Error 2
make: Target 'drivers/crypto/talitos/' not remade because of errors.


> ---
>   drivers/crypto/talitos/talitos.c | 524 +++++++++++++++++++++++++--------------
>   drivers/crypto/talitos/talitos.h |  36 ++-
>   2 files changed, 357 insertions(+), 203 deletions(-)
> 
> diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
> index f38a156a0459..b6793d97735e 100644
> --- a/drivers/crypto/talitos/talitos.c
> +++ b/drivers/crypto/talitos/talitos.c
> @@ -133,75 +133,124 @@ void unmap_single_talitos_ptr(struct device *dev,
>   			 from_talitos_ptr_len(ptr, is_sec1), dir);
>   }
>   
> -static int reset_channel(struct device *dev, int ch)
> +static int sec1_reset_channel(struct device *dev, int ch)
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	unsigned int timeout = TALITOS_TIMEOUT;
> -	bool is_sec1 = has_ftr_sec1(priv);
>   
> -	if (is_sec1) {
> -		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
> -			  TALITOS1_CCCR_LO_RESET);
> +	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, TALITOS1_CCCR_LO_RESET);
>   
> -		while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR_LO) &
> -			TALITOS1_CCCR_LO_RESET) && --timeout)
> -			cpu_relax();
> -	} else {
> -		setbits32(priv->chan[ch].reg + TALITOS_CCCR,
> -			  TALITOS2_CCCR_RESET);
> +	while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR_LO) &
> +		TALITOS1_CCCR_LO_RESET) &&
> +	       --timeout)
> +		cpu_relax();
>   
> -		while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
> -			TALITOS2_CCCR_RESET) && --timeout)
> -			cpu_relax();
> +	if (timeout == 0) {
> +		dev_err(dev, "failed to reset sec1 channel %d\n", ch);
> +		return -EIO;
>   	}
>   
> +	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
> +		  TALITOS_CCCR_LO_NE | TALITOS_CCCR_LO_CDIE |
> +			  TALITOS_CCCR_LO_CDWE);
> +
> +	return 0;
> +}
> +
> +static int sec2_reset_channel(struct device *dev, int ch)
> +{
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +	unsigned int timeout = TALITOS_TIMEOUT;
> +
> +	setbits32(priv->chan[ch].reg + TALITOS_CCCR, TALITOS2_CCCR_RESET);
> +
> +	while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
> +		TALITOS2_CCCR_RESET) &&
> +	       --timeout)
> +		cpu_relax();
> +
>   	if (timeout == 0) {
> -		dev_err(dev, "failed to reset channel %d\n", ch);
> +		dev_err(dev, "failed to reset sec2 channel %d\n", ch);
>   		return -EIO;
>   	}
>   
> -	/* set 36-bit addressing, done writeback enable and done IRQ enable */
> -	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, TALITOS_CCCR_LO_EAE |
> -		  TALITOS_CCCR_LO_CDWE | TALITOS_CCCR_LO_CDIE);
> -	/* enable chaining descriptors */
> -	if (is_sec1)
> -		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
> -			  TALITOS_CCCR_LO_NE);
> +	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
> +		  TALITOS_CCCR_LO_EAE | TALITOS_CCCR_LO_CDWE |
> +			  TALITOS_CCCR_LO_CDIE);
>   
> -	/* and ICCR writeback, if available */
> +	/* ICCR writeback, if available */
>   	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
>   		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
> -		          TALITOS_CCCR_LO_IWSE);
> +			  TALITOS_CCCR_LO_IWSE);
>   
>   	return 0;
>   }
>   
> -static int reset_device(struct device *dev)
> +static int sec1_reset_device(struct device *dev)
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	unsigned int timeout = TALITOS_TIMEOUT;
> -	bool is_sec1 = has_ftr_sec1(priv);
> -	u32 mcr = is_sec1 ? TALITOS1_MCR_SWR : TALITOS2_MCR_SWR;
>   
> -	setbits32(priv->reg + TALITOS_MCR, mcr);
> +	setbits32(priv->reg + TALITOS_MCR, TALITOS1_MCR_SWR);
>   
> -	while ((in_be32(priv->reg + TALITOS_MCR) & mcr)
> -	       && --timeout)
> +	while ((in_be32(priv->reg + TALITOS_MCR) & TALITOS1_MCR_SWR) &&
> +	       --timeout)
>   		cpu_relax();
>   
> -	if (priv->irq[1]) {
> -		mcr = TALITOS_MCR_RCA1 | TALITOS_MCR_RCA3;
> -		setbits32(priv->reg + TALITOS_MCR, mcr);
> +	if (timeout == 0) {
> +		dev_err(dev, "failed to reset sec1 device\n");
> +		return -EIO;
>   	}
>   
> +	return 0;
> +}
> +
> +static int sec2_reset_device(struct device *dev)
> +{
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +	unsigned int timeout = TALITOS_TIMEOUT;
> +
> +	setbits32(priv->reg + TALITOS_MCR, TALITOS2_MCR_SWR);
> +
> +	while ((in_be32(priv->reg + TALITOS_MCR) & TALITOS2_MCR_SWR) &&
> +	       --timeout)
> +		cpu_relax();
> +
> +	if (priv->irq[1])
> +		setbits32(priv->reg + TALITOS_MCR,
> +			  TALITOS_MCR_RCA1 | TALITOS_MCR_RCA3);
> +
>   	if (timeout == 0) {
> -		dev_err(dev, "failed to reset device\n");
> +		dev_err(dev, "failed to reset sec2 device\n");
>   		return -EIO;
>   	}
>   
>   	return 0;
>   }
>   
> +static void sec1_configure_device(struct device *dev)
> +{
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +
> +	clrbits32(priv->reg + TALITOS_IMR, TALITOS1_IMR_INIT);
> +	clrbits32(priv->reg + TALITOS_IMR_LO, TALITOS1_IMR_LO_INIT);
> +	/* disable parity error check in DEU (erroneous? test vect.) */
> +	setbits32(priv->reg_deu + TALITOS_EUICR, TALITOS1_DEUICR_KPE);
> +}
> +
> +static void sec2_configure_device(struct device *dev)
> +{
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +
> +	setbits32(priv->reg + TALITOS_IMR, TALITOS2_IMR_INIT);
> +	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS2_IMR_LO_INIT);
> +
> +	/* disable integrity check error interrupts (use writeback instead) */
> +	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
> +		setbits32(priv->reg_mdeu + TALITOS_EUICR_LO,
> +			  TALITOS_MDEUICR_LO_ICE);
> +}
> +
>   /*
>    * Reset and initialize the device
>    */
> @@ -217,80 +266,81 @@ static int init_device(struct device *dev)
>   	 * are not fully cleared by writing the MCR:SWR bit,
>   	 * set bit twice to completely reset
>   	 */
> -	err = reset_device(dev);
> +	if (is_sec1)
> +		err = sec1_reset_device(dev);
> +	else
> +		err = sec2_reset_device(dev);
> +
>   	if (err)
>   		return err;
>   
> -	err = reset_device(dev);
> +	if (is_sec1)
> +		err = sec1_reset_device(dev);
> +	else
> +		err = sec2_reset_device(dev);
>   	if (err)
>   		return err;
>   
>   	/* reset channels */
>   	for (ch = 0; ch < priv->num_channels; ch++) {
> -		err = reset_channel(dev, ch);
> +		if (is_sec1)
> +			err = sec1_reset_channel(dev, ch);
> +		else
> +			err = sec2_reset_channel(dev, ch);
>   		if (err)
>   			return err;
>   	}
>   
> -	/* enable channel done and error interrupts */
> -	if (is_sec1) {
> -		clrbits32(priv->reg + TALITOS_IMR, TALITOS1_IMR_INIT);
> -		clrbits32(priv->reg + TALITOS_IMR_LO, TALITOS1_IMR_LO_INIT);
> -		/* disable parity error check in DEU (erroneous? test vect.) */
> -		setbits32(priv->reg_deu + TALITOS_EUICR, TALITOS1_DEUICR_KPE);
> -	} else {
> -		setbits32(priv->reg + TALITOS_IMR, TALITOS2_IMR_INIT);
> -		setbits32(priv->reg + TALITOS_IMR_LO, TALITOS2_IMR_LO_INIT);
> -	}
> -
> -	/* disable integrity check error interrupts (use writeback instead) */
> -	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
> -		setbits32(priv->reg_mdeu + TALITOS_EUICR_LO,
> -		          TALITOS_MDEUICR_LO_ICE);
> +	if (is_sec1)
> +		sec1_configure_device(dev);
> +	else
> +		sec2_configure_device(dev);
>   
>   	return 0;
>   }
>   
> -static void dma_map_request(struct device *dev, struct talitos_request *request,
> -			    struct talitos_desc *desc, bool is_sec1)
> +static void sec1_dma_map_request(struct device *dev,
> +				 struct talitos_request *request,
> +				 struct talitos_desc *desc)
>   {
>   	struct talitos_edesc *edesc =
>   		container_of(desc, struct talitos_edesc, desc);
>   	dma_addr_t dma_desc, prev_dma_desc;
>   	struct talitos_edesc *prev_edesc = NULL;
>   
> -	if (is_sec1) {
> -		while (edesc) {
> -			edesc->desc.hdr1 = edesc->desc.hdr;
> +	while (edesc) {
> +		edesc->desc.hdr1 = edesc->desc.hdr;
>   
> -			dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
> -						  TALITOS_DESC_SIZE,
> -						  DMA_BIDIRECTIONAL);
> +		dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
> +					  TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
>   
> -			if (!prev_edesc) {
> -				request->dma_desc = dma_desc;
> -				goto next;
> -			}
> +		if (!prev_edesc) {
> +			request->dma_desc = dma_desc;
> +			goto next;
> +		}
>   
> -			/* Chain in any previous descriptors. */
> +		/* Chain in any previous descriptors. */
>   
> -			prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
> +		prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
>   
> -			dma_sync_single_for_device(dev, prev_dma_desc,
> -						   TALITOS_DESC_SIZE,
> -						   DMA_TO_DEVICE);
> +		dma_sync_single_for_device(dev, prev_dma_desc,
> +					   TALITOS_DESC_SIZE, DMA_TO_DEVICE);
>   
>   next:
> -			prev_edesc = edesc;
> -			prev_dma_desc = dma_desc;
> -			edesc = edesc->next_desc;
> -		}
> -	} else {
> -		request->dma_desc = dma_map_single(dev, desc, TALITOS_DESC_SIZE,
> -						   DMA_BIDIRECTIONAL);
> +		prev_edesc = edesc;
> +		prev_dma_desc = dma_desc;
> +		edesc = edesc->next_desc;
>   	}
>   }
>   
> +static void sec2_dma_map_request(struct device *dev,
> +				 struct talitos_request *request,
> +				 struct talitos_desc *desc)
> +{
> +	request->dma_desc =
> +		dma_map_single(dev, desc, TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
> +}
> +
>   /**
>    * talitos_submit - submits a descriptor to the device for processing
>    * @dev:	the SEC device to be used
> @@ -327,7 +377,10 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
>   	request = &priv->chan[ch].fifo[head];
>   
>   	/* map descriptor and save caller data */
> -	dma_map_request(dev, request, desc, is_sec1);
> +	if (is_sec1)
> +		sec1_dma_map_request(dev, request, desc);
> +	else
> +		sec2_dma_map_request(dev, request, desc);
>   	request->callback = callback;
>   	request->context = context;
>   
> @@ -349,19 +402,12 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
>   	return -EINPROGRESS;
>   }
>   
> -static __be32 get_request_hdr(struct device *dev,
> -			      struct talitos_request *request, bool is_sec1)
> +static __be32 sec1_get_request_hdr(struct device *dev,
> +				   struct talitos_request *request)
>   {
>   	struct talitos_edesc *edesc;
>   	dma_addr_t dma_desc;
>   
> -	if (!is_sec1) {
> -		dma_sync_single_for_cpu(dev, request->dma_desc,
> -					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
> -
> -		return request->desc->hdr;
> -	}
> -
>   	edesc = container_of(request->desc, struct talitos_edesc, desc);
>   	dma_desc = request->dma_desc;
>   	while (edesc->next_desc) {
> @@ -375,27 +421,37 @@ static __be32 get_request_hdr(struct device *dev,
>   	return edesc->desc.hdr1;
>   }
>   
> -static void dma_unmap_request(struct device *dev,
> -			      struct talitos_request *request, bool is_sec1)
> +static __be32 sec2_get_request_hdr(struct device *dev,
> +				   struct talitos_request *request)
> +{
> +	dma_sync_single_for_cpu(dev, request->dma_desc, TALITOS_DESC_SIZE,
> +				DMA_BIDIRECTIONAL);
> +
> +	return request->desc->hdr;
> +}
> +
> +static void sec1_dma_unmap_request(struct device *dev,
> +				   struct talitos_request *request)
>   {
>   	struct talitos_edesc *edesc;
>   
> -	if (is_sec1) {
> -		dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
> -				 DMA_BIDIRECTIONAL);
> -		edesc = container_of(request->desc, struct talitos_edesc, desc);
> -		while (edesc->next_desc) {
> -			dma_unmap_single(dev,
> -					 be32_to_cpu(edesc->desc.next_desc),
> -					 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
> -			edesc = edesc->next_desc;
> -		}
> -	} else {
> -		dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
> -				 DMA_BIDIRECTIONAL);
> +	dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
> +			 DMA_BIDIRECTIONAL);
> +	edesc = container_of(request->desc, struct talitos_edesc, desc);
> +	while (edesc->next_desc) {
> +		dma_unmap_single(dev, be32_to_cpu(edesc->desc.next_desc),
> +				 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
> +		edesc = edesc->next_desc;
>   	}
>   }
>   
> +static void sec2_dma_unmap_request(struct device *dev,
> +				   struct talitos_request *request)
> +{
> +	dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
> +			 DMA_BIDIRECTIONAL);
> +}
> +
>   /*
>    * process what was done, notify callback of error if not
>    */
> @@ -417,7 +473,10 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
>   
>   		/* descriptors with their done bits set don't get the error */
>   		rmb();
> -		hdr = get_request_hdr(dev, request, is_sec1);
> +		if (is_sec1)
> +			hdr = sec1_get_request_hdr(dev, request);
> +		else
> +			hdr = sec2_get_request_hdr(dev, request);
>   
>   		if ((hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
>   			status = 0;
> @@ -427,7 +486,10 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
>   			else
>   				status = error;
>   
> -		dma_unmap_request(dev, request, is_sec1);
> +		if (is_sec1)
> +			sec1_dma_unmap_request(dev, request);
> +		else
> +			sec2_dma_unmap_request(dev, request);
>   
>   		/* copy entries so we can call callback outside lock */
>   		saved_req.desc = request->desc;
> @@ -516,21 +578,30 @@ DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE)
>   DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
>   DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
>   
> -static __be32 search_desc_hdr_in_request(struct talitos_request *request,
> -					 dma_addr_t cur_desc, bool is_sec1)
> +static __be32 sec1_search_desc_hdr_in_request(struct talitos_request *request,
> +					      dma_addr_t cur_desc)
>   {
>   	struct talitos_edesc *edesc;
>   
> -	if (request->dma_desc == cur_desc) {
> +
> +	if (request->dma_desc == cur_desc)
>   		return request->desc->hdr;
> -	} else if (is_sec1) {
> -		edesc = container_of(request->desc, struct talitos_edesc, desc);
> -		while (edesc->next_desc) {
> -			if (edesc->desc.next_desc == cpu_to_be32(cur_desc))
> -				return edesc->next_desc->desc.hdr1;
> -			edesc = edesc->next_desc;
> -		}
> +
> +	edesc = container_of(request->desc, struct talitos_edesc, desc);
> +	while (edesc->next_desc) {
> +		if (edesc->desc.next_desc == cpu_to_be32(cur_desc))
> +			return edesc->next_desc->desc.hdr1;
> +		edesc = edesc->next_desc;
>   	}
> +
> +	return 0;
> +}
> +
> +static __be32 sec2_search_desc_hdr_in_request(struct talitos_request *request,
> +					      dma_addr_t cur_desc)
> +{
> +	if (request->dma_desc == cur_desc)
> +		return request->desc->hdr;
>   	return 0;
>   }
>   
> @@ -559,7 +630,10 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
>   	do {
>   		request = &priv->chan[ch].fifo[iter];
>   
> -		hdr = search_desc_hdr_in_request(request, cur_desc, is_sec1);
> +		if (is_sec1)
> +			hdr = sec1_search_desc_hdr_in_request(request, cur_desc);
> +		else
> +			hdr = sec2_search_desc_hdr_in_request(request, cur_desc);
>   		if (hdr)
>   			break;
>   
> @@ -647,79 +721,100 @@ static void report_eu_error(struct device *dev, int ch, __be32 desc_hdr)
>   			in_be32(priv->chan[ch].reg + TALITOS_DESCBUF_LO + 8*i));
>   }
>   
> -/*
> - * recover from error interrupts
> - */
> -static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
> +static int sec1_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
> +{
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +	int ch, error;
> +	u32 v_lo;
> +
> +	for (ch = 0; ch < priv->num_channels; ch++) {
> +		if (!TALITOS1_CH_HAS_ERROR(isr, ch))
> +			continue;
> +
> +		v_lo = in_be32(priv->chan[ch].reg + TALITOS_CCPSR_LO);
> +
> +		error = -EINVAL;
> +
> +		if (v_lo & TALITOS1_CCPSR_LO_TEA)
> +			dev_err(dev, "transfer error acknowledge\n");
> +		if (v_lo & TALITOS1_CCPSR_LO_PTRNC)
> +			dev_err(dev, "pointer not complete error\n");
> +		if (v_lo & TALITOS1_CCPSR_LO_PE)
> +			dev_err(dev, "parity error\n");
> +		if (v_lo & TALITOS1_CCPSR_LO_IDH)
> +			dev_err(dev, "illegal descriptor header error\n");
> +		if (v_lo & TALITOS1_CCPSR_LO_SA)
> +			dev_err(dev, "static assignment error\n");
> +		if (v_lo & TALITOS1_CCPSR_LO_EU)
> +			report_eu_error(dev, ch, current_desc_hdr(dev, ch));
> +
> +		flush_channel(dev, ch, error, 1);
> +		priv->ops->reset_channel(dev, ch);
> +	}
> +
> +	if (isr_lo & TALITOS1_ISR_TEA_ERR)
> +		dev_err(dev, "TEA error: ISR 0x%08x_%08x\n", isr, isr_lo);
> +
> +	return (isr & ~TALITOS1_ISR_4CHERR) || isr_lo;
> +}
> +
> +static int sec2_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	unsigned int timeout = TALITOS_TIMEOUT;
>   	int ch, error, reset_dev = 0;
>   	u32 v_lo;
> -	bool is_sec1 = has_ftr_sec1(priv);
> -	int reset_ch = is_sec1 ? 1 : 0; /* only SEC2 supports continuation */
> +	int reset_ch = 0;
>   
>   	for (ch = 0; ch < priv->num_channels; ch++) {
> -		/* skip channels without errors */
> -		if (is_sec1) {
> -			/* bits 29, 31, 17, 19 */
> -			if (!(isr & (1 << (29 + (ch & 1) * 2 - (ch & 2) * 6))))
> -				continue;
> -		} else {
> -			if (!(isr & (1 << (ch * 2 + 1))))
> -				continue;
> -		}
> +		if (!TALITOS2_CH_HAS_ERROR(isr, ch))
> +			continue;
>   
>   		error = -EINVAL;
>   
>   		v_lo = in_be32(priv->chan[ch].reg + TALITOS_CCPSR_LO);
>   
> -		if (v_lo & TALITOS_CCPSR_LO_DOF) {
> +		if (v_lo & TALITOS2_CCPSR_LO_DOF) {
>   			dev_err(dev, "double fetch fifo overflow error\n");
>   			error = -EAGAIN;
>   			reset_ch = 1;
>   		}
> -		if (v_lo & TALITOS_CCPSR_LO_SOF) {
> +		if (v_lo & TALITOS2_CCPSR_LO_SOF) {
>   			/* h/w dropped descriptor */
>   			dev_err(dev, "single fetch fifo overflow error\n");
>   			error = -EAGAIN;
>   		}
> -		if (v_lo & TALITOS_CCPSR_LO_MDTE)
> +		if (v_lo & TALITOS2_CCPSR_LO_MDTE)
>   			dev_err(dev, "master data transfer error\n");
> -		if (v_lo & TALITOS_CCPSR_LO_SGDLZ)
> -			dev_err(dev, is_sec1 ? "pointer not complete error\n"
> -					     : "s/g data length zero error\n");
> -		if (v_lo & TALITOS_CCPSR_LO_FPZ)
> -			dev_err(dev, is_sec1 ? "parity error\n"
> -					     : "fetch pointer zero error\n");
> -		if (v_lo & TALITOS_CCPSR_LO_IDH)
> +		if (v_lo & TALITOS2_CCPSR_LO_SGDLZ)
> +			dev_err(dev, "s/g data length zero error\n");
> +		if (v_lo & TALITOS2_CCPSR_LO_FPZ)
> +			dev_err(dev, "fetch pointer zero error\n");
> +		if (v_lo & TALITOS2_CCPSR_LO_IDH)
>   			dev_err(dev, "illegal descriptor header error\n");
> -		if (v_lo & TALITOS_CCPSR_LO_IEU)
> -			dev_err(dev, is_sec1 ? "static assignment error\n"
> -					     : "invalid exec unit error\n");
> -		if (v_lo & TALITOS_CCPSR_LO_EU)
> +		if (v_lo & TALITOS2_CCPSR_LO_IEU)
> +			dev_err(dev, "invalid exec unit error\n");
> +		if (v_lo & TALITOS2_CCPSR_LO_EU)
>   			report_eu_error(dev, ch, current_desc_hdr(dev, ch));
> -		if (!is_sec1) {
> -			if (v_lo & TALITOS_CCPSR_LO_GB)
> -				dev_err(dev, "gather boundary error\n");
> -			if (v_lo & TALITOS_CCPSR_LO_GRL)
> -				dev_err(dev, "gather return/length error\n");
> -			if (v_lo & TALITOS_CCPSR_LO_SB)
> -				dev_err(dev, "scatter boundary error\n");
> -			if (v_lo & TALITOS_CCPSR_LO_SRL)
> -				dev_err(dev, "scatter return/length error\n");
> -		}
> +		if (v_lo & TALITOS2_CCPSR_LO_GB)
> +			dev_err(dev, "gather boundary error\n");
> +		if (v_lo & TALITOS2_CCPSR_LO_GRL)
> +			dev_err(dev, "gather return/length error\n");
> +		if (v_lo & TALITOS2_CCPSR_LO_SB)
> +			dev_err(dev, "scatter boundary error\n");
> +		if (v_lo & TALITOS2_CCPSR_LO_SRL)
> +			dev_err(dev, "scatter return/length error\n");
>   
>   		flush_channel(dev, ch, error, reset_ch);
>   
>   		if (reset_ch) {
> -			reset_channel(dev, ch);
> +			priv->ops->reset_channel(dev, ch);
>   		} else {
>   			setbits32(priv->chan[ch].reg + TALITOS_CCCR,
>   				  TALITOS2_CCCR_CONT);
>   			setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, 0);
>   			while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
> -			       TALITOS2_CCCR_CONT) && --timeout)
> +				TALITOS2_CCCR_CONT) && --timeout)
>   				cpu_relax();
>   			if (timeout == 0) {
>   				dev_err(dev, "failed to restart channel %d\n",
> @@ -728,14 +823,29 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
>   			}
>   		}
>   	}
> -	if (reset_dev || (is_sec1 && isr & ~TALITOS1_ISR_4CHERR) ||
> -	    (!is_sec1 && isr & ~TALITOS2_ISR_4CHERR) || isr_lo) {
> -		if (is_sec1 && (isr_lo & TALITOS1_ISR_TEA_ERR))
> -			dev_err(dev, "TEA error: ISR 0x%08x_%08x\n",
> -				isr, isr_lo);
> -		else
> -			dev_err(dev, "done overflow, internal time out, or "
> -				"rngu error: ISR 0x%08x_%08x\n", isr, isr_lo);
> +
> +	return reset_dev || (isr & ~TALITOS2_ISR_4CHERR) || isr_lo;
> +}
> +
> +/*
> + * recover from error interrupts
> + */
> +static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
> +{
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +	bool is_sec1 = has_ftr_sec1(priv);
> +	int ch, reset_dev;
> +
> +	if (is_sec1)
> +		reset_dev = sec1_talitos_handle_error(dev, isr, isr_lo);
> +	else
> +		reset_dev = sec2_talitos_handle_error(dev, isr, isr_lo);
> +
> +	if (reset_dev) {
> +		dev_err(dev,
> +			"done overflow, internal time out, or "
> +			"rngu error: ISR 0x%08x_%08x\n",
> +			isr, isr_lo);
>   
>   		/* purge request queues */
>   		for (ch = 0; ch < priv->num_channels; ch++)
> @@ -1181,25 +1291,41 @@ int talitos_register_common(struct device *dev,
>   	return 0;
>   }
>   
> -static int talitos_probe_irq(struct platform_device *ofdev)
> +static int sec1_talitos_probe_irq(struct platform_device *ofdev)
>   {
>   	struct device *dev = &ofdev->dev;
>   	struct device_node *np = ofdev->dev.of_node;
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	int err;
> -	bool is_sec1 = has_ftr_sec1(priv);
>   
>   	priv->irq[0] = irq_of_parse_and_map(np, 0);
>   	if (!priv->irq[0]) {
>   		dev_err(dev, "failed to map irq\n");
>   		return -EINVAL;
>   	}
> -	if (is_sec1) {
> -		err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
> -				  dev_driver_string(dev), dev);
> -		goto primary_out;
> +	err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
> +			  dev_driver_string(dev), dev);
> +	if (err) {
> +		dev_err(dev, "failed to request primary irq\n");
> +		irq_dispose_mapping(priv->irq[0]);
> +		priv->irq[0] = 0;
>   	}
>   
> +	return err;
> +}
> +
> +static int sec2_talitos_probe_irq(struct platform_device *ofdev)
> +{
> +	struct device *dev = &ofdev->dev;
> +	struct device_node *np = ofdev->dev.of_node;
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +	int err;
> +
> +	priv->irq[0] = irq_of_parse_and_map(np, 0);
> +	if (!priv->irq[0]) {
> +		dev_err(dev, "failed to map irq\n");
> +		return -EINVAL;
> +	}
>   	priv->irq[1] = irq_of_parse_and_map(np, 1);
>   
>   	/* get the primary irq line */
> @@ -1235,6 +1361,36 @@ static int talitos_probe_irq(struct platform_device *ofdev)
>   	return err;
>   }
>   
> +static void sec1_init_task(struct device *dev)
> +{
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +
> +	if (priv->num_channels == 1)
> +		tasklet_init(&priv->done_task[0], talitos1_done_ch0,
> +			     (unsigned long)dev);
> +	else
> +		tasklet_init(&priv->done_task[0], talitos1_done_4ch,
> +			     (unsigned long)dev);
> +}
> +
> +static void sec2_init_task(struct device *dev)
> +{
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +
> +	if (priv->irq[1]) {
> +		tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
> +			     (unsigned long)dev);
> +		tasklet_init(&priv->done_task[1], talitos2_done_ch1_3,
> +			     (unsigned long)dev);
> +	} else if (priv->num_channels == 1) {
> +		tasklet_init(&priv->done_task[0], talitos2_done_ch0,
> +			     (unsigned long)dev);
> +	} else {
> +		tasklet_init(&priv->done_task[0], talitos2_done_4ch,
> +			     (unsigned long)dev);
> +	}
> +}
> +
>   static int talitos_probe(struct platform_device *ofdev)
>   {
>   	struct device *dev = &ofdev->dev;
> @@ -1317,31 +1473,17 @@ static int talitos_probe(struct platform_device *ofdev)
>   		stride = TALITOS2_CH_STRIDE;
>   	}
>   
> -	err = talitos_probe_irq(ofdev);
> +	if (has_ftr_sec1(priv))
> +		err = sec1_talitos_probe_irq(ofdev);
> +	else
> +		err = sec2_talitos_probe_irq(ofdev);
>   	if (err)
>   		goto err_out;
>   
> -	if (has_ftr_sec1(priv)) {
> -		if (priv->num_channels == 1)
> -			tasklet_init(&priv->done_task[0], talitos1_done_ch0,
> -				     (unsigned long)dev);
> -		else
> -			tasklet_init(&priv->done_task[0], talitos1_done_4ch,
> -				     (unsigned long)dev);
> -	} else {
> -		if (priv->irq[1]) {
> -			tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
> -				     (unsigned long)dev);
> -			tasklet_init(&priv->done_task[1], talitos2_done_ch1_3,
> -				     (unsigned long)dev);
> -		} else if (priv->num_channels == 1) {
> -			tasklet_init(&priv->done_task[0], talitos2_done_ch0,
> -				     (unsigned long)dev);
> -		} else {
> -			tasklet_init(&priv->done_task[0], talitos2_done_4ch,
> -				     (unsigned long)dev);
> -		}
> -	}
> +	if (has_ftr_sec1(priv))
> +		sec1_init_task(dev);
> +	else
> +		sec2_init_task(dev);
>   
>   	priv->fifo_len = roundup_pow_of_two(priv->chfifo_len);
>   
> diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
> index 6cf3628c52c2..904fdc9dec80 100644
> --- a/drivers/crypto/talitos/talitos.h
> +++ b/drivers/crypto/talitos/talitos.h
> @@ -301,20 +301,32 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
>   #define   TALITOS1_CCCR_LO_RESET	0x1    /* channel reset on SEC1 */
>   
>   /* CCPSR: channel pointer status register */
> +
> +/* bits 29, 31, 17, 19 */
> +#define TALITOS1_CH_HAS_ERROR(isr, ch) \
> +	((isr) & (1 << (29 + ((ch) & 1) * 2 - ((ch) & 2) * 6)))
> +#define TALITOS2_CH_HAS_ERROR(isr, ch) ((isr) & (1 << ((ch) * 2 + 1)))
> +
>   #define TALITOS_CCPSR			0x10
>   #define TALITOS_CCPSR_LO		0x14
> -#define   TALITOS_CCPSR_LO_DOF		0x8000 /* double FF write oflow error */
> -#define   TALITOS_CCPSR_LO_SOF		0x4000 /* single FF write oflow error */
> -#define   TALITOS_CCPSR_LO_MDTE		0x2000 /* master data transfer error */
> -#define   TALITOS_CCPSR_LO_SGDLZ	0x1000 /* s/g data len zero error */
> -#define   TALITOS_CCPSR_LO_FPZ		0x0800 /* fetch ptr zero error */
> -#define   TALITOS_CCPSR_LO_IDH		0x0400 /* illegal desc hdr error */
> -#define   TALITOS_CCPSR_LO_IEU		0x0200 /* invalid EU error */
> -#define   TALITOS_CCPSR_LO_EU		0x0100 /* EU error detected */
> -#define   TALITOS_CCPSR_LO_GB		0x0080 /* gather boundary error */
> -#define   TALITOS_CCPSR_LO_GRL		0x0040 /* gather return/length error */
> -#define   TALITOS_CCPSR_LO_SB		0x0020 /* scatter boundary error */
> -#define   TALITOS_CCPSR_LO_SRL		0x0010 /* scatter return/length error */
> +#define   TALITOS1_CCPSR_LO_TEA		0x2000 /* transfer error acknowledge */
> +#define   TALITOS1_CCPSR_LO_PTRNC	0x1000 /* pointer not complete error */
> +#define   TALITOS1_CCPSR_LO_PE		0x0800 /* parity error */
> +#define   TALITOS1_CCPSR_LO_IDH		0x0400 /* illegal desc hdr error */
> +#define   TALITOS1_CCPSR_LO_SA		0x0200 /* static assignment error */
> +#define   TALITOS1_CCPSR_LO_EU		0x0100 /* EU error detected */
> +#define   TALITOS2_CCPSR_LO_DOF		0x8000 /* double FF write oflow error */
> +#define   TALITOS2_CCPSR_LO_SOF		0x4000 /* single FF write oflow error */
> +#define   TALITOS2_CCPSR_LO_MDTE	0x2000 /* master data transfer error */
> +#define   TALITOS2_CCPSR_LO_SGDLZ	0x1000 /* s/g data len zero error */
> +#define   TALITOS2_CCPSR_LO_FPZ		0x0800 /* fetch ptr zero error */
> +#define   TALITOS2_CCPSR_LO_IDH		0x0400 /* illegal desc hdr error */
> +#define   TALITOS2_CCPSR_LO_IEU		0x0200 /* invalid EU error */
> +#define   TALITOS2_CCPSR_LO_EU		0x0100 /* EU error detected */
> +#define   TALITOS2_CCPSR_LO_GB		0x0080 /* gather boundary error */
> +#define   TALITOS2_CCPSR_LO_GRL		0x0040 /* gather return/length error */
> +#define   TALITOS2_CCPSR_LO_SB		0x0020 /* scatter boundary error */
> +#define   TALITOS2_CCPSR_LO_SRL		0x0010 /* scatter return/length error */
>   
>   /* channel fetch fifo register */
>   #define TALITOS_FF			0x48
> 

