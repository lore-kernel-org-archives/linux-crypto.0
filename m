From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 01/11] crypto: Documentation - crypto API high level
 spec
Date: Mon, 3 Nov 2014 22:43:37 +0800
Message-ID: <20141103144337.GA31659@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4303532.NGaUQ44sQJ@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 03, 2014 at 03:18:29PM +0100, Stephan Mueller wrote:
>
> > > + * CRYPTO_ALG_TYPE_CIPHER	Raw block cipher
> > > + * CRYPTO_ALG_TYPE_COMPRESS	Compression
> > > + * CRYPTO_ALG_TYPE_AEAD		Authenticated Encryption with 
> Associated Data
> > > (MAC) + * CRYPTO_ALG_TYPE_BLKCIPHER	Synchronous multi-block cipher
> > > + * CRYPTO_ALG_TYPE_ABLKCIPHER	Asynchronous multi-block cipher
> > > + * CRYPTO_ALG_TYPE_GIVCIPHER
> > 
> > What's this one?
> 
> I would like to ask Herbert what that is -- I looked around in the code and I 
> am not sure what that flag shall indicate.

givcipher is an ablkcipher packed together with an IV generator.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
