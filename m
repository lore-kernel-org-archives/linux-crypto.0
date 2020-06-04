Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58ADAC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 06:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D8F8207DA
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 06:44:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gzRnbTkc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgFDGo2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 02:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgFDGo2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 02:44:28 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F34C03E96D
        for <linux-crypto@vger.kernel.org>; Wed,  3 Jun 2020 23:44:28 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id e9so3013223pgo.9
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jun 2020 23:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=lQVlXH+uj/MULxrEGj2byT6IBDKh5uPIe65HnVp2khs=;
        b=gzRnbTkcAnqvYEoVW9YseGY+0u1VoTMW/IO49nxbU4/b5h6mTCySH8tG+xs+BPJv/6
         KRDGlwtV9Ah7167fzuEQ8xp4anjyd5TQkJJ69SvgbXyirs97ICE1UiVX3L19uqWuQjAP
         3sot+5jrOtfXbLnpKCD/twibMkrA8D4z22h6fVm1qdzWoymfGSQkMemFvoN8iU3SWC3J
         10VJ1+++UoYEjyFX96NS4Co2pCuWJ/3yrjzugj9djTKFrXCDsNYr3XinRwGWguYuoCwg
         fyPAolJ41+4q6j+lvVYWBlvSj23VuYFXKER+6olegZJTTXe1Cl3lXoVoe6USONUNZocH
         Fz9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lQVlXH+uj/MULxrEGj2byT6IBDKh5uPIe65HnVp2khs=;
        b=jfSZTFZh3Rqcm/Mjb6wNiVpu8rb9JDCmbw7QLK2UsW+JkmBefjECQQ7WkogzoABycn
         9O+e+kuo8N3L0F+WieigEk5x2UtbRrwu7uuCZeAiooHF6plYYeojnlhqt4S0+SC/5PwY
         OkLlFjFbj7a5UMk7uDrWEZayo5etp6BO+lVG6xPkjuQYPOksQejydtFou2GkAMoy9Gf6
         bjEsHOHUNDZBcE8fakfdJ2mesfHhj6FpvjkiOCgi5EqbrmMF6lAWJjKh/lsqHym8tqjl
         WEF+oILiAikPRv8sCzU0kTKHofDnXDwDgi9lvIHhFSQQBPPI80TizfLV6Ou6DmZfTX9Q
         am1A==
X-Gm-Message-State: AOAM533g7Ijrt9Fz4e03bvdfRkkVKUB/7yEsD2JlNCtBxgs8S1XSM1Tz
        Lj3C3oZdpPMbs+oHy1Q/he1lQg==
X-Google-Smtp-Source: ABdhPJyTNTnMWGua4MqL8tx6aHu8UCUxEO5kUDj97h0sJ9J229Uu3bn79HTRPASqqjCM+e2BTW3S9Q==
X-Received: by 2002:a63:ad43:: with SMTP id y3mr2934343pgo.435.1591253067552;
        Wed, 03 Jun 2020 23:44:27 -0700 (PDT)
Received: from [10.15.1.238] ([45.135.186.21])
        by smtp.gmail.com with ESMTPSA id b140sm3461949pfb.119.2020.06.03.23.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 23:44:27 -0700 (PDT)
Subject: Re: [PATCH] crypto: hisilicon - fix strncpy warning with strlcpy
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        wangzhou1 <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        kbuild-all@lists.01.org
References: <202006032110.BEbKqovX%lkp@intel.com>
 <1591241524-6452-1-git-send-email-zhangfei.gao@linaro.org>
 <20200604033918.GA2286@gondor.apana.org.au>
 <b6ad8af2-1cb7-faac-0446-5e09e97f3616@linaro.org>
 <20200604061811.GA28759@gondor.apana.org.au>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <b23433f8-d95d-8142-c830-fb92e5ccd4a1@linaro.org>
Date:   Thu, 4 Jun 2020 14:44:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200604061811.GA28759@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/6/4 下午2:18, Herbert Xu wrote:
> On Thu, Jun 04, 2020 at 02:10:37PM +0800, Zhangfei Gao wrote:
>>> Should this even allow truncation? Perhaps it'd be better to fail
>>> in case of an overrun?
>> I think we do not need consider overrun, since it at most copy size-1 bytes
>> to dest.
>>  From the manual: strlcpy()
>>         This  function  is  similar  to  strncpy(), but it copies at most
>> size-1 bytes to dest, always adds a terminating null
>>         byte,
>> And simple tested with smaller SIZE of interface.name,  only SIZE-1 is
>> copied, so it is safe.
>> -#define UACCE_MAX_NAME_SIZE    64
>> +#define UACCE_MAX_NAME_SIZE    4
> That's not what I meant.  As it is if you do exceed the limit the
> name is silently truncated.  Wouldn't it be better to fail the
> allocation instead?
I think it is fine.
1. Currently the name size is 64, bigger enough.
Simply grep in driver name, 64 should be enough.
We can make it larger when there is a request.
2. it does not matter what the name is, since it is just an interface.
cat /sys/class/uacce/hisi_zip-0/flags
cat /sys/class/uacce/his-0/flags
should be both fine to app only they can be distinguished.
3. It maybe a hard restriction to fail just because of a long name.

What do you think.

Thanks
