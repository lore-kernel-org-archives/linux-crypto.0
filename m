Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7972B49B44C;
	Mon, 21 Sep 2026 13:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789997580; cv=none; b=c47yOy4Q4xhbx1UaJlDLL/A9mqn33lhnrY+UlBJJ6tjbGjMLBpNauGmnpDfwpDJ0TJPNC/3EJbfhinIQ3Z+ZdgSCGdkPcD2+DHkt2Ncog8zIjQArpWSrQLEk9V6vpkg9JJEYITTfzvGCa8h3p+FpY/5Wx4GC91PDOuH3rcVkulo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789997580; c=relaxed/simple;
	bh=JjhCW1GGKWq7Zu9uq0G4JVdlgCFxJ4U0D9FYdCT+CcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhUBy7ipbl7Munh081viEZ8IAdtK6FSV50GQ/ZJQv/5y65RdMbYNqYFcpraZ71kanm0cfKWLQ9+vcxZAtsyGojtPz+NWWCgdtQmwoT2bIkKCWEQi4FmYUAU1xwEiAv+mbe9oOrvDx18TbcMooeb3i+HkEAfev+9mm99yPK/gLS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3tpSZLD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3tpSZLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781C71F000FF;
	Mon, 21 Sep 2026 13:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789997579;
	bh=yWUhiXl5gMY74Q2ZQKcACxCy4EHySzkWPxEPYfMKsvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L3tpSZLDfnhVSl5arRVEo5V0LvHJ5z6h5nut1nYzZ+uqFsnm7rQvdsB+ZEb2WFkkf
	 WTFqAaJO3PP3VeYS+g8ZhxaqgzQfaCW8MhTLa8DMqICMsS6P7jpzcwF2o6Q+Qoxntk
	 E4b71N4HSjCGuHEboOqqOFlxAo2N1iFmFfoBLQqM=
Date: Mon, 21 Sep 2026 10:12:06 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Weili Qian <qianweili@huawei.com>
Cc: herbert@gondor.apana.org.au, zhangfei.gao@linaro.org,
	wangzhou1@hisilicon.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, huangchenghai2@huawei.com,
	liulongfang@huawei.com
Subject: Re: [PATCH 1/2] uacce: add device usage sysfs interface
Message-ID: <2026092125-define-unit-ac52@gregkh>
References: <20260921075131.1062155-1-qianweili@huawei.com>
 <20260921075131.1062155-2-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921075131.1062155-2-qianweili@huawei.com>

On Mon, Sep 21, 2026 at 03:51:30PM +0800, Weili Qian wrote:
> Userspace has no way to query the runtime usage of a UACCE
> device; it can only be inferred indirectly from queue state, which is
> neither accurate nor uniform across drivers.
> 
> Add a read-only dev_usage sysfs attribute and a get_dev_usage callback
> in struct uacce_ops. A driver implementing the callback writes the
> current usage as a percentage (0-100) string into the caller-provided
> buffer and returns the number of bytes written; dev_usage_show()
> appends the trailing newline. The attribute is hidden via
> uacce_dev_is_visible() when the driver does not provide the callback.
> 
> The corresponding ABI entry is added to Documentation/ABI/testing/
> sysfs-driver-uacce.
> 
> Signed-off-by: Weili Qian <qianweili@huawei.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-uacce |  9 +++++++++
>  drivers/misc/uacce/uacce.c                   | 19 +++++++++++++++++++
>  include/linux/uacce.h                        |  5 +++++
>  3 files changed, 33 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-uacce b/Documentation/ABI/testing/sysfs-driver-uacce
> index d3f0b8f3c589..3e4af4c1e5a9 100644
> --- a/Documentation/ABI/testing/sysfs-driver-uacce
> +++ b/Documentation/ABI/testing/sysfs-driver-uacce
> @@ -55,3 +55,12 @@ Date:           Feb 2020
>  KernelVersion:  5.7
>  Contact:        linux-accelerators@lists.ozlabs.org
>  Description:    Size (bytes) of dus region queue file
> +
> +What:           /sys/class/uacce/<dev_name>/dev_usage
> +Date:           Sep 2026
> +KernelVersion:  7.3

That's not going to happen here :(

> +Contact:        linux-accelerators@lists.ozlabs.org
> +Description:    (R) Current usage of the device, reported as a driver-defined
> +                string of up to PAGE_SIZE - 1 bytes. Usage is expressed as a
> +                percentage (0-100). The attribute is hidden if the driver does
> +                not implement the get_dev_usage callback.
> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> index 45521d4a56d1..545ba35a590b 100644
> --- a/drivers/misc/uacce/uacce.c
> +++ b/drivers/misc/uacce/uacce.c
> @@ -433,6 +433,20 @@ static ssize_t isolate_strategy_store(struct device *dev, struct device_attribut
>  	return count;
>  }
>  
> +static ssize_t dev_usage_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct uacce_device *uacce = to_uacce_device(dev);
> +	int ret;
> +
> +	ret = uacce->ops->get_dev_usage(uacce, buf, PAGE_SIZE - 1);

Why can't you use sysfs_emit()?  That way you don't have to worry about
PAGE_SIZE, and you don't have to do:

> +	if (ret < 0)
> +		return ret;
> +
> +	buf[ret++] = '\n';

That type of thing :(

Also, you got your math wrong above :(

> +
> +	return ret;
> +}
> +
>  static DEVICE_ATTR_RO(api);
>  static DEVICE_ATTR_RO(flags);
>  static DEVICE_ATTR_RO(available_instances);
> @@ -441,6 +455,7 @@ static DEVICE_ATTR_RO(region_mmio_size);
>  static DEVICE_ATTR_RO(region_dus_size);
>  static DEVICE_ATTR_RO(isolate);
>  static DEVICE_ATTR_RW(isolate_strategy);
> +static DEVICE_ATTR_RO(dev_usage);
>  
>  static struct attribute *uacce_dev_attrs[] = {
>  	&dev_attr_api.attr,
> @@ -451,6 +466,7 @@ static struct attribute *uacce_dev_attrs[] = {
>  	&dev_attr_region_dus_size.attr,
>  	&dev_attr_isolate.attr,
>  	&dev_attr_isolate_strategy.attr,
> +	&dev_attr_dev_usage.attr,
>  	NULL,
>  };
>  
> @@ -474,6 +490,9 @@ static umode_t uacce_dev_is_visible(struct kobject *kobj,
>  	if (attr == &dev_attr_isolate.attr && !uacce->ops->get_isolate_state)
>  		return 0;
>  
> +	if (attr == &dev_attr_dev_usage.attr && !uacce->ops->get_dev_usage)
> +		return 0;
> +
>  	return attr->mode;
>  }
>  
> diff --git a/include/linux/uacce.h b/include/linux/uacce.h
> index e290c0269944..8f0b9765e4b6 100644
> --- a/include/linux/uacce.h
> +++ b/include/linux/uacce.h
> @@ -34,6 +34,10 @@ struct uacce_qfile_region {
>   * @get_isolate_state: get the device state after set the isolate strategy
>   * @isolate_err_threshold_write: stored the isolate error threshold to the device
>   * @isolate_err_threshold_read: read the isolate error threshold value from the device
> + * @get_dev_usage: get the device usage. Write a string describing current
> + *                 usage as a percentage (0-100) into @buf, at most @size
> + *                 bytes, without a trailing newline. Return the number of
> + *                 bytes written on success or a negative errno on failure.

Why the newline thing?

thanks,

greg k-h
