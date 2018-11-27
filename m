Return-Path: <SRS0=NopL=OG=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:15163 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727741AbeK0NrZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Nov 2018 08:47:25 -0500
Date: Tue, 27 Nov 2018 10:52:30 +0800
From: Kenneth Lee <liguozhu@hisilicon.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Tim Sell <timothy.sell@unisys.com>, <linux-doc@vger.kernel.org>,
        "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
        Zaibo Xu <xuzaibo@huawei.com>, <zhangfei.gao@foxmail.com>,
        <linuxarm@huawei.com>, <haojian.zhuang@linaro.org>,
        Christoph Lameter <cl@linux.com>,
        Hao Fang <fanghao11@huawei.com>,
        Gavin Schenk <g.schenk@eckelmann.de>,
        "RDMA mailing list" <linux-rdma@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Doug Ledford <dledford@redhat.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
        <u.kleine-koenig@pengutronix.de>,
        "David Kershner" <david.kershner@unisys.com>,
        Kenneth Lee <nek.in.cn@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Jerome Glisse <jglisse@redhat.com>,
        "Cyrille Pitchen" <cyrille.pitchen@free-electrons.com>,
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
Message-ID: <20181127025230.GM157308@Turing-Arch-b>
References: <20181112075807.9291-2-nek.in.cn@gmail.com>
 <20181113002354.GO3695@mtr-leonro.mtl.com>
 <95310df4-b32c-42f0-c750-3ad5eb89b3dd@gmail.com>
 <20181114160017.GI3759@mtr-leonro.mtl.com>
 <20181115085109.GD157308@Turing-Arch-b>
 <20181115145455.GN3759@mtr-leonro.mtl.com>
 <20181119091405.GE157308@Turing-Arch-b>
 <20181119091910.GF157308@Turing-Arch-b>
 <20181119104801.GF8268@mtr-leonro.mtl.com>
 <20181120023055.GG157308@Turing-Arch-b>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181120023055.GG157308@Turing-Arch-b>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 20, 2018 at 10:30:55AM +0800, Kenneth Lee wrote:
