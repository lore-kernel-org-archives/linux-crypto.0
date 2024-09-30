Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19946189902;
	Mon, 30 Sep 2024 13:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727702743; cv=none; b=m0wh6YjUM4dPxRnjCWbc4GX4TfG3uY5StBq9H/7apiTI+YSNFwRHZATI+OhiFL2BJz+eLIHUlDElt1tzdCkSy/skICu3WwKLXe4JiqA+vDTcACxoYaNJHDDpXkFpVU1u5aJRFKaksSMOZEGHrLpXp/f7HpvwkKWskfIev5OH0eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727702743; c=relaxed/simple;
	bh=AgxyAnJ5EQ/LR3SVJtEalqWx68cjEE7WvGTJNPg4MJY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UhDV10T5gjLC+kPS30vfUE5zvwEyxGjjQiJ9IT4I9ksIbZxOJOSdS52Yq/gH9GyLfqIkSye+eYQ1+TOJu0hNYrhkVbxgV898Zktp1/HjLHhwpXa+wmfWbAvt0tOEW54tkEWy5yiqsJgEHwKV/ioBniSnq9xeGNifEltf0Kba3zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r+PFsEo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r+PFsEo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BE8C4CECF;
	Mon, 30 Sep 2024 13:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727702742;
	bh=AgxyAnJ5EQ/LR3SVJtEalqWx68cjEE7WvGTJNPg4MJY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r+PFsEo6FraBZuvaXE0ZiuhmI5gaG2OLqM/Ej34DNje4AnqzPexqyMeJbffhI8Lkm
	 9Z33ljcE25eOP/Y0HsPQoDvLNT4hGTHCsrXJJ4hcu1g4xYK9vGcG8IlGedWnI4rz01
	 y5NOseuPwbvFa19YzfFd01ibCL67UgmDL1wWNmE4Bvjj+EqlOonJ9mGe6IgXbQDGW3
	 9z8z6PoBOpXJOmMDOKbTNwBxqVUNrlZr0mkx2xOniPSQBms/ao5UCPGldDNzsqWDeF
	 GNbPxcQ2+p+TFQ5YRLw3LiuwnrJI1xMk9aFA15MNjEYP0I86o79OLKjQT+/L/hzHbt
	 5it+AVW3b7auw==
Message-ID: <3cc10e1c-bec7-4432-a067-72f8eb514b5f@kernel.org>
Date: Mon, 30 Sep 2024 15:25:37 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 4/7] Add SPAcc AEAD support
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
 devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org, robh@kernel.org
Cc: Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
 bhoomikak@vayavyalabs.com, Shweta Raikar <shwetar@vayavyalabs.com>
References: <20240930093054.215809-1-pavitrakumarm@vayavyalabs.com>
 <20240930093054.215809-5-pavitrakumarm@vayavyalabs.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 fv0=
In-Reply-To: <20240930093054.215809-5-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/09/2024 11:30, Pavitrakumar M wrote:
> Add AEAD support to SPAcc driver.
> Below are the supported AEAD algos:
> - ccm(sm4)
> - ccm(aes)
> - gcm(sm4)
> - gcm(aes)
> - rfc7539(chacha20,poly1305)

...

> +
> +struct spacc_iv_buf {
> +	unsigned char iv[SPACC_MAX_IV_SIZE];
> +	unsigned char spacc_adata[ADATA_BUF_SIZE];
> +	struct scatterlist sg[2], spacc_adata_sg[2];
> +	struct scatterlist *spacc_ptextsg, temp_aad[2];
> +};
> +
> +static struct kmem_cache *spacc_iv_pool;

How do you handle multiple devices? I don't see it...

> +
> +static struct mode_tab possible_aeads[] = {
> +	{ MODE_TAB_AEAD("rfc7539(chacha20,poly1305)",
> +			CRYPTO_MODE_CHACHA20_POLY1305, CRYPTO_MODE_NULL,
> +			16, 12, 1), .keylen = { 16, 24, 32 }
> +	},
> +	{ MODE_TAB_AEAD("gcm(aes)",
> +			CRYPTO_MODE_AES_GCM, CRYPTO_MODE_NULL,
> +			16, 12, 1), .keylen = { 16, 24, 32 }
> +	},
> +	{ MODE_TAB_AEAD("gcm(sm4)",
> +			CRYPTO_MODE_SM4_GCM, CRYPTO_MODE_NULL,
> +			16, 12, 1), .keylen = { 16 }
> +	},
> +	{ MODE_TAB_AEAD("ccm(aes)",
> +			CRYPTO_MODE_AES_CCM, CRYPTO_MODE_NULL,
> +			16, 16, 1), .keylen = { 16, 24, 32 }
> +	},
> +	{ MODE_TAB_AEAD("ccm(sm4)",
> +			CRYPTO_MODE_SM4_CCM, CRYPTO_MODE_NULL,
> +			16, 16, 1), .keylen = { 16, 24, 32 }
> +	},
> +};

...

