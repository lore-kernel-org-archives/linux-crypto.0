Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B250C6379F
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Feb 2023 13:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjBON3h (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Feb 2023 08:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbjBON30 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2023 08:29:26 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45D95580;
        Wed, 15 Feb 2023 05:29:09 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pSHqN-0005qp-0A;
        Wed, 15 Feb 2023 14:29:07 +0100
Date:   Wed, 15 Feb 2023 13:27:30 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     devicetree@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Mingming Su <Mingming.Su@mediatek.com>,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] dt-bindings: rng: Add MediaTek MT7981 TRNG
Message-ID: <c750e786ad0f529d2ae63c8f766d3c294808ff53.1676467500.git.daniel@makrotopia.org>
References: <89865515728cb937b6591160ad9c30b4bcc8dd41.1676467500.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89865515728cb937b6591160ad9c30b4bcc8dd41.1676467500.git.daniel@makrotopia.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add documentation to describe the MediaTek true random number generator
which is provided by ARM TrustedFirmware-A of the MT7981.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 .../bindings/rng/mediatek,mt7981-rng.yaml     | 39 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/mediatek,mt7981-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/mediatek,mt7981-rng.yaml b/Documentation/devicetree/bindings/rng/mediatek,mt7981-rng.yaml
new file mode 100644
index 000000000000..d577d60538d8
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/mediatek,mt7981-rng.yaml
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/mediatek,mt7981-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek Random number generator (v2/SMC)
+
+maintainers:
+  - Daniel Golle <daniel@makrotopia.org>
+
+properties:
+  $nodename:
+    pattern: "^rng$"
+
+  compatible:
+    enum:
+      - mediatek,mt7981-rng
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: rng
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    rng {
+      compatible = "mediatek,mt7981-rng";
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 90d82aba6d73..523f1abf00d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13148,6 +13148,7 @@ F:	drivers/leds/leds-mt6323.c
 MEDIATEK RANDOM NUMBER GENERATOR SUPPORT
 M:	Sean Wang <sean.wang@mediatek.com>
 S:	Maintained
+F:	Documentation/devicetree/bindings/rng/mediatek,*
 F:	drivers/char/hw_random/mtk-rng-v2.c
 F:	drivers/char/hw_random/mtk-rng.c
 
-- 
2.39.1

