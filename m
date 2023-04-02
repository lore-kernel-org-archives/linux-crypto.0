Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCE6C7619A
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Apr 2023 10:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjDBKIc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Apr 2023 06:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjDBKIF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Apr 2023 06:08:05 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9EB902B
        for <linux-crypto@vger.kernel.org>; Sun,  2 Apr 2023 03:07:46 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id h14so15834251pgj.7
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2023 03:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680430066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ScrPtwLifF81mLBCSzco8cbRfT+aGGc+R4ZbxOTPL28=;
        b=xgu8DjvZsG1vIfCnPmIyi1d1f1dEnXwIxVUnJ+R1sAT2Y9/CdCohp8mwakGRuJWxCW
         Pzo3C+382VCOMTsjrqfpyFBEXi0gwVgS63ibE3kM7Ga2OaMGJOZdoZ1y96Pipq0CMCcJ
         PvfGHkfY17g/iQt2p5CfUtKQfSjrYcauqc5hlOmQVeeJ4GHpF7Goxmp0bKEWPE10gF5m
         acHHOhse70AqeKG1te191ex8uSQ93ZPfT+yMXZIXUvIVLEx+4UOhRoqjdWAQlzI+CPkk
         1s7F3aRmeyBRKj5lOgCPVeM0CXnjjlcShABXDw1ENtP94d6d3vBZyOqb40AXMAyMMNuy
         w4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680430066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ScrPtwLifF81mLBCSzco8cbRfT+aGGc+R4ZbxOTPL28=;
        b=4dgUrXILN6RMN0eXtkQVpkRx+ALQVaviHQRcUP+L5oACSdKDdsmTU18MbRGgNue6d0
         LT4mUKv4VsgLJnFGL4r0HFF+07hhoCYO+DiwlF1KViN9EXMakQ9L4G/dz9EPfN2y6Hk7
         PUaIj4sQxrI+1tuyFbItqIrMBAKVYWaqYjtsrSm7FDlWb2Pbnm3a5NLxBeXnCdr7um5F
         Yp/nu5iAzlJ99Svd6w/CIWLgVRRqYB0xOvqDcXISpRW15NxtODGXd4JtrIItRtoHECDg
         Vq/RE9pq4m6c/7/+zXZMlDUzzV37LeysKU/v6lnnmsqHZzFDpDDEkbc6KD/U2IysCt5M
         H0bg==
X-Gm-Message-State: AAQBX9cmX+ad+ymNquDPIyUjptnCl6V9IfHoyYJTPhHjarXGtqgUF4s3
        jZ5y9+y3Bt12Pr0aBSRjUccev9+CVB0l23tMwb8=
X-Google-Smtp-Source: AKy350bE8U9vbqH+ow3+PWsevkiaCi1uYp8UZh1ap078kAA+wHtCuycGeEFGfcgAXqx1peBrXMn2oA==
X-Received: by 2002:a62:18d5:0:b0:625:ff85:21ec with SMTP id 204-20020a6218d5000000b00625ff8521ecmr32686433pfy.26.1680430066539;
        Sun, 02 Apr 2023 03:07:46 -0700 (PDT)
Received: from localhost.localdomain ([223.233.66.184])
        by smtp.gmail.com with ESMTPSA id a26-20020a62bd1a000000b0062dba4e4706sm4788739pff.191.2023.04.02.03.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 03:07:46 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v5 06/11] dt-bindings: qcom-qce: Add compatibles for SM6115 and QCM2290
Date:   Sun,  2 Apr 2023 15:35:04 +0530
Message-Id: <20230402100509.1154220-7-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
References: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Crypto Engine block on Qualcomm SoCs SM6115 and QCM2290
do not require clocks strictly, so add compatibles for these
SoCs, indicating that they are similar to the flavour
found on SM8150.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 90ddf98a6df9..82ea97568008 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -41,6 +41,8 @@ properties:
 
       - items:
           - enum:
+              - qcom,qcm2290-qce
+              - qcom,sm6115-qce
               - qcom,sm8250-qce
               - qcom,sm8350-qce
               - qcom,sm8450-qce
-- 
2.38.1

