From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Tue, 11 Sep 2018 10:42:09 +0800
Message-ID: <20180911024209.GK230707@Turing-Arch-b>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
	<20180904150019.GA4024@redhat.com>
	<20180904101509.62314b67@t450s.home>
	<20180906094532.GG230707@Turing-Arch-b>
	<20180906133133.GA3830@redhat.com>
	<20180907040138.GI230707@Turing-Arch-b>
	<20180907165303.GA3519@redhat.com>
	<20180910032809.GJ230707@Turing-Arch-b>
	<20180910145423.GA3488@redhat.com>
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
In-Reply-To: <20180910145423.GA3488-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

On Mon, Sep 10, 2018 at 10:54:23AM -0400, Jerome Glisse wrote:
> Date: Mon, 10 Sep 2018 10:54:23 -0400
> From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> CC: Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Williamson
>  <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
>  kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman
>  <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>,
>  linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sanjay Kumar <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hao
>  Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
>  linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "David S . Miller"
>  <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhou Wang
>  <wangzhou1-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>,
>  Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
>  linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
> User-Agent: Mutt/1.10.0 (2018-05-17)
> Message-ID: <20180910145423.GA3488-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =

> On Mon, Sep 10, 2018 at 11:28:09AM +0800, Kenneth Lee wrote:
> > On Fri, Sep 07, 2018 at 12:53:06PM -0400, Jerome Glisse wrote:
> > > On Fri, Sep 07, 2018 at 12:01:38PM +0800, Kenneth Lee wrote:
> > > > On Thu, Sep 06, 2018 at 09:31:33AM -0400, Jerome Glisse wrote:
> > > > > On Thu, Sep 06, 2018 at 05:45:32PM +0800, Kenneth Lee wrote:
> > > > > > On Tue, Sep 04, 2018 at 10:15:09AM -0600, Alex Williamson wrote:
> > > > > > > On Tue, 4 Sep 2018 11:00:19 -0400 Jerome Glisse <jglisse@redh=
at.com> wrote:
> > > > > > > > On Mon, Sep 03, 2018 at 08:51:57AM +0800, Kenneth Lee wrote:
> =

> [...]
> =

> > > > I took a look at i915_gem_execbuffer_ioctl(). It seems it "copy_fro=
m_user" the
> > > > user memory to the kernel. That is not what we need. What we try to=
 get is: the
> > > > user application do something on its data, and push it away to the =
accelerator,
> > > > and says: "I'm tied, it is your turn to do the job...". Then the ac=
celerator has
> > > > the memory, referring any portion of it with the same VAs of the ap=
plication,
> > > > even the VAs are stored inside the memory itself.
> > > =

> > > You were not looking at right place see drivers/gpu/drm/i915/i915_gem=
_userptr.c
> > > It does GUP and create GEM object AFAICR you can wrap that GEM object=
 into a
> > > dma buffer object.
> > > =

> > =

> > Thank you for directing me to this implementation. It is interesting:).
> > =

> > But it is not yet solve my problem. If I understand it right, the userp=
tr in
> > i915 do the following:
> > =

> > 1. The user process sets a user pointer with size to the kernel via ioc=
tl.
> > 2. The kernel wraps it as a dma-buf and keeps the process's mm for furt=
her
> >    reference.
> > 3. The user pages are allocated, GUPed or DMA mapped to the device. So =
the data
> >    can be shared between the user space and the hardware.
> > =

> > But my scenario is: =

> > =

> > 1. The user process has some data in the user space, pointed by a point=
er, say
> >    ptr1. And within the memory, there may be some other pointers, let's=
 say one
> >    of them is ptr2.
> > 2. Now I need to assign ptr1 *directly* to the hardware MMIO space. And=
 the
> >    hardware must refer ptr1 and ptr2 *directly* for data.
> > =

> > Userptr lets the hardware and process share the same memory space. But =
I need
> > them to share the same *address space*. So IOMMU is a MUST for WarpDriv=
e,
> > NOIOMMU mode, as Jean said, is just for verifying some of the procedure=
 is OK.
> =

> So to be 100% clear should we _ignore_ the non SVA/SVM case ?
> If so then wait for necessary SVA/SVM to land and do warp drive
> without non SVA/SVM path.
> =


