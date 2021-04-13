Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6468EC433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 19:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1775A61220
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 19:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhDMT2q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 15:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhDMT2p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 15:28:45 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F550C061574
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 12:28:25 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id iu14so8689356qvb.4
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 12:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b8ZN7Qwwd5Ix7pE604LHRgxVLUozgSWTjN9Rn065Nm0=;
        b=PP3iAuCANMnnD5BG2ntiGPA2FwlNMHOgU6s6gp6rNGpbGZM3IdJFhOdCXLoQMrGL5c
         LBuPYHM0UfsnoZYKR8l0HFmi1aS3DSZrmSSUljyJq0GqLDhDMjew7VG90wfCLeIaY41D
         PX5fQ52pvCpxSsVSsoUFliEo3vEMoi5g4fkGpRtersFBJWXjc+TIjU/AMkiHk7e6stdG
         IKCYYTgJxoN3r6X8cGorkQYGD6yGZQjn4HuIaUs/JumRsiQOUNGbJexrqIeX6PFZzBeM
         fXsfdkwRm1+2N3JMv2SkO0C7ePbmsST034Fq6JpuZWuRumencTEu0NbM9SzV8IzCow0I
         uifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b8ZN7Qwwd5Ix7pE604LHRgxVLUozgSWTjN9Rn065Nm0=;
        b=Aeyhc4JP1kUQ5jXZWt+W4KVi20LK0rxbpR4lu4WGIqmKTwaC1GAsDXAJK5kLfzlRIL
         pA6AtsoMMKoIqzFT4QkoEXXMAwWDbUhpzh6qMCc2sALd9TEsqSboKhVKfWfgbRoF+k/S
         aHdtv3WHJ1s0hjETjHB3oX8zaK6p3cKC94Zwy+Noz3RC4YAZPc1etrwQY488QBwobBAr
         /8SPHE3Q3jBBXYAwUYdANSgJwBReoZXsZViVNiSHj1By58Nmfqfzc1wc3vuR2dkWCi4j
         qGiFoCvP3j2/ghqvuW7zvUrNgmjDmgVJigXdpR7KV9Lr7QNOBlndZyz0h+BT582Cyyu8
         /RtQ==
X-Gm-Message-State: AOAM530/mJ/SFqhn/S9O+zPLk+SLqK2QBOcfG4QxtuB960WFjkTqmUyt
        kz7T0WO4FKVaYRdZOT8G6OxrBA==
X-Google-Smtp-Source: ABdhPJx4Jk9iR0YN79tqg6Frh2oZT736ordw3dNwYHyVuHbLQOJybbs3OevNIgjoOh2nF+f3T0hXOg==
X-Received: by 2002:a05:6214:248f:: with SMTP id gi15mr34367277qvb.40.1618342104272;
        Tue, 13 Apr 2021 12:28:24 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id e13sm10797545qtm.35.2021.04.13.12.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 12:28:23 -0700 (PDT)
Subject: Re: [PATCH 1/7] crypto: qce: common: Add MAC failed error checking
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-2-thara.gopinath@linaro.org>
 <20210405173600.GZ904837@yoga>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <1c3523d6-ac4d-f0b7-ad89-724ed1e4f485@linaro.org>
Date:   Tue, 13 Apr 2021 15:28:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210405173600.GZ904837@yoga>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Bjorn,

Thanks for the reviews.
I realized that I had these replies in my draft for a while and forgot 
to send them!

On 4/5/21 1:36 PM, Bjorn Andersson wrote:
> On Thu 25 Feb 12:27 CST 2021, Thara Gopinath wrote:
> 
>> MAC_FAILED gets set in the status register if authenthication fails
>> for ccm algorithms(during decryption). Add support to catch and flag
>> this error.
>>
>> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
>> ---
>>   drivers/crypto/qce/common.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
>> index dceb9579d87a..7c3cb483749e 100644
>> --- a/drivers/crypto/qce/common.c
>> +++ b/drivers/crypto/qce/common.c
>> @@ -403,7 +403,8 @@ int qce_start(struct crypto_async_request *async_req, u32 type)
>>   }
>>   
>>   #define STATUS_ERRORS	\
>> -		(BIT(SW_ERR_SHIFT) | BIT(AXI_ERR_SHIFT) | BIT(HSD_ERR_SHIFT))
>> +		(BIT(SW_ERR_SHIFT) | BIT(AXI_ERR_SHIFT) |	\
>> +		 BIT(HSD_ERR_SHIFT) | BIT(MAC_FAILED_SHIFT))
>>   
>>   int qce_check_status(struct qce_device *qce, u32 *status)
>>   {
>> @@ -417,8 +418,12 @@ int qce_check_status(struct qce_device *qce, u32 *status)
>>   	 * use result_status from result dump the result_status needs to be byte
>>   	 * swapped, since we set the device to little endian.
>>   	 */
>> -	if (*status & STATUS_ERRORS || !(*status & BIT(OPERATION_DONE_SHIFT)))
>> -		ret = -ENXIO;
>> +	if (*status & STATUS_ERRORS || !(*status & BIT(OPERATION_DONE_SHIFT))) {
>> +		if (*status & BIT(MAC_FAILED_SHIFT))
> 
> Afaict MAC_FAILED indicates a different category of errors from the
> others. So I would prefer that the conditionals are flattened.
> 
> Is OPERATION_DONE set when MAC_FAILED?
Yes it is. I will change the check to the pattern you have suggested. It 
is less confusing..

> 
> If so:
> 
> if (errors || !done)
> 	return -ENXIO;
> else if (*status & BIT(MAC_FAILED))
> 	return -EBADMSG;
> 
> Would be cleaner in my opinion.
> 
> Regards,
> Bjorn
> 
>> +			ret = -EBADMSG;
>> +		else
>> +			ret = -ENXIO;
>> +	}
>>   
>>   	return ret;
>>   }
>> -- 
>> 2.25.1
>>

-- 
Warm Regards
Thara
