Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D694C77B61
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Mar 2023 13:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbjC0NsN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Mar 2023 09:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbjC0NsB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Mar 2023 09:48:01 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1573C28
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2023 06:47:56 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id eg48so36365755edb.13
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2023 06:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679924876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lTn5F189KIeSyouIqB7oUGZ+SeBBT4oUoo83nt/2Gcg=;
        b=oxhUElUHmPdIZTLZrDwdo1G7diHSpjN4uhtVEx/rynJrJvnifbjEJyBaFRw6dJN1XG
         1sAsirN3LenRaebtJdzlJ2p/hJATZV0uIK9Cf3syLngE9i4R00qgs4w9hRn/pfWEDmHB
         1yCdfZmXv2MAR5eZdj4OsYjpj2MJ6wVT61CFxGkrO6sapaQ5yEdxNmNnT5WJXg/OHNNH
         GxCvenTPn9+xWbvYzsRG/P/z2PT8el57LZXdUL7y9sd2itqlUELVt8RnJFkg0HQDXaIF
         25/IPOTWt4+PT+4XDzNK1IYITRDfn8+K0kALNcCvOeum3vK0gNjPkfSmMpnkPADFujwh
         2Ldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679924876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lTn5F189KIeSyouIqB7oUGZ+SeBBT4oUoo83nt/2Gcg=;
        b=k/zlEdteVrqV58IxqQRkm9+O1ryJeCPqF5gisN2h5k599fpR4KnxiLC47D6GmCTjar
         d5KuNx18lvmu8mO7CeFHxNpvqZ9hTIzBnXZkOkIYSegm8SfqTtnsrHfj8gcajWD7hZmC
         hJDI+l3E/8mfeHcF9lAYmpUO6BBGJV+FdwJb7IZxq7AYmOQkD0hpAqVozH9AFNFotw14
         WO1WRW3S6dj3qkGQYQtbHcydZmWlasY41acptKAr9CAkxLESni4uS8YraWQquUEencJO
         IYru/57TqtOnxeXIBHuRrSInAU2dp3qBX/CLuM/7lfg3YZJs56zdEHC1DfXZksQS+QRc
         1qLA==
X-Gm-Message-State: AAQBX9fNMNFPC1RMBtGwoj3qB2RKCIlNcykrsusPyWea4W8uhhMA0oHa
        mBP6srxHKW40c2uNMnfwQBVPow==
X-Google-Smtp-Source: AKy350ZibMohoGFEowWAQx58zdQHFHlGZBRmO/0/lGjWGv5kIFkFtZCQNW3hEXg9RNgGC0ba29s01g==
X-Received: by 2002:a17:906:6dd7:b0:931:c99c:480 with SMTP id j23-20020a1709066dd700b00931c99c0480mr12763873ejt.69.1679924876049;
        Mon, 27 Mar 2023 06:47:56 -0700 (PDT)
Received: from localhost.localdomain ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id n7-20020a509347000000b005023ddb37eesm2394303eda.8.2023.03.27.06.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:47:55 -0700 (PDT)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH v4 7/7] arm64: dts: qcom: sm8550: Add the Inline Crypto Engine node
Date:   Mon, 27 Mar 2023 16:47:34 +0300
Message-Id: <20230327134734.3256974-8-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327134734.3256974-1-abel.vesa@linaro.org>
References: <20230327134734.3256974-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for UFS ICE by adding the qcom,ice property and the
ICE dedicated devicetree node. While at it, add the reg-name property
to the UFS HC node to be in line with older platforms.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
---

The v3 (RFC) is here:
https://lore.kernel.org/all/20230313115202.3960700-8-abel.vesa@linaro.org/

Changes since v3:
 * none

 arch/arm64/boot/dts/qcom/sm8550.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index c6613654942a..dcfbbf33663a 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1889,6 +1889,7 @@ ufs_mem_hc: ufs@1d84000 {
 			compatible = "qcom,sm8550-ufshc", "qcom,ufshc",
 				     "jedec,ufs-2.0";
 			reg = <0x0 0x01d84000 0x0 0x3000>;
+			reg-names = "std";
 			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&ufs_mem_phy>;
 			phy-names = "ufsphy";
@@ -1932,9 +1933,18 @@ ufs_mem_hc: ufs@1d84000 {
 				<0 0>,
 				<0 0>,
 				<0 0>;
+			qcom,ice = <&ice>;
+
 			status = "disabled";
 		};
 
+		ice: crypto@1d88000 {
+			compatible = "qcom,sm8550-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0 0x01d88000 0 0x8000>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+		};
+
 		tcsr_mutex: hwlock@1f40000 {
 			compatible = "qcom,tcsr-mutex";
 			reg = <0 0x01f40000 0 0x20000>;
-- 
2.34.1

