Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013009.outbound.protection.outlook.com [40.107.201.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5773C2E7F17;
	Fri, 21 Nov 2025 08:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763712507; cv=fail; b=SoM8Ff9XGKNbt+VqQLYS/knHioLKCRhaarH/F3n+j4xh0x9lN50mGkvDqcIE4heAiHnkdaYZv7wge9Es18ebzPfnmSif/5Uldya0vtTsBmFE1s3+Whxb102djmNrdbCNGPjfwuWOQD5weAL45vNdvbSyvESEIqSkb9FiQbJp+L0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763712507; c=relaxed/simple;
	bh=Tpk+JjEkqqzHKrC0rWwdYLZJWWP37Nlde339wCz0LkM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YlXMWoMR1ezY5CKQkMx1+xB81kSRXnAOPrtNKcbom767O8TqYJ4uN0axCmmkgV7y70MkAHK5Hu35mFR27H2my0neWBh7JioFqdnR2T7LePRNUe8wPE4eiEEIEeSYegEmUxNO9R8i/KMISo0Yvcwe+hAN+2SNqBcoU8ZpqAlym9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XqhgEOe8; arc=fail smtp.client-ip=40.107.201.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XqhgEOe8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JxOGv3IjFNA3ieuEZIkdM0SN5IYq7YkF/l4Q8MWw6eOrv/oFEz4QsxX3KTnAOqRLXj9EXbvyU96ZUfxES1avJCvQgGlTYEpdZWBEP261mEOdWNUuzhnT1KLv6Om1V/I1p2VPqC6fJc7nLh0/9Jgnl1MxhDzpB5MU2BSnFVsG6j6UQ+CdAFMACgW8dnQg6J5AqLYfAakyVoJIoyKlkZhUHhXwnZG3uX7I++U4pOlsHExygicUrt/L4AuqGwiLhEnWlT6q0dxMiGjHJ0OenG6hj/854h0dCC9f9aIhxUqTF2WG1SRvBr1QOAELewR0O3h34zL4yr43XqeTUioVuDzvGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTCW9vMS+OKj4a4kAiX1B3dxybqcDaJ/IMvL/pBlFfA=;
 b=ctkAxUqGF5wcrGa/6BLnNYVjPaJ9YBuLZoHDWhWEF1/gBe5+W24t4+ktSz27IB18+USCJKrpy9m3NuMB6mI4K2+hgRTHwwDPJG52iTbaRj/ICNtCVV1DkMsOOB8Z4SWJxheewgZSgVyp91n+KYW3oBNgojThUJxXh4q++9VSaMHGVaKVB5mJJfTh29Xai1W5jS3lTjwgjcVgKsn/6DbXsdbIQLJh8HULN1k/ASIOVamw2eVf75cRHr7gKVz4OSpYjfgx2J5pihqW7iQoJ1CIXoyaY9Apr2w7/y+xWiKbS+NYDJfPOz987MZO7S4oBtXMG8Yi9m0tRY5Ul6s3z6ZcOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTCW9vMS+OKj4a4kAiX1B3dxybqcDaJ/IMvL/pBlFfA=;
 b=XqhgEOe8Sc0BIF6rupsGNLEn8gvEntJIVfYxbMppuHu2AorRS3C01hgr5BO56d9/VosaGveZzevFsSe1vvorzcqwgBurIGG3tAkWJNpwAwek/U5fwHZyc92cvqtD+h+GRgowArgd0ZxeOrAcf7Qsx9ZsPhuZwSW7xV9ggWO+Irs=
Received: from DM6PR14CA0064.namprd14.prod.outlook.com (2603:10b6:5:18f::41)
 by SA1PR12MB7412.namprd12.prod.outlook.com (2603:10b6:806:2b2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Fri, 21 Nov
 2025 08:08:20 +0000
Received: from CY4PEPF0000EE38.namprd03.prod.outlook.com
 (2603:10b6:5:18f:cafe::c9) by DM6PR14CA0064.outlook.office365.com
 (2603:10b6:5:18f::41) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.12 via Frontend Transport; Fri,
 21 Nov 2025 08:08:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE38.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 08:08:19 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 00:08:07 -0800
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-crypto@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, Kim Phillips
	<kim.phillips@amd.com>, Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, Gao Shiyuan
	<gaoshiyuan@baidu.com>, Sean Christopherson <seanjc@google.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>, Amit Shah
	<amit.shah@amd.com>, Peter Gonda <pgonda@google.com>,
	<iommu@lists.linux.dev>, Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel v2 3/5] iommu/amd: Report SEV-TIO support
Date: Fri, 21 Nov 2025 19:06:27 +1100
Message-ID: <20251121080629.444992-4-aik@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121080629.444992-1-aik@amd.com>
References: <20251121080629.444992-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE38:EE_|SA1PR12MB7412:EE_
X-MS-Office365-Filtering-Correlation-Id: 3178deec-7d76-4099-39b4-08de28d52221
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cUbkbzbgYfHcZoyUsBaRDDRvyt8phfrUHV2UajBmbT/wFvGiZIcOUckZ9FRR?=
 =?us-ascii?Q?ggWARPg/k/2FevRXkpM1AtjsAysj9dvwgJNfoJj4W/Tiqc+aREwAA3xRgyf7?=
 =?us-ascii?Q?fFjn8wFGwt7BriKbnAS84BN6wQZxYHR7a1igATRx8sDN0FDw/dn0WtpUageu?=
 =?us-ascii?Q?ZBai3ZWXjiCSXK7EmUeDWSmQYemjCjtgIF8Va5t56LD3RmaXaFvGglhDyr6j?=
 =?us-ascii?Q?YetZWnfagZGNoPZGgmFPXwNkF3uVm7ilVXUZKdVxxU6qAJcLsegA1hZU0xdv?=
 =?us-ascii?Q?6VQSOzGhp8lV+T1bzRkxXn9OhVqd+pz0AI+0ERRHH1ISBQrRKItZjYcnemtp?=
 =?us-ascii?Q?JfV6PbS2149OQrDa3p4Fm1lt4A0+fRCLgyWyZQbbuozaU7JvgpcnQ0eLvC1m?=
 =?us-ascii?Q?AGDAfkzplbS8n3Twyr/QsD2b//q7G7t8kU3gZ6XdAubXWdrWkB/rh9rw6kJD?=
 =?us-ascii?Q?lTw8bBfPQ7pqNqnC7+dKLrPFRm/at/aW/u6aBigCiCpjkhZYam3R74pHYuDN?=
 =?us-ascii?Q?uvsOkUxbphF+jQczX5sa3a7XZ6eTp+e6voEh/0RWKvh718PMQNkdXspew8Xq?=
 =?us-ascii?Q?6fmIxs5U5XeL89KXlu/9YNpegYDLawKQXjFqdGoWw1xVjCg1rHjgxZGzBvsP?=
 =?us-ascii?Q?n/apWet/8QvcqdCWwx6bdlLJ7BgNcSGhkQYyylpQejUOHhOZtM6WjVomt4PU?=
 =?us-ascii?Q?6WB6OA5iwk/surh4h6R9nbvDbcdt+SUx4svRf2MFlbLhGl1YHCOLoWSAa05F?=
 =?us-ascii?Q?opfoAaA8WbE0DT6IfoV0FiLuCeO4mwCgZ8+i2rHljQMoi/U6gWgTQxGHJGuK?=
 =?us-ascii?Q?QqfK7bQ6u5R504q0e5q8ot6w6bqfeGvA0kSnLRLEudryyN+CXkK32iTjTXDM?=
 =?us-ascii?Q?ZbPZ5LU1LYDI+InnzDxJmkOawPAiOsmwVcSua8c+T2/HOEF7l+Nv3g3Xe1Fm?=
 =?us-ascii?Q?Md79ekCz1Dq5Nq5XrhDL8PSgK0iAV4r40uN8rGyDGzessPTXOnY8CIEQDmyR?=
 =?us-ascii?Q?jkLHnEnHlBVXQjZWVp7naM1VISuJKjtCGJK/8A57pUlFCbQGqoGgq2PWhgTZ?=
 =?us-ascii?Q?c1lGOZ1jqWPq8UN1syhsNxjPMKRUXtGbu4P/onO0HwKOg/zkgop2b4ZsE/+J?=
 =?us-ascii?Q?HZAX8pRBIWRA2R7xg8l7rvyvQ1TXGt5dbfN7XYQy6byDykIyxD/UvytXy49Q?=
 =?us-ascii?Q?tOeUZMkMHQAk1MOHpOOqJroA2AbBq0b3gi3iu+SndXvupJSzTroQ/vnCFlT9?=
 =?us-ascii?Q?HpJy+eT2XMtOztHRozc5qPSAOvoTcpS48KSrJ1ODQt3OpSKqximNnG2x9SMo?=
 =?us-ascii?Q?2ZefYKBk9shnPhfC35QjVYVWUYLIk2EEQ/DWD2ZhgureBhyJw6rp5oKaEm53?=
 =?us-ascii?Q?GrSQ0xAF1njo0CK4IxsTgwn9UCEEEapoQ4+gwTjJ0DixVfS07d9kT/PhNFc+?=
 =?us-ascii?Q?PkFSzM1XSgQAb+JU5LXuwf3BZl/bPmM+YsDPYcjACu4IIAIC6jKcAoENJ705?=
 =?us-ascii?Q?oQJxrFKBM09qZG3qiCDodZf/UlgIsP5bqZY0lU03ilMxwXTGpauEY2Z904Ds?=
 =?us-ascii?Q?77FIheaRmaXnywpw8H0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:08:19.8047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3178deec-7d76-4099-39b4-08de28d52221
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE38.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7412

The SEV-TIO switch in the AMD BIOS is reported to the OS via
the IOMMU Extended Feature 2 register (EFR2), bit 1.

Add helper to parse the bit and report the feature presence.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/iommu/amd/amd_iommu_types.h | 1 +
 include/linux/amd-iommu.h           | 2 ++
 drivers/iommu/amd/init.c            | 9 +++++++++
 3 files changed, 12 insertions(+)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index a698a2e7ce2a..a2f72c53d3cc 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -107,6 +107,7 @@
 
 
 /* Extended Feature 2 Bits */
+#define FEATURE_SEVSNPIO_SUP	BIT_ULL(1)
 #define FEATURE_SNPAVICSUP	GENMASK_ULL(7, 5)
 #define FEATURE_SNPAVICSUP_GAM(x) \
 	(FIELD_GET(FEATURE_SNPAVICSUP, x) == 0x1)
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 8cced632ecd0..0f64f09d1f34 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -18,10 +18,12 @@ struct task_struct;
 struct pci_dev;
 
 extern void amd_iommu_detect(void);
+extern bool amd_iommu_sev_tio_supported(void);
 
 #else /* CONFIG_AMD_IOMMU */
 
 static inline void amd_iommu_detect(void) { }
+static inline bool amd_iommu_sev_tio_supported(void) { return false; }
 
 #endif /* CONFIG_AMD_IOMMU */
 
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index f2991c11867c..ba95467ba492 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2252,6 +2252,9 @@ static void print_iommu_info(void)
 		if (check_feature(FEATURE_SNP))
 			pr_cont(" SNP");
 
+		if (check_feature2(FEATURE_SEVSNPIO_SUP))
+			pr_cont(" SEV-TIO");
+
 		pr_cont("\n");
 	}
 
@@ -4015,4 +4018,10 @@ int amd_iommu_snp_disable(void)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(amd_iommu_snp_disable);
+
+bool amd_iommu_sev_tio_supported(void)
+{
+	return check_feature2(FEATURE_SEVSNPIO_SUP);
+}
+EXPORT_SYMBOL_GPL(amd_iommu_sev_tio_supported);
 #endif
-- 
2.51.1

