From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 10/12] dt-bindings: rng: Incorporate brcm,bcm6368.txt binding
Date: Tue,  7 Nov 2017 16:44:47 -0800
Message-ID: <20171108004449.32730-11-f.fainelli@gmail.com>
References: <20171108004449.32730-1-f.fainelli@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM
        BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE...),
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-crypto@vger.k
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171108004449.32730-1-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Since the same block is used on BCM2835 and BCM6368, merge the bindings
and remove the brcm,bcm6368.txt binding document.

Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/rng/brcm,bcm2835.txt       | 22 +++++++++++++++++++---
 .../devicetree/bindings/rng/brcm,bcm6368.txt       | 17 -----------------
 2 files changed, 19 insertions(+), 20 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm6368.txt

diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt b/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
index 26542690b578..627b29531a32 100644
--- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
@@ -1,11 +1,19 @@
-BCM2835 Random number generator
+BCM2835/6368 Random number generator
 
 Required properties:
 
-- compatible : should be "brcm,bcm2835-rng"  or "brcm,bcm-nsp-rng" or
-  "brcm,bcm5301x-rng"
+- compatible : should be one of
+	"brcm,bcm2835-rng"
+	"brcm,bcm-nsp-rng"
+	"brcm,bcm5301x-rng" or
+	"brcm,bcm6368-rng"
 - reg : Specifies base physical address and size of the registers.
 
+Optional properties:
+
+- clocks : phandle to clock-controller plus clock-specifier pair
+- clock-names : "ipsec" as a clock name
+
 Example:
 
 rng {
@@ -17,3 +25,11 @@ rng@18033000 {
 	compatible = "brcm,bcm-nsp-rng";
 	reg = <0x18033000 0x14>;
 };
+
+random: rng@10004180 {
+	compatible = "brcm,bcm6368-rng";
+	reg = <0x10004180 0x14>;
+
+	clocks = <&periph_clk 18>;
+	clock-names = "ipsec";
+};
diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm6368.txt b/Documentation/devicetree/bindings/rng/brcm,bcm6368.txt
deleted file mode 100644
index 4b5ac600bfbd..000000000000
--- a/Documentation/devicetree/bindings/rng/brcm,bcm6368.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-BCM6368 Random number generator
-
-Required properties:
-
-- compatible : should be "brcm,bcm6368-rng"
-- reg : Specifies base physical address and size of the registers
-- clocks : phandle to clock-controller plus clock-specifier pair
-- clock-names : "ipsec" as a clock name
-
-Example:
-	random: rng@10004180 {
-		compatible = "brcm,bcm6368-rng";
-		reg = <0x10004180 0x14>;
-
-		clocks = <&periph_clk 18>;
-		clock-names = "ipsec";
-	};
-- 
2.9.3
