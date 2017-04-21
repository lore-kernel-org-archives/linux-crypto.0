From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: acomp - report scomp implementations
Date: Fri, 21 Apr 2017 19:39:07 +0800
Message-ID: <20170421113907.GB14100@gondor.apana.org.au>
References: <20170419132614.3363-1-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com,
        giovanni.cabiddu@gmail.com
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:42828 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1038793AbdDULjl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 07:39:41 -0400
Content-Disposition: inline
In-Reply-To: <20170419132614.3363-1-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 19, 2017 at 02:26:14PM +0100, Giovanni Cabiddu wrote:
> Fix crypto_has_acomp to report scomp implementations.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  include/crypto/acompress.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> index e328b52..39871f9 100644
> --- a/include/crypto/acompress.h
> +++ b/include/crypto/acompress.h
> @@ -162,6 +162,7 @@ static inline int crypto_has_acomp(const char *alg_name, u32 type, u32 mask)
>  {
>  	type &= ~CRYPTO_ALG_TYPE_MASK;
>  	type |= CRYPTO_ALG_TYPE_ACOMPRESS;
> +	type |= CRYPTO_ALG_TYPE_SCOMPRESS;
>  	mask |= CRYPTO_ALG_TYPE_MASK;
>  
>  	return crypto_has_alg(alg_name, type, mask);

Are you sure this works? I think you should modify the mask instead.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
