Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E9EC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 10:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF89460F21
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 10:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhJMK66 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 06:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbhJMK6a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 06:58:30 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EB6C061770
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:56:24 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so1992870pjb.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z2sBrvxA3Mihi2vqUGXbJq+xZIOpCjvkxgHKQyKWO9M=;
        b=dLxvEsOxnAJ/yiZvhLJAWdzUsjZx4F/hO8SG55sjqC0uoMeR5cKq8CRX6rctKV7T67
         Jnys6dAYsj5lAOLQp7uBRdoyWZsJvcC9PIimn/onluhCZRb2JuuEotwod62vfk2svJN0
         FYD3mJgXEgaXBT/qqliSdkQDC73Kr5MPVt02l+0OE1aVwSdKU80Nrd9auYlbcoMlWXPg
         dW+FpGdBF+SjX9kHvmUMPAfpOKCkKP41ROJmArpxZ/8LzolH0WeLVXrdQXVQ50Mhx311
         fCDBbsAvrNH63RX3hSSaPtxGTzzdqYWlskRYVOe+Pe3rxCTPoONuN/u0ax2AgjASAjCG
         5z9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z2sBrvxA3Mihi2vqUGXbJq+xZIOpCjvkxgHKQyKWO9M=;
        b=T4THZE9KSuH0/c05Q47ryFb2ke+L59CfLi9oG9xkBz6mY3gOhBMLNIq3MxhjHpH+/z
         MR7FLIQMD4pHs1FXPFt0qPYUFEhYRBQLtuR6ek8gGWbUtDJYeu4QZeUHysIWZl132CAn
         nCmTLYS2KuZnhMUZUyhWvx7GC7/dRcXzcSXTnlHA+6lnUazrhf439qkMZG0U8le1/Kg0
         Z7Y2h4wSSMaC881GZIzjNnlX28n5xlsEQTEXEyoMXHZ/HvYK64qIf09CWDFZ+dPaqwWR
         orswDQmBK9t+N5F/+mm6TuoKr7l96PJiTD/rwDOPe1wC3DZ6N39+1WV0zO/rwQW/F4c0
         TuXA==
X-Gm-Message-State: AOAM533CMLMC9stUta9aV1UfKZ3f/yJmfpFPwyHdqpnfKiPl9YmZMRim
        +eNv5vb2PZSMYLpBHTopRsISJA==
X-Google-Smtp-Source: ABdhPJzS5MsQJ5G6pY/x5ilWe9j0Ca4cdetOxPcEMbiTwTVvfiYrezOs7OgcrbQRhYkzYJDvZNyTdw==
X-Received: by 2002:a17:90b:4d8e:: with SMTP id oj14mr12663660pjb.160.1634122583633;
        Wed, 13 Oct 2021 03:56:23 -0700 (PDT)
Received: from localhost.name ([122.161.48.68])
        by smtp.gmail.com with ESMTPSA id b13sm6155351pjl.15.2021.10.13.03.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:56:23 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v4 06/20] dt-bindings: qcom-bam: Add 'iommus' to optional properties
Date:   Wed, 13 Oct 2021 16:25:27 +0530
Message-Id: <20211013105541.68045-7-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add 'optional' property - 'iommus' to the
device-tree binding documentation for qcom-bam DMA IP.

This property describes the phandle(s) to apps_smmu node
with sid mask.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 .../devicetree/bindings/dma/qcom_bam_dma.yaml          | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml b/Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml
index 602e68df971f..7c046a281fcd 100644
--- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml
+++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml
@@ -53,6 +53,12 @@ properties:
   interconnect-names:
     const: memory
 
+  iommus:
+    minItems: 1
+    maxItems: 8
+    description: |
+      phandle(s) to apps_smmu node with sid mask.
+
   qcom,ee:
     $ref: /schemas/types.yaml#/definitions/uint32
     description:
@@ -94,4 +100,8 @@ examples:
         clock-names = "bam_clk";
         #dma-cells = <1>;
         qcom,ee = <0>;
+        iommus = <&apps_smmu 0x584 0x0011>,
+                 <&apps_smmu 0x586 0x0011>,
+                 <&apps_smmu 0x594 0x0011>,
+                 <&apps_smmu 0x596 0x0011>;
     };
-- 
2.31.1

