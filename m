From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Thu, 13 Sep 2018 16:32:32 +0800
Message-ID: <20180913083232.GB207969@Turing-Arch-b>
References: <20180906094532.GG230707@Turing-Arch-b>
	<20180906133133.GA3830@redhat.com>
	<20180907040138.GI230707@Turing-Arch-b>
	<20180907165303.GA3519@redhat.com>
	<20180910032809.GJ230707@Turing-Arch-b>
	<20180910145423.GA3488@redhat.com>
	<20180911024209.GK230707@Turing-Arch-b>
	<20180911033358.GA4730@redhat.com>
	<20180911064043.GA207969@Turing-Arch-b>
	<20180911134013.GA3932@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Sanjay Kumar <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hao
	Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
	Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
	"David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
To: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180911134013.GA3932-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 11, 2018 at 09:40:14AM -0400, Jerome Glisse wrote:
> Date: Tue, 11 Sep 2018 09:40:14 -0400
> From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> CC: Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Williamson
>  <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
>  kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman
>  <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
>  linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sanjay Kumar <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hao
>  Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
>  linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "David S . Miller"
>  <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhou Wang
>  <wangzhou1-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>,
>  Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>,
>  linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
> User-Agent: Mutt/1.10.1 (2018-07-13)
> Message-ID: <20180911134013.GA3932-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =

> On Tue, Sep 11, 2018 at 02:40:43PM +0800, Kenneth Lee wrote:
> > On Mon, Sep 10, 2018 at 11:33:59PM -0400, Jerome Glisse wrote:
> > > On Tue, Sep 11, 2018 at 10:42:09AM +0800, Kenneth Lee wrote:
> > > > On Mon, Sep 10, 2018 at 10:54:23AM -0400, Jerome Glisse wrote:
> > > > > On Mon, Sep 10, 2018 at 11:28:09AM +0800, Kenneth Lee wrote:
> > > > > > On Fri, Sep 07, 2018 at 12:53:06PM -0400, Jerome Glisse wrote:
> > > > > > > On Fri, Sep 07, 2018 at 12:01:38PM +0800, Kenneth Lee wrote:
> > > > > > > > On Thu, Sep 06, 2018 at 09:31:33AM -0400, Jerome Glisse wro=
te:
> > > > > > > > > On Thu, Sep 06, 2018 at 05:45:32PM +0800, Kenneth Lee wro=
te:
> > > > > > > > > > On Tue, Sep 04, 2018 at 10:15:09AM -0600, Alex Williams=
on wrote:
> > > > > > > > > > > On Tue, 4 Sep 2018 11:00:19 -0400 Jerome Glisse <jgli=
sse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > > > > > > > > > > On Mon, Sep 03, 2018 at 08:51:57AM +0800, Kenneth L=
ee wrote:
> > > > > =

> > > > > [...]
> > > > > =

> > > > > > > > I took a look at i915_gem_execbuffer_ioctl(). It seems it "=
copy_from_user" the
> > > > > > > > user memory to the kernel. That is not what we need. What w=
e try to get is: the
> > > > > > > > user application do something on its data, and push it away=
 to the accelerator,
> > > > > > > > and says: "I'm tied, it is your turn to do the job...". The=
n the accelerator has
> > > > > > > > the memory, referring any portion of it with the same VAs o=
f the application,
> > > > > > > > even the VAs are stored inside the memory itself.
> > > > > > > =

> > > > > > > You were not looking at right place see drivers/gpu/drm/i915/=
i915_gem_userptr.c
> > > > > > > It does GUP and create GEM object AFAICR you can wrap that GE=
M object into a
> > > > > > > dma buffer object.
> > > > > > > =

> > > > > > =

> > > > > > Thank you for directing me to this implementation. It is intere=
sting:).
> > > > > > =

> > > > > > But it is not yet solve my problem. If I understand it right, t=
he userptr in
> > > > > > i915 do the following:
> > > > > > =

> > > > > > 1. The user process sets a user pointer with size to the kernel=
 via ioctl.
> > > > > > 2. The kernel wraps it as a dma-buf and keeps the process's mm =
for further
> > > > > >    reference.
> > > > > > 3. The user pages are allocated, GUPed or DMA mapped to the dev=
ice. So the data
> > > > > >    can be shared between the user space and the hardware.
> > > > > > =

> > > > > > But my scenario is: =

> > > > > > =

> > > > > > 1. The user process has some data in the user space, pointed by=
 a pointer, say
