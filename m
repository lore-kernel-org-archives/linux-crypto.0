Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E961C0015E
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jul 2023 10:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbjG1K0Q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jul 2023 06:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235836AbjG1KZu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2023 06:25:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5E03ABD;
        Fri, 28 Jul 2023 03:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1690539925; x=1722075925;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0bWiq7B4vJ55DoLBtkBNi4eKcSYsW8jCGPwXuAU6VZs=;
  b=GfsbQC/rz1nEcLGlI3Y4nf/lhInbgJb4UtAwCLDe//cOy/CEtxXSPKLU
   t9nxTr3MSFDMKHzKFsHOpuGpaqlnaDKe9DUlCXFA3ZyOEx4DHHt1PdBon
   NAPfMcMMmKcSA+aveVqjpeSLdRG6Kr7ldRccN9liaSC8D2HeSOP0QXXUG
   roEeyQI+p1ePObwfgt+F/svFwgvOFcBYJP3aCRSe9DtbeIKfak8tSqTc5
   ZoEEUW2PieslaAZ9OMKtdBesh9InGGIpy5mPzDH2j+ZyptuZlxM2OmteA
   Gj7vOBE1419EH9tgEO8CR4HcJaK4Ocqs/jPc7MUoEkbG4SXCqTisHZo0z
   g==;
X-IronPort-AV: E=Sophos;i="6.01,237,1684825200"; 
   d="scan'208";a="226622875"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jul 2023 03:24:52 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Jul 2023 03:24:50 -0700
Received: from che-lt-i67070.amer.actel.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 28 Jul 2023 03:24:45 -0700
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
Subject: [PATCH v3 11/50] dt-bindings: crypto: add sam9x7 in Atmel TDES
Date:   Fri, 28 Jul 2023 15:54:42 +0530
Message-ID: <20230728102442.265820-1-varshini.rajendran@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add DT bindings for atmel TDES.

Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
---
 .../devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml  | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml
index 3d6ed24b1b00..6a441f79efea 100644
--- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml
+++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml
@@ -12,7 +12,11 @@ maintainers:
 
 properties:
   compatible:
-    const: atmel,at91sam9g46-tdes
+    oneOf:
+      - const: atmel,at91sam9g46-tdes
+      - items:
+          - const: microchip,sam9x7-tdes
+          - const: atmel,at91sam9g46-tdes
 
   reg:
     maxItems: 1
-- 
2.25.1

