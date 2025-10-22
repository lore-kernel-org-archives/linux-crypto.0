Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E2B221F26;
	Wed, 22 Oct 2025 07:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761118661; cv=none; b=o2wRX613gNWx61VgqN5mK8WUaJO/UDwAcKqVWgdvOwQuxEsAxNYIonv4Rtlo34Ka68mRLOV5hnHHeklD76BSJjgPSICi7HVwrTkEzC349ONBzpBcdhScUld66L4r2ffv4T6FBTBpGNf/tlLgGxJI2I6CxNBLtlmwMIzano0zCIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761118661; c=relaxed/simple;
	bh=CNXsacZrYlCizcNkP14G0p+hbYUYpHwtpracQ0YFDWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=AcXMv5Xv8a2jh2VsW7ZAk2deLc8+KEAa2eTFJg2gxYtkYmcuaHGV2bgTFvcM/J7Q3CppVZR40JIiDJiTXlRX2kAnYHbl1xc98HZJEmuC4zGNbB2kC/btkovPufCbm+Iu+TdmUUU97yyCeB7r9aYw3u6IDrT1MwAfdCcyHCkvxWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=RqwbGJUO; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="RqwbGJUO"
Received: from canpmsgout12.his.huawei.com (unknown [172.19.92.144])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cs1FV4pzgznfm2;
	Wed, 22 Oct 2025 15:36:46 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uMulYN+qePmxL2vU5StmzMeZjoafSCMQNt2A3M/a23A=;
	b=RqwbGJUOHi7tAE2d7phDKzoo9ZtzuVj/7aJuYLNnleM3ilmd2ysq5hnzUB58XiON8Ud0mev4d
	15iA3PgL+HRtkdGIUGBdCkaMjjnsep1EMn9VI3NpidZ3qOYmG0PyUvyKax728QvHjoO0nu7AUo7
	fIDIjE1ziPuZpf+vyhQ/t2Y=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cs1FV0hWSznTVF;
	Wed, 22 Oct 2025 15:36:46 +0800 (CST)
Received: from kwepemk200007.china.huawei.com (unknown [7.202.194.73])
	by mail.maildlp.com (Postfix) with ESMTPS id 487911A016C;
	Wed, 22 Oct 2025 15:37:27 +0800 (CST)
Received: from [10.67.121.172] (10.67.121.172) by
 kwepemk200007.china.huawei.com (7.202.194.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 15:37:26 +0800
Message-ID: <2523f498-3723-48a1-8594-83bac35a4ead@hisilicon.com>
Date: Wed, 22 Oct 2025 15:37:26 +0800
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
Regarding your concern, cdev_device_add() use cdev_del rolls back
its cdev_add operations (add the refcount to 2) upon failure when
dev->devt is not null, the refcount of cdev is still 1 after the
rollback, so it does not free the memory of the cdev structure itself.

Therefore, in the error path of uacce_register, we still need to
manually call kobject_put to decrement the refcount of the kobject to
zero within cdev and free it.

Thanks,
Wenkai
