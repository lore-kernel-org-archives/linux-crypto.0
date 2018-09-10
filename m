From: Kenneth Lee <liguozhu@hisilicon.com>
Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Mon, 10 Sep 2018 11:28:09 +0800
Message-ID: <20180910032809.GJ230707@Turing-Arch-b>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
 <20180904150019.GA4024@redhat.com>
 <20180904101509.62314b67@t450s.home>
 <20180906094532.GG230707@Turing-Arch-b>
 <20180906133133.GA3830@redhat.com>
 <20180907040138.GI230707@Turing-Arch-b>
 <20180907165303.GA3519@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: Kenneth Lee <nek.in.cn@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <kvm@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Joerg Roedel" <joro@8bytes.org>, <linux-doc@vger.kernel.org>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Hao Fang <fanghao11@huawei.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        <linux-crypto@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        "Zaibo Xu" <xuzaibo@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-accelerators@lists.ozlabs.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
To: Jerome Glisse <jglisse@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180907165303.GA3519@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 07, 2018 at 12:53:06PM -0400, Jerome Glisse wrote:
> Date: Fri, 7 Sep 2018 12:53:06 -0400
> From: Jerome Glisse <jglisse@redhat.com>
> To: Kenneth Lee <liguozhu@hisilicon.com>
> CC: Kenneth Lee <nek.in.cn@gmail.com>, Herbert Xu
>  <herbert@gondor.apana.org.au>, kvm@vger.kernel.org, Jonathan Corbet
>  <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg
>  Roedel <joro@8bytes.org>, linux-doc@vger.kernel.org, Sanjay Kumar
>  <sanjay.k.kumar@intel.com>, Hao Fang <fanghao11@huawei.com>,
>  iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
>  linuxarm@huawei.com, Alex Williamson <alex.williamson@redhat.com>, Thomas
>  Gleixner <tglx@linutronix.de>, linux-crypto@vger.kernel.org, Zhou Wang
>  <wangzhou1@hisilicon.com>, Philippe Ombredanne <pombredanne@nexb.com>,
>  Zaibo Xu <xuzaibo@huawei.com>, "David S . Miller" <davem@davemloft.net>,
>  linux-accelerators@lists.ozlabs.org, Lu Baolu <baolu.lu@linux.intel.com>
> Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
> User-Agent: Mutt/1.10.0 (2018-05-17)
> Message-ID: <20180907165303.GA3519@redhat.com>
> 
> On Fri, Sep 07, 2018 at 12:01:38PM +0800, Kenneth Lee wrote:
> > On Thu, Sep 06, 2018 at 09:31:33AM -0400, Jerome Glisse wrote:
> > > Date: Thu, 6 Sep 2018 09:31:33 -0400
> > > From: Jerome Glisse <jglisse@redhat.com>
> > > To: Kenneth Lee <liguozhu@hisilicon.com>
> > > CC: Alex Williamson <alex.williamson@redhat.com>, Kenneth Lee
> > >  <nek.in.cn@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Herbert Xu
> > >  <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
> > >  Joerg Roedel <joro@8bytes.org>, Hao Fang <fanghao11@huawei.com>, Zhou Wang
> > >  <wangzhou1@hisilicon.com>, Zaibo Xu <xuzaibo@huawei.com>, Philippe
> > >  Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman
> > >  <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>,
> > >  linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
> > >  linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
> > >  kvm@vger.kernel.org, linux-accelerators@lists.ozlabs.org, Lu Baolu
> > >  <baolu.lu@linux.intel.com>, Sanjay Kumar <sanjay.k.kumar@intel.com>,
> > >  linuxarm@huawei.com
> > > Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
> > > User-Agent: Mutt/1.10.0 (2018-05-17)
> > > Message-ID: <20180906133133.GA3830@redhat.com>
> > > 
> > > On Thu, Sep 06, 2018 at 05:45:32PM +0800, Kenneth Lee wrote:
> > > > On Tue, Sep 04, 2018 at 10:15:09AM -0600, Alex Williamson wrote:
> > > > > Date: Tue, 4 Sep 2018 10:15:09 -0600
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > To: Jerome Glisse <jglisse@redhat.com>
> > > > > CC: Kenneth Lee <nek.in.cn@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
> > > > >  Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
> > > > >  <davem@davemloft.net>, Joerg Roedel <joro@8bytes.org>, Kenneth Lee
> > > > >  <liguozhu@hisilicon.com>, Hao Fang <fanghao11@huawei.com>, Zhou Wang
> > > > >  <wangzhou1@hisilicon.com>, Zaibo Xu <xuzaibo@huawei.com>, Philippe
> > > > >  Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman
> > > > >  <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>,
> > > > >  linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
> > > > >  linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
> > > > >  kvm@vger.kernel.org, linux-accelerators@lists.ozlabs.org, Lu Baolu
> > > > >  <baolu.lu@linux.intel.com>, Sanjay Kumar <sanjay.k.kumar@intel.com>,
> > > > >  linuxarm@huawei.com
> > > > > Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
> > > > > Message-ID: <20180904101509.62314b67@t450s.home>
> > > > > 
> > > > > On Tue, 4 Sep 2018 11:00:19 -0400
> > > > > Jerome Glisse <jglisse@redhat.com> wrote:
> > > > > 
> > > > > > On Mon, Sep 03, 2018 at 08:51:57AM +0800, Kenneth Lee wrote:
> > > > > > > From: Kenneth Lee <liguozhu@hisilicon.com>
> > > > > > > 
> > > > > > > WarpDrive is an accelerator framework to expose the hardware capabilities
> > > > > > > directly to the user space. It makes use of the exist vfio and vfio-mdev
> > > > > > > facilities. So the user application can send request and DMA to the
> > > > > > > hardware without interaction with the kernel. This removes the latency
> > > > > > > of syscall.
> > > > > > > 
> > > > > > > WarpDrive is the name for the whole framework. The component in kernel
> > > > > > > is called SDMDEV, Share Domain Mediated Device. Driver driver exposes its
> > > > > > > hardware resource by registering to SDMDEV as a VFIO-Mdev. So the user
> > > > > > > library of WarpDrive can access it via VFIO interface.
> > > > > > > 
> > > > > > > The patchset contains document for the detail. Please refer to it for more
> > > > > > > information.
> > > > > > > 
> > > > > > > This patchset is intended to be used with Jean Philippe Brucker's SVA
> > > > > > > patch [1], which enables not only IO side page fault, but also PASID
> > > > > > > support to IOMMU and VFIO.
> > > > > > > 
> > > > > > > With these features, WarpDrive can support non-pinned memory and
> > > > > > > multi-process in the same accelerator device.  We tested it in our SoC
> > > > > > > integrated Accelerator (board ID: D06, Chip ID: HIP08). A reference work
> > > > > > > tree can be found here: [2].
> > > > > > > 
> > > > > > > But it is not mandatory. This patchset is tested in the latest mainline
> > > > > > > kernel without the SVA patches.  So it supports only one process for each
> > > > > > > accelerator.
> > > > > > > 
> > > > > > > We have noticed the IOMMU aware mdev RFC announced recently [3].
> > > > > > > 
> > > > > > > The IOMMU aware mdev has similar idea but different intention comparing to
> > > > > > > WarpDrive. It intends to dedicate part of the hardware resource to a VM.
> > > > > > > And the design is supposed to be used with Scalable I/O Virtualization.
> > > > > > > While sdmdev is intended to share the hardware resource with a big amount
> > > > > > > of processes.  It just requires the hardware supporting address
> > > > > > > translation per process (PCIE's PASID or ARM SMMU's substream ID).
> > > > > > > 
> > > > > > > But we don't see serious confliction on both design. We believe they can be
> > > > > > > normalized as one.
> > > > > > >   
> > > > > > 
> > > > > > So once again i do not understand why you are trying to do things
> > > > > > this way. Kernel already have tons of example of everything you
> > > > > > want to do without a new framework. Moreover i believe you are
> > > > > > confuse by VFIO. To me VFIO is for VM not to create general device
> > > > > > driver frame work.
> > > > > 
> > > > > VFIO is a userspace driver framework, the VM use case just happens to
> > > > > be a rather prolific one.  VFIO was never intended to be solely a VM
> > > > > device interface and has several other userspace users, notably DPDK
> > > > > and SPDK, an NVMe backend in QEMU, a userspace NVMe driver, a ruby
> > > > > wrapper, and perhaps others that I'm not aware of.  Whether vfio is
> > > > > appropriate interface here might certainly still be a debatable topic,
> > > > > but I would strongly disagree with your last sentence above.  Thanks,
> > > > > 
> > > > > Alex
> > > > > 
> > > > 
> > > > Yes, that is also my standpoint here.
> > > > 
> > > > > > So here is your use case as i understand it. You have a device
> > > > > > with a limited number of command queues (can be just one) and in
> > > > > > some case it can support SVA/SVM (when hardware support it and it
> > > > > > is not disabled). Final requirement is being able to schedule cmds
> > > > > > from userspace without ioctl. All of this exists already exists
> > > > > > upstream in few device drivers.
> > > > > > 
> > > > > > 
> > > > > > So here is how every body else is doing it. Please explain why
> > > > > > this does not work.
> > > > > > 
> > > > > > 1 Userspace open device file driver. Kernel device driver create
> > > > > >   a context and associate it with on open. This context can be
> > > > > >   uniq to the process and can bind hardware resources (like a
> > > > > >   command queue) to the process.
> > > > > > 2 Userspace bind/acquire a commands queue and initialize it with
> > > > > >   an ioctl on the device file. Through that ioctl userspace can
> > > > > >   be inform wether either SVA/SVM works for the device. If SVA/
> > > > > >   SVM works then kernel device driver bind the process to the
> > > > > >   device as part of this ioctl.
> > > > > > 3 If SVM/SVA does not work userspace do an ioctl to create dma
> > > > > >   buffer or something that does exactly the same thing.
> > > > > > 4 Userspace mmap the command queue (mmap of the device file by
> > > > > >   using informations gather at step 2)
> > > > > > 5 Userspace can write commands into the queue it mapped
> > > > > > 6 When userspace close the device file all resources are release
> > > > > >   just like any existing device drivers.
> > > > 
> > > > Hi, Jerome,
> > > > 
> > > > Just one thing, as I said in the cover letter, dma-buf requires the application
> > > > to use memory created by the driver for DMA. I did try the dma-buf way in
> > > > WrapDrive (refer to [4] in the cover letter), it is a good backup for NOIOMMU
> > > > mode or we cannot solve the problem in VFIO.
> > > > 
> > > > But, in many of my application scenario, the application already has some memory
> > > > in hand, maybe allocated by the framework or libraries. Anyway, they don't get
> > > > memory from my library, and they pass the poiter for data operation. And they
> > > > may also have pointer in the buffer. Those pointer may be used by the
> > > > accelerator. So I need hardware fully share the address space with the
> > > > application. That is what dmabuf cannot do.
> > > 
> > > dmabuf can do that ... it is call uptr you can look at i915 for
> > > instance. Still this does not answer my question above, why do
> > > you need to be in VFIO to do any of the above thing ? Kernel has
> > > tons of examples that does all of the above and are not in VFIO
> > > (including usinng existing user pointer with device).
> > > 
> > > Cheers,
> > > Jérôme
> > 
> > I took a look at i915_gem_execbuffer_ioctl(). It seems it "copy_from_user" the
> > user memory to the kernel. That is not what we need. What we try to get is: the
> > user application do something on its data, and push it away to the accelerator,
> > and says: "I'm tied, it is your turn to do the job...". Then the accelerator has
> > the memory, referring any portion of it with the same VAs of the application,
> > even the VAs are stored inside the memory itself.
> 
> You were not looking at right place see drivers/gpu/drm/i915/i915_gem_userptr.c
> It does GUP and create GEM object AFAICR you can wrap that GEM object into a
> dma buffer object.
> 

