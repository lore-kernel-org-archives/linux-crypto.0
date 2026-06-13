Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD5B2BDC23;
	Sat, 13 Jun 2026 14:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781360518; cv=none; b=q1HPb0tn5f1uWi0OkkSSZv7bdgij3XA9Kjeh/JFw0ZXA0rU2sWA9Rl3PGsSn+UUv1ZSb3qBpW8A/ugDA2k4+fWwYpKkMf2yi3Hnn1Ahin0T1ZhxJwPRFoLTbc3ol2HkHjtZU3CjwMmIUltxgo0WdFfapfV8kzZ25unKM9hswg+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781360518; c=relaxed/simple;
	bh=c8H3re+20PIBNk1cVLaerN7ifaokmo2K9DIBvbPiMWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yga/uui38l7XGR1aOFP2USgfJ6RgVPMQnr4+x4k3vmkicsHE+hvh0NYoVjLSal/drAs0z3HS0iLQisd/3gF3/w1McWpawFmJhBPbxixalsNrRvTKt/LXhb/EnUzk3kC0bry3gNBOz/zoJf7dVRg9jkp9W3UZEFUH3mnEnLiuDlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DVVb9Ck2; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DVVb9Ck2"
Date: Sat, 13 Jun 2026 16:21:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781360515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eZvGsfpraU6oBDZ4RPThDPrlUZXNyfD9kScODFAv9r8=;
	b=DVVb9Ck2muSHWK5iJBtFSxAwQKlH91rRhb4Hp8Bp2DQ2/AK172e1Vccow58W0s3PZ3fbnO
	mXVqRI5DNhTYy+g08XLUi0WETYe8OcJJyTeu0KjW08Ck8Xfn60eDaYutmUh6yIqQP8t5Bx
	WNBVOYf8keiSUZgkV8nqZIZoz/DaBDI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - reject hardware ECDH without a
 public key
Message-ID: <ai1neXGLIQqSjlWl@linux.dev>
References: <20260611213617.463552-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611213617.463552-2-thorsten.blum@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 11, 2026 at 11:36:17PM +0200, Thorsten Blum wrote:
> The hardware ECDH path in atmel_ecdh_compute_shared_secret() uses the
> private key stored in the device. However, the public key is cached only
> after atmel_ecdh_set_secret() successfully generated that private key
> for the current tfm.
> 
> atmel_ecdh_generate_public_key() already rejects requests when no public
> key is cached. Add the same check to atmel_ecdh_compute_shared_secret()
> to prevent the device from using a private key that was not generated
> for the current tfm.
> 
> Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-ecc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> index 93f219558c2f..542c8cc13a0f 100644
> --- a/drivers/crypto/atmel-ecc.c
> +++ b/drivers/crypto/atmel-ecc.c
> @@ -173,6 +173,9 @@ static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
>  		return crypto_kpp_compute_shared_secret(req);
>  	}
>  
> +	if (!ctx->public_key)
> +		return -EINVAL;
> +
>  	/* must have exactly two points to be on the curve */
>  	if (req->src_len != ATMEL_ECC_PUBKEY_SIZE)
>  		return -EINVAL;

I'll need to rebase and resend this assuming [1] is applied first, as it
currently doesn't apply cleanly.

[1] https://lore.kernel.org/lkml/20260609100552.233494-3-thorsten.blum@linux.dev/
