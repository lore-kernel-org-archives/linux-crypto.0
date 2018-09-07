From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Fri, 7 Sep 2018 12:53:06 -0400
Message-ID: <20180907165303.GA3519@redhat.com>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
	<20180904150019.GA4024@redhat.com>
	<20180904101509.62314b67@t450s.home>
	<20180906094532.GG230707@Turing-Arch-b>
	<20180906133133.GA3830@redhat.com>
	<20180907040138.GI230707@Turing-Arch-b>
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
In-Reply-To: <20180907040138.GI230707@Turing-Arch-b>
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

On Fri, Sep 07, 2018 at 12:01:38PM +0800, Kenneth Lee wrote:
> On Thu, Sep 06, 2018 at 09:31:33AM -0400, Jerome Glisse wrote:
> > Date: Thu, 6 Sep 2018 09:31:33 -0400
> > From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> > CC: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kenneth Lee
> >  <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Herbert Xu
> >  <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org=
>,
> >  Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Hao Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zhou =
Wang
> >  <wangzhou1-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Philippe
> >  Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>, Greg Kroah-Hartman
> >  <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
> >  linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
> >  linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org,
> >  kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Lu Baolu
> >  <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sanjay Kumar <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
> >  linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
> > Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDri=
ve
> > User-Agent: Mutt/1.10.0 (2018-05-17)
> > Message-ID: <20180906133133.GA3830-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > =

> > On Thu, Sep 06, 2018 at 05:45:32PM +0800, Kenneth Lee wrote:
> > > On Tue, Sep 04, 2018 at 10:15:09AM -0600, Alex Williamson wrote:
> > > > Date: Tue, 4 Sep 2018 10:15:09 -0600
> > > > From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > To: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > CC: Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet@lwn.=
net>,
> > > >  Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, "David S . Miller"
> > > >  <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Kenneth Lee
> > > >  <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Hao Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zhou Wa=
ng
> > > >  <wangzhou1-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Philippe
> > > >  Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>, Greg Kroah-Hartman
> > > >  <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
> > > >  linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
> > > >  linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org,
> > > >  kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Lu Baolu
> > > >  <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sanjay Kumar <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org=
>,
> > > >  linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
> > > > Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, War=
pDrive
> > > > Message-ID: <20180904101509.62314b67-1yVPhWWZRC1BDLzU/O5InQ@public.gmane.org>
> > > > =

> > > > On Tue, 4 Sep 2018 11:00:19 -0400
> > > > Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > > =

> > > > > On Mon, Sep 03, 2018 at 08:51:57AM +0800, Kenneth Lee wrote:
> > > > > > From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> > > > > > =

> > > > > > WarpDrive is an accelerator framework to expose the hardware ca=
pabilities
> > > > > > directly to the user space. It makes use of the exist vfio and =
vfio-mdev
> > > > > > facilities. So the user application can send request and DMA to=
 the
> > > > > > hardware without interaction with the kernel. This removes the =
latency
> > > > > > of syscall.
> > > > > > =

> > > > > > WarpDrive is the name for the whole framework. The component in=
 kernel
> > > > > > is called SDMDEV, Share Domain Mediated Device. Driver driver e=
xposes its
> > > > > > hardware resource by registering to SDMDEV as a VFIO-Mdev. So t=
he user
> > > > > > library of WarpDrive can access it via VFIO interface.
> > > > > > =

> > > > > > The patchset contains document for the detail. Please refer to =
it for more
> > > > > > information.
> > > > > > =

> > > > > > This patchset is intended to be used with Jean Philippe Brucker=
's SVA
> > > > > > patch [1], which enables not only IO side page fault, but also =
PASID
> > > > > > support to IOMMU and VFIO.
> > > > > > =

> > > > > > With these features, WarpDrive can support non-pinned memory and
> > > > > > multi-process in the same accelerator device.  We tested it in =
our SoC
> > > > > > integrated Accelerator (board ID: D06, Chip ID: HIP08). A refer=
ence work
> > > > > > tree can be found here: [2].
> > > > > > =

