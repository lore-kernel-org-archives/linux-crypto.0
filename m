Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BC9C41513
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jul 2023 10:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbjG1K0O (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jul 2023 06:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbjG1KZq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2023 06:25:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17C23AAC;
        Fri, 28 Jul 2023 03:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1690539919; x=1722075919;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DXPjYaor5Qf24EOpgH2GGN2yVYXgC8H1FPKyjlWcbio=;
  b=Qt3wI1lM7mFZT6G4dPqkWetFZ1gQiaD7dRiprxcyNQgCNpC0stKKLkNT
   IT0eDHyCav7m37hXpOA6DjYKZ9efbc0gxj7os92tEXosGAMj+vQD+4k8s
   UruL+k5NsJOyj8hTfZrlbHNI7356jVOSEdym63f8DUDR7utbzL+qCF1eQ
   3UkB9+dCwaLMfkP0zj7zClHb8zfR9FCeh04B2EP3/L1mN6AkL7/ZEW06B
   rGPsPqNEmqaMrhMDd1nG0Y4q6lBAycuK9P1plS+5eK91cBzXEZ0SisIae
   61XnTpPErZYQaaueRYtr9GuiOv7f1t6BXaIkd0dpOECVHJxvP56m3Xemn
   g==;
X-IronPort-AV: E=Sophos;i="6.01,237,1684825200"; 
   d="scan'208";a="222728522"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jul 2023 03:24:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Jul 2023 03:24:41 -0700
Received: from che-lt-i67070.amer.actel.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 28 Jul 2023 03:24:36 -0700
From:   Varshini Rajendran <varshini.rajendran@microchip.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <conor+dt@kernel.org>, <nicolas.ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <claudiu.beznea@microchip.com>,
        <tudor.ambarus@linaro.org>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <varshini.rajendran@microchip.com>
Subject: [PATCH v3 10/50] dt-bindings: crypto: add sam9x7 in Atmel SHA
Date:   Fri, 28 Jul 2023 15:54:33 +0530
Message-ID: <20230728102433.265772-1-varshini.rajendran@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add DT bindings for atmel SHA.

Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
---
 .../devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml   | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
index ee2ffb034325..d378c53314dd 100644
--- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
+++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
@@ -12,7 +12,11 @@ maintainers:
 
 properties:
   compatible:
-    const: atmel,at91sam9g46-sha
+    oneOf:
+      - const: atmel,at91sam9g46-sha
+      - items:
+          - const: microchip,sam9x7-sha
+          - const: atmel,at91sam9g46-sha
 
   reg:
     maxItems: 1
-- 
2.25.1

