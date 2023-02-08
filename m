Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9A2C636D6
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Feb 2023 18:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjBHSiw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Feb 2023 13:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjBHSiY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2023 13:38:24 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FCF1BC0
        for <linux-crypto@vger.kernel.org>; Wed,  8 Feb 2023 10:38:18 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id u21so21743976edv.3
        for <linux-crypto@vger.kernel.org>; Wed, 08 Feb 2023 10:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=seDN7hLl5swt4J3XJglUIV2zzqtOSiYmNP6OJCG/0cc=;
        b=Vb5ztwSumtqb2AB0kziEEW5EbhUthUpiOANbKW6VF+Np5gKsFzuhYqYjxzZ3M398Q3
         DGAayObtSCsTqCgKdKBec95E17hC16j/qqyWWIaUMJ9Zdy0v3L+Vz89mgOwnvMrNp8Tv
         icUlj9/ErrnolSiksCWHbKyB4I2VRRIMYJzjfVDleHSxOli6A6uwyLJE7upSTC+h7bnl
         ypD3IdhRp4A9rODPxSK7rNDKBM/6UcXcjw9oRKtA7Hi5vX4CWM90mRI16Y3ecTmBTQJo
         ufMO/Wb65MP/SnSIB+ctt4JSSiQr3QzAdBs9zU/bngEn85oUusQyl+B9wGX49OW+gBfu
         2awg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=seDN7hLl5swt4J3XJglUIV2zzqtOSiYmNP6OJCG/0cc=;
        b=ukG40WGoF4JCMz8AOVj7zRcb3Soovhw0Ryg1MUmjxF2aey4NpAl3O/Ylg6YrQleNFg
         rWVp1H9NRXG/m6/Z8e1dQbkIT2p2Jdy9wkRDItndTp6xs1JBtgH+aLXMNWGUPMP6N1F5
         YRaxbu3sHJ35AVbx+care16O/5C9wYb4pXrIp4bhV2BobnzI3tEby/U14GMk+OS7j19k
         SwhGHnRWRHlekZpC/bkRbmc5DqfGOWG4NaYJzG6Y01+jH0gKRxo61oPjOR/xixHZVVXy
         yTTXbxWd0bB9hkVqVWRyLyKM7S5n2TT61cNC9je7pYDe9wYKM1vOJtjkDD4hKrJBkPQV
         8LEA==
X-Gm-Message-State: AO0yUKX6BegF1bOEGXzgeMbjRsgHsVSVNDVSWfU38Nx1l5mGDWHqq7ep
        Z1w2qUpPmQu61HvRdSoMcVAs8Q==
X-Google-Smtp-Source: AK7set+y4vkuO6iCpFVJRNS7wp74veH5JnO0RdabOe4YWDYh+5U6S4gBwdKJ8pFaGEI7pgC9E7iKLw==
X-Received: by 2002:a05:6402:51d2:b0:4a2:64d7:16bc with SMTP id r18-20020a05640251d200b004a264d716bcmr9494711edd.4.1675881497254;
        Wed, 08 Feb 2023 10:38:17 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id d22-20020a50cd56000000b004aaa8e65d0esm5179663edj.84.2023.02.08.10.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:38:16 -0800 (PST)
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
        linux-crypto@vger.kernel.org
Subject: [PATCH v9 05/14] dt-bindings: qcom-qce: Add new SoC compatible strings for qcom-qce
Date:   Wed,  8 Feb 2023 20:37:46 +0200
Message-Id: <20230208183755.2907771-6-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
References: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change QCE IP version specific compatible to two QCE IP family compatibles
based on SoC name and populate these two IP families with particular SoC
specific IP compatible names, which are known at the moment.

Keep the old compatible 'qcom,crypto-v5.1' for backward compatibility
of DTB ABI, but mark it as deprecated.

The change is based on the original one written by Bhupesh Sharma.

Cc: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 .../devicetree/bindings/crypto/qcom-qce.yaml  | 24 +++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 4e00e7925fed..f6f1759a2f6e 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -15,7 +15,27 @@ description:
 
 properties:
   compatible:
-    const: qcom,crypto-v5.1
+    oneOf:
+      - const: qcom,crypto-v5.1
+        deprecated: true
+        description: Kept only for ABI backward compatibility
+      - const: qcom,crypto-v5.4
+        deprecated: true
+        description: Kept only for ABI backward compatibility
+      - items:
+          - enum:
+              - qcom,ipq6018-qce
+              - qcom,ipq8074-qce
+              - qcom,msm8996-qce
+              - qcom,sdm845-qce
+          - const: qcom,ipq4019-qce
+      - items:
+          - enum:
+              - qcom,sm8250-qce
+              - qcom,sm8350-qce
+              - qcom,sm8450-qce
+              - qcom,sm8550-qce
+          - const: qcom,sm8150-qce
 
   reg:
     maxItems: 1
@@ -70,7 +90,7 @@ examples:
   - |
     #include <dt-bindings/clock/qcom,gcc-apq8084.h>
     crypto-engine@fd45a000 {
-        compatible = "qcom,crypto-v5.1";
+        compatible = "qcom,ipq6018-qce", "qcom,ipq4019-qce";
         reg = <0xfd45a000 0x6000>;
         clocks = <&gcc GCC_CE2_AHB_CLK>,
                  <&gcc GCC_CE2_AXI_CLK>,
-- 
2.33.0

