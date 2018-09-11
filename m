From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Mon, 10 Sep 2018 23:33:59 -0400
Message-ID: <20180911033358.GA4730@redhat.com>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
	<20180904150019.GA4024@redhat.com>
	<20180904101509.62314b67@t450s.home>
	<20180906094532.GG230707@Turing-Arch-b>
	<20180906133133.GA3830@redhat.com>
	<20180907040138.GI230707@Turing-Arch-b>
	<20180907165303.GA3519@redhat.com>
	<20180910032809.GJ230707@Turing-Arch-b>
	<20180910145423.GA3488@redhat.com>
	<20180911024209.GK230707@Turing-Arch-b>
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
	Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180911024209.GK230707@Turing-Arch-b>
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

On Tue, Sep 11, 2018 at 10:42:09AM +0800, Kenneth Lee wrote:
> On Mon, Sep 10, 2018 at 10:54:23AM -0400, Jerome Glisse wrote:
> > On Mon, Sep 10, 2018 at 11:28:09AM +0800, Kenneth Lee wrote:
> > > On Fri, Sep 07, 2018 at 12:53:06PM -0400, Jerome Glisse wrote:
> > > > On Fri, Sep 07, 2018 at 12:01:38PM +0800, Kenneth Lee wrote:
> > > > > On Thu, Sep 06, 2018 at 09:31:33AM -0400, Jerome Glisse wrote:
> > > > > > On Thu, Sep 06, 2018 at 05:45:32PM +0800, Kenneth Lee wrote:
> > > > > > > On Tue, Sep 04, 2018 at 10:15:09AM -0600, Alex Williamson wro=
te:
> > > > > > > > On Tue, 4 Sep 2018 11:00:19 -0400 Jerome Glisse <jglisse@re=
dhat.com> wrote:
> > > > > > > > > On Mon, Sep 03, 2018 at 08:51:57AM +0800, Kenneth Lee wro=
te:
> > =

> > [...]
> > =

> > > > > I took a look at i915_gem_execbuffer_ioctl(). It seems it "copy_f=
rom_user" the
> > > > > user memory to the kernel. That is not what we need. What we try =
to get is: the
> > > > > user application do something on its data, and push it away to th=
e accelerator,
> > > > > and says: "I'm tied, it is your turn to do the job...". Then the =
accelerator has
> > > > > the memory, referring any portion of it with the same VAs of the =
application,
> > > > > even the VAs are stored inside the memory itself.
> > > > =

> > > > You were not looking at right place see drivers/gpu/drm/i915/i915_g=
em_userptr.c
> > > > It does GUP and create GEM object AFAICR you can wrap that GEM obje=
ct into a
> > > > dma buffer object.
> > > > =

> > > =

> > > Thank you for directing me to this implementation. It is interesting:=
).
> > > =

> > > But it is not yet solve my problem. If I understand it right, the use=
rptr in
> > > i915 do the following:
> > > =

> > > 1. The user process sets a user pointer with size to the kernel via i=
octl.
> > > 2. The kernel wraps it as a dma-buf and keeps the process's mm for fu=
rther
> > >    reference.
> > > 3. The user pages are allocated, GUPed or DMA mapped to the device. S=
o the data
> > >    can be shared between the user space and the hardware.
> > > =

> > > But my scenario is: =

> > > =

> > > 1. The user process has some data in the user space, pointed by a poi=
nter, say
> > >    ptr1. And within the memory, there may be some other pointers, let=
's say one
> > >    of them is ptr2.
> > > 2. Now I need to assign ptr1 *directly* to the hardware MMIO space. A=
nd the
> > >    hardware must refer ptr1 and ptr2 *directly* for data.
> > > =

> > > Userptr lets the hardware and process share the same memory space. Bu=
t I need
> > > them to share the same *address space*. So IOMMU is a MUST for WarpDr=
ive,
> > > NOIOMMU mode, as Jean said, is just for verifying some of the procedu=
re is OK.
> > =

> > So to be 100% clear should we _ignore_ the non SVA/SVM case ?
> > If so then wait for necessary SVA/SVM to land and do warp drive
> > without non SVA/SVM path.
> > =

> =

> I think we should clear the concept of SVA/SVM here. As my understanding,=
 Share
> Virtual Address/Memory means: any virtual address in a process can be use=
d by
> device at the same time. This requires IOMMU device to support PASID. And
> optionally, it requires the feature of page-fault-from-device.

Yes we agree on what SVA/SVM is. There is a one gotcha thought, access
to range that are MMIO map ie CPU page table pointing to IO memory, IIRC
it is undefined what happens on some platform for a device trying to
access those using SVA/SVM.


> But before the feature is settled down, IOMMU can be used immediately in =
the
> current kernel. That make it possible to assign ONE process's virtual add=
resses
> to the device's IOMMU page table with GUP. This make WarpDrive work well =
for one
> process.

UH ? How ? You want to GUP _every_ single valid address in the process
and map it to the device ? How do you handle new vma, page being replace
(despite GUP because of things that utimately calls zap pte) ...

