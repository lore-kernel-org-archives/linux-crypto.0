Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC49C7619A
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Mar 2023 11:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjCVLqB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Mar 2023 07:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCVLpv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Mar 2023 07:45:51 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283A75F223
        for <linux-crypto@vger.kernel.org>; Wed, 22 Mar 2023 04:45:48 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id w4so10926416plg.9
        for <linux-crypto@vger.kernel.org>; Wed, 22 Mar 2023 04:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679485547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZX8cxV4gmi38o9Pi6mmNL+xnFc7tlNvHJgTN5N6z5i8=;
        b=AX9DZXXME3un8pj7UdSfIKe1GjqelLDlEqm7BPP5UV7FblYgG1cQbIIyf3O9J41AM/
         JoWdOMBL087P8bDBLKQ5pzNcXKZqRCrD8hnPw19kCG+jygl/BnNWuLzeTQdm8bcFVb7m
         Oy5ZxYG/14IANAFkHscVuUp3ZcdYVo8Fq5CZdDhkylXWzYVEbipT2hgiWuL++4dZbOk0
         xu4hrlG+ibw6nCUcewjG/QOBO20rV83f56Unidsxc4U/8SUOR5I+ABSMjRSUUYKHATXY
         iCCT98hPzlZ/oGkGutxq4eRNk+Xwu3ijrPbwy7uCEE9qTcb9XwZxJQRWncdpRCO/yYf6
         Muig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679485547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZX8cxV4gmi38o9Pi6mmNL+xnFc7tlNvHJgTN5N6z5i8=;
        b=csv/1msPn6W5hwEiX9gD+km19kt/64A9JyibandurrYYN6Xodzzart01myWPMh4w9U
         NNr2+p22YY7TVLOtDQPZJMiJzQLxtDgr/ZuRxSQhO/ETSRcgonOwow0NPkYb9tjq6OYR
         +fMVCMEJU5Cu3J+NzEFtJ8D4jiT8VQEOtuD2iFKlP8Y93fBn6G2qC6+JDeLZF8y8Gjlw
         ydTRNttMqoeW5mgOVfcbzobW9fa5nt926SqFsanUV5IfpaSXa25ASZbYYd4/R+HaeK9C
         2Gs0658CCsjQzUxdmwPG4myqEJsSuAkqeztAn55V03vPWHDv1VC9nj5NqFJBQxRmGUZE
         s9vw==
X-Gm-Message-State: AO0yUKUL6sQtbuKOFubHzUbkuU5kMglVGE9IZhLFBvlZMbiZXKuBl3Gd
        EGbxt8oaaVQ/D3esW0PS2rj78Q==
X-Google-Smtp-Source: AK7set+eRrg5SBWT9mrl9Tl4A+lrVSioOw8rILTAatf+MN0B6uFdDlAl4lwhS8AFubm3E2HKQbUUHQ==
X-Received: by 2002:a17:90b:1e46:b0:23f:8752:98be with SMTP id pi6-20020a17090b1e4600b0023f875298bemr3535836pjb.4.1679485547584;
        Wed, 22 Mar 2023 04:45:47 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c60:d4c3:8671:83c0:33ae:5a96])
        by smtp.gmail.com with ESMTPSA id jd1-20020a170903260100b0019b0afc24e8sm10386649plb.250.2023.03.22.04.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 04:45:47 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v2 03/10] dt-bindings: qcom-qce: Fix compatibles combinations for SM8150 and IPQ4019 SoCs
Date:   Wed, 22 Mar 2023 17:15:12 +0530
Message-Id: <20230322114519.3412469-4-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230322114519.3412469-1-bhupesh.sharma@linaro.org>
References: <20230322114519.3412469-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently the compatible list available in 'qce' dt-bindings does not
support SM8150 and IPQ4019 SoCs directly, leading to following
'dtbs_check' error:

 arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano-griffin.dtb:
  crypto@1dfa000: compatible: 'oneOf' conditional failed, one must be fixed:
	['qcom,sm8150-qce', 'qcom,qce'] is too long
	['qcom,sm8150-qce', 'qcom,qce'] is too short

Fix the same.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index e375bd981300..90ddf98a6df9 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -24,6 +24,12 @@ properties:
         deprecated: true
         description: Kept only for ABI backward compatibility
 
+      - items:
+          - enum:
+              - qcom,ipq4019-qce
+              - qcom,sm8150-qce
+          - const: qcom,qce
+
       - items:
           - enum:
               - qcom,ipq6018-qce
-- 
2.38.1

