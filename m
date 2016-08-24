From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 3/5] hwrng: amd: Be consitent with the driver name
Date: Wed, 24 Aug 2016 15:51:22 +0200
Message-ID: <20160824135122.GC29212@Red>
References: <1471614177-12380-1-git-send-email-clabbe.montjoie@gmail.com>
 <1471614177-12380-3-git-send-email-clabbe.montjoie@gmail.com>
 <20160824105811.GA2120@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160824105811.GA2120@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 24, 2016 at 06:58:11PM +0800, Herbert Xu wrote:
> On Fri, Aug 19, 2016 at 03:42:55PM +0200, LABBE Corentin wrote:
> > The driver name is displayed each time differently.
> > This patch make use of the same name everywhere.
> > 
> > Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> > ---
> >  drivers/char/hw_random/amd-rng.c | 13 ++++++-------
> >  1 file changed, 6 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
> > index d0042f5..d0a806a 100644
> > --- a/drivers/char/hw_random/amd-rng.c
> > +++ b/drivers/char/hw_random/amd-rng.c
> > @@ -31,7 +31,7 @@
> >  #include <linux/delay.h>
> >  #include <asm/io.h>
> >  
> > -#define PFX	KBUILD_MODNAME ": "
> > +#define DRV_NAME "AMD768-HWRNG"
> >  
> >  /*
> >   * Data for PCI driver interface
> > @@ -98,7 +98,7 @@ static void amd_rng_cleanup(struct hwrng *rng)
> >  }
> >  
> >  static struct hwrng amd_rng = {
> > -	.name		= "amd",
> > +	.name		= DRV_NAME,
> 
> Hmm, this changes a sysfs-exported name which has the potential
> to break user-space.  So I think you'd need to a stronger argument
> to do it other than just cleaning it up.
> 

amd is really really too generic.

But if you still NACK that (and I understand perfectly why), I will update my series.

Regards
