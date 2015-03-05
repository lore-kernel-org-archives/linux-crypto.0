From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 17/17] crypto: talitos - Update DT bindings with SEC1
Date: Thu,  5 Mar 2015 17:46:07 +0100 (CET)
Message-ID: <20150305164607.65D3E1A2422@localhost.localdomain>
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
 Documentation/devicetree/bindings/crypto/fsl-sec2.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec2.txt b/Documentation/devicetree/bindings/crypto/fsl-sec2.txt
index 38988ef..570d6a2 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-sec2.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-sec2.txt
@@ -1,9 +1,10 @@
-Freescale SoC SEC Security Engines versions 2.x-3.x
+Freescale SoC SEC Security Engines versions 1.x-2.x-3.x
 
 Required properties:
 
 - compatible : Should contain entries for this and backward compatible
-  SEC versions, high to low, e.g., "fsl,sec2.1", "fsl,sec2.0"
+  SEC versions, high to low, e.g., "fsl,sec2.1", "fsl,sec2.0" (SEC2/3)
+                             e.g., "fsl,sec1.2", "fsl,sec1.0" (SEC1)
 - reg : Offset and length of the register set for the device
 - interrupts : the SEC's interrupt number
 - fsl,num-channels : An integer representing the number of channels
-- 
2.1.0
