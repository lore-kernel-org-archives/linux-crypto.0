Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96BFC64EC7
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Feb 2023 18:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjBHSiu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Feb 2023 13:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjBHSiV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2023 13:38:21 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E722F29E29
        for <linux-crypto@vger.kernel.org>; Wed,  8 Feb 2023 10:38:11 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id l14so11819558eds.4
        for <linux-crypto@vger.kernel.org>; Wed, 08 Feb 2023 10:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rf0VgEByS+dEGqCN3splXKV9KTkduOfaE2qRRkUgcps=;
        b=otfIg0lMcA0LiEEexjKctTDxFiwun8LBerKGA2G07WULFCmFiExXjVN36Ni+f1DCAi
         uovh1uNcC+v1RwwFjkokwxalcQ3W9NZLczb8O8uwwzBNT86burdXkGfXtThYQMNWDy7T
         y+DpdwySYoqrG0rymffiV0H3khIY6UFLR/5qO6zdx1gEgHOhWOi12swFUpMBSl+M9k9+
         hatGrfocdXqfAbohZclNnQ94sQqpT6lCIENh9kWsZd8m/KdtJD4XHFWG5H0k7UEqA567
         PLNwtEOHeTHtrgP5tamJ0EwwbA1MXEMDc480/tUtaOXy9RXuuOGLj697ffiq9eUvsTIO
         InFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rf0VgEByS+dEGqCN3splXKV9KTkduOfaE2qRRkUgcps=;
        b=ct/VWVq1ijx2egez7T10vm/VpPKv/iILjQsUUxDWhkXL53qAcXRGFug02wlA2HXzxI
         IEeWmjSiTh+p6bclwxJCeISZo0FZYg6+9yOf22HsWrKjAPyqKN09t5XpWqkbGQN43RLL
         3GduMfUEc7EUjd+xjeh2tl4xZyMs2RsZXBPoEUM9xEBxIy41k9ZcS3TefXc9toRhbngG
         rHuNqWe/uYk79zD4KyQdGdjZVOVkarLkuEhnxoec9muYmS2nm6SXGJPNq2d3vXOFZt67
         WeWCFHMwPWEm88aTlXorZqN7nuVvtQ01Pl7CeObS8HowbP8s7xc5ancbqGqydyGd3SLn
         Nbyw==
X-Gm-Message-State: AO0yUKXMZQBA3iHyUq5Z7N6h3m2DP00RNcfZeHRD6Cg4o8ILTq4laoDw
        2vUqd6ahFcks9i1NF4rIi7cpwQ==
X-Google-Smtp-Source: AK7set+Q6k8e3Qkz/CA4VS2kB34Azo854Lo4l8KjuohfIBc46OuJ76vovKvUhG5n/f9vvR54+m1kPQ==
X-Received: by 2002:a05:6402:5205:b0:4aa:a501:9bce with SMTP id s5-20020a056402520500b004aaa5019bcemr10596363edd.0.1675881490559;
        Wed, 08 Feb 2023 10:38:10 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id d22-20020a50cd56000000b004aaa8e65d0esm5179663edj.84.2023.02.08.10.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:38:09 -0800 (PST)
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
Subject: [PATCH v9 01/14] dt-bindings: qcom-qce: Convert bindings to yaml
Date:   Wed,  8 Feb 2023 20:37:42 +0200
Message-Id: <20230208183755.2907771-2-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
References: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
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

