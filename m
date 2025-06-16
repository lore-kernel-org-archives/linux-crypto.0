Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2059.outbound.protection.outlook.com [40.107.101.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED482CA6;
	Mon, 16 Jun 2025 21:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750110210; cv=fail; b=b2fB99R4OVbOd0IEAf15wtHcl9eA0yRM2KoQdqSFb1hC+yndgnJQLvlqewi05JujWHtZ/qUMfLHPJV12aLqBV+BsU6t1UcCWXKRWHstVtmm1qAM/KJ9JfZfGz7lvEeF/K0CJMKrINztAF+tVvcDZs1G3mx93pFl36n4rv0sUJMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750110210; c=relaxed/simple;
	bh=L4D7YjtZ6TgrkmNNO83VMu/O27wQpLdXhOtGQhoR0wY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=L09tHFnXK/moBIAOMONQQG8CBrqwf79ZaXucdVocZ8ld+dR+A6Ad8GLkhOYBzFYJAKX4C5awt8Po0SDXVNGL7E1E/I3kuxG/1ed45tQbYI+ViepJL004Ynk3L/1EvIjOPCH10TFuA3loguKJGCSXWyqS1KkXb6YcbWOa86OjWSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SMzQBUUb; arc=fail smtp.client-ip=40.107.101.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SMzQBUUb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oc0bIIwCLImBXj+cAO338BRuwx4wvu5JENll9BrnQcgeLTMvkmpDH0rTWtQ6nfijcQo3uoDUNeqBz/hdZajqqgjZx/NaCr4zYW4L+gP8ca8bA/Nv3Ww5m81cH2JEbd32rGhui0n4Nt4RhKT6GOKFfH8jdtTlAS2Ifu6HzzOKe775jdvl8npcjGa47cYbWf+uEqXq/5wi4UwTlHSSteOQtoZPSmutL7wWuHRVCAtjdxcxZVbJfWyNRXTPyKvPPH5SNjlze0R5ixr8WaQb+DE+mMwLckkCk11PwY1gsiCI2y/3hd9MSkS0VgDDojoGq44Uk3KLlpAvY37MsBwDcwNL9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFYJs2mMa3EHH0kiif/CulCnrYdO8RjV9SYfvWvzHaQ=;
 b=npPOZywgolUJZM1Dk0jMpYpQfTdEU6j62L9BbgTIuKnMNRj+sdD/W3hTQf+Db+zRPJbd7yT84P5rWZkvCsoc7Iw0LnyXt0TjniDdVLx4vSsxq1obFTfgJYOiwHAO1JDxrsBTdS71iajoVxXzJTWE1J5Xxv1jCOhuPgNy2c7+9LEA0wCe7414QD0MBCvllyI7em5EIbcMrYMIrGH7jOa5gjnA0d5Yq8QmTyxn9XhQ6i2YBRSfmby/2yT6JuDRZTb5a/T056Yu6JVjEOde1/K23zp56TA/Zu1IkyOa3CSm/MeDFbww914+zmZ+8ieYxndPEcWO0JPlIdOmn8eekWTnhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFYJs2mMa3EHH0kiif/CulCnrYdO8RjV9SYfvWvzHaQ=;
 b=SMzQBUUb3she7V5UfRPVLpkGTWSQbsSUIGZBXtyyHxEwEy3Ie4vsJGZBEeckQ/PQSyPPi53LskkgGYWKsDj3bdXcf1qz8VhYb2JKVSy68y163bQ8Gu0/SFjoDUWqf2hn0L/L1ZUXecM8cGYgVyXqu7L9labAxldXMgC/PtPCoL0=
Received: from MW4PR02CA0028.namprd02.prod.outlook.com (2603:10b6:303:16d::7)
 by SA1PR12MB6994.namprd12.prod.outlook.com (2603:10b6:806:24d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Mon, 16 Jun
 2025 21:43:26 +0000
Received: from SJ1PEPF00002327.namprd03.prod.outlook.com
 (2603:10b6:303:16d:cafe::a6) by MW4PR02CA0028.outlook.office365.com
 (2603:10b6:303:16d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.22 via Frontend Transport; Mon,
 16 Jun 2025 21:43:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002327.mail.protection.outlook.com (10.167.242.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Mon, 16 Jun 2025 21:43:25 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 16 Jun
 2025 16:43:24 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <aik@amd.com>, <dionnaglaze@google.com>, <michael.roth@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: [PATCH v3] crypto: ccp: Fix SNP panic notifier unregistration
Date: Mon, 16 Jun 2025 21:43:14 +0000
Message-ID: <20250616214314.68518-1-Ashish.Kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002327:EE_|SA1PR12MB6994:EE_
X-MS-Office365-Filtering-Correlation-Id: 0448a32d-cc82-46dc-c99b-08ddad1ed2ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z38isYzb+QZmPgPUGFutw3p3NTcaldcvNw3p0lGbEtUvGHfKVcK+r9iF5BY6?=
 =?us-ascii?Q?jhH+lnd7ESqHCjksJmeyo/bd43OypQl6BVQFc9HunqkoKnmlTBjElb4VguX2?=
 =?us-ascii?Q?DeW5BBRwa2fZcVDI6fHpXCjSIsJ/e11oCpQWrQJu9+779/R64l07tJEl0Lwl?=
 =?us-ascii?Q?KLnJ2Fp5yKfaY8q4IM2wC0X3azueCwZKKDPW1VZovTfhZRfSUOl3a9kmsZAA?=
 =?us-ascii?Q?3+uXkb1HuO5l1juLa22YR51CJCqODO33Ud5TQCRNfK7XAfbxnS1hg1Lu3Gxk?=
 =?us-ascii?Q?71cunYqTkYJKZD1e4FsocsXc5T4C+N5FiRdC2Dvu8hpKJTWD/dC1Nso64rFz?=
 =?us-ascii?Q?q9586wQW7ubzRyDQffMds74IYVAzOEkNftiHoIz1YYQgc2l7aOfD/O0g1whz?=
 =?us-ascii?Q?Bx23G10ekq1+2i73FiYgL3KZmMf931n2Qig0ORR2+1q9Yu0T1jYYM8CpRACx?=
 =?us-ascii?Q?uMK6OH6SXtWfXOrF6++5PAOpOMODSlhdPmUvbyJqnvYLhq712L5ABMifmxsE?=
 =?us-ascii?Q?6OE+PviNrccvmo0Y1fEu0N0oxnbV6s71rB/U2a9/rGIKstOSD9LkIwPTo/Z6?=
 =?us-ascii?Q?kfO3p0NUrrlTzmpKmIJzj9Zy/cneONFcqWrWpok4rl5/gswKz7WGYuMFuUlh?=
 =?us-ascii?Q?YDEzknYTgxa/DLCeGJFcrThHC+vHG0nr/rv9Eo88v3FWEPM0Jpx1iVJV6q5+?=
 =?us-ascii?Q?t3AXH76kKBd2XeBbEnKjwHzUQBKR9Ec7WveA4mEQhjjKPrK4br5wA15T+hx+?=
 =?us-ascii?Q?vMRtENBaM0ZRg0r+NPIJtocG5hYWBw3jAOZAKtRwM9W/cmFaWQ99MK9jxc4k?=
 =?us-ascii?Q?UKHQMuExV+53ZtBavX1UNrUVJwGE3GhznkiFwIbOwVHCgoWGRDf8N6rtipl1?=
 =?us-ascii?Q?Vzn8Op4yc7E2TQVQ27fBzJlmw+w1HYVz3B6Z/ZpzzbVTrw3NtPIiZRpZfdK4?=
 =?us-ascii?Q?BSh06DRxY+9DWnpdpwxLVLcdqenN/g24ZGor0LucflvHfgti05Q2PlV71LvW?=
 =?us-ascii?Q?7TMexVZJWMvq+BwSg+zOYqikY876ztsK9K2+VKtw6Cljb4G4iWHZUeb9OweP?=
 =?us-ascii?Q?Z/jNf+fdgskt6F65s1tY9JuqmrKucRwFu6pZhHyIn99AFT600+04c3+8qCXk?=
 =?us-ascii?Q?gWlIP0d5GD+tsKgiX0tlMOZaqInXLa/0N8B5GXCayq3hqtlopy0Uuik5xnfq?=
 =?us-ascii?Q?tya4wdLZow+Cvbm/t3IuRwPnvIm4YIr5p9Hhj4poGHlHhZX1ZCnU7YdIWCGb?=
 =?us-ascii?Q?cg8tl8WFpB5zMqwy8wrQPNFi5TiuvtJgTbmbuvmUw1zIu5EfbxnejWpXxxa6?=
 =?us-ascii?Q?XWBFf8dzQCunIZBCoE5O1bBThe4Qp7LoeFAgF3f9zh9uNwIbPqcpjXcVXnHN?=
 =?us-ascii?Q?fQYGOP3Yaa/6g2CKgKz3EHH90J0nlVaOeCrv6t0wCRAq8/LgkGA24FVUmUQ3?=
 =?us-ascii?Q?KI6/vOUddkmmlv4GojcQPT2KjbIysw0l5DOBCznxDCFJ5l2FNq63s3KnXyI4?=
 =?us-ascii?Q?ZpKcMayh93NG7h6HSZghY3dcdINLkdeLc9nW?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 21:43:25.4382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0448a32d-cc82-46dc-c99b-08ddad1ed2ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002327.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6994

From: Ashish Kalra <ashish.kalra@amd.com>

Panic notifiers are invoked with RCU read lock held and when the
SNP panic notifier tries to unregister itself from the panic
notifier callback itself it causes a deadlock as notifier
unregistration does RCU synchronization.

Code flow for SNP panic notifier:
snp_shutdown_on_panic() ->
__sev_firmware_shutdown() ->
__sev_snp_shutdown_locked() ->
atomic_notifier_chain_unregister(.., &snp_panic_notifier)

Fix SNP panic notifier to unregister itself during SNP shutdown
only if panic is not in progress.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Fixes: 19860c3274fb ("crypto: ccp - Register SNP panic notifier only if SNP is enabled")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8fb94c5f006a..17edc6bf5622 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1787,8 +1787,14 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
+	/*
+	 * __sev_snp_shutdown_locked() deadlocks when it tries to unregister
+	 * itself during panic as the panic notifier is called with RCU read
+	 * lock held and notifier unregistration does RCU synchronization.
+	 */
+	if (!panic)
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+						 &snp_panic_notifier);
 
 	/* Reset TMR size back to default */
 	sev_es_tmr_size = SEV_TMR_SIZE;
-- 
2.34.1

