Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600683090D5;
	Mon, 12 Jan 2026 08:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768208194; cv=none; b=tU1Gdk4MwU8vvOtYXBtzOvQsoOljymolgLG9NDBOOAb6j58rAueZ5ICcOqrVp1Lsavr+UhNWcen5XLHqAmb9rDzj8N0NLC9W8X8XcIYFa8I5aQKTVK6M744c4T9H6d0KROGaEgA+RknvHB4qlEOjblS5jftiG4f0CCGgu6fDj6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768208194; c=relaxed/simple;
	bh=ff7c8nDvG3/uV+VQ/OqrkrYfEBYLjseVoi5+CAXEcgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=of+AV1QoNLAWeuLrxmRYGPi8KUV/LgCVTNe4qx3bk9Kik0q2tq5LHwP2F6EPVtMzOfU2wsruECLXsJJw+pBVn2vJ2lf9JcLmb8pZvH9lIZjfc2UAR8FnClUiJuSbWN5ZPUrsyhTN1BH1w69y5pis+cSKZkUva8mV0yxZI2p+IAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2tQQu6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2tQQu6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94686C19422;
	Mon, 12 Jan 2026 08:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768208194;
	bh=ff7c8nDvG3/uV+VQ/OqrkrYfEBYLjseVoi5+CAXEcgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c2tQQu6H02ndWrOEYyQUUF58xiq5hcnS2eyn7Kp69reEkky1cM8z0eZmEOoVZ6faJ
	 2/eAy3ovgVrQSGcmmpjueqiu7dydoXplNqteoDCt7RSi/qGda+Q+E+/9eAdWm/PZPF
	 3f0cKbeXI/K6+V0wOeNz97EtFGzgkLZpIuvIi4xy0UXRIm7ls66A2QbqRUAWeuUK+9
	 fcoSVpOjbrsBLmT4R2HW9qQ+4y9kZXD9V10QzNPiy+EzkQ91GpdHF6q4K1OVdwD8JY
	 xLdhrTAJNLhQEASfHHyPYBLdJvmym5IyvqOlynowJwBh8y3fMQWSi8k5qES/eM4EcB
	 DK1J+VErkl8OQ==
Date: Mon, 12 Jan 2026 09:56:30 +0100
From: Antoine Tenart <atenart@kernel.org>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: ansuelsmth@gmail.com, maxim.anisimov.ua@gmail.com, amadeus@jmu.edu.cn, 
	atenart@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	vschagen@icloud.com, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure/eip93 - unregister only available
 algorithm
Message-ID: <aWS3A7wAv5KNVa1b@kwain>
References: <20260111132531.2232417-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260111132531.2232417-1-olek2@wp.pl>

On Sun, Jan 11, 2026 at 02:20:32PM +0100, Aleksander Jan Bajkowski wrote:
> EIP93 has an options register. This register indicates which crypto
> algorithms are implemented in silicon. Supported algorithms are
> registered on this basis. Unregister algorithms on the same basis.
> Currently, all algorithms are unregistered, even those not supported
> by HW. This results in panic on platforms that don't have all options
> implemented in silicon.
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Acked-by: Antoine Tenart <atenart@kernel.org>

Thanks!
Antoine

