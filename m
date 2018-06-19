From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH v2 2/2] hwrng: msm - Add support for prng v2
Date: Tue, 19 Jun 2018 18:01:28 +0530
Message-ID: <20180619123128.GD13316@vkoul-mobl>
References: <20180619095430.26358-1-vkoul@kernel.org>
 <20180619095430.26358-3-vkoul@kernel.org>
 <b7543a73-e35a-c015-3bba-1e3ab3a389d5@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b7543a73-e35a-c015-3bba-1e3ab3a389d5@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 19-06-18, 15:11, Stanimir Varbanov wrote:

Hi Stan,

> On 06/19/2018 12:54 PM, Vinod Koul wrote:

> >  	rng->hwrng.name = KBUILD_MODNAME,
> > -	rng->hwrng.init = msm_rng_init,
> > -	rng->hwrng.cleanup = msm_rng_cleanup,
> > -	rng->hwrng.read = msm_rng_read,
> > +	rng->hwrng.read = msm_rng_read;
> > +	skip_init = (unsigned long)of_device_get_match_data(&pdev->dev);
> 
> skip_init is unsigned int, despite I think you don't need to cast it.

This is needed. of_device_get_match_data returns void *, so an explicit
cast is required for integer warning, otherwise it shows up as
-Wint-conversion warning

> >  static const struct of_device_id msm_rng_of_match[] = {
> > -	{ .compatible = "qcom,prng", },
> > +	{ .compatible = "qcom,prng", .data = (void *)0},
> > +	{ .compatible = "qcom,prng-v2", .data = (void *)1},
> 
> No need to cast. IMO it'd be better to create defines for these numbers:

again driver_data is void * and we need a cast

> 
> #define PRNG_V1	0
> #define PRNG_V2	1

That can be done. Since it is more used as flag and not version number
here to skip init, it doesn't really mean versions now

Thanks
-- 
~Vinod
