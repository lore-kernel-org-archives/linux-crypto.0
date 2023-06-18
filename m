Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2DCEB64DB
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jun 2023 08:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjFRIhF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Jun 2023 04:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjFRIhE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Jun 2023 04:37:04 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9E418B
        for <linux-crypto@vger.kernel.org>; Sun, 18 Jun 2023 01:37:02 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-983f499fc81so307042766b.3
        for <linux-crypto@vger.kernel.org>; Sun, 18 Jun 2023 01:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687077421; x=1689669421;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CqBu5wPBLSKpT6xKjTZPHEicExKCCi3BZO99th5vmu0=;
        b=IfI28QAoO6Y19vMkOqSdshh/D7g51BT9PMVm9xXlg7mMo17+2bESmsKYK1I+u5OLB0
         D0R4gNuEpTL6u1yDfAH7fKIOsBVZbhyf8oJtrmqSg4rkoyPwCRabJKDVMrgyCV5AK3xg
         9wcXRyiPBHwjy4Tp616coNpDGxCe1xLvStRT46g6qtL6hGueMu0yjj1bUSVsperBa09t
         NmJDXQvc3CPB5EVTx1/xraCuBi0P2wsxjD8XDJi9U40Pugpb00JwT5SkPy+p48VEYL6g
         j2skJpK4AtNQiaYIGdul19ponWJc7BSXnvCWM8d0a42hOHuRk5U0WYd9duM+srSRSHyv
         FnFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687077421; x=1689669421;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CqBu5wPBLSKpT6xKjTZPHEicExKCCi3BZO99th5vmu0=;
        b=dhcNQRYxCm8oO1aXKU2fF1i1MCzp5aFYsg0LZ/mVNi1gFSngZsEqxDERZHJizjXcjW
         d9aVg3YPeg9GDtL2V9oXAZ+X71iXEY91UwFxxQHMO3D00IycDoHIsXQoCGZXDY3APOoi
         dk7P1MsnEMaSRRTPGV6ayJWFLG8uQvF6/OXVJV+IUv5Prb7erDUloezBg5T9uYnj9swV
         FDgr2ChHZz3HT4kqL8n2NEIk5uiGp8VAPYxCRkifIrlkcgV2KKvnyrPQW4RKVUQ2bWpc
         +SpP3zTgb9/AnQjUqus1Zd32Mv5uv0njgmKIt+xP1OMB1iacJXYC528YnX0Iwc6OQcCZ
         h1KA==
X-Gm-Message-State: AC+VfDxedLuPwhtifsbeA6eoztXYOBK0BrRFsYTuCQt6eptC3bhVi0Is
        aGe5K1av17/LKgWodk7Ot4Pbhg==
X-Google-Smtp-Source: ACHHUZ6D8tZRpKg4w9Sff05q/wAII4JkK1iFtnAjdeEIIbbZN0hkWuSpiteTsfq+osyb55Q4+XZMJw==
X-Received: by 2002:a17:907:1b09:b0:974:771e:6bf0 with SMTP id mp9-20020a1709071b0900b00974771e6bf0mr5372268ejc.56.1687077420866;
        Sun, 18 Jun 2023 01:37:00 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id cd10-20020a170906b34a00b0098696189722sm2578047ejb.192.2023.06.18.01.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jun 2023 01:37:00 -0700 (PDT)
Message-ID: <bfa97efc-cd3d-dee7-157f-02f2cd01ff46@linaro.org>
Date:   Sun, 18 Jun 2023 10:36:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v8 02/11] dt-bindings: dma: Increase iommu maxItems for
 BAM DMA
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org,
        stephan@gerhold.net, Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
References: <20230526192210.3146896-1-bhupesh.sharma@linaro.org>
 <20230526192210.3146896-3-bhupesh.sharma@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230526192210.3146896-3-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 26/05/2023 21:22, Bhupesh Sharma wrote:
> Since SM8450 BAM DMA engine supports five iommu entries,
> increase the maxItems in the iommu property section, without
> which 'dtbs_check' reports the following error:
> 
>   arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx224.dtb:
>     dma-controller@1dc4000: iommus: is too long
> 
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Tested-by: Anders Roxell <anders.roxell@linaro.org>
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
> index c663b6102f50..5636d38f712a 100644
> --- a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
> +++ b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
> @@ -44,7 +44,7 @@ properties:
>  
>    iommus:
>      minItems: 1
> -    maxItems: 4
> +    maxItems: 5

This needs at least 6 (sm8250).

Best regards,
Krzysztof

