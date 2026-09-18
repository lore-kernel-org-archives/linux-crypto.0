Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012048.outbound.protection.outlook.com [52.101.43.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA8550EC07;
	Fri, 18 Sep 2026 16:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789749749; cv=fail; b=QVj5adGH7+1kVMeXgOrUsQr41GNS4mEs7syxqGdzVB8rs5Dg69zKSwWYbtBp4axTsyU77SEJuPBo7e/7h6RiezL/ThBifQDxaIkbTYU9lU3hqtftQUKMhMZDm4r99uT6vzqbt8xmV9gW/bHfSWjNyDg99ZDZnaFyeuXvF2StEnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789749749; c=relaxed/simple;
	bh=+6STHUGYVKtaTl6IbwFdaameYh3/Y1xs0ASxaJOxvek=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JtAngZ2G6GS4Lcqs2SZSoe9dQ77vjT1brLDDkB3+8JckYmJ30LTpW+RNUZdEcRpdivBzJhyJ2P2wLqgyPQfpWsvPFVuK5cGADdzYaGJI1g51dUX55M4/acDKRmbp0d5QOjZ5FTJsKxjbaI+jrfWaYWbHzKpfzaySBARbifRK12I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vl5DD8Tr; arc=fail smtp.client-ip=52.101.43.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vl5DD8Tr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BIUNlBJzWPPr7YYLfM8kieL49DjG76DnSTHcbVJUycksksEvNZBUOx9Mo4tf84yTF6wNjXILNtCK6TvW46U9beutdNzb2dsIo0En4nLOPk4ifrXrj/AeSOa5HN4FOr6fhPf6IfFaLiRg0AAAzpWLOfk99T0GDcoI8cHAzIvZ3Nl4TK4YRdBaHA9If8zg3TSIObjdNGj1QFq6KaaA+5aSL/+qZfQ1QcHUYrVc+woSe00nMBhWAJEgkBXDMzUsskNyXQG/uKgO4iDpREf9ySrCIF8PubI0qVh+/Ki5cMT6dN/G8EKYk8yoL6c8mbLNxYMfWBc/sgdHsU/uUF6seYmjUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bE7Ge1BjtRa9VzLR01DX+qnlhEI8i700n/5uL3bLjrE=;
 b=cvBQP+0GvqTm0jSpKQNBXSm3GPF6kc/2PeoYFq/PZb+bTbyjGBDjFRTjPOjgL4nfdpINgl/Ie2OFVs/ZNq5gfTJ7xjVhsokJDZOt1tOk/9aXHr5PPK1he10ZWPXCaAvy+HW/ZBBjkq2VKCqosVr05Gaio6ygWreJFOSv5m8w3fVdlkBbzz2iVvZ3Cba1CYTxFx7AqZ8CK7sPQetJ5sFXb+F8w5HyheG8V3V3U6QjXwfBrsNrnepplWdy0T46VnIZHZi5p6VDjvyvE1mq7D4XabP4V4ZXaOYEPgYVGniNwF0ymcoo6noyG3SPqgp6I2Zx3eOkowBs+oklzcJ2cJINxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bE7Ge1BjtRa9VzLR01DX+qnlhEI8i700n/5uL3bLjrE=;
 b=vl5DD8Tr6y5XnnI7Ysh5NBY3vD/cImYmEqd0lD/Bapiy6x1dq02fiEP204kSsIWJHp1gJpBDTKEzUb12YNPr7H3xYybQbGOA67nxEe8pqmOC/XeFIFbT7NXIIXh8TDH1d503D81Ylk0Dl7CzvBORXhocYUDXJYAfs/LfKsgztlk=
Received: from SJ0PR13CA0139.namprd13.prod.outlook.com (2603:10b6:a03:2c6::24)
 by CY8PR12MB7124.namprd12.prod.outlook.com (2603:10b6:930:5f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 16:42:13 +0000
Received: from SJ1PEPF00001CDD.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::8a) by SJ0PR13CA0139.outlook.office365.com
 (2603:10b6:a03:2c6::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.9 via Frontend Transport; Fri, 18
 Sep 2026 16:42:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDD.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 16:42:13 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 18 Sep
 2026 11:42:12 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v2 5/7] crypto: ccp - Allow SNP platform data to be queried after SNP INIT
Date: Fri, 18 Sep 2026 16:40:59 +0000
Message-ID: <0f67392979b8db85aacd62fe547d9e2937a93393.1789749016.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789749016.git.prsampat@amd.com>
References: <cover.1789749016.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|CY8PR12MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: 096bd5a2-c609-4210-7a3c-08df15a3caee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700016|23010399003|1800799024|10067099003|11063799006|56012099006|3023799007|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8kQm7TDUjbtTClW4SMFANvieSBYMuA57wO14LZsJOwPO5hrRL5C3PIWVh9rPxe74CC0IoMmtZW9fhraE6T9CUA1Z5YIph3MotG9G+k6UpN3qyvk03bdkuF8qHe+BlZPHLTSfg0UEb1bpMPhEnUEtKXHGLlFMlfL+1HBus6eJ+AW4dJk6zFpsPPDRs1eOI/P+sIqVlz9RMkvKu7zn52TCpEU88CBfIRE4tF1Egifb9HGuk3Fnxf/O7kC9a5kaKuJJj4uD5SY28NSeebqzPpht1fZEDjuwmnaZjxLPo4LuSVtttjsZJH48Ss8ewSELD8zTbtWoQuSP8widk0e2YbRR24Cts/0TSPc4Fh6Wh7wpCxBmPpyzePxDu9XErdG70p1FmMoXy+sA2skbu5E5VASGO1bVOHoM6ZbMn0V+DjIB6EhioY8ngbJhg1BJ4RhDqMxmhsE4BClZC9H0MRg4SB3cgnWwlV9uiHk1Y9fgFqIQbj9yTDjt7LUoD08bKv6u1Uh4YJXLLvC5Rbv0QB4i9PVdnHBfLlBOQAQq8dtAFIHVZ8ob7tiaOKhFKliGpqweVPA2bygSaQB6O0xRCkeKacIa4OC5mk+8TDXmrAv693djzQNHvPbLhEQPmoQ0y1wEDr2IzOv80UJRRkVcSraC072V/O3fJ62X02qDDbNQUmL2k0wACysCFLdkW7k/OLKDAs/RZTtpDTIQ5R6AV146FH/NVg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700016)(23010399003)(1800799024)(10067099003)(11063799006)(56012099006)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	85iA2rXnSmXDOZNcroYT3zba0mGbGbBDIjel6BqKsOsaxVHTc0TYdvvBc3n1+Na+PS29YHjTC0werIuP+e9DU+tVOGV/qxzJcEuQykSLGyQL5NcpA+MGUQct0OoIZaPWnzmifSU8u8sEYcYQVgfOdI4/QZMlcJ6IVlvUIT/X/Jxbsu+1f53ggwnXgceTwR9c893rQRF66XeKfYS/qTBjIXwSKM1QKKpo6Z3H7/6EAIJq/i30aO6t0pWH3MclsdprMy7hDDTFVl25j3v+dm3OLxfAmpdcgJPpQzj6HNLlGurYMLmz3GOcOV7t+u6OUvE9ykvAcdlWNt/8vxtRxqtXJ2gMJi7WC4zMc7BMiyeGm5NJpQI7o28wXHN/vNQbNxVGhsN71rPrVTIGYxbVuHj57eDyk+uzhKtCVG7eRbIEcfY0QPipAv3Cswpsm1lfz/wd
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 16:42:13.7670
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 096bd5a2-c609-4210-7a3c-08df15a3caee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7124

