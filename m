Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E8C1D2F71;
	Wed, 14 Aug 2024 20:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668202; cv=fail; b=s4mL6mHGEk2Q0ZJjhBgv0PePqXubbsf0vuvLtklzcfJfGrOaqHGqNgr6bqYXAuE6WlJA2kHYqh6y8KJsEXS7NaYCmkHMJ8J+Dzvy0oXO+24iT5nTgrEKlo6iSThqLvVMvfwrBIwIsfqn23v0HAtYNbfOO13mXABu/DiXI+9maO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668202; c=relaxed/simple;
	bh=wto2bESn8z7Divh1qrLKE8vHGkHle59z3HcODp7GYbc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NpeiuGyFrmdVNZKojnapWuM1lgGcuikxdeuaaSOuvXrIMS3cx4M6IgcDOsgYH4J8RYwwryqwe6fiMkRpgIeNaARAoJjUDU1keRroDbFbAaHe39SMsqBU0W2MKO23eOr6zeOM7ZdSOUULLO9e5BOVkVpV24LZaloLtostGYtcIgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KyXP45/6; arc=fail smtp.client-ip=40.107.236.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KyXP45/6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UiYWaHvlJRRVboYc7byGcwxnLk3D17JcVDqYKKxn4vb876cyQuz5tYOyXwuu1c4IQB3uAaKZUv2KD4ptjvLZrQVsF3x5qXlQg34hWU2P4RGJjxOnK2FiejMu88JCgkEU9A5leFLQM9uiaQlBXfqABwOgyBoNjvEWwM3R+MRb98g7yVrh7Flkkk/eii/eH/txT5ZTqkE4R1NJwb7ahf+jhkleG4vQHEmGirazKvU0sN73m3BZNkenMZMWNJFNL/RlF/iq2k/LEFqFNj15brNC1K/HrOfujZdNGwHkHuVT4zje3c4l6pyCTWPGrVdr/5+3gBakIlizIm87AnfFVUduDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=magN7AVVzHhsPvHzIQUHp4dRtyyY3nSiiXINbpEf/TI=;
 b=cjpZ9/kQw0ICzjpwLU2LXe3AR1bL+OgJVEm0B94hJIewXrTg/C2HJwEkDWYbLiJHAJJ5d01RcWY48ZzJBLt9V0NDwXhzT29wm6DREy3Fu00B1AY882CIllmfRDq8vFEmctFDA+DeeEAeGFdrPuq6hhQxChdMketAGlSAAZ4zRRibfGKTrjQOm6FpEexKAWztqmlaSiHWx5n+B/baqyO2k+NH0els8CsvSF8WR5EDE2EVzj+yDHb/zZkw27DhgBUwOZa4WgvGXffCvWnRyRZGjQ6dHyOQjYz2l06XlaKTIgwjb3/zlBMFA2o/LCBr8WCPk811UMCdlJi/vTgbKvO8iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=magN7AVVzHhsPvHzIQUHp4dRtyyY3nSiiXINbpEf/TI=;
 b=KyXP45/6/f05J7oGXUa1USY46DONAJbK1gtujRKDdvwxAbauTTd9y0guiPxhSGCUthXjAgnYBfcmJsA5FmLWKDlbihW1ksnVNddDdMbpF23yAtjllQiLTOs4GpxxYNQPLQ/CdbKKjigY0SAWuSdCu8pYcSwdFqE/PZxSGd359hM=
