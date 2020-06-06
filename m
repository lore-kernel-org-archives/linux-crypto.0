Return-Path: <SRS0=oTH+=7T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF27C433E0
	for <linux-crypto@archiver.kernel.org>; Sat,  6 Jun 2020 01:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB4A2206A2
	for <linux-crypto@archiver.kernel.org>; Sat,  6 Jun 2020 01:43:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="guyzmat0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgFFBnC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 21:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728275AbgFFBnC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 21:43:02 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8B1C08C5C2
        for <linux-crypto@vger.kernel.org>; Fri,  5 Jun 2020 18:43:01 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 185so5956836pgb.10
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jun 2020 18:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=DbXAp5/mOHSUcFP2m8gAxFQyaj9/4HkDHeSJAHvf2Nk=;
        b=guyzmat0kRSj8x3VdhawIMvoQHYsLeFauJNEXxE0MRbUB2V51M1Vvl3QRecFNf3hcH
         hM0XPrc64T9pNtRjIbBF8DNKIldsQ2lDkAjx/3rWjYCSovwBPUEBRshuSiA2p8uJ0CH5
         pjf1ltkaAt7VD+v+zlWwja4/tl3TBWXxOSrlavZf0WAewZNGE2prQYLpIGDjR6CjQhK9
         Gubub7dH84Qm+DJ5tEkW3fO/fPWUBkGmjaOsWgBr1JW9CnphaFcJdQngcrvLWKpXaase
         WJKTu12+VxHd6hrhmvsqLzCit5j20BkiOUzQ4tz5W0jEQCNOK3j4fQgI2bo0ZUk1JcAl
         TGQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DbXAp5/mOHSUcFP2m8gAxFQyaj9/4HkDHeSJAHvf2Nk=;
        b=ttNX5vux878ZyCVQ5O3iwOipP8dOdA5LzwiuDvY4UJoP2f2MlmwO3o4Zn09DOfdlSU
         DGJoxCCKOOidchhUr++TAFUS05R6BtOdcndb9Lx+VjKgGXZ0lMPcIv9ZxEdlv9e//yMN
         AbKRYFJbvo1jfGiCO4G64DQCaODdb9syUjRaSOTnPcW7+TcTDc7+MOPo7ODLcoTrEBZK
         0iFblCppJxBFWo1Va6+WPtYM0mMCWsIHzgVP+iBjorZZV/3MazO3RQ31JVn6GtwBTRwl
         Ozr7VPqPQrStpZ3clqdSKMfSFmaEy1JxvBHpdw4jSTdlyY2GzOX5Yqzo0f93Y9kWsFm3
         2ZeA==
X-Gm-Message-State: AOAM532QtmSqzHUVlzqmeBpCpmMe896ZubWq+zTRtXrcnTfEu1p2/DEp
        7DlOFzCbbkrKGu0xeuP9uu7y0g==
X-Google-Smtp-Source: ABdhPJxcd87YcZ9bbiQmBGZIYjSw43dGEGVkhQnC2vBIXHHobdOt4ZFUVFlarn1pk1MXioPWHpje/Q==
X-Received: by 2002:a63:b0f:: with SMTP id 15mr11589015pgl.6.1591407780601;
        Fri, 05 Jun 2020 18:43:00 -0700 (PDT)
Received: from [10.110.2.214] ([45.135.186.59])
        by smtp.gmail.com with ESMTPSA id y4sm599785pgr.76.2020.06.05.18.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 18:42:59 -0700 (PDT)
Subject: Re: [PATCH] crypto: hisilicon - fix strncpy warning with strlcpy
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        wangzhou1 <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        kbuild-all@lists.01.org
References: <202006032110.BEbKqovX%lkp@intel.com>
 <1591241524-6452-1-git-send-email-zhangfei.gao@linaro.org>
 <20200604033918.GA2286@gondor.apana.org.au>
 <b6ad8af2-1cb7-faac-0446-5e09e97f3616@linaro.org>
 <20200604061811.GA28759@gondor.apana.org.au>
 <b23433f8-d95d-8142-c830-fb92e5ccd4a1@linaro.org>
 <20200604065009.GA29822@gondor.apana.org.au>
 <f8dceec5-6835-c064-bb43-fd12668c2dbb@linaro.org>
 <20200605121703.GA3792@gondor.apana.org.au>
 <47b747d2-3b27-4f39-85c9-204c2b8a92e1@linaro.org>
 <20200605154902.GA1373@sol.localdomain>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <e17e20cf-c62b-e4a6-4acc-e08e1c655c90@linaro.org>
Date:   Sat, 6 Jun 2020 09:42:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200605154902.GA1373@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/6/5 下午11:49, Eric Biggers wrote:
> On Fri, Jun 05, 2020 at 11:26:20PM +0800, Zhangfei Gao wrote:
>>
>> On 2020/6/5 下午8:17, Herbert Xu wrote:
>>> On Fri, Jun 05, 2020 at 05:34:32PM +0800, Zhangfei Gao wrote:
>>>> Will add a check after the copy.
>>>>
>>>>           strlcpy(interface.name, pdev->driver->name, sizeof(interface.name));
>>>>           if (strlen(pdev->driver->name) != strlen(interface.name))
>>>>                   return -EINVAL;
>>> You don't need to do strlen.  The function strlcpy returns the
>>> length of the source string.
>>>
>>> Better yet use strscpy which will even return an error for you.
>>>
>>>
>> Yes, good idea, we can use strscpy.
>>
>> +       int ret;
>>
>> -       strncpy(interface.name, pdev->driver->name, sizeof(interface.name));
>> +       ret = strscpy(interface.name, pdev->driver->name,
>> sizeof(interface.name));
>> +       if (ret < 0)
>> +               return ret;
> You might want to use -ENAMETOOLONG instead of the strscpy return value of
> -E2BIG.
Yes, make sense, thanks Eric

