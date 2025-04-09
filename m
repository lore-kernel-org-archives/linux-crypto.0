Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFDE143748;
	Wed,  9 Apr 2025 19:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744227289; cv=fail; b=KQ8pD9fy4R29ALRpEnooKFPgvzM5VcujQgyfFCGlmK+L1hE4QfW42mFQfv8Mp7GLrqWXgmhy5AodWstH1uTYhKApLtl/++WcloVxiy9fJl+i+8BReIcC55GJKkrWbkwZYN+i/OcfVa0/MCTH1uwo9oLtcFKGg7g29/oHsk/VJrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744227289; c=relaxed/simple;
	bh=0514w3TLB34QLDrbo3yxLA5L+YiWFpPDKlp43GY9UAE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VjV7Z7iMsVsWKGfPcAhTNUVwBk7rP1iJMPo7WMcwrOcOC16DLxQFHACcCrWQq6Ogz41whQUOXdHN56GkRY1uYQ+MWcvOvXwm+hHvJSgzU5fbnm09rt20zJhLm6347eI0b7wbnBN6KMl15x8B9iTA3oAgKHHM4rOAj2OGba/EWT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Eu+deHHg; arc=fail smtp.client-ip=40.107.237.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Eu+deHHg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FTSM4HrGQ6XJfAf+yNb92Zfl4Cb6bAbkG4Uv23rwwysZQ7yslPhbm0rkeZyQLl3MITDz09mqeFGFYFruuyaL0kfzB3tr81iIrjBKXLmWa1U0KvjM/dgraFwn3EIX5thj4820R3qyozl3gdpmFz7tEKd2I8+13gRe0y5c1PM3Iq4C0LXmgz1iSCj6KtcwE85q8jWgqs9eJrt3cGeUQXSA0+5WssLFEVvb7spavnBiBM3ogpc0O0HgQrVJIQErpE0UIu7uTyik9ASQI9Wk9f7WWuE45Tcx4YMc71BJegp7KtYWVpaw7qwxmuQ1+2fQZo7d4vAXZwgsoyiNKJAYGKhoRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CPgA/jHYwkWauLlipETv+WXfh7Jx3hweK/7oJk3mTek=;
 b=ylyIG021VnNlCRqLv+zYUgQDnPL7ER6JR36eNtpw3Z5peu2+Q5EyrIiyt7XcQwm0OwXmHakN0+3T8gIWT8Q26n3Uy3ns7pebLtnXecGWnhhuEyLOmxRoszTYDTuRVhtpGX5yNgenNgwmzO41yiAvN3iSYz7aMdZtJNFlasAifsz9NHwTpfh/fBkdw5F37t38atNsuLeIs3AsBjCOG84xGv5rOqce/eO7igBZlibKGxhxRzMxAJtq3plL0ZSQWqNeM3dHmFoeP4VpyE4CE1K98GtjLJtmQ095N6jQEsfhk3yhGACdHMfRJvRKOLngDJIDJtWaxMySLmuiOcwwrzIdIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linaro.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPgA/jHYwkWauLlipETv+WXfh7Jx3hweK/7oJk3mTek=;
 b=Eu+deHHgYtXo5Anjeh/l088AdP+noyiSBUVYO9CYKVAfTLbrm5mZ0ZUsyn7n3KibK9n/jdGGTQbI2Cr6GAawV0f5O0gZfl9Bkuj1Mgzf0aKB2o+dNLZh4LfjoiZNEDjz16K/MdhAi+OHE5hQj1+f4PcZpvW3ss0lX5Vi0Z8a1pA=
