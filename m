Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4209C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jun 2022 06:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379746AbiFQGFb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jun 2022 02:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiFQGFa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jun 2022 02:05:30 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE9011158
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jun 2022 23:05:29 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id w19-20020a17090a8a1300b001ec79064d8dso408314pjn.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jun 2022 23:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=hr1DvHgRKVwFFs3GnYKSdW/r6E3KQ20avG9OQnOIekI=;
        b=C9coYDLUoKd71hlkBvzPkdaOsLrcAmU67cb+Wb/aq4db4IWuJ45WMqWpHTInqbaWeA
         geGjYU+Hjl6jShCVqNrAP2QBlICq6ApiSLWYvnLLRWR3m1RZtQEnG12AX88R16PR/Z0C
         JxBYVrAUJ5RPXMQnjh0fEUv+dDd/VZvhpWn196R8kWafbO+7PV0mFAqkptyqRCFqMzvE
         PUBYUCbD8YjvsaBjTuwfAaZx/z6Y9hHM3BgVq+tBCBG9MlGhVrsx4XTLsuy0KCgWByhr
         PRzC+tYKAYkObRlTmpSG6YF/Gmbh7xOIzOt7nJOceLLje2Wl6ZvEmRGtBHcMJzAX2arB
         JkPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hr1DvHgRKVwFFs3GnYKSdW/r6E3KQ20avG9OQnOIekI=;
        b=E4ZYKsw8Gx04rk5LUS/o5t+VqGm6ZIUXYm9yUyf6OJXGEXXPgkiqJhn1Fp2TUvjp9v
         FgRkq+hDUUTgTjO/OVpaWbPVrJyxVYml6tpzcYvSzoqHT8HYaDBGixtPODEkzT5iwA0h
         0rfOub00pnZ9J7rc7eN4WxXQVfxIcJ0C1hTgsXSbgzGJW9XqWtBn9MuB3KjN7VhTJVbL
         6cnOZl5VEWi0GAhe6cQY0tTv1HfargDI3PlCevPxWEUL0zNS4Fob+ufesxAZ/DGO/oyM
         nuVs4ThavtWJy0h5GvpIsULE3rAKHIQTJ2+tr5MGvQ/7N4L4s2v7kP163jEGBgphX7+K
         HKIA==
X-Gm-Message-State: AJIora8LFNXs9LBsfB5ghEwyrv0AsyKdqpAisIgMrsVuqnmXhcq9sasY
        h4kl/pQek0ljGQI1kqZ25BYn8w==
X-Google-Smtp-Source: AGRyM1uiaMIGymdgFePwN95624WGlKC3MieAgDLn29xOGvCxCRUevfFmDABWgQ4fRn7G9pR0FV2CFw==
X-Received: by 2002:a17:90b:1986:b0:1ec:71f6:5fd9 with SMTP id mv6-20020a17090b198600b001ec71f65fd9mr2954395pjb.188.1655445928835;
        Thu, 16 Jun 2022 23:05:28 -0700 (PDT)
Received: from [10.83.0.6] ([199.101.192.187])
        by smtp.gmail.com with ESMTPSA id y11-20020a170902d64b00b00161955fe0d5sm2606256plh.274.2022.06.16.23.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 23:05:28 -0700 (PDT)
Subject: Re: [PATCH] uacce: fix concurrency of fops_open and uacce_remove
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Wangzhou <wangzhou1@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        Yang Shen <shenyang39@huawei.com>
References: <20220610123423.27496-1-zhangfei.gao@linaro.org>
 <Yqn3spLZHpAkQ9Us@myrica> <fdc8d8b0-4e04-78f5-1e8a-4cf44c89a37f@linaro.org>
 <YqrmdKNrYTCiS/MC@myrica>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <d90e8ea5-2f18-2eda-b4b2-711083aa7ecd@linaro.org>
