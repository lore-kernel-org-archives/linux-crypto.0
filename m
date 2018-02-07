From: Artem Savkov <asavkov@redhat.com>
Subject: Re: [PATCH 1/2] sun4i_ss_prng: fix return value of
 sun4i_ss_prng_generate
Date: Wed, 7 Feb 2018 11:52:01 +0100
Message-ID: <20180207105201.pnn2s57wdk5zuda2@shodan.usersys.redhat.com>
References: <20180206212022.1309-1-artem.savkov@gmail.com>
 <20180206212022.1309-2-artem.savkov@gmail.com>
 <20180207095659.GA19249@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Artem Savkov <artem.savkov@gmail.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180207095659.GA19249@Red>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 07, 2018 at 10:56:59AM +0100, Corentin Labbe wrote:
> On Tue, Feb 06, 2018 at 10:20:21PM +0100, Artem Savkov wrote:
> > According to crypto/rng.h generate function should return 0 on success
> > and < 0 on error.
> > 
> > Fixes: b8ae5c7387ad ("crypto: sun4i-ss - support the Security System PRNG")
> > Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
> > ---
> >  drivers/crypto/sunxi-ss/sun4i-ss-prng.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-prng.c b/drivers/crypto/sunxi-ss/sun4i-ss-prng.c
> > index 0d01d1624252..5754e0b92fb0 100644
> > --- a/drivers/crypto/sunxi-ss/sun4i-ss-prng.c
> > +++ b/drivers/crypto/sunxi-ss/sun4i-ss-prng.c
> > @@ -52,5 +52,5 @@ int sun4i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
> >  
> >  	writel(0, ss->base + SS_CTL);
> >  	spin_unlock(&ss->slock);
> > -	return dlen;
> > +	return 0;
> >  }
> > -- 
> > 2.15.1
> > 
> 
> According to Documentation/crypto/api-samples.rst ("Code Example For Random Number Generator Usage")
> you must return the length of data generated.

I don't think that example is the same as rng_alg.generate, it has a
different protottype.

> So crypto_rng_generate/crypto_rng_get_bytes documentation in crypto/rng.h must be fixed.

It's not just documentation, every other rng driver returns it this way
and it gets aead_init_geniv() (and subsequently crypto_create_tfm())
really confused because they expect the return value to be 0 or < 0.

> Herbert could you confirm ?


-- 
Regards,
  Artem
