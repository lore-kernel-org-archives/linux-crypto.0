Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B08C77B60
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 19:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbjCaTzL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 15:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbjCaTzG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 15:55:06 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48E020318
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 12:55:04 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id o20so21333225ljp.3
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 12:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680292503;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aOMcoQFSkWIySigpw65oRdlyB2wMDMaHYKBxC1qWQqM=;
        b=VkNSZr2mOAHKOcAG9VE6tMt63eVoLh8ecw1/u1gxD6IDCpGY8GZdhXsI0hg0hGC+O3
         jczJ/PeqiYaLlVwlcvYYWgH2wLtCvCjhX5R2W9k1rvmcWSwDK75nb656N6S/ZM18hHoe
         rriOfXV2bY4n0wlgEgscjYUYvz51CG8C5MaaOHz533EDG5eYAZ8469mJbRQlXFMqOIC9
         yVL74+I8kfmoImdm/1WfXxdk0YxRCtlQzQ+BjpyQ+47vUyvGJnnY67w/8QPnQnKt1fI+
         uInCdSnHvDGXmH7jNyGsdVvAjVDkOQBMhBnUq/9Dc/jZZ0k4APBNS/UCPALn/sR0ldaC
         wzLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680292503;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aOMcoQFSkWIySigpw65oRdlyB2wMDMaHYKBxC1qWQqM=;
        b=HeWnA1xvE1AcGHlwQSKOlMoSVdM7/XprY56HSzLHQy11Zh9mHuWpynOTvXfwq+KRdr
         c/NP17nNAIqxa/BsYKAcX90K7Gasi8UcSOOo+0Tjy8sDmIiTZr7q6k494CNotCUT5AjF
         rr6ButfcF19QNO9EuCoTHKaBCBLlcxk1XFZyJhW+RM+3kI1XoaUpnGsXC71pag7lDaCY
         4bjgvGGewpllB4ahVyW1PfL4cUyb3TWzTbmYHqenDHsbk9J5vDnzT0530kGH/WponlGE
         72ZweCYIMAotylm5bRPdaSWH0SuWRJABgGgq839gMAjd9bnFz9W4l6eLYR7rA65BJjak
         c7CA==
X-Gm-Message-State: AAQBX9dr7fobzaRC8SV29v905FmWl2DjGCqQE/aynPlcG0qwAA1fnVNr
        Uc/qKYy4Etha5S41Iw12wzhKWQ==
X-Google-Smtp-Source: AKy350YAPaRJRZBDs1Lve1FOBrg2hkyAPTUJF+YIBzinY99phCuglBf/iMrWhggu02oH8g3z/DxolQ==
X-Received: by 2002:a2e:930c:0:b0:29f:3e2e:fbd0 with SMTP id e12-20020a2e930c000000b0029f3e2efbd0mr2913518ljh.15.1680292502952;
        Fri, 31 Mar 2023 12:55:02 -0700 (PDT)
Received: from [192.168.1.101] (abxj225.neoplus.adsl.tpnet.pl. [83.9.3.225])
        by smtp.gmail.com with ESMTPSA id y18-20020a2e95d2000000b002986d9bdecesm494911ljh.129.2023.03.31.12.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 12:55:02 -0700 (PDT)
Message-ID: <be20c226-317f-9c4b-858b-8d551eb7acaf@linaro.org>
Date:   Fri, 31 Mar 2023 21:55:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 04/11] arm64: dts: qcom: sdm845: Fix the slimbam DMA
 engine compatible string
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, krzysztof.kozlowski@linaro.org,
        robh+dt@kernel.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
References: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
 <20230331164323.729093-5-bhupesh.sharma@linaro.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230331164323.729093-5-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 31.03.2023 18:43, Bhupesh Sharma wrote:
> As per documentation, Qualcomm SDM845 SoC supports SLIMBAM DMA
> engine v1.7.4, so use the correct compatible strings.
> 
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> index 2f32179c7d1b..17a29184884c 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> @@ -5152,7 +5152,7 @@ msi-controller@17a40000 {
>  		};
>  
>  		slimbam: dma-controller@17184000 {
> -			compatible = "qcom,bam-v1.7.0";
> +			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
>  			qcom,controlled-remotely;
>  			reg = <0 0x17184000 0 0x2a000>;
>  			num-channels = <31>;