Date:   Fri, 17 Jun 2022 14:05:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YqrmdKNrYTCiS/MC@myrica>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2022/6/16 下午4:14, Jean-Philippe Brucker wrote:
> On Thu, Jun 16, 2022 at 12:10:18PM +0800, Zhangfei Gao wrote:
>>>> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
>>>> index 281c54003edc..b6219c6bfb48 100644
>>>> --- a/drivers/misc/uacce/uacce.c
>>>> +++ b/drivers/misc/uacce/uacce.c
>>>> @@ -136,9 +136,16 @@ static int uacce_fops_open(struct inode *inode, struct file *filep)
>>>>    	if (!q)
>>>>    		return -ENOMEM;
>>>> +	mutex_lock(&uacce->queues_lock);
>>>> +
>>>> +	if (!uacce->parent->driver) {
>>> I don't think this is useful, because the core clears parent->driver after
>>> having run uacce_remove():
>>>
>>>     rmmod hisi_zip		open()
>>>      ...				 uacce_fops_open()
>>>      __device_release_driver()	  ...
>>>       pci_device_remove()
>>>        hisi_zip_remove()
>>>         hisi_qm_uninit()
>>>          uacce_remove()
>>>           ...			  ...
>>>      				  mutex_lock(uacce->queues_lock)
>>>       ...				  if (!uacce->parent->driver)
>>>       device_unbind_cleanup()	  /* driver still valid, proceed */
>>>        dev->driver = NULL
>> The check  if (!uacce->parent->driver) is required, otherwise NULL pointer
>> may happen.
> I agree we need something, what I mean is that this check is not
> sufficient.
>
>> iommu_sva_bind_device
>> const struct iommu_ops *ops = dev_iommu_ops(dev);  ->
>> dev->iommu->iommu_dev->ops
>>
>> rmmod has no issue, but remove parent pci device has the issue.
> Ah right, relying on the return value of bind() wouldn't be enough even if
> we mandated SVA.
>
> [...]
>>> I think we need the global uacce_mutex to serialize uacce_remove() and
>>> uacce_fops_open(). uacce_remove() would do everything, including
>>> xa_erase(), while holding that mutex. And uacce_fops_open() would try to
>>> obtain the uacce object from the xarray while holding the mutex, which
>>> fails if the uacce object is being removed.
>> Since fops_open get char device refcount, uacce_release will not happen
>> until open returns.
> The refcount only ensures that the uacce_device object is not freed as
> long as there are open fds. But uacce_remove() can run while there are
> open fds, or fds in the process of being opened. And atfer uacce_remove()
> runs, the uacce_device object still exists but is mostly unusable. For
> example once the module is freed, uacce->ops is not valid anymore. But
> currently uacce_fops_open() may dereference the ops in this case:
>
> 	uacce_fops_open()
> 	 if (!uacce->parent->driver)
> 	 /* Still valid, keep going */		
> 	 ...					rmmod
> 						 uacce_remove()
> 	 ...					 free_module()
> 	 uacce->ops->get_queue() /* BUG */

uacce_remove should wait for uacce->queues_lock, until fops_open release 
the lock.
If open happen just after the uacce_remove: unlock, uacce_bind_queue in 
open should fail.

> Accessing uacce->ops after free_module() is a use-after-free. We need all
you men parent release the resources.
> the fops to synchronize with uacce_remove() to ensure they don't use any
> resource of the parent after it's been freed.
After fops_open, currently we are counting on parent driver stop all dma 
first, then call uacce_remove, which is assumption.
Like drivers/crypto/hisilicon/zip/zip_main.c: hisi_qm_wait_task_finish, 
which will wait uacce_release.
If comments this , there may other issue,
Unable to handle kernel paging request at virtual address ffff80000b700204
pc : hisi_qm_cache_wb.part.0+0x2c/0xa0

> I see uacce_fops_poll() may have the same problem, and should be inside
> uacce_mutex.
Do we need consider this, uacce_remove can happen anytime but not 
waiting dma stop?

Not sure uacce_mutex can do this.
Currently the sequence is
mutex_lock(&uacce->queues_lock);
mutex_lock(&uacce_mutex);

Or we set all the callbacks of uacce_ops to NULL?
Module_get/put only works for module, but not for removing device.

Thanks

>
> Thanks,
> Jean

