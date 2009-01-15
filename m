From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH crypto -v3 1/2] AES-NI: Add support to access
	underlying blkcipher under cryptd ablkcipher
Date: Thu, 15 Jan 2009 14:14:54 +1100
Message-ID: <20090115031454.GA27821@gondor.apana.org.au>
References: <1231919046.5937.159.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44224 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753814AbZAODPA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2009 22:15:00 -0500
Content-Disposition: inline
In-Reply-To: <1231919046.5937.159.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 14, 2009 at 03:44:06PM +0800, Huang Ying wrote:
> cryptd_alloc_ablkcipher() will allocate a cryptd-ed ablkcipher for
> specified algorithm name. The new allocated one is guaranteed to be
> cryptd-ed ablkcipher, so the blkcipher underlying can be gotten via
> cryptd_ablkcipher_child().
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Thanks for the patch!
  
> +struct crypto_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
> +						  u32 type, u32 mask)

It should have its own type so that we get compiler type checking.
Something like,

	struct cryptd_ablkcipher {
		struct crypto_ablkcipher *cipher;
	};

> +	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
> +		     "cryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
> +		return ERR_PTR(-EINVAL);
> +	return crypto_alloc_ablkcipher(cryptd_alg_name, type, mask);

We should also check that the new tfm's module matches ours, i.e.,

	crypto_ablkcipher_tfm(cipher)->__crt_alg->cra_module ==
	THIS_MODULE

Granted this doesn't do much if we're built-in but it's better
than nothing.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
