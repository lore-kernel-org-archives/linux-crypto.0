From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2] crypto: sun4i-ss: support the Security System PRNG
Date: Thu, 8 Dec 2016 10:24:00 +0100
Message-ID: <20161208092400.GA9743@Red>
References: <1480934922-20732-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161205123705.GA10732@gondor.apana.org.au>
 <20161205125738.GA13525@Red>
 <20161207120900.GC20680@gondor.apana.org.au>
 <20161207125127.GB28218@Red>
 <20161208090618.GB22932@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, maxime.ripard@free-electrons.com,
        wens@csie.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161208090618.GB22932@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 08, 2016 at 05:06:18PM +0800, Herbert Xu wrote:
> On Wed, Dec 07, 2016 at 01:51:27PM +0100, Corentin Labbe wrote:
> > 
> > So I must expose it as a crypto_rng ?
> 
> If it is to be exposed at all then algif_rng would be the best
> place.
> 

I have badly said my question.
So I need to use the HW PRNG in a crypto_rng "provider" that could be thereafter used from user space via algif_rng. right ?

> > Could you explain why PRNG must not be used as hw_random ?
> 
> The hwrng interface was always meant to be an interface for real
> hardware random number generators.  People rely on that so we
> should not provide bogus entropy sources through this interface.
> 

Why not adding a KCONFIG HW_RANDOM_ACCEPT_ALSO_PRNG with big warning ?
Or a HW_PRNG Kconfig which do the same than hwrandom with /dev/prng ?
With that it will be much easier to convert in-tree PRNG that you want to remove.

Regards
Corentin Labbe
