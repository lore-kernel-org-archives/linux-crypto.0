From: Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: [RFC PATCH 1/3] dt-bindings: Add bindings for Hisilicon SEC crypto accelerators.
Date: Tue, 30 Jan 2018 15:29:51 +0000
Message-ID: <20180130152953.14068-2-jonathan.cameron@huawei.com>
References: <20180130152953.14068-1-jonathan.cameron@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linuxarm@huawei.com>, <xuzaibo@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        <devicetree@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Xiongfeng Wang <xiongfeng.wang@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:58730 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753005AbeA3Pa6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jan 2018 10:30:58 -0500
In-Reply-To: <20180130152953.14068-1-jonathan.cameron@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

The hip06 and hip07 SoCs contain a number of these crypto units which
accelerate AES and DES operations.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 .../bindings/crypto/hisilicon,hip07-sec.txt        | 71 ++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt b/Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt
new file mode 100644
index 000000000000..bf81118e560c
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt
@@ -0,0 +1,71 @@
+* Hisilicon hip07 Security Accelerator (SEC)
+
+Required properties:
+- compatible: Must contain one of
+  - "hisilicon,hip06-sec"
+  - "hisilicon,hip07-sec"
+- #address-cells: Must be <2> as 64 bit addresses in reg.
+- #size-cells: Must be <2> as 64 bit lengths in reg.
+- reg: Memory addresses and lengths of the memory regions used by the driver.
+  Region 0 has registers to control the backend processing engines.
+  Region 1 has registers for functionality common to all queues.
+  Regions 2-18 have registers for the individual queues which are isolated
+  both in hardware and within the driver.
+- interrupts: Interrupt specifiers.
+  Refer to interrupt-controller/interrupts.txt for generic interrupt client node
+  bindings.
+  Interrupt 0 is for the SEC unit error queue.
+  Interrupt 2N + 1 is the completion interrupt for queue N.
+  Interrupt 2N + 2 is the error interrupt for queue N.
+- dma-coherent:  The driver assumes coherent dma is possible.
+
+Optional properties:
+- iommus: The SEC units are behind smmu-v3 iommus.
+  Refer to iommu/arm,smmu-v3.txt for more information.
+
+Example:
+Second socket, first unit chosen to illustrate need for 64 bit addresses.
+
+p1_sec_a: sec@d2000000 {
+	compatible = "hisilicon,hip07-sec";
+	#address-cells = <2>;
+	#size-cells = <2>;
+	reg = <0x400 0xd0000000 0x0 0x10000
+	       0x400 0xd2000000 0x0 0x10000
+	       0x400 0xd2010000 0x0 0x10000
+	       0x400 0xd2020000 0x0 0x10000
+	       0x400 0xd2030000 0x0 0x10000
+	       0x400 0xd2040000 0x0 0x10000
+	       0x400 0xd2050000 0x0 0x10000
+	       0x400 0xd2060000 0x0 0x10000
+	       0x400 0xd2070000 0x0 0x10000
+	       0x400 0xd2080000 0x0 0x10000
+	       0x400 0xd2090000 0x0 0x10000
+	       0x400 0xd20a0000 0x0 0x10000
+	       0x400 0xd20b0000 0x0 0x10000
+	       0x400 0xd20c0000 0x0 0x10000
+	       0x400 0xd20d0000 0x0 0x10000
+	       0x400 0xd20e0000 0x0 0x10000
+	       0x400 0xd20f0000 0x0 0x10000
+	       0x400 0xd2100000 0x0 0x10000>;
+	interrupt-parent = <&p1_mbigen_sec_a>;
+	iommus = <&p1_smmu_alg_a 0x600>;
+	dma-coherent;
+	interrupts = <576 4>,
+		     <577 1>,<578 4>,
+		     <579 1>,<580 4>,
+		     <581 1>,<582 4>,
+		     <583 1>,<584 4>,
+		     <585 1>,<586 4>,
+		     <587 1>,<588 4>,
+		     <589 1>,<590 4>,
+		     <591 1>,<592 4>,
+		     <593 1>,<594 4>,
+		     <595 1>,<596 4>,
+		     <597 1>,<598 4>,
+		     <599 1>,<600 4>,
+		     <601 1>,<602 4>,
+		     <603 1>,<604 4>,
+		     <605 1>,<606 4>,
+		     <607 1>,<608 4>;
+};
-- 
2.11.0
