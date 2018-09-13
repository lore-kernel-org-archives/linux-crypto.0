From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Thu, 13 Sep 2018 10:51:50 -0400
Message-ID: <20180913145149.GB3576@redhat.com>
References: <20180906133133.GA3830@redhat.com>
 <20180907040138.GI230707@Turing-Arch-b>
 <20180907165303.GA3519@redhat.com>
 <20180910032809.GJ230707@Turing-Arch-b>
 <20180910145423.GA3488@redhat.com>
 <20180911024209.GK230707@Turing-Arch-b>
 <20180911033358.GA4730@redhat.com>
 <20180911064043.GA207969@Turing-Arch-b>
 <20180911134013.GA3932@redhat.com>
 <20180913083232.GB207969@Turing-Arch-b>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Kenneth Lee <nek.in.cn@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zaibo Xu <xuzaibo@huawei.com>, linux-doc@vger.kernel.org,
        Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Hao Fang <fanghao11@huawei.com>, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, iommu@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Zhou Wang <wangzhou1@hisilicon.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        linux-accelerators@lists.ozlabs.org,
        Lu Baolu <baolu.lu@linux.intel.com>
To: Kenneth Lee <liguozhu@hisilicon.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180913083232.GB207969@Turing-Arch-b>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 13, 2018 at 04:32:32PM +0800, Kenneth Lee wrote:
> On Tue, Sep 11, 2018 at 09:40:14AM -0400, Jerome Glisse wrote:
> > On Tue, Sep 11, 2018 at 02:40:43PM +0800, Kenneth Lee wrote:
> > > On Mon, Sep 10, 2018 at 11:33:59PM -0400, Jerome Glisse wrote:
> > > > On Tue, Sep 11, 2018 at 10:42:09AM +0800, Kenneth Lee wrote:
> > > > > On Mon, Sep 10, 2018 at 10:54:23AM -0400, Jerome Glisse wrote:
> > > > > > On Mon, Sep 10, 2018 at 11:28:09AM +0800, Kenneth Lee wrote:
> > > > > > > On Fri, Sep 07, 2018 at 12:53:06PM -0400, Jerome Glisse wrote:
> > > > > > > > On Fri, Sep 07, 2018 at 12:01:38PM +0800, Kenneth Lee wrote:
> > > > > > > > > On Thu, Sep 06, 2018 at 09:31:33AM -0400, Jerome Glisse wrote:
> > > > > > > > > > On Thu, Sep 06, 2018 at 05:45:32PM +0800, Kenneth Lee wrote:
> > > > > > > > > > > On Tue, Sep 04, 2018 at 10:15:09AM -0600, Alex Williamson wrote:
> > > > > > > > > > > > On Tue, 4 Sep 2018 11:00:19 -0400 Jerome Glisse <jglisse@redhat.com> wrote:
> > > > > > > > > > > > > On Mon, Sep 03, 2018 at 08:51:57AM +0800, Kenneth Lee wrote:
> > > > > > 
> > > > > > [...]
> > > > > > 
> > > > > > > > > I took a look at i915_gem_execbuffer_ioctl(). It seems it "copy_from_user" the
> > > > > > > > > user memory to the kernel. That is not what we need. What we try to get is: the
> > > > > > > > > user application do something on its data, and push it away to the accelerator,
> > > > > > > > > and says: "I'm tied, it is your turn to do the job...". Then the accelerator has
> > > > > > > > > the memory, referring any portion of it with the same VAs of the application,
> > > > > > > > > even the VAs are stored inside the memory itself.
> > > > > > > > 
> > > > > > > > You were not looking at right place see drivers/gpu/drm/i915/i915_gem_userptr.c
> > > > > > > > It does GUP and create GEM object AFAICR you can wrap that GEM object into a
> > > > > > > > dma buffer object.
> > > > > > > > 
> > > > > > > 
> > > > > > > Thank you for directing me to this implementation. It is interesting:).
> > > > > > > 
> > > > > > > But it is not yet solve my problem. If I understand it right, the userptr in
> > > > > > > i915 do the following:
> > > > > > > 
> > > > > > > 1. The user process sets a user pointer with size to the kernel via ioctl.
> > > > > > > 2. The kernel wraps it as a dma-buf and keeps the process's mm for further
> > > > > > >    reference.
> > > > > > > 3. The user pages are allocated, GUPed or DMA mapped to the device. So the data
> > > > > > >    can be shared between the user space and the hardware.
> > > > > > > 
> > > > > > > But my scenario is: 
> > > > > > > 
> > > > > > > 1. The user process has some data in the user space, pointed by a pointer, say
> > > > > > >    ptr1. And within the memory, there may be some other pointers, let's say one
> > > > > > >    of them is ptr2.
> > > > > > > 2. Now I need to assign ptr1 *directly* to the hardware MMIO space. And the
> > > > > > >    hardware must refer ptr1 and ptr2 *directly* for data.
> > > > > > > 
> > > > > > > Userptr lets the hardware and process share the same memory space. But I need
> > > > > > > them to share the same *address space*. So IOMMU is a MUST for WarpDrive,
> > > > > > > NOIOMMU mode, as Jean said, is just for verifying some of the procedure is OK.
> > > > > > 
> > > > > > So to be 100% clear should we _ignore_ the non SVA/SVM case ?
> > > > > > If so then wait for necessary SVA/SVM to land and do warp drive
> > > > > > without non SVA/SVM path.
> > > > > > 
> > > > > 
> > > > > I think we should clear the concept of SVA/SVM here. As my understanding, Share
> > > > > Virtual Address/Memory means: any virtual address in a process can be used by
> > > > > device at the same time. This requires IOMMU device to support PASID. And
> > > > > optionally, it requires the feature of page-fault-from-device.
> > > > 
> > > > Yes we agree on what SVA/SVM is. There is a one gotcha thought, access
> > > > to range that are MMIO map ie CPU page table pointing to IO memory, IIRC
> > > > it is undefined what happens on some platform for a device trying to
> > > > access those using SVA/SVM.
> > > > 
> > > > 
> > > > > But before the feature is settled down, IOMMU can be used immediately in the
> > > > > current kernel. That make it possible to assign ONE process's virtual addresses
> > > > > to the device's IOMMU page table with GUP. This make WarpDrive work well for one
> > > > > process.
> > > > 
> > > > UH ? How ? You want to GUP _every_ single valid address in the process
> > > > and map it to the device ? How do you handle new vma, page being replace
> > > > (despite GUP because of things that utimately calls zap pte) ...
> > > > 
> > > > Again here you said that the device must be able to access _any_ valid
> > > > pointer. With GUP this is insane.
> > > > 
> > > > So i am assuming this is not what you want to do without SVA/SVM ie with
> > > > GUP you have a different programming model, one in which the userspace
> > > > must first bind _range_ of memory to the device and get a DMA address
> > > > for the range.
> > > > 
> > > > Again, GUP range of process address space to map it to a device so that
> > > > userspace can use the device on the mapped range is something that do
> > > > exist in various places in the kernel.
> > > > 
> > > 
> > > Yes same as your expectation, in WarpDrive, we use the concept of "sharing" to
> > > do so. If some memory is going to be shared among process and devices, we use
> > > wd_share_mem(queue, ptr, size) to share those memory. When the queue is working
> > > in this mode, the point is valid in those memory segments. The wd_share_mem call
> > > vfio dma map syscall which will do GUP. 
> > > 
> > > If SVA/SVM is enabled, user space can set SHARE_ALL flags to the queue. Then
> > > wd_share_mem() is not necessary.
> > > 
> > > This is really not popular when we started the work on WarpDrive. The GUP
> > > document said it should be put within the scope of mm_sem is locked. Because GUP
> > > simply increase the page refcount, not keep the mapping between the page and the
> > > vma. We keep our work together with VFIO to make sure the problem can be solved
> > > in one deal.
> > 
> > The problem can not be solved in one deal, you can not maintain vaddr
> > pointing to same page after a fork() this can not be solve without the
> > use of mmu notifier and device dma mapping invalidation ! So being part
> > of VFIO will not help you there.
> 
> Good point. But sadly, even with mmu notifier and dma mapping invalidation, I
> cannot do anything here. If the process fork a sub-process, the sub-process need
> a new pasid and hardware resource. The IOMM space mapped should not be used. The
> parent process should be aware of this, unmap and close the device file before
> the fork. I have the same limitation as VFIO:(
> 
> I don't think I can change much here. If I can, VFIO can too:)

The forbid child to access the device is easy in the kernel whenever
someone open the device file force set the OCLOEXEC flag on the file
some device driver already do that and so should you. With that you
should always have a struct file - mm struct one to one relationship
and thus one PASID per struct file ie per open of the device file.

That does not solve the GUP/fork issue i describe below.


> > AFAIK VFIO is fine with the way it is as QEMU do not fork() once it
> > is running a guest and thus the COW that would invalidate vaddr to
> > physical page assumption is not broken. So i doubt VFIO folks have
> > any incentive to go down the mmu notifier path and invalidate device
> > mapping. They also have the replay thing that probably handle some
> > of fork cases by trusting user space program to do it. In your case
> > you can not trust the user space program.
> > 
> > In your case AFAICT i do not see any warning or gotcha so the following
> > scenario is broken (in non SVA/SVM):
> >     1) program setup the device (open container, mdev, setup queue, ...)
> >     2) program map some range of its address space wih VFIO_IOMMU_MAP_DMA
> >     3) program start using the device using map setup in 2)
> >     ...
> >     4) program fork()
> >     5) parent trigger COW inside the range setup in 2)
> > 
> >     At this point it is the child process that can write to the page that
> >     are access by the device (which was map by the parent in 2)). The
> >     parent can no longer access that memory from the CPU.
> > 
> > There is just no sane way to fix this beside invalidating device mapping
> > on fork (and you can not rely on userspace to do so) and thus stopping
> > the device on fork (SVA/SVM case do not have any issue here).
> 
> Indeed. But as soon as we choose to expose the device space to the user space,
> the limitation is already there. If we want to solve the problem, we have to
> have a hook in the copy_process() procedure and copy the parent's queue state to
> a new queue, assign it to the child's fd and redirect the child's mmap to
> it. If I can do so, the same logic can also be applied to VFIO.

