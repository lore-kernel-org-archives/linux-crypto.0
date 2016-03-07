From: Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Subject: [PATCH v3 1/3] Documentation: devicetree: add Freescale SCC bindings
Date: Mon,  7 Mar 2016 13:00:03 +0100
Message-ID: <1457352005-17457-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	kernel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
To: Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add documentation for the Freescale Security Controller (SCC)
found on i.MX25 SoCs.

Signed-off-by: Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Changes in v2:
  - add clocks to required properties
  - add Acked-by

 .../devicetree/bindings/crypto/fsl-imx-scc.txt      | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt

diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt b/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
new file mode 100644
index 000000000000..7aad448e8a36
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
@@ -0,0 +1,21 @@
+Freescale Security Controller (SCC)
+
+Required properties:
+- compatible : Should be "fsl,imx25-scc".
+- reg : Should contain register location and length.
+- interrupts : Should contain interrupt numbers for SCM IRQ and SMN IRQ.
+- interrupt-names : Should specify the names "scm" and "smn" for the
+		    SCM IRQ and SMN IRQ.
+- clocks: Should contain the clock driving the SCC core.
+- clock-names: Should be set to "ipg".
+
+Example:
+
+	scc: crypto@53fac000 {
+		compatible = "fsl,imx25-scc";
+		reg = <0x53fac000 0x4000>;
+		clocks = <&clks 111>;
+		clock-names = "ipg";
+		interrupts = <49>, <50>;
+		interrupt-names = "scm", "smn";
+	};
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
