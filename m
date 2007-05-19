From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [Patch] [CRYPTO] add alignment for setkey() (rev 2)
Date: Sat, 19 May 2007 17:41:36 +1000
Message-ID: <20070519074136.GA6281@gondor.apana.org.au>
References: <20070518140130.GB16349@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3070 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754437AbXESHlk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 May 2007 03:41:40 -0400
Content-Disposition: inline
In-Reply-To: <20070518140130.GB16349@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Sebastian:

On Fri, May 18, 2007 at 04:01:30PM +0200, Sebastian Siewior wrote:
> setkey() in {cipher,blkcipher,ablkcipher,hash}.c does not respect the
> requested alignment by the algorithm. This patch fixes it. The extra
> memory is allocated by kmalloc() with GFP_KERNEL flag.

I think we should stick with GFP_ATOMIC for now.  Once all the atomic
users have been fixed (if they can be), then we can start changing this
interface.

> Index: ps3-linux/crypto/cipher.c
> ===================================================================
> --- ps3-linux.orig/crypto/cipher.c
> +++ ps3-linux/crypto/cipher.c
> @@ -20,16 +20,43 @@
>  #include <linux/string.h>
>  #include "internal.h"
>  
> +static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen,
> +		unsigned long alignmask)

Minor nit.  Could you get rid of the alignmask parameter here and just
read it again from tfm? This should make it easier for certain compiler/
arch combos to generate a tail call.

>  static int setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
>  {
>  	struct cipher_alg *cia = &tfm->__crt_alg->cra_cipher;
> -	
> +	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
> +
>  	tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
>  	if (keylen < cia->cia_min_keysize || keylen > cia->cia_max_keysize) {
>  		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
>  		return -EINVAL;
> -	} else
> -		return cia->cia_setkey(tfm, key, keylen);
> +	}
> +
> +	if ((unsigned long) key & alignmask)

Please kill the space before key.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
