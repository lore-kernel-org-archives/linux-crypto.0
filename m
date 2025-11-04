Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A332D8DD0;
	Tue,  4 Nov 2025 12:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762260072; cv=none; b=H40qHw5X33I7qB/89o9+jusQBQt86M+Iui/DCvMjbuOmf01wFFmRBFSxAra+OuCDQ0Qde6kEnN/3ihCEANjizRUfi8ZLAF6HeLwiWsFZ5egOxphmz3eLGVZhKL5BzBWIIJ41BRvb/BHb/1x7Xha7pPSkqkf3IVCxFLVyx4T2048=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762260072; c=relaxed/simple;
	bh=asMVvWaDfRW//ZOtOFF0CvCOuu/R5Hw+oNHDV3Cvk8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tJCl+RlLFV2NdT7ult32ZiXnOL3NAYJhPJhYja0pJdiiVNyxb0UBYo838TlLRSSi5oTkgBi/DQDPJJyMjP0CIaWQwaUX4EAcHeFHvrI2eIM5f+0SwqJ13QHSZVxsCtX9jE7A3loAtWsd94gJhgf92J34iL7TR2B6FWSfdj1daRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=ZYp3+Ern; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="ZYp3+Ern"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3uXoQaYvR1z5GQkw6T1nnphvPuxtVByjX6LrFkv7c5A=;
	b=ZYp3+ErnpScjfSEx3YxParwax6XWkI+5qA/h3UVi5WjdWJTznzjjdps/zSeFctfVst6ZMhABn
	qwrKvOWm9qy/7x3u8WiHVmBU0lucQgHbpC8sx/5IHrntZ9CxaV8r2nlpx5lRG0HnutMqWVIHnKH
	uXFkuNNFahHDj6cN2iBVdWM=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4d17Ln0SlMzLlT0;
	Tue,  4 Nov 2025 20:39:29 +0800 (CST)
Received: from kwepemk200007.china.huawei.com (unknown [7.202.194.73])
	by mail.maildlp.com (Postfix) with ESMTPS id 66D121A0188;
	Tue,  4 Nov 2025 20:41:03 +0800 (CST)
Received: from [10.67.121.172] (10.67.121.172) by
 kwepemk200007.china.huawei.com (7.202.194.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 20:41:02 +0800
Message-ID: <12a8a634-f256-45e8-be74-a283e8edce9c@hisilicon.com>
Date: Tue, 4 Nov 2025 20:41:02 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] uacce: fix for cdev memory leak
To: Zhangfei Gao <zhangfei.gao@linaro.org>, Chenghai Huang
	<huangchenghai2@huawei.com>
CC: <gregkh@linuxfoundation.org>, <wangzhou1@hisilicon.com>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <shenyang39@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>
References: <20251022021149.1771168-1-huangchenghai2@huawei.com>
 <20251022021149.1771168-2-huangchenghai2@huawei.com>
 <CABQgh9HFHSstR19NtOw5c6E+qS7_d_=6qnCYq9VY6DNKT6o3ng@mail.gmail.com>
From: "linwenkai (C)" <linwenkai6@hisilicon.com>
In-Reply-To: <CABQgh9HFHSstR19NtOw5c6E+qS7_d_=6qnCYq9VY6DNKT6o3ng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk200007.china.huawei.com (7.202.194.73)


在 2025/10/22 14:17, Zhangfei Gao 写道:
> On Wed, 22 Oct 2025 at 10:12, Chenghai Huang <huangchenghai2@huawei.com> wrote:
>> From: Wenkai Lin <linwenkai6@hisilicon.com>
>>
>> In uacce_register(), if cdev_device_add() fails, we should properly
>> decrease the reference count of the cdev kobject and set uacce->cdev
>> to NULL to avoid potential use-after-free or double free issues.
>>
>> This change adds proper error handling after cdev_device_add() fails,
>> ensuring that kobject_put() is called and uacce->cdev is cleared.
>>
>> Fixes: 015d239ac014 ("uacce: add uacce driver")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
>> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
>> ---
>>   drivers/misc/uacce/uacce.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
>> index 42e7d2a2a90c..9b82a6731832 100644
>> --- a/drivers/misc/uacce/uacce.c
>> +++ b/drivers/misc/uacce/uacce.c
>> @@ -519,6 +519,8 @@ EXPORT_SYMBOL_GPL(uacce_alloc);
>>    */
>>   int uacce_register(struct uacce_device *uacce)
>>   {
>> +       int ret;
>> +
>>          if (!uacce)
>>                  return -ENODEV;
>>
>> @@ -529,7 +531,14 @@ int uacce_register(struct uacce_device *uacce)
>>          uacce->cdev->ops = &uacce_fops;
>>          uacce->cdev->owner = THIS_MODULE;
>>
>> -       return cdev_device_add(uacce->cdev, &uacce->dev);
>> +       ret = cdev_device_add(uacce->cdev, &uacce->dev);
>> +       if (ret) {
>> +               kobject_put(&uacce->cdev->kobj);
> Not understanding this,
> What if kobject_put(&p->kobj) is called twice?
> cdev_device_add would call cdev_del->kobject_put(&p->kobj) as well.
>
> If you think cdev_device_add has an issue, maybe fixing
> cdev_device_add itself is better?
>
> Thanks
After more testing, a new conclusion was reached.

After the cdev_set_parent function in cdev_device_add is called,
the cdev and the device will share the same lifetime and the memory
of the cdev is managed by the device.
So when put_device is called in the uacce_remove, the memory of the cdev
will also be released, so there is no memory leak issue in the code.

In addition, when cdev_device_add fails, a flag should be set to detect
this situation to prevent the uacce_remove from incorrectly calling
cdev_device_del to release the unallocated resources.
This issue will be fixed in the next patch.

Thanks,
Wenkai
