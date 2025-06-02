Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DC12C324E;
	Mon,  2 Jun 2025 19:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748891438; cv=fail; b=CTO54GD48gWMyDAmPq6yuSstYhWtivVgfrR7BYMlm/e9euO5EOio8PuChxBA6P4+PE1HCbs4h2Rb8LNDGcEV/zjhWAKAcd4zgKk4ZEgbuouOsvcYJl2ir/AjsWWv1dyVwkzxz+V8dgz9ArIn4ibdHmFl0uDdRZEgmnlU+bnZOA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748891438; c=relaxed/simple;
	bh=J737KMe7VHwa/VblqQNBxzMR5HLm2E85sbZ6m2fuhAM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CCgBkipu6gIWlAIlReEWHU67ouCRpi56jfsEPoA3hGaLcvmc3TTV0IdTx1yTthVuHC0xzolZ6wbD1DKkIJzU0/IsJug0kL0di0dJIri+GnY4rjEIW4SYH2R1SPxKqxi2SNVzD13uKQVU6SUFiko3zB61/blP0ODUSxeXZyBiJF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L9ZDfo4X; arc=fail smtp.client-ip=40.107.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L9ZDfo4X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x5j1ciBB/JwZmINgDRISPPtjc51HrOtpX5uIN1BmDqmlddekBMcyB7xC86g6jsiLDXtrTrLKYC+uzPidCPebSsM3lkT8u+/CjM4co9l1V+VdDxxRkOQ+zeGVZ3YI7kzDIJ+31V6z0wXiyi2Dj/r9B/z7DTAbkcqYTu3dvNgoxCWD0cnv1/O7GA5RXzr2FXhWRFMBqz261AHkAhYr8zQvPyNkFPtihV7TLtmVDlnbea7l/mSkWernlotWkwrUa6+RWO32HZAPaLMajHlhg0kbTY1K3qgP4JEJL/49s+EFD5f8iwIuIwxf6lyzGPv9p3po9gENJUIQ9vfu3pfSj6Q/rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ry8B05YzTbQ7wYg4kjYYao/0gcbkPUWCu4PvY+OIHbM=;
 b=Jkk89MhUVi5HSvno/ZZAT63o23gE1bvBhrpuOQ58iOAE1u6tHYofPhFCxArglbyTU2mZkG+L8+slAVpLsYjY7T+3CrkGdNF+YeRs4pbNOY/WrANUk0hhmQP6urea0kseJ4h6D4TGK/ZnIVy3lqlAKTSoeEKa6d/hi+OVnuL7eFx/BYKTZ21sh3tFR9MoSBRhcDQeLBq+AQJJGw3SlsGIFPrJqaqdPCJcaiiSceK35+/3SKlTUmeUzhikzdCqcoBOc4UW4Hs+OqHAVPsx+L+TJUoMiBw99E+QTYDJmwMPln4nNr7SZg5NxiZKVp68kBKfag0WtbtUdwFIVSGwuz/V1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ry8B05YzTbQ7wYg4kjYYao/0gcbkPUWCu4PvY+OIHbM=;
 b=L9ZDfo4XgEkkoW5shzh0hxgzODQ9D2f2ApsjtlW3o0ks2c/4F47i0enhhR8F9QWtXWoxbIUgn2+QA6qTjrEy0FnU/ujf9A7kC6WyAmUv5TnPH1i4G1PvQ7/WvKrNgFcTyEilDqYKPTciVbTE9678r/uebef+/GA+Q6xqEpSUSRw=
