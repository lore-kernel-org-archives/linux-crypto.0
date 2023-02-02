Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436F3C636D4
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 13:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjBBNvD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 08:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjBBNuu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 08:50:50 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF55D8F25A
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 05:50:48 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id gr7so6122167ejb.5
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 05:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zPdqAVNJI8VFw+E8thVrlhFODN9g8GlhI24Q34QDNM=;
        b=xkt5fSFaBJho8h7UG9vENvhjDy171tUIop7AB7aQ7RVX2ee4jmyR6xnIml9wyQrUDn
         o8SLo2Jm3RBREBi7Gx+jHqLbcX4/AjAVpO3j7dHcVr9yMHln5M5eCOlLLoFqqUobKbgF
         gxoj4DMKM2VXJ+M1YarDK/CGCkiYlMemrh/8b8DciYJh9ieHtDjOC40dHOtCzXrP19wV
         cjlqQ82JoZAl2dOUEe04emqhjMmTnnz1cpPJwqrLhRf199F33aq/qojZK0vrKS0iLySA
         izdixL3D4xrf4ekXQTqb/IT6Bvc0sZu3sfH7tTOY4MWbKpPfjAE+N6NFJ6Bz94vasuqF
         VO3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+zPdqAVNJI8VFw+E8thVrlhFODN9g8GlhI24Q34QDNM=;
        b=XTJP3C/4yfnoLvwaub9ZqR9U1oqIedd8qYQ2kPXV5uyyAXmOE+yf+G8uhGdwjs/O3s
         zv3zScPfJ95RlkLygmyafpCq5vptKbfxOLlJ9IV/h/FxnLecSfxjmRZsR25LnrylOdEV
         C9sqguokGBnj9p5j7m2FuoZYjsbkRwZtttkt0l3J2/hlE90o8YfSmzq4kQWZv9N9M3yE
         PJRP3RvOSDtEGb2mcK3vL/WhlVa/fk75rkR/YqQeHB5wdGTGc8WX9pZq56CZtfl9NzcJ
         5kwfz61R8QuUoG/yaO64g60bTEU0eWcGK4z/i5Kp4K41sCLdcvS3je7OWg0v2IrTO4bT
         FtTg==
X-Gm-Message-State: AO0yUKWq32dS7w2+REwDYe4isnS1C0/F3uSIX8xkvXQuqdTdN+8uhovs
        m/yKNkRmOJgwEKDeTs+5dbg1EQ==
X-Google-Smtp-Source: AK7set+d+HsZwHjXohQNciwKLGCx2roMBm0KGC3YJNl/uSvLOKbPupalGTRAJvFqIPKknMC9zIH/xg==
X-Received: by 2002:a17:907:cc25:b0:7c0:d7af:fce3 with SMTP id uo37-20020a170907cc2500b007c0d7affce3mr4819110ejc.1.1675345847460;
        Thu, 02 Feb 2023 05:50:47 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id r23-20020aa7c157000000b0049e1f167956sm7596332edp.9.2023.02.02.05.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 05:50:46 -0800 (PST)
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
Subject: [PATCH v8 4/9] dt-bindings: qcom-qce: Add 'iommus' to optional properties
Date:   Thu,  2 Feb 2023 15:50:31 +0200
Message-Id: <20230202135036.2635376-5-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
References: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Add the missing optional property - 'iommus' to the
device-tree binding documentation for qcom-qce crypto IP.

This property describes the phandle(s) to apps_smmu node with sid mask.

Cc: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Tested-by: Jordan Crouse <jorcrous@amazon.com>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
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
2.33.0