> > > > > > But it is not mandatory. This patchset is tested in the latest =
mainline
> > > > > > kernel without the SVA patches.  So it supports only one proces=
s for each
> > > > > > accelerator.
> > > > > > =

> > > > > > We have noticed the IOMMU aware mdev RFC announced recently [3].
> > > > > > =

> > > > > > The IOMMU aware mdev has similar idea but different intention c=
omparing to
> > > > > > WarpDrive. It intends to dedicate part of the hardware resource=
 to a VM.
> > > > > > And the design is supposed to be used with Scalable I/O Virtual=
ization.
> > > > > > While sdmdev is intended to share the hardware resource with a =
big amount
> > > > > > of processes.  It just requires the hardware supporting address
> > > > > > translation per process (PCIE's PASID or ARM SMMU's substream I=
D).
> > > > > > =

> > > > > > But we don't see serious confliction on both design. We believe=
 they can be
> > > > > > normalized as one.
> > > > > >   =

> > > > > =

> > > > > So once again i do not understand why you are trying to do things
> > > > > this way. Kernel already have tons of example of everything you
> > > > > want to do without a new framework. Moreover i believe you are
> > > > > confuse by VFIO. To me VFIO is for VM not to create general device
> > > > > driver frame work.
> > > > =

> > > > VFIO is a userspace driver framework, the VM use case just happens =
to
> > > > be a rather prolific one.  VFIO was never intended to be solely a VM
> > > > device interface and has several other userspace users, notably DPDK
> > > > and SPDK, an NVMe backend in QEMU, a userspace NVMe driver, a ruby
> > > > wrapper, and perhaps others that I'm not aware of.  Whether vfio is
> > > > appropriate interface here might certainly still be a debatable top=
ic,
> > > > but I would strongly disagree with your last sentence above.  Thank=
s,
> > > > =

> > > > Alex
> > > > =

> > > =

> > > Yes, that is also my standpoint here.
> > > =

> > > > > So here is your use case as i understand it. You have a device
> > > > > with a limited number of command queues (can be just one) and in
> > > > > some case it can support SVA/SVM (when hardware support it and it
> > > > > is not disabled). Final requirement is being able to schedule cmds
> > > > > from userspace without ioctl. All of this exists already exists
> > > > > upstream in few device drivers.
> > > > > =

> > > > > =

> > > > > So here is how every body else is doing it. Please explain why
> > > > > this does not work.
> > > > > =

> > > > > 1 Userspace open device file driver. Kernel device driver create
> > > > >   a context and associate it with on open. This context can be
> > > > >   uniq to the process and can bind hardware resources (like a
> > > > >   command queue) to the process.
> > > > > 2 Userspace bind/acquire a commands queue and initialize it with
> > > > >   an ioctl on the device file. Through that ioctl userspace can
> > > > >   be inform wether either SVA/SVM works for the device. If SVA/
> > > > >   SVM works then kernel device driver bind the process to the
> > > > >   device as part of this ioctl.
> > > > > 3 If SVM/SVA does not work userspace do an ioctl to create dma
> > > > >   buffer or something that does exactly the same thing.
> > > > > 4 Userspace mmap the command queue (mmap of the device file by
> > > > >   using informations gather at step 2)
> > > > > 5 Userspace can write commands into the queue it mapped
> > > > > 6 When userspace close the device file all resources are release
> > > > >   just like any existing device drivers.
> > > =

> > > Hi, Jerome,
> > > =

> > > Just one thing, as I said in the cover letter, dma-buf requires the a=
pplication
> > > to use memory created by the driver for DMA. I did try the dma-buf wa=
y in
> > > WrapDrive (refer to [4] in the cover letter), it is a good backup for=
 NOIOMMU
> > > mode or we cannot solve the problem in VFIO.
> > > =

