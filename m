From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Tue, 18 Sep 2018 14:00:14 +0800
Message-ID: <20180918060014.GF207969@Turing-Arch-b>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
	<20180917014244.GA27596@redhat.com>
	<20180917083940.GE207969@Turing-Arch-b>
	<20180917123744.GA3605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Sanjay Kumar <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Hao Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org,
	"David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>, Thomas
	Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
To: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180917123744.GA3605-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

On Mon, Sep 17, 2018 at 08:37:45AM -0400, Jerome Glisse wrote:
> Date: Mon, 17 Sep 2018 08:37:45 -0400
> From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> CC: Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Herbert Xu
>  <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet
>  <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Joerg
>  Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sanjay Kumar
>  <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hao Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
>  iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
>  linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas
>  Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhou Wang
>  <wangzhou1-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>,
>  Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
>  linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
> User-Agent: Mutt/1.10.1 (2018-07-13)
> Message-ID: <20180917123744.GA3605-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =

> On Mon, Sep 17, 2018 at 04:39:40PM +0800, Kenneth Lee wrote:
> > On Sun, Sep 16, 2018 at 09:42:44PM -0400, Jerome Glisse wrote:
> > > So i want to summarize issues i have as this threads have dig deep in=
to
> > > details. For this i would like to differentiate two cases first the e=
asy
> > > one when relying on SVA/SVM. Then the second one when there is no SVA=
/SVM.
> > =

> > Thank you very much for the summary.
> > =

> > > In both cases your objectives as i understand them:
> > > =

> > > [R1]- expose a common user space API that make it easy to share boiler
> > >       plate code accross many devices (discovering devices, opening
> > >       device, creating context, creating command queue ...).
> > > [R2]- try to share the device as much as possible up to device limits
> > >       (number of independant queues the device has)
> > > [R3]- minimize syscall by allowing user space to directly schedule on=
 the
> > >       device queue without a round trip to the kernel
> > > =

> > > I don't think i missed any.
> > > =

> > > =

> > > (1) Device with SVA/SVM
> > > =

> > > For that case it is easy, you do not need to be in VFIO or part of any
> > > thing specific in the kernel. There is no security risk (modulo bug in
> > > the SVA/SVM silicon). Fork/exec is properly handle and binding a proc=
ess
> > > to a device is just couple dozen lines of code.
> > > =

> > =

> > This is right...logically. But the kernel has no clear definition about=
 "Device
> > with SVA/SVM" and no boiler plate for doing so. Then VFIO may become on=
e of the
> > boiler plate.
> > =

> > VFIO is one of the wrappers for IOMMU for user space. And maybe it is t=
he only
> > one. If we add that support within VFIO, which solve most of the proble=
m of
> > SVA/SVM, it will save a lot of work in the future.
> =

> You do not need to "wrap" IOMMU for SVA/SVM. Existing upstream SVA/SVM us=
er
> all do the SVA/SVM setup in couple dozen lines and i failed to see how it
> would require any more than that in your case.
> =

> =

> > I think this is the key confliction between us. So could Alex please say
> > something here? If the VFIO is going to take this into its scope, we ca=
n try
> > together to solve all the problem on the way. If it it is not, it is al=
so
> > simple, we can just go to another way to fulfill this part of requireme=
nts even
> > we have to duplicate most of the code.
> > =

> > Another point I need to emphasis here: because we have to replace the h=
ardware
> > queue when fork, so it won't be very simple even in SVA/SVM case.
> =

> I am assuming hardware queue can only be setup by the kernel and thus
> you are totaly safe forkwise as the queue is setup against a PASID and
> the child does not bind to any PASID and you use VM_DONTCOPY on the
> mmap of the hardware MMIO queue because you should really use that flag
> for that.
> =

> =

> > > (2) Device does not have SVA/SVM (or it is disabled)
> > > =

> > > You want to still allow device to be part of your framework. However
> > > here i see fundamentals securities issues and you move the burden of
> > > being careful to user space which i think is a bad idea. We should
> > > never trus the userspace from kernel space.
> > > =

