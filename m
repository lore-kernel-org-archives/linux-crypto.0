From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v3 8/8] arm64: dts: marvell: add TRNG description for Armada 8K CP
Date: Fri, 16 Sep 2016 12:08:56 +0200
Message-ID: <20160916100856.31727-9-romain.perier@free-electrons.com>
References: <20160916100856.31727-1-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Romain Perier <romain.perier@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org
To: dsaxena@plexity.net, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:60879 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758324AbcIPKMS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2016 06:12:18 -0400
In-Reply-To: <20160916100856.31727-1-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This commits adds the devicetree description of the SafeXcel IP-76 TRNG
found in the two Armada CP110.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi | 8 ++++++++
 arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi  | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi b/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi
index da31bbb..aaffa24 100644
--- a/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi
@@ -164,6 +164,14 @@
 				clocks = <&cpm_syscon0 1 21>;
 				status = "disabled";
 			};
+
+			cpm_trng: trng@760000 {
+				compatible = "marvell,armada-8k-rng", "inside-secure,safexcel-eip76";
+				reg = <0x760000 0x7d>;
+				interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&cpm_syscon0 1 25>;
+				status = "okay";
+			};
 		};
 
 		cpm_pcie0: pcie@f2600000 {
diff --git a/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi b/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi
index 6ff1201..216de12 100644
--- a/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi
@@ -164,6 +164,14 @@
 				clocks = <&cps_syscon0 1 21>;
 				status = "disabled";
 			};
+
+			cps_trng: trng@760000 {
+				compatible = "marvell,armada-8k-rng", "inside-secure,safexcel-eip76";
+				reg = <0x760000 0x7d>;
+				interrupts = <GIC_SPI 312 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&cps_syscon0 1 25>;
+				status = "okay";
+			};
 		};
 
 		cps_pcie0: pcie@f4600000 {
-- 
2.9.3
