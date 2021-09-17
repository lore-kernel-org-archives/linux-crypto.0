Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F935C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 16:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B01A611C4
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 16:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbhIQQXO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Sep 2021 12:23:14 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:41432
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229979AbhIQQXO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Sep 2021 12:23:14 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C62FC402CE
        for <linux-crypto@vger.kernel.org>; Fri, 17 Sep 2021 16:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631895710;
        bh=G8QlOu8E9SL6+IICPk34QRa2K7n8iVCHf0hLFCHuieI=;
        h=To:Cc:References:From:Subject:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=GvJQLG2new4os8v5TlxfgQeSXdhbv551v79YIE+20urBrxxMmyTLHoyjwMEGvgMEY
         6W3AgS8ATwhk3hh9HW1d+ZdknyH59StWaNSa/oPF2STEPA+YKWmibSgpZ2vGN9FRXJ
         qFgqpMvNY4FzFXN5LoVQMLF0PJSnpOxhv1kNV65q219Anuz13Rhu7KPqvdPvP7ritL
         zzyc0JNI58EzQFrC2vXqYGDKvhZhYYHKRF9yN1sZWTScCufIl5zeIybRY/cPm5QgH1
         mKRPCNOy9icwr1Wj9jsYFOkcmIfLB6xXfqmT/sTVlXXwuKsXfC4twr1XSjVeyvfjke
         1Zh6mKtt4kBOQ==
Received: by mail-ed1-f69.google.com with SMTP id r23-20020a50d697000000b003d824845066so1125275edi.8
        for <linux-crypto@vger.kernel.org>; Fri, 17 Sep 2021 09:21:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G8QlOu8E9SL6+IICPk34QRa2K7n8iVCHf0hLFCHuieI=;
        b=PNQuMQC6L2op64YIdpU4JHezqEuyNVqlMsdh5X8+/LvJEb2UBbTxh9av4W8A5kRkPX
         pRjJ0/whzvx2xMycB6fxskfvTp4UHiQ0zBGqUPVv9cYEXNRUcliC5C+D5okZB/bvatzS
         gNSIraqjPw2JcuzYfpQjyQXR5/LoeP2vE+y64SEs9tW+0TA6XUYWS9SCi0IcZAOJ9Cfi
         yBWENSLP+LCOSqtgK2udYsckOoQWtYtCaLX0VUSCiNdoX0puGcIix7GD2XoZPx7YmlRc
         Rbb48aEhkdzVb2XYZauNnobMvtpKk1m6Vv/RRcHh67ebr+Hd8iR87/WnHAGryooTh3I6
         1SHA==
X-Gm-Message-State: AOAM530yY+wzp5i+jcLT0ymi8eaGSrw8YHCLvNBvzAmfFXuuW9BB71bg
        YcNFqlXgMyY4ozlY7vwvmP1cmCIsgiYlSoP5ZVT2g1dRxRMHpTAWxaHRVGIfF4G51a1FfU3mYEg
        lB4+ew9DTKK4N81gdlwMT1cLl4Sz2jC8LeBX3YuXlhQ==
X-Received: by 2002:a05:6402:5163:: with SMTP id d3mr13587781ede.220.1631895709583;
        Fri, 17 Sep 2021 09:21:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx27XqEfhMwAr3nRZ25ngBqNuAAqdiGsgKx6YxVoDWcoyjDwxvkiwLVAC3bveuBw7iVHtU0jQ==
X-Received: by 2002:a05:6402:5163:: with SMTP id d3mr13587765ede.220.1631895709380;
        Fri, 17 Sep 2021 09:21:49 -0700 (PDT)
