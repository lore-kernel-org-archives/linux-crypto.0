Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C816524A05D;
	Mon, 24 Feb 2025 09:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740388708; cv=fail; b=t5zPOnyDoyfad9o6YroQdkxT3wPU/4LBeLGjFBeqrKWk/UtDF42+gp2t/c/9W6I+SdA+D2j+O2ze0GVwb+5nWCQKjSSqd44Afs/TEaDbbiOTWJEVS7HrueCprjuuTT4xRq7BmQH+TIhh+uc/vZf7KMxArZUDkzAR4cM267cMCX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740388708; c=relaxed/simple;
	bh=Qywm3nTMex5ITrZzQf1wMMCgzSZVAS/DKmLx3FdJiVU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PEVWC+GGP8AJgLVKw2xZOl4Grg2yz+NyBI/wLwGVsCg9B7BCjSEx58UmUhk8s+sFWjDwe/VK+miAZEABhACoSNmvEfVTBejnAosY+vtBZnGJ20r1AV/3/puWLVciinzFsp2YQz875J8W7MeHBFsy25aJZxaZlYvH9iZOXX3hySA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ooebYysK; arc=fail smtp.client-ip=40.107.244.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ooebYysK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c4OBsV1ekwnxlFeIKF3UR8GgiVzQtL8kxVId4vKRAq2ueIc2RcKftSZFC7K8OxgHnT9PPW5O/0fR7PtZffheaa2s/mrztFKxS62NhbXTI8OMhDOUJKGlOd6LyvIM/JiQxLzyf2bzWEi2kUTox5UAR25me0ud6HgrZ5WSs+K/MtjzO6plJ/DJUZOM/cmgtKO6q2n839Ad8Az5lOzZVyENgftNvwnrzNhvxIcg9zzMZF2gRPug0WsFiHy5LWmT01OOJPs/VLHPceMbtXJGmCWNYGRrdWamLhtZhZMXrEwFsMJnpgkTQjx0eYg2pKS1fBLYCOKjrcjhDFNYQzEekrRbug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pa4G057SGVkS8OmMwtnMM9uWi38TDqLI2kWxXJuIB90=;
 b=v/kIDlFZoAcr5U0ODQ11LMx+c4Casn7xjYWX4fNKOxkurKATjOU8WDRlW1YuQRH7ZghTUm6PhiLwYnaQ7AMrNtUAgGWJfhyly1doT8LGxi/Pt10ny1bjqXhXsb3BTJ8+TCFSYiOtd9KbiHj5OQ61OqXYaLGk9vWu/3N9/ywXhrg5v7wdCoDTSWRtteWeGFc4DEX03yrfVAmmAb57Hwgoaf1ZBim6yS5sBfpbpNf02PFb1pf0Yl0IHy0pUiAjR+F1nWXmr38kLuza6w4P655rpZa8iykCCM9cI5WySd/mInNf6fkrgS7ALC40S8chPl0yqgwlnfe5Z7AJ3IdxxUZ+Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pa4G057SGVkS8OmMwtnMM9uWi38TDqLI2kWxXJuIB90=;
 b=ooebYysKCOGo1IGHC3ahLzgDYPya9pkDWHmLL4rAeK4rkUEGINbVty2lXSf8bgKlg5S7WOVQ2fdl+Nxx3CfTN4zylFi/iHUzouXsdFKeLgyR6qvAUaPXeVVnbeIXEcD7iuORfb9gKEiws9h47A8PF64Vyl2lwxfrHvxAGXEjNU/SsakLPeejWVveiQ83sw6xuEvHgLfpyNJ/oq6P/6ohPYhp/4KljpWACO/fMG09eXkoSTIKqGms4U0RpJYmgQ9rkQFifGeUkKbHXjDNybTD7557kSAxqlFgxDiXSEoW4MKdcOivLLKgUTkGOSbZWgUVuapNR1HauF/pz5Nd9bzoLw==
