From: Kenneth Lee <liguozhu@hisilicon.com>
Subject: Re: [PATCH 3/7] vfio: add sdmdev support
Date: Thu, 6 Sep 2018 17:01:40 +0800
Message-ID: <20180906090140.GB230707@Turing-Arch-b>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
 <20180903005204.26041-4-nek.in.cn@gmail.com>
 <4ea51b20-dcc1-db32-18eb-24a004ab9085@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Kenneth Lee <nek.in.cn@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Fang <fanghao11@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <linux-accelerators@lists.ozlabs.org>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>, <linuxarm@huawei.com>
To: Lu Baolu <baolu.lu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4ea51b20-dcc1-db32-18eb-24a004ab9085@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 03, 2018 at 10:55:57AM +0800, Lu Baolu wrote:
> Date: Mon, 3 Sep 2018 10:55:57 +0800
> From: Lu Baolu <baolu.lu@linux.intel.com>
> To: Kenneth Lee <nek.in.cn@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
>  Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
>  <davem@davemloft.net>, Joerg Roedel <joro@8bytes.org>, Alex Williamson
>  <alex.williamson@redhat.com>, Kenneth Lee <liguozhu@hisilicon.com>, Hao
>  Fang <fanghao11@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>, Zaibo Xu
>  <xuzaibo@huawei.com>, Philippe Ombredanne <pombredanne@nexb.com>, Greg
>  Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner
>  <tglx@linutronix.de>, linux-doc@vger.kernel.org,
>  linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
>  iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
>  linux-accelerators@lists.ozlabs.org, Sanjay Kumar
>  <sanjay.k.kumar@intel.com>
> CC: linuxarm@huawei.com, baolu.lu@linux.intel.com
> Subject: Re: [PATCH 3/7] vfio: add sdmdev support
> User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
>  Thunderbird/52.9.1
> Message-ID: <4ea51b20-dcc1-db32-18eb-24a004ab9085@linux.intel.com>
> 
> Hi,
> 
> On 09/03/2018 08:52 AM, Kenneth Lee wrote:
> >From: Kenneth Lee <liguozhu@hisilicon.com>
> >
> >SDMDEV is "Share Domain Mdev". It is a vfio-mdev. But differ from
> >the general vfio-mdev, it shares its parent's IOMMU. If Multi-PASID
> >support is enabled in the IOMMU (not yet in the current kernel HEAD),
> >multiple process can share the IOMMU by different PASID. If it is not
> >support, only one process can share the IOMMU with the kernel driver.
> >
> 
> If only for share domain purpose, I don't think it's necessary to create
> a new device type.
> 

Yes, if ONLY for share domain purpose. But we need also to share the interrupt.