Received: from CH0PR04CA0018.namprd04.prod.outlook.com (2603:10b6:610:76::23)
 by PH0PR12MB8798.namprd12.prod.outlook.com (2603:10b6:510:28d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 2 Jun
 2025 19:10:33 +0000
Received: from CH1PEPF0000AD76.namprd04.prod.outlook.com
 (2603:10b6:610:76:cafe::4a) by CH0PR04CA0018.outlook.office365.com
 (2603:10b6:610:76::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.29 via Frontend Transport; Mon,
 2 Jun 2025 19:10:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD76.mail.protection.outlook.com (10.167.244.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8792.29 via Frontend Transport; Mon, 2 Jun 2025 19:10:31 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 2 Jun
 2025 14:10:29 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <aik@amd.com>, <dionnaglaze@google.com>, <michael.roth@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: ccp: Fix SNP panic notifier unregistration
Date: Mon, 2 Jun 2025 19:10:17 +0000
Message-ID: <20250602191017.60936-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD76:EE_|PH0PR12MB8798:EE_
X-MS-Office365-Filtering-Correlation-Id: 100d489f-0363-4666-7440-08dda2092542
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yPN9rsqihc9ibDFLOnGWosaJItW9AAIn2VO7iiEsW6az8ZSHZ6yeUxtwSYST?=
 =?us-ascii?Q?Xb45vFtWfxIuTVgJzhAlc7hd8J8vHLUtA5jMyQ71AInZlmNIiM91y1smSvUe?=
 =?us-ascii?Q?O1etLILkv7UHC/kw3GqMYq9aGMGOj0bpwmMNbQMLXDGL91mXyoVfFkvOh8fp?=
 =?us-ascii?Q?8a54qSo2pt1Dry7YIUqfeecm9gJ1jRMM3cuHI9d4V7ivsPW17U0feigQL6yo?=
 =?us-ascii?Q?vlxKx20r5uv/YFp7OiMRN8TVWwyojTd/D0/FI+T85G/RsQ/labhdaV2rsg6a?=
 =?us-ascii?Q?ompYnyCgO3TdFn8Yza7MnnIPSRGIbAeSFzsVjdyflrGuwtUVxQphNGVgPKJy?=
 =?us-ascii?Q?V14fKxmp2ihHEfWvTIf/mKkFZIAIP6N/+cpVJ7/qNcxFDyUu9xWUR+JKQG1W?=
 =?us-ascii?Q?39o7c1pkY6CfK5n5/zsw6LnrKp8zR8QP4k37djwq1TBB0WNdqTKq8t9xFSW+?=
 =?us-ascii?Q?0RkadVqJxuO7yQIWY7zx06q+AHqDRkwykZsUyt/V2QXHVozMVSrpbbmgqYhH?=
 =?us-ascii?Q?Sso7Ugo1THHVZJX0kM5Y0lQwnpwYJ8a6ipCR4onkZZG3Mu5drGwFlWucqAa9?=
 =?us-ascii?Q?DC6HIn+qS+wPyWZd/M90aDhp7Qnq0KDMNpX5X8QHIxTVyWo9nfwz4K3BuGIv?=
 =?us-ascii?Q?EyAAa4N1GGMIt1WjeNYSSfnWwvYTm175jlxPGTbNIoYp+gXd0aoX5KFPoFA2?=
 =?us-ascii?Q?OLGRftY27yaSWbDk+60UhZnV/DEVD4qSZI/p0F8NxXkeceIN0rWycM23Kc4l?=
 =?us-ascii?Q?zu/Rsf8NwhsvR2/vIBWC7gjr9zVe8z+BrrzmWhJmIAE7DlgCOw+WRACDdLto?=
 =?us-ascii?Q?x2R5Jc/1Jt0N7QSoYQdRQFGX1aS+1GiVLsG1f7sH1OhIn2CFWKOwWJROInGl?=
 =?us-ascii?Q?5x6OXOe7wApgK1/i1PmB8fpPQRQLDKaEzkMGeyMNeRdCVkfd5VjjBMw5n45v?=
 =?us-ascii?Q?yiMmv4ct5QtdUECq2aCzjXh0iTIKWa0I83DnY1dnKJmVk6zINVwq/8r30Mmx?=
 =?us-ascii?Q?369ESIXfc1AQe/NCcnXdGcb7o8hU8aPRdw/ME2HtrkGAODGIDb8O4ywNZj1D?=
 =?us-ascii?Q?Pz2iIF+khzwi9EYj1axq+2/iyPn7kEGYlg38MahRxwflLrg36dTPBJNNaKI/?=
 =?us-ascii?Q?1zdaT/0nNgRhvB3qz4D3RXE7kWubX0ozc7JfXNO9riFPMajnXo54m19UpuAF?=
 =?us-ascii?Q?UaCZMfT7hWRtwx4UqL8HyVtnk6rkSnkFGxHbablXErJITiYDcdQJlZTIbhK6?=
 =?us-ascii?Q?SImGhjXBcwzA9WHf32ZVtr0Aw5BMLKiz6CfickKz9sME8vKxVRfSlKCoZvbJ?=
 =?us-ascii?Q?ZeTmQseFe3XGaXmpvyih68OusrtxL5Fs0RC2bdWOOYfiauX07i7JwLHuori7?=
 =?us-ascii?Q?nmSGrTyNL8gsqjBaSTuBOCLWXCWLuLwNmhtAuSKalOgzb5hOeDLYRDFDmbAt?=
 =?us-ascii?Q?hy995+lJD78QS4Dn/C41zaduwkhuvtH8sW10LNTSJY3vwJfWIWwShJlk04j+?=
 =?us-ascii?Q?60tS/uXXcU0fu3pnhTUvrA4D71NCTh5Ims/p?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 19:10:31.9448
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 100d489f-0363-4666-7440-08dda2092542
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD76.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8798

From: Ashish Kalra <ashish.kalra@amd.com>

Panic notifiers are invoked with RCU read lock held and when the
SNP panic notifier tries to unregister itself from the panic
notifier callback itself it causes a deadlock as notifier
unregistration does RCU synchronization.

Fix SNP panic notifier to unregister itself during module unload
if SNP is initialized.

Fixes: 19860c3274fb ("crypto: ccp - Register SNP panic notifier only if SNP is enabled")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8fb94c5f006a..942d93da1136 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1787,9 +1787,6 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
-
 	/* Reset TMR size back to default */
 	sev_es_tmr_size = SEV_TMR_SIZE;
 
@@ -2562,4 +2559,8 @@ void sev_pci_exit(void)
 		return;
 
 	sev_firmware_shutdown(sev);
+
+	if (sev->snp_initialized)
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+						 &snp_panic_notifier);
 }
-- 
2.34.1

