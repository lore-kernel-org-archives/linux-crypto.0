Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FF817C;
	Sat, 25 May 2024 00:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716595762; cv=none; b=lA5s7oI+AKhFYI2v3wYIB+thRzuPLri5NNg70elHopBpkfvNCZFyjXjAj5cIlMH3OEMmkzO0Dvr6H+MhkIfn8tdcEgBjjDv68eQ2nyQrjDE3zXfwTkV0dOo0l077vE3VCsF0340IQpecHhhYvzP+40k3nE3NnSOu3adHz5RUQJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716595762; c=relaxed/simple;
	bh=aM5sWLM0UH7fhbVqQABGRdgI6VqLOtZC6UR97WHhgww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ku4ibutrW/WZGg9ZBkozXY/teCVGXbeeeIN4wXNLAeVsz23vkKuiEaLBKuBRAaMpR0CClq68VMVuPPSfQksAOvP8uZxexMhHqhmBjxp5oShi4fOHsNcSp+9Mk5RnKOFAmbum0eEk3EOcHWzWJhawaJ/OXGKWvQ9FYJGI3D0BFFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=HfxB1L2b; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="HfxB1L2b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=UZhKIy0Yrc0Ws4kcMyEJnctS9jEAqL96AA14XHxT3cY=; b=HfxB1L2beYD69tma
	/UkqgKsUMMUEWbXxJLLJvazcZ0ekw8r6kO4WMGt8/6GbJ/EsKLeBu1b4k9gsgEopLQgYUWaE+ecAr
	hDfDglHbejWgptJypDPke1tNbC9M3sX9oNTuDaLVN0m9ACw8DNqXCLj77ex6aY7tKJqvGOfKxGBk0
	xd2t8PNRkrpQoK6Ppg09vMM3sgg6VMO1J6Qk4XSvyHY9cd+fHpA2KM13ESY29i2z2Henk2G6y5AYg
	djivCO1z6eSPJUOrGwuTW4I0oNDKQE0ffNX40iukuWAsIHGHwiTIj4du6M6GxA8QDibH9xLILHSOE
	P5jmTw3ACGhi2H9VhA==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1sAeyL-002TRt-0h;
	Sat, 25 May 2024 00:09:17 +0000
Date: Sat, 25 May 2024 00:09:17 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org,
	andreas@gaisler.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: niagara2: Remove unused struct
 'n2_skcipher_request_context'
Message-ID: <ZlEsLYaoQxZjyyAX@gallifrey>
References: <20240511145620.226548-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20240511145620.226548-1-linux@treblig.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 00:09:04 up 16 days, 11:23,  1 user,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* linux@treblig.org (linux@treblig.org) wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> 'n2_skcipher_request_context' was added in
> commit 23a6564a6b51 ("crypto: niagara2 - switch to skcipher API")
> but never used.
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Ping.

Dave
> ---
>  drivers/crypto/n2_core.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
> index 59d472cb11e75..251e088a53dff 100644
> --- a/drivers/crypto/n2_core.c
> +++ b/drivers/crypto/n2_core.c
> @@ -720,10 +720,6 @@ static inline struct n2_skcipher_alg *n2_skcipher_alg(struct crypto_skcipher *tf
>  	return container_of(alg, struct n2_skcipher_alg, skcipher);
>  }
>  
> -struct n2_skcipher_request_context {
> -	struct skcipher_walk	walk;
> -};
> -
>  static int n2_aes_setkey(struct crypto_skcipher *skcipher, const u8 *key,
>  			 unsigned int keylen)
>  {
> -- 
> 2.45.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
