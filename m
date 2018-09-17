From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Mon, 17 Sep 2018 08:37:45 -0400
Message-ID: <20180917123744.GA3605@redhat.com>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
 <20180917014244.GA27596@redhat.com>
 <20180917083940.GE207969@Turing-Arch-b>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Kenneth Lee <nek.in.cn@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, linux-doc@vger.kernel.org,
        Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Hao Fang <fanghao11@huawei.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, Alex Williamson <alex.williamson@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, Zhou Wang <wangzhou1@hisilicon.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-accelerators@lists.ozlabs.org,
        Lu Baolu <baolu.lu@linux.intel.com>
To: Kenneth Lee <liguozhu@hisilicon.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180917083940.GE207969@Turing-Arch-b>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 17, 2018 at 04:39:40PM +0800, Kenneth Lee wrote:
> On Sun, Sep 16, 2018 at 09:42:44PM -0400, Jerome Glisse wrote:
> > So i want to summarize issues i have as this threads have dig deep into
> > details. For this i would like to differentiate two cases first the easy
> > one when relying on SVA/SVM. Then the second one when there is no SVA/SVM.
> 
> Thank you very much for the summary.
> 
> > In both cases your objectives as i understand them:
> > 
> > [R1]- expose a common user space API that make it easy to share boiler
> >       plate code accross many devices (discovering devices, opening
> >       device, creating context, creating command queue ...).
> > [R2]- try to share the device as much as possible up to device limits
> >       (number of independant queues the device has)
> > [R3]- minimize syscall by allowing user space to directly schedule on the
> >       device queue without a round trip to the kernel
> > 
> > I don't think i missed any.
> > 
> > 
> > (1) Device with SVA/SVM
> > 
> > For that case it is easy, you do not need to be in VFIO or part of any
> > thing specific in the kernel. There is no security risk (modulo bug in
> > the SVA/SVM silicon). Fork/exec is properly handle and binding a process
> > to a device is just couple dozen lines of code.
> > 
> 
> This is right...logically. But the kernel has no clear definition about "Device
> with SVA/SVM" and no boiler plate for doing so. Then VFIO may become one of the
> boiler plate.
> 
> VFIO is one of the wrappers for IOMMU for user space. And maybe it is the only
> one. If we add that support within VFIO, which solve most of the problem of
> SVA/SVM, it will save a lot of work in the future.

You do not need to "wrap" IOMMU for SVA/SVM. Existing upstream SVA/SVM user
all do the SVA/SVM setup in couple dozen lines and i failed to see how it
would require any more than that in your case.


> I think this is the key confliction between us. So could Alex please say
> something here? If the VFIO is going to take this into its scope, we can try
> together to solve all the problem on the way. If it it is not, it is also
> simple, we can just go to another way to fulfill this part of requirements even
> we have to duplicate most of the code.
> 
> Another point I need to emphasis here: because we have to replace the hardware
> queue when fork, so it won't be very simple even in SVA/SVM case.

I am assuming hardware queue can only be setup by the kernel and thus
you are totaly safe forkwise as the queue is setup against a PASID and
the child does not bind to any PASID and you use VM_DONTCOPY on the
mmap of the hardware MMIO queue because you should really use that flag
for that.


