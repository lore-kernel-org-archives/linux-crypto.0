Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1860EE49BD
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Aug 2023 11:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241040AbjHXLeB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241046AbjHXLdm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Aug 2023 07:33:42 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229FD1987
        for <linux-crypto@vger.kernel.org>; Thu, 24 Aug 2023 04:33:40 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-31aeee69de0so4389389f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 24 Aug 2023 04:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692876818; x=1693481618;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u1+VydXzfxLqbKymTpC2ek/0uqcSPu9zE4cPEud2i4c=;
        b=zpVSJoV2OKTnEF/1zVaCh/yqQ080b9x0nwt7F01EzBGNMfogfM7g611Q97JS3isnRD
         rtA/CYfT3MTKMPTz3MxC8KkH79z95zeXAv9eSBswKW51hEFYWq1cRe6/GCSnnMxz6vAg
         1hbdk7KtCMyCLu+YKw4fBLJEMyet90sispYC6y2sj6zrbyHVpCRRkjseFHQXFWy/Jq3I
         LyfdJ6mUE6jCwn0uoL5snWQIYQZr0PtQtrGnn8KjUI5shgA6vJpt0MGLQeN1NKAPZePF
         eEGxscTy6RIDuLv6iUAQCvRdM1QV7QGvO5o9vuckk81IzF6H8EhDRSW2drP4BLTMjrwF
         LAwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692876818; x=1693481618;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1+VydXzfxLqbKymTpC2ek/0uqcSPu9zE4cPEud2i4c=;
        b=OVEbnA8knT7sau60FuVbY8vU9C9D9us4aDBYKG9/8qnH8CMgoQy2Sd72OSiwrZ11Zv
         NdLpFadqZHdcApvE7j791yJb6sd3LlJhKWhm5PitApNHYHkKjV5TirL1sv//b6umeybV
         9i9jbLgvHxio6Lb6j80jwQ70ChjGRPG7c8mBg5rEc4b7pnI+ghF8VQ6NuunpIY9i2Emj
         EiWD3iBSg3Hwr/cH8HC2owI4UyIZDEcSL72Smv6MWlWUXSUyX7oeESMFbF25gqKQyc7n
         qB/wtB9VIt42sC2mkJi/GIP4MoR/+q/JW0Ji9wqcdiMI/YaXf64WLBp6dNDX2UnjWDMZ
         lszA==
X-Gm-Message-State: AOJu0Yymdc7sv25Y4rAGmdYFFUyBq2pdKi9+T7Sq5JFY5JgLvRoqg7ZW
        J9Z2NoirEcjnZLPq7N/dvFDILx8iFfa4HDq712GPxKTJ
X-Google-Smtp-Source: AGHT+IH23BZ6wC+UHlfW7T/eaLxJ7f8JWRo2I+hbpN4B3h1hcfk9Qtaidv401lbLT2VCxb4+z9q1wQ==
X-Received: by 2002:adf:e40c:0:b0:31a:d551:c2c0 with SMTP id g12-20020adfe40c000000b0031ad551c2c0mr12824744wrm.57.1692876818535;
        Thu, 24 Aug 2023 04:33:38 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d65cb000000b003179d7ed4f3sm22063938wrw.12.2023.08.24.04.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 04:33:38 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Thu, 24 Aug 2023 13:33:26 +0200
Subject: [PATCH v2 7/7] arm64: dts: qcom: sm8450: add TRNG node
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230824-topic-sm8550-rng-v2-7-dfcafbb16a3e@linaro.org>
References: <20230824-topic-sm8550-rng-v2-0-dfcafbb16a3e@linaro.org>
In-Reply-To: <20230824-topic-sm8550-rng-v2-0-dfcafbb16a3e@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=771;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=m7/7ECgc0fg/dhJmabho4FQvGRAnMOFTyf9xpw4qgS0=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBk50AJMPuB4Ma/4wWIQ6Uc5MaTwp6I1znHAJiVW4s9
 1hJuwEeJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZOdACQAKCRB33NvayMhJ0ZwED/
 45gkp84ObxZzVGYOsHOcWnrEMnMXLTVDgi5lNRBTcN72PJd9lyMGRwMvMkm+k9Uno6DhbZbSazrCRk
 CjaYhP7t0jp7EUFw+C/XU9iCqY8rtaIRZUFJ9iMKzhSt+CM9+ynB75eXrcZw84kdYokNEozSN5yD3j
 Cy3LEd2ad7LT0rsV3VIa6eVF8Pb1hr6PlR2eQaCybugzfn7tCxC8+CyhbVcIxA4Iusr253aWLi/UhU
 gz4kcwxylNSlm1beOOlP657cco8eFfIcmv1DApAGlYQrFAy39LDxmsXQufiHxuFVIo5DqKxNLKS545
 0mcAzP4Ugol5IYYlDwKSOeQ2wGttaGLNvJTnGmo7jATfyi9BxVk+l07WoGduFOTaAN4jpJgOPL2X63
 IJ1Z36rD5YbUA4k0x3IH7KldQrN3WLU/NWGEWz+tRpPy3Ze3IvGdvyktECLvpIhWJ5xjG1YIQgnHl4
 oCZ8Tn7gQNPyiss8lTrrTlEXs3QmawysaaeM65usNzgjRswUEkucRVUG03sWWMllXTAXdrpL5oJrsX
 BJIUM0aG6Vl7Sw3+4kT1g0wW0LB6Fw8SDK+9i34UpKBx0sngDjU2IAiYrwI08ScCk6tYFWcsCMkce2
 K21iK5QaR/qQoDZWX6AaDwa2qiZpct/clKPdXJ7ACnmIe2KihCZ2KdW1QH3A==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The SM8450 SoC has a True Random Number Generator, add the node with
the correct compatible set.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 6ae64059cea5..e267c6286b1a 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -1738,6 +1738,11 @@ spi14: spi@a98000 {
 			};
 		};
 
+		rng: rng@10c3000 {
+			compatible = "qcom,sm8450-trng", "qcom,trng";
+			reg = <0 0x010c3000 0 0x1000>;
+		};
+
 		pcie0: pci@1c00000 {
 			compatible = "qcom,pcie-sm8450-pcie0";
 			reg = <0 0x01c00000 0 0x3000>,

-- 
2.34.1

