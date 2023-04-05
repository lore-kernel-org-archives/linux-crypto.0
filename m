Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC1AC7619A
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Apr 2023 07:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbjDEHbi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Apr 2023 03:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237093AbjDEHbS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2023 03:31:18 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8F64EE5
        for <linux-crypto@vger.kernel.org>; Wed,  5 Apr 2023 00:31:10 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f22so29531952plr.0
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2023 00:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680679869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6lP0xe1rpfhrIkLyhMnO9naLS5LLel1l/TortX66fNI=;
        b=JaMs1axwgRzopOcNZli/yegR4fCkEtluCFhn7aQTV0CAyfEHR2p+08/j0RBRU3isL3
         V6xdTP2duLMfvSUdj8Fg2ukiyClbh2rwnVVDQqJ3ErHtAYnaQpVaZEY89n5S0/m4FQJQ
         XaLLY+U7mfIZmq5F+YU1+Mh2k+LjhZ8HQ/hXPneyv47FGxPfSBNMf7MDCOPYSAAH34wG
         AKiupOUELltb/jtgakeaobvQzpVrMbSb4NV7hmxeSaKB4lLr+u22LIdBniUNGwHWpAua
         soPtBzPK/K32psjpLb+SfVeq1m/T8ICbvCewNr7KIhxxHL/SomwUeEIBSGOjPQNMg6SJ
         0Eug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680679869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6lP0xe1rpfhrIkLyhMnO9naLS5LLel1l/TortX66fNI=;
        b=PfrC7eFXWQV54BWGdKgMfkCMc0JJEqMa6mR+sRw+4CcoXwgqVCr3HUyZnsLrZxolv/
         hZEYugs/OPQ7HUHKxR1uyV9Ko9EYrwWg0zyflfaWgtOS7DLqTBsw4bABVAsQY1pCJz3z
         yfsj5nuKjvDrb4UBVCt0K+7t4alKNFwSlS+0l7XBPJfIpYt3la56QDy2Bj/G4UrYXMwA
         m6aTUtShiKs8PZrpTMyHCohXYu1lXYkVGxrna+KdvzU3gb6hOd0xFsGOdMUdY86Vn6T+
         GzUKZt8NH5F1N6wr70NNfzBSKZQZQPAi1rWpTAH5EFdMhDh77QirK4Tr5d1YxHcdN0ZC
         CzaA==
X-Gm-Message-State: AAQBX9dPYpBfGnZt3DYBDbWGZWn1KhrmYo2CYVGRnJ/UFJ+t7vEePt8q
        i9r7zUIg9Fss8/s142JYR1I99w==
X-Google-Smtp-Source: AKy350YwQopALW/nSXnNj4j+Q8AncsUlQ8WIHCM0GGMBCgeyuh3Rja+To4Pj1goHjZKKp1ELj9wi7Q==
X-Received: by 2002:a17:90a:1a13:b0:23d:e0e8:f453 with SMTP id 19-20020a17090a1a1300b0023de0e8f453mr5407502pjk.38.1680679869411;
        Wed, 05 Apr 2023 00:31:09 -0700 (PDT)
Received: from localhost.localdomain ([223.233.67.41])
        by smtp.gmail.com with ESMTPSA id l7-20020a635b47000000b004facdf070d6sm8781507pgm.39.2023.04.05.00.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 00:31:09 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org
Subject: [PATCH v6 04/11] arm64: dts: qcom: sdm845: Fix the slimbam DMA engine compatible string
Date:   Wed,  5 Apr 2023 12:58:29 +0530
Message-Id: <20230405072836.1690248-5-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
References: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As per documentation, Qualcomm SDM845 SoC supports SLIMBAM DMA
engine v1.7.4, so use the correct compatible strings.

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 2f32179c7d1b..17a29184884c 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -5152,7 +5152,7 @@ msi-controller@17a40000 {
 		};
 
 		slimbam: dma-controller@17184000 {
-			compatible = "qcom,bam-v1.7.0";
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			qcom,controlled-remotely;
 			reg = <0 0x17184000 0 0x2a000>;
 			num-channels = <31>;
-- 
2.38.1

