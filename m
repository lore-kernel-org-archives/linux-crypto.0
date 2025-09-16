Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0F034167D;
	Tue, 16 Sep 2025 15:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758035663; cv=none; b=Iy8Zgy5A7SLfUM9Fz6j6BvYdjge3QnnU8fJtHng4d9lXhUgldceBoXKBEMdF+Uu/WJQEevHL2kJIo1aeq0lOTDNWaCuZINCfvmrAdM9kx6Plp2SyJDQGD24QvhmOeq91m19DaEbMlSqb/yzh5oZCpEf9idGA/GNdXkVUo7LTyUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758035663; c=relaxed/simple;
	bh=iuHBraZ6RVFjDpHf88PWAP4EJDMCcCZNFb7fBK+tG28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vjf2I9sgKHQaN9K7/AncXQFzgXUeimxMt8WBFiBZDueBSi6+/DHKUBIDGwaaMKzVwEboeUI/l7B3KTr0eGRkp+ILZcrm6HRNckIWs8wvzJAF6ZyFHSeujBpBzrxgVlagLFS+SkqepXDryH5k6DeZP1txafRgOrpMW/TTT+pUU3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9PZw4mR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9PZw4mR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A9FC4CEF0;
	Tue, 16 Sep 2025 15:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758035663;
	bh=iuHBraZ6RVFjDpHf88PWAP4EJDMCcCZNFb7fBK+tG28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M9PZw4mRWwUGN2uoIRyD5QHhIsd5xvE2ptwYG89Kw31BYX1c1tceTWc9FykYYR9Sv
	 g5M2NkrzI4lFQEIKyO1vY93SS7s0mhxje9wR1il1T9A4+XThVuDS8nlgqHMPPks4EY
	 XVAbeKMhc2ezxiMq8lMU1DLi5RZUqv3+IR66LfFo=
Date: Tue, 16 Sep 2025 17:14:20 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: zhangfei.gao@linaro.org, wangzhou1@hisilicon.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linuxarm@openeuler.org, fanghao11@huawei.com, shenyang39@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com
Subject: Re: [PATCH v2 1/4] uacce: fix for cdev memory leak
Message-ID: <2025091620-theft-glue-5e7f@gregkh>
References: <20250916144811.1799687-1-huangchenghai2@huawei.com>
 <20250916144811.1799687-2-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916144811.1799687-2-huangchenghai2@huawei.com>

On Tue, Sep 16, 2025 at 10:48:08PM +0800, Chenghai Huang wrote:
> From: Wenkai Lin <linwenkai6@hisilicon.com>
> 
> If cdev_device_add failed, it is hard to determine
> whether cdev_del has been executed, which lead to a
> memory leak issue, so we use cdev_init to avoid it.

I do not understand, what is wrong with the current code?  It checks if
add fails:

> 
> Fixes: 015d239ac014 ("uacce: add uacce driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/misc/uacce/uacce.c | 13 ++++---------
>  include/linux/uacce.h      |  2 +-
>  2 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> index 42e7d2a2a90c..12370469f646 100644
> --- a/drivers/misc/uacce/uacce.c
> +++ b/drivers/misc/uacce/uacce.c
> @@ -522,14 +522,10 @@ int uacce_register(struct uacce_device *uacce)
>  	if (!uacce)
>  		return -ENODEV;
>  
> -	uacce->cdev = cdev_alloc();
> -	if (!uacce->cdev)
> -		return -ENOMEM;

This is the check.


> -
> -	uacce->cdev->ops = &uacce_fops;
> -	uacce->cdev->owner = THIS_MODULE;
> +	cdev_init(&uacce->cdev, &uacce_fops);
> +	uacce->cdev.owner = THIS_MODULE;
>  
> -	return cdev_device_add(uacce->cdev, &uacce->dev);
> +	return cdev_device_add(&uacce->cdev, &uacce->dev);

And so is this.  So what is wrong here?


>  }
>  EXPORT_SYMBOL_GPL(uacce_register);
>  
> @@ -568,8 +564,7 @@ void uacce_remove(struct uacce_device *uacce)
>  		unmap_mapping_range(q->mapping, 0, 0, 1);
>  	}
>  
> -	if (uacce->cdev)
> -		cdev_device_del(uacce->cdev, &uacce->dev);
> +	cdev_device_del(&uacce->cdev, &uacce->dev);
>  	xa_erase(&uacce_xa, uacce->dev_id);
>  	/*
>  	 * uacce exists as long as there are open fds, but ops will be freed
> diff --git a/include/linux/uacce.h b/include/linux/uacce.h
> index e290c0269944..98b896192a44 100644
> --- a/include/linux/uacce.h
> +++ b/include/linux/uacce.h
> @@ -126,7 +126,7 @@ struct uacce_device {
>  	bool is_vf;
>  	u32 flags;
>  	u32 dev_id;
> -	struct cdev *cdev;
> +	struct cdev cdev;
>  	struct device dev;

You can not do this, you now have 2 different reference counts
controlling the lifespan of this one structure.  That is just going to
cause so many more bugs...

How was this tested?  What is currently failing that requires this
change?

thanks,

greg k-h
