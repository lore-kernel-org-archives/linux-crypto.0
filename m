From: Cosar Dindar <cosardindar@gmail.com>
Subject: [RESEND,PATCH v4 2/3] dt-bindings : Document the STM32F4 CRC32 binding
Date: Mon, 17 Jul 2017 11:27:14 +0300
Message-ID: <1500280034-46193-1-git-send-email-cosardindar@gmail.com>
Cc: davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Cosar Dindar <cosardindar@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33597 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751257AbdGQI10 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 04:27:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add device tree binding for STM32F4.

Signed-off-by: Cosar Dindar <cosardindar@gmail.com>
---
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