Received: from DM6PR18CA0033.namprd18.prod.outlook.com (2603:10b6:5:15b::46)
 by DS7PR12MB6093.namprd12.prod.outlook.com (2603:10b6:8:9e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 09:18:18 +0000
Received: from CH3PEPF00000016.namprd21.prod.outlook.com
 (2603:10b6:5:15b:cafe::f3) by DM6PR18CA0033.outlook.office365.com
 (2603:10b6:5:15b::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Mon,
 24 Feb 2025 09:18:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF00000016.mail.protection.outlook.com (10.167.244.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.0 via Frontend Transport; Mon, 24 Feb 2025 09:18:17 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 01:18:09 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 01:18:08 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 01:18:06 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v3 06/10] crypto: tegra: Fix HASH intermediate result handling
Date: Mon, 24 Feb 2025 14:46:06 +0530
Message-ID: <20250224091610.49683-7-akhilrajeev@nvidia.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250224091610.49683-1-akhilrajeev@nvidia.com>
References: <20250224091610.49683-1-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000016:EE_|DS7PR12MB6093:EE_
X-MS-Office365-Filtering-Correlation-Id: 7107405a-4a87-4d5f-d6cb-08dd54b42c9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r0c/J8fNJWH7rEjNwm562m9xImdyWTrwwar8w7yQuY+WyPvTl81YXnmyLxUI?=
 =?us-ascii?Q?9QfcBYXPof3vACwzJnBIIzX5hTEs7myFK5esENCBNxb3cq0gtOmG33ix/kUd?=
 =?us-ascii?Q?K95qGwPHFH8x8+Q4ouyC9IO/DITQ6tYzCTfIfJL3az4O9F1zje1Ek2QyEPrc?=
 =?us-ascii?Q?Pbd0IPiZ5oWrW2qBn0kSELkeTQc3/umIuzHTqRitPJzKS4FgV82ZMI1VY8LX?=
 =?us-ascii?Q?HXaYRTtblKR/QuKpQ9m88Jwfq8omtgv3uqBWXDqQ4xT8EI5MEwvtXkM9x3Sn?=
 =?us-ascii?Q?pt2m9ficbYEZg/OLIrR7hTrhg3Y9L/GsyfwFViCT5Oqffcdkr6f+vnZTQeBh?=
 =?us-ascii?Q?K7ykl6nkL/+ORtmPu9urf52fUM0YSzqanzKx5s0/gfE7X9N89eAlZHlrFUs/?=
 =?us-ascii?Q?8sGt9nkAVS9luMF+8XVwzjaIjKICh8lLlKeibWXjpSMDkc8ZR7+mBrnAnr3n?=
 =?us-ascii?Q?TvRqzRgDjvF9mZ3y5838YEJc3bBbVgvlO8xu4QrvCmsMHcQhHfAEOTa/QnrW?=
 =?us-ascii?Q?y6f8ftzD5Y7zJm6OV6nSDqM6FiBCcPcJtzsCIYc1fxN7qjLC0wPATtgGieQ4?=
 =?us-ascii?Q?keKg/pI3/ROAJzKqLzCqGXIntfLT0jn4JPhefqDkxW6HfhDl5gNkm+ZshzxL?=
 =?us-ascii?Q?IRaIHW3hf9Am4hF1lhGFuL2d9H6pxyYdv6tG0JgtSUK9ftFWi4VlqVoymYEV?=
 =?us-ascii?Q?rTgqyRp0WWUg1XF1fXcq//K3L7h1RD5DKPr9H6WV/JoUJ7sfTuyOiaHs4cHl?=
 =?us-ascii?Q?J+XbWnZx8vtkhGHhabRLjDkmDhjgVLq6spQjshmmpObaQ7BSubEhhvt9HNTN?=
 =?us-ascii?Q?rFWQHlRsn4uatrfGTniaYRIxaYXGpk6I913MZo2osa/0zYqU1D9zljXHBlK/?=
 =?us-ascii?Q?jRAWs6a+ae9CIGS6uuTO27byyhzeE0UEet11+11+T7RPgyFhrBcs6RVHY8/f?=
 =?us-ascii?Q?ZoXsDMfq8xJVYEwW2ByP0bquS10HGRkw74ngxtmhzFLbGNIXzD8SBl/GyVJm?=
 =?us-ascii?Q?CrxCHFMuQ1ud6iYcQkxIF/KSf6EtMSt5nCPgX5XMySPPdhN+CZVBacnUPNzh?=
 =?us-ascii?Q?2fWRDjiNyreS5JxowMbwHSBd9U48okF+1U1prDrffTLEsN/G05dPz3KLbQO6?=
 =?us-ascii?Q?DH+U8BIzhk4uluMvIxK+iAq4K6NwaBnAQ4KzQ7oFBHOrZlfZ2u6HhwD/Fb/U?=
 =?us-ascii?Q?f+seHhoPpit//oAdqsSyMWXm13O1VvtPQB3YD+m35BnOGRlyEaBWE3nv4UgW?=
 =?us-ascii?Q?xNwafce13cuatEGh1vNzRVldad9bMyTErjpYeRkZMpjy5uOHeNkcXFwEMJST?=
 =?us-ascii?Q?PMTK+x3QXso1TqbWCAOrfrx5caHwSQBIG15o4am3DToZsTKCJ4zlhh/u8x42?=
 =?us-ascii?Q?aQo1OcYtRjRAwqHXDA2QhuiI99jmQd+agjTKw8UMp1xBZDKsMv2oPf/6befL?=
 =?us-ascii?Q?S7+QcLN1hMY+LXAXxdhUqeEAOqu8YnYDxi3WALGqtjfSp+X9EYKoLPU1/zgY?=
 =?us-ascii?Q?Dj6GSb4lwGQP07w=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 09:18:17.4238
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7107405a-4a87-4d5f-d6cb-08dd54b42c9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000016.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6093

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
 drivers/crypto/tegra/tegra-se-hash.c | 149 +++++++++++++++++----------
 drivers/crypto/tegra/tegra-se.h      |   1 +
 2 files changed, 98 insertions(+), 52 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 07e4c7320ec8..8bed13552ab9 100644
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
@@ -211,9 +212,62 @@ static int tegra_sha_fallback_export(struct ahash_request *req, void *out)
 	return crypto_ahash_export(&rctx->fallback_req, out);
 }
 
-static int tegra_sha_prep_cmd(struct tegra_se *se, u32 *cpuvaddr,
+static int tegra_se_insert_hash_result(struct tegra_sha_ctx *ctx, u32 *cpuvaddr,
+				       struct tegra_sha_reqctx *rctx)
+{
+	__be32 *res_be = (__be32 *)rctx->intr_res.buf;
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
+			cpuvaddr[i++] = be32_to_cpu(res_be[idx]);
+		else
+			cpuvaddr[i++] = res[idx];
+	}
+
+	return i;
+}
+
+static int tegra_sha_prep_cmd(struct tegra_sha_ctx *ctx, u32 *cpuvaddr,
 			      struct tegra_sha_reqctx *rctx)
 {
+	struct tegra_se *se = ctx->se;
 	u64 msg_len, msg_left;
 	int i = 0;
 
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

