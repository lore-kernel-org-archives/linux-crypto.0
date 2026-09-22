Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5304E5372D1;
	Tue, 22 Sep 2026 11:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790078250; cv=none; b=Z1EN+qb2eNljcG8B4CQ7JdPyyLojHWDLu9iVTWfzX36LJcLFZHWgieEAZJVqkt/dWVI8UR2drpRI7qrIXIGtQ3PThPmp+o6uq24+hRF4FQKOk1S8pL5q3MnHPHVzZW0bEybHiuf6ga6oVRJ70ej5CFF/6/QGu6es6vHjcpnmgao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790078250; c=relaxed/simple;
	bh=QXfXzrnMBRdHvowFMQn1F2KTStceqWCuOqGWRPwMhps=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=hbQB5h8sNChPvLaugR9enTp/MG33OVl0JaKLtGdmtnb+rDMTXFb7OrtK9q9b5zkgWdVd7/4GKGEHMMfRiyHFLgPwKByDQ173WnSEpG3vOutWBrZwr3rpUv4FhqY5BBzyCF68q424i2Mj7mamFYGofJOJsjTLbX8Ff5504fJAAtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=05peRNuk; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="05peRNuk"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=odicV0kwaMwg+amPQO8FW+pwQJpqzHdlEw2XT9bqsCc=;
	b=05peRNukkat7K2ElEu1ezQw4dIfSQnPpYZI2/KrkQjxCuevw48Z+elFHdR+o0E+SaB+OOoqrg
	T0mDg5utwcJklhHIPetSQOxsyw+ewsMraks2tXXyrqvY6h2lIheAPtQyKCK4COmOYB/adqfKCY1
	CxJ+wUJqLTfC06D+qRxu7FE=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hpywj40ktz1cyVP;
	Tue, 22 Sep 2026 19:46:13 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 598C14057A;
	Tue, 22 Sep 2026 19:57:15 +0800 (CST)