Received: from MN0PR05CA0026.namprd05.prod.outlook.com (2603:10b6:208:52c::8)
 by DM4PR12MB5867.namprd12.prod.outlook.com (2603:10b6:8:66::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.20; Wed, 9 Apr
 2025 19:34:40 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:52c:cafe::b3) by MN0PR05CA0026.outlook.office365.com
 (2603:10b6:208:52c::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.8 via Frontend Transport; Wed, 9
 Apr 2025 19:34:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.13 via Frontend Transport; Wed, 9 Apr 2025 19:34:40 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Apr
 2025 14:34:39 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <dan.carpenter@linaro.org>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: ccp: Fix __sev_snp_shutdown_locked()
Date: Wed, 9 Apr 2025 19:34:29 +0000
Message-ID: <20250409193429.346501-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|DM4PR12MB5867:EE_
X-MS-Office365-Filtering-Correlation-Id: 16e47014-9318-4f7a-a62d-08dd779d925c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TE918e0JremDXbBPwAKKd2poRBdeioqvoypD9gugy7W4o9+j3yllpiWI3jrv?=
 =?us-ascii?Q?M0rDPDbP5OF5LdRH4VwLp7k5JEtfgM89gIXiAZYrf9TMZIDjE3H8Hfgm+JDE?=
 =?us-ascii?Q?fo7uiJXGbtABc5ZAuzuy3fIRU/H+J9E1uSVNRmBBto2LxJzJ+n9P5e6/OHxc?=
 =?us-ascii?Q?ZrF7TVO2cqLLJ40TqhvzuLAPfJN0Ai0kR5weaBHvmZpbMuAf3KelbEwxouO0?=
 =?us-ascii?Q?nUAwWyAyhjU9fiLCunAMRnDLo17OGgO/750CaH58PBRuBSqORYPCZQ6nhocp?=
 =?us-ascii?Q?m+LNw92p/LeMhbKUYyIQnJPNXNKSAvRhaxEaU75OXp4s58iZYB+4i2daHQ1Q?=
 =?us-ascii?Q?6GEgMwW1tT89zBXoRmBO8+CBWwrHUxEFYNFGFz5xdiA2PQOBuKCS4UW2gVub?=
 =?us-ascii?Q?qmU3WYs9Lxt5ks8TeVp5O0mFhqH1zWlFUwwgnayoUz0RNCY1BfcxEQMDcxkC?=
 =?us-ascii?Q?JmcNROxsBRkISzmxeNFGPDcuZLGj2lOCQxcKB4skaw18YEqf7NCf4JtXZe93?=
 =?us-ascii?Q?Gsqganexjh0EdzPbpRJupvDS1xgY46MOvwPm5kW0eG491bRvycX1h2T0CNEE?=
 =?us-ascii?Q?xEAdBplJrMKPL8VddkcotKz9fifza5Bm+kl/Mokn+vgGV9ZnhWR9KPBb5Ys9?=
 =?us-ascii?Q?g1y+DvgoxVjv8a33xfSqmeODc/qWC0IGyMdVWo1ilMzEQI9rIEsBz+emLdYE?=
 =?us-ascii?Q?94iPGnKLQ+BN6kLySi8FR3gR7OC2OUKEKBUpk7lLv6kxsuL07zY6ogY4M9gb?=
 =?us-ascii?Q?IaW6V9des2uCJYFP0vRUKA4R6Y77c7Db/O7baswwfz2Pv/v1UPA5ThbgLQQZ?=
 =?us-ascii?Q?+v7yS4Cv1rsiCNvN7MoSlaN+tce03WlB0Rx6bfOjkdSVTmbbLTLnawrq9EMU?=
 =?us-ascii?Q?4ZqCePjHiXyuLSDM9Xuyi08RFIxI1SCMDwx/va+d7J+Ksg+2SsJlhu9kNIKP?=
 =?us-ascii?Q?Yzqqq0D4RFTH2h2iYfmLIOBmX5iPu+wdtVEJq/O4f8Yi0jHpnhAsJSJW+DB6?=
 =?us-ascii?Q?W7eDWeHTJZvtXS9DCpeLlsjOgLbRiOfjXbstO/7ONV6lJTMr8bYbKNByGglY?=
 =?us-ascii?Q?3IIfnTI2uTYtl3OwjGZTV6Ae1V8MS4eWhsqboMFE4i5jp3le1LZ3jvyXFOzB?=
 =?us-ascii?Q?hZNEDdpLRtWIqvrFuz57j6AIg6pK9OqWiqz6yFgG55RI8/keM6fz/PolnRX+?=
 =?us-ascii?Q?sqqFHPN2PYhnXc+3XMt35BxQietb0yVr3Py742vy7J6q9RzWJRaio28wIeAr?=
 =?us-ascii?Q?37SqSufdxabaFdZN9rSAVyMK8rhA4uGJEMOqgSLhOODwK3OKW1iKea0tQMVp?=
 =?us-ascii?Q?mWyCTbM/cC/tp2NkTRVNdRH+5JsBAvMO2e9mm2L3qaVK8plcSPTkfOUUniM0?=
 =?us-ascii?Q?ANRIJwrGl/UgMM5OfzHucJ4MdyUXF1LaWftMp6ZF3hycoSM5EVW1v9STqCs0?=
 =?us-ascii?Q?O90V6wj6PmXn1wHIUEtUzdBqqeeyGKUEwWqzCmte8wPMMQh3s6jTmhD8+8pM?=
 =?us-ascii?Q?YjyaTC2/JOdpw40=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 19:34:40.5282
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e47014-9318-4f7a-a62d-08dd779d925c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5867

From: Ashish Kalra <ashish.kalra@amd.com>

Fix smatch warning:
	drivers/crypto/ccp/sev-dev.c:1755 __sev_snp_shutdown_locked()
	error: uninitialized symbol 'dfflush_error'.

Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-crypto/d9c2e79c-e26e-47b7-8243-ff6e7b101ec3@stanley.mountain/
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 19fb51558a7d..1ccff5e3f4bc 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1744,7 +1744,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
 	/* SHUTDOWN may require DF_FLUSH */
 	if (*error == SEV_RET_DFFLUSH_REQUIRED) {
-		int dfflush_error;
+		int dfflush_error = SEV_RET_NO_FW_CALL;
 
 		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, &dfflush_error);
 		if (ret) {
-- 
2.34.1

