Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5089FC61DA4
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Feb 2023 17:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbjBVRXH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Feb 2023 12:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbjBVRW4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2023 12:22:56 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62F81BD8
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 09:22:53 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id z5so8617099ljc.8
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 09:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zPdqAVNJI8VFw+E8thVrlhFODN9g8GlhI24Q34QDNM=;
        b=F6NRcVNCEQdpHj0xn9o3B59THa3C2w5KIWBO4IwiQXZvqbmLJxSDZGxTKRQMNBRoe7
         GBQTmDVD2qhrRPCMp/3K8WrysytiyPToPMGf2tUTa6gPF1MtecU49cJ5kulB7/BP5cSF
         gu9vlHKt/rmrIm+QzxVJnI5pjNg/mC/LFAHDdBlzh7zFZy5qhOH8KiugatNFAeYu3XWH
         8itr2yVBLcvl4kJc+K+zL12MnRNqNvVFxYWjvLfrTa2H4832vdfArdS6b/nUhvb4NYQD
         5Hk+/bHJ/LlV0xEMr77VXaXWpV/Qq5QTd2FCzGxlipPdUpNdqlZ7RluEAJGv7KYk8IRG
         bUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+zPdqAVNJI8VFw+E8thVrlhFODN9g8GlhI24Q34QDNM=;
        b=Dt7dnjOmjx4ClnDVeKrqvX5FKAqoDic0fTDLYCWZIddb5m0hrD79ij4eVW+PeMUFZk
         D4gdbxkcdLTTXS90s+AtesEyK45JqfRM2mnOmvOadAjMwLBj3HV6GAX5XA/BUIMiyDbp
         oxt2Jem/yK/34z3XIbwlQaM9j3AnRMu8QkBzAuxfyHK5yzcTVfx8d+m0UDHPch2Tb2c5
         S3CL1rwgiNr6dRWBRFz4X3EmJsXwRNaLSNwil/IN/yZ07Ka5Ih1StNt4worbxBG7RgM6
         wpBmnWhADyDTvF1vIiajpOD7LuzwBsrZYyFDquOOXLxE9rZWsqmTbwnz1jwRcm3zfKyI
         U54g==
X-Gm-Message-State: AO0yUKWLK319etpdn2eWX3TgbbfDfwxSe0TWoCaWC/LXrnglNKcUjGdH
        r0z9I9mqfaQ3H/a9FRaEbsW6OA==
X-Google-Smtp-Source: AK7set+dySSsvAUYZ+NCjmcRgJDbatvPF1pZQ+8JGZ/LM9IEJ0mMTBryhF62Lye5uGvasxQ0OjDt9w==
X-Received: by 2002:a05:651c:554:b0:293:2c7e:bf53 with SMTP id q20-20020a05651c055400b002932c7ebf53mr4847659ljp.0.1677086571881;
        Wed, 22 Feb 2023 09:22:51 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id r3-20020a2e80c3000000b0029358afcc9esm805233ljg.34.2023.02.22.09.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 09:22:51 -0800 (PST)
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
Subject: [PATCH v11 04/10] dt-bindings: qcom-qce: Add 'iommus' to optional properties
Date:   Wed, 22 Feb 2023 19:22:34 +0200
Message-Id: <20230222172240.3235972-5-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230222172240.3235972-1-vladimir.zapolskiy@linaro.org>
References: <20230222172240.3235972-1-vladimir.zapolskiy@linaro.org>
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

