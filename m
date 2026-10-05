Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012018.outbound.protection.outlook.com [52.101.48.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC2F480DD2;
	Mon,  5 Oct 2026 16:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791217028; cv=fail; b=N1eVlepOqtJfAxgN5nZKJWuwEOsJg4y5LF6dm111yuSeee6SojyHQTLdDPgubYHU1PLTFBmJJOmNcO/2N/lkpNW646mWbXOcYAUb/mZ8XNkth0eCRXRKY3lCiviLK3zVUOb2Alr4k7j6DJOTZNzzR11byqFVjlw0t1y8y3T4kM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791217028; c=relaxed/simple;
	bh=pRluhpGY8mH1gDLh53107yIqMbigOAUjYvMsNwcc02o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rkCURBxitHrruWwT+FZnIxJV7pXB6T7yrI0qyF42Mq2bItEtf5Nz3pEgI+Y3SElmF651GawiW8oy8WfjsD/jUNhw5MaRKy25vH7eKl1FlX0NnbNwtBtJIJOfghLDD88mhGgCL8j94Ps1IA0CPPJBs1U/63CeI1P69EVuTtm3jPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fNJUirJd; arc=fail smtp.client-ip=52.101.48.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fNJUirJd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fmP7u0xucx5sQE5Iy+8H20uBiJB49ziY3XR1vN5iqJGkuhHePoqZZY/LCuq6syYIoc5594YKzQjXFfTJv3tQXaok8hUgd2LAY20e/51QppGWkbD49ZpO5uJv+ufZ3OnL/qt1uCKKH+qxJJ8jloqeADZdW5nPqI28bA8G5zDDnIakrbCmsfmoYPIeFpuUohheJg9dRTPVFxkO3pwUaZbC/i7E41WM/eEeyiSlaK4WfuDqgRNDLNd4iscXJQyZ7l1o30n17ExUNndjChI/1kqTRWL7Xufd35zn8RmHPvQFxssPRPlY8vMErD/XD/0j2o7iTVoPzqCVAufkb2aMUK9qsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vg91gnp5GqLPLo/XhrWfZ2EtlMO9Z9IFFB6ndtHHn5c=;
 b=D8jmkCAn0f4y4YQQqcjl6jQvd18IjUGx8FHyWZb4i0WTF6IMK+pSCK3/9hsanUGZ8M3dxJ4uSTnyKv1qdNRyjX9W6oFInftob8Ms4tugNBFiCcj7AaTvl8vMSZrFIdFIklLhcVaFnvnDZEQbg/WxlYYnqMooDP0wSFe/wsopkK9QUNqujFh5jdNarDXp4whuZ6suYC9CVVLEbWxJkWRbi6M06rmiXrXRvQyl7TDcmgvI1K3WrZXAJ45AEIA9/A525hPyi9LhiASRXp107d24OJLdz8MnApmMPuejmuHNXBpDJyVI9pdGX2uVRLkTARIxq0s03nxsYyTrHvEAPSgcFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vg91gnp5GqLPLo/XhrWfZ2EtlMO9Z9IFFB6ndtHHn5c=;
 b=fNJUirJdXpRM/hxr+sA9N8DanlnYWnx/7U0NU+H9GcGxA/4NhqhYta/owGGuYOjIj8H+QzMFJ44lupVYPSgCBVpihGrnNKCBWnzG0N1mSx/2RAoAMjFFGdZdusbEvvxh9MvBnnXitZY+c0+BeB9dGG70l3fDoXdHpBnn7npvznE=
Received: from BN0PR04CA0121.namprd04.prod.outlook.com (2603:10b6:408:ed::6)
 by CH1PPFD8936FA16.namprd12.prod.outlook.com (2603:10b6:61f:fc00::624) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Mon, 5 Oct
 2026 16:16:59 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com
 (2603:10b6:408:ed:cafe::97) by BN0PR04CA0121.outlook.office365.com
 (2603:10b6:408:ed::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Mon, 5
 Oct 2026 16:16:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Mon, 5 Oct 2026 16:16:59 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 11:16:56 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v3 5/7] crypto: ccp - Allow SNP platform data to be queried after SNP INIT
Date: Mon, 5 Oct 2026 16:15:39 +0000
Message-ID: <c09108e28dbf9f54cbf63f8c912fd5815b564f33.1791212077.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791212077.git.prsampat@amd.com>
References: <cover.1791212077.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|CH1PPFD8936FA16:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c06df16-b590-4dc6-d351-08df22fc158a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|36860700016|82310400026|376014|7416014|56012099006|11063799006|6133799003|3023799007|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8/a0cABnqgqtAngL2Gtu3HDfvVUEfqERNfdrVC4Vmz49s1ZnAD81jvHbJMd+sGnUk+0hi0DItWvyFa+OUgbK9WYcKv7OKh+p34yx60GkKWvMfqhsW2HaE3qLe+ZaFN8MlaE3EPt/s0N01F1824IptOT91SIMMuPxpawenHpm3tRsu40XakUvkURWc9IeYeVBTRIEU4hfe5HUvcyZH7O0TjcJWCm3JZZWbbA1wm/JtGqtpbJccOokV2Zrk25PbkyyC9bax8T9SqFCN5OAFxR7NZSM0pdE6ZAZ1T6EQh9KsYAMITnP/5FbjhMKdL/dmMiYoRpQBVtAvr7zJM+SY+99Vh95bL9lyxgJ6GVavX8Ez1attnQRs4sEOX0n12yMHv/BwRSbw42RyxVfIh2qW4/kegRMeRhcQAnKCv1+ieYX2Ly+jadjRUfaCkQpJHtkFvmrb5H8jXxnxJz2oSpgwxUHsPigiVkLKeIQFXNA27vDF4jxhqqXw5Y19Wl+AB0FJ41AIpyzAqdcvNJGuTQE535DMPYPKhtM0Y40C0LF2Vb4Op7vT3FpD7WysRviMWR/xRydLDbjGTpxn6QjdnBtMhLOZFPrZvg868xmSc56uVUf657oRwcwhIIBbxo7sKhRR+6QyKg2v/QpsiXDUShXjGPfc5SAcYRqktUV34PB+xnDtFYkrNlMYyggd6yXYr451TjbR6WIAVvFPXcmvK77ZRGfYw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(36860700016)(82310400026)(376014)(7416014)(56012099006)(11063799006)(6133799003)(3023799007)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	O+wXzZQZ9ITaKXkQHgsW9v5yFjmj2K/fXqJDlEGIuZoqZUSSkEVtTY8LWuk7CubQksH2kbMetqQGZ2fYzmdqiWE1DgIOXrdDtOqB1ZkIhMMgOuZwq3OEmNVsAnrX/W9e/HZbgExxSwm7rfef4deZJZdYc2cjRERsrF2bLAj86H0LToKD8cQ1l5Dqt3DFDZQ7K06TlQoYm++9y1wJl01yneMSKNAD2liWjwTYoXvfEENHlm72YeCrXoBGAzGD5WyJWbC+zHwWiZAIJ7fO6wWNyGp3X/4mgqgJW1/ZJt2OPGuLFirTDiKKUDnUwUleWlTwAY8gY7Kkc4yPszUjl9iGHhsr5qMxQrv8OkafKB2wsL7jiuDZigRWD2Xm13DNGXK1sp4x8AJVHmYrIgJPcUq7sZM00H6ihQRk7Uln6lXU0SoSox2XLXcoja990Wchhmoc
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 16:16:59.7996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c06df16-b590-4dc6-d351-08df22fc158a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFD8936FA16

In preparation for refreshing the cached SNP platform status and feature
information after a successful firmware live update from
DOWNLOAD_FIRMWARE_EX, allow snp_get_platform_data() to be called while
the SNP firmware is in the INIT state.

Once SNP is initialized the firmware requires the output page of both
commands to be firmware-owned. sev->snp_plat_status cannot satisfy that
as it is embedded in struct sev_device, so use
__sev_do_snp_platform_status(), which stages the output through a
dedicated page. Allocate the SNP_FEATURE_INFO output page with
__snp_alloc_firmware_pages(), which transitions the page to
firmware-owned when SNP is initialized, and release it with
__snp_free_firmware_pages(), which reclaims it before freeing.

Typically this was only ever exercised during initialization. However
DOWNLOAD_FIRMWARE_EX can change that. Live firmware update can race with
IOCTLs such as SEV_FACTORY_RESET which could cause operations performed
on incorrect cached platform states. Avoid this race by wrapping the
function under the sev_cmd_mutex.

Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 1ed9e61a95cc..c40401c861d3 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -131,6 +131,8 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
 
 static int snp_shutdown_on_panic(struct notifier_block *nb,
 				 unsigned long reason, void *arg);
+static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
+					int *error);
 
 static struct notifier_block snp_panic_notifier = {
 	.notifier_call = snp_shutdown_on_panic,
@@ -1261,19 +1263,12 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
 {
 	struct sev_data_snp_feature_info snp_feat_info;
 	struct snp_feature_info *feat_info;
-	struct sev_data_snp_addr buf;
 	struct page *page;
 	int rc;
 
-	/*
-	 * This function is expected to be called before SNP is
-	 * initialized.
-	 */
-	if (sev->snp_initialized)
-		return -EINVAL;
+	lockdep_assert_held(&sev_cmd_mutex);
 
-	buf.address = __psp_pa(&sev->snp_plat_status);
-	rc = sev_do_cmd(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
+	rc = __sev_do_snp_platform_status(&sev->snp_plat_status, error);
 	if (rc) {
 		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
 			rc, *error);
@@ -1297,23 +1292,23 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
 	 * command to ensure structure is 8-byte aligned, and does not
 	 * cross a page boundary.
 	 */
-	page = alloc_page(GFP_KERNEL);
-	if (!page)
+	page = __snp_alloc_firmware_pages(GFP_KERNEL, 0, true);
+	feat_info =  page ? page_address(page) : NULL;
+	if (!feat_info)
 		return -ENOMEM;
 
-	feat_info = page_address(page);
 	snp_feat_info.length = sizeof(snp_feat_info);
 	snp_feat_info.ecx_in = 0;
 	snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
 
-	rc = sev_do_cmd(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
+	rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
 	if (!rc)
 		sev->snp_feat_info_0 = *feat_info;
 	else
 		dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
 			rc, *error);
 
-	__free_page(page);
+	__snp_free_firmware_pages(page, 0, true);
 
 	return rc;
 }
@@ -2097,6 +2092,8 @@ static int sev_get_api_version(void)
 	struct sev_user_data_status status;
 	int error = 0, ret;
 
+	guard(mutex)(&sev_cmd_mutex);
+
 	/*
 	 * Cache SNP platform status and SNP feature information
 	 * if SNP is available.
@@ -2107,7 +2104,7 @@ static int sev_get_api_version(void)
 			return 1;
 	}
 
-	ret = sev_platform_status(&status, &error);
+	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &status, &error);
 	if (ret) {
 		dev_err(sev->dev,
 			"SEV: failed to get status. Error: %#x\n", error);
-- 
2.43.0

