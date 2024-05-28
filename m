Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EAA17DE36;
	Tue, 28 May 2024 21:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716930468; cv=fail; b=bh6koC5LQO1k6wE46HGFnHVWEKitxBfd1ascj3crSzt5vl24ESl+yPnnqa3AyJKiP9eLJnsYhFwDkJCYlrGSwCUiRM/PK7Fx8ZCyrjT3vc/FEAJYT7rhvA3qVLESII14auVWqr56yriv61idOntKdgRk5kuT1gCQLGCbgQk9sEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716930468; c=relaxed/simple;
	bh=2vNSvuEeughsOfGEix/zWS2NTHvSnXsbH16bexSPGUo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GWIp4s0D/5IsVqtlAIroZvgnMlr4fDfrNmmAKx++Qywdg3D9Z9Z9KqWFV6lLnA8F+y3EAQLiUHCKQhjgNQnD9XME/VlF6icimXnTZAyg7Rt8tb1XIyzGmVwRlmAF2dv5oX/yq7FEZZDeuEOD/C+PbstrzWieZ31k1QyCgMD4a7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kp7yiksx; arc=fail smtp.client-ip=40.107.244.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kp7yiksx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+FO0WcVM911VA8DxrOURtb6zLKvS3bneqcNxe8znosdAnOo3bRYmsaPN3h2i6WH6bQCz+zPpPhPpAFpaNBNmMACy2zRfEdZ2CDhlmF6jM5tWeP4M5P7cn1ZF2Wt84CC/Zdcvqch3gzUmBTFpGQuByozDLh0rAf8rq1x9XGW05E/AniTBLytCtAm2fL6g9ptI+xyTunkoy52I8h3nuAeiHV5NLk2bMjMZlHAhf9mfJA0nn9/ti2MZjHWW8HuBnPQIYPq3jaME3qULaZMRyLDk5/Nnt7O3PcKQoQjyvkSTMywS90YKNKJVKOoGuYChaZPdn7owoEfb6Qw0Ddt7wC4Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7wy7Tu6JuM4mF/LAM5XeHS/VPLYE1E8iFBIIr6qWKwM=;
 b=Q6XNGHZMCwnbURDpo923AThEQc+Txad+j797rq1WQvVaSsvE2rYIAxkz/i5eTdpnLJHoKC10XeE7dCJXwLfa5TIZzvMV1FwnsBx0ccn4MDsxrysqd94STb9gq3cToCYFKOtMRJROn+WW9PvIXamu20JrpgmV7Hay0O/VkS/+Ef8oJVdkGFiIfFIkZJ2MpmNsUfXmuDg8Fpvven51OJKBO+Nxkl6TK7CRsLHWUhqOXXtKbKozVrY5yhEu1VNjL5+D4La260OYsjnrRIp3bBeHbityARWPjIiyceZx5XCEHMd7j/HILjnYDQMlEvlEf9fFSkCz09G/ZVguFwBck4kF5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wy7Tu6JuM4mF/LAM5XeHS/VPLYE1E8iFBIIr6qWKwM=;
 b=kp7yiksxE7LWeZK+s8ERKV0Zmskh2/7a/hfGF9iVMHI04KPZwNQ91owSKk6hMBSm4No3+BuqRZtLOgh3bY5I6XLILSrWxQ9R9Um3XarIgIhyAaRSvbL52ioNOwAxOiGELE80os4oXXPj5M/mQvATHi2OJhZcqPRHgpwRqK56qQY=
