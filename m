Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0252A1DB124;
	Tue, 20 May 2025 23:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747782162; cv=none; b=r2C7Y/Tx5/4eZ9VCNmF3jTe8p/SpiGPAyXk3wyYdlfLq5NNVBePJHrqO1q8DwdDFUOJhp0pK8MRuKNzvW8ALIKVyHcQGsUpPxc7jgfonNZGRK42e7gtUrV6yJZu9Z/+5Ur/OTMJsjGK9ouafAArBD/tAlGlo1nWDJoAv7TJO+4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747782162; c=relaxed/simple;
	bh=X89w/Ge3vNdYTIH4Qr9ztFZLtgEVfBUbEt6JXk9CW60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=heGRIhATPGNWoCDbgOY8E0Xf+EMNlPlLjjUIynCSfDY8V6pz9VNt+7c0MvdPwPZdvtFp9W6lhRXq6TYV79OYKuat3vvc/AUzL7/gp2MChwyTRfrWcjCmf7eymObR/WeA9iHeG0yW22fu+K+N0l2YTS6sbtnnodAzdQ2sviYsQeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=r1ifDl5j; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="r1ifDl5j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sKVjQdW7Rud/G+zZZNUFlXpV899aZG0J0h6VJvtUqKw=; b=r1ifDl5j3I1BRXYPKzMAtUjLfL
	SQCwo8c45463K/X1lu/l9TeMv/rzsIzOxEv6cQJrwd+3+gYi5gMSMbwAm7x0BrN4T0608zacAs32t
	k+OUWsLDE/vuVQm2cKe+XK2owihSICKt96VKoGcpuruWEswSXmb4Rlxt9WkjKfWeVg+V9KmKXCRME
	g9SysceYtTq4IoJcMz9rcwOXT//WwYhYO0U15pvROWuNqktzcv7fFyiy3pAX4GKeqHbmKcNz7a+03
	G+xKoy1cvL/bIBbNxRXZOyGBdeMqhUDGHm3pfpMe4souctaw9boB3Ovqiaba1CyglGwU39BWBWYNN
	DTikmaGw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uHVyM-007f2G-1Y;
	Wed, 21 May 2025 07:02:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 21 May 2025 07:02:10 +0800
Date: Wed, 21 May 2025 07:02:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bharat Bhushan <bbhushan2@marvell.com>
Cc: bbrezillon@kernel.org, schalla@marvell.com, davem@davemloft.net,
	giovanni.cabiddu@intel.com, linux@treblig.org,
	bharatb.linux@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/4 v2] crypto: octeontx2: Fix address alignment issue on
 ucode loading
Message-ID: <aC0J8g6UYxSw_7zZ@gondor.apana.org.au>
References: <20250520130737.4181994-1-bbhushan2@marvell.com>
 <20250520130737.4181994-3-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520130737.4181994-3-bbhushan2@marvell.com>

On Tue, May 20, 2025 at 06:37:35PM +0530, Bharat Bhushan wrote:
>
> @@ -1519,22 +1520,27 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
>  	if (ret)
>  		goto delete_grps;
>  
> -	compl_rlen = ALIGN(sizeof(union otx2_cpt_res_s), OTX2_CPT_DMA_MINALIGN);
> -	len = compl_rlen + LOADFVC_RLEN;
> +	len = LOADFVC_RLEN + sizeof(union otx2_cpt_res_s) +
> +	       OTX2_CPT_RES_ADDR_ALIGN;
>  
> -	result = kzalloc(len, GFP_KERNEL);
> -	if (!result) {
> +	rptr = kzalloc(len, GFP_KERNEL);
> +	if (!rptr) {
>  		ret = -ENOMEM;
>  		goto lf_cleanup;
>  	}
> -	rptr_baddr = dma_map_single(&pdev->dev, (void *)result, len,
> +
> +	rptr_baddr = dma_map_single(&pdev->dev, rptr, len,
>  				    DMA_BIDIRECTIONAL);

After this change rptr is still unaligned.  However, you appear
to be doing bidirectional DMA to rptr, so it should be aligned
to ARCH_DMA_MINALIGN or you risk corrupting the surrounding
memory.

Only TO_DEVICE DMA addresses can be unaligned.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
