Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207F7C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 20:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06DAE63236
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 20:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350674AbhKOUZE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 15:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344537AbhKOTY6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:58 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36399C05D6E6
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 10:34:14 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id t23so5281799oiw.3
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 10:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JwKaMGX//1jqQPgDQEKIqD6sj+mcxEeOUNB16V+QNig=;
        b=DFT6UQaUnkLeIQWICHLYL168uKkR+5z/D503YvheavNu5LiGXarxG6M4vUb/yuUeFD
         wBeAd1dgB4RTBrkHKWNx5vHplM5nGYRvGK6EK2v8gYF/BgYKF5TAeSn9oTYU2G9Rg6ry
         z2c4r2xISK/Vtm2nhmfSxW68yTnYiaYpGTGqkDNwXAqZgA8XmgltvNZukUt+9DrFjMuD
         r73Q4hkk7eD/v5RIcYrP/VSaMyRINws5XEqPvF3FmAvUzyfwJb0zkbwxkf2cMnq2YAGs
         CGRKPgVnuTvg6vm0+59+1YVaYaJ+91+pWkyulqApmmQzKhQUNbWlmiqQm3Q0bV+wPvMf
         llQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JwKaMGX//1jqQPgDQEKIqD6sj+mcxEeOUNB16V+QNig=;
        b=ZLiGqFDXT7jCC2KRuNn+a2K+nW9+WVGr6c3DokDtRFjwl24QNYPlZqSvRTb0bY6K+y
         UyjZmP5EweO0sgH/5/k42wc/HvOtM04w/og3qn0WlirdIApSx7BGbajUtaPTUW+PAWvB
         vzCkVJtknwzT/4aUll3O1l5WCWeCt4G0BipUiprwQViPXPgejaSJLTFT40/DtHWyfO8M
         hO1MD56Yfs1o6Iz+ki4Sv/TlustIheZVtE1NRaLjCqSPmrAyHWzOK0H9PVJqnZNz4Jry
         bXfF0kwCEblfvkNsVE7eP8JN27erfGZKDzgFA0JWKZYT8Gq9/ETmFoDJFuQURVB/JtSi
         OgQA==
X-Gm-Message-State: AOAM5332RiiiYQ2x2ipJL0CJMU6XnzInzWQOSYPJlAJFq9jUwm5uaTiB
        KjV4/p/XjwPSv7u1mk+UYQ492A==
X-Google-Smtp-Source: ABdhPJxgGwtHSE6Ow+bkBcfir6vTaVoPAfAiPVhu0Xx/3q9Ecwchi5RX5V5eKCac1+SsR9K0YPHcGQ==
X-Received: by 2002:a54:4f1d:: with SMTP id e29mr47401177oiy.179.1637001253519;
        Mon, 15 Nov 2021 10:34:13 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id o2sm2821311oik.11.2021.11.15.10.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 10:34:13 -0800 (PST)
Date:   Mon, 15 Nov 2021 12:34:08 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        stephan@gerhold.net, Thara Gopinath <thara.gopinath@linaro.org>
Subject: Re: [PATCH v5 21/22] arm64/dts: qcom: sm8250: Add dt entries to
 support crypto engine.
Message-ID: <YZKoIA7kPHDaFoQK@builder.lan>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
 <20211110105922.217895-22-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110105922.217895-22-bhupesh.sharma@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed 10 Nov 04:59 CST 2021, Bhupesh Sharma wrote:

> Add crypto engine (CE) and CE BAM related nodes and definitions to
> "sm8250.dtsi".
> 
> Cc: Thara Gopinath <thara.gopinath@linaro.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/sm8250.dtsi | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
> index 6f6129b39c9c..691c28066cec 100644
> --- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
> @@ -4104,6 +4104,34 @@ cpufreq_hw: cpufreq@18591000 {
>  
>  			#freq-domain-cells = <1>;
>  		};
> +
> +		cryptobam: dma-controller@1dc4000 {
> +			compatible = "qcom,bam-v1.7.0";
> +			reg = <0 0x01dc4000 0 0x24000>;

Please keep nodes under /soc sorted by address.

Thanks,
Bjorn

> +			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
> +			#dma-cells = <1>;
> +			qcom,ee = <0>;
> +			qcom,controlled-remotely;
> +			iommus = <&apps_smmu 0x584 0x0011>,
> +				 <&apps_smmu 0x586 0x0011>,
> +				 <&apps_smmu 0x594 0x0011>,
> +				 <&apps_smmu 0x596 0x0011>;
> +			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
> +			interconnect-names = "memory";
> +		};
> +
> +		crypto: crypto@1dfa000 {
> +			compatible = "qcom,sm8250-qce";
> +			reg = <0 0x01dfa000 0 0x6000>;
> +			dmas = <&cryptobam 4>, <&cryptobam 5>;
> +			dma-names = "rx", "tx";
> +			iommus = <&apps_smmu 0x584 0x0011>,
> +				 <&apps_smmu 0x586 0x0011>,
> +				 <&apps_smmu 0x594 0x0011>,
> +				 <&apps_smmu 0x596 0x0011>;
> +			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
> +			interconnect-names = "memory";
> +		};
>  	};
>  
>  	timer {
> -- 
> 2.31.1
> 
