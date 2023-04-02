Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF991C76196
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Apr 2023 10:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjDBKI4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Apr 2023 06:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjDBKIW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Apr 2023 06:08:22 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92140B756
        for <linux-crypto@vger.kernel.org>; Sun,  2 Apr 2023 03:08:00 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ml21so2680942pjb.4
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2023 03:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680430075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3MVums2xGimULwLAksXbnkYaopPwvTqx5iwZKEFGpjA=;
        b=JT63Rdhv/c5JJ5GCMTVSXvcZVx4bC/BZrzg1L8YflrpvJhy83hlbx+Xq5LAfxEkOv6
         ws8KXu9cULU4hHrByxg/rEX4R+VQgHOj9uLYiMCpUlOdHRXkNjBePqyIAi1bD6JMvmk0
         vy2xfk7ziuSDm7zwYt9DNnhIinKUKAvTLU8/Az6Pb4LNjFI7B/5xGhGTek7OB5PZDboR
         HlYRM6Dy2upjTDMaW4QQz/dJLM9S/U177RksXavoVJGi4cTWhV/pSAoRAN/B0OXuS0xO
         FBPUzajRoqzoF/J9Y1TxkKHDM429XvjVuBnT44KlrrgCUcKfOXdMUt2gswsCoDP0yGZ6
         cizQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680430075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3MVums2xGimULwLAksXbnkYaopPwvTqx5iwZKEFGpjA=;
        b=wdHjXAoSZM5tBrPZK806E+QbNIH+NgSvBrmIfQX9ncTCONH1V2ELIlZClJ3hmIGDXD
         8tuQn1QxriH/l35S4Wna5O2li7iEMOdBFs0ZrmPRaUFBguXqY/aahaGyAZLd0etXyKO/
         Ia+aEz3k+fi2hfI4mo6f0X7OMvnft0lYI1tCaovyU7WyYiIoDoBcIWrFbfYTPoFb0N1G
         U0Bq4wLVnXVjRDX7ePpW6GLUZPP1SgOk3QksYf9ba2IdAPFqT0DHgmF/q4+X4nNwyjwY
         scfBI+nikGXNTJIfEHWtXWxi6FwYbVy74tgpQyFGPsIfdmv8uZUcBL0oNO/36qn960LY
         ZjFA==
X-Gm-Message-State: AO0yUKX/JQK9KWhvDXklTcrpIAzC1XXNSI1YklKJsn/HR5YvmAXID8pU
        C2lzbt2WkZfMwupZvtufb4FZtg==
X-Google-Smtp-Source: AK7set/a4NgE5LwbYfh0ahtKl9foMp+tcXqTh0MqHAh8T0+VmTx9clHTv5xmJZ45GCuvFvhLcIqVbA==
X-Received: by 2002:a05:6a20:1222:b0:db:a03c:713d with SMTP id v34-20020a056a20122200b000dba03c713dmr25718269pzf.23.1680430075466;
        Sun, 02 Apr 2023 03:07:55 -0700 (PDT)
Received: from localhost.localdomain ([223.233.66.184])
        by smtp.gmail.com with ESMTPSA id a26-20020a62bd1a000000b0062dba4e4706sm4788739pff.191.2023.04.02.03.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 03:07:55 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v5 08/11] arm64: dts: qcom: sm8150: Add Crypto Engine support
Date:   Sun,  2 Apr 2023 15:35:06 +0530
Message-Id: <20230402100509.1154220-9-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
References: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto engine (CE) and CE BAM related nodes and definitions to
'sm8150.dtsi'.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 9491be4a6bf0..c104d0b12dc6 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -2081,6 +2081,28 @@ ufs_mem_phy_lanes: phy@1d87400 {
 			};
 		};
 
+		cryptobam: dma-controller@1dc4000 {
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
+			reg = <0 0x01dc4000 0 0x24000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			iommus = <&apps_smmu 0x514 0x0011>,
+				 <&apps_smmu 0x516 0x0011>;
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,sm8150-qce", "qcom,qce";
+			reg = <0 0x01dfa000 0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x514 0x0011>,
+				 <&apps_smmu 0x516 0x0011>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
+			interconnect-names = "memory";
+		};
+
 		tcsr_mutex: hwlock@1f40000 {
 			compatible = "qcom,tcsr-mutex";
 			reg = <0x0 0x01f40000 0x0 0x20000>;
-- 
2.38.1

