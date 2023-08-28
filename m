Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0735C83F1D
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Aug 2023 08:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjH1IGD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Aug 2023 04:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjH1IF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Aug 2023 04:05:29 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31269191
        for <linux-crypto@vger.kernel.org>; Mon, 28 Aug 2023 01:05:22 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-401187f8071so17998925e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 28 Aug 2023 01:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693209920; x=1693814720;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UQ5Oj6dPwAeurm4890sw86MQpHuIzNsi2cFp4x5AjEw=;
        b=Or+X4HqXgab7p8Bc6QU0kgEnAZkyk8YD5tkpmqMVP2bvEoJNWb5li3w/ua17Wa1jd/
         outK8KUi4/EWIH7InY3sIrvRoi2vQUMgwwEjHIbZsjEKHqVMAioGAXIVVXNoBp11B0dp
         iXxRVbAXtdYnPNZFlu9Oe6tuBBZKW0F82AX2W9I2OUoOt2384aTCEAmkxSXVAK1Yqy6A
         4saV/a47fveFBAlMNANN4Xwi93Wli3r1T3QhL6gwkTC8I1QakAb2giP9T3b1Y9omdQBP
         my4CBxpH6LSJp3rYHVtUntPFs9TAExVdAx3pmh94j91d9VDVqaj77usIy1yvs+X439e8
         glrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693209920; x=1693814720;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UQ5Oj6dPwAeurm4890sw86MQpHuIzNsi2cFp4x5AjEw=;
        b=bA11W7fxWn2auSWJ5tD9q3HqLTyaEDK2WaYnzNwhACCmVv0yoyaGJ/hqQyFNA6jepa
         S3Z6CmGyg2RSERI1gA/QhAw/J1+DoViDSIWWfv/kdJfqmyDvBbLyNKjhO/62oZ9kYFcf
         jtE4fv0DCsFHuDtF7H8zM8rHBlQJ3TPyns4g7v3kU4uiuVgerpz5xhz4X9W16BgpsR7j
         5Hi913pr81UmT8Rg6vZMq4D9N00stZ+JTx8Zzm9A743zM/daJVLxTHKcKHRAsbLc+/n6
         31bLCZykMQHYO79G67K19qMib1BxNYCAoNvignCXOD1NgZ0/Pq+9w1/GhBIR61NU7Ujk
         Qe7A==
X-Gm-Message-State: AOJu0Yyn49tAFiSTmlzmG6ATOZ26yyBQXt/5FEW1f7VaKqkP9oTM9iO6
        Oor10r2L2uXCk0A8Vew7T1ixWw==
X-Google-Smtp-Source: AGHT+IF22r5FjSBxYy8sW/y39UnlaDyM/PsQz1C7ObZ/6JiOQheJ1wW/uoh/KdxajGS0R5jzMnWIYA==
X-Received: by 2002:a7b:c8d0:0:b0:3f6:d90:3db with SMTP id f16-20020a7bc8d0000000b003f60d9003dbmr20239679wml.3.1693209920712;
        Mon, 28 Aug 2023 01:05:20 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id z16-20020a1c4c10000000b003fa96fe2bd9sm13067035wmf.22.2023.08.28.01.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 01:05:20 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Mon, 28 Aug 2023 10:04:41 +0200
Subject: [PATCH v3 6/6] arm64: dts: qcom: sm8450: add TRNG node
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230828-topic-sm8550-rng-v3-6-7a0678ca7988@linaro.org>
References: <20230828-topic-sm8550-rng-v3-0-7a0678ca7988@linaro.org>
In-Reply-To: <20230828-topic-sm8550-rng-v3-0-7a0678ca7988@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=826;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=dDA/t5wxOksk/sHtfojL7tFaSJFH5RjxPNNhxCh91eY=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBk7FU5W5EUQDZTjl8yU1azqFvazPRpMFkFH9e8IRbS
 HclK4HWJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZOxVOQAKCRB33NvayMhJ0RkgEA
 CaTwxgg+dHEFnY+HuVmYb7WoBT39wsJ5v3o0AXAAxGVRImWgWbdsX4dLiBQCXJejUtKQjiT3IQAPag
 mSoDOIXsQLhS/huzsgkNI8IIGKzP/W2iLqdcS/IAnpaURWWlOzYTnHYAkMZasvxXXX6now3DjEZpA7
 izTFclq4PAjDclQmzt+2O3s3Z+Xp5OWMk5zhStDfN67z3woCOg6nXMBM5pvhzAwOHAJdPXONRZ3yJC
 kOtKUHnIC2xiQNxWErPpKKQNYXsY5Jy/2YrgdE3UsdaMwz51nzUgUiZL/MWYx2Fj/CCylL2KxYztyI
 INA21YyjzDmO/QYunse2P+CN3DGqr8UJEEQJEn19FMuzg5oLJxW6J+Jk+UCkjCpv8HvzWi/X7XQjYX
 4p1kG5mtmeQPZnqwPdDt0RZsprTEl7GmscLXNHtRmW4jmZyuBmHwoxRdg4oeJsX8aO5yu9YZkTs6JH
 L0K0Ib1f/m5SFcqWdq4S+EZXDWLrMDBKCWs4Da0EUs7zRHcBVVXSEEh2IHs25vRXBVmJTnLKYvWPmw
 sgcjjQOI1hozD8iwdJCpya2daexh/caJtYiuRimg8+qBAUFuWeac4uCAH34y/wwY2aoPt46aLueGVe
 QQbYd3sJPXLo7nZVwAy15mY2IIet3Vy0h0bS7bJCrrU6/37REr9/IutKXxPA==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The SM8450 SoC has a True Random Number Generator, add the node with
the correct compatible set.

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
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

