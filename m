Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114A7C3F2CD
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 11:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC8192146E
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 11:45:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Os41xsdy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgCCLpV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 06:45:21 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35185 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728661AbgCCLpV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 06:45:21 -0500
Received: by mail-wr1-f66.google.com with SMTP id r7so3966601wro.2
        for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2020 03:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PZ26SY4OwzsSrrvvDGgwwk0/Jl3p0EnMD6uJWZM6hTo=;
        b=Os41xsdyARcThMKgbHdgjT2+ry+sDNsiEi589q5nCVRho3STC+L29GGxO7sHC3e8mR
         +DAjmJXd+wBqZoeuUGQ8IfRJ48h7xqleIj9yg2t3x6sEaZjLp5+8uR/M69QtkqCLZmjB
         5n8viie8sqPIAQv/el8Cu2RHEevc3PnyAk+WKwjd7N72EO/PmDcplEzStoeeQXpTBd+B
         zfRLNNZFj6pgVODZ62JI9IxMFgP86GXWT9mVSe4OzNNIkcutBUlneGzQGtPujn3Tdhfk
         1G5BM85dir9NDY07dZk8lt6CEKfsyf/B7f4J5D74lvlB/MqFZqRi3bR/uEa3D6amHtMi
         DtDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PZ26SY4OwzsSrrvvDGgwwk0/Jl3p0EnMD6uJWZM6hTo=;
        b=cwO8R8bwa+IMWMm9J8I+zif6+GWM0xKkq8HtKzSk7SCBguTMto5+c7BEZsLXfj7cHO
         pjQZG7FAb+B38hisEr0QskuIyANd2cR3ELYuiV6dZa24pq5nFYZVNTzv0DTpjxrlD4oS
         sg8+Y9PWG3Mw/nVh8J+cSYsMidp+dmHZVzCTKAI0GWtYZQbXuk8/a3WpIvpfoF1gVXxM
         8UsHhQNzkQgZ/pSWUXyxkXoLZiTyB31y4V01fbOGmlBFONIgfiarrjlXtzk1/VEebNrG
         Q/dZv+Fix/fy0dK9q7hjdQXV4o95v0B3YuFxwB6koOnWqMcHEZ9dlU4IXBinpo/ycWBe
         m2zQ==
X-Gm-Message-State: ANhLgQ0GrtIfPXN8oNcrSobjZLoMhnDN46+T6t4f+NFDh0TDx6VLYHMH
        xvu9ZPzgtovj8YwWHaaTmF7p7A==
X-Google-Smtp-Source: ADFU+vvAQcjhLmXZmUStTMU0McPCavF6iV/MgepVuImdgSSkgWiW5gBhUK4eC9HXObGd07iarLeZ4g==
X-Received: by 2002:a05:6000:2:: with SMTP id h2mr5422393wrx.182.1583235918023;
        Tue, 03 Mar 2020 03:45:18 -0800 (PST)
Received: from myrica ([2001:171b:c9a8:fbc0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id a7sm3510943wmb.0.2020.03.03.03.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 03:45:17 -0800 (PST)
Date:   Tue, 3 Mar 2020 12:45:10 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Raj, Ashok" <ashok.raj@linux.intel.com>
Cc:     Zhangfei Gao <zhangfei.gao@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, dave.jiang@intel.com,
        grant.likely@arm.com, Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>, Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v12 2/4] uacce: add uacce driver
Message-ID: <20200303114510.GA584461@myrica>
References: <1579097568-17542-1-git-send-email-zhangfei.gao@linaro.org>
 <1579097568-17542-3-git-send-email-zhangfei.gao@linaro.org>
 <20200224182201.GA22668@araj-mobl1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224182201.GA22668@araj-mobl1.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 24, 2020 at 10:22:02AM -0800, Raj, Ashok wrote:
> Hi Kenneth,
> 
> sorry for waking up late on this patchset.
> 
> 
> On Wed, Jan 15, 2020 at 10:12:46PM +0800, Zhangfei Gao wrote:
> [... trimmed]
> 
> > +
> > +static int uacce_fops_open(struct inode *inode, struct file *filep)
> > +{
> > +	struct uacce_mm *uacce_mm = NULL;
> > +	struct uacce_device *uacce;
> > +	struct uacce_queue *q;
> > +	int ret = 0;
> > +
> > +	uacce = xa_load(&uacce_xa, iminor(inode));
> > +	if (!uacce)
> > +		return -ENODEV;
> > +
> > +	q = kzalloc(sizeof(struct uacce_queue), GFP_KERNEL);
> > +	if (!q)
> > +		return -ENOMEM;
> > +
> > +	mutex_lock(&uacce->mm_lock);
> > +	uacce_mm = uacce_mm_get(uacce, q, current->mm);
> 
> I think having this at open time is a bit unnatural. Since when a process
> does fork, we do not inherit the PASID. Although it inherits the fd
> but cannot use the mmaped address in the child.

Both the queue and the PASID are tied to a single address space. When it
disappears, the queue is stopped (zombie state) and the PASID is freed.
The fd is not usable nor recoverable at this point, it's just waiting to
be released.

> If you move this to the mmap time, its more natural. The child could
> do a mmap() get a new PASID + mmio space to work with the hardware.

I like the idea, as it ties the lifetime of the bond to that of the queue
mapping, but I have two small concerns:

* It adds a lot of side-effect to mmap(). In addition to mapping the MMIO
  region it would now create both the bond and the queue. For userspace,
  figuring out why the mmap() fails would be more difficult.

* It forces uacce drivers to implement an mmap() interface, and have MMIO
  regions to share. I suspect it's going to be the norm but at the moment
  it's not mandatory, drivers could just implement ioctls ops.

I guess the main benefit would be reusing an fd after the original address
space dies, but is it a use-case?

I'd rather go one step further in the other direction, declare that an fd
is a queue and is exclusive to an address space, by preventing any
operation (ioctl and mmap) from an mm other than the one that opened the
fd. It's not natural but it'd keep the kernel driver simple as we wouldn't
have to reconfigure the queue during the lifetime of the fd.

Thanks,
Jean
