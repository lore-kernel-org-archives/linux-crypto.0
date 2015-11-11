From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Hardware Crypto Driver
Date: Wed, 11 Nov 2015 12:24:03 +0800
Message-ID: <20151111042403.GA21253@gondor.apana.org.au>
References: <CAG3F19ArjmvN=hEsL67f1vH56nxVfZryV9utNCqosVT9J6FTCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Orlando <orlcp440@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46270 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbKKEYI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Nov 2015 23:24:08 -0500
Content-Disposition: inline
In-Reply-To: <CAG3F19ArjmvN=hEsL67f1vH56nxVfZryV9utNCqosVT9J6FTCQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Orlando <orlcp440@gmail.com> wrote:
> Hello, I am new to the crypto framework in linux kernel and mailing
> list in general. I am porting a driver omap-aes.c to my platform and
> having problems with IV being modified against my will. I am doing
> AES-128-CTR and I need the IV to increment by 1 every 16 bytes.
> Instead some garbage IV is being returned to me after I do an encrypt
> operation.
> 
> I have no idea how the IV is being manipulated since the omap-aes.c
> driver accepts and write the IV to the Hardware that comes from upper
> layers but it never writes it back to the upper layers after doing
> encryption.

The omap-aes is probably buggy in this regard.  The crypto selftest
system isn't currently testing this so a number of buggy drivers
have slipped through.

If you can send us a patch to fix this it would be great.  Otherwise
I will be working through the drivers during the skcipher conversion.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
