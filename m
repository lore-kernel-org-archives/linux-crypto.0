Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2A7149C7D;
	Fri, 14 Feb 2025 03:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739505592; cv=fail; b=Owa5zc5d+FTc21davVkv4YDxKz0BAXyDh0wDYVt55+7jno2zMYCL90TZ0mtyjQNCnVQlv36MA6OI5u9uOd12L1oTR7jQEIXq8TvApy3SWLF309Z6y3Fi0H+z1emI6WhTMTuwwGgl+UqMuIWKeZqeAECDVJbD7mRQ3IvYtOY6kcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739505592; c=relaxed/simple;
	bh=Y9ujkOxV3KdwYpO+g/9C3TH3sFuhFuFQpWgsljZ3S4Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A3NXkz2Z4Q3zJPmDpW1XW9OeumzIGFsape+WOakaD1iILSmAXvYD1/cua80taL1VJN1kjngXKyh4/nF5q5KOGJS25KGHIT5Q/P3bD6pYgddLWSJlhIy7WNDQMag8PGS/oBL6YTxZYznuKHDdw+rX/jYxlRkYkuxFlJPASsgy4Ao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YJJopdZ+; arc=fail smtp.client-ip=40.107.220.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YJJopdZ+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UhVXapSyftfOQJ5+OwkfNB2RzV+Db4kXlKQ3EyB3NlcXjpOTYCvBJ2e2eQC8gpcNguQdWumkirwG/CTYZgT57vxoX0tnzvwChPQZBs0npC6jMdEy7RkhqeAVUcxEMX6wPqDAWM5WNADGM3lc86IEG8ts6fNy6bKGwYhoZJ6fDcYewyMjMt1fe0m/8hDpOVojctUh5jpPerEsf26DZbVIvUavqgitR8qpdVoQQj6aXqyP68d/2QqqWqKn8w7eM2YrhdJNXnlK9DcR6RPswJr0WPbPlMSsJv23eSlDntFalOUKe2qoQPqNy9AJXVAU6rbqp91iLuQWqI/L6R0biijRKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94vFyjtYj12n4PfD/DXCekJzCKn4Jyh5o0dR62PvklU=;
 b=gtkb8SEaldSALtQe/+elNv+6hrAPZ1ZCVO6244LGxLP4AMYVB/UpBChJjByW+f3wqG8aBQ6X3VfRS9Ud2d68muid7bhBCK03YY1XHcqwHBV17cwEqNMHP2WkUikds48+XQFt1xHx9ZVPjTQXHgi4P2Bne+hAmPKyMTt8qtBxJH9EuhsHygQzEwVOI/abjEggaG34U1KPBwmEBebc2taRo06fTByu8DP+ts5k9PTL6XdSCdKdA5y9YO2WVzdogvU16qVqN2SC/E2JhbjIVuiWKZsfEO1OgjzEiVaD9GKY2Z95Myqq0mnxRLouHpQC6cuXaahnYpw37cGZa/fyZsR7pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94vFyjtYj12n4PfD/DXCekJzCKn4Jyh5o0dR62PvklU=;
 b=YJJopdZ+XNmFwvL1RZhh1t6UjeWhJUf475s5k9sD5zHg05xTYARPomQi33htFO39Y0jDibllTyp4TIQ2q7sCo+4zWMyS0C6N0xrOYK52B5X+HaySv8DmgX/FhX9pkOUroc3l3Pa9N5gWBIFBJ+hXbguFqqG8qZ3m9hpFrpIIt48=
Received: from BN9PR03CA0054.namprd03.prod.outlook.com (2603:10b6:408:fb::29)
 by PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Fri, 14 Feb
 2025 03:59:46 +0000
