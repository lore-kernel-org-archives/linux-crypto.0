From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 5/8 v4] clk: samsung: exynos5250/5420: Add gate clock for
 SSS module
Date: Fri, 24 Jan 2014 16:26:38 +0100
Message-ID: <52E2862E.9020402@samsung.com>
References: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
 <1389777366-15147-1-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, tomasz.figa@gmail.com,
	Kukjin Kim <kgene.kim@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <1389777366-15147-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Naveen,

Exynos5250 specific part looks good, but I have a little doubt in case 
of Exynos5420.

On 15.01.2014 10:16, Naveen Krishna Chatradhi wrote:
> This patch adds gating clock for SSS(Security SubSystem)
> module on Exynos5250/5420.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> TO: <linux-samsung-soc@vger.kernel.org>
> TO: Tomasz Figa <t.figa@samsung.com>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: <linux-crypto@vger.kernel.org>
> ---
> Changes since v3:
> 1. Rebased on to https://git.kernel.org/pub/scm/linux/kernel/git/tfiga/samsung-clk.git
> 2. Added new ID for SSS clock on Exynos5250, with Documentation and
> 3. Added gate clocks definitions for SSS on Exynos5420 and Exynos5250
[snip]
> --- a/drivers/clk/samsung/clk-exynos5420.c
> +++ b/drivers/clk/samsung/clk-exynos5420.c
> @@ -26,6 +26,7 @@
>   #define DIV_CPU1		0x504
>   #define GATE_BUS_CPU		0x700
>   #define GATE_SCLK_CPU		0x800
> +#define GATE_BUS_G2D		0x8700
>   #define CPLL_LOCK		0x10020
>   #define DPLL_LOCK		0x10030
>   #define EPLL_LOCK		0x10040
> @@ -702,6 +703,9 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
>   		0),
>   	GATE(CLK_SMMU_MIXER, "smmu_mixer", "aclk200_disp1", GATE_IP_DISP1, 9, 0,
>   		0),
> +
> +	/* SSS */
> +	GATE(CLK_SSS, "sss", "aclk266_g2d", GATE_BUS_G2D, 2, 0, 0),

Isn't there a combined gate for all SSS clocks in one of GATE_IP_* 
registers?

Best regards,
Tomasz
