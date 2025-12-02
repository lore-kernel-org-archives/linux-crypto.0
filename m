Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010015.outbound.protection.outlook.com [52.101.193.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87705274B4D;
	Tue,  2 Dec 2025 02:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764643642; cv=fail; b=POovTkVKUwYjTApK9tM1Ic7muj59k+v9Qaky6bVg36kklltchHXvhSCrX04tu65J3qihX/ZdEOOsXkdXrOgPGhJii5T4D94odAplPcik7L7fjCEQ0HAVCaXkeIYyJRoAbmEtU4774QTrGLCM2tZEI0aGEv0616+TGnoCy4WYM8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764643642; c=relaxed/simple;
	bh=CKG7z2irchx1a87B1Nge747jj+sR0eMABKkULQGGl+g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LjXXo/X1ha74C6WhHie2eFv6u0/+SOv9GT4MRaQWZwirCSZTWVJvihT+RXNQnsOi14M3vo+EcKi4qSjRyckIJHTXP/Bdfxfekc4ZLLfP+mjiamjM5BbnTEdXr2klUJ7MuJS8UyOnklBcmATGfgn/+2dS3/F7HogvHUie5ucGW6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L++9fqGW; arc=fail smtp.client-ip=52.101.193.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L++9fqGW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W2KWonWdGpNjjpYUIKKWu+a/upH4IUa54JqkD8lzYeEVph4/7E+4OvvrRNJ/+8zP0mGADHcEJpqP/raEGARvvniNdSoKcuTpWi/mHUwXPv78LoluuqX5NkX2BPAERGn+67Jbv48nfZXzyCpBbua/RcVopGBbpbvCofSJ4Cy9mZIdOFDgrGu4kQ8UcNByXhWnLwFuKh/b+gyMzvzp09mBaWjxUPZPbeoU5VADFVJ7iXzR2LCDUgfAKXSkzZyeZasP1I6eZxNdz+aZK51F1JlLwGQm51Qofxvc67W+CNaZaheLXEtT1oESfNQoTYrR4Gbksg5YpqMmT8nzxmIh7fiqXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1nmreBKEXo/et6r1Bl189ijsOkd+4TfzrMb20KVnQgM=;
 b=pBExqv8d2Y5iiMovYOTZMTRd/xhqPUokS7VAyuWHVyMQPjXkc/A2a8QoeqcWpzBk3xvgqE3XKRgByVxOwcbNngJMR7hOy9D38bfqcESKJa3tM88sY9JJdOeht/CIn7sxOKKragLZEYvkrgSL4DfcqmUPRCBGN9C7dJp0O9IWRIkHTiWhJ6cJbqvPOPzvnWOAkO2/nYamll9U81P+t/0JBKN49KoC+Ms888udqfiMALV+Xh6tYbkBiShL5pYbHozoP5/o0q1HCPtxg7gYXr0x9gyqqgCz/wqx2oq3VH4EjEITVVK8gjSvQx2roqXxPcBjMFgfm26wc+wlGQiXAOmZtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1nmreBKEXo/et6r1Bl189ijsOkd+4TfzrMb20KVnQgM=;
 b=L++9fqGWENaf2/NsbukNcEwT5ZP+NGvooWy+sPoA7CRgfxV2BctJZ97L3zBB1PB5d5QBfVcg2RlYCji88nGpqhS4DTBpi41EI4xzM4PuKJtLpm/ltzJMIo0sGzS+Hj4fogdf0Ug3Njq2U694RQoqyi4kdwxLkP+VKajWM68fL4k=
Received: from SJ0PR13CA0240.namprd13.prod.outlook.com (2603:10b6:a03:2c1::35)
 by SA1PR12MB8598.namprd12.prod.outlook.com (2603:10b6:806:253::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 02:47:13 +0000
Received: from SJ5PEPF000001EB.namprd05.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::6c) by SJ0PR13CA0240.outlook.office365.com
 (2603:10b6:a03:2c1::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.9 via Frontend Transport; Tue, 2
 Dec 2025 02:47:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EB.mail.protection.outlook.com (10.167.242.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 2 Dec 2025 02:47:13 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 1 Dec
 2025 20:47:00 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-crypto@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, Borislav Petkov <bp@suse.de>, "Borislav Petkov (AMD)"
	<bp@alien8.de>, Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Gao Shiyuan <gaoshiyuan@baidu.com>, "Sean
 Christopherson" <seanjc@google.com>, Kim Phillips <kim.phillips@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, <iommu@lists.linux.dev>, "Alexey
 Kardashevskiy" <aik@amd.com>, <x86@kernel.org>, <linux-coco@lists.linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH kernel v3 3/4] iommu/amd: Report SEV-TIO support
Date: Tue, 2 Dec 2025 13:44:48 +1100
Message-ID: <20251202024449.542361-4-aik@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251202024449.542361-1-aik@amd.com>
References: <20251202024449.542361-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EB:EE_|SA1PR12MB8598:EE_
X-MS-Office365-Filtering-Correlation-Id: 41b676f1-3240-4b1f-52c7-08de314d1917
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V8AZ1jBPeUN2sDQ97aWTHMbfEU0nMgf+HRm8bjGa8lyohtFfVHqVGsoRrXFj?=
 =?us-ascii?Q?8eyl0bG/gr9CFFehAS6KD6vNGxPPtemEzY7PDFTH09KgegIe9lobmzx23j20?=
 =?us-ascii?Q?kET6Q4mLRnhOfGM23wCVielhALDqaviOvPjLVNMlFHTUjntjkfAUXG1jhfNB?=
 =?us-ascii?Q?JMhS+UbXsAS7u5X3kQO/ljEZKFmnBN7E2/6UxIs2ysvl/ueWy1LRnIQx9+Ap?=
 =?us-ascii?Q?Mcvl8SE0fvAohep3DX0sVNO0xjkBAz+8H3yHb+Fj2Gh0VKYocJXOs9F2E15E?=
 =?us-ascii?Q?Ql7lejRRZsv+9bpsT7BjaURczwEEcZbqhQFAE+lusGJHsw8abErudsQfWJGY?=
 =?us-ascii?Q?jUZVSFR13rtRwNsl/PGw/wbRRrBN4prr4ovcVWCkh0b+89PbzzZhnRVm10mb?=
 =?us-ascii?Q?du9CEE9zpyrb51WU8bTEqSAZuQkTyN0+dw4hHC4Gnt/K+eo0thbz7Xs1ft1I?=
 =?us-ascii?Q?DUgJxcgmTlzr7KFlfokPpf0aOTYgApFPTtWGkkLhA98PoR3JxiqxbIxSLXSR?=
 =?us-ascii?Q?sXq5x7Tkdl5cLxxWRQ+QrHwz9hZgGdn9O2cEKHcsY5o1WSe3pNWMj6q5EMOt?=
 =?us-ascii?Q?4SCb0782Ytwh9nI0I7UBvgOHsAeTFifSbbhGAm8tOsZ0X9qNzSdsg+kaN+Zm?=
 =?us-ascii?Q?Rh97TBpsfgsi2NPpjvj3L2Rj8AK3I0jcYoW9SiIcozYnnlE6SrVjoKjUVZg9?=
 =?us-ascii?Q?KhYIJCfK231NXuXt/oJ4moscGTwbtsWAsUtEhsk1v+8qv9qmieYn/X6+hOpc?=
 =?us-ascii?Q?JzdXYB0BJoyhQGTGe3OuxiJ/kOH76x9x57VUR6K0iPN9rVjUg4YIR8G8XTEd?=
 =?us-ascii?Q?wrU3qQGKvb6TnCKi8jxjM3b6MohpW95D1h8S/U7xJQOjIbmY1thA2T1jHWIw?=
 =?us-ascii?Q?UwPZSGsk4mYnOi7pP4NRPgm7oUqFb7u/vQECnixu+W/fJsRLZ5hqEdd3u1LP?=
 =?us-ascii?Q?kCfzSPl2rWmN0CR5gaNRvrxUfl4ZaTr3r5nvDonVENqceIDMXKz4b45r8T/C?=
 =?us-ascii?Q?wtAQuMpKcNkT/n91y7Pa0FpMLzr5o8MxMfzfOibUp+0evX7bp0pFqYHR2QiM?=
 =?us-ascii?Q?fiQwpmRiof+OjENvoO/I16TD9cELuRGz2qfNU4OOBY+tddtsJsYUU6I+D8v8?=
 =?us-ascii?Q?6SWkq5p93NLKJ2T5J98Z/TGBwQRKOyhbFsOgYX7xmgQQb+wDC8FTOjfwEJFz?=
 =?us-ascii?Q?XtlQDuRCb3D9FQ4Ix/8mmH91bg3GAf03c7x7ZrmU/4Eq+dZyuzDgvPRqQ82n?=
 =?us-ascii?Q?J0wHc2nI69vS5HqAUkIRQWSF9Xukv9+bIYMHgm66bIJQvrHbVCQDEyYhVJSQ?=
 =?us-ascii?Q?4ICLIktX+rY7Fx96Op7oomiLNK/eYyCbcgCd+irOD2z1LkFUEJitK0o3W2RY?=
 =?us-ascii?Q?2mn5qxalBxpSkVTtSAVhgaHEHIB0pEkuhRI2PVvCEq9nMNxt1vcDFEMEEuw2?=
 =?us-ascii?Q?ABzkSCGRdmgEa1IhgAZMhIGGDdtAmEipk3KDs1rOWvwsCUSKmmPjmSeHNOco?=
 =?us-ascii?Q?2iDxPoE9fPBcaQxU3rZ1wB18ERuWtFEVLOub?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 02:47:13.5641
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41b676f1-3240-4b1f-52c7-08de314d1917
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8598

The SEV-TIO switch in the AMD BIOS is reported to the OS via
the IOMMU Extended Feature 2 register (EFR2), bit 1.

Add helper to parse the bit and report the feature presence.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Link: https://patch.msgid.link/20251121080629.444992-4-aik@amd.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
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

