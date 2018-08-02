From: "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Thu, 2 Aug 2018 02:59:33 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D191290EB3@SHSMSX101.ccr.corp.intel.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linuxarm@huawei.com" <linuxarm@huawei.com>
To: Kenneth Lee <nek.in.cn@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kv
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801102221.5308-1-nek.in.cn@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> From: Kenneth Lee
> Sent: Wednesday, August 1, 2018 6:22 PM
> 
> From: Kenneth Lee <liguozhu@hisilicon.com>
> 
> WarpDrive is an accelerator framework to expose the hardware capabilities
> directly to the user space. It makes use of the exist vfio and vfio-mdev
> facilities. So the user application can send request and DMA to the
> hardware without interaction with the kernel. This remove the latency
> of syscall and context switch.
> 
> The patchset contains documents for the detail. Please refer to it for more
> information.
> 
> This patchset is intended to be used with Jean Philippe Brucker's SVA
> patch [1] (Which is also in RFC stage). But it is not mandatory. This
> patchset is tested in the latest mainline kernel without the SVA patches.
> So it support only one process for each accelerator.

If no sharing, then why not just assigning the whole parent device to
the process? IMO if SVA usage is the clear goal of your series, it
might be made clearly so then Jean's series is mandatory dependency...

> 
> With SVA support, WarpDrive can support multi-process in the same
> accelerator device.  We tested it in our SoC integrated Accelerator (board
> ID: D06, Chip ID: HIP08). A reference work tree can be found here: [2].
> 
> We have noticed the IOMMU aware mdev RFC announced recently [3].
> 
> The IOMMU aware mdev has similar idea but different intention comparing
> to
> WarpDrive. It intends to dedicate part of the hardware resource to a VM.

Not just to VM, though I/O Virtualization is in the name. You can assign
such mdev to either VMs, containers, or bare metal processes. It's just
a fully-isolated device from user space p.o.v.

> And the design is supposed to be used with Scalable I/O Virtualization.
> While spimdev is intended to share the hardware resource with a big
> amount
> of processes.  It just requires the hardware supporting address
> translation per process (PCIE's PASID or ARM SMMU's substream ID).
> 
> But we don't see serious confliction on both design. We believe they can be
> normalized as one.

yes there are something which can be shared, e.g. regarding to
the interface to IOMMU.

Conceptually I see them different mindset on device resource sharing:

WarpDrive more aims to provide a generic framework to enable SVA
usages on various accelerators, which lack of a well-abstracted user
API like OpenCL. SVA is a hardware capability - sort of exposing resources
composing ONE capability to user space through mdev framework. It is
not like a VF which naturally carries most capabilities as PF.

Intel Scalable I/O virtualization is a thorough design to partition the
device into minimal sharable copies (queue, queue pair, context), 
while each copy carries most PF capabilities (including SVA) similar to
VF. Also with IOMMU scalable mode support, the copy can be 
independently assigned to any client (process, container, VM, etc.)

Thanks
Kevin
