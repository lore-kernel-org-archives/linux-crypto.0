From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH V1 2/3] crypto: ccp - CCP device bindings documentation
Date: Thu, 5 Jun 2014 10:17:50 -0500
Message-ID: <20140605151750.20604.61561.stgit@tlendack-t1.amdoffice.net>
References: <20140605151739.20604.41748.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:25559
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752001AbaFEPR4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jun 2014 11:17:56 -0400
In-Reply-To: <20140605151739.20604.41748.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch provides the documentation of the device bindings
for the AMD Cryptographic Coprocessor driver.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 .../devicetree/bindings/crypto/amd-ccp.txt         |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/amd-ccp.txt

diff --git a/Documentation/devicetree/bindings/crypto/amd-ccp.txt b/Documentation/devicetree/bindings/crypto/amd-ccp.txt
new file mode 100644
index 0000000..6e0b11a
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/amd-ccp.txt
@@ -0,0 +1,16 @@
+* AMD Cryptographic Coprocessor driver (ccp)
+
+Required properties:
+- compatible: Should be "amd,ccp-seattle-v1a"
+- reg: Address and length of the register set for the device
+- interrupt-parent: Should be the phandle for the interrupt controller
+  that services interrupts for this device
+- interrupts: Should contain the CCP interrupt
+
+Example:
+	ccp@e0100000 {
+		compatible = "amd,ccp-seattle-v1a";
+		reg = <0 0xe0100000 0 0x10000>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 3 4>;
+	};
