Return-Path: <SRS0=9Lzg=36=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C6CC352A4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 23:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 546E62082F
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 23:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581377835;
	bh=fQpQqnYEf7MvKwrBnRZJUnT0J9NgKJgcijmSIdr/c18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2UXFTI0sKXgvBHGo7F4TjpeQqguPIGjwOQxwq2df89PqPtP9dHziF7dn2+v/muD4+
	 /1EuruXjnmZHYGiQFugDf1/V1kmGGuGMd6d+i6u7cemS1xRqPECV+fzkHIq8jEP974
	 5g4+4IwuuoiP4knXFbnXmdyJkjyjK5FEangmx11k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgBJXhO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Feb 2020 18:37:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727435AbgBJXhO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Feb 2020 18:37:14 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F40D7206D6;
        Mon, 10 Feb 2020 23:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581377832;
        bh=fQpQqnYEf7MvKwrBnRZJUnT0J9NgKJgcijmSIdr/c18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cM2hoNmd23mfSTK9sPXuHKGXGUb0TQe3NETEctiotIHp+2eQwIk42VvwHuxy8uu0R
         JVvK7VBmPJmLUvnPOMpJ04tyIR1gCw7GrFJSe4gjT4I96vr/2EaW0m4DAUnLjhwFMl
         D1Ghj9eJ5dAL5/qD0z97BKNctSIm7VYBrEy6RfyM=
Date:   Mon, 10 Feb 2020 15:37:11 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, dave.jiang@intel.com,
        grant.likely@arm.com, jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
Subject: Re: [PATCH v12 2/4] uacce: add uacce driver
Message-ID: <20200210233711.GA1787983@kroah.com>
References: <1579097568-17542-1-git-send-email-zhangfei.gao@linaro.org>
 <1579097568-17542-3-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579097568-17542-3-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 15, 2020 at 10:12:46PM +0800, Zhangfei Gao wrote:
> From: Kenneth Lee <liguozhu@hisilicon.com>
> 
> Uacce (Unified/User-space-access-intended Accelerator Framework) targets to
> provide Shared Virtual Addressing (SVA) between accelerators and processes.
> So accelerator can access any data structure of the main cpu.
> This differs from the data sharing between cpu and io device, which share
> only data content rather than address.
> Since unified address, hardware and user space of process can share the
> same virtual address in the communication.
> 
> Uacce create a chrdev for every registration, the queue is allocated to
> the process when the chrdev is opened. Then the process can access the
> hardware resource by interact with the queue file. By mmap the queue
> file space to user space, the process can directly put requests to the
> hardware without syscall to the kernel space.
> 
> The IOMMU core only tracks mm<->device bonds at the moment, because it
> only needs to handle IOTLB invalidation and PASID table entries. However
> uacce needs a finer granularity since multiple queues from the same
> device can be bound to an mm. When the mm exits, all bound queues must
> be stopped so that the IOMMU can safely clear the PASID table entry and
> reallocate the PASID.
> 
> An intermediate struct uacce_mm links uacce devices and queues.
> Note that an mm may be bound to multiple devices but an uacce_mm
> structure only ever belongs to a single device, because we don't need
> anything more complex (if multiple devices are bound to one mm, then
> we'll create one uacce_mm for each bond).
> 
>         uacce_device --+-- uacce_mm --+-- uacce_queue
>                        |              '-- uacce_queue
>                        |
>                        '-- uacce_mm --+-- uacce_queue
>                                       +-- uacce_queue
>                                       '-- uacce_queue
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>

Looks much saner now, thanks for all of the work on this:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Or am I supposed to take this in my tree?  If so, I can, but I need an
ack for the crypto parts.

thanks,

greg k-h
