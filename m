From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Fri, 14 Sep 2018 10:13:43 -0400
Message-ID: <20180914141342.GB3826@redhat.com>
References: <20180907165303.GA3519@redhat.com>
 <20180910032809.GJ230707@Turing-Arch-b>
 <20180910145423.GA3488@redhat.com>
 <20180911024209.GK230707@Turing-Arch-b>
 <20180911033358.GA4730@redhat.com>
 <20180911064043.GA207969@Turing-Arch-b>
 <20180911134013.GA3932@redhat.com>
 <20180913083232.GB207969@Turing-Arch-b>
 <20180913145149.GB3576@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D191303A7F@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Kenneth Lee <liguozhu@hisilicon.com>,
        Kenneth Lee <nek.in.cn@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        Hao Fang <fanghao11@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Philippe Ombredanne <pombredanne@
To: "Tian, Kevin" <kevin.tian@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D191303A7F@SHSMSX101.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 14, 2018 at 06:50:55AM +0000, Tian, Kevin wrote:
> > From: Jerome Glisse
> > Sent: Thursday, September 13, 2018 10:52 PM
> >
> [...]
>  > AFAIK, on x86 and PPC at least, all PCIE devices are in the same group
> > by default at boot or at least all devices behind the same bridge.
> 
> the group thing reflects physical hierarchy limitation, not changed
> cross boot. Please note iommu group defines the minimal isolation
> boundary - all devices within same group must be attached to the
> same iommu domain or address space, because physically IOMMU
> cannot differentiate DMAs out of those devices. devices behind
> legacy PCI-X bridge is one example. other examples include devices
> behind a PCIe switch port which doesn't support ACS thus cannot
> route p2p transaction to IOMMU. If talking about typical PCIe 
> endpoint (with upstreaming ports all supporting ACS), you'll get
> one device per group.
> 
> One iommu group today is attached to only one iommu domain.
> In the future one group may attach to multiple domains, as the
> aux domain concept being discussed in another thread.

Thanks for the info.

> 
> > 
> > Maybe they are kernel option to avoid that and userspace init program
> > can definitly re-arrange that base on sysadmin policy).
> 
> I don't think there is such option, as it may break isolation model
> enabled by IOMMU.
> 
> [...]
> > > > That is why i am being pedantic :) on making sure there is good reasons
> > > > to do what you do inside VFIO. I do believe that we want a common
> > frame-
> > > > work like the one you are proposing but i do not believe it should be
> > > > part of VFIO given the baggages it comes with and that are not relevant
> > > > to the use cases for this kind of devices.
> > >
> 
> The purpose of VFIO is clear - the kernel portal for granting generic 
> device resource (mmio, irq, etc.) to user space. VFIO doesn't care
> what exactly a resource is used for (queue, cmd reg, etc.). If really
> pursuing VFIO path is necessary, maybe such common framework
> should lay down in user space, which gets all granted resource from
> kernel driver thru VFIO and then provides accelerator services to 
> other processes?

Except that many existing device driver falls under that description
(ie exposing mmio, command queues, ...) and are not under VFIO.

Up to mdev VFIO was all about handling a full device to userspace AFAIK.
With the introduction of mdev a host kernel driver can "slice" its
device and share it through VFIO to userspace. Note that in that case
it might never end over any mmio, irq, ... the host driver might just
be handling over memory and would be polling from it to schedule on
the real hardware.


The question i am asking about warpdrive is wether being in VFIO is
necessary ? as i do not see the requirement myself.

Cheers,
Jérôme
