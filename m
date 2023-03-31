Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E003AC761A6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 19:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbjCaTzC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 15:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjCaTzB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 15:55:01 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DB01D2F4
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 12:54:58 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id s20so3957063ljp.7
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 12:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680292497;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R6Wa2EnpF34LgvveW3IVoHFJpoC0G9OylXTyrH0K+dM=;
        b=dNV6n8RFal1AEz1MeUBkwtxsIzr5W9eg4J6TTJXuk9W4/xeIWcBVnecPdUZqVLOLf1
         h4EfpqmxV4mfcDFYS0avSFBSTAjo9QqnqSBwqxaX7JNggqoEVrFizWMjYKIuuK/4jut/
         C7T9VEOfn3Sj/ZuignsPWWWIqDszjEvlX8pL9pgNak2Ydha8KI9J+ZIkx4pmQl2ddR8C
         IryhxZzUWU0DHMxxv4WsuunkTPN1Mse3qpEow4J36KZKuHZw8xTxwniizYXVX/NkGIAO
         pzFJxM0oILHtK1DBDbDPE0gSpLJK9x88sQX7FRaCgVKdkOgQ5X19uC2fmaKV9GHd1hgo
         M+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680292497;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R6Wa2EnpF34LgvveW3IVoHFJpoC0G9OylXTyrH0K+dM=;
        b=Bega5cfA/WOT0jZke6QPg5ekqK/h+d+F8E1lxQ1abtNGWT5McXtYh27YRr5rv8hg6V
         51pwHI7vDZjYVkwKHa/x8xAW2BVRlRwN5WiTx5l676W1zty56Kb9Ah5UJM9Z1Fp8jGhe
         WT9V6PBMyUXqOQZnSn8sRqJ9U0jx1Qzwg3t4bk19M0Fqv0CahuL6LXUhIhdizB/9M26o
         tsI0VWAGxR+Swm8TnehK7+Y2qSuvm6lyGpWcHERnmBf82ZoqUNWPlPi2RtWe5DtCTvqN
         9ENbcG1cGjwoRA8zUXAnO3lehFO44bL72KI4px2VQX+94qIk1KwsXXQFglwN4Knde8Sj
         X9pQ==
X-Gm-Message-State: AAQBX9cYt13dYSpaLeY6+05mELzK3Re7cjQlCVky0OUizyPG3F8TfOvD
        8rbRUkbkFmZbt5MHQJ0K712n0A==
X-Google-Smtp-Source: AKy350aWTea+C6DsL0gAE79uwlsUkI2jyhCUtMUNJYht0xgcWLWAX/iBAEdjVwdVHesotkac92rsdA==
X-Received: by 2002:a2e:9d18:0:b0:29a:fbca:e8a8 with SMTP id t24-20020a2e9d18000000b0029afbcae8a8mr7862371lji.19.1680292496974;
        Fri, 31 Mar 2023 12:54:56 -0700 (PDT)
Received: from [192.168.1.101] (abxj225.neoplus.adsl.tpnet.pl. [83.9.3.225])
        by smtp.gmail.com with ESMTPSA id u7-20020a2e8547000000b00295a8d1ecc7sm494987ljj.18.2023.03.31.12.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 12:54:56 -0700 (PDT)
Message-ID: <414b659a-888f-b31e-de90-79f81491580a@linaro.org>
Date:   Fri, 31 Mar 2023 21:54:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 03/11] arm64: dts: qcom: sdm8550: Fix the BAM DMA
 engine compatible string
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, krzysztof.kozlowski@linaro.org,
        robh+dt@kernel.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org,
        Bhupesh Sharma <bhupesh.sharma@qcom-hackbox.linaro.org>
References: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
 <20230331164323.729093-4-bhupesh.sharma@linaro.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230331164323.729093-4-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 31.03.2023 18:43, Bhupesh Sharma wrote:
> From: Bhupesh Sharma <bhupesh.sharma@qcom-hackbox.linaro.org>
> 
> As per documentation, Qualcomm SM8550 SoC supports BAM DMA
> engine v1.7.4, so use the correct compatible strings.
> 
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
> index 9c24af40ee61..774e3295081c 100644
> --- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
> @@ -1841,7 +1841,7 @@ pcie1_phy: phy@1c0e000 {
>  		};
>  
>  		cryptobam: dma-controller@1dc4000 {
> -			compatible = "qcom,bam-v1.7.0";
> +			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
>  			reg = <0x0 0x01dc4000 0x0 0x28000>;
>  			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
>  			#dma-cells = <1>;