Received: from [10.67.120.87] (10.67.120.87) by kwepemf200011.china.huawei.com
 (7.202.181.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 22 Sep
 2026 19:57:14 +0800
Subject: Re: [PATCH 1/2] uacce: add device usage sysfs interface
To: Greg KH <gregkh@linuxfoundation.org>
References: <20260921075131.1062155-1-qianweili@huawei.com>
 <20260921075131.1062155-2-qianweili@huawei.com>
 <2026092125-define-unit-ac52@gregkh>
 <fd71cb7c-b9da-5cd9-c52e-ee287923073b@huawei.com>
 <2026092205-wrist-growing-0f04@gregkh>
CC: <herbert@gondor.apana.org.au>, <wangzhou1@hisilicon.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<huangchenghai2@huawei.com>, <liulongfang@huawei.com>
From: Weili Qian <qianweili@huawei.com>
Message-ID: <d171b247-bcd3-bffe-ec74-4ae2df4faef5@huawei.com>
Date: Tue, 22 Sep 2026 19:57:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2026092205-wrist-growing-0f04@gregkh>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf200011.china.huawei.com (7.202.181.237)



On 2026/9/22 17:21, Greg KH wrote:
> On Tue, Sep 22, 2026 at 05:11:55PM +0800, qianweili wrote:
>>
>> On 2026/9/21 16:12, Greg KH wrote:
>>> On Mon, Sep 21, 2026 at 03:51:30PM +0800, Weili Qian wrote:
>>>> Userspace has no way to query the runtime usage of a UACCE
>>>> device; it can only be inferred indirectly from queue state, which is
>>>> neither accurate nor uniform across drivers.
>>>>
>>>> Add a read-only dev_usage sysfs attribute and a get_dev_usage callback
>>>> in struct uacce_ops. A driver implementing the callback writes the
>>>> current usage as a percentage (0-100) string into the caller-provided
>>>> buffer and returns the number of bytes written; dev_usage_show()
>>>> appends the trailing newline. The attribute is hidden via
>>>> uacce_dev_is_visible() when the driver does not provide the callback.
>>>>
>>>> The corresponding ABI entry is added to Documentation/ABI/testing/
>>>> sysfs-driver-uacce.
>>>>
>>>> Signed-off-by: Weili Qian <qianweili@huawei.com>
>>>> ---
>>>>    Documentation/ABI/testing/sysfs-driver-uacce |  9 +++++++++
>>>>    drivers/misc/uacce/uacce.c                   | 19 +++++++++++++++++++
>>>>    include/linux/uacce.h                        |  5 +++++
>>>>    3 files changed, 33 insertions(+)
>>>>
>>>> diff --git a/Documentation/ABI/testing/sysfs-driver-uacce b/Documentation/ABI/testing/sysfs-driver-uacce
>>>> index d3f0b8f3c589..3e4af4c1e5a9 100644
>>>> --- a/Documentation/ABI/testing/sysfs-driver-uacce
>>>> +++ b/Documentation/ABI/testing/sysfs-driver-uacce
>>>> @@ -55,3 +55,12 @@ Date:           Feb 2020
>>>>    KernelVersion:  5.7
>>>>    Contact:        linux-accelerators@lists.ozlabs.org
>>>>    Description:    Size (bytes) of dus region queue file
>>>> +
>>>> +What:           /sys/class/uacce/<dev_name>/dev_usage
>>>> +Date:           Sep 2026
>>>> +KernelVersion:  7.3
>>> That's not going to happen here :(
>> I'll change it to 7.4 in the next version.
>>>> +Contact:        linux-accelerators@lists.ozlabs.org
>>>> +Description:    (R) Current usage of the device, reported as a driver-defined
>>>> +                string of up to PAGE_SIZE - 1 bytes. Usage is expressed as a
>>>> +                percentage (0-100). The attribute is hidden if the driver does
>>>> +                not implement the get_dev_usage callback.
>>>> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
>>>> index 45521d4a56d1..545ba35a590b 100644
>>>> --- a/drivers/misc/uacce/uacce.c
>>>> +++ b/drivers/misc/uacce/uacce.c
>>>> @@ -433,6 +433,20 @@ static ssize_t isolate_strategy_store(struct device *dev, struct device_attribut
>>>>    	return count;
>>>>    }
>>>> +static ssize_t dev_usage_show(struct device *dev, struct device_attribute *attr, char *buf)
>>>> +{
>>>> +	struct uacce_device *uacce = to_uacce_device(dev);
>>>> +	int ret;
>>>> +
>>>> +	ret = uacce->ops->get_dev_usage(uacce, buf, PAGE_SIZE - 1);
>>> Why can't you use sysfs_emit()?  That way you don't have to worry about
>>> PAGE_SIZE, and you don't have to do:
>>>
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	buf[ret++] = '\n';
>>> That type of thing :(
>>>
>>> Also, you got your math wrong above :(
>> sysfs_emit() is useful when the framework side knows the format string
>> upfront.  Here get_dev_usage is a driver callback that dynamically
>> generates content -- the format is not known to the framework, so
>> there is no format string to emit.  Having the callback write into a
>> temporary buffer and then sysfs_emit(buf, "%s", tmp) in the show
>> function would just add an unnecessary copy without gaining the
>> overflow protection that sysfs_emit normally provides.
> Then that is going to be a mess, sysfs files should be in a consistant
> way, don't have random formats for the same filename depending on random
> hardware types.  Use different sysfs files if you want to do that.
>
> And this is just going to be a single value, nothing complex, so why do
> you need a callback for that?
A single device may run multiple independent algorithms in parallel
-- e.g. the HiSilicon ZIP device has separate compression and
decompression engines whose usage rates are independent and cannot
be aggregated into one meaningful number.

Following your suggestion of different sysfs files, one approach is
to expose one file per algorithm.  Each file contains a single int
(0-100) formatted with sysfs_emit(), and the callback returns int.
But the number of algorithms is driver-specific (1 to 3 in the
HiSilicon drivers), so the framework would need to create attributes
dynamically at registration time, which adds complexity.

I'm not sure this is the best approach.  Do you have a better
suggestion for handling this case?

Thanks!
Weili
>
>> But you're right that the manual newline append and the PAGE_SIZE - 1
>> math were unnecessary.  In the next version I'll rework the callback
>> contract so the driver writes the complete output (including any
>> trailing newlines) and dev_usage_show() just returns the callback
>> result directly:
>>
>>      static ssize_t dev_usage_show(struct device *dev,
>>                                    struct device_attribute *attr, char *buf)
>>      {
>>          struct uacce_device *uacce = to_uacce_device(dev);
>>
>>          return uacce->ops->get_dev_usage(uacce, buf, PAGE_SIZE);
> Why not have the get_dev_usage() return the value that you want to write
> to the buffer, and then use sysfs_emit() to write it?  Then no need to
> worry about PAGE_SIZE at all.
>
> thanks,
>
> greg k-h
>
> .
>

