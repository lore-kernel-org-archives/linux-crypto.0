Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC8AC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB3C061248
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhKJLDf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbhKJLDT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 06:03:19 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A5BC06120B
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:00:27 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id m26so2343117pff.3
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Eecmho/J6Agff4bcpW3b3Dj2ZtsofOUgkrIvTWiN8c=;
        b=leAvj1mXLG0HHHpuqJnYx4iiChlD88CZNwcnrsMCfsebweYhh7+0cGtjUPp2+2Xg91
         itLpKUAmWtnIVRMCe/7gpXX17rZJmMSk67gsHRGP+i4Md3B3cBtFZS3JOQuyYMjtmjLo
         sj4LpG3ZNcqvU8fawzrzltxb81kcAz0udI9Pm1TkjMzRz9fUHT8xpD2y1RiPJXELCBO5
         qX9CSqiQ2zTbMtli+tWsLOnDtm4h97/2IDZqQ+LKwulNix3Km7Nf4QKedfxfzFE0Z+yg
         57QDQdVlQOeG8IvYmaVYw8bSV99q6D3UZdQokfweNzCbYzHDfPoAUW85x6zTrazzixa3
         h+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Eecmho/J6Agff4bcpW3b3Dj2ZtsofOUgkrIvTWiN8c=;
        b=lFkgM3qnEHuxckR3w6yqJn697o5R7XlgiyUrYF32a2VjBfIrr23KNh6W6cYiYCSoM5
         3jaNwhjg9XhLtGlnSR1QPzVJpJ3Pxv6NdG++jjfvToe8sibHIx0Q7snjXNHnVW3HfG3U
         C29Sgb2x/qXVDrz/zbL4w2Fne7zgxp2faREL/P0JUE+EH+Qg7AqMJTQI/rckFDsLraQA
         1AH2R+DMCCK2XDmddvzFg2PDyMo/3grrfgS7InaULeIR41Z4JauZGXQxcQuJDMV/AXyM
         J4Xcrz7NSQpef0QfiWZ8LTtO+CNUKs+3TaJRko/RjCF/9bB7n3aPcy63wvEpZHGmrFxu
         rfQw==
X-Gm-Message-State: AOAM533Ibw9+ixIlL6E4DC7quho+ieVFPk9ZTMmwuWRlyKsF6osYNOlm
        T0OzjzqQwuo6T39ZJs/5b2DMCQ==
X-Google-Smtp-Source: ABdhPJxviW6mvmO0Bz+ZTQMwv+gsFrpAJRqvbJUVly9WWffJckKn5XGCguRKyP28KHPeCjFmGfFF1g==
X-Received: by 2002:a05:6a00:b49:b0:49f:cc01:10ff with SMTP id p9-20020a056a000b4900b0049fcc0110ffmr15448827pfo.42.1636542026926;
        Wed, 10 Nov 2021 03:00:26 -0800 (PST)
Received: from localhost.name ([122.161.52.143])
        by smtp.gmail.com with ESMTPSA id e11sm5585282pjl.20.2021.11.10.03.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:00:26 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, stephan@gerhold.net,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v5 09/22] dt-bindings: qcom-qce: Move 'clocks' to optional properties
Date:   Wed, 10 Nov 2021 16:29:09 +0530
Message-Id: <20211110105922.217895-10-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

QCom QCE block on some SoCs like ipq6018 don't
require clock as the required property, so the properties
'clocks' and 'clock-names' can be moved instead in the dt-bindings
to the 'optional' properties section.

Otherwise, running 'make dtbs_check' leads to the following
errors:

dma-controller@7984000: clock-names:0: 'bam_clk' was expected
	arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dt.yaml

dma-controller@7984000: clock-names: Additional items are not allowed ('bam_clk' was unexpected)
	arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dt.yaml

dma-controller@7984000: clock-names: ['iface_clk', 'bam_clk'] is too long
	arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dt.yaml

dma-controller@7984000: clocks: [[9, 138], [9, 137]] is too long
	arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dt.yaml

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 30deaa0fa93d..f35bdb9ee7a8 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -53,8 +53,6 @@ properties:
 required:
   - compatible
   - reg
-  - clocks
-  - clock-names
   - dmas
   - dma-names
 
-- 
2.31.1

