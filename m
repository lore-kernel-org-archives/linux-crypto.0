Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011038.outbound.protection.outlook.com [40.93.194.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A171E868;
	Mon,  1 Dec 2025 07:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764575641; cv=fail; b=cxmy1+OU+LuHJHZJ1+SBPJZYUsTenBg8NDmMuYdVq8qob5D6g1O+Jt6o1yqWqaqVomT4Nu3ujfEINpo3x4shQS1CIIboU0SO8uAOcAP1MZEISyNf5xXcofV5joHc+uoBhrgV8nBUsqY5sWIn6d9yNKEIftOPfWViT3bfLu5+LBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764575641; c=relaxed/simple;
	bh=9yrMiwuolCwqoFVPXXzVjBCMqGv3xJH1pXzzrPuLNkk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FlC6ivTSXXlbF8ckMOozXmBqEz3yclQ00v7j07ruvD9QlHVv9Un0g8KOhgQfdBHDfm3czBEgw+PyAEOW/PPSHzJGf05eDXkPI31HRZfFmIcPisocXRDEx2z5eaWehlgzO0b+G8DlJYyYAK3BiaJD4L4XeFk12PVr3ezyGC+2xRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Vo//ry1/; arc=fail smtp.client-ip=40.93.194.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Vo//ry1/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bjkweozteBngbkyRITGjdJJlmXXgf/BXf/qqq7a61RgM1jDJYC82bmAw9oxaGmgIPJeUwmOLG3uF7jArkkaUxpz7uD7isq4FwdPKbt9s4meT+Q9nyvhM3qYt4qOggeyVG9BeAQvekzvhTskhpC0fM5dPjjV8CY/+FKe3GSAFFY1skOHYSy2cu9FEjoIMWFcPI2UUiwO857nVM0loF+5jfuDmBK/I99jT3f1/0Dsp6ftnhkg9FPGWM6roWLSRnBtX3iiqNpY1+ohZNTxxlz71TeaNfu/2dhriZ9S/YAbbRYa5ygkEJFQNuKgwhScj+WB7M5qLXZ6PNa2Cmas0lYBaMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxmmKMj4hHeMUYsuIRxymCqyMMl443RvLWa+rGW3ggI=;
 b=GPk7fDBuNdzxvf2s8VMs6gKjfTl9mWVz1OtIQ2CkHLFWkSSgkgM0f7jE1neS0bhJyBxOqkViQViYC2a5Pffm3AbWuzRcdZIr5XWuxXsQ8pB9K4Qqb6jPVa8EwQXNw3WKqjcYk9az9EKytM7pensL/kzWlO+wfkNSlwuHgnb7AC6Ex/JlAmTtYDvvVzmvXz0ODzWaf5mnHENJz+M1YZxu5bwkSr/yb8VDFoJtaP4oL49aVe28O7Uc3pIijKpW7KQsY6IajmELq1PrH2DakCTSlGLQJ9krXBD/CK83mY4jOJQOd6FsXKXxg1lOT7H7HyskyYOVRVtFCgIyAmDPjrYSWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxmmKMj4hHeMUYsuIRxymCqyMMl443RvLWa+rGW3ggI=;
 b=Vo//ry1/4iweiOhiLPtdNhl0v19t5HNvARSjcZOsAHo8mDqwAu4743vMPNj7eUwfsxb1myCiPTgekXqbc+YjpwwhvJ2iuEYlWgs7ceB52/0ggaHb60v5Y3b+MX7KhKCpQNkTJZXUQx36zcVl/ssxB0Y2tE00yCMxaIFPnLR4Vwk=
Received: from MN2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:208:23a::12)
 by CH3PR12MB8281.namprd12.prod.outlook.com (2603:10b6:610:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 07:53:54 +0000
Received: from BL02EPF00021F6F.namprd02.prod.outlook.com
 (2603:10b6:208:23a:cafe::be) by MN2PR03CA0007.outlook.office365.com
 (2603:10b6:208:23a::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Mon,
 1 Dec 2025 07:53:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF00021F6F.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Mon, 1 Dec 2025 07:53:54 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 1 Dec
 2025 01:53:47 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Dan Williams <dan.j.williams@intel.com>, "Borislav
 Petkov (AMD)" <bp@alien8.de>, Alexey Kardashevskiy <aik@amd.com>,
	<linux-coco@lists.linux.dev>, Srikanth Aithal <Srikanth.Aithal@amd.com>
Subject: [PATCH kernel] crypto/ccp: Fix no-TSM build in SEV-TIO PCIe IDE
Date: Mon, 1 Dec 2025 18:52:57 +1100
Message-ID: <20251201075257.484492-1-aik@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <https://lore.kernel.org/r/ffbe5f5f-48c6-42b0-9f62-36fb0a4f67ab@amd.com>
References: <https://lore.kernel.org/r/ffbe5f5f-48c6-42b0-9f62-36fb0a4f67ab@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6F:EE_|CH3PR12MB8281:EE_
X-MS-Office365-Filtering-Correlation-Id: 6692ac3e-f466-420f-dab6-08de30aec65f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HPAT7qou3rHXEzAx/92eEjZ7WwPUHdL7okOBDObFxA/lx4PogXDg/HrxxsFU?=
 =?us-ascii?Q?o+LtrMezGJ4M4J14QjE0/T8GzAtyLNiB7b5GN24Kxnz+fzUnJ87o7ulS1O4w?=
 =?us-ascii?Q?sz/UWob9jZ8e+HmkcxVrMmvDZyPjhpxnzWtL0OvDI1+sgtjR6ac1xCNiLGIC?=
 =?us-ascii?Q?96/MhYaAJEP2FC+y+M9cbHrfTF7Fg4Kelzz61s3+mvInGDFaTUIxZoJHGyQ4?=
 =?us-ascii?Q?GzXxgWm1A1Yw7Shp2lv46geMWsi84DAA8hKJl14W2g5OmgNWvm5eFEQz+/bB?=
 =?us-ascii?Q?5rpSL1ctFZFocnUo/Bx3dKMxBGgd/HcNL6W3WIp8BF9VZcoDkAZBccPcXuM1?=
 =?us-ascii?Q?CHssUCTZR6mW/hRfiVVD/af182TL1p3yApJ6p5OYSoqhwmKTVfRdRVpJQYGV?=
 =?us-ascii?Q?wac47pFZxQaDkVm/hIlc3QD679Ephzou0p4ecemiRjJzh4HRYqifbSvtKDC7?=
 =?us-ascii?Q?I8dS1pAnYlt48kc5BgjqqycR6t+ZSNMnFlVoO+2WclsqZITGFgzPnEBtEmzs?=
 =?us-ascii?Q?4VsRHnUl8rEa4AzAujBqQpjI9gfP+sMNeh+y3POoFJECTl9nfiHX2H3m3pDC?=
 =?us-ascii?Q?PVhht34oMdg5UbXpwsrsPBMPD4tyepgZr/4WtWHD7qROtPQECByqCRgrjFyV?=
 =?us-ascii?Q?hw8HSW887DxFQp4wYDhrOUi5W6DGO4ZlzO1MclqJdLW7EhLY0QATAtp7Ae6w?=
 =?us-ascii?Q?U4Bspb3nz7crO5kd5zk9EYE88JGoNP3Unh7814z3Ilhmzzv88Bh+o3HnILKN?=
 =?us-ascii?Q?EifPA5pVgJgB3eBxUsM5qSrQosDjcyV8wo+LKLsFd4vhtfst3QHqWMXvk2GT?=
 =?us-ascii?Q?CznOhe6HuKr1njAAEFkRJYpx4wGvb3r2Mk5VdDU4uUn7i2gG5B1AoPuJrOuE?=
 =?us-ascii?Q?EEMungX0BqRzAUDGocW1D1y4yMaz2yacue8DdhxWWtYFWS4La3RP/ORI7W/O?=
 =?us-ascii?Q?BWt4PFhsA+/nUQIIkGnJMKtLudTQiSDm6LSo3s2ftdgIk7PvMBQhm2gd7115?=
 =?us-ascii?Q?yoqDDdp+FaT7LYDorEuuqNzxgfZqteks54xX+sp5TV1hn3RgW5LtjUuFfF5T?=
 =?us-ascii?Q?DJ80anndy5wVFjwxigr5Y7csSWk4kXHg0X3jF7QtXYew1trKe56BTi48fXX0?=
 =?us-ascii?Q?8IMxuLUBhIAQHrD6m3SVTqC+3JJIOpMpRMQI6DVLk0yChBkpcD2HyDpXay1t?=
 =?us-ascii?Q?RkKBNM40WlIsU3bp9Ae6+VXHXYBwBuUff+d8rvlNeq21P0qrmHmwsHxPBe/u?=
 =?us-ascii?Q?R9R5mq/a9VU4Ug0QCy/2yr3Qv48dEIYcui0Wdo8qWtzgAaUmjW4msLbRhsRE?=
 =?us-ascii?Q?+LV1ErKbJjUWDIftzaOMEACmv8qCeGXoIilkYDJXHDcoojg1YnUwXccdBngY?=
 =?us-ascii?Q?FjNPS1yBMRY6YpeGAmAzJ+AevJ4qkNydLMfER5gBjhamRyp1G7K1PlEFAuak?=
 =?us-ascii?Q?BxbjfaCOCW+2AG0CDG8HxBhikDEL5x1hgxHYhP5hNvsKKQxheucyAITuE+rB?=
 =?us-ascii?Q?rtVv0RkMpUKqI4+TYA8RK5UMCG3ND6IQ4fzCNauDkQoqsb2IwRBu/OSdtJA8?=
 =?us-ascii?Q?Sav8ljKd1MlDV0k/H0s=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 07:53:54.3365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6692ac3e-f466-420f-dab6-08de30aec65f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8281

Here are some cleanups for disable TSM+IDE.

Fixes: 3532f6154971 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Reported-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

Better be just squashed into 3532f6154971 while it is in the next.
---
 drivers/crypto/ccp/sev-dev-tio.h | 12 ------------
 drivers/crypto/ccp/sev-dev.h     |  8 ++++++++
 drivers/crypto/ccp/sev-dev.c     | 12 ++++--------
 3 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tio.h b/drivers/crypto/ccp/sev-dev-tio.h
index 7c42351210ef..71f232a2b08b 100644
--- a/drivers/crypto/ccp/sev-dev-tio.h
+++ b/drivers/crypto/ccp/sev-dev-tio.h
@@ -7,8 +7,6 @@
 #include <linux/pci-ide.h>
 #include <uapi/linux/psp-sev.h>
 
-#if defined(CONFIG_CRYPTO_DEV_SP_PSP)
-
 struct sla_addr_t {
 	union {
 		u64 sla;
@@ -129,14 +127,4 @@ int sev_tio_dev_connect(struct tsm_dsm_tio *dev_data, u8 tc_mask, u8 ids[8], u8
 int sev_tio_dev_disconnect(struct tsm_dsm_tio *dev_data, bool force);
 int sev_tio_dev_reclaim(struct tsm_dsm_tio *dev_data);
 
-#endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
-
-#if defined(CONFIG_PCI_TSM)
-void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page);
-void sev_tsm_uninit(struct sev_device *sev);
-int sev_tio_cmd_buffer_len(int cmd);
-#else
-static inline int sev_tio_cmd_buffer_len(int cmd) { return 0; }
-#endif
-
 #endif	/* __PSP_SEV_TIO_H__ */
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index dced4a8e9f01..d3e506206dbd 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -81,4 +81,12 @@ void sev_pci_exit(void);
 struct page *snp_alloc_hv_fixed_pages(unsigned int num_2mb_pages);
 void snp_free_hv_fixed_pages(struct page *page);
 
+#if defined(CONFIG_PCI_TSM)
+void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page);
+void sev_tsm_uninit(struct sev_device *sev);
+int sev_tio_cmd_buffer_len(int cmd);
+#else
+static inline int sev_tio_cmd_buffer_len(int cmd) { return 0; }
+#endif
+
 #endif /* __SEV_DEV_H */
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 365867f381e9..67ea9b30159a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -38,7 +38,6 @@
 
 #include "psp-dev.h"
 #include "sev-dev.h"
-#include "sev-dev-tio.h"
 
 #define DEVICE_NAME		"sev"
 #define SEV_FW_FILE		"amd/sev.fw"
@@ -1365,11 +1364,6 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	return 0;
 }
 
-static bool sev_tio_present(struct sev_device *sev)
-{
-	return (sev->snp_feat_info_0.ebx & SNP_SEV_TIO_SUPPORTED) != 0;
-}
-
 static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 {
 	struct psp_device *psp = psp_master;
@@ -1448,10 +1442,12 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		data.list_paddr = __psp_pa(snp_range_list);
 
 #if defined(CONFIG_PCI_TSM)
-		data.tio_en = sev_tio_present(sev) &&
+		bool tio_supp = !!(sev->snp_feat_info_0.ebx & SNP_SEV_TIO_SUPPORTED);
+
+		data.tio_en = tio_supp &&
 			sev_tio_enabled && psp_init_on_probe &&
 			amd_iommu_sev_tio_supported();
-		if (sev_tio_present(sev) && !psp_init_on_probe)
+		if (tio_supp && !psp_init_on_probe)
 			dev_warn(sev->dev, "SEV-TIO as incompatible with psp_init_on_probe=0\n");
 #endif
 		cmd = SEV_CMD_SNP_INIT_EX;
-- 
2.51.1

