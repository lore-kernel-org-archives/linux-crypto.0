Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8718FCCA488
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 16:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiGUQcR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 12:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiGUQcQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 12:32:16 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0949789A62
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 09:32:14 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u13so3631028lfn.5
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 09:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+oK+pOh8MGs7bFdJqgWR+kgnOKb6pAhLXHsdjc9P39M=;
        b=jeV22coreGgshD+gkAquxb7fsVo72DB+o/dKajf74blBq9YB1jI8G2Y2ZB46jiDhlh
         OgKUwryyrOPuim6TUIMc1PaoRQm3dZ6VD3Zz3BekL80J9HFLZy9pGf2V9yMM1M2wV0Mm
         kQ5/WBt8kFGAyKSjg99cd9dytVdNLTTbl9SFYJpWmUifgVJ60aocAV0zJYWNwA/+YBlt
         NSK8G8hafDTjjC7VYw+bMzLf8C5Na5B0BnXQ23Gw140mJN5gCLCBGHARM/zpaBL6mxeJ
         kuJkDnJ5QaYXGSqGRirp4uHlRtnbvqh8/f+FAqWyEQUAZx62bM/9OdyLltpBWfSz1LxU
         V3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+oK+pOh8MGs7bFdJqgWR+kgnOKb6pAhLXHsdjc9P39M=;
        b=hgUjCMhKm847GYvTdMCQbYH6xtcJkADOww+FDak35e9CU+i3qU4FliIqLyr00BqDR3
         Uf7CtFNsrQnLgzFu1IrwiVCozUlBH72aJRRBhQuCi7urpR27W7kdOXKOMa/nI5Xx354y
         vqBOxgYimKZKyRwu7caYJPkfny3hQLdFgZvsDn/yzeH/Q8m5Vu18thcrrTdLFCJOCgT+
         4QO626Qsx4UO+AOsGvTrRifX2jayopyuwly032IafcNAzx8xvS4QMRaJGWb2w5hpo0Ij
         jxkG3G89kSgNe5NUM2436mLbgQNrn+E7cF04wckNyM38BQ2Y3MED36j5z88QCnS2aI5q
         Fa1A==
X-Gm-Message-State: AJIora+cOQw0EhixHBQ81VVx5zJ+30P0Z//6A/oMTrhgbwrYvnAxVFuK
        1QklYqOC2AG1SSk9v9yjaKCO7u2sjT3VoA==
X-Google-Smtp-Source: AGRyM1tnVCiYtipecpPF2+nlfxAx4GIakxxmeBxEAhUT2vxG/jCChsvmPA2jWxbrvW3SMCP0Uf4Ahw==
X-Received: by 2002:a05:6512:2611:b0:478:da8f:e2d8 with SMTP id bt17-20020a056512261100b00478da8fe2d8mr21957614lfb.460.1658421132859;
        Thu, 21 Jul 2022 09:32:12 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id b5-20020a056512070500b0047da6e495b1sm536580lfs.4.2022.07.21.09.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 09:32:12 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org,
        Lionel Debieve <lionel.debieve@foss.st.com>
Subject: [PATCH] dt-bindings: crypto: Add ST-Ericsson Ux500 CRYP
Date:   Thu, 21 Jul 2022 18:30:10 +0200
Message-Id: <20220721163010.1060062-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This adds device tree bindings for the Ux500 CRYP block.

This has been used for ages in the kernel device tree for
Ux500 but was never documented, so fill in the gap.

Cc: devicetree@vger.kernel.org
Cc: Lionel Debieve <lionel.debieve@foss.st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
The relationship to the existing STM32 CRYP block is pretty
obvious when looking at the register map. If preferred, I
can just extend the STM32 bindings with these extra
(generic) properties and compatibles as well.
---
 .../crypto/stericsson,ux500-cryp.yaml         | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/stericsson,ux500-cryp.yaml

diff --git a/Documentation/devicetree/bindings/crypto/stericsson,ux500-cryp.yaml b/Documentation/devicetree/bindings/crypto/stericsson,ux500-cryp.yaml
new file mode 100644
index 000000000000..9653776007a0
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/stericsson,ux500-cryp.yaml
@@ -0,0 +1,67 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/stericsson,ux500-cryp.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: ST Microelectronics and ST-Ericsson Ux500 CRYP bindings
+
+description: The Ux500 CRYP block is identical to the one found in
+  STn8820 introduced in 2007. It seems to also be a related ancestor to the
+  STM32 CRYP block.
+
+maintainers:
+  - Linus Walleij <linus.walleij@linaro.org>
+
+properties:
+  compatible:
+    enum:
+      - st,stn8820-cryp
+      - stericsson,ux500-cryp
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  dmas:
+    items:
+      - description: mem2cryp DMA channel
+      - description: cryp2mem DMA channel
+
+  dma-names:
+    items:
+      - const: mem2cryp
+      - const: cryp2mem
+
+  power-domains:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/reset/stericsson,db8500-prcc-reset.h>
+    #include <dt-bindings/arm/ux500_pm_domains.h>
+    cryp@a03cb000 {
+      compatible = "stericsson,ux500-cryp";
+      reg = <0xa03cb000 0x1000>;
+      interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&prcc_pclk 6 2>;
+      power-domains = <&pm_domains DOMAIN_VAPE>;
+    };
-- 
2.36.1

