Return-Path: <SRS0=Mcmw=PN=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:34523 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfAEMpz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Jan 2019 07:45:55 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 10/16] crypto: keywrap - convert to skcipher API
Date: Sat, 05 Jan 2019 12:40:52 +0100
Message-ID: <4689628.BzlDcjisQ8@tauon.chronox.de>
In-Reply-To: <20190104041625.3259-11-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org> <20190104041625.3259-11-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 4. Januar 2019, 05:16:19 CET schrieb Eric Biggers:

Hi Eric,

> From: Eric Biggers <ebiggers@google.com>
> 
> Convert the keywrap template from the deprecated "blkcipher" API to the
> "skcipher" API, taking advantage of skcipher_alloc_instance_simple() to
> simplify it considerably.
> 
> Cc: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Adding the *_simple functions to the kernel crypto API is really nice to 
reduce code duplication! Thanks a lot.

Also, for this patch:

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan
