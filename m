Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5CA30AAD6;
	Mon,  5 Jan 2026 14:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767624548; cv=none; b=Os0oQNrOC0Y8hBXxGAatRMY0l17OkUnIN3zEFvr5eLEAd3u/5cj0QVOMq2T++sS7xFOYVRxpPfaxpZ0LSoJdJs3vbgf1xeO/Rt1eoCcQdcsN6iqdFcBmA9u3evY8BY94uDW0uoX0P8WvcHuOLKJQ2nJDWVyb2qe5TkEkpvHBwy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767624548; c=relaxed/simple;
	bh=8M+Vfx6ueyK9P2ZiMeGjDD5J+ucAR8RqPbH/nqhUUGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FDDJN6TVEOsEQUB+me6BDIBBtyfguwP9yf6vK6r9wboEckhNAcefT2aVEVECiWKI2L3S7mbJ6+VlfXUPsgYAIa+C9PyZfauww30q50KS46Mf2Ty2JSb7Q/T3pOYNpb0ghBQpvU3H0ZsrGQB/BjaDf885IA/bhTe+7FQ5pdM88oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uh1T2F16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uh1T2F16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953A4C116D0;
	Mon,  5 Jan 2026 14:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767624548;
	bh=8M+Vfx6ueyK9P2ZiMeGjDD5J+ucAR8RqPbH/nqhUUGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uh1T2F16FzdHlPLwQO2ieEwrCncvNEbISugSeyyVlAGeBTlIsylSFn9aCz3S2lv6t
	 dzMqGqq2ZESYUpzANeGV7Pc8IZD7uXYsePVTodAy9e0L487IaXHT9jqV4VH7AzX3Y1
	 c8PCRPEipB/ExpvTRPC2lznYKX6nY3G/Jb3hcsxwUsqxo7vCliIkviVozaE0CRvV1z
	 z8MBK4jPCfX0Z8dia2SMg/X2Lo+5tZGMHDuwtgZC5lwH1vG5DkqzYcfYr7iC3b4CNh
	 AkEM1KKIq0zAL+NmRhGJD/Bl6CYZD78HHkbBKO3Io83J5pECoQi8in73TDtyDNJvh8
	 5bwU1kr6rIYhQ==
Date: Mon, 5 Jan 2026 15:49:04 +0100
From: Antoine Tenart <atenart@kernel.org>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: ansuelsmth@gmail.com, atenart@kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, vschagen@icloud.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure/eip93 - fix kernel panic in driver
 detach
Message-ID: <aVvPIJCy3rG2vL7Y@kwain>
References: <20251230211721.1110174-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230211721.1110174-1-olek2@wp.pl>

On Tue, Dec 30, 2025 at 10:17:17PM +0100, Aleksander Jan Bajkowski wrote:
> During driver detach, the same hash algorithm is unregistered multiple
> times due to a wrong iterator.
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Reviewed-by: Antoine Tenart <atenart@kernel.org>

Thanks!

> ---
>  drivers/crypto/inside-secure/eip93/eip93-main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
> index 0b38a567da0e..3cdc3308dcac 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-main.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
> @@ -90,7 +90,7 @@ static void eip93_unregister_algs(unsigned int i)
>  			crypto_unregister_aead(&eip93_algs[j]->alg.aead);
>  			break;
>  		case EIP93_ALG_TYPE_HASH:
> -			crypto_unregister_ahash(&eip93_algs[i]->alg.ahash);
> +			crypto_unregister_ahash(&eip93_algs[j]->alg.ahash);
>  			break;
>  		}
>  	}
> -- 
> 2.47.3
> 
