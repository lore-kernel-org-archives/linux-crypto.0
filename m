From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Mon, 13 Aug 2018 15:23:01 -0400
Message-ID: <20180813192301.GC3451@redhat.com>
References: <20180806031252.GG91035@Turing-Arch-b>
	<20180806153257.GB6002@redhat.com>
	<11bace0e-dc14-5d2c-f65c-25b852f4e9ca@gmail.com>
	<20180808151835.GA3429@redhat.com>
	<20180809080352.GI91035@Turing-Arch-b>
	<20180809144613.GB3386@redhat.com>
	<20180810033913.GK91035@Turing-Arch-b>
	<0f6bac9b-8381-1874-9367-46b5f4cef56e@arm.com>
	<6ea4dcfd-d539-93e4-acf1-d09ea35f0ddc@gmail.com>
	<20180813092931.GL91035@Turing-Arch-b>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
	Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>,
	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	"linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kumar,
	Sanjay K" <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Hao Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	"David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"l
To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180813092931.GL91035@Turing-Arch-b>
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

On Mon, Aug 13, 2018 at 05:29:31PM +0800, Kenneth Lee wrote:
> =

> I made a quick change basing on the RFCv1 here: =

> =

> https://github.com/Kenneth-Lee/linux-kernel-warpdrive/commits/warpdrive-v=
0.6
> =

> I just made it compilable and not test it yet. But it shows how the idea =
is
> going to be.
> =

> The Pros is: most of the virtual device stuff can be removed. Resource
> management is on the openned files only.
> =

> The Cons is: as Jean said, we have to redo something that has been done b=
y VFIO.
> These mainly are:
> =

> 1. Track the dma operation and remove them on resource releasing
> 2. Pin the memory with gup and do accounting
> =

> It not going to be easy to make a decision...
> =


Maybe it would be good to list things you want do. Looking at your tree
it seems you are re-inventing what dma-buf is already doing.

So here is what i understand for SVM/SVA:
    (1) allow userspace to create a command buffer for a device and bind
        it to its address space (PASID)
    (2) allow userspace to directly schedule commands on its command buffer

No need to do tracking here as SVM/SVA which rely on PASID and something
like PCIE ATS (address translation service). Userspace can shoot itself
in the foot but nothing harmful can happen.


Non SVM/SVA:
    (3) allow userspace to wrap a region of its memory into an object so
        that it can be DMA map (ie GUP + dma_map_page())
    (4) Have userspace schedule command referencing object created in (3)
        using an ioctl.

We need to keep track of object usage by the hardware so that we know
when it is safe to release resources (dma_unmap_page()). The dma-buf
provides everything you want for (3) and (4). With dma-buf you create
object and each time it is use by a device you associate a fence with
it. When fence is signaled it means that the hardware is done using
that object. Fence also allow proper synchronization between multiple
devices. For instance making sure that the second device wait for the
first device before starting doing its thing. dma-buf documentations is
much more thorough explaining all this.


Now from implementation point of view, maybe it would be a good idea
to create something like the virtual gem driver. It is a virtual device
that allow to create GEM object. So maybe we want a virtual device that
allow to create dma-buf object from process memory and allow sharing of
those dma-buf between multiple devices.

Userspace would only have to talk to this virtual device to create
object and wrap its memory around, then it could use this object against
many actual devices.


This decouples the memory management, that can be share between all
devices, from the actual device driver, which is obviously specific to
every single device.


Note that dma-buf use file so that once all file reference are gone the
resource can be free and cleanup can happen (dma_unmap_page() ...). This
properly handle the resource lifetime issue you seem to worried about.

Cheers,
J=E9r=F4me
