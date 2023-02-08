Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3194C6FA9D
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Feb 2023 18:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbjBHSi5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Feb 2023 13:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjBHSi1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2023 13:38:27 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E812725
        for <linux-crypto@vger.kernel.org>; Wed,  8 Feb 2023 10:38:24 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id u22so8786891ejj.10
        for <linux-crypto@vger.kernel.org>; Wed, 08 Feb 2023 10:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6Xkj1uvomIqvV5vtczDqyKqzJQXhJ76whYXVbHQRUQ=;
        b=ffI3XCS4l92o9hwe5j/shy1u1L+qV168krZto2cXNR5wARnSRUoqEEqGuKyCcvKpc2
         x6IKLWAhmUysj+bBkosvaHUkjAQsSm27KQCv0jxcnEJIYc5d5J8179v5rsOww7Skrx0Y
         8ppUFoFDIjjNSiutNBDJNg+ucy0frepTp8P7zpxmSXsLH6vsa0dNmHaqOInYxVQaAzy2
         0oBUn6f2SbnWH7Ws8za68ZIaWs2eBEze2LF1WtFEw76K8FFk7mmUVmNECpCIPxwlaJJ3
         K581XZ5oRsWvUubQFoIEVIzdx0OHvce2A6eJcigRhd0LEygaVJzNXK/lhvleVjdOxyeD
         SUDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i6Xkj1uvomIqvV5vtczDqyKqzJQXhJ76whYXVbHQRUQ=;
        b=dmPsCB42Dx0uHzHCJAbxug6YCY3j8SkIaTt1dwp7zSr/kLxHWrSImq+Bb3qjD8tP8c
         DMoDTORXlDaVVs6XMzgKGAQTQvHLQDFfDs7U9p1BRtgsMZVUJeEPSv0uVuxl5OQB6q8c
         zYkuDBP4GiCwO1ZnCU5cz+/VhuQ1kmqRJ5BS6VE/ri2dELlkpOsqBFytwX0HiMA/pOSJ
         j6z5PKXYwd0aY1KdhtsJcEdQ4UfnOjlzXgnodhl9sKlw6+nBCY8DShpUOrFa0CYv8nft
         bUHP4uae673KWxXiRZ9ZezHrC11lPrhkVL/u9IpFzDUjo+gKUWfz0pw8dCPGnFR4PCo0
         ITBQ==
X-Gm-Message-State: AO0yUKXWuvinP7q8hDIJbhXiNPOVEy8oXpzEpfcndV1Ktz+fwXyBxW1T
        sp3LbQFvnNfoXPJdFV6VzzD39Q==
X-Google-Smtp-Source: AK7set8mwOxLCl0RNGRM/7A9ghZt28JBV7F4PVrkuIM0uG9foafHtvMsHOIS892LYvJsV6GrS9A7pQ==
X-Received: by 2002:a17:906:d6:b0:86e:2051:a514 with SMTP id 22-20020a17090600d600b0086e2051a514mr8339869eji.5.1675881503218;
        Wed, 08 Feb 2023 10:38:23 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id d22-20020a50cd56000000b004aaa8e65d0esm5179663edj.84.2023.02.08.10.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:38:22 -0800 (PST)
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
        linux-crypto@vger.kernel.org
Subject: [PATCH v9 09/14] arm64: dts: qcom: sdm845: update QCE compatible according to a new scheme
Date:   Wed,  8 Feb 2023 20:37:50 +0200
Message-Id: <20230208183755.2907771-10-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
References: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change the old deprecated compatible name of QCE IP on SDM845 to new
ones based on SoC name.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 9ffc0fe07c21..2cf19e4d211b 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2632,7 +2632,7 @@ cryptobam: dma-controller@1dc4000 {
 		};
 
 		crypto: crypto@1dfa000 {
-			compatible = "qcom,crypto-v5.4";
+			compatible = "qcom,sdm845-qce", "qcom,ipq4019-qce";
 			reg = <0 0x01dfa000 0 0x6000>;
 			clocks = <&gcc GCC_CE1_AHB_CLK>,
 				 <&gcc GCC_CE1_AXI_CLK>,
-- 
2.33.0

