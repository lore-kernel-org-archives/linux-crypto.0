From: Jonathan Cameron <jonathan.cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 3/3] arm64: dts: hisi: add SEC crypto accelerator nodes for hip07 SoC
Date: Tue, 30 Jan 2018 15:29:53 +0000
Message-ID: <20180130152953.14068-4-jonathan.cameron@huawei.com>
References: <20180130152953.14068-1-jonathan.cameron@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>,
        <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Xiongfeng Wang <xiongfeng.wang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        Jonathan Cameron <Jonathan.Cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
To: <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180130152953.14068-1-jonathan.cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Enable all 4 SEC units available on d05 boards.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 arch/arm64/boot/dts/hisilicon/hip07.dtsi | 293 +++++++++++++++++++++++++++++++
 1 file changed, 293 insertions(+)

diff --git a/arch/arm64/boot/dts/hisilicon/hip07.dtsi b/arch/arm64/boot/dts/hisilicon/hip07.dtsi
index 2c01a21c3665..81b57c8ce720 100644
--- a/arch/arm64/boot/dts/hisilicon/hip07.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hip07.dtsi
@@ -1049,7 +1049,74 @@
 			num-pins = <2>;
 		};
 	};
+	p0_mbigen_alg_a:interrupt-controller@d0080000 {
+		compatible = "hisilicon,mbigen-v2";
+		reg = <0x0 0xd0080000 0x0 0x10000>;
 
+		p0_mbigen_sec_a: intc_sec {
+			msi-parent = <&p0_its_dsa_a 0x40400>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			num-pins = <33>;
+		};
+		p0_mbigen_smmu_alg_a: intc_smmu_alg {
+			msi-parent = <&p0_its_dsa_a 0x40b1b>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			num-pins = <3>;
+		};
+	};
+	p0_mbigen_alg_b:interrupt-controller@8,d0080000 {
+		compatible = "hisilicon,mbigen-v2";
+		reg = <0x8 0xd0080000 0x0 0x10000>;
+
+		p0_mbigen_sec_b: intc_sec {
+			msi-parent = <&p0_its_dsa_b 0x42400>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			num-pins = <33>;
+		};
+		p0_mbigen_smmu_alg_b: intc_smmu_alg {
+			msi-parent = <&p0_its_dsa_b 0x42b1b>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			num-pins = <3>;
+		};
+	};
+	p1_mbigen_alg_a:interrupt-controller@400,d0080000 {
+		compatible = "hisilicon,mbigen-v2";
+		reg = <0x400 0xd0080000 0x0 0x10000>;
+
+		p1_mbigen_sec_a: intc_sec {
+			msi-parent = <&p1_its_dsa_a 0x44400>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			num-pins = <33>;
+		};
+		p1_mbigen_smmu_alg_a: intc_smmu_alg {
+			msi-parent = <&p1_its_dsa_a 0x44b1b>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			num-pins = <3>;
+		};
+	};
+	p1_mbigen_alg_b:interrupt-controller@408,d0080000 {
+		compatible = "hisilicon,mbigen-v2";
+		reg = <0x408 0xd0080000 0x0 0x10000>;
+
+		p1_mbigen_sec_b: intc_sec {
+			msi-parent = <&p1_its_dsa_b 0x46400>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			num-pins = <33>;
+		};
+		p1_mbigen_smmu_alg_b: intc_smmu_alg {
+			msi-parent = <&p1_its_dsa_b 0x46b1b>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			num-pins = <3>;
+		};
+	};
 	p0_mbigen_dsa_a: interrupt-controller@c0080000 {
 		compatible = "hisilicon,mbigen-v2";
 		reg = <0x0 0xc0080000 0x0 0x10000>;
@@ -1083,6 +1150,58 @@
 		};
 	};
 
