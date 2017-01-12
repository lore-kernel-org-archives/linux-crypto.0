From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: kpp - clear CRYPTO_ALG_DEAD bit in prepare_alg
Date: Thu, 12 Jan 2017 23:41:50 +0800
Message-ID: <20170112154150.GA16389@gondor.apana.org.au>
References: <1483364021-103771-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53883 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750747AbdALPmC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 10:42:02 -0500
Content-Disposition: inline
In-Reply-To: <1483364021-103771-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 02, 2017 at 01:33:41PM +0000, Salvatore Benedetto wrote:
> Make sure CRYPTO_ALG_DEAD is not set when preparing for
> alg registration. This fixes qat-dh registration that occurs
> when reloading qat_c62x module.
> 
> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
> ---
>  crypto/kpp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/crypto/kpp.c b/crypto/kpp.c
> index d36ce05..d1adef8e 100644
> --- a/crypto/kpp.c
> +++ b/crypto/kpp.c
> @@ -101,6 +101,7 @@ static void kpp_prepare_alg(struct kpp_alg *alg)
>  
>  	base->cra_type = &crypto_kpp_type;
>  	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
> +	base->cra_flags &= ~CRYPTO_ALG_DEAD;
>  	base->cra_flags |= CRYPTO_ALG_TYPE_KPP;
>  }

Same comment as in

https://patchwork.kernel.org/patch/9485115/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
