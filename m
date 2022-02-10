Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E41C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 16:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243809AbiBJQOK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 11:14:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239586AbiBJQOK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 11:14:10 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55D0137
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 08:14:10 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id m14so10422593wrg.12
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 08:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LPIeJwlMRoaFTb6x9y6uY9bjxgeWFd/hUz/un3WMnt8=;
        b=gqwIkL0ffuvTTfQv7jCOcVX6pKks03HwuOPtAL1P5jX7NNxfBKGgvTvZ0/xRTtS5ol
         caXbL8A0KNI/sET96stGgIQN0DqvcTmc+vbn5wkT4t85r+2Dtg1c+4jwZoHi0oee5r6n
         zFDEO7O9j8eH04R8QyTcqz8yZH/wsaIihQTxvVSGSGYPiIBeUMvTILZra7hoZMwqUdNs
         lgAVHz1VDFu1bvnvUrhixD/wQM00fYsEQd+NcugZKbfmfuuJo5cEYHj7WZpp0QkpL1ZH
         axhda/4ymIDDlZRA6pZ81H1qDw+tCX3rDBAP6d04G0KbuL/+ueHUh5xvPKtDfhs6ebQS
         lG/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LPIeJwlMRoaFTb6x9y6uY9bjxgeWFd/hUz/un3WMnt8=;
        b=dcH8VkmrIJS8xSBJ/98Fw12LpiTr8yuTk7VPgLAabPCG69SWk893AFO9/e7rExGbcx
         lLBBUi/LHJtn0hAu6LjKvBuYVFcOJBxHluTJsjb15zHdbocbBXxS2PFJqFmLlJulg+m2
         peqpNfP+aw1D3uochs0RZdeXkIGS8+Dcl+xtFFalsibLnlYYBe00Os2aO0dPGft4NrCt
         2EB5/NmStlKBfrerbJdUa1+rjgqrNAPUBJEZLOVgg0m9ibJ0cUrxPqVFzO+M2Fyc/eb8
         2NGQCPhXh8OMMpnW8a67/ZzOVRy7wYO03ngdm+AR5Lw9LRvD3SU0kL65AIOgCxqIBUa0
         G+Cg==
X-Gm-Message-State: AOAM533ZihqKxlzkxxnxQfLV09fKlKg4EuNE+3+MawOATaCKX93Ua690
        5sSXYkDjH3FkJc0pCymWDiW+RA==
X-Google-Smtp-Source: ABdhPJyiUzM3gKv/ARPyVBIDz/r78rcok0Pn/FL7DVHv9o7EZbNbxzYFxwKS9f1FNQHLmMhjiiVIsQ==
X-Received: by 2002:a5d:6850:: with SMTP id o16mr6846336wrw.344.1644509649210;
        Thu, 10 Feb 2022 08:14:09 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id e8sm4529430wru.37.2022.02.10.08.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:14:08 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2] dt-bindings: crypto: convert rockchip-crypto to yaml
Date:   Thu, 10 Feb 2022 16:14:03 +0000
Message-Id: <20220210161403.2966196-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert rockchip-crypto to yaml

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
Change since v1:
- fixed example
- renamed to a new name
- fixed some maxItems

 .../crypto/rockchip,rk3288-crypto.yaml        | 66 +++++++++++++++++++
 .../bindings/crypto/rockchip-crypto.txt       | 28 --------
 2 files changed, 66 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
new file mode 100644
index 000000000000..44f415597e32
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
@@ -0,0 +1,66 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/rockchip,rk3288-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Rockchip Electronics And Security Accelerator
+
+maintainers:
+  - Corentin Labbe <clabbe@baylibre.com>
+
+properties:
+  compatible:
+    const: rockchip,rk3288-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: clock data
+      - description: clock data
+      - description: clock crypto accelerator
+      - description: clock dma
+
+  clock-names:
+    items:
+      - const: aclk
+      - const: hclk
+      - const: sclk
+      - const: apb_pclk
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    const: crypto-rst
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
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
+      reset-names = "crypto-rst";
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

