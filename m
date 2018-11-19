Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729611AbeKTGLr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 01:11:47 -0500
Date: Mon, 19 Nov 2018 14:46:32 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>,
        Kenneth Lee <liguozhu@hisilicon.com>,
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
Message-ID: <20181119194631.GE4593@redhat.com>
References: <20181115145455.GN3759@mtr-leonro.mtl.com>
 <20181119091405.GE157308@Turing-Arch-b>
 <20181119091910.GF157308@Turing-Arch-b>
 <20181119104801.GF8268@mtr-leonro.mtl.com>
 <20181119164853.GA4593@redhat.com>
 <20181119182752.GA4890@ziepe.ca>
 <20181119184215.GB4593@redhat.com>
 <20181119185333.GC4890@ziepe.ca>
 <20181119191721.GC4593@redhat.com>
 <20181119192702.GD4890@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181119192702.GD4890@ziepe.ca>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 19, 2018 at 12:27:02PM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 19, 2018 at 02:17:21PM -0500, Jerome Glisse wrote:
> > On Mon, Nov 19, 2018 at 11:53:33AM -0700, Jason Gunthorpe wrote:
> > > On Mon, Nov 19, 2018 at 01:42:16PM -0500, Jerome Glisse wrote:
> > > > On Mon, Nov 19, 2018 at 11:27:52AM -0700, Jason Gunthorpe wrote:
> > > > > On Mon, Nov 19, 2018 at 11:48:54AM -0500, Jerome Glisse wrote:
> > > > > 
> > > > > > Just to comment on this, any infiniband driver which use umem and do
> > > > > > not have ODP (here ODP for me means listening to mmu notifier so all
> > > > > > infiniband driver except mlx5) will be affected by same issue AFAICT.
> > > > > > 
> > > > > > AFAICT there is no special thing happening after fork() inside any of
> > > > > > those driver. So if parent create a umem mr before fork() and program
> > > > > > hardware with it then after fork() the parent might start using new
> > > > > > page for the umem range while the old memory is use by the child. The
> > > > > > reverse is also true (parent using old memory and child new memory)
> > > > > > bottom line you can not predict which memory the child or the parent
> > > > > > will use for the range after fork().
> > > > > > 
> > > > > > So no matter what you consider the child or the parent, what the hw
> > > > > > will use for the mr is unlikely to match what the CPU use for the
> > > > > > same virtual address. In other word:
> > > > > > 
> > > > > > Before fork:
> > > > > >     CPU parent: virtual addr ptr1 -> physical address = 0xCAFE
> > > > > >     HARDWARE:   virtual addr ptr1 -> physical address = 0xCAFE
> > > > > > 
> > > > > > Case 1:
> > > > > >     CPU parent: virtual addr ptr1 -> physical address = 0xCAFE
> > > > > >     CPU child:  virtual addr ptr1 -> physical address = 0xDEAD
> > > > > >     HARDWARE:   virtual addr ptr1 -> physical address = 0xCAFE
> > > > > > 
> > > > > > Case 2:
> > > > > >     CPU parent: virtual addr ptr1 -> physical address = 0xBEEF
> > > > > >     CPU child:  virtual addr ptr1 -> physical address = 0xCAFE
> > > > > >     HARDWARE:   virtual addr ptr1 -> physical address = 0xCAFE
> > > > > 
> > > > > IIRC this is solved in IB by automatically calling
> > > > > madvise(MADV_DONTFORK) before creating the MR.
> > > > > 
> > > > > MADV_DONTFORK
> > > > >   .. This is useful to prevent copy-on-write semantics from changing the
> > > > >   physical location of a page if the parent writes to it after a
> > > > >   fork(2) ..
> > > > 
> > > > This would work around the issue but this is not transparent ie
> > > > range marked with DONTFORK no longer behave as expected from the
> > > > application point of view.
> > > 
> > > Do you know what the difference is? The man page really gives no
> > > hint..
> > > 
> > > Does it sometimes unmap the pages during fork?
> > 
> > It is handled in kernel/fork.c look for DONTCOPY, basicaly it just
> > leave empty page table in the child process so child will have to
> > fault in new page. This also means that child will get 0 as initial
> > value for all memory address under DONTCOPY/DONTFORK which breaks
> > application expectation of what fork() do.
> 
> Hum, I wonder why this API was selected then..