Except we do not want to do that and this does not solve the COW i describe
above unless you disable COW altogether which is a big no.

> The good side is, this is not a security leak. The hardware has been given to
> the process. It is the process who choose to share it. If it won't work, it is
> the process's problem;)

No this is bad, you can not expect every single userspace program to know and
be aware of that. If some trusted application (say systemd or firefox, ...)
start using your device and is unaware or does not comprehend all side effect
it would allow the child to access/change its parent memory and that is bad.
Device driver need to protect against user doing stupid thing. All existing
device driver that do ATS/PASID already protect themself against child (ie the
child can not use the device through a mix of OCLOEXEC and other checks).

You must set the OCLOEXEC flag but that does not solve the COW problem above.

My motto in life is "do not trust userspace" :) which also translate to "do
not expect userspace will do the right thing".


> > > And now we have GUP-longterm and many accounting work in VFIO, we don't want to
> > > do that again.
> > 
> > GUP-longterm does not solve any GUP problem, it just block people to
> > do GUP on DAX backed vma to avoid pining persistent memory as it is
> > a nightmare to handle in the block device driver and file system code.
> > 
> > The accounting is the rt limit thing and is litteraly 10 lines of
> > code so i would not see that as hard to replicate.
> 
> OK. Agree.
> 
> > 
> > 
> > > > > Now We are talking about SVA and PASID, just to make sure WarpDrive can benefit
> > > > > from the feature in the future. It dose not means WarpDrive is useless before
> > > > > that. And it works for our Zip and RSA accelerators in physical world.
> > > > 
> > > > Just not with random process address ...
> > > > 
> > > > > > If you still want non SVA/SVM path what you want to do only works
> > > > > > if both ptr1 and ptr2 are in a range that is DMA mapped to the
> > > > > > device (moreover you need DMA address to match process address
> > > > > > which is not an easy feat).
> > > > > > 
> > > > > > Now even if you only want SVA/SVM, i do not see what is the point
> > > > > > of doing this inside VFIO. AMD GPU driver does not and there would
> > > > > > be no benefit for them to be there. Well a AMD VFIO mdev device
> > > > > > driver for QEMU guest might be useful but they have SVIO IIRC.
> > > > > > 
> > > > > > For SVA/SVM your usage model is:
> > > > > > 
> > > > > > Setup:
> > > > > >     - user space create a warp drive context for the process
> > > > > >     - user space create a device specific context for the process
> > > > > >     - user space create a user space command queue for the device
> > > > > >     - user space bind command queue
> > > > > > 
> > > > > >     At this point the kernel driver has bound the process address
> > > > > >     space to the device with a command queue and userspace
> > > > > > 
> > > > > > Usage:
> > > > > >     - user space schedule work and call appropriate flush/update
> > > > > >       ioctl from time to time. Might be optional depends on the
> > > > > >       hardware, but probably a good idea to enforce so that kernel
> > > > > >       can unbind the command queue to bind another process command
> > > > > >       queue.
> > > > > >     ...
> > > > > > 
> > > > > > Cleanup:
> > > > > >     - user space unbind command queue
> > > > > >     - user space destroy device specific context
> > > > > >     - user space destroy warp drive context
> > > > > >     All the above can be implicit when closing the device file.
> > > > > > 
> > > > > > So again in the above model i do not see anywhere something from
> > > > > > VFIO that would benefit this model.
> > > > > > 
> > > > > 
> > > > > Let me show you how the model will be if I use VFIO:
> > > > > 
> > > > > Setup (Kernel part)
> > > > > 	- Kernel driver do every as usual to serve the other functionality, NIC
> > > > > 	  can still be registered to netdev, encryptor can still be registered
> > > > > 	  to crypto...
> > > > > 	- At the same time, the driver can devote some of its hardware resource
> > > > > 	  and register them as a mdev creator to the VFIO framework. This just
> > > > > 	  need limited change to the VFIO type1 driver.
> > > > 
> > > > In the above VFIO does not help you one bit ... you can do that with
> > > > as much code with new common device as front end.
> > > > 
> > > > > Setup (User space)
> > > > > 	- System administrator create mdev via the mdev creator interface.
> > > > > 	- Following VFIO setup routine, user space open the mdev's group, there is
> > > > > 	  only one group for one device.
> > > > > 	- Without PASID support, you don't need to do anything. With PASID, bind
> > > > > 	  the PASID to the device via VFIO interface.
> > > > > 	- Get the device from the group via VFIO interface and mmap it the user
> > > > > 	  space for device's MMIO access (for the queue).
> > > > > 	- Map whatever memory you need to share with the device with VFIO
> > > > > 	  interface.
> > > > > 	- (opt) Add more devices into the container if you want to share the
> > > > > 	  same address space with them
> > > > 
> > > > So all VFIO buys you here is boiler plate code that does insert_pfn()
> > > > to handle MMIO mapping. Which is just couple hundred lines of boiler
> > > > plate code.
> > > > 
> > > 
> > > No. With VFIO, I don't need to:
> > > 
> > > 1. GUP and accounting for RLIMIT_MEMLOCK
> > 
> > That's 10 line of code ...
> > 
> > > 2. Keep all GUP pages for releasing (VFIO uses the rb_tree to do so)
> > 
> > GUP pages are not part of rb_tree and what you want to do can be done
> > in few lines of code here is pseudo code:
> > 
> > warp_dma_map_range(ulong vaddr, ulong npages)
> > {
> >     struct page *pages = kvzalloc(npages);
> > 
> >     for (i = 0; i < npages; ++i, vaddr += PAGE_SIZE) {
> >         GUP(vaddr, &pages[i]);
> >         iommu_map(vaddr, page_to_pfn(pages[i]));
> >     }
> >     kvfree(pages);
> > }
> > 
> > warp_dma_unmap_range(ulong vaddr, ulong npages)
> > {
> >     for (i = 0; i < npages; ++i, vaddr += PAGE_SIZE) {
> >         unsigned long pfn;
> > 
> >         pfn = iommu_iova_to_phys(vaddr);
> >         iommu_unmap(vaddr);
> >         put_page(pfn_to_page(page)); /* set dirty if mapped write */
> >     }
> > }
> > 
> 
> But what if the process exist without unmapping? The pages will be pinned in the
> kernel forever.

