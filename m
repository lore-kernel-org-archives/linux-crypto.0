From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: poly1305 - get rid of cra_alignmask
Date: Fri, 5 Jan 2018 22:17:40 +1100
Message-ID: <20180105111740.GE16156@gondor.apana.org.au>
References: <20171229161026.28102-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:50010 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751642AbeAELRq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jan 2018 06:17:46 -0500
Content-Disposition: inline
In-Reply-To: <20171229161026.28102-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 29, 2017 at 10:10:23AM -0600, Eric Biggers wrote:
> This series gets rid of the cra_alignmask set on poly1305-generic and
> poly1305-simd, since it was only actually used when outputting the final
> digest.  By removing the alignmask, the crypto API will no longer need
> to waste time aligning the buffers.
> 
> Eric Biggers (3):
>   crypto: poly1305 - use unaligned access macros to output digest
>   crypto: poly1305 - remove cra_alignmask
>   crypto: x86/poly1305 - remove cra_alignmask
> 
>  arch/x86/crypto/poly1305_glue.c |  1 -
>  crypto/poly1305_generic.c       | 10 ++++------
>  2 files changed, 4 insertions(+), 7 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
