From: Cosar Dindar <cosardindar@gmail.com>
Subject: [PATCH v3 1/5] dt-bindings : Document the STM32F4 CRC32 binding
Date: Mon, 22 May 2017 17:34:01 +0300
Message-ID: <289d16be9d88579c5e6ade916d191d9e2f614b9a.1495463449.git.cosardindar@gmail.com>
References: <cover.1495463449.git.cosardindar@gmail.com>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, fabien.dessenne@st.com,
        weiyongjun1@huawei.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Cosar Dindar <cosardindar@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36076 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933917AbdEVOeR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 May 2017 10:34:17 -0400
In-Reply-To: <cover.1495463449.git.cosardindar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add device tree binding for STM32F4.

Signed-off-by: Cosar Dindar <cosardindar@gmail.com>
---
 Documentation/devicetree/bindings/crypto/st,stm32-crc.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
index 3ba92a5..7b30f1e 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
@@ -1,7 +1,7 @@
 * STMicroelectronics STM32 CRC
 
 Required properties:
-- compatible: Should be "st,stm32f7-crc".
+- compatible: Can be either "st,stm32f7-crc" or "st,srm32f4-crc".
 - reg: The address and length of the peripheral registers space
 - clocks: The input clock of the CRC instance
 
@@ -10,7 +10,7 @@ Optional properties: none
 Example:
 
 crc: crc@40023000 {
-	compatible = "st,stm32f7-crc";
+	compatible = "st,stm32f7-crc", "st,stm32f4-crc";
 	reg = <0x40023000 0x400>;
 	clocks = <&rcc 0 12>;
 };
-- 
2.7.4
