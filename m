From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 3/8 v4] crypto:s5p-sss: Add support for SSS module on Exynos
Date: Fri, 24 Jan 2014 15:09:58 +0100
Message-ID: <52E27436.5040908@samsung.com>
References: <1389243569-13161-1-git-send-email-ch.naveen@samsung.com>
 <1389777316-15070-1-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, tomasz.figa@gmail.com,
	"David S. Miller" <davem@davemloft.net>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <1389777316-15070-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Naveen,

On 15.01.2014 10:15, Naveen Krishna Chatradhi wrote:
> This patch adds new compatible and variant struct to support the SSS
> module on Exynos4 (Exynos4210), Exynos5 (Exynos5420 and Exynos5250)
> for which
> 1. AES register are at an offset of 0x200 and
> 2. hash interrupt is not available
[snip]
>   Required properties:
>
>   - compatible : Should contain entries for this and backward compatible
>     SSS versions:
>     - "samsung,s5pv210-secss" for S5PV210 SoC.
> +  - "samsung,exynos4210-secss" for Exynos4210, Exynos4212, Exynos4412, Exynos5250,
> +		Exynos5260 and Exynos5420 SoCs.
>   - reg : Offset and length of the register set for the module
>   - interrupts : the interrupt-specifier for the SSS module.
> -		Two interrupts "feed control and hash" in case of S5PV210
> -- clocks : the required gating clock for the SSS module.
> -- clock-names : the gating clock name to be requested in the SSS driver.
> +		-- Two interrupts "feed control and hash" in case of
> +		   "samsung,s5pv210-secss"
> +		-- One interrupts "feed control" in case of
> +		   "samsung,exynos4210-secss".
> +- clocks : list of clock phandle and specifier pairs for all clocks  listed in
> +		clock-names property.
> +- clock-names : list of device clock input names; should contain one entry
> +		"secss".

Hmm, I guess this is a rebase error, because this should rather be 
squashed with patch 2/8.

Otherwise the patch looks good to me.

Best regards,
Tomasz
