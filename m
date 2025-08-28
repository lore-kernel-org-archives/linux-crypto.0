Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90761264623;
	Thu, 28 Aug 2025 12:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756385966; cv=none; b=DRjm8FVGtv5QOIND5ua2hHN8bWeBmyFVdiNI8+ll583ZUYZqTz0Otnu4vB419TftD05RhVkW0Q8ttDg9ey1UZd8x8lMe4/m9maXIDsqTormQrGPdP3IcNH/7+Z9wcyuDU/kz7XpkIFZDkLPV3+VR9D/ta5mpOz/0f1cJql4WO0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756385966; c=relaxed/simple;
	bh=vBCWjkfrSux2aJceCBnGfEdia0w9pV1fl3FB/9Iq144=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Wuyj3N8epSr0/dqUrzrVbf6wUpqBwTdbrGF7ha9IO1M71Je6hTZJ0Wf0uG2j8PFS1faU+DTEq2gCEDE9xcfQZI0d3n6Q0z5IzpL5li7citeUmN9PLGipcNH4aeoRHp1CePzOKngydqJ69Gm9BrBqbOC9tpyfMgwzB1CKKueD/14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cCM0v32R3z14Mm2;
	Thu, 28 Aug 2025 20:59:11 +0800 (CST)
Received: from kwepemk200007.china.huawei.com (unknown [7.202.194.73])
	by mail.maildlp.com (Postfix) with ESMTPS id D2D77140123;
	Thu, 28 Aug 2025 20:59:18 +0800 (CST)
Received: from [10.67.121.172] (10.67.121.172) by
 kwepemk200007.china.huawei.com (7.202.194.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 28 Aug 2025 20:59:18 +0800
Message-ID: <2b2b530f-6f29-429a-8549-f2fef8d14c24@hisilicon.com>
Date: Thu, 28 Aug 2025 20:59:04 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] uacce: fix for cdev memory leak
To: Zhangfei Gao <zhangfei.gao@linaro.org>, Chenghai Huang
	<huangchenghai2@huawei.com>
CC: <gregkh@linuxfoundation.org>, <wangzhou1@hisilicon.com>,
	<linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
	<linux-crypto@vger.kernel.org>, <fanghao11@huawei.com>,
	<shenyang39@huawei.com>, <qianweili@huawei.com>, <liulongfang@huawei.com>
References: <20250822103904.3776304-1-huangchenghai2@huawei.com>
 <20250822103904.3776304-2-huangchenghai2@huawei.com>
 <CABQgh9GwQ6mB1q12X8pci=QTCw4R7f4CXLkwMfT-VvGeM+qqkw@mail.gmail.com>
From: "linwenkai (C)" <linwenkai6@hisilicon.com>
In-Reply-To: <CABQgh9GwQ6mB1q12X8pci=QTCw4R7f4CXLkwMfT-VvGeM+qqkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk200007.china.huawei.com (7.202.194.73)


在 2025/8/25 16:20, Zhangfei Gao 写道:
> On Fri, 22 Aug 2025 at 18:39, Chenghai Huang <huangchenghai2@huawei.com> wrote:
>> From: Wenkai Lin <linwenkai6@hisilicon.com>
>>
>> If adding uacce cdev to the system fails, it could be due to two
>> reasons: either the device's devt exists when the failure occurs,
>> or the device_add operation fails. In the latter case, cdev_del
>> will be executed, but in the former case, it will not, leading to a
>> resource leak. Therefore, it is necessary to perform the cdev_del
>> action during abnormal exit.
>>
>> Fixes: 015d239ac014 ("uacce: add uacce driver")
>> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
>> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
>> ---
>>   drivers/misc/uacce/uacce.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
>> index 42e7d2a2a90c..3604f722ed60 100644
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
>> +               cdev_del(uacce->cdev);
> Can cdev_del be called multi-times? since cdev_device_add may call
> cdev_device_add itself.
> Does this introduce another issue?
>
> Not understand the case: "either the device's devt exists when the
> failure occurs,"
> Looks it is cdev_device_add itself issue, or need add check
> if (uacce->dev.devt)
>   cdev_del(uacce->cdev);
> how about other drivers' behavior.

When devt is non-zero, there is still no way to distinguish whether cdev_del

has been executed internally, which might be a  restriction of 
cdev_device_add.

Other drivers often use cdev_init, which does not require consideration

of memory leak, perhaps uacce should use this method too, the plan is to

modify it in v2.

> Thanks
