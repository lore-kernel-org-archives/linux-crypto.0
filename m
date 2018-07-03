From: Timur Tabi <timur@kernel.org>
Subject: Re: [PATCH v3 6/6] crypto: qcom: Add ACPI support
Date: Tue, 3 Jul 2018 09:10:06 -0500
Message-ID: <0d523023-52e8-4154-2e5d-69d54458caa0@kernel.org>
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
        Jeffrey Hugo <jhugo@codeaurora.org>
To: Vinod Koul <vkoul@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703060434.19293-7-vkoul@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/3/18 1:04 AM, Vinod Koul wrote:
> Add support for probing on ACPI systems, with ACPI HID QCOM8160.
> 
> On ACPI systems, clocks are always enabled, the PRNG should
> already be enabled, and the register region is read-only.
> The driver only verifies that the hardware is already
> enabled never tries to disable or configure it.
> 
> Signed-off-by: Timur Tabi<timur@codeaurora.org>
> [port to crypto API]
> Signed-off-by: Vinod Koul<vkoul@kernel.org>

I've asked a colleague who still works at Qualcomm to test this code on 
silicon.  It looks okay, but I just want to be sure.

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

I'm having second thoughts about this PRNG_CONFIG_HW_ENABLE check.  The 
PRNG on the QDF2400 is the same as the one on the 8996, so it should 
have the same register interface.  Currently, the ACPI table points to a 
full PRNG register block, but I'm beginning to believe that it should 
instead point to a "reduced" block that doesn't have a PRNG_CONFIG register.
