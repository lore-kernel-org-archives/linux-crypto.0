From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Fri, 10 Aug 2018 10:32:31 -0400
Message-ID: <20180810143231.GA7253@redhat.com>
References: <20180802142243.GA3481@redhat.com>
 <20180803034721.GC91035@Turing-Arch-b>
 <20180803143944.GA4079@redhat.com>
 <20180806031252.GG91035@Turing-Arch-b>
 <20180806153257.GB6002@redhat.com>
 <11bace0e-dc14-5d2c-f65c-25b852f4e9ca@gmail.com>
 <20180808151835.GA3429@redhat.com>
 <20180809080352.GI91035@Turing-Arch-b>
 <20180809144613.GB3386@redhat.com>
 <20180810033913.GK91035@Turing-Arch-b>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
        Philippe Ombredanne <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@linu
To: Kenneth Lee <liguozhu@hisilicon.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180810033913.GK91035@Turing-Arch-b>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 10, 2018 at 11:39:13AM +0800, Kenneth Lee wrote:
> On Thu, Aug 09, 2018 at 10:46:13AM -0400, Jerome Glisse wrote:
> > Date: Thu, 9 Aug 2018 10:46:13 -0400
> > From: Jerome Glisse <jglisse@redhat.com>
> > To: Kenneth Lee <liguozhu@hisilicon.com>
> > CC: Kenneth Lee <nek.in.cn@gmail.com>, "Tian, Kevin"
> >  <kevin.tian@intel.com>, Alex Williamson <alex.williamson@redhat.com>,
> >  Herbert Xu <herbert@gondor.apana.org.au>, "kvm@vger.kernel.org"
> >  <kvm@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Greg
> >  Kroah-Hartman <gregkh@linuxfoundation.org>, Zaibo Xu <xuzaibo@huawei.com>,
> >  "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "Kumar, Sanjay K"
> >  <sanjay.k.kumar@intel.com>, Hao Fang <fanghao11@huawei.com>,
> >  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
> >  "linuxarm@huawei.com" <linuxarm@huawei.com>,
> >  "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
> >  "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Philippe
> >  Ombredanne <pombredanne@nexb.com>, Thomas Gleixner <tglx@linutronix.de>,
> >  "David S . Miller" <davem@davemloft.net>,
> >  "linux-accelerators@lists.ozlabs.org"
> >  <linux-accelerators@lists.ozlabs.org>
> > Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
> > User-Agent: Mutt/1.10.0 (2018-05-17)
> > Message-ID: <20180809144613.GB3386@redhat.com>
> > 
> > On Thu, Aug 09, 2018 at 04:03:52PM +0800, Kenneth Lee wrote:
> > > On Wed, Aug 08, 2018 at 11:18:35AM -0400, Jerome Glisse wrote:
> > > > On Wed, Aug 08, 2018 at 09:08:42AM +0800, Kenneth Lee wrote:
> > > > > 在 2018年08月06日 星期一 11:32 下午, Jerome Glisse 写道:
> > > > > > On Mon, Aug 06, 2018 at 11:12:52AM +0800, Kenneth Lee wrote:
> > > > > > > On Fri, Aug 03, 2018 at 10:39:44AM -0400, Jerome Glisse wrote:
> > > > > > > > On Fri, Aug 03, 2018 at 11:47:21AM +0800, Kenneth Lee wrote:
> > > > > > > > > On Thu, Aug 02, 2018 at 10:22:43AM -0400, Jerome Glisse wrote:
> > > > > > > > > > On Thu, Aug 02, 2018 at 12:05:57PM +0800, Kenneth Lee wrote:
> > 
> > [...]
> > 
> > > > > > > > > > your mechanisms the userspace must have a specific userspace
> > > > > > > > > > drivers for each hardware and thus there are virtually no
> > > > > > > > > > differences between having this userspace driver open a device
> > > > > > > > > > file in vfio or somewhere else in the device filesystem. This is
> > > > > > > > > > just a different path.
> > > > > > > > > > 
> > > > > > > > > The basic problem WarpDrive want to solve it to avoid syscall. This is important
> > > > > > > > > to accelerators. We have some data here:
> > > > > > > > > https://www.slideshare.net/linaroorg/progress-and-demonstration-of-wrapdrive-a-accelerator-framework-sfo17317
> > > > > > > > > 
> > > > > > > > > (see page 3)
> > > > > > > > > 
> > > > > > > > > The performance is different on using kernel and user drivers.
> > > > > > > > Yes and example i point to is exactly that. You have a one time setup
> > > > > > > > cost (creating command buffer binding PASID with command buffer and
> > > > > > > > couple other setup steps). Then userspace no longer have to do any
> > > > > > > > ioctl to schedule work on the GPU. It is all down from userspace and
> > > > > > > > it use a doorbell to notify hardware when it should go look at command
> > > > > > > > buffer for new thing to execute.
> > > > > > > > 
> > > > > > > > My point stands on that. You have existing driver already doing so
> > > > > > > > with no new framework and in your scheme you need a userspace driver.
> > > > > > > > So i do not see the value add, using one path or the other in the
> > > > > > > > userspace driver is litteraly one line to change.
> > > > > > > > 
> > > > > > > Sorry, I'd got confuse here. I partially agree that the user driver is
> > > > > > > redundance of kernel driver. (But for WarpDrive, the kernel driver is a full
> > > > > > > driver include all preparation and setup stuff for the hardware, the user driver
> > > > > > > is simply to send request and receive answer). Yes, it is just a choice of path.
> > > > > > > But the user path is faster if the request come from use space. And to do that,
> > > > > > > we need user land DMA support. Then why is it invaluable to let VFIO involved?
> > > > > > Some drivers in the kernel already do exactly what you said. The user
> > > > > > space emit commands without ever going into kernel by directly scheduling
> > > > > > commands and ringing a doorbell. They do not need VFIO either and they
> > > > > > can map userspace address into the DMA address space of the device and
> > > > > > again they do not need VFIO for that.
> > > > > Could you please directly point out which driver you refer to here? Thank
> > > > > you.
> > > > 
> > > > drivers/gpu/drm/amd/
> > > > 
> > > > Sub-directory of interest is amdkfd
> > > > 
> > > > Because it is a big driver here is a highlevel overview of how it works
> > > > (this is a simplification):
> > > >   - Process can allocate GPUs buffer (through ioclt) and map them into
> > > >     its address space (through mmap of device file at buffer object
> > > >     specific offset).
> > > >   - Process can map any valid range of virtual address space into device
> > > >     address space (IOMMU mapping). This must be regular memory ie not an
> > > >     mmap of a device file or any special file (this is the non PASID
> > > >     path)
> > > >   - Process can create a command queue and bind its process to it aka
> > > >     PASID, this is done through an ioctl.
> > > >   - Process can schedule commands onto queues it created from userspace
> > > >     without ioctl. For that it just write command into a ring buffer
> > > >     that it mapped during the command queue creation process and it
> > > >     rings a doorbell when commands are ready to be consume by the
> > > >     hardware.
> > > >   - Commands can reference (access) all 3 types of object above ie
> > > >     either full GPUs buffer, process regular memory maped as object
> > > >     (non PASID) and PASID memory all at the same time ie you can
> > > >     mix all of the above in same commands queue.
> > > >   - Kernel can evict, unbind any process command queues, unbind commands
> > > >     queue are still valid from process point of view but commands
> > > >     process schedules on them will not be executed until kernel re-bind
> > > >     the queue.
> > > >   - Kernel can schedule commands itself onto its dedicated command
> > > >     queues (kernel driver create its own command queues).
> > > >   - Kernel can control priorities between all the queues ie it can
> > > >     decides which queues should the hardware executed first next.
> > > > 
> > > 
> > > Thank you. Now I think I understand the point. Indeed, I can see some drivers,
> > > such GPU and IB, attach their own iommu_domain to their iommu_group and do their
> > > own iommu_map().
> > > 
> > > But we have another requirement which is to combine some device together to
> > > share the same address space. This is a little like these kinds of solution:
> > > 
> > > http://tce.technion.ac.il/wp-content/uploads/sites/8/2015/06/SC-7.2-M.-Silberstein.pdf
> > > 
> > > With that, the application can directly pass the NiC packet pointer to the
> > > decryption accelerator, and get the bare data in place. This is the feature that
> > > the VFIO container can provide.
> > 
> > Yes and GPU would very much like do the same. There is already out of
> > tree solution that allow NiC to stream into GPU memory or GPU to stream
> > its memory to a NiC. I am sure we will want to use more accelerator in
> > conjunction with GPU in the future.
> > 
> > > 
> > > > I believe all of the above are the aspects that matters to you. The main
> > > > reason i don't like creating a new driver infrastructure is that a lot
> > > > of existing drivers will want to use some of the new features that are
> > > > coming (memory topology, where to place process memory, pipeline devices,
> > > > ...) and thus existing drivers are big (GPU drivers are the biggest of
> > > > all the kernel drivers).
> > > > 
> > > 
> > > I think it is not necessarily to rewrite the GPU driver if they don't need to
> > > share their space with others. But if they do, no matter how, they have to create
> > > some facility similar to VFIO container. Then why not just create them in VFIO?
> > 
> > No they do not, nor does anyone needs to. We already have that. If you want
> > device to share memory object you have either:
> >     - PASID and everything is just easy no need to create anything, as
> >       all valid virtual address will work
> >     - no PASID or one of the device does not support PASID then use the
> >       existing kernel infrastructure aka dma buffer see Documentation/
> >       driver-api/dma-buf.rst
> > 
> > Everything you want to do is already happening upstream and they are allready
> > working example.
> 
> OK, I accept it.
> 
> > 
> > > Actually, some GPUs have already used mdev to manage the resource by different
> > > users, it is already part of VFIO.
> > 
> > The current use of mdev with GPU is to "emulate" the SR_IOV of PCIE in
> > software so that a single device can be share between multiple guests.
> > For this using VFIO make sense, as we want to expose device as a single
> > entity that can be manage without the userspace (QEMU) having to know
> > or learn about each individual devices.
> > 
> > QEMU just has a well define API to probe and attach device to guest.
> > It is the guest that have dedicated drivers for each of those mdev
> > devices.
> > 
> 
> Agree
> 
> > 
> > What you are trying to do is recreate a whole driver API inside the
> > VFIO subsystem and i do not see any valid reasons for that. Moreover
> > you want to restrict future use to only drivers that are part of this
> > new driver subsystem and again i do not see any good reasons to
> > mandate any of the existing driver to be rewritten inside a new VFIO
> > infrastructure.
> > 
> 
> I think you have persuaded me now. I thought VFIO was the only unified place to do
> user land DMA operations. So I tried to make use of it even there was facility I
> needed not.
> 
> Thank you very much for the help.
> 
> > 
> > You can achieve everything you want to achieve with existing upstream
> > solution. Re-inventing a whole new driver infrastructure should really
> > be motivated with strong and obvious reasons.
> 
> I want to understand better of your idea. If I create some unified helper
> APIs in drivers/iommu/, say:
> 
> 	wd_create_dev(parent_dev, wd_dev)
> 	wd_release_dev(wd_dev)
> 
> The API create chrdev to take request from user space for open(resource
> allocation), iomap, epoll (irq), and dma_map(with pasid automatically).
> 
> Do you think it is acceptable?
> 
> I agree that these all can be done with the driver itself. But without a unified
> interface, it is hard to create a user land ecosystem for accelerator to
> cooperate.

I am fine with creating a new sub-system for pipelining devices (ie some
place where it is easy for userspace to get list of all devices that can
fit in such model). I am not sure if we want to have everything part of
it (ie DMA mapping of memory and pipelining as same thing) i tend to be
more unix oriented one tool for one job. But maybe it makes sense, this
would likely avoid having each device driver have their own code to
create dma buffer or track SVM pointer.

In any case for the non SVM case i would suggest to use dma buffer, it
has been widely use, it is well tested in many scenarios. Moreover it
would allow many existing device driver to register themself in this
new framework with minimal changes (couple hundred lines).

Cheers,
Jérôme
