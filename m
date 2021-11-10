Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511ABC4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38A3561279
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhKJLDs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbhKJLD3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 06:03:29 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD266C061226
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:00:33 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gt5so1261535pjb.1
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=54tdVliIWNsHoxLvT29lfSVXNZQfROhZR/ww4Z9gmDs=;
        b=pBlsYdbzcAF2OMaaiRBWhvf27TxuDH/EbI7XqtEdLDgSUDDZ9tRpcMW0KRvxECHqr4
         VPrD1Qz65SwFtF4R3Z+SgdCK9cMqmclKQHEKIMYWklIoh1zd3LPtJUJlaImALZcmrlAV
         /9j0iSVdJ0kDUmqkXO8E74beY/Xss7p6QYSyYm79Muh11SwfFPWhyrym7G/TkpKjT0vt
         xdyloJoryMFbILTC8ha8Mb5EeOIRTMl8ME8e737YakFzeUD6K4JGCWNY8547FIEAkG6c
         XEkBsk7ivGB+APV/iDPjnXiAQpmKPI/vGmoSeQreuBRSJteW+OZMlhS9yPowTzzi1vG1
         WfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=54tdVliIWNsHoxLvT29lfSVXNZQfROhZR/ww4Z9gmDs=;
        b=TGM6yXGaWmgKrh0h56FBtoU2/sZUxt05pueeVf4cPirhwjzaFyrvwJJmxmpXwU971b
         4HJTMaubCMU5GH9eI3huKi5R9RoV1TDv1B/3dqSQEtpRoQ+3tAtcqql0eeaqcpYsWTpo
         fL37jPRXSfM4HsJz3XZqV1OZyGEpNzVYQhDkMYl6/Zy/TiE67Y1ghkZsViCXtg2A9B2f
         cl85uPNJaOmOKxFboK80Y85VrBjWy9kwJDg0Ov+SnO5Hb7Ltn5VuAnV/wwNgem+NKQHp
         2uxjTFN9AfIJ2CfnE1IVNUloerq4dtqtGolLGNjSgDxFkGCJL8qMMmCTpO3e5ZR5Degw
         15zg==
X-Gm-Message-State: AOAM532JD+eTRfBVppketgk7sHhhfyOtZZPIdXeCPnDwlw9IV4tY8eYV
        7XBilanhVgO0dHdmQ8+xTc66Rg==
X-Google-Smtp-Source: ABdhPJx3NHUP62WpCyEovHay7pM3+NqDoM66ogl6ACc4C7Im2L9Z/Zo7FBb4lh5Wh2JLmJD0EppiwQ==
X-Received: by 2002:a17:90b:38c9:: with SMTP id nn9mr15751456pjb.241.1636542032065;
        Wed, 10 Nov 2021 03:00:32 -0800 (PST)
Received: from localhost.name ([122.161.52.143])
        by smtp.gmail.com with ESMTPSA id e11sm5585282pjl.20.2021.11.10.03.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:00:31 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, stephan@gerhold.net,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v5 10/22] dt-bindings: qcom-qce: Add 'iommus' to optional properties
Date:   Wed, 10 Nov 2021 16:29:10 +0530
Message-Id: <20211110105922.217895-11-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the missing optional property - 'iommus' to the
device-tree binding documentation for qcom-qce crypto IP.

This property describes the phandle(s) to apps_smmu node with sid mask.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 .../devicetree/bindings/crypto/qcom-qce.yaml          | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index f35bdb9ee7a8..efe349e66ae7 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -32,6 +32,12 @@ properties:
       - const: bus
       - const: core
 
+  iommus:
+    minItems: 1
+    maxItems: 8
+    description: |
+      phandle to apps_smmu node with sid mask.
+
   interconnects:
     maxItems: 1
     description:
@@ -70,4 +76,9 @@ examples:
         clock-names = "iface", "bus", "core";
         dmas = <&cryptobam 2>, <&cryptobam 3>;
         dma-names = "rx", "tx";
+        iommus = <&apps_smmu 0x584 0x0011>,
+                 <&apps_smmu 0x586 0x0011>,
+                 <&apps_smmu 0x594 0x0011>,
+                 <&apps_smmu 0x596 0x0011>;
+
     };
-- 
2.31.1

