Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB3B262D1C;
	Tue, 11 Feb 2025 17:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294418; cv=fail; b=VjChUpjwybD3b/ytasejLGsbN2BbcWQUjMe7kB4mPkPxu46FEbL9HGWmGlSA49UqiFqywFLPBT9pMsOM2ax72TknzFcldb0BbZbrCeUq3JIv3Qmg2kCUo+FXsvDmFhfiVcI6Mte5Ttt46Lsu/gecGfDIoLFU7UxjnQXwFn7/SLQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294418; c=relaxed/simple;
	bh=Ovyb5TaYIJB4Uhw5leOKopG3qWtS3qt8CuMeEgIbVpE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zd51qcBPNFXUiFUXUP2fQHrErux+OrIelxEnuYNaViYtq1uzoQeUa8pdgIra/jX8KFiwYh53tUSp+BOoIGxa9Tw8dmqaYk/Ro9zJO3dPUXnnJJSyf3OO/7sSihWzvU0ZVWRNYBlEhXw8kPIRFF2DQbqRFfjlBosnsJAwBgXndng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MQFFwaOz; arc=fail smtp.client-ip=40.107.243.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MQFFwaOz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o1zvdtQBKKpObvfwE1rcSIYF+o0+M8iO5kI634QlhgUL0uugIzQb49kjR+JubqCqYtuXaaKuWCX4/29NtHr+g4Fh2fK4jwplErOiHu+2sgYj7lyqDv6ORJxk1TbDXEgpkfCXLXdC/76iNencB6uErzcaJwoCUvcxdUmA5iysjF4huiLlFggujQXxlBcF2LNwzg5PXRBqbY53Ymu6JnmfYU8BJI0Eh9GZ/BOmagdPFwrz4fQXXTZp02ltpZARn0YyPa1l8qgDw+LTErmaas4Sb4VIesnHowTPUJGBofusBtt7HtREWttJLapTsEvcxC6NsUtkOcEimz1ywQrEldxxiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=174cNErxa6PPINw/pp9tanQO9Vxu0GYoUE1mXDdWZXk=;
 b=FgkEEQQ8QM9M2FyfjK+fxiA82IzpCoic6DCt30tAjtzrrNbvaf+87sokIMFyQGcyC7Y/Ne2eq3NkyArRmWImThW0GnPsnGDSRF58FgKB2ww6a8hL5+IX1U9Hl+8UNiRSGevhNheusvf0Qbz+RPyJtg+EFgBj8Tfwv2/Fym3YTlOd7mFypOV6c64CavH5kScjRxijLA9exzIkH6iDffNpdbpec5qTuQ7EnGt67H6wbahwE+PUYo33FDXT5ofE9VGt1Phdh13IyPU21IODShrUqTK9JVjpsQhw//pf9LafsvH6ZWDKU3Y6BBY6jxP1A41S9yLNcW8vUy7LB8xttkW44A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=174cNErxa6PPINw/pp9tanQO9Vxu0GYoUE1mXDdWZXk=;
 b=MQFFwaOz1W3JHeyJrcrStZl8hkGdIyvygykO2jPGSvqYJnJfAxiBueT1K6nIzckiBWlWQCHDCe6MU5Uj3hVopatNjPSM2kg1RJLHzldbSQczlWK/M0Ub6T+dKquXKrAfYQp6ADOS1T8gtWf0nnpVgpWvry9Hs+r841GlWSTb/GMSrbY+MQCRmEoNfbY7prqdB+xkLjbLQyes5o2hKN1w0sl5QKYJAowocgMnvQYuTGLZrxO/20WPqs3k3vbYbXIsdAgSQOti+vxdg03C02bReVza7OiIRP+TQUge5kM89WxtXXIgXrMHc71SiSnFs2JoBnc8biwzcs17XLzD55c2Yg==
Received: from DM6PR13CA0018.namprd13.prod.outlook.com (2603:10b6:5:bc::31) by
 SJ0PR12MB7474.namprd12.prod.outlook.com (2603:10b6:a03:48d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.11; Tue, 11 Feb 2025 17:20:10 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:5:bc:cafe::e8) by DM6PR13CA0018.outlook.office365.com
 (2603:10b6:5:bc::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.11 via Frontend Transport; Tue,
 11 Feb 2025 17:20:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Tue, 11 Feb 2025 17:20:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Feb
 2025 09:19:59 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Feb
 2025 09:19:58 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Feb 2025 09:19:56 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v2 06/10] crypto: tegra: Fix HASH intermediate result handling
