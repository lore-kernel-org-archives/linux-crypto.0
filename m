From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 2] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Sat, 9 Jun 2007 15:02:29 +1000
Message-ID: <20070609050229.GA692@gondor.apana.org.au>
References: <20070604134248.GA9645@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3866 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750958AbXFIFCi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Jun 2007 01:02:38 -0400
Content-Disposition: inline
In-Reply-To: <20070604134248.GA9645@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 04, 2007 at 05:42:48PM +0400, Evgeniy Polyakov wrote:
> 
> take2:
>  * added a lot of cryptoapi interfaces (i.e. support for all crypto
>    modes and three ciphers: aes, des and 3des via cryptoapi).
>    
>    My cat has pissed on my domestic slippers when he saw that.
>    And believe me, he does know, how to distinguish between good and
>    other code. Well, I do not have a cat, but if I would, he would
>    definitely piss on my slippers. The most interesting stuff starts
>    from 1600+ lines. Herbert, are you sure it is ok?

Well I congratulate your imaginary cat because he's obviously seen
something fishy :)

> +static struct hifn_alg_template hifn_alg_templates[] = {
> +	{
> +		.name = "ecb(aes)", .drv_name = "hifn-aes", .bsize = 16, 
> +		.ablkcipher = {
> +			.min_keysize	=	AES_MIN_KEY_SIZE,
> +			.max_keysize	=	AES_MAX_KEY_SIZE,
> +			.setkey		=	hifn_setkey,
> +			.encrypt	=	hifn_encrypt_aes_ecb_16,
> +			.decrypt	=	hifn_decrypt_aes_ecb_16,
> +		},
> +	},

You don't have to repeat this for every key size, well not just yet.
If we get enough weird hardware in future that doesn't support all
of 16/24/32, then it might become necessary.

So for now you should reduce the 16/24/32 variants down to just one.

> +	{
> +		.name = "ecb(aes)", .drv_name = "hifn-aes", .bsize = 24, 

Even if we were doing different key sizes individually, it's not bsize
that needs changing but keysize.  The block size for AES is always 16.

I'll look over the rest of it next.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
