From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RESEND] crypto: algif_rng - zeroize buffer with random
 data
Date: Mon, 16 Mar 2015 21:49:58 +1100
Message-ID: <20150316104958.GC793@gondor.apana.org.au>
References: <1488589.sO3PXAYh7F@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1488589.sO3PXAYh7F@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 13, 2015 at 11:44:07AM +0100, Stephan Mueller wrote:
> Due to the change to RNGs to always return zero in success case, the RNG
> interface must zeroize the buffer with the length provided by the
> caller.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
