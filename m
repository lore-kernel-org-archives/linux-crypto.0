Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1F1C4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Nov 2022 10:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbiKPK0a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Nov 2022 05:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238427AbiKPKZu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2022 05:25:50 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AED425F1
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2022 02:23:32 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id y16so29120447wrt.12
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2022 02:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7vNIlS80kI1g8+qpgwOwxCzQSIw/iF68yTj9CQJk6jc=;
        b=Bxsr3i43QperYujsQtXipOC905fXuVERDgusSJIvEtaTQ68Vf0jd9PCrODZ+fyxjDR
         iA0Vnq5qlE2yi/za2uQeLdUNeEPhdIWqO7m78jkfZj58Pu99og/hLBHbeDl/QpKMYnsP
         XzdAid08n1klbkzVjV0qrW+zGW3E5+AvI5gYEEUa0LgrTxeoCVTXZ+MKWiRIVQ9gtHDS
         qar1/O6Yl9vXfu+eo/++l+XXM4koB4lwwUNNea13xLKIxp53iHIKpW5kzfuKZMhQ/4m5
         ozc9jdpJb1VdzG1BJNY+I3xYMbGzQEZC68SM9zjqY4wfndLuu6w/u/Gl+Y4tZX2Jwtfj
         sZsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7vNIlS80kI1g8+qpgwOwxCzQSIw/iF68yTj9CQJk6jc=;
        b=j0/TM9c98catlVxU8S9D3XbFMXqb9MVXa28nHbevFvQtLYhlcsp9YGEOMbwKkfyIOO
         XmNGOIJEQU8TKy/Sk+bWyg9YQL7F2nJNlpQSe3CH3latBXlG4Xjmcz30t/K+IktWEk9V
         QfJI1W8MKoeQsrWgGttDbCNLUP9HmrM9dA++VJl+3uayQfXLtXk6StN7KE2WIx52W4OU
         pOMnTSGYfZrDgxvlcCDaDtXtGzMhOil+Jmq0AivRXwIqknAufslBoE6aetQqDvQmzDwP
         aXVoK0lJQAF4R1e8uBDfxOtmGzb3f0h+OFzty69shJqUkEPFcHnHcW7aj0+gwYZ9VHqq
         NM+w==
X-Gm-Message-State: ANoB5pltvNjMhWdkO4d/6iswAlM1W7/dCaxfFN/xonIM5OrwWbvJtCrG
        kHTmNYcvR/uhtOFjo3mMj8QwmQ==
X-Google-Smtp-Source: AA0mqf4aCq3gfSN0xjPybxVilQeFWq0t3p4Q22xrVpZc1FMzU+XToiawOAMTArWuFmxIBWKZiHBGKQ==
X-Received: by 2002:a05:6000:691:b0:241:7e9f:8afd with SMTP id bo17-20020a056000069100b002417e9f8afdmr10325981wrb.228.1668594191959;
        Wed, 16 Nov 2022 02:23:11 -0800 (PST)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id i9-20020adfefc9000000b00228dbf15072sm14927047wrp.62.2022.11.16.02.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 02:23:11 -0800 (PST)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Wed, 16 Nov 2022 11:23:09 +0100
Subject: [PATCH 2/4] dt-bindings: qcom-qce: document clocks and clock-names as
 optional
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221114-narmstrong-sm8550-upstream-qce-v1-2-31b489d5690a@linaro.org>
References: <20221114-narmstrong-sm8550-upstream-qce-v1-0-31b489d5690a@linaro.org>
In-Reply-To: <20221114-narmstrong-sm8550-upstream-qce-v1-0-31b489d5690a@linaro.org>
To:     Vinod Koul <vkoul@kernel.org>, Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Andersson <andersson@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Abel Vesa <abel.vesa@linaro.org>, linux-arm-msm@vger.kernel.org
X-Mailer: b4 0.10.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On certain Snapdragon processors, the crypto engine clocks are enabled by
default by security firmware.

Drop clocks and clock-names from the required properties list.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index aa2f676f5382..f25089bf9a2b 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -67,8 +67,6 @@ properties:
 required:
   - compatible
   - reg
-  - clocks
-  - clock-names
   - dmas
   - dma-names
 

-- 
b4 0.10.1
