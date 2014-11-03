From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 01/11] crypto: Documentation - crypto API high level
 spec
Date: Mon, 3 Nov 2014 22:49:25 +0800
Message-ID: <20141103144925.GA31688@gondor.apana.org.au>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
 <4163724.RCMDlx8dmE@tachyon.chronox.de>
 <20141103083439.635f5cb6@lwn.net>
 <4303532.NGaUQ44sQJ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jonathan Corbet <corbet@lwn.net>,
	"David S. Miller" <davem@davemloft.net>,
	Marek Vasut <marex@denx.de>,
	Jason Cooper <cryptography@lakedaemon.net>,
	Grant Likely <grant.likely@secretlab.ca>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36147 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaKCOtn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Nov 2014 09:49:43 -0500
Content-Disposition: inline
In-Reply-To: <4303532.NGaUQ44sQJ@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 03, 2014 at 03:18:29PM +0100, Stephan Mueller wrote:
>
> > > + * CRYPTO_ALG_TYPE_DIGEST	Raw message digest
> > > + * CRYPTO_ALG_TYPE_HASH		Alias for CRYPTO_ALG_TYPE_DIGEST
> > > + * CRYPTO_ALG_TYPE_SHASH	Synchronous multi-block hash
> > > + * CRYPTO_ALG_TYPE_AHASH	Asynchronous multi-block hash
> > > + * CRYPTO_ALG_TYPE_RNG		Random Number Generation
> > > + * CRYPTO_ALG_TYPE_PCOMPRESS
> > 
> > What's that last one?
> 
> Same here.

pcompress is an enhanced version of compress allowing for piece-meal
compression/decompression rather than having to shove everything in
all at once.

Eventually pcompress should replace the compress interface once
everything is converted across.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
