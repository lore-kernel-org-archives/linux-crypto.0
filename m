Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012020.outbound.protection.outlook.com [40.107.200.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E942DE719;
	Fri, 21 Nov 2025 08:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763712537; cv=fail; b=rxz2LHG+bRZgbV7qWN/2FMJYrDtXB6SdJbUUkQd5OqZ6RTNPxDMkzkAW6vr50eAA0B8OAksboBvKfO+nlbDuFK61xYx8ySA8xlz2EBJ69sPF9hr3mcXTDgEfReXYXuAHjOgzCjxDBnT2GPKLc04Su29Z4EHn5Fx6pzFpc0aWR5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763712537; c=relaxed/simple;
	bh=of6eDeh+Ayp2Ym6RB98ftLPufzlBbDyL2hPnWlTHamk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UkGURp5WwLaj0j66UP0yu/Nzuuf67lyq1B8aQqbG/QDSUJ1eRuvj6wqLMgBASHXE9xxrj2MKGQvjvS9n0VT4oz+poFyYd1Vgbp1Gs1CaBeRTORCCvZBafko/8c9sRQPQ8n8KM7I0WpSIv+wHSi4T02oj928Xk0pTdLgIZycoe0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LlJxyi2r; arc=fail smtp.client-ip=40.107.200.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LlJxyi2r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TdVlRiJvQyOioosBXc9Z1cx9T1y4v3OmMhKThXxZMBX3o34uTk67Jmxd/onV0AMvOkF3oXoY5/rCCebIJ6niD8maP8lob+TS/Hr8z3309CG1GJaHBWur7g3eHkwf5aYkCHdYHB2W4jgMoVtH5193DmmzPAUQgdrgJ7vCsM4fpTpV/eZtsvOc62zKdHn5vS2fuz+dH29rkn9/h3SUNSQ8gytNM4EPWVMeZkusIbUPBG1dWJidY5H9VGWogwBw3rGTsPCA+dKEsxJwLXHTuDTwu4Li6HqwdFMRSd0u0etGyCQAZgx17yFSL5noNUkH1kM1SoomD7OWLR+STuOFq3W64w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=000nAwWv/D4KpbFuG2buv6PGScLlDcNooq66HQwfwMc=;
 b=C4QVLB7H5033Su6OYpsAUvymkJIx1vmTtIVKLp+m7v5JDTfbBMT/F+B+YXSb5Pw/qhwsfPBbKIMHcgvCNF2tXRm70hiv/um9CgFo6fEW802HFksbEWl6gN0YsYvfMRja9Wxf5z8M9ZTXhRCfxyfDI+9bri2V4av+R6kPig3XxuZOdG+Wi7cMDyHtbyTALAhtxMEbLUttjjjF/IWPn6ZHebzuSW3KQvT77YrnGeXgr5Lcj13Ce7Y1rM0/1VHzLqUxNCVrJeCOJU813qc5NkBnCMSOjpp9qL+r4vue21dTNrDB7oDFlQ3osut2i0x9g3HvvpFmyLBCw7IYOo97BhZ4pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=000nAwWv/D4KpbFuG2buv6PGScLlDcNooq66HQwfwMc=;
 b=LlJxyi2r/joY7ioRTI/vuxfuQ8tsbkuC4UFUkEUJPdLNQLH+WHeS/NKMsZwALAgtfN+A+d2Wmh5YpeJN9H1xMIoykHo/Reu65l1ysW5P6gPtzE9blyQoSCTUz/KMQoyBq46KNDT88T3hJzFIozVWshy6TDSHuWbsLeR/9R7oFOU=
Received: from BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33)
 by DM6PR12MB4370.namprd12.prod.outlook.com (2603:10b6:5:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 08:08:52 +0000
Received: from CO1PEPF000042AE.namprd03.prod.outlook.com
 (2603:10b6:a02:a8:cafe::d8) by BYAPR03CA0020.outlook.office365.com
 (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.11 via Frontend Transport; Fri,
 21 Nov 2025 08:08:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000042AE.mail.protection.outlook.com (10.167.243.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 08:08:51 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 00:08:39 -0800
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
Subject: [PATCH kernel v2 4/5] crypto: ccp: Enable SEV-TIO feature in the PSP when supported
Date: Fri, 21 Nov 2025 19:06:28 +1100
Message-ID: <20251121080629.444992-5-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AE:EE_|DM6PR12MB4370:EE_
X-MS-Office365-Filtering-Correlation-Id: a64e269c-b2f6-47b0-6a0c-08de28d5353b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ehof338VbDwhaC7bamxF6rhHogbDuMGuey9dab0mTEX8bLlAyLSj1Hb0eSFG?=
 =?us-ascii?Q?vvgmHZa4J4sd4Tn4gRaupBdktMjMP7jWNteu2OI+VM71MgjeJRFFoJNIQXLK?=
 =?us-ascii?Q?cDc+MJEv+J2BUUqhuxzBtBc8zZV0Q9yM9G4pGN7qdR1Bt+C8HbfNOrmCza16?=
 =?us-ascii?Q?PkMjP8pOca1CDI985S6BE2E0RcAsrl/7B/kW8lG48ZGiPwy9ltUzf/y4F7UP?=
 =?us-ascii?Q?9rSsTgoqV457Uh66TvbOMh9rE2M+VUBJHl41OfqvCoNv8mhH3lT7+xIDl8fW?=
 =?us-ascii?Q?Cw8+m7wKJoMsZvbGT4JuEV+1qeG/0GjzJ3DZehseERSuzYbiUjdlphRxnQak?=
 =?us-ascii?Q?RxbqADaXWQrKQQ15edL4SeAJuRHI7XTqIpD/nijVFZv1GjiXRTIqwlR3MpmC?=
 =?us-ascii?Q?sGdlRcxa+J4nQp/JeprHyusvdma+k+K+pc6Og1XblwTIwMlrqJBbYofimwSV?=
 =?us-ascii?Q?FIPTLY9EqzY6lKkaHy9bUtB8LjRkN/A+aKkwPJ95le8TaqOyI6/k6TdhxFtB?=
 =?us-ascii?Q?bCm9IxBQAaeb/FaQUtKIevUA7xnKj83gQimU/2jmozyYzUK+v+jXI0hpKZQH?=
 =?us-ascii?Q?yhNbWyXxw88fgOzZPM93r7E9gojmIvNJEKuzQPIQ6iH/qXCbBleLod7oyaBN?=
 =?us-ascii?Q?SB0GjCtGdySNQFBawjbXz2tyacGGiRX5kWjgy4Ve+NXE+uHoPfcewMmoKduU?=
 =?us-ascii?Q?1ac18l1LZN1/YUWi3PAQljLB5hp+yWM/GQ6pktsharHNGreYD2ttZhq0YFuu?=
 =?us-ascii?Q?23Ml9Tu2drx0zGuqfaFBroEYNrIigJZco5jarSj5rFawaUY2jmxX5dqg+hRH?=
 =?us-ascii?Q?tTBbuhIEkH1Ucx/bogXqf/7yzIy+G/3e8D3U6LVvZUUD1VV8crMZvZugPIOu?=
 =?us-ascii?Q?w8gDvOrYSlcH3KG7Va6YwZlwpOUhVp6PdRMgMSfip68FxxAVoFYa56njXtZp?=
 =?us-ascii?Q?WgSGAC5vcIPf+WncV0FxNOj/5y8ZGhWAPP+hXfCTlJFXbZ+8DBG2ogIUl4ve?=
 =?us-ascii?Q?79ohIv6yWitME6v0p82tPqdoTfCqvZoqr8OqGK7VFP3Pv9GEbwizgHcm7e7Y?=
 =?us-ascii?Q?rFmWW/A/X73VFqqrZkG3OL1CjhYNFET0dbiKG12ioPlACzzi1V+O0vmaRwKt?=
 =?us-ascii?Q?PZYQOsbxEWVv9E5yxzXWmK4c18jON9qA7hhBnHbC2Dz9XxIFfzEKK120eOvS?=
 =?us-ascii?Q?S3e7CMVaOO4cW9nnuf2jckqus9Qm8hK0O/LsgAeyON4MsHO6YJj+sukPFnCM?=
 =?us-ascii?Q?aBIm3tpBk3bjq1WUQKkDxiVpU6rSb8i3ym5HrW+a3iWIm/JAaC128m9ku0Pj?=
 =?us-ascii?Q?ZRYPST0Q0Ims3Sx8b046mhoJw3it3DK2Yr/EhJ7yh5aXOad9+WLdHmWN2Ur+?=
 =?us-ascii?Q?bHY5dPhscFuB+yhIXl35sAnvyFeVILH/CbFgjVtRbOHzy+6ZuBCeK43R0548?=
 =?us-ascii?Q?j1iG4gUlMGc4arKskYIl9+MOmbGplMUWyhEargfZzI/qrymUnQ1G1FOlKwcm?=
 =?us-ascii?Q?/8tZrvP0/1YBReZqE+tXuvi6WNPKHeA3phryuozg+f8V6jFKoAxSCuKnqmwM?=
 =?us-ascii?Q?74sPSeLrm9SSdzglBlM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:08:51.8097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a64e269c-b2f6-47b0-6a0c-08de28d5353b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4370

The PSP advertises the SEV-TIO support via the FEATURE_INFO command
advertised via SNP_PLATFORM_STATUS.

The BIOS advertises the SEV-TIO enablement via the IOMMU EFR2 register
(added in an earlier patch).

Enable SEV-TIO during the SNP_INIT_EX call if both the PSP and the BIOS
advertise support for it.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/linux/psp-sev.h      |  4 +++-
 drivers/crypto/ccp/sev-dev.c | 10 +++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 34a25209f909..c0c817ca3615 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -750,7 +750,8 @@ struct sev_data_snp_init_ex {
 	u32 list_paddr_en:1;
 	u32 rapl_dis:1;
 	u32 ciphertext_hiding_en:1;
-	u32 rsvd:28;
+	u32 tio_en:1;
+	u32 rsvd:27;
 	u32 rsvd1;
 	u64 list_paddr;
 	u16 max_snp_asid;
@@ -850,6 +851,7 @@ struct snp_feature_info {
 } __packed;
 
 #define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
+#define SNP_SEV_TIO_SUPPORTED			BIT(1) /* EBX */
 
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9e0c16b36f9c..2f1c9614d359 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1358,6 +1358,11 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	return 0;
 }
 
+static bool sev_tio_present(struct sev_device *sev)
+{
+	return (sev->snp_feat_info_0.ebx & SNP_SEV_TIO_SUPPORTED) != 0;
+}
+
 static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 {
 	struct psp_device *psp = psp_master;
@@ -1434,6 +1439,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
 		data.list_paddr = __psp_pa(snp_range_list);
+		data.tio_en = sev_tio_present(sev) &&
+			amd_iommu_sev_tio_supported();
 		cmd = SEV_CMD_SNP_INIT_EX;
 	} else {
 		cmd = SEV_CMD_SNP_INIT;
@@ -1471,7 +1478,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 
 	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
 	sev->snp_initialized = true;
-	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
+	dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
+		data.tio_en ? "enabled" : "disabled");
 
 	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
 		 sev->api_minor, sev->build);
-- 
2.51.1

