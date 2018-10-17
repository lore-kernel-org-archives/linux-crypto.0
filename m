Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45514 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbeJQXOx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 19:14:53 -0400
From: AnilKumar Chimata <anilc@codeaurora.org>
To: andy.gross@linaro.org, david.brown@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc: linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        AnilKumar Chimata <anilc@codeaurora.org>
Subject: [PATCH 2/3] dt-bindings: Add ICE device specific parameters
Date: Wed, 17 Oct 2018 20:47:55 +0530
Message-Id: <1539789476-6098-3-git-send-email-anilc@codeaurora.org>
In-Reply-To: <1539789476-6098-1-git-send-email-anilc@codeaurora.org>
References: <1539789476-6098-1-git-send-email-anilc@codeaurora.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add dt parameters information specific to the Inline
Crypto Engine (ICE) device.

Signed-off-by: AnilKumar Chimata <anilc@codeaurora.org>
---
 .../devicetree/bindings/crypto/msm/ice.txt         | 34 ++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/msm/ice.txt

diff --git a/Documentation/devicetree/bindings/crypto/msm/ice.txt b/Documentation/devicetree/bindings/crypto/msm/ice.txt
new file mode 100644
index 0000000..86eed5e
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/msm/ice.txt
@@ -0,0 +1,34 @@
+* Inline Crypto Engine (ICE)
+
+Required properties:
+  - compatible			: should be "qcom,ice"
+  - reg 			: <register mapping>
+
+Optional properties:
+  - interrupt-names     	: name describing the interrupts for ICE IRQ
+  - interrupts          	: <interrupt mapping for ICE IRQ>
+  - qcom,enable-ice-clk 	: should enable clocks for ICE HW
+  - clocks              	: List of phandle and clock specifier pairs
+  - clock-names         	: List of clock input name strings sorted in the same
+				  order as the clocks property.
+  - qcom,op-freq-hz     	: max clock speed sorted in the same order as the clocks
+				  property.
+  - qcom,instance-type  	: describe the storage type for which ICE node is defined
+				  currently, only "ufs" and "sdcc" are supported storage type
+  - power-domains		: regulator supply to be used by ICE HW
+
+Example:
+	ufs_ice: ufsice@1d90000 {
+		compatible = "qcom,ice";
+		reg = <0x1d90000 0x8000>;
+		qcom,enable-ice-clk;
+		clock-names = "ufs_core_clk", "bus_clk",
+				"iface_clk", "ice_core_clk";
+		clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
+			 <&gcc GCC_UFS_MEM_CLKREF_CLK>,
+			 <&gcc GCC_UFS_PHY_AHB_CLK>,
+			 <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+		qcom,op-freq-hz = <0>, <0>, <0>, <300000000>;
+		power-domains = <&gcc UFS_PHY_GDSC>;
+		qcom,instance-type = "ufs";
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
