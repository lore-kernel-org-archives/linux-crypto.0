From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG - remove SGL end indicator when chaining
Date: Wed, 20 Sep 2017 15:47:46 +0200
Message-ID: <4784255.BN0h4dhmNf@tauon.chronox.de>
References: <1913314.pET67Fvxje@positron.chronox.de> <20170920083209.GA3395@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170920083209.GA3395@gondor.apana.org.au>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 20. September 2017, 10:32:09 CEST schrieb Herbert Xu:

Hi Herbert,

> 
> Hmm, this patch does not apply against the current tree.  Is this
> a stable-only patch?

This would be a stable-only patch. With the overhauling of the AF_ALG memory 
handling, this is a no-issue any more.

Thanks

Ciao
Stephan
