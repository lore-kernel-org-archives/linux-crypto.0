From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 8/9] staging: ccree: add DT bindings for Arm CryptoCell
Date: Thu, 20 Apr 2017 16:13:02 +0300
Message-ID: <1492693983-8175-9-git-send-email-gilad@benyossef.com>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, gilad.benyossef@arm.com,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Stuart Yoder <stuart.yoder@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This adds DT bindings for the Arm TrustZone CryptoCell cryptographic
accelerator IP.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 .../devicetree/bindings/crypto/arm-cryptocell.txt  | 27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 drivers/staging/ccree/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt

diff --git a/drivers/staging/ccree/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt b/drivers/staging/ccree/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
new file mode 100644
index 0000000..2ea6517
--- /dev/null
+++ b/drivers/staging/ccree/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
@@ -0,0 +1,27 @@
+Arm TrustZone CryptoCell cryptographic accelerators
+
+Required properties:
+- compatible: must be "arm,cryptocell-712-ree".
+- reg: shall contain base register location and length.
+	Typically length is 0x10000.
+- interrupts: shall contain the interrupt for the device.
+
+Optional properties:
+- interrupt-parent: can designate the interrupt controller the
+	device interrupt is connected to, if needed.
+- clocks: may contain the clock handling the device, if needed.
+- power-domains: may contain a reference to the PM domain, if applicable.
+
+
+Examples:
+
+Zynq FPGA device
+----------------
+
+       arm_cc7x: arm_cc7x@80000000 {
+               compatible = "arm,cryptocell-712-ree";
+               interrupt-parent = <&intc>;
+               interrupts = < 0 30 4 >;
+               reg = < 0x80000000 0x10000 >;
+       };
+
-- 
2.1.4
