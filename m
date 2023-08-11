Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B23CC41513
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 20:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236789AbjHKUvI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 16:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236768AbjHKUvG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 16:51:06 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4225130F9
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 13:51:05 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4fe457ec6e7so3854549e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 13:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691787062; x=1692391862;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QB5xPzqWzKOoML0l3PVSjUAWLn+OWEjXc30hnsMTP30=;
        b=fBmCkYdDOdODeooFLeiVItqNPuPMPFnsB2sguQDoHmPAbHa7mBkfKmxoJpZXpbayW9
         yqkHuR5uj9WVDaS6qIQ3GM4Z6P6U6Z2xmkNyZTmx5a0poyfVZFHHkjB9p0GSUbSITy5T
         Vqqe/Cus5frPq6pT5Pg2jlZYCc7Mr+ZnnK8KlV7rXK0JDRVRPXCSBq5zZCiYiVSURHIc
         ggWR37h9BBUMhYCAFIot+/xPLOj35MkHl2GE3d0Taz2NnFc4D6TsByIsmDyw2wXMLNjj
         HChGL1aKNx/tKbxfCV7C+l20cp3iWPbK6NZpRE1wQACf9qpY5+wITo0V1VRLQTgRK4EB
         DVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691787062; x=1692391862;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QB5xPzqWzKOoML0l3PVSjUAWLn+OWEjXc30hnsMTP30=;
        b=WUbRw6q60Y5t3xhOj973hRDeGErsNP92tImj6zJ8AqtPJjEe2+61Kqc9qz7wYjhWmj
         paB0av/yYmb3aY3eYz+0u6DvEjPcLZ8TxwsV6Af+57DX9nOd947858cj7E+PAZ9wPI6t
         TLKpAmJ7q0z1yWazmZDLWW6VuC5a3YQlL5smH0OwCZocCB27qhG74PaNaxnF12Vh8Wrv
         B0m4jbh+VXM68F//axkcVSkLyNLlIJTNqDnTrbXnSlts1C3RUDKdC3dzzNCj+OVS5x8X
         vl+bmZc//IQJePMa8edYWjl/TWN3GNyjWumNDZ40XZNYmcZoTCDLbbCuInFSS4NgVseL
         o7sg==
X-Gm-Message-State: AOJu0YxB08Qs90MuPe5kNXn1d1XmsgTeB/wDQ6O0fRbAWS+6ACgKH5U1
        xKogN1ogfAz+T13sdqqDa5s7gA==
X-Google-Smtp-Source: AGHT+IFz+rCkKcqd0YzQc8eu1kZyDXmDzxIVaGMt3ZEHL79F0JeFtqROLu1tLVU1YdhHiMY9MUonuw==
X-Received: by 2002:a05:6512:1194:b0:4f5:a181:97b8 with SMTP id g20-20020a056512119400b004f5a18197b8mr2670689lfr.25.1691787062202;
        Fri, 11 Aug 2023 13:51:02 -0700 (PDT)
Received: from [192.168.1.101] (abyj188.neoplus.adsl.tpnet.pl. [83.9.29.188])
        by smtp.gmail.com with ESMTPSA id w26-20020a19c51a000000b004fb964d48e6sm858285lfe.95.2023.08.11.13.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 13:51:01 -0700 (PDT)
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
Date:   Fri, 11 Aug 2023 22:50:57 +0200
Subject: [PATCH 2/3] crypto: qcom-rng: Make the core clock optional
 regardless of ACPI presence
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230811-topic-8450_prng-v1-2-01becceeb1ee@linaro.org>
References: <20230811-topic-8450_prng-v1-0-01becceeb1ee@linaro.org>
In-Reply-To: <20230811-topic-8450_prng-v1-0-01becceeb1ee@linaro.org>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1691787056; l=1084;
 i=konrad.dybcio@linaro.org; s=20230215; h=from:subject:message-id;
 bh=RzvdGw3IEkgoyMi6gKDkVuP1H4j8B0h8WD5wZuY2HnM=;
 b=+9SEp37pEI+KIv4leu0konNKFkQlJyzX4N8S00ogXVAhEo4UoRef+dyDlDBl7nifWIr6voJO7
 /JIK/XDll/eBBzVyMALXSlpwdsVVy6H4VVHp417WyQtwBxZpzBR0Gx3
X-Developer-Key: i=konrad.dybcio@linaro.org; a=ed25519;
 pk=iclgkYvtl2w05SSXO5EjjSYlhFKsJ+5OSZBjOkQuEms=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some newer SoCs (like SM8450) do not require a clock vote for the PRNG
to function. Make it entirely optional and rely on the bindings checker
to ensure platforms that need it, consume one.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
---
 drivers/crypto/qcom-rng.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 72dd1a4ebac4..825a729f205e 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -173,13 +173,9 @@ static int qcom_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(rng->base))
 		return PTR_ERR(rng->base);
 
-	/* ACPI systems have clk already on, so skip clk_get */
-	if (!has_acpi_companion(&pdev->dev)) {
-		rng->clk = devm_clk_get(&pdev->dev, "core");
-		if (IS_ERR(rng->clk))
-			return PTR_ERR(rng->clk);
-	}
-
+	rng->clk = devm_clk_get_optional(&pdev->dev, "core");
+	if (IS_ERR(rng->clk))
+		return PTR_ERR(rng->clk);
 
 	rng->skip_init = (unsigned long)device_get_match_data(&pdev->dev);
 

-- 
2.41.0

