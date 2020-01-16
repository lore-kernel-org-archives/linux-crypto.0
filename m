Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAD5C32771
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 02:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2F57222C3
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 02:12:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i2BXAPLH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbgAPCMC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jan 2020 21:12:02 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54769 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730599AbgAPCMB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jan 2020 21:12:01 -0500
Received: by mail-pj1-f66.google.com with SMTP id kx11so787340pjb.4
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jan 2020 18:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ISxVLQvK8s5nY6LD7WJ8K+q3IuJWjWSPNsTVjYjwR80=;
        b=i2BXAPLH47Eap5rnuaSk8R3uM2RBSpnlp2GmGBNYBu9aWN7QmFKWYXXjSZ0zO2NJ5l
         TtgRXB620x7o7cZqjHRAu5vtlw8XUy026f4IXofijWYbgiqL6OZkmTv0LALmnqLA3GI0
         apyz/E6RIb6mnB31hZ5IWR9SRCdBnv3ROCv4zfnvf7ABKpOha1w44MuNGwgY5aDHoGfy
         dZNbKRKgKfaNxkoOSGBRVZPlGyIOAkWZEpoZY0gUle3V95e44IgMYbrwbTbw+qWnwwFc
         tMqnci8VTrjsBHDFf1sunwD9DjGW33qVtO23fpOgUW05G3QsHLKwN/RpRkVszP7ZITFN
         QhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ISxVLQvK8s5nY6LD7WJ8K+q3IuJWjWSPNsTVjYjwR80=;
        b=JS8T5j8fOk/k/y+70/t0T/v+6Zob3iPDglBu1wXDi3wInrFMbiS5gh4W9B9HnP7DXG
         P6dKvWxP6LK13r0aOP5MrqCi1gS8VwUYW8563BqVNLFNpjerVN7Vvo0dHb8SdRIWzREO
         xLOzGZY9fHnqDFW8e4GXIGqUMU2khgdSwcxLnJD7lMzyl2c+2lvblqB+0qLE02AJ7fsV
         o3BFwBhlrv7/X0U6NKvwBz8LYiRPFt8A4AhBh3ODfAiowuvLsB7jLgs4ryyP1JViEvuT
         LaGP7T3LuTasovUGMif8amc/YZpjGr3yVHfadgfoZemOHOj4BzK77AGcZR79T+ggkMgj
         Y6zQ==
X-Gm-Message-State: APjAAAUayidB4fabZJ92wmFuaFpvBKcQKjvvtsjqDyxDdUxKd1nRRtt9
        wZQtS6y7zRTYWGqUa7A8pGmJ7g==
X-Google-Smtp-Source: APXvYqwPtaRpD5q+1zpA9jWTonAeFglbEPocCdD4h8NzV1Oc8GcurWseUbRfe1v2M61Rtj3lXNrDwA==
X-Received: by 2002:a17:902:462:: with SMTP id 89mr29644947ple.270.1579140720839;
        Wed, 15 Jan 2020 18:12:00 -0800 (PST)
Received: from ?IPv6:240e:362:43d:200:56f:3d32:378b:3366? ([240e:362:43d:200:56f:3d32:378b:3366])
        by smtp.gmail.com with ESMTPSA id g11sm22149064pgd.26.2020.01.15.18.11.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jan 2020 18:12:00 -0800 (PST)
Subject: Re: [PATCH v11 2/4] uacce: add uacce driver
To:     Dave Jiang <dave.jiang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
References: <1578710919-12141-1-git-send-email-zhangfei.gao@linaro.org>
 <1578710919-12141-3-git-send-email-zhangfei.gao@linaro.org>
 <20200111194006.GD435222@kroah.com>
 <053ccd05-4f11-5be6-47c2-eee5c2f1fdc4@linaro.org>
 <20200114145934.GA1960403@kroah.com>
 <c71b402c-a185-50a7-2827-c1836cc6c237@linaro.org>
 <9454d674-85db-32ba-4f28-eb732777d59d@intel.com>
