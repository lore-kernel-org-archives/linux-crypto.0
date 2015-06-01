From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v3 PATCH] crypto: aesni - Convert rfc4106 to new AEAD interface
Date: Mon, 1 Jun 2015 17:09:51 +0800
Message-ID: <20150601090951.GA12317@gondor.apana.org.au>
References: <20150528140311.GA8423@gondor.apana.org.au>
 <20150601075022.GA11611@gondor.apana.org.au>
 <20150601075306.GA11725@gondor.apana.org.au>
 <2306645.epOL7FXtYn@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56054 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbbFAJKA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 05:10:00 -0400
Content-Disposition: inline
In-Reply-To: <2306645.epOL7FXtYn@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 01, 2015 at 11:04:39AM +0200, Stephan Mueller wrote:
>
> Just FYI: when testing rfc4106(gcm(aes-aesni)) with the old givcipher API, I 
> got a crash in my code invoking the cipher which used to work in older kernels 
> and which works with the C implementations. So, there must be some change in 
> how givcipher is treated by the AESNI implementation.
> 
> As this API is sunset now, shall I dig deeper or shall we simply deactivate 
> the API entirely?

What do you mean by the old givcipher API? Are you referring to the
old algif_aead that was disabled?

Can you show me the crash that you got and as much information as
you can about the caller that triggered the crash?

The assumption at this point is that all users outside of crypto/
itself are gone.  But I'd still like to look at the crash just in
case it's relevant for users within crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
