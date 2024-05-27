Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7E515EFA8;
	Mon, 27 May 2024 15:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716823647; cv=fail; b=Dnr1ZF0SQd3PtKCM/bVFVugKYh8Z+cbNTwvLO9WYEsbudauYiLeJVX57IAPf548gNuSLCRqJ6Qv4uMa7ASYb1vJOZn2LEBeWSzMXSKlV7/YNvEeQqVXIjm2yj3e8QH+9Wjeb696M4PvprNSRt+OC2eFiLVNjSlkaH92sgCkb41U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716823647; c=relaxed/simple;
	bh=xRIHbcRh7gbg0yDMMARawggtgJypuKz0aBUSh9SBoMw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KQI1dhMVHSFul0e4brINUeU07LPqfIa3EWKSns6W0GbV9ffaO9uLj5SOHNHhZ49hKga6NDhIuG08lwfXPsC7WMvvBdH03z1M8KG4JngwkbXYOZAe/nVVhCAKdVtgGaZcKDj5ucM+l2O1ZxbkdtbOl7m+c1BQU4CwU0TFjVo92c0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rmMk1pIO; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rmMk1pIO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqC2+z1/Q0dyLBMnTOpjZKtpDn71mzNwFPrOWNoGfAYQVlboRysQoqMLuJhfZuG+I1kiTkln3Gcc9VclmF2XpiGKt5S71hacRzMHdIlMnWabPBYpdC6P+MX8iU5fA9Hr3hXJ3fFOvorpSd+yWHpn1onW1qketEx4lFmhBzDWngzklOx3tv1PLjufQgZbqh7lW1RIld6ZFY4VD/I6jP7+A9FIt9ZPCHCStZHDhKDUD9nb0Vyb6YmspqRnSa2fhNgpTZwOU2ceD+L+gj4S7bkIH1/9RoVgMDLZuLt6lxWbwtfvP/mFknI8sjxEmmSwCZZE3JtF3o9jqKxOwFsqI5Lu9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YquFsLnkm1GDh9ty+4t8dlGgHsWR7Z+Y/isQ2dgcbmg=;
 b=F1RqATgs9Lwhvjw30WUra1CnCZstKEN5w2UCZ9hK30GK15PTGGvfaSNYNxrOB5I5jVm+GKE3wVDRnN1NeWn23bVgThQYSxqiwzJaamdNr4LVlX4wqNWdGClAYfaIbbSsk6paZzq7nrZfIZjdU7O48vLMthMVkyOtUzUHkOxzf5zJ16icQ57DyMR+tFJI2rtYX0viMi9fk1ENM2K4aiIoB044+x4D3VgBH+KxHlHOzQfkguy+vDXjesVdvsSmzu0fJD2N+6ouahmHeB+uI/jh8E8eUHWDqxrWy2hMhV2QhOZs5pFcmpH3MnsZ/FdXtPwQJU+RnjX9jElHa1flqi07Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YquFsLnkm1GDh9ty+4t8dlGgHsWR7Z+Y/isQ2dgcbmg=;
 b=rmMk1pIO4dcIGux2ybj20La1/blgTaDQNkx738GCV4UMT42RReCYTSNCFUBVgK3HJAiRzfFC1kzPfoz3wnI1y3sdB1lkZ4NzQWOiFxuOaE92TRv2yUACLY8rui1VRSmcN1mb9duW7Gd6hjvWfcxWxYO2af6bRymp+MM5KAqc430=
Received: from CH2PR05CA0028.namprd05.prod.outlook.com (2603:10b6:610::41) by
 DM4PR12MB6160.namprd12.prod.outlook.com (2603:10b6:8:a7::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.29; Mon, 27 May 2024 15:27:22 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:0:cafe::a8) by CH2PR05CA0028.outlook.office365.com
 (2603:10b6:610::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.16 via Frontend
 Transport; Mon, 27 May 2024 15:27:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Mon, 27 May 2024 15:27:18 +0000
Received: from AUS-P9-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 27 May
 2024 10:27:11 -0500
From: Mario Limonciello <mario.limonciello@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mario Limonciello <mario.limonciello@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP)
 DRIVER - DB..." <linux-crypto@vger.kernel.org>, Richard Hughes
	<hughsient@gmail.com>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] crypto: ccp: Move message about TSME being enabled later in init
