Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D22C761A6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 16:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbjCaQpm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 12:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbjCaQpJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 12:45:09 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC0722902
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:43:51 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id iw3so21769558plb.6
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680281028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WuXrMueLRWrhHUa7fCmg8muj+EQ/U1dtVRPqyEUW0vE=;
        b=SRv8DW91VLCT1ajfXUE+834+ijiXo3QjGAkCgiaTyezW9t9SzTnTEisdXX1dAwyiqY
         NzxQsJNKu6uJ5YpenRIoU3ILkliWIC4WSdlbjH5TOP1w5wTn7qb6LxtB3zCDZrtvlksC
         Vxl4L2pj3a1DykNUFoi4eNe+1k3u5pa1m1AHwFmWBKMO/jAE74WR7gelTNQQI1nGScNM
         2b1xNwukJtTMdugKopkQt/sI7r9ty9kdpw4iZjeEIeVOeM4z16LM3rPS9FHshNiVX3vu
         v7yW3L1pOWQJiVm6gXKM6TXQ6GEymaMVmdpR6MXfOd/pfaoxDqAqilW0rX56Iyp6mZ9x
         CwYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680281028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WuXrMueLRWrhHUa7fCmg8muj+EQ/U1dtVRPqyEUW0vE=;
        b=KRO8M3WktO28TzpDm56aHZbJ8q0xGmvxSVuuELBzDh6uo0QAPn7VDWF+sKelCBpYpR
         pNoo0SBh7prwYWgoTgXVD576jkV/f3Hvpp4ePHVZydsB5X0NEfShdrJKwYZNb9r2NcSc
         I3sgKxkowTJYq6+EZzvczZXQig5ooQ1HRt7R6R7EkJMeti6aam9jkhhiUIGfFMlse4SU
         uj+BWTX71pb7aVfT1H75InPpS7Zmd0oje42GQAmZQIsFVtz6Dh2qtHB95b8jCo0PDgxX
         1In5pIe/bUd9pPWAxBqnoHn/gfPjaLPbU/TrgMDaf0WhBJT8t7T+2wGeivgQfE3OLRSn
         T8nA==
X-Gm-Message-State: AAQBX9f5BGSjxC0AWPmBgJn3Zq4SX7aNH/jChzvZ4ABslxFMnX9Akqjh
        n+wVg7DY9wifpp6lk0aEcvaouQ==
X-Google-Smtp-Source: AKy350ZmEG8WaTKOjjWRBYb2Bmn89WlVuRseq8ly3sj8tdpljeaao2CFSdPERgo86tS0AfVbsWv5KQ==
X-Received: by 2002:a17:903:2803:b0:1a1:ad71:7402 with SMTP id kp3-20020a170903280300b001a1ad717402mr23267178plb.28.1680281028271;
        Fri, 31 Mar 2023 09:43:48 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c5e:53ce:1f39:30a5:d20f:f205])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902b40d00b0019b089bc8d7sm1798767plr.78.2023.03.31.09.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 09:43:47 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org,
        Bhupesh Sharma <bhupesh.sharma@qcom-hackbox.linaro.org>
Subject: [PATCH v4 03/11] arm64: dts: qcom: sdm8550: Fix the BAM DMA engine compatible string
Date:   Fri, 31 Mar 2023 22:13:15 +0530
Message-Id: <20230331164323.729093-4-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
References: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@qcom-hackbox.linaro.org>

As per documentation, Qualcomm SM8550 SoC supports BAM DMA
engine v1.7.4, so use the correct compatible strings.

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

