From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Where has CRYPTO_TFM_MODE_nnn gone?
Date: Fri, 08 Jun 2007 16:17:48 +1000
Message-ID: <E1HwXnA-0005QC-00@gondolin.me.apana.org.au>
References: <46689D79.8020908@pmc-sierra.com>
Cc: linux-crypto@vger.kernel.org, Shane_McDonald@pmc-sierra.com
To: Marc_St-Jean@pmc-sierra.com (Marc St-Jean)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2281 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754843AbXFHGRz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jun 2007 02:17:55 -0400
In-Reply-To: <46689D79.8020908@pmc-sierra.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Marc St-Jean <Marc_St-Jean@pmc-sierra.com> wrote:
> 
> I'm porting a security engine driver from 2.6.18 to 2.6.21/22. I've found
> that although 'cit_mode' is still in struct cipher_tfm, the definitions
> for CRYPTO_TFM_MODE_ECB and CRYPTO_TFM_MODE_CBC are gone!

Thanks for noticing it, I'll make sure that cit_mode disappears :)

> Our HW needs to know what mode to set up some SA flags. Any advice on
> how to best find this mode from a common cipher function which can handle
> AES, DES and 3DES?

The block algorithm is now part of the name just like the cipher
algorithm itself.  So if you're providing a block cipher you should
register it as "cbc(aes)" (for example) instead of "aes" as you would've
done previously.

Check out drivers/crypto/padlock* for a good example.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
