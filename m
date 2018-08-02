From: "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Thu, 2 Aug 2018 04:36:52 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19129105A@SHSMSX101.ccr.corp.intel.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D191290EB3@SHSMSX101.ccr.corp.intel.com>
 <20180802034006.GJ160746@Turing-Arch-b>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Kenneth Lee <nek.in.cn@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        Hao Fang <fanghao11@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        "David S . Miller" <davem@
To: Kenneth Lee <liguozhu@hisilicon.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802034006.GJ160746@Turing-Arch-b>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> From: Kenneth Lee
> Sent: Thursday, August 2, 2018 11:40 AM
> 
> On Thu, Aug 02, 2018 at 02:59:33AM +0000, Tian, Kevin wrote:
> > > From: Kenneth Lee
> > > Sent: Wednesday, August 1, 2018 6:22 PM
> > >
> > > From: Kenneth Lee <liguozhu@hisilicon.com>
> > >
> > > WarpDrive is an accelerator framework to expose the hardware
> capabilities
> > > directly to the user space. It makes use of the exist vfio and vfio-mdev
> > > facilities. So the user application can send request and DMA to the
> > > hardware without interaction with the kernel. This remove the latency
> > > of syscall and context switch.
> > >
> > > The patchset contains documents for the detail. Please refer to it for
> more
> > > information.
> > >
> > > This patchset is intended to be used with Jean Philippe Brucker's SVA
> > > patch [1] (Which is also in RFC stage). But it is not mandatory. This
> > > patchset is tested in the latest mainline kernel without the SVA patches.
> > > So it support only one process for each accelerator.
> >
> > If no sharing, then why not just assigning the whole parent device to
> > the process? IMO if SVA usage is the clear goal of your series, it
> > might be made clearly so then Jean's series is mandatory dependency...
> >
> 
> We don't know how SVA will be finally. But the feature, "make use of
> per-PASID/substream ID IOMMU page table", should be able to be enabled
> in the
> kernel. So we don't want to enforce it here. After we have this serial ready,
> it
> can be hooked to any implementation.

"any" or "only queue-based" implementation? some devices may not
have queue concept, e.g. GPU.

> 
> Further more, even without "per-PASID IOMMU page table", this series has
> its
> value. It is not simply dedicate the whole device to the process. It "shares"
> the device with the kernel driver. So you can support crypto and a user
> application at the same time.

OK.

Thanks
Kevin
