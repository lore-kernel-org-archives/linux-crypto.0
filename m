Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012058.outbound.protection.outlook.com [40.93.195.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4D73101A7;
	Fri,  6 Feb 2026 21:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770413237; cv=fail; b=lvzQsdZxGOnvPBSSrdM4O3LPTFEIGFWCHMHBXjyf15P05FirqJCs++nk683dMgzaLhM/UN7qxN2xFw4X8C9wOImcPYq3X55a3ugIiXoc5Fg2ToTPusHw/rLzmdPKUEFkEyYCf69OLIJHU2QAcwdaegCrVKHwTQ85ymvVrO32FQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770413237; c=relaxed/simple;
	bh=Z1kHdoK/Itb6a58TN2MaBjR2EuQHP9wTuKdBdFRLVV4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VbYQfyRCgAZduFJRYS1w83w8DzFl+6q9YblVseNTpv0MrGKMkKCH8cdhbOkpHOAslArNsluCmFH9vzWyioOoHMvWmf/h6k1q0nE6wzV4KSLz9V6Cx/1UazvFp34zd8Sxd1q+39SZXYPud0IuzvB6lb/UIEmvUbROgyfxt4d9xPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4rABlsd2; arc=fail smtp.client-ip=40.93.195.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4rABlsd2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i1dGWcl3Y8GlQfrAoOwnsVkUIzU9whUIGQo2yX833BnmplxS8Cuhqt1tbsiMskm8KXpXyEuNdULeGXoQMr13azQ9/cb5SUH5lC8bMdVs+BMfrFiM0eJ7vQT304MxHgtWB8mly1bL46ZVyxT0v9drVQeCK6zOU72h9n0S4n6UZizoV4UX0Sf2aYOnh8H6qOpHFpaKw0QuVIQqFb24Q6ZrQqCLTzNch4yu9L05kY2ejiZelS9XvZDLrROqT2ReiSfBt0ixSOdzlinRJ8aIxm73JV4WmdYSKyU/2ZDPavGT4pnDhvuvZDU4AKgv5lRgJr7w+4bHZSiQpE7uEMXq5UL6vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=coYbOXtAWsbIobyM8/6mr7kOad3pHSMjTNXJYnkslak=;
 b=Xn3mCAC3Gq9/aU+VIviwGz59jR5bvwJhHzfz++GKIhwJuFg3J7cKGmJdHfW3Blli+Fh3T9sTVIpAy+UvCb4YdKlImQolZDqVaHubi+PRhLH1BR6/WyCi3qiVwlepE/7fwZ6UwoY+7dfBN2GGeULAsIhjdFBKhINmD5nQ0nEQB2kSy8wnifmtVsWeoCzPh8JUp62t1+gWsG63kUMIMujVD8CUlXPf2G1uzhQ0GkgFtSAPyGvlV7nVYInkvxrbYktPfpqnzI3a5pgXtdub9xJy6rl9ALFH8SukuO/Ezm4Ym1tqEwrRVsIXswJxPbPCjfOPdtlNJqj9XcFpNddte8xj3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=coYbOXtAWsbIobyM8/6mr7kOad3pHSMjTNXJYnkslak=;
 b=4rABlsd2TQnW8VaUiFImx0GTa8P3beLssip4aK1jQeTBIzxngcdF5KvHR+ZRg9sIXczaCKLTagl3wup24T3TVpaOWMRbtpjYjTa3xtk/+MOsSifskIRc9mu1TgdQkLJ4p9uBWHOCXEWr0oZ+P7nnhDGSkQiMQ7q9jvL48z38op4=
Received: from SJ0PR03CA0283.namprd03.prod.outlook.com (2603:10b6:a03:39e::18)
 by SA1PR12MB9001.namprd12.prod.outlook.com (2603:10b6:806:387::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 21:27:08 +0000
Received: from SJ5PEPF000001D3.namprd05.prod.outlook.com
 (2603:10b6:a03:39e:cafe::6a) by SJ0PR03CA0283.outlook.office365.com
 (2603:10b6:a03:39e::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.16 via Frontend Transport; Fri,
 6 Feb 2026 21:26:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001D3.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 21:27:07 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 15:27:01 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <bp@alien8.de>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH] crypto: ccp - allow callers to use HV-Fixed page API when SEV is disabled
Date: Fri, 6 Feb 2026 21:26:45 +0000
Message-ID: <20260206212645.125485-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D3:EE_|SA1PR12MB9001:EE_
X-MS-Office365-Filtering-Correlation-Id: 08a8a317-3321-481a-0314-08de65c67b13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q+VGcXL55s6pZIH0lIsmFmbIhFvKrLQa3oFqwg3Lgx/4jIe1oNYZSTpGmb0m?=
 =?us-ascii?Q?Ort0PmO5AqNd3toJT67o/gcluJLNixNzbHDrkOPHQVshhkqFkm9xadPv1KXv?=
 =?us-ascii?Q?LhFb/l937ePaKD7eEekIWEm7KXhAQ+o1iAftsMxGtHYNfjY1RUvhnxrBXN4E?=
 =?us-ascii?Q?MXq3aCYn3zwAJSsfHfY9Vae9ve3/V4Zeq8gOau3Zf32Lz+P+0uDiIf05hxA4?=
 =?us-ascii?Q?yRfrc8gR/xpMDepl3oHwFVmC+gSvVyA3v3ddCsSPMaJ8OB+WepD1ifuWiHfS?=
 =?us-ascii?Q?unAG6mxgbJ2tSBE0Jx8iCA0bfn2Sx3do1HJQvFMORWUwvKwAbuwINaA9rXzp?=
 =?us-ascii?Q?H6bmuZgk5rZOCH3POBYIvu1M79tzQ+gGGwF23cQQL6n8S/IU9elPHUc6xeIu?=
 =?us-ascii?Q?DhkY9jrCVt56nVTdNtuYS3TWGwKGE+cmBHr9JX7gs/Rn8YRAbzsSLAA0y7Gh?=
 =?us-ascii?Q?Md8o34brYRc3i9dMHinecgnerQUYg08RLaq0gC+jrrlhaT9Fe00HPUH3IQ+D?=
 =?us-ascii?Q?zxg0B7hqsiXI6rCehlew51e2MLR7tCiJHpfSWBAJLAOwwixTnIwdWMyAitrX?=
 =?us-ascii?Q?NrA4LS4vLpro/C/5a9/UQ2lYVXcpzqcx254BHMZeVU5gujNRwhwoMtkzDMAB?=
 =?us-ascii?Q?UbPeQgw7dka3u6ryq0Dg2UoGEUmHocDYYkLMnBD+8vHK8B82d/M+369BWBuE?=
 =?us-ascii?Q?9sT9jZMUnxle8eZQm0KSs/lGRWyJtrRIZJUftTisQ4vybjFq7FyyEFDAFlko?=
 =?us-ascii?Q?TpBMrphoxRCaaMTJ9+NdCoEG7GTMSPxesJ2icHZujRn6SOO4gt/3JAdVx6Z/?=
 =?us-ascii?Q?kvQiYx1UkM6IquS3gPU6U+c9q7UZLKGGaz4aQ0GyGqQ6/soL5Rx9YJtvA24t?=
 =?us-ascii?Q?bYrJd0gltePPPZlbOP6I6fdH0CoTKRQNEhW+hAatXYaM8lOzTNJtUdBNOghm?=
 =?us-ascii?Q?6mvE3KyLQWaK9CHr3rH56YYcZCLzfdkQXUD7ieEnyXny6o7YdqWHL1fKwZky?=
 =?us-ascii?Q?Acu/7yhWBvP/SMUCtBMNhqvDeAPv0TAX/iQOtcPuBfO928YdzSBUgeSTtQHa?=
 =?us-ascii?Q?EMHcDRQe80YqrMKlhzVkLYsdVMR5AmXPFGntLCKnasF+HY7p/BwJesYHe490?=
 =?us-ascii?Q?9CDZsk7c8B/1oeXrSpCGxIvubKtEWnlMIl6nPVWFWSQ42jOXxxWFmr/jkYTG?=
 =?us-ascii?Q?dLp6kRFIHkxeddkAv+T9JAW89nq3KiuEa3o4meOcu1QBFJGJWv8nNn7A5DtC?=
 =?us-ascii?Q?vKuhZWJ3uxFmoy7fIFk48QwrR7yvLTRdlz4NQVKFilTaTg5TS/ObMVERac0u?=
 =?us-ascii?Q?oqNjMyDySj90Ns3HoPfFcb5bypQyat+f+Ao7THuO4a01f1Rjx4v8xpBWo0C7?=
 =?us-ascii?Q?a5wIaVEdhXcXzap5nhYMzsZGSMYm+k/c7WLx5DELmnu7L2uRyp+DvdVDXHd/?=
 =?us-ascii?Q?iO573c+tHHUS61EuKTeYbXTKis0yvrzK69hsbd+BwGibGJpLVarigCevBtVI?=
 =?us-ascii?Q?0uDGQVGayKxW0EH+JGcPn28yDoOG5W0NEzVb3JBZxsSkv596fw0PVSEexF9G?=
 =?us-ascii?Q?D0v4XXIs64NNAzuUA99gPWvVIXq+hebwxp3efGOwDsdz7YBzR3d7+xwZI90v?=
 =?us-ascii?Q?p6qbZv+K1audmTqepgGzJIYzN4tUix84LTMkbYCty7oc4vk63RDeIy7LgZEy?=
 =?us-ascii?Q?BBXFBA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nLtRm6bOjFe4Qe1pWdelviuwrrlcAHaw9KaQLIusVXDwqGsZAhVlkaXk7jItHsFYJeW1Y/66dPAKA8v8KTGuqp+KRCfPdntLiNG1iU8tOr/LLhiIwP7XvE1jvlpA2cJESP/KjSF7kpHoktvng6zHqfr5tX+XjjdteBlTEdzLz/BivYKlnbt65APQjU1Ae9R6WOGvFH6nPqDu0kKCAvCiu26wGa8zTA+YEQvfmVpumNeEGsTXbP5T2Q/0MnLoawngrXSHzjDg/Zp/XGb9DDKQHQsQMnrIvtb+jmxyBo4wMXBjstpvDJDbzRtLSspLLau50POYRuPfKCAbX5L9CDObOjbVlQD7udPDfSJWoqQZyj97QcxJvgNGbb+3SuhpbiJZg3F+DEp1bV77NeWk0fts20uNVkEE+h9H2J4lwi6yW6UPYEz0mdUkI6BSJMvUZabj
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 21:27:07.5242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a8a317-3321-481a-0314-08de65c67b13
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9001

From: Ashish Kalra <ashish.kalra@amd.com>

When SEV is disabled, the HV-Fixed page allocation call fails, which in
turn causes SFS initialization to fail.

Fix the HV-Fixed API so callers (for example, SFS) can use it even when
SEV is disabled by performing normal page allocation and freeing.

Fixes: e09701dcdd9c ("crypto: ccp - Add new HV-Fixed page allocation/free API")
Cc: stable@vger.kernel.org
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 1cdadddb744e..0d90b5f6a454 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1105,15 +1105,12 @@ struct page *snp_alloc_hv_fixed_pages(unsigned int num_2mb_pages)
 {
 	struct psp_device *psp_master = psp_get_master_device();
 	struct snp_hv_fixed_pages_entry *entry;
-	struct sev_device *sev;
 	unsigned int order;
 	struct page *page;
 
-	if (!psp_master || !psp_master->sev_data)
+	if (!psp_master)
 		return NULL;
 
-	sev = psp_master->sev_data;
-
 	order = get_order(PMD_SIZE * num_2mb_pages);
 
 	/*
@@ -1126,7 +1123,8 @@ struct page *snp_alloc_hv_fixed_pages(unsigned int num_2mb_pages)
 	 * This API uses SNP_INIT_EX to transition allocated pages to HV_Fixed
 	 * page state, fail if SNP is already initialized.
 	 */
-	if (sev->snp_initialized)
+	if (psp_master->sev_data &&
+	    ((struct sev_device *)psp_master->sev_data)->snp_initialized)
 		return NULL;
 
 	/* Re-use freed pages that match the request */
@@ -1162,7 +1160,7 @@ void snp_free_hv_fixed_pages(struct page *page)
 	struct psp_device *psp_master = psp_get_master_device();
 	struct snp_hv_fixed_pages_entry *entry, *nentry;
 
-	if (!psp_master || !psp_master->sev_data)
+	if (!psp_master)
 		return;
 
 	/*
-- 
2.34.1

