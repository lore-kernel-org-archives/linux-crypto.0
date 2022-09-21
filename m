Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37915C32771
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Sep 2022 06:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiIUGQd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Sep 2022 02:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiIUGQb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Sep 2022 02:16:31 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3757FFB2
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 23:16:29 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id rt12so2910775pjb.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 23:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=HZLYiNEjRcKw3klqYTO7kBwCBzLEHz3GnBytTHIhZBQ=;
        b=yYs52SMiJTjR1PL0GZki28IXpJDV8ybztDMtG5jwodsotczaqAb/ajbXWFzb2TldRT
         S0P53IZ21DbXdP3gpgS6DE3yvVAY9IfIfSK4lEeMB+Ty781mlo3T/JuH4/dGMh6c7RnL
         bLb8i6yyKDIhFcqeg0EG5abdjZpNNzY7Fx39H4H7wNhPBQQ+hz0AGGi3JWky1EpNwFKU
         zWXqBzmVdCYfzPaWaklMS11680zs6ZHbbWz5BNfYP+M7vHoFmqG2Txr0+TJM3uiBBa8B
         uDbguENilE7LvKix0oiXPv+ToFfINiTRGlDQ9eS7H6ZY1wmmsioACRJ+hSTBcPqmCXDB
         qRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=HZLYiNEjRcKw3klqYTO7kBwCBzLEHz3GnBytTHIhZBQ=;
        b=bh8rPpEF10Or67P/OKwkZ5Zde2aro1umISKTCckwXTNShIXsTjfLvgr6TXtj/1Xk+d
         MhU4w8dr7TRlbF4TlVQXlPxanwSCzfG5z1usxQFHKsTwYR34o4b2kV6lTctdngOnbl/Z
         p9f/WkFh7m17uphXVGq3AnhcbBIzrn/LfT5kz6nZEF1L78MJEAfofbCyouJH3kWML32j
         zZvMPj+BCIF4B+0bQ0d8i/qkVOSbhO5Pp8VBma9NzcQdQKR2pBViAcRYEHxYgbTYtgoE
         CuOWz7cP36smQOGESdBBjVvU587X/3nJTUYYUKQKujbAlTkScyydOFCqUB9mDx8jn/7J
         r1FQ==
X-Gm-Message-State: ACrzQf0+CYt7pe7csRTub3XyBjw5qze6Ls8Gm77aVJpEq41Pp0dcBBXq
        Aj1540neCHIN3NcUfAzaPQSLUg==
X-Google-Smtp-Source: AMsMyM5Mzwt7zm2xVZRnyhLdY/pWEBix3FgD4qFtPkYJjoTnxEbUUgyNK9/yAiTS2+3HW+NE80U1og==
X-Received: by 2002:a17:90b:3149:b0:202:e9e9:632f with SMTP id ip9-20020a17090b314900b00202e9e9632fmr7972919pjb.96.1663740988455;
        Tue, 20 Sep 2022 23:16:28 -0700 (PDT)
Received: from ?IPV6:2401:4900:1c61:8e50:8ba8:7ad7:f34c:2f5? ([2401:4900:1c61:8e50:8ba8:7ad7:f34c:2f5])
        by smtp.gmail.com with ESMTPSA id g10-20020a170902c38a00b001750b31faabsm987104plg.262.2022.09.20.23.16.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 23:16:26 -0700 (PDT)
Message-ID: <9b111583-519b-95a6-15b5-243e88dc8d39@linaro.org>
Date:   Wed, 21 Sep 2022 11:46:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v7 6/9] crypto: qce: core: Add new compatibles for qce
 crypto driver
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        linux-arm-msm@vger.kernel.org, thara.gopinath@gmail.com,
        robh@kernel.org, andersson@kernel.org, bhupesh.linux@gmail.com,
        davem@davemloft.net, Jordan Crouse <jorcrous@amazon.com>
References: <20220920114051.1116441-1-bhupesh.sharma@linaro.org>
 <20220920114051.1116441-7-bhupesh.sharma@linaro.org>
 <b4016460-f43a-13f8-432e-47c27237e005@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
In-Reply-To: <b4016460-f43a-13f8-432e-47c27237e005@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 9/20/22 8:42 PM, Krzysztof Kozlowski wrote:
> On 20/09/2022 13:40, Bhupesh Sharma wrote:
>> Since we decided to use soc specific compatibles for describing
>> the qce crypto IP nodes in the device-trees, adapt the driver
>> now to handle the same.
>>
>> Keep the old deprecated compatible strings still in the driver,
>> to ensure backward compatibility.
>>
>> Cc: Bjorn Andersson <andersson@kernel.org>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: herbert@gondor.apana.org.au
>> Tested-by: Jordan Crouse <jorcrous@amazon.com>
>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>> ---
>>   drivers/crypto/qce/core.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
>> index 63be06df5519..99ed540611ab 100644
>> --- a/drivers/crypto/qce/core.c
>> +++ b/drivers/crypto/qce/core.c
>> @@ -291,8 +291,17 @@ static int qce_crypto_remove(struct platform_device *pdev)
>>   }
>>   
>>   static const struct of_device_id qce_crypto_of_match[] = {
>> +	/* Following two entries are deprecated (kept only for backward compatibility) */
>>   	{ .compatible = "qcom,crypto-v5.1", },
>>   	{ .compatible = "qcom,crypto-v5.4", },
> 
> This is okay, so there is no ABI break.

Great. Thanks for the confirmation.

>> +	/* Add compatible strings as per updated dt-bindings, here: */
>> +	{ .compatible = "qcom,ipq4019-qce", },
>> +	{ .compatible = "qcom,ipq6018-qce", },
>> +	{ .compatible = "qcom,ipq8074-qce", },
>> +	{ .compatible = "qcom,msm8996-qce", },
>> +	{ .compatible = "qcom,sdm845-qce", },
>> +	{ .compatible = "qcom,sm8150-qce", },
>> +	{ .compatible = "qcom,sm8250-qce", },
> 
> This is a bit odd... you have 7 devices which are simply compatible or
> even the same. This should be instead one compatible.
> 
> I don't really get why do you want to deprecate "qcom,crypto-v5.1".
> Commit msg only says "we decided" but I do not know who is "we" and "why
> we decided like this". If you want to deprecate it, perfectly fine by
> me, but please say in commit msg why you are doing it.

I understand. This patchset has been in flight for some time and hence I 
might have missed sharing some detailed information about the review 
comments and rework done along the way (in the cover letter for this 
series).

Coming back to your concern, here is the relevant background:
- Please see: 
https://lore.kernel.org/linux-arm-msm/20210316222825.GA3792517@robh.at.kernel.org/

- Rob shared some comments on the v1 series regarding the soc-specific 
compatibles. He mentioned in the above thread that 'you should stick 
with SoC specific compatibles as *everyone* else does (including most 
QCom bindings).'

- So, while I had proposed "qcom,crypto-v5.1" (for ipq6018) and 
"qcom,crypto-v5.4" (for sdm845, sm8150) etc. as the compatible(s) in the 
v1 series, I shifted to using the soc-specific compatibles from the v2 
series, onwards.

- Basically, since we are going to have newer qce IP versions available 
in near future, e.g. "qcom,crypto-v5.5" etc, and we will have 2 or more 
SoCs also sharing 1 version, these compatibles would grow and become 
more confusing. IMO, having a soc-specific compatible in such cases is 
probably a much cleaner approach.

Hope this helps answer some of your concerns and provides some relevant 
background information.

Thanks,
Bhupesh