I think we should clear the concept of SVA/SVM here. As my understanding, S=
hare
Virtual Address/Memory means: any virtual address in a process can be used =
by
device at the same time. This requires IOMMU device to support PASID. And
optionally, it requires the feature of page-fault-from-device.

But before the feature is settled down, IOMMU can be used immediately in the
current kernel. That make it possible to assign ONE process's virtual addre=
sses
to the device's IOMMU page table with GUP. This make WarpDrive work well fo=
r one
process.

Now We are talking about SVA and PASID, just to make sure WarpDrive can ben=
efit
from the feature in the future. It dose not means WarpDrive is useless befo=
re
that. And it works for our Zip and RSA accelerators in physical world.

> If you still want non SVA/SVM path what you want to do only works
> if both ptr1 and ptr2 are in a range that is DMA mapped to the
> device (moreover you need DMA address to match process address
> which is not an easy feat).
> =

> Now even if you only want SVA/SVM, i do not see what is the point
> of doing this inside VFIO. AMD GPU driver does not and there would
> be no benefit for them to be there. Well a AMD VFIO mdev device
> driver for QEMU guest might be useful but they have SVIO IIRC.
> =

> For SVA/SVM your usage model is:
> =

> Setup:
>     - user space create a warp drive context for the process
>     - user space create a device specific context for the process
>     - user space create a user space command queue for the device
>     - user space bind command queue
> =

>     At this point the kernel driver has bound the process address
>     space to the device with a command queue and userspace
> =

> Usage:
>     - user space schedule work and call appropriate flush/update
>       ioctl from time to time. Might be optional depends on the
>       hardware, but probably a good idea to enforce so that kernel
>       can unbind the command queue to bind another process command
>       queue.
>     ...
> =

> Cleanup:
>     - user space unbind command queue
>     - user space destroy device specific context
>     - user space destroy warp drive context
>     All the above can be implicit when closing the device file.
> =

> So again in the above model i do not see anywhere something from
> VFIO that would benefit this model.
> =


Let me show you how the model will be if I use VFIO:

Setup (Kernel part)
	- Kernel driver do every as usual to serve the other functionality, NIC
	  can still be registered to netdev, encryptor can still be registered
	  to crypto...
	- At the same time, the driver can devote some of its hardware resource
	  and register them as a mdev creator to the VFIO framework. This just
	  need limited change to the VFIO type1 driver.

Setup (User space)
	- System administrator create mdev via the mdev creator interface.
	- Following VFIO setup routine, user space open the mdev's group, there is
	  only one group for one device.
	- Without PASID support, you don't need to do anything. With PASID, bind
	  the PASID to the device via VFIO interface.
	- Get the device from the group via VFIO interface and mmap it the user
	  space for device's MMIO access (for the queue).
	- Map whatever memory you need to share with the device with VFIO
	  interface.
	- (opt) Add more devices into the container if you want to share the
	  same address space with them

Cleanup:
	- User space close the group file handler
	- There will be a problem to let the other process know the mdev is
	  freed to be used again. My RFCv1 choose a file handler solution. Alex
	  dose not like it. But it is not a big problem. We can always have a
	  scheduler process to manage the state of the mdev or even we can
	  switch back to the RFCv1 solution without too much effort if we like
	  in the future. =


Except for the minimum update to the type1 driver and use sdmdev to manage =
the
interrupt sharing, I don't need any extra code to gain the address sharing
capability. And the capability will be strengthen along with the upgrade of=
 VFIO.

> =

> > > > And I don't understand why I should avoid to use VFIO? As Alex said=
, VFIO is the
> > > > user driver framework. And I need exactly a user driver interface. =
Why should I
> > > > invent another wheel? It has most of stuff I need:
> > > > =

> > > > 1. Connecting multiple devices to the same application space
> > > > 2. Pinning and DMA from the application space to the whole set of d=
evice
> > > > 3. Managing hardware resource by device
> > > > =

> > > > We just need the last step: make sure multiple applications and the=
 kernel can
> > > > share the same IOMMU. Then why shouldn't we use VFIO?
> > > =

> > > Because tons of other drivers already do all of the above outside VFI=
O. Many
> > > driver have a sizeable userspace side to them (anything with ioctl do=
) so they
> > > can be construded as userspace driver too.
> > > =

> > =

> > Ignoring if there are *tons* of drivers are doing that;), even I do the=
 same as
> > i915 and solve the address space problem. And if I don't need to with V=
FIO, why
> > should I spend so much effort to do it again?
> =

