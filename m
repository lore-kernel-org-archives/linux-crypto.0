From: Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 3/3] crypto: sahara: Add device tree binding for SAHARA2.
Date: Wed, 27 Feb 2013 11:41:51 +0100
Message-ID: <1361961711-4603-4-git-send-email-javier.martin@vista-silicon.com>
References: <1361961711-4603-1-git-send-email-javier.martin@vista-silicon.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, kernel@pengutronix.de,
	gcembed@gmail.com, shawn.guo@linaro.org, arnd@arndb.de,
	swarren@nvidia.com, Javier Martin <javier.martin@vista-silicon.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1361961711-4603-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 .../devicetree/bindings/crypto/fsl-imx-sahara.txt  |   14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/fsl-imx-sahara.txt

diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.txt b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.txt
new file mode 100644
index 0000000..44abf11
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.txt
@@ -0,0 +1,14 @@
+* Freescale i.MX SAHARA Cryptographic Accelerator
+
+Required properties:
+- compatible : Should be "fsl,<soc>-sahara"
+- reg : Should contain SAHARA registers location and length
+- interrupts : Should contain SAHARA interrupt number
+
+Example:
+
+sah@10025000 {
+	compatible = "fsl,imx27-sahara";
+	reg = <	0x10025000 0x800>;
+	interrupts = <75>;
+};
-- 
1.7.9.5

