From: Kenneth Lee <nek.in.cn@gmail.com>
Subject: [RFC PATCH 2/7] iommu: Add share domain interface in iommu for spimdev
Date: Wed,  1 Aug 2018 18:22:16 +0800
Message-ID: <20180801102221.5308-3-nek.in.cn@gmail.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
Cc: linuxarm@huawei.com
To: Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-accelerators@lists.ozlabs.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801102221.5308-1-nek.in.cn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Kenneth Lee <liguozhu@hisilicon.com>

This patch add sharing interface for a iommu_group. The new interface:

	iommu_group_share_domain()
	iommu_group_unshare_domain()

can be used by some virtual iommu_group (such as iommu_group for spimdev)
to share their parent's iommu_group.

When the domain of the group is shared, it cannot be changed before
unshared.  In the future, notification can be added if update is required.

Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
---
 drivers/iommu/iommu.c | 28 +++++++++++++++++++++++++++-
 include/linux/iommu.h |  2 ++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 63b37563db7e..a832aafe660d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -54,6 +54,9 @@ struct iommu_group {
 	int id;
 	struct iommu_domain *default_domain;
 	struct iommu_domain *domain;
+	atomic_t domain_shared_ref; /* Number of user of current domain.
+				     * The domain cannot be modified if ref > 0
+				     */
 };
 
 struct group_device {
@@ -353,6 +356,7 @@ struct iommu_group *iommu_group_alloc(void)
 		return ERR_PTR(ret);
 	}
 	group->id = ret;
+	atomic_set(&group->domain_shared_ref, 0);
 
 	ret = kobject_init_and_add(&group->kobj, &iommu_group_ktype,
 				   NULL, "%d", group->id);
@@ -482,6 +486,25 @@ int iommu_group_set_name(struct iommu_group *group, const char *name)
 }
 EXPORT_SYMBOL_GPL(iommu_group_set_name);
 
+struct iommu_domain *iommu_group_share_domain(struct iommu_group *group)
+{
+	/* the domain can be shared only when the default domain is used */
+	/* todo: more shareable check */
+	if (group->domain != group->default_domain)
+		return ERR_PTR(-EINVAL);
+
+	atomic_inc(&group->domain_shared_ref);
+	return group->domain;
+}
+EXPORT_SYMBOL_GPL(iommu_group_share_domain);
+
+void iommu_group_unshare_domain(struct iommu_group *group)
+{
+	atomic_dec(&group->domain_shared_ref);
+	WARN_ON(atomic_read(&group->domain_shared_ref) < 0);
+}
+EXPORT_SYMBOL_GPL(iommu_group_unshare_domain);
+
 static int iommu_group_create_direct_mappings(struct iommu_group *group,
 					      struct device *dev)
 {
@@ -1401,7 +1424,8 @@ static int __iommu_attach_group(struct iommu_domain *domain,
 {
 	int ret;
 
-	if (group->default_domain && group->domain != group->default_domain)
+	if ((group->default_domain && group->domain != group->default_domain) ||
+	     atomic_read(&group->domain_shared_ref) > 0)
 		return -EBUSY;
 
 	ret = __iommu_group_for_each_dev(group, domain,
@@ -1438,6 +1462,8 @@ static void __iommu_detach_group(struct iommu_domain *domain,
 {
 	int ret;
 
+	WARN_ON(atomic_read(&group->domain_shared_ref) > 0);
+
 	if (!group->default_domain) {
 		__iommu_group_for_each_dev(group, domain,
 					   iommu_group_do_detach_device);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 19938ee6eb31..278d60e3ec39 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -349,6 +349,8 @@ extern int iommu_domain_get_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
 extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
+extern struct iommu_domain *iommu_group_share_domain(struct iommu_group *group);
+extern void iommu_group_unshare_domain(struct iommu_group *group);
 
 /* Window handling function prototypes */
 extern int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
-- 
2.17.1
