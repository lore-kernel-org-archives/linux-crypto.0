From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC PATCH 2/7] iommu: Add share domain interface in iommu for
	spimdev
Date: Thu, 2 Aug 2018 04:39:37 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19129107A@SHSMSX101.ccr.corp.intel.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
	<20180801102221.5308-3-nek.in.cn@gmail.com>
	<AADFC41AFE54684AB9EE6CBC0274A5D191290F49@SHSMSX101.ccr.corp.intel.com>
	<20180802041547.GM160746@Turing-Arch-b>
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
To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180802041547.GM160746@Turing-Arch-b>
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

> From: Kenneth Lee
> Sent: Thursday, August 2, 2018 12:16 PM
> 
> On Thu, Aug 02, 2018 at 03:17:03AM +0000, Tian, Kevin wrote:
> > > From: Kenneth Lee
> > > Sent: Wednesday, August 1, 2018 6:22 PM
> > >
> > > From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> > >
> > > This patch add sharing interface for a iommu_group. The new interface:
> > >
> > > 	iommu_group_share_domain()
> > > 	iommu_group_unshare_domain()
> > >
> > > can be used by some virtual iommu_group (such as iommu_group for
> > > spimdev)
> > > to share their parent's iommu_group.
> > >
> > > When the domain of the group is shared, it cannot be changed before
> > > unshared.  In the future, notification can be added if update is required.
> >
> > Is it necessary or just asking VFIO to use parent domain directly?
> >
> Even we add to VFIO, the iommu still need to be changed. We can move
> the type1
> part to VFIO if we have agreement in RFC stage.

We have similar consideration in IOMMU aware mdev series. Now
we are inclined to avoid faked entity within IOMMU layer - leave to
caller to figure out right physical entity for any IOMMU ops. That 
might be leveraged here too after we get a new version.

Thanks
Kevin
