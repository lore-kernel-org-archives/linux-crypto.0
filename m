Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18AA4C6FA8B
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Sep 2022 11:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiITLlf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Sep 2022 07:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiITLl3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2022 07:41:29 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967CB74344
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 04:41:19 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so2237642pjl.0
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 04:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=g6AC6jEf76DqrwOwWwOtLtUk31f5tzTAXDubM2/ZX08=;
        b=ARe77Wi6S4c70JwGGEeGv+7LI1vlm8Iao63LhaaZHXbimsEa+2gKXKIj45z3WezXK8
         9NYPi+kjzosHx4EpLu4dXx7ZqZ4LDGoZy8FTEym+8iVCkRSq9FE1w3aKbtH3k33G0U/9
         OMowAo+E47vhSo3QmIZYnzcxdvxPibw/EO8hBjPaxGYOlh1We22+Ax1EA81tAI+nR1QN
         7S8VI5BuEajQ0w+LShkZeO9VD5m8WNxwnm6YPkAsivGsP8SfhNUQdzRqJgLjWngm8U7c
         wOgBquSA33uMDBYT+Nm2XKAKlqna45n+bBgo4qdhO2ockESRK3rna8I/hxoKPxYJ+lQk
         fPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=g6AC6jEf76DqrwOwWwOtLtUk31f5tzTAXDubM2/ZX08=;
        b=8PPPJpy77FUZ+WHZK4b3z8G+3YE1qNsC9O51/KUSOlepEicC/GXVRL0XL7SIqOqtfB
         W7awB2kt2UCG9pcqhGF34DfzvWurydI5HfmATJcNyHYD23UkCpBBjfSh9f+pa3gLki4o
         QVIn9H2sFpyjFaN5Azo+VR+cv5kbfR2s5QxRi1dvhe1emzaRMJYtRKgeDyqeom2oVXTo
         KuA5p4+Lu+r5z9Pgwj7A7DzffM5NLebtv353JDzGxxh5J5pdRLUeeJYwiIYIS974cn/9
         m8M6Xt52o4heUiyBFIU8EHqhV157tU4Cemz8CwglKEGGJvoawXaJ4PfrnczSUk6rNnIW
         LYgg==
X-Gm-Message-State: ACrzQf2wWs9N6jEiCPwIUD268Br9fFFYAFXqAIZJYp+RJhDGi+4mJPUG
        swC/Xlo2jP1OMxUEA5RpdX63ID7ua2AuRA==
X-Google-Smtp-Source: AMsMyM5G7F0wTVQPxep+p0SCdwjOJ5D5ZVd8XO7y6z3cQPkLD0IruGY9NAplEmO3T0icT/eFqApszg==
X-Received: by 2002:a17:903:496:b0:176:ba09:1cc0 with SMTP id jj22-20020a170903049600b00176ba091cc0mr4344800plb.41.1663674078004;
        Tue, 20 Sep 2022 04:41:18 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c61:6535:ca5f:67d1:670d:e188])
        by smtp.gmail.com with ESMTPSA id p30-20020a63741e000000b00434e57bfc6csm1348793pgc.56.2022.09.20.04.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 04:41:17 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        linux-arm-msm@vger.kernel.org, thara.gopinath@gmail.com,
        robh@kernel.org, krzysztof.kozlowski@linaro.org,
        andersson@kernel.org, bhupesh.sharma@linaro.org,
        bhupesh.linux@gmail.com, davem@davemloft.net,
        Jordan Crouse <jorcrous@amazon.com>
Subject: [PATCH v7 3/9] dt-bindings: qcom-qce: Add 'iommus' to optional properties
Date:   Tue, 20 Sep 2022 17:10:45 +0530
Message-Id: <20220920114051.1116441-4-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220920114051.1116441-1-bhupesh.sharma@linaro.org>
References: <20220920114051.1116441-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the missing optional property - 'iommus' to the
device-tree binding documentation for qcom-qce crypto IP.

This property describes the phandle(s) to apps_smmu node with sid mask.

Cc: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Tested-by: Jordan Crouse <jorcrous@amazon.com>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 94f96ebc5dac..4e00e7925fed 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -32,6 +32,12 @@ properties:
       - const: bus
       - const: core
 
+  iommus:
+    minItems: 1
+    maxItems: 8
+    description:
+      phandle to apps_smmu node with sid mask.
+
   interconnects:
     maxItems: 1
     description:
@@ -72,4 +78,8 @@ examples:
         clock-names = "iface", "bus", "core";
         dmas = <&cryptobam 2>, <&cryptobam 3>;
         dma-names = "rx", "tx";
+        iommus = <&apps_smmu 0x584 0x0011>,
+                 <&apps_smmu 0x586 0x0011>,
+                 <&apps_smmu 0x594 0x0011>,
+                 <&apps_smmu 0x596 0x0011>;
     };
-- 
2.37.1

