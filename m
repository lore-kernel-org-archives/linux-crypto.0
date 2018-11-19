Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48672 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389110AbeKTDNQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Nov 2018 22:13:16 -0500
Date: Mon, 19 Nov 2018 11:48:54 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Kenneth Lee <liguozhu@hisilicon.com>,
        Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Zaibo Xu <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com,
        linuxarm@huawei.com, haojian.zhuang@linaro.org,
        Christoph Lameter <cl@linux.com>,
        Hao Fang <fanghao11@huawei.com>,
        Gavin Schenk <g.schenk@eckelmann.de>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Doug Ledford <dledford@redhat.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
        <u.kleine-koenig@pengutronix.de>,
        David Kershner <david.kershner@unisys.com>,
        Kenneth Lee <nek.in.cn@gmail.com>,
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
Message-ID: <20181119164853.GA4593@redhat.com>
References: <20181112075807.9291-1-nek.in.cn@gmail.com>
 <20181112075807.9291-2-nek.in.cn@gmail.com>
 <20181113002354.GO3695@mtr-leonro.mtl.com>
 <95310df4-b32c-42f0-c750-3ad5eb89b3dd@gmail.com>
 <20181114160017.GI3759@mtr-leonro.mtl.com>
 <20181115085109.GD157308@Turing-Arch-b>
 <20181115145455.GN3759@mtr-leonro.mtl.com>
 <20181119091405.GE157308@Turing-Arch-b>
 <20181119091910.GF157308@Turing-Arch-b>
 <20181119104801.GF8268@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181119104801.GF8268@mtr-leonro.mtl.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 19, 2018 at 12:48:01PM +0200, Leon Romanovsky wrote:
> On Mon, Nov 19, 2018 at 05:19:10PM +0800, Kenneth Lee wrote:
> > On Mon, Nov 19, 2018 at 05:14:05PM +0800, Kenneth Lee wrote:
> > > On Thu, Nov 15, 2018 at 04:54:55PM +0200, Leon Romanovsky wrote:
> > > > On Thu, Nov 15, 2018 at 04:51:09PM +0800, Kenneth Lee wrote:
> > > > > On Wed, Nov 14, 2018 at 06:00:17PM +0200, Leon Romanovsky wrote:
> > > > > > On Wed, Nov 14, 2018 at 10:58:09AM +0800, Kenneth Lee wrote:
> > > > > > > > On Mon, Nov 12, 2018 at 03:58:02PM +0800, Kenneth Lee wrote:

[...]

> > > > memory exposed to user is properly protected from security point of view.
> > > > 3. "stop using the page for a while for the copying" - I'm not fully
> > > > understand this claim, maybe this article will help you to better
> > > > describe : https://lwn.net/Articles/753027/
> > >
> > > This topic was being discussed in RFCv2. The key problem here is that:
> > >
> > > The device need to hold the memory for its own calculation, but the CPU/software
> > > want to stop it for a while for synchronizing with disk or COW.
> > >
> > > If the hardware support SVM/SVA (Shared Virtual Memory/Address), it is easy, the
> > > device share page table with CPU, the device will raise a page fault when the
> > > CPU downgrade the PTE to read-only.
> > >
> > > If the hardware cannot share page table with the CPU, we then need to have
> > > some way to change the device page table. This is what happen in ODP. It
> > > invalidates the page table in device upon mmu_notifier call back. But this cannot
> > > solve the COW problem: if the user process A share a page P with device, and A
> > > forks a new process B, and it continue to write to the page. By COW, the
> > > process B will keep the page P, while A will get a new page P'. But you have
> > > no way to let the device know it should use P' rather than P.
> 
> I didn't hear about such issue and we supported fork for a long time.
> 

Just to comment on this, any infiniband driver which use umem and do
not have ODP (here ODP for me means listening to mmu notifier so all
infiniband driver except mlx5) will be affected by same issue AFAICT.

AFAICT there is no special thing happening after fork() inside any of
those driver. So if parent create a umem mr before fork() and program
hardware with it then after fork() the parent might start using new
page for the umem range while the old memory is use by the child. The
reverse is also true (parent using old memory and child new memory)
bottom line you can not predict which memory the child or the parent
will use for the range after fork().

So no matter what you consider the child or the parent, what the hw
will use for the mr is unlikely to match what the CPU use for the
same virtual address. In other word:

Before fork:
    CPU parent: virtual addr ptr1 -> physical address = 0xCAFE
    HARDWARE:   virtual addr ptr1 -> physical address = 0xCAFE

Case 1:
    CPU parent: virtual addr ptr1 -> physical address = 0xCAFE
    CPU child:  virtual addr ptr1 -> physical address = 0xDEAD
    HARDWARE:   virtual addr ptr1 -> physical address = 0xCAFE

Case 2:
    CPU parent: virtual addr ptr1 -> physical address = 0xBEEF
    CPU child:  virtual addr ptr1 -> physical address = 0xCAFE
    HARDWARE:   virtual addr ptr1 -> physical address = 0xCAFE


This apply for every single page and is not predictable. This only
apply to private memory (mmap() with MAP_PRIVATE)

I am not familiar enough with RDMA user space API contract to know
if this is an issue or not.

Note that this can not be fix, no one should have done umem without
ODP like mlx5. For this to work properly you need sane hardware like
mlx5.

Cheers,
Jérôme
