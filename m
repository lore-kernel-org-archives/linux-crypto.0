From: Kenneth Lee <liguozhu@hisilicon.com>
Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Thu, 9 Aug 2018 16:03:52 +0800
Message-ID: <20180809080352.GI91035@Turing-Arch-b>
References: <20180801165644.GA3820@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D191290E1A@SHSMSX101.ccr.corp.intel.com>
 <20180802040557.GL160746@Turing-Arch-b>
 <20180802142243.GA3481@redhat.com>
 <20180803034721.GC91035@Turing-Arch-b>
 <20180803143944.GA4079@redhat.com>
 <20180806031252.GG91035@Turing-Arch-b>
 <20180806153257.GB6002@redhat.com>
 <11bace0e-dc14-5d2c-f65c-25b852f4e9ca@gmail.com>
 <20180808151835.GA3429@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Kenneth Lee <nek.in.cn@gmail.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        Hao Fang <fanghao11@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Philippe Ombredanne" <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@li
To: Jerome Glisse <jglisse@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180808151835.GA3429@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 08, 2018 at 11:18:35AM -0400, Jerome Glisse wrote:
> Date: Wed, 8 Aug 2018 11:18:35 -0400
> From: Jerome Glisse <jglisse@redhat.com>
> To: Kenneth Lee <nek.in.cn@gmail.com>
> CC: Kenneth Lee <liguozhu@hisilicon.com>, "Tian, Kevin"
>  <kevin.tian@intel.com>, Alex Williamson <alex.williamson@redhat.com>,
>  Herbert Xu <herbert@gondor.apana.org.au>, "kvm@vger.kernel.org"
>  <kvm@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Greg
>  Kroah-Hartman <gregkh@linuxfoundation.org>, Zaibo Xu <xuzaibo@huawei.com>,
>  "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "Kumar, Sanjay K"
>  <sanjay.k.kumar@intel.com>, Hao Fang <fanghao11@huawei.com>,
>  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
>  "linuxarm@huawei.com" <linuxarm@huawei.com>,
>  "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
>  "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Philippe
>  Ombredanne <pombredanne@nexb.com>, Thomas Gleixner <tglx@linutronix.de>,
>  "David S . Miller" <davem@davemloft.net>,
>  "linux-accelerators@lists.ozlabs.org"
>  <linux-accelerators@lists.ozlabs.org>
> Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
> User-Agent: Mutt/1.10.0 (2018-05-17)
> Message-ID: <20180808151835.GA3429@redhat.com>
> 
> On Wed, Aug 08, 2018 at 09:08:42AM +0800, Kenneth Lee wrote:
> > 
> > 
> > 在 2018年08月06日 星期一 11:32 下午, Jerome Glisse 写道:
> > > On Mon, Aug 06, 2018 at 11:12:52AM +0800, Kenneth Lee wrote:
> > > > On Fri, Aug 03, 2018 at 10:39:44AM -0400, Jerome Glisse wrote:
> > > > > On Fri, Aug 03, 2018 at 11:47:21AM +0800, Kenneth Lee wrote:
> > > > > > On Thu, Aug 02, 2018 at 10:22:43AM -0400, Jerome Glisse wrote:
> > > > > > > On Thu, Aug 02, 2018 at 12:05:57PM +0800, Kenneth Lee wrote:
> > > > > > > > On Thu, Aug 02, 2018 at 02:33:12AM +0000, Tian, Kevin wrote:
> > > > > > > > > > On Wed, Aug 01, 2018 at 06:22:14PM +0800, Kenneth Lee wrote:
> 
> [...]
> 
> > > > > > > > > > My more general question is do we want to grow VFIO to become
> > > > > > > > > > a more generic device driver API. This patchset adds a command
> > > > > > > > > > queue concept to it (i don't think it exist today but i have
> > > > > > > > > > not follow VFIO closely).
> > > > > > > > > > 
> > > > > > > > The thing is, VFIO is the only place to support DMA from user land. If we don't
> > > > > > > > put it here, we have to create another similar facility to support the same.
> > > > > > > No it is not, network device, GPU, block device, ... they all do
> > > > > > > support DMA. The point i am trying to make here is that even in
> > > > > > Sorry, wait a minute, are we talking the same thing? I meant "DMA from user
> > > > > > land", not "DMA from kernel driver". To do that we have to manipulate the
> > > > > > IOMMU(Unit). I think it can only be done by default_domain or vfio domain. Or
> > > > > > the user space have to directly access the IOMMU.
> > > > > GPU do DMA in the sense that you pass to the kernel a valid
> > > > > virtual address (kernel driver do all the proper check) and
> > > > > then you can use the GPU to copy from or to that range of
> > > > > virtual address. Exactly how you want to use this compression
> > > > > engine. It does not rely on SVM but SVM going forward would
> > > > > still be the prefered option.
> > > > > 
> > > > No, SVM is not the reason why we rely on Jean's SVM(SVA) series. We rely on
> > > > Jean's series because of multi-process (PASID or substream ID) support.
> > > > 
> > > > But of couse, WarpDrive can still benefit from the SVM feature.
> > > We are getting side tracked here. PASID/ID do not require VFIO.
> > > 
> > Yes, PASID itself do not require VFIO. But what if:
> > 
> > 1. Support DMA from user space.
> > 2. The hardware makes use of standard IOMMU/SMMU for IO address translation.
> > 3. The IOMMU facility is shared by both kernel and user drivers.
> > 4. Support PASID with the current IOMMU facility
> 
> I do not see how any of this means it has to be in VFIO.
> Other devices do just that. GPUs driver for instance share
> DMA engine (that copy data around) between kernel and user
> space. Sometime kernel use it to move things around. Evict
> some memory to make room for a new process is the common
> example. Same DMA engines is often use by userspace itself
> during rendering or compute (program moving things on there
> own). So they are already kernel driver that do all 4 of
> the above and are not in VFIO.
> 