> > (2) Device does not have SVA/SVM (or it is disabled)
> > 
> > You want to still allow device to be part of your framework. However
> > here i see fundamentals securities issues and you move the burden of
> > being careful to user space which i think is a bad idea. We should
> > never trus the userspace from kernel space.
> > 
> > To keep the same API for the user space code you want a 1:1 mapping
> > between device physical address and process virtual address (ie if
> > device access device physical address A it is accessing the same
> > memory as what is backing the virtual address A in the process.
> > 
> > Security issues are on two things:
> > [I1]- fork/exec, a process who opened any such device and created an
> >       active queue can transfer without its knowledge control of its
> >       commands queue through COW. The parent map some anonymous region
> >       to the device as a command queue buffer but because of COW the
> >       parent can be the first to copy on write and thus the child can
> >       inherit the original pages that are mapped to the hardware.
> >       Here parent lose control and child gain it.
> 
> This is indeed an issue. But it remains an issue only if you continue to use the
> queue and the memory after fork. We can use at_fork kinds of gadget to fix it in
> user space.

Trusting user space is a no go from my point of view.


> From some perspectives, I think the issue can be solved by iommu_notifier. For
> example, when the process is fork-ed, we can set the mapped device mmio space as
> COW for the child process, so a new queue can be created and set to the same
> state as the parent's if the space is accessed. Then we can have two separated
> queues for both the parent and the child. The memory part can be done in the
> same way.

The mmap of mmio space for the queue is not an issue just use VM_DONTCOPY
for it. Issue is with COW and IOMMU mapping of pages and this can not be
solve in your model.

> The thing is, the same strategy can be applied to VFIO without changing its
> original feature.

No it can not it would break existing VFIO contract (which only should be
use against private anonymous vma).

> 
> > 
> > [I2]- Because of [R3] you want to allow userspace to schedule commands
> >       on the device without doing an ioctl and thus here user space
> >       can schedule any commands to the device with any address. What
> >       happens if that address have not been mapped by the user space
> >       is undefined and in fact can not be defined as what each IOMMU
> >       does on invalid address access is different from IOMMU to IOMMU.
> > 
> >       In case of a bad IOMMU, or simply an IOMMU improperly setup by
> >       the kernel, this can potentialy allow user space to DMA anywhere.
> 
> I don't think this is an issue. If you cannot trust IOMMU and proper setup of
> IOMMU in kernel, you cannot trust anything. And the whole VFIO framework is
> untrustable.

VFIO device is usualy restricted to trusted user and other device that
do DMA do various checks to make sure user space can not abuse them, the
assumption i have always seen so far is to not trust that IOMMU will do
all the work. So exposing user space access to device with DMA capabilities
should be done carefuly IMHO.

To be thorough list of potential bugs i am concern about:
    - IOMMU hardware bug
    - IOMMU does not isolate device after too many fail attempt
    - firmware setup the IOMMU in some unsafe way and linux kernel does
      not catch that (like passthrough on error or when there is no
      entry for the PA which i am told is a thing for debug)
    - bug in the linux IOMMU kernel driver



> > 
> > [I3]- By relying on GUP in VFIO you are not abiding by the implicit
> >       contract (at least i hope it is implicit) that you should not
> >       try to map to the device any file backed vma (private or share).
> > 
> >       The VFIO code never check the vma controlling the addresses that
> >       are provided to VFIO_IOMMU_MAP_DMA ioctl. Which means that the
> >       user space can provide file backed range.
> > 
> >       I am guessing that the VFIO code never had any issues because its
> >       number one user is QEMU and QEMU never does that (and that's good
> >       as no one should ever do that).
> > 
> >       So if process does that you are opening your self to serious file
> >       system corruption (depending on file system this can lead to total
> >       data loss for the filesystem).
> > 
> >       Issue is that once you GUP you never abide to file system flushing
> >       which write protect the page before writing to the disk. So
> >       because the page is still map with write permission to the device
> >       (assuming VFIO_IOMMU_MAP_DMA was a write map) then the device can
> >       write to the page while it is in the middle of being written back
> >       to disk. Consult your nearest file system specialist to ask him
> >       how bad that can be.
> 
> Same as I2, it is an issue, but the problem can be solved in VFIO if we really
> take it in the scope of VFIO.

Except it can not be solve without breaking VFIO. If you use mmu_notifier
it means that the the IOMMU mapping can vanish at _any_ time and because
you allow user space to directly schedule work on the hardware command
queue than you do not have any synchronization point to use.

When notifier calls you must stop all hardware access and wait for any
pending work that might still dereference affected range. Finaly you can
restore mapping only once the notifier is done. AFAICT this would break
all existing VFIO user.

So solving that for your case it means you would have to:
warp_invalidate_range_callback() {
    - take some lock to protect against restore
    - unmap the command queue (zap_range) from userspace to stop further
      commands
    - wait for any pending commands on the hardware to complete
    - clear all IOMMU mappings for the range
    - put_pages()
    - drop restore lock
    return to let invalidation complete its works
}

warp_restore() {
    // This is call by the page fault handler on the command queue mapped
    // to user space.
    - take restore lock
    - go over all IOMMU mapping and restore them (GUP)
    - remap command queue to userspace
    - drop restore lock
}

This model does not work for VFIO existing users AFAICT.


> > [I4]- Design issue, mdev design As Far As I Understand It is about
> >       sharing a single device to multiple clients (most obvious case
> >       here is again QEMU guest). But you are going against that model,
> >       in fact AFAIUI you are doing the exect opposite. When there is
> >       no SVA/SVM you want only one mdev device that can not be share.
> 
> Wait. It is NOT "I want only one mdev device when there is no SVA/SVM", it is "I
> can support only one mdev when there is no PASID support for the IOMMU".

Except you can support more than one user when no SVA/SVM with the model
i outlined below.


> > 
> >       So this is counter intuitive to the mdev existing design. It is
> >       not about sharing device among multiple users but about giving
> >       exclusive access to the device to one user.
> > 
> > 
> > 
> > All the reasons above is why i believe a different model would serve
> > you and your user better. Below is a design that avoids all of the
> > above issues and still delivers all of your objectives with the
> > exceptions of the third one [R3] when there is no SVA/SVM.
> > 
> > 
> > Create a subsystem (very much boiler plate code) which allow device to
> > register themself against (very much like what you do in your current
> > patchset but outside of VFIO).
> > 
> > That subsystem will create a device file for each registered system and
> > expose a common API (ie set of ioctl) for each of those device files.
> > 
> > When user space create a queue (through an ioctl after opening the device
> > file) the kernel can return -EBUSY if all the device queue are in use,
> > or create a device queue and return a flag like SYNC_ONLY for device that
> > do not have SVA/SVM.
> > 
> > For device with SVA/SVM at the time the process create a queue you bind
> > the process PASID to the device queue. From there on the userspace can
> > schedule commands and use the device without going to kernel space.
> 
> As mentioned previously, this is not enough for fork scenario.

It is for every existing user of SVA/SVM so i fail to see why it would
be any different in your case. Note that they all use VM_DONTCOPY flag
on the queue mapped to userspace.


> > For device without SVA/SVM you create a fake queue that is just pure
> > memory is not related to the device. From there on the userspace must
> > call an ioctl every time it wants the device to consume its queue
> > (hence why the SYNC_ONLY flag for synchronous operation only). The
> > kernel portion read the fake queue expose to user space and copy
> > commands into the real hardware queue but first it properly map any
> > of the process memory needed for those commands to the device and
> > adjust the device physical address with the one it gets from dma_map
> > API.
> > 
> 
> But in this way, we will lost most of the benefit of avoiding syscall.

Yes but only when there is SVA/SVM. What i am trying to stress is that
there is no sane way to mirror user space address space onto device
without mmu_notifier so short of that this model where you have to
syscall to schedules thing on the hardware is the easiest thing to do.


> > With that model it is "easy" to listen to mmu_notifier and to abide by
> > them to avoid issues [I1], [I3] and [I4]. You obviously avoid the [I2]
> > issue by only mapping a fake device queue to userspace.
> > 
> > So yes with that models it means that every device that wish to support
> > the non SVA/SVM case will have to do extra work (ie emulate its command
> > queue in software in the kernel). But by doing so, you support an
> > unlimited number of process on your device (ie all the process can share
> > one single hardware command queues or multiple hardware queues).
> 
> If I can do this, I will not need WarpDrive at all:(

This is only needed if you wish to support non SVA/SVM, shifting the
burden to the kernel is always the thing to do especially if they are
legitimate security concerns.


Cheers,
Jérôme
