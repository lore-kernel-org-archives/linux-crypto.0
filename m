Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FDFC4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Nov 2022 10:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237640AbiKPK04 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Nov 2022 05:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiKPK0B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2022 05:26:01 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741ED60F6
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2022 02:23:37 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id w14so29115507wru.8
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2022 02:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zdSAVQ71puckRR9im8mq9rOhaC+Mv88lhj00YQialFs=;
        b=R37LfVZXdfhwaTuCYEskPwFUsZkWIMdaR9ntD1Z58b3k63t8RMlLLIOLZamMzJqBso
         0gNPmLlwqfiCerQMTemZ0D/vo4bcFhIsR6T29fakjhvBAOtkMlqNUQMwlAlsSyVU8gAm
         D6fAIc5GEXgcbFT81ReDCzUWacExTuKMatjdbTln6KN8zJKLEor/Zb9gGh/O84VbTMaR
         MQAELkSgd+Fs/i2qv6ol+f6k88Z7+rAEHIMwjLOERl6fjVx1BgFLMJJldxpKUMhSJ3qz
         e+ea7ktRayMcPZhlTB4qwBOdCCfY7fPGs17SZA52qhtDX/Vf6rTIAafPs5a1BytpXA/W
         s5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zdSAVQ71puckRR9im8mq9rOhaC+Mv88lhj00YQialFs=;
        b=Wl9C7MMGSaP4SvFrK3z5PNS5QGZG3uutg6Bug8v5rATkCC+cOvAX2vKJcWg5mhJ4EU
         9AlV0pnwGHgG12rIgAIJ0W7iR9MyoG6py0uC9V1ZsT1lFCSAoeqxrA/0cmbuTmr0k8jU
         Y124EwCqfbaC5M1jb+VfcXWKpZe6PMHSThQleT2BmnDSYt+VY7nosrnFCPA2u05peQfx
         xsGnx+zIkfop4YT8ZmDQ6vY6jFnnB85TgV3gFxfT5imcc/HV2YqIHya40kzwPPCIj8GZ
         j1eEqPgyN4coCWY6H0xuisL5QQCdqFLfRfqJ9kpf2JWUpyRpIDESIrDk3O/xR42Cfr5t
         OEXA==
X-Gm-Message-State: ANoB5pl/uSZkhoI+HZK0bxs62E/7kqp05J7j/52sTCSpe/Ro2Hj0aHui
        cgQxkK5S+CYbY2gNBbkcR3z74A==
X-Google-Smtp-Source: AA0mqf4DbEw1kvnp9Dz1TV1uBQU0fg/bQ2C8GhBHA95/esOJkaZvu0TTNv1kKvLGsuh7/gMWfDA/Lg==
X-Received: by 2002:a5d:4884:0:b0:22e:3725:8acc with SMTP id g4-20020a5d4884000000b0022e37258accmr13549349wrq.330.1668594194009;
        Wed, 16 Nov 2022 02:23:14 -0800 (PST)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id i9-20020adfefc9000000b00228dbf15072sm14927047wrp.62.2022.11.16.02.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 02:23:13 -0800 (PST)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Wed, 16 Nov 2022 11:23:11 +0100
Subject: [PATCH 4/4] crypto: qce: core: Add new compatibles for SM8550
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221114-narmstrong-sm8550-upstream-qce-v1-4-31b489d5690a@linaro.org>
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

Add the compatible for the Qualcomm Crypto core found in the SM8550 SoC.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/qce/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index ef774f6edb5a..fae578ba3e30 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -302,6 +302,7 @@ static const struct of_device_id qce_crypto_of_match[] = {
 	{ .compatible = "qcom,sdm845-qce", },
 	{ .compatible = "qcom,sm8150-qce", },
 	{ .compatible = "qcom,sm8250-qce", },
+	{ .compatible = "qcom,sm8550-qce", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, qce_crypto_of_match);

-- 
b4 0.10.1
