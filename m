From: 'Antoine Tenart' <antoine.tenart@bootlin.com>
Subject: Re: [PATCH 01/10] crypto: aead - allow to allocate AEAD requests on
 the stack
Date: Thu, 3 May 2018 14:23:30 +0200
Message-ID: <20180503122330.GB3324@kwain>
References: <20180502095725.31935-1-antoine.tenart@bootlin.com>
 <20180502095725.31935-2-antoine.tenart@bootlin.com>
 <02ad9eb93c494314a85db69886cf787a@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: 'Antoine Tenart' <antoine.tenart@bootlin.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        "nadavh@marvell.com" <nadavh@marvell.com>,
        "oferh@marvell.com" <oferh@marvell.com>,
        "igall@marvell.com" <igall@marvell.com>
To: David Laight <David.Laight@aculab.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <02ad9eb93c494314a85db69886cf787a@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi David,

On Wed, May 02, 2018 at 02:55:19PM +0000, David Laight wrote:
> From: Antoine Tenart
> > 
> > +#define AEAD_REQUEST_ON_STACK(name, tfm) \
> > +	char __##name##_desc[sizeof(struct aead_request) + \
> > +		crypto_aead_reqsize(tfm)] CRYPTO_MINALIGN_ATTR; \
> > +	struct aead_request *name = (void *)__##name##_desc
> > +
> 
> This looks stunningly like a VLA.

I was expecting this question :) The thing is this define looks *a lot*
like the ones defined in other places in the crypto framework, such as
SKCIPHER_REQUEST_ON_STACK and AHASH_REQUEST_ON_STACK. Those haven't been
tackled down so far by the whole VLA removal so the idea was that the
same solution will apply to the 3 of them (and then I'm not really
adding a new one).

If you do have a suggestion on how to fix the 3 of them, I'll be glad to
make a patch for that, but I'm not sure there's an easy solution. And I
don't think I saw a patch on the mailing list about those defines.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