> > > > > >    ptr1. And within the memory, there may be some other pointer=
s, let's say one
> > > > > >    of them is ptr2.
> > > > > > 2. Now I need to assign ptr1 *directly* to the hardware MMIO sp=
ace. And the
> > > > > >    hardware must refer ptr1 and ptr2 *directly* for data.
> > > > > > =

> > > > > > Userptr lets the hardware and process share the same memory spa=
ce. But I need
> > > > > > them to share the same *address space*. So IOMMU is a MUST for =
WarpDrive,
> > > > > > NOIOMMU mode, as Jean said, is just for verifying some of the p=
rocedure is OK.
> > > > > =

> > > > > So to be 100% clear should we _ignore_ the non SVA/SVM case ?
> > > > > If so then wait for necessary SVA/SVM to land and do warp drive
> > > > > without non SVA/SVM path.
> > > > > =

> > > > =

> > > > I think we should clear the concept of SVA/SVM here. As my understa=
nding, Share
> > > > Virtual Address/Memory means: any virtual address in a process can =
be used by
> > > > device at the same time. This requires IOMMU device to support PASI=
D. And
> > > > optionally, it requires the feature of page-fault-from-device.
> > > =

> > > Yes we agree on what SVA/SVM is. There is a one gotcha thought, access
> > > to range that are MMIO map ie CPU page table pointing to IO memory, I=
IRC
> > > it is undefined what happens on some platform for a device trying to
> > > access those using SVA/SVM.
> > > =

> > > =

> > > > But before the feature is settled down, IOMMU can be used immediate=
ly in the
> > > > current kernel. That make it possible to assign ONE process's virtu=
al addresses
> > > > to the device's IOMMU page table with GUP. This make WarpDrive work=
 well for one
> > > > process.
> > > =

> > > UH ? How ? You want to GUP _every_ single valid address in the process
> > > and map it to the device ? How do you handle new vma, page being repl=
ace
> > > (despite GUP because of things that utimately calls zap pte) ...
> > > =

> > > Again here you said that the device must be able to access _any_ valid
> > > pointer. With GUP this is insane.
> > > =

> > > So i am assuming this is not what you want to do without SVA/SVM ie w=
ith
> > > GUP you have a different programming model, one in which the userspace
> > > must first bind _range_ of memory to the device and get a DMA address
> > > for the range.
> > > =

> > > Again, GUP range of process address space to map it to a device so th=
at
> > > userspace can use the device on the mapped range is something that do
> > > exist in various places in the kernel.
> > > =

> > =

> > Yes same as your expectation, in WarpDrive, we use the concept of "shar=
ing" to
> > do so. If some memory is going to be shared among process and devices, =
we use
> > wd_share_mem(queue, ptr, size) to share those memory. When the queue is=
 working
> > in this mode, the point is valid in those memory segments. The wd_share=
_mem call
> > vfio dma map syscall which will do GUP. =

> > =

> > If SVA/SVM is enabled, user space can set SHARE_ALL flags to the queue.=
 Then
> > wd_share_mem() is not necessary.
> > =

> > This is really not popular when we started the work on WarpDrive. The G=
UP
> > document said it should be put within the scope of mm_sem is locked. Be=
cause GUP
> > simply increase the page refcount, not keep the mapping between the pag=
e and the
> > vma. We keep our work together with VFIO to make sure the problem can b=
e solved
> > in one deal.
> =

> The problem can not be solved in one deal, you can not maintain vaddr
> pointing to same page after a fork() this can not be solve without the
> use of mmu notifier and device dma mapping invalidation ! So being part
> of VFIO will not help you there.

Good point. But sadly, even with mmu notifier and dma mapping invalidation,=
 I
cannot do anything here. If the process fork a sub-process, the sub-process=
 need
a new pasid and hardware resource. The IOMM space mapped should not be used=
. The
parent process should be aware of this, unmap and close the device file bef=
ore
the fork. I have the same limitation as VFIO:(

I don't think I can change much here. If I can, VFIO can too:)

> =

> AFAIK VFIO is fine with the way it is as QEMU do not fork() once it
> is running a guest and thus the COW that would invalidate vaddr to
> physical page assumption is not broken. So i doubt VFIO folks have
> any incentive to go down the mmu notifier path and invalidate device
> mapping. They also have the replay thing that probably handle some
> of fork cases by trusting user space program to do it. In your case
> you can not trust the user space program.
> =

> In your case AFAICT i do not see any warning or gotcha so the following
> scenario is broken (in non SVA/SVM):
>     1) program setup the device (open container, mdev, setup queue, ...)
>     2) program map some range of its address space wih VFIO_IOMMU_MAP_DMA
>     3) program start using the device using map setup in 2)
>     ...
>     4) program fork()
>     5) parent trigger COW inside the range setup in 2)
> =

