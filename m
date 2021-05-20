Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A674BC43460
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 12:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BD7F61261
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 12:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhETMXM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 08:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhETMXG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 08:23:06 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D57DC09F5F3
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 04:17:03 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id y184-20020a1ce1c10000b02901769b409001so4989936wmg.3
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 04:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yx+H6sGvKvZ1+h7/FHdbh/ExAGjj5lQ+jgoR4DDOZ70=;
        b=H8QxOOSaBCTdMFu68ay2mgGLL1LN0CBNKCF8GtN/bctB2bS9jC5Y5CEpGVTPCropIE
         K6NQgmolkq35WNpQiS1w+vAuky69CLhY1/L0rQqVYI4jgfK5M77g35On91XRrcQ8FAix
         Bpp2QASmxtI5NZ9Xwss0C9pLRIE40OXwHovZcRcYfhlijfoNu5agaV/cLmttOE89bl/r
         dItwI2J7LYKBwn1OpG0AvsDogWsS4jjq+76V6y0VcZ+5ZIRnAfOke5FFXcdJWsqH2Db9
         v31JDgmD55hfZW3pJLLj8IZzQW8xfN/RhISkSsu95HnxzudVWO04/ADStXPXHQLlt4Do
         qwWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yx+H6sGvKvZ1+h7/FHdbh/ExAGjj5lQ+jgoR4DDOZ70=;
        b=OZomFPfbJH2Va8NW+IOamXOy3Z9H9+3jMsCQgCL2LD9r/DW4rM36xEsPdKnaw1ReY5
         RDJkMr3UAu5F3fbBGwypiZoykstKPcK9XcQvBdsY37dmYcr2T3gUzjZFIVrOOUkwMa+1
         /9/zWpOIr/YeCBEXCCOI1/8CHZsyxtztaji301/pmBcTPgInqMZjkR/AuniSgcp0EgwM
         qizbW5d5fEkulsjZhD6xzf+A4PZYF84kGXn0gDsB8X7pdjun7CJmKO4pOK1zOKq73/rA
         VjIy+nF6/+Nhd6dr5OTNMLQ8grLvU04Yo3rskAYdBWf4UsEoeUhZqcOeTYQkKx9OCnLk
         Sq1w==
X-Gm-Message-State: AOAM530UvSljwarZBruyTXvxaK+tX5raYENv/viKtoBOJZBjZ18YXfft
        GY3Z46EQvu0a08cbYmjmApM4OA==
X-Google-Smtp-Source: ABdhPJyl/rBzjv6gpMQ32Rtdhwde6u6dVWQkPtQQ3xivTTNnE168I4ovRNuIuNkAaXjhralPvS5OPg==
X-Received: by 2002:a05:600c:3553:: with SMTP id i19mr2397972wmq.159.1621509421823;
        Thu, 20 May 2021 04:17:01 -0700 (PDT)
Received: from localhost.localdomain ([88.160.162.107])
        by smtp.gmail.com with ESMTPSA id a19sm2310757wmb.40.2021.05.20.04.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 04:17:01 -0700 (PDT)
From:   Fabien Parent <fparent@baylibre.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     mkorpershoek@baylibre.com, Fabien Parent <fparent@baylibre.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] dt-bindings: rng: mediatek: convert to yaml schema
Date:   Thu, 20 May 2021 13:16:55 +0200
Message-Id: <20210520111656.66017-1-fparent@baylibre.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert the RNG binding for MediaTek to use YAML schema.

Signed-off-by: Fabien Parent <fparent@baylibre.com>
---

v2: Write the compatibles in a more compact way

 .../devicetree/bindings/rng/mtk-rng.txt       | 22 --------
 .../devicetree/bindings/rng/mtk-rng.yaml      | 53 +++++++++++++++++++
 2 files changed, 53 insertions(+), 22 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/mtk-rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/mtk-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.txt b/Documentation/devicetree/bindings/rng/mtk-rng.txt
deleted file mode 100644
index dfdcb5cd2ea8..000000000000
--- a/Documentation/devicetree/bindings/rng/mtk-rng.txt
+++ /dev/null
@@ -1,22 +0,0 @@
-Device-Tree bindings for Mediatek random number generator
-found in MediaTek SoC family
-
-Required properties:
-- compatible	    : Should be
-			"mediatek,mt7622-rng", 	"mediatek,mt7623-rng" : for MT7622
-			"mediatek,mt7629-rng",  "mediatek,mt7623-rng" : for MT7629
-			"mediatek,mt7623-rng" : for MT7623
-			"mediatek,mt8516-rng", "mediatek,mt7623-rng" : for MT8516
-- clocks	    : list of clock specifiers, corresponding to
-		      entries in clock-names property;
-- clock-names	    : Should contain "rng" entries;
-- reg 		    : Specifies base physical address and size of the registers
-
-Example:
-
-rng: rng@1020f000 {
-	compatible = "mediatek,mt7623-rng";
-	reg = <0 0x1020f000 0 0x1000>;
-	clocks = <&infracfg CLK_INFRA_TRNG>;
-	clock-names = "rng";
-};
diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.yaml b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
new file mode 100644
index 000000000000..4be5fc3c1409
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
@@ -0,0 +1,53 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/rng/mtk-rng.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: MediaTek Random number generator
+
+maintainers:
+  - Sean Wang <sean.wang@mediatek.com>
+
+properties:
+  $nodename:
+    pattern: "^rng@[0-9a-f]+$"
+
+  compatible:
+    oneOf:
+      - enum:
+          - mediatek,mt7623-rng
+      - items:
+          - enum:
+              - mediatek,mt7622-rng
+              - mediatek,mt7629-rng
+              - mediatek,mt8516-rng
+          - const: mediatek,mt7623-rng
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
+  - reg
+  - clocks
+  - clock-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/mt2701-clk.h>
+    rng: rng@1020f000 {
+            compatible = "mediatek,mt7623-rng";
+            reg = <0x1020f000 0x1000>;
+            clocks = <&infracfg CLK_INFRA_TRNG>;
+            clock-names = "rng";
+    };
-- 
2.31.1

