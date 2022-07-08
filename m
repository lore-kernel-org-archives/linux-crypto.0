Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78257C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jul 2022 09:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbiGHJdr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jul 2022 05:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbiGHJdq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jul 2022 05:33:46 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3641205DB;
        Fri,  8 Jul 2022 02:33:44 -0700 (PDT)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LfShL43cyzhZF2;
        Fri,  8 Jul 2022 17:31:14 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 8 Jul 2022 17:33:42 +0800
Received: from [10.67.103.212] (10.67.103.212) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 8 Jul 2022 17:33:42 +0800
Subject: Re: [PATCH v5 1/3] uacce: supports device isolation feature
To:     Greg KH <gregkh@linuxfoundation.org>
References: <20220708070820.43958-1-yekai13@huawei.com>
 <20220708070820.43958-2-yekai13@huawei.com> <YsfctnUkPCo+qGJW@kroah.com>
CC:     <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wangzhou1@hisilicon.com>
From:   "yekai(A)" <yekai13@huawei.com>
Message-ID: <288f82bf-ca0b-b049-4dcf-fd7b6a29607b@huawei.com>
Date:   Fri, 8 Jul 2022 17:33:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YsfctnUkPCo+qGJW@kroah.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.212]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2022/7/8 15:28, Greg KH wrote:
> On Fri, Jul 08, 2022 at 03:08:18PM +0800, Kai Ye wrote:
>> UACCE adds the hardware error isolation API. Users can configure
>> the isolation frequency by this sysfs node. UACCE reports the device
>> isolate state to the user space. If the AER error frequency exceeds
>> the value of setting for a certain period of time, the device will be
>> isolated.
>>
>> Signed-off-by: Kai Ye <yekai13@huawei.com>
>> ---
>>  drivers/misc/uacce/uacce.c | 55 ++++++++++++++++++++++++++++++++++++++
>>  include/linux/uacce.h      | 11 ++++++++
>>  2 files changed, 66 insertions(+)
>>
>> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
>> index 281c54003edc..d07b5f1f0596 100644
>> --- a/drivers/misc/uacce/uacce.c
>> +++ b/drivers/misc/uacce/uacce.c
>> @@ -7,6 +7,8 @@
>>  #include <linux/slab.h>
>>  #include <linux/uacce.h>
>>
>> +#define MAX_ERR_ISOLATE_COUNT		65535
>> +
>>  static struct class *uacce_class;
>>  static dev_t uacce_devt;
>>  static DEFINE_MUTEX(uacce_mutex);
>> @@ -339,12 +341,63 @@ static ssize_t region_dus_size_show(struct device *dev,
>>  		       uacce->qf_pg_num[UACCE_QFRT_DUS] << PAGE_SHIFT);
>>  }
>>
>> +static ssize_t isolate_show(struct device *dev,
>> +			    struct device_attribute *attr, char *buf)
>> +{
>> +	struct uacce_device *uacce = to_uacce_device(dev);
>> +
>> +	if (!uacce->ops->get_isolate_state)
>> +		return -ENODEV;
>
> If there is no callback, why is this sysfs even created at all?  Please
> do not create it if it can not be accessed.
>
> Use the is_visable() callback for the group to do this.
>

If is_visable() is used as the judgment, all uacce device nodes cannot 
be registered if there is no callback by test.

>> +
>> +	return sysfs_emit(buf, "%d\n", uacce->ops->get_isolate_state(uacce));
>> +}
>> +
>> +static ssize_t isolate_strategy_show(struct device *dev,
>> +				     struct device_attribute *attr, char *buf)
>> +{
>> +	struct uacce_device *uacce = to_uacce_device(dev);
>> +	u32 val;
>> +
>> +	if (!uacce->ops->isolate_strategy_read)
>> +		return -ENODEV;
>
> Same here, don't have a sysfs file that does nothing.
>
>> +
>> +	val = uacce->ops->isolate_strategy_read(uacce);
>> +	if (val > MAX_ERR_ISOLATE_COUNT)
>> +		return -EINVAL;
>> +
>> +	return sysfs_emit(buf, "%u\n", val);
>> +}
>> +
>> +static ssize_t isolate_strategy_store(struct device *dev,
>> +				      struct device_attribute *attr,
>> +				      const char *buf, size_t count)
>> +{
>> +	struct uacce_device *uacce = to_uacce_device(dev);
>> +	unsigned long val;
>> +	int ret;
>> +
>> +	if (!uacce->ops->isolate_strategy_write)
>> +		return -ENODEV;
>
> Same here.
>
> thanks,
>
> greg k-h
> .
>
