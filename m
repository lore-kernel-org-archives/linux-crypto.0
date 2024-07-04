Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D64A3232;
	Thu,  4 Jul 2024 02:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720061135; cv=none; b=hCWdkjVwwkWS/p03UE8MMXVvyslw/G0jFERz5EiLvWKqAog52ynOpoqca5HORziyVp5pYxAXLs7O64eyveR5IYAjTKcBZHDIUPda+MbpQmbrRQExOcjFz3fEpWjM2ynqxING1QH3VBlcMNxHrNNIf56Sl8PQs9zu+hahyDy0Yc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720061135; c=relaxed/simple;
	bh=pFP9IxCw7IYe6OVYz0+ush3KMUC3J8iarT/TRPZp4Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iTetWmBALGpA3I47EA3r4p+mfVDHQbxzcvTxZEES7EnmjMv4LDi1UB+DmT/BgO0m1/faA1MLdk6j5KvDFG4YuWOyW1YOOvpIjza/VZgk3mjRRH9Q1fxq5F1NYEdsLbuW2Wy6odNzaU4ruCYuvDEMMwLYOpNOi4dBpYWcCHxtzFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=npZazG+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="npZazG+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C329C2BD10;
	Thu,  4 Jul 2024 02:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720061134;
	bh=pFP9IxCw7IYe6OVYz0+ush3KMUC3J8iarT/TRPZp4Pk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=npZazG+WyFRwPSNDIE22wrtS5mBL5a/vZ/U6MkDA7J9RZuqhXhOrrore8Z55msytf
	 qnMQAUKQQshhqxvPSoUCdgtkmZwedZikV8HLIAj6PgeC1fGJnkLUru8QxRah51EqOd
	 GBtcAZzH4k2S1eSYWvJOEzAsVGKRi/10Qwa4pnJzbgnFSCxMAucxnhUUIdURt/dhQZ
	 dGheeB5aP/6fbdYJt8e7nYaMkrXmxl8/UOcA1fPQGxCVEVjJSGPfVMdFDfVxvsU857
	 bIT7FI8x0LmGAKsFyZH8Ew/bVy/eXdcsGE6z7b/IExCrh+B+m5/Z8+EGNriWmnk0/E
	 Nd1DVSCeVI4YQ==
Date: Wed, 3 Jul 2024 19:45:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, horms@kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/4] crypto: caam: Unembed net_dev structure
 from qi
Message-ID: <20240703194533.5a00ea5d@kernel.org>
In-Reply-To: <20240702185557.3699991-4-leitao@debian.org>
References: <20240702185557.3699991-1-leitao@debian.org>
	<20240702185557.3699991-4-leitao@debian.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  2 Jul 2024 11:55:53 -0700 Breno Leitao wrote:
> +static void free_caam_qi_pcpu_netdev(const cpumask_t *cpus)
> +{
> +	struct caam_qi_pcpu_priv *priv;
> +	int i;
> +
> +	for_each_cpu(i, cpus) {
> +		priv = per_cpu_ptr(&pcpu_qipriv, i);
> +		free_netdev(priv->net_dev);
> +	}
> +}
> +
>  int caam_qi_init(struct platform_device *caam_pdev)
>  {
>  	int err, i;
>  	struct device *ctrldev = &caam_pdev->dev, *qidev;
>  	struct caam_drv_private *ctrlpriv;
>  	const cpumask_t *cpus = qman_affine_cpus();
> +	cpumask_t clean_mask;
>  
>  	ctrlpriv = dev_get_drvdata(ctrldev);
>  	qidev = ctrldev;
> @@ -743,6 +756,8 @@ int caam_qi_init(struct platform_device *caam_pdev)
>  		return err;
>  	}
>  
> +	cpumask_clear(&clean_mask);
> +
>  	/*
>  	 * Enable the NAPI contexts on each of the core which has an affine
>  	 * portal.
> @@ -751,10 +766,16 @@ int caam_qi_init(struct platform_device *caam_pdev)
>  		struct caam_qi_pcpu_priv *priv = per_cpu_ptr(&pcpu_qipriv, i);
>  		struct caam_napi *caam_napi = &priv->caam_napi;
>  		struct napi_struct *irqtask = &caam_napi->irqtask;
> -		struct net_device *net_dev = &priv->net_dev;
> +		struct net_device *net_dev;
>  
> +		net_dev = alloc_netdev_dummy(0);
> +		if (!net_dev) {
> +			err = -ENOMEM;
> +			goto fail;

free_netdev() doesn't take NULL, free_caam_qi_pcpu_netdev()
will feed it one if we fail here

> +		}
> +		cpumask_set_cpu(i, &clean_mask);
> +		priv->net_dev = net_dev;
>  		net_dev->dev = *qidev;
> -		INIT_LIST_HEAD(&net_dev->napi_list);
>  
>  		netif_napi_add_tx_weight(net_dev, irqtask, caam_qi_poll,
>  					 CAAM_NAPI_WEIGHT);
> @@ -766,16 +787,22 @@ int caam_qi_init(struct platform_device *caam_pdev)
>  				     dma_get_cache_alignment(), 0, NULL);
>  	if (!qi_cache) {
>  		dev_err(qidev, "Can't allocate CAAM cache\n");
> -		free_rsp_fqs();
> -		return -ENOMEM;
> +		err = -ENOMEM;
> +		goto fail2;
>  	}
>  
>  	caam_debugfs_qi_init(ctrlpriv);
>  
>  	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, ctrlpriv);
>  	if (err)
> -		return err;
> +		goto fail2;
>  
>  	dev_info(qidev, "Linux CAAM Queue I/F driver initialised\n");
>  	return 0;
> +
> +fail2:
> +	free_rsp_fqs();
> +fail:
> +	free_caam_qi_pcpu_netdev(&clean_mask);