> Date: Tue, 20 Nov 2018 10:30:55 +0800
> From: Kenneth Lee <liguozhu@hisilicon.com>
> To: Leon Romanovsky <leon@kernel.org>
> CC: Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org,
>  Alexander Shishkin <alexander.shishkin@linux.intel.com>, Zaibo Xu
>  <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com, linuxarm@huawei.com,
>  haojian.zhuang@linaro.org, Christoph Lameter <cl@linux.com>, Hao Fang
>  <fanghao11@huawei.com>, Gavin Schenk <g.schenk@eckelmann.de>, RDMA mailing
>  list <linux-rdma@vger.kernel.org>, Zhou Wang <wangzhou1@hisilicon.com>,
>  Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Uwe
>  Kleine-König <u.kleine-koenig@pengutronix.de>, David Kershner
>  <david.kershner@unisys.com>, Kenneth Lee <nek.in.cn@gmail.com>, Johan
>  Hovold <johan@kernel.org>, Jerome Glisse <jglisse@redhat.com>, Cyrille
>  Pitchen <cyrille.pitchen@free-electrons.com>, Sagar Dharia
>  <sdharia@codeaurora.org>, Jens Axboe <axboe@kernel.dk>,
>  guodong.xu@linaro.org, linux-netdev <netdev@vger.kernel.org>, Randy Dunlap
>  <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Vinod Koul
>  <vkoul@kernel.org>, linux-crypto@vger.kernel.org, Philippe Ombredanne
>  <pombredanne@nexb.com>, Sanyog Kale <sanyog.r.kale@intel.com>, "David S.
>  Miller" <davem@davemloft.net>, linux-accelerators@lists.ozlabs.org
> Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
> User-Agent: Mutt/1.5.21 (2010-09-15)
> Message-ID: <20181120023055.GG157308@Turing-Arch-b>
> 
> On Mon, Nov 19, 2018 at 12:48:01PM +0200, Leon Romanovsky wrote:
> > Date: Mon, 19 Nov 2018 12:48:01 +0200
> > From: Leon Romanovsky <leon@kernel.org>
> > To: Kenneth Lee <liguozhu@hisilicon.com>
> > CC: Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org,
> >  Alexander Shishkin <alexander.shishkin@linux.intel.com>, Zaibo Xu
> >  <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com, linuxarm@huawei.com,
> >  haojian.zhuang@linaro.org, Christoph Lameter <cl@linux.com>, Hao Fang
> >  <fanghao11@huawei.com>, Gavin Schenk <g.schenk@eckelmann.de>, RDMA mailing
> >  list <linux-rdma@vger.kernel.org>, Vinod Koul <vkoul@kernel.org>, Jason
> >  Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Uwe
> >  Kleine-König <u.kleine-koenig@pengutronix.de>, David Kershner
> >  <david.kershner@unisys.com>, Kenneth Lee <nek.in.cn@gmail.com>, Johan
> >  Hovold <johan@kernel.org>, Cyrille Pitchen
> >  <cyrille.pitchen@free-electrons.com>, Sagar Dharia
> >  <sdharia@codeaurora.org>, Jens Axboe <axboe@kernel.dk>,
> >  guodong.xu@linaro.org, linux-netdev <netdev@vger.kernel.org>, Randy Dunlap
> >  <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Zhou Wang
> >  <wangzhou1@hisilicon.com>, linux-crypto@vger.kernel.org, Philippe
> >  Ombredanne <pombredanne@nexb.com>, Sanyog Kale <sanyog.r.kale@intel.com>,
> >  "David S. Miller" <davem@davemloft.net>,
> >  linux-accelerators@lists.ozlabs.org, Jerome Glisse <jglisse@redhat.com>
> > Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
> > User-Agent: Mutt/1.10.1 (2018-07-13)
> > Message-ID: <20181119104801.GF8268@mtr-leonro.mtl.com>
> > 
> > On Mon, Nov 19, 2018 at 05:19:10PM +0800, Kenneth Lee wrote:
> > > On Mon, Nov 19, 2018 at 05:14:05PM +0800, Kenneth Lee wrote:
> > > > Date: Mon, 19 Nov 2018 17:14:05 +0800
> > > > From: Kenneth Lee <liguozhu@hisilicon.com>
> > > > To: Leon Romanovsky <leon@kernel.org>
> > > > CC: Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org,
> > > >  Alexander Shishkin <alexander.shishkin@linux.intel.com>, Zaibo Xu
> > > >  <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com, linuxarm@huawei.com,
> > > >  haojian.zhuang@linaro.org, Christoph Lameter <cl@linux.com>, Hao Fang
> > > >  <fanghao11@huawei.com>, Gavin Schenk <g.schenk@eckelmann.de>, RDMA mailing
> > > >  list <linux-rdma@vger.kernel.org>, Vinod Koul <vkoul@kernel.org>, Jason
> > > >  Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Uwe
> > > >  Kleine-König <u.kleine-koenig@pengutronix.de>, David Kershner
> > > >  <david.kershner@unisys.com>, Kenneth Lee <nek.in.cn@gmail.com>, Johan
> > > >  Hovold <johan@kernel.org>, Cyrille Pitchen
> > > >  <cyrille.pitchen@free-electrons.com>, Sagar Dharia
> > > >  <sdharia@codeaurora.org>, Jens Axboe <axboe@kernel.dk>,
> > > >  guodong.xu@linaro.org, linux-netdev <netdev@vger.kernel.org>, Randy Dunlap
> > > >  <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Zhou Wang
> > > >  <wangzhou1@hisilicon.com>, linux-crypto@vger.kernel.org, Philippe
> > > >  Ombredanne <pombredanne@nexb.com>, Sanyog Kale <sanyog.r.kale@intel.com>,
> > > >  "David S. Miller" <davem@davemloft.net>,
> > > >  linux-accelerators@lists.ozlabs.org
> > > > Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
> > > > User-Agent: Mutt/1.5.21 (2010-09-15)
> > > > Message-ID: <20181119091405.GE157308@Turing-Arch-b>
> > > >
> > > > On Thu, Nov 15, 2018 at 04:54:55PM +0200, Leon Romanovsky wrote:
> > > > > Date: Thu, 15 Nov 2018 16:54:55 +0200
> > > > > From: Leon Romanovsky <leon@kernel.org>
> > > > > To: Kenneth Lee <liguozhu@hisilicon.com>
> > > > > CC: Kenneth Lee <nek.in.cn@gmail.com>, Tim Sell <timothy.sell@unisys.com>,
> > > > >  linux-doc@vger.kernel.org, Alexander Shishkin
> > > > >  <alexander.shishkin@linux.intel.com>, Zaibo Xu <xuzaibo@huawei.com>,
> > > > >  zhangfei.gao@foxmail.com, linuxarm@huawei.com, haojian.zhuang@linaro.org,
> > > > >  Christoph Lameter <cl@linux.com>, Hao Fang <fanghao11@huawei.com>, Gavin
> > > > >  Schenk <g.schenk@eckelmann.de>, RDMA mailing list
> > > > >  <linux-rdma@vger.kernel.org>, Zhou Wang <wangzhou1@hisilicon.com>, Jason
> > > > >  Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Uwe
> > > > >  Kleine-König <u.kleine-koenig@pengutronix.de>, David Kershner
> > > > >  <david.kershner@unisys.com>, Johan Hovold <johan@kernel.org>, Cyrille
> > > > >  Pitchen <cyrille.pitchen@free-electrons.com>, Sagar Dharia
> > > > >  <sdharia@codeaurora.org>, Jens Axboe <axboe@kernel.dk>,
> > > > >  guodong.xu@linaro.org, linux-netdev <netdev@vger.kernel.org>, Randy Dunlap
> > > > >  <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Vinod Koul
> > > > >  <vkoul@kernel.org>, linux-crypto@vger.kernel.org, Philippe Ombredanne
> > > > >  <pombredanne@nexb.com>, Sanyog Kale <sanyog.r.kale@intel.com>, "David S.
> > > > >  Miller" <davem@davemloft.net>, linux-accelerators@lists.ozlabs.org
> > > > > Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
> > > > > User-Agent: Mutt/1.10.1 (2018-07-13)
> > > > > Message-ID: <20181115145455.GN3759@mtr-leonro.mtl.com>
> > > > >
> > > > > On Thu, Nov 15, 2018 at 04:51:09PM +0800, Kenneth Lee wrote:
> > > > > > On Wed, Nov 14, 2018 at 06:00:17PM +0200, Leon Romanovsky wrote:
> > > > > > > Date: Wed, 14 Nov 2018 18:00:17 +0200
> > > > > > > From: Leon Romanovsky <leon@kernel.org>
> > > > > > > To: Kenneth Lee <nek.in.cn@gmail.com>
> > > > > > > CC: Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org,
> > > > > > >  Alexander Shishkin <alexander.shishkin@linux.intel.com>, Zaibo Xu
> > > > > > >  <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com, linuxarm@huawei.com,
> > > > > > >  haojian.zhuang@linaro.org, Christoph Lameter <cl@linux.com>, Hao Fang
> > > > > > >  <fanghao11@huawei.com>, Gavin Schenk <g.schenk@eckelmann.de>, RDMA mailing
> > > > > > >  list <linux-rdma@vger.kernel.org>, Zhou Wang <wangzhou1@hisilicon.com>,
> > > > > > >  Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Uwe
> > > > > > >  Kleine-König <u.kleine-koenig@pengutronix.de>, David Kershner
> > > > > > >  <david.kershner@unisys.com>, Johan Hovold <johan@kernel.org>, Cyrille
> > > > > > >  Pitchen <cyrille.pitchen@free-electrons.com>, Sagar Dharia
> > > > > > >  <sdharia@codeaurora.org>, Jens Axboe <axboe@kernel.dk>,
> > > > > > >  guodong.xu@linaro.org, linux-netdev <netdev@vger.kernel.org>, Randy Dunlap
> > > > > > >  <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Vinod Koul
> > > > > > >  <vkoul@kernel.org>, linux-crypto@vger.kernel.org, Philippe Ombredanne
> > > > > > >  <pombredanne@nexb.com>, Sanyog Kale <sanyog.r.kale@intel.com>, Kenneth Lee
> > > > > > >  <liguozhu@hisilicon.com>, "David S. Miller" <davem@davemloft.net>,
> > > > > > >  linux-accelerators@lists.ozlabs.org
> > > > > > > Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
> > > > > > > User-Agent: Mutt/1.10.1 (2018-07-13)
> > > > > > > Message-ID: <20181114160017.GI3759@mtr-leonro.mtl.com>
> > > > > > >
> > > > > > > On Wed, Nov 14, 2018 at 10:58:09AM +0800, Kenneth Lee wrote:
> > > > > > > >
> > > > > > > > 在 2018/11/13 上午8:23, Leon Romanovsky 写道:
> > > > > > > > > On Mon, Nov 12, 2018 at 03:58:02PM +0800, Kenneth Lee wrote:
> > > > > > > > > > From: Kenneth Lee <liguozhu@hisilicon.com>
> > > > > > > > > >
> > > > > > > > > > WarpDrive is a general accelerator framework for the user application to
> > > > > > > > > > access the hardware without going through the kernel in data path.
> > > > > > > > > >
> > > > > > > > > > The kernel component to provide kernel facility to driver for expose the
> > > > > > > > > > user interface is called uacce. It a short name for
> > > > > > > > > > "Unified/User-space-access-intended Accelerator Framework".
> > > > > > > > > >
> > > > > > > > > > This patch add document to explain how it works.
> > > > > > > > > + RDMA and netdev folks
> > > > > > > > >
> > > > > > > > > Sorry, to be late in the game, I don't see other patches, but from
> > > > > > > > > the description below it seems like you are reinventing RDMA verbs
> > > > > > > > > model. I have hard time to see the differences in the proposed
> > > > > > > > > framework to already implemented in drivers/infiniband/* for the kernel
> > > > > > > > > space and for the https://github.com/linux-rdma/rdma-core/ for the user
> > > > > > > > > space parts.
> > > > > > > >
> > > > > > > > Thanks Leon,
> > > > > > > >
> > > > > > > > Yes, we tried to solve similar problem in RDMA. We also learned a lot from
> > > > > > > > the exist code of RDMA. But we we have to make a new one because we cannot
> > > > > > > > register accelerators such as AI operation, encryption or compression to the
> > > > > > > > RDMA framework:)
> > > > > > >
> > > > > > > Assuming that you did everything right and still failed to use RDMA
> > > > > > > framework, you was supposed to fix it and not to reinvent new exactly
> > > > > > > same one. It is how we develop kernel, by reusing existing code.
> > > > > >
> > > > > > Yes, but we don't force other system such as NIC or GPU into RDMA, do we?
> > > > >
> > > > > You don't introduce new NIC or GPU, but proposing another interface to
> > > > > directly access HW memory and bypass kernel for the data path. This is
> > > > > whole idea of RDMA and this is why it is already present in the kernel.
> > > > >
> > > > > Various hardware devices are supported in our stack allow a ton of crazy
> > > > > stuff, including GPUs interconnections and NIC functionalities.
> > > >
> > > > Yes. We don't want to invent new wheel. That is why we did it behind VFIO in RFC
> > > > v1 and v2. But finally we were persuaded by Mr. Jerome Glisse that VFIO was not
> > > > a good place to solve the problem.
> > 
> > I saw a couple of his responses, he constantly said to you that you are
> > reinventing the wheel.
> > https://lore.kernel.org/lkml/20180904150019.GA4024@redhat.com/
> > 
> 
> No. I think he asked me did not create trouble in VFIO but just use common
> interface from dma_buf and iommu itself. That is exactly what I am doing.
> 
> > > >
> > > > And currently, as you see, IB is bound with devices doing RDMA. The register
> > > > function, ib_register_device() hint that it is a netdev (get_netdev() callback), it know
> > > > about gid, pkey, and Memory Window. IB is not simply a address space management
> > > > framework. And verbs to IB are not transparent. If we start to add
> > > > compression/decompression, AI (RNN, CNN stuff) operations, and encryption/decryption
> > > > to the verbs set. It will become very complexity. Or maybe I misunderstand the
> > > > IB idea? But I don't see compression hardware is integrated in the mainline
> > > > Kernel. Could you directly point out which one I can used as a reference?
> > > >
> > 
> > I strongly advise you to read the code, not all drivers are implementing
> > gids, pkeys and get_netdev() callback.
> > 
> > Yes, you are misunderstanding drivers/infiniband subsystem. We have
> > plenty options to expose APIs to the user space applications, starting
> > from standard verbs API and ending with private objects which are
> > understandable by specific device/driver.
> > 
> > IB stack provides secure FD to access device, by creating context,
> > after that you can send direct commands to the FW (see mlx5 DEVX
> > or hfi1) in sane way.
> > 
> > So actually, you will need to register your device, declare your own
> > set of objects (similar to mlx5 include/uapi/rdma/mlx5_user_ioctl_*.h).
> > 
> > In regards to reference of compression hardware, I don't have.
> > But there is an example of how T10-DIF can be implemented in verbs
> > layer:
> > https://www.openfabrics.org/images/2018workshop/presentations/307_TOved_T10-DIFOffload.pdf
> > Or IPsec crypto:
> > https://www.spinics.net/lists/linux-rdma/msg48906.html
> > 
> 
> OK. I will spend some time on it first. But according to current discussion,
> Don't you think I should avoid all these complexities but simply use SVM/SVA on
> iommu or let the user application use the kernel-allocated VMA and page? It
> does not create anything new. Just a new user of IOMMU and its SVM/SVA
> capability.
> 

Hi, Leon,

I have done some architecture and code study to the IB solution these days. Now
I understand why you said WarpDrive was another wheel of IB. At the very
beginning when I understood the verbs concept, I had the same feeling.  But when
I considered to merge them together, I finally found that it would be a disaster
to both of them if we do so.

As my understanding, the idea of IB is to manage share memory among "peers".
Verbs are to help the peers to communicate to each other with these share
memory, which is wrapped as MRs. The benefit of IB framework itself is to
provide the communication channel in most efficiency way. To do so, it let the
user process send the communicating data to the hardware directly.

While the idea of WD is simply to provide a channel between the process and the
LOCAL devices and let them share "address space", rather than "memory region".

We can take the device of WD accelerator as a "peer" in IB. But then most of the
semantics in verbs will become worthless, e.g. IBV_WR_RDMA_READ/WRITE. As a
local system, you just need to read or write to it, you don't need to "tell" you
are writing to it:). The semantics of verbs hint MRs are remote.

We can also invent a new "local dma" semantics to the original MRs  semantic
space. But it is worthless, because it has already provided.  Further, it bring
no benefit to the current IB users.

In another way, WD get very few benefit by integrating into IB framework
either. The verb interface provides a standard interface for memory operation.
But WD only need a pure message channel between the process and the device, it
dose not intercept between them. The ODP feature will be provided by IOMMU
framework if Jean's patchset is upstreamed, we don't need to get it from IB.
Moreover, ODP simply provides the "fault from device" feature. But WD can also be
benefit from the "share page table" feature, but which does no good to IB.

Please understand I have no any motivation to reinvent anything. As a software
architect for 10+ years and coder for 20+ years. I fully understand how hard to
make a module mature. It is not simply the problem of effort. But I also
understand that what is going to happen if we merge improper requirement to a
exist module. I don't think it is wise to merge WD into IB. It hurts both.

So would you change your previous conclusion?

Cheers
-Kenneth

> > > > >
> > > > > >
> > > > > > I assume you would not agree to register a zip accelerator to infiniband? :)
> > > > >
> > > > > "infiniband" name in the "drivers/infiniband/" is legacy one and the
> > > > > current code supports IB, RoCE, iWARP and OmniPath as a transport layers.
> > > > > For a lone time, we wanted to rename that folder to be "drivers/rdma",
> > > > > but didn't find enough brave men/women to do it, due to backport mess
> > > > > for such move.
> > > > >
> > > > > The addition of zip accelerator to RDMA is possible and depends on how
> > > > > you will model such new functionality - new driver, or maybe new ULP.
> > > > >
> > > > > >
> > > > > > Further, I don't think it is wise to break an exist system (RDMA) to fulfill a
> > > > > > totally new scenario. The better choice is to let them run in parallel for some
> > > > > > time and try to merge them accordingly.
> > > > >
> > > > > Awesome, so please run your code out-of-tree for now and once you are ready
> > > > > for submission let's try to merge it.
> > > >
> > > > Yes, yes. We know trust need time to gain. But the fact is that there is no
> > > > accelerator user driver can be added to mainline kernel. We should raise the
> > > > topic time to time. So to help the communication to fix the gap, right?
> > > >
> > > > We are also opened to cooperate with IB to do it within the IB framework. But
> > > > please let me know where to start. I feel it is quite wired to make a
> > > > ib_register_device for a zip or RSA accelerator.
> > 
> > Most of ib_ prefixes in drivers/infinband/ are legacy names. You can
> > rename them to be rdma_register_device() if it helps.
> > 
> > So from implementation point of view, as I wrote above.
> > Create minimal driver to register, expose MR to user space, add your own
> > objects and capabilities through our new KABI and implement user space part
> > in github.com/linux-rdma/rdma-core.
> 
> I don't think it is just a name. But anyway, let me spend some time to try the
> possibility.
> 
> > 
> > > >
> > > > >
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > Another problem we tried to address is the way to pin the memory for dma
> > > > > > > > operation. The RDMA way to pin the memory cannot avoid the page lost due to
> > > > > > > > copy-on-write operation during the memory is used by the device. This may
> > > > > > > > not be important to RDMA library. But it is important to accelerator.
> > > > > > >
> > > > > > > Such support exists in drivers/infiniband/ from late 2014 and
> > > > > > > it is called ODP (on demand paging).
> > > > > >
> > > > > > I reviewed ODP and I think it is a solution bound to infiniband. It is part of
> > > > > > MR semantics and required a infiniband specific hook
> > > > > > (ucontext->invalidate_range()). And the hook requires the device to be able to
> > > > > > stop using the page for a while for the copying. It is ok for infiniband
> > > > > > (actually, only mlx5 uses it). I don't think most accelerators can support
> > > > > > this mode. But WarpDrive works fully on top of IOMMU interface, it has no this
> > > > > > limitation.
> > > > >
> > > > > 1. It has nothing to do with infiniband.
> > > >
> > > > But it must be a ib_dev first.
> > 
> > It is just a name.
> > 
> > > >
> > > > > 2. MR and uncontext are verbs semantics and needed to ensure that host
> > > > > memory exposed to user is properly protected from security point of view.
> > > > > 3. "stop using the page for a while for the copying" - I'm not fully
> > > > > understand this claim, maybe this article will help you to better
> > > > > describe : https://lwn.net/Articles/753027/
> > > >
> > > > This topic was being discussed in RFCv2. The key problem here is that:
> > > >
> > > > The device need to hold the memory for its own calculation, but the CPU/software
> > > > want to stop it for a while for synchronizing with disk or COW.
> > > >
> > > > If the hardware support SVM/SVA (Shared Virtual Memory/Address), it is easy, the
> > > > device share page table with CPU, the device will raise a page fault when the
> > > > CPU downgrade the PTE to read-only.
> > > >
> > > > If the hardware cannot share page table with the CPU, we then need to have
> > > > some way to change the device page table. This is what happen in ODP. It
> > > > invalidates the page table in device upon mmu_notifier call back. But this cannot
> > > > solve the COW problem: if the user process A share a page P with device, and A
> > > > forks a new process B, and it continue to write to the page. By COW, the
> > > > process B will keep the page P, while A will get a new page P'. But you have
> > > > no way to let the device know it should use P' rather than P.
> > 
> > I didn't hear about such issue and we supported fork for a long time.
> > 
> > > >
> > > > This may be OK for RDMA application. Because RDMA is a big thing and we can ask
> > > > the programmer to avoid the situation. But for a accelerator, I don't think we
> > > > can ask a programmer to care for this when use a zlib.
> > > >
> > > > In WarpDrive/uacce, we make this simple. If you support IOMMU and it support
> > > > SVM/SVA. Everything will be fine just like ODP implicit mode. And you don't need
> > > > to write any code for that. Because it has been done by IOMMU framework. If it
> > > > dose not, you have to use the kernel allocated memory which has the same IOVA as
> > > > the VA in user space. So we can still maintain a unify address space among the
> > > > devices and the applicatin.
> > > >
> > > > > 4. mlx5 supports ODP not because of being partially IB device,
> > > > > but because HW performance oriented implementation is not an easy task.
> > > > >
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > Hope this can help the understanding.
> > > > > > >
> > > > > > > Yes, it helped me a lot.
> > > > > > > Now, I'm more than before convinced that this whole patchset shouldn't
> > > > > > > exist in the first place.
> > > > > >
> > > > > > Then maybe you can tell me how I can register my accelerator to the user space?
> > > > >
> > > > > Write kernel driver and write user space part of it.
> > > > > https://github.com/linux-rdma/rdma-core/
> > > > >
> > > > > I have no doubts that your colleagues who wrote and maintain
> > > > > drivers/infiniband/hw/hns driver know best how to do it.
> > > > > They did it very successfully.
> > > > >
> > > > > Thanks
> > > > >
> > > > > >
> > > > > > >
> > > > > > > To be clear, NAK.
> > > > > > >
> > > > > > > Thanks
> > > > > > >
> > > > > > > >
> > > > > > > > Cheers
> > > > > > > >
> > > > > > > > >
> > > > > > > > > Hard NAK from RDMA side.
> > > > > > > > >
> > > > > > > > > Thanks
> > > > > > > > >
[...]
