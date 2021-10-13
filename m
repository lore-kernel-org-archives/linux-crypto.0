Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791F9C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 10:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 603C660ED4
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 10:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhJMLAo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 07:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233228AbhJMK7n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 06:59:43 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8337DC061765
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:56:46 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g184so1949862pgc.6
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iCNu8a/Ck6W+not26VTW7TSP+LSVtLNhVTLfjLnMwhU=;
        b=HoODzbnRIqMs1Ucb4XCtlGs7keMM1yHeUyu18/XGO/ra+bc6paP4fL161r3MSmlZDn
         rEljVOOeubypK7iNjSyCLGAZm1B74B2bAyzRnZ7OrR07FKMQ6qTwjlJAm+LyhuKjhOzf
         cygF1XzPj0sSCGak+XUsiObtBXF1tIVJoSuVT1gT+wglp9P+zFYOHHy4EEpmsPbvg1HH
         YuBOYj3oWywvw8/x/Nhdd+OUQws3T0TQ4OKsr6EHgai9w6W6vW23XCvBV1i2UffVVhUv
         DLqvWgTgvrlLFc+DwztoGE6hcqJI3eeJHu7BEmUmh86xP+4W3bay/HSZQQYvvVZ5lVbo
         hxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iCNu8a/Ck6W+not26VTW7TSP+LSVtLNhVTLfjLnMwhU=;
        b=b5MlZbLTz2/U+oX3yfcasS12czFiBPdXAMwz5cpgQWZFfMvyUW6tX42wVFnUAbiar2
         39hmkuZIX60pPVa3EFZFWn0QLjATQ9uYz1Y68ZE8utIJp0xYZqbPdNuRrmd4SVzOijQr
         yFfgX0KKxPOhrt8JgK+/+A0DBYUIAblNXfV2I7OsudZcG9okNAc1Ugp5GgmaMa/6WytE
         ssifxFOj03tnPPu9JtrsDkNBgK9BvT/b6UmR6PCmjQlCX5VLJlduSAHjWM0aTxO+QX+a
         M1RqDUKAbd8W+6s2+pf25L8foaOPvqCiPBgadUJQox461TKpT6x+46QBRJW+pRymb2b2
         vCng==
X-Gm-Message-State: AOAM533EVjfTvcM1prLFuQP1riWsk8zP5Rj28ejnHIPOerbRNOD3Id43
        sAh9MvD0Qx/0eeri+z6ALjKRO9N6Hk73Lw==
X-Google-Smtp-Source: ABdhPJyVrf9QXDFYJZoXCanBdFDeGInOrKqhxMyoZYEt+QlVUqB6jeCrovsX3MptF1CiAE2Uz3v3GQ==
X-Received: by 2002:a62:7cd8:0:b0:44d:4574:ea8a with SMTP id x207-20020a627cd8000000b0044d4574ea8amr6943233pfc.80.1634122606038;
        Wed, 13 Oct 2021 03:56:46 -0700 (PDT)
Received: from localhost.name ([122.161.48.68])
        by smtp.gmail.com with ESMTPSA id b13sm6155351pjl.15.2021.10.13.03.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:56:45 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v4 11/20] dt-bindings: crypto : Add new compatible strings for qcom-qce
Date:   Wed, 13 Oct 2021 16:25:32 +0530
Message-Id: <20211013105541.68045-12-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Newer qcom chips support newer versions of the qce crypto IP, so add
soc specific compatible strings for qcom-qce instead of using crypto
IP version specific ones.

Keep the old strings for backward-compatibility, but mark them as
deprecated.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 1134899b422f..5ab9335219d9 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -15,7 +15,13 @@ description: |
 
 properties:
   compatible:
-    const: qcom,crypto-v5.1
+    enum:
+      - qcom,crypto-v5.1 # Deprecated. Kept only for backward compatibility
+      - qcom,ipq6018-qce
+      - qcom,sdm845-qce
+      - qcom,sm8150-qce
+      - qcom,sm8250-qce
+      - qcom,sm8350-qce
 
   reg:
     maxItems: 1
@@ -68,7 +74,7 @@ examples:
   - |
     #include <dt-bindings/clock/qcom,gcc-apq8084.h>
     crypto-engine@fd45a000 {
-        compatible = "qcom,crypto-v5.1";
+        compatible = "qcom,ipq6018-qce";
         reg = <0xfd45a000 0x6000>;
         clocks = <&gcc GCC_CE2_AHB_CLK>,
                  <&gcc GCC_CE2_AXI_CLK>,
-- 
2.31.1

