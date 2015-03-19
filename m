From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 01/16] crypto: prevent helper ciphers from being used
Date: Thu, 19 Mar 2015 18:29:52 +1100
Message-ID: <20150319072952.GA3106@gondor.apana.org.au>
References: <21952258.n2qYaab1Is@tachyon.chronox.de>
 <109752153.14abfcUJ8X@tachyon.chronox.de>
 <20150319071630.GA2902@gondor.apana.org.au>
 <29741349.4tmP3Ys1qT@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <29741349.4tmP3Ys1qT@tauon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Mar 19, 2015 at 08:23:58AM +0100, Stephan Mueller wrote:
>
> How can you distinguish between calls coming from crypto_*_spawn (which 
> we need to allow) and calls that come from the normal API calls (which 
> we should block?

crypto_*_spawn should not be the place where you make the call on
whether internals are allowed.  You should put that information
into places such as ablk_init_common or wherever these internals
are allocated.

So in ablk_init_common you would do

	cryptd_tfm = cryptd_alloc_ablkcipher(drv_name, CRYPTO_ALG_INTERNAL,
					     CRYPTO_ALG_INTERNAL);

IOW internals are disallowed if you don't specify it in the mask,
but you can get them if you do specify it in the mask (and the
corresponding bit in the type).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
