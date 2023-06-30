Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91112C0015E
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 08:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjF3Ia1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 04:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjF3IaZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 04:30:25 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3941D1FE3
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 01:30:21 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-55b5a3915f5so680933a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 01:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688113820; x=1690705820;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IylOOlS5ad80V9wYkTvlltIZ1alSaalCsW6vNzoqxCE=;
        b=w1n2X6SwuQTGf40ACuJOa3mBnZ6ZkpTXgN9WgWekcgA9wX8DhnWHIvrr/ntVep8Wfx
         xxgnSrGUku9qrt5TAFiqidVe8dfAzB7z8BGj0BthdVH6Fk7veTxovV3SqntFhLwev/Xa
         eUnJHfSZnVCkgbMzzE26Gxlda3H0ztt2I/95FfE803JDRp7pjeSO9jnZ3BLSXJludS5H
         yQtKkttWWKnagkVjdx8eHyDXlneyKqjT6bWj5R/9iUy1xW+l0s6qCRI+zleuBgi9kTQn
         U6yVyv6y2eeuryVrYLzfAODmlTygbytKVYCG0m/woa92+yDWDiaLEU2bdxcTFVaqGJz+
         AhUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688113820; x=1690705820;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IylOOlS5ad80V9wYkTvlltIZ1alSaalCsW6vNzoqxCE=;
        b=fOuqiHVI5CbJUsAe7RFFRJc9Fx512hhAsdX4/SzPALGKnDbSniAubhxznWFpBIC0BA
         mSjA8Hde2CH+I/fXL32GV1lu5/G6CboMHfVqI/JBqGPAYxTdVcjYiAo/n/bWLe6GDGpX
         3/mNMk9yPomVgQAAHFhggojkrNjup3xxRmQUkUxoVwqFqLV+5yTzHKL0QqMJ8p10sILV
         2OuP1FDN0AGqyU8r27b5TdLGqKzfINzeoLeQYfumJdRSHtRQkFz+OQDBbj080e9ousAj
         sRx8l4sLkLW+SXC7xaqWSfjrXaqtQiHMX6R7vSVd+eFWoHPSwSIp6j4T4/Oy/mYAXu+o
         4FSA==
X-Gm-Message-State: ABy/qLY84BncNf02nRYLm2ncE9EcjDnGsfWfYW47Ku2xjMAMKMYj1yFe
        e5XcoqmeLnBYaU9n7E4+s3Kd/w==
X-Google-Smtp-Source: APBJJlFwGdFpxh5lh0GMjOfiQCZJY9c+/4qoU0guVGErEKUDZanZB/3Rl1aCMaiF991mJDNpY11l/w==
X-Received: by 2002:a17:90b:954:b0:262:fc42:c7bc with SMTP id dw20-20020a17090b095400b00262fc42c7bcmr1366282pjb.32.1688113820036;
        Fri, 30 Jun 2023 01:30:20 -0700 (PDT)
Received: from [192.168.1.4] ([223.233.68.54])
        by smtp.gmail.com with ESMTPSA id x8-20020a17090a6b4800b002635db431a0sm2023231pjl.45.2023.06.30.01.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jun 2023 01:30:19 -0700 (PDT)
Message-ID: <f14c00e4-d0d2-17cd-da8c-5632558f53b9@linaro.org>
Date:   Fri, 30 Jun 2023 14:00:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v8 01/11] dt-bindings: dma: Add support for SM6115 and
 QCM2290 SoCs
To:     Vinod Koul <vkoul@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        dmaengine@vger.kernel.org, agross@kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        andersson@kernel.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org,
        stephan@gerhold.net, Rob Herring <robh@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
References: <20230526192210.3146896-1-bhupesh.sharma@linaro.org>
 <20230526192210.3146896-2-bhupesh.sharma@linaro.org>
 <CAH=2Ntx+4F+ZP_Y+=e4p9rdTRQV8FHaepJCyqVFtWUPjDehoNg@mail.gmail.com>
 <ZIHKWYMs1e/rOez0@matsya>
Content-Language: en-US
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
In-Reply-To: <ZIHKWYMs1e/rOez0@matsya>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/8/23 6:02 PM, Vinod Koul wrote:
> On 29-05-23, 11:43, Bhupesh Sharma wrote:
>> Hi Vinod,
>>
>>> On Sat, 27 May 2023 at 00:52, Bhupesh Sharma <bhupesh.sharma@linaro.org> wrote:
>>>
>>> Add new compatible for BAM DMA engine version v1.7.4 which is
>>> found on Qualcomm SM6115 and QCM2290 SoCs. Since its very similar
>>> to v1.7.0 used on SM8150 like SoCs, mark the comptible scheme
>>> accordingly.
>>>
>>> While at it, also update qcom,bam-dma bindings to add comments
>>> which describe the BAM DMA versions used in SM8150 and SM8250 SoCs.
>>> This provides an easy reference for identifying the actual BAM DMA
>>> version available on Qualcomm SoCs.
>>>
>>> Acked-by: Rob Herring <robh@kernel.org>
>>> Tested-by: Anders Roxell <anders.roxell@linaro.org>
>>> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
>>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>> ---
>>>   .../devicetree/bindings/dma/qcom,bam-dma.yaml | 20 ++++++++++++-------
>>>   1 file changed, 13 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
>>> index f1ddcf672261..c663b6102f50 100644
>>> --- a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
>>> +++ b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
>>> @@ -15,13 +15,19 @@ allOf:
>>>
>>>   properties:
>>>     compatible:
>>> -    enum:
>>> -        # APQ8064, IPQ8064 and MSM8960
>>> -      - qcom,bam-v1.3.0
>>> -        # MSM8974, APQ8074 and APQ8084
>>> -      - qcom,bam-v1.4.0
>>> -        # MSM8916 and SDM845
>>> -      - qcom,bam-v1.7.0
>>> +    oneOf:
>>> +      - enum:
>>> +          # APQ8064, IPQ8064 and MSM8960
>>> +          - qcom,bam-v1.3.0
>>> +          # MSM8974, APQ8074 and APQ8084
>>> +          - qcom,bam-v1.4.0
>>> +          # MSM8916, SDM630
>>> +          - qcom,bam-v1.7.0
>>> +      - items:
>>> +          - enum:
>>> +              # SDM845, SM6115, SM8150, SM8250 and QCM2290
>>> +              - qcom,bam-v1.7.4
>>> +          - const: qcom,bam-v1.7.0
>>>
>>>     clocks:
>>>       maxItems: 1
>>> --
>>> 2.38.1
>>
>> Bjorn has applied the dts patches from this series to his tree.
>> As suggested by him, can you please pick patches [PATCH 1/11] and
>> [PATCH 2/11] from this series via the 'dmaengine' tree.
> 
> I dont have this series in my inbox or dmaengine pw
> 
>> Seems some Cc fields got messed up while sending the patchset, so
>> Cc'ing the dmaengine list again.
> 
> not just list but mine too..
> 
> Please rebase and resend

Sure, I have sent a v9, which can be seen here: 
<https://lore.kernel.org/linux-arm-msm/20230630082230.2264698-1-bhupesh.sharma@linaro.org/>
Please help review.

Thanks,
Bhupesh
