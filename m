Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32CBE7542F
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 07:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239160AbjJCHKf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Oct 2023 03:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjJCHKe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2023 03:10:34 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010A483
        for <linux-crypto@vger.kernel.org>; Tue,  3 Oct 2023 00:10:28 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-4060b623e64so2903775e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Oct 2023 00:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696317027; x=1696921827; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s7hzBfBC1HHO38BV7omUifYbwC6NG9LeJwnsUI6sbYM=;
        b=ZMXJk7u5+LYYY5DkcIw7V4s1HvdOkF0SZpcspkvIuhwmgJ8yZIjDEMbWNSrbIIKQ65
         2fNSlpcUdcVcnVNclev265pEhGCnxb0FRsGXEBFXFvX/qVUSjZYcL+xKxXq4rjNrYq6U
         gJu9ac8F2cmtqYjRfhuZO5ZUsFaQt2urHfWbxgmR26pM+bLS7xeImVtKU+dBQsfK6YAE
         K+PW73QiFMsHMnf75VnLS4ZB/I1Ix1SP4hnyX2jWs5TXtig7CsLy8WsuZ8967vFC6dk7
         Gv+D6EQI2iSF5V/rShH7YZZHoMpcSst+WXCWVdP3MNRMl1wQuU6Kh2oapwrBvSI5SGIe
         usGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696317027; x=1696921827;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s7hzBfBC1HHO38BV7omUifYbwC6NG9LeJwnsUI6sbYM=;
        b=FaNdTRcfLnbK1q/YWQ4w68r6TRt8NZdejSxGJA0U5wqL3nX2eNMl+piB9maa+VzMBX
         +luDyAkJX3uQuad3M0ahdqJ58IOf5tudqeljCdv2wD+gmzITKdiChJYASW8IEp9CqM5x
         FBfZ9Gh/iOJ9GdUasWO5SNwftYMa+az6qhXubll0OR9kkk6MNEKSCgnXPingSdiZKJTA
         oRas8hhfCK0jUWRs/L2tECYqyQRsBVrP0xgtsC5i0nRqF+XI+paPIrUS4UqoGtiNP3jv
         3HI7eH/UH9aAGIWXzb+aBN57HkChNnBmbxm0Gu0TOovywGCvrxpWhtF0v8Mtwti6Vb2a
         U5oQ==
X-Gm-Message-State: AOJu0Yww4TGDYF1SBYGHnkdlwr+dudVs59ydy4JwjrDjhOG4YGICIKCx
        0sRpYCjZVEGBcA1VwThUWN6Tv6bPmwtkLrRdSErN/ucQ
X-Google-Smtp-Source: AGHT+IF7jiPhps88XqeDvcRH8mvXO3iykVwEjmlOZw4xbbw2PDPYg/oOaAFEIAwSIfAT+Rd34KKokg==
X-Received: by 2002:a05:600c:ac4:b0:405:784a:d53e with SMTP id c4-20020a05600c0ac400b00405784ad53emr1129083wmr.20.1696317026704;
        Tue, 03 Oct 2023 00:10:26 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id k2-20020a05600c1c8200b004065d72ab19sm8746652wms.0.2023.10.03.00.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 00:10:26 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH v4 0/5] arm64: qcom: sm8x50: enable RNG
Date:   Tue, 03 Oct 2023 09:10:18 +0200
Message-Id: <20231003-topic-sm8550-rng-v4-0-255e4d0ba08e@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFq+G2UC/33NTQ6CMBCG4auYrq3pD6WjK+9hXJQyQBOlpCWNh
 nB3CyuMxOX7JfPMRCIGh5FcDhMJmFx0vs9RHA/EdqZvkbo6NxFMSAZC0NEPztL4BKUYDX1LLUh
 eCA0SBSP5bAjYuNdK3u65OxdHH97rh8SX9Q+WOGUUkDOmFC9Vza8P15vgTz60ZNGS2ArFjiCyU
 DfWNFXFSyPxR5BbAXYEmQVtWKnBGn0G+BLmef4AXcLoITUBAAA=
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Om Prakash Singh <quic_omprsing@quicinc.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <quic_bjorande@quicinc.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3627;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=o7ZtrVsBXseXklDoypnZAvHP19ICMUjgfxdMDlPEwBQ=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBlG75euNE22zGyPZDuMSouTlgu9lYUBKwY6N1yb0q/
 xUrwAriJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZRu+XgAKCRB33NvayMhJ0aO/EA
 DAcrGAbWSGsdg9uSAUNUKsC5djHfy3D4WrX2BsZ64rUYzG9fQqR800TPYxJphXotIUJOcUOyNf/0mO
 HPkv0PjVegY0tLu1/CZRLCaRLQ3DLV75GpQG7qpWsttiYMzbHLTgYrOYWSQmKc0IgaQ3AaQnLkWiVH
 ODhnKCVEfxkwNhLNrbozIz3oI57xCvVLjwhbibYvKZMGVHEAMvTE4UPQKh2gbW9T+TalaepbpQWFWa
 cJZeUVu6cR77TkWyqRFw3CMQpwora3I6/vPSQLfc8/0vZ9diMmTe22ofsKLzc72WdfDe7y8kYDpMcO
 JvyI03aJxLzrRuJYkeq5NVKQ756QQ9to3CHsJCqEkXjJjMYwDodc5GK2rnufA3Z2MgwndUMbhttSGf
 OlfoKy6FOsO3Z/JDu8nbvHgn39ONbffCdPPItIpvH4EMJastQ8JFSHzBNoYoW2n+IPnUnVBGQMhftw
 H8OtdTcFIfpHGEzLzgs0AyyRMk0hrJ8xRk04MQRtEitgI+trPrkkhBVJuPJVr349MJ3z1TJxrNgXNs
 U3h7sbX90mf/6G037rspEbv4aFGS/tGVHC3ErYhE0mphBKFVHrcTqPVhmoZxFtay4mEqPmnjCTAuc2
 YPKhB55BflZFxj+ZOKpUSJryE3gKHuHLHzlgP8sS11KGVuyMvm0grJF4VO3w==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Enable RNG on SM8550 & SM8450 by reverting the PRNG bindings & DT
