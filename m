From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 09/14] Documentation/bindings: crypto: inside-secure: eip197d support
Date: Thu, 28 Jun 2018 17:15:39 +0200
Message-ID: <20180628151544.22134-10-antoine.tenart@bootlin.com>
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

This patch documents the new compatible used for the eip197d engine, as
this new engine is now supported by the Inside Secure SafeXcel
cryptographic driver.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 .../devicetree/bindings/crypto/inside-secure-safexcel.txt      | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
index dc8678db52fa..3bbf144c9988 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
+++ b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
@@ -1,7 +1,8 @@
 Inside Secure SafeXcel cryptographic engine
 
 Required properties:
-- compatible: Should be "inside-secure,safexcel-eip197b" or
+- compatible: Should be "inside-secure,safexcel-eip197b",
+	      "inside-secure,safexcel-eip197d" or
               "inside-secure,safexcel-eip97ies".
 - reg: Base physical address of the engine and length of memory mapped region.
 - interrupts: Interrupt numbers for the rings and engine.
-- 
2.17.1
