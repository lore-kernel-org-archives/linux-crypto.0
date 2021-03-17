Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CEEC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 02:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6690D64F8B
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 02:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhCQCIm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Mar 2021 22:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbhCQCIl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Mar 2021 22:08:41 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA16C06174A
        for <linux-crypto@vger.kernel.org>; Tue, 16 Mar 2021 19:08:40 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id x10so37445545qkm.8
        for <linux-crypto@vger.kernel.org>; Tue, 16 Mar 2021 19:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5K+i9EB30YDCBf5Ec7nN0Kmlxn8dBvWA2QPUBF4tmM0=;
        b=ZKtMYKT3DClvewV7ca7X458r647Gl63Q2Y28BVG0C9oKSr1btE07Eo0tVaR4IRhZJG
         IJpFOKKwhuRdcy2O+0UeHmfAKU5CeJEf6++TP9YgjMBtg/KBLlMgg1bnReMIT/asVE88
         Ey3oB2IA00vUJwztNsH3fiQKB7gg8eEvQrDT3F71NHFo7z4ACNQwoV19Y2QEhIE6/IKs
         z9pRZ5N1pShZXWmZ8OC2CzPq3fkOp51QjOSnHtrQo9Yu8m+7rOJH0a6aLbkxjPIx65ju
         VlE9f2Hd4l4jktA7pTHef9vLPQ7ZMMXCZigmP2zdHRgjxrtF0sTPMuOaS2tKkbTfSk5C
         U3YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5K+i9EB30YDCBf5Ec7nN0Kmlxn8dBvWA2QPUBF4tmM0=;
        b=MjHdW/xhQQwuKBAr9WiaQ2w7cB/MF9I4VMEZW2fXKyR+NuDoCVmSbbRLRgXDiTP8Q1
         646xQqWbe01V9V70iPBuZsshkgVsJnJQ98AdSM4y7LHpaeNFCfOxp0o+RvUjJ+BvDw8I
         FM5TTSioWOw19bkwmknaNXGLp8fiNPGW36zsEh6fqu4I3jQMtQZuqlbhu8ClbyyT2Fvl
         EJiLBZLDyLTZ9KGVfwHwkzZhsMxoTZjLO6Yx56MMCehihxhbi5r/uyGK+siavZxdMGBd
         pXzDEYKvU1DaJsT9D2Uu7cnfxU6CVn4LxWc69nIBRwYne0oF1YahkhNUh2DF3+1oKsyo
         avCw==
X-Gm-Message-State: AOAM533r48LoOfQugBCcfurvj5iY0o8Z1smAB1qFNAVzCMnkeS5Ucf4h
        giGgYQaQpYevrOzqiIYVRlclFA==
X-Google-Smtp-Source: ABdhPJyqKJsLFZkTCPWcsm5q4dBZRSraW2bsrajiGbsdcfZ/rP9PVKt5GCeNE7n50dmUAxIoFOhiUA==
X-Received: by 2002:a05:620a:55a:: with SMTP id o26mr2267267qko.43.1615946920091;
        Tue, 16 Mar 2021 19:08:40 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id t5sm12956454qkt.66.2021.03.16.19.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 19:08:39 -0700 (PDT)
Subject: Re: [PATCH 0/7] Add support for AEAD algorithms in Qualcomm Crypto
 Engine driver
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, Bjorn Andersson <bjorn.andersson@linaro.org>,
        Eric Biggers <ebiggers@google.com>, ardb@kernel.org,
        sivaprak@codeaurora.org, linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210304053027.GC25972@gondor.apana.org.au>
 <CALD-y_y8qidsypp7=F-5OLitaq3B1E==c+eQgyqq7hv9t3xcmw@mail.gmail.com>
 <20210312130221.GB17238@gondor.apana.org.au>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <35ef6e54-7865-4587-49b5-711b63b38319@linaro.org>
Date:   Tue, 16 Mar 2021 22:08:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210312130221.GB17238@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 3/12/21 8:02 AM, Herbert Xu wrote:
> On Thu, Mar 04, 2021 at 01:41:15PM -0500, Thara Gopinath wrote:
>>
>> Yes it did. The last patch adds fallback for unsupported cases and
>> this will make it pass the fuzz tests.
> 
> Please include this information in the next round.

I will. Thanks!
> 
> Thanks,
> 

-- 
Warm Regards
Thara
