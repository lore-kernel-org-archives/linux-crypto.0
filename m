From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [QUESTION] hash import and request initialization
Date: Tue, 26 Dec 2017 14:07:51 +1100
Message-ID: <20171226030751.GA11758@gondor.apana.org.au>
References: <CAOtvUMdsqEpUSSBZXxHPzuO-84B3VKxRLLN=y1cxfNbt+5qpSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:48548 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750810AbdLZDII (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Dec 2017 22:08:08 -0500
Content-Disposition: inline
In-Reply-To: <CAOtvUMdsqEpUSSBZXxHPzuO-84B3VKxRLLN=y1cxfNbt+5qpSQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 25, 2017 at 10:07:54AM +0200, Gilad Ben-Yossef wrote:
> Hi there,
> 
> I have ran into something I am unsure about regarding the ccree driver
> implementation and would love to get some guidance:
> 
> I have assumed, based on previous list correspondence, that both of
> the following sequences are legal:
> 
> Scenario A
> 1. ahash_request_alloc
> 2. ahash_import
> 
> Scenario B
> 1. ahash_request_alloc
> 2. crypto_ahash_init
> 3. ahash_import
> 
> However, I've run into the problem that since ahash_request_alloc does
> not zero the allocated request memory
> and specifically does not zero the tfm specific context part of it, I
> have no way to distinguish  between A and B and therefore
> if I have any initialization sequence that needs to happen once per
> request (DMA buffer allocation and mapping in my
> case), I cannot tell if I need to do them in ahash_import callback or not.

crypto_ahash_init is not necessary prior to an ahash_import.  If
crypto_ahash_init does any hardware initialisations, then the same
would be needed in ahash_import and crypto_ahash_digest.

> So, am I'm missing something here or is the B scenario simply not legal?

B is completely legal, just as it would be legal to do this:

1. ahash_request_alloc
2. crypto_ahash_init
3. crypto_ahash_update
4. crypto_ahash_init		// discard previous hash state

Basically you must not hold onto any permanent state at the end
of a hash operation such as init.  IOW you cannot expect a hash
state to be finalised.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
