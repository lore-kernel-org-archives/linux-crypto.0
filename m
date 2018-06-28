From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 03/14] Documentation/bindings: crypto: inside-secure: update the compatibles
Date: Thu, 28 Jun 2018 17:15:33 +0200
Message-ID: <20180628151544.22134-4-antoine.tenart@bootlin.com>
References: <20180628151544.22134-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, oferh@marvell.com,
        igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        gregory.clement@bootlin.com, andrew@lunn.ch, jason@lakedaemon.net,
        sebastian.hesselbarth@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180628151544.22134-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The compatibles were updated in the Inside Secure SafeXcel cryptographic
driver, as the ones previously used were not specific enough. The old
compatibles are still supported by the driver for backward
compatibility.

This patch updates the documentation accordingly.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 .../bindings/crypto/inside-secure-safexcel.txt     | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
index 5dba55cdfa63..dc8678db52fa 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
+++ b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
@@ -1,8 +1,8 @@
 Inside Secure SafeXcel cryptographic engine
 
 Required properties:
-- compatible: Should be "inside-secure,safexcel-eip197" or
-              "inside-secure,safexcel-eip97".
+- compatible: Should be "inside-secure,safexcel-eip197b" or
+              "inside-secure,safexcel-eip97ies".
 - reg: Base physical address of the engine and length of memory mapped region.
 - interrupts: Interrupt numbers for the rings and engine.
 - interrupt-names: Should be "ring0", "ring1", "ring2", "ring3", "eip", "mem".
@@ -14,10 +14,18 @@ Optional properties:
                name must be "core" for the first clock and "reg" for
                the second one.
 
+Backward compatibility:
+Two compatibles are kept for backward compatibility, but shouldn't be used for
+new submissions:
+- "inside-secure,safexcel-eip197" is equivalent to
+  "inside-secure,safexcel-eip197b".
+- "inside-secure,safexcel-eip97" is equivalent to
+  "inside-secure,safexcel-eip97ies".
+
 Example:
 
 	crypto: crypto@800000 {
-		compatible = "inside-secure,safexcel-eip197";
+		compatible = "inside-secure,safexcel-eip197b";
 		reg = <0x800000 0x200000>;
 		interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.17.1
