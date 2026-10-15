Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013019.outbound.protection.outlook.com [40.93.196.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC45D3BA220;
	Thu, 15 Oct 2026 02:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030536; cv=fail; b=SmbEb5Uuqr/HEhyN+KLEJX3Y99yUFkFBAjnZhdLVG8oXqDdV337/n3WwsygFbCGHrIPvpu+3anIMXoNPmLTEbTNlX9w80NeE0wj/LlVM19rNN+gT/nPOXrQ4xcWqN+A+buPdWj0/jwBmYZTbbd7uieOYQOVkJ/syZNWo0dWr7PE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030536; c=relaxed/simple;
	bh=bsnL6yDo/W7Zl8llPMf7OjDt2Qo+H95MPhhJanO2mIY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fLOn81mAw7cE6UAykUhLwz59LxJBbtt7RDqNqVZDHOtUx7VJrFmqfPtuqQG+v9iPV5ib/nFCoxo7HLmWBxNeW6NgAYlfgsdgGubbacH0LJ4I4ImnuGd+jYWc/2mjSthhPDZfc02wKXuo7hUrMOQSJ8znw0M8VZzF6n0Jb/wnbxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AyqWDCPG; arc=fail smtp.client-ip=40.93.196.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AyqWDCPG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ivXYLW0nhjsY0qJ1357yhogfso+WgPNISKTYFGBr8SkP8Sr2NG5x/c9V8bgaz9rI7x+aLGmWUgwEd5XQ2DHTSuUbv3lI3SlW9//ko1L6A3p69flGfPHyFAaTM7by7MvfQIJb31EDYSQ/4G5CZshYkXsabXgLCYrDgyeV0G6MvU5yrMJzuPngZqqmNdMYSBHrotPTDTRp7+91LwtlvY/UiRmZta/6mO+Vp2PK/wneGJZJ6vVWQOjTOOnJbWURgnSHlekuU/ehTcEGgO5pZCFXhm70gUk2WsqA9KJ+T6LZNL2Jllx5t3gSjRiQ4UaN/zthYs1D7mwqQS9ZpgwQHedsXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SY/FZ0vPzu5CnlNomt6+I82iSEsJGdSKL1z26Y5wXRM=;
 b=xKja+B3OSC5xH0kVN+PVs22GlTLSkQVTlWUWmF8N9Jorsvh3Vx8wLnhuTwCItIau4/5Qof8oJe/BXE2+aNgljYp1h6+T0/7Y/1g3Eepp+uoI38ctRx4ywV6gebHojlZezDMDvWChsJqtziN3i8cZsg1JOPBMGYnls7+LcTOT9M1cf3tj5D0AAj+wjN0Bc5jpRzxqOjCVUoMg07doKa54EXlSLlOqdBWJ7sCac0GcaAGdq4SbP3SVbE+HvCARbNtnc8jIRfUOyR4fa//rfXw2OPhQ+nu6ZUGJHb5Xzyv+uPQyFYXyr2NIEBwa3EcVVP06Mil7Wa1etTU4AIJB2jV3eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SY/FZ0vPzu5CnlNomt6+I82iSEsJGdSKL1z26Y5wXRM=;
 b=AyqWDCPGfS8aaX9kgErcyb1tR03Oq8XnRLW3IhWExG15fI/Xh1n+0l2QctER3SxvMFvtWy7K57t8eo/V5g4daCUbnXH9DrkB0b+tkaZXW+c1nhVSR1q+Il3/874eLTmizsvFpS7unbtY8iB/jMJtUopiwo9stoWUO8fRke7kN8k=
Received: from BN9PR03CA0899.namprd03.prod.outlook.com (2603:10b6:408:13c::34)
 by IA1PR12MB7566.namprd12.prod.outlook.com (2603:10b6:208:42e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 02:15:31 +0000
Received: from LV8PEPF00000068.namprd03.prod.outlook.com
 (2603:10b6:408:13c:cafe::76) by BN9PR03CA0899.outlook.office365.com
 (2603:10b6:408:13c::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Thu,
 15 Oct 2026 02:15:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 LV8PEPF00000068.mail.protection.outlook.com (10.167.248.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 02:15:31 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 21:15:24 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v4 5/7] crypto: ccp - Allow SNP platform data to be queried after SNP INIT
Date: Thu, 15 Oct 2026 02:14:07 +0000
Message-ID: <d79a84d4fa9da4c02d21a6a88f0651c66b0e2ef3.1792014060.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1792014060.git.prsampat@amd.com>
References: <cover.1792014060.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000068:EE_|IA1PR12MB7566:EE_
X-MS-Office365-Filtering-Correlation-Id: 521dd984-5016-46df-eb55-08df2a623012
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|82310400026|1800799024|23010399003|261009223027099003|10067099003|56012099006|11063799006|6133799003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zoET+AlKagTZP/YHO242mwY1ym9QgsUUFiPa9yFHhZ78Zv+rlOkg81+0AtnAsChGwDs0QeKTTHN81kVH26G2DlFoCu2mV4wr5iuDqa3m9nITsTBL0hlqriFaPbYPan5k4ajWM7l2l0M6vLUoNSSfhQ1njuzTNFHrJwuAbBqYRvKLEcgLpcA1t6IY/259TEnbU5Jk3KVnKY7iW66aMyk1RgwIHdiox3nCITaF2kJ/wFCYD7wsFZ8M2nHyMD9Y7zF7DEh6AONIqmDKuicdi5BjDFDW5n8gw/1Ln5qcmVH86qcjuRihlHPiAo+KPSMjm72k+gGBvnGV+MaQNy8kn3vCw3KEspxAf3JXcaFIUYbTiY9WDoFa2FgLyMrXxhJ4c5lNjR+fQQZP+4vaV7An2j1ltSufDp7of6pZjukt6GHyXK07VenvaZy23+OzYIdIBrinSjB80sIkf6C8P9i8DCpVZHUG3AiaH1n3h03f4KhwJ/y95ZlRDGWcL2/w5EmI6IR8PYMr2Gz2VCOD3OUBT4n8MrsiY0MbWceQyT05O5zdDhuRc8sro3hJ8V07QZU5i/hmQNVkcRj9YP/a6DSqb3PMvJfQcZ/FGyP/7QATPeZHdTMp8o6sty4E5buE7mc/wibrpifalvqMMGn7PwsQnkdYCKc/zKkfuUHo/+Zfe91c0ezOeFbg3y4gDfKu2oI2f6WjkEm7qbr/aFuCI4cApRwt3A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(82310400026)(1800799024)(23010399003)(261009223027099003)(10067099003)(56012099006)(11063799006)(6133799003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YORNdG727Is9Pp06WqzO7l426HciXLLuhoePbr2W5rtOw71kwhOCuuS/YXx1i+IrqD9wYJukSbQYuN/qEDmBtCKeMOrj9U6tIjw/F4bFVCU1bIVD9jWJhtE9WpLaf8JBT+25ldtyT0lUO2aI4UHf8IW/MyCnrEULXoD5jaLVnobhtOaolD9k3jSYa4mVX4BiKbvtCsrCRd+jP8/1RYOOW1Q9J9x5ozCyZkWNjgShtPfiMEsdBHZB/xczDnhYNmVz41wSv1CW6j25e+GGsG/ia+/jNqlaG4nxVLUOc12zceTxEA++6Cw7rsFxRWajkgaXlm4olfC+CBOe0ulPMT2LJ58qKSL/yr+UQVidvPkoVWDrtUUAE3PFA8dsyKCSDEKTMA9DBioxFsZMcUYuDWgv5CjU7MAHiznaN1Sbl6d2evJd3/zSxmfnLi5h9yMBpseh
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 02:15:31.1193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 521dd984-5016-46df-eb55-08df2a623012
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000068.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7566

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

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v3..v4:

* Collected reviewed-by tags
* Simplify snp_alloc_firmware_pages() error handing - Tom
---
 drivers/crypto/ccp/sev-dev.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 1ed9e61a95cc..76698a7a1a3c 100644
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
@@ -1297,7 +1292,7 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
 	 * command to ensure structure is 8-byte aligned, and does not
 	 * cross a page boundary.
 	 */
-	page = alloc_page(GFP_KERNEL);
+	page = __snp_alloc_firmware_pages(GFP_KERNEL, 0, true);
 	if (!page)
 		return -ENOMEM;
 
@@ -1306,14 +1301,14 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
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

