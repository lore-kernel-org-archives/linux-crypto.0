Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2839AC433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 01:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BBEB6135A
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 01:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237211AbhEUBsg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 21:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbhEUBsf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 21:48:35 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC96CC0613CE
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 18:47:13 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id k4so7202301qkd.0
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 18:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m4x7lU1U7Nhzd1I5e57Naj6BhSC/JD8u6YQwuIwYouE=;
        b=Jv66ORDh/GUPU+ziJkeIfJao5g5k+Gn979a/+af8pXMgS21oiuBKVeO4JVq3HoYiXX
         ksOVdHjKYPObmYufYaKOZ3BO8dPeNT2g6q67R+Uw+RKO0r6ZYArypFy1dpGYkb8oi+QR
         afNiXzYbIjDyXa6gu2HD8bMwIFswPPj4dcA85oAyb1cExpDh4+K/suH2IU7cpS0SmJ19
         IFtUaoXDHHoBaSqGyzLIZGukGY2ZArBfIJ4RTZJJ341z4usaU7LXMGsx8cR9AX956ugM
         T3SmPW/qzHjW0M8W23cXKdOtX3s7eiC0muF4jv0B+ubcWj1Q8de5A3Fe+4yj9mLS5rAd
         qOwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m4x7lU1U7Nhzd1I5e57Naj6BhSC/JD8u6YQwuIwYouE=;
        b=UMNXrwz3cyHWta6JCELWxs+p9sEcnsFwHgrIIfNvIrP2BuHBWZ78SxCt+dWPZ5ZzNb
         1AJVFkZ4iVl/5T64r3/SV7jsN1g+2zHcsQYVAOC6gW0YcbVGDNNavB7pYksb1WMRYrYw
         lBTTgG4HfmA4DHs6uG6SKbB8NT/sxN5V2euf6itWrZRuFmA/xR2s2V7AthUDVh898n1W
         rmLCZGyIVhdGKFnHblU9NSjS+n0NG64YwraWOINDyPetVxTkRGLFiJ3lAPMVKjVGi0wa
         7htAP6MmYyCD0O0zJOA38WDJFI9AC7Mv0HKYoNBbQqmaupOb7e2OJ4rcH8FavOE1aTWa
         IINQ==
X-Gm-Message-State: AOAM533YAtQD3yRILoikB9Y8tTfsVi+SeJ0BkEDGR/riCcSguBWzQML9
        usRjNm994SibP4FvYeYtiqdqMg==
X-Google-Smtp-Source: ABdhPJwsz3B6Ow0zdsob/uNRAg7KYoQSta4h9ulEkAfsBE/ikkwVlrzwDK+nX2qnpzqBReNRxCgSqQ==
X-Received: by 2002:a37:8b86:: with SMTP id n128mr7761986qkd.141.1621561632844;
        Thu, 20 May 2021 18:47:12 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id a14sm3356422qtj.57.2021.05.20.18.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 18:47:12 -0700 (PDT)
Subject: Re: [PATCH v3 07/17] arm64/dts: qcom: sdm845: Use RPMH_CE_CLK macro
 directly
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
References: <20210519143700.27392-1-bhupesh.sharma@linaro.org>
 <20210519143700.27392-8-bhupesh.sharma@linaro.org>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <ead0b21e-3cf3-e882-ebef-eecf2e0a0f8c@linaro.org>
Date:   Thu, 20 May 2021 21:47:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210519143700.27392-8-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 5/19/21 10:36 AM, Bhupesh Sharma wrote:
> In commit 3e482859f1ef ("dts: qcom: sdm845: Add dt entries
> to support crypto engine."), we decided to use the value indicated
> by constant RPMH_CE_CLK rather than using it directly.
> 
> Now that the same RPMH clock value might be used for other
> SoCs (in addition to sdm845), let's use the constant
> RPMH_CE_CLK to make sure that this dtsi is compatible with the
> other qcom ones.
> 
> Cc: Thara Gopinath <thara.gopinath@linaro.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Andy Gross <agross@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Michael Turquette <mturquette@baylibre.com>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: dmaengine@vger.kernel.org
> Cc: linux-clk@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: bhupesh.linux@gmail.com
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Reviewed-by: Thara Gopinath <thara.gopinath@linaro.org>


Warm Regards
Thara

> ---
>   arch/arm64/boot/dts/qcom/sdm845.dtsi | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> index 0a86fe71a66d..2ec4be930fd6 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> @@ -2316,7 +2316,7 @@ cryptobam: dma@1dc4000 {
>   			compatible = "qcom,bam-v1.7.0";
>   			reg = <0 0x01dc4000 0 0x24000>;
>   			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
> -			clocks = <&rpmhcc 15>;
> +			clocks = <&rpmhcc RPMH_CE_CLK>;
>   			clock-names = "bam_clk";
>   			#dma-cells = <1>;
>   			qcom,ee = <0>;
> @@ -2332,7 +2332,7 @@ crypto: crypto@1dfa000 {
>   			reg = <0 0x01dfa000 0 0x6000>;
>   			clocks = <&gcc GCC_CE1_AHB_CLK>,
>   				 <&gcc GCC_CE1_AHB_CLK>,
> -				 <&rpmhcc 15>;
> +				 <&rpmhcc RPMH_CE_CLK>;
>   			clock-names = "iface", "bus", "core";
>   			dmas = <&cryptobam 6>, <&cryptobam 7>;
>   			dma-names = "rx", "tx";
> 


