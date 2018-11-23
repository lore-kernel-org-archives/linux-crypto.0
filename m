Return-Path: <SRS0=Oq1A=OC=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:57633 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729827AbeKWSoR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Nov 2018 13:44:17 -0500
Date: Fri, 23 Nov 2018 16:02:42 +0800
From: Kenneth Lee <liguozhu@hisilicon.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Leon Romanovsky <leon@kernel.org>,
        Kenneth Lee <nek.in.cn@gmail.com>,
        "Tim Sell" <timothy.sell@unisys.com>, <linux-doc@vger.kernel.org>,
        "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
        Zaibo Xu <xuzaibo@huawei.com>, <zhangfei.gao@foxmail.com>,
        <linuxarm@huawei.com>, <haojian.zhuang@linaro.org>,
        Christoph Lameter <cl@linux.com>,
        Hao Fang <fanghao11@huawei.com>,
        Gavin Schenk <g.schenk@eckelmann.de>,
        "RDMA mailing list" <linux-rdma@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        "Doug Ledford" <dledford@redhat.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
        <u.kleine-koenig@pengutronix.de>,
        David Kershner <david.kershner@unisys.com>,
        Johan Hovold <johan@kernel.org>,
        Cyrille Pitchen <cyrille.pitchen@free-electrons.com>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Jens Axboe <axboe@kernel.dk>, <guodong.xu@linaro.org>,
        linux-netdev <netdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        <linux-kernel@vger.kernel.org>, Vinod Koul <vkoul@kernel.org>,
        <linux-crypto@vger.kernel.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-accelerators@lists.ozlabs.org>
Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
Message-ID: <20181123080242.GK157308@Turing-Arch-b>
References: <95310df4-b32c-42f0-c750-3ad5eb89b3dd@gmail.com>
 <20181114160017.GI3759@mtr-leonro.mtl.com>
 <20181115085109.GD157308@Turing-Arch-b>
 <20181115145455.GN3759@mtr-leonro.mtl.com>
 <20181119091405.GE157308@Turing-Arch-b>
 <20181119184954.GB4890@ziepe.ca>
 <20181120030702.GH157308@Turing-Arch-b>
 <20181120032939.GR4890@ziepe.ca>
 <20181121060805.GJ157308@Turing-Arch-b>
 <20181122025840.GB19938@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181122025840.GB19938@ziepe.ca>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 21, 2018 at 07:58:40PM -0700, Jason Gunthorpe wrote:
> Date: Wed, 21 Nov 2018 19:58:40 -0700
> From: Jason Gunthorpe <jgg@ziepe.ca>
> To: Kenneth Lee <liguozhu@hisilicon.com>
> CC: Leon Romanovsky <leon@kernel.org>, Kenneth Lee <nek.in.cn@gmail.com>,
>  Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org, Alexander
>  Shishkin <alexander.shishkin@linux.intel.com>, Zaibo Xu
>  <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com, linuxarm@huawei.com,
>  haojian.zhuang@linaro.org, Christoph Lameter <cl@linux.com>, Hao Fang
>  <fanghao11@huawei.com>, Gavin Schenk <g.schenk@eckelmann.de>, RDMA mailing
>  list <linux-rdma@vger.kernel.org>, Zhou Wang <wangzhou1@hisilicon.com>,
>  Doug Ledford <dledford@redhat.com>, Uwe Kleine-König
>  <u.kleine-koenig@pengutronix.de>, David Kershner
>  <david.kershner@unisys.com>, Johan Hovold <johan@kernel.org>, Cyrille
>  Pitchen <cyrille.pitchen@free-electrons.com>, Sagar Dharia
>  <sdharia@codeaurora.org>, Jens Axboe <axboe@kernel.dk>,
>  guodong.xu@linaro.org, linux-netdev <netdev@vger.kernel.org>, Randy Dunlap
>  <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Vinod Koul
>  <vkoul@kernel.org>, linux-crypto@vger.kernel.org, Philippe Ombredanne
>  <pombredanne@nexb.com>, Sanyog Kale <sanyog.r.kale@intel.com>, "David S.
>  Miller" <davem@davemloft.net>, linux-accelerators@lists.ozlabs.org
> Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
> User-Agent: Mutt/1.9.4 (2018-02-28)
> Message-ID: <20181122025840.GB19938@ziepe.ca>
> 
> On Wed, Nov 21, 2018 at 02:08:05PM +0800, Kenneth Lee wrote:
> 
> > > But considering Jean's SVA stuff seems based on mmu notifiers, I have
> > > a hard time believing that it has any different behavior from RDMA's
> > > ODP, and if it does have different behavior, then it is probably just
> > > a bug in the ODP implementation.
> > 
> > As Jean has explained, his solution is based on page table sharing. I think ODP
> > should also consider this new feature.
> 
> Shared page tables would require the HW to walk the page table format
> of the CPU directly, not sure how that would be possible for ODP?
> 
> Presumably the implementation for ARM relies on the IOMMU hardware
> doing this?

Yes, that is the idea. And since Jean is merging the AMD and Intel solution
together, I assume they can do the same. This is also the reason I want to solve
my problem on top of IOMMU directly. But anyway, let me try to see if I can
merge the logic with ODP.

> 
> > > > > If all your driver needs is to mmap some PCI bar space, route
> > > > > interrupts and do DMA mapping then mediated VFIO is probably a good
> > > > > choice. 
> > > > 
> > > > Yes. That is what is done in our RFCv1/v2. But we accepted Jerome's opinion and
> > > > try not to add complexity to the mm subsystem.
> > > 
> > > Why would a mediated VFIO driver touch the mm subsystem? Sounds like
> > > you don't have a VFIO driver if it needs to do stuff like that...
> > 
> > VFIO has no ODP-like solution, and if we want to solve the fork problem, we have
> > to make some change to iommu and the fork procedure. Further, VFIO takes every
> > queue as a independent device. This create a lot of trouble on resource
> > management. For example, you will need a manager process to withdraw the unused
> > device and you need to let the user process know about PASID of the queue, and
> > so on.
> 
> Well, I would think you'd add SVA support to the VFIO driver as a
> generic capability - it seems pretty useful for any VFIO user as it
> avoids all the kernel upcalls to do memory pinning and DMA address
> translation.

It is already part of Jean's patchset. And that's why I built my solution on
VFIO in the first place. But I think the concept of SVA and PASID is not
compatible with the original VFIO concept space. You would not share your whole
address space to a device at all in a virtual machine manager, wouldn't you? And
if you can manage to have a separated mdev for your virtual machine, why bother
to set a PASID to it?  The answer to those problem, I think, will be Intel's
Scalable IO Virtualization. For accelerator, the requirement is simply: getting
a handle to device, attaching the process's mm with the handle by sharing the
process's page table with its iommu indexed by PASID, and start the
communication...

> 
> Once the VFIO driver knows about this as a generic capability then the
> device it exposes to userspace would use CPU addresses instead of DMA
> addresses.
> 
> The question is if your driver needs much more than the device
> agnostic generic services VFIO provides.
> 
> I'm not sure what you have in mind with resource management.. It is
> hard to revoke resources from userspace, unless you are doing
> kernel syscalls, but then why do all this?

Say, I have 1024 queues in my accelerator. I can get one by opening the device
and attach it with the fd. If the process exit by any means, the queue can be
returned with the release of the fd. But if it is mdev, it will still be there
and some one should tell the allocator it is available again. This is not easy
to design in user space.

> 
> Jason

-- 
