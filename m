From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Subject: Re: [RFC PATCH 2/7] iommu: Add share domain interface in iommu for
	spimdev
Date: Thu, 9 Aug 2018 09:09:38 +0800
Message-ID: <20180809010938.GH91035@Turing-Arch-b>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
	<20180801102221.5308-3-nek.in.cn@gmail.com>
	<20180808091354.ppqgineql3pufwwr@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Hao Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg
	Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Sanjay Kumar <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
	"David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
To: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180808091354.ppqgineql3pufwwr-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
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

On Wed, Aug 08, 2018 at 11:13:54AM +0200, Joerg Roedel wrote:
> Date: Wed, 8 Aug 2018 11:13:54 +0200
> From: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
> To: Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Herbert Xu
>  <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
>  Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kenneth Lee
>  <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Hao Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zhou Wang
>  <wangzhou1-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Philippe
>  Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>, Greg Kroah-Hartman
>  <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
>  linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
>  linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org,
>  kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Lu Baolu
>  <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sanjay Kumar <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
>  linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
> Subject: Re: [RFC PATCH 2/7] iommu: Add share domain interface in iommu for
>  spimdev
> User-Agent: NeoMutt/20170421 (1.8.2)
> Message-ID: <20180808091354.ppqgineql3pufwwr-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
> 
> On Wed, Aug 01, 2018 at 06:22:16PM +0800, Kenneth Lee wrote:
> > From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> > 
> > This patch add sharing interface for a iommu_group. The new interface:
> > 
> > 	iommu_group_share_domain()
> > 	iommu_group_unshare_domain()
> > 
> > can be used by some virtual iommu_group (such as iommu_group for spimdev)
> > to share their parent's iommu_group.
> > 
> > When the domain of the group is shared, it cannot be changed before
> > unshared.  In the future, notification can be added if update is required.
> 
> >From the description or the patch I don't really get why this is needed.
> Please update the description and make a case for this API addition.
> 

Yes, I will add more description in next version.

The idea here is:

1. iommu_domain is the setting of the IOMMU(the unit) of an iommu_group.

2. The iommu_group originally uses a default domain or a created one (e.g. by vfio)
   as its effective domain. There is only one user for a domain. If a device is
   bound to vfio driver, it uses the new created domain. And if it is unbound from
   vfio driver, it is switched back to the default domain.

3. But for spimdev, we create an mdev which share it parent device's IOMMU. That
   means, the parent device (along with its iommu group) will continue use its
   iommu_domain, and the mdev will use the same at the same time.

4. This API, is to tell the iommu_group that the domain is shared by the
   spimdev. And it should be changed before it is unshared.

Cheers

> 
> 	Joerg

-- 
			-Kenneth(Hisilicon)