> > > To keep the same API for the user space code you want a 1:1 mapping
> > > between device physical address and process virtual address (ie if
> > > device access device physical address A it is accessing the same
> > > memory as what is backing the virtual address A in the process.
> > > =

> > > Security issues are on two things:
> > > [I1]- fork/exec, a process who opened any such device and created an
> > >       active queue can transfer without its knowledge control of its
> > >       commands queue through COW. The parent map some anonymous region
> > >       to the device as a command queue buffer but because of COW the
> > >       parent can be the first to copy on write and thus the child can
> > >       inherit the original pages that are mapped to the hardware.
> > >       Here parent lose control and child gain it.
> > =

> > This is indeed an issue. But it remains an issue only if you continue t=
o use the
> > queue and the memory after fork. We can use at_fork kinds of gadget to =
fix it in
> > user space.
> =

> Trusting user space is a no go from my point of view.

Can we dive deeper on this? Maybe we have different understanding on "Trust=
ing
user space". As my understanding, "trusting user space" means "no matter wh=
at
the user process does, it should only hurt itself and anything give to it, =
no
the kernel and the other process".

In our case, we create a channel between a process and the hardware. The pr=
ocess
can do whateven it like to its own memory the channel itself. It won't hurt=
 the
other process and the kernel. And if the process fork a child and give the
channel to the child, it should the freedom on those resource remain within=
 the
parent and the child. We are not trust another else.

So do you refer to something else here?

> =

> =

> > From some perspectives, I think the issue can be solved by iommu_notifi=
er. For
> > example, when the process is fork-ed, we can set the mapped device mmio=
 space as
> > COW for the child process, so a new queue can be created and set to the=
 same
> > state as the parent's if the space is accessed. Then we can have two se=
parated
> > queues for both the parent and the child. The memory part can be done i=
n the
> > same way.
> =

> The mmap of mmio space for the queue is not an issue just use VM_DONTCOPY
> for it. Issue is with COW and IOMMU mapping of pages and this can not be
> solve in your model.
> =

> > The thing is, the same strategy can be applied to VFIO without changing=
 its
> > original feature.
> =

> No it can not it would break existing VFIO contract (which only should be
> use against private anonymous vma).
> =

> > =

> > > =

> > > [I2]- Because of [R3] you want to allow userspace to schedule commands
> > >       on the device without doing an ioctl and thus here user space
> > >       can schedule any commands to the device with any address. What
> > >       happens if that address have not been mapped by the user space
> > >       is undefined and in fact can not be defined as what each IOMMU
> > >       does on invalid address access is different from IOMMU to IOMMU.
> > > =

> > >       In case of a bad IOMMU, or simply an IOMMU improperly setup by
> > >       the kernel, this can potentialy allow user space to DMA anywher=
e.
> > =

> > I don't think this is an issue. If you cannot trust IOMMU and proper se=
tup of
> > IOMMU in kernel, you cannot trust anything. And the whole VFIO framewor=
k is
> > untrustable.
> =

> VFIO device is usualy restricted to trusted user and other device that
> do DMA do various checks to make sure user space can not abuse them, the
> assumption i have always seen so far is to not trust that IOMMU will do
> all the work. So exposing user space access to device with DMA capabiliti=
es
> should be done carefuly IMHO.
> =

> To be thorough list of potential bugs i am concern about:
>     - IOMMU hardware bug
>     - IOMMU does not isolate device after too many fail attempt
>     - firmware setup the IOMMU in some unsafe way and linux kernel does
>       not catch that (like passthrough on error or when there is no
>       entry for the PA which i am told is a thing for debug)
>     - bug in the linux IOMMU kernel driver
> =

> =

> =

> > > =

> > > [I3]- By relying on GUP in VFIO you are not abiding by the implicit
> > >       contract (at least i hope it is implicit) that you should not
> > >       try to map to the device any file backed vma (private or share).
> > > =

> > >       The VFIO code never check the vma controlling the addresses that
> > >       are provided to VFIO_IOMMU_MAP_DMA ioctl. Which means that the
> > >       user space can provide file backed range.
> > > =

> > >       I am guessing that the VFIO code never had any issues because i=
ts
> > >       number one user is QEMU and QEMU never does that (and that's go=
od
> > >       as no one should ever do that).
> > > =

> > >       So if process does that you are opening your self to serious fi=
le
> > >       system corruption (depending on file system this can lead to to=
tal
> > >       data loss for the filesystem).
> > > =

> > >       Issue is that once you GUP you never abide to file system flush=
ing
> > >       which write protect the page before writing to the disk. So
> > >       because the page is still map with write permission to the devi=
ce
> > >       (assuming VFIO_IOMMU_MAP_DMA was a write map) then the device c=
an
> > >       write to the page while it is in the middle of being written ba=
ck
> > >       to disk. Consult your nearest file system specialist to ask him
> > >       how bad that can be.
> > =

> > Same as I2, it is an issue, but the problem can be solved in VFIO if we=
 really
> > take it in the scope of VFIO.
> =

> Except it can not be solve without breaking VFIO. If you use mmu_notifier
> it means that the the IOMMU mapping can vanish at _any_ time and because
> you allow user space to directly schedule work on the hardware command
> queue than you do not have any synchronization point to use.
> =

> When notifier calls you must stop all hardware access and wait for any
> pending work that might still dereference affected range. Finaly you can
> restore mapping only once the notifier is done. AFAICT this would break
> all existing VFIO user.
> =

> So solving that for your case it means you would have to:
> warp_invalidate_range_callback() {
>     - take some lock to protect against restore
>     - unmap the command queue (zap_range) from userspace to stop further
>       commands
>     - wait for any pending commands on the hardware to complete
>     - clear all IOMMU mappings for the range
>     - put_pages()
>     - drop restore lock
>     return to let invalidation complete its works
> }
> =

> warp_restore() {
>     // This is call by the page fault handler on the command queue mapped
>     // to user space.
>     - take restore lock
>     - go over all IOMMU mapping and restore them (GUP)
>     - remap command queue to userspace
>     - drop restore lock
> }
> =

> This model does not work for VFIO existing users AFAICT.
> =

> =

> > > [I4]- Design issue, mdev design As Far As I Understand It is about
> > >       sharing a single device to multiple clients (most obvious case
> > >       here is again QEMU guest). But you are going against that model,
> > >       in fact AFAIUI you are doing the exect opposite. When there is
> > >       no SVA/SVM you want only one mdev device that can not be share.
> > =

> > Wait. It is NOT "I want only one mdev device when there is no SVA/SVM",=
 it is "I
> > can support only one mdev when there is no PASID support for the IOMMU".
> =

> Except you can support more than one user when no SVA/SVM with the model
> i outlined below.
> =

> =

> > > =

> > >       So this is counter intuitive to the mdev existing design. It is
> > >       not about sharing device among multiple users but about giving
> > >       exclusive access to the device to one user.
> > > =

> > > =

> > > =

> > > All the reasons above is why i believe a different model would serve
> > > you and your user better. Below is a design that avoids all of the
> > > above issues and still delivers all of your objectives with the
> > > exceptions of the third one [R3] when there is no SVA/SVM.
> > > =

> > > =

> > > Create a subsystem (very much boiler plate code) which allow device to
> > > register themself against (very much like what you do in your current
> > > patchset but outside of VFIO).
> > > =

> > > That subsystem will create a device file for each registered system a=
nd
> > > expose a common API (ie set of ioctl) for each of those device files.
> > > =

> > > When user space create a queue (through an ioctl after opening the de=
vice
> > > file) the kernel can return -EBUSY if all the device queue are in use,
> > > or create a device queue and return a flag like SYNC_ONLY for device =
that
> > > do not have SVA/SVM.
> > > =

> > > For device with SVA/SVM at the time the process create a queue you bi=
nd
> > > the process PASID to the device queue. From there on the userspace can
> > > schedule commands and use the device without going to kernel space.
> > =

> > As mentioned previously, this is not enough for fork scenario.
> =

> It is for every existing user of SVA/SVM so i fail to see why it would
> be any different in your case. Note that they all use VM_DONTCOPY flag
> on the queue mapped to userspace.
> =

> =

> > > For device without SVA/SVM you create a fake queue that is just pure
> > > memory is not related to the device. From there on the userspace must
> > > call an ioctl every time it wants the device to consume its queue
> > > (hence why the SYNC_ONLY flag for synchronous operation only). The
> > > kernel portion read the fake queue expose to user space and copy
> > > commands into the real hardware queue but first it properly map any
> > > of the process memory needed for those commands to the device and
> > > adjust the device physical address with the one it gets from dma_map
> > > API.
> > > =

> > =

> > But in this way, we will lost most of the benefit of avoiding syscall.
> =

> Yes but only when there is SVA/SVM. What i am trying to stress is that
> there is no sane way to mirror user space address space onto device
> without mmu_notifier so short of that this model where you have to
> syscall to schedules thing on the hardware is the easiest thing to do.
> =

> =

> > > With that model it is "easy" to listen to mmu_notifier and to abide by
> > > them to avoid issues [I1], [I3] and [I4]. You obviously avoid the [I2]
> > > issue by only mapping a fake device queue to userspace.
> > > =

> > > So yes with that models it means that every device that wish to suppo=
rt
> > > the non SVA/SVM case will have to do extra work (ie emulate its comma=
nd
> > > queue in software in the kernel). But by doing so, you support an
> > > unlimited number of process on your device (ie all the process can sh=
are
> > > one single hardware command queues or multiple hardware queues).
> > =

> > If I can do this, I will not need WarpDrive at all:(
> =

> This is only needed if you wish to support non SVA/SVM, shifting the
> burden to the kernel is always the thing to do especially if they are
> legitimate security concerns.

For the other part, please give me some more time to write some test code a=
nd
come back to the discussino. Thank you.

Cheers

> =

> =

> Cheers,
> J=E9r=F4me

-- =

			-Kenneth(Hisilicon)
