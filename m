From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: remove instance when test failed
Date: Mon, 6 Apr 2015 12:45:03 +0800
Message-ID: <20150406044503.GA6331@gondor.apana.org.au>
References: <3394653.LODBE1uz62@tachyon.chronox.de>
 <1731327.mgbsjj4MeV@tachyon.chronox.de>
 <20150403155246.GA21458@gondor.apana.org.au>
 <12421064.DcDv9fIrjP@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <12421064.DcDv9fIrjP@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 03, 2015 at 09:29:44PM +0200, Stephan Mueller wrote:
>
> What about moving the current crypto_unregister_instance into 
> __crypto_unregister_instance and creating a new crypto_unregister_instance 
> that takes the ref count and once it got it, it calls 
> __crypto_unregister_instance. If it did not get the ref count, it simply 
> returns because the inst apparently was already removed.
> 
> Only the crypto_unregister_instance is EXPORT_SYMBOL whereas the 
> __crypto_unregister_instance is static.

That's not going to work because you need to grab the reference
count before you release the mutex.  Let me fix up crypto_user first
and then you can use it for your case too (or at least borrow the
idea).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
