From: Kenneth Lee <nek.in.cn@gmail.com>
Subject: [PATCH 2/7] iommu: Add share domain interface in iommu for sdmdev
Date: Mon,  3 Sep 2018 08:51:59 +0800
Message-ID: <20180903005204.26041-3-nek.in.cn@gmail.com>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
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
In-Reply-To: <20180903005204.26041-1-nek.in.cn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Kenneth Lee <liguozhu@hisilicon.com>

This patch add sharing interface for a iommu_group. The new interface:

	iommu_group_share_domain()
	iommu_group_unshare_domain()

can be used by some virtual iommu_group (such as iommu_group of sdmdev)
to share their parent's iommu_group.

When the domain of a group is shared, it cannot be changed before
being unshared. By this way, all domain users can assume the shared
IOMMU have the same configuration.  In the future, notification can be
added if update is required.

Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
---
 drivers/iommu/iommu.c | 29 ++++++++++++++++++++++++++++-
 include/linux/iommu.h | 15 +++++++++++++++
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 8c15c5980299..8e567e1037dd 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -58,6 +58,9 @@ struct iommu_group {
 	int id;
 	struct iommu_domain *default_domain;
 	struct iommu_domain *domain;
+	atomic_t domain_shared_ref; /* Number of user of current domain.
+				     * The domain cannot be modified if ref > 0
+				     */
 };
 
 struct group_device {
@@ -385,6 +388,7 @@ struct iommu_group *iommu_group_alloc(void)
 		return ERR_PTR(ret);
 	}
 	group->id = ret;
+	atomic_set(&group->domain_shared_ref, 0);
 
 	ret = kobject_init_and_add(&group->kobj, &iommu_group_ktype,
 				   NULL, "%d", group->id);
@@ -518,6 +522,26 @@ int iommu_group_set_name(struct iommu_group *group, const char *name)
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
+struct iommu_domain *iommu_group_unshare_domain(struct iommu_group *group)
+{
+	atomic_dec(&group->domain_shared_ref);
+	WARN_ON(atomic_read(&group->domain_shared_ref) < 0);
+	return group->domain;
+}
+EXPORT_SYMBOL_GPL(iommu_group_unshare_domain);
+
 static int iommu_group_create_direct_mappings(struct iommu_group *group,
 					      struct device *dev)
 {
@@ -1437,7 +1461,8 @@ static int __iommu_attach_group(struct iommu_domain *domain,
 {
 	int ret;
 
-	if (group->default_domain && group->domain != group->default_domain)
+	if ((group->default_domain && group->domain != group->default_domain) ||
+	     atomic_read(&group->domain_shared_ref) > 0)
 		return -EBUSY;
 
 	ret = __iommu_group_for_each_dev(group, domain,
@@ -1474,6 +1499,8 @@ static void __iommu_detach_group(struct iommu_domain *domain,
 {
 	int ret;
 
+	WARN_ON(atomic_read(&group->domain_shared_ref) > 0);
+
 	if (!group->default_domain) {
 		__iommu_group_for_each_dev(group, domain,
 					   iommu_group_do_detach_device);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 87994c265bf5..013ac400b643 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -344,6 +344,9 @@ extern int iommu_domain_get_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
 extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
+extern struct iommu_domain *iommu_group_share_domain(struct iommu_group *group);
+extern struct iommu_domain *iommu_group_unshare_domain(
+		struct iommu_group *group);
 
 /* Window handling function prototypes */
 extern int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
@@ -616,6 +619,18 @@ static inline int iommu_domain_set_attr(struct iommu_domain *domain,
 	return -EINVAL;
 }
 
+static inline struct iommu_domain *iommu_group_share_domain(
+		struct iommu_group *group)
+{
+	return NULL;
+}
+
+static inline struct iommu_domain *iommu_group_unshare_domain(
+		struct iommu_group *group)
+{
+	return NULL;
+}
+
 static inline int  iommu_device_register(struct iommu_device *iommu)
 {
 	return -ENODEV;
-- 
2.17.1
