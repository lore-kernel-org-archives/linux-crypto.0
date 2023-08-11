Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A195C04A6A
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 20:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbjHKUvB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 16:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbjHKUvB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 16:51:01 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096F02D54
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 13:51:00 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4fe2de785e7so3853697e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 13:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691787058; x=1692391858;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3jqJojQwGIq+MbCn3Pj9qfGFrLvfGPKUQcVkXP9fboM=;
        b=FoBWDVFKaSuMp8L5zWplC149YlqCLDO46D2o+bG3qHyrOIrUyanu9nfaBq5Z9u6OX+
         Bu8wIpp27FYsMOBb/aNtjx3k120YqgfNF8w4wqV7nWka7och4jugEJP9w1WqK9AdjxlT
         /hOifF0TchdYcSXU4NdE1of49eaK2HxwUF4V7WZhrt+nhHPk6Nb5NzEPR6BZ39JJMt7R
         lY0PR/Ypkr8qmXT7glrlNwnDSuTNwODJ1smlmjYwW24+gW1VKRJBl/GvyGG7RvEXwnpj
         PofHeCdPETrCIXVBFyM6CRGFxfHWdcGypLFq+aUI+r5HJwt6BxqGQr/NkbR11YZaexbe
         BIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691787058; x=1692391858;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3jqJojQwGIq+MbCn3Pj9qfGFrLvfGPKUQcVkXP9fboM=;
        b=DSEYywLBdpdxmm2NTkucKVyIpj9O3U/4XN/EAidCN+iIfSFh1YzbU2muDmM3+Ep+97
         CJZZLG42XXYT11+2KvTrpsBWkEBd0GAGT+HyC0kQHLfm9SfYGu+S8GePGesL6FJWrBCz
         3lxpDOWpq0B627OggyR2gPDy4/fMw760zWTg1YEjEE+a8UK1mdEWnXIOTAeGtUZ0YM6S
         smFiBYfKJxEUYsWfEoHrI7FRCrO60+iQqaPcVUlVkAQeT7O7DDRxXA+1bO+OzPhcZ+s7
         OSh591imVu+Q1I+OyIUchdER9DEQspBH76nfQlx9wGTMUsnXzdBefrq/QeNqpxQS9R71
         VJlA==
X-Gm-Message-State: AOJu0YyzW/t8RRq8VgqaMorOwvwCophNyseNhIHT0MMkOBvU05+Xxy5+
        e+GuugOwoAUdvme1mfbK49mxlA==
X-Google-Smtp-Source: AGHT+IH0hhbtty9vT+TeG2QntORrbeXlcZhcz/Q6BxEU88bKOnfFh8w4K3jurXe77Op8sXmuYkKT0Q==
X-Received: by 2002:a05:6512:3452:b0:4fe:15b5:a5f9 with SMTP id j18-20020a056512345200b004fe15b5a5f9mr2048837lfr.54.1691787058307;
        Fri, 11 Aug 2023 13:50:58 -0700 (PDT)
Received: from [192.168.1.101] (abyj188.neoplus.adsl.tpnet.pl. [83.9.29.188])
        by smtp.gmail.com with ESMTPSA id w26-20020a19c51a000000b004fb964d48e6sm858285lfe.95.2023.08.11.13.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 13:50:57 -0700 (PDT)
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
Subject: [PATCH 0/3] Introduce PRNG on SM8450
Date:   Fri, 11 Aug 2023 22:50:55 +0200
Message-Id: <20230811-topic-8450_prng-v1-0-01becceeb1ee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC+f1mQC/x2NWwrCQAwAr1LybSDbVl28iojsI20DJV2yKkLp3
 V38nIFhdqhswhVu3Q7GH6myaQN36iAtQWdGyY2hp34g7xy+tiIJ/XimZzGd8RImIn8dchwztCq
 GyhgtaFpap+91bbIYT/L9b+6P4/gBWBV7FnYAAAA=
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Cc:     Marijn Suijten <marijn.suijten@somainline.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@linaro.org>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1691787056; l=888;
 i=konrad.dybcio@linaro.org; s=20230215; h=from:subject:message-id;
 bh=achINi13s2oBouycijFvJmTS8jFnC3XtwNFEu/25/9I=;
 b=TsC/xrTi+lazROIHVs6x9cO4a9GqYA13OfLaqe0W1JMsaPXXxGezBGPM3CTF2/X4nRy1nnK3z
 YIZ4j8k9kj1CGBz8wPh0gQjRphAFSgXMOlp99Vur885oeRRtRbzjxEF
X-Developer-Key: i=konrad.dybcio@linaro.org; a=ed25519;
 pk=iclgkYvtl2w05SSXO5EjjSYlhFKsJ+5OSZBjOkQuEms=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SM8450's PRNG seems to be the same good ol' IP, except without a core
clock.

For a lack of a better idea on how to test it, /proc/crypto reports that
the selftest has gone through..

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
---
Konrad Dybcio (3):
      dt-bindings: crypto: qcom,prng: Add SM8450
      crypto: qcom-rng: Make the core clock optional regardless of ACPI presence
      arm64: dts: qcom: sm8450: Add PRNG

 .../devicetree/bindings/crypto/qcom,prng.yaml      | 24 +++++++++++++++++-----
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |  5 +++++
 drivers/crypto/qcom-rng.c                          | 10 +++------
 3 files changed, 27 insertions(+), 12 deletions(-)
---
base-commit: 21ef7b1e17d039053edaeaf41142423810572741
change-id: 20230811-topic-8450_prng-6af00873db4d

Best regards,
-- 
Konrad Dybcio <konrad.dybcio@linaro.org>

