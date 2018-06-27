From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Wed, 27 Jun 2018 11:57:01 +0530
Message-ID: <20180627062701.GF22377@vkoul-mobl>
References: <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
 <70ED61EB-BD3E-48D1-8B4D-D7835494C035@chronox.de>
 <20180627050853.GE22377@vkoul-mobl>
 <52764537.cSZCttAJ1I@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52764537.cSZCttAJ1I@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephan,

Thanks for the answers, they are helpful.

On 27-06-18, 08:13, Stephan Mueller wrote:
> > I have two follow up question on crypto:
> > 
> >  - If there a way to avoid using a global variable in driver to hold the
> >    pointer for driver memory? Looks like exynos driver does that.
> > 
> >    I understand that the crypto callback don't provide driver context as
> >    they copy the data structures passed in registration API, but a simpler
> >    way to get driver context would be desirable.
> 
> Sure the kernel crypto API can and has to maintain a per-instance data 
> structure.
> 
> See the crypto/drbg.c for instance.
> 
> static int drbg_kcapi_random(struct crypto_rng *tfm,
>                              const u8 *src, unsigned int slen,
>                              u8 *dst, unsigned int dlen)
> {
>         struct drbg_state *drbg = crypto_rng_ctx(tfm);
> 
> static int drbg_kcapi_seed(struct crypto_rng *tfm,
>                            const u8 *seed, unsigned int slen)
> {
>         struct drbg_state *drbg = crypto_rng_ctx(tfm);
> 
> The key is:
> 
>         alg->base.cra_ctxsize   = sizeof(struct drbg_state);
> 
> during initialization since the kernel crypto API allocates that buffer for 
> you and releases it during deallocation.

The difference here is that memory is allocated by crypto and driver has
no way to pass "it's" own data while doing registration. Ideally
registration should accept a pointer/long and pass that back on a
callbacks

Currently am doing bunch of initialization in .probe (platform driver)
and I think recommendation would be to move that to .cra_init, which seem
plausible but I don't have pdev to read hw_resource etc.. so would still
need to get that.

FWIW here is the code I wrote:
https://git.linaro.org/people/vinod.koul/kernel.git/commit/?h=topic/rng_v2&id=feb23a41afb0d4cf42a2825b84a43dbc9a49e8b9

-- 
~Vinod
