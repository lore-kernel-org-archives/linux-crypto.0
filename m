Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C195476F2;
	Tue, 22 Sep 2026 13:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082720; cv=none; b=nZA6kqkpNN0rJ31bklic0lxpfy4KA4SRZktmV8SAabwHKWCtIDOnJFuKSwsOW6k1kiWbBDg21A65k+lFR9om2fia9fL9QUk4zC/NKmVU5oyisOhEQaWmsA9q5fLOo9pZrzJRGE8/abFDbc9daJGVROwnBZncvVPyODQ8+k/9Dvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082720; c=relaxed/simple;
	bh=CdsAG3KSh8PjS/f49i9tcfZ3ioMlrCSV6IqWxIBanMU=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UDjHs/1ClcpySAhjL0ex1y3oZzRR5Rpns9l477Mx/2eTVbvJVYWT/h1k/5+sd5KlOyz1GpOaS27t73BLAxpqD5rX7bjX8pNPpgjSHmtD4VphJqWKbQba9/A+JmXq1nc7Ezhg+kp+zlJGZZ6NouNrTF21+7bB+8GFoTjYGVfc+k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=D0UkJp4u; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="D0UkJp4u"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lGa9iYltj0lV2iB9NKTKxsT6ZtQ516uua2dW47qpZyA=;
	b=D0UkJp4uvyQanl8KRZ014S1mQSc7Cry6CpHQOo8InWTpO7D2ZUePtMEgKaIqAontIR4j4fz0v
	KZq5CxnXWU5Ika02UiT3xALE9A79cGfJ1XsNe6uIPed4e4RPqy2CUjKHTaEURSWLRRg/dDCPL/q
	G81Sw3GbjkM4/za6d/lc7pA=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hq0Zn58pYz1cyPY;
	Tue, 22 Sep 2026 21:00:49 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 8D1F44048B;
	Tue, 22 Sep 2026 21:11:51 +0800 (CST)
