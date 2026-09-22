Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE4752CCDD;
	Tue, 22 Sep 2026 09:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068336; cv=none; b=CqYTZ5/4P6SOICRAcCd07LZtgFlfScVBN0/vih6NhSHcipc719wja/SK1sFn5ETsis3vOcl3wWuvQOBsdM+CXqizMt0bTKQpncNfAPR4wa7eYghb2l0ONYDt5WVv8+j9X+VKh1IisJ8sNNRvBNjFnjEb7B54hSndUZ+XMDk9SzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068336; c=relaxed/simple;
	bh=sQIbSLK4r5T3rVQobu+nzJ2JfwTv5PqVKdayID4MoiE=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DHOAOiVt7MzOBRli/SP3xvSS5RL4WM+GqEewrCG6o0DSrUCoZYNMNo/LAGh9SAQEPnu3zh95dgbTc3UfnfqomIqyAVICA80rU49Z/LnjVpLb8c+DuTWLNFECrAH2lfoRtqOzihLEqmiT6sos8t08uJ9tgfrDrBE1jRaVAn0JxiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=r3qoW8Wy; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="r3qoW8Wy"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NUUh20zjV8l60eJcJvOBW1TaddyIjsUbgBj00DAQWr4=;
	b=r3qoW8Wy9xEVqfvPS7CnUbseiLABfs2NYKWhnSvM5aJGfOBRaqE6CsrQlqtUqLjwk9bXuQN08
	y74YoaoIlG9SlNM0vUvhSI3Pv826m4P5C30OGjvoCVTugZwq5RWPMA8JZiWD95co9KjNStl2wga
	L2FQaj89t69Z2sq8nhbsRY4=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hpvDm3pdyzmVC5;
	Tue, 22 Sep 2026 16:59:52 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A60D40586;
	Tue, 22 Sep 2026 17:11:56 +0800 (CST)