> >Currently only the vfio type-1 driver is updated to make it to be aware
> >of.
> >
> >Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
> >Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
> >Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> >---
> >  drivers/vfio/Kconfig              |   1 +
> >  drivers/vfio/Makefile             |   1 +
> >  drivers/vfio/sdmdev/Kconfig       |  10 +
> >  drivers/vfio/sdmdev/Makefile      |   3 +
> >  drivers/vfio/sdmdev/vfio_sdmdev.c | 363 ++++++++++++++++++++++++++++++
> >  drivers/vfio/vfio_iommu_type1.c   | 151 ++++++++++++-
> >  include/linux/vfio_sdmdev.h       |  96 ++++++++
> >  include/uapi/linux/vfio_sdmdev.h  |  29 +++
> >  8 files changed, 648 insertions(+), 6 deletions(-)
> >  create mode 100644 drivers/vfio/sdmdev/Kconfig
> >  create mode 100644 drivers/vfio/sdmdev/Makefile
> >  create mode 100644 drivers/vfio/sdmdev/vfio_sdmdev.c
> >  create mode 100644 include/linux/vfio_sdmdev.h
> >  create mode 100644 include/uapi/linux/vfio_sdmdev.h
> >
> 
> [--cut for short --]
> 
> >diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >index d9fd3188615d..ba73231d8692 100644
> >--- a/drivers/vfio/vfio_iommu_type1.c
> >+++ b/drivers/vfio/vfio_iommu_type1.c
> >@@ -41,6 +41,7 @@
> >  #include <linux/notifier.h>
> >  #include <linux/dma-iommu.h>
> >  #include <linux/irqdomain.h>
> >+#include <linux/vfio_sdmdev.h>
> >  #define DRIVER_VERSION  "0.2"
> >  #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
> >@@ -89,6 +90,8 @@ struct vfio_dma {
> >  };
> >  struct vfio_group {
> >+	/* iommu_group of mdev's parent device */
> >+	struct iommu_group	*parent_group;
> >  	struct iommu_group	*iommu_group;
> >  	struct list_head	next;
> >  };
> >@@ -1327,6 +1330,109 @@ static bool vfio_iommu_has_sw_msi(struct iommu_group *group, phys_addr_t *base)
> >  	return ret;
> >  }
> >+/* return 0 if the device is not sdmdev.
> >+ * return 1 if the device is sdmdev, the data will be updated with parent
> >+ *	device's group.
> >+ * return -errno if other error.
> >+ */
> >+static int vfio_sdmdev_type(struct device *dev, void *data)
> >+{
> >+	struct iommu_group **group = data;
> >+	struct iommu_group *pgroup;
> >+	int (*_is_sdmdev)(struct device *dev);
> >+	struct device *pdev;
> >+	int ret = 1;
> >+
> >+	/* vfio_sdmdev module is not configurated */
> >+	_is_sdmdev = symbol_get(vfio_sdmdev_is_sdmdev);
> >+	if (!_is_sdmdev)
> >+		return 0;
> >+
> >+	/* check if it belongs to vfio_sdmdev device */
> >+	if (!_is_sdmdev(dev)) {
> >+		ret = 0;
> >+		goto out;
> >+	}
> >+
> >+	pdev = dev->parent;
> >+	pgroup = iommu_group_get(pdev);
> >+	if (!pgroup) {
> >+		ret = -ENODEV;
> >+		goto out;
> >+	}
> >+
> >+	if (group) {
> >+		/* check if all parent devices is the same */
> >+		if (*group && *group != pgroup)
> >+			ret = -ENODEV;
> >+		else
> >+			*group = pgroup;
> >+	}
> >+
> >+	iommu_group_put(pgroup);
> >+
> >+out:
> >+	symbol_put(vfio_sdmdev_is_sdmdev);
> >+
> >+	return ret;
> >+}
> >+
> >+/* return 0 or -errno */
> >+static int vfio_sdmdev_bus(struct device *dev, void *data)
> >+{
> >+	struct bus_type **bus = data;
> >+
> >+	if (!dev->bus)
> >+		return -ENODEV;
> >+
> >+	/* ensure all devices has the same bus_type */
> >+	if (*bus && *bus != dev->bus)
> >+		return -EINVAL;
> >+
> >+	*bus = dev->bus;
> >+	return 0;
> >+}
> >+
> >+/* return 0 means it is not sd group, 1 means it is, or -EXXX for error */
> >+static int vfio_iommu_type1_attach_sdgroup(struct vfio_domain *domain,
> >+					    struct vfio_group *group,
> >+					    struct iommu_group *iommu_group)
> >+{
> >+	int ret;
> >+	struct bus_type *pbus = NULL;
> >+	struct iommu_group *pgroup = NULL;
> >+
> >+	ret = iommu_group_for_each_dev(iommu_group, &pgroup,
> >+				       vfio_sdmdev_type);
> >+	if (ret < 0)
> >+		goto out;
> >+	else if (ret > 0) {
> >+		domain->domain = iommu_group_share_domain(pgroup);
> >+		if (IS_ERR(domain->domain))
> >+			goto out;
> >+		ret = iommu_group_for_each_dev(pgroup, &pbus,
> >+				       vfio_sdmdev_bus);
> >+		if (ret < 0)
> >+			goto err_with_share_domain;
> >+
> >+		if (pbus && iommu_capable(pbus, IOMMU_CAP_CACHE_COHERENCY))
> >+			domain->prot |= IOMMU_CACHE;
> >+
> >+		group->parent_group = pgroup;
> >+		INIT_LIST_HEAD(&domain->group_list);
> >+		list_add(&group->next, &domain->group_list);
> >+
> >+		return 1;
> >+	}
> 
> This doesn't match the function name. It only gets the domain from the
> parent device. It hasn't been really attached.
> 
> >+
> >+	return 0;
> >+
> >+err_with_share_domain:
> >+	iommu_group_unshare_domain(pgroup);
> >+out:
> >+	return ret;
> >+}
> >+
> >  static int vfio_iommu_type1_attach_group(void *iommu_data,
> >  					 struct iommu_group *iommu_group)
> >  {
> >@@ -1335,8 +1441,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> >  	struct vfio_domain *domain, *d;
> >  	struct bus_type *bus = NULL, *mdev_bus;
> >  	int ret;
> >-	bool resv_msi, msi_remap;
> >-	phys_addr_t resv_msi_base;
> >+	bool resv_msi = false, msi_remap;
> >+	phys_addr_t resv_msi_base = 0;
> >  	mutex_lock(&iommu->lock);
> >@@ -1373,6 +1479,14 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> >  	if (mdev_bus) {
> >  		if ((bus == mdev_bus) && !iommu_present(bus)) {
> >  			symbol_put(mdev_bus_type);
> >+
> >+			ret = vfio_iommu_type1_attach_sdgroup(domain, group,
> >+					iommu_group);
> >+			if (ret < 0)
> >+				goto out_free;
> >+			else if (ret > 0)
> >+				goto replay_check;
> 
> Here you get the domain from the parent device and save it for later
> use. The actual attaching is ignored.
> 
> I don't think this follows the philosophy of this function. It actually
> make all devices in the group with the same bus type to share a single
> domain.

I think the original logic here is:

1. Create a new vfio_domain along with a iommu_domain for the group attached to
   the container
2. Try to match the vfio_domain with the domain list in the container. If there
   is a match, free the created one and and reuse it, or add the new vfio_domain
   to the list. 

   With this design, the same configuration to the IOMMU(unit) will be applied
   only once.


For iommu_group that shares IOMMU with its parent, the configuration will never
be the same (The PASID will be different), so it is not necessary to merge them.

> 
> Further more, the parent domain might be a domain of type
> IOMMU_DOMAIN_DMA. That will not be able to use as an
> IOMMU_DOMAIN_UNMANAGED domain for iommu APIs.

Indeed, it should be checked when the domain is shared. Unmanaged domain should
not be used for sharing. I will update it in the future.

> 
> Best regards,
> Lu Baolu

-- 
			-Kenneth(Hisilicon)

================================================================================
本邮件及其附件含有华为公司的保密信息，仅限于发送给上面地址中列出的个人或群组。禁
止任何其他人以任何形式使用（包括但不限于全部或部分地泄露、复制、或散发）本邮件中
的信息。如果您错收了本邮件，请您立即电话或邮件通知发件人并删除本邮件！
This e-mail and its attachments contain confidential information from HUAWEI,
which is intended only for the person or entity whose address is listed above.
Any use of the 
information contained herein in any way (including, but not limited to, total or
partial disclosure, reproduction, or dissemination) by persons other than the
intended 
recipient(s) is prohibited. If you receive this e-mail in error, please notify
the sender by phone or email immediately and delete it!