Date: Tue, 11 Feb 2025 22:47:09 +0530
Message-ID: <20250211171713.65770-7-akhilrajeev@nvidia.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250211171713.65770-1-akhilrajeev@nvidia.com>
References: <20250211171713.65770-1-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|SJ0PR12MB7474:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d8a778b-d27f-4ce7-61a9-08dd4ac0565e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?COf2Afs4Cwq9/ACRE/dDa29Q50Hx9wDQZLPP1jdruFIRxU5PqNyZ1mVWXncd?=
 =?us-ascii?Q?GBy55tyHtgl8IJwz5PigPWjzsmnphPMz0bfe8cgbQ1zhKGK2GHA3g2brAjaP?=
 =?us-ascii?Q?NrWisAFRHILki0UF0/F3K/HAl+ERY2J+nCgPFZPc70Md4SJ8zn99CEUbGkpz?=
 =?us-ascii?Q?jVWx94JsCgs/9WzbYnvNSpS+UxSc12SeJjpwFyu0nJn7FSCCPb4r/WRyxlno?=
 =?us-ascii?Q?JgDO3DnGiEKI84OATgYleg5zWvyaPRKhX6sdKZp3wqxoe3funz91yVlNq8xB?=
 =?us-ascii?Q?76bFOu87TMDgjMtI/HFfIoyrBveiThr5Sqj9Mve9HaR7rxfD7eykALlzPz+W?=
 =?us-ascii?Q?7ZRdrzqJ/rS9623DG3YqTb0V3zhMaq474lVu9+o45lXJz2duKqg+oUI1+rMF?=
 =?us-ascii?Q?BBcHUQft+ygQ0uNDtULo6j/F4KPPvRbCiTxZM4unwk59LUz94lG++XzIZFM5?=
 =?us-ascii?Q?nhrKZemR2+7c/6JLGSkJKi/0NKB5K0sOMrKQskK/RkPtVlq8EEuDcOgh/OOR?=
 =?us-ascii?Q?CpeDoi1yD2OTCX2ny9cWIFGgqAeR6rkXr4NTq7mukqS25v2MgmwC+XGI3JQL?=
 =?us-ascii?Q?jommenE7YCNSfRglrllL5HGSj7fDRz4MqZG//q2y/voW2y3918EtpGXeaa5s?=
 =?us-ascii?Q?oID8dscgkMg0dlQ+bEUgN4nv7w5llV0IpbVOvPf/joGtoMv8gH8WfSqVAK2H?=
 =?us-ascii?Q?etV3+cwTL3CYliYXkTXxoQCeMIfwX1dkvrlB3Oq3HilOBqGJGQqRhADaavtO?=
 =?us-ascii?Q?pDv0Mt+o4jYIC53fqqZUQL6IkUG5PwcDMKJfFIONbU/N2Fe62TWyC3WJqEk4?=
 =?us-ascii?Q?Ieh+2nGZV/wseaF+voIEXLzZb0K3qdWRr/xqdFE+d34wWqQOk9yKEzEZyWeL?=
 =?us-ascii?Q?0SlNAH/rp25Cwwb9FW+3OiC8DDGr5edOmq0oHnHM5j35uAdrYPEC/UkaXZs1?=
 =?us-ascii?Q?5zXE+BIQZi/Wsnkt3B7q3jtd47bjUeOZEi6gLBlE5QSWVnzWgiHYY3alEisB?=
 =?us-ascii?Q?58zMisGV77mIEOVnfROdEGEaPQriXVpQMapYWUR+HjbCiuGXHP1ktn0InFGp?=
 =?us-ascii?Q?1XtpkMgQQh/a/LCsVuTNk4xRwj/BQoQ8HpWcF57PCP6A2DMfqcvuyaN93qr+?=
 =?us-ascii?Q?5pDxy7YzX+GBiQUYpJzjWJmIWCWsatQsYRKbit1FL1O4yTBOauyIOh24qIiB?=
 =?us-ascii?Q?BbD8baHMj8+NCHIxqAwu6rRuu7h0P4kQ1TL5XMJ7W+wC78C8TiHkbWMmA2UP?=
 =?us-ascii?Q?JxLz1Tnz5iZtfUZ7m6G0kD+I52JdlhaTZh4zatBrn15j10YcXRG4OLd9hREO?=
 =?us-ascii?Q?fhlWiYxEj1VrWInIfgsFv0V9HB3O8CguDOiUW+hVea1Z0b/M7XX9XK2pGqXO?=
 =?us-ascii?Q?dZJB7TdlSQ4grcWax3DUvPnW6wPCBi9Mw8Z0Zh4CNQa75w64xPIF5SgjMqwl?=
 =?us-ascii?Q?hETn4DjIg9irW/x8IRLGPCW+uJHuoWmCQq3c7vXNlr1YHxZA8utW2cqfbRUL?=
 =?us-ascii?Q?xEl7sTI5rZAhODc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 17:20:09.8274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d8a778b-d27f-4ce7-61a9-08dd4ac0565e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7474

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

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-hash.c | 148 +++++++++++++++++----------
 drivers/crypto/tegra/tegra-se.h      |   1 +
 2 files changed, 97 insertions(+), 52 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 6da18f0f7ce9..89c1e1a0016b 100644
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
@@ -211,9 +212,61 @@ static int tegra_sha_fallback_export(struct ahash_request *req, void *out)
 	return crypto_ahash_export(&rctx->fallback_req, out);
 }
 
