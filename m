Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2056.outbound.protection.outlook.com [40.107.96.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50192238C20;
	Mon, 28 Jul 2025 23:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753746208; cv=fail; b=armJd20K8tgFfqL+BUG6EYHf9ehC53cZ2DH4alyC2+1ZQ+2c0X+xue8vpJf0is9l2crplc5c3nOkGmsLn8xt6SAE3PS/52RrzYn8e22ndaAWIjYZ/oIzHlJtxLXhWO5lPc/wEZqPkgvzaeAgnPXEFK+SGiUnaIneg++G7AsC8fs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753746208; c=relaxed/simple;
	bh=1C0XSNkNFt6q/HoMRDcnbl0x3SyJxbRNy9S9ymI5T8w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ae6Bm2BIlMGmuAbAZnPjrXigM6Va/eGVAK+HQSeQVUWh47Yq+f0f1GqAAxn3B7TX3axXM9pYg4a+Zm8Xfaqjjj14jQGYlyq2VewPg7SiSdcSE7o5jNFwc7J9PV1KOsKqPukCsV49MpLRm0Ugc9JmuRpBQWthDd21Jde3+nZN5MA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PYQzxFOb; arc=fail smtp.client-ip=40.107.96.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PYQzxFOb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hj6b4+5Meh3CK54wA7IaQ4+Llr4JptoBDnsVKfvBLM68f7iCYT9xYSZsF/EA0y0grJz3QzdU9h1VcWxjRUC9PgN5JtxOxgPiiKJGJsKeZcpTu1ObbW5DfaTEjzuNv82z/lW6JQRW49hzNL3C4/JuiHwZxUDzahQgcPF8rw0sGhei72wCTc5260qOgCb1cBOrR69uXFfn026ok9YfBIGrZXsfYxz7prD/AUC8O6JJWjj48bnRFBKHL9uoAKlyYyb2jcFNc0i4I4aVqx0NADvBYI9K+UwXjuWnJEZtdBQXnJ/wypckvVjHYXd82yrEZvxhOaE90t+lNkvfjHmfQmn5UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HhOj/wt7g10qgk9h39s87scB96ZStS3+QFp07J0xl2g=;
 b=EnHsvOPgAgstoWGSrun5ZEgj7ZIANQaYOPRAg9onfLP6P3CfUy4Osf5oiYuluSRKgL9T3krMiXSsKZXsnDto94eQIu0O2RuMHdMoc/pVYKBkKxiJ0mcTiP0fh4HHlnpAEVGriJJ1SotCTfQuUYp5DA5cg+6BeFCkKTObLn3Dqxw9gznZa1kE+F5wzkTIuJsQe3Ww0K03epcGgD23SWiJRIZQ7G1JVRDMqdVwL65Lf3YkSaT6dAL6OabOSYw6nC4frFC/Xxl+wAJQZoDVq+3pAIh8+0IjM0+jBPVqzmRbeWm0f2W/sMxkc2DBbvl2cANsXOq9ZpwVMw/V+NwQcu1FXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhOj/wt7g10qgk9h39s87scB96ZStS3+QFp07J0xl2g=;
 b=PYQzxFOblyFERabSRO8iGNO/lXpWdwvZeyLCdDkoaypLJsi6NoNb/cvjkgl+JL1YeAL+hqRa2ZBKRvghjWe4ehkKIkSOLzAl/6ecsTwnTUZBp9vobNC3X6rfWwBqv7ndTujSjPBr2JAyTBrkU+CgrIER5BGHEUfx29w9Nm+uVVI=
Received: from SN4PR0501CA0113.namprd05.prod.outlook.com
 (2603:10b6:803:42::30) by IA1PR12MB6577.namprd12.prod.outlook.com
 (2603:10b6:208:3a3::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.25; Mon, 28 Jul
 2025 23:43:22 +0000
Received: from SA2PEPF000015CC.namprd03.prod.outlook.com
 (2603:10b6:803:42:cafe::93) by SN4PR0501CA0113.outlook.office365.com
 (2603:10b6:803:42::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.11 via Frontend Transport; Mon,
 28 Jul 2025 23:43:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF000015CC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8989.10 via Frontend Transport; Mon, 28 Jul 2025 23:43:22 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Jul
 2025 18:43:22 -0500
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>, "Diego
 GonzalezVillalobos" <Diego.GonzalezVillalobos@amd.com>
Subject: [PATCH] crypto: ccp: Fix checks for SNP_VLEK_LOAD input buffer length
Date: Mon, 28 Jul 2025 18:43:03 -0500
Message-ID: <20250728234303.2836702-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CC:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: be6ef38c-f3ff-4b85-3d12-08ddce308a25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z28tHhehJ7MEmd8jLCCVQaItJyXJvsECWfiGZn7RH4EzkkcP3mE9qwoALQGY?=
 =?us-ascii?Q?ShN5k5ArfsEo4EuUmsVc1abIpHTWWsTFJVAohjCgFemI2c0HabcyFyGedlJG?=
 =?us-ascii?Q?frTKAstUZWikJ5C/5FiY4COha75pM04OS60PJLtNnFR6k2Y0VTIF+EiYwhlB?=
 =?us-ascii?Q?2VGHKK92u7dgpJjzmmdfTgc2QszR6q8XwNUn0gbf1WOSp3rMkxmV2sTP66D9?=
 =?us-ascii?Q?2vMCO1FVCodVbqbKpmahcy0QPtEPBKxCuElL7Zp+dQUOnYDSjOhq7rAqSnC0?=
 =?us-ascii?Q?dSoTIgCz9rlg0aAIlrnOhGEUpHY6rfJNkhx3mugt2giDHvVOtOH4mpjcKXO7?=
 =?us-ascii?Q?8ibcfB2pOsv3MrN20wyoMYdRh1lZjsxDIEGZB9UYj2OtraX0QzAGOpXDNngW?=
 =?us-ascii?Q?Bf+F7JDoWyplYFJ9C9HjwYdFuSWbKNohNS8n5FIk/886E9Iu/qF6mJKSGHJO?=
 =?us-ascii?Q?GG6QGqN7ZedfIVk8e/4OPIgBWGNgE4OuMTJarKvzYwLsUH47AtIjmTnT8ttD?=
 =?us-ascii?Q?h0XQVZIKaafJnXE6IWd+t5HzV4Mr+pN1vG1OaGOUNwdv/uAQqkEk41MZSY77?=
 =?us-ascii?Q?eN6/LB9knzjrAgaUGuA0ZMuvVK/IVMVX1PBtOGNDQ0VsRPlAtR++xtEZ4q1z?=
 =?us-ascii?Q?lQ6E8pUKoJ1Xx6TCJ/fdeBoEuO1LBiMIFPj3OlJhcM5SFlmTMBUoFS9toFJ/?=
 =?us-ascii?Q?CP4fTGuz9obYR211zkEWjNRWqjpTvahxeIWyVm6GPHCv3JmNOPnUADSVDg9T?=
 =?us-ascii?Q?/yCMBvhDCdCaR7FW2WY/aXol2tLcK2XbAejzvVIpBQXI2iZMEPdvrKpbmVqe?=
 =?us-ascii?Q?yajXS6jiH/SKKWggz4+onQiTwOp9mgNSLft2T818K8+Tp9LgmYuOuPsoDMjX?=
 =?us-ascii?Q?EImjPWKalFIrGmxq+ftb8cUdiHW+T1joHveDvUV0K02g6oWSYno355rAkkP0?=
 =?us-ascii?Q?A+rtIibrsZ+YK0kCeg9l7d84KzGdv1ae3U6HVyraRVIAPLO+4C7EAIceZu++?=
 =?us-ascii?Q?EEu0m3fCbcw86EugLrvcsUktw4jxyoJGuChf6U1BdKHtaD32llkqVvSv7Foq?=
 =?us-ascii?Q?g64L+5vAQpjgvKBQcqyqerq5R1IG0KAzevePeS1g/xoLCdGpGTDGqDmMHB1h?=
 =?us-ascii?Q?kSmGUmCy5OYA93NXHh+DP6yBRzBIklV/3yMePw1fQvQ01NIrSX/Ol7jMi7h8?=
 =?us-ascii?Q?1oYBrYO+J0ixpDqLOga+HoWcFV1Xy+yW8GrRBA6FbOdX+ScRw/mLgHT3Yu6Y?=
 =?us-ascii?Q?m5Mhid75K6W0egIYNwudtZE1kBzTyhLunGGErhSoKLAQ0jBJDkv6C3ivRd/Y?=
 =?us-ascii?Q?/4GEuDb5TUkU3aDRsObwdfxNRAQT9lrlpBmbLVuynwCx3QhBF1UHETE9n1ty?=
 =?us-ascii?Q?DJ1DNHe0dgYQXjmjDtD0DXn1Fe/8jM/GzkPuVPO3j/8Y+FwmACWss4JwPtTQ?=
 =?us-ascii?Q?mriuNev85+CZDXoD9epRd899uXqvuBzKMLQ0pIhOgqQ/fLqMG0IiQuqM1FpI?=
 =?us-ascii?Q?x6QNrb/8iAji4JhCZ8wOAn0/WV8nMz6Gi5io?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2025 23:43:22.7276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be6ef38c-f3ff-4b85-3d12-08ddce308a25
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577

The SNP_VLEK_LOAD IOCTL currently fails due to sev_cmd_buffer_len()
returning the default expected buffer length of 0 instead of the correct
value, which would be sizeof(struct sev_user_data_snp_vlek_load). Add
specific handling for SNP_VLEK_LOAD so the correct expected size is
returned.

Reported-by: Diego GonzalezVillalobos <Diego.GonzalezVillalobos@amd.com>
Cc: Diego GonzalezVillalobos <Diego.GonzalezVillalobos@amd.com>
Fixes: 332d2c1d713e ("crypto: ccp: Add the SNP_VLEK_LOAD command")
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 3451bada884e..7843973ba4c6 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -233,6 +233,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
+	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
 	default:				return 0;
 	}
 
-- 
2.25.1

