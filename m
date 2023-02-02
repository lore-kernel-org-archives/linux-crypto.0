Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F2CC05027
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 13:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbjBBNvU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 08:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjBBNvH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 08:51:07 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5CD7F6B4
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 05:50:57 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id v13so2025374eda.11
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 05:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bnZ4Sd2YODcDYA7OAgTUgwmpZPLk3snZO1ph9Ml4xaw=;
        b=y5gctVTvEyV+jf6SE2ZDAH8jJMLfKnhYQYazC/xZwLoovvRhtnIldun94egmr5Vlo4
         dXSuOv6SZqmQjG/EjmqkSHIRmSBbROrnaiBaXylf8cymwsa11y0EHZ3aUafmBcORqRIb
         hWALb6fOcXjeCXgcuWlq1+vHC2JGvs3Jxzb/BObp1VwIDOiU6waPmTyyK6m9VJRpTFZO
         rk45A57DJeXaQXrIkXcvFm0KiWpd9LyQK0cEnGWKcBO/a580I1AEHXe/u5qoI5e9E0GM
         RCYNotyiHP6bSFGqU+CxI8toQ1PLZA3V+kOzC5AFo0xaz6iRzIjl07nGeAg8Nt/94Y+B
         iAEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bnZ4Sd2YODcDYA7OAgTUgwmpZPLk3snZO1ph9Ml4xaw=;
        b=7vaDZcudDztHQEGHLIbKJX30acQTbZbehfoiRGtwUAVcvs1Q1OlVKZWtJsGM65Wscj
         HMYodwf4YZc1sL5HZWvpmR1tdti1n27Di4/E8qNI5vPTfDf82rPBBi+X0mVa1YsXVeUl
         lmOvKH47HWl4flFKN61GQZVPva55ZyTt48o3vbjWRLzYknilPeMhWk9CMcN2WYBQ8xr5
         PX+s5QbzXjsrS7wyolylMaO4LgB1GqWtGtJr78DjY3ALdDtpbApRuxFWUBct6cw4qIGx
         5aOhAkGEZIL4u0a96BsEeNSqvjfXcZ6Cp8irsieiUlnCK91hk/YK0/VUpo3L8+uagN1l
         6lYQ==
X-Gm-Message-State: AO0yUKVfIFfWM4z64Os7sngoX8rq39GNbaCwp9/P3nmBFcjpDtseKZ7Q
        ymftDL2fQlZIQVWAMhPsTFip3g==
X-Google-Smtp-Source: AK7set/hwBTHqpLOwfstIVfiAKLMsbwFdgJzBBiwQPIytgA0gSi9CTKiorTNia9dedR3AI8H+fRDYg==
X-Received: by 2002:a05:6402:34cc:b0:4a2:5b11:1a51 with SMTP id w12-20020a05640234cc00b004a25b111a51mr6761353edc.2.1675345855901;
        Thu, 02 Feb 2023 05:50:55 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id r23-20020aa7c157000000b0049e1f167956sm7596332edp.9.2023.02.02.05.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 05:50:55 -0800 (PST)
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
        linux-crypto@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Jordan Crouse <jorcrous@amazon.com>
Subject: [PATCH v8 9/9] crypto: qce: core: Add new compatibles for qce crypto driver
Date:   Thu,  2 Feb 2023 15:50:36 +0200
Message-Id: <20230202135036.2635376-10-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
References: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Since we decided to use soc specific compatibles for describing
the qce crypto IP nodes in the device-trees, adapt the driver
now to handle the same.

Keep the old deprecated compatible strings still in the driver,
to ensure backward compatibility.

Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: herbert@gondor.apana.org.au
Tested-by: Jordan Crouse <jorcrous@amazon.com>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
[vladimir: added more SoC specfic compatibles]
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 drivers/crypto/qce/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 8e496fb2d5e2..2420a5ff44d1 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -291,8 +291,20 @@ static int qce_crypto_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id qce_crypto_of_match[] = {
+	/* Following two entries are deprecated (kept only for backward compatibility) */
 	{ .compatible = "qcom,crypto-v5.1", },
 	{ .compatible = "qcom,crypto-v5.4", },
+	/* Add compatible strings as per updated dt-bindings, here: */
+	{ .compatible = "qcom,ipq4019-qce", },
+	{ .compatible = "qcom,ipq6018-qce", },
+	{ .compatible = "qcom,ipq8074-qce", },
+	{ .compatible = "qcom,msm8996-qce", },
+	{ .compatible = "qcom,sdm845-qce", },
+	{ .compatible = "qcom,sm8150-qce", },
+	{ .compatible = "qcom,sm8250-qce", },
+	{ .compatible = "qcom,sm8350-qce", },
+	{ .compatible = "qcom,sm8450-qce", },
+	{ .compatible = "qcom,sm8550-qce", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
-- 
2.33.0

