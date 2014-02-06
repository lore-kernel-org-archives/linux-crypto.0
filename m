From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 5/9 v5] clk: samsung exynos5250/5420: Add gate clock for
 SSS module
Date: Thu, 06 Feb 2014 15:43:12 +0100
Message-ID: <52F39F80.1090709@samsung.com>
References: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
 <1390987446-18784-1-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, devicetree@vger.kernel.org,
	Kukjin Kim <kgene.kim@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10091 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaBFOnQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Feb 2014 09:43:16 -0500
In-reply-to: <1390987446-18784-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Naveen,

On 29.01.2014 10:24, Naveen Krishna Chatradhi wrote:
> This patch adds gating clock for SSS(Security SubSystem)
> module on Exynos5250/5420.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> TO: <linux-samsung-soc@vger.kernel.org>
> TO: Tomasz Figa <t.figa@samsung.com>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: <linux-crypto@vger.kernel.org>
> ---
> Changes since v4:
> Use register GATE_IP_G2D instead of GATE_BUS_G2D for Exynos5420
> Changes since v3:
> 1. Rebased on to https://git.kernel.org/pub/scm/linux/kernel/git/tfiga/samsung-clk.git
> 2. Added new ID for SSS clock on Exynos5250, with Documentation and
> 3. Added gate clocks definitions for SSS on Exynos5420 and Exynos5250
>   .../devicetree/bindings/clock/exynos5250-clock.txt |    1 +
>   drivers/clk/samsung/clk-exynos5250.c               |    1 +
>   drivers/clk/samsung/clk-exynos5420.c               |    4 ++++
>   include/dt-bindings/clock/exynos5250.h             |    1 +
>   4 files changed, 7 insertions(+)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
