From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Subject: Re: Where has CRYPTO_TFM_MODE_nnn gone?
Date: Fri, 8 Jun 2007 12:13:17 -0700
Message-ID: <4669AA4D.5040708@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Cc: linux-crypto@vger.kernel.org,
	Shane McDonald <Shane_McDonald@pmc-sierra.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mother.pmc-sierra.com ([216.241.224.12]:37556 "HELO
	mother.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750908AbXFHTNj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jun 2007 15:13:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu wrote:
> Marc St-Jean <Marc_St-Jean@pmc-sierra.com> wrote:
>  >
>  > I'm porting a security engine driver from 2.6.18 to 2.6.21/22. I've 
> found
>  > that although 'cit_mode' is still in struct cipher_tfm, the definitions
>  > for CRYPTO_TFM_MODE_ECB and CRYPTO_TFM_MODE_CBC are gone!
> 
> Thanks for noticing it, I'll make sure that cit_mode disappears :)

No problem :) Looking at your patch I see that you've also dropped
cit_encrypt_iv/cit_decrypt_iv. That is likely related to my next question
regarding crypto_tfm_alg_ivsize().

In CBC mode we had a line of code copying cipher_desc.info to get the
initialization vector. Such as:
		/* Copy in IV */
		memcpy((u8*)(sa->crypt_iv), desc->info,
			crypto_tfm_alg_ivsize(tfm));

Now the only reference to the function I can find is in an IPsec comment
from include/net/esp.h. Any tips on getting the size?


>  > Our HW needs to know what mode to set up some SA flags. Any advice on
>  > how to best find this mode from a common cipher function which can 
> handle
>  > AES, DES and 3DES?
> 
> The block algorithm is now part of the name just like the cipher
> algorithm itself.  So if you're providing a block cipher you should
> register it as "cbc(aes)" (for example) instead of "aes" as you would've
> done previously.

And if we can support both I assume we must register multiple times?

> Check out drivers/crypto/padlock* for a good example.

Thanks, I have been looking at that code but unfortunately it supports
fewer cryptos/hashes so does not answer all my questions.

Marc