> +
> +static int spacc_register_aead(unsigned int aead_mode,
> +			       struct platform_device *spacc_pdev)
> +{
> +	int rc;
> +	struct spacc_alg *salg;
> +
> +	salg = kmalloc(sizeof(*salg), GFP_KERNEL);
> +	if (!salg)
> +		return -ENOMEM;
> +
> +	salg->mode	= &possible_aeads[aead_mode];
> +	salg->dev[0]	= &spacc_pdev->dev;
> +	salg->dev[1]	= NULL;
> +	salg->calg	= &salg->alg.aead.base;
> +	salg->alg.aead	= spacc_aead_algs;
> +
> +	spacc_init_aead_alg(salg->calg, salg->mode);
> +
> +	salg->alg.aead.ivsize		  = salg->mode->ivlen;
> +	salg->alg.aead.maxauthsize	  = salg->mode->hashlen;
> +	salg->alg.aead.base.cra_blocksize = salg->mode->blocklen;
> +
> +	salg->keylen_mask = possible_aeads[aead_mode].keylen_mask;
> +
> +	if (salg->mode->aead.ciph & SPACC_MANGLE_IV_FLAG) {
> +		switch (salg->mode->aead.ciph & 0x7F00) {
> +		case SPACC_MANGLE_IV_RFC3686: /*CTR*/
> +		case SPACC_MANGLE_IV_RFC4106: /*GCM*/
> +		case SPACC_MANGLE_IV_RFC4543: /*GMAC*/
> +		case SPACC_MANGLE_IV_RFC4309: /*CCM*/
> +		case SPACC_MANGLE_IV_RFC8998: /*GCM/CCM*/
> +			salg->alg.aead.ivsize  = 12;
> +			break;
> +		}
> +	}
> +
> +	rc = crypto_register_aead(&salg->alg.aead);
> +	if (rc < 0) {
> +		kfree(salg);
> +		return rc;
> +	}
> +
> +	dev_dbg(salg->dev[0], "Registered %s\n", salg->mode->name);

Drop, too trivial.

> +
> +	mutex_lock(&spacc_aead_alg_mutex);
> +	list_add(&salg->list, &spacc_aead_alg_list);
> +	mutex_unlock(&spacc_aead_alg_mutex);
> +
> +	return 0;
> +}
> +
> +int probe_aeads(struct platform_device *spacc_pdev)
> +{
> +	int err;
> +	unsigned int x, y;
> +	struct spacc_priv *priv = NULL;
> +
> +	size_t alloc_size = max_t(unsigned long,
> +			roundup_pow_of_two(sizeof(struct spacc_iv_buf)),
> +			dma_get_cache_alignment());
> +
> +	spacc_iv_pool = kmem_cache_create("spacc-aead-iv", alloc_size,
> +					  alloc_size, 0, NULL);
> +
> +	if (!spacc_iv_pool)
> +		return -ENOMEM;
> +
> +	for (x = 0; x < ARRAY_SIZE(possible_aeads); x++) {
> +		possible_aeads[x].keylen_mask = 0;
> +		possible_aeads[x].valid       = 0;
> +	}
> +
> +	/* compute cipher key masks (over all devices) */
> +	priv = dev_get_drvdata(&spacc_pdev->dev);
> +
> +	for (x = 0; x < ARRAY_SIZE(possible_aeads); x++) {
> +		for (y = 0; y < ARRAY_SIZE(possible_aeads[x].keylen); y++) {
> +			if (spacc_isenabled(&priv->spacc,
> +					    possible_aeads[x].aead.ciph & 0xFF,
> +					possible_aeads[x].keylen[y]))
> +				possible_aeads[x].keylen_mask |= 1u << y;
> +		}
> +	}
> +
> +	/* scan for combined modes */
> +	priv = dev_get_drvdata(&spacc_pdev->dev);
> +
> +	for (x = 0; x < ARRAY_SIZE(possible_aeads); x++) {
> +		if (!possible_aeads[x].valid && possible_aeads[x].keylen_mask) {
> +			if (spacc_isenabled(&priv->spacc,
> +					    possible_aeads[x].aead.hash & 0xFF,
> +					possible_aeads[x].hashlen)) {
> +
> +				possible_aeads[x].valid = 1;
> +				err = spacc_register_aead(x, spacc_pdev);
> +				if (err < 0)
> +					goto error;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +
> +error:
> +	return err;
> +}
> +
> +int spacc_unregister_aead_algs(void)

Why do you make it global but without headers? Or you split the change
so weirdly that header is not here?

> +{
> +	struct spacc_alg *salg, *tmp;
> +
> +	mutex_lock(&spacc_aead_alg_mutex);
> +
> +	list_for_each_entry_safe(salg, tmp, &spacc_aead_alg_list, list) {
> +		crypto_unregister_alg(salg->calg);
> +		list_del(&salg->list);
> +		kfree(salg);
> +	}
> +
> +	mutex_unlock(&spacc_aead_alg_mutex);
> +
> +	kmem_cache_destroy(spacc_iv_pool);
> +
> +	return 0;
> +}

Best regards,
Krzysztof

