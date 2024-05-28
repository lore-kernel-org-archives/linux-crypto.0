Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A141617B410;
	Tue, 28 May 2024 21:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716930464; cv=fail; b=SvWJ9Rip2GsbIMCQpYjGHe7IDi+RE3Pdg89VFiPq2QjR21UwvUwi3A0lQMF8ONSBy5lUMJZgwBhQB7bEARphV+U5b5/jx8Gz02alnhzqviOAhYhZr2WbE/bdqleuK5hoCrc+PHf+yS+rwzEPyOy0Hv9r0W9Rn2bhLwDBEwHHNN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716930464; c=relaxed/simple;
	bh=AYyTRJqC7IsWTASylpHjhf5/AXo0kYF/meAnJyOACNQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lu9Tz/JZb0AIA9ajAXnZlHO1C3lQSeBvjmSl9hjwLsg9vR4Eg3/PPalqEmm6ceaMJl9G2FxUVh/ZT9x4ycW1unQWAX/MGNFObcrRAPfj5QgTBjPca2Jd5cIN50pCpzVA4Pba6vU4LOpYhG+h9vi5NW3EHdsOKSTV0XmQddF9N+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ld6ZR719; arc=fail smtp.client-ip=40.107.223.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ld6ZR719"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVAJ4PixxG24CvhR0evAr9OlyqhpM6+ascPlDfT0UAC6oKpxvwSzZmbXFggB2gRtYru3949NdNyYQvLmVnYKzXrGNAzKlYCckiidVVsITPBTyKHkipIL9liog5x7cUEeY3+qGdmB3+0zCvqlrznxWgSr8vDxnZuDgr1TgfIaX2ioZP6bHljygMDq84B50Xwbeqe6b4yuF7cizxn82CG1DfAFGWCFgAy0W7V1BhgZDmaqlK71PX4DOxa9av2VZIeFyHWisjEk+CSeyKYUHiCWdUcV+3uhadeFyMMXFeVD6K2FnD9OguNW5u416I+puxTLbPOMBb5tMKoiNDcd+gjN4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DYByaFjjTieVakmh1ZORKaASEbDVoB1wTHOhCZ+IDg=;
 b=D/2LpkZyH6A3vkPFfPHqkJlPKLVs6dVpA4N8TFjhWoPHE9KYhep4Hunq8KHxMrT0lw+INw7ZvskdlFoBXSzrvWBiPv3xWJDaZ78lENKuFyfMtrqV+G9plKwY9u9U4tNvdAf66Akkd0zO4oMhkoER3CYex+GCJIQJPe4V+Fk/YT0ZgekG65u+9g6iZv6LWP68Xsi7FUrBeXRBcJe9m7AXPsT1CxRBMigqIZTdkAMbMGakFRgaxeTZBe2BtXUON6m5pwZaIzfyuFLpO/4VH7i/ohSWiU1eEG1OGE0klpPg7T1OT7K0/wuxOVbbqSJo/7av8ghPeIMUS5+tMcdtPvTl3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DYByaFjjTieVakmh1ZORKaASEbDVoB1wTHOhCZ+IDg=;
 b=Ld6ZR719Z2hsN10YtAcZQT7kytYj8WKtzqZLaZAlJHKczb2wzML6DHhO5e035+zGfwTKZmcObS/Xq91icBOX7drDg3UJgF103OSm1qsG/AoOm/uspFWJQQQkm2TTz2ERoBNZtAo1d/iid1HT9GH2i31YWRPBlJ8Pl7u9aZ3Byrs=
Received: from MN2PR16CA0021.namprd16.prod.outlook.com (2603:10b6:208:134::34)
 by CH3PR12MB9172.namprd12.prod.outlook.com (2603:10b6:610:198::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Tue, 28 May
 2024 21:07:40 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:208:134:cafe::d) by MN2PR16CA0021.outlook.office365.com
 (2603:10b6:208:134::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.18 via Frontend
 Transport; Tue, 28 May 2024 21:07:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Tue, 28 May 2024 21:07:38 +0000
Received: from AUS-P9-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 28 May
 2024 16:07:34 -0500
From: Mario Limonciello <mario.limonciello@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mario Limonciello <mario.limonciello@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP)
 DRIVER - DB..." <linux-crypto@vger.kernel.org>, Richard Hughes
	<hughsient@gmail.com>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/5] crypto: ccp: align psp_platform_access_msg
