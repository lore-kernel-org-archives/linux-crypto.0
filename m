From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Thu, 2 Aug 2018 11:40:06 +0800
Message-ID: <20180802034006.GJ160746@Turing-Arch-b>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
	<AADFC41AFE54684AB9EE6CBC0274A5D191290EB3@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	"linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kumar,
	Sanjay K" <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hao Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>, Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	"David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D191290EB3-0J0gbvR4kThpB2pF5aRoyrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
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

On Thu, Aug 02, 2018 at 02:59:33AM +0000, Tian, Kevin wrote:
> Date: Thu, 2 Aug 2018 02:59:33 +0000
> From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> To: Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
>  Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, "David S . Miller"
>  <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Alex Williamson
>  <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Hao
>  Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zhou Wang <wangzhou1-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Zaibo Xu
>  <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>, Greg
>  Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Thomas Gleixner
>  <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
>  <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
>  <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
>  <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org"
>  <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
>  <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org"
>  <linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, Lu Baolu
>  <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Kumar, Sanjay K" <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: "linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Subject: RE: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
> Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D191290EB3-0J0gbvR4kThpB2pF5aRoyrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
> 
> > From: Kenneth Lee
> > Sent: Wednesday, August 1, 2018 6:22 PM
> > 
> > From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> > 
> > WarpDrive is an accelerator framework to expose the hardware capabilities
> > directly to the user space. It makes use of the exist vfio and vfio-mdev
> > facilities. So the user application can send request and DMA to the
> > hardware without interaction with the kernel. This remove the latency
> > of syscall and context switch.
> > 
> > The patchset contains documents for the detail. Please refer to it for more
> > information.
> > 
> > This patchset is intended to be used with Jean Philippe Brucker's SVA
> > patch [1] (Which is also in RFC stage). But it is not mandatory. This
> > patchset is tested in the latest mainline kernel without the SVA patches.
> > So it support only one process for each accelerator.
> 
> If no sharing, then why not just assigning the whole parent device to
> the process? IMO if SVA usage is the clear goal of your series, it
> might be made clearly so then Jean's series is mandatory dependency...
> 

We don't know how SVA will be finally. But the feature, "make use of
per-PASID/substream ID IOMMU page table", should be able to be enabled in the
kernel. So we don't want to enforce it here. After we have this serial ready, it
can be hooked to any implementation.

Further more, even without "per-PASID IOMMU page table", this series has its
value. It is not simply dedicate the whole device to the process. It "shares"
the device with the kernel driver. So you can support crypto and a user
application at the same time.

> > 
> > With SVA support, WarpDrive can support multi-process in the same
> > accelerator device.  We tested it in our SoC integrated Accelerator (board
> > ID: D06, Chip ID: HIP08). A reference work tree can be found here: [2].
> > 
> > We have noticed the IOMMU aware mdev RFC announced recently [3].
> > 
> > The IOMMU aware mdev has similar idea but different intention comparing
> > to
> > WarpDrive. It intends to dedicate part of the hardware resource to a VM.
> 
> Not just to VM, though I/O Virtualization is in the name. You can assign
> such mdev to either VMs, containers, or bare metal processes. It's just
> a fully-isolated device from user space p.o.v.

Oh, yes. Thank you for clarification.

> 
> > And the design is supposed to be used with Scalable I/O Virtualization.
> > While spimdev is intended to share the hardware resource with a big
> > amount
> > of processes.  It just requires the hardware supporting address
> > translation per process (PCIE's PASID or ARM SMMU's substream ID).
> > 
> > But we don't see serious confliction on both design. We believe they can be
> > normalized as one.
> 
> yes there are something which can be shared, e.g. regarding to
> the interface to IOMMU.
> 
> Conceptually I see them different mindset on device resource sharing:
> 
> WarpDrive more aims to provide a generic framework to enable SVA
> usages on various accelerators, which lack of a well-abstracted user
> API like OpenCL. SVA is a hardware capability - sort of exposing resources
> composing ONE capability to user space through mdev framework. It is
> not like a VF which naturally carries most capabilities as PF.
> 

Yes. But we believe the user abstraction layer will be enabled soon when the
channel is opened. WarpDrive gives the hardware the chance to serve the
application directly. For example, an AI engine can be called by many processes
for inference. The resource need not to be dedicated to one particular process.

> Intel Scalable I/O virtualization is a thorough design to partition the
> device into minimal sharable copies (queue, queue pair, context), 
> while each copy carries most PF capabilities (including SVA) similar to
> VF. Also with IOMMU scalable mode support, the copy can be 
> independently assigned to any client (process, container, VM, etc.)
> 
Yes, we can see this intension.
> Thanks
> Kevin

Thank you.

-- 
			-Kenneth(Hisilicon)
