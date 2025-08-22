Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5E32327A3;
	Fri, 22 Aug 2025 11:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755862059; cv=none; b=Jw2EUZm5yMurmOCQsLqkFclFj0qRq9jd8Ldbc7hp9TiwtR9FKplBpz3lnd6KMyQXFFmCWsf6xAJkvpTxhpq7MK4f9ts9sDqhJAxqHWd+2AanhzY8xhdqYct6XW4HVFaVEF+n3nJ8qoVZ/UtLW97vf2P6+ne7QzlwmhyGZ1A1mZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755862059; c=relaxed/simple;
	bh=3Kgf+y6e35Op9fQ+M1WLCnT+//IC1+yL8fOKMyX8TI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DMpyeu7c6WYd6E0wCLwqFmfAyBP/SGV+HCl0AehNw6MdTfFAuQ3+NtT0EAaQoykFjsdKsmiOAZsDLPi+EBsHXE0LB3Yy0O/4Qgo5JurYLdEP+Ma2EykkATzfaXXCURy7N24zhqDmb4kK1XPrbBGTXIcJC2duhmDsmkEDk50YZPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HamKAtjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HamKAtjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3079AC4CEED;
	Fri, 22 Aug 2025 11:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755862058;
	bh=3Kgf+y6e35Op9fQ+M1WLCnT+//IC1+yL8fOKMyX8TI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HamKAtjyg4VtGz/jADuVf4C7Az+cxSDiheUlbxSlNMYyRJpedtd+kq9nvyntoxeax
	 UnoC0zXaYStH5+gAjiCzz1oO6dRTTMYuIBRYiDsK+zSumOmUZTUHjnCqbI11xWRqnE
	 NYbiognmTV4JH9I/N/uUQN0RFW1quKo7iVwab0us=
Date: Fri, 22 Aug 2025 13:27:35 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: zhangfei.gao@linaro.org, wangzhou1@hisilicon.com,
	linux-kernel@vger.kernel.org, linuxarm@huawei.com,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	shenyang39@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, liulongfang@huawei.com
Subject: Re: [PATCH 1/4] uacce: fix for cdev memory leak
Message-ID: <2025082225-gooey-paralyses-5f24@gregkh>
References: <20250822103904.3776304-1-huangchenghai2@huawei.com>
 <20250822103904.3776304-2-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822103904.3776304-2-huangchenghai2@huawei.com>

On Fri, Aug 22, 2025 at 06:39:01PM +0800, Chenghai Huang wrote:
> From: Wenkai Lin <linwenkai6@hisilicon.com>
> 
> If adding uacce cdev to the system fails, it could be due to two
> reasons: either the device's devt exists when the failure occurs,
> or the device_add operation fails. In the latter case, cdev_del
> will be executed, but in the former case, it will not, leading to a
> resource leak. Therefore, it is necessary to perform the cdev_del
> action during abnormal exit.
> 
> Fixes: 015d239ac014 ("uacce: add uacce driver")
> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/misc/uacce/uacce.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> index 42e7d2a2a90c..3604f722ed60 100644
> --- a/drivers/misc/uacce/uacce.c
> +++ b/drivers/misc/uacce/uacce.c
> @@ -519,6 +519,8 @@ EXPORT_SYMBOL_GPL(uacce_alloc);
>   */
>  int uacce_register(struct uacce_device *uacce)
>  {
> +	int ret;
> +
>  	if (!uacce)
>  		return -ENODEV;
>  
> @@ -529,7 +531,14 @@ int uacce_register(struct uacce_device *uacce)
>  	uacce->cdev->ops = &uacce_fops;
>  	uacce->cdev->owner = THIS_MODULE;
>  
> -	return cdev_device_add(uacce->cdev, &uacce->dev);
> +	ret = cdev_device_add(uacce->cdev, &uacce->dev);
> +	if (ret) {
> +		cdev_del(uacce->cdev);
> +		uacce->cdev = NULL;
> +		return ret;
> +	}
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(uacce_register);
>  
> -- 
> 2.33.0
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- You have marked a patch with a "Fixes:" tag for a commit that is in an
  older released kernel, yet you do not have a cc: stable line in the
  signed-off-by area at all, which means that the patch will not be
  applied to any older kernel releases.  To properly fix this, please
  follow the documented rules in the
  Documentation/process/stable-kernel-rules.rst file for how to resolve
  this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