Again here you said that the device must be able to access _any_ valid
pointer. With GUP this is insane.

So i am assuming this is not what you want to do without SVA/SVM ie with
GUP you have a different programming model, one in which the userspace
must first bind _range_ of memory to the device and get a DMA address
for the range.

Again, GUP range of process address space to map it to a device so that
userspace can use the device on the mapped range is something that do
exist in various places in the kernel.

> Now We are talking about SVA and PASID, just to make sure WarpDrive can b=
enefit
> from the feature in the future. It dose not means WarpDrive is useless be=
fore
> that. And it works for our Zip and RSA accelerators in physical world.

Just not with random process address ...

> > If you still want non SVA/SVM path what you want to do only works
> > if both ptr1 and ptr2 are in a range that is DMA mapped to the
> > device (moreover you need DMA address to match process address
> > which is not an easy feat).
> > =

> > Now even if you only want SVA/SVM, i do not see what is the point
> > of doing this inside VFIO. AMD GPU driver does not and there would
> > be no benefit for them to be there. Well a AMD VFIO mdev device
> > driver for QEMU guest might be useful but they have SVIO IIRC.
> > =

> > For SVA/SVM your usage model is:
> > =

> > Setup:
> >     - user space create a warp drive context for the process
> >     - user space create a device specific context for the process
> >     - user space create a user space command queue for the device
> >     - user space bind command queue
> > =

> >     At this point the kernel driver has bound the process address
> >     space to the device with a command queue and userspace
> > =

> > Usage:
> >     - user space schedule work and call appropriate flush/update
> >       ioctl from time to time. Might be optional depends on the
> >       hardware, but probably a good idea to enforce so that kernel
> >       can unbind the command queue to bind another process command
> >       queue.
> >     ...
> > =

> > Cleanup:
> >     - user space unbind command queue
> >     - user space destroy device specific context
> >     - user space destroy warp drive context
> >     All the above can be implicit when closing the device file.
> > =

> > So again in the above model i do not see anywhere something from
> > VFIO that would benefit this model.
> > =

> =

> Let me show you how the model will be if I use VFIO:
> =

> Setup (Kernel part)
> 	- Kernel driver do every as usual to serve the other functionality, NIC
> 	  can still be registered to netdev, encryptor can still be registered
> 	  to crypto...
> 	- At the same time, the driver can devote some of its hardware resource
> 	  and register them as a mdev creator to the VFIO framework. This just
> 	  need limited change to the VFIO type1 driver.

In the above VFIO does not help you one bit ... you can do that with
as much code with new common device as front end.

> Setup (User space)
> 	- System administrator create mdev via the mdev creator interface.
> 	- Following VFIO setup routine, user space open the mdev's group, there =
is
> 	  only one group for one device.
> 	- Without PASID support, you don't need to do anything. With PASID, bind
> 	  the PASID to the device via VFIO interface.
> 	- Get the device from the group via VFIO interface and mmap it the user
> 	  space for device's MMIO access (for the queue).
> 	- Map whatever memory you need to share with the device with VFIO
> 	  interface.
> 	- (opt) Add more devices into the container if you want to share the
> 	  same address space with them

So all VFIO buys you here is boiler plate code that does insert_pfn()
to handle MMIO mapping. Which is just couple hundred lines of boiler
plate code.

> =

> Cleanup:
> 	- User space close the group file handler
> 	- There will be a problem to let the other process know the mdev is
> 	  freed to be used again. My RFCv1 choose a file handler solution. Alex
> 	  dose not like it. But it is not a big problem. We can always have a
> 	  scheduler process to manage the state of the mdev or even we can
> 	  switch back to the RFCv1 solution without too much effort if we like
> 	  in the future.

If you were outside VFIO you would have more freedom on how to do that.
For instance process opening the device file can be placed on queue and
first one in the queue get to use the device until it closes/release the
device. Then next one in queue get the device ...

> Except for the minimum update to the type1 driver and use sdmdev to manag=
e the
> interrupt sharing, I don't need any extra code to gain the address sharing
> capability. And the capability will be strengthen along with the upgrade =
of VFIO.
> =

> > =

> > > > > And I don't understand why I should avoid to use VFIO? As Alex sa=
id, VFIO is the
> > > > > user driver framework. And I need exactly a user driver interface=
. Why should I
> > > > > invent another wheel? It has most of stuff I need:
> > > > > =

> > > > > 1. Connecting multiple devices to the same application space
> > > > > 2. Pinning and DMA from the application space to the whole set of=
 device
> > > > > 3. Managing hardware resource by device
> > > > > =

> > > > > We just need the last step: make sure multiple applications and t=
he kernel can
> > > > > share the same IOMMU. Then why shouldn't we use VFIO?
> > > > =

> > > > Because tons of other drivers already do all of the above outside V=
FIO. Many
> > > > driver have a sizeable userspace side to them (anything with ioctl =
do) so they
> > > > can be construded as userspace driver too.
> > > > =

> > > =