Received: from [10.67.120.87] (10.67.120.87) by kwepemf200011.china.huawei.com
 (7.202.181.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 22 Sep
 2026 17:11:55 +0800
Subject: Re: [PATCH 1/2] uacce: add device usage sysfs interface
To: Greg KH <gregkh@linuxfoundation.org>
References: <20260921075131.1062155-1-qianweili@huawei.com>
 <20260921075131.1062155-2-qianweili@huawei.com>
 <2026092125-define-unit-ac52@gregkh>
CC: <herbert@gondor.apana.org.au>, <wangzhou1@hisilicon.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<huangchenghai2@huawei.com>, <liulongfang@huawei.com>
From: qianweili <qianweili@huawei.com>
Message-ID: <fd71cb7c-b9da-5cd9-c52e-ee287923073b@huawei.com>
Date: Tue, 22 Sep 2026 17:11:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2026092125-define-unit-ac52@gregkh>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf200011.china.huawei.com (7.202.181.237)



On 2026/9/21 16:12, Greg KH wrote:
> On Mon, Sep 21, 2026 at 03:51:30PM +0800, Weili Qian wrote:
>> Userspace has no way to query the runtime usage of a UACCE
>> device; it can only be inferred indirectly from queue state, which is
>> neither accurate nor uniform across drivers.
>>
>> Add a read-only dev_usage sysfs attribute and a get_dev_usage callback
>> in struct uacce_ops. A driver implementing the callback writes the
>> current usage as a percentage (0-100) string into the caller-provided
>> buffer and returns the number of bytes written; dev_usage_show()
>> appends the trailing newline. The attribute is hidden via
>> uacce_dev_is_visible() when the driver does not provide the callback.
>>
>> The corresponding ABI entry is added to Documentation/ABI/testing/
>> sysfs-driver-uacce.
>>
>> Signed-off-by: Weili Qian <qianweili@huawei.com>
>> ---
>>   Documentation/ABI/testing/sysfs-driver-uacce |  9 +++++++++
>>   drivers/misc/uacce/uacce.c                   | 19 +++++++++++++++++++
>>   include/linux/uacce.h                        |  5 +++++
>>   3 files changed, 33 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-driver-uacce b/Documentation/ABI/testing/sysfs-driver-uacce
>> index d3f0b8f3c589..3e4af4c1e5a9 100644
>> --- a/Documentation/ABI/testing/sysfs-driver-uacce
>> +++ b/Documentation/ABI/testing/sysfs-driver-uacce
>> @@ -55,3 +55,12 @@ Date:           Feb 2020
>>   KernelVersion:  5.7
>>   Contact:        linux-accelerators@lists.ozlabs.org
>>   Description:    Size (bytes) of dus region queue file
>> +
>> +What:           /sys/class/uacce/<dev_name>/dev_usage
>> +Date:           Sep 2026
>> +KernelVersion:  7.3
> That's not going to happen here :(
I'll change it to 7.4 in the next version.
>
>> +Contact:        linux-accelerators@lists.ozlabs.org
>> +Description:    (R) Current usage of the device, reported as a driver-defined
>> +                string of up to PAGE_SIZE - 1 bytes. Usage is expressed as a
>> +                percentage (0-100). The attribute is hidden if the driver does
>> +                not implement the get_dev_usage callback.
>> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
>> index 45521d4a56d1..545ba35a590b 100644
>> --- a/drivers/misc/uacce/uacce.c
>> +++ b/drivers/misc/uacce/uacce.c
>> @@ -433,6 +433,20 @@ static ssize_t isolate_strategy_store(struct device *dev, struct device_attribut
>>   	return count;
>>   }
>>   
>> +static ssize_t dev_usage_show(struct device *dev, struct device_attribute *attr, char *buf)
>> +{
>> +	struct uacce_device *uacce = to_uacce_device(dev);
>> +	int ret;
>> +
>> +	ret = uacce->ops->get_dev_usage(uacce, buf, PAGE_SIZE - 1);
> Why can't you use sysfs_emit()?  That way you don't have to worry about
> PAGE_SIZE, and you don't have to do:
>
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	buf[ret++] = '\n';
> That type of thing :(
>
> Also, you got your math wrong above :(
sysfs_emit() is useful when the framework side knows the format string
upfront.  Here get_dev_usage is a driver callback that dynamically
generates content -- the format is not known to the framework, so
there is no format string to emit.  Having the callback write into a
temporary buffer and then sysfs_emit(buf, "%s", tmp) in the show
function would just add an unnecessary copy without gaining the
overflow protection that sysfs_emit normally provides.

But you're right that the manual newline append and the PAGE_SIZE - 1
math were unnecessary.  In the next version I'll rework the callback
contract so the driver writes the complete output (including any
trailing newlines) and dev_usage_show() just returns the callback
result directly:

     static ssize_t dev_usage_show(struct device *dev,
                                   struct device_attribute *attr, char *buf)
     {
         struct uacce_device *uacce = to_uacce_device(dev);

         return uacce->ops->get_dev_usage(uacce, buf, PAGE_SIZE);
     }

No more PAGE_SIZE - 1, no more manual newline append.  For example,
the HiSilicon QM driver writes one line per channel with a trailing
newline ("ch0: 50\nch1: 30\n"), and the framework passes it through
unchanged.

>
>> +
>> +	return ret;
>> +}
>> +
>>   static DEVICE_ATTR_RO(api);
>>   static DEVICE_ATTR_RO(flags);
>>   static DEVICE_ATTR_RO(available_instances);
>> @@ -441,6 +455,7 @@ static DEVICE_ATTR_RO(region_mmio_size);
>>   static DEVICE_ATTR_RO(region_dus_size);
>>   static DEVICE_ATTR_RO(isolate);
>>   static DEVICE_ATTR_RW(isolate_strategy);
>> +static DEVICE_ATTR_RO(dev_usage);
>>   
>>   static struct attribute *uacce_dev_attrs[] = {
>>   	&dev_attr_api.attr,
>> @@ -451,6 +466,7 @@ static struct attribute *uacce_dev_attrs[] = {
>>   	&dev_attr_region_dus_size.attr,
>>   	&dev_attr_isolate.attr,
>>   	&dev_attr_isolate_strategy.attr,
>> +	&dev_attr_dev_usage.attr,
>>   	NULL,
>>   };
>>   
>> @@ -474,6 +490,9 @@ static umode_t uacce_dev_is_visible(struct kobject *kobj,
>>   	if (attr == &dev_attr_isolate.attr && !uacce->ops->get_isolate_state)
>>   		return 0;
>>   
>> +	if (attr == &dev_attr_dev_usage.attr && !uacce->ops->get_dev_usage)
>> +		return 0;
>> +
>>   	return attr->mode;
>>   }
>>   
>> diff --git a/include/linux/uacce.h b/include/linux/uacce.h
>> index e290c0269944..8f0b9765e4b6 100644
>> --- a/include/linux/uacce.h
>> +++ b/include/linux/uacce.h
>> @@ -34,6 +34,10 @@ struct uacce_qfile_region {
>>    * @get_isolate_state: get the device state after set the isolate strategy
>>    * @isolate_err_threshold_write: stored the isolate error threshold to the device
>>    * @isolate_err_threshold_read: read the isolate error threshold value from the device
>> + * @get_dev_usage: get the device usage. Write a string describing current
>> + *                 usage as a percentage (0-100) into @buf, at most @size
>> + *                 bytes, without a trailing newline. Return the number of
>> + *                 bytes written on success or a negative errno on failure.
> Why the newline thing?
The "without a trailing newline" contract was over-engineered.  In the
next version the callback will write a string and the framework
returns it as-is; the driver decides the formatting.  Updated
kernel-doc:

     * @get_dev_usage: get the device usage. Write a string into @buf, at
     *                 most @size bytes. Values within the string are
     *                 percentages in the range 0-100; the exact format is
     *                 driver specific. Return the number of bytes written
     *                 on success or a negative errno on failure.

I'll also reword the ABI description to match: "Values within the
string are percentages in the range 0-100; the exact format is driver
specific", since the callback may emit multiple values (e.g. one per
channel) and the layout is driver-specific, not a single percentage as
the old wording implied.

Thanks for the review.

Weili

>
> thanks,
>
> greg k-h
>
> .
>

