From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: remove instance when test failed
Date: Fri, 03 Apr 2015 21:29:44 +0200
Message-ID: <12421064.DcDv9fIrjP@tachyon.chronox.de>
References: <3394653.LODBE1uz62@tachyon.chronox.de> <1731327.mgbsjj4MeV@tachyon.chronox.de> <20150403155246.GA21458@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58128 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbbDCT3r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Apr 2015 15:29:47 -0400
In-Reply-To: <20150403155246.GA21458@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 3. April 2015, 23:52:46 schrieb Herbert Xu:

Hi Herbert,

> On Fri, Apr 03, 2015 at 05:17:13PM +0200, Stephan Mueller wrote:
> > Wpuldn't crypto_del_alg suffer from the same issue? I see that the
> > cra_refcnt is checked. But I guess there would be the same kind of race?
> 
> You're quite right.  It too needs to take a ref count on the
> algorithm in crypto_alg_match before releasing the mutex.
> 

What about moving the current crypto_unregister_instance into 
__crypto_unregister_instance and creating a new crypto_unregister_instance 
that takes the ref count and once it got it, it calls 
__crypto_unregister_instance. If it did not get the ref count, it simply 
returns because the inst apparently was already removed.

Only the crypto_unregister_instance is EXPORT_SYMBOL whereas the 
__crypto_unregister_instance is static.

> Cheers,


-- 
Ciao
Stephan
