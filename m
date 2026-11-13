Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794592133;
	b=HPFXp5uHhwePgi+5O2iiax919wbtdiHr3XQVwLdyqpQWeGLIq/LEr9upYMiK4qf7rpeT
	 oh2ho9BnzNp3fXxf7xmZ2427Z0UcKWKMVfyENDfTDAZGtMGB8mK41uNb09gIE5qE0N0Xr
	 6GZtfaqXQTp+G6iztJhuA1AJhML0ZcK+VNAFSn6mMpDeVSWf6YjCsxCcUV8YLR3oFXbpb
	 M8vQK15wnE9ehl+lBc9fqpl46S3nzPz7imJmKnPheH4r7l3WFS80YgTfA5nPqlT4pK+CN
	 GSJWmf+2zBC0mgk0yELjTUK3Nw994NcNoPhVYFbrHM5sSc8QjLkxnD7z2E7T68FUpfA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794592133;
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
	bh=6ktgbzTOirYKMGQT2xwmnxQFYC7gdaQWNyN2JNFJ44Q=;
	b=YjlYeCtdDnKG1mVfE6ScXIrLWgaq3J6X9fxPq98Z+XrYRCqH6BBjYGAQGQm2wqYEuqQO
	 PjSwGtXaHnxYPkYP/CpaV30qPPPW4U0Ve9DchJhZGwGduli/KNrJlXeP70P8uS7KHun2w
	 ALsk9MwXqwQ9XrY1MwMDuZiwRyUKLbEKqLgAvfrzVLcVm8BI2hyul0+b0Htf5hTgb9GVZ
	 SXWdqx7yDmlXZCo+9NeLvHXD5W38WWF9iRvIuJOyXI/S2MoGZLlySg4XgvYoHxxAtiuQR
	 fuWNVdj/L6UN3rVVjP3WS5K/YPNrQ55P2zTNIEBnIZmdgkIrHWDObyhjrXxlv3BOkOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=DOKRvO8b;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.7
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011007.outbound.protection.outlook.com [40.93.194.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69457607A5C4;
	Fri, 13 Nov 2026 17:48:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69457607A5C4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=DOKRvO8b
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=seMlZx6MbS3Ia8+vl2E67BmJ0ImiJ8kHafVkFbedt9l24RyYUnhHoKoV1r4AJIB82Pn3pyfBu8ygX1EN9rnnMixILRVf53YH9n1Vhg3fRj0EEu+/Q6Q4rk1yrPvRToLWQh9RsCwgv7LHFxjSura9uFoJNBWAHbPmjMz8+xSCpNcW39zbDsixhrDmvF6lOCnD/+m8iR7cuQL4SAchFSwUyPiMHaLaG0V6OsFfZnkfkLk584xRc5vR5HWJ1ORkrr0NGXxV75qe9n/1KY/e0GInxfSl/zP9lkbjQXxe0/kUf9XvE34vF3M0o/JZgK1jzZfvhI3bdX0jK28ExZCoj+o5wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ktgbzTOirYKMGQT2xwmnxQFYC7gdaQWNyN2JNFJ44Q=;
 b=kfM98LDswqfEMTL4F2bhjdYC5xBdIAyb7wS4IizoJfqBEsEWgnTmT6xGWiZautDinLx1awpgQ5CcmdI/bcHiU20ckShxvDF0tQzK1RL192kKMkgY7Fchen6n+46d4fKlXLZYL5MNH5fmxElA6HUO+U2V3i8DbFGUQkBxD7vQ2v2AJHUSgTWmxfFI5/bcys8zJ5K8uKwuEJXPEt2GjaMhOh9R0deFjc4hl03xukiFsrR6nHwqEB26w8etkjMyQoF+c8oWXSmVGDhEeGD1kiGKQZ3z1zcrW28ejj2gLsQ1zPRFHsHcalmgyPBlrDgxPf1R8//dFh2IQs2JTCQUgvJfoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ktgbzTOirYKMGQT2xwmnxQFYC7gdaQWNyN2JNFJ44Q=;
 b=DOKRvO8bimEs93JOpTohUeoOdkoUtpboK0iimHsoxMiYwUVfcUe+K1T4AvGEWyz3Jnv/pHW+JqE/yq6cn1TtzzbG/iVYldkcyjw1XyZnSVpn1fBI0OnCI2Uj8z1KjVNp76Wiho9ZTgs1GzIbvhFsy75kQOh6PF9xXrnM2wZPlxs=
Received: from CH3P220CA0023.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::29)
 by SA1PR12MB7104.namprd12.prod.outlook.com (2603:10b6:806:29e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 17:33:11 +0000
Received: from BL2PEPF000352D6.namprd02.prod.outlook.com
 (2603:10b6:610:1e8:cafe::a4) by CH3P220CA0023.outlook.office365.com
 (2603:10b6:610:1e8::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Fri,
 13 Nov 2026 17:33:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL2PEPF000352D6.mail.protection.outlook.com (10.167.254.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 13 Nov 2026 17:33:10 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 13 Nov
 2026 11:33:06 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v6 5/7] crypto: ccp - Allow SNP platform data to be queried after SNP INIT
Date: Fri, 13 Nov 2026 17:31:58 +0000
Message-ID: <d18002ac5818f19302ec411355fdc307ce427984.1794531772.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1794531772.git.prsampat@amd.com>
References: <cover.1794531772.git.prsampat@amd.com>
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
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D6:EE_|SA1PR12MB7104:EE_
X-MS-Office365-Filtering-Correlation-Id: 979079f8-d44f-4147-4c9d-08df41ac304a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|36860700016|82310400026|10067099003|11063799006|56012099006|261021135927099003|261021130227099003|261022115727099003|261022105027099003|261026135527099003|261028144727099003|261026121527099003|261026140227099003|261021133027099003|261022113327099003|261022075727099003|261021121427099003|261026130827099003|261021123027099003|261102123227099003|261102130727099003|261009223027099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	GZlTf03mJmq2pnqqbRUh6fgOcwUvZEH555y4XSMrpK2jz2Av9E7O3B/5y3CUsvH2VkSoYZi9jIRV18aJYvGrJSnIL9DXbx89bX0jZEQQQkC2NaJ/qoaopIEqitu1JN6opN6O0IW3gIIFU4ptadV8LWQjwBPVK4pum/saMsTtuu3h/kUzmaaquMm6JJnrqZINASl/pTBh+RYiI4jt641cyuwSn0peNyJvFSRITunxNjkuj5xCoRsnm9bStc+xShMne+n5Y3FlvacFiSFUjJLVcUApNKqHoFRtycqnkmSSVGKL58NL6t2pjMzYZ1bkXhdnFN8WdlqKXCCWhQ0ZckoYK3pBgnSbMcAxtm4OZybj7CCWEP79BRjpvt3UXLw5Go3Q+98SRc1GpA3H1jDAu3Irl3yuLTVYs2kKx0OsJNysm424e6HY7mwM+qIv4TnDp7/ZcyacbbFKkZkQq+5lFi1VzZ9aUAzLM2UXXOiznAB0KfRytjPy0Y0pmtm0ly5NLUZ1JhIsVuFyfZntiZ/ka3yKOmPePWTO+gLYs/ALjuNpxac1aCKC/HWFE1qih4QtF5A7tIXrLFhktnBhfIAXWZxnUkHx/AzhPNhXybGlyOCZCLzFS7Jf7IsoX0p0TakUWRR5Btid86R6TDn0LLNJQ2yBb1hEBkZ5MIHvnLJju74dZ2LQRUGWJtdac4VSKsEYY4TpA5YfnTXzdCSyxYxD/BF3Ew==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(36860700016)(82310400026)(10067099003)(11063799006)(56012099006)(261021135927099003)(261021130227099003)(261022115727099003)(261022105027099003)(261026135527099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021133027099003)(261022113327099003)(261022075727099003)(261021121427099003)(261026130827099003)(261021123027099003)(261102123227099003)(261102130727099003)(261009223027099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ntqexESWR4jANw2g7f5BrlcO2VYuznOCIOlVagUE6eSuulwbWjc/icAHuTQNTxaKLSGRVN1RH9VXN7M7uh4H1LssTw86ACPaTeNRKiLM7ski0cMl8FESfJ7GpiBbLWV5iTvQSoeyCjk4YUODLVF94QdwT0V1qDrdiPH87CPFpjLmcfx1VK/5lIvZlmEG6DUjfjQ0xicASABocz6ACotYMcjGpeQ1+zclDK7wvu/Piv+dzbzwoM+i7yyQcmL04ecp67xLphoKs2cZE01xTOz7N2Rxf/UzWNOISydh1ogJEzQIpTuNwOxS97qaT6lkiNY03o/dGge9Pyh3zDE6wqL9nn3PA9tfWySFvMQ8mEai8EFli1dXysIVQ+2sFALsRZBUBSf8CKvAaG87d+qCMxyWzXkNxQmrlb9izn5YCxlbkgTp9mVCPM7B7JT+2qHFo/4u
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 17:33:10.9814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 979079f8-d44f-4147-4c9d-08df41ac304a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7104

In preparation for refreshing the cached SNP platform status and feature
information after a successful firmware live update from
DOWNLOAD_FIRMWARE_EX, allow snp_get_platform_data() to be called while
the SNP firmware is in the INIT state.

Once SNP is initialized the firmware requires the output page of both
commands to be firmware-owned. sev->snp_plat_status cannot satisfy that
as it is embedded in struct sev_device, so stage the SNP_PLATFORM_STATUS
output through a dedicated page. Allocate the output pages of both
commands with __snp_alloc_firmware_pages(), which transitions the page
to firmware-owned when SNP is initialized, and release them with
__snp_free_firmware_pages(), which reclaims them before freeing.
__sev_do_snp_platform_status() is not used as it takes sev_cmd_mutex
itself.

Typically this was only ever exercised during initialization. However
DOWNLOAD_FIRMWARE_EX can change that. Live firmware update can race with
IOCTLs such as SEV_FACTORY_RESET which could cause operations performed
on incorrect cached platform states. Avoid this race by holding
sev_cmd_mutex across the whole of sev_get_api_version(), and split its
body out into __sev_get_api_version_locked() for callers that already
hold the mutex.

Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v5..v6:
* Since "crypto: ccp - Make usage of sev_cmd_mutex more granular" is
  merged, __sev_do_snp_platform_status() takes a sev_cmd_mutex itself,
  so calling it from snp_get_platform_data() with the mutex held would
  deadlock. Instead, stage the SNP_PLATFORM_STATUS output through a page
  from __snp_alloc_firmware_pages() and issue the command directly, the
  same way as SNP_FEATURE_INFO.

* Introduce __sev_get_api_version_locked variant to be used when the
  firmware is updated under a lock. - Sashiko

v4..v5:
No change
---
 drivers/crypto/ccp/sev-dev.c | 40 ++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 888d960f68a9..d8a4da1a29d1 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1265,15 +1265,20 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
 	struct page *page;
 	int rc;
 
-	/*
-	 * This function is expected to be called before SNP is
-	 * initialized.
-	 */
-	if (sev->snp_initialized)
-		return -EINVAL;
+	lockdep_assert_held(&sev_cmd_mutex);
+
+	page = __snp_alloc_firmware_pages(GFP_KERNEL, 0, true);
+	if (!page)
+		return -ENOMEM;
+
+	buf.address = __psp_pa(page_address(page));
+	rc = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
+	if (!rc)
+		memcpy(&sev->snp_plat_status, page_address(page),
+		       sizeof(sev->snp_plat_status));
+
+	__snp_free_firmware_pages(page, 0, true);
 
-	buf.address = __psp_pa(&sev->snp_plat_status);
-	rc = sev_do_cmd(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
 	if (rc) {
 		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
 			rc, *error);
@@ -1297,7 +1302,7 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
 	 * command to ensure structure is 8-byte aligned, and does not
 	 * cross a page boundary.
 	 */
-	page = alloc_page(GFP_KERNEL);
+	page = __snp_alloc_firmware_pages(GFP_KERNEL, 0, true);
 	if (!page)
 		return -ENOMEM;
 
@@ -1306,14 +1311,14 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
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
@@ -2115,12 +2120,14 @@ void *psp_copy_user_blob(u64 uaddr, u32 len)
 }
 EXPORT_SYMBOL_GPL(psp_copy_user_blob);
 
-static int sev_get_api_version(void)
+static int __sev_get_api_version_locked(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_status status;
 	int error = 0, ret;
 
+	lockdep_assert_held(&sev_cmd_mutex);
+
 	/*
 	 * Cache SNP platform status and SNP feature information
 	 * if SNP is available.
@@ -2131,7 +2138,7 @@ static int sev_get_api_version(void)
 			return 1;
 	}
 
-	ret = sev_platform_status(&status, &error);
+	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &status, &error);
 	if (ret) {
 		dev_err(sev->dev,
 			"SEV: failed to get status. Error: %#x\n", error);
@@ -2148,6 +2155,13 @@ static int sev_get_api_version(void)
 	return 0;
 }
 
+static int sev_get_api_version(void)
+{
+	guard(mutex)(&sev_cmd_mutex);
+
+	return __sev_get_api_version_locked();
+}
+
 static int sev_get_firmware(struct device *dev,
 			    const struct firmware **firmware)
 {
-- 
2.43.0

