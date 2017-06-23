From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH] Documentation/bindings: crypto: remove the dma-mask property
Date: Fri, 23 Jun 2017 16:52:18 +0200
Message-ID: <20170623145218.10795-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, arnd@arndb.de,
        linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:47417 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdFWOxN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 10:53:13 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The dma-mask property is broken and was removed in the device trees
having a safexcel-eip197 node and in the safexcel cryptographic
driver. This patch removes the dma-mask property from the documentation
as well.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
index f69773f4252b..941bb6a6fb13 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
+++ b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
@@ -8,7 +8,6 @@ Required properties:
 
 Optional properties:
 - clocks: Reference to the crypto engine clock.
-- dma-mask: The address mask limitation. Defaults to 64.
 
 Example:
 
@@ -24,6 +23,5 @@ Example:
 		interrupt-names = "mem", "ring0", "ring1", "ring2", "ring3",
 				  "eip";
 		clocks = <&cpm_syscon0 1 26>;
-		dma-mask = <0xff 0xffffffff>;
 		status = "disabled";
 	};
-- 
2.9.4
