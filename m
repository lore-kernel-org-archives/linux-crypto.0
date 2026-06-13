Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57337221FB1
	for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 14:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781360701; cv=none; b=forLNet7z3rTrs9z913zfNTVyLIOQXVs0zZxdwpbp0mxdMdAnPjJmfhbs887v3unTQT3yaUJLGz0waCAcB/uihquw14eAbXxtnUR7L8AjRs8RcHyJRHVBqQj2vG+R2U4oWBiL383v3xAz5LCo9xoGACp4a+vh0REorHP23GNQpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781360701; c=relaxed/simple;
	bh=YymJ1eQNnPUb5E/q1HSHY9HzbaB7+HHRNqaAGKXlTSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hMXoLSjbftxjgI2knu2c3ITConkJ/UJ1jK7D2TCrQ63KkVAiaNAK5uXg2/dTRl/VFVJFaJdT+AMIBwNtJoK99ESweFA5zQ5bmJMQMzzbGVjjt+aFzFSAYxIHiYgW+ptr3vIIog1l69SpzcT+ItZGPYFIWs5xbS8ZQ80uhK/M43Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U37ReKlu; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U37ReKlu"
Date: Sat, 13 Jun 2026 16:23:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781360643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v6Yfl0Uwg0BDUcS8cQ6OpAhkSkDfEgqDZ4hAaNO3jB4=;
	b=U37ReKluIKfFX2O9SyLBVovVvFsAjbn21u7eeb7/2LYmXsFmlnu+ZUuD9KcyUVJtiC0SB+
	iO3Bmk4hTxScH5rhpYx0Ulseuko7d8JRw/nEv5z8zeQa6s2M38q+Cz9cgbCPR6Q7pNvYox
	2s8t2zyY/zNdcfqLg64abgQ2JFk8FnI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - drop unused curve id from
 atmel_ecdh_ctx
Message-ID: <ai1n_1FbXrLIRZUt@linux.dev>
References: <20260611105159.460794-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611105159.460794-3-thorsten.blum@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 11, 2026 at 12:52:01PM +0200, Thorsten Blum wrote:
> ->curve_id is only set once, but never used - remove it.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-ecc.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> index 9da9dd6585df..93f219558c2f 100644
> --- a/drivers/crypto/atmel-ecc.c
> +++ b/drivers/crypto/atmel-ecc.c
> @@ -33,7 +33,6 @@ static struct atmel_ecc_driver_data driver_data;
>   * @public_key : generated when calling set_secret(). It's the responsibility
>   *               of the user to not call set_secret() while
>   *               generate_public_key() or compute_shared_secret() are in flight.
> - * @curve_id   : elliptic curve id
>   * @do_fallback: true when the device doesn't support the curve or when the user
>   *               wants to use its own private key.
>   */
> @@ -41,7 +40,6 @@ struct atmel_ecdh_ctx {
>  	struct i2c_client *client;
>  	struct crypto_kpp *fallback;
>  	const u8 *public_key;
> -	unsigned int curve_id;
>  	bool do_fallback;
>  };
>  
> @@ -250,7 +248,6 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
>  	struct crypto_kpp *fallback;
>  	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
>  
> -	ctx->curve_id = ECC_CURVE_NIST_P256;
>  	ctx->client = atmel_ecc_i2c_client_alloc();
>  	if (IS_ERR(ctx->client)) {
>  		pr_err("tfm - i2c_client binding failed\n");

I'll need to rebase and resend this assuming [1] is applied first, as it
currently doesn't apply cleanly.

[1] https://lore.kernel.org/lkml/20260609100552.233494-3-thorsten.blum@linux.dev/
