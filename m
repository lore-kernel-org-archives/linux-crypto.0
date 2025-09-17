Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9083534AB1D;
	Wed, 17 Sep 2025 09:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758102861; cv=none; b=D5lqJ20POxI2rBxq7R5TKojBmNesq1xu8Pawjfp7M8klaCHYJwzyoOTt6qDeA8OXwujaIqGr2zpBZcb4uN6tpnyU52mAGmjwz0bmHKjRtZp0luJJ8WAOy6jo0Ph82r1E/gcV+LGhYeCEoMOd2VrlxgwLftfms58QgW4dDTnj7Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758102861; c=relaxed/simple;
	bh=McqcASJsTzPznvt5YCM25psP2hkfHoNU+DH9+PrhYWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kfT9HKCeLB/IKD9TqHt1sJ/zWSuFulY1bkJiOVfneYBitu8tnPup+2Wue5kQ3g9pTVqiYsBqqnzhS7JyF5yruolOr7b8/3JbGOwzsZTMHslCvpdLTH1OgdjlUz7FJzrUoZlaLXw2xjg03Bl23LA59keG0YCZAeXS6wuDtvnTsw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cRYrz33m9zPsc3;
	Wed, 17 Sep 2025 17:49:39 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1182A18007F;
	Wed, 17 Sep 2025 17:54:15 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Sep 2025 17:54:14 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Sep 2025 17:54:14 +0800
Message-ID: <ace00212-b02b-4407-98ab-5aff3e0fad77@huawei.com>
Date: Wed, 17 Sep 2025 17:54:13 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] uacce: fix isolate sysfs check condition
To: Greg KH <gregkh@linuxfoundation.org>
CC: <zhangfei.gao@linaro.org>, <wangzhou1@hisilicon.com>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <fanghao11@huawei.com>, <shenyang39@huawei.com>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>
References: <20250916144811.1799687-1-huangchenghai2@huawei.com>
 <20250916144811.1799687-3-huangchenghai2@huawei.com>
 <2025091633-antacid-gluten-0a61@gregkh>
From: huangchenghai <huangchenghai2@huawei.com>
Content-Language: en-US
In-Reply-To: <2025091633-antacid-gluten-0a61@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200001.china.huawei.com (7.202.195.16)


On Mon, Sep 16, 2025 at 11:15 PM +0800, Greg KH wrote:
> On Tue, Sep 16, 2025 at 10:48:09PM +0800, Chenghai Huang wrote:
>> The uacce supports device isolation feature. If the driver
>> implements the isolate_err_threshold_read and
>> isolate_err_threshold_write callbacks, the uacce will create sysfs
>> files. Users can read and configure isolation policies through
>> sysfs. Currently, if either isolate_err_threshold_read or
>> isolate_err_threshold_write callback exists, sysfs files are
>> created.
>>
>> However, accessing a non-existent callback may cause a system panic.
> Where is the callback happening that fails?  Shouldn't that be checked
> instead of doing this change?
>
>> Therefore, sysfs files are only created when both
>> isolate_err_threshold_read and isolate_err_threshold_write are
>> present.
> What if a device only has 1?  That should still work properly?
>
> And why not just create the file if it is going to be used, that is the
> real solution here.
>
> thanks,
>
> greg k-h
Thank you for your feedback.I agree that the check should be done in the 
corresponding `isolate_strategy_show()` and `isolate_strategy_store()` 
functions.

How about the updated:

@@ -402,6 +402,9 @@ static ssize_t isolate_strategy_show(struct device 
*dev, struct device_attribute
         struct uacce_device *uacce = to_uacce_device(dev);
         u32 val;

+       if (!uacce->ops->isolate_err_threshold_read)
+               return -ENOENT;
+
         val = uacce->ops->isolate_err_threshold_read(uacce);

         return sysfs_emit(buf, "%u\n", val);
@@ -414,6 +417,9 @@ static ssize_t isolate_strategy_store(struct device 
*dev, struct device_attribut
         unsigned long val;
         int ret;

+       if (!uacce->ops->isolate_err_threshold_write)
+               return -ENOENT;
+
         if (kstrtoul(buf, 0, &val) < 0)
                 return -EINVAL;

@@ -460,9 +466,7 @@ static umode_t uacce_dev_is_visible(struct kobject 
*kobj,
             (!uacce->qf_pg_num[UACCE_QFRT_DUS])))
                 return 0;

-       if (attr == &dev_attr_isolate_strategy.attr &&
-           (!uacce->ops->isolate_err_threshold_read ||
-            !uacce->ops->isolate_err_threshold_write))
+       if (attr == &dev_attr_isolate_strategy.attr)
                 return 0;

This way, the sysfs files will only be created if they are going to be 
used, and the checks are done at the appropriate places.

Thanks,
Chenghai
