Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135042F60A2;
	Wed, 17 Sep 2025 09:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758102989; cv=none; b=b2nQHOGdiHSn+DkCWuGHlZDHgLRudvYiLgMjsUCiylHbr4ReqfJbgXGd27l1342Vmk7UT0TZBZXIuMIsN8CPdBYaqkE0dxfsKJnXrMUTW53/UKapydX5DY9t2caxkdgBZvCj+NJa1UXGj4cAxVUPPus7Hxx8nzoqBabvus0b8zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758102989; c=relaxed/simple;
	bh=JkKrUSNmn6eFBVBF/ul8YYiOU/ezlAAMmRX8Do1T+O8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TdcEkufOK508IgeTIz48xn7XQwgT5SZt+dwaooo8nQkjuTcdiWLe+gie8ycxP0w9CqWspQQNplglB7JuUW8EfG0hKVg6WPIm+44uy3tcsBTyID6cDOHTYBgvfOwMtbkINqaF2wX01daz/7YCcOBV3iCgjy5VoLgb7NFIXMd8eqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cRYwj1NZGz2VRk1;
	Wed, 17 Sep 2025 17:52:53 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1FE3C18001B;
	Wed, 17 Sep 2025 17:56:18 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Sep 2025 17:56:17 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Sep 2025 17:56:17 +0800
Message-ID: <8e5d4afb-8a21-4a93-a80f-e1f2b6baa8ca@huawei.com>
Date: Wed, 17 Sep 2025 17:56:16 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] uacce: fix for cdev memory leak
To: Greg KH <gregkh@linuxfoundation.org>
CC: <zhangfei.gao@linaro.org>, <wangzhou1@hisilicon.com>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <fanghao11@huawei.com>, <shenyang39@huawei.com>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>
References: <20250916144811.1799687-1-huangchenghai2@huawei.com>
 <20250916144811.1799687-2-huangchenghai2@huawei.com>
 <2025091620-theft-glue-5e7f@gregkh>
From: huangchenghai <huangchenghai2@huawei.com>
Content-Language: en-US
In-Reply-To: <2025091620-theft-glue-5e7f@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200001.china.huawei.com (7.202.195.16)


On Mon, Sep 16, 2025 at 11:15 PM +0800, Greg KH wrote:
> On Tue, Sep 16, 2025 at 10:48:08PM +0800, Chenghai Huang wrote:
>> From: Wenkai Lin <linwenkai6@hisilicon.com>
>>
>> If cdev_device_add failed, it is hard to determine
>> whether cdev_del has been executed, which lead to a
>> memory leak issue, so we use cdev_init to avoid it.
> I do not understand, what is wrong with the current code?  It checks if
> add fails:
>
>> Fixes: 015d239ac014 ("uacce: add uacce driver")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
>> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
>> ---
>>   drivers/misc/uacce/uacce.c | 13 ++++---------
>>   include/linux/uacce.h      |  2 +-
>>   2 files changed, 5 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
>> index 42e7d2a2a90c..12370469f646 100644
>> --- a/drivers/misc/uacce/uacce.c
>> +++ b/drivers/misc/uacce/uacce.c
>> @@ -522,14 +522,10 @@ int uacce_register(struct uacce_device *uacce)
>>   	if (!uacce)
>>   		return -ENODEV;
>>   
>> -	uacce->cdev = cdev_alloc();
>> -	if (!uacce->cdev)
>> -		return -ENOMEM;
> This is the check.
>
>
>> -
>> -	uacce->cdev->ops = &uacce_fops;
>> -	uacce->cdev->owner = THIS_MODULE;
>> +	cdev_init(&uacce->cdev, &uacce_fops);
>> +	uacce->cdev.owner = THIS_MODULE;
>>   
>> -	return cdev_device_add(uacce->cdev, &uacce->dev);
>> +	return cdev_device_add(&uacce->cdev, &uacce->dev);
> And so is this.  So what is wrong here?
>
>
>>   }
>>   EXPORT_SYMBOL_GPL(uacce_register);
>>   
>> @@ -568,8 +564,7 @@ void uacce_remove(struct uacce_device *uacce)
>>   		unmap_mapping_range(q->mapping, 0, 0, 1);
>>   	}
>>   
>> -	if (uacce->cdev)
>> -		cdev_device_del(uacce->cdev, &uacce->dev);
>> +	cdev_device_del(&uacce->cdev, &uacce->dev);
>>   	xa_erase(&uacce_xa, uacce->dev_id);
>>   	/*
>>   	 * uacce exists as long as there are open fds, but ops will be freed
>> diff --git a/include/linux/uacce.h b/include/linux/uacce.h
>> index e290c0269944..98b896192a44 100644
>> --- a/include/linux/uacce.h
>> +++ b/include/linux/uacce.h
>> @@ -126,7 +126,7 @@ struct uacce_device {
>>   	bool is_vf;
>>   	u32 flags;
>>   	u32 dev_id;
>> -	struct cdev *cdev;
>> +	struct cdev cdev;
>>   	struct device dev;
> You can not do this, you now have 2 different reference counts
> controlling the lifespan of this one structure.  That is just going to
> cause so many more bugs...
>
> How was this tested?  What is currently failing that requires this
> change?
>
> thanks,
>
> greg k-h
We analyze it theoretically there may be a memory leak
issue here, if the cdev_device_add returns a failure,
the uacce_remove will not be executed, which results in the
uacce cdev memory not being released.
Therefore, we have decided to align with the design of other
drivers by making cdev a static member of uacce_device and
releasing the memory through uacce_device.

found one example in drivers/watchdog/watchdog_dev.h.
struct watchdog_core_data {
     struct device dev;
     struct cdev cdev;
     struct watchdog_device *wdd;
     struct mutex lock;
     ktime_t last_keepalive;
     ktime_t last_hw_keepalive;
     ktime_t open_deadline;
     ...
};

static int watchdog_cdev_register(struct watchdog_device *wdd)
{
     struct watchdog_core_data *wd_data;
     int err;
     ...
     cdev_init(&wd_data->cdev, &watchdog_fops);
     wd_data->cdev.owner = wdd->ops->owner;

     /* Add the device */
     err = cdev_device_add(&wd_data->cdev, &wd_data->dev);
     ...
}

static void watchdog_cdev_unregister(struct watchdog_device *wdd)
{
     struct watchdog_core_data *wd_data = wdd->wd_data;
     ...
     cdev_device_del(&wd_data->cdev, &wd_data->dev);
     if (wdd->id == 0) {
             misc_deregister(&watchdog_miscdev);
             old_wd_data = NULL;
     }
     ...
}

Thanks,

ChengHai

