From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Fri, 3 Aug 2018 10:55:26 -0400
Message-ID: <20180803145526.GB4079@redhat.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
	<20180801165644.GA3820@redhat.com>
	<AADFC41AFE54684AB9EE6CBC0274A5D191290E1A@SHSMSX101.ccr.corp.intel.com>
	<20180802111000.4649d9ed@alans-desktop>
	<20180802144627.GB3481@redhat.com>
	<20180803152043.40f88947@alans-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	"linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kumar,
	Sanjay K" <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hao Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>,
	Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
	Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
	Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "David S . Mille
To: Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180803152043.40f88947@alans-desktop>
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

On Fri, Aug 03, 2018 at 03:20:43PM +0100, Alan Cox wrote:
> > If we are going to have any kind of general purpose accelerator API then
> > > it has to be able to implement things like  =

> > =

> > Why is the existing driver model not good enough ? So you want
> > a device with function X you look into /dev/X (for instance
> > for GPU you look in /dev/dri)
> =

> Except when my GPU is in an FPGA in which case it might be somewhere else
> or it's a general purpose accelerator that happens to be usable as a GPU.
> Unusual today in big computer space but you'll find it in
> microcontrollers.

You do need a specific userspace driver for each of those device
correct ?

You definitly do for GPU and i do not see that going away any time
soon. I doubt Xilinx and Altera will ever compile down to same bit-
stream format either.

So userspace application is bound to use some kind of library that
implement the userspace side of the driver and that library can
easily provide helpers to enumerate all the devices it supports.

For instance that is what OpenCL allows for both GPU and FPGA.
One single API and multiple different hardware you can target from
it.


> > Each of those device need a userspace driver and thus this
> > user space driver can easily knows where to look. I do not
> > expect that every application will reimplement those drivers
> > but instead use some kind of library that provide a high
> > level API for each of those devices.
> =

> Think about it from the user level. You have a pipeline of things you
> wish to execute, you need to get the right accelerator combinations and
> they need to fit together to meet system constraints like number of
> IOMMU ids the accelerator supports, where they are connected.

Creating a pipe of device ie one device consuming the work of
the previous one, is a problem on its own and it should be solved
separatly and not inside VFIO.

GPU (on ARM) already have this pipe thing because the IP block
that do overlay, or the IP block that push pixel to the screen or
the IP block that do 3D rendering are all coming from different
company.

I do not see the value of having all the device enumerated through
VFIO to address this problem. I can definitly understand having a
specific kernel mechanism to expose to userspace what is do-able
but i believe this should be its own thing that allow any device
(a VFIO one, a network one, a GPU, a FPGA, ...) to be use in "pipe"
mode.


> > Now you have a hierarchy of memory for the CPU (HBM, local
> > node main memory aka you DDR dimm, persistent memory) each
> =

> It's not a heirarchy, it's a graph. There's no fundamental reason two
> accelerators can't be close to two different CPU cores but have shared
> HBM that is far from each processor. There are physical reasons it tends
> to look more like a heirarchy today.

Yes you are right i used the wrong word.

> =

> > Anyway i think finding devices and finding relation between
> > devices and memory is 2 separate problems and as such should
> > be handled separatly.
> =

> At a certain level they are deeply intertwined because you need a common
> API. It's not good if I want a particular accelerator and need to then
> see which API its under on this machine and which interface I have to
> use, and maybe have a mix of FPGA, WarpDrive and Google ASIC interfaces
> all different.
> =

> The job of the kernel is to impose some kind of sanity and unity on this
> lot.
> =

> All of it in the end comes down to
> =

> 'Somehow glue some chunk of memory into my address space and find any
> supporting driver I need'
> =

> plus virtualization of the above.
> =

> That bit's easy - but making it usable is a different story.

My point is that for all those devices you will have a userspace drivers
and thus all the complexity of finding best memory for a given combination
of hardware can be push to userspace. Kernel only have to expose the
topology of the different memory and their relation with each of the
devices. Very much like you have NUMA node for CPU.


I rather see kernel having one API to expose topology, one API to
expose device mixing capabilities (ie how can you can pipe device
together if at all). Then having to update every single existing
upstream driver that want to participate in the above to now become
a VFIO driver.


I have nothing against VFIO ;) Just to me it seems that this is all
reinventing a new device driver infrastructure under it while the
existing one is good enough and can evolve to support all the cases
discussed here.

Cheers,
J=E9r=F4me
