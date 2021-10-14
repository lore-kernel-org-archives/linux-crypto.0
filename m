Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA02C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Oct 2021 08:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A059B610EA
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Oct 2021 08:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhJNIpF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Oct 2021 04:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbhJNIpE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Oct 2021 04:45:04 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC2EC06174E
        for <linux-crypto@vger.kernel.org>; Thu, 14 Oct 2021 01:42:59 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id r19so23295263lfe.10
        for <linux-crypto@vger.kernel.org>; Thu, 14 Oct 2021 01:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cpaeSIqpbccb1EDn+njbJaCTkDDoeQzhueTVC0eKR+U=;
        b=iTZZsFFonBqLycaFqe3TxPsySH11QuaTiXoJB+D4TsVKD8mtVjZkr6Vx3XtrXGGTEO
         rx0Ld/FWUvc07hIA79LrrlHKgFpFyRdPFc6n9hUiRICepD/Eq0eIrJMNijui0ubDSfrK
         p0C4qb1jXNsaDfyhFRQfKr17ivUhfOrpXPxf9U9t5gnBQm+obpkrjXiphl9f+t1BAXVa
         PmfVYsqcht3P+Xyt/utBAV0gwl9tp4hr5idCA0KXobrCmcr6J005tL0nfxvrIJr9wP4y
         ywGGf0wycNlBus5FXly9KI6MqTCDsyayGxI2BKVyKh6z/UUUYVtw+xkx59qsq6Wjupy6
         TVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cpaeSIqpbccb1EDn+njbJaCTkDDoeQzhueTVC0eKR+U=;
        b=d6UKJLlfpVgk7pOAXzk41ykfc0fj/LcVDj0R+3Oafb6ValbRo6l78TNxBIxY1z84hT
         kvJwRPEamcnGplwgreoY5BlduQTLLHMQMAfhERuLLY8XW2uFUbxD/q29LT/v5/bVWBH7
         7TpYqFODUuLCcsP2HFkBhRfkIt4Dzi+TbCAXYboaJL1+A1TlZ7ZelV1kFQFL8kHyMWxF
         bs4VO3EQ6CnFh74xwx+f7Ww0Y35M5lYt9L0Qql963bma7VkLQqA8CZ0pZ0lxuL6yTh0j
         3JNzwBrB9912M2m2qX3ALuSHF1q9HOmLkhfGz+B+97NI0/77AXsBfCtFuLWodVk6Buva
         v6Pg==
X-Gm-Message-State: AOAM533IMiNd5phidxJw204oqMknQUUcPU/kM2DtWgNNGHwBNbF2d5Cv
        kmKeaMepy5kvSIEjz8fw3Oy6/g==
X-Google-Smtp-Source: ABdhPJxyOKrg3Sdq0ECaZrMDUkjUehKfntkZkWSyfE8jchZPebHXR2IHYP75KkUxkmgQHFI+kj0TbQ==
X-Received: by 2002:a05:6512:338b:: with SMTP id h11mr4007443lfg.310.1634200977630;
        Thu, 14 Oct 2021 01:42:57 -0700 (PDT)
Received: from [192.168.1.102] (62-248-207-242.elisa-laajakaista.fi. [62.248.207.242])
        by smtp.gmail.com with ESMTPSA id h16sm195028lji.140.2021.10.14.01.42.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 01:42:57 -0700 (PDT)
Subject: Re: [PATCH v4 18/20] crypto: qce: Defer probing if BAM dma channel is
 not yet initialized
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     MSM <linux-arm-msm@vger.kernel.org>, linux-crypto@vger.kernel.org,
        bhupesh.linux@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
 <20211013105541.68045-19-bhupesh.sharma@linaro.org>
 <74893e20-3dd8-9b57-69bb-025264f51186@linaro.org>
 <CAH=2Ntw5_hycMqouneiU_Tb17OL0zxUpt8ecGZn+LxXEU_=ZQg@mail.gmail.com>
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Message-ID: <067150f9-3c8c-3b91-718e-33a4019d2d95@linaro.org>
Date:   Thu, 14 Oct 2021 11:42:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAH=2Ntw5_hycMqouneiU_Tb17OL0zxUpt8ecGZn+LxXEU_=ZQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Bhupesh,

On 10/14/21 10:40 AM, Bhupesh Sharma wrote:
> Hi Vladimir,
> 
> On Thu, 14 Oct 2021 at 02:19, Vladimir Zapolskiy
> <vladimir.zapolskiy@linaro.org> wrote:
>>
>> Hi Bhupesh,
>>
>> On 10/13/21 1:55 PM, Bhupesh Sharma wrote:
>>> Since the Qualcomm qce crypto driver needs the BAM dma driver to be
>>> setup first (to allow crypto operations), it makes sense to defer
>>> the qce crypto driver probing in case the BAM dma driver is not yet
>>> probed.
>>>
>>> Move the code leg requesting dma channels earlier in the
>>> probe() flow. This fixes the qce probe failure issues when both qce
>>> and BMA dma are compiled as static part of the kernel.
>>>
>>> Cc: Thara Gopinath <thara.gopinath@linaro.org>
>>> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
>>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>> ---
>>>    drivers/crypto/qce/core.c | 20 ++++++++++++--------
>>>    1 file changed, 12 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
>>> index cb8c77709e1e..c6f686126fc9 100644
>>> --- a/drivers/crypto/qce/core.c
>>> +++ b/drivers/crypto/qce/core.c
>>> @@ -209,9 +209,19 @@ static int qce_crypto_probe(struct platform_device *pdev)
>>>        if (ret < 0)
>>>                return ret;
>>>
>>> +     /* qce driver requires BAM dma driver to be setup first.
>>
>> I believe a multi-line block of comments should be started with '/*' line,
>> for reference please take a look at Documentation/process/coding-style.rst
> 
> There are exceptions to this rule as well. For e.g. see most of the
> networking drivers and the multi-line comment styles there :) .
> 
> There is a very interesting LWN article on the same :
> https://lwn.net/Articles/694755/
> Note that 'crypto/' and 'drivers/crypto' use these non-standard
> multi-line comments quite often as well.

Ah, yes, I agree here, thank you for the reminder! IIRC crypto drivers
kind of belong to netdev domain, at least in relation to the accepted
coding style.

> That said, I have no strong opinion on using either style. Although, I
> found one of the points raised by the networking maintainer during one
> of my patch reviews earlier quite useful - 'keeping the top line in a
> multi-line comment blank, wastes precious screen space while reading
> and reviewing the patch'.

--
Best wishes,
Vladimir
