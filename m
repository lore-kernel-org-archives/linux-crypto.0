Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78917C7EE26
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 10:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbjESKmb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 06:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjESKma (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 06:42:30 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C947199
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 03:42:27 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2ac770a99e2so34718881fa.3
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 03:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684492946; x=1687084946;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nilYh4tuNonfXNPLqfyrtTtVqM6ehrvF3FhppFCK2n4=;
        b=ThhaOP767aviQwtWl4g5ZoJjbNr5+5uY809XowpnTqPeJ5u8hl+bRXCqxSo9ws0B9a
         AFNuKDJGfz/uRSp+yIuACwqvJu86lCa8vS4LLyCjc18lMOx6UznLGg8JKvawiKNS7KD8
         zGddNPx2NC4XPpR/Wh1tOYxVDK/faGlVYhwC7K65dKoN2/Rr9B0++4+k6xdtzR33vJrD
         xVWDbmNmh+eEv5SgvVqYTo1YOWokTH65VM/07l/X3PTJCY4krIfui41PM3A67A+PVmEe
         E99AjSAe2Gu8Cx5C8rk2Er2PVjdir1XrYX8joAz4xtFxQIzHc179/SsWzyO3ofQzx7YP
         lm1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684492946; x=1687084946;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nilYh4tuNonfXNPLqfyrtTtVqM6ehrvF3FhppFCK2n4=;
        b=CnmN/bpIESgCReieVvDC+fMN+WbB2Mydq0Rb6k5HBu53EB1TzD6EfjoipVpCOc5bpK
         15bebqRjb9GsOHiOztk3wQo7vQvBoZHWbHp8f2G7R9aoru2tz6SKk/1ckD0HDXuL5+qI
         BUIPT6z9VKaPbebUCTfF5KMOG5r05EIf+rYGWO7de48nzrO0bahm1G9Zb0AxUmR/+m7T
         X3UB8ImC5ln7Pj1EfO8a/7kq9FJ/spf+nfC2zqd35wHHbvTc24N0f9xTXcdscJEtNUlA
         gntRQnCynLpK6pAIiFVsqOnIeiTcQQoy/W/EIMf+Gl9NnPCchAb5LiibcENV00xgSzJ/
         ahNg==
X-Gm-Message-State: AC+VfDz0RjF0bY/Hy5go4OK5zFvBMvX6ntHHHuLzNv0Ubbh9L9/AHNXE
        pSmUVbz3hG4zKwDD9djHHq+jaQ==
X-Google-Smtp-Source: ACHHUZ60+I6PmnYTGWuao+AMQoNizBNTuJw504xjp9UCZE+dbov6l6wgJSxLph167q3vnzWqyAzrXQ==
X-Received: by 2002:a05:6512:146:b0:4f3:b2ce:7a15 with SMTP id m6-20020a056512014600b004f3b2ce7a15mr36549lfo.29.1684492945741;
        Fri, 19 May 2023 03:42:25 -0700 (PDT)
Received: from [192.168.1.101] (abxi58.neoplus.adsl.tpnet.pl. [83.9.2.58])
        by smtp.gmail.com with ESMTPSA id m18-20020ac24292000000b004cb14fa604csm552098lfh.262.2023.05.19.03.42.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 03:42:25 -0700 (PDT)
Message-ID: <8c754bc2-abb3-faaa-0ab5-2c1991dfc2a6@linaro.org>
Date:   Fri, 19 May 2023 12:42:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v6 07/11] arm64: dts: qcom: sm6115: Add Crypto Engine
 support
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, krzysztof.kozlowski@linaro.org,
        robh+dt@kernel.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org
References: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
 <20230405072836.1690248-8-bhupesh.sharma@linaro.org>
 <ZGdLCdSof027mk5u@gerhold.net>
 <CAH=2Ntx4H+hOzYLWqiogdBGE+rQ2XayrweE_P8T8gVE0zbwzeg@mail.gmail.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <CAH=2Ntx4H+hOzYLWqiogdBGE+rQ2XayrweE_P8T8gVE0zbwzeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 19.05.2023 12:22, Bhupesh Sharma wrote:
