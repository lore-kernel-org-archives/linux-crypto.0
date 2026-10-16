Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0366146D547;
	Fri, 16 Oct 2026 09:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142021; cv=none; b=U6ZaLCk+j53+UTK4C5FXA0yyvMW8jewzjT6Tqp1yDiF0VtP+y1xUDYg99eFQfXjGXMg+xEPOIQ1embAJqyRUhnInUm30m6iIdkx4dLZr1uizDKvCZODDybiS/Bu+Wo8bANSqJZujAA7LWTtRAHD970zGYsL4wymfVxbSGVTVcwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142021; c=relaxed/simple;
	bh=LVDS0HnD/QnD6zawSDbzNLWAnl5Fnm7/XjXBFyRWCMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S0SuedPiRbODaMIw4uy6uCjTHmrVoEazPkih+dU2VfhtAUQniib4RC3RNLcxapf6NgzLgF5UUcUtZ64l/X/4wd1obUAhkzeY7b3wimDKSTS5fgIy/ELfRRWpBpmK8fwxC31BwMekw+N/c02QvebulgGBtCg5Lss/3yanj6BZih4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cQGXqaHE; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cQGXqaHE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=CejfQ7Xzl26VOk+jZ6vebpBL0jzLsbbVNEnQ7lsVEgY=; 
	b=cQGXqaHExzLpVXXNIbtaido2iealZxfQ09rbjfTsZf4Yk0ysn09Do+dUteIXMeAhl5zKxOrlHPA
	Dl8j4IFG14zmek0oo04j8kTvzGPFNQkRWfklgiW2+tJSLQa5Lp5o5xmfsLFfpUVwSWEi6jee3wP9s
	ZLU+z/1Jhl5zMi+MC8DDHd0mBP7nZiLJnaaXEbdYa7EwbkyaASYW6PoC8BY8WQkIdy4v54zOkG43h
	pQWtAcepIFE1zuRgQRhS+bcIGQxi1E6y6bHB9jIRaCU8mnAdrj2wgxZ9fEf73LxekwbKt7EjQVyLp
	B84yREHtJQkD/wNNKbM6UOPl14GILZPbnXqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHe0I-00000004U7u-0dLc;
	Fri, 16 Oct 2026 17:13:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Oct 2026 20:13:30 +1100
Date: Fri, 16 Oct 2026 20:13:30 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ralf Lici <ralf@mandelbit.com>
Cc: linux-crypto@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH crypto 2/2] crypto: safexcel - Map AEAD buffers with
 accurate DMA directions
Message-ID: <atHquk_AUj2Ys7Su@gondor.apana.org.au>
References: <cover.1789469436.git.ralf@mandelbit.com>
 <7bd0c89dd32e9712d7d08393842498698148064b.1789469436.git.ralf@mandelbit.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bd0c89dd32e9712d7d08393842498698148064b.1789469436.git.ralf@mandelbit.com>

On Tue, Sep 15, 2026 at 01:32:12PM +0200, Ralf Lici wrote:
>
> @@ -748,8 +833,17 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
>  			return -EINVAL;
>  		}
>  		if (sreq->nr_src > 0) {
> -			src_mapped = dma_map_sg(priv->dev, src, sreq->nr_src,
> -						DMA_BIDIRECTIONAL);
> +			if (ctx->aead)
> +				src_mapped =
> +					safexcel_map_aead(priv->dev, src,
> +							  sreq->nr_src,
> +							  sreq->output_offset,
> +							  sreq->output_len,
> +							  true);
> +			else
> +				src_mapped = dma_map_sg(priv->dev, src,
> +							sreq->nr_src,
> +							DMA_BIDIRECTIONAL);

This path doesn't actualy matter because BIDIRECTIONAL is safe
even if you use it unnecessarily.

> @@ -775,8 +869,17 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
>  		}
>  
>  		if (sreq->nr_dst > 0) {
> -			dst_mapped = dma_map_sg(priv->dev, dst, sreq->nr_dst,
> -						DMA_FROM_DEVICE);

So this is the really buggy path.  Why don't you just change it to
BIDRECTIONAL, perhaps with a comment referring to the assoc data?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
