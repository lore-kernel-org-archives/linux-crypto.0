Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A68C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Mar 2022 20:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353150AbiCUUKv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Mar 2022 16:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353066AbiCUUJy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Mar 2022 16:09:54 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EA51834D5
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 13:08:07 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j18so12588524wrd.6
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 13:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DGQHyhE/73CNabvymhoJTcg8Bi3arW1cv1zfXXK1DZo=;
        b=aEualytqvjRyUY7VI/hrJxlyktgpE0UuuhEy4bx3ZxwrMAcBa6DMwt3TEwRyup+2mt
         KhzT7uPiMMiOAYaV005/FX1UjV9DZ0fBHg7zMQ8p43h8ICi7NY7H0/fqFPltz5e6uIRZ
         +QvN6PEevUN/jeJC1ptck07oV2uvFzQhDr9+stuGUb22KrtetfQ16eQWk5FtghavQTTf
         hLAY+VoUXR9zHVEGbbLKAFZPOHdd+Jp0NQcKJu3b9AtEwhTRhlCYN53eABSSOYjj6YV4
         jrVa5IaATxWEyIHkMMBIWnbzTgeFQAZs3IP/eXLkiglNZMxUowqcUB6t2L84+3WOHlMf
         aeXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DGQHyhE/73CNabvymhoJTcg8Bi3arW1cv1zfXXK1DZo=;
        b=GtWTWLC9XNLxbQ9ecax5tRrsFVREzQa12Wof3hnptR23uAyuOkxKdMwvS0L68eZcwE
         1ZjlOqyj0Bx3Jz3BInAbkePKHhaNTGapNjiOKhAo2fuIyoI2QrLCyZTce+ocnlsv5LGU
         Qzd7JfvafCjOAxN4gt8xxzHc2XtdWSYCfFngPeaxENKkhkHi8GlRwX9XYDsre+GTvMVM
         wTwzkctU0+ifW2EkQECZExv/+/3+Y85wrO2QwPJMPu8AMGchZ56V9qUy612L4fHqPUoc
         StngjnYG1/blZKX194uXiKPdlx5fEgBnAHdQaREy2ZF+x1J7P4Nc4LM2kV59lbyhcAiC
         5CYw==
X-Gm-Message-State: AOAM531jDnUzf6+lq7ZX74/2PSawlobVgMAqQFeD81TBBHf6Xg/ohpk3
        u+b0A5V6n5pMTv3FkDUNJoqUcw==
X-Google-Smtp-Source: ABdhPJyClWStPMofGThgNOqaGK50UdbzCCGvlkQJgVVh8veL4GE8YXyqpASVm2SkWcM+LzazrquFTA==
X-Received: by 2002:a05:6000:144e:b0:203:e36c:74b3 with SMTP id v14-20020a056000144e00b00203e36c74b3mr20171231wrx.565.1647893285974;
        Mon, 21 Mar 2022 13:08:05 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id i14-20020a0560001ace00b00203da1fa749sm24426988wry.72.2022.03.21.13.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 13:08:05 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 21/26] dt-bindings: crypto: convert rockchip-crypto to yaml
Date:   Mon, 21 Mar 2022 20:07:34 +0000
Message-Id: <20220321200739.3572792-22-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220321200739.3572792-1-clabbe@baylibre.com>
References: <20220321200739.3572792-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert rockchip-crypto to yaml

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../crypto/rockchip,rk3288-crypto.yaml        | 84 +++++++++++++++++++
 .../bindings/crypto/rockchip-crypto.txt       | 28 -------
 2 files changed, 84 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
new file mode 100644
index 000000000000..a6be89a1c890
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
@@ -0,0 +1,84 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/rockchip,rk3288-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Rockchip Electronics And Security Accelerator
+
+maintainers:
+  - Heiko Stuebner <heiko@sntech.de>
+
+properties:
+  compatible:
+    enum:
+      - rockchip,rk3288-crypto
+      - rockchip,rk3328-crypto
+      - rockchip,rk3399-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    minItems: 4
+
+  clock-names:
+    minItems: 4
+
+  resets:
+    maxItems: 1
+
+if:
+  properties:
+    compatible:
+      const: rockchip,rk3399-crypto
+then:
+  properties:
+    reg:
+      minItems: 2
+    interrupts:
+      minItems: 2
+    clocks:
+      minItems: 6
+    clock-names:
+      minItems: 6
+    resets:
+      minItems: 6
+else:
+  if:
+    properties:
+      compatible:
+        const: rockchip,rk3328-crypto
+  then:
+    properties:
+      clocks:
+        minItems: 3
+      clock-names:
+        minItems: 3
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - resets
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/rk3288-cru.h>
+    crypto@ff8a0000 {
+      compatible = "rockchip,rk3288-crypto";
+      reg = <0xff8a0000 0x4000>;
+      interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&cru ACLK_CRYPTO>, <&cru HCLK_CRYPTO>,
+               <&cru SCLK_CRYPTO>, <&cru ACLK_DMAC1>;
+      clock-names = "aclk", "hclk", "sclk", "apb_pclk";
+      resets = <&cru SRST_CRYPTO>;
+    };
diff --git a/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
deleted file mode 100644
index 5e2ba385b8c9..000000000000
--- a/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
+++ /dev/null
@@ -1,28 +0,0 @@
-Rockchip Electronics And Security Accelerator
-
-Required properties:
-- compatible: Should be "rockchip,rk3288-crypto"
-- reg: Base physical address of the engine and length of memory mapped
-       region
-- interrupts: Interrupt number
-- clocks: Reference to the clocks about crypto
-- clock-names: "aclk" used to clock data
-	       "hclk" used to clock data
-	       "sclk" used to clock crypto accelerator
-	       "apb_pclk" used to clock dma
-- resets: Must contain an entry for each entry in reset-names.
-	  See ../reset/reset.txt for details.
-- reset-names: Must include the name "crypto-rst".
-
-Examples:
-
-	crypto: cypto-controller@ff8a0000 {
-		compatible = "rockchip,rk3288-crypto";
-		reg = <0xff8a0000 0x4000>;
-		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&cru ACLK_CRYPTO>, <&cru HCLK_CRYPTO>,
-			 <&cru SCLK_CRYPTO>, <&cru ACLK_DMAC1>;
-		clock-names = "aclk", "hclk", "sclk", "apb_pclk";
-		resets = <&cru SRST_CRYPTO>;
-		reset-names = "crypto-rst";
-	};
-- 
2.34.1

