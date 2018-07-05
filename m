From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH v4 6/6] crypto: qcom: Add ACPI support
Date: Thu, 5 Jul 2018 11:37:33 +0530
Message-ID: <20180705060733.GH22377@vkoul-mobl>
References: <20180704114427.29953-1-vkoul@kernel.org>
 <20180704114427.29953-7-vkoul@kernel.org>
 <b06a0327-bbfe-5f7c-c0e1-43227ce089ae@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>
To: Timur Tabi <timur@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b06a0327-bbfe-5f7c-c0e1-43227ce089ae@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 04-07-18, 09:46, Timur Tabi wrote:
> On 7/4/18 6:44 AM, Vinod Koul wrote:
> > +	if (has_acpi_companion(&pdev->dev)) {
> > +		rng->skip_init = 1;
> > +	} else {
> > +		rng->clk = devm_clk_get(&pdev->dev, "core");
> > +		if (IS_ERR(rng->clk))
> > +			return PTR_ERR(rng->clk);
> > +
> > +		rng->skip_init =
> > +			(unsigned long)of_device_get_match_data(&pdev->dev);
> > +	}
> 
> There is a device_get_match_data() function, if you want to be consistent
> between ACPI and DT.

Yes we can add driver data in ACPI ID as well so code can be:

        if (!has_acpi_companion(&pdev->dev)) {
                rng->clk = devm_clk_get(&pdev->dev, "core");
                if (IS_ERR(rng->clk))
                        return PTR_ERR(rng->clk);
        }
        rng->skip_init = device_get_match_data(&pdev->dev);

Looks much neater.

I will wait for feedback on other patches before updating this.

Meanwhile any word from testing on ACPI systems?

Thanks
-- 
~Vinod
