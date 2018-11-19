Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42506 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728938AbeKTGvj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 01:51:39 -0500
Date: Mon, 19 Nov 2018 15:26:15 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
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
        linux-kernel@vger.kernel.org, Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-accelerators@lists.ozlabs.org
Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
Message-ID: <20181119202614.GF4593@redhat.com>
References: <20181119091910.GF157308@Turing-Arch-b>
 <20181119104801.GF8268@mtr-leonro.mtl.com>
 <20181119164853.GA4593@redhat.com>
 <20181119182752.GA4890@ziepe.ca>
 <20181119184215.GB4593@redhat.com>
 <20181119185333.GC4890@ziepe.ca>
 <20181119191721.GC4593@redhat.com>
 <20181119192702.GD4890@ziepe.ca>
 <20181119194631.GE4593@redhat.com>
 <20181119201156.GG4890@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181119201156.GG4890@ziepe.ca>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 19, 2018 at 01:11:56PM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 19, 2018 at 02:46:32PM -0500, Jerome Glisse wrote:
> 
> > > ?? How can O_DIRECT be fine but RDMA not? They use exactly the same
> > > get_user_pages flow, right? Can we do what O_DIRECT does in RDMA and
> > > be fine too?
> > > 
> > > AFAIK the only difference is the length of the race window. You'd have
> > > to fork and fault during the shorter time O_DIRECT has get_user_pages
> > > open.
> > 
> > Well in O_DIRECT case there is only one page table, the CPU
> > page table and it gets updated during fork() so there is an
> > ordering there and the race window is small.
> 
> Not really, in O_DIRECT case there is another 'page table', we just
> call it a DMA scatter/gather list and it is sent directly to the block
> device's DMA HW. The sgl plays exactly the same role as the various HW
> page list data structures that underly RDMA MRs.
> 
> It is not a page table that matters here, it is if the DMA address of
> the page is active for DMA on HW.
> 
> Like you say, the only difference is that the race is hopefully small
> with O_DIRECT (though that is not really small, NVMeof for instance
> has windows as large as connection timeouts, if you try hard enough)
> 
> So we probably can trigger this trouble with O_DIRECT and fork(), and
> I would call it a bug :(

I can not think of any scenario that would be a bug with O_DIRECT.
Do you have one in mind ? When you fork() and do other syscall that
affect the memory of your process in another thread you should
expect non consistant results. Kernel is not here to provide a fully
safe environement to user, user can shoot itself in the foot and
that's fine as long as it only affect the process itself and no one
else. We should not be in the business of making everything baby
proof :)

> 
> > > Why? Keep track in each mm if there are any active get_user_pages
> > > FOLL_WRITE pages in the mm, if yes then sweep the VMAs and fix the
> > > issue for the FOLL_WRITE pages.
> > 
> > This has a cost and you don't want to do it for O_DIRECT. I am pretty
> > sure that any such patch to modify fork() code path would be rejected.
> > At least i would not like it and vote against.
> 
> I was thinking the incremental cost on top of what John is already
> doing would be very small in the common case and only be triggered in
> cases that matter (which apps should avoid anyhow).

What John is addressing has nothing to do with fork() it has to do with
GUP and filesystem page. More specificaly that after page_mkclean() all
filesystem expect that the page content is stable (ie no one write to
the page) with GUP and hardware (DIRECT_IO too) this is not necessarily
the case.

So John is trying to fix that. Not trying to make fork() baby proof
AFAICT :)

I rather keep saying that you should expect weird thing with RDMA and
VFIO when doing fork() than trying to work around this in the kernel.

Better behavior through hardware is what we should aim for (CAPI, ODP,
...).

Jérôme
