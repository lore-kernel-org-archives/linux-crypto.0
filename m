From: Timur Tabi <timur@kernel.org>
Subject: Re: [PATCH v4 6/6] crypto: qcom: Add ACPI support
Date: Wed, 4 Jul 2018 09:46:01 -0500
Message-ID: <b06a0327-bbfe-5f7c-c0e1-43227ce089ae@kernel.org>
References: <20180704114427.29953-1-vkoul@kernel.org>
 <20180704114427.29953-7-vkoul@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>
To: Vinod Koul <vkoul@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180704114427.29953-7-vkoul@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/4/18 6:44 AM, Vinod Koul wrote:
> +	if (has_acpi_companion(&pdev->dev)) {
> +		rng->skip_init = 1;
> +	} else {
> +		rng->clk = devm_clk_get(&pdev->dev, "core");
> +		if (IS_ERR(rng->clk))
> +			return PTR_ERR(rng->clk);
> +
> +		rng->skip_init =
> +			(unsigned long)of_device_get_match_data(&pdev->dev);
> +	}

There is a device_get_match_data() function, if you want to be 
consistent between ACPI and DT.