I think our divergence is on "it is common that some device drivers use IOMMU
for user land DMA operation". Let us dive into this in the AMD case.

> 
> > > > > > > your mechanisms the userspace must have a specific userspace
> > > > > > > drivers for each hardware and thus there are virtually no
> > > > > > > differences between having this userspace driver open a device
> > > > > > > file in vfio or somewhere else in the device filesystem. This is
> > > > > > > just a different path.
> > > > > > > 
> > > > > > The basic problem WarpDrive want to solve it to avoid syscall. This is important
> > > > > > to accelerators. We have some data here:
> > > > > > https://www.slideshare.net/linaroorg/progress-and-demonstration-of-wrapdrive-a-accelerator-framework-sfo17317
> > > > > > 
> > > > > > (see page 3)
> > > > > > 
> > > > > > The performance is different on using kernel and user drivers.
> > > > > Yes and example i point to is exactly that. You have a one time setup
> > > > > cost (creating command buffer binding PASID with command buffer and
> > > > > couple other setup steps). Then userspace no longer have to do any
> > > > > ioctl to schedule work on the GPU. It is all down from userspace and
> > > > > it use a doorbell to notify hardware when it should go look at command
> > > > > buffer for new thing to execute.
> > > > > 
> > > > > My point stands on that. You have existing driver already doing so
> > > > > with no new framework and in your scheme you need a userspace driver.
> > > > > So i do not see the value add, using one path or the other in the
> > > > > userspace driver is litteraly one line to change.
> > > > > 
> > > > Sorry, I'd got confuse here. I partially agree that the user driver is
> > > > redundance of kernel driver. (But for WarpDrive, the kernel driver is a full
> > > > driver include all preparation and setup stuff for the hardware, the user driver
> > > > is simply to send request and receive answer). Yes, it is just a choice of path.
> > > > But the user path is faster if the request come from use space. And to do that,
> > > > we need user land DMA support. Then why is it invaluable to let VFIO involved?
> > > Some drivers in the kernel already do exactly what you said. The user
> > > space emit commands without ever going into kernel by directly scheduling
> > > commands and ringing a doorbell. They do not need VFIO either and they
> > > can map userspace address into the DMA address space of the device and
> > > again they do not need VFIO for that.
> > Could you please directly point out which driver you refer to here? Thank
> > you.
> 
> drivers/gpu/drm/amd/
> 
> Sub-directory of interest is amdkfd
> 
> Because it is a big driver here is a highlevel overview of how it works
> (this is a simplification):
>   - Process can allocate GPUs buffer (through ioclt) and map them into
>     its address space (through mmap of device file at buffer object
>     specific offset).
>   - Process can map any valid range of virtual address space into device
>     address space (IOMMU mapping). This must be regular memory ie not an
>     mmap of a device file or any special file (this is the non PASID
>     path)
>   - Process can create a command queue and bind its process to it aka
>     PASID, this is done through an ioctl.
>   - Process can schedule commands onto queues it created from userspace
>     without ioctl. For that it just write command into a ring buffer
>     that it mapped during the command queue creation process and it
>     rings a doorbell when commands are ready to be consume by the
>     hardware.
>   - Commands can reference (access) all 3 types of object above ie
>     either full GPUs buffer, process regular memory maped as object
>     (non PASID) and PASID memory all at the same time ie you can
>     mix all of the above in same commands queue.
>   - Kernel can evict, unbind any process command queues, unbind commands
>     queue are still valid from process point of view but commands
>     process schedules on them will not be executed until kernel re-bind
>     the queue.
>   - Kernel can schedule commands itself onto its dedicated command
>     queues (kernel driver create its own command queues).
>   - Kernel can control priorities between all the queues ie it can
>     decides which queues should the hardware executed first next.
> 

