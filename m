From: Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH v2 1/2] dt-bindings: rng: add bindings doc for Keystone SA HWRNG driver
Date: Tue, 13 Mar 2018 13:33:30 -0400
Message-ID: <1520962411-18208-2-git-send-email-vitalya@ti.com>
References: <1520962411-18208-1-git-send-email-vitalya@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <t-kristo@ti.com>, <vitalya@ti.com>, <m-karicheri2@ti.com>
To: <mpm@selenic.com>, <herbert@gondor.apana.org.au>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <devicetree@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520962411-18208-1-git-send-email-vitalya@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The Keystone SA module has a hardware random generator module.
This commit adds binding doc for the KS2 SA HWRNG driver.

Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/rng/ks-sa-rng.txt | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/ks-sa-rng.txt

diff --git a/Documentation/devicetree/bindings/rng/ks-sa-rng.txt b/Documentation/devicetree/bindings/rng/ks-sa-rng.txt
new file mode 100644
index 0000000..b7a65b4
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/ks-sa-rng.txt
@@ -0,0 +1,21 @@
+Keystone SoC Hardware Random Number Generator(HWRNG) Module
+
+On Keystone SoCs HWRNG module is a submodule of the Security Accelerator.
+
+- compatible: should be "ti,keystone-rng"
+- ti,syscon-sa-cfg: phandle to syscon node of the SA configuration registers.
+		    This registers are shared between hwrng and crypto drivers.
+- clocks: phandle to the reference clocks for the subsystem
+- clock-names: functional clock name. Should be set to "fck"
+- reg: HWRNG module register space
+
+Example:
+/* K2HK */
+
+rng@24000 {
+	compatible = "ti,keystone-rng";
+	ti,syscon-sa-cfg = <&sa_config>;
+	clocks = <&clksa>;
+	clock-names = "fck";
+	reg = <0x24000 0x1000>;
+};
-- 
2.7.4
