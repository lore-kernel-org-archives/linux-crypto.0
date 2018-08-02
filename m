From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Thu, 2 Aug 2018 10:22:43 -0400
Message-ID: <20180802142243.GA3481@redhat.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
	<20180801165644.GA3820@redhat.com>
	<AADFC41AFE54684AB9EE6CBC0274A5D191290E1A@SHSMSX101.ccr.corp.intel.com>
	<20180802040557.GL160746@Turing-Arch-b>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	"linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kumar,
	Sanjay K" <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hao Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <linux-accelerators@
To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180802040557.GL160746@Turing-Arch-b>
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

On Thu, Aug 02, 2018 at 12:05:57PM +0800, Kenneth Lee wrote:
> On Thu, Aug 02, 2018 at 02:33:12AM +0000, Tian, Kevin wrote:
> > Date: Thu, 2 Aug 2018 02:33:12 +0000
> > > From: Jerome Glisse
> > > On Wed, Aug 01, 2018 at 06:22:14PM +0800, Kenneth Lee wrote:
> > > > From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> > > >
> > > > WarpDrive is an accelerator framework to expose the hardware
> > > capabilities
> > > > directly to the user space. It makes use of the exist vfio and vfio=
-mdev
> > > > facilities. So the user application can send request and DMA to the
> > > > hardware without interaction with the kernel. This remove the laten=
cy
> > > > of syscall and context switch.
> > > >
> > > > The patchset contains documents for the detail. Please refer to it =
for
> > > more
> > > > information.
> > > >
> > > > This patchset is intended to be used with Jean Philippe Brucker's S=
VA
> > > > patch [1] (Which is also in RFC stage). But it is not mandatory. Th=
is
> > > > patchset is tested in the latest mainline kernel without the SVA pa=
tches.
> > > > So it support only one process for each accelerator.
> > > >
> > > > With SVA support, WarpDrive can support multi-process in the same
> > > > accelerator device.  We tested it in our SoC integrated Accelerator=
 (board
> > > > ID: D06, Chip ID: HIP08). A reference work tree can be found here: =
[2].
> > > =

> > > I have not fully inspected things nor do i know enough about
> > > this Hisilicon ZIP accelerator to ascertain, but from glimpsing
> > > at the code it seems that it is unsafe to use even with SVA due
> > > to the doorbell. There is a comment talking about safetyness
> > > in patch 7.
> > > =

> > > Exposing thing to userspace is always enticing, but if it is
> > > a security risk then it should clearly say so and maybe a
> > > kernel boot flag should be necessary to allow such device to
> > > be use.
> > > =

> =

> But doorbell is just a notification. Except for DOS (to make hardware bus=
y) it
> cannot actually take or change anything from the kernel space. And the DOS
> problem can be always taken as the problem that a group of processes shar=
e the
> same kernel entity.
> =

> In the coming HIP09 hardware, the doorbell will come with a random number=
 so
> only the process who allocated the queue can knock it correctly.

When doorbell is ring the hardware start fetching commands from
the queue and execute them ? If so than a rogue process B might
ring the doorbell of process A which would starts execution of
random commands (ie whatever random memory value there is left
inside the command buffer memory, could be old commands i guess).

If this is not how this doorbell works then, yes it can only do
a denial of service i guess. Issue i have with doorbell is that
i have seen 10 differents implementations in 10 differents hw
and each are different as to what ringing or value written to the
doorbell does. It is painfull to track what is what for each hw.


> > > My more general question is do we want to grow VFIO to become
> > > a more generic device driver API. This patchset adds a command
> > > queue concept to it (i don't think it exist today but i have
> > > not follow VFIO closely).
> > > =

> =

> The thing is, VFIO is the only place to support DMA from user land. If we=
 don't
> put it here, we have to create another similar facility to support the sa=
me.

No it is not, network device, GPU, block device, ... they all do
support DMA. The point i am trying to make here is that even in
your mechanisms the userspace must have a specific userspace
drivers for each hardware and thus there are virtually no
differences between having this userspace driver open a device
file in vfio or somewhere else in the device filesystem. This is
just a different path.

So this is why i do not see any benefit to having all drivers with
SVM (can we please use SVM and not SVA as SVM is what have been use
in more places so far).


Cheers,
J=E9r=F4me
