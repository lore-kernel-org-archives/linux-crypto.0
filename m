From: Naveen Krishna Ch <ch.naveen@samsung.com>
Subject: [PATCH 5/5] ARM: exynos5420: add dt node for sss module
Date: Tue, 07 Jan 2014 17:21:49 +0530
Message-ID: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:21919 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaAGLvo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jan 2014 06:51:44 -0500
In-reply-to: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

this patch adds the device tree nodes for SSS module found on Exynos5420

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
TO: <linux-samsung-soc@vger.kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-crypto@vger.kernel.org>
---
 arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 11dd202..97045f9 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -652,4 +652,14 @@
 		clocks = <&clock 319>, <&clock 318>;
 		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
 	};
+
+	sss: sss {
+		compatible = "samsung,exynos-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 471>;
+		clock-names = "secss";
+		samsung,power-domain = <&g2d_pd>;
+	};
+
 };
-- 
1.7.9.5
