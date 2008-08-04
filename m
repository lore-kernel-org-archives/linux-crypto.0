From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API.
Date: Mon, 4 Aug 2008 22:18:22 +0800
Message-ID: <20080804141822.GB11415@gondor.apana.org.au>
References: <1217842507.20845.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Austin Zhang <austin_zhang@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60710 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754816AbYHDOS3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 10:18:29 -0400
Content-Disposition: inline
In-Reply-To: <1217842507.20845.18.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 04, 2008 at 05:35:07AM -0400, Austin Zhang wrote:
>
> +static int crc32c_intel_cra_init(struct crypto_tfm *tfm)
> +{
> +	u32 *key = crypto_tfm_ctx(tfm);
> +
> +	*key = ~0;
> +
> +	tfm->crt_ahash.reqsize = sizeof(u32);
> +
> +	if (cpu_has_xmm4_2)
> +		return 0;
> +	else
> +		return -1;
> +}

This check needs to be moved to the module init function and
if it fails the module should not register the algorithm.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