> Because you do not need any code from VFIO, nor do you need to reinvent
> things. If non SVA/SVM matters to you then use dma buffer. If not then
> i do not see anything in VFIO that you need.
> =


As I have explain, if I don't use VFIO, at lease I have to do all that has =
been
done in i915 or even more than that.

> =

> > > So there is no reasons to do that under VFIO. Especialy as in your ex=
ample
> > > it is not a real user space device driver, the userspace portion only=
 knows
> > > about writting command into command buffer AFAICT.
> > > =

> > > VFIO is for real userspace driver where interrupt, configurations, ..=
. ie
> > > all the driver is handled in userspace. This means that the userspace=
 have
> > > to be trusted as it could program the device to do DMA to anywhere (if
> > > IOMMU is disabled at boot which is still the default configuration in=
 the
> > > kernel).
> > > =

> > =

> > But as Alex explained, VFIO is not simply used by VM. So it need not to=
 have all
> > stuffs as a driver in host system. And I do need to share the user spac=
e as DMA
> > buffer to the hardware. And I can get it with just a little update, the=
n it can
> > service me perfectly. I don't understand why I should choose a long rou=
te.
> =

> Again this is not the long route i do not see anything in VFIO that
> benefit you in the SVA/SVM case. A basic character device driver can
> do that.
> =

> =

> > > So i do not see any reasons to do anything you want inside VFIO. All =
you
> > > want to do can be done outside as easily. Moreover it would be better=
 if
> > > you define clearly each scenario because from where i sit it looks li=
ke
> > > you are opening the door wide open to userspace to DMA anywhere when =
IOMMU
> > > is disabled.
> > > =

> > > When IOMMU is disabled you can _not_ expose command queue to userspace
> > > unless your device has its own page table and all commands are relati=
ve
> > > to that page table and the device page table is populated by kernel d=
river
> > > in secure way (ie by checking that what is populated can be access).
> > > =

> > > I do not believe your example device to have such page table nor do i=
 see
> > > a fallback path when IOMMU is disabled that force user to do ioctl for
> > > each commands.
> > > =

> > > Yes i understand that you target SVA/SVM but still you claim to suppo=
rt
> > > non SVA/SVM. The point is that userspace can not be trusted if you wa=
nt
> > > to have random program use your device. I am pretty sure that all user
> > > of VFIO are trusted process (like QEMU).
> > > =

> > > =

> > > Finaly i am convince that the IOMMU grouping stuff related to VFIO is
> > > useless for your usecase. I really do not see the point of that, it
> > > does complicate things for you for no reasons AFAICT.
> > =

> > Indeed, I don't like the group thing. I believe VFIO's maintains would =
not like
> > it very much either;). But the problem is, the group reflects to the sa=
me
> > IOMMU(unit), which may shared with other devices.  It is a security pro=
blem. I
> > cannot ignore it. I have to take it into account event I don't use VFIO.
> =

> To me it seems you are making a policy decission in kernel space ie
> wether the device should be isolated in its own group or not is a
> decission that is up to the sys admin or something in userspace.
> Right now existing user of SVA/SVM don't (at least AFAICT).
> =

> Do we really want to force such isolation ?
> =


But it is not my decision, that how the iommu subsystem is designed. Person=
ally
I don't like it at all, because all our hardwares have their own stream id
(device id). I don't need the group concept at all. But the iommu subsystem
assume some devices may share the name device ID to a single IOMMU.

> =

> > > > And personally, I believe the maturity and correctness of a framewo=
rk are driven
> > > > by applications. Now the problem in accelerator world is that we do=
n't have a
> > > > direction. If we believe the requirement is right, the method itsel=
f is not a
> > > > big problem in the end. We just need to let people have a unify pla=
tform to
> > > > share their work together.
> > > =

> > > I am not against that but it seems to me that all you want to do is o=
nly
> > > a matter of simplifying discovery of such devices and sharing few com=
mon
> > > ioctl (DMA mapping, creating command queue, managing command queue, .=
..)
> > > and again for all this i do not see the point of doing this under VFI=
O.
> > =

> > It is not a problem of device management, it is a problem of sharing ad=
dress
> > space.
> =

> This ties back to IOMMU SVA/SVM group isolation above.
> =

> J=E9r=F4me

Cheers
-- =

			-Kenneth(Hisilicon)
