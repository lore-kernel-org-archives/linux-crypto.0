Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E476C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 10:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15E8161051
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 10:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbhKLK3c (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 05:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbhKLK3b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 05:29:31 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A41C061767
        for <linux-crypto@vger.kernel.org>; Fri, 12 Nov 2021 02:26:40 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id c32so21202277lfv.4
        for <linux-crypto@vger.kernel.org>; Fri, 12 Nov 2021 02:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I1lUFEImuTS6xFBFWY3qJycDEfssA90Wiadl9cwV/KY=;
        b=SN5wNCz61qhLX6S9xmzQp/tuUbo/f7HlCefhytENH6KMoIfL6fRMtbPgCtk/JHMU/P
         Ua+qQRraE91I3khY8ECaus5KP8rfzHo1GOZtygjDDupIo7u/CtksKAL+fpJnnQuUHP7I
         kZDhihXxN2ao+btqke65WXDaShXldpZG7qdw3/SL4YPaBOkNpDQLhEKJGC1qtCe7Vvut
         gdiFQT64oPzupgfpc4CvLZNcdHg7bPkEsqHT3oh4gHiVUoYBxF2vv+wu8l/LYEYO/GaY
         8KM0AcIk7/iLd0AonIEAvaMQlM03DAYBt0A36LMEO0c5qvWK8K8cbVAaopAL8caT6hnB
         4S8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I1lUFEImuTS6xFBFWY3qJycDEfssA90Wiadl9cwV/KY=;
        b=I0INE0nU7yON355Ad3kiYbpmbpL5TGJLdyaFxC6NQIT9i7QR8GPbEuu4YMnbdsvE1O
         Uc+MtTmPCyWDfecHLAmzv9zO9r+JKGM8EjyhpA/GH1cM3m8czcbxMhDdR2rnM4YSsWbF
         lsZXVAbcG7KdUqkKz3D/nJ/jHhHdoaOVS5YmahSJEPlZp9uculznCxHtYnB3Hft14uP5
         l1R6JTxeBpEJhHWwyTHXyq/2uFQPeCmgAinOJxeMl23zscOWF+CH+viEqZmVMTpDoHFs
         hOWdRiP2QdI/0tfhwF5e78hhkw6s8Eu+z2aTp1gRriIR2UDifTlHxpSq5A8RiBnNhn47
         QQgw==
X-Gm-Message-State: AOAM533rheUk3QjpnSuQRgnFPRfN5YG5b5LIK7CMxcQhMBi3wP5VqN1Z
        l7wI5OFTR2oyKMmK06QgM/XbAQ==
X-Google-Smtp-Source: ABdhPJwp/Tx+3AEnAfXaNU1aY7BJXXgZBpHWYS9OqshzxEYOstBe+ZyajNnEb3y5N9hSKCWV7IQ04w==
X-Received: by 2002:a05:6512:203:: with SMTP id a3mr13265360lfo.409.1636712799215;
        Fri, 12 Nov 2021 02:26:39 -0800 (PST)
Received: from [192.168.1.102] (62-248-207-242.elisa-laajakaista.fi. [62.248.207.242])
        by smtp.gmail.com with ESMTPSA id g14sm525253lfv.138.2021.11.12.02.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 02:26:38 -0800 (PST)
Subject: Re: [PATCH v5 12/22] arm64/dts: qcom: Use new compatibles for crypto
 nodes
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        stephan@gerhold.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
 <20211110105922.217895-13-bhupesh.sharma@linaro.org>
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Message-ID: <7328ae17-1dc7-eaa1-5993-411b986e5e02@linaro.org>
Date:   Fri, 12 Nov 2021 12:26:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20211110105922.217895-13-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Bhupesh,

On 11/10/21 12:59 PM, Bhupesh Sharma wrote:
> Since we are using soc specific qce crypto IP compatibles
> in the bindings now, use the same in the device tree files
> which include the crypto nodes.
> 
> Cc: Thara Gopinath <thara.gopinath@linaro.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>   arch/arm64/boot/dts/qcom/ipq6018.dtsi | 2 +-
>   arch/arm64/boot/dts/qcom/sdm845.dtsi  | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
> index 933b56103a46..f477d026c949 100644
> --- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
> +++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
> @@ -204,7 +204,7 @@ cryptobam: dma-controller@704000 {
>   		};
>   
>   		crypto: crypto@73a000 {
> -			compatible = "qcom,crypto-v5.1";
> +			compatible = "qcom,ipq6018-qce";
>   			reg = <0x0 0x0073a000 0x0 0x6000>;
>   			clocks = <&gcc GCC_CRYPTO_AHB_CLK>,
>   				<&gcc GCC_CRYPTO_AXI_CLK>,
> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> index 526087586ba4..8e7cbadff25a 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> @@ -2329,7 +2329,7 @@ cryptobam: dma-controller@1dc4000 {
>   		};
>   
>   		crypto: crypto@1dfa000 {
> -			compatible = "qcom,crypto-v5.4";
> +			compatible = "qcom,sdm845-qce";
>   			reg = <0 0x01dfa000 0 0x6000>;
>   			clocks = <&gcc GCC_CE1_AHB_CLK>,
>   				 <&gcc GCC_CE1_AXI_CLK>,
> 

and in connection to my review comment on v5 11/22 there should be done
similar changes for ipq8074.dtsi and msm8996.dtsi.

--
Best wishes,
Vladimir
