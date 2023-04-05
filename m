Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B012DC76188
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Apr 2023 07:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbjDEHcB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Apr 2023 03:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237062AbjDEHbd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2023 03:31:33 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF66855B4
        for <linux-crypto@vger.kernel.org>; Wed,  5 Apr 2023 00:31:19 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id le6so33628640plb.12
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2023 00:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680679879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ScrPtwLifF81mLBCSzco8cbRfT+aGGc+R4ZbxOTPL28=;
        b=yo1E1yoKY/0EEUjn6/jguZggtiYUWH+mD44H2FkHddBMrSJuWJcHQWSDVCQNmY7FVp
         pe7VOZp36hWx40gL8Hx+cajf8mhR4hBMjx+v01GEVAnuLfHqUciud4cO/f7L3sCJl4Ar
         h2xTHNgkIpUBTnn18SlCyJfZJUHJ97Pbxw+IvYkfWQIfOe1RPcHv90jxjwXoR/gGm5E0
         RnPT3LEGLzwKRTR+apQ0yPjazPOn+oBj54pk/+tRYh7dQd7eTtowELjwnIQqmnz9l59t
         jdbR4BGjUerkQ55UFu260XundYpLzhisMh39RVzT/QZc1S0702FRuBVw7gZ8WiodnHMS
         NCFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680679879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ScrPtwLifF81mLBCSzco8cbRfT+aGGc+R4ZbxOTPL28=;
        b=wAq2xYN1O7qA17zY/5uvhn9PTuCop1KuRXOzGPPMxki5ZgrYcUYOtEb2433+fgH+/c
         i7htga89DfGEQHb5ojdXAJ68yecowcRvro6MLP1dlNpaO77md+N6vwkM27YGL7hj0ljU
         I1JLDBS7T4Js3YCxqCfny8wczXz4jxxVtomylr7MKMOZYrOgwlHWyiyCyHg/bPyl/cMP
         Jz5gXLVfwc/WZfw3/wqJXSEmm0mtpCkJ6CN2dJyp9YsMhBUwO4Um8HU2478NMVC6te6x
         ZrFdsYNKJBhB9vuv1BJOR5KY9mlhAbuuKA0REZg4+5p1hOba8Y8+xqOtQGZfKphyOxvA
         RVSg==
X-Gm-Message-State: AAQBX9f9XDqtI5fCIyz9N8GcmZQoLMRh3/ss23oSati/BahXMl0Mleyi
        5owT/TBmr1UfgRoErUNV20qaiQ==
X-Google-Smtp-Source: AKy350aMaZhBNcxFxbE9JlpaBqLSlaYmaAs4/UkCgsP7H00LbSh2jLBO3P8aHiryTuypoxgD89Adyg==
X-Received: by 2002:a05:6a20:bf1e:b0:d9:3937:43a7 with SMTP id gc30-20020a056a20bf1e00b000d9393743a7mr4416074pzb.55.1680679879122;
        Wed, 05 Apr 2023 00:31:19 -0700 (PDT)
Received: from localhost.localdomain ([223.233.67.41])
        by smtp.gmail.com with ESMTPSA id l7-20020a635b47000000b004facdf070d6sm8781507pgm.39.2023.04.05.00.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 00:31:18 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org
Subject: [PATCH v6 06/11] dt-bindings: qcom-qce: Add compatibles for SM6115 and QCM2290
Date:   Wed,  5 Apr 2023 12:58:31 +0530
Message-Id: <20230405072836.1690248-7-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
References: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
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

