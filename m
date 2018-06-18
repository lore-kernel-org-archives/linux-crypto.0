From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH 1/3] hwrng: msm - Move hwrng to a table
Date: Mon, 18 Jun 2018 22:24:27 +0530
Message-ID: <20180618165427.GI25852@vkoul-mobl>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-2-vkoul@kernel.org>
 <152933750484.16708.1950713243960317531@swboyd.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: Stephen Boyd <swboyd@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <152933750484.16708.1950713243960317531@swboyd.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 18-06-18, 08:58, Stephen Boyd wrote:
> Quoting Vinod Koul (2018-06-18 07:12:57)
> > @@ -127,6 +125,13 @@ static void msm_rng_cleanup(struct hwrng *hwrng)
> >         msm_rng_enable(hwrng, 0);
> >  }
> >  
> > +static struct hwrng msm_rng = {
> > +       .name = KBUILD_MODNAME,
> > +       .init = msm_rng_init,
> > +       .cleanup = msm_rng_cleanup,
> > +       .read = msm_rng_read,
> > +};
> > +
> >  static int msm_rng_probe(struct platform_device *pdev)
> >  {
> >         struct resource *res;
> > @@ -148,12 +153,10 @@ static int msm_rng_probe(struct platform_device *pdev)
> >         if (IS_ERR(rng->clk))
> >                 return PTR_ERR(rng->clk);
> >  
> > -       rng->hwrng.name = KBUILD_MODNAME,
> > -       rng->hwrng.init = msm_rng_init,
> > -       rng->hwrng.cleanup = msm_rng_cleanup,
> 
> Wouldn't it be a lot easier to skip assigning the init and cleanup
> functions on v2 devices with an if statement? It would be smaller size
> wise too because then we don't have two structs for v1 and v2 hwrngs.
> Plus the patch would be smaller overall because we would do everything
> else pretty much the same besides the if condition in probe.

Yes it would be an alternate approach and would involve lesser code
change.

My personal preference is table based init rather open coding and it
makes adding future revs easier, but said that I can change this...

-- 
~Vinod
