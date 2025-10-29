Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011059.outbound.protection.outlook.com [52.101.52.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B152286D72;
	Wed, 29 Oct 2025 10:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733399; cv=fail; b=iYm1IfudUN9u998CgwUQoShJm2wtZhVAe+ytXN8+O6ya2QXSkSEjKLEMf26/zlngezPhSTY4TKhjoFlCHfXyXBcEgEkewGHT9pF8t7Ta05AKhVxdk2N2sgfRk5hMd7RS6618seAAGy39DXtkcXTOQB6oII8RsX+gD1pfn3fiDEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733399; c=relaxed/simple;
	bh=0bSzV5aCneilgI1E4ZI2+gnrhM/ud8aRF5HSZ2tlBT4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dzVz6taNWBIqAvdIZqSxP34WETw2vDyyZ/RoteHMAqeyN+khSSP+5gp9DbydYzM85B+DMQEMrrap1ma2PBTpTj2+Z6KumdCNsUHdTTF/0Ev55m73CbsxzgY71nEfDcE60BkyyTrMpVOw5DQPYouD7hPpVTJXoQEqdiaRnNw/Rc0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=swTp4wrk; arc=fail smtp.client-ip=52.101.52.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="swTp4wrk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kauT6I6obMhKKCRLaqtlc6GxU0jgHd8lnWMAxcqbokMQ4ZI85Ik+FOW9h/Hr3YOy4aYp0wUwyLJ/hOKb/fkhwg0zUvU7p88hCTtDtvUIcPUPIK0HRBJCiB9jc91ZQP12Tiushdj3WZorEQ0vbBU3+D6ZJ2UHL2E9+/5L6YQ2Q6BPjJWK8SQgYalC9n78UVSiqqMbqG2RVwkXH9UvItT9UHtmCGG9AnWmh8/pbnmj9Kdn6DI6agLoO5f1SurmUxE1nud9pHrzdRef3BFc67VI0YCibhEcMpdqC6sKBu0yaO4TPD7i0GYFwond3zsW+Rd9Mg/x9jYEZMXkVIN9YKZYsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MkNAgWcDloiSRF+8UfLBI228BfVc1z38APkTnr0gjCM=;
 b=eVDpD2xoCvHVQyFUAf3Mgybx3yAW2nEHpVs7aXw7WpSxur+BwqYivhhTazh5aAD2dP09jDzfqf7hMLpLesNJVxT9OVu9MguGY/YF0qSi63wfz+AAAbQZmNYxyA2RAMJo9/9WrPNHitnsxGCbOYFv4jlCskkTHhocrY4EYvJ8vriABfiARBRSC25TmYY5+I/oO1xGGxY4GZoD/MwJrN7vlMU+JcTDwT/dgWgzIYQmmk3jhIIe50FVF/Kgf7Yv5h+9StvcvP6iZOl5nreB2x9WsYz/zD8O82Q6psY2yVgOxCP4B0tJ84YoCAOOV792J1HHl1QRWeGL45k+N8KGpVr7KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkNAgWcDloiSRF+8UfLBI228BfVc1z38APkTnr0gjCM=;
 b=swTp4wrkBkB4BjmSaPc4u1aHrn1Tv4KJWXrbgxm1ROxeK0XWLzeJ0GEzAt7ZYD5LvgUtP3A00Dn11B+3FAjxgy5MjUGE1hz3Hu1ZDGE6Gr442v+czJbcQ1vXAXLgc6NZlH9aMkjioDDBH4fmi2deLnMpcQfDQXEh1WwdRGjI0qs=
Received: from MN0PR03CA0025.namprd03.prod.outlook.com (2603:10b6:208:52f::9)
 by BN7PPFD3499E3E3.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Wed, 29 Oct
 2025 10:23:12 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:208:52f:cafe::29) by MN0PR03CA0025.outlook.office365.com
 (2603:10b6:208:52f::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.14 via Frontend Transport; Wed,
 29 Oct 2025 10:23:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 10:23:12 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:59 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Oct 2025 03:22:56 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 13/15] crypto: xilinx: cleanup: Remove un-necessary typecast operation
