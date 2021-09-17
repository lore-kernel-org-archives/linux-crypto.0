Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DE3C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 10:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BF556113A
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 10:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242253AbhIQKfL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Sep 2021 06:35:11 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:51158
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233543AbhIQKfK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Sep 2021 06:35:10 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 633DE3FE02
        for <linux-crypto@vger.kernel.org>; Fri, 17 Sep 2021 10:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631874828;
        bh=SvOIMU9s2tk6Iel7Z7uRZCftcp1vmChPuIz8m0bmvjY=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=AkDY/BT4WiQGirDeW3GgMeT2GosDZJNj+gzcmka14RkEhWyyI2Bxv0fpXjFU6y9th
         X+vitVMLgIYrXJ6NUZ6OOqsASA/rz4uQ+Qls0xi0IgC27GEFFO8kRhIKpNlKYuAxrw
         R+ZzfmB5GAFrXFAJB3Oujr8bMAdEDA84iSzu+0cofpLWdTj4OFbcXGNq0mC1P/BVb+
         cTo17OOhYaNTcyUllZL+THzbUnlbxDL4aS5mGFZWN5pUx5dnrmQG1HOSADkcA+a0OL
         YIVVaajN/8sTq9K2fpFmU4T1DDJEl2adPIJyNMozo6PeztLNNJeI8uwY158zofsXyz
         6GpQpbBWMjEpA==
Received: by mail-wm1-f72.google.com with SMTP id g74-20020a1c204d000000b0030a1652fea8so8420wmg.3
        for <linux-crypto@vger.kernel.org>; Fri, 17 Sep 2021 03:33:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SvOIMU9s2tk6Iel7Z7uRZCftcp1vmChPuIz8m0bmvjY=;
        b=XnNDwtnfHnDAH/JzV5bp9o7mdthLj+1stusXlGm1WbBicjl+j19jqhYpOMC/vWQP7d
         eYQo1/UZYZ83Y7bO6eSFdTrhDqF76JrCCD7jrQ6gQlQcmMR7ah04A++ogwNIAmQwvqtL
         72OrHwLVK+SLKJwBdzEToNn8sx/j6XQuht11mGXaNMp5JlLRZdVao1JW9TAdSa/IEPYR
         0QuFXSiTJFE/U9183sUURCPbJhUldvgtgLd9cYfC0RTD1R4gKYP2tPtta9MVeqM43Xae
         TwQkOaDan/4MuM7mWTHXPsvkiR5GwSPMgM0Gq2bzZux4sypBim1CH3AcZKAwfjGkOHJ3
         rs1A==
X-Gm-Message-State: AOAM531dktTR8k7FwGd64wWdZkLCBxS419g9q9036my6Y9sekIN9hlSs
        b/zx0LQLLBpxFW6TLGGRsuVNVOScE6Q2YvQVekhmJhC2rUn4Oglho5KUo2kMWoATOxEM62GlTGU
        69WGjHOilgBXQPpksO4QHv0Qy1fSnrABKVibEtUn9EA==
X-Received: by 2002:a1c:28a:: with SMTP id 132mr9475447wmc.101.1631874828058;
        Fri, 17 Sep 2021 03:33:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzx7YkdOeCTXEWccb/80g0fRkTroqFihFcs/rYB7WOgQIz+ulpi9iR6an0Ni8pNBLRyNqtbUQ==
X-Received: by 2002:a1c:28a:: with SMTP id 132mr9475439wmc.101.1631874827876;
        Fri, 17 Sep 2021 03:33:47 -0700 (PDT)
Received: from [192.168.0.134] (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id c7sm6190683wmq.13.2021.09.17.03.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 03:33:47 -0700 (PDT)
Subject: Re: [RFC][PATCH] crypto: caam - Add missing MODULE_ALIAS
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
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <a8900033-d84d-d741-7d72-b266f973e0d6@canonical.com>
Date:   Fri, 17 Sep 2021 12:33:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ea7e5aae-be43-057a-2710-fbcb57d40ddc@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 17/09/2021 11:51, Horia Geantă wrote:
> On 9/16/2021 5:06 PM, Marek Vasut wrote:
>> On 9/16/21 3:59 PM, Krzysztof Kozlowski wrote:
>>> On 16/09/2021 15:41, Marek Vasut wrote:
>>>> Add MODULE_ALIAS for caam and caam_jr modules, so they can be auto-loaded.
>>>>
>>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>>>> Cc: Horia Geantă <horia.geanta@nxp.com>
>>>> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
>>>> Cc: Krzysztof Kozlowski <krzk@kernel.org>
>>>> ---
>>>>   drivers/crypto/caam/ctrl.c | 1 +
>>>>   drivers/crypto/caam/jr.c   | 1 +
>>>>   2 files changed, 2 insertions(+)
>>>>
>>>
>>> Since you marked it as RFC, let me share a comment - would be nice to
>>> see here explanation why do you need module alias.
>>>
>>> Drivers usually do not need module alias to be auto-loaded, unless the
>>> subsystem/bus reports different alias than one used for binding. Since
>>> the CAAM can bind only via OF, I wonder what is really missing here. Is
>>> it a MFD child (it's one of cases this can happen)?
>>
>> I noticed the CAAM is not being auto-loaded on boot, and then I noticed 
>> the MODULE_ALIAS fixes cropping up in the kernel log, but I couldn't 
>> find a good documentation for that MODULE_ALIAS. So I was hoping to get 
>> a feedback on it.
>>
> What platform are you using?
> 
> "make modules_install" should take care of adding the proper aliases,
> relying on the MODULE_DEVICE_TABLE() macro in the caam, caam_jr drivers.
> 
> modules.alias file should contain:
> alias of:N*T*Cfsl,sec4.0C* caam
> alias of:N*T*Cfsl,sec4.0 caam
> alias of:N*T*Cfsl,sec-v4.0C* caam
> alias of:N*T*Cfsl,sec-v4.0 caam
> alias of:N*T*Cfsl,sec4.0-job-ringC* caam_jr
> alias of:N*T*Cfsl,sec4.0-job-ring caam_jr
> alias of:N*T*Cfsl,sec-v4.0-job-ringC* caam_jr
> alias of:N*T*Cfsl,sec-v4.0-job-ring caam_jr

Marek added a platform alias which is not present here on the list
(because there are no platform device IDs). The proper question is who
requests this device via a platform match? Who sends such event?

Best regards,
Krzysztof
