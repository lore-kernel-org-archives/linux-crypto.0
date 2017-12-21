From: LABBE Corentin <clabbe@baylibre.com>
Subject: Re: [PATCH RFC 1/3] crypto: Prevent to register duplicate
 cra_driver_name
Date: Thu, 21 Dec 2017 21:05:20 +0100
Message-ID: <20171221200520.GB954@Red>
References: <1513800567-12764-1-git-send-email-clabbe@baylibre.com>
 <1513800567-12764-2-git-send-email-clabbe@baylibre.com>
 <20171221063522.GA18211@gondor.apana.org.au>
 <20171221123527.GA17586@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, nhorman@tuxdriver.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171221123527.GA17586@Red>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 21, 2017 at 01:35:27PM +0100, LABBE Corentin wrote:
> On Thu, Dec 21, 2017 at 05:35:22PM +1100, Herbert Xu wrote:
> > On Wed, Dec 20, 2017 at 08:09:25PM +0000, Corentin Labbe wrote:
> > > Each crypto algorithm "cra_name" can have multiple implementation called
> > > "cra_driver_name".
> > > If two different implementation have the same cra_driver_name, nothing
> > > can easily differentiate them.
> > > Furthermore the mechanism for getting a crypto algorithm with its
> > > implementation name (crypto_alg_match() in crypto/crypto_user.c) will
> > > get only the first one found.
> > > 
> > > So this patch prevent the registration of two implementation with the
> > > same cra_driver_name.
> > > 
> > > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > 
> > No this is intentional.  The idea is that you can hot-replace
> > an implementation by registering a new version of it while the
> > old one is still in use.  The new one will be used for all new
> > allocations.
> > 
> 
> But the new implementation is different from the first so should have a new name.
> The only case I found is ctr-aes-ce, and both are different (use/dontuse simd) so qualifying for different name.
> 
> Anyway, any advice on how to populate properly /sys/crypto with unique name ?
> I have two idea:
> - A number which increment after each register
> - cra_driver_name-priority
> 
> Or does I use /sys/crypto/cra_driver_name/priority ? (which need to use some usage count on cra_driver_name node)

I just see that kobject already have reference counting so this solution is the better.

Regards
