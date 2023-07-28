Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420ECC41513
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jul 2023 10:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbjG1K3i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jul 2023 06:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbjG1K3N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2023 06:29:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6A84EF4;
        Fri, 28 Jul 2023 03:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1690540094; x=1722076094;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rdI92sqoPeLSTXdYOGgX5TrtLh9Co70Pe8rMuulMOEA=;
  b=XssJloGMqaDvvN0omOgDidoBZ6xWlbOJXly7bAdUugAPzP0o/1Xr7VR+
   Dwdr4VDzvmbP6VdXPm8EgycgrzOWlgnNKem41dZjn/cGvwA8r5IgD45K5
   EeSfV8CKEzrs22XWco6Of4fJ3lQv/Ap54fY8rOrz1SYWV8d1WcCzpolIS
   xc4gke0oh3FPymyFdawtP22ZghOoyRK7q6pIQTO2Q6PFBL0ZilXJdoKJJ
   aSxhEWJQ35aGaOVA0CXXyG6ABetwmjconc9H4BZKdyuHfd3+vLT1egjI1
   kWO9ek4S9t7ow+2PnrPhKR036SUzJyA+UP3YsPpmO7cvkxTzLb13ndaA4
   g==;
X-IronPort-AV: E=Sophos;i="6.01,237,1684825200"; 
   d="scan'208";a="163712703"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jul 2023 03:27:31 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Jul 2023 03:27:09 -0700
Received: from che-lt-i67070.amer.actel.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 28 Jul 2023 03:27:04 -0700
From:   Varshini Rajendran <varshini.rajendran@microchip.com>
To:     <olivia@selenic.com>, <herbert@gondor.apana.org.au>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <conor+dt@kernel.org>, <nicolas.ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <claudiu.beznea@microchip.com>,
        <varshini.rajendran@microchip.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 22/50] dt-bindings: rng: atmel,at91-trng: add sam9x7 TRNG
Date:   Fri, 28 Jul 2023 15:57:01 +0530
Message-ID: <20230728102701.266408-1-varshini.rajendran@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add compatbile for Microchip sam9x7 TRNG.

Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
---
 Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
index 3ce45456d867..b38f8252342e 100644
--- a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
+++ b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
@@ -21,6 +21,10 @@ properties:
           - enum:
               - microchip,sama7g5-trng
           - const: atmel,at91sam9g45-trng
+      - items:
+          - enum:
+              - microchip,sam9x7-trng
+          - const: microchip,sam9x60-trng
 
   clocks:
     maxItems: 1
-- 
2.25.1

