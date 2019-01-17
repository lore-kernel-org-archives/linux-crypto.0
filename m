Return-Path: <SRS0=b5ak=PZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr790089.outbound.protection.outlook.com ([40.107.79.89]:4444
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729594AbfAQHCp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 02:02:45 -0500
From: Kalyani Akula <kalyani.akula@xilinx.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kalyani Akula <kalyania@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [RFC PATCH 1/5] dt-bindings: crypto: Add bindings for ZynqMP AES driver
Date: Thu, 17 Jan 2019 12:32:17 +0530
Message-ID: <1547708541-23730-2-git-send-email-kalyani.akula@xilinx.com>
In-Reply-To: <1547708541-23730-1-git-send-email-kalyani.akula@xilinx.com>
References: <1547708541-23730-1-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add documentation to describe Xilinx ZynqMP AES driver
bindings.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt

diff --git a/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt
new file mode 100644
index 0000000..226bfb9
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt
@@ -0,0 +1,12 @@
+Xilinx ZynqMP AES hw acceleration support
+
+The ZynqMP PS-AES hw accelerator is used to encrypt/decrypt
+the given user data.
+
+Required properties:
+- compatible: should contain "xlnx,zynqmp-aes"
+
+Example:
+	zynqmp_aes {
+		compatible = "xlnx,zynqmp-aes";
+	};
-- 
1.9.5
