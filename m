Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbeKSVLX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Nov 2018 16:11:23 -0500
Date: Mon, 19 Nov 2018 12:48:01 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Kenneth Lee <liguozhu@hisilicon.com>
Cc: Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Zaibo Xu <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com,
        linuxarm@huawei.com, haojian.zhuang@linaro.org,
        Christoph Lameter <cl@linux.com>,
        Hao Fang <fanghao11@huawei.com>,
        Gavin Schenk <g.schenk@eckelmann.de>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
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
        "David S. Miller" <davem@davemloft.net>,
        linux-accelerators@lists.ozlabs.org,
        Jerome Glisse <jglisse@redhat.com>
Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
Message-ID: <20181119104801.GF8268@mtr-leonro.mtl.com>
References: <20181112075807.9291-1-nek.in.cn@gmail.com>
 <20181112075807.9291-2-nek.in.cn@gmail.com>
 <20181113002354.GO3695@mtr-leonro.mtl.com>
 <95310df4-b32c-42f0-c750-3ad5eb89b3dd@gmail.com>
 <20181114160017.GI3759@mtr-leonro.mtl.com>
 <20181115085109.GD157308@Turing-Arch-b>
 <20181115145455.GN3759@mtr-leonro.mtl.com>
 <20181119091405.GE157308@Turing-Arch-b>
 <20181119091910.GF157308@Turing-Arch-b>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <20181119091910.GF157308@Turing-Arch-b>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 19, 2018 at 05:19:10PM +0800, Kenneth Lee wrote:
> On Mon, Nov 19, 2018 at 05:14:05PM +0800, Kenneth Lee wrote:
> > Date: Mon, 19 Nov 2018 17:14:05 +0800
> > From: Kenneth Lee <liguozhu@hisilicon.com>
> > To: Leon Romanovsky <leon@kernel.org>
> > CC: Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org,
> >  Alexander Shishkin <alexander.shishkin@linux.intel.com>, Zaibo Xu
> >  <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com, linuxarm@huawei.com,
> >  haojian.zhuang@linaro.org, Christoph Lameter <cl@linux.com>, Hao Fang
> >  <fanghao11@huawei.com>, Gavin Schenk <g.schenk@eckelmann.de>, RDMA mai=
ling
> >  list <linux-rdma@vger.kernel.org>, Vinod Koul <vkoul@kernel.org>, Jason
> >  Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Uwe
> >  Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>, David Kershner
> >  <david.kershner@unisys.com>, Kenneth Lee <nek.in.cn@gmail.com>, Johan
> >  Hovold <johan@kernel.org>, Cyrille Pitchen
> >  <cyrille.pitchen@free-electrons.com>, Sagar Dharia
> >  <sdharia@codeaurora.org>, Jens Axboe <axboe@kernel.dk>,
> >  guodong.xu@linaro.org, linux-netdev <netdev@vger.kernel.org>, Randy Du=
nlap
> >  <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Zhou Wang
> >  <wangzhou1@hisilicon.com>, linux-crypto@vger.kernel.org, Philippe
> >  Ombredanne <pombredanne@nexb.com>, Sanyog Kale <sanyog.r.kale@intel.co=
m>,
> >  "David S. Miller" <davem@davemloft.net>,
> >  linux-accelerators@lists.ozlabs.org
> > Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
> > User-Agent: Mutt/1.5.21 (2010-09-15)
> > Message-ID: <20181119091405.GE157308@Turing-Arch-b>
> >
> > On Thu, Nov 15, 2018 at 04:54:55PM +0200, Leon Romanovsky wrote:
> > > Date: Thu, 15 Nov 2018 16:54:55 +0200
> > > From: Leon Romanovsky <leon@kernel.org>
> > > To: Kenneth Lee <liguozhu@hisilicon.com>
> > > CC: Kenneth Lee <nek.in.cn@gmail.com>, Tim Sell <timothy.sell@unisys.=
com>,
> > >  linux-doc@vger.kernel.org, Alexander Shishkin
> > >  <alexander.shishkin@linux.intel.com>, Zaibo Xu <xuzaibo@huawei.com>,
> > >  zhangfei.gao@foxmail.com, linuxarm@huawei.com, haojian.zhuang@linaro=
=2Eorg,
> > >  Christoph Lameter <cl@linux.com>, Hao Fang <fanghao11@huawei.com>, G=
avin
> > >  Schenk <g.schenk@eckelmann.de>, RDMA mailing list
> > >  <linux-rdma@vger.kernel.org>, Zhou Wang <wangzhou1@hisilicon.com>, J=
ason
> > >  Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Uwe
> > >  Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>, David Kershner
> > >  <david.kershner@unisys.com>, Johan Hovold <johan@kernel.org>, Cyrille
> > >  Pitchen <cyrille.pitchen@free-electrons.com>, Sagar Dharia
> > >  <sdharia@codeaurora.org>, Jens Axboe <axboe@kernel.dk>,
> > >  guodong.xu@linaro.org, linux-netdev <netdev@vger.kernel.org>, Randy =
Dunlap
> > >  <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Vinod Koul
> > >  <vkoul@kernel.org>, linux-crypto@vger.kernel.org, Philippe Ombredanne
> > >  <pombredanne@nexb.com>, Sanyog Kale <sanyog.r.kale@intel.com>, "Davi=
d S.
> > >  Miller" <davem@davemloft.net>, linux-accelerators@lists.ozlabs.org
> > > Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uac=
ce
> > > User-Agent: Mutt/1.10.1 (2018-07-13)
> > > Message-ID: <20181115145455.GN3759@mtr-leonro.mtl.com>
> > >
> > > On Thu, Nov 15, 2018 at 04:51:09PM +0800, Kenneth Lee wrote:
> > > > On Wed, Nov 14, 2018 at 06:00:17PM +0200, Leon Romanovsky wrote:
> > > > > Date: Wed, 14 Nov 2018 18:00:17 +0200
> > > > > From: Leon Romanovsky <leon@kernel.org>
> > > > > To: Kenneth Lee <nek.in.cn@gmail.com>
> > > > > CC: Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org,
> > > > >  Alexander Shishkin <alexander.shishkin@linux.intel.com>, Zaibo Xu
> > > > >  <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com, linuxarm@huawei.=
com,
> > > > >  haojian.zhuang@linaro.org, Christoph Lameter <cl@linux.com>, Hao=
 Fang
