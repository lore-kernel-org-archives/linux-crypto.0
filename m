From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 17/17] crypto: talitos - Update DT bindings with SEC1
Date: Wed, 4 Mar 2015 03:17:22 +0100
Message-ID: <20150417142411.6BCD31A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch updates the documentation by including SEC1 into SEC2/3 doc

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 Documentation/devicetree/bindings/crypto/fsl-sec2.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec2.txt b/Documentation/devicetree/bindings/crypto/fsl-sec2.txt
index 38988ef..f0d926b 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-sec2.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-sec2.txt
@@ -1,9 +1,11 @@
-Freescale SoC SEC Security Engines versions 2.x-3.x
+Freescale SoC SEC Security Engines versions 1.x-2.x-3.x
 
 Required properties:
 
 - compatible : Should contain entries for this and backward compatible
-  SEC versions, high to low, e.g., "fsl,sec2.1", "fsl,sec2.0"
+  SEC versions, high to low, e.g., "fsl,sec2.1", "fsl,sec2.0" (SEC2/3)
+                             e.g., "fsl,sec1.2", "fsl,sec1.0" (SEC1)
+    warning: SEC1 and SEC2 are mutually exclusive
 - reg : Offset and length of the register set for the device
 - interrupts : the SEC's interrupt number
 - fsl,num-channels : An integer representing the number of channels
-- 
2.1.0
