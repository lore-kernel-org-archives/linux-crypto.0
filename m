Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012069.outbound.protection.outlook.com [52.101.53.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ED22F8BCD;
	Fri, 21 Nov 2025 08:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763712446; cv=fail; b=NPmOKY1bpb617hGvdHxtlCkHi9dJnR/w0XVPGENw1w7ZJAsvNQYoVFirLbc3ykToQK1g5zM7f9ii/7wdmjOs6/VDCEUUvCj2lqw1YvbPw0CiJw5T/VUZSJZIaO8UUHfvfW4tRfmCg5Isc74jDUWxr87SSXCQg+8Ab8pblJEuXF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763712446; c=relaxed/simple;
	bh=eESXuq1cgqrFmPJCVSmA4s+jGH5QBcptGBVCekio0wg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FvkS/7fF1oTzKA66qpQ4sAyt4G+W+0ybtDK6JNnNSw9rLZfFBmhEVN7t28Ubz99wZlR5o6eBirmuGG0kIh06veedQ7HpACVkKiYG/h8v1Vf7mEUsQojpvYeQomJCkckF3t6Uj1gQ2dRS8sJ9+P0wbYIpLZ7EQT6KcDSvTpS53Pc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HJZeKCrs; arc=fail smtp.client-ip=52.101.53.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HJZeKCrs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YHKgu2w79DbL6iUz9jWqBrN7sANsQMCIvEfJClV2dc1ka1GaFN1A1SYTOvHDp2uM4Uzum0Fq6A1Wy7269ydnsbRawgxJvf+nD30ZwfXjF7t7e00SJ3kqqwKgBakCIcS0tTMr5t6Nzqbpae9pkhKqwPcF8fmKgd+O/qnT0PkH2vslyb/t4rOjBu2S8M13bQG4YOzyHdNbbgkxek7HVxWethT6k1Z2Z629HOQwfinnAAh7YECqp/PB/sgQtPPyjZiOG/XUo/+DJrtS3GwDHmKYTwy6r42sNbngPwn6HYytOEY2zg/xSnVoabSZNNp5k/iEu/uV+xnzEm840u7uOf56MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kO0wfA8Pcb6a6tsLhWY6VkzyCEzMkYR0HZfhkTZvbVw=;
 b=RpnXSgySMLDlxylcFSGGusR2hgw3JrnWJ1vLicV51sjnt8RJARBm452g1oopTnNmk3uNb0bRcX6lrKiQhw5/mnOkEuIA3pNntZNCJnnVCxjcNYMlt9/MDom3HJZQXxpvoVjHi4lnGnylvThJrU3n/dXplfMHb5R1X8lv4kGZeM2syfsPqPjzu4P1A74BpJ08xxTZCpnnZ4A1O5ed1GzVA/T3/7Udss9/hKfHjaKKMJ0I7sU0CQV3tWr0pz8mgA9+2TpyS8mej4hbyGIorxVWsjIdZdoV8dy9xplyHMsunfhEE/Kjt0DprUG/j0z5Nn/9bR/D4q1/pIo1PoBjIRIpUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kO0wfA8Pcb6a6tsLhWY6VkzyCEzMkYR0HZfhkTZvbVw=;
 b=HJZeKCrssta5H2Bq/E1S9FILlNWG7ZONQ/ftiQL+tLUkxz+ll0bApQcY7+UqM1/AaRkF3mrk0S2OhIJc1N3NnrlrwaTtYHtSn+jc9svbyelLiUhTj6BBIZs8d2UoXyu+0fKtrBtgvA4ou/r8AQxrbSfdQT+BiwB8R6E6EvB3YMM=
Received: from DM6PR06CA0089.namprd06.prod.outlook.com (2603:10b6:5:336::22)
 by IA1PR12MB8520.namprd12.prod.outlook.com (2603:10b6:208:44d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Fri, 21 Nov
 2025 08:07:21 +0000
Received: from CY4PEPF0000EE3B.namprd03.prod.outlook.com
 (2603:10b6:5:336:cafe::ec) by DM6PR06CA0089.outlook.office365.com
 (2603:10b6:5:336::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.11 via Frontend Transport; Fri,
 21 Nov 2025 08:07:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE3B.mail.protection.outlook.com (10.167.242.14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 08:07:20 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 00:07:08 -0800
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-crypto@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, Kim Phillips
	<kim.phillips@amd.com>, Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, Gao Shiyuan
	<gaoshiyuan@baidu.com>, Sean Christopherson <seanjc@google.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>, Amit Shah
	<amit.shah@amd.com>, Peter Gonda <pgonda@google.com>,
	<iommu@lists.linux.dev>, Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel v2 1/5] ccp: Make snp_reclaim_pages and __sev_do_cmd_locked public
Date: Fri, 21 Nov 2025 19:06:25 +1100
Message-ID: <20251121080629.444992-2-aik@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121080629.444992-1-aik@amd.com>
References: <20251121080629.444992-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3B:EE_|IA1PR12MB8520:EE_
X-MS-Office365-Filtering-Correlation-Id: e2c808be-b7db-4f12-40c1-08de28d4fef0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FS1xlbeQqJ9M0dGvTaQTtYzjnh0r+wktMXDdBht9SEXF1Uosc4vwJ28m0UA0?=
 =?us-ascii?Q?pFCM0grxp78Fcfga/EO2/1zVAFTMrHEYWPEqii3i7kzT2o/fDVO9lLPpAfOH?=
 =?us-ascii?Q?lyXU567dgBNuB0qxk8OSFZq1PRHubfA/RcV9VVUsYf48W08lwdATMGlJxc8r?=
 =?us-ascii?Q?OGzVD06xlWd5OYbflpnqUGYnGQ1ViUEj2ylaGb0wYOEzP+CjFy6Kro1lGiIT?=
 =?us-ascii?Q?k9E8ySxLlSEOYuW1rs8q4IKPHOi/wv8yQknwzE8A5l7cvrrExlSS/R6YjgFV?=
 =?us-ascii?Q?PttkExThw9AOwnON++V42gdFY1txdS8xBBukTJv7O+0wZRAy0B1Hop0tCE6G?=
 =?us-ascii?Q?DOl9SeD3kMW6+pMC/TJ3PY/YuKLFlyht5hsYMg3pukNETAwtKUIkbvolwuo3?=
 =?us-ascii?Q?1PJEH4dAXcahz2S7vq0V1ruuttAXrzaIRDameRXMN23Qd2SbzxQ3+6VwtAGS?=
 =?us-ascii?Q?o6ajhoE2Y2dCAHlqtQGTV3qMPn7KQCbafvnk+uS4Qk1LXWRLWqFOTGArgpTh?=
 =?us-ascii?Q?KEVoWcPXiifCD6MxXY39rHkOUA3SMwolv+Dfxbs95RqeMI94dMUTwibLEDX5?=
 =?us-ascii?Q?ogZyVWON/Tc/lFKH5JoGFUC0Yvy8iMSEqo26NFLi5zjmXDv/RcJGy0LmP6g4?=
 =?us-ascii?Q?ssVR7eTgqkX0isinXoymRff4FAueAVOXdkTWW6jBwoEThmEFmNlsaqWV17/Q?=
 =?us-ascii?Q?u4TpTvTkIhi2ouJLKfEulxkedoU/3ebjrvraaZjNAWFpnf6y148KhXa7qfQx?=
 =?us-ascii?Q?9o12Mh0URd1aXH5YtXvy1zFBTyrC3JCqaCdcCfqoSBjy/SPvHEoh7wB+0zoH?=
 =?us-ascii?Q?2JfAC6dHGnBP0CuEh6A8//s3HTe/GdNxReRghbDPJ//4i3BopsPZSiTq4oof?=
 =?us-ascii?Q?6bowWpBN6VgXTQVBs7uUpid+eiO/zjee7aE6Wd4wKHOIcoIFxkhZNljFCvZ2?=
 =?us-ascii?Q?nXqvs3uvqH1H5ge5u5/g3FAsqiG0kxRvr7jYohiU0YihU9M8U6bTvS+75HxX?=
 =?us-ascii?Q?idswQzleKLmHLfGkpcqxdpE8TpCWnsJVcyHPfXmblkOLyg31+y7msv78lBt8?=
 =?us-ascii?Q?T7CCTrqFpeTpaudXJfMa1LGEYDvZwymACm7Yxw+DwmETISTEY90qGcGa69ER?=
 =?us-ascii?Q?7GE6MWmI1Kx0ow+qD1SNF3HkuGECsEEOSUkRHlyyi1/Mq7/sAodMU8TOkUat?=
 =?us-ascii?Q?DzTG+XzUmpLBRGJVmMQ+XwEowA2uTarRws8e9iwHzr3UPqWmF4vH1cgfUB1a?=
 =?us-ascii?Q?DJFbrTBnM0mVD42EuTFrXwl3cX+1dT4HTXqGaG2Buoh1xMk49PHEoWmqYuI2?=
 =?us-ascii?Q?xsFTmBh6DNNXTtnsEO7ozVPQaH7iT0ztcWb3GFfoyBSI+OJ74YgKb1aFzIdQ?=
 =?us-ascii?Q?rOflxC1FrArCUKyJngTttaNfnUhQg2gQRVJ/7NhCYYzrIJkExj9/1LReQrPY?=
 =?us-ascii?Q?CIJnzY3esxeKSHb3ke7ZrE0TQioVgSZ0douYCis8r7AOgtYqLhKn5ePcqsQG?=
 =?us-ascii?Q?M/WAJoHJaevY68PifFqIOeETq2m2QHwSewoUbA1gHpHQ4FK48ivwnztl9a8V?=
 =?us-ascii?Q?mL1RuOGhlQ2A56xKpWM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:07:20.7636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2c808be-b7db-4f12-40c1-08de28d4fef0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8520

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

