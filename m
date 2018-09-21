From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Fri, 21 Sep 2018 10:52:01 -0400
Message-ID: <20180921145201.GA3357@redhat.com>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
 <20180917014244.GA27596@redhat.com>
 <20180921100314.GH207969@Turing-Arch-b>
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
In-Reply-To: <20180921100314.GH207969@Turing-Arch-b>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 21, 2018 at 06:03:14PM +0800, Kenneth Lee wrote:
> On Sun, Sep 16, 2018 at 09:42:44PM -0400, Jerome Glisse wrote:
> > 
> > So i want to summarize issues i have as this threads have dig deep into
> > details. For this i would like to differentiate two cases first the easy
> > one when relying on SVA/SVM. Then the second one when there is no SVA/SVM.
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
> > 
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
> > 
> 
> Hi, Jerome, 
> 
> I reconsider your logic. I think the problem can be solved. Let us separate the
> SVA/SVM feature into two: fault-from-device and device-va-awareness. A device
> with iommu can support only device-va-awareness or both.

Not sure i follow, are you also talking about the non SVA/SVM case here ?
Either device has SVA/SVM, either it does not. The fact that device can
use same physical address PA for its access as the process virtual address
VA does not change any of the issues listed here, same issues would apply
if device was using PA != VA ...


> VFIO works on top of iommu, so it will support at least device-va-awareness. For
> the COW problem, it can be taken as a mmu synchronization issue. If the mmu page
> table is changed, it should be synchronize to iommu (via iommu_notifier). In the
> case that the device support fault-from-device, it will work fine. In the case
> that it supports only device-va-awareness, we can prefault (handle_mm_fault)
> also via iommu_notifier and reset to iommu page table.
> 
> So this can be considered as a bug of VFIO, cannot it?

So again SVA/SVM is fine because it uses the same CPU page table so anything
done to the process address space reflect automaticly to the device. Nothing
to do for SVA/SVM.

For non SVA/SVM you _must_ unmap device command queues, flush and wait for
all pending commands, unmap all the IOMMU mapping and wait for the process
to fault on the unmapped device command queue before trying to restore any
thing. This would be terribly slow i described it in another email.

Also you can not fault inside a mmu_notifier it is illegal, all you can do
is unmap thing and wait for access to finish.

> > [I2]- Because of [R3] you want to allow userspace to schedule commands
> >       on the device without doing an ioctl and thus here user space
> >       can schedule any commands to the device with any address. What
> >       happens if that address have not been mapped by the user space
> >       is undefined and in fact can not be defined as what each IOMMU
> >       does on invalid address access is different from IOMMU to IOMMU.
> > 
> >       In case of a bad IOMMU, or simply an IOMMU improperly setup by
> >       the kernel, this can potentialy allow user space to DMA anywhere.
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
> In the case, we cannot do anything if the device do not support
> fault-from-device. But we can reject write map with file-backed mapping.

Yes this would avoid most issues with file-backed mapping, truncate would
still cause weird behavior but only for your device. But then your non
SVA/SVM case does not behave as the SVA/SVM case so why not do what i out-
lined below that allow same behavior modulo command flushing ...

> It seems both issues can be solved under VFIO framework:) (But of cause, I don't
> mean it has to)

The COW can not be solve without either the solution i described in this
previous mail below or the other one with mmu notifier. But the one below
is saner and has better performance.


> > 
> > [I4]- Design issue, mdev design As Far As I Understand It is about
> >       sharing a single device to multiple clients (most obvious case
> >       here is again QEMU guest). But you are going against that model,
> >       in fact AFAIUI you are doing the exect opposite. When there is
> >       no SVA/SVM you want only one mdev device that can not be share.
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
> > 
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
> > With that model it is "easy" to listen to mmu_notifier and to abide by
> > them to avoid issues [I1], [I3] and [I4]. You obviously avoid the [I2]
> > issue by only mapping a fake device queue to userspace.
> > 
> > So yes with that models it means that every device that wish to support
> > the non SVA/SVM case will have to do extra work (ie emulate its command
> > queue in software in the kernel). But by doing so, you support an
> > unlimited number of process on your device (ie all the process can share
> > one single hardware command queues or multiple hardware queues).
> > 
> > The big advantages i see here is that the process do not have to worry
> > about doing something wrong. You are protecting yourself and your user
> > from stupid mistakes.
> > 
> > 
> > I hope this is useful to you.
> > 
> > Cheers,
> > Jérôme
> 
> Cheers
> -- 
> 			-Kenneth(Hisilicon)
> 
