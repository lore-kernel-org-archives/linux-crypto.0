From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH  v5 2/2] crypto: akcipher - Changes to asymmetric key API
Date: Thu, 8 Oct 2015 21:06:33 +0800
Message-ID: <20151008130633.GC24128@gondor.apana.org.au>
References: <20151002051032.27263.21150.stgit@tstruk-mobl1>
 <20151002051043.27263.10920.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60122 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbbJHNGg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2015 09:06:36 -0400
Content-Disposition: inline
In-Reply-To: <20151002051043.27263.10920.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 01, 2015 at 10:10:43PM -0700, Tadeusz Struk wrote:
>
>  /**
> + * crypto_akcipher_get_len() -- Get minimum len for output buffer
> + *
> + * Function returns minimum dest buffer size for a given key
> + *
> + * @tfm:	AKCIPHER tfm handle allocated with crypto_alloc_akcipher()
> + *
> + * Return: minimum len for output buffer or error code in key hasn't been set
> + */
> +static inline int crypto_akcipher_get_len(struct crypto_akcipher *tfm)

Please rename this to something like

	crypto_akcipher_maxsize

I presume it's actually the maximum size that would be required
of the destination buffer rather than the minimum.  The latter
would seem to be quite useless.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
