Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010044.outbound.protection.outlook.com [52.101.56.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BBD53FD57;
	Thu, 10 Sep 2026 17:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789059810; cv=fail; b=YOSUB+ytIJmvoTLWlo+8QtZ7S7nmkD+NIEdHmuXnVWBCRP2QgYS8ZAoYub6g7M6iij73zal/a2mbLCTui2WS3VVSla/aDHgh371AXUs5u0YFN7MGvY8KzAOwhQmYV811HhNV48bsLXOkiMZa/H5C1PzB9WVytWpjy9oojRCS4Kk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789059810; c=relaxed/simple;
	bh=uKnmV2HlF9EYN4PdRrbvCqxWqANVSqx3SdF1X1+CGBY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JR1BJ8KbR4uvr/bOzmz3TZtGLd6ffxBVoyH0lhowEndqCaA0SNHMvp5JnYiq35M32PV2vD4QXNy+2CeRbH2KoXCXU+fnXD8QvJ3ZTNjHxdpvgYMNIbLf6bbO9xTsRZX9FqEx54v3yp1X7NbDUGhtG42XutE3iWrug+P9ixQr7sI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=19vYB8r9; arc=fail smtp.client-ip=52.101.56.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="19vYB8r9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Faj937H1PJSWo0H7XApsvshsCo++09b8/kS4WFilYLAmTzRUdf5tffXhUNKYOzMhSQm4++2cTJXI2SX6PuSmt50sweCy9T+UUd1K+T3qlA+fN65YAeHj2LAedhcevni4L1182CzhCLjYCnHoskgqArX19NoAuYU0Arv6iI2eBK7Lfr9pWbDmenZoq/sk6QXGIM9+5V6Q8D/q25Ew6KCHsiH7pbdLHy4AqBHAXv+FD+98bJi0WC91uriYvIQwmYvLU1SSGaED5RsGc7IkYrJnDsSflv3LjOMyDZvCeu2xxn8zgTQLEiVo9cVRVcshks1VuvnZuCQ6wz727FiejVRpvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptMdhHUHcjN+reKW7443y5HNZ0W8AyN/gVAosD6/fiM=;
 b=c5xgCeVl2KRCjV1ED6Lfurc04WWSzXR+mGVQ2ZeDTY7Dk3vcw/MAnsPmXru14eyxcYX+lTWxCbUJHe7ZNKQtnGjSe9O2QoYrInkzWykdNOSJgxesKpK1pvqDduQFXAu7ZT6WHUt0+Yo0HdCddHoPgwHpmq+PxR8bhjFcfZv0rPZk7O6W2733Yek92E1XK07ANq2iAMzYLRpdZG6QEiMEK2yIxYm+8dijnt5wm5a7UMaySikEjzwpG/yBFY38nlGjPgT15mfZOScfwtv+B4lEk30P98ZzyUcfvY5tYOcB4042wWisLevZ9D3GrW4KceE+te3SQ3AnH5yuL+iuBarggA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptMdhHUHcjN+reKW7443y5HNZ0W8AyN/gVAosD6/fiM=;
 b=19vYB8r9owmEdzheWjBKVpUd9ql/gWwYZfFjearEFepBEVKT+6eDlMYm7dwzzg2yGdhNsKiKdVgLzR8fPA9EIGbyf0588bnx6R6rkJG1FbYOmsPDS61YWIk0Zu5wCOZQtG6Oeu3so5Vwcf29VxUEwrBKZ9E57XYYGZV7CnFdwg4=
Received: from CH0PR03CA0356.namprd03.prod.outlook.com (2603:10b6:610:11a::34)
 by SJ2PR12MB9244.namprd12.prod.outlook.com (2603:10b6:a03:574::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 17:03:13 +0000
Received: from CH1PEPF0000AD76.namprd04.prod.outlook.com
 (2603:10b6:610:11a:cafe::58) by CH0PR03CA0356.outlook.office365.com
 (2603:10b6:610:11a::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:03:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD76.mail.protection.outlook.com (10.167.244.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:03:09 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 12:03:08 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [PATCH 5/7] crypto: ccp - Allow SNP platform data to be queried after SNP INIT
Date: Thu, 10 Sep 2026 17:02:00 +0000
Message-ID: <acb69b69796f5324c41dfd7a1f207044f1f18069.1789059392.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789059391.git.prsampat@amd.com>
References: <cover.1789059391.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD76:EE_|SJ2PR12MB9244:EE_
X-MS-Office365-Filtering-Correlation-Id: e7f484ab-e8cf-4edf-c952-08df0f5d642f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|36860700016|376014|7416014|3023799007|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	Pq0fpMXxeCyr6m9F+WBREviodOV6NGfs9NxA8cB/yqSNlEclwmA7CEWGv4yArKcKAJVT0PvpcSAEIslMRKN/BS7g46DzuGTFJbfigHCYvHPg/JX5BgnPVsvXOx7tWxY/NPN2BDBRKMpvs7J7QpbXquOXKmaGYPpJaseUt5wFdxAQoSvL8N1x6Im9T544cjW2rLECADGKbm3SH4g5RXFssGX7gAxF3JGfJhd7Z3cAK5NtVRRT+5T5iK2OoGIyn2bj4JhMo6WwxfyrlJZBR/c5wvWgNeP9Myzlr8ftK81t/mC7uan751Toi+lrO9dEDSHYK27Sw7q61PW8zJjmkxr8WVakNiyY6IQmaR1SVQhj79NTgNNAzvpusk89Vw+p9qGpxV3goKt6O4E9m+EXPCRcbAmB0XrtnMACHmu+Tzd/g/GiBir0gMAMuNSO1DEfyM1O7wgEiqVVIg+QvNZb6vxKjnwxvwe928DBtAXUo5QpL95wX3smHVjiwr8gFqPZHTEg4xH10XjHusNyb5ytzir9VeJuIXoBF7Mo83SiHX0dVYz/KYJUydKGqy3JdO2xA0H/3sblX19WxTbkLyZhmUc7XSnHiKzQMsh1lF90vSO9nvHdPSek+PAaR3TKkGYtzfWVYVQWYN9+zA+cjyv7NlUGr6Ybkirc6qShviyoDcbfKCc11VWzb6KSLZwiE3ISGMaZk7SI/EV0ipFxCCnUFwhxUA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(36860700016)(376014)(7416014)(3023799007)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	z+3Yxs500MhXgWKXKjeggNF1qxmMbanMQP0hz4OlR4SCuUjVRutu2kQExUh1PsdLbnCNYEfrCb3RcfQEEYCNHSP/M38cErEz23qLwondBTuFmTMvkcA7+fw1pStiC71Pmgl24bfq9e4rxrnXN61WF6bi81OwYGjbuNHc9ahstla4TNJViWbfCJw0q3eZ+Uv3KvI68kXYrhD9HMZ95izJTqfri3B42N7HT8sN4GLN71Bmqp9+e3tXVuyAtWRFzaDsWti04JLvavW2sRBwzXfzdqxP832iHfEYiEZRqq0lsUKMYIXMA6H3dITMj34fAeOH2APkHL+c0xJv5HHF3JZjDlWUvXrJF39H/pgwlVJ+RrejjCSZwgJ6B8xoJJkRHEmGdtw2rPwxNY+wJnoRfLHbvqr8yxYeRBrvO3h+POFaeDXxP1MaMPynjiXcxX1uXmWz
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:03:09.6591
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7f484ab-e8cf-4edf-c952-08df0f5d642f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD76.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9244

In preparation for refreshing the cached SNP platform status and feature
information after a successful firmware live update from
DOWNLOAD_FIRMWARE_EX, allow snp_get_platform_data() to be called while
the SNP firmware is in the INIT state.

Once SNP is initialized the firmware requires the output page of both
commands to be firmware-owned. sev->snp_plat_status cannot satisfy that
as it is embedded in struct sev_device, so use
__sev_do_snp_platform_status(), which stages the output through a
dedicated page, and mark/reclaim the SNP_FEATURE_INFO page around the
command.

Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 44 ++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 1ed9e61a95cc..e891d6d1c6f0 100644
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
-
-	buf.address = __psp_pa(&sev->snp_plat_status);
-	rc = sev_do_cmd(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
+	mutex_lock(&sev_cmd_mutex);
+	rc = __sev_do_snp_platform_status(&sev->snp_plat_status, error);
+	mutex_unlock(&sev_cmd_mutex);
 	if (rc) {
 		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
 			rc, *error);
@@ -1302,17 +1297,46 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
 		return -ENOMEM;
 
 	feat_info = page_address(page);
+
+	/* If SNP is initialized, transition to use a firmware-owned page */
+	if (sev->snp_initialized) {
+		if (rmp_mark_pages_firmware(__pa(feat_info), 1, false)) {
+			*error = SEV_RET_NO_FW_CALL;
+			rc = -EFAULT;
+			goto free_page;
+		}
+	}
+
 	snp_feat_info.length = sizeof(snp_feat_info);
 	snp_feat_info.ecx_in = 0;
 	snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
 
 	rc = sev_do_cmd(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
+
+	/*
+	 * The feature_info page will be in reclaim state on success, or left
+	 * in firmware state on failure. Transition the pages back to
+	 * Hypervisor-owned state.
+	 *
+	 * snp_reclaim_pages() has already pinned the page via snp_leak_pages()
+	 * if it could not do so, which keeps it away from the allocator. The
+	 * reference taken here is dropped either way.
+	 */
+	if (sev->snp_initialized) {
+		if (snp_reclaim_pages(__pa(feat_info), 1, false)) {
+			*error = SEV_RET_NO_FW_CALL;
+			rc = -EFAULT;
+			goto free_page;
+		}
+	}
+
 	if (!rc)
 		sev->snp_feat_info_0 = *feat_info;
 	else
 		dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
 			rc, *error);
 
+free_page:
 	__free_page(page);
 
 	return rc;
-- 
2.43.0