>     At this point it is the child process that can write to the page that
>     are access by the device (which was map by the parent in 2)). The
>     parent can no longer access that memory from the CPU.
> =

> There is just no sane way to fix this beside invalidating device mapping
> on fork (and you can not rely on userspace to do so) and thus stopping
> the device on fork (SVA/SVM case do not have any issue here).

Indeed. But as soon as we choose to expose the device space to the user spa=
ce,
the limitation is already there. If we want to solve the problem, we have to
have a hook in the copy_process() procedure and copy the parent's queue sta=
te to
a new queue, assign it to the child's fd and redirect the child's mmap to
it. If I can do so, the same logic can also be applied to VFIO.

The good side is, this is not a security leak. The hardware has been given =
to
the process. It is the process who choose to share it. If it won't work, it=
 is
the process's problem;)

> =

> > And now we have GUP-longterm and many accounting work in VFIO, we don't=
 want to
> > do that again.
> =

> GUP-longterm does not solve any GUP problem, it just block people to
> do GUP on DAX backed vma to avoid pining persistent memory as it is
> a nightmare to handle in the block device driver and file system code.
> =

> The accounting is the rt limit thing and is litteraly 10 lines of
> code so i would not see that as hard to replicate.

OK. Agree.

> =

> =

> > > > Now We are talking about SVA and PASID, just to make sure WarpDrive=
 can benefit
> > > > from the feature in the future. It dose not means WarpDrive is usel=
ess before
> > > > that. And it works for our Zip and RSA accelerators in physical wor=
ld.
> > > =

> > > Just not with random process address ...
> > > =

> > > > > If you still want non SVA/SVM path what you want to do only works
> > > > > if both ptr1 and ptr2 are in a range that is DMA mapped to the
> > > > > device (moreover you need DMA address to match process address
> > > > > which is not an easy feat).
> > > > > =

> > > > > Now even if you only want SVA/SVM, i do not see what is the point
> > > > > of doing this inside VFIO. AMD GPU driver does not and there would
> > > > > be no benefit for them to be there. Well a AMD VFIO mdev device
> > > > > driver for QEMU guest might be useful but they have SVIO IIRC.
> > > > > =

> > > > > For SVA/SVM your usage model is:
> > > > > =

> > > > > Setup:
> > > > >     - user space create a warp drive context for the process
> > > > >     - user space create a device specific context for the process
> > > > >     - user space create a user space command queue for the device
> > > > >     - user space bind command queue
> > > > > =

> > > > >     At this point the kernel driver has bound the process address
> > > > >     space to the device with a command queue and userspace
> > > > > =

> > > > > Usage:
> > > > >     - user space schedule work and call appropriate flush/update
> > > > >       ioctl from time to time. Might be optional depends on the
> > > > >       hardware, but probably a good idea to enforce so that kernel
> > > > >       can unbind the command queue to bind another process command
> > > > >       queue.
> > > > >     ...
> > > > > =

> > > > > Cleanup:
> > > > >     - user space unbind command queue
> > > > >     - user space destroy device specific context
> > > > >     - user space destroy warp drive context
> > > > >     All the above can be implicit when closing the device file.
> > > > > =

> > > > > So again in the above model i do not see anywhere something from
> > > > > VFIO that would benefit this model.
> > > > > =

> > > > =

> > > > Let me show you how the model will be if I use VFIO:
> > > > =

> > > > Setup (Kernel part)
> > > > 	- Kernel driver do every as usual to serve the other functionality=
, NIC
> > > > 	  can still be registered to netdev, encryptor can still be regist=
ered
> > > > 	  to crypto...
> > > > 	- At the same time, the driver can devote some of its hardware res=
ource
> > > > 	  and register them as a mdev creator to the VFIO framework. This =
just
> > > > 	  need limited change to the VFIO type1 driver.
> > > =

> > > In the above VFIO does not help you one bit ... you can do that with
> > > as much code with new common device as front end.
> > > =

> > > > Setup (User space)
> > > > 	- System administrator create mdev via the mdev creator interface.
> > > > 	- Following VFIO setup routine, user space open the mdev's group, =
there is
> > > > 	  only one group for one device.
> > > > 	- Without PASID support, you don't need to do anything. With PASID=
, bind
> > > > 	  the PASID to the device via VFIO interface.
> > > > 	- Get the device from the group via VFIO interface and mmap it the=
 user
