Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC059EB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 08:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbjF3Ifo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 04:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbjF3Ifb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 04:35:31 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E681997
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 01:35:26 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1b06c978946so1492184fac.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 01:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688114125; x=1690706125;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X1Gp5Gg4BNunXsleMrsnw5ZYlJcOJJdlLO0f4lwUvf4=;
        b=Xrs9VFWohqyU/H8LwH8zZ3T5PJKsE4qUa3nULVa/uzwCY3jburveYZTEQGU4h2OdVi
         2gpznjZeJwZ+mFFYBwJ0DuOwGEnxevyhmtLIj3blRjllRP2SefPyXkWFsyjYV3Hm2vSg
         zlffKwvxP2wyofstAyEnWxEDKW3X/n+QDpZrLL6dy4BOFhzijd7OCF9tEsdZMjaSKRWQ
         DRvbj0i2QDuKvdaYibY11rt1Q87SAy+LUHvraBoa5i1Emc/eb2Rjc4I7PwiArtUP8Ufy
         gYP88iMeno5kWSJ7doGeZLv0z0fzsjGAOpLsx6/tAlrndvy6WOdHzmUz8eH2sIPBfZX6
         1s9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688114125; x=1690706125;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X1Gp5Gg4BNunXsleMrsnw5ZYlJcOJJdlLO0f4lwUvf4=;
        b=R3y159XBRqLMwSu80UUyCkzHWYHBgHUl6GPTBT+YLv6DIwmCFQkhqYBsqramGSiasO
         cy7RpcPe+kT2OzQaOmQWBt/kyo34ZY1tZ5sTVqOHQtp6MEbeLQwtNyaAhoO8e5fJMriu
         xcFCkTWY1jJYwbIn2sra2Pilb+kqqoF2OLpK8TC1WHaq7gMaYjmYDBZibICQnzChTSyM
         k5cEP8OmBiJGRVCZVOyv8MM4pYT6gbIrnovJ5Y6bPclo75rIBpugKWro8TP9VY2+kSTK
         4qPBHPUCP+IyNrxA27V416o+4kijZk3eZdsujz4xtxenWAi/PDaOae6zd3cv/wNS8J74
         hVhA==
X-Gm-Message-State: ABy/qLYhOEoAX4UexX/lC1Dr8h1IoyFz/L8JhSObzBDWujSCFWipSNRA
        9vP48xfZafvaqara4rWfFY/GSw==
X-Google-Smtp-Source: ACHHUZ41dWBdoUrDVQNrZIPi2FWG8gSP1Rq8A5pKSjChQLo4+ZXNFCQAZ1VAvbvoSvq0q3MAE0kRvQ==
X-Received: by 2002:a05:6871:8a2:b0:1b0:38f1:841d with SMTP id r34-20020a05687108a200b001b038f1841dmr2814289oaq.45.1688114125620;
        Fri, 30 Jun 2023 01:35:25 -0700 (PDT)
Received: from [192.168.1.4] ([223.233.68.54])
        by smtp.gmail.com with ESMTPSA id jx15-20020a17090b46cf00b00262e914169csm8495370pjb.12.2023.06.30.01.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jun 2023 01:35:25 -0700 (PDT)
Message-ID: <2dcfd994-2729-8780-a7aa-9a051d2fa047@linaro.org>
Date:   Fri, 30 Jun 2023 14:05:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v8 02/11] dt-bindings: dma: Increase iommu maxItems for
 BAM DMA
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
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
 <27b85110-9eb8-84dc-17a9-908e312e2e22@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
In-Reply-To: <27b85110-9eb8-84dc-17a9-908e312e2e22@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Krzysztof,

On 6/18/23 2:09 PM, Krzysztof Kozlowski wrote:
> On 26/05/2023 21:22, Bhupesh Sharma wrote:
>> Since SM8450 BAM DMA engine supports five iommu entries,
>> increase the maxItems in the iommu property section, without
>> which 'dtbs_check' reports the following error:
>>
>>    arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx224.dtb:
>>      dma-controller@1dc4000: iommus: is too long
> 
> Also, please drop error message, because it is not true. The files do
> not have such device node, so you cannot have such warning.
> 
> Please rewrite the commit msg to explain that certain devices, e.g.
> sm8250, use more iommus.

I have sent a v9 (which can be seen here: 
<https://lore.kernel.org/linux-arm-msm/20230630082230.2264698-1-bhupesh.sharma@linaro.org/>), 
which addresses your review comments shared on v8.

Please help review.

Thanks,
Bhupesh
