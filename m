Return-Path: <SRS0=g7fO=NJ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:37784 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729343AbeJ2SiZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Oct 2018 14:38:25 -0400
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Ofir Drang <Ofir.Drang@arm.com>, Yael Chemla <Yael.Chemla@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] dt-bindings: crypto: ccree: add ccree 713
Date: Mon, 29 Oct 2018 09:50:13 +0000
Message-Id: <1540806616-5483-3-git-send-email-gilad@benyossef.com>
In-Reply-To: <1540806616-5483-1-git-send-email-gilad@benyossef.com>
References: <1540806616-5483-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add device tree bindings associating Arm TrustZone CryptoCell 713 with the
ccree driver.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
index 999fb2a..0ac06ec 100644
--- a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
+++ b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
@@ -1,8 +1,11 @@
 Arm TrustZone CryptoCell cryptographic engine
 
 Required properties:
-- compatible: Should be one of: "arm,cryptocell-712-ree",
-  "arm,cryptocell-710-ree" or "arm,cryptocell-630p-ree".
+- compatible: Should be one of -
+   "arm,cryptocell-713-ree"
+   "arm,cryptocell-712-ree"
+   "arm,cryptocell-710-ree"
+   "arm,cryptocell-630p-ree"
 - reg: Base physical address of the engine and length of memory mapped region.
 - interrupts: Interrupt number for the device.
 
-- 
2.7.4
