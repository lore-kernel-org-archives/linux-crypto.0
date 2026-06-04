Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D373264CF;
	Thu,  4 Jun 2026 09:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780565881; cv=none; b=jj8Vi0sagMoeXkwuT52t9yzPFwj6hYaoWmwEKR2uHj/yUowVe9OKuP+nMBmYgINWgQuuw8T1Obfi7kfLfHKW8n4L3xCHgxR/SUAWYcUIZu0P39D128VAGzfr59LwLmyRN1zLTNuQaN4jzmU/JOWgwuJYss3txWYa4WJK/rpMAGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780565881; c=relaxed/simple;
	bh=wpm9AXofKUrtZeyvDk5gVDnSH5UWhLWdiSpqyjD5K9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gCFf/6pPNVodYHfoQkaHowtLhOumkVcDBLIzuKEyyfaxYECf6o6i1FLwpm6ahyxdY+xPofXplJUTshW8uSOAL8EuVRk3LspeA1jcmoxBBs1kgKrOJEoHijpbCt8KwInvdOht0IJN/NV9ZxO9vfp4M3fYjFP8VM/HuSHLtlFdTm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/jf3bU5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/jf3bU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09521F00893;
	Thu,  4 Jun 2026 09:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780565879;
	bh=PZESff+3K5aN8VsDlxLWWoHzK60uf539ndleuuoF1ws=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E/jf3bU5qs06MXjFXNuVzYPSmeefgOrwyzPamyrK16ToFj6ZQi5CVr8shqEwWIrOZ
	 FFPwi+1wN+Gppxs315blq048C0hJfFGQSI1/ma7W2y0iFdcgqewrmZAm7xjqD2kTzy
	 7Msk3Y+EMURUXqynurxpkKbDHEIcSH57rCoxgdT3EC4rJHIbPmAIoP6NaWndpO18Yt
	 fXkv8kJuZ6IeltmIWYLkdy7TtZ06enHZY5DicG3oa7mEpBGSdDcqjfgItej/KzOZOj
	 nLLe9KO+yiZqVzgI/atgoK5NjQwyq3QoO1BMyCtXjECNzx4rDfi4m9lM2ywY3rCLFM
	 936/12COmN9jA==
Message-ID: <5dce751a-0d48-467e-b8c9-6702366cfd06@kernel.org>
Date: Thu, 4 Jun 2026 11:37:55 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/29] crypto: talitos - Replace SEC1/SEC2 conditionals
 with ops dispatch
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-20-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-20-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Replace the if/else is_sec1 dispatches in callers with indirect calls
> through priv->ops. Add static const sec1_ops and sec2_ops structs
> populated with the SEC1 and SEC2 function variants, and set priv->ops
> at probe time based on the detected hardware.

Why is that needed ?

I understand your objective at the end is to get rid of that is_sec1 
boolean that is carried over the entire call chain but using ops for 
that seems overkill.

What about changing it to a helper using static branches, something like 
(untested) :

#if defined(CONFIG_CRYPTO_DEV_TALITOS1) && 
defined(CONFIG_CRYPTO_DEV_TALITOS2)
DECLARE_STATIC_KEY_FALSE(talitos_is_sec1);
static __always_inline bool is_sec1(void)
{
	return static_branch_unlikely(&talitos_is_sec1);
}

static inline void talitos_init_branch(bool is_sec1)
{
	if (is_sec1)
		static_branch_enable(&talitos_is_sec1);
}
#else
static __always_inline bool is_sec1(void)
{
	return IS_ENABLED(CONFIG_CRYPTO_DEV_TALITOS1);
}

static inline void talitos_init_branch(bool is_sec1)
{
	BUILD_BUG_ON(is_sec1 && !IS_ENABLED(CONFIG_CRYPTO_DEV_TALITOS1));
}
#endif