> > > But, in many of my application scenario, the application already has =
some memory
> > > in hand, maybe allocated by the framework or libraries. Anyway, they =
don't get
> > > memory from my library, and they pass the poiter for data operation. =
And they
> > > may also have pointer in the buffer. Those pointer may be used by the
> > > accelerator. So I need hardware fully share the address space with the
> > > application. That is what dmabuf cannot do.
> > =

> > dmabuf can do that ... it is call uptr you can look at i915 for
> > instance. Still this does not answer my question above, why do
> > you need to be in VFIO to do any of the above thing ? Kernel has
> > tons of examples that does all of the above and are not in VFIO
> > (including usinng existing user pointer with device).
> > =

> > Cheers,
> > J=E9r=F4me
> =

> I took a look at i915_gem_execbuffer_ioctl(). It seems it "copy_from_user=
" the
> user memory to the kernel. That is not what we need. What we try to get i=
s: the
> user application do something on its data, and push it away to the accele=
rator,
> and says: "I'm tied, it is your turn to do the job...". Then the accelera=
tor has
> the memory, referring any portion of it with the same VAs of the applicat=
ion,
> even the VAs are stored inside the memory itself.

You were not looking at right place see drivers/gpu/drm/i915/i915_gem_userp=
tr.c
It does GUP and create GEM object AFAICR you can wrap that GEM object into a
dma buffer object.

> =

> And I don't understand why I should avoid to use VFIO? As Alex said, VFIO=
 is the
> user driver framework. And I need exactly a user driver interface. Why sh=
ould I
> invent another wheel? It has most of stuff I need:
> =

> 1. Connecting multiple devices to the same application space
> 2. Pinning and DMA from the application space to the whole set of device
> 3. Managing hardware resource by device
> =

> We just need the last step: make sure multiple applications and the kerne=
l can
> share the same IOMMU. Then why shouldn't we use VFIO?

Because tons of other drivers already do all of the above outside VFIO. Many
driver have a sizeable userspace side to them (anything with ioctl do) so t=
hey
can be construded as userspace driver too.

So there is no reasons to do that under VFIO. Especialy as in your example
it is not a real user space device driver, the userspace portion only knows
about writting command into command buffer AFAICT.

VFIO is for real userspace driver where interrupt, configurations, ... ie
all the driver is handled in userspace. This means that the userspace have
to be trusted as it could program the device to do DMA to anywhere (if
IOMMU is disabled at boot which is still the default configuration in the
kernel).

So i do not see any reasons to do anything you want inside VFIO. All you
want to do can be done outside as easily. Moreover it would be better if
you define clearly each scenario because from where i sit it looks like
you are opening the door wide open to userspace to DMA anywhere when IOMMU
is disabled.

When IOMMU is disabled you can _not_ expose command queue to userspace
unless your device has its own page table and all commands are relative
to that page table and the device page table is populated by kernel driver
in secure way (ie by checking that what is populated can be access).

I do not believe your example device to have such page table nor do i see
a fallback path when IOMMU is disabled that force user to do ioctl for
each commands.

Yes i understand that you target SVA/SVM but still you claim to support
non SVA/SVM. The point is that userspace can not be trusted if you want
to have random program use your device. I am pretty sure that all user
of VFIO are trusted process (like QEMU).


Finaly i am convince that the IOMMU grouping stuff related to VFIO is
useless for your usecase. I really do not see the point of that, it
does complicate things for you for no reasons AFAICT.


> =

> And personally, I believe the maturity and correctness of a framework are=
 driven
> by applications. Now the problem in accelerator world is that we don't ha=
ve a
> direction. If we believe the requirement is right, the method itself is n=
ot a
> big problem in the end. We just need to let people have a unify platform =
to
> share their work together.

I am not against that but it seems to me that all you want to do is only
a matter of simplifying discovery of such devices and sharing few common
ioctl (DMA mapping, creating command queue, managing command queue, ...)
and again for all this i do not see the point of doing this under VFIO.


Cheers,
J=E9r=F4me