for SM8450 and correctly document it as a True Random Number Generator.

- SM8550 QRD test run:

smccc_trng qcom_hwrng 

qcom_hwrng

rngtest 6.15
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 209420032
rngtest: FIPS 140-2 successes: 10461
rngtest: FIPS 140-2 failures: 10
rngtest: FIPS 140-2(2001-10-10) Monobit: 1
rngtest: FIPS 140-2(2001-10-10) Poker: 2
rngtest: FIPS 140-2(2001-10-10) Runs: 3
rngtest: FIPS 140-2(2001-10-10) Long run: 4
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=9.219; avg=63.879; max=19073.486)Mibits/s
rngtest: FIPS tests speed: (min=24.965; avg=29.093; max=118.469)Mibits/s
rngtest: Program run time: 10002827 microseconds

- SM8450 HDK test run:

qcom_hwrng

rngtest 6.15
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 420580032
rngtest: FIPS 140-2 successes: 21014
rngtest: FIPS 140-2 failures: 15
rngtest: FIPS 140-2(2001-10-10) Monobit: 2
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 7
rngtest: FIPS 140-2(2001-10-10) Long run: 6
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=15.711; avg=50.033; max=32.493)Mibits/s
rngtest: FIPS tests speed: (min=136.239; avg=203.833; max=227.065)Mibits/s
rngtest: Program run time: 10000978 microseconds

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
Changes in v4:
- changed to an enum in first bindings patch to simplify sm8550 change
- integrate Om's patch from (https://lore.kernel.org/all/20230926102005.3277045-1-quic_omprsing@quicinc.com)
  to simplify maintainer's life
- rebased on next-20230929
- dropped already applied revert
- Link to v3: https://lore.kernel.org/r/20230828-topic-sm8550-rng-v3-0-7a0678ca7988@linaro.org

Changes in v3:
- Removed invalid character in commit msg
- Added review tags
- Removed applied patch 1
- Link to v2: https://lore.kernel.org/r/20230824-topic-sm8550-rng-v2-0-dfcafbb16a3e@linaro.org

Changes in v2:
- Revert SM8450 DT & bindings
- Add new qcom,trng compatible and use it for SM8450 & SM8550
- Explicitly didn't collect the Reviewed-by tags due to the compatible change
- Link to v1: https://lore.kernel.org/r/20230822-topic-sm8550-rng-v1-0-8e10055165d1@linaro.org

---
Neil Armstrong (4):
      dt-bindings: crypto: qcom,prng: document that RNG on SM8450 is a TRNG
      dt-bindings: crypto: qcom,prng: document SM8550
      arm64: dts: qcom: sm8550: add TRNG node
      arm64: dts: qcom: sm8450: add TRNG node

Om Prakash Singh (1):
      crypto: qcom-rng - Add hw_random interface support

 .../devicetree/bindings/crypto/qcom,prng.yaml      | 26 +++++++--
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |  5 ++
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |  5 ++
 drivers/crypto/qcom-rng.c                          | 65 +++++++++++++++++++---
 4 files changed, 89 insertions(+), 12 deletions(-)
---
base-commit: df964ce9ef9fea10cf131bf6bad8658fde7956f6
change-id: 20230822-topic-sm8550-rng-c83142783e20

Best regards,
-- 
Neil Armstrong <neil.armstrong@linaro.org>

