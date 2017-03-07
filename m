From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH] dt-bindings: rng: clocks property on omap_rng is optional
Date: Tue,  7 Mar 2017 15:18:28 +0100
Message-ID: <1488896308-17731-1-git-send-email-thomas.petazzoni@free-electrons.com>
Cc: linux-crypto@vger.kernel.org, romain.perier@collabora.com,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        stable@vger.kernel.org
To: devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>,
        Deepak Saxena <dsaxena@plexity.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Commit 52060836f79 ("dt-bindings: omap-rng: Document SafeXcel IP-76
device variant") update the omap_rng Device Tree binding to add support
for the IP-76 variation of the IP. As part of this change, a "clocks"
property was added, but is indicated as "Required", while it is in fact
"Optional": some SoCs do not require a clock for this IP block.

Fixes: 52060836f79 ("dt-bindings: omap-rng: Document SafeXcel IP-76 device variant")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 Documentation/devicetree/bindings/rng/omap_rng.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/omap_rng.txt b/Documentation/devicetree/bindings/rng/omap_rng.txt
index 4714772..20d435da 100644
--- a/Documentation/devicetree/bindings/rng/omap_rng.txt
+++ b/Documentation/devicetree/bindings/rng/omap_rng.txt
@@ -12,6 +12,9 @@ Required properties:
 - reg : Offset and length of the register set for the module
 - interrupts : the interrupt number for the RNG module.
 		Used for "ti,omap4-rng" and "inside-secure,safexcel-eip76"
+
+Optional properties:
+
 - clocks: the trng clock source
 
 Example:
-- 
2.7.4
