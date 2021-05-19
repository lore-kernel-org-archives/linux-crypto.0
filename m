Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C987C43470
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 14:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A5A61244
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 14:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354307AbhESOjb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 10:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347649AbhESOj0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 10:39:26 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68882C0613CE
        for <linux-crypto@vger.kernel.org>; Wed, 19 May 2021 07:38:05 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso3545212pji.0
        for <linux-crypto@vger.kernel.org>; Wed, 19 May 2021 07:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R9Krb+n145fDfyPy6Q+6FikWTCuZ2x/Un3CW1NBeexc=;
        b=ZHUwdEfGjfzjF+1Xzy03WJG6lceLujT8ZApwtXutEA+cikysCCmrDPAXbDR6owzLvB
         TprktMT8fF7xDML9mbIYolmJBoiyzxgnLBWkDLzQk99IxBeCFBzw4mGdQ3dkdhdZ7dIc
         dnAfaukxJ+hZW0/F1m1rYrqI0ITrWXWcaaqAywwmok80BF4KYIBJ0d74MrVHdeNm6oY5
         eEh1x5KH/MuRK8MBEBbXHeX7h8Sm0cW2mJgV77v12S9lFs6bHNP7dEEBEoz9cPFY7DUb
         a7DmY1jaFJKTTpLy4543cdiDupl5HZ9XMYMf2Ukn5g0cAwVXlVHDS76sAdhcv2AMPhMa
         yzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R9Krb+n145fDfyPy6Q+6FikWTCuZ2x/Un3CW1NBeexc=;
        b=tgURIaB3cKO5qT7/+oyr1lF9u6a3rkCrFkJABEQ3GC3E02Md0DHLSwG4Z25+q333ju
         7W9LG3AEUFPHCZjAwgvuwCUXa+cMXJDSkux1QRcH4L14KdmugmnKhoyeDntuFz9861GU
         1GtqKCOLNUFt7DvFlzE8m+DV1B0kp5rRQeajimTXvNKKhNQxdpSL+MC7lsPt/+/X9V+o
         APLZie9xsugfdHzC7uSwRxziE54tu227pkNiQkBlYYoWmEW9Bz97SEK2GVazPrdU9w+Y
         YR9qWz+x7YjuxRkoITmyLHb26IOvPjDVRC9wwh1VOUJPGKHPD9kLuiXnos0qrK5XtDS+
         e1Xg==
X-Gm-Message-State: AOAM533hjoF5YOSS/wc0XKr6bEDKvg5TdSIU7MrfPXnXvb895voO3HnU
        wMg9KrBh9z7ekYryNevJ6ilyJg==
X-Google-Smtp-Source: ABdhPJzGm8igSQWVOQrpGm9zPwCp15NHaHODb+6kVtJ5RUfeDsQhZhOjJ/ZgJ0Bs/skxeb9IUjgK2A==
X-Received: by 2002:a17:90a:a087:: with SMTP id r7mr11679403pjp.84.1621435084870;
        Wed, 19 May 2021 07:38:04 -0700 (PDT)
Received: from localhost.localdomain.name ([122.177.135.250])
        by smtp.gmail.com with ESMTPSA id o24sm9239515pgl.55.2021.05.19.07.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:38:04 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
Subject: [PATCH v3 06/17] dt-bindings: qcom-qce: Add 'iommus' to required properties
Date:   Wed, 19 May 2021 20:06:49 +0530
Message-Id: <20210519143700.27392-7-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519143700.27392-1-bhupesh.sharma@linaro.org>
References: <20210519143700.27392-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the missing required property - 'iommus' to the
device-tree binding documentation for qcom-qce crypto IP.

This property describes the phandle(s) to apps_smmu node with sid mask.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Andy Gross <agross@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Cc: linux-clk@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: bhupesh.linux@gmail.com
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 .../devicetree/bindings/crypto/qcom-qce.yaml         | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index f8d3ea8b0d08..4be9ce697123 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -34,6 +34,12 @@ properties:
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
@@ -57,6 +63,7 @@ required:
   - reg
   - dmas
   - dma-names
+  - iommus
 
 additionalProperties: false
 
@@ -72,4 +79,9 @@ examples:
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