Thank you for directing me to this implementation. It is interesting:).

But it is not yet solve my problem. If I understand it right, the userptr in
i915 do the following:

1. The user process sets a user pointer with size to the kernel via ioctl.
2. The kernel wraps it as a dma-buf and keeps the process's mm for further
   reference.
3. The user pages are allocated, GUPed or DMA mapped to the device. So the data
   can be shared between the user space and the hardware.

But my scenario is: 

1. The user process has some data in the user space, pointed by a pointer, say
   ptr1. And within the memory, there may be some other pointers, let's say one
   of them is ptr2.
2. Now I need to assign ptr1 *directly* to the hardware MMIO space. And the
   hardware must refer ptr1 and ptr2 *directly* for data.

Userptr lets the hardware and process share the same memory space. But I need
them to share the same *address space*. So IOMMU is a MUST for WarpDrive,
NOIOMMU mode, as Jean said, is just for verifying some of the procedure is OK.

> > 
> > And I don't understand why I should avoid to use VFIO? As Alex said, VFIO is the
> > user driver framework. And I need exactly a user driver interface. Why should I
> > invent another wheel? It has most of stuff I need:
> > 
> > 1. Connecting multiple devices to the same application space
> > 2. Pinning and DMA from the application space to the whole set of device
> > 3. Managing hardware resource by device
> > 
> > We just need the last step: make sure multiple applications and the kernel can
> > share the same IOMMU. Then why shouldn't we use VFIO?
> 
> Because tons of other drivers already do all of the above outside VFIO. Many
> driver have a sizeable userspace side to them (anything with ioctl do) so they
> can be construded as userspace driver too.
> 