> > > > 	  space for device's MMIO access (for the queue).
> > > > 	- Map whatever memory you need to share with the device with VFIO
> > > > 	  interface.
> > > > 	- (opt) Add more devices into the container if you want to share t=
he
> > > > 	  same address space with them
> > > =

> > > So all VFIO buys you here is boiler plate code that does insert_pfn()
> > > to handle MMIO mapping. Which is just couple hundred lines of boiler
> > > plate code.
> > > =

> > =

> > No. With VFIO, I don't need to:
> > =

> > 1. GUP and accounting for RLIMIT_MEMLOCK
> =

> That's 10 line of code ...
> =

> > 2. Keep all GUP pages for releasing (VFIO uses the rb_tree to do so)
> =

> GUP pages are not part of rb_tree and what you want to do can be done
> in few lines of code here is pseudo code:
> =

> warp_dma_map_range(ulong vaddr, ulong npages)
> {
>     struct page *pages =3D kvzalloc(npages);
> =

>     for (i =3D 0; i < npages; ++i, vaddr +=3D PAGE_SIZE) {
>         GUP(vaddr, &pages[i]);
>         iommu_map(vaddr, page_to_pfn(pages[i]));
>     }
>     kvfree(pages);
> }
> =

> warp_dma_unmap_range(ulong vaddr, ulong npages)
> {
>     for (i =3D 0; i < npages; ++i, vaddr +=3D PAGE_SIZE) {
>         unsigned long pfn;
> =

>         pfn =3D iommu_iova_to_phys(vaddr);
>         iommu_unmap(vaddr);
>         put_page(pfn_to_page(page)); /* set dirty if mapped write */
>     }
> }
> =


But what if the process exist without unmapping? The pages will be pinned i=
n the
kernel forever.

> Add locking, error handling, dirtying and comments and you are barely
> looking at couple hundred lines of code. You do not need any of the
> complexity of VFIO as you do not have the same requirements. Namely
> VFIO have to keep track of iova and physical mapping for things like
> migration (migrating guest between host) and few others very
> virtualization centric requirements.
> =

> =

> > 2. Handle the PASID on SMMU (ARM's IOMMU) myself.
> =

> Existing driver do that with 20 lines of with comments and error
> handling (see kfd_iommu_bind_process_to_device() for instance) i
> doubt you need much more than that.
> =


OK, I agree.

> =

> > 3. Multiple devices menagement (VFIO uses container to manage this)
> =

> All the vfio_group* stuff ? OK that's boiler plate code, note that
> hard to replicate thought.

No, I meant the container thing. Several devices/group can be assigned to t=
he
same container and the DMA on the container can be assigned to all those
devices. So we can have some devices to share the same name space.

> =

> > And even as a boiler plate, it is valueable, the memory thing is sensit=
ive
> > interface to user space, it can easily become a security problem. If I =
can
> > achieve my target within the scope of VFIO, why not? At lease it has be=
en
> > proved to be safe for the time being.
> =

> The thing is being part of VFIO impose things on you, things that you
> do not need. Like one device per group (maybe it is you imposing this,
> i am loosing track here). Or the complex dma mapping tracking ...
> =


Err... But the one-device-per-group is not VFIO's decision. It is IOMMU's :=
).
Unless I don't use IOMMU.

> =

> > > > Cleanup:
> > > > 	- User space close the group file handler
> > > > 	- There will be a problem to let the other process know the mdev is
> > > > 	  freed to be used again. My RFCv1 choose a file handler solution.=
 Alex
> > > > 	  dose not like it. But it is not a big problem. We can always hav=
e a
> > > > 	  scheduler process to manage the state of the mdev or even we can
> > > > 	  switch back to the RFCv1 solution without too much effort if we =
like
> > > > 	  in the future.
> > > =

> > > If you were outside VFIO you would have more freedom on how to do tha=
t.
> > > For instance process opening the device file can be placed on queue a=
nd
> > > first one in the queue get to use the device until it closes/release =
the
> > > device. Then next one in queue get the device ...
> > =

> > Yes. I do like the file handle solution. But I hope the solution become=
 mature
> > as soon as possible. Many of our products, and as I know include some o=
f our
> > partners, are waiting for a long term solution as direction. If I rely =
on some
> > unmature solution, they may choose some deviated, customized solution. =
That will
> > be much harmful. Compare to this, the freedom is not so important...
> =