> Hi Stephan,
> 
> On Fri, 19 May 2023 at 15:40, Stephan Gerhold <stephan@gerhold.net> wrote:
>>
>> Hi Bhupesh,
>>
>> Not sure if this is the latest version of this series since it's pretty
>> old but I didn't find a new one. Just came here because you mentioned
>> RB1/RB2 [1] in my bam_dma patch and they don't have any BAM defined
>> upstream yet.
>>
>> [1]: https://lore.kernel.org/linux-arm-msm/CAH=2Ntw0BZH=RGp14mYLhX7D6jV5O5eDKRQbby=uCy85xMDU_g@mail.gmail.com/
>>
>> On Wed, Apr 05, 2023 at 12:58:32PM +0530, Bhupesh Sharma wrote:
>>> Add crypto engine (CE) and CE BAM related nodes and definitions to
>>> 'sm6115.dtsi'.
>>>
>>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>> ---
>>>  arch/arm64/boot/dts/qcom/sm6115.dtsi | 22 ++++++++++++++++++++++
>>>  1 file changed, 22 insertions(+)
>>>
>>> diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts/qcom/sm6115.dtsi
>>> index 2a51c938bbcb..ebac026b4cc7 100644
>>> --- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
>>> +++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
>>> @@ -650,6 +650,28 @@ usb_hsphy: phy@1613000 {
>>>                       status = "disabled";
>>>               };
>>>
>>> +             cryptobam: dma-controller@1b04000 {
>>> +                     compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
>>> +                     reg = <0x0 0x01b04000 0x0 0x24000>;
>>> +                     interrupts = <GIC_SPI 247 IRQ_TYPE_LEVEL_HIGH>;
>>> +                     #dma-cells = <1>;
>>> +                     qcom,ee = <0>;
>>> +                     qcom,controlled-remotely;
>>> +                     num-channels = <8>;
>>> +                     qcom,num-ees = <2>;
>>> +                     iommus = <&apps_smmu 0x94 0x11>,
>>> +                              <&apps_smmu 0x96 0x11>;
>>> +             };
>>> +
>>> +             crypto: crypto@1b3a000 {
>>> +                     compatible = "qcom,sm6115-qce", "qcom,sm8150-qce", "qcom,qce";
>>> +                     reg = <0x0 0x01b3a000 0x0 0x6000>;
>>> +                     dmas = <&cryptobam 6>, <&cryptobam 7>;
>>> +                     dma-names = "rx", "tx";
>>> +                     iommus = <&apps_smmu 0x94 0x11>,
>>> +                              <&apps_smmu 0x96 0x11>;
>>
>> Shouldn't you have clocks = <&rpmcc RPM_SMD_CE1_CLK> here to make sure
>> the clock for the crypto engine is on? Your binding patch (PATCH 06/11)
>> says "Crypto Engine block on Qualcomm SoCs SM6115 and QCM2290 do not
>> require clocks strictly" but doesn't say why.
>>
>> Make sure you don't rely on having rpmcc keep unused clocks on
>> permanently. This is the case at the moment, but we would like to change
>> this [2]. Adding new users that rely on this broken behavior would just
>> make this effort even more complicated.
>>
>> If you also add the clock to the cryptobam then you should be able to
>> see the advantage of my bam_dma patch [3]. It allows you to drop
>> "num-channels" and "qcom,num-ees" from the cryptobam in your changes
>> above because it can then be read directly from the BAM registers.
> 
> Thanks for pointing this out. Actually that's why I was using your
> patch while testing with RB1/RB2 :)
> 
> Yes, so the background is that I am preparing a new version of this
> crypto enablement patchset.
> Also your assumption about the clocks being turned on by the firmware
> is true for RB1/RB2 devices, so enabling them via Linux is optional as
> per Qualcomm enggs.
This is not necessarily true. Currently it's kept always-on on
by clk_smd_rpm_handoff, but that's a hack from 10 years ago when smd
was still new.

> 
> So, I am testing the new patchset right now with 'clock' entries
> provided in the .dtsi and see if that causes any issue / improvement
> (etc.)
It won't change since it's on anyway, but that won't be a given for long.

Konrad
> 
> Will come back with updates (and a new version of this patchset) soon.
> 
> Regards,
> Bhupesh
> 
>> Thanks,
>> Stephan
>>
>> [2]: https://lore.kernel.org/linux-arm-msm/20230303-topic-rpmcc_sleep-v2-0-ae80a325fe94@linaro.org/
>> [3]: https://lore.kernel.org/linux-arm-msm/20230518-bamclk-dt-v1-1-82f738c897d9@gerhold.net/
