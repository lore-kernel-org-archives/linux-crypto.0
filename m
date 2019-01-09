Return-Path: <SRS0=1Gsi=PR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr720089.outbound.protection.outlook.com ([40.107.72.89]:30752
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730112AbfAIJ0q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Jan 2019 04:26:46 -0500
From: Kalyani Akula <kalyani.akula@xilinx.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kalyani Akula <kalyania@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [RFC PATCH V2 1/4] dt-bindings: crypto: Add bindings for ZynqMP SHA3 driver
Date: Wed, 9 Jan 2019 14:56:22 +0530
Message-ID: <1547025985-7228-2-git-send-email-kalyani.akula@xilinx.com>
In-Reply-To: <1547025985-7228-1-git-send-email-kalyani.akula@xilinx.com>
References: <1547025985-7228-1-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add documentation to describe Xilinx ZynqMP SHA3 driver
bindings.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 .../devicetree/bindings/crypto/zynqmp-sha.txt      |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/zynqmp-sha.txt

diff --git a/Documentation/devicetree/bindings/crypto/zynqmp-sha.txt b/Documentation/devicetree/bindings/crypto/zynqmp-sha.txt
new file mode 100644
index 0000000..c7be6e2
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/zynqmp-sha.txt
@@ -0,0 +1,12 @@
+Xilinx ZynqMP SHA3(keccak-384) hw acceleration support.
+
+The ZynqMp PS-SHA hw accelerator is used to calculate the
+SHA3(keccak-384) hash value on the given user data.
+
+Required properties:
+- compatible:	should contain "xlnx,zynqmp-keccak-384"
+
+Example:
+	xlnx_keccak_384: sha384 {
+		compatible = "xlnx,zynqmp-keccak-384";
+	};
-- 
1.7.1