Yeah add a struct warp_map { struct list_head list; unsigned long vaddr,
unsigned long npages; } for every mapping, store the head into the device
file private field of struct file and when the release fs callback is
call you can walk done the list to force unmap any leftover. This is not
that much code. You ca even use interval tree which is 3 lines of code
with interval_tree_generic.h to speed up warp_map lookup on unmap ioctl.


> > Add locking, error handling, dirtying and comments and you are barely
> > looking at couple hundred lines of code. You do not need any of the
> > complexity of VFIO as you do not have the same requirements. Namely
> > VFIO have to keep track of iova and physical mapping for things like
> > migration (migrating guest between host) and few others very
> > virtualization centric requirements.
> > 
> > 
> > > 2. Handle the PASID on SMMU (ARM's IOMMU) myself.
> > 
> > Existing driver do that with 20 lines of with comments and error
> > handling (see kfd_iommu_bind_process_to_device() for instance) i
> > doubt you need much more than that.
> > 
> 
> OK, I agree.
> 
> > 
> > > 3. Multiple devices menagement (VFIO uses container to manage this)
> > 
> > All the vfio_group* stuff ? OK that's boiler plate code, note that
> > hard to replicate thought.
> 
> No, I meant the container thing. Several devices/group can be assigned to the
> same container and the DMA on the container can be assigned to all those
> devices. So we can have some devices to share the same name space.

This was the motivation of my question below, to me this is a policy
decision and it should be left to userspace to decide but not forced
upon userspace because it uses a given device driver.

Maybe i am wrong but i think you can create container and device group
without having a VFIO driver for the devices in the group. It is not
something i do often so i might be wrong here.


> > > And even as a boiler plate, it is valueable, the memory thing is sensitive
> > > interface to user space, it can easily become a security problem. If I can
> > > achieve my target within the scope of VFIO, why not? At lease it has been
> > > proved to be safe for the time being.
> > 
> > The thing is being part of VFIO impose things on you, things that you
> > do not need. Like one device per group (maybe it is you imposing this,
> > i am loosing track here). Or the complex dma mapping tracking ...
> > 
> 
> Err... But the one-device-per-group is not VFIO's decision. It is IOMMU's :).
> Unless I don't use IOMMU.