In preparation for refreshing the cached SNP platform status and feature
information after a successful firmware live update from
DOWNLOAD_FIRMWARE_EX, allow snp_get_platform_data() to be called while
the SNP firmware is in the INIT state.

Once SNP is initialized the firmware requires the output page of both
commands to be firmware-owned. sev->snp_plat_status cannot satisfy that
as it is embedded in struct sev_device, so use
__sev_do_snp_platform_status(), which stages the output through a
dedicated page, and allocate the SNP_FEATURE_INFO output page with
snp_alloc_firmware_page(), which transitions the page to firmware-owned
when SNP is initialized. snp_free_firmware_page() reclaims it once the
feature information has been copied out.

Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v1..v2:
Use snp_[alloc|free]_firmware_page() to transition pages to and from
firmware-owned state - Tom
---
 drivers/crypto/ccp/sev-dev.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 1ed9e61a95cc..3704f52bd08d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -131,6 +131,8 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
 
 static int snp_shutdown_on_panic(struct notifier_block *nb,
 				 unsigned long reason, void *arg);
+static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
+					int *error);
 
 static struct notifier_block snp_panic_notifier = {
 	.notifier_call = snp_shutdown_on_panic,
@@ -1261,19 +1263,11 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
 {
 	struct sev_data_snp_feature_info snp_feat_info;
 	struct snp_feature_info *feat_info;
-	struct sev_data_snp_addr buf;
-	struct page *page;
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
@@ -1297,11 +1291,10 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
 	 * command to ensure structure is 8-byte aligned, and does not
 	 * cross a page boundary.
 	 */
-	page = alloc_page(GFP_KERNEL);
-	if (!page)
+	feat_info = snp_alloc_firmware_page(GFP_KERNEL);
+	if (!feat_info)
 		return -ENOMEM;
 
-	feat_info = page_address(page);
 	snp_feat_info.length = sizeof(snp_feat_info);
 	snp_feat_info.ecx_in = 0;
 	snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
@@ -1313,7 +1306,7 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
 		dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
 			rc, *error);
 
-	__free_page(page);
+	snp_free_firmware_page(feat_info);
 
 	return rc;
 }
-- 
2.43.0