Received: from BN2PEPF000055DC.namprd21.prod.outlook.com
 (2603:10b6:408:fb:cafe::d4) by BN9PR03CA0054.outlook.office365.com
 (2603:10b6:408:fb::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.14 via Frontend Transport; Fri,
 14 Feb 2025 03:59:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DC.mail.protection.outlook.com (10.167.245.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.0 via Frontend Transport; Fri, 14 Feb 2025 03:59:45 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 13 Feb
 2025 21:59:43 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH] KVM: SVM: snp_alloc_firmware_pages: memory leak
Date: Fri, 14 Feb 2025 14:59:32 +1100
Message-ID: <20250214035932.3414337-1-aik@amd.com>
X-Mailer: git-send-email 2.47.1
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DC:EE_|PH0PR12MB7982:EE_
X-MS-Office365-Filtering-Correlation-Id: f8a4c640-5641-48ae-345e-08dd4cac04f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VB5BXK5EydO2iU6TlqjSq628/foEsaKwd1Ig8UGsmmYHymgax/oxLjcbSScT?=
 =?us-ascii?Q?bbQHK1XzhFC4AHFbizA+YQz7T7klP7xQXN3hBwKRTHvlK4FEfuShaoxWkNn1?=
 =?us-ascii?Q?0K0X9N4YgPWB6Et6nAPie7jlWYP5TX8vax0TCwW0x/mqYggwNudedrhC0Hur?=
 =?us-ascii?Q?DSKWHcc3wAOP+h0IdLIOxxedR8DZQ2JVuq77zocxOExZZbkIoIu4wCnrLJ46?=
 =?us-ascii?Q?np620zM7kdA3ZpD/phpK8IssbxgLB++KUupSUIphD2xvHtdWDhuu22gog82q?=
 =?us-ascii?Q?u7tgsRB33zikSqJ0dTJXWdJzzxY+WYhuhQJGR8wPTUEhxvCceiSQYFcUXO9I?=
 =?us-ascii?Q?eCN7Y0sbZQIgf+b4vl3zQB5ONqrHkO1yZzj/abF4y64N0kb1ccLsIoIKMZv1?=
 =?us-ascii?Q?yd4gxgYm7BAgZ5E0NDodN0Eza3gAIMiFj83y4lCge0Kifz4yh1x2FEnujHIJ?=
 =?us-ascii?Q?7l4YA+jX2sVusB2PV90bOBlX1ZYPMEWUz1lDE86N35wziteWXEi/iUoM5JwQ?=
 =?us-ascii?Q?dqxrWgGOD3TtYS4aof/jfw6mseXZ7a6hmYdN3hlnSLadaFuCcn22kgPlM0Vf?=
 =?us-ascii?Q?HLLIjq6lo8VuXrE9oPz4eg4tX1gDMZ5Hi/yifBhXh3rqDelU/MF6ILQKLmg0?=
 =?us-ascii?Q?YzaNsKBjAnNFrhIIpOyGkAHcim9xeKoP1MBDPLHNNywDis3K/PHSxokczmrU?=
 =?us-ascii?Q?n0VExJzypduHN+Obp6qhS20c7HDK5gvKx1eCG5V2yCRSHgzNgGtM+ZjQSCRK?=
 =?us-ascii?Q?4J/RIVK5P7vm/Yd+QRWkIOGe7I5gA0m06BpbedBzRt1Z75fUG20S+W38h570?=
 =?us-ascii?Q?ivrPZOEbho1Y6WcKsfO5N/nMIBLXChzOYX4aHQ8FFbYxXPrNFfcjcQwvEUJF?=
 =?us-ascii?Q?TWgWW+EV8A3OlET0+6AoSrK5JVZTWJUxQuk/kJuL4uC0ywUb4b9HwE8dOhcs?=
 =?us-ascii?Q?rOkr108CUp/IGUfzGG/Mw6TBcsmIpGJW/PcCyen1a2r1Lu4KYbaQcDXAJXxo?=
 =?us-ascii?Q?UeRypziZFwMPbrskX7BGiQVkYPDVHMoFYxJ3scOS2jLSker7eGh2Kp/mEJlj?=
 =?us-ascii?Q?Tla6KMGlpSS6uxled/4XeDy9y/PzhzAngw+vcP4hmWNWCXU4mmg9WDeuaRHp?=
 =?us-ascii?Q?cRIT4Zspm9UVcB7SctiT10MJXdZncFPh2AB/VHLj6YPPA+I4iTNOeXHTrWkI?=
 =?us-ascii?Q?g+6lfR0u/ooItTJhpq3OClQ0z7+/0IC5So0BzZOUEXfhB0WRQw2Nvg15g/6/?=
 =?us-ascii?Q?z6q7hdcpDHgl9n+w0PN/nFE0p1Yv2yH9HPzyzoGkfsTq50WH/ODQflFJCHEn?=
 =?us-ascii?Q?3amMc9V+Swb/8Sj/FbXrRvtOGCHxN0qfXy71d1H5n2+k04B8S9H73d1KmMgp?=
 =?us-ascii?Q?OugDidpZmk0zGqF0xFb84HnkK7rFSpQugaux6UEgpbVqUQ2WO91ix9sgBLPI?=
 =?us-ascii?Q?HvzDa+PU+SUuaoRrkokRDFCw7HQx7LUYltZOoMP4LvA3Atu15NhUROcTyqkW?=
 =?us-ascii?Q?zwdtIMf8iEGbU9E=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 03:59:45.7134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8a4c640-5641-48ae-345e-08dd4cac04f6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7982

Failure to rmpupdate leads to page(s) leak, fix that.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2e87ca0e292a..0b5f8ab657c5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -443,8 +443,10 @@ static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
 		return page;
 
 	paddr = __pa((unsigned long)page_address(page));
-	if (rmp_mark_pages_firmware(paddr, npages, false))
+	if (rmp_mark_pages_firmware(paddr, npages, false)) {
+		__free_pages(page, order);
 		return NULL;
+	}
 
 	return page;
 }
-- 
2.47.1

