From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] Added CRYPTO_ALG_KERN_DRIVER_ONLY flag (3rd
	attempt)
Date: Fri, 6 Jan 2012 12:37:01 +1100
Message-ID: <20120106013701.GA6484@gondor.apana.org.au>
References: <4EE7B6B8.7070700@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:34322 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab2AFBhE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jan 2012 20:37:04 -0500
Content-Disposition: inline
In-Reply-To: <4EE7B6B8.7070700@gnutls.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Nikos Mavrogiannopoulos <nmav@gnutls.org> wrote:
> The added CRYPTO_ALG_KERN_DRIVER_ONLY indicates whether a cipher
> is only available via a kernel driver. If the cipher implementation
> might be available by using an instruction set or by porting the
> kernel code, then it must not be set.
> 
> In addition it provides crypto_tfm_alg_flags() to obtain
> this and other possible flags.
> 
> Signed-off-by: Nikos Mavrogiannopoulos <nmav@gnutls.org>

For future reference a cc to me is appreciated.

> +static inline u32 crypto_tfm_alg_flags(struct crypto_tfm *tfm)
> +{
> +       return tfm->__crt_alg->cra_flags;
> +}
> +

Who is going to use this? For one it's not type-safe as we try
to avoid directly using crypto_tfm in kernel code.

Otherwise your patch looks OK.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
