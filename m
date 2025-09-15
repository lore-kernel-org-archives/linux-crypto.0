Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012066.outbound.protection.outlook.com [40.93.195.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E1830DEC5
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 13:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757943055; cv=fail; b=pPyszPvWmHo+BGadwdyn6Qua6nT0IZaIOXpcH7+Pn92aFOLnUnXypB5yvPOlvpCVdoXj+DLTXGkor4aoEwwWt9oUVUZ9mLOqEAKOyxNBrHfzS+a93fX+Lc4dbe5nMX32m+oKzK62neLSbGvoDwBS8ro4lj/0bjLA7XPXZFaEURQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757943055; c=relaxed/simple;
	bh=Pp6wp3QFsbR1OWe8oOUoeWGE4YmEz6YYr1IM7R3dPYc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OAhM++pOKUTQHjyh0WD2SoQKHuGWEOl265LudGD3WRL8IIkmF+2nfjieeKytvtYOOz8Y/I5u3nZ47LONJVVSTqrU0T6Q+52NzEbxMut+zA6IpZqv+w0RSVyTKC2HjprtmuJI0feTqtEYoSNRtQB6DOnkOn/tCzgdnpf5trtVfNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xGa2I/vb; arc=fail smtp.client-ip=40.93.195.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xGa2I/vb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R22vpaOTQ3CyjfFdhKQkJkN9M6vUvd4XEH/RtqRsIfu2H9otOWHAQQOnFvEMBpKRgWhkHOpOC91884jWRjb/ZcEsQStEUs3yNzX7KFutzakJ+zQtwMAbXyBsrQzCLoLKztR0VZsjNn4FUzdtXXGYmDOY/rofQDl4j6QvfIZQ6U0hTSz1Nr3DvDyCFJ8JTUU1f5eJVjdOchOc/iYBLOBwmxBdPYrUEA1j322mIBuyBY7g11zCgJEN2vjnQ+YA0zlTXxLfp20yQVjRpXzh9jUhBya/W66kesg4tvXknEUwsmyXcF0iccf9+cWpNuUmaDsqlphczlATxKdmVwEKDd0K7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8CR33F/pFU7/fXpwpx35hqHX2tujlw90HPLY2XBqrk=;
 b=yMZ2QpKAdUfhlTyeojQZRgVzOhNzNnNXxGYbNZtsxeQvroGWs9WXtmu6E8eh35ySxzFAxNsr4cycvcGsgFmGtLU5yfjzeGTAI9xWRCex2uTGf5tJnOvCmHr0cvawwxLWPSIthIrFSzhDExKHn2rGEsoF6IxMOLPgCCeRzxYMbTGwFdVMmuuymFxxyf86m0PvUsbpxLqngkgL0/DPg/hheYvQaUD341SGKkuRD87vplxku83mfN4Lpfw4oiX+Zgt3GTN+0ZkRRyGhTqWZhMsY6CTnk8ZtyV6hjPOq+3oLo203YVnPJq043l5YVeI4j2WjxZFQLXvYi8/k8JSfwxarAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8CR33F/pFU7/fXpwpx35hqHX2tujlw90HPLY2XBqrk=;
 b=xGa2I/vbAk15cHP3iSZMDasubu1k3AIye+tiCWUpgG2PdH1pLTSuiFsZeYCQJPlhb2EvbQmaJAjfI/TZyr/A1Oa4AzlRGI6V9oFfx7MG0/Ey3xHoldypnyD9Dd6EyK4Z43Vgqx549rga6yHiwqrpyQn+nP2xxpgb24H9JvIjQnU=
Received: from BN9PR03CA0933.namprd03.prod.outlook.com (2603:10b6:408:108::8)
 by MW4PR12MB7215.namprd12.prod.outlook.com (2603:10b6:303:228::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 13:30:49 +0000
Received: from BL6PEPF0001AB78.namprd02.prod.outlook.com
 (2603:10b6:408:108:cafe::cd) by BN9PR03CA0933.outlook.office365.com
 (2603:10b6:408:108::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Mon,
 15 Sep 2025 13:30:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0001AB78.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 15 Sep 2025 13:30:47 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Sep
 2025 06:30:46 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 15 Sep 2025 06:30:44 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <mounika.botcha@amd.com>,
	<sarat.chand.savitala@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 3/3] crypto: xilinx-trng: Add CTR_DRBG DF processing of seed
Date: Mon, 15 Sep 2025 19:00:27 +0530
Message-ID: <20250915133027.2100914-4-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250915133027.2100914-1-h.jain@amd.com>
References: <20250915133027.2100914-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB78:EE_|MW4PR12MB7215:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a309502-b8b9-45f4-7342-08ddf45c1493
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XDH4wLFCTirQxrkC3eZ/3Q/fzWcIiBCHDGfuHyZ0gmXkuAgyELex74wxT+zT?=
 =?us-ascii?Q?o+ueHsxluBSW6xyDY/lWQqLWZzYDwNLVm7OP8tyOP1W/1WmJDXiGgMqB9xoc?=
 =?us-ascii?Q?UmiJFsXnhSVzmey0cNnMVN2uBgVt27ocqciRPxCUTsU3U7bhuOWFUrw1RIF3?=
 =?us-ascii?Q?Qj9kWAK85rvX+j5YcedV2BF3OVolIoCgGiRIJgn/q9p6Gb1ozoudcpPdpHl2?=
 =?us-ascii?Q?9oZCqLVA7bC5l/HoVQ+jENkfmtRhgVsED26sTjVj5irn2FK2ObpT0j+M6dnP?=
 =?us-ascii?Q?LiFzFzWYphOwNkUpA7X/FssSpGwJbmCRDpPx5lnJ8cPJ611RPLVrf8aTrmMy?=
 =?us-ascii?Q?B/5HidY8hfko4KHrU0o9/2ZV4694ZD/MKaKFF5OtSyXE23mc8zhNfSFvxjwa?=
 =?us-ascii?Q?EP0YDKru3Fl2wk000VxyhwFXzxD1uU2uIn6AiYaJVDiDetz6hKX6de9qjD6R?=
 =?us-ascii?Q?d8aOp92U9AkumvNaxdzgroMt2et61qbEjYzSlnOehSnKjsyZ6AxMUCW4bfN0?=
 =?us-ascii?Q?uhVUHE3t7Sn2HhR4AIoDLGBeYGAVE9qxM+73kZnLv9SKzQEoABpglDnMb14p?=
 =?us-ascii?Q?nDXWBI2aGnJVBG5L+LOM7bEL9FrITcOM8+oYxYkV2WzWsM5wYoNAUbT2+4dg?=
 =?us-ascii?Q?0DRbc3PMyLhHE5rLHBOZyfwFb0ZS7iBczCBR/OmJvrlPeaNTiAIsEvDESr8K?=
 =?us-ascii?Q?Mgz9D5fasT1aysFx+4gdTKwWzNkzdjHFQJogsF1rkFV7Na4BrJ4+YnbIccRV?=
 =?us-ascii?Q?3wHABfmzBc2SIw1CHfaXSF1JW0lzcCJnnGLJTaXx/Me+Gh+U9SGIGMrVplGz?=
 =?us-ascii?Q?qNSqdr++q0yjcjPvawx503CLwhxvmtc0ko1/xhUXACPjWRb3WgHHNlaytFkJ?=
 =?us-ascii?Q?EZFmhi+hD0siLsBG+t4pgxdJ3DwuVAjQwEajvU5ECYXdBSia17BGeyvl7gC7?=
 =?us-ascii?Q?hot0Oui3GpMerAxYdyYQOdoD51nZxHO3nQy5MWPdKydT56YroppTlXUygj3s?=
 =?us-ascii?Q?v1GhzD/KRo5pJBut+9/EBWGEs1TfmOB102QjSm7gLzG4ufknOvBaIgHsU0Xz?=
 =?us-ascii?Q?Sala19r0JRDTSiLU6Qc2s2fqfsBHBQEdLDtevI5GZ0RugI1Eby0aiIQNQJNo?=
 =?us-ascii?Q?BOeOE1rBhj1yKVW9ODU6Wl/I7rm93CXHoSP5JFmF06i+UBkj3EEYBikiHrlU?=
 =?us-ascii?Q?4sLD5sl2aWhhaB6++wSiJ7/ou+LgpGyajYJHf4sGekyi6i/2wI19f4bdHxt5?=
 =?us-ascii?Q?hD2QWYO8f4gwLLakvyrd7+HDUH49cTn26oIV7Nu/X/k3g+45pnX1PijxF0ol?=
 =?us-ascii?Q?+5K58k/wP4oUBHLRqtLUff4OwfwDRElMnGyxOMPKAds1/Xsnak9PLegSRhgN?=
 =?us-ascii?Q?c66hN6+sK0fKE7dYSEBTz/UoRkLDnchxIuQVHhEXCEV0tuDEITnrm4ayi9F9?=
 =?us-ascii?Q?8zcMUO3DFqRrNejhSA48rpamnQortRF1sIHC6o3dl61hEw86Wf69v1z21Gq+?=
 =?us-ascii?Q?pVyWjT+C2Cu0u/dw1hffl0cc4rchEoFWirlr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 13:30:47.5420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a309502-b8b9-45f4-7342-08ddf45c1493
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7215

Versal TRNG IP does not support Derivation Function (DF) of seed.
Add DF processing for CTR_DRBG mode.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/xilinx-trng.c | 37 ++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
index 4e4700d68127..b89a2f70bf82 100644
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -8,7 +8,6 @@
 #include <linux/clk.h>
 #include <linux/crypto.h>
 #include <linux/delay.h>
-#include <linux/errno.h>
 #include <linux/firmware/xlnx-zynqmp.h>
 #include <linux/hw_random.h>
 #include <linux/io.h>
@@ -18,10 +17,11 @@
 #include <linux/mutex.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
-#include <linux/string.h>
+#include <crypto/aes.h>
+#include <crypto/df_sp80090a.h>
+#include <crypto/internal/drbg.h>
 #include <crypto/internal/cipher.h>
 #include <crypto/internal/rng.h>
-#include <crypto/aes.h>
 
 /* TRNG Registers Offsets */
 #define TRNG_STATUS_OFFSET			0x4U
@@ -59,6 +59,8 @@
 struct xilinx_rng {
 	void __iomem *rng_base;
 	struct device *dev;
+	unsigned char *scratchpadbuf;
+	struct crypto_aes_ctx *aesctx;
 	struct mutex lock;	/* Protect access to TRNG device */
 	struct hwrng trng;
 };
@@ -182,9 +184,13 @@ static void xtrng_enable_entropy(struct xilinx_rng *rng)
 static int xtrng_reseed_internal(struct xilinx_rng *rng)
 {
 	u8 entropy[TRNG_ENTROPY_SEED_LEN_BYTES];
+	struct drbg_string data;
+	LIST_HEAD(seedlist);
 	u32 val;
 	int ret;
 
+	drbg_string_fill(&data, entropy, TRNG_SEED_LEN_BYTES);
+	list_add_tail(&data.list, &seedlist);
 	memset(entropy, 0, sizeof(entropy));
 	xtrng_enable_entropy(rng);
 
@@ -192,9 +198,14 @@ static int xtrng_reseed_internal(struct xilinx_rng *rng)
 	ret = xtrng_collect_random_data(rng, entropy, TRNG_SEED_LEN_BYTES, true);
 	if (ret != TRNG_SEED_LEN_BYTES)
 		return -EINVAL;
+	ret = crypto_drbg_ctr_df(rng->aesctx, rng->scratchpadbuf,
+				 TRNG_SEED_LEN_BYTES, &seedlist, AES_BLOCK_SIZE,
+				 TRNG_SEED_LEN_BYTES);
+	if (ret)
+		return ret;
 
 	xtrng_write_multiple_registers(rng->rng_base + TRNG_EXT_SEED_OFFSET,
-				       (u32 *)entropy, TRNG_NUM_INIT_REGS);
+				       (u32 *)rng->scratchpadbuf, TRNG_NUM_INIT_REGS);
 	/* select reseed operation */
 	iowrite32(TRNG_CTRL_PRNGXS_MASK, rng->rng_base + TRNG_CTRL_OFFSET);
 
@@ -324,6 +335,7 @@ static void xtrng_hwrng_unregister(struct hwrng *trng)
 static int xtrng_probe(struct platform_device *pdev)
 {
 	struct xilinx_rng *rng;
+	size_t sb_size;
 	int ret;
 
 	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
@@ -337,11 +349,22 @@ static int xtrng_probe(struct platform_device *pdev)
 		return PTR_ERR(rng->rng_base);
 	}
 
+	rng->aesctx = devm_kzalloc(&pdev->dev, sizeof(*rng->aesctx), GFP_KERNEL);
+	if (!rng->aesctx)
+		return -ENOMEM;
+
+	sb_size = crypto_drbg_ctr_df_datalen(TRNG_SEED_LEN_BYTES, AES_BLOCK_SIZE);
+	rng->scratchpadbuf = devm_kzalloc(&pdev->dev, sb_size, GFP_KERNEL);
+	if (!rng->scratchpadbuf) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
 	xtrng_trng_reset(rng->rng_base);
 	ret = xtrng_reseed_internal(rng);
 	if (ret) {
 		dev_err(&pdev->dev, "TRNG Seed fail\n");
-		return ret;
+		goto end;
 	}
 
 	xilinx_rng_dev = rng;
@@ -349,8 +372,9 @@ static int xtrng_probe(struct platform_device *pdev)
 	ret = crypto_register_rng(&xtrng_trng_alg);
 	if (ret) {
 		dev_err(&pdev->dev, "Crypto Random device registration failed: %d\n", ret);
-		return ret;
+		goto end;
 	}
+
 	ret = xtrng_hwrng_register(&rng->trng);
 	if (ret) {
 		dev_err(&pdev->dev, "HWRNG device registration failed: %d\n", ret);
@@ -363,6 +387,7 @@ static int xtrng_probe(struct platform_device *pdev)
 crypto_rng_free:
 	crypto_unregister_rng(&xtrng_trng_alg);
 
+end:
 	return ret;
 }
 
-- 
2.34.1