+	p0_smmu_alg_a: smmu_alg@d0040000 {
+		compatible = "arm,smmu-v3";
+		reg = <0x0 0xd0040000 0x0 0x20000>;
+		interrupt-parent = <&p0_mbigen_smmu_alg_a>;
+		interrupts = <733 1>,
+		<734 1>,
+		<735 1>;
+		interrupt-names = "eventq", "gerror", "priq";
+		#iommu-cells = <1>;
+		dma-coherent;
+		hisilicon,broken-prefetch-cmd;
+		/* smmu-cb-memtype = <0x0 0x1>;*/
+	};
+	p0_smmu_alg_b: smmu_alg@8,d0040000 {
+		compatible = "arm,smmu-v3";
+		reg = <0x8 0xd0040000 0x0 0x20000>;
+		interrupt-parent = <&p0_mbigen_smmu_alg_b>;
+		interrupts = <733 1>,
+		<734 1>,
+		<735 1>;
+		interrupt-names = "eventq", "gerror", "priq";
+		#iommu-cells = <1>;
+		dma-coherent;
+		hisilicon,broken-prefetch-cmd;
+		/* smmu-cb-memtype = <0x0 0x1>;*/
+	};
+	p1_smmu_alg_a: smmu_alg@400,d0040000 {
+		compatible = "arm,smmu-v3";
+		reg = <0x400 0xd0040000 0x0 0x20000>;
+		interrupt-parent = <&p1_mbigen_smmu_alg_a>;
+		interrupts = <733 1>,
+		<734 1>,
+		<735 1>;
+		interrupt-names = "eventq", "gerror", "priq";
+		#iommu-cells = <1>;
+		dma-coherent;
+		hisilicon,broken-prefetch-cmd;
+		/* smmu-cb-memtype = <0x0 0x1>;*/
+	};
+	p1_smmu_alg_b: smmu_alg@408,d0040000 {
+		compatible = "arm,smmu-v3";
+		reg = <0x408 0xd0040000 0x0 0x20000>;
+		interrupt-parent = <&p1_mbigen_smmu_alg_b>;
+		interrupts = <733 1>,
+		<734 1>,
+		<735 1>;
+		interrupt-names = "eventq", "gerror", "priq";
+		#iommu-cells = <1>;
+		dma-coherent;
+		hisilicon,broken-prefetch-cmd;
+		/* smmu-cb-memtype = <0x0 0x1>;*/
+	};
 	soc {
 		compatible = "simple-bus";
 		#address-cells = <2>;
@@ -1166,6 +1285,7 @@
 			reg-names = "ppe-base", "dsaf-base";
 			interrupt-parent = <&mbigen_dsaf0>;
 			subctrl-syscon = <&dsa_subctrl>;
+			/*iommus = <&smmu1 0x0>;*/
 			reset-field-offset = <0>;
 			interrupts =
 			<576 1>, <577 1>, <578 1>, <579 1>, <580 1>,
@@ -1556,5 +1676,178 @@
 					 0x0 0 0 4 &mbigen_pcie2_a 671 4>;
 			status = "disabled";
 		};
