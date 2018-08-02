From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC PATCH 2/7] iommu: Add share domain interface in iommu for
	spimdev
Date: Thu, 2 Aug 2018 03:17:03 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D191290F49@SHSMSX101.ccr.corp.intel.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
	<20180801102221.5308-3-nek.in.cn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
To: Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, "David S . Miller"
	<davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Alex Williamson
	<alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>,
	Hao Fang
	<fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zhou Wang <wangzhou1-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Zaibo Xu
	<xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>, "Greg
	Kroah-Hartman" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Thomas Gleixner
	<tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
	<linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
	<linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
	<linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org"
	<iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
	<kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org"
	<linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>,
	Lu
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180801102221.5308-3-nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
> Sent: Wednesday, August 1, 2018 6:22 PM
> 
> From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> 
> This patch add sharing interface for a iommu_group. The new interface:
> 
> 	iommu_group_share_domain()
> 	iommu_group_unshare_domain()
> 
> can be used by some virtual iommu_group (such as iommu_group for
> spimdev)
> to share their parent's iommu_group.
> 
> When the domain of the group is shared, it cannot be changed before
> unshared.  In the future, notification can be added if update is required.

Is it necessary or just asking VFIO to use parent domain directly? 

> 
> Signed-off-by: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> ---
>  drivers/iommu/iommu.c | 28 +++++++++++++++++++++++++++-
>  include/linux/iommu.h |  2 ++
>  2 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 63b37563db7e..a832aafe660d 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -54,6 +54,9 @@ struct iommu_group {
>  	int id;
>  	struct iommu_domain *default_domain;
>  	struct iommu_domain *domain;
> +	atomic_t domain_shared_ref; /* Number of user of current domain.
> +				     * The domain cannot be modified if ref >
> 0
> +				     */
>  };
> 
>  struct group_device {
> @@ -353,6 +356,7 @@ struct iommu_group *iommu_group_alloc(void)
>  		return ERR_PTR(ret);
>  	}
>  	group->id = ret;
> +	atomic_set(&group->domain_shared_ref, 0);
> 
>  	ret = kobject_init_and_add(&group->kobj, &iommu_group_ktype,
>  				   NULL, "%d", group->id);
> @@ -482,6 +486,25 @@ int iommu_group_set_name(struct iommu_group
> *group, const char *name)
>  }
>  EXPORT_SYMBOL_GPL(iommu_group_set_name);
> 
> +struct iommu_domain *iommu_group_share_domain(struct
> iommu_group *group)
> +{
> +	/* the domain can be shared only when the default domain is used
> */
> +	/* todo: more shareable check */
> +	if (group->domain != group->default_domain)
> +		return ERR_PTR(-EINVAL);
> +
> +	atomic_inc(&group->domain_shared_ref);
> +	return group->domain;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_share_domain);
> +
> +void iommu_group_unshare_domain(struct iommu_group *group)
> +{
> +	atomic_dec(&group->domain_shared_ref);
> +	WARN_ON(atomic_read(&group->domain_shared_ref) < 0);
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_unshare_domain);
> +
>  static int iommu_group_create_direct_mappings(struct iommu_group
> *group,
>  					      struct device *dev)
>  {
> @@ -1401,7 +1424,8 @@ static int __iommu_attach_group(struct
> iommu_domain *domain,
>  {
>  	int ret;
> 
> -	if (group->default_domain && group->domain != group-
> >default_domain)
> +	if ((group->default_domain && group->domain != group-
> >default_domain) ||
> +	     atomic_read(&group->domain_shared_ref) > 0)
>  		return -EBUSY;
> 
>  	ret = __iommu_group_for_each_dev(group, domain,
> @@ -1438,6 +1462,8 @@ static void __iommu_detach_group(struct
> iommu_domain *domain,
>  {
>  	int ret;
> 
> +	WARN_ON(atomic_read(&group->domain_shared_ref) > 0);
> +
>  	if (!group->default_domain) {
>  		__iommu_group_for_each_dev(group, domain,
>  					   iommu_group_do_detach_device);
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 19938ee6eb31..278d60e3ec39 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -349,6 +349,8 @@ extern int iommu_domain_get_attr(struct
> iommu_domain *domain, enum iommu_attr,
>  				 void *data);
>  extern int iommu_domain_set_attr(struct iommu_domain *domain, enum
> iommu_attr,
>  				 void *data);
> +extern struct iommu_domain *iommu_group_share_domain(struct
> iommu_group *group);
> +extern void iommu_group_unshare_domain(struct iommu_group *group);
> 
>  /* Window handling function prototypes */
>  extern int iommu_domain_window_enable(struct iommu_domain
> *domain, u32 wnd_nr,
> --
> 2.17.1
