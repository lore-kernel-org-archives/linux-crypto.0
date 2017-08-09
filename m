From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: engine - Permit to enqueue skcipher
 request
Date: Wed, 9 Aug 2017 11:40:12 +0200
Message-ID: <20170809094012.GC7137@Red>
References: <20170606134417.18850-1-clabbe.montjoie@gmail.com>
 <20170606134417.18850-3-clabbe.montjoie@gmail.com>
 <20170619052707.GA13180@gondor.apana.org.au>
 <20170619075524.GA27419@Red>
 <20170623064837.GA29139@gondor.apana.org.au>
 <20170714111536.GA30440@Red>
 <20170728135257.GE21401@gondor.apana.org.au>
 <20170728150119.GD7221@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35852 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751932AbdHIJkS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2017 05:40:18 -0400
Content-Disposition: inline
In-Reply-To: <20170728150119.GD7221@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 28, 2017 at 05:01:19PM +0200, Corentin Labbe wrote:
> On Fri, Jul 28, 2017 at 09:52:57PM +0800, Herbert Xu wrote:
> > On Fri, Jul 14, 2017 at 01:15:36PM +0200, Corentin Labbe wrote:
> > > On Fri, Jun 23, 2017 at 02:48:37PM +0800, Herbert Xu wrote:
> > > > On Mon, Jun 19, 2017 at 09:55:24AM +0200, Corentin Labbe wrote:
> > > > >
> > > > > Since there are two different user of "crypto engine + ablkcipher", it will be not easy to convert them in one serie. (I could do it, but I simply could not test it for OMAP (lack of hw))
> > > > > And any new user which want to use crypto engine+skcipher (like me with the sun8i-ce driver) are simply stuck.
> > > > 
> > > > You're right.  We'll need to do this in a backwards-compatible way.  In fact
> > > > we already do something similar in skcipher.c itself.  Simply look at the
> > > > cra_type field and if it matches blkcipher/ablkcipher/givcipher then it's
> > > > legacy ablkcipher, otherwise it's skcipher.
> > > > 
> > > > Also the way crypto_engine looks at the request type in the data-path is
> > > > suboptimal.  This should really be built into the cra_type object.  For
> > > > example, we can have cra_type->engine->prepare_request which would just
> > > > do the right thing.
> > > > 
> > > 
> > > Not sure to have well understand what you want.
> > > You want that I switch on cra_type instead of crypto_tfm_alg_type() ?
> > 
> > No I mean that we should have an engine hooks object registered
> > under cra_type so that you simply call
> > 
> > 	cra_type->engine->prepare_request()
> > 
> > regardless of what type you're using.
> > 
> 
> I am sorry, I didnt see how to do that.

Hello

I really didnt see how to do that since cra_type is const.
Anyway, I think it cannot be possible since we could have two different engine with two different prepare_request().

I will really appreciate any advice on what you want exactly.

Regards
