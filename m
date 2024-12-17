Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04A41F63F5;
	Tue, 17 Dec 2024 16:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734452040; cv=fail; b=Kjca5uwj5WeWEQpDh/Py8tsW/+GOiSn65Kun1WpEc3QU9BJcBkbprq5mChzngARK2q+5Xu90TYfhzKcgMsFb9+9FG9Q6wyGgnHe3Kw9XZvaqSI/seu7sSgD+NdA7fvvS2mm48u+ifRuh6BmPrIAD0cMRQmbn17fsaL5s0xeAn6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734452040; c=relaxed/simple;
	bh=h3RL+O+iSoT40DegjlpJgv4xfPcD1SKwI72Sb+0Eoi0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bj2YCXmg7EXX/HuB1caJPn7kuJtaCht8a5oJJ9W+UMvRH/gbzB1wvgVb3X2659iGKKLy+WckIe6Ppkx7KpIwZ2ow4Txmwird9hEFU3agv6HWx5BDGFiETwICQ23saEDXisV010N2vYap2BIVkKKFB4rb0YcsjizBSUAjqOI+t9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lhEC3ItQ; arc=fail smtp.client-ip=40.107.220.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lhEC3ItQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=scWwioRt47SOaeFWoamVouJoSv3dYCBXfYe8skifaiceSp2UKr8erMhGqPOKrZO8Hr8uYfjVN6dYMRH7ihdPya0VL7CRuugDx3hXsp2BGpd1v9C8x1bR5+GdIqKOhdM335fUGIS/uQYrvqdaF7tyG6LU9WQWXWBGmixvzqcaiL1eg58J0dfKjDezU7fZUbDebYqxsj4hBMMkpLpQAQS1UJZ1lXKXkro62J4m+la4aVVMZoLMHcl9nLcG5sKd8FeoC9xno2ZXSdyqpDVyH1GSp7gaCBsO5vGbOHQLaHhSMsqewYYQimso9fg8g679QeAJiMon1rKnUIUcs3O1fKnL9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Xy109XI88qm7g368t4Zi6jciT9LZzHWZR2i5Dp62i4=;
 b=oVSX++dFV/Av8BAX20Z0BxmLXkxsIbKjydpLUev57/LXC8WJzCg0Tyht8Jb3jyjmmvOkTR1/D9hpSFylHihcRBTyULgVePGgUMCG+t6g9ItnO9vZ5WrHmnnyVzst+KK5FzdglDedob39Q6w36EdfimctaNMLfIpJbMuhELuuJwgF52bt3u9ljwBar+OFpn1smry2aP6QZA4FCKIVrKep8GF96i/1M/+j2a3dpfluz5dVybXcBUgkjSac/Sl9QD+167VmmLVvM0kSaz8X55SZZrCQzZLdhVmvOiiFYS7fLPeOwVuFoF9rJz2914yWbKyfmE8qIWEsuLnT1ftRd3hk2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Xy109XI88qm7g368t4Zi6jciT9LZzHWZR2i5Dp62i4=;
 b=lhEC3ItQUgfxFSddfclgf5lrp09VZv/UhlWM/a7q4olVc53pX11JIhi+aStXV6Q2Dz/n3GlcVmBTSW4/n5NJsmZJzQo3A8iIpYoVqciGpP70EPntMpXU0mIB3MzAmXh8AzgYiKS7aLMzz6LCjGbGGhyj/LQLBbTPiMDu+FjnZvjA5IMCUwMHR2KXdO9T5IdYyNn8tZXLgOrdpJ2CDrWGyL++fGFLRJwdVIvJTojPg0OxC3kkHMwfF7gaCp+Ep1Nxec4KTHY7MGRfhCrMT1LtJhuI5vFFeq9xmN4+0+OpDU5zrY1qx5EcyAEHMbkTfkCmS8iAxXVUVOgnscVwioXtMg==