Date: Wed, 29 Oct 2025 15:51:56 +0530
Message-ID: <20251029102158.3190743-14-h.jain@amd.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251029102158.3190743-1-h.jain@amd.com>
References: <20251029102158.3190743-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|BN7PPFD3499E3E3:EE_
X-MS-Office365-Filtering-Correlation-Id: 25da9646-d1d6-41f9-cd10-08de16d52a22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Vnll5qc1zojLBe/HU9WjusUZ4a7b3Ysi3U3EDC0a/xNxgbw9AfaBeZ05jAGl?=
 =?us-ascii?Q?JVWxVFNawFIijl43qYC5B8q/iRFvVYe1OXLkgvtSd5SYvuf2qlcRZFfpZP/g?=
 =?us-ascii?Q?bEX0iM8644swjNEmesGJGijVJ0WZB6HVYERVKRMdl14b0hv774DyRMraBtdJ?=
 =?us-ascii?Q?yAZCxMWR+h1B4Rkjp3+fUtVx8n+RWI43kk6TTXQa1Sqk+Ir93H/9uL9I/enE?=
 =?us-ascii?Q?GWhLUx8VaCX7ZiThXBexrp1of4USG9CugGtlU6+LnNsL5ug/vZUGnY5ogdr9?=
 =?us-ascii?Q?HsxpBesm/XKFhrKtXsQwDZoGGa2iZ2HG5HPv928CkS1S9jX9ifdYQHxUYGDW?=
 =?us-ascii?Q?PNQMXeateYTYsQQYvn3tR2IweRFsJPRI6M9koiOz+ApMcgj+eGvJL41UeUDj?=
 =?us-ascii?Q?SF7dg3f/19+J0PtOZ6aAQPnx28k4TLcXzAV9qtM71EojG27euB7+6HWyamOY?=
 =?us-ascii?Q?aEnP+OsxzDwmxehFfRfCetTXE1wHGX0uXejKkz2hEgXslh8243/XQjh+7s+/?=
 =?us-ascii?Q?PvZOWnVlKj9w10dPwKEOwQqEsvbVXvC1l+2CCuLZL4BBqvHIHsDY70bpBU1x?=
 =?us-ascii?Q?eTwbAW0FVbksjpbbcm0a2IipiZSHhKbbrd1oO0My79CSzIOiLm88gCSFJfPs?=
 =?us-ascii?Q?RY2wBBQLd0nQrVgQu9U48CUn2DR7XJACWC72Jwkqr9a3wiu77jiyFaBQ534M?=
 =?us-ascii?Q?ox9Ozvkes/fo/Or3jQKGBmmcw2tEgxi8M3cOdNUI9SsXcRpQbpjfc7VL+510?=
 =?us-ascii?Q?STkt/ampCx24aAc9YqkOfyXEZGogco6sA6cYKJLuj0RgG2benTFSFtCo5SC9?=
 =?us-ascii?Q?3mfOXBdBYGNPrtEkPYhyziVO0ffiKl/ZDn0M79rVygxtiJCBD2nonc5ArCa0?=
 =?us-ascii?Q?q5rW2EtIspK6ty3oSY/e1STRfmW08u8DexG0Gnr7bJiZTMa4g4YBHdRIQA4l?=
 =?us-ascii?Q?dV2/ACD+qm08XnLPHB5E2tWvG0vkzAeZKEZTiK6Gz5nkA/03pIKq9+xVLTTr?=
 =?us-ascii?Q?9JUeOtC6HwvmZn9pWokJ/L/dEAAqLbOZwkSNa/AZ73KDr4iviFTpFI1I+IQq?=
 =?us-ascii?Q?P4RCxaxJVQTONYBOJU59wza/Afrk6ifq+yC1NFal5LXS8MC2KB8nAtzMQs8J?=
 =?us-ascii?Q?kET8ENERt0+8ZD4Fpd5+I7KhI1dvddlXhsPouk+VJvTyqEr27Sw8uXg1kH14?=
 =?us-ascii?Q?2Xi4w5xEtqMZhLPxHNS6vf1zA0jihW2n4YhwW3mKQoNK/A7gVqOe2xUa1YLU?=
 =?us-ascii?Q?RxVGiTiasotg8irRQ2i0ZANBe3VRebY4Ck5Gu49h1/oQ0H2bHHk9W+StN7b2?=
 =?us-ascii?Q?oIgibm/nUh5DPyvJS23gmFWj49cDQtT4qRHb7Ps4t/FP+GYXWLepJeVIwlbl?=
 =?us-ascii?Q?2qb2JvinpUt+/isbwR6VOFUXdOAVV5k+dC0IxYqAnnAjQxpiGI/1q5M9HTCQ?=
 =?us-ascii?Q?BGlIfmCHTeLBd+Jv6YO6mZ3TzFBDVLre9FpMuHa5qg9/27cB4V4rdSrphAHV?=
 =?us-ascii?Q?vaB6Q+ZRb92hqJoKyYVCODouRzqOT7Crk8zrWCEOHaUtnCzpRZiGdcj36hpE?=
 =?us-ascii?Q?VhSqgcKBmU2y1N4prcLOpLkKcdBUqUBdzpVUbnSN?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 10:23:12.3519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25da9646-d1d6-41f9-cd10-08de16d52a22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFD3499E3E3

Return type of crypto_tfm_ctx() is void *. Remove explicit type cast.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index b0ebb4971608..6bc5dec94884 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -267,8 +267,7 @@ static int xilinx_aes_aead_setauthsize(struct crypto_aead *aead,
 				       unsigned int authsize)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct xilinx_aead_tfm_ctx *tfm_ctx =
-			(struct xilinx_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
 
 	tfm_ctx->authsize = authsize;
 	return crypto_aead_setauthsize(tfm_ctx->fbk_cipher, authsize);
@@ -345,8 +344,7 @@ static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 static int xilinx_aes_aead_init(struct crypto_aead *aead)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct xilinx_aead_tfm_ctx *tfm_ctx =
-		(struct xilinx_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
 	struct xilinx_aead_drv_ctx *drv_ctx;
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
@@ -388,8 +386,7 @@ static int xilinx_aes_aead_init(struct crypto_aead *aead)
 static void xilinx_aes_aead_exit(struct crypto_aead *aead)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct xilinx_aead_tfm_ctx *tfm_ctx =
-			(struct xilinx_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
 
 	dma_unmap_single(tfm_ctx->dev, tfm_ctx->key_dma_addr, AES_KEYSIZE_256, DMA_TO_DEVICE);
 	kfree(tfm_ctx->key);
-- 
2.49.1

