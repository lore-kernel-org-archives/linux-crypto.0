Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2056.outbound.protection.outlook.com [40.107.96.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998D21FBE9A;
	Tue, 17 Dec 2024 16:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734452061; cv=fail; b=m2rcIZZerMuDLslMBTXWU3m2fx7Q+gryggBpYHiE7vJDCZzFE63wI6GPmIq0AqVwpPmYtTm2I4Yb63GAmxl/KVEwcLJFTNvFFsjQaShPvjX0TGKVZqhjDpNPG832wdPrSVil44gm6UFCfJLSYtlETbdyAvmRbK3PyRN+/0BFOec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734452061; c=relaxed/simple;
	bh=jbkCphjjxqSyf6NzRWGDoMXpWoGQ2kgZN3IsLfSIlwI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=msivgURKfeBh4m7ETLEHGVhHQqPpL2EjjKiVDUAxqMgKWayXTmY31vWdRootTmEItwMHvFvFuhBBywQsBg1OoMHmbwoPA2/kdrvBa8eESvWH+wbiCFEznPhq7n7UcdiB7SseO+/q9zJOWTPcDU2WHux7IzlJRMQYaizicN1XO7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JmeXsTmB; arc=fail smtp.client-ip=40.107.96.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JmeXsTmB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tGzH34O1UxfrtkhFmG7G+nVOZyDcDwAw5X5edGOm34XzlNs1AvE2SDofy2c+0J/y3VkPeFBkHEEW9I44M5LK9EojuUI4pykGBgO4+urDAUmY2tIY/Dnfb+6PzcZ/q3pkClWVGJeTsPPJ2zyMJCOjecnk8QljdXwcDNbnkaWQMf3mSWq0L1q+/htuPKAjb2vJApRioSGWE7rRgqHltk/bRHEhoM6rS2d2NZJJ3wUtm9xERy/ZcycPqFeU2FWCK1nf4bpBMeslJeJn8KvIG5q0EbttnPtUnIdQDIQ7miEprHeHh1xu/vXmKTUO6YBEA7MnHlxoJKu5vMvWoJ43awX1BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSoitAu1S4bUFn5FCahSzUgTm++oEbkLGV1SXf4iiXQ=;
 b=g4RfLeV4Zb+aGr/lalXabHLx3oye74fkH/8OX3Hj1DnpJOfQZ9LjHpyncA4XRItXMOg38b9DMiB03b8KQkb02m0EJRHg+3quhyWpnfk0TSgoGBD5+Ll6ba+RUPMjQQLxf8nM2+6QepPn5/Qdt0HeZB6k/F0QCgp9K9vh6BIoWX7WdKb+SRolWrdzqa2Ys/hOfswccm3jIvCQT2fv/RjI1uShZVtsaLDbZmiUWL5bfz+q1uXiMtajTM8hRHYb8LXWsWvycBQdFoSbfO5E7UbLynxrCzgvJ7JX1hJHUItnEPLB1H6+XY+tJdMzX7Do4GpxzxfAEDNF/t5eUN+PJaO0Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSoitAu1S4bUFn5FCahSzUgTm++oEbkLGV1SXf4iiXQ=;
 b=JmeXsTmBaMCh0UWYwtU0m0vW3eN4gz3m1i9bb+MoIEvOSU+LlD60LoJmj/UMuOZ7QothKXPwvdMdhSKJ88GLLOImfhU2VKEfJrsgAz2iSX0o9KeJ06DArv8nUComToCtwIJg1N8REE2xPkpK1G3Ytq7ce9e2GUvSNJJZHHTpN31TTzwfOCqg9K4WeLA34EET78LvF+GW2EMLJSnV2tLjO2OfEWIF0WUs3O/znO4ycjhn/LrTS+VX04U8JMjcO+BC3518fI120tBjhP7kbzeqJqJG5ZXCUDfNLwNgjHeFg0QTHwsIzUyVbghioVEJWiU11h+wbL9EzwetT7TXB6ARiQ==
Received: from PH7PR13CA0020.namprd13.prod.outlook.com (2603:10b6:510:174::27)
 by MW6PR12MB7088.namprd12.prod.outlook.com (2603:10b6:303:238::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Tue, 17 Dec
 2024 16:14:13 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:510:174:cafe::49) by PH7PR13CA0020.outlook.office365.com
 (2603:10b6:510:174::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8272.11 via Frontend Transport; Tue,
 17 Dec 2024 16:14:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Tue, 17 Dec 2024 16:14:12 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:13:50 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:13:49 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 17 Dec 2024 08:13:47 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <akhilrajeev@nvidia.com>
Subject: [PATCH 5/7] crypto: tegra: Fix HASH intermediate result handling
Date: Tue, 17 Dec 2024 21:42:05 +0530
Message-ID: <20241217161207.72921-6-akhilrajeev@nvidia.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241217161207.72921-1-akhilrajeev@nvidia.com>
References: <20241217161207.72921-1-akhilrajeev@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|MW6PR12MB7088:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cf5650c-461c-4db5-a70f-08dd1eb5d842
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V0K5iyr3MuyrzRyThkPnEmscw/LAUHmlGVwqMUsX4InX77kWIPf1n6kNaX+r?=
 =?us-ascii?Q?ZR1Zibh0YsmPAqXU1vdGPQuKg8bl/TfOXJcw+xYBWrwcnVC6yu6hbFb6ap3H?=
 =?us-ascii?Q?XIe88iTrNnuyohEASdJFG65lAOKRznsX6FIZXK8/+ZT7j7BO7PONXVrxv3N+?=
 =?us-ascii?Q?F6jTZifRohnfFD+ZOITMdOeSK4prvo1Pi8yLoLJE+Th5z7p58g94sHZNhSxl?=
 =?us-ascii?Q?+ZgXHuaHsSnIeV1Vo8pdJlK5eUGX7k0Ofr9fmLTojXEoXvCjY9rGpW4pjQlC?=
 =?us-ascii?Q?WiMn2ViZpVMk5to8sZaOcDAJPkW8rYOfEYlYP8sdSTDnTHXh25+0/L88URcf?=
 =?us-ascii?Q?+WZO+SNi1nAM2XNGKjHyP1kDCCWc0/3i100Te632lOi9NE7Twif/AnJX2qCg?=
 =?us-ascii?Q?g19J1famGmdcdJ0Kfq9Dns/GZqGZKXLQ61bd+uT+nz0AX12eKJkuJCDSYHJ+?=
 =?us-ascii?Q?SIidaiSMiKHWKao8EEA1pZBu1Pcr8lhPND7wY7F6Pp5Ar/YH91Xt4RrxftMm?=
 =?us-ascii?Q?NvXuQlH+ncycnpcfEAu8K2bVgwoamdli8VPm6H+IyTX2uu5Rb3W9hpCOlk9k?=
 =?us-ascii?Q?a05+9hMeVogxo3WTEw00lBfYeAY8+k+blcxdwZVmu4a9/trlvUGlU8iRAVc9?=
 =?us-ascii?Q?QzRQkkXebawYfIKBgldXtSL/5Z588bjveZVgroFw+sdL1pBRFATki5FA+vwt?=
 =?us-ascii?Q?QZZ/gonnNB7Dehb6z9HwLH+fEPGI0BnIICWZKb7Rsev5jDg4TGFCp0B1y7uZ?=
 =?us-ascii?Q?4Ct6ZftEv5FDtQqK+R41Nkbv0OaX/NtKuteSE+EuGNTqiGTIVZUr/16FVD7d?=
 =?us-ascii?Q?ebTULsDMcgT6+8BOdBzzAw/g9B5GeiyZ1WV69yyDcSfNilQ577hnGF8M4Ewh?=
 =?us-ascii?Q?r2P2pDEhx9orPPwS4DIDVHzlndrNwZbblnUw/ErgOPI+PZEMpHyiiutY6cm0?=
 =?us-ascii?Q?x2JyTCwHoZVzjxqkOWgP4Jl82Gsc+KdnoTO53e+39zEVsBPr7nbCT+Tfr5V9?=
 =?us-ascii?Q?niKXxzE/8wCBVtnYuacNDT9bITWe7aJf0FceG3YjnDnzF7QyZY0ikcq+bxnS?=
 =?us-ascii?Q?UK7oWozxEkEKZZ+fbDFCxtSDTX2a+Xi8AoQzsuRLkIsiPep/dAgXestwFCRo?=
 =?us-ascii?Q?WpaUIi1k5vkTpIucIewtWgDJrJJHzYHbtcrhntTXL9DeFgK8vkmNqMFM1f/p?=
 =?us-ascii?Q?xEASnIa0Kqudyi4M+oClXtrlUvuxWrrSHzjxCrHgyaMLUqCNcJ7eVJnqXc93?=
 =?us-ascii?Q?LKFMv+LiB9Znxr5CziRzLwJ5Ca4gTkS/Us22Q+R2Xm0drXlyEAoJUz7WjGz4?=
 =?us-ascii?Q?5N+eBh9B0is9qj+JFQ09GsK+VQj8KIwyJKzwNA34euZ1Rmg54Bjlx0fm7WBe?=
 =?us-ascii?Q?02dlwPqIEdqW/vhIyAVvyKUXmcLlGfih0ic5dLC7RqYQVy75kmr74Z6W04hw?=
 =?us-ascii?Q?g0DUGfThRz76Ry+otrrq2Qii2iqhzmj8uIG6jKUY9EW75EgC+6OIDFVo+pTZ?=
 =?us-ascii?Q?tAsSPbWlgOgD9kg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 16:14:12.2170
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf5650c-461c-4db5-a70f-08dd1eb5d842
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7088

The intermediate hash values generated during an update task were
handled incorrectly in the driver. The values have a defined format for
each algorithm. Copying and pasting from the HASH_RESULT register
balantly would not work for all the supported algorithms. This incorrect
handling causes failures when there is a context switch between multiple
operations.

To handle the expected format correctly, add a separate buffer for
storing the intermediate results for each request. Remove the previous
copy/paste functions which read/wrote to the registers directly. Instead
configure the hardware to get the intermediate result copied to the
buffer and use host1x path to restore the intermediate hash results.

Fixes:  0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-hash.c | 151 +++++++++++++++++----------
 drivers/crypto/tegra/tegra-se.h      |   1 +
 2 files changed, 99 insertions(+), 53 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 07e4c7320ec8..407ed696a770 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -34,6 +34,7 @@ struct tegra_sha_reqctx {
 	struct tegra_se_datbuf datbuf;
 	struct tegra_se_datbuf residue;
 	struct tegra_se_datbuf digest;
+	struct tegra_se_datbuf intr_res;
 	unsigned int alg;
 	unsigned int config;
 	unsigned int total_len;
@@ -211,11 +212,64 @@ static int tegra_sha_fallback_export(struct ahash_request *req, void *out)
 	return crypto_ahash_export(&rctx->fallback_req, out);
 }
 
-static int tegra_sha_prep_cmd(struct tegra_se *se, u32 *cpuvaddr,
+static int tegra_se_insert_hash_result(struct tegra_sha_ctx *ctx, u32 *cpuvaddr,
 			      struct tegra_sha_reqctx *rctx)
 {
+	u32 *res = (u32 *)rctx->intr_res.buf;
+	int i = 0, j, idx;
+
+	cpuvaddr[i++] = 0;
+	cpuvaddr[i++] = host1x_opcode_setpayload(HASH_RESULT_REG_COUNT);
+	cpuvaddr[i++] = se_host1x_opcode_incr_w(SE_SHA_HASH_RESULT);
+
+	for (j = 0; j < HASH_RESULT_REG_COUNT; j++) {
+		int idx = j;
+
+		/*
+		 * The initial, intermediate and final hash value of SHA-384, SHA-512
+		 * in SHA_HASH_RESULT registers follow the below layout of bytes.
+		 *
+		 * +---------------+------------+
+		 * | HASH_RESULT_0 | B4...B7    |
+		 * +---------------+------------+
+		 * | HASH_RESULT_1 | B0...B3    |
+		 * +---------------+------------+
+		 * | HASH_RESULT_2 | B12...B15  |
+		 * +---------------+------------+
+		 * | HASH_RESULT_3 | B8...B11   |
+		 * +---------------+------------+
+		 * |            ......          |
+		 * +---------------+------------+
+		 * | HASH_RESULT_14| B60...B63  |
+		 * +---------------+------------+
+		 * | HASH_RESULT_15| B56...B59  |
+		 * +---------------+------------+
+		 *
+		 */
+		if (ctx->alg == SE_ALG_SHA384 || ctx->alg == SE_ALG_SHA512)
+			idx = (j % 2)? j - 1: j + 1;
+
+		/* For SHA-1, SHA-224, SHA-256, SHA-384, SHA-512 the initial
+		 * intermediate and final hash value when stored in
+		 * SHA_HASH_RESULT registers, the byte order is NOT in
+		 * little-endian.
+		 */
+		if (ctx->alg <= SE_ALG_SHA512)
+			cpuvaddr[i++] = be32_to_cpu(res[idx]);
+		else
+			cpuvaddr[i++] = res[idx];
+	}
+
+	return i;
+}
+
+
+static int tegra_sha_prep_cmd(struct tegra_sha_ctx *ctx, u32 *cpuvaddr,
+			      struct tegra_sha_reqctx *rctx)
+{
+	struct tegra_se *se = ctx->se;
 	u64 msg_len, msg_left;
-	int i = 0;
+	int i = 0, j;
 
 	msg_len = rctx->total_len * 8;
 	msg_left = rctx->datbuf.size * 8;
@@ -241,7 +295,7 @@ static int tegra_sha_prep_cmd(struct tegra_se *se, u32 *cpuvaddr,
 	cpuvaddr[i++] = upper_32_bits(msg_left);
 	cpuvaddr[i++] = 0;
 	cpuvaddr[i++] = 0;
-	cpuvaddr[i++] = host1x_opcode_setpayload(6);
+	cpuvaddr[i++] = host1x_opcode_setpayload(2);
 	cpuvaddr[i++] = se_host1x_opcode_incr_w(SE_SHA_CFG);
 	cpuvaddr[i++] = rctx->config;
 
@@ -249,15 +303,29 @@ static int tegra_sha_prep_cmd(struct tegra_se *se, u32 *cpuvaddr,
 		cpuvaddr[i++] = SE_SHA_TASK_HASH_INIT;
 		rctx->task &= ~SHA_FIRST;
 	} else {
-		cpuvaddr[i++] = 0;
+		/*
+		 * If it isn't the first task, program the HASH_RESULT register
+		 * with the intermediate result from the previous task
+		 */
+		i += tegra_se_insert_hash_result(ctx, cpuvaddr + i, rctx);
 	}
 
+	cpuvaddr[i++] = host1x_opcode_setpayload(4);
+	cpuvaddr[i++] = se_host1x_opcode_incr_w(SE_SHA_IN_ADDR);
 	cpuvaddr[i++] = rctx->datbuf.addr;
 	cpuvaddr[i++] = (u32)(SE_ADDR_HI_MSB(upper_32_bits(rctx->datbuf.addr)) |
 				SE_ADDR_HI_SZ(rctx->datbuf.size));
-	cpuvaddr[i++] = rctx->digest.addr;
-	cpuvaddr[i++] = (u32)(SE_ADDR_HI_MSB(upper_32_bits(rctx->digest.addr)) |
-				SE_ADDR_HI_SZ(rctx->digest.size));
+
+	if (rctx->task & SHA_UPDATE) {
+		cpuvaddr[i++] = rctx->intr_res.addr;
+		cpuvaddr[i++] = (u32)(SE_ADDR_HI_MSB(upper_32_bits(rctx->intr_res.addr)) |
+					SE_ADDR_HI_SZ(rctx->intr_res.size));
+	} else {
+		cpuvaddr[i++] = rctx->digest.addr;
+		cpuvaddr[i++] = (u32)(SE_ADDR_HI_MSB(upper_32_bits(rctx->digest.addr)) |
+					SE_ADDR_HI_SZ(rctx->digest.size));
+	}
+
 	if (rctx->key_id) {
 		cpuvaddr[i++] = host1x_opcode_setpayload(1);
 		cpuvaddr[i++] = se_host1x_opcode_nonincr_w(SE_SHA_CRYPTO_CFG);
@@ -266,36 +334,18 @@ static int tegra_sha_prep_cmd(struct tegra_se *se, u32 *cpuvaddr,
 
 	cpuvaddr[i++] = host1x_opcode_setpayload(1);
 	cpuvaddr[i++] = se_host1x_opcode_nonincr_w(SE_SHA_OPERATION);
-	cpuvaddr[i++] = SE_SHA_OP_WRSTALL |
-			SE_SHA_OP_START |
+	cpuvaddr[i++] = SE_SHA_OP_WRSTALL | SE_SHA_OP_START |
 			SE_SHA_OP_LASTBUF;
 	cpuvaddr[i++] = se_host1x_opcode_nonincr(host1x_uclass_incr_syncpt_r(), 1);
 	cpuvaddr[i++] = host1x_uclass_incr_syncpt_cond_f(1) |
 			host1x_uclass_incr_syncpt_indx_f(se->syncpt_id);
 
-	dev_dbg(se->dev, "msg len %llu msg left %llu cfg %#x",
-		msg_len, msg_left, rctx->config);
+	dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
+		msg_len, msg_left, rctx->datbuf.size, rctx->config);
 
 	return i;
 }
 
-static void tegra_sha_copy_hash_result(struct tegra_se *se, struct tegra_sha_reqctx *rctx)
-{
-	int i;
-
-	for (i = 0; i < HASH_RESULT_REG_COUNT; i++)
-		rctx->result[i] = readl(se->base + se->hw->regs->result + (i * 4));
-}
-
-static void tegra_sha_paste_hash_result(struct tegra_se *se, struct tegra_sha_reqctx *rctx)
-{
-	int i;
-
-	for (i = 0; i < HASH_RESULT_REG_COUNT; i++)
-		writel(rctx->result[i],
-		       se->base + se->hw->regs->result + (i * 4));
-}
-
 static int tegra_sha_do_init(struct ahash_request *req)
 {
 	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
@@ -325,8 +375,17 @@ static int tegra_sha_do_init(struct ahash_request *req)
 	if (!rctx->residue.buf)
 		goto resbuf_fail;
 
+	rctx->intr_res.size = HASH_RESULT_REG_COUNT * 4;
+	rctx->intr_res.buf = dma_alloc_coherent(se->dev, rctx->intr_res.size,
+					       &rctx->intr_res.addr, GFP_KERNEL);
+	if (!rctx->intr_res.buf)
+		goto intr_res_fail;
+
 	return 0;
 
+intr_res_fail:
+	dma_free_coherent(se->dev, rctx->residue.size, rctx->residue.buf,
+			  rctx->residue.addr);
 resbuf_fail:
 	dma_free_coherent(se->dev, rctx->digest.size, rctx->digest.buf,
 			  rctx->digest.addr);
@@ -356,7 +415,6 @@ static int tegra_sha_do_update(struct ahash_request *req)
 
 	rctx->src_sg = req->src;
 	rctx->datbuf.size = (req->nbytes + rctx->residue.size) - nresidue;
-	rctx->total_len += rctx->datbuf.size;
 
 	/*
 	 * If nbytes are less than a block size, copy it residue and
@@ -365,12 +423,12 @@ static int tegra_sha_do_update(struct ahash_request *req)
 	if (nblks < 1) {
 		scatterwalk_map_and_copy(rctx->residue.buf + rctx->residue.size,
 					 rctx->src_sg, 0, req->nbytes, 0);
-
 		rctx->residue.size += req->nbytes;
+
 		return 0;
 	}
 
-	rctx->datbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->datbuf.size,
+	rctx->datbuf.buf = dma_alloc_coherent(se->dev, rctx->datbuf.size,
 					      &rctx->datbuf.addr, GFP_KERNEL);
 	if (!rctx->datbuf.buf)
 		return -ENOMEM;
@@ -387,31 +445,15 @@ static int tegra_sha_do_update(struct ahash_request *req)
 
 	/* Update residue value with the residue after current block */
 	rctx->residue.size = nresidue;
+	rctx->total_len += rctx->datbuf.size;
 
 	rctx->config = tegra_sha_get_config(rctx->alg) |
-			SE_SHA_DST_HASH_REG;
-
-	/*
-	 * If this is not the first 'update' call, paste the previous copied
-	 * intermediate results to the registers so that it gets picked up.
-	 * This is to support the import/export functionality.
-	 */
-	if (!(rctx->task & SHA_FIRST))
-		tegra_sha_paste_hash_result(se, rctx);
-
-	size = tegra_sha_prep_cmd(se, cpuvaddr, rctx);
+			SE_SHA_DST_MEMORY;
 
+	size = tegra_sha_prep_cmd(ctx, cpuvaddr, rctx);
 	ret = tegra_se_host1x_submit(se, se->cmdbuf, size);
 
-	/*
-	 * If this is not the final update, copy the intermediate results
-	 * from the registers so that it can be used in the next 'update'
-	 * call. This is to support the import/export functionality.
-	 */
-	if (!(rctx->task & SHA_FINAL))
-		tegra_sha_copy_hash_result(se, rctx);
-
-	dma_free_coherent(ctx->se->dev, rctx->datbuf.size,
+	dma_free_coherent(se->dev, rctx->datbuf.size,
 			  rctx->datbuf.buf, rctx->datbuf.addr);
 
 	return ret;
@@ -443,8 +485,7 @@ static int tegra_sha_do_final(struct ahash_request *req)
 	rctx->config = tegra_sha_get_config(rctx->alg) |
 		       SE_SHA_DST_MEMORY;
 
-	size = tegra_sha_prep_cmd(se, cpuvaddr, rctx);
-
+	size = tegra_sha_prep_cmd(ctx, cpuvaddr, rctx);
 	ret = tegra_se_host1x_submit(se, se->cmdbuf, size);
 	if (ret)
 		goto out;
@@ -461,6 +502,10 @@ static int tegra_sha_do_final(struct ahash_request *req)
 			  rctx->residue.buf, rctx->residue.addr);
 	dma_free_coherent(se->dev, rctx->digest.size, rctx->digest.buf,
 			  rctx->digest.addr);
+
+	dma_free_coherent(se->dev, rctx->intr_res.size, rctx->intr_res.buf,
+			  rctx->intr_res.addr);
+
 	return ret;
 }
 
diff --git a/drivers/crypto/tegra/tegra-se.h b/drivers/crypto/tegra/tegra-se.h
index e1ec37bfb80a..0f5bcf27358b 100644
--- a/drivers/crypto/tegra/tegra-se.h
+++ b/drivers/crypto/tegra/tegra-se.h
@@ -24,6 +24,7 @@
 #define SE_STREAM_ID					0x90
 
 #define SE_SHA_CFG					0x4004
+#define SE_SHA_IN_ADDR					0x400c
 #define SE_SHA_KEY_ADDR					0x4094
 #define SE_SHA_KEY_DATA					0x4098
 #define SE_SHA_KEYMANIFEST				0x409c
-- 
2.43.2

