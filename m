Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3C63859C3
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 08:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776673850; cv=none; b=GhJfgiq1W8lNbpaCqkEb5B6OUoyIYudfYczCGbVbCxZg2O7PMMLCRVMHUyHtxs3TfFVr/tlova7QbgsOxMQa1DsI0p/gCNIqplREwaxF/M8X2yzvkizQV8+ZaMNQRhac8B1tLSqUv2EyZ8nwlC89HZ6n3e2vnA8+2mvc/g+IJXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776673850; c=relaxed/simple;
	bh=0mb4gKSyVsypvTKQm5KEmBbTT/IqhWw0lizlsL9Abjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PodV3YZW/nbYZ760oihF30xpyViH9/FccsIaGDLe4dXoAGcimj/MDpYoUFxNBrQ3vq9JA9h6mA0rehG+NgQ074SS4oSJ4i2a+egv6VC3ArG38Nv8D7xKVKA1y29cvaOR1dtnUBsHdS4b5up9uWSbOa/QAfF2PqH2oCyexsf5phE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Lxim6JC3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Lxim6JC3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0Z9pwSpJUHNQiqFvtIMPl5paELBd72x+kis+ur4H1kg=; 
	b=Lxim6JC3skLrWd2RaH4p07m910MfFruxssC5rgjHJgQW2lkqldhVQOsAvkxGPvflg4Ap8x4qYbR
	44NV27MGQANQ/ecf9P9ZACT9zsm9o9ea9zghyhInG4gFyN0NatKzAYzHyq5GZUXUCGCl1r69sVAyK
	vGEhErjqwyRZL1DEGzb04iWlKFo6mGH6Ht02CvZfXtcGUMe//65ud1U9fkQSdfOfQp6VKURgQkSQh
	+tI1x5ZNDWQOeDPR7MvLjrkAlxtu8MBf/TntaH77HXkA/d351zG6B2BPyvnurLMSBEiQGTEicTYKt
	ccZ2roP8zzXYdjMOQzEHNXPZEUVtM7TRXZVg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wEk1i-007Lax-0L;
	Mon, 20 Apr 2026 16:30:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Apr 2026 16:30:42 +0800
Date: Mon, 20 Apr 2026 16:30:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, smueller@chronox.de,
	yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
	bird@lzu.edu.cn, tr0jan@lzu.edu.cn, kanolyc@gmail.com,
	ldy3087146292@gmail.com, enjou1224@outlook.com
Subject: Re: [PATCH v2 2/2] crypto: ccm - keep a private IV for auth and CTR
 state
Message-ID: <aeXkMlFIzOWQKL_f@gondor.apana.org.au>
References: <43955efb67bf85481da7457b73bd30539d8e5d79.1776578475.git.enjou1224@outlook.com>
 <7f569774b437b9056985db1fec58aff337a41a4d.1776578475.git.enjou1224@outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f569774b437b9056985db1fec58aff337a41a4d.1776578475.git.enjou1224@outlook.com>

On Sun, Apr 19, 2026 at 04:53:00PM +0800, Ren Wei wrote:
>
> @@ -288,7 +291,7 @@ static int crypto_ccm_encrypt(struct aead_request *req)
>  	struct scatterlist *dst;
>  	unsigned int cryptlen = req->cryptlen;
>  	u8 *odata = pctx->odata;
> -	u8 *iv = req->iv;
> +	u8 *iv = pctx->idata;
>  	int err;
>  
>  	err = crypto_ccm_init_crypt(req, odata);
> @@ -303,6 +306,8 @@ static int crypto_ccm_encrypt(struct aead_request *req)
>  	if (req->src != req->dst)
>  		dst = pctx->dst;
>  
> +	memcpy(iv, pctx->iv, 16);
> +
>  	skcipher_request_set_tfm(skreq, ctx->ctr);
>  	skcipher_request_set_callback(skreq, pctx->flags,
>  				      crypto_ccm_encrypt_done, req);

This doesn't seem to make sense.  Why are you copying req->iv into
pctx->idata here?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