AFAIK, on x86 and PPC at least, all PCIE devices are in the same group
by default at boot or at least all devices behind the same bridge.

Maybe they are kernel option to avoid that and userspace init program
can definitly re-arrange that base on sysadmin policy).


> > > > > Cleanup:
> > > > > 	- User space close the group file handler
> > > > > 	- There will be a problem to let the other process know the mdev is
> > > > > 	  freed to be used again. My RFCv1 choose a file handler solution. Alex
> > > > > 	  dose not like it. But it is not a big problem. We can always have a
> > > > > 	  scheduler process to manage the state of the mdev or even we can
> > > > > 	  switch back to the RFCv1 solution without too much effort if we like
> > > > > 	  in the future.
> > > > 
> > > > If you were outside VFIO you would have more freedom on how to do that.
> > > > For instance process opening the device file can be placed on queue and
> > > > first one in the queue get to use the device until it closes/release the
> > > > device. Then next one in queue get the device ...
> > > 
> > > Yes. I do like the file handle solution. But I hope the solution become mature
> > > as soon as possible. Many of our products, and as I know include some of our
> > > partners, are waiting for a long term solution as direction. If I rely on some
> > > unmature solution, they may choose some deviated, customized solution. That will
> > > be much harmful. Compare to this, the freedom is not so important...
> > 
> > I do not see how being part of VFIO protect you from people doing crazy
> > thing to their kernel ... Time to market being key in this world, i doubt
> > that being part of VFIO would make anyone think twice before taking a
> > shortcut.
> > 
> > I have seen horrible things on that front and only players like Google
> > can impose a minimum level of sanity.
> > 
> 
> OK. My fault, to talk about TTM. It has nothing doing with the architecture
> decision. But I don't yet see what harm will be brought if I use VFIO when it
> can fulfill almost all my requirements.