Received: from BN9PR03CA0861.namprd03.prod.outlook.com (2603:10b6:408:13d::26)
 by IA0PR12MB7775.namprd12.prod.outlook.com (2603:10b6:208:431::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Tue, 17 Dec
 2024 16:13:56 +0000
Received: from BN1PEPF00004684.namprd03.prod.outlook.com
 (2603:10b6:408:13d:cafe::2c) by BN9PR03CA0861.outlook.office365.com
 (2603:10b6:408:13d::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.21 via Frontend Transport; Tue,
 17 Dec 2024 16:13:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00004684.mail.protection.outlook.com (10.167.243.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Tue, 17 Dec 2024 16:13:54 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:13:38 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:13:38 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 17 Dec 2024 08:13:35 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <akhilrajeev@nvidia.com>
Subject: [PATCH 4/7] crypto: tegra: Transfer HASH init function to crypto engine
Date: Tue, 17 Dec 2024 21:42:04 +0530
Message-ID: <20241217161207.72921-5-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004684:EE_|IA0PR12MB7775:EE_
X-MS-Office365-Filtering-Correlation-Id: 06beb773-2424-4f1c-40fc-08dd1eb5cdd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Zfd6H2e5at1SJPtyO5zPf0O5btpTLyRzicHoTZt+EgnoLqqEv1565gneMYSc?=
 =?us-ascii?Q?9atsrttl4EgKxYs/7elgIwoFteaDpw9HzjN7lQtEbdXT+Mkqgrk8gOjvWpoh?=
 =?us-ascii?Q?QSFO9hqmZN9Zv2aEKEz0usY7bh11cpM0FBwWGDjN0N7gc+7+pOKbCTCcwKwN?=
 =?us-ascii?Q?ZfJ15UWvI2P5TqpanT76P/V6Um0KLUeRDu23PIAOXS7E4IV3FNpzNVLAIcWH?=
 =?us-ascii?Q?KZnBezEQshw+2JKOYtq0xjKMM9yHYrnSFaBAbYurMZoUNZazeHjdCZ8hTFq9?=
 =?us-ascii?Q?c4wVRNLBrmdGAhv/QYAQpunoRoazOWOWa8H90LAAbIaPsatBU8mwUvWYlLoX?=
 =?us-ascii?Q?/M70GnHzbZUnSIjoSZwPPEEHHrHNaGEry8BnzmZhWcGIodcb47rsFrw6SHs8?=
 =?us-ascii?Q?ki42HUh2mqMgnJ6pk6zuFU4y3uG48cKfVAzqQZC4SFo4zs4lLLowBnQ9vAOS?=
 =?us-ascii?Q?9yMpmIVvvGGDtstO5rkqiMHPcJ8jp2lLkBX4AfNVC0ag0o0TWdZFKr8qNq6a?=
 =?us-ascii?Q?c/YVvqR67Js5VOXQMI3O59R5G4tpwLNDGEeA3nv2Be/x7soOwYXcZ+KPBi+0?=
 =?us-ascii?Q?QVYEvg+1Wkeb9MJOew0CIQZ14H5e224fue4woSJ4ZM+G1+ecH7Bv7oWs0VwN?=
 =?us-ascii?Q?iCwGFiZn2Fad+Vokx6xeTC0Iydy0ko/UunA3dnEuWleU9l52G7o6LnS7fGww?=
 =?us-ascii?Q?4NQVmbvFzh1U7yzSHW78T/tKTr4mVR7ykHerwQytnLsf1pxbQuYtOyx7MqYU?=
 =?us-ascii?Q?xTgTc57+DMWnN/Izm7wpg9SQdTLh76Ov3I/k0vljGGWW+bfSthneoTpUOcp4?=
 =?us-ascii?Q?Fx+xWVMHOOpdmj7CTsTE10ni1vFZsne86joSw50eEnGgNq8ghpGHEYGT4n7Z?=
 =?us-ascii?Q?w3pfAIQAO/MGJt0TAcRxEOtxZeXEQBuKRu/Pfkfy94UhWwygGoUOzajxj8t7?=
 =?us-ascii?Q?aHpNsAj2efUiGLlp/kwR+M0xNMXFYi6nz0uZVPgTTxBpqNylV9+tr9DdU4IT?=
 =?us-ascii?Q?gnciO8KNGNPPDxD6N1KRnTDgaHRmOM3NKkGJ5+CDHgnnr8URz5s/9aO4GQf1?=
 =?us-ascii?Q?0evdbn2JQwBWpX8rzAwf2KJQZaEhOGlKICBHSaag2bb73ev1UaPFeOImZTUO?=
 =?us-ascii?Q?q5HI2J8dTUL9JMnBNvOJTgPvXXAD5d4xrEU5JurbbeJMu0+r6ul3GqL1Bj99?=
 =?us-ascii?Q?HLGIG0qT8LystYQ2w2MbQaxxVhMzDyMY7Fswh6mhUZ/AVDUT97ac/NIxhUuJ?=
 =?us-ascii?Q?+VLIgh26KJItMh8paWoFVRXqU9xRVypfx0u1NTOtNBdDXS6hfsQpqeocv/tr?=
 =?us-ascii?Q?cBLG9zPwU61lh1nSTvgBCtO9D8P+1O9ZCHIvUGMvBJaX7lkGn+pdc5SD9V2n?=
 =?us-ascii?Q?ThsFsPeC32WGQnXgI7Xs/U/sHn4Z2hD0UWB6MLdOCqKMXnhYM4bdNbbGjb5z?=
 =?us-ascii?Q?Es5AN/P+0o12yYhPFETivxV0FisGaKpz3ix9HSmNRQ70j0Kv2epR0G8Oa6+c?=
 =?us-ascii?Q?HapmS6qVLSQznok=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 16:13:54.5625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06beb773-2424-4f1c-40fc-08dd1eb5cdd2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004684.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7775

Ahash init() function was called asynchronous to the crypto engine queue.
This could corrupt the request context if there is any ongoing operation
for the same request. Queue the init function as well to the crypto
engine queue so that this scenario can be avoided.

Fixes:  0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 78 +++++++++++++---------
 drivers/crypto/tegra/tegra-se-hash.c | 98 ++++++++++++++++------------
 drivers/crypto/tegra/tegra-se.h      |  5 +-
 3 files changed, 109 insertions(+), 72 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 6ed6da0ecc32..5d8237cda58f 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1453,6 +1453,34 @@ static void tegra_cmac_paste_result(struct tegra_se *se, struct tegra_cmac_reqct
 		       se->base + se->hw->regs->result + (i * 4));
 }
 
+static int tegra_cmac_do_init(struct ahash_request *req)
+{
+	struct tegra_cmac_reqctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct tegra_cmac_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct tegra_se *se = ctx->se;
+	int i;
+
+	rctx->total_len = 0;
+	rctx->datbuf.size = 0;
+	rctx->residue.size = 0;
+	rctx->task |= SHA_FIRST;
+	rctx->blk_size = crypto_ahash_blocksize(tfm);
+
+	rctx->residue.buf = dma_alloc_coherent(se->dev, rctx->blk_size * 2,
+					       &rctx->residue.addr, GFP_KERNEL);
+	if (!rctx->residue.buf)
+		return -ENOMEM;
+
+	rctx->residue.size = 0;
+
+	/* Clear any previous result */
+	for (i = 0; i < CMAC_RESULT_REG_COUNT; i++)
+		writel(0, se->base + se->hw->regs->result + (i * 4));
+
+	return 0;
+}
+
 static int tegra_cmac_do_update(struct ahash_request *req)
 {
 	struct tegra_cmac_reqctx *rctx = ahash_request_ctx(req);
@@ -1598,6 +1626,14 @@ static int tegra_cmac_do_one_req(struct crypto_engine *engine, void *areq)
 	struct tegra_se *se = ctx->se;
 	int ret = 0;
 
+	if (rctx->task & SHA_INIT) {
+		ret = tegra_cmac_do_init(req);
+		if (ret)
+			goto out;
+
+		rctx->task &= ~SHA_INIT;
+	}
+
 	if (rctx->task & SHA_UPDATE) {
 		ret = tegra_cmac_do_update(req);
 		if (ret)
@@ -1678,34 +1714,6 @@ static void tegra_cmac_cra_exit(struct crypto_tfm *tfm)
 	tegra_key_invalidate(ctx->se, ctx->key_id, ctx->alg);
 }
 
-static int tegra_cmac_init(struct ahash_request *req)
-{
-	struct tegra_cmac_reqctx *rctx = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct tegra_cmac_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct tegra_se *se = ctx->se;
-	int i;
-
-	rctx->total_len = 0;
-	rctx->datbuf.size = 0;
-	rctx->residue.size = 0;
-	rctx->task = SHA_FIRST;
-	rctx->blk_size = crypto_ahash_blocksize(tfm);
-
-	rctx->residue.buf = dma_alloc_coherent(se->dev, rctx->blk_size * 2,
-					       &rctx->residue.addr, GFP_KERNEL);
-	if (!rctx->residue.buf)
-		return -ENOMEM;
-
-	rctx->residue.size = 0;
-
-	/* Clear any previous result */
-	for (i = 0; i < CMAC_RESULT_REG_COUNT; i++)
-		writel(0, se->base + se->hw->regs->result + (i * 4));
-
-	return 0;
-}
-
 static int tegra_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 			     unsigned int keylen)
 {
@@ -1722,6 +1730,17 @@ static int tegra_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	return tegra_key_submit(ctx->se, key, keylen, ctx->alg, &ctx->key_id);
 }
 
+static int tegra_cmac_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct tegra_cmac_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct tegra_cmac_reqctx *rctx = ahash_request_ctx(req);
+
+	rctx->task = SHA_INIT;
+
+	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
+}
+
 static int tegra_cmac_update(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -1761,8 +1780,7 @@ static int tegra_cmac_digest(struct ahash_request *req)
 	struct tegra_cmac_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct tegra_cmac_reqctx *rctx = ahash_request_ctx(req);
 
-	tegra_cmac_init(req);
-	rctx->task |= SHA_UPDATE | SHA_FINAL;
+	rctx->task |= SHA_INIT | SHA_UPDATE | SHA_FINAL;
 
 	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
 }
diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index d35bce81e017..07e4c7320ec8 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -296,6 +296,44 @@ static void tegra_sha_paste_hash_result(struct tegra_se *se, struct tegra_sha_re
 		       se->base + se->hw->regs->result + (i * 4));
 }
 