Ignoring if there are *tons* of drivers are doing that;), even I do the same as
i915 and solve the address space problem. And if I don't need to with VFIO, why
should I spend so much effort to do it again?

> So there is no reasons to do that under VFIO. Especialy as in your example
> it is not a real user space device driver, the userspace portion only knows
> about writting command into command buffer AFAICT.
> 
> VFIO is for real userspace driver where interrupt, configurations, ... ie
> all the driver is handled in userspace. This means that the userspace have
> to be trusted as it could program the device to do DMA to anywhere (if
> IOMMU is disabled at boot which is still the default configuration in the
> kernel).
> 

But as Alex explained, VFIO is not simply used by VM. So it need not to have all
stuffs as a driver in host system. And I do need to share the user space as DMA
buffer to the hardware. And I can get it with just a little update, then it can
service me perfectly. I don't understand why I should choose a long route.

> So i do not see any reasons to do anything you want inside VFIO. All you
> want to do can be done outside as easily. Moreover it would be better if
> you define clearly each scenario because from where i sit it looks like
> you are opening the door wide open to userspace to DMA anywhere when IOMMU
> is disabled.
> 
> When IOMMU is disabled you can _not_ expose command queue to userspace
> unless your device has its own page table and all commands are relative
> to that page table and the device page table is populated by kernel driver
> in secure way (ie by checking that what is populated can be access).
> 
> I do not believe your example device to have such page table nor do i see
> a fallback path when IOMMU is disabled that force user to do ioctl for
> each commands.
> 
> Yes i understand that you target SVA/SVM but still you claim to support
> non SVA/SVM. The point is that userspace can not be trusted if you want
> to have random program use your device. I am pretty sure that all user
> of VFIO are trusted process (like QEMU).
> 
> 
> Finaly i am convince that the IOMMU grouping stuff related to VFIO is
> useless for your usecase. I really do not see the point of that, it
> does complicate things for you for no reasons AFAICT.

Indeed, I don't like the group thing. I believe VFIO's maintains would not like
it very much either;). But the problem is, the group reflects to the same
IOMMU(unit), which may shared with other devices.  It is a security problem. I
cannot ignore it. I have to take it into account event I don't use VFIO.

> 
> 
> > 
> > And personally, I believe the maturity and correctness of a framework are driven
> > by applications. Now the problem in accelerator world is that we don't have a
> > direction. If we believe the requirement is right, the method itself is not a
> > big problem in the end. We just need to let people have a unify platform to
> > share their work together.
> 
> I am not against that but it seems to me that all you want to do is only
> a matter of simplifying discovery of such devices and sharing few common
> ioctl (DMA mapping, creating command queue, managing command queue, ...)
> and again for all this i do not see the point of doing this under VFIO.

It is not a problem of device management, it is a problem of sharing address
space.

Cheers,

> 
> 
> Cheers,
> Jérôme

-- 
			-Kenneth(Hisilicon)
