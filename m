From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Thu, 8 Apr 2010 22:07:58 +0800
Message-ID: <20100408140758.GA25138@gondor.apana.org.au>
References: <4BAA26DD.3000007@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:58000 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750768Ab0DHOID (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Apr 2010 10:08:03 -0400
Content-Disposition: inline
In-Reply-To: <4BAA26DD.3000007@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

OK so you did answer my question :)

Dmitry Kasatkin <dmitry.kasatkin@nokia.com> wrote:
>
> Interesting case with hmac.
> 
>     return crypto_shash_init(&desc.shash) ?:
>            crypto_shash_update(&desc.shash, ipad, bs) ?:
>            crypto_shash_export(&desc.shash, ipad) ?:
>            crypto_shash_init(&desc.shash) ?:
>            crypto_shash_update(&desc.shash, opad, bs) ?:
>            crypto_shash_export(&desc.shash, opad);
> 
> Basically it does not call final.
> Then call init again.
> 
> hw has certain limitation that it requires to process last block with 
> some bit set.
> WHen update is called there is no possibility to know that no more 
> update() will come.
> So possible last block is stored and then hashed out from the final.
> 
> I see that above code will not work with the driver.
> I wonder how intermediate export/import could be done with omap hw.
> 
> But if it's not possible, then why not to have hmac(sha1) as just sw.
> Anyway hmac should not process as huge amount of data as hash itself.
>
> What is your opinion/advice?

A sha1-only driver is not very useful since the biggest potential
user IPsec uses hmac(sha1).

Is the omap hw documentation available publicly?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
