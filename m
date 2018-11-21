Return-Path: <SRS0=qsBZ=OA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:14692 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726195AbeKUQjm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Nov 2018 11:39:42 -0500
Date: Wed, 21 Nov 2018 14:08:05 +0800
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
Message-ID: <20181121060805.GJ157308@Turing-Arch-b>
References: <20181112075807.9291-2-nek.in.cn@gmail.com>
 <20181113002354.GO3695@mtr-leonro.mtl.com>
 <95310df4-b32c-42f0-c750-3ad5eb89b3dd@gmail.com>
 <20181114160017.GI3759@mtr-leonro.mtl.com>
 <20181115085109.GD157308@Turing-Arch-b>
 <20181115145455.GN3759@mtr-leonro.mtl.com>
 <20181119091405.GE157308@Turing-Arch-b>
 <20181119184954.GB4890@ziepe.ca>
 <20181120030702.GH157308@Turing-Arch-b>
 <20181120032939.GR4890@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181120032939.GR4890@ziepe.ca>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 19, 2018 at 08:29:39PM -0700, Jason Gunthorpe wrote:
> Date: Mon, 19 Nov 2018 20:29:39 -0700
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
> Message-ID: <20181120032939.GR4890@ziepe.ca>
> 
> On Tue, Nov 20, 2018 at 11:07:02AM +0800, Kenneth Lee wrote:
> > On Mon, Nov 19, 2018 at 11:49:54AM -0700, Jason Gunthorpe wrote:
> > > Date: Mon, 19 Nov 2018 11:49:54 -0700
> > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > To: Kenneth Lee <liguozhu@hisilicon.com>
> > > CC: Leon Romanovsky <leon@kernel.org>, Kenneth Lee <nek.in.cn@gmail.com>,
> > >  Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org, Alexander
> > >  Shishkin <alexander.shishkin@linux.intel.com>, Zaibo Xu
> > >  <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com, linuxarm@huawei.com,
> > >  haojian.zhuang@linaro.org, Christoph Lameter <cl@linux.com>, Hao Fang
> > >  <fanghao11@huawei.com>, Gavin Schenk <g.schenk@eckelmann.de>, RDMA mailing
> > >  list <linux-rdma@vger.kernel.org>, Zhou Wang <wangzhou1@hisilicon.com>,
> > >  Doug Ledford <dledford@redhat.com>, Uwe Kleine-König
> > >  <u.kleine-koenig@pengutronix.de>, David Kershner
> > >  <david.kershner@unisys.com>, Johan Hovold <johan@kernel.org>, Cyrille
> > >  Pitchen <cyrille.pitchen@free-electrons.com>, Sagar Dharia
> > >  <sdharia@codeaurora.org>, Jens Axboe <axboe@kernel.dk>,
> > >  guodong.xu@linaro.org, linux-netdev <netdev@vger.kernel.org>, Randy Dunlap
> > >  <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Vinod Koul
> > >  <vkoul@kernel.org>, linux-crypto@vger.kernel.org, Philippe Ombredanne
> > >  <pombredanne@nexb.com>, Sanyog Kale <sanyog.r.kale@intel.com>, "David S.
> > >  Miller" <davem@davemloft.net>, linux-accelerators@lists.ozlabs.org
> > > Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
> > > User-Agent: Mutt/1.9.4 (2018-02-28)
> > > Message-ID: <20181119184954.GB4890@ziepe.ca>
> > > 
> > > On Mon, Nov 19, 2018 at 05:14:05PM +0800, Kenneth Lee wrote:
> > >  
> > > > If the hardware cannot share page table with the CPU, we then need to have
> > > > some way to change the device page table. This is what happen in ODP. It
> > > > invalidates the page table in device upon mmu_notifier call back. But this cannot
> > > > solve the COW problem: if the user process A share a page P with device, and A 
> > > > forks a new process B, and it continue to write to the page. By COW, the
> > > > process B will keep the page P, while A will get a new page P'. But you have
> > > > no way to let the device know it should use P' rather than P.
> > > 
> > > Is this true? I thought mmu_notifiers covered all these cases.
> > > 
> > > The mm_notifier for A should fire if B causes the physical address of
> > > A's pages to change via COW. 
> > > 
> > > And this causes the device page tables to re-synchronize.
> > 
> > I don't see such code. The current do_cow_fault() implemenation has nothing to
> > do with mm_notifer.
> 
> Well, that sure sounds like it would be a bug in mmu_notifiers..

