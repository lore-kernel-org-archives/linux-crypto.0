Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C89C76196
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Apr 2023 13:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbjDFN6e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Apr 2023 09:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238950AbjDFN60 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Apr 2023 09:58:26 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4D693EA
        for <linux-crypto@vger.kernel.org>; Thu,  6 Apr 2023 06:58:07 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id b6so20747754ljr.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Apr 2023 06:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680789483;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=veXi6X8hXncoY1cFpYaYdFHnrA4v/kUv68rWDNLT4iU=;
        b=BCDQiASBk1BGRzDQ5Wdj7XVOd/o+REpjKRxfUPZoShop7Qd4ebGPZ7QQMJSx0EEBWk
         qQXryNJ3LDNUF7eX3xTG/A0D2gD1dAGIbs87txMkndOIp3UDtLKQGfYeXCqaHZe3EHM6
         FX50m+DmwME8g7x2XLpL3c+toFkEeTTc1V4n85r1pfasfJtgYYKk7EDbg0qKg6EbkQ3A
         1kIIz3x40Gp9+EFAxunCq6RghHzTHX+B1Ly5Mid0VRw+J+xmuMCI/pYWjmpuBcmXOucI
         I9iqewUwfL//cH/UbH2uj3G6WQ10tEbAMtJLoIgTsEuHRemXHPWed6UXHOV3eRHLUG6I
         wY7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680789483;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=veXi6X8hXncoY1cFpYaYdFHnrA4v/kUv68rWDNLT4iU=;
        b=HUB49fLe/OKSOAejLDuF9D3qpR02CUFjIhiJLw126zexI1m1gNlwietzZNuADc9uSw
         SYMsBi11CyfHDMmJWxvJYhreCX5PGlzNSnGwx3v1lofG1Y3Q4UkGXewRgBbPtCsj/Ilm
         DytPAd0KkTvL6xR5IjymSep0iDLePcjZtdMtX4cIgmKTMXllMzYlj1o9gAdXd6IxCqKh
         ChnqRhcq8JBn2OVRuyKv99uDFxefAm54splVwYp0CnigCAVCWH5y6rANoQ+QnNmRu9O/
         4KJqIad7/huYQstUda4OX8nutTEUqIKI8kB5RKa//yz4zPgDAGcDjlYY7aJbT6n+ubev
         4mhw==
X-Gm-Message-State: AAQBX9fS44pcVB35QtT12WJYOGiOy32A4+GzdkzBqq0F5I1XKuWyXmv3
        Z71oEvCkFiBVGpHKjc6Yw1uIGA==
X-Google-Smtp-Source: AKy350ZE6dBJy6A2aSVdHV4ceMB49ftIHKNRdbW1HDjL4B1qPI8/x0aA/5cnv+OfOHEmjxhjcDt1Ww==
X-Received: by 2002:a05:651c:113:b0:2a1:17f8:e904 with SMTP id a19-20020a05651c011300b002a117f8e904mr2745961ljb.4.1680789483178;
        Thu, 06 Apr 2023 06:58:03 -0700 (PDT)
Received: from [192.168.1.101] (abxh37.neoplus.adsl.tpnet.pl. [83.9.1.37])
        by smtp.gmail.com with ESMTPSA id v11-20020a2e924b000000b00299ab2475ebsm300064ljg.1.2023.04.06.06.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 06:58:02 -0700 (PDT)
Message-ID: <9ecbea6a-d7bd-0f4d-e94f-dd1130e578c7@linaro.org>
Date:   Thu, 6 Apr 2023 15:58:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 08/11] arm64: dts: qcom: sm8150: Add Crypto Engine
 support
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, krzysztof.kozlowski@linaro.org,
        robh+dt@kernel.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org
References: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
 <20230405072836.1690248-9-bhupesh.sharma@linaro.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230405072836.1690248-9-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 5.04.2023 09:28, Bhupesh Sharma wrote:
> Add crypto engine (CE) and CE BAM related nodes and definitions to
> 'sm8150.dtsi'.
> 
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/sm8150.dtsi | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
> index 9491be4a6bf0..c104d0b12dc6 100644
> --- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
> @@ -2081,6 +2081,28 @@ ufs_mem_phy_lanes: phy@1d87400 {
>  			};
>  		};
>  
> +		cryptobam: dma-controller@1dc4000 {
> +			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
> +			reg = <0 0x01dc4000 0 0x24000>;
> +			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
> +			#dma-cells = <1>;
> +			qcom,ee = <0>;
> +			qcom,controlled-remotely;
> +			iommus = <&apps_smmu 0x514 0x0011>,
> +				 <&apps_smmu 0x516 0x0011>;
> +		};
> +
> +		crypto: crypto@1dfa000 {
> +			compatible = "qcom,sm8150-qce", "qcom,qce";
> +			reg = <0 0x01dfa000 0 0x6000>;
> +			dmas = <&cryptobam 4>, <&cryptobam 5>;
> +			dma-names = "rx", "tx";
> +			iommus = <&apps_smmu 0x514 0x0011>,
> +				 <&apps_smmu 0x516 0x0011>;
Downstream uses these (sid, mask) combos:

qcedev:
0x0506 0x0011 
0x0516 0x0011 // equal to 0x506 0x11

qcom_cedev_ns_cb:
0x512 0
0x518 0
0x519 0
0x51f 0

Shouldn't we use them too?

Konrad

> +			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
> +			interconnect-names = "memory";
> +		};
> +
>  		tcsr_mutex: hwlock@1f40000 {
>  			compatible = "qcom,tcsr-mutex";
>  			reg = <0x0 0x01f40000 0x0 0x20000>;
