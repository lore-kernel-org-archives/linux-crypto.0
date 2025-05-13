Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA51EEAC7;
	Tue, 13 May 2025 08:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747123223; cv=none; b=S7MAF9xyCG12bzjGiX1/CIu5H1ExSmZg6jhZJg49Z2Vyz3DLlalZ7K8YtE9KXVOJA4o9qm4oy6teQKZmii+sWUnlJgdToAPhH3LjKjgLKeKoHhaWbPTEQZBbtFM8fzyiDVQ62WHzNO9gAlNbZS2/878tAdoLkmwUI5wAyzKw3jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747123223; c=relaxed/simple;
	bh=wEenYHHWJ9V5aj4emFyoFLBOwGXkZN558Odcr7RWChA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ta6A7xQIvCQe4dwgIiR8qEPjzEcHOLCmrObHzfYt8nsodhDIfNAEvLMTOvdNYGJJUr92MrJlp52RXeeOIuKmVMWKkW9VM6yYRNrTR7lLySjWtjPWMwOdotr1GZ6q6yJbYLpzWjDYTo2vKjSlBAi5N6BQfGJj3mHyQdAiBzO6vyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=US9sP3tq; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="US9sP3tq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HbsAu37T82bXcUeXJnp8nD65sIahcgoyyzcqcX2y3ZE=; b=US9sP3tqbb8EbobI3dSoMfXZb/
	tDWXTeDo46GzC/9mkp9Q12y5Celu5x1QNqpJ1GzciOcXw61hulVzsGjnoFUDcz47/Zcu1+r3QFklz
	RTL+J6EyouOhaVQlBNn78U/yu/OUZxD77uLUpRHYlPceqagF73OTsZBTR+5OzjU1mzlBerpi/qm35
	7nDtIUpsYdKGSnkpeHYiLYD7INHGJaRAgm04JrTuTjZPeLZn0MbHUBKeSybHQ8p9I42fnZVJrSFYn
	sbdbptUG9F2AaePoKUITm/QRKzlGSSNdxRKuaKcpONloTwXkuzgJD95a4vBtCigauB54knnVEA5zv
	hdb1SeSA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEkYZ-005hKh-2m;
	Tue, 13 May 2025 16:00:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 16:00:07 +0800
Date: Tue, 13 May 2025 16:00:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 2/2] crypto: ti: Add driver for DTHE V2 AES Engine
 (ECB, CBC)
Message-ID: <aCL8BxpHr5OpT04k@gondor.apana.org.au>
References: <20250508101723.846210-2-t-pratham@ti.com>
 <20250508101723.846210-4-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508101723.846210-4-t-pratham@ti.com>

On Thu, May 08, 2025 at 03:37:41PM +0530, T Pratham wrote:
>
> +static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
> +{
> +	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct dthe_data *dev_data = dthe_get_dev(ctx);
> +
> +	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
> +	u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
> +	u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
> +
> +	memzero_explicit(ctx, sizeof(*ctx));
> +	ctx->dev_data = dev_data;
> +	ctx->ctx_info.aes_ctx = kzalloc(sizeof(*ctx->ctx_info.aes_ctx), GFP_KERNEL);
> +	if (!ctx->ctx_info.aes_ctx)
> +		return -ENOMEM;

The ctx_info union should just become part of ctx instead of a
separate allocation.

> +	crypto_skcipher_set_reqsize(tfm, sizeof(struct dthe_aes_req_ctx));

Please set cra_reqsize instead in the algorithm.

> +	aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
> +	writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
> +
> +	aes_irqenable_val |= DTHE_AES_IRQENABLE_EN_ALL;
> +	writel_relaxed(aes_irqenable_val, aes_base_reg + DTHE_P_AES_IRQENABLE);

This does not look right.  The tfm allocation happens once for each
key, and they could be done concurrently.  You should not be operating
on the hardware in the init_tfm function.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