> > > > >  <fanghao11@huawei.com>, Gavin Schenk <g.schenk@eckelmann.de>, RD=
MA mailing
> > > > >  list <linux-rdma@vger.kernel.org>, Zhou Wang <wangzhou1@hisilico=
n.com>,
> > > > >  Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.co=
m>, Uwe
> > > > >  Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>, David Kershn=
er
> > > > >  <david.kershner@unisys.com>, Johan Hovold <johan@kernel.org>, Cy=
rille
> > > > >  Pitchen <cyrille.pitchen@free-electrons.com>, Sagar Dharia
> > > > >  <sdharia@codeaurora.org>, Jens Axboe <axboe@kernel.dk>,
> > > > >  guodong.xu@linaro.org, linux-netdev <netdev@vger.kernel.org>, Ra=
ndy Dunlap
> > > > >  <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Vinod Koul
> > > > >  <vkoul@kernel.org>, linux-crypto@vger.kernel.org, Philippe Ombre=
danne
> > > > >  <pombredanne@nexb.com>, Sanyog Kale <sanyog.r.kale@intel.com>, K=
enneth Lee
> > > > >  <liguozhu@hisilicon.com>, "David S. Miller" <davem@davemloft.net=
>,
> > > > >  linux-accelerators@lists.ozlabs.org
> > > > > Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive=
/uacce
> > > > > User-Agent: Mutt/1.10.1 (2018-07-13)
> > > > > Message-ID: <20181114160017.GI3759@mtr-leonro.mtl.com>
> > > > >
> > > > > On Wed, Nov 14, 2018 at 10:58:09AM +0800, Kenneth Lee wrote:
> > > > > >
> > > > > > =E5=9C=A8 2018/11/13 =E4=B8=8A=E5=8D=888:23, Leon Romanovsky =
=E5=86=99=E9=81=93:
> > > > > > > On Mon, Nov 12, 2018 at 03:58:02PM +0800, Kenneth Lee wrote:
> > > > > > > > From: Kenneth Lee <liguozhu@hisilicon.com>
> > > > > > > >
> > > > > > > > WarpDrive is a general accelerator framework for the user a=
pplication to
> > > > > > > > access the hardware without going through the kernel in dat=
a path.
> > > > > > > >
> > > > > > > > The kernel component to provide kernel facility to driver f=
or expose the
> > > > > > > > user interface is called uacce. It a short name for
> > > > > > > > "Unified/User-space-access-intended Accelerator Framework".
> > > > > > > >
> > > > > > > > This patch add document to explain how it works.
> > > > > > > + RDMA and netdev folks
> > > > > > >
> > > > > > > Sorry, to be late in the game, I don't see other patches, but=
 from
