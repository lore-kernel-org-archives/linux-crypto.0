From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] crypto: sun4i-ss: support the Security System PRNG
Date: Tue, 20 Jun 2017 13:45:36 +0200
Message-ID: <20170620114536.GA4766@Red>
References: <20170620085819.20114-1-clabbe.montjoie@gmail.com>
 <20170620095947.i3r3iym2cxz5jciw@flea.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, wens@csie.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170620095947.i3r3iym2cxz5jciw@flea.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 20, 2017 at 11:59:47AM +0200, Maxime Ripard wrote:
> Hi,
> 
> On Tue, Jun 20, 2017 at 10:58:19AM +0200, Corentin Labbe wrote:
> > The Security System have a PRNG, this patch add support for it via
> > crypto_rng.
> 
> This might be a dumb question, but is the CRYPTO_RNG code really
> supposed to be used with PRNG?
> 

Yes, see recently added drivers/crypto/exynos-rng.c

[...]
> > --- a/drivers/crypto/sunxi-ss/sun4i-ss.h
> > +++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
> > @@ -32,6 +32,7 @@
> >  #include <crypto/aes.h>
> >  #include <crypto/des.h>
> >  #include <crypto/internal/rng.h>
> > +#include <crypto/rng.h>
> >  
> >  #define SS_CTL            0x00
> >  #define SS_KEY0           0x04
> > @@ -127,6 +128,9 @@
> >  #define SS_RXFIFO_EMP_INT_ENABLE	(1 << 2)
> >  #define SS_TXFIFO_AVA_INT_ENABLE	(1 << 0)
> >  
> > +#define SS_SEED_LEN (192 / 8)
> > +#define SS_DATA_LEN (160 / 8)
> > +
> >  struct sun4i_ss_ctx {
> >  	void __iomem *base;
> >  	int irq;
> > @@ -136,6 +140,7 @@ struct sun4i_ss_ctx {
> >  	struct device *dev;
> >  	struct resource *res;
> >  	spinlock_t slock; /* control the use of the device */
> > +	u32 seed[SS_SEED_LEN / 4];
> 
> Shouldn't you define SS_SEED_LEN in bits, and then use either
> BITS_PER_BYTE and BITS_PER_LONG so that it's obvious what you're doing
> ?
> 
> And you could also make that variable defined based on the option,
> otherwise you'll always allocate that array, even if you're not using
> it.

I will do that

Thanks
