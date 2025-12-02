Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013028.outbound.protection.outlook.com [40.107.201.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03033597B;
	Tue,  2 Dec 2025 02:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764643585; cv=fail; b=XuEfDjHpFJxwG68R3jozX+QlVdpuE64G0FbwOZa93gau9iONigeJNsuw8GhFp1SUoLttcOymymEJ90+kqtU5xQV8ZJkHbxbdRa6qCvBiwK6X221HN1Kl9RY7ZkDe3qF/EXEOKDCshW9zBq1uoL6aRLySzT9NugV8ORCKoXPEJnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764643585; c=relaxed/simple;
	bh=4eoDYJoBjaLMGnjpS4CW9Aj2ahyBWK3IsxQVmGwcNpw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J+ak7A4coBdHT2OfAdzPspm5UVTvlOvhkWnDHgerqRfe9tjoKjG78ra8kush+ddb56zjqSktOMQ65Ac+nOTvMs9ZpBj8tiqxjDstg5bAA7HkfOxveWor/QIHkBj/stehLbNv695pXG2E1p5g2zEEdAZwWIp2QAXhnhXZ1TklZlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zeAYTHUi; arc=fail smtp.client-ip=40.107.201.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zeAYTHUi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RNopS5xNqjofi1GcIub71FYiH6Sxl2o5iYv5pBLxoI/Cl7IcvvyABy9a0cl/TvMiqt9MrRsxQbTpvKoTHfkWdkq67E7eCXYqRy6WxShBylsDTAYCBv0OwapaSWSGymGodX0t7IsG09ZfXiBgMX+OHnvPOuFw7Jp3ira9DKIi8GIEq19LvhMyvrpamHbMIfg7mRYf161CQyVtlH7wk0gKfMQTy14B78bnKntJCQitPu4xNLj5K+q7DnH4s88EZSDn0PZAEzbwsJE+Ci23aoGu/DmPzYH7Ggv3yhwFKqSaUzLv6bPfdd8hRa5JcAhaNygGavTk+QxFksw/hxkC9FAERA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KknJf2ozoM6U4HHuUCBefQi9p0ZQ4nX/uHoVMl0SvLk=;
 b=WTJzaGLPK2XIje72rpfGKe7UOihDMrJxREOL6eoSVDJYAleP98v0+zho2n60jOXYz0mULkknIN31lAywFWmWDbnaLgq2DciAr45zA1S3QFUoME5HUAWM7ckrGdrla9fAp1in7huHP3LbmuzUNJwMuW0Hvr0v4QMIvavRxNSZHdaMUI2s6NaIsg1+RdAiheNVodREUHfXvXdWywss1RgMYYXZswivkg89ycRVG8OAr/GQj+Un8gHj+75xl1fJsjW43oFTNa+d24jaeqhY87QcQ/GS7CtW9pKp9S2qaF0BcLfVIHml56syWmbCOc80DY+YYIzPqoW0OX+GYKBxCb7M7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KknJf2ozoM6U4HHuUCBefQi9p0ZQ4nX/uHoVMl0SvLk=;
 b=zeAYTHUihk1K+HbpUS66qtQKZ8N8eIOYyoCmIbrvakSQb6VRgAmTO9vAyfQoQOdUORxpIB4/7VBNV05uLT7Gxhv7Utspzbz2HkbsQYt+s9v7QzEVdjrqEQKyL7u8zeWf6n6cOr4Yo4iEhhhnfnlxcMIDdIbSnwXRdFttpCvnFx4=
Received: from SJ0PR03CA0211.namprd03.prod.outlook.com (2603:10b6:a03:39f::6)
 by LV8PR12MB9230.namprd12.prod.outlook.com (2603:10b6:408:186::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 02:46:18 +0000
Received: from SJ5PEPF000001EF.namprd05.prod.outlook.com
 (2603:10b6:a03:39f:cafe::df) by SJ0PR03CA0211.outlook.office365.com
 (2603:10b6:a03:39f::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Tue,
 2 Dec 2025 02:45:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EF.mail.protection.outlook.com (10.167.242.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 2 Dec 2025 02:46:18 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 1 Dec
 2025 20:46:04 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-crypto@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, Borislav Petkov <bp@suse.de>, "Borislav Petkov (AMD)"
	<bp@alien8.de>, Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Gao Shiyuan <gaoshiyuan@baidu.com>, "Sean
 Christopherson" <seanjc@google.com>, Kim Phillips <kim.phillips@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, <iommu@lists.linux.dev>, "Alexey
 Kardashevskiy" <aik@amd.com>, <x86@kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH kernel v3 1/4] ccp: Make snp_reclaim_pages and __sev_do_cmd_locked public
Date: Tue, 2 Dec 2025 13:44:46 +1100
Message-ID: <20251202024449.542361-2-aik@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251202024449.542361-1-aik@amd.com>
References: <20251202024449.542361-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EF:EE_|LV8PR12MB9230:EE_
X-MS-Office365-Filtering-Correlation-Id: a36ad92b-505d-4e9d-dbbe-08de314cf81d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mEO9a5nT61MdNeEO/RxCpU0Jii+ELz2hwrCbUve04BSCDqqdHmbkPqj0mJEN?=
 =?us-ascii?Q?XRl8ZSABQGXW8PgJxQQLDeyXkUDoCJlXRVFzBMjCh2pgZMFw13RjxAFwUgKc?=
 =?us-ascii?Q?hYjWBkkzZj8+7CtzrXO6LVrWnIl8VXGIzgnbrx9/aB1NxUHl7DkeEt/Iy3cG?=
 =?us-ascii?Q?Eb8Op6d8sN2ylglznq6mrPDiAfVq8aYROHYxIScdoPt9EHdpAWVAsIrjTPFV?=
 =?us-ascii?Q?oiY1qPEjYA27WItaw9fMueHkhY6b8EXEsQ/CrPSV/FqKLooOjBN8GRCs+whw?=
 =?us-ascii?Q?XKF0Z9EPftTh7pbHFaCgtDT8KuNU4nAYRrDepYhCGoMN7MYNWx5NTBa4KeDC?=
 =?us-ascii?Q?ic3YhWAI3fIrYNo9BQsoSSO8iWk87K1Pa5WuMznbJCrW5mq/HDcqQULOmhoc?=
 =?us-ascii?Q?QDL0NJFFcJjX8mmmDLXg4W0qbtiS33CeR8qvrfs92n6c0trP4g5OqQRBZSjy?=
 =?us-ascii?Q?wRwYssHcHAL6Nyb2hpwrWZen75XF2aLgVNuu8kKoLthT6qI22OuFU5uGz/8k?=
 =?us-ascii?Q?k+pYBaeZ8CjFNtl23wgegv0jjNgLCQ8KhQJszw09d198D859ckkdZmClEbg+?=
 =?us-ascii?Q?ccze3AIUC4Mm1GNQHoF3CARDTvVKQHKLRbOGP5pgQyZ/EQiDoY1r8e81g8zd?=
 =?us-ascii?Q?92K8l20YvzU89pp1qmgHvfayjfuq5Sqh8paWCHXm+usMGWhUctKN0IkU4wNA?=
 =?us-ascii?Q?jl9h6MRJJ+Z8cc54LJEiEKrmYYzDl7VKyWA4yzqDIBPyTUxFxJWm2TSQ+pkx?=
 =?us-ascii?Q?3effqHBYiwlVXYjEMX4Hr2lIz3PPD1Ub/tM57b2rm7u6GE/3buo8UxSPVeae?=
 =?us-ascii?Q?3EhbhcJULhRDZ1m34BCmW8rTcO0vGq16BjaxUpRW6emirqbc5DwDT5W2VcKf?=
 =?us-ascii?Q?nFuzwvcfL9NWEnWD8XvEjVE9tOOPd+iy7vIjk/KSmFhIzeZ0qXgMZusXCGFj?=
 =?us-ascii?Q?iTRG+I4nzaOY1nGj57PHXN1hUIh+1+7tg+8D0qcjfwuQ4iArjzz/8yFduyNb?=
 =?us-ascii?Q?nMsepTJT2x0XVgeUCHzv8nIo0+rs+TpDt44vsDgbZjsQUG+rYWZHbztlpYHz?=
 =?us-ascii?Q?QDBBgGpteomOYcYf41dVJ4rZRQiZVi48R2R6VXuPFJ7pDRWNpSD9yDZZWwLp?=
 =?us-ascii?Q?XM8CC+26dd+7I9iYgMbEw/b+rN9iuI9j9rfEUoIAZiyHxQ+RRondKs2nXBL+?=
 =?us-ascii?Q?/auw4y6e7OSrG3yVIZ+wSRv6rwQLZ60Uxu3DJ3On71UsFreGLYDMLsQGD2VI?=
 =?us-ascii?Q?sTT0qVQ1ro3qPB/wuf0/CRanG6WEurHmsi26Kw9euJeh7M+UqgutxVuczirg?=
 =?us-ascii?Q?wGR/IRgMsGZJpm4+wsdCMKWeeiHqRqXk+MlCtckHSloXxMkv5pYfV+JzLRL6?=
 =?us-ascii?Q?+giP/SKtxtkPATDTFsdjAWeebNxlfe04zVzGwrATqUxa4nftn2BGTodse9be?=
 =?us-ascii?Q?Xtl8C+O0n29ZOSB0MO7BGNrQRk8jA04/soAvy8kPqgclBD0v6+X5o5U+7hdr?=
 =?us-ascii?Q?Gh0k/Zbmovbd+NyhtCyDQTP4gsp9oYj05HaH?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 02:46:18.1842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a36ad92b-505d-4e9d-dbbe-08de314cf81d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9230

The snp_reclaim_pages() helper reclaims pages in the FW state. SEV-TIO
and the TMPM driver (a hardware engine which smashes IOMMU PDEs among
other things) will use to reclaim memory when cleaning up.

Share and export snp_reclaim_pages().

Most of the SEV-TIO code uses sev_do_cmd() which locks the sev_cmd_mutex
and already exported. But the SNP init code (which also sets up SEV-TIO)
executes under the sev_cmd_mutex lock so the SEV-TIO code has to use
the __sev_do_cmd_locked() helper. This one though does not need to be
exported/shared globally as SEV-TIO is a part of the CCP driver still.

Share __sev_do_cmd_locked() via the CCP internal header.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Link: https://patch.msgid.link/20251121080629.444992-2-aik@amd.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/crypto/ccp/sev-dev.h |  2 ++
 include/linux/psp-sev.h      |  6 ++++++
 drivers/crypto/ccp/sev-dev.c | 11 +++--------
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index ac03bd0848f7..b9029506383f 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -66,6 +66,8 @@ struct sev_device {
 int sev_dev_init(struct psp_device *psp);
 void sev_dev_destroy(struct psp_device *psp);
 
+int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
+
 void sev_pci_init(void);
 void sev_pci_exit(void);
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index e0dbcb4b4fd9..34a25209f909 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -992,6 +992,7 @@ int sev_do_cmd(int cmd, void *data, int *psp_ret);
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
+int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked);
 void snp_free_firmware_page(void *addr);
 void sev_platform_shutdown(void);
 bool sev_is_snp_ciphertext_hiding_supported(void);
@@ -1027,6 +1028,11 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
 	return NULL;
 }
 
+static inline int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
+{
+	return -ENODEV;
+}
+
 static inline void snp_free_firmware_page(void *addr) { }
 
 static inline void sev_platform_shutdown(void) { }
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 0d13d47c164b..9e0c16b36f9c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -387,13 +387,7 @@ static int sev_write_init_ex_file_if_required(int cmd_id)
 	return sev_write_init_ex_file();
 }
 
-/*
- * snp_reclaim_pages() needs __sev_do_cmd_locked(), and __sev_do_cmd_locked()
- * needs snp_reclaim_pages(), so a forward declaration is needed.
- */
-static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
-
-static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
+int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
 {
 	int ret, err, i;
 
@@ -427,6 +421,7 @@ static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool lock
 	snp_leak_pages(__phys_to_pfn(paddr), npages - i);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(snp_reclaim_pages);
 
 static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, bool locked)
 {
@@ -857,7 +852,7 @@ static int snp_reclaim_cmd_buf(int cmd, void *cmd_buf)
 	return 0;
 }
 
-static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
+int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
 	struct cmd_buf_desc desc_list[CMD_BUF_DESC_MAX] = {0};
 	struct psp_device *psp = psp_master;
-- 
2.51.1

