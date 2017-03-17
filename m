From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH v2] dt-bindings: rng: clocks property on omap_rng not always mandatory
Date: Fri, 17 Mar 2017 13:58:39 +0100
Message-ID: <1489755519-32664-1-git-send-email-thomas.petazzoni@free-electrons.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, romain.perier@collabora.com,
        Nadav Haklai <nadavh@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        stable@vger.kernel.org
To: devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Commit 52060836f79 ("dt-bindings: omap-rng: Document SafeXcel IP-76
device variant") update the omap_rng Device Tree binding to add support
for the IP-76 variation of the IP. As part of this change, a "clocks"
property was added, but is indicated as "Required", without indicated
it's actually only required for some compatible strings.

This commit fixes that, by explicitly stating that the clocks property
is only required with the inside-secure,safexcel-eip76 compatible
string.

Fixes: 52060836f79 ("dt-bindings: omap-rng: Document SafeXcel IP-76 device variant")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
Changes since v1:
 - Instead of indicating the property as optional, indicate it as
   mandatory for the inside-secure,safexcel-eip76 compatible string, as
   suggested by Rob Herring.
---
 Documentation/devicetree/bindings/rng/omap_rng.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/omap_rng.txt b/Documentation/devicetree/bindings/rng/omap_rng.txt
index 4714772..9cf7876 100644
--- a/Documentation/devicetree/bindings/rng/omap_rng.txt
+++ b/Documentation/devicetree/bindings/rng/omap_rng.txt
@@ -12,7 +12,8 @@ Required properties:
 - reg : Offset and length of the register set for the module
 - interrupts : the interrupt number for the RNG module.
 		Used for "ti,omap4-rng" and "inside-secure,safexcel-eip76"
-- clocks: the trng clock source
+- clocks: the trng clock source. Only mandatory for the
+  "inside-secure,safexcel-eip76" compatible.
 
 Example:
 /* AM335x */
-- 
2.7.4
