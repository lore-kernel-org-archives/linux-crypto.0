From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] Add VMAC(AES) to Linux for intel_txt support
Date: Tue, 21 Jul 2009 15:29:44 +0800
Message-ID: <20090721072944.GB15534@gondor.apana.org.au>
References: <4A5F41C4.3050808@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, joseph.cihula@intel.com
To: Shane Wang <shane.wang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58401 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751038AbZGUH3r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jul 2009 03:29:47 -0400
Content-Disposition: inline
In-Reply-To: <4A5F41C4.3050808@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 16, 2009 at 11:05:40PM +0800, Shane Wang wrote:
>
> The following VMAC(AES) patch, ported from http://fastcrypto.org/vmac,  
> is used to support S3 memory integrity verification for Intel(R) Trusted  
> Execution Technology (for more about Intel(R) TXT patches, see  
> http://lkml.org/lkml/2009/6/22/578), since the VMAC algorithm is very  
> fast to MAC the memory during S3 sleep, compared with other MAC 
> algorithms.
>
> We request your feedback and suggestions.

Thanks for your patch.  Could you please follow the instructions
in Documentation/SubmitChecklist and update the patch? As it is
it's a bit of a pain to review.

> +/*
> + * Enable code tuned for 64-bit registers; otherwise tuned for 32-bit
> + */
> +#ifndef VMAC_ARCH_64
> +#define VMAC_ARCH_64 (__x86_64__ || __ppc64__ || _M_X64)
> +#endif

If you really must have this then please use CONFIG_64BIT instead.

> +/*
> + * Native word reads. Update (or define via compiler) if incorrect
> + */
> +#ifndef VMAC_ARCH_BIG_ENDIAN	/* Assume big-endian unless on the list */
> +#define VMAC_ARCH_BIG_ENDIAN \
> +	(!(__x86_64__ || __i386__ || _M_IX86 || \
> +	_M_X64 || __ARMEL__ || __MIPSEL__))
> +#endif

This is unnecessary.  Please use the standard kernel helpers
from asm/byteorder.h (which you get by including linux/kernel.h).

> +#define UINT64_C(x) x##ULL
> +const uint64_t p64   = UINT64_C(0xfffffffffffffeff);  /* 2^64 - 257  
> prime  */

Please use u64 instead of uint64_t to be consistent with the current
convention in crypto/.

> +static struct crypto_instance *vmac_alloc(struct rtattr **tb)
> +{
> +	struct crypto_instance *inst;
> +	struct crypto_alg *alg;
> +	int err;
> +
> +	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_HASH);
> +	if (err)
> +		return ERR_PTR(err);

Please reimplement this as an SHASH algorithm.  You can refer
to the new hmac implementation in the current cryptodev tree
as an example.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
