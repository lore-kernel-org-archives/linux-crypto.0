From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH v5 3/6] crypto: Add Qcom prng driver
Date: Mon, 16 Jul 2018 09:45:38 +0530
Message-ID: <20180716041538.GZ3219@vkoul-mobl>
References: <20180709061925.20276-1-vkoul@kernel.org>
 <20180709061925.20276-4-vkoul@kernel.org>
 <CACRpkdYk11wNMFFFqbVXgRtPCrvq25MOHDrG_dikCr31oUWyqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>, jhugo@codeaurora.org
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACRpkdYk11wNMFFFqbVXgRtPCrvq25MOHDrG_dikCr31oUWyqA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 14-07-18, 12:16, Linus Walleij wrote:
> On Mon, Jul 9, 2018 at 8:20 AM Vinod Koul <vkoul@kernel.org> wrote:
> 
> > This ports the Qcom prng from older hw_random driver.
> >
> > No change of functionality and move from hw_random to crypto
> > APIs is done.
> >
> > Signed-off-by: Vinod Koul <vkoul@kernel.org>
> 
> FWIW:
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Thanks

> > +config CRYPTO_DEV_QCOM_RNG
> > +       tristate "Qualcomm Randon Number Generator Driver"
> 
> Random speling error.

Will fix, thanks for pointing

> > +#include <linux/of_device.h>
> 
> Do you need this? It seems like a platform device fair and square.

It was required for of_device_get_match_data() but then the change is in
subsequent patch, I should move that

-- 
~Vinod
