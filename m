Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D23DC83F17
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Aug 2023 08:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjH1IGC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Aug 2023 04:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjH1IFZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Aug 2023 04:05:25 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B73C195
        for <linux-crypto@vger.kernel.org>; Mon, 28 Aug 2023 01:05:17 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-401b393ddd2so27471475e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 28 Aug 2023 01:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693209915; x=1693814715;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BcfV/UeCF03lYaBfVGaWErOz9xb6mzpP56XAVU5L9WU=;
        b=wQ35rCZ+mnMDVuF1Ud+9LfZHO9to7g1o19C6+f1n9m4UqrGLyo1WGRDoqYcTCw1hJA
         wRheMMBevqGNrZvybEE/idzl2Dxd4FBOfGJ3piLePPwTCIOT6KXI8L7dX2HG30ZHuzMR
         KlaJx58HqDRfPSKwPufnYybqKjS7kKHHdhLbXVhlC5/Mc+vEAWVIxGSmtqh94+t4+l2W
         RRZqWCU0uNWdapX7JOLeCmu2RsZ3/Bqf39P6OAergQ9CHIl58Vye0wpOVdBcLQQUcLBs
         m8AbGiOALEDQM4y++UUiQ0buVwB1sDQGkWgpIQay5xEbeAroxP9sZL8bCajQ48Dg6o7K
         rVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693209915; x=1693814715;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BcfV/UeCF03lYaBfVGaWErOz9xb6mzpP56XAVU5L9WU=;
        b=Gxlh9TN2iT85c3lB6Bl41OJZbCvz4vtSvCEE+ZPI2MvN6JIX7Faoryt/2TKu+VpWwi
         WCblbFYOMbPQAKpXew3osC1+tuWhzu5iz96LssxLmdOpnYohCTgjhHFno3CKfBXCLy8A
         cNoQlamIi/fC++8mouCLLi4zNUxZ/QMzypa9fgGNXaXKBYrXifMQolwWAkFtNNl7gQfQ
         PSEwCNLtVVnJudsIsJR8uJ3RW/dh6ghGB25x4QemO1k7IjVyaUU34ZGYtjX5QTdyoPNd
         M64/6gfl+n6g17OY408caCCyvPewHoUJp1/PjHB3Vi/8UdkMYF5BrWJ+VMgRDfEbHpHy
         vLIA==
X-Gm-Message-State: AOJu0YybGbD3I5tDH5GrMJrO9+WpjdV6YocFMOmN+o0xaPN5aHwi6RM4
        qA9MFv/mI54OuEKEA0mBI0XU+Q==
X-Google-Smtp-Source: AGHT+IEaSeTDCq4UIQR2vbGQlNVvUC4SZGmhnUEhDdSQRE9Dl3c1sByW2PUS5nv+cBEYo1AFZNSudQ==
X-Received: by 2002:a1c:f304:0:b0:3fe:4900:db95 with SMTP id q4-20020a1cf304000000b003fe4900db95mr20038766wmq.37.1693209915562;
        Mon, 28 Aug 2023 01:05:15 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id z16-20020a1c4c10000000b003fa96fe2bd9sm13067035wmf.22.2023.08.28.01.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 01:05:15 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Mon, 28 Aug 2023 10:04:36 +0200
Subject: [PATCH v3 1/6] Revert "arm64: dts: qcom: sm8450: Add PRNG"
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230828-topic-sm8550-rng-v3-1-7a0678ca7988@linaro.org>
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
        Neil Armstrong <neil.armstrong@linaro.org>,
        Om Prakash Singh <quic_omprsing@quicinc.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1157;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=XBF1rawv9t8Lox/h3s0QWqZEse/zdnYYb1W459yD0uA=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBk7FU3O4++6/1oeT3zoL8oGptWTdDDESBfY9/bTk5X
 dDQpW0iJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZOxVNwAKCRB33NvayMhJ0b2DD/
 4lx5GvVpFkUuE4NjITWhcFGPSoleo1LsS8SCKFUP7ZQNZGPKJ7j0jJeIOp7qUSHRhp3UZLoTg06lEJ
 4mDqsutYXqSxS652q6Zuf3yZU1MiW/SkjrCdL3FB5D5pGJ6riTZvtjCChHnajbG1bLQFHO2PIv5Zos
 ACLyONl9uqixUkAEY5sTMHz8+jAev5DQ80+29GV3nQe4WT8z1AIJJFCSXo9F+NhgVMeAou+0obo3+s
 FjtDy6IRET0lUBUt+ZxLk4BJ91FOUBtUnDcJE10KGk3Qv/TkgB48nWskNARRDtUYFhBbOcWjK94a7o
 UZyu4nS9RjejmUicDr9jDwVswD4tBNkOlJOIwrn0xlCpsXCoNEqJImdfl/0Lia12cwDkMlnDwg8k9D
 uLA/XpJM8QqMo7uvlawOCQ91VoQpbmg6JJ7jyqN8oMIJwdsjs7yC/CecEzHwgiygc90wmcWUWvzsYp
 wk7a2xoluNFLjRmQ4E4HabD5kUrVi7mCwOBBdWjozbC6E62y40REtxmyByePGK42Yc0r5cyMi9T3Ux
 eQrpWuxz4FThSJqjSxcBKGp051NhhDmt9ZdLjtX2J7FzhxCwbav8r01r6G0ee019xRZ9NgmpaipjHv
 ejeSpYVRSl9St1+3VYeNrF+1n5AI4UhFZ4+qRbMD9qEwU6ODj4++W5iZkZYw==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This reverts commit 76a6dd7bfcbb ("arm64: dts: qcom: sm8450: Add PRNG"),
since the RNG HW on the SM8450 SoC is in fact a True Random Number Generator,
a more appropriate compatible should be instead as reported at [1].

[1] https://lore.kernel.org/all/20230818161720.3644424-1-quic_omprsing@quicinc.com/

Suggested-by: Om Prakash Singh <quic_omprsing@quicinc.com>
Suggested-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 2a60cf8bd891..6ae64059cea5 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -1738,11 +1738,6 @@ spi14: spi@a98000 {
 			};
 		};
 
-		rng: rng@10c3000 {
-			compatible = "qcom,sm8450-prng-ee", "qcom,prng-ee";
-			reg = <0 0x010c3000 0 0x1000>;
-		};
-
 		pcie0: pci@1c00000 {
 			compatible = "qcom,pcie-sm8450-pcie0";
 			reg = <0 0x01c00000 0 0x3000>,

-- 
2.34.1

