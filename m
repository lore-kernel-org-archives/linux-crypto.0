From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AEAD: add check for presence of auth tag
Date: Mon, 5 Jan 2015 21:55:40 +1100
Message-ID: <20150105105540.GA25665@gondor.apana.org.au>
References: <15957213.Wu7Np8vQse@tachyon.chronox.de>
 <7639295.Yx6QIQScqO@tachyon.chronox.de>
 <20150105103957.GA25307@gondor.apana.org.au>
 <1656062.b6mnFyMzhb@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1656062.b6mnFyMzhb@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jan 05, 2015 at 11:53:38AM +0100, Stephan Mueller wrote:
>
> Could you please check: I am unable to find the function.

It's in crypto/authenc.c.

> Note, there is no size parameter provided in crypto_aead_decrypt. To obtain 
> the size, I would need to walk the scatterlists, no?

The cryptlen is supposed to contain the entire input apart from the
AD, including the authentication tag if one is present.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
