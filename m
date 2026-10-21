Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792602394;
	b=sWFJFFED+281anqZcAKb9NXwp/a+1ounvmcVrETX7LxnD+iQZP9jxuB6/IIyschZOwGx
	 dsoS/vYqyBiBsYw1A3cq18e9tF0bY1NAapJotvNJcJNu42MGwnZauYD6IGXCqywDy9/LI
	 mT4eGxyP/EjJOL6/KT2GR+es5Tzio9Dk86z2svfyrws0R8MW36/x2d6zAl9g63UlfWckL
	 qrhFbhCU2x9iOrpagpixlQy1CeTxrD5mVxSYHdeh3A3liqANkwfHVEzdL6a8MiIdztcMv
	 1LMmOMOO0MCeyOKQLpFB+vuKPoOoVZ3cllQMiwg5LcqW6s2ohNPQ/zKVpahTpHbwWLQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602394;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=I/kLrsfaX+zOOiYi5jQ7101n9LK/p6JJnj7mzuEC6oI=;
	b=0U/Nszu+G/wV1euO+yu5aI8AyIT07pRk5mo1Qe5lIH2Yin9iRgUMlkCBw/UHdTK16NAN
	 H5FT513QuX5K/lKQTVios2oJ1iy8hB3QtuApJgd0Pd3S2nl5yG7EaBm9RLXDBHWI2OD/U
	 GmFRzRpxrp3eWJBebPkeopYoWuXcN4RgY0kaMoZF6cqkIA2wZUskkCZAYgMesZYPztmQq
	 LRetvEfMc/F0/Ydve8uYPB9WdzeSNRk2t+zO7tSyStMY95Mij5SH4FH4vfX8fkCVIAi+/
	 IUIXRF1h8/+7NEBf74jpjT7rEOXCwzwSM4yfxc9C/IPMfQuFy126g+N6W6FkEga77Hw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=BDNoUCnA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.9
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012009.outbound.protection.outlook.com [52.101.43.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB97760A2615;
	Wed, 21 Oct 2026 17:06:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB97760A2615
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=BDNoUCnA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PguW3yrRaUEywhwhpcmxDFIuNwHdb+PlhIX7YIzRwFuaC/hQZXQ5jf14sHszglqMbHP1yEwi2wYIh6WR8HPTdFZv+BwujefuDChk+Wizh+XxCOtzVdZ1YeIUtEBd7kcdMGCYXCgrRrqxJrb3BLaBzL/Ke+wLuOQdL/hot/Tfl10rUf4BF0emw6m6KAAB/1VaSrXmCc1irInX5CQe1Kv5qoREj65pWTkVa0+rFhrVIAI6r84DIdoPWQmejBlNwn5wFXogFQLR2STadlDDCNCZbOAnfQxgs4QxmqL/3YGrwHo2WJxHdUg9LcaMn1L6/b+yFlZRFBuT8+GZ7RXhjEhE1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I/kLrsfaX+zOOiYi5jQ7101n9LK/p6JJnj7mzuEC6oI=;
 b=HKNr0zt70vLouEaI9ZHQHdZGYvEMvkARbJrQ7LtIXaepVIpgqqdvR/ZJ92t8uqj+vE4LaBKQLe+tk0nCWPj5umdKiVKaU72aZpnhsLDFMUX0mV9GK1sXYmU1qicoG/BUon+tvQ2CALNqVNeMKdbhw49zFcNRJ7ncB+3fCeDZDBz8PP00SdRGGUsg2ymABhyVYg6s9NjueW4sOE7HPrIwl/pDErLm1RiOYEKe+yX+v54XH2rlZzGxJVFfC2ymuoUJ5e38gR1H5T9M0ct+Zvaxi8rKNgtHYP+DPOZOrv5GpG/cr9Dl82nvLYH1oLy6mvwVfJweGW+58zjRlGvEYuXaNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/kLrsfaX+zOOiYi5jQ7101n9LK/p6JJnj7mzuEC6oI=;
 b=BDNoUCnA0rT+45V4/Dr7Ng0Zb0epYPNTKXm633pr7EKsShvOdTjHWj21ljnmHDIKs6ChA8BGRqiC7UNarv21PYh/fVYMxAwI99vx1oBmkgKKB4WqxTtAmcruDYzDHMAUQyauAZ5dzgE3rP+L1eCKSseghE+RElVRshBkzOQk6JI=
Received: from CH0PR04CA0096.namprd04.prod.outlook.com (2603:10b6:610:75::11)
 by MW3PR12MB4346.namprd12.prod.outlook.com (2603:10b6:303:58::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 17:06:28 +0000
Received: from CH01EPF000BE94F.namprd02.prod.outlook.com
 (2603:10b6:610:75:cafe::a2) by CH0PR04CA0096.outlook.office365.com
 (2603:10b6:610:75::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.15 via Frontend Transport; Wed,
 21 Oct 2026 17:06:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH01EPF000BE94F.mail.protection.outlook.com (10.167.244.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 17:06:27 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 21 Oct
 2026 12:06:26 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v5 5/7] crypto: ccp - Allow SNP platform data to be queried after SNP INIT
Date: Wed, 21 Oct 2026 17:05:01 +0000
Message-ID: <3351af6c2325131535a931cbe462636e3e75fb46.1792599491.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1792599491.git.prsampat@amd.com>
References: <cover.1792599491.git.prsampat@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94F:EE_|MW3PR12MB4346:EE_
X-MS-Office365-Filtering-Correlation-Id: 258d9fe8-f842-4147-a4dc-08df2f95a50f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700016|1800799024|23010399003|261021123027099003|261009223027099003|56012099006|11063799006|10067099003|22082099003|18002099003|6133799003|261021121427099003|3023799007|261021135927099002;
X-Microsoft-Antispam-Message-Info:
	trxlfxgTDpc29VK9umqLIFb6V1KgQZH8EUGqQpM+hoGPryYvsk0G251nloYtNjoGOsUDrQSG8W5ahMhPq20Ql8XBPLY56Y0iiGIcDZ5UbIfhpruZ1ydfuOALMT29Rt5mpSuPbNnoWmHEnbwlr3k+qvziJ4PBN/0q6SWtPy45oznfCgFtsA4JWo/f0Yehq3/N74237V/1SCtrIxXLgTuLGSj3cy8v0S8FcUNN8YIezZwyLJozizRcq4vlnFvbmosBy2+LEsd+z/hs33eoI4jL8MsgoWRa9epzqMLpvtoNyxMDiE2NWhx3gNa8Yl00pXdCWeMabcokZcb0jOsZyEUXRixgNwccZXb5SL7wk/pTSa7SpyPqvASua+4aJi5vK8P75O1FjcdrRK+M1fM3hlWxdUOceX3D5m2yK5eN6EkrZs6E8x7MM/A2PCyIxCakWxy5zI3keOJbrOE5YILHjIMCTOQWmUOhyD0xXtIBj1qfsZf2qiqwzjXvfepwCQt/wo5HjPAHPpsVkbUU8rk51FydFd4DhP/Hu/oRdr61Z46mTsqd1Ahcb70k5XSvd05sBf0IoAH6mskm06ZrSGHjBb+3OjT9ycqtQVr1egC70XSngL2aWA6B/Vlsa9Y8jINpt3Qd6IPnjxCSTZAhsGif0aEmCYTcDWZYI0P8hiuBvrJw/z8dxrZGhMppnKXMdr6k3iWkEj/PrHe8cHArcQFi857pxA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700016)(1800799024)(23010399003)(261021123027099003)(261009223027099003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(6133799003)(261021121427099003)(3023799007)(261021135927099002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eAOQgBCmKuMLDnITK7LUd/gczt8aGA2MtPWb7rAC5zDsH+59gT5WBFwupE37MXlAu+j4tVFtAty+MsRAyJJv0VVKRJHQKgaGXMIji4SU5SgrvxfEjWM4xWarjmv5K6wyunSACdlCIg2pJa8Kp0znkHp17Bo62ku+8MDFwV4kSjEZWS8LBBQfRLf7RV0t0XgHT83TtN8ZM1YX4arieSmyDqj6tYGrUwtD+q5xVV2WyWNFdhBCea0R7jDSeiprprVK9gyOTxrn37gtN4a26PSggAvuqMQYE6EgCl4ytoE1wZKCM89gNCOOVNcswxNG0RVwh7suDToTgf8kPRfSXrsb2Knanze87Os8UJpgshzvCVR/5mqFWEejMZXrIeynGTGmSIuC8O50jG4RQn0hkeMuGXHM9ugAUFE11nAWVamcSkVQWIhBQW9Ht+t1UTBs7sBu
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 17:06:27.5224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 258d9fe8-f842-4147-a4dc-08df2f95a50f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4346

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
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v4..v5:
No change
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