> > > > > > > the description below it seems like you are reinventing RDMA =
verbs
> > > > > > > model. I have hard time to see the differences in the proposed
> > > > > > > framework to already implemented in drivers/infiniband/* for =
the kernel
> > > > > > > space and for the https://github.com/linux-rdma/rdma-core/ fo=
r the user
> > > > > > > space parts.
> > > > > >
> > > > > > Thanks Leon,
> > > > > >
> > > > > > Yes, we tried to solve similar problem in RDMA. We also learned=
 a lot from
> > > > > > the exist code of RDMA. But we we have to make a new one becaus=
e we cannot
> > > > > > register accelerators such as AI operation, encryption or compr=
ession to the
> > > > > > RDMA framework:)
> > > > >
> > > > > Assuming that you did everything right and still failed to use RD=
MA
> > > > > framework, you was supposed to fix it and not to reinvent new exa=
ctly
> > > > > same one. It is how we develop kernel, by reusing existing code.
> > > >
> > > > Yes, but we don't force other system such as NIC or GPU into RDMA, =
do we?
> > >
> > > You don't introduce new NIC or GPU, but proposing another interface to
> > > directly access HW memory and bypass kernel for the data path. This is
> > > whole idea of RDMA and this is why it is already present in the kerne=
l.
> > >
> > > Various hardware devices are supported in our stack allow a ton of cr=
azy
> > > stuff, including GPUs interconnections and NIC functionalities.
> >
> > Yes. We don't want to invent new wheel. That is why we did it behind VF=
IO in RFC
> > v1 and v2. But finally we were persuaded by Mr. Jerome Glisse that VFIO=
 was not
> > a good place to solve the problem.

I saw a couple of his responses, he constantly said to you that you are
reinventing the wheel.
https://lore.kernel.org/lkml/20180904150019.GA4024@redhat.com/

> >
> > And currently, as you see, IB is bound with devices doing RDMA. The reg=
ister
> > function, ib_register_device() hint that it is a netdev (get_netdev() c=
allback), it know
> > about gid, pkey, and Memory Window. IB is not simply a address space ma=
nagement
> > framework. And verbs to IB are not transparent. If we start to add
> > compression/decompression, AI (RNN, CNN stuff) operations, and encrypti=
on/decryption
> > to the verbs set. It will become very complexity. Or maybe I misunderst=
and the
> > IB idea? But I don't see compression hardware is integrated in the main=
line
> > Kernel. Could you directly point out which one I can used as a referenc=
e?
> >

I strongly advise you to read the code, not all drivers are implementing
gids, pkeys and get_netdev() callback.

Yes, you are misunderstanding drivers/infiniband subsystem. We have
plenty options to expose APIs to the user space applications, starting
=66rom standard verbs API and ending with private objects which are
understandable by specific device/driver.

IB stack provides secure FD to access device, by creating context,
after that you can send direct commands to the FW (see mlx5 DEVX
or hfi1) in sane way.

So actually, you will need to register your device, declare your own
set of objects (similar to mlx5 include/uapi/rdma/mlx5_user_ioctl_*.h).

In regards to reference of compression hardware, I don't have.
But there is an example of how T10-DIF can be implemented in verbs
layer:
https://www.openfabrics.org/images/2018workshop/presentations/307_TOved_T10=
-DIFOffload.pdf
Or IPsec crypto:
https://www.spinics.net/lists/linux-rdma/msg48906.html

> > >
> > > >
> > > > I assume you would not agree to register a zip accelerator to infin=
iband? :)
> > >
> > > "infiniband" name in the "drivers/infiniband/" is legacy one and the
> > > current code supports IB, RoCE, iWARP and OmniPath as a transport lay=
ers.
> > > For a lone time, we wanted to rename that folder to be "drivers/rdma",
> > > but didn't find enough brave men/women to do it, due to backport mess
> > > for such move.
> > >
> > > The addition of zip accelerator to RDMA is possible and depends on how
> > > you will model such new functionality - new driver, or maybe new ULP.
> > >
> > > >
> > > > Further, I don't think it is wise to break an exist system (RDMA) t=
o fulfill a
> > > > totally new scenario. The better choice is to let them run in paral=
lel for some
> > > > time and try to merge them accordingly.
> > >
> > > Awesome, so please run your code out-of-tree for now and once you are=
 ready
> > > for submission let's try to merge it.
> >
> > Yes, yes. We know trust need time to gain. But the fact is that there i=
s no
> > accelerator user driver can be added to mainline kernel. We should rais=
e the
> > topic time to time. So to help the communication to fix the gap, right?
> >
> > We are also opened to cooperate with IB to do it within the IB framewor=
k. But
> > please let me know where to start. I feel it is quite wired to make a
> > ib_register_device for a zip or RSA accelerator.

Most of ib_ prefixes in drivers/infinband/ are legacy names. You can
rename them to be rdma_register_device() if it helps.

So from implementation point of view, as I wrote above.
Create minimal driver to register, expose MR to user space, add your own
objects and capabilities through our new KABI and implement user space part
in github.com/linux-rdma/rdma-core.

> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > Another problem we tried to address is the way to pin the memor=
y for dma
> > > > > > operation. The RDMA way to pin the memory cannot avoid the page=
 lost due to
> > > > > > copy-on-write operation during the memory is used by the device=
=2E This may
> > > > > > not be important to RDMA library. But it is important to accele=
rator.
> > > > >
> > > > > Such support exists in drivers/infiniband/ from late 2014 and
> > > > > it is called ODP (on demand paging).
> > > >
> > > > I reviewed ODP and I think it is a solution bound to infiniband. It=
 is part of
> > > > MR semantics and required a infiniband specific hook
> > > > (ucontext->invalidate_range()). And the hook requires the device to=
 be able to
> > > > stop using the page for a while for the copying. It is ok for infin=
iband
> > > > (actually, only mlx5 uses it). I don't think most accelerators can =
support
> > > > this mode. But WarpDrive works fully on top of IOMMU interface, it =
has no this
> > > > limitation.
> > >
> > > 1. It has nothing to do with infiniband.
> >
> > But it must be a ib_dev first.

It is just a name.

> >
> > > 2. MR and uncontext are verbs semantics and needed to ensure that host
> > > memory exposed to user is properly protected from security point of v=
iew.
> > > 3. "stop using the page for a while for the copying" - I'm not fully
> > > understand this claim, maybe this article will help you to better
> > > describe : https://lwn.net/Articles/753027/
> >
> > This topic was being discussed in RFCv2. The key problem here is that:
> >
> > The device need to hold the memory for its own calculation, but the CPU=
/software
> > want to stop it for a while for synchronizing with disk or COW.
> >
> > If the hardware support SVM/SVA (Shared Virtual Memory/Address), it is =
easy, the
> > device share page table with CPU, the device will raise a page fault wh=
en the
> > CPU downgrade the PTE to read-only.
> >
> > If the hardware cannot share page table with the CPU, we then need to h=
ave
> > some way to change the device page table. This is what happen in ODP. It
> > invalidates the page table in device upon mmu_notifier call back. But t=
his cannot
> > solve the COW problem: if the user process A share a page P with device=
, and A
> > forks a new process B, and it continue to write to the page. By COW, the
> > process B will keep the page P, while A will get a new page P'. But you=
 have
> > no way to let the device know it should use P' rather than P.

I didn't hear about such issue and we supported fork for a long time.

> >
> > This may be OK for RDMA application. Because RDMA is a big thing and we=
 can ask
> > the programmer to avoid the situation. But for a accelerator, I don't t=
hink we
> > can ask a programmer to care for this when use a zlib.
> >
> > In WarpDrive/uacce, we make this simple. If you support IOMMU and it su=
pport
> > SVM/SVA. Everything will be fine just like ODP implicit mode. And you d=
on't need
> > to write any code for that. Because it has been done by IOMMU framework=
=2E If it
> > dose not, you have to use the kernel allocated memory which has the sam=
e IOVA as
> > the VA in user space. So we can still maintain a unify address space am=
ong the
> > devices and the applicatin.
> >
> > > 4. mlx5 supports ODP not because of being partially IB device,
> > > but because HW performance oriented implementation is not an easy tas=
k.
> > >
> > > >
> > > > >
> > > > > >
> > > > > > Hope this can help the understanding.
> > > > >
> > > > > Yes, it helped me a lot.
> > > > > Now, I'm more than before convinced that this whole patchset shou=
ldn't
> > > > > exist in the first place.
> > > >
> > > > Then maybe you can tell me how I can register my accelerator to the=
 user space?
> > >
> > > Write kernel driver and write user space part of it.
> > > https://github.com/linux-rdma/rdma-core/
> > >
> > > I have no doubts that your colleagues who wrote and maintain
> > > drivers/infiniband/hw/hns driver know best how to do it.
> > > They did it very successfully.
> > >
> > > Thanks
> > >
> > > >
> > > > >
> > > > > To be clear, NAK.
> > > > >
> > > > > Thanks
> > > > >
> > > > > >
> > > > > > Cheers
> > > > > >
> > > > > > >
> > > > > > > Hard NAK from RDMA side.
> > > > > > >
> > > > > > > Thanks
> > > > > > >
> > > > > > > > Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
> > > > > > > > ---
> > > > > > > >   Documentation/warpdrive/warpdrive.rst       | 260 +++++++
> > > > > > > >   Documentation/warpdrive/wd-arch.svg         | 764 +++++++=
+++++++++++++
> > > > > > > >   Documentation/warpdrive/wd.svg              | 526 +++++++=
+++++++
> > > > > > > >   Documentation/warpdrive/wd_q_addr_space.svg | 359 +++++++=
++
> > > > > > > >   4 files changed, 1909 insertions(+)
> > > > > > > >   create mode 100644 Documentation/warpdrive/warpdrive.rst
> > > > > > > >   create mode 100644 Documentation/warpdrive/wd-arch.svg
> > > > > > > >   create mode 100644 Documentation/warpdrive/wd.svg
> > > > > > > >   create mode 100644 Documentation/warpdrive/wd_q_addr_spac=
e.svg
> > > > > > > >
> > > > > > > > diff --git a/Documentation/warpdrive/warpdrive.rst b/Docume=
ntation/warpdrive/warpdrive.rst
> > > > > > > > new file mode 100644
> > > > > > > > index 000000000000..ef84d3a2d462
> > > > > > > > --- /dev/null
> > > > > > > > +++ b/Documentation/warpdrive/warpdrive.rst
> > > > > > > > @@ -0,0 +1,260 @@
> > > > > > > > +Introduction of WarpDrive
> > > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > > > > > > > +
> > > > > > > > +*WarpDrive* is a general accelerator framework for the use=
r application to
> > > > > > > > +access the hardware without going through the kernel in da=
ta path.
> > > > > > > > +
> > > > > > > > +It can be used as the quick channel for accelerators, netw=
ork adaptors or
> > > > > > > > +other hardware for application in user space.
> > > > > > > > +
> > > > > > > > +This may make some implementation simpler.  E.g.  you can =
reuse most of the
> > > > > > > > +*netdev* driver in kernel and just share some ring buffer =
to the user space
> > > > > > > > +driver for *DPDK* [4] or *ODP* [5]. Or you can combine the=
 RSA accelerator with
> > > > > > > > +the *netdev* in the user space as a https reversed proxy, =
etc.
> > > > > > > > +
> > > > > > > > +*WarpDrive* takes the hardware accelerator as a heterogene=
ous processor which
> > > > > > > > +can share particular load from the CPU:
> > > > > > > > +
> > > > > > > > +.. image:: wd.svg
> > > > > > > > +        :alt: WarpDrive Concept
> > > > > > > > +
> > > > > > > > +The virtual concept, queue, is used to manage the requests=
 sent to the
> > > > > > > > +accelerator. The application send requests to the queue by=
 writing to some
> > > > > > > > +particular address, while the hardware takes the requests =
directly from the
> > > > > > > > +address and send feedback accordingly.
> > > > > > > > +
> > > > > > > > +The format of the queue may differ from hardware to hardwa=
re. But the
> > > > > > > > +application need not to make any system call for the commu=
nication.
> > > > > > > > +
> > > > > > > > +*WarpDrive* tries to create a shared virtual address space=
 for all involved
> > > > > > > > +accelerators. Within this space, the requests sent to queu=
e can refer to any
> > > > > > > > +virtual address, which will be valid to the application an=
d all involved
> > > > > > > > +accelerators.
> > > > > > > > +
> > > > > > > > +The name *WarpDrive* is simply a cool and general name mea=
ning the framework
> > > > > > > > +makes the application faster. It includes general user lib=
rary, kernel
> > > > > > > > +management module and drivers for the hardware. In kernel,=
 the management
> > > > > > > > +module is called *uacce*, meaning "Unified/User-space-acce=
ss-intended
> > > > > > > > +Accelerator Framework".
> > > > > > > > +
> > > > > > > > +
> > > > > > > > +How does it work
> > > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > > +
> > > > > > > > +*WarpDrive* uses *mmap* and *IOMMU* to play the trick.
> > > > > > > > +
> > > > > > > > +*Uacce* creates a chrdev for the device registered to it. =
A "queue" will be
> > > > > > > > +created when the chrdev is opened. The application access =
the queue by mmap
> > > > > > > > +different address region of the queue file.
> > > > > > > > +
> > > > > > > > +The following figure demonstrated the queue file address s=
pace:
> > > > > > > > +
> > > > > > > > +.. image:: wd_q_addr_space.svg
> > > > > > > > +        :alt: WarpDrive Queue Address Space
> > > > > > > > +
> > > > > > > > +The first region of the space, device region, is used for =
the application to
> > > > > > > > +write request or read answer to or from the hardware.
> > > > > > > > +
> > > > > > > > +Normally, there can be three types of device regions mmio =
and memory regions.
> > > > > > > > +It is recommended to use common memory for request/answer =
descriptors and use
> > > > > > > > +the mmio space for device notification, such as doorbell. =
But of course, this
> > > > > > > > +is all up to the interface designer.
> > > > > > > > +
> > > > > > > > +There can be two types of device memory regions, kernel-on=
ly and user-shared.
> > > > > > > > +This will be explained in the "kernel APIs" section.
> > > > > > > > +
> > > > > > > > +The Static Share Virtual Memory region is necessary only w=
hen the device IOMMU
> > > > > > > > +does not support "Share Virtual Memory". This will be expl=
ained after the
> > > > > > > > +*IOMMU* idea.
> > > > > > > > +
> > > > > > > > +
> > > > > > > > +Architecture
> > > > > > > > +------------
> > > > > > > > +
> > > > > > > > +The full *WarpDrive* architecture is represented in the fo=
llowing class
> > > > > > > > +diagram:
> > > > > > > > +
> > > > > > > > +.. image:: wd-arch.svg
> > > > > > > > +        :alt: WarpDrive Architecture
> > > > > > > > +
> > > > > > > > +
> > > > > > > > +The user API
> > > > > > > > +------------
> > > > > > > > +
> > > > > > > > +We adopt a polling style interface in the user space: ::
> > > > > > > > +
> > > > > > > > +        int wd_request_queue(struct wd_queue *q);
> > > > > > > > +        void wd_release_queue(struct wd_queue *q);
> > > > > > > > +
> > > > > > > > +        int wd_send(struct wd_queue *q, void *req);
> > > > > > > > +        int wd_recv(struct wd_queue *q, void **req);
> > > > > > > > +        int wd_recv_sync(struct wd_queue *q, void **req);
> > > > > > > > +        void wd_flush(struct wd_queue *q);
> > > > > > > > +
> > > > > > > > +wd_recv_sync() is a wrapper to its non-sync version. It wi=
ll trapped into
> > > > > > > > +kernel and waits until the queue become available.
> > > > > > > > +
> > > > > > > > +If the queue do not support SVA/SVM. The following helper =
function
> > > > > > > > +can be used to create Static Virtual Share Memory: ::
> > > > > > > > +
> > > > > > > > +        void *wd_preserve_share_memory(struct wd_queue *q,=
 size_t size);
> > > > > > > > +
> > > > > > > > +The user API is not mandatory. It is simply a suggestion a=
nd hint what the
> > > > > > > > +kernel interface is supposed to support.
> > > > > > > > +
> > > > > > > > +
> > > > > > > > +The user driver
> > > > > > > > +---------------
> > > > > > > > +
> > > > > > > > +The queue file mmap space will need a user driver to wrap =
the communication
> > > > > > > > +protocol. *UACCE* provides some attributes in sysfs for th=
e user driver to
> > > > > > > > +match the right accelerator accordingly.
> > > > > > > > +
> > > > > > > > +The *UACCE* device attribute is under the following direct=
ory:
> > > > > > > > +
> > > > > > > > +/sys/class/uacce/<dev-name>/params
> > > > > > > > +
> > > > > > > > +The following attributes is supported:
> > > > > > > > +
> > > > > > > > +nr_queue_remained (ro)
> > > > > > > > +        number of queue remained
> > > > > > > > +
> > > > > > > > +api_version (ro)
> > > > > > > > +        a string to identify the queue mmap space format a=
nd its version
> > > > > > > > +
> > > > > > > > +device_attr (ro)
> > > > > > > > +        attributes of the device, see UACCE_DEV_xxx flag d=
efined in uacce.h
> > > > > > > > +
> > > > > > > > +numa_node (ro)
> > > > > > > > +        id of numa node
> > > > > > > > +
> > > > > > > > +priority (rw)
> > > > > > > > +        Priority or the device, bigger is higher
> > > > > > > > +
> > > > > > > > +(This is not yet implemented in RFC version)
> > > > > > > > +
> > > > > > > > +
> > > > > > > > +The kernel API
> > > > > > > > +--------------
> > > > > > > > +
> > > > > > > > +The *uacce* kernel API is defined in uacce.h. If the hardw=
are support SVM/SVA,
> > > > > > > > +The driver need only the following API functions: ::
> > > > > > > > +
> > > > > > > > +        int uacce_register(uacce);
> > > > > > > > +        void uacce_unregister(uacce);
> > > > > > > > +        void uacce_wake_up(q);
> > > > > > > > +
> > > > > > > > +*uacce_wake_up* is used to notify the process who epoll() =
on the queue file.
> > > > > > > > +
> > > > > > > > +According to the IOMMU capability, *uacce* categories the =
devices as follow:
> > > > > > > > +
> > > > > > > > +UACCE_DEV_NOIOMMU
> > > > > > > > +        The device has no IOMMU. The user process cannot u=
se VA on the hardware
> > > > > > > > +        This mode is not recommended.
> > > > > > > > +
> > > > > > > > +UACCE_DEV_SVA (UACCE_DEV_PASID | UACCE_DEV_FAULT_FROM_DEV)
> > > > > > > > +        The device has IOMMU which can share the same page=
 table with user
> > > > > > > > +        process
> > > > > > > > +
> > > > > > > > +UACCE_DEV_SHARE_DOMAIN
> > > > > > > > +        The device has IOMMU which has no multiple page ta=
ble and device page
> > > > > > > > +        fault support
> > > > > > > > +
> > > > > > > > +If the device works in mode other than UACCE_DEV_NOIOMMU, =
*uacce* will set its
> > > > > > > > +IOMMU to IOMMU_DOMAIN_UNMANAGED. So the driver must not us=
e any kernel
> > > > > > > > +DMA API but the following ones from *uacce* instead: ::
> > > > > > > > +
> > > > > > > > +        uacce_dma_map(q, va, size, prot);
> > > > > > > > +        uacce_dma_unmap(q, va, size, prot);
> > > > > > > > +
> > > > > > > > +*uacce_dma_map/unmap* is valid only for UACCE_DEV_SVA devi=
ce. It creates a
> > > > > > > > +particular PASID and page table for the kernel in the IOMM=
U (Not yet
> > > > > > > > +implemented in the RFC)
> > > > > > > > +
> > > > > > > > +For the UACCE_DEV_SHARE_DOMAIN device, uacce_dma_map/unmap=
 is not valid.
> > > > > > > > +*Uacce* call back start_queue only when the DUS and DKO re=
gion is mmapped. The
> > > > > > > > +accelerator driver must use those dma buffer, via uacce_qu=
eue->qfrs[], on
> > > > > > > > +start_queue call back. The size of the queue file region i=
s defined by
> > > > > > > > +uacce->ops->qf_pg_start[].
> > > > > > > > +
> > > > > > > > +We have to do it this way because most of current IOMMU ca=
nnot support the
> > > > > > > > +kernel and user virtual address at the same time. So we ha=
ve to let them both
> > > > > > > > +share the same user virtual address space.
> > > > > > > > +
> > > > > > > > +If the device have to support kernel and user at the same =
time, both kernel
> > > > > > > > +and the user should use these DMA API. This is not conveni=
ent. A better
> > > > > > > > +solution is to change the future DMA/IOMMU design to let t=
hem separate the
> > > > > > > > +address space between the user and kernel space. But it is=
 not going to be in
> > > > > > > > +a short time.
> > > > > > > > +
> > > > > > > > +
> > > > > > > > +Multiple processes support
> > > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > > > > > > > +
> > > > > > > > +In the latest mainline kernel (4.19) when this document is=
 written, the IOMMU
> > > > > > > > +subsystem do not support multiple process page tables yet.
> > > > > > > > +
> > > > > > > > +Most IOMMU hardware implementation support multi-process w=
ith the concept
> > > > > > > > +of PASID. But they may use different name, e.g. it is call=
 sub-stream-id in
> > > > > > > > +SMMU of ARM. With PASID or similar design, multi page tabl=
e can be added to
> > > > > > > > +the IOMMU and referred by its PASID.
> > > > > > > > +
> > > > > > > > +*JPB* has a patchset to enable this[1]_. We have tested it=
 with our hardware
> > > > > > > > +(which is known as *D06*). It works well. *WarpDrive* rely=
 on them to support
> > > > > > > > +UACCE_DEV_SVA. If it is not enabled, *WarpDrive* can still=
 work. But it
> > > > > > > > +support only one process, the device will be set to UACCE_=
DEV_SHARE_DOMAIN
> > > > > > > > +even it is set to UACCE_DEV_SVA initially.
> > > > > > > > +
> > > > > > > > +Static Share Virtual Memory is mainly used by UACCE_DEV_SH=
ARE_DOMAIN device.
> > > > > > > > +
> > > > > > > > +
> > > > > > > > +Legacy Mode Support
> > > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > > +For the hardware without IOMMU, WarpDrive can still work, =
the only problem is
> > > > > > > > +VA cannot be used in the device. The driver should adopt a=
nother strategy for
> > > > > > > > +the shared memory. It is only for testing, and not recomme=
nded.
> > > > > > > > +
> > > > > > > > +
> > > > > > > > +The Folk Scenario
> > > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > > +For a process with allocated queues and shared memory, wha=
t happen if it forks
> > > > > > > > +a child?
> > > > > > > > +
> > > > > > > > +The fd of the queue will be duplicated on folk, so the chi=
ld can send request
> > > > > > > > +to the same queue as its parent. But the requests which is=
 sent from processes
> > > > > > > > +except for the one who open the queue will be blocked.
> > > > > > > > +
> > > > > > > > +It is recommended to add O_CLOEXEC to the queue file.
> > > > > > > > +
> > > > > > > > +The queue mmap space has a VM_DONTCOPY in its VMA. So the =
child will lost all
> > > > > > > > +those VMAs.
> > > > > > > > +
> > > > > > > > +This is why *WarpDrive* does not adopt the mode used in *V=
FIO* and *InfiniBand*.
> > > > > > > > +Both solutions can set any user pointer for hardware shari=
ng. But they cannot
> > > > > > > > +support fork when the dma is in process. Or the "Copy-On-W=
rite" procedure will
> > > > > > > > +make the parent process lost its physical pages.
> > > > > > > > +
> > > > > > > > +
> > > > > > > > +The Sample Code
> > > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > > +There is a sample user land implementation with a simple d=
river for Hisilicon
> > > > > > > > +Hi1620 ZIP Accelerator.
> > > > > > > > +
> > > > > > > > +To test, do the following in samples/warpdrive (for the ca=
se of PC host): ::
> > > > > > > > +        ./autogen.sh
> > > > > > > > +        ./conf.sh       # or simply ./configure if you bui=
ld on target system
> > > > > > > > +        make
> > > > > > > > +
> > > > > > > > +Then you can get test_hisi_zip in the test subdirectory. C=
opy it to the target
> > > > > > > > +system and make sure the hisi_zip driver is enabled (the m=
ajor and minor of
> > > > > > > > +the uacce chrdev can be gotten from the dmesg or sysfs), a=
nd run: ::
> > > > > > > > +        mknod /dev/ua1 c <major> <minior>
> > > > > > > > +        test/test_hisi_zip -z < data > data.zip
> > > > > > > > +        test/test_hisi_zip -g < data > data.gzip
> > > > > > > > +
> > > > > > > > +
> > > > > > > > +References
> > > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > > +.. [1] https://patchwork.kernel.org/patch/10394851/
> > > > > > > > +
> > > > > > > > +.. vim: tw=3D78
> > > > [...]
> > > > > > > > --
> > > > > > > > 2.17.1
> > > > > > > >
>
> I don't know if Mr. Jerome Glisse in the list. I think I should cc him fo=
r my
> respectation  to his help on last RFC.
>
> - Kenneth

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb8pThAAoJEORje4g2clin0VkP/0mm+/wYaqbR8aHIrEuQAjK6
mKPa7GwmjgWDJLjWUdG3LJCzzaAY1pcrGzqEd+9lpfmQFAS2ep8eTf1upa1lstFu
mMkAzu6uEojUjGlh/FjhGVuJ61+2MybKL762bSbs64si2r0memcDv/lK8V6zKBGR
ZdunVXcHXKAevJTs0t0P40DCRmGygaVWt8qIu2vontsPV0GPXa8f3o9kfWu6UGyI
Z9ZKUW8BsaDCxjY7w8wDe+m68DYv+aPKQhgjMhnX6YHvnC6aWyekpS80zP3v47SL
w6XNBH5tgXyp8bMUQFb0lCRTwHSWOaW2Z0JKO74GekEKNLAE17LVSTGJT9fq331P
afzShBnzU7k+pFxHg4C+WWj5iitwtZ5Y2TSR3cP681HBlrQbZtoLTXWt/R7+PjCI
RwbH7rGUPfs5J02qtaI/mn0E1eCYzfb44XJe+7GvmaMX7CjZNKLrYOBKF8ln8aqk
0MTCYrkH+R4bPaR8s7W/jjCsYxuNFT/52Mu3bPKv6zVLzBjPzQY9jbppDpu5w3Lq
qiJqGeP1hn+GQmWZcEZs3qZlJ0P63jXK8KXc4lcV3SusvWoUwDMw4i05Et4IQGEC
HxqmhPBoIJxNSHNsHnDpQj4ImSnoxd5derld+wBsoccAY1KBVhZlqeMlTOj3IAkk
qz1DA6HA3E9QR6t0reJP
=Lylx
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
