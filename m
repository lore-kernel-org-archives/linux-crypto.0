Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DE420B81B;
	Tue, 16 Sep 2025 15:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758035730; cv=none; b=CwhxJj8NIz5PWx3GrXYnGHUWwIGDiTllEf3XjSpK9tparxQFB+bFFSGbdxeYV3PAz9WS3Z03PO/hNja5ER1I/8JaZ6laIRsF32U1H82AvRo9N7N7Kgur6xlaB8DFdHiAPNWiNGek93O7mpO2YkkRJulaSViLETWUnGgz4w2E29w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758035730; c=relaxed/simple;
	bh=2lcTw4C7fqN2W7CHQ26kx1ZwB7S9YNJhj6YNlOeL4fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARHUpSLRJihKuLuApiLGQoO0UHOp+nHJzloFTXYWjOFv9A63SAnevSc7yrOB1Ptpa6kgqcdDhRmgFM3q41C67T+mHJkuV9AjamOOLstw/pQVlSzBWnFmjTJjqxqVHEGuZ37SKbROaOBdjw+iNjv/bl8V2pgZ/W1iIEtNqZdIaRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaGmHdk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaGmHdk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0DEC4CEEB;
	Tue, 16 Sep 2025 15:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758035730;
	bh=2lcTw4C7fqN2W7CHQ26kx1ZwB7S9YNJhj6YNlOeL4fM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TaGmHdk3RM+MwEz3zWyKQZNgXU5cqDbYL4dMp/18WDuTcF1yoiC7jYAqYwkpSIFKk
	 ODd1P4sxMPUPjnU56HkKeQvupeLqQQkX6rO7fsZNLken56MQsQ7egJzrRq20cn5I5K
	 9O2M0Nu8L76sKKSx1jg0PF0ui7p3LgiHSLpddMB8=
Date: Tue, 16 Sep 2025 17:15:26 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: zhangfei.gao@linaro.org, wangzhou1@hisilicon.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linuxarm@openeuler.org, fanghao11@huawei.com, shenyang39@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com
Subject: Re: [PATCH v2 2/4] uacce: fix isolate sysfs check condition
Message-ID: <2025091633-antacid-gluten-0a61@gregkh>
References: <20250916144811.1799687-1-huangchenghai2@huawei.com>
 <20250916144811.1799687-3-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916144811.1799687-3-huangchenghai2@huawei.com>

On Tue, Sep 16, 2025 at 10:48:09PM +0800, Chenghai Huang wrote:
> The uacce supports device isolation feature. If the driver
> implements the isolate_err_threshold_read and
> isolate_err_threshold_write callbacks, the uacce will create sysfs
> files. Users can read and configure isolation policies through
> sysfs. Currently, if either isolate_err_threshold_read or
> isolate_err_threshold_write callback exists, sysfs files are
> created.
> 
> However, accessing a non-existent callback may cause a system panic.

Where is the callback happening that fails?  Shouldn't that be checked
instead of doing this change?

> Therefore, sysfs files are only created when both
> isolate_err_threshold_read and isolate_err_threshold_write are
> present.

What if a device only has 1?  That should still work properly?

And why not just create the file if it is going to be used, that is the
real solution here.

thanks,

greg k-h
