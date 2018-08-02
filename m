From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Thu, 2 Aug 2018 02:33:12 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D191290E1A@SHSMSX101.ccr.corp.intel.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
	<20180801165644.GA3820@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Hao Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
	"Kumar, Sanjay K" <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
	Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, "David
	S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org"
	<linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
To: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180801165644.GA3820-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
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

> From: Jerome Glisse
> Sent: Thursday, August 2, 2018 12:57 AM
> =

> On Wed, Aug 01, 2018 at 06:22:14PM +0800, Kenneth Lee wrote:
> > From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> >
> > WarpDrive is an accelerator framework to expose the hardware
> capabilities
> > directly to the user space. It makes use of the exist vfio and vfio-mdev
> > facilities. So the user application can send request and DMA to the
> > hardware without interaction with the kernel. This remove the latency
> > of syscall and context switch.
> >
> > The patchset contains documents for the detail. Please refer to it for
> more
> > information.
> >
> > This patchset is intended to be used with Jean Philippe Brucker's SVA
> > patch [1] (Which is also in RFC stage). But it is not mandatory. This
> > patchset is tested in the latest mainline kernel without the SVA patche=
s.
> > So it support only one process for each accelerator.
> >
> > With SVA support, WarpDrive can support multi-process in the same
> > accelerator device.  We tested it in our SoC integrated Accelerator (bo=
ard
> > ID: D06, Chip ID: HIP08). A reference work tree can be found here: [2].
> =

> I have not fully inspected things nor do i know enough about
> this Hisilicon ZIP accelerator to ascertain, but from glimpsing
> at the code it seems that it is unsafe to use even with SVA due
> to the doorbell. There is a comment talking about safetyness
> in patch 7.
> =

> Exposing thing to userspace is always enticing, but if it is
> a security risk then it should clearly say so and maybe a
> kernel boot flag should be necessary to allow such device to
> be use.
> =

> =

> My more general question is do we want to grow VFIO to become
> a more generic device driver API. This patchset adds a command
> queue concept to it (i don't think it exist today but i have
> not follow VFIO closely).
> =

> Why is that any better that existing driver model ? Where a
> device create a device file (can be character device, block
> device, ...). Such models also allow for direct hardware
> access from userspace. For instance see the AMD KFD driver
> inside drivers/gpu/drm/amd

One motivation I guess, is that most accelerators lack of a =

well-abstracted high level APIs similar to GPU side (e.g. OpenCL =

clearly defines Shared Virtual Memory models). VFIO mdev
might be an alternative common interface to enable SVA usages =

on various accelerators...

> =

> So you can already do what you are doing with the Hisilicon
> driver today without this new infrastructure. This only need
> hardware that have command queue and doorbell like mechanisms.
> =

> =

> Unlike mdev which unify a very high level concept, it seems
> to me spimdev just introduce low level concept (namely command
> queue) and i don't see the intrinsic value here.
> =

> =

> Cheers,
> J=E9r=F4me
> _______________________________________________
> iommu mailing list
> iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
