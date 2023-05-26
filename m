Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C57A3C7EE2F
	for <linux-crypto@archiver.kernel.org>; Fri, 26 May 2023 20:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243272AbjEZUt7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 May 2023 16:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243481AbjEZUtu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2023 16:49:50 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664EDE7F
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 13:49:23 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f4b256a0c9so1258161e87.2
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 13:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685134160; x=1687726160;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CtQXLv6RM2qyU/OUCk91P8cjkfCSH2NoumWpYu1Uxzs=;
        b=oe2jEZLsRQkMOwyU2pOSrR3av/jnRiWrDVBPjq0ZAipX3zb81BhNCpeUmHmrBApxUT
         FDHFmm3lsPDKsPF27GHx3K4v/xpE59q2rNeKPnRXJJIEgFWCZDFTfm9nObc+QT8a3guF
         bDrhlKiJukcmp42/7POTgX2qR335EmlOHGrGNahR/tCQwFj1u5OJJRFr6qUqsivcHD7q
         Fhuct9bt86uTOv3cC4cSwAmoAsLK02AmLNaKolnjFOxxHRBYUW5mhs957RRszzk54RQJ
         xS0izSKbFmMZhnZgcbw9/mMBXm3C63FmJsP+Gg06+2uB0obD4lw3RSnci5u2IWAUNPuB
         Bd/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685134160; x=1687726160;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CtQXLv6RM2qyU/OUCk91P8cjkfCSH2NoumWpYu1Uxzs=;
        b=MAWEgktCvGIO5DVvi6GxCmsONJEZGvTu8bNeHJMpxWNpA3bx2QpmMLpl8gkTLyoCYh
         mozOuC+5QNYlpzRuoeOXHbSauYXRjATGnhr1bwwMjehUzJbPqcBjDHXs57hsEOk6SB+y
         5FC2eWjPSsJEgu4/EnEXbJdsQ+KwLR1NSXpnjiVw2yEirEtn+9xoMTxsAsV5uX8p6JoL
         fSPaz0YCfuNylfrGcfiquMJb+n4nBpnDaaVEQ4qhg3IBttTR+cNkOut+TqoeXdzpfVDa
         tvAVsY3g2qb0vkftUvhzKVSW9uqcvGejEr4pIO5PTPBO4X4EJUK5Xy6mNkDovh89Mbv7
         8DAw==
X-Gm-Message-State: AC+VfDzMEWPwxyjvMaPgbSAFR8a9hiz3RK/dNIGkREJ3Za/Ts9w21acR
        bz41Pg+Zs6Ou6CTocIu5U3j3cg==
X-Google-Smtp-Source: ACHHUZ7EK86n+2aoUVAUalgpJ72zlP2Vj+7PioVmhvTQX5TDsrB0m07KPd073r7TS4EVyTb1KSuBDg==
X-Received: by 2002:a19:551a:0:b0:4ed:b329:5d85 with SMTP id n26-20020a19551a000000b004edb3295d85mr854898lfe.15.1685134160564;
        Fri, 26 May 2023 13:49:20 -0700 (PDT)
Received: from [192.168.1.101] (abyj77.neoplus.adsl.tpnet.pl. [83.9.29.77])
        by smtp.gmail.com with ESMTPSA id e18-20020ac25472000000b004f4589808cfsm775616lfn.300.2023.05.26.13.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 13:49:20 -0700 (PDT)
Message-ID: <7db82f55-72a5-bdd6-ff87-34aefa624602@linaro.org>
Date:   Fri, 26 May 2023 22:49:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v8 07/11] arm64: dts: qcom: sm6115: Add Crypto Engine
 support
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, krzysztof.kozlowski@linaro.org,
        robh+dt@kernel.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org,
        stephan@gerhold.net, Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
References: <20230526192210.3146896-1-bhupesh.sharma@linaro.org>
 <20230526192210.3146896-8-bhupesh.sharma@linaro.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230526192210.3146896-8-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 26.05.2023 21:22, Bhupesh Sharma wrote:
> Add crypto engine (CE) and CE BAM related nodes and definitions to
> 'sm6115.dtsi'.
> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> Tested-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> Tested-by: Anders Roxell <anders.roxell@linaro.org>
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/sm6115.dtsi | 31 ++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts/qcom/sm6115.dtsi
> index 43f31c1b9d5a..2aa148340277 100644
> --- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
> @@ -663,6 +663,37 @@ usb_hsphy: phy@1613000 {
>  			status = "disabled";
>  		};
>  
> +		cryptobam: dma-controller@1b04000 {
> +			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
> +			reg = <0x0 0x01b04000 0x0 0x24000>;
> +			interrupts = <GIC_SPI 247 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&rpmcc RPM_SMD_CE1_CLK>;
> +			clock-names = "bam_clk";
> +			#dma-cells = <1>;
> +			qcom,ee = <0>;
> +			qcom,controlled-remotely;
> +			iommus = <&apps_smmu 0x92 0>,
> +				 <&apps_smmu 0x94 0x11>,
> +				 <&apps_smmu 0x96 0x11>,
> +				 <&apps_smmu 0x98 0x1>,
> +				 <&apps_smmu 0x9F 0>;
> +		};
> +
> +		crypto: crypto@1b3a000 {
> +			compatible = "qcom,sm6115-qce", "qcom,ipq4019-qce", "qcom,qce";
> +			reg = <0x0 0x01b3a000 0x0 0x6000>;
> +			clocks = <&rpmcc RPM_SMD_CE1_CLK>;
> +			clock-names = "core";
> +
> +			dmas = <&cryptobam 6>, <&cryptobam 7>;
> +			dma-names = "rx", "tx";
> +			iommus = <&apps_smmu 0x92 0>,
> +				 <&apps_smmu 0x94 0x11>,
> +				 <&apps_smmu 0x96 0x11>,
> +				 <&apps_smmu 0x98 0x1>,
> +				 <&apps_smmu 0x9F 0>;
Nit: masks should be hex (0 -> 0x0) and the 0x9F could be lowercase

Konrad
> +		};
> +
>  		qfprom@1b40000 {
>  			compatible = "qcom,sm6115-qfprom", "qcom,qfprom";
>  			reg = <0x0 0x01b40000 0x0 0x7000>;
