Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1776BA4A;
	Sat,  6 Sep 2025 12:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757160232; cv=none; b=srFD4EjMkDMQ9WMd+pGg5uzhcVAQTzJ0EvPDnb/kZViMFYTS1Djh0Kkqo9StSvw9ur5UuR2eTFJoGQMzUxO+ZSIwCnGD7jXGfho1jvefNW2WJIiW+7ZhpuQ2DdK5SnOeRnMIWt47ynb5vWAQYO0PZg/5EEqchy9ukH6ffZ6qNX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757160232; c=relaxed/simple;
	bh=yYQTV6D3GGpRrEu0sZMiFOUTFVX0nYAZY2Hlbea5Ht0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fj+cZMpoPcHdPYy/dCQ0o8p6uLQffliDEf3CxvQRHJ+aUpmrrJWchnKBOwwO1PYtnvLzq+OJYwSvpZWPTwk9J5JUlJK03l5/MJPRyCqmIFOjX0MBCGBL2wKqljgPBtq8h025NKOkjNUBxl56U/f4WmJggH9YSDd+b61niOq2Uwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbG58StW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbG58StW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F21C4CEE7;
	Sat,  6 Sep 2025 12:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757160231;
	bh=yYQTV6D3GGpRrEu0sZMiFOUTFVX0nYAZY2Hlbea5Ht0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MbG58StWpwFaWjc+a6xkmrMPnXlLaKhL2mCgu0zw2K8DTuS/5zFoYycxPNGTbr/co
	 lYBD4R+S5Xc72ndACipmOt8UizDp4Tf8WRDHYBkdtUEd8WsJzVN6DYwXYdiFtErvs4
	 pWk9SEo3yuLs2xQEVnxGzntx9rwLYAO2+3fij9dM=
Date: Sat, 6 Sep 2025 14:03:48 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: Chenghai Huang <huangchenghai2@huawei.com>, wangzhou1@hisilicon.com,
	linux-kernel@vger.kernel.org, linuxarm@huawei.com,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	shenyang39@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, liulongfang@huawei.com
Subject: Re: [PATCH 3/4] uacce: implement mremap in uacce_vm_ops to return
 -EPERM
Message-ID: <2025090608-afloat-grumbling-e729@gregkh>
References: <20250822103904.3776304-1-huangchenghai2@huawei.com>
 <20250822103904.3776304-4-huangchenghai2@huawei.com>
 <2025082208-coauthor-pagan-e72c@gregkh>
 <CABQgh9GEZSasZq5bDthQrTZnJ_Uo8G-swDsrM_gWCecWbtTKgA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABQgh9GEZSasZq5bDthQrTZnJ_Uo8G-swDsrM_gWCecWbtTKgA@mail.gmail.com>

On Thu, Aug 28, 2025 at 01:59:48PM +0800, Zhangfei Gao wrote:
> Hi, Greg
> 
> On Fri, 22 Aug 2025 at 19:46, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Aug 22, 2025 at 06:39:03PM +0800, Chenghai Huang wrote:
> > > From: Yang Shen <shenyang39@huawei.com>
> > >
> > > The current uacce_vm_ops does not support the mremap operation of
> > > vm_operations_struct. Implement .mremap to return -EPERM to remind
> > > users
> >
> > Why is this needed?  If mremap is not set, what is the value returned?
> 
> Did some debug locally.
> 
> By default, mremap is permitted.
> 
> With mremap, the original vma is released,
> The vma_close is called and free resources, including q->qfr.
> 
> However, vma->vm_private_data (q) is copied to the new vma.
> When the new vma is closed, vma_close will get q and q->qft=0.
> 
> So disable mremap here looks safer.
> 
> >
> > And why is -EPERM the correct value to return here?  That's not what the
> > man pages say is valid :(
> 
> if disable mremap, -1 is returned as MAP_FAILED.
> The errno is decided by the return value, -EPERM (-1) or -EINVAL (-22).
> man mremap only lists -EINVAL.
> 
> However, here the driver wants to disable mremap, looks -EPERM is more suitable.

Disabling mremap is not a permission issue, it's more of an invalid
call?  I don't know, what do other drivers do?

thanks,

greg k-h