-static int tegra_sha_prep_cmd(struct tegra_se *se, u32 *cpuvaddr,
+static int tegra_se_insert_hash_result(struct tegra_sha_ctx *ctx, u32 *cpuvaddr,
 			      struct tegra_sha_reqctx *rctx)
 {
+	u32 *res = (u32 *)rctx->intr_res.buf;
+	int i = 0, j;
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
+			idx = (j % 2) ? j - 1 : j + 1;
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
+static int tegra_sha_prep_cmd(struct tegra_sha_ctx *ctx, u32 *cpuvaddr,
+			      struct tegra_sha_reqctx *rctx)
+{
+	struct tegra_se *se = ctx->se;
 	u64 msg_len, msg_left;
 	int i = 0;
 
@@ -241,7 +294,7 @@ static int tegra_sha_prep_cmd(struct tegra_se *se, u32 *cpuvaddr,
 	cpuvaddr[i++] = upper_32_bits(msg_left);
 	cpuvaddr[i++] = 0;
 	cpuvaddr[i++] = 0;
-	cpuvaddr[i++] = host1x_opcode_setpayload(6);
+	cpuvaddr[i++] = host1x_opcode_setpayload(2);
 	cpuvaddr[i++] = se_host1x_opcode_incr_w(SE_SHA_CFG);
 	cpuvaddr[i++] = rctx->config;
 
@@ -249,15 +302,29 @@ static int tegra_sha_prep_cmd(struct tegra_se *se, u32 *cpuvaddr,
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
@@ -266,36 +333,18 @@ static int tegra_sha_prep_cmd(struct tegra_se *se, u32 *cpuvaddr,
 
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
@@ -325,8 +374,17 @@ static int tegra_sha_do_init(struct ahash_request *req)
 	if (!rctx->residue.buf)
 		goto resbuf_fail;
 
+	rctx->intr_res.size = HASH_RESULT_REG_COUNT * 4;
+	rctx->intr_res.buf = dma_alloc_coherent(se->dev, rctx->intr_res.size,
+						&rctx->intr_res.addr, GFP_KERNEL);
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
@@ -356,7 +414,6 @@ static int tegra_sha_do_update(struct ahash_request *req)
 
 	rctx->src_sg = req->src;
 	rctx->datbuf.size = (req->nbytes + rctx->residue.size) - nresidue;
-	rctx->total_len += rctx->datbuf.size;
 
 	/*
 	 * If nbytes are less than a block size, copy it residue and
@@ -365,12 +422,12 @@ static int tegra_sha_do_update(struct ahash_request *req)
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
@@ -387,31 +444,15 @@ static int tegra_sha_do_update(struct ahash_request *req)
 
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
@@ -443,8 +484,7 @@ static int tegra_sha_do_final(struct ahash_request *req)
 	rctx->config = tegra_sha_get_config(rctx->alg) |
 		       SE_SHA_DST_MEMORY;
 
-	size = tegra_sha_prep_cmd(se, cpuvaddr, rctx);
-
+	size = tegra_sha_prep_cmd(ctx, cpuvaddr, rctx);
 	ret = tegra_se_host1x_submit(se, se->cmdbuf, size);
 	if (ret)
 		goto out;
@@ -461,6 +501,10 @@ static int tegra_sha_do_final(struct ahash_request *req)
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

