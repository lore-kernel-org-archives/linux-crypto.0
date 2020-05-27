Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D0CC433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 09:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDB9420723
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 09:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590570085;
	bh=WaKZbkte9zWy+gFwJcABM4VB+ItBxdRy7nyXN7rBb3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GxBsYXv26NDPhbRUDm8FyjYyfJOXCIHwZSDB3+YpVERjhiy/aOP93Zwi+JdwsqzpC
	 NWGn06HGpTl15qi3az5LXXayFNEcX6mlkbrmz7ioUSU5iuyDkTFvUgH0xjitX+f5Fd
	 I8JfpmTior1g3ADl8K09UaK/kMuV0eKo5KQaf4w8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388362AbgE0JBS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 05:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388331AbgE0JBS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 05:01:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1184920723;
        Wed, 27 May 2020 09:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590570077;
        bh=WaKZbkte9zWy+gFwJcABM4VB+ItBxdRy7nyXN7rBb3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mGy3UQlKkCSG671Ydi7G9PDHAXHw3tvtIYrcoZsk94xWH7NkmD8YF+mjSEFmwocHn
         dx9nTApSCbCQ2C0rP4Wh0RmwLgzASHW4OVNvv0tAMviYc/4qJ0+c7Nh6YkoAjWCiYF
         MbwANd2b+y59F8114ucQHxhJVnTvz7S8zkgTDHe8=
Date:   Wed, 27 May 2020 11:01:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        jean-philippe <jean-philippe@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu: calling pci_fixup_iommu in iommu_fwspec_init
Message-ID: <20200527090115.GB179718@kroah.com>
References: <1590493749-13823-1-git-send-email-zhangfei.gao@linaro.org>
 <1590493749-13823-3-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590493749-13823-3-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 26, 2020 at 07:49:09PM +0800, Zhangfei Gao wrote:
> Calling pci_fixup_iommu in iommu_fwspec_init, which alloc
> iommu_fwnode. Some platform devices appear as PCI but are
> actually on the AMBA bus, and they need fixup in
> drivers/pci/quirks.c handling iommu_fwnode.
> So calling pci_fixup_iommu after iommu_fwnode is allocated.
> 
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> ---
>  drivers/iommu/iommu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 7b37542..fb84c42 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2418,6 +2418,10 @@ int iommu_fwspec_init(struct device *dev, struct fwnode_handle *iommu_fwnode,
>  	fwspec->iommu_fwnode = iommu_fwnode;
>  	fwspec->ops = ops;
>  	dev_iommu_fwspec_set(dev, fwspec);
> +
> +	if (dev_is_pci(dev))
> +		pci_fixup_device(pci_fixup_iommu, to_pci_dev(dev));

Why can't the caller do this as it "knows" it is a PCI device at that
point in time, right?

thanks,

greg k-h
