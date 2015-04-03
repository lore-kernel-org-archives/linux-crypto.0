From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: remove instance when test failed
Date: Fri, 3 Apr 2015 23:52:46 +0800
Message-ID: <20150403155246.GA21458@gondor.apana.org.au>
References: <3394653.LODBE1uz62@tachyon.chronox.de>
 <20150403095828.GA19273@gondor.apana.org.au>
 <1731327.mgbsjj4MeV@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1731327.mgbsjj4MeV@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 03, 2015 at 05:17:13PM +0200, Stephan Mueller wrote:
>
> Wpuldn't crypto_del_alg suffer from the same issue? I see that the cra_refcnt 
> is checked. But I guess there would be the same kind of race?

You're quite right.  It too needs to take a ref count on the
algorithm in crypto_alg_match before releasing the mutex.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
