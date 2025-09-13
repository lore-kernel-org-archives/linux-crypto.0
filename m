Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D0C28489B;
	Sat, 13 Sep 2025 10:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757760213; cv=none; b=NDwvfw+Dov22IBUNGyZ1+oPvXf85DUVPWOnntyeb1JqkJFfbElGVRy3DRb3veWgNWS/Ka9jHlj0TcpqgMu3FnB9Uh6l3NPb5lPx/UjxQB5x9Yr1rEBApj0NvYs1j3AM6T44g/X2IqU/2eF1tLJqFGf1X7Aksa/I4/OJgDKJzK7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757760213; c=relaxed/simple;
	bh=mjrxhUFNG4wgKg6PgXTBGwlhEzgkPgfMJ1pkJuCQzaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UkGNOfb3m9S0+mBdEX2bp5ry9JcVTj7q2nI3ezGFFeGF37b0WPx1v+RCFZEd8SaQXHWARXCvxG3y3WsLHY2kdcAV14RC4ca/5oQh1X0wmq/fyAoMxS+ku/Yu0lH42qlvi00OO/etidrZHtn0dIRihKAhT9VGNGm5DF01E+cYN1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cP7Cr1XjwztTRf;
	Sat, 13 Sep 2025 18:42:32 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id C9059140137;
	Sat, 13 Sep 2025 18:43:26 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:43:26 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:43:25 +0800
Message-ID: <44a1dfc6-7432-4a6d-9739-4ff0b6271c77@huawei.com>
Date: Sat, 13 Sep 2025 18:43:25 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] uacce: fix for cdev memory leak
To: Greg KH <gregkh@linuxfoundation.org>
CC: <zhangfei.gao@linaro.org>, <wangzhou1@hisilicon.com>,
	<linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
	<linux-crypto@vger.kernel.org>, <fanghao11@huawei.com>,
	<shenyang39@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<liulongfang@huawei.com>
References: <20250822103904.3776304-1-huangchenghai2@huawei.com>
 <20250822103904.3776304-2-huangchenghai2@huawei.com>
 <2025082225-gooey-paralyses-5f24@gregkh>
From: huangchenghai <huangchenghai2@huawei.com>
In-Reply-To: <2025082225-gooey-paralyses-5f24@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200001.china.huawei.com (7.202.195.16)


On Thu, Aug 22, 2025 at 07:27 PM +0800, Greg KH wrote:
> On Fri, Aug 22, 2025 at 06:39:01PM +0800, Chenghai Huang wrote:
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
>> +	int ret;
>> +
>>   	if (!uacce)
>>   		return -ENODEV;
>>   
>> @@ -529,7 +531,14 @@ int uacce_register(struct uacce_device *uacce)
>>   	uacce->cdev->ops = &uacce_fops;
>>   	uacce->cdev->owner = THIS_MODULE;
>>   
>> -	return cdev_device_add(uacce->cdev, &uacce->dev);
>> +	ret = cdev_device_add(uacce->cdev, &uacce->dev);
>> +	if (ret) {
>> +		cdev_del(uacce->cdev);
>> +		uacce->cdev = NULL;
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>>   }
>>   EXPORT_SYMBOL_GPL(uacce_register);
>>   
>> -- 
>> 2.33.0
>>
> Hi,
>
> This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
> a patch that has triggered this response.  He used to manually respond
> to these common problems, but in order to save his sanity (he kept
> writing the same thing over and over, yet to different people), I was
> created.  Hopefully you will not take offence and will fix the problem
> in your patch and resubmit it so that it can be accepted into the Linux
> kernel tree.
>
> You are receiving this message because of the following common error(s)
> as indicated below:
>
> - You have marked a patch with a "Fixes:" tag for a commit that is in an
>    older released kernel, yet you do not have a cc: stable line in the
>    signed-off-by area at all, which means that the patch will not be
>    applied to any older kernel releases.  To properly fix this, please
>    follow the documented rules in the
>    Documentation/process/stable-kernel-rules.rst file for how to resolve
>    this.
>
> If you wish to discuss this problem further, or you have questions about
> how to resolve this issue, please feel free to respond to this email and
> Greg will reply once he has dug out from the pending patches received
> from other developers.
>
> thanks,
>
> greg k-h's patch email bot
Okay，I will add it in v2.

Thanks,
ChengHai
