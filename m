Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555B1EE49A4
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Aug 2023 14:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbjHVOM5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Aug 2023 10:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236646AbjHVOMi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2023 10:12:38 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8D2E5A
        for <linux-crypto@vger.kernel.org>; Tue, 22 Aug 2023 07:12:16 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-31768ce2e81so4067472f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 22 Aug 2023 07:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692713491; x=1693318291;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gtuVpXwzMWaEGB5Cog4rldjWRfctqtTvAKEr2qA47a0=;
        b=jrsLu4OK5YNUPhALPL0I23aolOPR0gxWLbx3ArwjKaqJFKr7lrHWqM20Cw/SCIQEAt
         EK3RpfCgATOkdJZeCsUaPyXXPOI81zRnRt86ZQ9+vHZUNc0N1GKQ+wwOZO8XD1fE39NM
         r7IiKKjFomA51ccrBcdxBPsKW/q4tAywISe6wTx9f5P9iA/25oN9i40H/gv5lmB2tpG4
         A5DO9v2/70CIeNC0VkpHZOXd6h6X2cVK2gMOiJnpRBMTCpSM2AN9HY2/BdIMNoYkOTLr
         NgxVq2D0hT0JvAbJdvTvfOvCAMsNs3VQYRH9wC9kaoQT05RLp1gdb67xqmIX5b3rO2X/
         g/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692713491; x=1693318291;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gtuVpXwzMWaEGB5Cog4rldjWRfctqtTvAKEr2qA47a0=;
        b=anYU7SA1jZ0/tehheK2pdL1JwOT9NpqDt5l53NEuYOYuAASi3UN65NWj1bYXkLDhL9
         dCT/4vIN/ODJrNpg4rxhczhl5t5eOE7ZR3J5+0uQ62rf0qRGVdvYGtwu4isrTZK7VkXJ
         d25jmmibQyyl5hqVD22S47KH1paVmkZZz95x9eSz3xtBh6CeYEFGMMCYZkrn8AmRLcKf
         olFtrjD/6jahSISY/zgQ3CZzGdCY9G9KDMJhThKTdZeZNM2DvM6aqqyQE7ox1GZQGpQS
         P/gLbH0CJ6YJvTeLK2RrcGoyaQ86bRv+1gBRv2GLEUQWZPjU8DLXhT9mTi1Zm8xcjvVM
         RqEQ==
X-Gm-Message-State: AOJu0Yz7wdE3wh/G4IoZYBd+lqZqeWXnXkQfOPVSH5VBPVGMN4voeyO/
        e2Eek48r4up2wNbLyPkG7zmB5Q==
X-Google-Smtp-Source: AGHT+IG3axjvpue4qJhnlyhDa9rG2BdtfVF5SwL11Xk400+vtf82q0540IzXmG0em8nbpnu1dvRaOA==
X-Received: by 2002:adf:e6c9:0:b0:313:dee2:e052 with SMTP id y9-20020adfe6c9000000b00313dee2e052mr7424653wrm.26.1692713491002;
        Tue, 22 Aug 2023 07:11:31 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id m9-20020a05600c280900b003fe539b83f2sm19587753wmb.42.2023.08.22.07.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 07:11:30 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Tue, 22 Aug 2023 16:11:25 +0200
Subject: [PATCH 2/2] arm64: dts: qcom: sm8550: Add PRNG
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230822-topic-sm8550-rng-v1-2-8e10055165d1@linaro.org>
References: <20230822-topic-sm8550-rng-v1-0-8e10055165d1@linaro.org>
In-Reply-To: <20230822-topic-sm8550-rng-v1-0-8e10055165d1@linaro.org>
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
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=759;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=OJpdRyF5Au18OAODNZEy6fBEK+Vc+azzodyRiMN3bls=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBk5MIP76cER9EmyxruqX9NYGR6Jn0RJnTMzyheD4Ut
 zX0fxUeJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZOTCDwAKCRB33NvayMhJ0RK5D/
 4tNEi6O+SlSFOeJZvyWu1fzMBWkKIizUTOm7fYnRQ6HuLks1bVXeo7B89Mh9kQU5IZEhy0NWVe27mM
 UINmm2mFfnO55TvEWuDzMrYZK+vbMebZgpP5vif56SjEBefeasFElXR2WFEc7Vz8M73tYVRIBdn6gN
 8cXCbu1BzW0NW11RXY9r2ohM3V80Z/EsqXRJac83wboswvVIJnvbhHtHiLKaQ+AKS2TqrAe8qpF2nZ
 G/J4lu/dDFtAn4gVScbCkFlQiFDwLZgwpWhqe8ILkzEmQjLy+VFzeUlCRp7nBGsLED2gWA0BttHItC
 vQUzPJEkE3gu9mCCu50LMaJPqEqT7FFEZskGvV3XTgUB/kEdHQgu5c+RVEtUG09wK4ObAcECxMnWeS
 H/3qkHqK/h2Hunc6BIWSpDa401wht9+Yr2Dj08Ibuz6f0YkOPhdKSOh7Q7MKzwun8QL1MNr+xt25GV
 uuZoL48R90MJbqr0FClxYajfI9DvQJWLclpyKJQjccQzWR3/uAMW2TvaPmzUpHkCioVJBgLI2IWFx/
 +bAqBsN9w9qqlpK5tQ7OG2T+H85Rx0ciL/lGH2IAr3kkZLw/8VVbjyBNp2dIbYoqL26/ondxjOfy0w
 wZRT6wMn0+79AwOyS6G/aUwJTuSLGzjhp4RUPzDPqKQYIam684Azn59PKRNA==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the Qualcomm Pseudo-Random Number Generator.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index d115960bdeec..643ec80feacc 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1661,6 +1661,11 @@ mmss_noc: interconnect@1780000 {
 			qcom,bcm-voters = <&apps_bcm_voter>;
 		};
 
+		rng: rng@10c3000 {
+			compatible = "qcom,sm8550-prng-ee", "qcom,prng-ee";
+			reg = <0 0x010c3000 0 0x1000>;
+		};
+
 		pcie0: pci@1c00000 {
 			device_type = "pci";
 			compatible = "qcom,pcie-sm8550";

-- 
2.34.1