The harm is in forcing the device group isolation policy which is not
necessary for all devices like you said so yourself on ARM with the
device stream id so that IOMMU can identify individual devices.

So i would rather see the device isolation as something orthogonal to
what you want to achieve and that should be forced upon user ie sysadmin
should control that distribution can have sane default for each platform.


> > > > > Except for the minimum update to the type1 driver and use sdmdev to manage the
> > > > > interrupt sharing, I don't need any extra code to gain the address sharing
> > > > > capability. And the capability will be strengthen along with the upgrade of VFIO.
> > > > > 
> > > > > > 
> > > > > > > > > And I don't understand why I should avoid to use VFIO? As Alex said, VFIO is the
> > > > > > > > > user driver framework. And I need exactly a user driver interface. Why should I
> > > > > > > > > invent another wheel? It has most of stuff I need:
> > > > > > > > > 
> > > > > > > > > 1. Connecting multiple devices to the same application space
> > > > > > > > > 2. Pinning and DMA from the application space to the whole set of device
> > > > > > > > > 3. Managing hardware resource by device
> > > > > > > > > 
> > > > > > > > > We just need the last step: make sure multiple applications and the kernel can
> > > > > > > > > share the same IOMMU. Then why shouldn't we use VFIO?
> > > > > > > > 
> > > > > > > > Because tons of other drivers already do all of the above outside VFIO. Many
> > > > > > > > driver have a sizeable userspace side to them (anything with ioctl do) so they
> > > > > > > > can be construded as userspace driver too.
> > > > > > > > 
> > > > > > > 
> > > > > > > Ignoring if there are *tons* of drivers are doing that;), even I do the same as
> > > > > > > i915 and solve the address space problem. And if I don't need to with VFIO, why
> > > > > > > should I spend so much effort to do it again?
> > > > > > 
> > > > > > Because you do not need any code from VFIO, nor do you need to reinvent
> > > > > > things. If non SVA/SVM matters to you then use dma buffer. If not then
> > > > > > i do not see anything in VFIO that you need.
> > > > > > 
> > > > > 
> > > > > As I have explain, if I don't use VFIO, at lease I have to do all that has been
> > > > > done in i915 or even more than that.
> > > > 
> > > > So beside the MMIO mmap() handling and dma mapping of range of user space
> > > > address space (again all very boiler plate code duplicated accross the
> > > > kernel several time in different forms). You do not gain anything being
> > > > inside VFIO right ?
> > > > 
> > > 
> > > As I said, rb-tree for gup, rlimit accounting, cooperation on SMMU, and mature
> > > user interface are our concern.
> > > > 
> > > > > > > > So there is no reasons to do that under VFIO. Especialy as in your example
> > > > > > > > it is not a real user space device driver, the userspace portion only knows
> > > > > > > > about writting command into command buffer AFAICT.
> > > > > > > > 
> > > > > > > > VFIO is for real userspace driver where interrupt, configurations, ... ie
> > > > > > > > all the driver is handled in userspace. This means that the userspace have
> > > > > > > > to be trusted as it could program the device to do DMA to anywhere (if
> > > > > > > > IOMMU is disabled at boot which is still the default configuration in the
> > > > > > > > kernel).
> > > > > > > > 
> > > > > > > 
> > > > > > > But as Alex explained, VFIO is not simply used by VM. So it need not to have all
> > > > > > > stuffs as a driver in host system. And I do need to share the user space as DMA
> > > > > > > buffer to the hardware. And I can get it with just a little update, then it can
> > > > > > > service me perfectly. I don't understand why I should choose a long route.
> > > > > > 
> > > > > > Again this is not the long route i do not see anything in VFIO that
> > > > > > benefit you in the SVA/SVM case. A basic character device driver can
> > > > > > do that.
> > > > > > 
> > > > > > 
> > > > > > > > So i do not see any reasons to do anything you want inside VFIO. All you
> > > > > > > > want to do can be done outside as easily. Moreover it would be better if
> > > > > > > > you define clearly each scenario because from where i sit it looks like
> > > > > > > > you are opening the door wide open to userspace to DMA anywhere when IOMMU
> > > > > > > > is disabled.
> > > > > > > > 
> > > > > > > > When IOMMU is disabled you can _not_ expose command queue to userspace
> > > > > > > > unless your device has its own page table and all commands are relative
> > > > > > > > to that page table and the device page table is populated by kernel driver
> > > > > > > > in secure way (ie by checking that what is populated can be access).
> > > > > > > > 
> > > > > > > > I do not believe your example device to have such page table nor do i see
> > > > > > > > a fallback path when IOMMU is disabled that force user to do ioctl for
> > > > > > > > each commands.
> > > > > > > > 
> > > > > > > > Yes i understand that you target SVA/SVM but still you claim to support
> > > > > > > > non SVA/SVM. The point is that userspace can not be trusted if you want
> > > > > > > > to have random program use your device. I am pretty sure that all user
> > > > > > > > of VFIO are trusted process (like QEMU).
> > > > > > > > 
> > > > > > > > 
> > > > > > > > Finaly i am convince that the IOMMU grouping stuff related to VFIO is
> > > > > > > > useless for your usecase. I really do not see the point of that, it
> > > > > > > > does complicate things for you for no reasons AFAICT.
> > > > > > > 
> > > > > > > Indeed, I don't like the group thing. I believe VFIO's maintains would not like
> > > > > > > it very much either;). But the problem is, the group reflects to the same
> > > > > > > IOMMU(unit), which may shared with other devices.  It is a security problem. I
> > > > > > > cannot ignore it. I have to take it into account event I don't use VFIO.
> > > > > > 
> > > > > > To me it seems you are making a policy decission in kernel space ie
> > > > > > wether the device should be isolated in its own group or not is a
> > > > > > decission that is up to the sys admin or something in userspace.
> > > > > > Right now existing user of SVA/SVM don't (at least AFAICT).
> > > > > > 
> > > > > > Do we really want to force such isolation ?
> > > > > > 
> > > > > 
> > > > > But it is not my decision, that how the iommu subsystem is designed. Personally
> > > > > I don't like it at all, because all our hardwares have their own stream id
> > > > > (device id). I don't need the group concept at all. But the iommu subsystem
> > > > > assume some devices may share the name device ID to a single IOMMU.
> > > > 
> > > > My question was do you really want to force group isolation for the
> > > > device ? Existing SVA/SVM capable driver do not force that, they let
> > > > the userspace decide this (sysadm, distributions, ...). Being part of
> > > > VFIO (in the way you do, likely ways to avoid this inside VFIO too)
> > > > force this decision ie make a policy decision without userspace having
> > > > anything to say about it.
> > 
> > You still do not answer my question, do you really want to force group
> > isolation for device in your framework ? Which is a policy decision from
> > my POV and thus belong to userspace and should not be enforce by kernel.
> 
> No. But I have to follow the rule defined by IOMMU, haven't I?

