From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Fix race around ctx->rcvused by making it
 atomic_t
Date: Fri, 22 Dec 2017 18:57:03 +1100
Message-ID: <20171222075703.GA27971@gondor.apana.org.au>
References: <20171218161045.0000161c@huawei.com>
 <20171222074803.GD27149@gondor.apana.org.au>
 <11744235.QUrfmsyV1D@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto@vger.kernel.org, linuxarm@huawei.com,
        davem@davemloft.net
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46062 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753416AbdLVH5L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 02:57:11 -0500
Content-Disposition: inline
In-Reply-To: <11744235.QUrfmsyV1D@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 22, 2017 at 08:50:01AM +0100, Stephan Mueller wrote:
> Am Freitag, 22. Dezember 2017, 08:48:03 CET schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Tue, Dec 19, 2017 at 10:31:22AM +0000, Jonathan Cameron wrote:
> > > This variable was increased and decreased without any protection.
> > > Result was an occasional misscount and negative wrap around resulting
> > > in false resource allocation failures.
> > > 
> > > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > > Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")
> > 
> > Actually I think it used to be fine because we held the socket
> > lock in the async callback.  It only got broken when we removed
> > the socket lock from the callback.
> 
> But we cannot hold the lock in the async callback since it may be called in 
> interrupt context.

I know.  I'm just saying that the bug was introduced in the commit
that removed the socket lock rather than the commit that introduced
this originally.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
