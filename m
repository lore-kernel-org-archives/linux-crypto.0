Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAB5C7619A
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Apr 2023 10:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjDBKHs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Apr 2023 06:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjDBKHj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Apr 2023 06:07:39 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05157EB4A
        for <linux-crypto@vger.kernel.org>; Sun,  2 Apr 2023 03:07:33 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id le6so25370967plb.12
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2023 03:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680430053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=USgI5KIZDkQs51mZEs919xqTD9B9rGrh5rzRG7rRJwk=;
        b=YeX5UOWgQVGmyrhzZ82cTpIyfrmjqONY0Izo9vYzx+DIl+ysHX0IUrDNroGzdQhC1b
         V7ZpjcPuaRBdboghC2/llLIRhmWelBv6cNiegWV92y56zn8Z7QIgxzxJW7Bw5ZSYlV/G
         klZ5spVywHCcB+GrHwmDWCM3VTOR0O4NlAXuecdP5LAFaMKn6l9GaOEI8KuqjYU1kedp
         QFc7b0U+GnVN+A1mqxI8VyOwVibEj+tX2546JmvY15j0M9EerqvH7JJENdt6matbuImH
         q8SEWeTy7z0w1lAijqJqzX0fr04y4/DK41M4wETghn8L0i1J4N1+WKRPSrrIiBhW2A4s
         HH8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680430053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=USgI5KIZDkQs51mZEs919xqTD9B9rGrh5rzRG7rRJwk=;
        b=iyN6dJy6nnvnyvOxgrKMG4ryPy8d5sqWXNVEELLyL7F8nUEYGLvLO4B4qOqFRJeVq3
         g3E1UwQpZiBJy6Nn0Och3MOA5lPBtE79/kd7LCAh1BzroyDaardnWaD7YxeG0HDV8GJG
         f2Rpi4e9a8wWizgHRFNEsZA63hKBghdr1gvxH6mdaomqANzs+3nCumMwxCXI1Rad8BAf
         UPM9XVR8u1pNKAUEMUUjcBgXwHUMJyNFDb9GKZar6eCsJQE6LVI9/PeiiFkPQEOEM/qw
         Ei4VF3DwRTVLz+77xK6fmsGR4iFYyBo1zs8IutSyVtvPQIK2bfIcEcidqr9IhK9sMDFc
         oCFw==
X-Gm-Message-State: AO0yUKV9y2Fxz3WHyvz8y6JzF66qEKuBhwehVY1mRjNQ5qlypACgIcZU
        E1Thlr/kWcmEXxrjn1NayLDVIA==
X-Google-Smtp-Source: AK7set/T2Icgl7ZAgzNyL1bUT+Wuz1wyVIKtq9f04c/4z33KwkgzYXP0AI15bomvnQL1/FoaY1aL2w==
X-Received: by 2002:a05:6a20:4f24:b0:da:6c0b:c3b0 with SMTP id gi36-20020a056a204f2400b000da6c0bc3b0mr26146909pzb.39.1680430053128;
        Sun, 02 Apr 2023 03:07:33 -0700 (PDT)
Received: from localhost.localdomain ([223.233.66.184])
        by smtp.gmail.com with ESMTPSA id a26-20020a62bd1a000000b0062dba4e4706sm4788739pff.191.2023.04.02.03.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 03:07:32 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v5 03/11] arm64: dts: qcom: sdm8550: Fix the BAM DMA engine compatible string
Date:   Sun,  2 Apr 2023 15:35:01 +0530
Message-Id: <20230402100509.1154220-4-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
References: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As per documentation, Qualcomm SM8550 SoC supports BAM DMA
engine v1.7.4, so use the correct compatible strings.

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 9c24af40ee61..774e3295081c 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1841,7 +1841,7 @@ pcie1_phy: phy@1c0e000 {
 		};
 
 		cryptobam: dma-controller@1dc4000 {
-			compatible = "qcom,bam-v1.7.0";
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			reg = <0x0 0x01dc4000 0x0 0x28000>;
 			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
-- 
2.38.1

