Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DF6C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13D5461078
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhKJLDI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbhKJLC4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 06:02:56 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7A5C06127A
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:00:06 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id h24so1256225pjq.2
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rbApVhsArFiEK2jewYhlo8Ja8onBMQkN7/T+JTYi1Gg=;
        b=peNYxpcs7mtexs3d0yeF1cCOMVzTtj7Nz8HEF2MiJ8xwua8BkFZ3CwUek0oI3Jo56c
         syhvi6+PbvMGofCX0Z1T5hPShyFSd7EP6+AII3LnVJpoFRkomKQXJaBkenu/IM/u32ou
         IVAhiOmwZW3D+4jpzCDINBlQdvZCBXeuGu4eFOwvCNlmPyvMIKG29fgE72IF6bfMTiF/
         kV1Am+HwmxQr6ICkpZAVPvnKjw9Zj2l2aCklTTMjdHagaDh77g0Es0Fpnvzf7J4XrIrc
         UOf3mA9YcSelXv5MHMUo5nJoWoNuCh9BuljuespUonCnNGe/AsI9+qZjcKx1NKqIAioi
         9TxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rbApVhsArFiEK2jewYhlo8Ja8onBMQkN7/T+JTYi1Gg=;
        b=npPCAKSEv7K1h7U+qw4hN9lYRUYxprmQ12NSPrp22vE/f39dKBUUxCvPdm57V8bdym
         MIFx7bf7sMouymU4942dzxpPFLc0aHJh3r6EySAR3s9YmCR65lMw1tPjQAvjdov3X9GS
         trL2ixdLFjWkwlexTYQan4aSMrfcn0NsHQ1YA5SGDkzl0q/bscLm04HoOaN8LJPNEL7b
         Jo40E7/vcXqnRrT6AJP4AA0uTxvgRVxCh44T5gHu01Zyc/ltMoM4b1q7JrX/AT5yzxpG
         TiqvA5d0YGJHmmpYUWA2fM6U84UsBjOQ240Kwa6Betz84mewwEBIm2ywzfN2fgpk+FE9
         IKKg==
X-Gm-Message-State: AOAM531DENi/36nfRWHL3Lg75mzl6QcUkHRmGUgBW+RiGYivBM1rZHxu
        VrFd6hMCK/9x4gN10R4x93xEsg==
X-Google-Smtp-Source: ABdhPJweMujZoY1RGGyRy8cWHOVOH511XlIDYHU4XmaLF98GhNDmFbd+sDc/91gHQ/VFeu2MpAfZcg==
X-Received: by 2002:a17:902:da81:b0:141:fa9d:806d with SMTP id j1-20020a170902da8100b00141fa9d806dmr14548568plx.26.1636542006449;
        Wed, 10 Nov 2021 03:00:06 -0800 (PST)
Received: from localhost.name ([122.161.52.143])
        by smtp.gmail.com with ESMTPSA id e11sm5585282pjl.20.2021.11.10.03.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:00:06 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, stephan@gerhold.net,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v5 05/22] dt-bindings: qcom-bam: Add 'iommus' to optional properties
Date:   Wed, 10 Nov 2021 16:29:05 +0530
Message-Id: <20211110105922.217895-6-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
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
index 20e734448c1f..cfff3a2286fb 100644
--- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml
+++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml
@@ -53,6 +53,12 @@ properties:
   interconnect-names:
     const: memory
 
+  iommus:
+    minItems: 1
+    maxItems: 8
+    description:
+      phandle(s) to apps_smmu node with sid mask.
+
   qcom,ee:
     $ref: /schemas/types.yaml#/definitions/uint32
     minimum: 0
@@ -96,4 +102,8 @@ examples:
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