> 
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
>   drivers/crypto/talitos/talitos.c | 88 +++++++++++++++++++---------------------
>   1 file changed, 41 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
> index b6793d97735e..c4a311a8e7fd 100644
> --- a/drivers/crypto/talitos/talitos.c
> +++ b/drivers/crypto/talitos/talitos.c
> @@ -258,7 +258,6 @@ static int init_device(struct device *dev)
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	int ch, err;
> -	bool is_sec1 = has_ftr_sec1(priv);
>   
>   	/*
>   	 * Master reset
> @@ -266,35 +265,23 @@ static int init_device(struct device *dev)
>   	 * are not fully cleared by writing the MCR:SWR bit,
>   	 * set bit twice to completely reset
>   	 */
> -	if (is_sec1)
> -		err = sec1_reset_device(dev);
> -	else
> -		err = sec2_reset_device(dev);
> +	err = priv->ops->reset_device(dev);
>   
>   	if (err)
>   		return err;
>   
> -	if (is_sec1)
> -		err = sec1_reset_device(dev);
> -	else
> -		err = sec2_reset_device(dev);
> +	err = priv->ops->reset_device(dev);
>   	if (err)
>   		return err;
>   
>   	/* reset channels */
>   	for (ch = 0; ch < priv->num_channels; ch++) {
> -		if (is_sec1)
> -			err = sec1_reset_channel(dev, ch);
> -		else
> -			err = sec2_reset_channel(dev, ch);
> +		err = priv->ops->reset_channel(dev, ch);
>   		if (err)
>   			return err;
>   	}
>   
> -	if (is_sec1)
> -		sec1_configure_device(dev);
> -	else
> -		sec2_configure_device(dev);
> +	priv->ops->configure_device(dev);
>   
>   	return 0;
>   }
> @@ -363,7 +350,6 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
>   	struct talitos_request *request;
>   	unsigned long flags;
>   	int head;
> -	bool is_sec1 = has_ftr_sec1(priv);
>   
>   	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
>   
> @@ -377,10 +363,8 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
>   	request = &priv->chan[ch].fifo[head];
>   
>   	/* map descriptor and save caller data */
> -	if (is_sec1)
> -		sec1_dma_map_request(dev, request, desc);
> -	else
> -		sec2_dma_map_request(dev, request, desc);
> +	priv->ops->dma_map_request(dev, request, desc);
> +
>   	request->callback = callback;
>   	request->context = context;
>   
> @@ -461,7 +445,6 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
>   	struct talitos_request *request, saved_req;
>   	unsigned long flags;
>   	int tail, status;
> -	bool is_sec1 = has_ftr_sec1(priv);
>   
>   	spin_lock_irqsave(&priv->chan[ch].tail_lock, flags);
>   
> @@ -473,10 +456,7 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
>   
>   		/* descriptors with their done bits set don't get the error */
>   		rmb();
> -		if (is_sec1)
> -			hdr = sec1_get_request_hdr(dev, request);
> -		else
> -			hdr = sec2_get_request_hdr(dev, request);
> +		hdr = priv->ops->get_request_hdr(dev, request);
>   
>   		if ((hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
>   			status = 0;
> @@ -486,10 +466,7 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
>   			else
>   				status = error;
>   
> -		if (is_sec1)
> -			sec1_dma_unmap_request(dev, request);
> -		else
> -			sec2_dma_unmap_request(dev, request);
> +		priv->ops->dma_unmap_request(dev, request);
>   
>   		/* copy entries so we can call callback outside lock */
>   		saved_req.desc = request->desc;
> @@ -611,7 +588,6 @@ static __be32 sec2_search_desc_hdr_in_request(struct talitos_request *request,
>   static __be32 current_desc_hdr(struct device *dev, int ch)
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
> -	bool is_sec1 = has_ftr_sec1(priv);
>   	struct talitos_request *request;
>   	int tail, iter;
>   	dma_addr_t cur_desc;
> @@ -630,10 +606,7 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
>   	do {
>   		request = &priv->chan[ch].fifo[iter];
>   
> -		if (is_sec1)
> -			hdr = sec1_search_desc_hdr_in_request(request, cur_desc);
> -		else
> -			hdr = sec2_search_desc_hdr_in_request(request, cur_desc);
> +		hdr = priv->ops->search_desc_hdr_in_request(request, cur_desc);
>   		if (hdr)
>   			break;
>   
> @@ -833,13 +806,9 @@ static int sec2_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
>   static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
> -	bool is_sec1 = has_ftr_sec1(priv);
>   	int ch, reset_dev;
>   
> -	if (is_sec1)
> -		reset_dev = sec1_talitos_handle_error(dev, isr, isr_lo);
> -	else
> -		reset_dev = sec2_talitos_handle_error(dev, isr, isr_lo);
> +	reset_dev = priv->ops->handle_error(dev, isr, isr_lo);
>   
>   	if (reset_dev) {
>   		dev_err(dev,
> @@ -1391,6 +1360,32 @@ static void sec2_init_task(struct device *dev)
>   	}
>   }
>   
> +static const struct talitos_ops sec1_ops = {
> +	.probe_irq = sec1_talitos_probe_irq,
> +	.init_task = sec1_init_task,
> +	.reset_device = sec1_reset_device,
> +	.reset_channel = sec1_reset_channel,
> +	.configure_device = sec1_configure_device,
> +	.dma_map_request = sec1_dma_map_request,
> +	.dma_unmap_request = sec1_dma_unmap_request,
> +	.get_request_hdr = sec1_get_request_hdr,
> +	.search_desc_hdr_in_request = sec1_search_desc_hdr_in_request,
> +	.handle_error = sec1_talitos_handle_error,
> +};
> +
> +static const struct talitos_ops sec2_ops = {
> +	.probe_irq = sec2_talitos_probe_irq,
> +	.init_task = sec2_init_task,
> +	.reset_device = sec2_reset_device,
> +	.reset_channel = sec2_reset_channel,
> +	.configure_device = sec2_configure_device,
> +	.dma_map_request = sec2_dma_map_request,
> +	.dma_unmap_request = sec2_dma_unmap_request,
> +	.get_request_hdr = sec2_get_request_hdr,
> +	.search_desc_hdr_in_request = sec2_search_desc_hdr_in_request,
> +	.handle_error = sec2_talitos_handle_error,
> +};
> +
>   static int talitos_probe(struct platform_device *ofdev)
>   {
>   	struct device *dev = &ofdev->dev;
> @@ -1474,16 +1469,15 @@ static int talitos_probe(struct platform_device *ofdev)
>   	}
>   
>   	if (has_ftr_sec1(priv))
> -		err = sec1_talitos_probe_irq(ofdev);
> +		priv->ops = &sec1_ops;
>   	else
> -		err = sec2_talitos_probe_irq(ofdev);
> +		priv->ops = &sec2_ops;
> +
> +	err = priv->ops->probe_irq(ofdev);
>   	if (err)
>   		goto err_out;
>   
> -	if (has_ftr_sec1(priv))
> -		sec1_init_task(dev);
> -	else
> -		sec2_init_task(dev);
> +	priv->ops->init_task(dev);
>   
>   	priv->fifo_len = roundup_pow_of_two(priv->chfifo_len);
>   
> 

