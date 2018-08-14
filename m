From: Kenneth Lee <liguozhu@hisilicon.com>
Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Tue, 14 Aug 2018 11:46:29 +0800
Message-ID: <20180814034629.GM91035@Turing-Arch-b>
References: <20180806153257.GB6002@redhat.com>
 <11bace0e-dc14-5d2c-f65c-25b852f4e9ca@gmail.com>
 <20180808151835.GA3429@redhat.com>
 <20180809080352.GI91035@Turing-Arch-b>
 <20180809144613.GB3386@redhat.com>
 <20180810033913.GK91035@Turing-Arch-b>
 <0f6bac9b-8381-1874-9367-46b5f4cef56e@arm.com>
 <6ea4dcfd-d539-93e4-acf1-d09ea35f0ddc@gmail.com>
 <20180813092931.GL91035@Turing-Arch-b>
 <20180813192301.GC3451@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: Kenneth Lee <nek.in.cn@gmail.com>,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Thom
To: Jerome Glisse <jglisse@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180813192301.GC3451@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 13, 2018 at 03:23:01PM -0400, Jerome Glisse wrote:
> Received: from popscn.huawei.com [10.3.17.45] by Turing-Arch-b with POP3
>  (fetchmail-6.3.26) for <kenny@localhost> (single-drop); Tue, 14 Aug 2018
>  03:30:02 +0800 (CST)
> Received: from DGGEMM401-HUB.china.huawei.com (10.3.20.209) by
>  DGGEML402-HUB.china.huawei.com (10.3.17.38) with Microsoft SMTP Server
>  (TLS) id 14.3.399.0; Tue, 14 Aug 2018 03:23:25 +0800
> Received: from dggwg01-in.huawei.com (172.30.65.34) by
>  DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server id
>  14.3.399.0; Tue, 14 Aug 2018 03:23:21 +0800
> Received: from mx1.redhat.com (unknown [66.187.233.73])	by Forcepoint
>  Email with ESMTPS id 301B5D4F60895	for <liguozhu@hisilicon.com>; Tue, 14
>  Aug 2018 03:23:16 +0800 (CST)
> Received: from smtp.corp.redhat.com
>  (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])	(using
>  TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))	(No client
>  certificate requested)	by mx1.redhat.com (Postfix) with ESMTPS id
>  4D0A14023461;	Mon, 13 Aug 2018 19:23:05 +0000 (UTC)
> Received: from redhat.com (unknown [10.20.6.215])	by
>  smtp.corp.redhat.com (Postfix) with ESMTPS id 20D072156712;	Mon, 13 Aug
>  2018 19:23:03 +0000 (UTC)
> Date: Mon, 13 Aug 2018 15:23:01 -0400
> From: Jerome Glisse <jglisse@redhat.com>
> To: Kenneth Lee <liguozhu@hisilicon.com>
> CC: Kenneth Lee <nek.in.cn@gmail.com>, Jean-Philippe Brucker
>  <jean-philippe.brucker@arm.com>, Herbert Xu <herbert@gondor.apana.org.au>,
>  "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Jonathan Corbet
>  <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zaibo
>  Xu <xuzaibo@huawei.com>, "linux-doc@vger.kernel.org"
>  <linux-doc@vger.kernel.org>, "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
>  "Tian, Kevin" <kevin.tian@intel.com>, "iommu@lists.linux-foundation.org"
>  <iommu@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
>  <linux-kernel@vger.kernel.org>, "linuxarm@huawei.com"
>  <linuxarm@huawei.com>, Alex Williamson <alex.williamson@redhat.com>,
>  "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Philippe
>  Ombredanne <pombredanne@nexb.com>, Thomas Gleixner <tglx@linutronix.de>,
>  Hao Fang <fanghao11@huawei.com>, "David S . Miller" <davem@davemloft.net>,
>  "linux-accelerators@lists.ozlabs.org"
>  <linux-accelerators@lists.ozlabs.org>
> Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
> Message-ID: <20180813192301.GC3451@redhat.com>
> References: <20180806031252.GG91035@Turing-Arch-b>
>  <20180806153257.GB6002@redhat.com>
>  <11bace0e-dc14-5d2c-f65c-25b852f4e9ca@gmail.com>
>  <20180808151835.GA3429@redhat.com> <20180809080352.GI91035@Turing-Arch-b>
>  <20180809144613.GB3386@redhat.com> <20180810033913.GK91035@Turing-Arch-b>
>  <0f6bac9b-8381-1874-9367-46b5f4cef56e@arm.com>
>  <6ea4dcfd-d539-93e4-acf1-d09ea35f0ddc@gmail.com>
>  <20180813092931.GL91035@Turing-Arch-b>
> Content-Type: text/plain; charset="iso-8859-1"
> Content-Disposition: inline
> Content-Transfer-Encoding: 8bit
> In-Reply-To: <20180813092931.GL91035@Turing-Arch-b>
> User-Agent: Mutt/1.10.0 (2018-05-17)
> X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
> X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
>  (mx1.redhat.com [10.11.55.6]); Mon, 13 Aug 2018 19:23:05 +0000 (UTC)
> X-Greylist: inspected by milter-greylist-4.5.16 (mx1.redhat.com
>  [10.11.55.6]); Mon, 13 Aug 2018 19:23:05 +0000 (UTC) for IP:'10.11.54.6'
>  DOMAIN:'int-mx06.intmail.prod.int.rdu2.redhat.com'
>  HELO:'smtp.corp.redhat.com' FROM:'jglisse@redhat.com' RCPT:''
> Return-Path: jglisse@redhat.com
> X-MS-Exchange-Organization-AuthSource: DGGEMM401-HUB.china.huawei.com
> X-MS-Exchange-Organization-AuthAs: Anonymous
> MIME-Version: 1.0
> 
> On Mon, Aug 13, 2018 at 05:29:31PM +0800, Kenneth Lee wrote:
> > 
> > I made a quick change basing on the RFCv1 here: 
> > 
> > https://github.com/Kenneth-Lee/linux-kernel-warpdrive/commits/warpdrive-v0.6
> > 
> > I just made it compilable and not test it yet. But it shows how the idea is
> > going to be.
> > 
> > The Pros is: most of the virtual device stuff can be removed. Resource
> > management is on the openned files only.
> > 
> > The Cons is: as Jean said, we have to redo something that has been done by VFIO.
> > These mainly are:
> > 
> > 1. Track the dma operation and remove them on resource releasing
> > 2. Pin the memory with gup and do accounting
> > 
> > It not going to be easy to make a decision...
> > 
> 
> Maybe it would be good to list things you want do. Looking at your tree
> it seems you are re-inventing what dma-buf is already doing.

