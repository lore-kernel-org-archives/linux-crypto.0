From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 6/8 v4] ARM: dts: exynos5250/5420: add dt node for sss
 module
Date: Fri, 24 Jan 2014 16:36:33 +0100
Message-ID: <52E28881.5080008@samsung.com>
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
 <1389777397-15193-1-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, tomasz.figa@gmail.com,
	Kukjin Kim <kgene.kim@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1389777397-15193-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Naveen,

On 15.01.2014 10:16, Naveen Krishna Chatradhi wrote:
> This patch adds the device tree node for SSS module
> found on Exynos5420 and Exynos5250
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> TO: <linux-samsung-soc@vger.kernel.org>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: <linux-crypto@vger.kernel.org>
> ---
> Changes since v3:
> 1. Modified the SSS clock ID as per dt-bindings for Exynos5250 in
>     samsung-clk.git tree.
>
>   arch/arm/boot/dts/exynos5250.dtsi |    8 ++++++++
>   arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
>   2 files changed, 18 insertions(+)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
