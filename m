Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE35E26C391;
	Fri, 26 Sep 2025 09:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758879481; cv=none; b=KDputOfE95DF3GSZqA51T/b3MRJOJK5T/BunBeJE8Rq5GHUWHMBpoFC6GX82zXre3mseNdtJYzGpjl2ubnYKQRoHHeZf9/8rG1saLLiQvuNXOJhKcCs5I1hqDZ8OX3Vr65tE0/AvQqhRrcUDrS5P3ykT1W8d2ukhe1R1T7ns5n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758879481; c=relaxed/simple;
	bh=NIL6k2DPMsux45wF2sJX5fm0A5tzSZzwo3QJ2RUekiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=eSBcNp8v8+uIVylrp953nWK0kouOk0o32Jq3adCgJa3vWtV94u2gQkOR5CdUH6VKheb9E7g6bb0MfXHvnBUVyqbhY8T9BrHbFF7EQZMgZgX7HYUkWX3hc7efNtMAl5mAXYtVrCmnVdOLO3DQxoeW02CuQlLS4I0GU8nIZrBpw64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cY53s2tfmz2Cgn0;
	Fri, 26 Sep 2025 17:33:13 +0800 (CST)
Received: from kwepemk200007.china.huawei.com (unknown [7.202.194.73])
	by mail.maildlp.com (Postfix) with ESMTPS id CEDCA1A0171;
	Fri, 26 Sep 2025 17:37:52 +0800 (CST)
Received: from [10.67.121.172] (10.67.121.172) by
 kwepemk200007.china.huawei.com (7.202.194.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 26 Sep 2025 17:37:52 +0800
Message-ID: <d7e82e65-5257-4d72-9fac-91d588770b44@hisilicon.com>
Date: Fri, 26 Sep 2025 17:37:51 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] uacce: fix for cdev memory leak
To: huangchenghai <huangchenghai2@huawei.com>, Greg KH
	<gregkh@linuxfoundation.org>
CC: <zhangfei.gao@linaro.org>, <wangzhou1@hisilicon.com>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <fanghao11@huawei.com>, <shenyang39@huawei.com>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>
References: <20250916144811.1799687-1-huangchenghai2@huawei.com>
 <20250916144811.1799687-2-huangchenghai2@huawei.com>
 <2025091620-theft-glue-5e7f@gregkh>
 <8e5d4afb-8a21-4a93-a80f-e1f2b6baa8ca@huawei.com>
 <2025091746-starship-nearest-7c10@gregkh>
 <c9b562b4-dd34-411c-91cc-5eda3eadd1de@huawei.com>
From: "linwenkai (C)" <linwenkai6@hisilicon.com>
In-Reply-To: <c9b562b4-dd34-411c-91cc-5eda3eadd1de@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk200007.china.huawei.com (7.202.194.73)