Because there is nothing else ? :)

> 
> > > I actually wonder if the kernel is a bit broken here, we have the same
> > > problem with O_DIRECT and other stuff, right?
> > 
> > No it is not, O_DIRECT is fine. The only corner case i can think
> > of with O_DIRECT is one thread launching an O_DIRECT that write
> > to private anonymous memory (other O_DIRECT case do not matter)
> > while another thread call fork() then what the child get can be
> > undefined ie either it get the data before the O_DIRECT finish
> > or it gets the result of the O_DIRECT. But this is realy what
> > you should expect when doing such thing without synchronization.
> > 
> > So O_DIRECT is fine.
> 
> ?? How can O_DIRECT be fine but RDMA not? They use exactly the same
> get_user_pages flow, right? Can we do what O_DIRECT does in RDMA and
> be fine too?
> 
> AFAIK the only difference is the length of the race window. You'd have
> to fork and fault during the shorter time O_DIRECT has get_user_pages
> open.

Well in O_DIRECT case there is only one page table, the CPU
page table and it gets updated during fork() so there is an
ordering there and the race window is small.

More over programmer knows that can get in trouble if they
do thing like fork() and don't synchronize their threads
with each other. So while some weird thing can happen with
O_DIRECT, it is unlikely (very small race window) and if
it happens its well within the expected behavior.

For hardware the race window is the same as the process
lifetime so it can be days, months, years ... Once the
hardware has programmed its page table they will never
see any update (again mlx5 ODP is the exception here).

This is where "issues" weird behavior can arise. Because
you use DONTFORK than you never see weird thing happening.
If you were to comment out DONTFORK then RDMA in the parent
might change data in the child (or the other way around ie
RDMA in the child might change data in the parent).


> > > Really, if I have a get_user_pages FOLL_WRITE on a page and we fork,
> > > then shouldn't the COW immediately be broken during the fork?
> > > 
> > > The kernel can't guarentee that an ongoing DMA will not write to those
> > > pages, and it breaks the fork semantic to write to both processes.
> > 
> > Fixing that would incur a high cost: need to grow struct page, need
> > to copy potentialy gigabyte of memory during fork() ... this would be
> > a serious performance regression for many folks just to work around an
> > abuse of device driver. So i don't think anything on that front would
> > be welcome.
> 
> Why? Keep track in each mm if there are any active get_user_pages
> FOLL_WRITE pages in the mm, if yes then sweep the VMAs and fix the
> issue for the FOLL_WRITE pages.

This has a cost and you don't want to do it for O_DIRECT. I am pretty
sure that any such patch to modify fork() code path would be rejected.
At least i would not like it and vote against.

> 
> John is already working on being able to detect pages under GUP, so it
> seems like a small step..

John is trying to fix serious bugs which can result in filesystem
corruption. It has a performance cost and thus i don't see that as
something we should pursue as a default solution. I posted patches
to remove get_user_page() from GPU driver and i intend to remove
as many GUP as i can (for hardware that can do the right thing).

To me it sounds better to reward good hardware rather than punish
everyone :)

> 
> Since nearly all cases of fork don't have a GUP FOLL_WRITE active
> there would be no performance hit.
> 
> > umem without proper ODP and VFIO are the only bad user i know of (for
> > VFIO you can argue that it is part of the API contract and thus that
> > it is not an abuse but it is not spell out loud in documentation). I
> > have been trying to push back on any people trying to push thing that
> > would make the same mistake or at least making sure they understand
> > what is happening.
> 
> It is something we have to live with and support for the foreseeable
> future.

Yes for RDMA and VFIO, but i want to avoid any more new users hence
why i push back on any solution that have the same issues.

> 
> > What really need to happen is people fixing their hardware and do the
> > right thing (good software engineer versus evil hardware engineer ;))
> 
> Even ODP is no pancea, there are performance problems. What we really
> need is CAPI like stuff, so you will tell Intel to redesign the CPU??
> :)

I agree

Jérôme
