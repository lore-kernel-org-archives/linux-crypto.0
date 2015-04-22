From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Wed, 22 Apr 2015 14:06:08 +0800
Message-ID: <20150422060608.GA7987@gondor.apana.org.au>
References: <6218629.uO4632Hmli@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48601 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbbDVGGM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 02:06:12 -0400
Content-Disposition: inline
In-Reply-To: <6218629.uO4632Hmli@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 22, 2015 at 06:36:59AM +0200, Stephan Mueller wrote:
>
> +	if (req->iv)
> +		ret = crypto_memneq(block.A, req->iv, SEMIBSIZE);
> +	else
> +		ret = crypto_memneq(block.A, default_iv, SEMIBSIZE);

No we don't allow variable-sized IVs.  Either you should always
have an IV, or never have one (i.e., make it zero-sized).

If you want to accomodate both, then provide kw(aes) as the full
IV version and then add a rfc3394(kw(aes)) on top of it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
