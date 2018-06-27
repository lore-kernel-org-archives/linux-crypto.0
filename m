From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Wed, 27 Jun 2018 08:13:34 +0200
Message-ID: <52764537.cSZCttAJ1I@tauon.chronox.de>
References: <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au> <70ED61EB-BD3E-48D1-8B4D-D7835494C035@chronox.de> <20180627050853.GE22377@vkoul-mobl>
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
In-Reply-To: <20180627050853.GE22377@vkoul-mobl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 27. Juni 2018, 07:08:53 CEST schrieb Vinod:

Hi Vinod,

> Thanks for the pointers, it helped me to test the driver :)
> 
> I have two follow up question on crypto:
> 
>  - If there a way to avoid using a global variable in driver to hold the
>    pointer for driver memory? Looks like exynos driver does that.
> 
>    I understand that the crypto callback don't provide driver context as
>    they copy the data structures passed in registration API, but a simpler
>    way to get driver context would be desirable.

Sure the kernel crypto API can and has to maintain a per-instance data 
structure.

See the crypto/drbg.c for instance.

static int drbg_kcapi_random(struct crypto_rng *tfm,
                             const u8 *src, unsigned int slen,
                             u8 *dst, unsigned int dlen)
{
        struct drbg_state *drbg = crypto_rng_ctx(tfm);

static int drbg_kcapi_seed(struct crypto_rng *tfm,
                           const u8 *seed, unsigned int slen)
{
        struct drbg_state *drbg = crypto_rng_ctx(tfm);

The key is:

        alg->base.cra_ctxsize   = sizeof(struct drbg_state);

during initialization since the kernel crypto API allocates that buffer for 
you and releases it during deallocation.
> 
>  - .seed seems to be mandatory, if I do not set it and even use
>    .seedsize = 0, it panics at crypto_rng_reset(). So is .seed
>    mandatory?

Well, seedsize = 0 just says that the RNG is ready to use after initialization 
(i.e. it does not need to be seeded after initialization).

That does not preclude that a caller wants to reseed.

And yes, .seed must be set.
> 
> Thanks



Ciao
Stephan
