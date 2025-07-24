Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACED526C383;
	Thu, 24 Jul 2025 21:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753391862; cv=fail; b=CnQ/mDZmSiBzhDVR5BRP+hOTefz+WS5LMDbpTA+yl8viwjXIu8JxuaB5KfolowSaYynLqz3x/breQ9QJtAAIbYYgaXXEFxl2e8W6N7FEzT3jlqh5P+s/dznP61mVKkeSz+7vRF7FodVhU05pujQm1fICgYaPWIIQYlKZoXoQ7Uc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753391862; c=relaxed/simple;
	bh=+VSfKLp0886wdNrUY/3SLZb8ngrJWri2oKtYlR73qv0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tvRM40OipyMZVYQuYzCLi0BzvTv9X6EPF8kzKGAAiRa2q5ev6L2VYsZbK7TiHoSKE+4qkLpZYkpd/ZDczVqaGUt7/KZ4VW656cPUtVxXZqdZhLcYGmYyNBcKF2d69xlgT9K+cGvxHavAtOxTGvS9JaF5qFW5OyeDd1VXq1vaHP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jkOybsqd; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jkOybsqd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NNteOOGD+u5Psrzj674A7/I23sT+yctkBunh7gpuaXUvez9c6S+gLOWFx8rMC1opCZoSJ6pBjO3Hlcx3GgfHHev4CP/IWgyuUU+xKoPB05y2tuCOSGjbzWG/HGjEIBUKQ3Swf2DLLDZ8Y68+KWrqD+T8x0zO5iH+Yf5izkeir8/IHZI/ItxmQIkYOQDOkz6YEBLoTLmisqG3R8ac4jDYpCJTxHSQG/1+mpubssjI4PDZvN/zs7nB7r9ybGE3X3jdWqI0GcjRO/1jzpYUDewXPLvKRDZ7+N7p3Qmd2qYJ+UdYL/8NGw3mFO6coVUbNR30FPizLJiytw+yXHaviDcecg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IWrz94P8mXMcKK3Y9EhmGKDrHc8poepe23xWffVOo1Y=;
 b=pkpBORHtC5gFyJQf7N6iM8c7U5wd+Nk81uj4/mvJuq1vQLZKNA+DjiX8CNHWxjSYjzZ2L5abmn4OD6Kmk1Nf6guJfxxYtZXLQhj1PxUzRvGqGhFxUcRrSSYsYitvDavS3Y8fFeeuXhFeUN41syct9jWydR0fc5I9SddKHDPqYnJTg1vBQhVFwPZspTP6RQRvAYX1NIYyVlBjC8PrgibzVinwqd04gVGiazpjhA3Tk6lBaOpEmp2D/xTBbHMs2ZqsZ4f5EPR1yrTKcDbxhJvLeDi9D+VcOKcN2UDm3hvhFkm9DTzThbYYmA0i7NgnB4kLGyta4JB0gPOK8PZkr5sl4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWrz94P8mXMcKK3Y9EhmGKDrHc8poepe23xWffVOo1Y=;
 b=jkOybsqdI0BfmzsYxkVuzPCiIfc3AVwnzIvcQonltZ2RlUyKNyfCT0MyVDZY7ni/AE31OORbuWtx5boZskLrfr8KxDmDaLREgZSTFJQBSoyNwLDhjfQeQiPsDarTtMvXI5YChJFKTl4uotPE7QkKDZ1L6umkcY3p+UIUuYCJ2bs=