Date: Mon, 27 May 2024 10:26:49 -0500
Message-ID: <20240527152649.3722-6-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240527152649.3722-1-mario.limonciello@amd.com>
References: <20240527152649.3722-1-mario.limonciello@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|DM4PR12MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a1c6f0b-4f23-433f-f95d-08dc7e617f0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jrpXh2erEb/kB1bI0gEr2+7qDqTqW7nMP8tBcGL5KgrPsflzG/Ko/JUjSClo?=
 =?us-ascii?Q?V90OmK5b5RGyQP+49yc4yfIuyIqbodzTedbZ8Skv92FHPCtXaG/iqtxDBBc/?=
 =?us-ascii?Q?H4GkqakMJ1JhCgdHEADaazmA4ZXMnmnWfLeMKqTkbhMciWu7+ATQjNO7ZFAE?=
 =?us-ascii?Q?5NeDOEj8LH/krPxn+Atgs2Bp0TKR4KNQ9MvE2L+uub8aMIkWgPV5GR40KPXq?=
 =?us-ascii?Q?qDHNSehoUH8ges1DP2rV7WBuS9QqOxq19GF08lyykHCH2GYFVuIIZEfbmyPx?=
 =?us-ascii?Q?Bsr5homxqTwoGwHvl1GwvIqdxW9y+mhv30plyXFEVvBJfPZG2myMFQnG1I+Z?=
 =?us-ascii?Q?exPhWikFxzp6kwNox7/s41EyP2P4EERIfZoc3GT5QVI5HkuMB+qkBCMXCek4?=
 =?us-ascii?Q?5YPlrmZ5f8T3PhGT07esV7IE3Jq16uByYFRCGuuAfEAyly5RMSEmIdwq9/2b?=
 =?us-ascii?Q?XakfonceTQ7VAPJZxS60rHJpeh3F4kPtK/0auUxAKWuTg5+Y9TUs66RtVZWf?=
 =?us-ascii?Q?bsF5ZAsBt2vuAi468gg916FuSmFTBVYIzq6AYENx3YTIhBsxyZ392RxWpnIx?=
 =?us-ascii?Q?0ZK8kJVQ2+qNYU8DvtlHoXYzzVO7Sbk20DAZ9iLfiAdm8CDb1l7v49Q8VIt7?=
 =?us-ascii?Q?a7UPgz4U9KO9mZonlKbfaOyWipmeSQiDFlnogjmlqMM8weRKj/KyrSILjhC7?=
 =?us-ascii?Q?32GWGcDcJW+OlSz0tqGA/vnHapziEM29zyReskN0K0ZdE7Ay+ABVc5P80h5j?=
 =?us-ascii?Q?Ojt5XiNO/vIoWfunChkQk7KNlO9mJgJLSchmkfM5tkeU6Lh63FyKjmB66T+B?=
 =?us-ascii?Q?vTp9ap5VwMWd3m85e/PYoNogjhUxHtszMvL6KfpZxOrkb94Bc0Wg5aqUzfak?=
 =?us-ascii?Q?POVLGvGBPY2so+yaBDCCgY8Mv1hYW1/a5fslPkRl+ceqjBP1LeQme86Fef+8?=
 =?us-ascii?Q?xZMHJ/WDB7yQFotxZGIGv0+RiSQe+Rprh7e0XNeoWFaM0nPsdqaHpu08UoXR?=
 =?us-ascii?Q?/o9gCWSDQmz4OEepXxymd/MSb28z5EiwctW8oLQVFkXUHozRD+Bm0HXcAkK+?=
 =?us-ascii?Q?HtUlNfhAQ9givXkGLFgRIQmsqsW4nGjNanV/15bocFspcRwFBRxKOzxHZbSE?=
 =?us-ascii?Q?7+UlxP/Skuy4jFw1lIt0C5w5u3vp8LsW/CAC8lvh7ANKjJO5CyXMKQlLQWri?=
 =?us-ascii?Q?YJvVY9w6HMsN/1RxoqY5HHF2FGhjdpiJq6Fp9Bm9yESzUolP0sB6ehho1dzb?=
 =?us-ascii?Q?Ju+JIxKYWXRNDn1pLErGDRtCfYfG/TbB0/514NURbFodJunaV2r+kwRktdHd?=
 =?us-ascii?Q?zO61XOCY4T3cC+eddp2ATQteKmdOatHOhhHiA//I0hzB3bC5njblNKAXYYja?=
 =?us-ascii?Q?Fwmyredsz845FZalAv1N18Q8MiYO?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2024 15:27:18.7692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a1c6f0b-4f23-433f-f95d-08dc7e617f0d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6160

Some of the security attributes data is now populated from an HSTI
command on some processors, so show the message after it has been
populated.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/crypto/ccp/hsti.c    | 7 +++++++
 drivers/crypto/ccp/psp-dev.c | 8 --------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
index 8f583902d786..1b39a4fb55c0 100644
--- a/drivers/crypto/ccp/hsti.c
+++ b/drivers/crypto/ccp/hsti.c
@@ -127,5 +127,12 @@ int psp_init_hsti(struct psp_device *psp)
 	if (!psp->capability.security_reporting)
 		return 0;
 
+	if (psp->capability.tsme_status) {
+		if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
+			dev_notice(psp->dev, "psp: Both TSME and SME are active, SME is unnecessary when TSME is active.\n");
+		else
+			dev_notice(psp->dev, "psp: TSME enabled\n");
+	}
+
 	return 0;
 }
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 0a01ad134609..1c5a7189631e 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -157,14 +157,6 @@ static unsigned int psp_get_capability(struct psp_device *psp)
 	}
 	psp->capability.raw = val;
 
-	/* Detect TSME and/or SME status */
-	if (psp->capability.security_reporting && psp->capability.tsme_status) {
-		if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
-			dev_notice(psp->dev, "psp: Both TSME and SME are active, SME is unnecessary when TSME is active.\n");
-		else
-			dev_notice(psp->dev, "psp: TSME enabled\n");
-	}
-
 	return 0;
 }
 
-- 
2.43.0

