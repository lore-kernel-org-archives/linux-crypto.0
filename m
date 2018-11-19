Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44879 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729991AbeKTFOs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 00:14:48 -0500
Received: by mail-pf1-f195.google.com with SMTP id u6so2816720pfh.11
        for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2018 10:49:57 -0800 (PST)
Date: Mon, 19 Nov 2018 11:49:54 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Kenneth Lee <liguozhu@hisilicon.com>
Cc: Leon Romanovsky <leon@kernel.org>,
        Kenneth Lee <nek.in.cn@gmail.com>,
        Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Zaibo Xu <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com,
        linuxarm@huawei.com, haojian.zhuang@linaro.org,
        Christoph Lameter <cl@linux.com>,
        Hao Fang <fanghao11@huawei.com>,
        Gavin Schenk <g.schenk@eckelmann.de>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Doug Ledford <dledford@redhat.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?=
        <u.kleine-koenig@pengutronix.de>,
        David Kershner <david.kershner@unisys.com>,
        Johan Hovold <johan@kernel.org>,
        Cyrille Pitchen <cyrille.pitchen@free-electrons.com>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Jens Axboe <axboe@kernel.dk>, guodong.xu@linaro.org,
        linux-netdev <netdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        linux-crypto@vger.kernel.org,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-accelerators@lists.ozlabs.org
Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
Message-ID: <20181119184954.GB4890@ziepe.ca>
References: <20181112075807.9291-1-nek.in.cn@gmail.com>
 <20181112075807.9291-2-nek.in.cn@gmail.com>
 <20181113002354.GO3695@mtr-leonro.mtl.com>
 <95310df4-b32c-42f0-c750-3ad5eb89b3dd@gmail.com>
 <20181114160017.GI3759@mtr-leonro.mtl.com>
 <20181115085109.GD157308@Turing-Arch-b>
 <20181115145455.GN3759@mtr-leonro.mtl.com>
 <20181119091405.GE157308@Turing-Arch-b>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119091405.GE157308@Turing-Arch-b>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 19, 2018 at 05:14:05PM +0800, Kenneth Lee wrote:
 
> If the hardware cannot share page table with the CPU, we then need to have
> some way to change the device page table. This is what happen in ODP. It
> invalidates the page table in device upon mmu_notifier call back. But this cannot
> solve the COW problem: if the user process A share a page P with device, and A 
> forks a new process B, and it continue to write to the page. By COW, the
> process B will keep the page P, while A will get a new page P'. But you have
> no way to let the device know it should use P' rather than P.

Is this true? I thought mmu_notifiers covered all these cases.

The mm_notifier for A should fire if B causes the physical address of
A's pages to change via COW. 

And this causes the device page tables to re-synchronize.

> In WarpDrive/uacce, we make this simple. If you support IOMMU and it support
> SVM/SVA. Everything will be fine just like ODP implicit mode. And you don't need
> to write any code for that. Because it has been done by IOMMU framework. If it

Looks like the IOMMU code uses mmu_notifier, so it is identical to
IB's ODP. The only difference is that IB tends to have the IOMMU page
table in the device, not in the CPU.

The only case I know if that is different is the new-fangled CAPI
stuff where the IOMMU can directly use the CPU's page table and the
IOMMU page table (in device or CPU) is eliminated.

Anyhow, I don't think a single instance of hardware should justify an
entire new subsystem. Subsystems are hard to make and without multiple
hardware examples there is no way to expect that it would cover any
future use cases.

If all your driver needs is to mmap some PCI bar space, route
interrupts and do DMA mapping then mediated VFIO is probably a good
choice. 

If it needs to do a bunch of other stuff, not related to PCI bar
space, interrupts and DMA mapping (ie special code for compression,
crypto, AI, whatever) then you should probably do what Jerome said and
make a drivers/char/hisillicon_foo_bar.c that exposes just what your
hardware does.

If you have networking involved in here then consider RDMA,
particularly if this functionality is already part of the same
hardware that the hns infiniband driver is servicing.

'computational MRs' are a reasonable approach to a side-car offload of
already existing RDMA support.

Jason