> > > Ignoring if there are *tons* of drivers are doing that;), even I do t=
he same as
> > > i915 and solve the address space problem. And if I don't need to with=
 VFIO, why
> > > should I spend so much effort to do it again?
> > =

> > Because you do not need any code from VFIO, nor do you need to reinvent
> > things. If non SVA/SVM matters to you then use dma buffer. If not then
> > i do not see anything in VFIO that you need.
> > =

> =

> As I have explain, if I don't use VFIO, at lease I have to do all that ha=
s been
> done in i915 or even more than that.

So beside the MMIO mmap() handling and dma mapping of range of user space
address space (again all very boiler plate code duplicated accross the
kernel several time in different forms). You do not gain anything being
inside VFIO right ?


> > > > So there is no reasons to do that under VFIO. Especialy as in your =
example
> > > > it is not a real user space device driver, the userspace portion on=
ly knows
> > > > about writting command into command buffer AFAICT.
> > > > =

> > > > VFIO is for real userspace driver where interrupt, configurations, =
... ie
> > > > all the driver is handled in userspace. This means that the userspa=
ce have
> > > > to be trusted as it could program the device to do DMA to anywhere =
(if
> > > > IOMMU is disabled at boot which is still the default configuration =
in the
> > > > kernel).
> > > > =

> > > =

> > > But as Alex explained, VFIO is not simply used by VM. So it need not =
to have all
> > > stuffs as a driver in host system. And I do need to share the user sp=
ace as DMA
> > > buffer to the hardware. And I can get it with just a little update, t=
hen it can
> > > service me perfectly. I don't understand why I should choose a long r=
oute.
> > =

> > Again this is not the long route i do not see anything in VFIO that
> > benefit you in the SVA/SVM case. A basic character device driver can
> > do that.
> > =

> > =

> > > > So i do not see any reasons to do anything you want inside VFIO. Al=
l you
> > > > want to do can be done outside as easily. Moreover it would be bett=
er if
> > > > you define clearly each scenario because from where i sit it looks =
like
> > > > you are opening the door wide open to userspace to DMA anywhere whe=
n IOMMU
> > > > is disabled.
> > > > =

> > > > When IOMMU is disabled you can _not_ expose command queue to usersp=
ace
> > > > unless your device has its own page table and all commands are rela=
tive
> > > > to that page table and the device page table is populated by kernel=
 driver
> > > > in secure way (ie by checking that what is populated can be access).
> > > > =

> > > > I do not believe your example device to have such page table nor do=
 i see
> > > > a fallback path when IOMMU is disabled that force user to do ioctl =
for
> > > > each commands.
> > > > =

> > > > Yes i understand that you target SVA/SVM but still you claim to sup=
port
> > > > non SVA/SVM. The point is that userspace can not be trusted if you =
want
> > > > to have random program use your device. I am pretty sure that all u=
ser
> > > > of VFIO are trusted process (like QEMU).
> > > > =

> > > > =

> > > > Finaly i am convince that the IOMMU grouping stuff related to VFIO =
is
> > > > useless for your usecase. I really do not see the point of that, it
> > > > does complicate things for you for no reasons AFAICT.
> > > =

> > > Indeed, I don't like the group thing. I believe VFIO's maintains woul=
d not like
> > > it very much either;). But the problem is, the group reflects to the =
same
> > > IOMMU(unit), which may shared with other devices.  It is a security p=
roblem. I
> > > cannot ignore it. I have to take it into account event I don't use VF=
IO.
> > =

> > To me it seems you are making a policy decission in kernel space ie
> > wether the device should be isolated in its own group or not is a
> > decission that is up to the sys admin or something in userspace.
> > Right now existing user of SVA/SVM don't (at least AFAICT).
> > =

> > Do we really want to force such isolation ?
> > =

> =

> But it is not my decision, that how the iommu subsystem is designed. Pers=
onally
> I don't like it at all, because all our hardwares have their own stream id
> (device id). I don't need the group concept at all. But the iommu subsyst=
em
> assume some devices may share the name device ID to a single IOMMU.

My question was do you really want to force group isolation for the
device ? Existing SVA/SVM capable driver do not force that, they let
the userspace decide this (sysadm, distributions, ...). Being part of
VFIO (in the way you do, likely ways to avoid this inside VFIO too)
force this decision ie make a policy decision without userspace having
anything to say about it.


The IOMMU group thing as always been doubt full to me, it is advertise
as allowing to share resources (ie IOMMU page table) between devices.
But this assume that all device driver in the group have some way of
communicating with each other to share common DMA address that point
to memory devices care. I believe only VFIO does that and probably
only when use by QEMU.


Anyway my question is:

Is it that much useful to be inside VFIO (to avoid few hundred lines
of boiler plate code) given that it forces you into a model (group
isolation) that so far have never been the prefered way for all
existing device driver that already do what you want to achieve ?


>From where i stand i do not see overwhelming reasons to do what you
are doing inside VFIO.

To me it would make more sense to have regular device driver. They
all can have device file under same hierarchy to make devices with
same programming model easy to discover.

J=E9r=F4me