> I do not see how being part of VFIO protect you from people doing crazy
> thing to their kernel ... Time to market being key in this world, i doubt
> that being part of VFIO would make anyone think twice before taking a
> shortcut.
> =

> I have seen horrible things on that front and only players like Google
> can impose a minimum level of sanity.
> =


OK. My fault, to talk about TTM. It has nothing doing with the architecture
decision. But I don't yet see what harm will be brought if I use VFIO when =
it
can fulfill almost all my requirements.

> =

> > > > Except for the minimum update to the type1 driver and use sdmdev to=
 manage the
> > > > interrupt sharing, I don't need any extra code to gain the address =
sharing
> > > > capability. And the capability will be strengthen along with the up=
grade of VFIO.
> > > > =

> > > > > =

> > > > > > > > And I don't understand why I should avoid to use VFIO? As A=
lex said, VFIO is the
> > > > > > > > user driver framework. And I need exactly a user driver int=
erface. Why should I
> > > > > > > > invent another wheel? It has most of stuff I need:
> > > > > > > > =

> > > > > > > > 1. Connecting multiple devices to the same application space
> > > > > > > > 2. Pinning and DMA from the application space to the whole =
set of device
> > > > > > > > 3. Managing hardware resource by device
> > > > > > > > =

> > > > > > > > We just need the last step: make sure multiple applications=
 and the kernel can
> > > > > > > > share the same IOMMU. Then why shouldn't we use VFIO?
> > > > > > > =

> > > > > > > Because tons of other drivers already do all of the above out=
side VFIO. Many
> > > > > > > driver have a sizeable userspace side to them (anything with =
ioctl do) so they
> > > > > > > can be construded as userspace driver too.
> > > > > > > =

> > > > > > =

> > > > > > Ignoring if there are *tons* of drivers are doing that;), even =
I do the same as
> > > > > > i915 and solve the address space problem. And if I don't need t=
o with VFIO, why
> > > > > > should I spend so much effort to do it again?
> > > > > =

> > > > > Because you do not need any code from VFIO, nor do you need to re=
invent
> > > > > things. If non SVA/SVM matters to you then use dma buffer. If not=
 then
> > > > > i do not see anything in VFIO that you need.
> > > > > =

> > > > =

> > > > As I have explain, if I don't use VFIO, at lease I have to do all t=
hat has been
> > > > done in i915 or even more than that.
> > > =

> > > So beside the MMIO mmap() handling and dma mapping of range of user s=
pace
> > > address space (again all very boiler plate code duplicated accross the
> > > kernel several time in different forms). You do not gain anything bei=
ng
> > > inside VFIO right ?
> > > =

> > =

> > As I said, rb-tree for gup, rlimit accounting, cooperation on SMMU, and=
 mature
> > user interface are our concern.
> > > =

> > > > > > > So there is no reasons to do that under VFIO. Especialy as in=
 your example
> > > > > > > it is not a real user space device driver, the userspace port=
ion only knows
> > > > > > > about writting command into command buffer AFAICT.
> > > > > > > =

> > > > > > > VFIO is for real userspace driver where interrupt, configurat=
ions, ... ie
> > > > > > > all the driver is handled in userspace. This means that the u=
serspace have
> > > > > > > to be trusted as it could program the device to do DMA to any=
where (if
> > > > > > > IOMMU is disabled at boot which is still the default configur=
ation in the
> > > > > > > kernel).
> > > > > > > =

> > > > > > =

> > > > > > But as Alex explained, VFIO is not simply used by VM. So it nee=
d not to have all
> > > > > > stuffs as a driver in host system. And I do need to share the u=
ser space as DMA
> > > > > > buffer to the hardware. And I can get it with just a little upd=
ate, then it can
> > > > > > service me perfectly. I don't understand why I should choose a =
long route.
> > > > > =

> > > > > Again this is not the long route i do not see anything in VFIO th=
at
> > > > > benefit you in the SVA/SVM case. A basic character device driver =
can
> > > > > do that.
> > > > > =

> > > > > =

> > > > > > > So i do not see any reasons to do anything you want inside VF=
IO. All you
> > > > > > > want to do can be done outside as easily. Moreover it would b=
e better if
> > > > > > > you define clearly each scenario because from where i sit it =
looks like
> > > > > > > you are opening the door wide open to userspace to DMA anywhe=
re when IOMMU
> > > > > > > is disabled.
> > > > > > > =

