Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6FF30E827;
	Thu, 19 Jun 2025 18:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750356625; cv=none; b=Z1hjF83RxP3/t1zHBAEzlri0Lus+MUcDsKvB2+FZsNNPUK/lPWXWuApFbg9pRhfBWono4ccTInDzgjQNkeqmhgDp8mWiCKCh5I+t6P914GLO8tlTWR6vKM6B7ZD/vgDx+OOtUH6lGr2pAo/FMHULhOxn1HYS5z0UA4n/TRc01yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750356625; c=relaxed/simple;
	bh=8NdxjQh1wQGIx0t1SPod5gYipeYIYwG78j5c0YMVNo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nAfC8A5CVS2TmuKXI4M7SB/hOiz3oBaEGDIbrxOzKgRkIYJzYwtXwErA0i+PONr2NVH4ff44Km8iQoYzsDmT7f4+elfvbqbbh7kd4VjT7QiD8Amhuo/wFMJ21Mb0pxPkSwEEPIcNM+imh0il2KbKvLFCzOVBy9/HWqg9cbZ8IRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YEL9JSGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YEL9JSGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2409C4CEEA;
	Thu, 19 Jun 2025 18:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750356625;
	bh=8NdxjQh1wQGIx0t1SPod5gYipeYIYwG78j5c0YMVNo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YEL9JSGnf+xP/a34eZBVWZQH0Nat8kaYwCEiFT/WY9jnd3xnyw08D8gOZrpKMdEo/
	 0LN4euivbYiaavwfvTV1Yl3XGYNbEg4UMnhrsdCpZCWCpK9hIpekmKrDf/VA+UV8Dw
	 T7i7Va9fvsYrxV0NBlhs1ryZ3UvQ8hYM6OEa3mnRW0Lue/nYq9uSxxUnXtZrW5u0PI
	 W+bANQWt/m3Qsh3PdoDIxYH05OPii2X1tvqfEl8Q7CH45c+WFAYflt29UDwGV4r+HE
	 QWAXCQW9DOBlQtNeKD0RUDrzpUxFhmw3ZM8h9j+ACfEfg7nHg2nctZiH3Njmme2sXN
	 sKL9vC4+e2s2g==
Date: Thu, 19 Jun 2025 20:10:22 +0200
From: Antoine Tenart <atenart@kernel.org>
To: fourier.thomas@gmail.com
Cc: Antoine Tenart <atenart@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure: Fix `dma_unmap_sg()` nents value
Message-ID: <itx47uifmow4fcovhritufa76pfes4zsor4ttyf2bzzoycugvc@ivv65ci3wrwq>
References: <20250619152838.349584-1-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250619152838.349584-1-fourier.thomas@gmail.com>

IMO the patch subject could be improved, to remove the ` and to be more
descriptive. E.g.

"crypto: inside-secure: unmap DMA buffers using the original number of entries"

On Thu, Jun 19, 2025 at 05:28:36PM +0200, fourier.thomas@gmail.com wrote:
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index d2b632193beb..1ef1ccfaaa95 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -249,7 +249,10 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv,
>  	safexcel_complete(priv, ring);
>  
>  	if (sreq->nents) {
> -		dma_unmap_sg(priv->dev, areq->src, sreq->nents, DMA_TO_DEVICE);
> +		dma_unmap_sg(priv->dev,
> +			     areq->src,
> +			     sg_nents_for_len(areq->src, areq->nbytes),
> +			     DMA_TO_DEVICE);

No need to put 'areq->src,' on a new line.

>  		sreq->nents = 0;
>  	}
>  
> @@ -497,7 +500,10 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
>  			 DMA_FROM_DEVICE);
>  unmap_sg:
>  	if (req->nents) {
> -		dma_unmap_sg(priv->dev, areq->src, req->nents, DMA_TO_DEVICE);
> +		dma_unmap_sg(priv->dev,
> +			     areq->src,
> +			     sg_nents_for_len(areq->src, areq->nbytes),
> +			     DMA_TO_DEVICE);

Same here.

Otherwise this looks good to me. With those fixed, you can add:

Reviewed-by: Antoine Tenart <atenart@kernel.org>

Thanks!
