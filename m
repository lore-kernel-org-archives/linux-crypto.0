From: Jeffrey Hugo <jhugo@codeaurora.org>
Subject: Re: [PATCH v3 6/6] crypto: qcom: Add ACPI support
Date: Tue, 3 Jul 2018 11:08:10 -0600
Message-ID: <28000d33-5321-76af-7985-94a564a75336@codeaurora.org>
References: <20180703060434.19293-1-vkoul@kernel.org>
 <20180703060434.19293-7-vkoul@kernel.org>
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
In-Reply-To: <20180703060434.19293-7-vkoul@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/3/2018 12:04 AM, Vinod Koul wrote:
> From: Timur Tabi <timur@codeaurora.org>
> 
> Add support for probing on ACPI systems, with ACPI HID QCOM8160.
> 
> On ACPI systems, clocks are always enabled, the PRNG should
> already be enabled, and the register region is read-only.
> The driver only verifies that the hardware is already
> enabled never tries to disable or configure it.
> 
> Signed-off-by: Timur Tabi <timur@codeaurora.org>
> [port to crypto API]
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> ---
>   drivers/crypto/qcom-rng.c | 37 +++++++++++++++++++++++++++++++++----
>   1 file changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
> index fdbbcac7bcb8..bc0131d130d6 100644
> --- a/drivers/crypto/qcom-rng.c
> +++ b/drivers/crypto/qcom-rng.c
> @@ -4,6 +4,7 @@
>   // Based on msm-rng.c and downstream driver
>   
>   #include <crypto/internal/rng.h>
> +#include <linux/acpi.h>
>   #include <linux/clk.h>
>   #include <linux/crypto.h>
>   #include <linux/module.h>
> @@ -154,6 +155,7 @@ static int qcom_rng_probe(struct platform_device *pdev)
>   {
>   	struct resource *res;
>   	struct qcom_rng *rng;
> +	u32 val;
>   	int ret;
>   
>   	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
> @@ -168,11 +170,27 @@ static int qcom_rng_probe(struct platform_device *pdev)
>   	if (IS_ERR(rng->base))
>   		return PTR_ERR(rng->base);
>   
> -	rng->clk = devm_clk_get(&pdev->dev, "core");
> -	if (IS_ERR(rng->clk))
> -		return PTR_ERR(rng->clk);
>   
> -	rng->skip_init = (unsigned long)of_device_get_match_data(&pdev->dev);
> +	/*
> +	 * ACPI systems have v2 hardware. The clocks are always enabled,
> +	 * the PRNG register space is read-only and the PRNG should
> +	 * already be enabled.
> +	 */
> +	if (has_acpi_companion(&pdev->dev)) {
> +		val = readl(rng->base + PRNG_CONFIG);
> +		if (!(val & PRNG_CONFIG_HW_ENABLE)) {
> +			dev_err(&pdev->dev, "device is not enabled\n");
> +			return -ENODEV;
> +		}
> +		rng->skip_init = 1;
> +	} else {
> +		rng->clk = devm_clk_get(&pdev->dev, "core");
> +		if (IS_ERR(rng->clk))
> +			return PTR_ERR(rng->clk);
> +
> +		rng->skip_init =
> +			(unsigned long)of_device_get_match_data(&pdev->dev);
> +	}
>   
>   	qcom_rng_dev = rng;
>   	ret = crypto_register_rng(&qcom_rng_alg);
> @@ -193,6 +211,16 @@ static int qcom_rng_remove(struct platform_device *pdev)
>   	return 0;
>   }
>   
> +#if IS_ENABLED(CONFIG_ACPI)
> +static const struct acpi_device_id qcom_rng_acpi_match[] = {
> +	{
> +		.id = "QCOM8160",
> +	},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(acpi, msm_rng_acpi_match);

qcom_rng_acpi_match?
Looks like a copy/paste issue.  This causes a build failure for me.
I'm trying to see if it works otherwise...

> +#endif
> +
>   static const struct of_device_id qcom_rng_of_match[] = {
>   	{ .compatible = "qcom,prng", .data = (void *)0},
>   	{ .compatible = "qcom,prng-ee", .data = (void *)1},
> @@ -206,6 +234,7 @@ static struct platform_driver qcom_rng_driver = {
>   	.driver = {
>   		.name = KBUILD_MODNAME,
>   		.of_match_table = of_match_ptr(qcom_rng_of_match),
> +		.acpi_match_table = ACPI_PTR(qcom_rng_acpi_match),
>   	}
>   };
>   module_platform_driver(qcom_rng_driver);
> 


-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
