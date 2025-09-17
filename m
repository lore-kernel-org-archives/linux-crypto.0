Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E393A22D78A;
	Wed, 17 Sep 2025 10:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758104340; cv=none; b=XU1DPVGeYYXYnvjyKq77A05QWEIjqJxjTbu3qBwDDU0kD3/CUlbXaqp/LU30Nmfjgikrv7IDl/1GwfRh5Ff5GU/DMVee2HuGIRrP5UI2FTUQW0mH3Gjs/c6ogMGx+mL4dI9h0A0XNcYLlWl8VPbWaxMhu20sw4y3+BLNFuBWJQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758104340; c=relaxed/simple;
	bh=xZ6oXqrCDIheh5tPbFkiJHA70YfhI8hMU67vH9KKc3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s2iYE/yV8QGdnpKVJNB5GoC+De5R4s9NsZzwuvd369G3P+u2qaZ2F8MZXBX2FWP0js0BxKBydXYqW6vhPe3UjtluJUVHor+4Hik4kKoYWPEXy6IO1ZmHJrUat6bLT3p7tSOU3bPoHaFrhtRZAZ7OuxyVMxGe6k1iaCBtbchyGjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIRWCGrg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIRWCGrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82BCC4CEF5;
	Wed, 17 Sep 2025 10:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758104339;
	bh=xZ6oXqrCDIheh5tPbFkiJHA70YfhI8hMU67vH9KKc3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nIRWCGrg8zQB1/9nrBX4+gIT93fXJCdHrLlOXraWkhHOcvMjix4bnG5nZTbs0tSRY
	 9EwBETbwx3zQfpRxvrMC2J8fTlopiHG8JRa+7u3SksUwns+WleqzPeJN8/tC9uBBNO
	 ifRxNVBVIPxSng0oLMdsXdf6K+eQ+uLXZFDH5pGY=
Date: Wed, 17 Sep 2025 12:18:56 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: huangchenghai <huangchenghai2@huawei.com>
Cc: zhangfei.gao@linaro.org, wangzhou1@hisilicon.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linuxarm@openeuler.org, fanghao11@huawei.com, shenyang39@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com
Subject: Re: [PATCH v2 1/4] uacce: fix for cdev memory leak
Message-ID: <2025091746-starship-nearest-7c10@gregkh>
References: <20250916144811.1799687-1-huangchenghai2@huawei.com>
 <20250916144811.1799687-2-huangchenghai2@huawei.com>
 <2025091620-theft-glue-5e7f@gregkh>
 <8e5d4afb-8a21-4a93-a80f-e1f2b6baa8ca@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8e5d4afb-8a21-4a93-a80f-e1f2b6baa8ca@huawei.com>

On Wed, Sep 17, 2025 at 05:56:16PM +0800, huangchenghai wrote:
> 
> On Mon, Sep 16, 2025 at 11:15 PM +0800, Greg KH wrote:
> > On Tue, Sep 16, 2025 at 10:48:08PM +0800, Chenghai Huang wrote:
> > > From: Wenkai Lin <linwenkai6@hisilicon.com>
> > > 
> > > If cdev_device_add failed, it is hard to determine
> > > whether cdev_del has been executed, which lead to a
> > > memory leak issue, so we use cdev_init to avoid it.
> > I do not understand, what is wrong with the current code?  It checks if
> > add fails:
> > 
> > > Fixes: 015d239ac014 ("uacce: add uacce driver")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> > > Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> > > ---
> > >   drivers/misc/uacce/uacce.c | 13 ++++---------
> > >   include/linux/uacce.h      |  2 +-
> > >   2 files changed, 5 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> > > index 42e7d2a2a90c..12370469f646 100644
> > > --- a/drivers/misc/uacce/uacce.c
> > > +++ b/drivers/misc/uacce/uacce.c
> > > @@ -522,14 +522,10 @@ int uacce_register(struct uacce_device *uacce)
> > >   	if (!uacce)
> > >   		return -ENODEV;
> > > -	uacce->cdev = cdev_alloc();
> > > -	if (!uacce->cdev)
> > > -		return -ENOMEM;
> > This is the check.
> > 
> > 
> > > -
> > > -	uacce->cdev->ops = &uacce_fops;
> > > -	uacce->cdev->owner = THIS_MODULE;
> > > +	cdev_init(&uacce->cdev, &uacce_fops);
> > > +	uacce->cdev.owner = THIS_MODULE;
> > > -	return cdev_device_add(uacce->cdev, &uacce->dev);
> > > +	return cdev_device_add(&uacce->cdev, &uacce->dev);
> > And so is this.  So what is wrong here?
> > 
> > 
> > >   }
> > >   EXPORT_SYMBOL_GPL(uacce_register);
> > > @@ -568,8 +564,7 @@ void uacce_remove(struct uacce_device *uacce)
> > >   		unmap_mapping_range(q->mapping, 0, 0, 1);
> > >   	}
> > > -	if (uacce->cdev)
> > > -		cdev_device_del(uacce->cdev, &uacce->dev);
> > > +	cdev_device_del(&uacce->cdev, &uacce->dev);
> > >   	xa_erase(&uacce_xa, uacce->dev_id);
> > >   	/*
> > >   	 * uacce exists as long as there are open fds, but ops will be freed
> > > diff --git a/include/linux/uacce.h b/include/linux/uacce.h
> > > index e290c0269944..98b896192a44 100644
> > > --- a/include/linux/uacce.h
> > > +++ b/include/linux/uacce.h
> > > @@ -126,7 +126,7 @@ struct uacce_device {
> > >   	bool is_vf;
> > >   	u32 flags;
> > >   	u32 dev_id;
> > > -	struct cdev *cdev;
> > > +	struct cdev cdev;
> > >   	struct device dev;
> > You can not do this, you now have 2 different reference counts
> > controlling the lifespan of this one structure.  That is just going to
> > cause so many more bugs...
> > 
> > How was this tested?  What is currently failing that requires this
> > change?
> > 
> > thanks,
> > 
> > greg k-h
> We analyze it theoretically there may be a memory leak
> issue here, if the cdev_device_add returns a failure,
> the uacce_remove will not be executed, which results in the
> uacce cdev memory not being released.

Then properly clean up if that happens.

> Therefore, we have decided to align with the design of other
> drivers by making cdev a static member of uacce_device and
> releasing the memory through uacce_device.

But again, this is wrong to do.

> found one example in drivers/watchdog/watchdog_dev.h.
> struct watchdog_core_data {
>     struct device dev;
>     struct cdev cdev;

This is also wrong and needs to be fixed.  Please send a patch to
resolve it as well, as it should not be copied as a valid example.

thanks,

greg k-h
