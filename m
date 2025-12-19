Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8E123A562;
	Fri, 19 Dec 2025 03:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766113501; cv=none; b=hs1fTvE6mxyJ2Rqvn1mGMPXQxV2k7Pdu376Te7Y8d+5WmzipHAljrpUOI7G7f4hYfeOMxP9E/9oT6Seuq7gE3vtSJb1DT8kVuzqXUx9qYVAW4CT4GB8cLsGq6V0YztseW0WXiOiEdZjrTld/cTObWgkROyFMFnZE8OtIe/O1XGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766113501; c=relaxed/simple;
	bh=MVre47JUe3IkLj/HPRh3oIe3R9GGnfFWeX1TMow9nl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qHjptBxPSKOMq4IRJyM8I8p17kCCu2krl55gbVylE7wN9TbKMXAC+v04OCqDOVv5uE2aK/f4Q9NckzYs/BjxkdNRJCxLBCModUtXpfgRu57dQ+Ep4V1Mb+C6OguK4eK60cfkECbtBlWlY8UIQ9s7CqR3v7AV9puip7V6VoUw0pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=O+qIG0ub; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="O+qIG0ub"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=fgZuMXS3QM46CcT4v0IxUeCBpXrs6vd4Cp5T1MHO37s=; 
	b=O+qIG0ub6b4zlRB14JOSwD2Yb2JBnJqhuZlHD86yX9JnwftmNn03Axg3nLKpfdqJF15YDaQmnn9
	EJ2Yuy4QkbQvmunIw496eQu642KDluRlU+YNwsbzhhVsxZACAXZNkgxmDgJOvVJGrU3vBnDjL9RWZ
	rYTQegEwN2eBR4ywowxTm6nq1/MbMMkKdo1TRMQpEUGpJvwtlI7EpEaRGSigT0XzaTJXwQJ8QGjxj
	q7OAE3WwpWgV61+VLHb+4vakYIcUxVVoFenqC/pxvbIldRvu5/H1DcuM1WASi0h+NRExHIn+scvLm
	djHvb7VeZEbxeXtn7sO9GTnV4TGp70WLrbGA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWQnO-00BCkz-30;
	Fri, 19 Dec 2025 11:04:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 11:04:46 +0800
Date: Fri, 19 Dec 2025 11:04:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH 1/2] crypto: hisilicon/trng - use DEFINE_MUTEX() and
 LIST_HEAD()
Message-ID: <aUTAznUr2OrikTH9@gondor.apana.org.au>
References: <20251120135812.1814923-1-huangchenghai2@huawei.com>
 <20251120135812.1814923-2-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120135812.1814923-2-huangchenghai2@huawei.com>

On Thu, Nov 20, 2025 at 09:58:11PM +0800, Chenghai Huang wrote:
>
> @@ -308,12 +302,10 @@ static void hisi_trng_remove(struct platform_device *pdev)
>  	struct hisi_trng *trng = platform_get_drvdata(pdev);
>  
>  	/* Wait until the task is finished */
> -	while (hisi_trng_del_from_list(trng))
> -		;
> -
> -	if (trng->ver != HISI_TRNG_VER_V1 &&
> -	    atomic_dec_return(&trng_active_devs) == 0)
> -		crypto_unregister_rng(&hisi_trng_alg);
> +	while (hisi_trng_crypto_unregister(trng)) {
> +		dev_info(&pdev->dev, "trng is in using!\n");
> +		msleep(WAIT_PERIOD);
> +	}

Please use the new CRYPTO_ALG_DUP_FIRST flag to let the Crypto API
deal with reference count tracking.  With that, you should be able
to unregister the RNG even if there are still tfms using it.

The RNG will be freed after all tfms using it are freed.

Of course you should create a way to mark the trng as dead so
that the hisi_trng_generate returns an error instead of trying
to read from the non-existant RNG.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