Yes, it can be taken that way:) But it is going to be a tough bug.

> 
> But considering Jean's SVA stuff seems based on mmu notifiers, I have
> a hard time believing that it has any different behavior from RDMA's
> ODP, and if it does have different behavior, then it is probably just
> a bug in the ODP implementation.

As Jean has explained, his solution is based on page table sharing. I think ODP
should also consider this new feature.

> 
> > > > In WarpDrive/uacce, we make this simple. If you support IOMMU and it support
> > > > SVM/SVA. Everything will be fine just like ODP implicit mode. And you don't need
> > > > to write any code for that. Because it has been done by IOMMU framework. If it
> > > 
> > > Looks like the IOMMU code uses mmu_notifier, so it is identical to
> > > IB's ODP. The only difference is that IB tends to have the IOMMU page
> > > table in the device, not in the CPU.
> > > 
> > > The only case I know if that is different is the new-fangled CAPI
> > > stuff where the IOMMU can directly use the CPU's page table and the
> > > IOMMU page table (in device or CPU) is eliminated.
> >
> > Yes. We are not focusing on the current implementation. As mentioned in the
> > cover letter. We are expecting Jean Philips' SVA patch:
> > git://linux-arm.org/linux-jpb.
> 
> This SVA stuff does not look comparable to CAPI as it still requires
> maintaining seperate IOMMU page tables.
> 
> Also, those patches from Jean have a lot of references to
> mmu_notifiers (ie look at iommu_mmu_notifier).
> 
> Are you really sure it is actually any different at all?
> 
> > > Anyhow, I don't think a single instance of hardware should justify an
> > > entire new subsystem. Subsystems are hard to make and without multiple
> > > hardware examples there is no way to expect that it would cover any
> > > future use cases.
> > 
> > Yes. That's our first expectation. We can keep it with our driver. But because
> > there is no user driver support for any accelerator in mainline kernel. Even the
> > well known QuickAssit has to be maintained out of tree. So we try to see if
> > people is interested in working together to solve the problem.
> 
> Well, you should come with patches ack'ed by these other groups.

Yes, that is what we are doing.

> 
> > > If all your driver needs is to mmap some PCI bar space, route
> > > interrupts and do DMA mapping then mediated VFIO is probably a good
> > > choice. 
> > 
> > Yes. That is what is done in our RFCv1/v2. But we accepted Jerome's opinion and
> > try not to add complexity to the mm subsystem.
> 
> Why would a mediated VFIO driver touch the mm subsystem? Sounds like
> you don't have a VFIO driver if it needs to do stuff like that...

VFIO has no ODP-like solution, and if we want to solve the fork problem, we have
to make some change to iommu and the fork procedure. Further, VFIO takes every
queue as a independent device. This create a lot of trouble on resource
management. For example, you will need a manager process to withdraw the unused
device and you need to let the user process know about PASID of the queue, and
so on.

> 
> > > If it needs to do a bunch of other stuff, not related to PCI bar
> > > space, interrupts and DMA mapping (ie special code for compression,
> > > crypto, AI, whatever) then you should probably do what Jerome said and
> > > make a drivers/char/hisillicon_foo_bar.c that exposes just what your
> > > hardware does.
> > 
> > Yes. If no other accelerator driver writer is interested. That is the
> > expectation:)
> 
> I don't think it matters what other drivers do. 
> 
> If your driver does not need any other kernel code then VFIO is
> sensible. In this kind of world you will probably have a RDMA-like
> userspace driver that can bring this to a common user space API, even
> if one driver use VFIO and a different driver uses something else.

Yes, in some way. But in another way, if they don't have the same address space
logic. It won't be easy to cooperate. In VFIO, you have to use DMA address for
device while you cannot direct share RDMA-ODP memory to other device.
WarpDrive/uacce can solve all these problem.

> 
> > You create some connections (queues) to NIC, RSA, and AI engine. Then you got
> > data direct from the NIC and pass the pointer to RSA engine for decryption. The
> > CPU then finish some data taking or operation and then pass through to the AI
> > engine for CNN calculation....This will need a place to maintain the same
> > address space by some means.
> 
> How is this any different from what we have today? 
> 
> SVA is not something even remotely new, IB has been doing various
> versions of it for 20 years.

But now we can have them unified to IOMMU framework.

> 
> Jason

-- 
