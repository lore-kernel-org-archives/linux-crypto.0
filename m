Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85AA78F4B;
	Wed, 22 Oct 2025 01:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761096890; cv=none; b=N45HRdHannWuzu/QZXSssfeBsTw87OhGfWyI6gujU6kIJTvzyXq0zlshSHfbym/xtbSiXIZOcKCmnVigfUnmG/jIRVm43wB9lHvl1OS++EDwgay/Pk3Fl9cun/Ag8uVSF3nDX3gfAH9kFmL/1OEkxuANo0Zp7nAEwRX03Zc3h70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761096890; c=relaxed/simple;
	bh=iGEDrF5yfwf+vRxnVRPKHBnPdEPhMrlz3GbZ8GRnFyw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=EYA07VEGhRsqWYsOcBCSDbKMGnTZY0R25X6QxM4lmsmFWrbMPyIsl5NwgkIOge+dx7DOLIUgvRNNoxXc83SfjV9+Tu+x4K0hLcOlf+hAvJdBKOzbjOPQhJ7zGHEdsg6HQu/EHt2qp1yE4Tc15ZUtQEKyebxr3q5jgtaJ1HVE1SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=AqTfNumn; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="AqTfNumn"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=epdm1RbUwUFBY15HOOvBG2aQfK/58vGsDkZk2qE97Hw=;
	b=AqTfNumnSPioVgDVgr9Ksjb1meVYQ+ui+tKLKbJ6PwQt+ve4lrM/FTFeHKJcSXAp3P+6daxOp
	YkVsKgtpBBJKyeLxQuyo0KiiIsxLZjYGbMkxI35k6PtjdtEcDgcrzVxdM1cdaaQqSW8qsz4Gmv+
	kj9gp9hUGVqmbJLCifB8ZOc=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4crsBP5XK1zcZxv;
	Wed, 22 Oct 2025 09:33:33 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 4FC0E140154;
	Wed, 22 Oct 2025 09:34:44 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 09:34:44 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 09:34:43 +0800
Message-ID: <28d3972c-73c3-40f8-8563-02650aceb4e5@huawei.com>
Date: Wed, 22 Oct 2025 09:34:42 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] uacce: fix isolate sysfs check condition
From: huangchenghai <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <shenyang39@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>
References: <20251021135003.786588-1-huangchenghai2@huawei.com>
 <20251021135003.786588-3-huangchenghai2@huawei.com>
Content-Language: en-US
In-Reply-To: <20251021135003.786588-3-huangchenghai2@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200001.china.huawei.com (7.202.195.16)


在 2025/10/21 21:50, Chenghai Huang 写道:
> uacce supports the device isolation feature. If the driver
> implements the isolate_err_threshold_read and
> isolate_err_threshold_write callback functions, uacce will create
> sysfs files now. Users can read and configure the isolation policy
> through sysfs. Currently, sysfs files are created as long as either
> isolate_err_threshold_read or isolate_err_threshold_write callback
> functions are present.
>
> However, accessing a non-existent callback function may cause the
> system to crash. Therefore, check whether the function exists
> before calling isolate_err_threshold_read or
> isolate_err_threshold_write.
>
> Fixes: e3e289fbc0b5 ("uacce: supports device isolation feature")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>   drivers/misc/uacce/uacce.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> index 9b82a6731832..e3433d95640a 100644
> --- a/drivers/misc/uacce/uacce.c
> +++ b/drivers/misc/uacce/uacce.c
> @@ -382,6 +382,9 @@ static ssize_t isolate_strategy_show(struct device *dev, struct device_attribute
>   	struct uacce_device *uacce = to_uacce_device(dev);
>   	u32 val;
>   
> +	if (!uacce->ops->isolate_err_threshold_read)
> +		return -ENOENT;
> +
>   	val = uacce->ops->isolate_err_threshold_read(uacce);
>   
>   	return sysfs_emit(buf, "%u\n", val);
> @@ -394,6 +397,9 @@ static ssize_t isolate_strategy_store(struct device *dev, struct device_attribut
>   	unsigned long val;
>   	int ret;
>   
> +	if (!uacce->ops->isolate_err_threshold_write)
> +		return -ENOENT;
> +
>   	if (kstrtoul(buf, 0, &val) < 0)
>   		return -EINVAL;
>   
> @@ -440,9 +446,7 @@ static umode_t uacce_dev_is_visible(struct kobject *kobj,
>   	    (!uacce->qf_pg_num[UACCE_QFRT_DUS])))
>   		return 0;
>   
> -	if (attr == &dev_attr_isolate_strategy.attr &&
> -	    (!uacce->ops->isolate_err_threshold_read &&
> -	     !uacce->ops->isolate_err_threshold_write))
> +	if (attr == &dev_attr_isolate_strategy.attr)
>   		return 0;

sorry，I send the wrong version of patch 2.

Intercept the creation of sysfs if neither read nor write exists;
create sysfs if either is supported, but intercept unsupported
operations at the call site.

I will send the right version in v4.


Thanks,
Chenghai

>   
>   	if (attr == &dev_attr_isolate.attr && !uacce->ops->get_isolate_state)