在 2025/9/26 16:47, huangchenghai 写道:
>
> On Wed, Sep 17, 2025 at 06:18 PM +0800, Greg KH wrote:
>> On Wed, Sep 17, 2025 at 05:56:16PM +0800, huangchenghai wrote:
>>> On Mon, Sep 16, 2025 at 11:15 PM +0800, Greg KH wrote:
>>>> On Tue, Sep 16, 2025 at 10:48:08PM +0800, Chenghai Huang wrote:
>>>>> From: Wenkai Lin <linwenkai6@hisilicon.com>
>>>>>
>>>>> If cdev_device_add failed, it is hard to determine
>>>>> whether cdev_del has been executed, which lead to a
>>>>> memory leak issue, so we use cdev_init to avoid it.
>>>> I do not understand, what is wrong with the current code? It checks if
>>>> add fails:
>>>>
>>>>> Fixes: 015d239ac014 ("uacce: add uacce driver")
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
>>>>> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
>>>>> ---
>>>>>    drivers/misc/uacce/uacce.c | 13 ++++---------
>>>>>    include/linux/uacce.h      |  2 +-
>>>>>    2 files changed, 5 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
>>>>> index 42e7d2a2a90c..12370469f646 100644
>>>>> --- a/drivers/misc/uacce/uacce.c
>>>>> +++ b/drivers/misc/uacce/uacce.c
>>>>> @@ -522,14 +522,10 @@ int uacce_register(struct uacce_device *uacce)
>>>>>        if (!uacce)
>>>>>            return -ENODEV;
>>>>> -    uacce->cdev = cdev_alloc();
>>>>> -    if (!uacce->cdev)
>>>>> -        return -ENOMEM;
>>>> This is the check.
>>>>
>>>>
>>>>> -
>>>>> -    uacce->cdev->ops = &uacce_fops;
>>>>> -    uacce->cdev->owner = THIS_MODULE;
>>>>> +    cdev_init(&uacce->cdev, &uacce_fops);
>>>>> +    uacce->cdev.owner = THIS_MODULE;
>>>>> -    return cdev_device_add(uacce->cdev, &uacce->dev);
>>>>> +    return cdev_device_add(&uacce->cdev, &uacce->dev);
>>>> And so is this.  So what is wrong here?
>>>>
>>>>
>>>>>    }
>>>>>    EXPORT_SYMBOL_GPL(uacce_register);
>>>>> @@ -568,8 +564,7 @@ void uacce_remove(struct uacce_device *uacce)
>>>>>            unmap_mapping_range(q->mapping, 0, 0, 1);
>>>>>        }
>>>>> -    if (uacce->cdev)
>>>>> -        cdev_device_del(uacce->cdev, &uacce->dev);
>>>>> +    cdev_device_del(&uacce->cdev, &uacce->dev);
>>>>>        xa_erase(&uacce_xa, uacce->dev_id);
>>>>>        /*
>>>>>         * uacce exists as long as there are open fds, but ops will 
>>>>> be freed
>>>>> diff --git a/include/linux/uacce.h b/include/linux/uacce.h
>>>>> index e290c0269944..98b896192a44 100644
>>>>> --- a/include/linux/uacce.h
>>>>> +++ b/include/linux/uacce.h
>>>>> @@ -126,7 +126,7 @@ struct uacce_device {
>>>>>        bool is_vf;
>>>>>        u32 flags;
>>>>>        u32 dev_id;
>>>>> -    struct cdev *cdev;
>>>>> +    struct cdev cdev;
>>>>>        struct device dev;
>>>> You can not do this, you now have 2 different reference counts
>>>> controlling the lifespan of this one structure.  That is just going to
>>>> cause so many more bugs...
>>>>
>>>> How was this tested?  What is currently failing that requires this
>>>> change?
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>> We analyze it theoretically there may be a memory leak
>>> issue here, if the cdev_device_add returns a failure,
>>> the uacce_remove will not be executed, which results in the
>>> uacce cdev memory not being released.
>> Then properly clean up if that happens.
>>
>>> Therefore, we have decided to align with the design of other
>>> drivers by making cdev a static member of uacce_device and
>>> releasing the memory through uacce_device.
>> But again, this is wrong to do.
>>
>>> found one example in drivers/watchdog/watchdog_dev.h.
>>> struct watchdog_core_data {
>>>      struct device dev;
>>>      struct cdev cdev;
>> This is also wrong and needs to be fixed.  Please send a patch to
>> resolve it as well, as it should not be copied as a valid example.
>>
>> thanks,
>>
>> greg k-h
> Very sorry for the delayed response.
>
> In v1, our first thought was that if cdev_device_add returns a
> failure, we could release the resources allocated by cdev_alloc
> using cdev_del. For this, we attempted the following modification:
>
> @@ -519,6 +519,8 @@ EXPORT_SYMBOL_GPL(uacce_alloc);
>   */
>  int uacce_register(struct uacce_device *uacce)
>  {
> +    int ret;
> +
>      if (!uacce)
>          return -ENODEV;
>
> @@ -529,7 +531,14 @@ int uacce_register(struct uacce_device *uacce)
>      uacce->cdev->ops = &uacce_fops;
>      uacce->cdev->owner = THIS_MODULE;
>
> -    return cdev_device_add(uacce->cdev, &uacce->dev);
> +    ret = cdev_device_add(uacce->cdev, &uacce->dev);
> +    if (ret) {
> +        cdev_del(uacce->cdev);
> +        uacce->cdev = NULL;
> +        return ret;
> +    }
> +
> +    return 0;
>  }
>
> However, after further analysis, we found that cdev_device_add does
> not increment the reference count when it fails. Therefore, in this
> case, cdev_del is not necessary. This means that the resources
> allocated by cdev_alloc will not cause a memory leak in the failure
> path.
>
> Thus, I believe this patch modification is unnecessary. In the
> upcoming v3 version, I will remove this modification.
>
> Thank you for your patient guidance!
>
> Best regards,
> Chenghai
>>
After further analysis, it was found that during the cdev_alloc
process, the reference count of the cdev is initialized to 1.

If kobject_put is not actively executed, the release function of
the cdev cannot be called, and the memory will never be released,
leading to a leak, so kobject_put is still necessary here?

Here is the new solution:
@@ -519,6 +519,8 @@ EXPORT_SYMBOL_GPL(uacce_alloc);
   */
  int uacce_register(struct uacce_device *uacce)
  {
+    int ret;
+
      if (!uacce)
          return -ENODEV;

@@ -529,7 +531,14 @@ int uacce_register(struct uacce_device *uacce)
      uacce->cdev->ops = &uacce_fops;
      uacce->cdev->owner = THIS_MODULE;

-    return cdev_device_add(uacce->cdev, &uacce->dev);
+    ret = cdev_device_add(uacce->cdev, &uacce->dev);
+    if (ret) {
+        kobject_put(&uacce->cdev->kobject);
+        uacce->cdev = NULL;
+        return ret;
+    }
+
+    return 0;
  }

Thanks,
WenKai
