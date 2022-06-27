Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E46C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jun 2022 14:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbiF0OPB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jun 2022 10:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236203AbiF0OOy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jun 2022 10:14:54 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42F513EBC
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jun 2022 07:14:50 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id k14so8301981plh.4
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jun 2022 07:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/1pEyyNCsqbdIDyIk4tQ2++JMSyF3lNesIio8vbDJJ0=;
        b=vRygcjE1RbBzh8t5qstRzPJBuA1Uzs5Ezt/4rabDxNmeFtrfbNKOe1BHEnCROyXVJj
         1lR3ZhoD1OnFXkKOjqQFZHTC+f97zivXNQL3w1MyS6XrsqatKybpSDIJmXmHKtiurwyv
         JQOM85TSdoojed5yzS59daVmnUmU+1SqLjmuI2a3p9XsAcSivCNNKjUKegZ+TUgTb797
         xT9BHQIcZfprUIqB8cJ6EHJ8F1mpxlsupp2mq+EuLInHcsbSvBRua4jtiVwMBYxsH5zV
         HxibyIbmUZ+bPudanwAHAR+1IFSkwnhD4qB7GFKUWZ+ZKiMT2GlQq0zYUTNTUz9nxCrQ
         Vtug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/1pEyyNCsqbdIDyIk4tQ2++JMSyF3lNesIio8vbDJJ0=;
        b=lwhF1zZZvXA//+rmV6RnnPCYxCmy7Ry42CMJl28Sp02BAx0FUkjupzsfiSjapj7g4V
         xYzHKE303zmQFZSkOT92dm4PyAYFcGk44MJR11ZJu1ZUNaDHuhfJhokVMvCdha5bnjem
         MidHzaM3RXjwekrJwiMrDHM/1D5xhsIk4YKlT4zJY1KFE9OftPWRbx/wf/j/IjHxr5+W
         LIBM5bgmXZWXQKtkodCwkaOiCDJAuSC+B2mI7iVTvGQnzdJ1kWX2DoRA2z9WZrnWVox9
         RKiSP7C1hAT4qirqzsoMHJM0AkgWG/wX7AEjwFuXr60x4JQKuH4624EDzkeGDtzGg+aD
         JXOg==
X-Gm-Message-State: AJIora/am2tEZ22ROMdEef7qEcT1XjdvmLmt0CiqsIKQsCbQcF4yIIts
        N4htDbGc7tZnqcQmx3ePrYjCHA==
X-Google-Smtp-Source: AGRyM1s51NooW5cHYYqEauofyEExbdlF2joSTp28zhB89OYB96VIj4M097T3t1l8IEc1OA9uMN0LlQ==
X-Received: by 2002:a17:902:8644:b0:168:fe0e:f92d with SMTP id y4-20020a170902864400b00168fe0ef92dmr14615111plt.23.1656339290034;
        Mon, 27 Jun 2022 07:14:50 -0700 (PDT)
Received: from [10.176.0.6] ([199.101.192.171])
        by smtp.gmail.com with ESMTPSA id g29-20020aa79f1d000000b0051c4f6d2d95sm7440786pfr.106.2022.06.27.07.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 07:14:49 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] uacce: Handle parent driver module removal
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jean-philippe <jean-philippe@linaro.org>,
        Wangzhou <wangzhou1@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        acc@openeuler.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux.dev,
        Yang Shen <shenyang39@huawei.com>
References: <20220624142122.30528-1-zhangfei.gao@linaro.org>
 <20220624142122.30528-2-zhangfei.gao@linaro.org> <Yrmu9DcNObmraG72@kroah.com>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <9ab01d6b-76c2-885c-2827-57912dee62e0@linaro.org>
Date:   Mon, 27 Jun 2022 22:14:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <Yrmu9DcNObmraG72@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2022/6/27 下午9:21, Greg Kroah-Hartman wrote:
> On Fri, Jun 24, 2022 at 10:21:21PM +0800, Zhangfei Gao wrote:
>> Change cdev owner to parent driver owner, which blocks rmmod parent
>> driver module once fd is opened.
>>
>> Signed-off-by: Yang Shen <shenyang39@huawei.com>
>> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
>> ---
>>   drivers/misc/uacce/uacce.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
>> index 281c54003edc..f82f2dd30e76 100644
>> --- a/drivers/misc/uacce/uacce.c
>> +++ b/drivers/misc/uacce/uacce.c
>> @@ -484,7 +484,7 @@ int uacce_register(struct uacce_device *uacce)
>>   		return -ENOMEM;
>>   
>>   	uacce->cdev->ops = &uacce_fops;
>> -	uacce->cdev->owner = THIS_MODULE;
>> +	uacce->cdev->owner = uacce->parent->driver->owner;
> What if parent is not set?  What if parent does not have a driver set to
> it yet?  Why would a device's parent module control the lifespan of this
> child device's cdev?
Have used try_module_get(uacce->parent->driver->owner) in open, and 
module_put in release.
Seems same issue.

>
> This feels wrong and like a layering violation here.
>
> If a parent's module is unloaded, then invalidate the cdev for the
> device when you tear it down before the module is unloaded.

Yes, make sense.
>
> Yes, the interaction between the driver model and a cdev is messy, and
> always tricky (see the recent ksummit discussion about this again, and
> last year's discussion), but that does not mean you should add laying
> violations like this to the codebase.  Please fix this properly.

Thanks Greg

Yes, I was in hesitation whether adding the patch 1, but it looks very 
simple.
In fact, the patch 2 can cover both removing device and rmmod parent 
driver module.

We can just keep patch 2.

Thanks