Received: from BY5PR20CA0029.namprd20.prod.outlook.com (2603:10b6:a03:1f4::42)
 by CYYPR12MB8853.namprd12.prod.outlook.com (2603:10b6:930:cb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Wed, 14 Aug
 2024 20:43:14 +0000
Received: from MWH0EPF000971E9.namprd02.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::f5) by BY5PR20CA0029.outlook.office365.com
 (2603:10b6:a03:1f4::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20 via Frontend
 Transport; Wed, 14 Aug 2024 20:43:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E9.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Wed, 14 Aug 2024 20:43:14 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 14 Aug
 2024 15:43:12 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, David Miller
	<davem@davemloft.net>, John Allen <john.allen@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>
Subject: [PATCH] crypto: ccp: Add additional information about an SEV firmware upgrade
Date: Wed, 14 Aug 2024 15:42:40 -0500
Message-ID: <bba259429fc14c4cac9ee4995dfb05d82065b67b.1723668160.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.43.2
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E9:EE_|CYYPR12MB8853:EE_
X-MS-Office365-Filtering-Correlation-Id: acb30720-dadf-4eb4-58f1-08dcbca1b809
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nGnvybVCSm7osDRukkiC5pSVpZcDKMGtGureb1yVVsisVGiYcLXVgNLHxF3T?=
 =?us-ascii?Q?XLq7oHK2jZkb3UOU7+eKAJyAr3LshEU/Xm5IO2icNlBAtOfYwDIKYCjJN2q4?=
 =?us-ascii?Q?YjRgwNhFV4dRMo7134tMg7vTUkXlqi59Q5yVmYtFAlVFtjdy1YlonQ1K5/b9?=
 =?us-ascii?Q?An+64ekLW6TBybmo4Ac0hnIXE41GgAvpa8QnXX3F4AQpo+YqT2oM1zh4BDq1?=
 =?us-ascii?Q?lHTjfPLdgQbyHEFJ1TykUnsv7D1HEOIHEnH+5g2xw2vWG7Xuj5foGdi1V+q6?=
 =?us-ascii?Q?K3LLbNa4VDcuPN/d1EgJl6eMs6VC7IA7KK3OWC03xxZYX8X5oys2qJqnfipP?=
 =?us-ascii?Q?tp2vjOB6/nxkYilMYqtBnXmWu2fKDItPcq8APTaitXCU7Ktarzwc5Y2zU/Kb?=
 =?us-ascii?Q?CzsrNch8qZKvaNKgd20JO3kx5SjPu+8SxW4UPR6Q3CUzTYHSi2bDaLUnB1pE?=
 =?us-ascii?Q?xrbmwJfbA33u4PrL2k2xmdr0192gU8WOhmd86ZVT7fWH/Z9xpA+rq/cC0Z/2?=
 =?us-ascii?Q?BxAZIf5Nl13iTXvPJfWaZ1+rnOxM/Orm2yrwbNtWt1tJkySUgrTjEDy8jajo?=
 =?us-ascii?Q?5SasxiKQOrb3+6SWL9okcWf0PKOWXBfBmkeYXGyOZJmGb66QlBfGxbBtyrrq?=
 =?us-ascii?Q?fAurFGG+EElsqlm2CmvB8zv63WJxmOj5VUrQmEzhwKUZuROeJRSfJ0NeH9Bc?=
 =?us-ascii?Q?HtyFmHw7wm5sTODC8uAG/hzdTSuUd2t2C6T55vzkJCicSZDchVTxAs7lrIx5?=
 =?us-ascii?Q?kncOEQGIdklCSlv7TDgZsSefGuKBcH0m4TF6davGlJ5JpAOOqjS3jWzp/95Q?=
 =?us-ascii?Q?49yRzRTneONnIdTFKM832rQowdzp7XdmnoxA+YYEVsqSzorsUqplasf5W5UM?=
 =?us-ascii?Q?zRs0eWj96SvZuy9Bdnuhkl0DiOLAdxKEFfBML4BI3x/QfmYbKi/soitk4c9J?=
 =?us-ascii?Q?kWe+OEbCZmT9WS93ebSP1b9UVKG/8QUkjMQEzY67Mnw3j3db0ZGSpfVbfTz/?=
 =?us-ascii?Q?u0KpItTsNEFGtSfB782lna9cE5uSZKIlygjNyd1dUftpB2qu0FGLSgCooVZv?=
 =?us-ascii?Q?naoWw8+fmDMDSWA53DQQBAET26ThR3BO2AbD4dDDx9gQDQ6J63/y/vM63/64?=
 =?us-ascii?Q?10hzX1/7ai9GdOcfljKnVE4hWhv+yse9PYUxrXgOzhDUS3fk5BI8dXIO2snP?=
 =?us-ascii?Q?l0hzcJ2HpXHHF524zJm1/W9o5tSXdDSwDPYRQYdSkUZO55YQH7igaXC2Ygxr?=
 =?us-ascii?Q?FnwLlDXIHHhfjJ9ZUvb2BUUqHnAZAUqrMqufyItlycsJWJZ/VP5jrxxDBjGP?=
 =?us-ascii?Q?TXvix084bZ57FtuDLq2L3OfJnq/JOMUE2nESUgXzUXcRWr4vO1DEZFyO//9E?=
 =?us-ascii?Q?mwgVAkAZyYqMRdpGB+N3ZwzPNSOToASfEe+P5GkyJJM6ijblz6NSG0766jqx?=
 =?us-ascii?Q?lPkXlJ/1GCnI5HwJ6vrUhwoLygb9+3KZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 20:43:14.1269
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acb30720-dadf-4eb4-58f1-08dcbca1b809
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8853

Print additional information, in the form of the old and new versions of
the SEV firmware, so that it can be seen what the base firmware was before
the upgrade.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9810edbb272d..3b89f23afcd7 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1629,8 +1629,6 @@ static int sev_update_firmware(struct device *dev)
 
 	if (ret)
 		dev_dbg(dev, "Failed to update SEV firmware: %#x\n", error);
-	else
-		dev_info(dev, "SEV firmware update successful\n");
 
 	__free_pages(p, order);
 
@@ -2382,6 +2380,7 @@ void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_platform_init_args args = {0};
+	u8 api_major, api_minor, build;
 	int rc;
 
 	if (!sev)
@@ -2392,9 +2391,19 @@ void sev_pci_init(void)
 	if (sev_get_api_version())
 		goto err;
 
+	api_major = sev->api_major;
+	api_minor = sev->api_minor;
+	build     = sev->build;
+
 	if (sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
 
+	if (api_major != sev->api_major || api_minor != sev->api_minor ||
+	    build != sev->build)
+		dev_info(sev->dev, "SEV firmware updated from %d.%d.%d to %d.%d.%d\n",
+			 api_major, api_minor, build,
+			 sev->api_major, sev->api_minor, sev->build);
+
 	/* Initialize the platform */
 	args.probe = true;
 	rc = sev_platform_init(&args);
-- 
2.43.2