From:   zhangfei <zhangfei.gao@linaro.org>
Message-ID: <6c08d1ad-53a5-0238-3767-c40d7b10df3c@linaro.org>
Date:   Thu, 16 Jan 2020 10:11:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <9454d674-85db-32ba-4f28-eb732777d59d@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Dave

On 2020/1/16 上午12:43, Dave Jiang wrote:
>
>
> On 1/15/20 4:18 AM, zhangfei wrote:
>> Hi, Greg
>>
>> On 2020/1/14 下午10:59, Greg Kroah-Hartman wrote:
>>> On Mon, Jan 13, 2020 at 11:34:55AM +0800, zhangfei wrote:
>>>> Hi, Greg
>>>>
>>>> Thanks for the review.
>>>>
>>>> On 2020/1/12 上午3:40, Greg Kroah-Hartman wrote:
>>>>> On Sat, Jan 11, 2020 at 10:48:37AM +0800, Zhangfei Gao wrote:
>>>>>> +static int uacce_fops_open(struct inode *inode, struct file *filep)
>>>>>> +{
>>>>>> +    struct uacce_mm *uacce_mm = NULL;
>>>>>> +    struct uacce_device *uacce;
>>>>>> +    struct uacce_queue *q;
>>>>>> +    int ret = 0;
>>>>>> +
>>>>>> +    uacce = xa_load(&uacce_xa, iminor(inode));
>>>>>> +    if (!uacce)
>>>>>> +        return -ENODEV;
>>>>>> +
>>>>>> +    if (!try_module_get(uacce->parent->driver->owner))
>>>>>> +        return -ENODEV;
>>>>> Why are you trying to grab the module reference of the parent device?
>>>>> Why is that needed and what is that going to help with here?
>>>>>
>>>>> This shouldn't be needed as the module reference of the owner of the
>>>>> fileops for this module is incremented, and the "parent" module 
>>>>> depends
>>>>> on this module, so how could it be unloaded without this code being
>>>>> unloaded?
>>>>>
>>>>> Yes, if you build this code into the kernel and the "parent" 
>>>>> driver is a
>>>>> module, then you will not have a reference, but when you remove that
>>>>> parent driver the device will be removed as it has to be unregistered
>>>>> before that parent driver can be removed from the system, right?
>>>>>
>>>>> Or what am I missing here?
>>>> The refcount here is preventing rmmod "parent" module after fd is 
>>>> opened,
>>>> since user driver has mmap kernel memory to user space, like mmio, 
>>>> which may
>>>> still in-use.
>>>>
>>>> With the refcount protection, rmmod "parent" module will fail until
>>>> application free the fd.
>>>> log like: rmmod: ERROR: Module hisi_zip is in use
>>> But if the "parent" module is to be unloaded, it has to unregister the
>>> "child" device and that will call the destructor in here and then you
>>> will tear everything down and all should be good.
>>>
>>> There's no need to "forbid" a module from being unloaded, even if it is
>>> being used.  Look at all networking drivers, they work that way, right?
>> Thanks Greg for the kind suggestion.
>>
>> I still have one uncertainty.
>> Does uacce has to block process continue accessing the mmapped area 
>> when remove "parent" module?
>> Uacce can block device access the physical memory when parent module 
>> call uacce_remove.
>> But application is still running, and suppose it is not the kernel 
>> driver's responsibility to call unmap.
>>
>> I am looking for some examples in kernel,
>> looks vfio does not block process continue accessing when 
>> vfio_unregister_iommu_driver either.
>>
>> In my test, application will keep waiting after rmmod parent, until 
>> ctrl+c, when unmap is called.
>> During the process, kernel does not report any error.
>>
>> Do you have any advice?
>
> Would it work to call unmap_mapping_range() on the char dev 
> inode->i_mappings? I think you need to set the vma->fault function ptr 
> for the vm_operations_struct in the original mmap(). After the 
> mappings are unmapped, you can set a state variable to trigger the 
> return of VM_FAULT_SIGBUS in the ->fault function when the user app 
> accesses the mmap region again and triggers a page fault. The user app 
> needs to be programmed to catch exceptions to deal with that.

Thanks Dave for the advice.
Will look into it, may need some time to investigate.
I would like to make an additional patch for this issue, since it does 
not impact the main function.

Thanks

