From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sun4i-ss: support the Security System PRNG
Date: Thu, 22 Jun 2017 07:47:10 +0800
Message-ID: <20170621234710.GA22306@gondor.apana.org.au>
References: <20170620085819.20114-1-clabbe.montjoie@gmail.com>
 <20170620095947.i3r3iym2cxz5jciw@flea.lan>
 <20170620114536.GA4766@Red>
 <20170621064855.z5mu4f3r3dt4kotc@flea.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, davem@davemloft.net,
        wens@csie.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33632 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751689AbdFUXrk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2017 19:47:40 -0400
Content-Disposition: inline
In-Reply-To: <20170621064855.z5mu4f3r3dt4kotc@flea.lan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 21, 2017 at 08:48:55AM +0200, Maxime Ripard wrote:
> On Tue, Jun 20, 2017 at 01:45:36PM +0200, Corentin Labbe wrote:
> > On Tue, Jun 20, 2017 at 11:59:47AM +0200, Maxime Ripard wrote:
> > > Hi,
> > > 
> > > On Tue, Jun 20, 2017 at 10:58:19AM +0200, Corentin Labbe wrote:
> > > > The Security System have a PRNG, this patch add support for it via
> > > > crypto_rng.
> > > 
> > > This might be a dumb question, but is the CRYPTO_RNG code really
> > > supposed to be used with PRNG?
> > > 
> > 
> > Yes, see recently added drivers/crypto/exynos-rng.c
> 
> It's still not really clear from the commit log (if you're talking
> about c46ea13f55b6) why and if using the RNG code for a PRNG is a good
> idea.

The hwrng interface is meant for true hardware RNGs.  The crypto API
rng interface is primarily intended for PRNGs.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
