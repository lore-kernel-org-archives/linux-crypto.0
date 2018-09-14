From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Fri, 14 Sep 2018 06:50:55 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D191303A7F@SHSMSX101.ccr.corp.intel.com>
References: <20180906133133.GA3830@redhat.com>
	<20180907040138.GI230707@Turing-Arch-b>
	<20180907165303.GA3519@redhat.com>
	<20180910032809.GJ230707@Turing-Arch-b>
	<20180910145423.GA3488@redhat.com>
	<20180911024209.GK230707@Turing-Arch-b>
	<20180911033358.GA4730@redhat.com>
	<20180911064043.GA207969@Turing-Arch-b>
	<20180911134013.GA3932@redhat.com>
	<20180913083232.GB207969@Turing-Arch-b>
	<20180913145149.GB3576@redhat.com>
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
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
	"David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
To: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180913145149.GB3576-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
> Sent: Thursday, September 13, 2018 10:52 PM
>
[...]
 > AFAIK, on x86 and PPC at least, all PCIE devices are in the same group
> by default at boot or at least all devices behind the same bridge.

the group thing reflects physical hierarchy limitation, not changed
cross boot. Please note iommu group defines the minimal isolation
boundary - all devices within same group must be attached to the
same iommu domain or address space, because physically IOMMU
cannot differentiate DMAs out of those devices. devices behind
legacy PCI-X bridge is one example. other examples include devices
behind a PCIe switch port which doesn't support ACS thus cannot
route p2p transaction to IOMMU. If talking about typical PCIe 
endpoint (with upstreaming ports all supporting ACS), you'll get
one device per group.

One iommu group today is attached to only one iommu domain.
In the future one group may attach to multiple domains, as the
aux domain concept being discussed in another thread.

> 
> Maybe they are kernel option to avoid that and userspace init program
> can definitly re-arrange that base on sysadmin policy).

I don't think there is such option, as it may break isolation model
enabled by IOMMU.

[...]
> > > That is why i am being pedantic :) on making sure there is good reasons
> > > to do what you do inside VFIO. I do believe that we want a common
> frame-
> > > work like the one you are proposing but i do not believe it should be
> > > part of VFIO given the baggages it comes with and that are not relevant
> > > to the use cases for this kind of devices.
> >

The purpose of VFIO is clear - the kernel portal for granting generic 
device resource (mmio, irq, etc.) to user space. VFIO doesn't care
what exactly a resource is used for (queue, cmd reg, etc.). If really
pursuing VFIO path is necessary, maybe such common framework
should lay down in user space, which gets all granted resource from
kernel driver thru VFIO and then provides accelerator services to 
other processes?

Thanks
Kevin
