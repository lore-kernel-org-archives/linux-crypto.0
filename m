Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010034.outbound.protection.outlook.com [52.101.85.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FE131A546;
	Wed, 29 Oct 2025 10:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733413; cv=fail; b=IqkSGkfD6O7yl3uA8omDdY2y8PPwF4wUtgwpbw4dXM6by3PIZdbu+oPNEnY+szpevTKCdPWicuX4COx0mA+nSDYB1iEAZ28P6xeM42ZkIm9RPnwozffi/AOJCfviLihpSnUkkHhb0nVBL3zim3RKRIYDGtQCl9qeKuGm8cNqLt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733413; c=relaxed/simple;
	bh=QPSGN0Yk8OAIaFBbRMek5sAsi/tvjlyT7J3N9kz8Qi0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TyzP3ecGXMpWzRbqiyHs8hUnQRJftKS/Eu2af8AxxPa7tF1wCpKsQm1SDxjri8/tOGZ8NMd5/zheRbIkOYE8Y+G/9j7YvFNtGGreA56kwINlL6ndJ92hwFFjw+GDY/7QovE2B+JJSInLHhMREP8glgc3+lXK151siCOywX2+NZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fQR05tWq; arc=fail smtp.client-ip=52.101.85.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fQR05tWq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=THgeled2KciO2uDosqzRO+DCjfnKXGwiZV0Papm+HO0J/S6DUkiLurtER3B6gDkozKBFuFrZ9FvcdMrmLOf/oXW7fw6aqa9n7tpjhMFrKhDE9nHg8fa4I468M7I4s7Thc/phsTri2HNxMWkxxN9GWBp+RlFRpdpOebVYdQeqN8jpfVwa9cAgnQNw+pPq9zm5Z2q0o400Vn4mwOXgtgvcSSLeKbIJjNmkYuAchG5eAtZAIuDQzIo8g9EgxgdDirt+ms30TtXDeyoNP7DgiFzwVJvKszq4jQBPC5NX/H/COdSMdpEKkp/pcdyrGLVBza/u1ZGhtkhJB/ldINojEeLdzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8TwBqYrEuSc+qH5Pnt5sxeOyU9bxboqz2cu3FUY5hw=;
 b=werGyeX7mVFxkkPYk3MdBV4qbMUbofAiu8AuuBus3HglPGeh3drxK9J8U3MAQV6yckOxQMWyEwfA+LuVJ9kEloKsw0nlI6Z2t1I9n926+YldByD5Ilfz8CeJZUtxo2INhvRMTfPQeuxhm806vqdyvHL82Ou/8emIItcLHS5OmwmLXVonGrMniouIxdIqLVHudXH90w7+6EJ3G4LfsjJrpuS8B17BFXT44IaPzzWz9cfVZagAMrAL9f0Q40GUzF6ZbhghluxcJThpAy+VlflJ3tZdV3suGYYNp5jYceFH/jdpUnjpxB1V84yM3OeyUEXvGfSaqlTi8ECYrCOtCCsqvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8TwBqYrEuSc+qH5Pnt5sxeOyU9bxboqz2cu3FUY5hw=;
 b=fQR05tWqbNNU3tTLJBaU8CdZ3nMwlSczHbqC715ZnBoRlLvVsFMHCuq7ey6CI4mYR6u44LQx+Nd+zgCwYjnaL2lNuEGf8jdo/+xUp5bDgaesUkC9suyw51WD6ddIAMpAKiHYyD66yHEGOMpGlWI6qEoM4iCz4pTs8Mao22us7qc=
Received: from BL1PR13CA0078.namprd13.prod.outlook.com (2603:10b6:208:2b8::23)
 by MN0PR12MB6151.namprd12.prod.outlook.com (2603:10b6:208:3c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Wed, 29 Oct
 2025 10:23:27 +0000
Received: from BL6PEPF00022574.namprd02.prod.outlook.com
 (2603:10b6:208:2b8:cafe::54) by BL1PR13CA0078.outlook.office365.com
 (2603:10b6:208:2b8::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.4 via Frontend Transport; Wed,
 29 Oct 2025 10:23:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF00022574.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 10:23:27 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Oct
 2025 03:23:03 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Oct 2025 03:23:00 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 14/15] crypto: zynqmp-aes-gcm: Save dma bit mask value in driver context
Date: Wed, 29 Oct 2025 15:51:57 +0530
Message-ID: <20251029102158.3190743-15-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022574:EE_|MN0PR12MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 4456c7b6-8f04-4b34-84c0-08de16d53305
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IZnouQFZXxqCBzOolEUbyBIVNzA1WAJF3j+pbx+lYGzv6DFbS5OZ+IReHvcw?=
 =?us-ascii?Q?Mof/egJAfwmQouH8LcJ0CMtEjkiakDydq0yMvFm8hfpFPxyHpbGfmXFqHiso?=
 =?us-ascii?Q?/O2zadfjMHW1wq+nFPPv+TRB8/h/+PejvychiCgtnET/b/VrvaK+02WPw1Xz?=
 =?us-ascii?Q?IJiGlxnwFC82Kw1v3ofWg4hAzJH7R/czHs4CKcL5ATbqQlfCB/zK+gyXDweY?=
 =?us-ascii?Q?1/GmbASkAOLjAQ8KLPLrLORChubcn4HtymWMeaA/eQCombG86Mu2UIReoY6F?=
 =?us-ascii?Q?0GF1w/aFooTnJ0vCcD9bK00bkhwalbdbakrUnt4HvL5UKz8g1jHj2yDBrZwq?=
 =?us-ascii?Q?zfFAynTsBQIOzItO+Nu0SNkfBhXzGc7ObRpOrS9w6b38uRy7xTIMVCBeM7yW?=
 =?us-ascii?Q?0FNQkEWQiHvJeg5ioUjdj2wB0EKfzXjxAvSxpkbCqYj5BhcY4znSkJKr+tk/?=
 =?us-ascii?Q?b3cgJXyGyxvKpPp6NXrgvZUdpE7hDci+OY9+wUwsWXhpRuCj67J/m/mYvOdL?=
 =?us-ascii?Q?woxcV8L+jJXt6WSwrzezcu8GHwf1RSEBQsfXaGS6IOW3nigtseRDDkZJHSc4?=
 =?us-ascii?Q?zd1ZEoHZRV68fA85w9JiOiZuCnQsTrXciZJyOIIoLCbqW4MRvdfiSjPd5a0q?=
 =?us-ascii?Q?e+KfnLVFCftZYQN1OsAP0tUPpdIjTEYSfZ4iVtHgG8+a7urQuJ4cyg56w5Gp?=
 =?us-ascii?Q?jgkwfB57/gphg8K5hR+rDzbOmxZ2uQXxI2GMBbi/NvJ3oLY57Jbg4bfeyuv1?=
 =?us-ascii?Q?j59RCT2NwfOfH+Y3VrP2f6R4X4M5H8O9GJsqXPSOIFtOLBjp/jA9kp2Bvdf8?=
 =?us-ascii?Q?CPzrSBGUq9k/yn98EZhYTgDntrFw8NXkmR4g/2fzsvIsoFkgG3gFOD82MlsI?=
 =?us-ascii?Q?GXUuJ98kPub1W8GcWIjoJ1EOSYdIyAFGlYLUpnvSxMUfg2OZo7u0BEhBAqjh?=
 =?us-ascii?Q?P4rJ1hYbvDDKnBfbGnmbBH1cs2uCqcs/bO18DyF7R8CJ8x+vHmsRTAkbAFwO?=
 =?us-ascii?Q?XhrGiVuCrNidVNrvLBAYEibnYZ+YEeJgwOzzZ1nAb9IGsG02/VJ8TKB4AMAM?=
 =?us-ascii?Q?zMZD2q158jDVCqnwk3Z/Bz3plJdipPOkQQZjZLj8u+asK3swP3tTZJZ9SbPd?=
 =?us-ascii?Q?QNySQFVNxi2rR/a7z/k2cg6fNU9CZ5UtGKw8rov1VN+wCauFeJCTeJdX0eI/?=
 =?us-ascii?Q?Rnh+5OcGJ714zdbLkmA/B+uMHh0XxGQ5wAUbkqZ4MPXQC9sWK8ySC4AOxKer?=
 =?us-ascii?Q?NtrMeXS9QVLBci61ePw8A/chprfqgUchKq8XhMsa+qoFLgByZmV1fNUcLfXK?=
 =?us-ascii?Q?CBYUmz3VRIAkw09+QLf4Df6pu9XPJoyVmP7mUCco2wbY2t69kNjZo6nOlOXp?=
 =?us-ascii?Q?DqE40MJsAP6LbVJj01rd33EoVc13/dNjDXPQd3MlpOPIx3mm8NdvqWfdxQUc?=
 =?us-ascii?Q?ZVBz6Jo7KFZq9G/4xavSgDQCw4fq4nw4bJoEDISCyls5F1TsCnZJIGefTnZN?=
 =?us-ascii?Q?OQRmD9SLvOqz9XUr5YUACUSutmD7vGKCjWaco8as2ckGzSzOhI8oW+4AlcYy?=
 =?us-ascii?Q?Aj/8EnYpWubeww2ZEZ8a71kACO+gVkhErAME3RtO?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 10:23:27.2593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4456c7b6-8f04-4b34-84c0-08de16d53305
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022574.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6151

Save dma mask in driver context. It will allow upcoming Versal device to
use different value.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 6bc5dec94884..834852a042dd 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -44,6 +44,7 @@ struct xilinx_aead_drv_ctx {
 	struct aead_engine_alg aead;
 	struct device *dev;
 	struct crypto_engine *engine;
+	u8 dma_bit_mask;
 };
 
 struct xilinx_hwkey_info {
@@ -424,6 +425,7 @@ static struct xilinx_aead_drv_ctx zynqmp_aes_drv_ctx = {
 	.aead.op = {
 		.do_one_request = xilinx_handle_aes_req,
 	},
+	.dma_bit_mask = ZYNQMP_DMA_BIT_MASK,
 };
 
 static struct xlnx_feature aes_feature_map[] = {
@@ -455,7 +457,8 @@ static int xilinx_aes_aead_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	platform_set_drvdata(pdev, aes_drv_ctx);
-	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(ZYNQMP_DMA_BIT_MASK));
+
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(aes_drv_ctx->dma_bit_mask));
 	if (err < 0) {
 		dev_err(dev, "No usable DMA configuration\n");
 		return err;
-- 
2.49.1

