Return-Path: <SRS0=Oe9a=X2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30AAC352AA
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BAE621855
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NuBENbdQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfJASmq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Oct 2019 14:42:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37629 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfJASly (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Oct 2019 14:41:54 -0400
Received: by mail-wr1-f68.google.com with SMTP id i1so16770840wro.4;
        Tue, 01 Oct 2019 11:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8RScTeZ75nbsv+9yuHpXGe/wKnF3vqAqsp9h8uoT4tg=;
        b=NuBENbdQZE/kGoNM/ITTDYe0seZt25Z/StnqSpTqFTqOJLYyBQPRgFuEQKDx+XwY5L
         7GqQXtj/ljrrOYwr/DkyMdZQVOSZqkhHZJVwoDVwxxYEDziI+ybMoriQ0b6UiYd1wH7P
         cZIJWztP75HNY+1CF8hAOErWwmeU7uxrkrqFomHn7Bq9Be2BUHwF6CshloZturj/8lRa
         QL1/ZYuFm7eYqojQCbVKKMGXZ7jzvlM2AUken0svzCpSooNPO2egcuupUQViLt4obCuq
         /fSOWun8DA2un0vB4yxq2gyFlrEeuE6rSjYUDnj/Lyh8DXxXOvOzqBb4R2Ff02jzqEkm
         zLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8RScTeZ75nbsv+9yuHpXGe/wKnF3vqAqsp9h8uoT4tg=;
        b=pFhaoFz8u2Vnq6SRO8X3hnboqtqetSsZxgBdsA6jW4ds15ho9uXtpwe50RRD7RAVhM
         3KCChdLc4rYG9lZDa8dnQgKIhIZR5RRWAyiTgPJUSQUthkcGLiBTzpNqJJjjjwL4yCSh
         Ne9LOYqMVP3NE22m3tOca/Z+itIjJwiAr3O7Z7tqI2v4nHFiwNnE2/9kyTjruUZyENWw
         PP2MnDHYjBpN5YjcCM/xoLM0woeQ1XygU80UqmtEaurlxE+CCf93Qq68sVuKAO0jIwBp
         eXWb8IsXXrRIe9fUAiFO9ZHwepCotTvYgulFX0bfcXRiAQFwI+JzPYEHnpbz/mh9NglI
         eAeg==
X-Gm-Message-State: APjAAAVuyWWen9tNActXeth7hUulmH42g1XG7P5S+Y4gfH2nLMepHOV3
        qxD2wUPVl4mMWKyjOBnockg=
X-Google-Smtp-Source: APXvYqx5lPO7Frbw7k5tcVmreN/iCtnJ+oksNmprbbANmrVQpyFpzY5b+DiGfDoIO3YAxy9ctRCcLg==
X-Received: by 2002:a05:6000:186:: with SMTP id p6mr17729145wrx.136.1569955312419;
        Tue, 01 Oct 2019 11:41:52 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n8sm6788987wma.7.2019.10.01.11.41.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:41:51 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 03/11] dt-bindings: crypto: Add DT bindings documentation for sun8i-ce Crypto Engine
Date:   Tue,  1 Oct 2019 20:41:33 +0200
Message-Id: <20191001184141.27956-4-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
References: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds documentation for Device-Tree bindings for the
Crypto Engine cryptographic accelerator driver.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 .../bindings/crypto/allwinner,sun8i-ce.yaml   | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
new file mode 100644
index 000000000000..9bd26a2eff33
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
@@ -0,0 +1,92 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/allwinner,sun8i-ce.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Allwinner Crypto Engine driver
+
+maintainers:
+  - Corentin Labbe <clabbe.montjoie@gmail.com>
+
+properties:
+  compatible:
+    enum:
+      - allwinner,sun8i-h3-crypto
+      - allwinner,sun8i-r40-crypto
+      - allwinner,sun50i-a64-crypto
+      - allwinner,sun50i-h5-crypto
+      - allwinner,sun50i-h6-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: Bus clock
+      - description: Module clock
+      - description: MBus clock
+    minItems: 2
+    maxItems: 3
+
+  clock-names:
+    items:
+      - const: bus
+      - const: mod
+      - const: ram
+    minItems: 2
+    maxItems: 3
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    const: bus
+
+if:
+  properties:
+    compatible:
+      items:
+        const: allwinner,sun50i-h6-crypto
+then:
+  properties:
+      clocks:
+        minItems: 3
+      clock-names:
+        minItems: 3
+else:
+  properties:
+      clocks:
+        maxItems: 2
+      clock-names:
+        maxItems: 2
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - resets
+
+additionalProperties: true
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/sun50i-a64-ccu.h>
+    #include <dt-bindings/reset/sun50i-a64-ccu.h>
+
+    crypto: crypto@1c15000 {
+      compatible = "allwinner,sun8i-h3-crypto";
+      reg = <0x01c15000 0x1000>;
+      interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+      clock-names = "bus", "mod";
+      resets = <&ccu RST_BUS_CE>;
+      reset-names = "bus";
+    };
+
-- 
2.21.0

