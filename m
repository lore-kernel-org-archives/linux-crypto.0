Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45600 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731054AbeKTIGt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 03:06:49 -0500
Received: by mail-pf1-f194.google.com with SMTP id g62so12208904pfd.12
        for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2018 13:41:13 -0800 (PST)
Date: Mon, 19 Nov 2018 14:41:10 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jerome Glisse <jglisse@redhat.com>
Cc: Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Zaibo Xu <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com,
        linuxarm@huawei.com, haojian.zhuang@linaro.org,
        Christoph Lameter <cl@linux.com>,
        Hao Fang <fanghao11@huawei.com>,
        Gavin Schenk <g.schenk@eckelmann.de>,
        Leon Romanovsky <leon@kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?=
        <u.kleine-koenig@pengutronix.de>,
        David Kershner <david.kershner@unisys.com>,
        Kenneth Lee <nek.in.cn@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Cyrille Pitchen <cyrille.pitchen@free-electrons.com>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Jens Axboe <axboe@kernel.dk>, guodong.xu@linaro.org,
        linux-netdev <netdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-accelerators@lists.ozlabs.org
Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
Message-ID: <20181119214110.GJ4890@ziepe.ca>
References: <20181119182752.GA4890@ziepe.ca>
 <20181119184215.GB4593@redhat.com>
 <20181119185333.GC4890@ziepe.ca>
 <20181119191721.GC4593@redhat.com>
 <20181119192702.GD4890@ziepe.ca>
 <20181119194631.GE4593@redhat.com>
 <20181119201156.GG4890@ziepe.ca>
 <20181119202614.GF4593@redhat.com>
 <20181119212638.GI4890@ziepe.ca>
 <20181119213320.GG4593@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119213320.GG4593@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 19, 2018 at 04:33:20PM -0500, Jerome Glisse wrote:
> On Mon, Nov 19, 2018 at 02:26:38PM -0700, Jason Gunthorpe wrote:
> > On Mon, Nov 19, 2018 at 03:26:15PM -0500, Jerome Glisse wrote:
> > > On Mon, Nov 19, 2018 at 01:11:56PM -0700, Jason Gunthorpe wrote:
> > > > On Mon, Nov 19, 2018 at 02:46:32PM -0500, Jerome Glisse wrote:
> > > > 
> > > > > > ?? How can O_DIRECT be fine but RDMA not? They use exactly the same
> > > > > > get_user_pages flow, right? Can we do what O_DIRECT does in RDMA and
> > > > > > be fine too?
> > > > > > 
> > > > > > AFAIK the only difference is the length of the race window. You'd have
> > > > > > to fork and fault during the shorter time O_DIRECT has get_user_pages
> > > > > > open.
> > > > > 
> > > > > Well in O_DIRECT case there is only one page table, the CPU
> > > > > page table and it gets updated during fork() so there is an
> > > > > ordering there and the race window is small.
> > > > 
> > > > Not really, in O_DIRECT case there is another 'page table', we just
> > > > call it a DMA scatter/gather list and it is sent directly to the block
> > > > device's DMA HW. The sgl plays exactly the same role as the various HW
> > > > page list data structures that underly RDMA MRs.
> > > > 
> > > > It is not a page table that matters here, it is if the DMA address of
> > > > the page is active for DMA on HW.
> > > > 
> > > > Like you say, the only difference is that the race is hopefully small
> > > > with O_DIRECT (though that is not really small, NVMeof for instance
> > > > has windows as large as connection timeouts, if you try hard enough)
> > > > 
> > > > So we probably can trigger this trouble with O_DIRECT and fork(), and
> > > > I would call it a bug :(
> > > 
> > > I can not think of any scenario that would be a bug with O_DIRECT.
> > > Do you have one in mind ? When you fork() and do other syscall that
> > > affect the memory of your process in another thread you should
> > > expect non consistant results. Kernel is not here to provide a fully
> > > safe environement to user, user can shoot itself in the foot and
> > > that's fine as long as it only affect the process itself and no one
> > > else. We should not be in the business of making everything baby
> > > proof :)
> > 
> > Sure, I setup AIO with O_DIRECT and launch a read.
> > 
> > Then I fork and dirty the READ target memory using the CPU in the
> > child.
> > 
> > As you described in this case the fork will retain the physical page
> > that is undergoing O_DIRECT DMA, and the parent gets a new copy'd page.
> > 
> > The DMA completes, and the child gets the DMA'd to page. The parent
> > gets an unchanged copy'd page.
> > 
> > The parent gets the AIO completion, but can't see the data.
> > 
> > I'd call that a bug with O_DIRECT. The only correct outcome is that
> > the parent will always see the O_DIRECT data. Fork should not cause
> > the *parent* to malfunction. I agree the child cannot make any
> > prediction what memory it will see.
> > 
> > I assume the same flow is possible using threads and read()..
> > 
> > It is really no different than the RDMA bug with fork.
> > 
> 
> Yes and that's expected behavior :) If you fork() and have anything
> still in flight at time of fork that can change your process address
> space (including data in it) then all bets are of.
> 
> At least this is my reading of fork() syscall.

Not mine.. I can't think of anything else that would have this
behavior.

All traditional syscalls, will properly dirty the pages of the
parent. ie if I call read() in a thread and do fork in another thread,
then not seeing the data after read() completes is clearly a bug. All
other syscalls are the same.

It is bonkers that opening the file with O_DIRECT would change this
basic behavior. I'm calling it a bug :)

Jason
