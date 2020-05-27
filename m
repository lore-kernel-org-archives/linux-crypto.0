Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C3CC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 09:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6265207E8
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 09:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590570106;
	bh=Ly0PPgLoVOdP2MHz53CmBLAFstCS5mfpl1WpLZ15gps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=pKTgM8A0Bph0xvGGI1XPq3paib1yuVr7HfDtvCOpcp3IfoO2wPCGdwadEbXQMpQNg
	 LQHNJcxEa7uvWsWrSKgvyjIvU7RJO7+a9qsHvaN2fJC73qUNqmBvLmLlLJzDMLMPtV
	 QtgYAQ2O5KfbjhT9sGcUzt9VVmHQebTTsH/9WPKo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388320AbgE0JBp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 05:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388213AbgE0JBp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 05:01:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CC1F20723;
        Wed, 27 May 2020 09:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590570104;
        bh=Ly0PPgLoVOdP2MHz53CmBLAFstCS5mfpl1WpLZ15gps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=onCoAOhnzHO9z1pUO0//RWYJLmKfFMRTqXoBIY+gdObr+17e6nwXXsvWN0RMThy9e
         uwLwAnL2f9xW9oLDKOWZn/Nzmaln1ON7ULTIQPpaM1zsoyYnkrxXXpwhUkArhx2hE2
         yEEIJrw8f7A1SPpbRQGH1EvlHjbsZMtVrqHdWmVk=
Date:   Wed, 27 May 2020 11:01:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
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
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] PCI: Introduce PCI_FIXUP_IOMMU
Message-ID: <20200527090142.GC179718@kroah.com>
References: <1590493749-13823-1-git-send-email-zhangfei.gao@linaro.org>
 <1590493749-13823-2-git-send-email-zhangfei.gao@linaro.org>
 <20200526144644.GA20784@infradead.org>
 <39144dc0-3b04-3127-978b-bd8487dd06e0@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39144dc0-3b04-3127-978b-bd8487dd06e0@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 26, 2020 at 11:09:57PM +0800, Zhangfei Gao wrote:
> Hi, Christoph
> 
> On 2020/5/26 下午10:46, Christoph Hellwig wrote:
> > On Tue, May 26, 2020 at 07:49:08PM +0800, Zhangfei Gao wrote:
> > > Some platform devices appear as PCI but are actually on the AMBA bus,
> > > and they need fixup in drivers/pci/quirks.c handling iommu_fwnode.
> > > Here introducing PCI_FIXUP_IOMMU, which is called after iommu_fwnode
> > > is allocated, instead of reusing PCI_FIXUP_FINAL since it will slow
> > > down iommu probing as all devices in fixup final list will be
> > > reprocessed.
> > Who is going to use this?  I don't see a single user in the series.
> We will add iommu fixup in drivers/pci/quirks.c, handling
> 
> fwspec->can_stall, which is introduced in
> 
> https://www.spinics.net/lists/linux-pci/msg94559.html
> 
> Unfortunately, the patch does not catch v5.8, so we have to wait.
> And we want to check whether this is a right method to solve this issue.

We can't take new apis without a real user, so please submit them all at
once.

thanks,

greg k-h
