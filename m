Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660B8246788;
	Sat, 13 Sep 2025 11:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757761581; cv=none; b=gTiif43BRkSkRUqSkbtyDnBRQu8pErgh8bbee1L4KR+Q9dkV4JWNhWCkOCfWPnQ5jfQ8PX82MjYImWq3PEDKUPyTbkfa3fXBp88oUqnVT0M1hPzelAR77CDjZld4QNrIOqw+KxKyNNq17xM0lXEyDNSzozU+9jTRtAr+/TQAKlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757761581; c=relaxed/simple;
	bh=szFTrZp5S9Oy4p7ylGbdzdMqQBAOQWe3AlXIIsUOjWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIJzCoDQBXNLS1GSOzie9rFvUKWVhAgX2aBdRTmOwQwtXMWwj5OLubl++Sg+LWO0Uje2872PQCnp3VupDw0Vn/6biYjK6MWgbJ2l6KN7D6/vg4lHK5+vAO0FbgQNshJ0/uxZ0kf9byihsZ/99da4QKKQ2tLadqA5TkCzpKOHrc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ctkjdq05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ctkjdq05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873B8C4CEEB;
	Sat, 13 Sep 2025 11:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757761579;
	bh=szFTrZp5S9Oy4p7ylGbdzdMqQBAOQWe3AlXIIsUOjWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ctkjdq05sdDXthTlFmPEY/dXi1Z23yu9NNw4emWqkHw4ot8Fbuo0HQ8wQ7lkhcaw3
	 QhCAbNhFAIg1qdY+VsqVNCIU7CoUGuKuUd3tqTob2p5wd7yTEAH3ej7PxbAj/BCsDt
	 pzqkP85QR6r7WIUYRcmfSK5TeSt7nRHXidg7p09k=
Date: Sat, 13 Sep 2025 13:06:15 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: huangchenghai <huangchenghai2@huawei.com>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>, wangzhou1@hisilicon.com,
	linux-kernel@vger.kernel.org, linuxarm@huawei.com,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	shenyang39@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, liulongfang@huawei.com
Subject: Re: [PATCH 3/4] uacce: implement mremap in uacce_vm_ops to return
 -EPERM
Message-ID: <2025091358-doornail-underpaid-35ca@gregkh>
References: <20250822103904.3776304-1-huangchenghai2@huawei.com>
 <20250822103904.3776304-4-huangchenghai2@huawei.com>
 <2025082208-coauthor-pagan-e72c@gregkh>
 <CABQgh9GEZSasZq5bDthQrTZnJ_Uo8G-swDsrM_gWCecWbtTKgA@mail.gmail.com>
 <2025090608-afloat-grumbling-e729@gregkh>
 <868ceb0e-f4ba-4495-a1e1-0e387049281a@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868ceb0e-f4ba-4495-a1e1-0e387049281a@huawei.com>

On Sat, Sep 13, 2025 at 06:40:23PM +0800, huangchenghai wrote:
> 
> On Sat, 6 Sept 2025 at 20:03, Greg KH wrote:
> > On Thu, Aug 28, 2025 at 01:59:48PM +0800, Zhangfei Gao wrote:
> > > Hi, Greg
> > > 
> > > On Fri, 22 Aug 2025 at 19:46, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > On Fri, Aug 22, 2025 at 06:39:03PM +0800, Chenghai Huang wrote:
> > > > > From: Yang Shen <shenyang39@huawei.com>
> > > > > 
> > > > > The current uacce_vm_ops does not support the mremap operation of
> > > > > vm_operations_struct. Implement .mremap to return -EPERM to remind
> > > > > users
> > > > Why is this needed?  If mremap is not set, what is the value returned?
> > > Did some debug locally.
> > > 
> > > By default, mremap is permitted.
> > > 
> > > With mremap, the original vma is released,
> > > The vma_close is called and free resources, including q->qfr.
> > > 
> > > However, vma->vm_private_data (q) is copied to the new vma.
> > > When the new vma is closed, vma_close will get q and q->qft=0.
> > > 
> > > So disable mremap here looks safer.
> > > 
> > > > And why is -EPERM the correct value to return here?  That's not what the
> > > > man pages say is valid :(
> > > if disable mremap, -1 is returned as MAP_FAILED.
> > > The errno is decided by the return value, -EPERM (-1) or -EINVAL (-22).
> > > man mremap only lists -EINVAL.
> > > 
> > > However, here the driver wants to disable mremap, looks -EPERM is more suitable.
> > Disabling mremap is not a permission issue, it's more of an invalid
> > call?  I don't know, what do other drivers do?
> > 
> > thanks,
> > 
> > greg k-h
> Hi Greg,
> 
> Thank you for your feedback.
> 
> The reason we need to explicitly disable mremap is that when the
> driver does not implement .mremap, it uses the default mremap
> method. This could lead to a risk scenario:
> 
> An application might first mmap address p1, then mremap to p2,
> followed by munmap(p1), and finally munmap(p2). Since the default
> mremap copies the original vma's vm_private_data (i.e., q) to the
> new vma, both munmap operations would trigger vma_close, causing
> q->qfr to be freed twice(qfr will be set to null here, so repeated release
> is ok).

Great, can you please include that in the changelog text?

thanks,

greg k-h
