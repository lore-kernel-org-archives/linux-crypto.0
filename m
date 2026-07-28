Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF2015A86D;
	Tue, 28 Jul 2026 06:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785219425; cv=none; b=qHUZqcdwlRRTRuHJ2sVyU4wyiexHv1PggIC1yH+DJHi7x4z91KRqRNm4Q7iB+WEc+3CIiEc3Adapp+JF5olBhFjNzwCwVXarCqnthiOIxqJ2tz+vsj9UDT895++NnAxXmM5R1qkPqMMcuJKmOfrSw3Ot1Dz+vFSX/vKcfEkZVr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785219425; c=relaxed/simple;
	bh=wBQ3X824qj3vU5WIQW5+TP5ssNj2UhQD4Yd/pQhzvNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oK4Nj6vrTyHhKZura329r+F7h5NIZZGix/Gglk2iVNjlrJ7HtbEYGXnHMDsPIZ6V7qcjAuq2FE1qpE7QkCQmabe4C5RQjo+SyxG5DKw4iuS9Ye8xpCozQdAZWKNiQel4ws3X8a4hNjSGx2cBqIfl7vrQaQ+xGdj+ay+LVTbryWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id 257251717;
	Tue, 28 Jul 2026 08:16:58 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 16B9F60B03EB; Tue, 28 Jul 2026 08:16:58 +0200 (CEST)
Date: Tue, 28 Jul 2026 08:16:58 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Changwei Zou <changwei.zou@canonical.com>,
	Martin Kepplinger-Novakovic <Martin.Kepplinger-Novakovic@ginzinger.com>,
	Martin Kepplinger-Novakovic <martink@posteo.de>
Cc: herbert@gondor.apana.org.au, ignat@linux.win, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: rsassa-pkcs1: align DMA buffer to
 ARCH_DMA_MINALIGN
Message-ID: <amhJWs2AdPgFzw8t@wunner.de>
References: <20260727224300.150132-1-changwei.zou@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260727224300.150132-1-changwei.zou@canonical.com>

[cc += Martin Kepplinger-Novaković]

On Tue, Jul 28, 2026 at 08:43:00AM +1000, Changwei Zou wrote:
> out_buf is used as a DMA buffer for the RSA verification operation.
> If out_buf is not aligned to ARCH_DMA_MINALIGN, cacheline sharing
> problems (data corruption) would occur on CPUs with DMA-incoherent caches,
> leading to -EKEYREJECTED.
> 
> Fix by aligning out_buf to ARCH_DMA_MINALIGN using PTR_ALIGN(), and
> allocating ARCH_DMA_MINALIGN extra bytes in the child_req allocation
> to accommodate the alignment padding.
> 
> The intermittent error 'Key was rejected by service' on i.MX8 with CAAM
> can be triggered when loading signed kernel modules.
> 
>     for i in $(seq 1 100); do
>         sudo modprobe xfs 2>&1 && echo "SUCCESS on attempt $i" \
>         && sudo rmmod xfs || echo "FAILED on attempt $i"
>     done
> 
> Fixes: 8552cb04e083 ("crypto: rsassa-pkcs1 - Copy source data for SG list")
> Signed-off-by: Changwei Zou <changwei.zou@canonical.com>

@Martin Kepplinger-Novaković:  Could you test whether this fixes
the issue you reported in February?

If it does:

Reported-by: Martin Kepplinger-Novaković <Martin.Kepplinger-Novakovic@ginzinger.com>
Closes: https://lore.kernel.org/r/6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com


@Changwei Zou:  Just to double-check, I assume this supersedes the
following patch, right?

https://lore.kernel.org/r/20260723150107.33546-1-changwei.zou@canonical.com


> +++ b/crypto/rsassa-pkcs1.c
> @@ -237,12 +239,13 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
>  		return -EINVAL;
>  
>  	/* RFC 8017 sec 8.2.2 step 2 - RSA verification */
> -	child_req = kmalloc(sizeof(*child_req) + child_reqsize + ctx->key_size,
> -			    GFP_KERNEL);
> +	child_req = kmalloc(sizeof(*child_req) + child_reqsize +
> +				    ctx->key_size + ARCH_DMA_MINALIGN, GFP_KERNEL);
>  	if (!child_req)
>  		return -ENOMEM;
>  
> -	out_buf = (u8 *)(child_req + 1) + child_reqsize;
> +	out_buf  = PTR_ALIGN((u8 *)(child_req + 1) + child_reqsize,
> +				    ARCH_DMA_MINALIGN);
>  	memcpy(out_buf, src, slen);

We've got CRYPTO_DMA_ALIGN, CRYPTO_MINALIGN, CRYPTO_DMA_PADDING macros,
I think those would be more appropriate.

A few nits:
There's a duplicate blank in the "out_buf  =" assignment and
the line-wrapped function arguments aren't aligned to the opening brace.

> @@ -7,6 +7,8 @@
>   * Copyright (c) 2015 - 2024 Intel Corporation
>   */
>  
> +#include <linux/align.h>
> +#include <linux/cache.h>
>  #include <linux/module.h>
>  #include <linux/scatterlist.h>
>  #include <crypto/akcipher.h>

I think you won't be needing those #includes if you use the CRYPTO_*
alignment macros.

Thanks,

Lukas
