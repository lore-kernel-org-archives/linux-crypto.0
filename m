From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: sun4i-ss: support the Security System PRNG
Date: Thu, 8 Dec 2016 17:06:18 +0800
Message-ID: <20161208090618.GB22932@gondor.apana.org.au>
References: <1480934922-20732-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161205123705.GA10732@gondor.apana.org.au>
 <20161205125738.GA13525@Red>
 <20161207120900.GC20680@gondor.apana.org.au>
 <20161207125127.GB28218@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, maxime.ripard@free-electrons.com,
        wens@csie.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161207125127.GB28218@Red>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 07, 2016 at 01:51:27PM +0100, Corentin Labbe wrote:
> 
> So I must expose it as a crypto_rng ?

If it is to be exposed at all then algif_rng would be the best
place.

> Could you explain why PRNG must not be used as hw_random ?

The hwrng interface was always meant to be an interface for real
hardware random number generators.  People rely on that so we
should not provide bogus entropy sources through this interface.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
