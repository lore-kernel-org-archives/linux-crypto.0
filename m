From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/5] crypto: michael_mic - Switch to shash
Date: Wed, 3 Dec 2008 20:04:29 +0800
Message-ID: <20081203120429.GA9818@gondor.apana.org.au>
References: <12282575141051-git-send-email-ken@codelabs.ch> <12282575163307-git-send-email-ken@codelabs.ch> <12282575173222-git-send-email-ken@codelabs.ch> <122825751834-git-send-email-ken@codelabs.ch> <12282575202908-git-send-email-ken@codelabs.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55010 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751155AbYLCMEe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2008 07:04:34 -0500
Content-Disposition: inline
In-Reply-To: <12282575202908-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 02, 2008 at 11:38:34PM +0100, Adrian-Ken Rueegsegger wrote:
> This patch changes michael_mic to the  new shash interface.
> 
> Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>

I've applied patches 1-4.

> -static int michael_setkey(struct crypto_tfm *tfm, const u8 *key,
> +static int michael_setkey(struct crypto_shash *tfm, const u8 *key,
>  			  unsigned int keylen)
>  {
> -	struct michael_mic_ctx *mctx = crypto_tfm_ctx(tfm);
> +	struct michael_mic_ctx *mctx = crypto_shash_ctx(tfm);
>  	const __le32 *data = (const __le32 *)key;
>  
>  	if (keylen != 8) {
> -		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> +		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
>  		return -EINVAL;
>  	}

This looks broken though.  michael_mic is one of the few hashes
with a setkey function.  So you need to model it after crc32c
rather than the others.

In particular, you'll need to split the context structure between
the key part and the descritptor part.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