> ---
> v2:
> - keep the keysize assignment in eip93_register_algs
> ---
>  .../crypto/inside-secure/eip93/eip93-main.c   | 92 +++++++++++--------
>  1 file changed, 53 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
> index 3cdc3308dcac..b7fd9795062d 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-main.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
> @@ -77,11 +77,44 @@ inline void eip93_irq_clear(struct eip93_device *eip93, u32 mask)
>  	__raw_writel(mask, eip93->base + EIP93_REG_INT_CLR);
>  }
>  
> -static void eip93_unregister_algs(unsigned int i)
> +static int eip93_algo_is_supported(u32 alg_flags, u32 supported_algo_flags)
> +{
> +	if ((IS_DES(alg_flags) || IS_3DES(alg_flags)) &&
> +	    !(supported_algo_flags & EIP93_PE_OPTION_TDES))
> +		return 0;
> +
> +	if (IS_AES(alg_flags) &&
> +	    !(supported_algo_flags & EIP93_PE_OPTION_AES))
> +		return 0;
> +
> +	if (IS_HASH_MD5(alg_flags) &&
> +	    !(supported_algo_flags & EIP93_PE_OPTION_MD5))
> +		return 0;
> +
> +	if (IS_HASH_SHA1(alg_flags) &&
> +	    !(supported_algo_flags & EIP93_PE_OPTION_SHA_1))
> +		return 0;
> +
> +	if (IS_HASH_SHA224(alg_flags) &&
> +	    !(supported_algo_flags & EIP93_PE_OPTION_SHA_224))
> +		return 0;
> +
> +	if (IS_HASH_SHA256(alg_flags) &&
> +	    !(supported_algo_flags & EIP93_PE_OPTION_SHA_256))
> +		return 0;
> +
> +	return 1;
> +}
> +
> +static void eip93_unregister_algs(u32 supported_algo_flags, unsigned int i)
>  {
>  	unsigned int j;
>  
>  	for (j = 0; j < i; j++) {
> +		if (!eip93_algo_is_supported(eip93_algs[j]->flags,
> +					     supported_algo_flags))
> +			continue;
> +
>  		switch (eip93_algs[j]->type) {
>  		case EIP93_ALG_TYPE_SKCIPHER:
>  			crypto_unregister_skcipher(&eip93_algs[j]->alg.skcipher);
> @@ -106,49 +139,27 @@ static int eip93_register_algs(struct eip93_device *eip93, u32 supported_algo_fl
>  
>  		eip93_algs[i]->eip93 = eip93;
>  
> -		if ((IS_DES(alg_flags) || IS_3DES(alg_flags)) &&
> -		    !(supported_algo_flags & EIP93_PE_OPTION_TDES))
> +		if (!eip93_algo_is_supported(alg_flags, supported_algo_flags))
>  			continue;
>  
> -		if (IS_AES(alg_flags)) {
> -			if (!(supported_algo_flags & EIP93_PE_OPTION_AES))
> -				continue;
> +		if (IS_AES(alg_flags) && !IS_HMAC(alg_flags)) {
> +			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY128)
> +				eip93_algs[i]->alg.skcipher.max_keysize =
> +					AES_KEYSIZE_128;
>  
> -			if (!IS_HMAC(alg_flags)) {
> -				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY128)
> -					eip93_algs[i]->alg.skcipher.max_keysize =
> -						AES_KEYSIZE_128;
> +			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY192)
> +				eip93_algs[i]->alg.skcipher.max_keysize =
> +					AES_KEYSIZE_192;
>  
> -				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY192)
> -					eip93_algs[i]->alg.skcipher.max_keysize =
> -						AES_KEYSIZE_192;
> +			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY256)
> +				eip93_algs[i]->alg.skcipher.max_keysize =
> +					AES_KEYSIZE_256;
>  
> -				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY256)
> -					eip93_algs[i]->alg.skcipher.max_keysize =
> -						AES_KEYSIZE_256;
> -
> -				if (IS_RFC3686(alg_flags))
> -					eip93_algs[i]->alg.skcipher.max_keysize +=
> -						CTR_RFC3686_NONCE_SIZE;
> -			}
> +			if (IS_RFC3686(alg_flags))
> +				eip93_algs[i]->alg.skcipher.max_keysize +=
> +					CTR_RFC3686_NONCE_SIZE;
>  		}
>  
> -		if (IS_HASH_MD5(alg_flags) &&
> -		    !(supported_algo_flags & EIP93_PE_OPTION_MD5))
> -			continue;
> -
> -		if (IS_HASH_SHA1(alg_flags) &&
> -		    !(supported_algo_flags & EIP93_PE_OPTION_SHA_1))
> -			continue;
> -
> -		if (IS_HASH_SHA224(alg_flags) &&
> -		    !(supported_algo_flags & EIP93_PE_OPTION_SHA_224))
> -			continue;
> -
> -		if (IS_HASH_SHA256(alg_flags) &&
> -		    !(supported_algo_flags & EIP93_PE_OPTION_SHA_256))
> -			continue;
> -
>  		switch (eip93_algs[i]->type) {
>  		case EIP93_ALG_TYPE_SKCIPHER:
>  			ret = crypto_register_skcipher(&eip93_algs[i]->alg.skcipher);
> @@ -167,7 +178,7 @@ static int eip93_register_algs(struct eip93_device *eip93, u32 supported_algo_fl
>  	return 0;
>  
>  fail:
> -	eip93_unregister_algs(i);
> +	eip93_unregister_algs(supported_algo_flags, i);
>  
>  	return ret;
>  }
> @@ -469,8 +480,11 @@ static int eip93_crypto_probe(struct platform_device *pdev)
>  static void eip93_crypto_remove(struct platform_device *pdev)
>  {
>  	struct eip93_device *eip93 = platform_get_drvdata(pdev);
> +	u32 algo_flags;
> +
> +	algo_flags = readl(eip93->base + EIP93_REG_PE_OPTION_1);
>  
> -	eip93_unregister_algs(ARRAY_SIZE(eip93_algs));
> +	eip93_unregister_algs(algo_flags, ARRAY_SIZE(eip93_algs));
>  	eip93_cleanup(eip93);
>  }
>  
> -- 
> 2.47.3
> 