The IOMMU rule does not say that every device _must_ always be in one
group and one domain only. I am pretty sure on x86 by default you get
one domain for all PCIE devices behind same bridge.

My point is that the device grouping into domain/group should be an
orthogonal decision ie it should not be a requirement by the device
driver and should be under control of userspace as it is a policy
decission.

One exception if it is unsafe to have device share a domain in which
case following my motto the driver should refuse to work and return
an error on open (and a kernel explaining why). But this depends on
device and platform.


> > > > The IOMMU group thing as always been doubt full to me, it is advertise
> > > > as allowing to share resources (ie IOMMU page table) between devices.
> > > > But this assume that all device driver in the group have some way of
> > > > communicating with each other to share common DMA address that point
> > > > to memory devices care. I believe only VFIO does that and probably
> > > > only when use by QEMU.
> > > > 
> > > > 
> > > > Anyway my question is:
> > > > 
> > > > Is it that much useful to be inside VFIO (to avoid few hundred lines
> > > > of boiler plate code) given that it forces you into a model (group
> > > > isolation) that so far have never been the prefered way for all
> > > > existing device driver that already do what you want to achieve ?
> > > > 
> > > 
> > > You mean to say I create another framework and copy most of the code from VFIO?
> > > It is hard to believe the mainline kernel will take my code. So how about let me
> > > try the VFIO way first and try that if it won't work? ;)
> > 
> > There is no trying, this is the kernel, once you expose something to
> > userspace you have to keep supporting it forever ... There is no, hey
> > let's add this new framework and see how it goes and removing it few
> > kernel version latter ...
> > 
> 
> No, I don't meant it was unserious when I said "try". I was just not sure if the
> community can accept it. 
> 
> Can Alex say something on this? Is this scenario in the future scope of VFIO? If
> it is, we have the season to solve the problem on the way. If it is not, we
> should choose other way even we have to copy most of the code.
> 
> > That is why i am being pedantic :) on making sure there is good reasons
> > to do what you do inside VFIO. I do believe that we want a common frame-
> > work like the one you are proposing but i do not believe it should be
> > part of VFIO given the baggages it comes with and that are not relevant
> > to the use cases for this kind of devices.
> 
> Understood. And I appreciate the discussion and help:)

Thank you for bearing with in this long discussion :)

Cheers,
Jérôme
