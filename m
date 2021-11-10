Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D4BC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 10:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F5CB61205
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 10:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhKJLCj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbhKJLCi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 06:02:38 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA1AC061767
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 02:59:51 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id b13so2722915plg.2
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 02:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xmXHtUph5kI3A4THoshYaiB9SXE1WqSgPuWSYTceQ14=;
        b=XMGVuBzJ9Ua636COgZ7s+PAk3M23S6fAVhvJYTfxGzerPvlwM1qTsepNn8Fq4x+Y6l
         KDt/KPHMyXLN1S/Jnp9dgOm4t9KBrO+iqImjtjru4DILZdMpWzuTe/6zlOU5xA47lMpi
         me77Ax88fBqKXc9QIgb3zXEnUKJUQH+EwcbAqz6iQ9A3MYMCa3hCiw94u7G7cLB5LRm9
         UJNuznl09pdVaCuxNwWljMrhaav1Jj7QotTO9e8Vej/L4TrbyjNj9Azg0zlkztjbzbN+
         ARNq4RjsGN/AR5VMvVHAlcr5yNqbdv3Idq1GGoKd9MFWRxO0f5rNa9ZpvF9TvRyxhYbY
         albg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xmXHtUph5kI3A4THoshYaiB9SXE1WqSgPuWSYTceQ14=;
        b=ja1IPs2h/k3KeQdKUZhMtP136Z/dW8J2sT9hSJmQXaqUSYppZDSdarTFARKBD2bl/9
         K9wiI/PZKg5uYNY/L+LJjL5wOn2Sgc3gf7glN5TiKjVDF6iLl03B202eR+Ld9vtXDiug
         TTBw/2ad5JihT+TCX9GCktdvRFVWGog+KjQmeNCzfihJIdLQUqL8AktPPIyGelz9dmDb
         Zge/VpuBpTDnXpR4b1B4oSc9R5KHB2dPFQrS8BVGb7AP4+UAqCh+rTD6WJ3tYQNLsLCG
         A73jB9fT6eprGBSOtPLTSLXDCJS97lcCBCWvNdTo6cVzwvlF/1nvyVViuJGOZLEWXyrw
         pAww==
X-Gm-Message-State: AOAM533Oj/0XlHPJtaI+fucm0tpOXajYJWaXdWlkmKWDQoE+i7+EUVEN
        gkxieLS0H5RfLvTQFO5KWCkWjQ==
X-Google-Smtp-Source: ABdhPJy4ts8w7Xkiy9SPbaVv/tdNYX5gLSvj68Q0W/rZCt0biWFoqI2+HODRQOYEkFQFNXDuG/+AFA==
X-Received: by 2002:a17:902:8505:b0:142:892d:918 with SMTP id bj5-20020a170902850500b00142892d0918mr14860752plb.39.1636541991083;
        Wed, 10 Nov 2021 02:59:51 -0800 (PST)
Received: from localhost.name ([122.161.52.143])
        by smtp.gmail.com with ESMTPSA id e11sm5585282pjl.20.2021.11.10.02.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 02:59:50 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, stephan@gerhold.net,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v5 02/22] arm64: dts: qcom: msm8996: Fix 'dma' nodes in dts
Date:   Wed, 10 Nov 2021 16:29:02 +0530
Message-Id: <20211110105922.217895-3-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Preparatory patch for subsequent patch in this series which
converts the qcom_bam_dma device-tree binding into YAML format.

Correct dma-controller node inside msm8996 dts, which
leads to following errors with 'make dtbs_check':

     dma@164400: $nodename:0: 'dma@164400' does not match
     '^dma-controller(@.*)?$'

Fix the same.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 27683d7fdfe6..508cd9d06350 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -705,7 +705,7 @@ tsens1: thermal-sensor@4ad000 {
 			#thermal-sensor-cells = <1>;
 		};
 
-		cryptobam: dma@644000 {
+		cryptobam: dma-controller@644000 {
 			compatible = "qcom,bam-v1.7.0";
 			reg = <0x00644000 0x24000>;
 			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.31.1

