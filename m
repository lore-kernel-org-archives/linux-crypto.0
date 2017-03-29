From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 4/7] arm64: marvell: dts: add crypto engine description for 7k/8k
Date: Wed, 29 Mar 2017 14:44:29 +0200
Message-ID: <20170329124432.27457-5-antoine.tenart@free-electrons.com>
References: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36280 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932178AbdC2Moo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Mar 2017 08:44:44 -0400
In-Reply-To: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the description of the crypto engine hardware block for the Marvell
Armada 7k and Armada 8k processors; for both the CP110 slave and master.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi | 15 +++++++++++++++
 arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi  | 15 +++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi b/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi
index 9a2ce2ae49cd..7530a1b541c5 100644
--- a/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-cp110-master.dtsi
@@ -210,6 +210,21 @@
 				clocks = <&cpm_syscon0 1 25>;
 				status = "okay";
 			};
+
+			cpm_crypto: crypto@800000 {
+				compatible = "inside-secure,safexcel-eip197";
+				reg = <0x800000 0x200000>;
+				interrupts = <GIC_SPI 34 (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_LEVEL_HIGH)>,
+					     <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "mem", "ring0", "ring1",
+						  "ring2", "ring3", "eip";
+				clocks = <&cpm_syscon0 1 26>;
+				status = "disabled";
+			};
 		};
 
 		cpm_pcie0: pcie@f2600000 {
diff --git a/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi b/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi
index c9dfa244ebb6..6110d39087a6 100644
--- a/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-cp110-slave.dtsi
@@ -210,6 +210,21 @@
 				clocks = <&cps_syscon0 1 25>;
 				status = "okay";
 			};
+
+			cps_crypto: crypto@800000 {
+				compatible = "inside-secure,safexcel-eip197";
+				reg = <0x800000 0x200000>;
+				interrupts = <GIC_SPI 34 (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_LEVEL_HIGH)>,
+					     <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 279 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 280 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 281 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 282 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "mem", "ring0", "ring1",
+						  "ring2", "ring3", "eip";
+				clocks = <&cps_syscon0 1 26>;
+				status = "disabled";
+			};
 		};
 
 		cps_pcie0: pcie@f4600000 {
-- 
2.11.0