Date: Tue, 28 May 2024 16:07:10 -0500
Message-ID: <20240528210712.1268-4-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240528210712.1268-1-mario.limonciello@amd.com>
References: <20240528210712.1268-1-mario.limonciello@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|CH3PR12MB9172:EE_
X-MS-Office365-Filtering-Correlation-Id: 6eca8308-e7f9-4f70-45e7-08dc7f5a3490
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fvOyMmKkgn1QW4igloBtOzsDY1UXeW4X/Pu+NbDT+9X6XTIezs2Y+UcSDAx8?=
 =?us-ascii?Q?tXHiKy2AZZ+4HC9Bqpf365ldVcUrHGSOjs045SD0dZVBmaYp2Rb9Jo0XSulY?=
 =?us-ascii?Q?gNtqfp7Kh5yTwY/v9taqbovpHNjXaZI325jWSvvMT79aLCGJmhgZaTp6gwQL?=
 =?us-ascii?Q?WovIlK+d+DqkH3tEPS/Z/BvXuxT8EkvhZEQDtdx/dJGlu8riwnpUZSDqbc09?=
 =?us-ascii?Q?TlS98wbDVYqHwqtoVjuLOxpkdNdAEoaaJ6LwnZetLwMHx99DWxuVc3/6q3pS?=
 =?us-ascii?Q?DAlYjYhzTM/CtkWm3SVN0frFnw+KJRqcZ9m2RQ1OSBnxZc40hOWS5rwsMLfd?=
 =?us-ascii?Q?Vv5f2ov2iMC69NQc6WazPhuHwJUkdd4CfZ5XyWeeUGSL8opFL8p1HNs+XQIi?=
 =?us-ascii?Q?Uns2AJWDmQL9QouzE3pFobn8F486Rwe+FQE8FdSknH9gVQ+XZM4vvCzca0lA?=
 =?us-ascii?Q?JtetHUBXgJLIb05bA7vs72I3spjd9uFs+2GAxDxnhF7BqOp/IMan+dxM6AXU?=
 =?us-ascii?Q?SLERXAdXPTObytYUtssy+v1zfbBv4RyxrkEMKGqaU3ml7v+kfUgS6N9W/vwu?=
 =?us-ascii?Q?EL04WRsnjm+bcYSrjlz/ewVjRpTqhfLerhqLFw9MNXBJgztdHHy0KRKPelV+?=
 =?us-ascii?Q?J8hL50JSFjDTn90+s6NGm/i6y8rB8WE87zbCt7DpnPAZwPXhdsOvGoZdRtye?=
 =?us-ascii?Q?L0Ux6nX1AnhowTv6cH1J1ybN/BklCIrZL42pR6kWUpS7zoRAzUaXEFs7C9M0?=
 =?us-ascii?Q?O/46X83lti74SI5gU8+itvo7Dh2JEb0aezwZVNr8nH8l3wdVpewwwnTazltY?=
 =?us-ascii?Q?CadFp0Nb46X9Y0hfsFz9gVxpZf4xjWfF7pG8JTCTeqqyPdzCYEdQqLKvCPix?=
 =?us-ascii?Q?E9j1FMQ7SHpNRyUFqzY5SsNOapqTgOnBqGjwISIqxGd1Qf32drNfsg90JLok?=
 =?us-ascii?Q?voJMI42Forbr6Ncad2v4KeqJxfb7Lw+5mPQkOchtjdlaLkKELFx/z2diZaDT?=
 =?us-ascii?Q?bB9AGvC1quY9Bw7FKWu5pc0ZuhREuW4IrPcZ4479GvqxVLbB9hpp/KvRMFyV?=
 =?us-ascii?Q?/QosNR5iX3/N8LRhTlBqpPiolR8Bq3C59wJHhIpyq17h0N58KkBLdufAnARm?=
 =?us-ascii?Q?t+5sa8h960W7DygafZnYSewlhnZbrkjFJLZ8JyAz1tRm2tJCjQPp9V584gmq?=
 =?us-ascii?Q?HtWTsutoT4fPI1bQzTB7J4iavqT9/LSljgtQpUbVFnR/TTH360gsiD/Vl7cQ?=
 =?us-ascii?Q?QUB6reUrtnTh6NGJLvsgUCQIIm43k5Zqm1/qPYfDdgsr9Sn9Bgnp3PjiiAqT?=
 =?us-ascii?Q?QCutW4jeUVHurrksGnatbelSTTRfpAKvXpbyIOqW9VAC/lgn+rz0IAV7/RRh?=
 =?us-ascii?Q?KKIfHdx8U5Iy5+8h1CEKFF83hCVU?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 21:07:38.4797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eca8308-e7f9-4f70-45e7-08dc7f5a3490
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9172

Align the whitespace so that future messages will also be better
aligned.

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v1->v2:
 * Add tag
---
 include/linux/psp-platform-access.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/psp-platform-access.h b/include/linux/psp-platform-access.h
index c1dc87fc536b..23893b33e48c 100644
--- a/include/linux/psp-platform-access.h
+++ b/include/linux/psp-platform-access.h
@@ -6,8 +6,8 @@
 #include <linux/psp.h>
 
 enum psp_platform_access_msg {
-	PSP_CMD_NONE = 0x0,
-	PSP_I2C_REQ_BUS_CMD = 0x64,
+	PSP_CMD_NONE			= 0x0,
+	PSP_I2C_REQ_BUS_CMD		= 0x64,
 	PSP_DYNAMIC_BOOST_GET_NONCE,
 	PSP_DYNAMIC_BOOST_SET_UID,
 	PSP_DYNAMIC_BOOST_GET_PARAMETER,
-- 
2.43.0

