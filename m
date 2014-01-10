From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Subject: [PATCH 5/8 v3] clk:exynos-5250: Add gate clock for SSS module
Date: Fri, 10 Jan 2014 17:13:49 +0530
Message-ID: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, tomasz.figa@gmail.com
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:35685 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaAJLnd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jan 2014 06:43:33 -0500
In-reply-to: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds gating clock for SSS(Security SubSystem)
module on Exynos5250.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v2:
This is a new change to support SSS on Exynos5250

 drivers/clk/samsung/clk-exynos5250.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index adf3234..b47bf0a 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -120,7 +120,7 @@ enum exynos5250_clks {
 	spi2, i2s1, i2s2, pcm1, pcm2, pwm, spdif, ac97, hsi2c0, hsi2c1, hsi2c2,
 	hsi2c3, chipid, sysreg, pmu, cmu_top, cmu_core, cmu_mem, tzpc0, tzpc1,
 	tzpc2, tzpc3, tzpc4, tzpc5, tzpc6, tzpc7, tzpc8, tzpc9, hdmi_cec, mct,
-	wdt, rtc, tmu, fimd1, mie1, dsim0, dp, mixer, hdmi, g2d,
+	wdt, rtc, tmu, fimd1, mie1, dsim0, dp, mixer, hdmi, g2d, sss,
 
 	/* mux clocks */
 	mout_hdmi = 1024,
@@ -492,6 +492,7 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(mixer, "mixer", "mout_aclk200_disp1", GATE_IP_DISP1, 5, 0, 0),
 	GATE(hdmi, "hdmi", "mout_aclk200_disp1", GATE_IP_DISP1, 6, 0, 0),
 	GATE(g2d, "g2d", "aclk200", GATE_IP_ACP, 3, 0, 0),
+	GATE(sss, "sss", "aclk200", GATE_IP_ACP, 2, 0, 0),
 };
 
 static struct samsung_pll_rate_table vpll_24mhz_tbl[] __initdata = {
-- 
1.7.9.5
