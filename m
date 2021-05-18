Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541CDC433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 11:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3770961285
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 11:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240104AbhERLYc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 07:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233486AbhERLYT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 07:24:19 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0580DC061573
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 04:23:00 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r12so9812186wrp.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 04:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DCCqrr8wK9Z3oX5rCaA/n2nKsKJmS6s8+5KqyY7fBB4=;
        b=ADRUVcjfyh7wZo3ai7Jq+kamkrpn1NhqE2Uw9xnl7FpO6NO3acOJ188VsHlZh4yXed
         aBMn0Mg9z1PGgva7uPUyTXObcFMPAL7XkomDwf1ygn6kCsZ2P/FqRF8QQE9LmKVEebBD
         BWdo60LPPy42Ak5WblviNwa40W0eUHs1VlDY8voDaWXGRP3rVnz68rAY5HfXXeHF97+c
         /hIYla5G5VSW6srZin6MsA4xVbPUY5D+lfKTanbB5tYkHmQq10mdAvHoH6YBefBOoCaX
         1eKuuhHEdjbNcVuoQfAJkPCqwwHlsRi6W+7GPWVjU31bmXaatCxQe5qZmgCRaDwWNZ9h
         lIzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DCCqrr8wK9Z3oX5rCaA/n2nKsKJmS6s8+5KqyY7fBB4=;
        b=Zd6YI6SRpzoNvIWR/ZGe4gNEkXuNyqojZKYqkASxQW/kazRRlz43tZms6FOcTxJpVd
         dtS+a7TY9CkIbtk4B5TWap1Sx0lgNRRt3rb84HYbIVWgup4oP05n4aB3TP3wERWAq+Ex
         7SvWDUbmwVhsUS69Pon+yQ7yY4aPmzwwIYu3TOGahVR+4D5rsyXLKJUPVNtnAn5+ie4Q
         eE43EY237KqFJ+H/nBJJAOoEukietc9oC84iFav2vFeCSqTBXSBqZZp+qxLjv5+tH0cj
         SntMZmEpSqqIhg/tLeAqbMxCo+d3HNlOHI/r4a8DxLXme6sxhBIFzg6av0QN/jRvptKA
         LfAw==
X-Gm-Message-State: AOAM532GZb72UM3p5n74y6l71edfu75F/a2jc9t04Z2Y6Z1oL0xOUg6X
        ERJKaIi2r4dbN7KGpAk3+U1wbQ==
X-Google-Smtp-Source: ABdhPJzWfBKWSIvh12WRInRFuIbcscfo06bwrlqRgQ6iVnYGxH1e0APjYYd/RYQzdnFUMzyG5/s2Zg==
X-Received: by 2002:a5d:45c6:: with SMTP id b6mr6217248wrs.333.1621336978698;
        Tue, 18 May 2021 04:22:58 -0700 (PDT)
Received: from localhost.localdomain ([88.160.162.107])
        by smtp.gmail.com with ESMTPSA id y20sm2881337wmi.0.2021.05.18.04.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 04:22:58 -0700 (PDT)
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
Subject: [PATCH 1/2] dt-bindings: rng: mediatek: convert to yaml schema
Date:   Tue, 18 May 2021 13:22:49 +0200
Message-Id: <20210518112250.2146819-1-fparent@baylibre.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert the RNG binding for MediaTek to use YAML schema.

Signed-off-by: Fabien Parent <fparent@baylibre.com>
---
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
index 000000000000..d9731f0ae47d
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
+  compatible:
+    oneOf:
+      - enum:
+          - mediatek,mt7623-rng
+      - items:
+          - const: mediatek,mt7622-rng
+          - const: mediatek,mt7623-rng
+      - items:
+          - const: mediatek,mt7629-rng
+          - const: mediatek,mt7623-rng
+      - items:
+          - const: mediatek,mt8516-rng
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