Received: from MN2PR16CA0002.namprd16.prod.outlook.com (2603:10b6:208:134::15)
 by SJ2PR12MB9116.namprd12.prod.outlook.com (2603:10b6:a03:557::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Tue, 28 May
 2024 21:07:44 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:208:134:cafe::70) by MN2PR16CA0002.outlook.office365.com
 (2603:10b6:208:134::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.18 via Frontend
 Transport; Tue, 28 May 2024 21:07:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Tue, 28 May 2024 21:07:42 +0000
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
Subject: [PATCH v2 5/5] crypto: ccp: Move message about TSME being enabled later in init
Date: Tue, 28 May 2024 16:07:12 -0500
Message-ID: <20240528210712.1268-6-mario.limonciello@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|SJ2PR12MB9116:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dff57dc-d872-40c6-c343-08dc7f5a3737
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xva4elvqeWxBB0rb/CjIFRu2Zj2CqaeZx5FbGQwQDm1U9i93f+tjYhNyNj10?=
 =?us-ascii?Q?4/TJV8PjZZ0DDlhBpnIk0+VERW9T7DfVBt12tgeTcjttu9plcn+yJ02kdGmV?=
 =?us-ascii?Q?5IPRuOwGnEMn/N9yfXpIoUQOxxGIldESBZJQvtKoLkTzld4QWIGakAhcZJxB?=
 =?us-ascii?Q?OT0sv5uvzH0zEnOCwgCZsxiBgotqDrmCCmUCmmcUXvCtvH67uli1DzgDchG2?=
 =?us-ascii?Q?C1nXyOhxD5/VrbRCttqZK81f7BQLbIu2eY7fOQlacYaTyryTMoWGxxY7Qxyi?=
 =?us-ascii?Q?ecXu+D9xD3WpHFj0Jq3YDJ/1M4yUsvy+ZCGp/K9oxCgHkbiYgVeHz5aQr9w5?=
 =?us-ascii?Q?SFuto3Tcrvvip0tRFADMhjG/1M9LIXYve2d4ORt16NrlisSgK7DSobw2JZjC?=
 =?us-ascii?Q?dSWyb1AelCza3keskfm1k9n8VZQJEZlHokbxvnKm2LeGjN3DcFbRdHcAQaEU?=
 =?us-ascii?Q?0v0+tIv4SiaDHmPy1nzBP9KjWjxas6ayau7LNnZs7KC5jBpizWluITmn0vxM?=
 =?us-ascii?Q?EQ/C2AkqxLj1NgftZW3Vt28hYC6z25d6RBjnKjnPsG0gZtMmdfqW7chwZRMs?=
 =?us-ascii?Q?4SEotiPrrL8idUHrvZCCTowJdnUEa0MJIh1X8QGo5bZrI9Hwk80kqU4PzkEg?=
 =?us-ascii?Q?2KsXi9PULhbJrxwMMzzrr/lLUcQKeGSwRr3ni8CrkoSWUwPgXmWj7RM6pmYE?=
 =?us-ascii?Q?qQv+si4A8SQbn+3vHSiMOUkNqhfwck8sKR0tgcaF25PKzmZs4qF7B19Demje?=
 =?us-ascii?Q?aLjh0BSYSWPE0SUL3nakjBefZmd/WmIEuZXbT2Ww2HWgXuAnFzLzV/5hFua/?=
 =?us-ascii?Q?1hR/0xwSI4XLTnZrI7E2zdINwo43kpza/qZzDQzyYg/HCniegvh1ylFCxVlf?=
 =?us-ascii?Q?F8AKnAxSmbVscVW4b6CDDBkv6mkeQPhfn9HinQ2KemRQGzi/OZg2kC6p4LDo?=
 =?us-ascii?Q?hxl9VefUs6xZOCMjunggXQtSfwdRnHdIiY1H6FznJLf1YWvQWP/auosqIVRx?=
 =?us-ascii?Q?/rk6woZSInc2Jwv8lNq99nzyqbTbyMjLTljDkPY2VGoW+G6xGxiGC4IxsbGB?=
 =?us-ascii?Q?R+zA+670IJckZAsDR1s56fCRTAQCTp1ZXixLwfCLyuzdE4/oXYh/AKjZzTyV?=
 =?us-ascii?Q?xU25lNQSn7ojqdFc67w3pbbBClj9nnlWXo5/0NnOGwEwMPtCZIOItOa7mjAO?=
 =?us-ascii?Q?KKh6LFR+OJl/uxCWPeuGhJM90v7poW/y3BA1NSHkwpsi67NErZzcNLpp0VM3?=
 =?us-ascii?Q?GF+WYJkDxoGrKAH1zrgrXcdqZk1xG2IBo83FqlhBm4FFZPzHtFC4awWV1ni2?=
 =?us-ascii?Q?o3gmcwWndVwL4rYzVF85CUT+lFKsmxOKvhXzrybs2Kb+Yhj4P8cRvpx6UzNR?=
 =?us-ascii?Q?n6h30tTaTHE1bLROs8He4X5fEGbT?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 21:07:42.9640
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dff57dc-d872-40c6-c343-08dc7f5a3737
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9116

Some of the security attributes data is now populated from an HSTI
command on some processors, so show the message after it has been
populated.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v1->v2:
 * Move code from patch 4
---
 drivers/crypto/ccp/hsti.c    | 15 +++++++++++++++
 drivers/crypto/ccp/psp-dev.c |  8 --------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
index 8b99bbd4efe2..1b39a4fb55c0 100644
--- a/drivers/crypto/ccp/hsti.c
+++ b/drivers/crypto/ccp/hsti.c
@@ -119,5 +119,20 @@ int psp_init_hsti(struct psp_device *psp)
 			return ret;
 	}
 
+	/*
+	 * At this stage, if security information hasn't been populated by
+	 * either the PSP or by the driver through the platform command,
+	 * then there is nothing more to do.
+	 */
+	if (!psp->capability.security_reporting)
+		return 0;
+
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

