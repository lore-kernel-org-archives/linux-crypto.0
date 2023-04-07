Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0C7C77B71
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Apr 2023 10:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240641AbjDGKus (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Apr 2023 06:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240293AbjDGKup (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Apr 2023 06:50:45 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98217A5F6
        for <linux-crypto@vger.kernel.org>; Fri,  7 Apr 2023 03:50:42 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r29so41971311wra.13
        for <linux-crypto@vger.kernel.org>; Fri, 07 Apr 2023 03:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680864641; x=1683456641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nU/yphFY/brnvT8pyeHTqL0FHqwuTdveAK5097Yxf5M=;
        b=wkQaGNlivZjUxdi0Uvp81wH0UIN4Z7VmgY2cR4J3I4UdLSLeb9qXt5wi+IpMLpS45g
         sYjZsoapnUQK0C6baq45oGHKLUPt3TEl1cnu4brLQBZ/kxsoRSfBGqadpvRYAUwjCVSu
         cwybVpDgtiTtwt3LD7azzhYDozmITkk03bhJ9Egr7w1zIv3hUdiIuXmvL9GauqBjRaXI
         rcRs3gib+dC2G2ZqaKSAfO2M9X5zsx7/Jl1adlAh7gZCcXqn+WK8XMcARn7V311V6iA0
         94z0b+CAkXqkgWrAY9vzI10i3PNpHy+JWDCsHaWbvV+AJOVw3olMJfjJBabzcQIQM4Cn
         18GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680864641; x=1683456641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nU/yphFY/brnvT8pyeHTqL0FHqwuTdveAK5097Yxf5M=;
        b=NIwXkf4223kgzkkJmoDt7drrOFOa4/Bcn/ahYvLDPBT0+umBzE2Pmp8cOi89nj4jXL
         0a9yGWeMefz/B0NDTgroha1xtzqeUppC+HbBFHsdA56529lc/6UE8kI/GW/dBJ2Pyytl
         nLsdHE7rZ2kXqkWhn/H0CsmydXLjzuz/zL9y0jqI2bg2Ku416xLYBwqWFkBNxwM3zrwx
         1wvwrqmqMPPPNDpr0FBKslWtX9FMaWbiJy8fG+D0nB4WfggRKnzYYiT5hnTJIchp/rO5
         laskImEhw0g6nHkWkX6nLZB4gHR9rcB0wmAcScSMtVTLHaVjUFqQ1kf03jPG9f2GTIs1
         bX0w==
X-Gm-Message-State: AAQBX9dIVqho7KQ2uSfoemmnCiGCadINDVWhVKNSOoWxY3zbS4o73Vlp
        QGXNG3Ht//py+EztC2VGX75kXA==
X-Google-Smtp-Source: AKy350aQWMU/oZEkCE3WmgisVy1qKBuHAqfk4gyyXdRSSkJRS1RihuemTI7nHUfKvB+PmDIUyAZtUA==
X-Received: by 2002:a5d:6b02:0:b0:2c7:1d0d:7184 with SMTP id v2-20020a5d6b02000000b002c71d0d7184mr1111061wrw.11.1680864640867;
        Fri, 07 Apr 2023 03:50:40 -0700 (PDT)
Received: from localhost.localdomain ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id i16-20020a05600c355000b003ede6540190sm8131909wmq.0.2023.04.07.03.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 03:50:40 -0700 (PDT)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v6 1/6] dt-bindings: crypto: Add Qualcomm Inline Crypto Engine
Date:   Fri,  7 Apr 2023 13:50:24 +0300
Message-Id: <20230407105029.2274111-2-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230407105029.2274111-1-abel.vesa@linaro.org>
References: <20230407105029.2274111-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add schema file for new Qualcomm Inline Crypto Engine driver.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---

The v5 is here:
https://lore.kernel.org/all/20230403200530.2103099-2-abel.vesa@linaro.org/

Changes since v5:
 * none

Changes since v4:
 * added Eric's R-b tag

Changes since v3:
 * added Krzysztof's R-b tag

Changes since v2:
 * moved the file to crypto dir
 * added soc specific compatible
 * dropped top level description
 * renamed node to crypto and dropped label in example

 .../crypto/qcom,inline-crypto-engine.yaml     | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
new file mode 100644
index 000000000000..92e1d76e29ee
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -0,0 +1,42 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/qcom,inline-crypto-engine.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Technologies, Inc. (QTI) Inline Crypto Engine
+
+maintainers:
+  - Bjorn Andersson <andersson@kernel.org>
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - qcom,sm8550-inline-crypto-engine
+      - const: qcom,inline-crypto-engine
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/qcom,sm8550-gcc.h>
+
+    crypto@1d88000 {
+      compatible = "qcom,sm8550-inline-crypto-engine",
+                   "qcom,inline-crypto-engine";
+      reg = <0x01d88000 0x8000>;
+      clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+    };
+...
-- 
2.34.1

