Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A76C636D7
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 13:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbjBBNvK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 08:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbjBBNvF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 08:51:05 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F285EF88
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 05:50:52 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id m2so6085202ejb.8
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 05:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1P4BmKVoM4WJy6aig5rieOVj5RerisqiQF5OT6iCjY=;
        b=hRpVImmxZniqQkapnMCar5U5wkC9eGWxPUNDNVF1Y3GCcmiRMgd9piM6lcpAw/UWg2
         udNyfpZjNr/JqOER0rvTii8XIRVV9cwYo/3ElVxdblJMmQDh0gXWBlCottEjOhQDJZUK
         +7fAlqZ68kvwBrPQbMff6Y6sk58i8PVKcdMJW3XFfu+9TyM/P4Guc/O5SA52+xe6rGK2
         QEqdtNubtAQEqQ2WcgDSKbQLNimfyxi28mpbqe/JmEhURRT6A7/u7qQNAlBz8bBLmqHM
         +cLmzzujFeFN/L9kV76RVzWmV2u0hMNjwsFcXU4qr8TZZB+egCkTU3OXZwHqzEcK9Wr2
         eCAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1P4BmKVoM4WJy6aig5rieOVj5RerisqiQF5OT6iCjY=;
        b=Tp1LAwSbHPAdS+pBID4cjyvcpd5Wwwc2DlZyblOzaMjU+sRixEPJ9bQnObFzL/2dhS
         ciJbJ3kEccBuZ0Kh336PP1ec6HJPecbVGMCSDQVT1g15TkEocywm7/Jz6nJqeZNN3CYl
         +plzsRDWRvI6S3Kvp40QoMOlXVGSDHslmhTVJQrRHY7w5m6a22m9VFTGmyTtv9LxZYwV
         fOYavzmCESuD+sc0A0ECzdkrp5G2vucRn1Ip+zDeWQSkwwkAEqG38cvB0uC0s2uWfJhB
         jsSyTvxWxc5yHV6IFBRJ1FuXlc+ephO0twiylfq2cVpp5EBa01xBxk7ggcyloEmtbgzz
         Z0YA==
X-Gm-Message-State: AO0yUKU/m3VLvzvxkGd310J6pxHmd+nNiH1YmzGD6KmCkno/vB2qkVUb
        bBXn+gO3BpiTuadWwfWcd7slgg==
X-Google-Smtp-Source: AK7set+g5jTvG/NOdtCPrjOchy0lRQ+8KjTwLoFtd7CPYNPM01Ga3Xp369rZiq4CsTirrTr2nqkI8Q==
X-Received: by 2002:a17:907:2ad2:b0:889:3d10:ae93 with SMTP id fm18-20020a1709072ad200b008893d10ae93mr5738774ejc.6.1675345850913;
        Thu, 02 Feb 2023 05:50:50 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id r23-20020aa7c157000000b0049e1f167956sm7596332edp.9.2023.02.02.05.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 05:50:50 -0800 (PST)
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
Subject: [PATCH v8 6/9] dt-bindings: qcom-qce: Add new SoC compatible strings for qcom-qce
Date:   Thu,  2 Feb 2023 15:50:33 +0200
Message-Id: <20230202135036.2635376-7-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
References: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Newer Qualcomm chips support newer versions of the qce crypto IP, so add
soc specific compatible strings for qcom-qce instead of using crypto
IP version specific ones.

Keep the old strings for backward-compatibility, but mark them as
deprecated.

Cc: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Tested-by: Jordan Crouse <jorcrous@amazon.com>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 .../devicetree/bindings/crypto/qcom-qce.yaml  | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index a159089e8a6a..4e0b63b85267 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -15,7 +15,22 @@ description:
 
 properties:
   compatible:
-    const: qcom,crypto-v5.1
+    oneOf:
+      - const: qcom,crypto-v5.1
+        deprecated: true
+        description: Kept only for ABI backward compatibility
+      - items:
+          - enum:
+              - qcom,ipq4019-qce
+              - qcom,ipq6018-qce
+              - qcom,ipq8074-qce
+              - qcom,msm8996-qce
+              - qcom,sdm845-qce
+              - qcom,sm8150-qce
+              - qcom,sm8250-qce
+              - qcom,sm8350-qce
+              - qcom,sm8450-qce
+              - qcom,sm8550-qce
 
   reg:
     maxItems: 1
@@ -68,7 +83,7 @@ examples:
   - |
     #include <dt-bindings/clock/qcom,gcc-apq8084.h>
     crypto-engine@fd45a000 {
-        compatible = "qcom,crypto-v5.1";
+        compatible = "qcom,ipq6018-qce";
         reg = <0xfd45a000 0x6000>;
         clocks = <&gcc GCC_CE2_AHB_CLK>,
                  <&gcc GCC_CE2_AXI_CLK>,
-- 
2.33.0

