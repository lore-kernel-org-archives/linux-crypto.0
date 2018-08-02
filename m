From: Cornelia Huck <cohuck-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/7] vfio: add spimdev support
Date: Thu, 2 Aug 2018 10:35:28 +0200
Message-ID: <20180802103528.0b863030.cohuck@redhat.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
	<20180801102221.5308-4-nek.in.cn@gmail.com>
	<AADFC41AFE54684AB9EE6CBC0274A5D191290F7B@SHSMSX101.ccr.corp.intel.com>
	<20180802034727.GK160746@Turing-Arch-b>
	<AADFC41AFE54684AB9EE6CBC0274A5D19129102C@SHSMSX101.ccr.corp.intel.com>
	<20180802073440.GA91035@Turing-Arch-b>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	Hao Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	"linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>,
	linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org "          <linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>,  Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,   , Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, SanjayK" <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	"lin
To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180802073440.GA91035@Turing-Arch-b>
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

On Thu, 2 Aug 2018 15:34:40 +0800
Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org> wrote:

> On Thu, Aug 02, 2018 at 04:24:22AM +0000, Tian, Kevin wrote:

> > > From: Kenneth Lee [mailto:liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org]
> > > Sent: Thursday, August 2, 2018 11:47 AM
> > >   
> > > >  
> > > > > From: Kenneth Lee
> > > > > Sent: Wednesday, August 1, 2018 6:22 PM
> > > > >
> > > > > From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> > > > >
> > > > > SPIMDEV is "Share Parent IOMMU Mdev". It is a vfio-mdev. But differ  
> > > from  
> > > > > the general vfio-mdev:
> > > > >
> > > > > 1. It shares its parent's IOMMU.
> > > > > 2. There is no hardware resource attached to the mdev is created. The
> > > > > hardware resource (A `queue') is allocated only when the mdev is
> > > > > opened.  
> > > >
> > > > Alex has concern on doing so, as pointed out in:
> > > >
> > > > 	https://www.spinics.net/lists/kvm/msg172652.html
> > > >
> > > > resource allocation should be reserved at creation time.  
> > > 
> > > Yes. That is why I keep telling that SPIMDEV is not for "VM", it is for "many
> > > processes", it is just an access point to the process. Not a device to VM. I
> > > hope
> > > Alex can accept it:)
> > >   
> > 
> > VFIO is just about assigning device resource to user space. It doesn't care
> > whether it's native processes or VM using the device so far. Along the direction
> > which you described, looks VFIO needs to support the configuration that
> > some mdevs are used for native process only, while others can be used
> > for both native and VM. I'm not sure whether there is a clean way to
> > enforce it...  
> 
> I had the same idea at the beginning. But finally I found that the life cycle
> of the virtual device for VM and process were different. Consider you create
> some mdevs for VM use, you will give all those mdevs to lib-virt, which
> distribute those mdev to VMs or containers. If the VM or container exits, the
> mdev is returned to the lib-virt and used for next allocation. It is the
> administrator who controlled every mdev's allocation.
> 
> But for process, it is different. There is no lib-virt in control. The
> administrator's intension is to grant some type of application to access the
> hardware. The application can get a handle of the hardware, send request and get
> the result. That's all. He/She dose not care which mdev is allocated to that
> application. If it crashes, it should be the kernel's responsibility to withdraw
> the resource, the system administrator does not want to do it by hand.

I don't think that you should distinguish the cases by the presence of
a management application. How can the mdev driver know what the
intention behind using the device is?

Would it make more sense to use a different mechanism to enforce that
applications only use those handles they are supposed to use? Maybe
cgroups? I don't think it's a good idea to push usage policy into the
kernel.

[I have not read the documentation, so I may be totally off on the
intended use of this.]