> > > > > > > When IOMMU is disabled you can _not_ expose command queue to =
userspace
> > > > > > > unless your device has its own page table and all commands ar=
e relative
> > > > > > > to that page table and the device page table is populated by =
kernel driver
> > > > > > > in secure way (ie by checking that what is populated can be a=
ccess).
> > > > > > > =

> > > > > > > I do not believe your example device to have such page table =
nor do i see
> > > > > > > a fallback path when IOMMU is disabled that force user to do =
ioctl for
> > > > > > > each commands.
> > > > > > > =

> > > > > > > Yes i understand that you target SVA/SVM but still you claim =
to support
> > > > > > > non SVA/SVM. The point is that userspace can not be trusted i=
f you want
> > > > > > > to have random program use your device. I am pretty sure that=
 all user
> > > > > > > of VFIO are trusted process (like QEMU).
> > > > > > > =

> > > > > > > =

> > > > > > > Finaly i am convince that the IOMMU grouping stuff related to=
 VFIO is
> > > > > > > useless for your usecase. I really do not see the point of th=
at, it
> > > > > > > does complicate things for you for no reasons AFAICT.
> > > > > > =

> > > > > > Indeed, I don't like the group thing. I believe VFIO's maintain=
s would not like
> > > > > > it very much either;). But the problem is, the group reflects t=
o the same
> > > > > > IOMMU(unit), which may shared with other devices.  It is a secu=
rity problem. I
> > > > > > cannot ignore it. I have to take it into account event I don't =
use VFIO.
> > > > > =

> > > > > To me it seems you are making a policy decission in kernel space =
ie
> > > > > wether the device should be isolated in its own group or not is a
> > > > > decission that is up to the sys admin or something in userspace.
> > > > > Right now existing user of SVA/SVM don't (at least AFAICT).
> > > > > =

> > > > > Do we really want to force such isolation ?
> > > > > =

> > > > =

> > > > But it is not my decision, that how the iommu subsystem is designed=
. Personally
> > > > I don't like it at all, because all our hardwares have their own st=
ream id
> > > > (device id). I don't need the group concept at all. But the iommu s=
ubsystem
> > > > assume some devices may share the name device ID to a single IOMMU.
> > > =

> > > My question was do you really want to force group isolation for the
> > > device ? Existing SVA/SVM capable driver do not force that, they let
> > > the userspace decide this (sysadm, distributions, ...). Being part of
> > > VFIO (in the way you do, likely ways to avoid this inside VFIO too)
> > > force this decision ie make a policy decision without userspace having
> > > anything to say about it.
> =

> You still do not answer my question, do you really want to force group
> isolation for device in your framework ? Which is a policy decision from
> my POV and thus belong to userspace and should not be enforce by kernel.

No. But I have to follow the rule defined by IOMMU, haven't I?

> =

> =

> > > The IOMMU group thing as always been doubt full to me, it is advertise
> > > as allowing to share resources (ie IOMMU page table) between devices.
> > > But this assume that all device driver in the group have some way of
> > > communicating with each other to share common DMA address that point
> > > to memory devices care. I believe only VFIO does that and probably
> > > only when use by QEMU.
> > > =

> > > =

> > > Anyway my question is:
> > > =

> > > Is it that much useful to be inside VFIO (to avoid few hundred lines
> > > of boiler plate code) given that it forces you into a model (group
> > > isolation) that so far have never been the prefered way for all
> > > existing device driver that already do what you want to achieve ?
> > > =

> > =

> > You mean to say I create another framework and copy most of the code fr=
om VFIO?
> > It is hard to believe the mainline kernel will take my code. So how abo=
ut let me
> > try the VFIO way first and try that if it won't work? ;)
> =

> There is no trying, this is the kernel, once you expose something to
> userspace you have to keep supporting it forever ... There is no, hey
> let's add this new framework and see how it goes and removing it few
> kernel version latter ...
> =


No, I don't meant it was unserious when I said "try". I was just not sure i=
f the
community can accept it. =


Can Alex say something on this? Is this scenario in the future scope of VFI=
O? If
it is, we have the season to solve the problem on the way. If it is not, we
should choose other way even we have to copy most of the code.

> That is why i am being pedantic :) on making sure there is good reasons
> to do what you do inside VFIO. I do believe that we want a common frame-
> work like the one you are proposing but i do not believe it should be
> part of VFIO given the baggages it comes with and that are not relevant
> to the use cases for this kind of devices.

Understood. And I appreciate the discussion and help:)

Cheers
> =

> Cheers,
> J=E9r=F4me

-- =

			-Kenneth(Hisilicon)