My English is quite limited;). I think I did not explain it well in the WrapDrive
document. Please let me try again here:

The requirement of WrapDrive is simple. Many acceleration requirements are from
user space, such as OpenSSL, AI, and so on. We want to provide a framework for
the user land application to summon the accelerator easily.

So the scenario is simple: The application is doing its job and faces a tough
and boring task, say compression. Then it drops the data pointer to the command
queue and let the accelerator do it at its bidding, and continue its job until
the task is done, or its other task synchronously

My understanding to the dma-buf is driver oriented. The buffer is created by one
driver and exported as fd to user space, then the user space can share it with
some attached devices.

But our scenario is that the whole buffer is from the user space. The
application will directly assign the pointer to the command queue. The hardware
will directly use this address.  The kernel should set this particular virtual
memory or the whole process space to the IOMMU with its pasid. So the hardware
can use the process' address, which may not only be the address assigning in the
command queue, it can also be an address inside the memory itself.

To let this work, we have to pin the memory or set a page fault handler when the
memory is shared (to the hardware). And... the big work of pinning memory is not
gup (get user page), but rlimit accounting:)

> 
> So here is what i understand for SVM/SVA:
>     (1) allow userspace to create a command buffer for a device and bind
>         it to its address space (PASID)
>     (2) allow userspace to directly schedule commands on its command buffer
> 
> No need to do tracking here as SVM/SVA which rely on PASID and something
> like PCIE ATS (address translation service). Userspace can shoot itself
> in the foot but nothing harmful can happen.
> 

Yes, we can release the whole page table based on PASID (It also need Jean to
provide this interface;)). But the gup part still need to be tracked. (This is
what is done in VFIO)

> 
> Non SVM/SVA:
>     (3) allow userspace to wrap a region of its memory into an object so
>         that it can be DMA map (ie GUP + dma_map_page())
>     (4) Have userspace schedule command referencing object created in (3)
>         using an ioctl.

Yes, this is going to be something like NOIOMMU mode in VFIO. The hardware have
to accept DMA/physical address. But anyway, this not the major intension of
WrapDrive.

> 
> We need to keep track of object usage by the hardware so that we know
> when it is safe to release resources (dma_unmap_page()). The dma-buf
> provides everything you want for (3) and (4). With dma-buf you create
> object and each time it is use by a device you associate a fence with
> it. When fence is signaled it means that the hardware is done using
> that object. Fence also allow proper synchronization between multiple
> devices. For instance making sure that the second device wait for the
> first device before starting doing its thing. dma-buf documentations is
> much more thorough explaining all this.
> 

Your idea hints me that the dma_buf design is based on sharing memory from the
driver, not from the user space. That's why the signal is based on the buffer
itself, because the buffer can be used again and again.

This is good for performance. The cost is high if remap the data every time. But
if consider we can devote the whole application space with SVM/SVA support. This
can become acceptable.

> 
> Now from implementation point of view, maybe it would be a good idea
> to create something like the virtual gem driver. It is a virtual device
> that allow to create GEM object. So maybe we want a virtual device that
> allow to create dma-buf object from process memory and allow sharing of
> those dma-buf between multiple devices.
> 
> Userspace would only have to talk to this virtual device to create
> object and wrap its memory around, then it could use this object against
> many actual devices.
> 
> 
> This decouples the memory management, that can be share between all
> devices, from the actual device driver, which is obviously specific to
> every single device.
> 

Forcing the application to use the device allocate memory is an alluring choice,
it makes thing simple. Let us consider it for a while...

> 
> Note that dma-buf use file so that once all file reference are gone the
> resource can be free and cleanup can happen (dma_unmap_page() ...). This
> properly handle the resource lifetime issue you seem to worried about.
> 
> Cheers,
> Jérôme

-- 
			-Kenneth(Hisilicon)
