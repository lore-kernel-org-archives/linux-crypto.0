Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012000.outbound.protection.outlook.com [52.101.53.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915D43019A6
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522454; cv=fail; b=s32/k++FZwemfzPwaq8Ztx+cmS5LXvfL2LOPZZGGpbv11PAY2kLv8EX9cd+M2hG1oIu8u6rSNyw+kEDRKpPfHkxnelR/XOlpVedl9qx+s0/+BCBj/NXLgmKPPhfsNtpK4pXMMTBjIUMNTYHnCcEpL/HUvQ63sF0t5X3JVCctHjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522454; c=relaxed/simple;
	bh=35uKdkGhIFwvqd9mGWuc/7OTV23+OlaOlj/peY0PMf0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y4eaMS8OtVxHl/+BHWxeacIV+Xepd5xn9Y7N7J4t97cDutdAGAtz9ir9aYf5XCnWDEP1HAwUZkQyUfZqWu0nK2YeY8d1P3PKWItwD6Gvv8Emfq/li7Ny95x4tiB5A31o7/JVp/NhXaLFD1mFSXtQAwijc270rl1Sj6aw0MrvX/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KngH7Lv5; arc=fail smtp.client-ip=52.101.53.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KngH7Lv5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oi7m8AF8kzg5TCKdHDLDNuAf+Jyq96wbnDAHtH9jj0FAsGAuCGBnnlQXV7LhOVKM//8wTew7XTybRFv04P8tzQIQj4ZovshwkVg8+qO2jrtb2hVr8PYIAeNxDTDaPvYuJ9iFC5iCqD6G4DS4vjF7+nrHT3lOvGJris3HlS81MD+AgMK/6BBNcSgYobI5BpB9L53Pjd/Fh8upJLhiaXO1zZOY1yvKoF2m9lpcE1I0cPQDd8xSxCTL2zOFvBaBh2FENYzH5OUzk36rVifVpQBZWiP1MNyLPYG0zF+NwDjERmr95q/PzoNFUHSirAF5ef/MRc8VGo7T1bG6Ui2DiwF+cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1a6tSSZpYKwqDFMVFTHdaEkf859zFfw/dqAIeBBBDzA=;
 b=VvRfQ/QRM3jeCINDnBia2alQd1mqVUIQuFC/aRe68YM6jqEQ7uCJL5WF8BOngPk6XQVK8ZznQoL2/+nDIu99lMkF1v3sJDTpfX383uT8UvzPpcSZVcphr5kWUGUvQ3Uu+UWTaGSv6pjZ+xji2FEDq6FCQKk44+vMxaDZnpj8zzgUa6P2Av75H6YLIyeeVzxXBhwx/lTrEHTdvqdPHfQnnloD+w+dw8qHdXOcmMP3Xz4IOJO6ZWEPHtdeV/HNUithiiB+UkUwik6ji+t46bpcE1gJEuGDQS2hJqfLnXgxGMjiI7Q/wMTHkpEhOCuaaWp5ZreJD9PDOBT4G7snd2ZBqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1a6tSSZpYKwqDFMVFTHdaEkf859zFfw/dqAIeBBBDzA=;
 b=KngH7Lv5oEUeLCCwEW/kZ6TpjsvHbaxCAGojvoV2qG9ZQHbSbULHNNaYgdXcm+A0+8Vy3qOXTP27ccI+zZI8iMt2UABRfoovF5MHMotPnxAQneoXYkzDDc7L8keeKKitoKrEcNr03Y2QoNzw0pelg8pqMgaNVFL8vsQAhytIl+A=
Received: from BY1P220CA0026.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::17)
 by IA1PR12MB9498.namprd12.prod.outlook.com (2603:10b6:208:594::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 07:20:49 +0000
Received: from MWH0EPF000C6184.namprd02.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::ff) by BY1P220CA0026.outlook.office365.com
 (2603:10b6:a03:5c3::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.22 via Frontend Transport; Tue,
 3 Mar 2026 07:20:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000C6184.mail.protection.outlook.com (10.167.249.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Tue, 3 Mar 2026 07:20:48 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Mar
 2026 01:20:46 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 3 Mar 2026 01:20:44 -0600
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <mounika.botcha@amd.com>,
	<sarat.chand.savitala@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 5/6] crypto: zynqmp-sha: Save dma bit mask value in driver context
Date: Tue, 3 Mar 2026 12:49:52 +0530
Message-ID: <20260303071953.149252-6-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303071953.149252-1-h.jain@amd.com>
References: <20260303071953.149252-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6184:EE_|IA1PR12MB9498:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d85d5d3-8738-4da5-75e3-08de78f56487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	L1E0dJicO5LUo1dM7GUdBPVzraTW3cOL0PO/idrmGrzIdvln4Khyf0s6fkqQ96bp9WBElOBav+XXzZaWQGEXtI7guRS03BTuZazux4CR/57MDJjIiuGnOdKuPPqIWnjEwS/oVK0V+AX/+OqgbY8is1SELE7qea/ILZo8xZerOV4XSFTbX8nQxT9TjGe1l9/rppakzMebMhlpt8xVuBz134o5DDipkJRFTHrjkUZCBiYplnK55cLW8igcWhnosgijy9mHaPXwtyrqW0fBWVBwiD7cceWkmh9vp3oOnK4C+QTmr7BShziO5lCaSCgWWQoZllYNiF9U0kRnQ7JXq540aR3DZbW39cfdTV9uGvehspeD0wK9eAgGR8afxmhu/NR5VUV9uGYXBlCWdIsSQWp48VR/ls5US2opoKaMB2o65Z06LaMImTOiwMPcuXt62L47OV1KWeBJhI4XpRcCZZiOcSaazPkzCydQ1y7FJAaPHy99vRo0CERCiwV3hxBrlMGU9Z5GHc2RXhAxP2ywYttayo3Ix8TQe1hjtvQkjpchWnZ6Rh3nMbp10SEmbgmco7iiwDixsLrwJXo6pLY9q5R3Y5JhPQD8jmveFllnJS1F75OZrs4dpxCMUbwfW8SEvoGlWlB2/crgNsNQXHXkkipbRHK2W3vn6oBeYp36u+V4z+NSdBrmNdYgwaomoNOIoBCdbbFTvwJWdAkbgLoHRznOaWKMXRosWgxBmWgYwODPZ9AEXTrIiRkfFkpi/edDNpOaF2f9/hDoIVzDkFiflyaHp4e+eQypnd7PVFzAMCTIiEQ0m9WX8TKaM9gFUSmtOCSQ
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eb3S+2rnjAoYN6dicQ+TMm6bQ2MX2lsOe+99Upy/+mOGoK4L4AIexY+kGxwWUNwONJ7QnkcbaekJFESpaigGE6VPKtybtemIroKqEC8z5F56vdgs33pe/rEMMpJTJ3EFFneDU2824XwKCZDunOt5PotqYJ2FbTp7ic1YVMcLgH+GDrjsnzItSafWZYisFPd7dNXrpQOgLnlMVyU/lpjJFQ55Mq/CF0OsUDJA2AHJXWXqA8tyIjRIut++r4ogQR3q86RlDjdUNF6s8AQlWCTWc5Mf9pGZpOcfojXkH9YJrADaFzof2cLMRRII9cjbzth+lcqmiT5rnvJLKlAiNsw64jC9S8534g1mXaBnn6wLR2/TSLO28Km4NPBjX0WC98sAZfdCLweE49OaRAK1mpeP5I7TrS60J6r9y9h8uPCFDg51Mv/V+39inRJb6I307j8x
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 07:20:48.0770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d85d5d3-8738-4da5-75e3-08de78f56487
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6184.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9498

Save dma mask in driver context. It will allow upcoming Versal sha3-384 to
use different value.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-sha.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index 74e95df5eefc..72b405758200 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -31,6 +31,7 @@ struct xilinx_sha_drv_ctx {
 	struct ahash_engine_alg sha3_384;
 	struct crypto_engine *engine;
 	struct device *dev;
+	u8 dma_addr_size;
 };
 
 struct xilinx_sha_tfm_ctx {
@@ -248,6 +249,7 @@ static struct xilinx_sha_drv_ctx zynqmp_sha3_drv_ctx = {
 	.sha3_384.op = {
 		.do_one_request = handle_zynqmp_sha_engine_req,
 	},
+	.dma_addr_size = ZYNQMP_DMA_BIT_MASK,
 };
 
 
@@ -273,7 +275,7 @@ static int zynqmp_sha_probe(struct platform_device *pdev)
 		return PTR_ERR(sha3_drv_ctx);
 	}
 
-	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(ZYNQMP_DMA_BIT_MASK));
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(sha3_drv_ctx->dma_addr_size));
 	if (err < 0) {
 		dev_err(dev, "No usable DMA configuration\n");
 		return err;
-- 
2.34.1

