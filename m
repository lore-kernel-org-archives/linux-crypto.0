From: Cosar Dindar <cosardindar@gmail.com>
Subject: [RESEND,PATCH v4 1/5] dt-bindings : Document the STM32F4 CRC32 binding
Date: Thu, 22 Jun 2017 02:14:12 +0300
Message-ID: <1498086852-104737-1-git-send-email-cosardindar@gmail.com>
Cc: davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Cosar Dindar <cosardindar@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33661 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751901AbdFUXOv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2017 19:14:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add device tree binding for STM32F4.

Signed-off-by: Cosar Dindar <cosardindar@gmail.com>
---

 Changes in V4:
	- Edited binding explanations.

 Documentation/devicetree/bindings/crypto/st,stm32-crc.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
index 3ba92a5..1e9af69 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
@@ -1,7 +1,9 @@
 * STMicroelectronics STM32 CRC
 
 Required properties:
-- compatible: Should be "st,stm32f7-crc".
+- compatible: Should be one of the following string.
+	      "st,stm32f7-crc"
+	      "st,stm32f4-crc"
 - reg: The address and length of the peripheral registers space
 - clocks: The input clock of the CRC instance
 
-- 
2.7.4
