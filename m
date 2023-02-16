Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AE9C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 13:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjBPNOl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 08:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjBPNOj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 08:14:39 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9796521C2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:36 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id g14so1869839ljh.10
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676553275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rf0VgEByS+dEGqCN3splXKV9KTkduOfaE2qRRkUgcps=;
        b=a5EwyqEypoXTw0DtXn7SVGobLC4ouFyURvHB/FeIeYjNgQvs3S6eP2im2lAlye60tk
         vXU6nnbKAkZkzV+amJUX/YLIvp+0qJU3pWL0/bN3KC7YcdBVoZO+/H/MeDNaVk9Z+ZLA
         jsCx9KYqkOr7/31PpJFLoRAj8rdHiotR2W8oRsYc4nYfYPR5myZcfvjxc6zKqr1LZ3UJ
         MTmxEsTjTQnFbsviZ5/EIeedQ/CZdJKcCywsXormVzDh1JT4wYtybGSlrnys7g/5bkwu
         zAn0J48l+xynWLPmTjTk/ACw+0dOUgyl7I8Ps9tGMn9GIrH+d//H5aPr+S+IiTDd/mkN
         eBRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676553275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rf0VgEByS+dEGqCN3splXKV9KTkduOfaE2qRRkUgcps=;
        b=PaZRFSClgiClDpBxYvbfrN6c3as0D5TRYmBQXMc6d0+Lyqm5lLGcps8+KoSj8BF6Sk
         B5QaMU3MJRdZWD3q4r2HGH4hbwG/pZ75y89dr16jnR7EjjY1XT/IGsol2rEAGJ5HOCeJ
         NOT11SGj3aU39iHKWt7/1afSJYZbTkl4jGgBEPK7GxXzON1z8eKjBQZV4IussaN02S5B
         amaGAzBX7iSgnza8mHAa66pMREwi791EcU7rkeMZ0odUrrPBqPPMjQlQUt+ywlkxlXMo
         uMu16AbedM9a+TFHsgcB4C1Kb8VkxeTls1G6vcPCt+/CpI31QudGt3v/q/+oOOMPWZ2p
         wdPA==
X-Gm-Message-State: AO0yUKXTwA2wy5gMTADJchOpMNH7MBLro3T/L4OqDx/2FRmEX7qrHlTq
        X+hHH57YNUxJBw2GqxUFMRNZmg==
X-Google-Smtp-Source: AK7set/Kcq9tqH/xvtPIGvnFw/bZxGfyZ3RHW3qcWce03bFSZ9SldIJaXKTqjX13WfIeR10UsAL4sA==
X-Received: by 2002:a05:651c:2102:b0:290:733f:169f with SMTP id a2-20020a05651c210200b00290733f169fmr2172347ljq.2.1676553275031;
        Thu, 16 Feb 2023 05:14:35 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id j8-20020a2e8248000000b00293500280e5sm194345ljh.111.2023.02.16.05.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 05:14:34 -0800 (PST)
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Jordan Crouse <jorcrous@amazon.com>
Subject: [PATCH v10 01/10] dt-bindings: qcom-qce: Convert bindings to yaml
Date:   Thu, 16 Feb 2023 15:14:21 +0200
Message-Id: <20230216131430.3107308-2-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
References: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Convert Qualcomm QCE crypto devicetree binding to YAML.

Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Tested-by: Jordan Crouse <jorcrous@amazon.com>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 .../devicetree/bindings/crypto/qcom-qce.txt   | 25 -------
 .../devicetree/bindings/crypto/qcom-qce.yaml  | 67 +++++++++++++++++++
 2 files changed, 67 insertions(+), 25 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.yaml

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.txt b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
deleted file mode 100644
index fdd53b184ba8..000000000000
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.txt
+++ /dev/null
@@ -1,25 +0,0 @@
-Qualcomm crypto engine driver
-
-Required properties:
-
-- compatible  : should be "qcom,crypto-v5.1"
-- reg         : specifies base physical address and size of the registers map
-- clocks      : phandle to clock-controller plus clock-specifier pair
-- clock-names : "iface" clocks register interface
-                "bus" clocks data transfer interface
-                "core" clocks rest of the crypto block
-- dmas        : DMA specifiers for tx and rx dma channels. For more see
-                Documentation/devicetree/bindings/dma/dma.txt
-- dma-names   : DMA request names should be "rx" and "tx"
-
-Example:
-	crypto@fd45a000 {
-		compatible = "qcom,crypto-v5.1";
-		reg = <0xfd45a000 0x6000>;
-		clocks = <&gcc GCC_CE2_AHB_CLK>,
-			 <&gcc GCC_CE2_AXI_CLK>,
-			 <&gcc GCC_CE2_CLK>;
-		clock-names = "iface", "bus", "core";
-		dmas = <&cryptobam 2>, <&cryptobam 3>;
-		dma-names = "rx", "tx";
-	};
diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
new file mode 100644
index 000000000000..8df47e8513b8
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -0,0 +1,67 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/qcom-qce.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm crypto engine driver
+
+maintainers:
+  - Bhupesh Sharma <bhupesh.sharma@linaro.org>
+
+description:
+  This document defines the binding for the QCE crypto
+  controller found on Qualcomm parts.
+
+properties:
+  compatible:
+    const: qcom,crypto-v5.1
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: iface clocks register interface.
+      - description: bus clocks data transfer interface.
+      - description: core clocks rest of the crypto block.
+
+  clock-names:
+    items:
+      - const: iface
+      - const: bus
+      - const: core
+
+  dmas:
+    items:
+      - description: DMA specifiers for rx dma channel.
+      - description: DMA specifiers for tx dma channel.
+
+  dma-names:
+    items:
+      - const: rx
+      - const: tx
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - dmas
+  - dma-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/qcom,gcc-apq8084.h>
+    crypto-engine@fd45a000 {
+        compatible = "qcom,crypto-v5.1";
+        reg = <0xfd45a000 0x6000>;
+        clocks = <&gcc GCC_CE2_AHB_CLK>,
+                 <&gcc GCC_CE2_AXI_CLK>,
+                 <&gcc GCC_CE2_CLK>;
+        clock-names = "iface", "bus", "core";
+        dmas = <&cryptobam 2>, <&cryptobam 3>;
+        dma-names = "rx", "tx";
+    };
-- 
2.33.0