+		p0_sec_a: sec@d2000000 {
+			compatible = "hisilicon,hip07-sec";
+			#address-cells = <2>;
+			#size-cells = <2>;
+			reg = <0x0 0xd0000000 0x0 0x10000
+			       0x0 0xd2000000 0x0 0x10000
+			       0x0 0xd2010000 0x0 0x10000
+			       0x0 0xd2020000 0x0 0x10000
+			       0x0 0xd2030000 0x0 0x10000
+			       0x0 0xd2040000 0x0 0x10000
+			       0x0 0xd2050000 0x0 0x10000
+			       0x0 0xd2060000 0x0 0x10000
+			       0x0 0xd2070000 0x0 0x10000
+			       0x0 0xd2080000 0x0 0x10000
+			       0x0 0xd2090000 0x0 0x10000
+			       0x0 0xd20a0000 0x0 0x10000
+			       0x0 0xd20b0000 0x0 0x10000
+			       0x0 0xd20c0000 0x0 0x10000
+			       0x0 0xd20d0000 0x0 0x10000
+			       0x0 0xd20e0000 0x0 0x10000
+			       0x0 0xd20f0000 0x0 0x10000
+			       0x0 0xd2100000 0x0 0x10000>;
+			interrupt-parent = <&p0_mbigen_sec_a>;
+			iommus = <&p0_smmu_alg_a 0x600>;
+			dma-coherent;
+			interrupts = <576 4>,
+				     <577 1>,<578 4>,
+				     <579 1>,<580 4>,
+				     <581 1>,<582 4>,
+				     <583 1>,<584 4>,
+				     <585 1>,<586 4>,
+				     <587 1>,<588 4>,
+				     <589 1>,<590 4>,
+				     <591 1>,<592 4>,
+				     <593 1>,<594 4>,
+				     <595 1>,<596 4>,
+				     <597 1>,<598 4>,
+				     <599 1>,<600 4>,
+				     <601 1>,<602 4>,
+				     <603 1>,<604 4>,
+				     <605 1>,<606 4>,
+				     <607 1>,<608 4>;
+		};
+		p0_sec_b: sec@8,d2000000 {
+			compatible = "hisilicon,hip07-sec";
+			#address-cells = <2>;
+			#size-cells = <2>;
+			reg = <0x8 0xd0000000 0x0 0x10000
+			       0x8 0xd2000000 0x0 0x10000
+			       0x8 0xd2010000 0x0 0x10000
+			       0x8 0xd2020000 0x0 0x10000
+			       0x8 0xd2030000 0x0 0x10000
+			       0x8 0xd2040000 0x0 0x10000
+			       0x8 0xd2050000 0x0 0x10000
+			       0x8 0xd2060000 0x0 0x10000
+			       0x8 0xd2070000 0x0 0x10000
+			       0x8 0xd2080000 0x0 0x10000
+			       0x8 0xd2090000 0x0 0x10000
+			       0x8 0xd20a0000 0x0 0x10000
+			       0x8 0xd20b0000 0x0 0x10000
+			       0x8 0xd20c0000 0x0 0x10000
+			       0x8 0xd20d0000 0x0 0x10000
+			       0x8 0xd20e0000 0x0 0x10000
+			       0x8 0xd20f0000 0x0 0x10000
+			       0x8 0xd2100000 0x0 0x10000>;
+			interrupt-parent = <&p0_mbigen_sec_b>;
+			iommus = <&p0_smmu_alg_b 0x600>;
+			dma-coherent;
+			interrupts = <576 4>,
+				     <577 1>,<578 4>,
+				     <579 1>,<580 4>,
+				     <581 1>,<582 4>,
+				     <583 1>,<584 4>,
+				     <585 1>,<586 4>,
+				     <587 1>,<588 4>,
+				     <589 1>,<590 4>,
+				     <591 1>,<592 4>,
+				     <593 1>,<594 4>,
+				     <595 1>,<596 4>,
+				     <597 1>,<598 4>,
+				     <599 1>,<600 4>,
+				     <601 1>,<602 4>,
+				     <603 1>,<604 4>,
+				     <605 1>,<606 4>,
+				     <607 1>,<608 4>;
+		};
+		p1_sec_a: sec@400,d2000000 {
+			compatible = "hisilicon,hip07-sec";
+			#address-cells = <2>;
+			#size-cells = <2>;
+			reg = <0x400 0xd0000000 0x0 0x10000
+			       0x400 0xd2000000 0x0 0x10000
+			       0x400 0xd2010000 0x0 0x10000
+			       0x400 0xd2020000 0x0 0x10000
+			       0x400 0xd2030000 0x0 0x10000
+			       0x400 0xd2040000 0x0 0x10000
+			       0x400 0xd2050000 0x0 0x10000
+			       0x400 0xd2060000 0x0 0x10000
+			       0x400 0xd2070000 0x0 0x10000
+			       0x400 0xd2080000 0x0 0x10000
+			       0x400 0xd2090000 0x0 0x10000
+			       0x400 0xd20a0000 0x0 0x10000
+			       0x400 0xd20b0000 0x0 0x10000
+			       0x400 0xd20c0000 0x0 0x10000
+			       0x400 0xd20d0000 0x0 0x10000
+			       0x400 0xd20e0000 0x0 0x10000
+			       0x400 0xd20f0000 0x0 0x10000
+			       0x400 0xd2100000 0x0 0x10000>;
+			interrupt-parent = <&p1_mbigen_sec_a>;
+			iommus = <&p1_smmu_alg_a 0x600>;
+			dma-coherent;
+			interrupts = <576 4>,
+				     <577 1>,<578 4>,
+				     <579 1>,<580 4>,
+				     <581 1>,<582 4>,
+				     <583 1>,<584 4>,
+				     <585 1>,<586 4>,
+				     <587 1>,<588 4>,
+				     <589 1>,<590 4>,
+				     <591 1>,<592 4>,
+				     <593 1>,<594 4>,
+				     <595 1>,<596 4>,
+				     <597 1>,<598 4>,
+				     <599 1>,<600 4>,
+				     <601 1>,<602 4>,
+				     <603 1>,<604 4>,
+				     <605 1>,<606 4>,
+				     <607 1>,<608 4>;
+		};
+		p1_sec_b: sec@408,d2000000 {
+			compatible = "hisilicon,hip07-sec";
+			#address-cells = <2>;
+			#size-cells = <2>;
+			reg = <0x408 0xd0000000 0x0 0x10000
+			       0x408 0xd2000000 0x0 0x10000
+			       0x408 0xd2010000 0x0 0x10000
+			       0x408 0xd2020000 0x0 0x10000
+			       0x408 0xd2030000 0x0 0x10000
+			       0x408 0xd2040000 0x0 0x10000
+			       0x408 0xd2050000 0x0 0x10000
+			       0x408 0xd2060000 0x0 0x10000
+			       0x408 0xd2070000 0x0 0x10000
+			       0x408 0xd2080000 0x0 0x10000
+			       0x408 0xd2090000 0x0 0x10000
+			       0x408 0xd20a0000 0x0 0x10000
+			       0x408 0xd20b0000 0x0 0x10000
+			       0x408 0xd20c0000 0x0 0x10000
+			       0x408 0xd20d0000 0x0 0x10000
+			       0x408 0xd20e0000 0x0 0x10000
+			       0x408 0xd20f0000 0x0 0x10000
+			       0x408 0xd2100000 0x0 0x10000>;
+			interrupt-parent = <&p1_mbigen_sec_b>;
+			iommus = <&p1_smmu_alg_b 0x600>;
+			dma-coherent;
+			interrupts = <576 4>,
+				     <577 1>,<578 4>,
+				     <579 1>,<580 4>,
+				     <581 1>,<582 4>,
+				     <583 1>,<584 4>,
+				     <585 1>,<586 4>,
+				     <587 1>,<588 4>,
+				     <589 1>,<590 4>,
+				     <591 1>,<592 4>,
+				     <593 1>,<594 4>,
+				     <595 1>,<596 4>,
+				     <597 1>,<598 4>,
+				     <599 1>,<600 4>,
+				     <601 1>,<602 4>,
+				     <603 1>,<604 4>,
+				     <605 1>,<606 4>,
+				     <607 1>,<608 4>;
+		};
+
 	};
 };
-- 
2.11.0


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
