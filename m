Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A71245FFA0;
	Wed, 19 Aug 2026 11:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787139838; cv=none; b=e6yygXbE62XJbwUqcyTUH7/aBAVKBYkXDT8mbdCQz4hn76E1iZqPRac+JQ8Eqck1q+CqxBu2/4ARz1vHgEEpDnkronJ7t7qhXqv7PLmj91tYCdKoiy7CQ93BSMj97F3NZtT5wP/KtJvXSwSpKd6JndHAB/qENobADZZng7/IQ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787139838; c=relaxed/simple;
	bh=UVDrf/NFw4E80XU2kjsyEPfNkNlnBpj8aVnPdObnKb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BD7RHIz2dS9MTsgVHsVvLqWC7v3lmBZdCTHZzUUF7AsX/juh/H3l/f1ihIuQyHbRqVCubhad7bLM+H0qFpiYFFkWGXgGJ9lghIFYCDsubGRP8jT2iTAIHHntfuh0AR7owm4ro8cnnj6RtJw+4rVAn5odxctw3RL1CX67DIW77Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WSZmSkvg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WSZmSkvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4104A1F000E9;
	Wed, 19 Aug 2026 11:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787139834;
	bh=zKNTXXunbgUhz5Rg+SoCXd/5MRHAFklWPe//rf7MFms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WSZmSkvgp1PDJVWYWfBIg5NVr93qWG3d+bnbQL5BihKNYhdUk8+QcLlzEA29dalaM
	 J3Cl2orSxjMBNGiNRnPUf31Su6RtXBummNe2pO5k+MLRbwcdLAj63qqzRjYte47Lz6
	 T/ASI4QxGNWh+2QIQ5v31ZbdM+U2H7oeGob+f8A9QiKm04k6MD2DHH08cu5RFNEgur
	 sGztxJlUmHQ59FGA/2XECQcs+dS5cd7MzYotnSkv2FnhwEv2MHB2NcGyqhkh4E3GsI
	 GTzdEdUqooR5GcemhT6KH0yRIyB0pEF4obIKF/h6dZc5VYy0TV7qnYwanAASWS40mV
	 ywv/4fupmiAPw==
Date: Wed, 19 Aug 2026 13:43:51 +0200
From: Antoine Tenart <atenart@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: atenart@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Pascal van Leeuwen <pascalvanl@gmail.com>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: inside-secure - Zeroize temporary arrays on
 stack with sensitive data
Message-ID: <aoWWgixBpVypLoWx@kwain>
References: <20260819105836.156251-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819105836.156251-1-thuth@redhat.com>

On Wed, Aug 19, 2026 at 12:58:36PM +0200, Thomas Huth wrote:
> key_tmp[] in safexcel_xcbcmac_setkey() and consts[] / _const[] in
> safexcel_cmac_setkey() contain crypto key material that should not
> get exposed to the outside once the function is done. Scrub the
> arrays with memzero_explicit() to avoid that the data could leak
> via the stack.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260813134953.979481-1-thuth%40redhat.com
> Fixes: 38f21b4bab11f ("crypto: inside-secure - Added support for the AES XCBC ahash")
> Fixes: 7a627db9cafdb ("crypto: inside-secure - Added support for the AES-CMAC ahash")
> Acked-by: Antoine Tenart <atenart@kernel.org>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  v2: Added "Fixes:" and "Reported-by:" tags
>  
>  drivers/crypto/inside-secure/safexcel_hash.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index 3402e570d045c..1ae6fbec31298 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -1993,6 +1993,7 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>  	ret = aes_prepareenckey(ctx->aes,
>  				(u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
>  				AES_MIN_KEY_SIZE);
> +	memzero_explicit(key_tmp, sizeof(key_tmp));
>  	if (ret)
>  		return ret;
>  
> @@ -2104,6 +2105,9 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>  	}
>  	ctx->cbcmac = false;
>  
> +

Sorry, I just noticed there's an extra empty line here.

> +	memzero_explicit(consts, sizeof(consts));
> +	memzero_explicit(_const, sizeof(_const));
>  	return 0;
>  }
>  
> -- 
> 2.55.0
> 
