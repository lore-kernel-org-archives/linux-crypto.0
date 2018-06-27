From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Wed, 27 Jun 2018 08:43:16 +0200
Message-ID: <170012246.0U45yCEtus@tauon.chronox.de>
References: <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au> <52764537.cSZCttAJ1I@tauon.chronox.de> <20180627062701.GF22377@vkoul-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: Vinod <vkoul@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180627062701.GF22377@vkoul-mobl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 27. Juni 2018, 08:27:01 CEST schrieb Vinod:

Hi Vinod,

> Hi Stephan,
> 
> Thanks for the answers, they are helpful.
> 
> On 27-06-18, 08:13, Stephan Mueller wrote:
> > > I have two follow up question on crypto:
> > >  - If there a way to avoid using a global variable in driver to hold the
> > >  
> > >    pointer for driver memory? Looks like exynos driver does that.
> > >    
> > >    I understand that the crypto callback don't provide driver context as
> > >    they copy the data structures passed in registration API, but a
> > >    simpler
> > >    way to get driver context would be desirable.
> > 
> > Sure the kernel crypto API can and has to maintain a per-instance data
> > structure.
> > 
> > See the crypto/drbg.c for instance.
> > 
> > static int drbg_kcapi_random(struct crypto_rng *tfm,
> > 
> >                              const u8 *src, unsigned int slen,
> >                              u8 *dst, unsigned int dlen)
> > 
> > {
> > 
> >         struct drbg_state *drbg = crypto_rng_ctx(tfm);
> > 
> > static int drbg_kcapi_seed(struct crypto_rng *tfm,
> > 
> >                            const u8 *seed, unsigned int slen)
> > 
> > {
> > 
> >         struct drbg_state *drbg = crypto_rng_ctx(tfm);
> > 
> > The key is:
> >         alg->base.cra_ctxsize   = sizeof(struct drbg_state);
> > 
> > during initialization since the kernel crypto API allocates that buffer
> > for
> > you and releases it during deallocation.
> 
> The difference here is that memory is allocated by crypto and driver has
> no way to pass "it's" own data while doing registration. Ideally
> registration should accept a pointer/long and pass that back on a
> callbacks

Looking at your code, it seems you do what makes sense: there is only one 
instance of the driver, if at all. Thus, having qcom_rng_dev as static makes 
sense. The kernel crypto API allows arbitrary instances of the RNG as well as 
frequent allocations and deallocations. And this is why there must be a 
disconnect between the one hardware-resource driver-instance data structure 
and the (potentially) multiple crypto API RNG instances and their data 
structures.

> 
> Currently am doing bunch of initialization in .probe (platform driver)
> and I think recommendation would be to move that to .cra_init, which seem
> plausible but I don't have pdev to read hw_resource etc.. so would still
> need to get that.

It seems that your allocation during probe relates to the hardware resource 
where you only have one in the system. Thus, doing the allocation here makes 
sense. And, you do not want to perform probe or such resource allocation once 
per crypto API RNG instance allocation. As said, there can be multiple or even 
they can be allocated and deallocated frequently. This in particular applies 
if your driver's "stdrng" has the highest prio which means that it will be 
allocated and deallocated frequently.

Ciao
Stephan