Received: from PH8PR07CA0035.namprd07.prod.outlook.com (2603:10b6:510:2cf::22)
 by PH7PR12MB5928.namprd12.prod.outlook.com (2603:10b6:510:1db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Thu, 24 Jul
 2025 21:17:37 +0000
Received: from SJ1PEPF000026C7.namprd04.prod.outlook.com
 (2603:10b6:510:2cf:cafe::f1) by PH8PR07CA0035.outlook.office365.com
 (2603:10b6:510:2cf::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.22 via Frontend Transport; Thu,
 24 Jul 2025 21:17:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000026C7.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Thu, 24 Jul 2025 21:17:36 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 24 Jul
 2025 16:14:54 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <michael.roth@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] crypto: ccp - Add new API for extending HV_Fixed Pages
Date: Thu, 24 Jul 2025 21:14:26 +0000
Message-ID: <a5dfa1b5e73286c2d7a2d38422577aff9de48226.1753389962.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1753389962.git.ashish.kalra@amd.com>
References: <cover.1753389962.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C7:EE_|PH7PR12MB5928:EE_
X-MS-Office365-Filtering-Correlation-Id: 9523f015-b7c2-4821-0213-08ddcaf783ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LwQU+6XG8jVbg4pE9AO1mEwJvoqnnH/A/qpViZhN/jmsg1LGAfhwsBV4GI6V?=
 =?us-ascii?Q?rqpxcMtQc7yY8YrieRubQUQuH45Y+2CxdFJYNz+5CDu4pWTlr3A0PtsiHHrv?=
 =?us-ascii?Q?mTmI0MlD14knlzOyNEf1c8r0L6D2VIKD+mtPyMOGAb1kln73bS+21mQjIylS?=
 =?us-ascii?Q?7Oflyuf58XaMXQ4FOzHsmjLWisWD0l4OKWVdJ6VJ1ckrYDCoA7ORqoFm8Nnz?=
 =?us-ascii?Q?tWrkHaeSawOWaxm/e75pjMOeWM3lEEDAQOu0uhoSy5qQOatcRNP8d+ZPuTTy?=
 =?us-ascii?Q?dHm5iKeusZPLw8aIlnTgo/U+vH/BzciaVPJnJ9kwq4t9kicncyVDvyMRKvDE?=
 =?us-ascii?Q?PH2AorFjEMrlBkZfV18g0nl2GP02W1mNZA4YYXoIAxMY4+dwnEy/UIcVu8ar?=
 =?us-ascii?Q?OUGtHfHw4VqAwWOnL3Kl8Hb4ec5n8d/R+VH5HqcfVXoYPww/4NFTh2N29Z8+?=
 =?us-ascii?Q?+d5AiWQaW/M96pypMRmgl8H3DN4KkBQHTsK8eP/aj5K3r+e4/eC728H/20a+?=
 =?us-ascii?Q?gxsUvuc+LZl5nFTQxr+UIV2DdZ5FL/jHjsyIg4lmabm832VYSH86yyFrAz18?=
 =?us-ascii?Q?fyAkJbVIhK2hBLnC2Eutv+qmS04Bg95GrjATeqQE3Kz1GXy6btt61OdNi7Zr?=
 =?us-ascii?Q?k6HrU5sBGKjwV6RQ6Lbd8WiTyk97hM6dYr+fVCHRwhfNba75BgoZIFb9owiv?=
 =?us-ascii?Q?gaSxUCjpJGSPsYtENviT3Xksf/mh79GuGJs6HvKLgf37BRJbDwm2XMfyaDFA?=
 =?us-ascii?Q?Pt+UL6eGef1stH1mB96Pl2IF6JoARX1qFfsrOf+gD44JBACWitfrfTwHuBhk?=
 =?us-ascii?Q?Wfclm3kdru59+C4vU7Oy+poYqrpZk9zkcpXPUMet64LHfyjJ2V6tYJPUip3V?=
 =?us-ascii?Q?xueJxJxyNv5T0L98rIueipga/9m9uxBdsvV2ANRi+Ab3XeYvcl+A8vvPpUi9?=
 =?us-ascii?Q?an+P4afgQm2iHdgFOxt7PjFtINXuPZd2jMrHiTQ4C/Juxmoaifb62ux+VtT1?=
 =?us-ascii?Q?b0CiOLNfSkWm2Ge/J6gLqPO/C4wdzf8fw5xr7Rzcv8V1Kia+U72hQcFAY4Xp?=
 =?us-ascii?Q?m4Jq6ip78B3p2cb1qm4hPjt2TTP7m35VxoB4c7/iVDpA+6KAhC32cya7KBP2?=
 =?us-ascii?Q?9a23Iiar8ticlLZDBpUqBpBxT7DPqSZKYzWV+YjVZDEH/bTT5b6FcnHrWpD9?=
 =?us-ascii?Q?5bn6IYwECIEXuFr+em6YL8qkmnP13fParXMhLNWRdBcri7eOHU3HlPMwQnPl?=
 =?us-ascii?Q?VGr3+C33/dX2CKSxH5UVU0M8617SJ5GrWyvwvPlgaBHCzJZz//m6HmQkOcNm?=
 =?us-ascii?Q?RWoKgeiv7Z5MIM4IDBGji6H+N50BnGza+nZ6tTZ8Aal2LZ9jf7DMtWUtWA6B?=
 =?us-ascii?Q?mdVlZJpS//sAalcFdvGaQvwWC0BqVWwwo6QQMNxTwQfEwC9qO131dh1UdjzX?=
 =?us-ascii?Q?/aq/ZgFF6lq2Ym/2DisKL0hXHXabxYpEGzjeAdOi2GWJWruGdDkddhiv+ldA?=
 =?us-ascii?Q?eNh3N+/sSHg63qXWUDejy6AQhhE/awpPRXjJ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 21:17:36.9570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9523f015-b7c2-4821-0213-08ddcaf783ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5928

From: Ashish Kalra <ashish.kalra@amd.com>

Implement new API to add support for extending the HV_Fixed pages list
passed to SNP_INIT_EX.

Adds a simple list based interface to extend the HV_Fixed pages list
for PSP sub-devices such as the SFS driver.

Suggested-by: Thomas.Lendacky@amd.com <Thomas.Lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 88 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |  3 ++
 2 files changed, 91 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e058ba027792..c3ff40cd7a96 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -82,6 +82,14 @@ MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
 static bool psp_dead;
 static int psp_timeout;
 
+struct snp_hv_fixed_pages_entry {
+	u64 base;
+	int npages;
+	struct list_head list;
+};
+static LIST_HEAD(snp_hv_fixed_pages);
+static DEFINE_SPINLOCK(snp_hv_fixed_pages_lock);
+
 /* Trusted Memory Region (TMR):
  *   The TMR is a 1MB area that must be 1MB aligned.  Use the page allocator
  *   to allocate the memory, which will return aligned memory for the specified
@@ -1073,6 +1081,76 @@ static void snp_set_hsave_pa(void *arg)
 	wrmsrq(MSR_VM_HSAVE_PA, 0);
 }
 
+int snp_insert_hypervisor_fixed_pages_list(u64 paddr, int npages)
+{
+	struct snp_hv_fixed_pages_entry *entry;
+
+	spin_lock(&snp_hv_fixed_pages_lock);
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		spin_unlock(&snp_hv_fixed_pages_lock);
+		return -ENOMEM;
+	}
+	entry->base = paddr;
+	entry->npages = npages;
+	list_add_tail(&entry->list, &snp_hv_fixed_pages);
+
+	spin_unlock(&snp_hv_fixed_pages_lock);
+
+	return 0;
+}
+
+void snp_delete_hypervisor_fixed_pages_list(u64 paddr)
+{
+	struct snp_hv_fixed_pages_entry *entry, *nentry;
+
+	spin_lock(&snp_hv_fixed_pages_lock);
+	list_for_each_entry_safe(entry, nentry, &snp_hv_fixed_pages, list) {
+		if (entry->base == paddr) {
+			list_del(&entry->list);
+			kfree(entry);
+			break;
+		}
+	}
+	spin_unlock(&snp_hv_fixed_pages_lock);
+}
+
+static int snp_extend_hypervisor_fixed_pages(struct sev_data_range_list *range_list)
+{
+	struct sev_data_range *range = &range_list->ranges[range_list->num_elements];
+	struct snp_hv_fixed_pages_entry *entry;
+	int new_element_count, ret = 0;
+
+	spin_lock(&snp_hv_fixed_pages_lock);
+	if (list_empty(&snp_hv_fixed_pages))
+		goto out;
+
+	new_element_count = list_count_nodes(&snp_hv_fixed_pages) +
+			    range_list->num_elements;
+
+	/*
+	 * Ensure the list of HV_FIXED pages that will be passed to firmware
+	 * do not exceed the page-sized argument buffer.
+	 */
+	if (new_element_count * sizeof(struct sev_data_range) +
+	    sizeof(struct sev_data_range_list) > PAGE_SIZE) {
+		ret = -E2BIG;
+		goto out;
+	}
+
+	list_for_each_entry(entry, &snp_hv_fixed_pages, list) {
+		range->base = entry->base;
+		range->page_count = entry->npages;
+		range++;
+	}
+	range_list->num_elements = new_element_count;
+out:
+	spin_unlock(&snp_hv_fixed_pages_lock);
+
+	return ret;
+}
+
 static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 {
 	struct sev_data_range_list *range_list = arg;
@@ -1163,6 +1241,16 @@ static int __sev_snp_init_locked(int *error)
 			return rc;
 		}
 
+		/*
+		 * Extend the HV_Fixed pages list with HV_Fixed pages added from other
+		 * PSP sub-devices such as SFS. Warn if the list can't be extended
+		 * but continue with SNP_INIT_EX.
+		 */
+		rc = snp_extend_hypervisor_fixed_pages(snp_range_list);
+		if (rc)
+			dev_warn(sev->dev,
+				 "SEV: SNP_INIT_EX extend HV_Fixed pages failed rc = %d\n", rc);
+
 		memset(&data, 0, sizeof(data));
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 3e4e5574e88a..444d7fffd801 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -65,4 +65,7 @@ void sev_dev_destroy(struct psp_device *psp);
 void sev_pci_init(void);
 void sev_pci_exit(void);
 
+int snp_insert_hypervisor_fixed_pages_list(u64 paddr, int npages);
+void snp_delete_hypervisor_fixed_pages_list(u64 paddr);
+
 #endif /* __SEV_DEV_H */
-- 
2.34.1

