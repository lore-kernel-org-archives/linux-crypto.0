From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Subject: [PATCH 6/9 v7] ARM: dts: exynos5250/5420: add dt node for sss module
Date: Mon, 17 Feb 2014 15:14:32 +0530
Message-ID: <1392630275-8667-7-git-send-email-ch.naveen@samsung.com>
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, davem@davemloft.net,
	Kukjin Kim <kgene.kim@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds the device tree node for SSS module
found on Exynos5420 and Exynos5250

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
TO: <linux-samsung-soc@vger.kernel.org>
CC: David S. Miller <davem@davemloft.net>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-crypto@vger.kernel.org>
---
Changes since v6:
None

 arch/arm/boot/dts/exynos5250.dtsi |    8 ++++++++
 arch/arm/boot/dts/exynos5420.dtsi |    9 +++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index a76a189..13b748f 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -715,4 +715,12 @@
 		io-channel-ranges;
 		status = "disabled";
 	};
+
+	sss@10830000 {
+		compatible = "samsung,exynos4210-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 348>;
+		clock-names = "secss";
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 9c834cc..b4ce625 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -666,4 +666,13 @@
 		clock-names = "watchdog";
 		samsung,syscon-phandle = <&pmu_system_controller>;
         };
+
+	sss@10830000 {
+		compatible = "samsung,exynos4210-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 471>;
+		clock-names = "secss";
+		samsung,power-domain = <&g2d_pd>;
+	};
 };
-- 
1.7.9.5