Received: from [192.168.0.134] (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id jl12sm2452034ejc.120.2021.09.17.09.21.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 09:21:48 -0700 (PDT)
To:     =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Marek Vasut <marex@denx.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     "ch@denx.de" <ch@denx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
References: <20210916134154.8764-1-marex@denx.de>
 <441a7e2e-7ac8-5000-72e0-3793ae7e58d5@canonical.com>
 <08afb147-07c7-9fbb-4a0c-8a79717b06b7@denx.de>
 <ea7e5aae-be43-057a-2710-fbcb57d40ddc@nxp.com>
 <a8900033-d84d-d741-7d72-b266f973e0d6@canonical.com>
 <bc94681c-58e5-8c6f-42d3-0e51ddd060c7@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: Re: [RFC][PATCH] crypto: caam - Add missing MODULE_ALIAS
Message-ID: <77467cbf-afad-d7e1-5042-569d5a276c20@canonical.com>
Date:   Fri, 17 Sep 2021 18:21:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <bc94681c-58e5-8c6f-42d3-0e51ddd060c7@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 17/09/2021 16:44, Horia Geantă wrote:
> On 9/17/2021 1:33 PM, Krzysztof Kozlowski wrote:
>> On 17/09/2021 11:51, Horia Geantă wrote:
>>> On 9/16/2021 5:06 PM, Marek Vasut wrote:
>>>> On 9/16/21 3:59 PM, Krzysztof Kozlowski wrote:
>>>>> On 16/09/2021 15:41, Marek Vasut wrote:
>>>>>> Add MODULE_ALIAS for caam and caam_jr modules, so they can be auto-loaded.
>>>>>>
>>>>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>>>>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>>>>>> Cc: Horia Geantă <horia.geanta@nxp.com>
>>>>>> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
>>>>>> Cc: Krzysztof Kozlowski <krzk@kernel.org>
>>>>>> ---
>>>>>>   drivers/crypto/caam/ctrl.c | 1 +
>>>>>>   drivers/crypto/caam/jr.c   | 1 +
>>>>>>   2 files changed, 2 insertions(+)
>>>>>>
>>>>>
>>>>> Since you marked it as RFC, let me share a comment - would be nice to
>>>>> see here explanation why do you need module alias.
>>>>>
>>>>> Drivers usually do not need module alias to be auto-loaded, unless the
>>>>> subsystem/bus reports different alias than one used for binding. Since
>>>>> the CAAM can bind only via OF, I wonder what is really missing here. Is
>>>>> it a MFD child (it's one of cases this can happen)?
>>>>
>>>> I noticed the CAAM is not being auto-loaded on boot, and then I noticed 
>>>> the MODULE_ALIAS fixes cropping up in the kernel log, but I couldn't 
>>>> find a good documentation for that MODULE_ALIAS. So I was hoping to get 
>>>> a feedback on it.
>>>>
>>> What platform are you using?
>>>
>>> "make modules_install" should take care of adding the proper aliases,
>>> relying on the MODULE_DEVICE_TABLE() macro in the caam, caam_jr drivers.
>>>
>>> modules.alias file should contain:
>>> alias of:N*T*Cfsl,sec4.0C* caam
>>> alias of:N*T*Cfsl,sec4.0 caam
>>> alias of:N*T*Cfsl,sec-v4.0C* caam
>>> alias of:N*T*Cfsl,sec-v4.0 caam
>>> alias of:N*T*Cfsl,sec4.0-job-ringC* caam_jr
>>> alias of:N*T*Cfsl,sec4.0-job-ring caam_jr
>>> alias of:N*T*Cfsl,sec-v4.0-job-ringC* caam_jr
>>> alias of:N*T*Cfsl,sec-v4.0-job-ring caam_jr
>>
>> Marek added a platform alias which is not present here on the list
>> (because there are no platform device IDs). The proper question is who
>> requests this device via a platform match? Who sends such event?
>>
> AFAICS the platform bus adds the "platform:" alias to uevent env.
> in its .uevent callback - platform_uevent().
> 
> When caam (platform) device is added, the uevent is generated with this env.,
> which contains both OF-style and "platform:" modaliases.

I am not saying about theoretical case, I know that platform bus will
send platform uevent. How did this device end up in platform bus so this
uevent is being sent? It should be instantiated from OF on for example
amba bus or directly from OF FDT scanning.

Therefore I have the same question - who requests device via a platform
match? Is it used out-of-tree in different configuration?

Best regards,
Krzysztof
