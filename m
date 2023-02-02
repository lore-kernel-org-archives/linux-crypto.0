Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557D0C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 13:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbjBBNvI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 08:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjBBNvB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 08:51:01 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F6A8FB49
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 05:50:50 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id mf7so6111388ejc.6
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 05:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fuFiTTM6JEhHJzLRQ/j1mXJ8nHJb7It1hei8p86wkig=;
        b=IDl3F/0c3cBy9P1lwXlE2TEeOR1WFlgPz52kdt2loNZLMDzdMWGJB5gt89dxD2bL/G
         pePR7iJjZ6aCuzKyIxP49MRM6NnJirPG2ZbNbEIKci9Vct5VAX9KDihBL2E+VBjaJZVo
         FKDRpex8qMtM4A/XrFBt4NO7CMdO88iA8Nccw+xWZYN0AfXY8GZFY6Q7HJBJ1xiku6kB
         9EkgnnS8AvR14nWZL4sxzGj+3RTgXsSDsNXqg9r0VK4j2o398dLIu8dyP6PyPLxhLYgd
         bsRq7wDKoruGxO3wnaoeLkgH1qfe2r+UI2qsXjeRIxXwf9CHM0n+rM2hxo5Z686OyQ8q
         tJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fuFiTTM6JEhHJzLRQ/j1mXJ8nHJb7It1hei8p86wkig=;
        b=hiaBQswlmAIQI3uRdaheRN5juS/i9U8bFbG7PNYHFwSib2MR7G4YUxzZtWtR1ujGB/
         HgYqB6SJfRKOGA/6e1GUi8YYLtsQekyJGLNO0BHxMVo5sW81w61VLEXxeGpWi9WwlNRv
         H7vv80KEr1OTSUSEV27/bc6EilsRrb7rretC8cexxDXf88XLnYu4Y9zwtHHwmaFqRyx0
         TzZzq+6KCNM/ag3qCrkYj5iMfdqn/X08BlZ5NoLka4DZm37g3pSfclcgt4EJJHw9qaLS
         ERdR0BogPMV5kVZp+39qS9jBPhmRmTunkh71LkutXxbkUYKcmmB+kEb9I5vvO1k3/UbE
         mIUw==
X-Gm-Message-State: AO0yUKWEz9tRWAGy8f+GO4otmpEQnQOOXmhhlMmImMQInSOv5zr7HuEC
        u8th6jG4hCBrFKiXvbTPwP5s0A==
X-Google-Smtp-Source: AK7set8gPQbo9ZbJBkSzUeLY+AdrtbASn+bQuTN2nc9XWMgBDr9nl0PkFXXO9V6dmfItr4QAPPUT7A==
X-Received: by 2002:a17:906:106:b0:878:51a6:ff3d with SMTP id 6-20020a170906010600b0087851a6ff3dmr6944454eje.4.1675345849108;
        Thu, 02 Feb 2023 05:50:49 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id r23-20020aa7c157000000b0049e1f167956sm7596332edp.9.2023.02.02.05.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 05:50:48 -0800 (PST)
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH v8 5/9] dt-bindings: qcom-qce: document clocks and clock-names as optional
Date:   Thu,  2 Feb 2023 15:50:32 +0200
Message-Id: <20230202135036.2635376-6-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
References: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Neil Armstrong <neil.armstrong@linaro.org>

On certain Snapdragon processors, the crypto engine clocks are enabled by
default by security firmware.

Drop clocks and clock-names from the required properties list.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 4e00e7925fed..a159089e8a6a 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -59,8 +59,6 @@ properties:
 required:
   - compatible
   - reg
-  - clocks
-  - clock-names
   - dmas
   - dma-names
 
-- 
2.33.0

