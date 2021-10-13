Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2790FC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 10:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BC4F60FDA
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 10:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhJMK7o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 06:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbhJMK7B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 06:59:01 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA9FC061749
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:56:37 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id m21so1918472pgu.13
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T1vPQV0qYkahKzrrtJ/01RQjfjjhS4pae1ACyI/Og8E=;
        b=QtFFChBCVKJbBjVREl6Cbomp6VGjcmLbYdGmQB/vFJ4aRhinw2L7mpc3BzmX7YoSeX
         tfcHVxsPWdJ7YefZ9rflKwQC5yeNzU2mXmzWyXSn7o8t8cnt4A//GhwNPCRMea61VI38
         1S6JzFum0ZGSdQ4zKCdWk6s5RfsZXbXdRPosgOW4Nprdpv+iMOXWoHsuEasz7SpaQzZJ
         7qOSlhCS72ZgaK3ZNqc+hofdoLd6DPNQSUWPCf77pEAxWtJALG6y+wZVjl7I0sZzMezY
         XSaoggE+6/+BK6AKyb/BH6ssCXGWuuYOYWLWRV8QQ/J7QUNGzs9j4fNkbCnlxqCbAgeu
         6l/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T1vPQV0qYkahKzrrtJ/01RQjfjjhS4pae1ACyI/Og8E=;
        b=CnlGpU0JSeAkhHHpdEhbBA/JgqgaqXYzs0YSRjRsSe21TgswlK76qvApPgPT9t/f4w
         IKeb+HqngJIpM6bt4it07LlMDO/TYQM2wnBHSNmUjEbH8NV8pfrTZRpaWLvdlmk77XEj
         mKlFpffCtq9DU82AEWBFPMldv/KvdHZpThvl89UbIuXWCuzQrfoRUAGe6/3VDFSo53B6
         P36e4m6Mntixe+JLKhnQMekCqyR309EApmL0cJwW8eQKZJgyzwzn/CvNByBqDAhfqPWh
         TMSU/GJ+T6rQ/H5A4F1AHCYu3Fk45FTWWkJDW/2m3zCJxYYM7dciQpq9SbjIs8ALbQXc
         e51g==
X-Gm-Message-State: AOAM532/9tTQ3KHQARrEDDNtXO6T2JqY9/FOATY2bBUIgjMvoRBe5XUp
        K+d+vKwZ6jPxxZSAu5xIMW2GZQ==
X-Google-Smtp-Source: ABdhPJzuAijvw6u9ng9pTmrZ4h94CJzoLbSo1QOZoyjgmY5sreij4smFSSvzEJuo0l2MVJ3/dL0aRw==
X-Received: by 2002:a63:3d4a:: with SMTP id k71mr27435332pga.276.1634122597073;
        Wed, 13 Oct 2021 03:56:37 -0700 (PDT)
Received: from localhost.name ([122.161.48.68])
        by smtp.gmail.com with ESMTPSA id b13sm6155351pjl.15.2021.10.13.03.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:56:36 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v4 09/20] dt-bindings: qcom-qce: Add 'iommus' to optional properties
Date:   Wed, 13 Oct 2021 16:25:30 +0530
Message-Id: <20211013105541.68045-10-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
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
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 .../devicetree/bindings/crypto/qcom-qce.yaml          | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 954f762090f3..1134899b422f 100644
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
     description: |
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