Received: from [10.67.120.87] (10.67.120.87) by kwepemf200011.china.huawei.com
 (7.202.181.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 22 Sep
 2026 21:11:51 +0800
Subject: Re: [PATCH 1/2] uacce: add device usage sysfs interface
To: Greg KH <gregkh@linuxfoundation.org>
References: <20260921075131.1062155-1-qianweili@huawei.com>
 <20260921075131.1062155-2-qianweili@huawei.com>
 <2026092125-define-unit-ac52@gregkh>
 <fd71cb7c-b9da-5cd9-c52e-ee287923073b@huawei.com>
 <2026092205-wrist-growing-0f04@gregkh>
 <d171b247-bcd3-bffe-ec74-4ae2df4faef5@huawei.com>
 <2026092235-unfrosted-concept-4bd9@gregkh>
CC: <herbert@gondor.apana.org.au>, <wangzhou1@hisilicon.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<huangchenghai2@huawei.com>, <liulongfang@huawei.com>
From: Weili Qian <qianweili@huawei.com>
Message-ID: <783736cc-c836-c283-8b6a-fa803a12d36d@huawei.com>
Date: Tue, 22 Sep 2026 21:11:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2026092235-unfrosted-concept-4bd9@gregkh>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf200011.china.huawei.com (7.202.181.237)



On 2026/9/22 20:13, Greg KH wrote:
> On Tue, Sep 22, 2026 at 07:57:14PM +0800, Weili Qian wrote:
>>
>> On 2026/9/22 17:21, Greg KH wrote:
>>> On Tue, Sep 22, 2026 at 05:11:55PM +0800, qianweili wrote:
>>>> On 2026/9/21 16:12, Greg KH wrote:
>>>>> On Mon, Sep 21, 2026 at 03:51:30PM +0800, Weili Qian wrote:
>>>>>> Userspace has no way to query the runtime usage of a UACCE
>>>>>> device; it can only be inferred indirectly from queue state, which is
>>>>>> neither accurate nor uniform across drivers.
>>>>>>
>>>>>> Add a read-only dev_usage sysfs attribute and a get_dev_usage callback
>>>>>> in struct uacce_ops. A driver implementing the callback writes the
>>>>>> current usage as a percentage (0-100) string into the caller-provided
>>>>>> buffer and returns the number of bytes written; dev_usage_show()
>>>>>> appends the trailing newline. The attribute is hidden via
>>>>>> uacce_dev_is_visible() when the driver does not provide the callback.
>>>>>>
>>>>>> The corresponding ABI entry is added to Documentation/ABI/testing/
>>>>>> sysfs-driver-uacce.
>>>>>>
>>>>>> Signed-off-by: Weili Qian <qianweili@huawei.com>
>>>>>> ---
>>>>>>     Documentation/ABI/testing/sysfs-driver-uacce |  9 +++++++++
>>>>>>     drivers/misc/uacce/uacce.c                   | 19 +++++++++++++++++++
>>>>>>     include/linux/uacce.h                        |  5 +++++
>>>>>>     3 files changed, 33 insertions(+)
>>>>>>
>>>>>> diff --git a/Documentation/ABI/testing/sysfs-driver-uacce b/Documentation/ABI/testing/sysfs-driver-uacce
>>>>>> index d3f0b8f3c589..3e4af4c1e5a9 100644
>>>>>> --- a/Documentation/ABI/testing/sysfs-driver-uacce
>>>>>> +++ b/Documentation/ABI/testing/sysfs-driver-uacce
>>>>>> @@ -55,3 +55,12 @@ Date:           Feb 2020
>>>>>>     KernelVersion:  5.7
>>>>>>     Contact:        linux-accelerators@lists.ozlabs.org
>>>>>>     Description:    Size (bytes) of dus region queue file
>>>>>> +
>>>>>> +What:           /sys/class/uacce/<dev_name>/dev_usage
>>>>>> +Date:           Sep 2026
>>>>>> +KernelVersion:  7.3
>>>>> That's not going to happen here :(
>>>> I'll change it to 7.4 in the next version.
>>>>>> +Contact:        linux-accelerators@lists.ozlabs.org
>>>>>> +Description:    (R) Current usage of the device, reported as a driver-defined
>>>>>> +                string of up to PAGE_SIZE - 1 bytes. Usage is expressed as a
>>>>>> +                percentage (0-100). The attribute is hidden if the driver does
>>>>>> +                not implement the get_dev_usage callback.
>>>>>> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
>>>>>> index 45521d4a56d1..545ba35a590b 100644
>>>>>> --- a/drivers/misc/uacce/uacce.c
>>>>>> +++ b/drivers/misc/uacce/uacce.c
>>>>>> @@ -433,6 +433,20 @@ static ssize_t isolate_strategy_store(struct device *dev, struct device_attribut
>>>>>>     	return count;
>>>>>>     }
>>>>>> +static ssize_t dev_usage_show(struct device *dev, struct device_attribute *attr, char *buf)
>>>>>> +{
>>>>>> +	struct uacce_device *uacce = to_uacce_device(dev);
>>>>>> +	int ret;
>>>>>> +
>>>>>> +	ret = uacce->ops->get_dev_usage(uacce, buf, PAGE_SIZE - 1);
>>>>> Why can't you use sysfs_emit()?  That way you don't have to worry about
>>>>> PAGE_SIZE, and you don't have to do:
>>>>>
>>>>>> +	if (ret < 0)
>>>>>> +		return ret;
>>>>>> +
>>>>>> +	buf[ret++] = '\n';
>>>>> That type of thing :(
>>>>>
>>>>> Also, you got your math wrong above :(
>>>> sysfs_emit() is useful when the framework side knows the format string
>>>> upfront.  Here get_dev_usage is a driver callback that dynamically
>>>> generates content -- the format is not known to the framework, so
>>>> there is no format string to emit.  Having the callback write into a
>>>> temporary buffer and then sysfs_emit(buf, "%s", tmp) in the show
>>>> function would just add an unnecessary copy without gaining the
>>>> overflow protection that sysfs_emit normally provides.
>>> Then that is going to be a mess, sysfs files should be in a consistant
>>> way, don't have random formats for the same filename depending on random
>>> hardware types.  Use different sysfs files if you want to do that.
>>>
>>> And this is just going to be a single value, nothing complex, so why do
>>> you need a callback for that?
>> A single device may run multiple independent algorithms in parallel
>> -- e.g. the HiSilicon ZIP device has separate compression and
>> decompression engines whose usage rates are independent and cannot
>> be aggregated into one meaningful number.
> Then that can not be a sysfs file, as sysfs files are "one value per
> file".
>
>> Following your suggestion of different sysfs files, one approach is
>> to expose one file per algorithm.  Each file contains a single int
>> (0-100) formatted with sysfs_emit(), and the callback returns int.
>> But the number of algorithms is driver-specific (1 to 3 in the
>> HiSilicon drivers), so the framework would need to create attributes
>> dynamically at registration time, which adds complexity.
>>
>> I'm not sure this is the best approach.  Do you have a better
>> suggestion for handling this case?
> I don't know, just don't violate the one-version-per-file rule AND
> always have the same type of data in the file with the same name (i.e.
> don't have a file that can contain different types of data.)
>
> This propose api seems to violate all of that, so I wouldn't recommend
> it at all.
>
> Why is this info needed in userspace at all?  What is userspace going to
> do with it?

Userspace schedulers use this to decide whether to submit a task to
the hardware accelerator or fall back to CPU computation.  When a
process initializes, it reads the device usage and compares it
against a threshold: if the accelerator is busy, the process uses
CPU computation for its lifetime; if it's idle, the process
submits tasks to the accelerator.  This needs a stable,
programmatically readable interface.

The per-algorithm detail is necessary because a device may have
independent engines -- e.g. the HiSilicon ZIP device has separate
compression and decompression engines, and a process doing
compression should only check the compression usage, not the
decompression usage.  Aggregating them into one value would cause
wrong scheduling decisions.

To follow the one-value-per-file rule, I propose exposing one sysfs
file per algorithm, with the algorithm name in the filename:

     /sys/class/uacce/<dev>/dev_usage_compress
     /sys/class/uacce/<dev>/dev_usage_decompress

Each file contains a single integer (0-100) formatted with
sysfs_emit().  The filenames are driver-defined based on the
algorithms the device supports, but every dev_usage_* file always
returns the same type -- a single usage percentage.  Userspace
discovers the available files by listing the device directory.

Is this approach acceptable?

Thanks!
Weili
>
> thanks,
>
> greg k-h
>
> .
>

