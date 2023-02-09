Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19DBC61DA4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Feb 2023 14:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjBIOao (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Feb 2023 09:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjBIOaW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2023 09:30:22 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586ED5EBC4
        for <linux-crypto@vger.kernel.org>; Thu,  9 Feb 2023 06:30:21 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id v13so2226208eda.11
        for <linux-crypto@vger.kernel.org>; Thu, 09 Feb 2023 06:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G8CEuoh8/tO2WNNegwThQxagifKl5T8FJBwqfoW5Qnc=;
        b=SLGQcgFTk/Q7umfCm+MrcT/2zfBfsY9XWR6t8bXBJw05C+0rMFcK4Z/xQMX6wGtpL6
         SGMPId3De6pc/g9HmwUn1T2FhUt6whVHN+xb0rcIvu0EbgFSqsiZiKyyTR6f4yRkn/Pc
         22VI8DLNLF+gAEDs0/OuwADncNQt5WrRQ61gJMlBVRyEoMAlV2TBpWSdYYYShiBwAVda
         ig1uLWuZZwelZ3DBQXFwfWw9kN3L1i/KxnEDlQ+bfdyiKRsqraRlxBMAyw4panDajrRp
         T7ht0+06i3UD1pvoI8GlZeT2Boe/2K3OGn8t/z1vZassa39GpFZgwFpfMpMBMvHSVes1
         brrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G8CEuoh8/tO2WNNegwThQxagifKl5T8FJBwqfoW5Qnc=;
        b=PRLBowv0BHyyPJM3+RNP3jy+k5B7aKSKJuwSPJBxHQb99vFxAsS3BXW1BloPxJ+4Y8
         ta0av96SePTsRm5Fru1Iiq86X5jJJicyj0el1BLDZGhMQD8clKF71tWl75cYgjoBOn18
         ub/9U0djgXQqsZi4XYG4GZn8XnKosSrWSXgT/A69qszaodDRpTuIZARb4uzTcdGwmPzm
         UVvuV1cC9E/E2OnL79Ksr6MLgdytJKbjTVYFJlXqsRmDnuMjDAwsLLwp2VDTT+3frvr/
         RINm6rVVn2HOsl/4iyH/j/HhbS2ErakFZ4I+JjFlVrzDsTTaga/kb1CFKu853R0le8yA
         rqaQ==
X-Gm-Message-State: AO0yUKUO0xUubDliBM+fhKNiMdCJFWlMSjVBqek2rhzQYYxmQYq/H7CS
        WXCERCL8f9KFA4NFas9Pi3PG2Q==
X-Google-Smtp-Source: AK7set/YQoyOdPS8Zp+k/ZHZSM5vg5zjI3jXX8fddlGMbqeVIPumeeTulTVDogjdrTt4rG8rFZ4dAg==
X-Received: by 2002:a05:6402:268b:b0:4a2:2e9e:c2ec with SMTP id w11-20020a056402268b00b004a22e9ec2ecmr14059882edd.4.1675953019947;
        Thu, 09 Feb 2023 06:30:19 -0800 (PST)
Received: from [192.168.1.102] (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id v28-20020a50d59c000000b004aaa09d50adsm815359edi.94.2023.02.09.06.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 06:30:19 -0800 (PST)
Message-ID: <ce42e852-fb73-08ca-48c7-9826ab087289@linaro.org>
Date:   Thu, 9 Feb 2023 16:30:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v9 11/14] arm64: dts: qcom: sm8250: add description of
 Qualcomm Crypto Engine IP
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
 <20230208183755.2907771-12-vladimir.zapolskiy@linaro.org>
 <7b38331c-3b29-03c1-fbed-f5799d11ca1f@linaro.org>
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
In-Reply-To: <7b38331c-3b29-03c1-fbed-f5799d11ca1f@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Bhupesh,

On 2/9/23 14:21, Bhupesh Sharma wrote:
> Hi Vladimir,
> 
> On 2/9/23 12:07 AM, Vladimir Zapolskiy wrote:
>> Add description of QCE and its corresponding BAM DMA IPs on SM8250 SoC.
>>
>> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>> ---
>>    arch/arm64/boot/dts/qcom/sm8250.dtsi | 24 ++++++++++++++++++++++++
>>    1 file changed, 24 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
>> index e59c16f74d17..d8698d18223e 100644
>> --- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
>> @@ -2215,6 +2215,30 @@ ufs_mem_phy_lanes: phy@1d87400 {
>>    			};
>>    		};
>>    
>> +		cryptobam: dma-controller@1dc4000 {
>> +			compatible = "qcom,bam-v1.7.0";
>> +			reg = <0x0 0x01dc4000 0x0 0x24000>;
>> +			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
>> +			#dma-cells = <1>;
>> +			qcom,ee = <0>;
>> +			qcom,controlled-remotely;
>> +			num-channels = <8>;
>> +			qcom,num-ees = <2>;
>> +			iommus = <&apps_smmu 0x586 0x11>,
>> +				 <&apps_smmu 0x596 0x11>;
>> +		};
>> +
>> +		crypto: crypto@1dfa000 {
>> +			compatible = "qcom,sm8250-qce", "qcom,sm8150-qce";
>> +			reg = <0x0 0x01dfa000 0x0 0x6000>;
>> +			dmas = <&cryptobam 6>, <&cryptobam 7>;
>> +			dma-names = "rx", "tx";
>> +			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
>> +			interconnect-names = "memory";
>> +			iommus = <&apps_smmu 0x586 0x11>,
>> +				 <&apps_smmu 0x596 0x11>;
>> +		};
>> +
>>    		tcsr_mutex: hwlock@1f40000 {
>>    			compatible = "qcom,tcsr-mutex";
>>    			reg = <0x0 0x01f40000 0x0 0x40000>;
> 
> This patch was part of the v7 arm64 dts fixes I sent out - see [1].

thank you for pointing it out, so there are two different v7 series of related
patches, as it's stated in the cover letter I based my v8 on top of linux-crypto
changes [*], and this particular change was developed independently from yours.

And so, there are some differences, can you please comment on them?

- My change does not have 'interconnects' property under dma-controller@1dc4000
   device tree node, I believe it is not needed, but please correct me here.
- My change uses DMA channel number taken from the downstream code [**], is
   there a reason to use different ones like in your change?
- My change has a shorter list of IOMMUs also copied from the same downstream
   code, is there a reason to use a different extended list like in your change?
- On my end I have to retest your change without 'num-channels' and 'qcom,num-ees'
   properties, since this also seems as an important difference between two patches.

Nevertheless, thank you again for bringing my attention to a different patch
series, I'll reuse the changes from it, and also publish all of them together and
in a separate changeset as Krzysztof suggested.

> Probably you can use it as a base and make the changes (interconnect
> property for the BAM DMA node and qce-compatible names) directly there
> and include it in your patch series.

[*]  https://lore.kernel.org/linux-arm-msm/20220920114051.1116441-1-bhupesh.sharma@linaro.org/
[**] https://source.codeaurora.org/quic/la/kernel/msm-4.19/tree/arch/arm64/boot/dts/qcom/kona.dtsi?h=LA.UM.8.12.3.1&id=f3dd4aaeb34438c877ccd42f5a48ccd554dd765a#n2979

> [1].
> https://lore.kernel.org/linux-arm-msm/20220921045602.1462007-3-bhupesh.sharma@linaro.org/

--
Best wishes,
Vladimir