+static int tegra_sha_do_init(struct ahash_request *req)
+{
+	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct tegra_se *se = ctx->se;
+
+	if (ctx->fallback)
+		return tegra_sha_fallback_init(req);
+
+	rctx->total_len = 0;
+	rctx->datbuf.size = 0;
+	rctx->residue.size = 0;
+	rctx->key_id = ctx->key_id;
+	rctx->task |= SHA_FIRST;
+	rctx->alg = ctx->alg;
+	rctx->blk_size = crypto_ahash_blocksize(tfm);
+	rctx->digest.size = crypto_ahash_digestsize(tfm);
+
+	rctx->digest.buf = dma_alloc_coherent(se->dev, rctx->digest.size,
+					      &rctx->digest.addr, GFP_KERNEL);
+	if (!rctx->digest.buf)
+		goto digbuf_fail;
+
+	rctx->residue.buf = dma_alloc_coherent(se->dev, rctx->blk_size,
+					       &rctx->residue.addr, GFP_KERNEL);
+	if (!rctx->residue.buf)
+		goto resbuf_fail;
+
+	return 0;
+
+resbuf_fail:
+	dma_free_coherent(se->dev, rctx->digest.size, rctx->digest.buf,
+			  rctx->digest.addr);
+digbuf_fail:
+	return -ENOMEM;
+}
+
 static int tegra_sha_do_update(struct ahash_request *req)
 {
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
@@ -435,6 +473,14 @@ static int tegra_sha_do_one_req(struct crypto_engine *engine, void *areq)
 	struct tegra_se *se = ctx->se;
 	int ret = 0;
 
+	if (rctx->task & SHA_INIT) {
+		ret = tegra_sha_do_init(req);
+		if (ret)
+			goto out;
+
+		rctx->task &= ~SHA_INIT;
+	}
+
 	if (rctx->task & SHA_UPDATE) {
 		ret = tegra_sha_do_update(req);
 		if (ret)
@@ -525,44 +571,6 @@ static void tegra_sha_cra_exit(struct crypto_tfm *tfm)
 	tegra_key_invalidate(ctx->se, ctx->key_id, ctx->alg);
 }
 
-static int tegra_sha_init(struct ahash_request *req)
-{
-	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct tegra_se *se = ctx->se;
-
-	if (ctx->fallback)
-		return tegra_sha_fallback_init(req);
-
-	rctx->total_len = 0;
-	rctx->datbuf.size = 0;
-	rctx->residue.size = 0;
-	rctx->key_id = ctx->key_id;
-	rctx->task = SHA_FIRST;
-	rctx->alg = ctx->alg;
-	rctx->blk_size = crypto_ahash_blocksize(tfm);
-	rctx->digest.size = crypto_ahash_digestsize(tfm);
-
-	rctx->digest.buf = dma_alloc_coherent(se->dev, rctx->digest.size,
-					      &rctx->digest.addr, GFP_KERNEL);
-	if (!rctx->digest.buf)
-		goto digbuf_fail;
-
-	rctx->residue.buf = dma_alloc_coherent(se->dev, rctx->blk_size,
-					       &rctx->residue.addr, GFP_KERNEL);
-	if (!rctx->residue.buf)
-		goto resbuf_fail;
-
-	return 0;
-
-resbuf_fail:
-	dma_free_coherent(se->dev, rctx->digest.size, rctx->digest.buf,
-			  rctx->digest.addr);
-digbuf_fail:
-	return -ENOMEM;
-}
-
 static int tegra_hmac_fallback_setkey(struct tegra_sha_ctx *ctx, const u8 *key,
 				      unsigned int keylen)
 {
@@ -588,6 +596,17 @@ static int tegra_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	return tegra_key_submit(ctx->se, key, keylen, ctx->alg, &ctx->key_id);
 }
 
+static int tegra_sha_init(struct ahash_request *req)
+{
+	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
+
+	rctx->task = SHA_INIT;
+
+	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
+}
+
 static int tegra_sha_update(struct ahash_request *req)
 {
 	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
@@ -639,8 +658,7 @@ static int tegra_sha_digest(struct ahash_request *req)
 	if (ctx->fallback)
 		return tegra_sha_fallback_digest(req);
 
-	tegra_sha_init(req);
-	rctx->task |= SHA_UPDATE | SHA_FINAL;
+	rctx->task |= SHA_INIT | SHA_UPDATE | SHA_FINAL;
 
 	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
 }
diff --git a/drivers/crypto/tegra/tegra-se.h b/drivers/crypto/tegra/tegra-se.h
index e196a90eedb9..e1ec37bfb80a 100644
--- a/drivers/crypto/tegra/tegra-se.h
+++ b/drivers/crypto/tegra/tegra-se.h
@@ -342,8 +342,9 @@
 #define SE_MAX_MEM_ALLOC			SZ_4M
 
 #define SHA_FIRST	BIT(0)
-#define SHA_UPDATE	BIT(1)
-#define SHA_FINAL	BIT(2)
+#define SHA_INIT	BIT(1)
+#define SHA_UPDATE	BIT(2)
+#define SHA_FINAL	BIT(3)
 
 /* Security Engine operation modes */
 enum se_aes_alg {
-- 
2.43.2

