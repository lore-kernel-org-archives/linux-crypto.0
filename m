From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Thu, 20 Sep 2018 10:23:40 -0400
Message-ID: <20180920142340.GA3341@redhat.com>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
 <20180917014244.GA27596@redhat.com>
 <20180917083940.GE207969@Turing-Arch-b>
 <20180917123744.GA3605@redhat.com>
 <20180918060014.GF207969@Turing-Arch-b>
 <20180918130314.GA3500@redhat.com>
 <20180920055543.GG207969@Turing-Arch-b>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Kenneth Lee <nek.in.cn@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, linux-doc@vger.kernel.org,
        Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Hao Fang <fanghao11@huawei.com>, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, iommu@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Zhou Wang <wangzhou1@hisilicon.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zaibo Xu <xuzaibo@huawei.com>,
        linux-accelerators@lists.ozlabs.org,
        Lu Baolu <baolu.lu@linux.intel.com>
To: Kenneth Lee <liguozhu@hisilicon.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180920055543.GG207969@Turing-Arch-b>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 20, 2018 at 01:55:43PM +0800, Kenneth Lee wrote:
> On Tue, Sep 18, 2018 at 09:03:14AM -0400, Jerome Glisse wrote:
> > On Tue, Sep 18, 2018 at 02:00:14PM +0800, Kenneth Lee wrote:
> > > On Mon, Sep 17, 2018 at 08:37:45AM -0400, Jerome Glisse wrote:
> > > > On Mon, Sep 17, 2018 at 04:39:40PM +0800, Kenneth Lee wrote:
> > > > > On Sun, Sep 16, 2018 at 09:42:44PM -0400, Jerome Glisse wrote:
> > > > > > So i want to summarize issues i have as this threads have dig deep into
> > > > > > details. For this i would like to differentiate two cases first the easy
> > > > > > one when relying on SVA/SVM. Then the second one when there is no SVA/SVM.
> > > > > 
> > > > > Thank you very much for the summary.
> > > > > 
> > > > > > In both cases your objectives as i understand them:
> > > > > > 
> > > > > > [R1]- expose a common user space API that make it easy to share boiler
> > > > > >       plate code accross many devices (discovering devices, opening
> > > > > >       device, creating context, creating command queue ...).
> > > > > > [R2]- try to share the device as much as possible up to device limits
> > > > > >       (number of independant queues the device has)
> > > > > > [R3]- minimize syscall by allowing user space to directly schedule on the
> > > > > >       device queue without a round trip to the kernel
> > > > > > 
> > > > > > I don't think i missed any.
> > > > > > 
> > > > > > 
> > > > > > (1) Device with SVA/SVM
> > > > > > 
> > > > > > For that case it is easy, you do not need to be in VFIO or part of any
> > > > > > thing specific in the kernel. There is no security risk (modulo bug in
> > > > > > the SVA/SVM silicon). Fork/exec is properly handle and binding a process
> > > > > > to a device is just couple dozen lines of code.
> > > > > > 
> > > > > 
> > > > > This is right...logically. But the kernel has no clear definition about "Device
> > > > > with SVA/SVM" and no boiler plate for doing so. Then VFIO may become one of the
> > > > > boiler plate.
> > > > > 
> > > > > VFIO is one of the wrappers for IOMMU for user space. And maybe it is the only
> > > > > one. If we add that support within VFIO, which solve most of the problem of
> > > > > SVA/SVM, it will save a lot of work in the future.
> > > > 
> > > > You do not need to "wrap" IOMMU for SVA/SVM. Existing upstream SVA/SVM user
> > > > all do the SVA/SVM setup in couple dozen lines and i failed to see how it
> > > > would require any more than that in your case.
> > > > 
> > > > 
> > > > > I think this is the key confliction between us. So could Alex please say
> > > > > something here? If the VFIO is going to take this into its scope, we can try
> > > > > together to solve all the problem on the way. If it it is not, it is also
> > > > > simple, we can just go to another way to fulfill this part of requirements even
> > > > > we have to duplicate most of the code.
> > > > > 
> > > > > Another point I need to emphasis here: because we have to replace the hardware
> > > > > queue when fork, so it won't be very simple even in SVA/SVM case.
> > > > 
> > > > I am assuming hardware queue can only be setup by the kernel and thus
> > > > you are totaly safe forkwise as the queue is setup against a PASID and
> > > > the child does not bind to any PASID and you use VM_DONTCOPY on the
> > > > mmap of the hardware MMIO queue because you should really use that flag
> > > > for that.
> > > > 
> > > > 
> > > > > > (2) Device does not have SVA/SVM (or it is disabled)
> > > > > > 
> > > > > > You want to still allow device to be part of your framework. However
> > > > > > here i see fundamentals securities issues and you move the burden of
> > > > > > being careful to user space which i think is a bad idea. We should
> > > > > > never trus the userspace from kernel space.
> > > > > > 
> > > > > > To keep the same API for the user space code you want a 1:1 mapping
> > > > > > between device physical address and process virtual address (ie if
> > > > > > device access device physical address A it is accessing the same
> > > > > > memory as what is backing the virtual address A in the process.
> > > > > > 
> > > > > > Security issues are on two things:
> > > > > > [I1]- fork/exec, a process who opened any such device and created an
> > > > > >       active queue can transfer without its knowledge control of its
> > > > > >       commands queue through COW. The parent map some anonymous region
> > > > > >       to the device as a command queue buffer but because of COW the
> > > > > >       parent can be the first to copy on write and thus the child can
> > > > > >       inherit the original pages that are mapped to the hardware.
> > > > > >       Here parent lose control and child gain it.
> > > > > 
> > > > > This is indeed an issue. But it remains an issue only if you continue to use the
> > > > > queue and the memory after fork. We can use at_fork kinds of gadget to fix it in
> > > > > user space.
> > > > 
> > > > Trusting user space is a no go from my point of view.
> > > 
> > > Can we dive deeper on this? Maybe we have different understanding on "Trusting
> > > user space". As my understanding, "trusting user space" means "no matter what
> > > the user process does, it should only hurt itself and anything give to it, no
> > > the kernel and the other process".
> > > 
> > > In our case, we create a channel between a process and the hardware. The process
> > > can do whateven it like to its own memory the channel itself. It won't hurt the
> > > other process and the kernel. And if the process fork a child and give the
> > > channel to the child, it should the freedom on those resource remain within the
> > > parent and the child. We are not trust another else.
> > > 
> > > So do you refer to something else here?
> > > 
> > 
> > I am refering to COW giving control to the child on to what happens
> > in the parent from device point of view. A process hurting itself is
> > fine, but if process now has to do special steps to protect from
> > its child ie make sure that its childs can not hurt it, then i see
> > that as a kernel bug. We can not ask user space process to know about
> > all the thousands things that needs to be done to avoid issues with
> > each device driver that the process may use (process can be totaly
> > ignorant it is using a device if that device is use by a library it
> > links to).
> > 
> > 
> > Maybe what needs to happen will explain it better. So if userspace
> > wants to be secure and protect itself from its child taking over the
> > device through COW:
> > 
> >     - parent opened a device and is using it
> > 
> >     ... when parent wants to fork/exec it must:
> > 
> >     - parent _must_ flush device command queue and wait for the
> >       device to finish all pending jobs
> > 
> >     - parent _must_ unmap all range mapped to the device
> > 
> >     - parent should first close device file (unless you force set
> >       the CLOEXEC flag in the kernel)/it could also just flush
> >       but if you are not mapping the device command queue with
> >       VM_DONTCOPY then you should really be closing the device
> > 
> >     - now parent can fork/exec
> > 
> >     - parent must force COW ie write at least one byte to _all_
> >       pages in the range it wants to use with the device
> > 
> >     - parent re-open the device and re-initialize everything
> > 
> > 
> > So this is putting quite a burden on a number of steps the parent
> > _must_ do in order to keep control of memory exposed to the device.
> > Not doing so can potentialy lead (it depends on who does the COW
> > first) to the child taking control of memory use by the device,
> > memory which was mapped by the parent before the child was created.
> > 
> > Forcing CLOEXEC and VM_DONTCOPY somewhat help to simplify this,
> > but you still need to stop, flush, unmap, before fork/exec and then
> > re-init everything after.
> > 
> > 
> > This is only when not using SVA/SVM, SVA/SVM is totaly fine from
> > that point of view, no issues whatsoever.
> > 
> > The solution i outlined in previous email do not have that above
> > issue either, no need to rely on user space doing that dance.
> 
> Thank you. I get the point. I'm now trying to see if I can solve the problem by
> seting the vma to VM_SHARED when the portiong is "shared to the hardware".
> 

FYI you can not convert a private anonymous vma to a share one it is
illegal AFAIK at least i never heard of it and i am pretty sure the
mm code would break if that happens. The user space is the one that
decide what flags a vma has, not the kernel. Modulo few flags like
DONTCOPY that can be force set by device driver for their vma ie vma
of an mmap against the device file.

If you don't like my solution here is another one but it is ugly and
i think it is a bad idea. Again this is for the non SVA/SVM case and
it assumes that the command queue is a mmap() of the device file:
  (A) register mmu_notifier
  (B) on _every_ invalidate range callback (_no matter_ what is the
      range) you zap the command queue mapped to user space (this is
      because you can't tell if the callback happens for a fork or
      something else) wait for the hardware queue to finish and clear
      all the iommu/dma mapping and you unpin all the pages ie
      put_page()
  (C) in device file vma page fault handler (vm_operations_struct.
      fault) you redo all the GUP and redo all the iommu/dma mapping
      and you remap the command queue to the userspace

In (C) you can remap different command queue if you are in the child
than in the parent (just look at current->mm and compare it to the
one the command queue was created against).

Note that this solution will be much __slower__ than what i described
in my previous email. You will see that mmu notifier callbacks happens
often and for tons of reasons and you will be _constantly_ undoing and
redoing tons of work.

This can be mitigated if you can differentiate reasons behind a mmu
notifier callback. I posted patchset to do that a while ago and i
intend to post it again in the next month or so. But this would still
be a bad idea and solution i described previously is much more sane.

Trying to pretend you can have the same thing as SVA/SVM without SVA
is not a good idea. The non SVA case can still expose same API (like
i described previously) but should go through kernel for _every_
hardware submission (you can batch multiple commands in one submission).
Not doing so is way too risky from my POV.

Cheers,
Jérôme