Thank you. Now I think I understand the point. Indeed, I can see some drivers,
such GPU and IB, attach their own iommu_domain to their iommu_group and do their
own iommu_map().

But we have another requirement which is to combine some device together to
share the same address space. This is a little like these kinds of solution:

http://tce.technion.ac.il/wp-content/uploads/sites/8/2015/06/SC-7.2-M.-Silberstein.pdf

With that, the application can directly pass the NiC packet pointer to the
decryption accelerator, and get the bare data in place. This is the feature that
the VFIO container can provide.

> I believe all of the above are the aspects that matters to you. The main
> reason i don't like creating a new driver infrastructure is that a lot
> of existing drivers will want to use some of the new features that are
> coming (memory topology, where to place process memory, pipeline devices,
> ...) and thus existing drivers are big (GPU drivers are the biggest of
> all the kernel drivers).
> 

I think it is not necessarily to rewrite the GPU driver if they don't need to
share their space with others. But if they do, no matter how, they have to create
some facility similar to VFIO container. Then why not just create them in VFIO?

Actually, some GPUs have already used mdev to manage the resource by different
users, it is already part of VFIO.

> So rewritting those existing drivers into VFIO or into any new infra-
> structure so that they can leverage new features is a no go from my
> point of view.
> 
> I would rather see a set of helpers so that each features can be use
> either by new drivers or existing drivers. For instance a new way to
> expose memory topology. A new way to expose how you can pipe devices
> from one to another ...
> 
> 
> Hence i do not see any value in a whole new infra-structure in which
> drivers must be part of to leverage new features.
> 
> Cheers,
> Jérôme

-- 
			-Kenneth(Hisilicon)

================================================================================
本邮件及其附件含有华为公司的保密信息，仅限于发送给上面地址中列出的个人或群组。禁
止任何其他人以任何形式使用（包括但不限于全部或部分地泄露、复制、或散发）本邮件中
的信息。如果您错收了本邮件，请您立即电话或邮件通知发件人并删除本邮件！
This e-mail and its attachments contain confidential information from HUAWEI,
which is intended only for the person or entity whose address is listed above.
Any use of the 
information contained herein in any way (including, but not limited to, total or
partial disclosure, reproduction, or dissemination) by persons other than the
intended 
recipient(s) is prohibited. If you receive this e-mail in error, please notify
the sender by phone or email immediately and delete it!
