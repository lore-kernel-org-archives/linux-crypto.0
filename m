Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2082.outbound.protection.outlook.com [40.107.95.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57882475E8;
	Mon, 24 Feb 2025 09:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740388686; cv=fail; b=e/8NG3zmKxK7m937+e2IkQem86b9RbNN2Z6kxA7YFhd2Ab5ODy45j5ZtsTyMq9HJBAH63X/M5uzrGZa4U+KH31ZgJwscUBt72pFlUl+HRKQCKjURZ8bCBW4rxMBuu4iOUOk5ZGcPIgH+s+BnyZfSr27x35bPHSu1RvO6EiPf9mw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740388686; c=relaxed/simple;
	bh=gPiYvw9rT4f0xdKm2x+nAQkXKy0VWWyFkRM9ivSjRJ4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rwmmbIM98Iu8CFYBldN1M5qBbLTlXJPM6SRIxmWgW/JT27RnjtTTi0kSf/ejqpzJ0Rp15NioIBOd5pdr5OLqLnB0+/EvGSM2gdoGPRgGO68DLAQUj7J3OF1TY5J/w0KrWc/0MC5I42KlX82x+ws+waed3a0gw8DjQlG8PqKbrAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZIhoSjUg; arc=fail smtp.client-ip=40.107.95.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZIhoSjUg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pKBfxZLnNuQFo8EQlfSJ1ZXJ8IvQLhDXLd+PZrewabdh7LroRv0UInbtQoqKmT/e1pPbXl5eYNnEWmo7nP8pRtPZO0A0Quzrha7Td/oDMTicuC5BX8SqAZ3F1uuJ6ub4YpReSGDYbJfUVcuEviQn/m31+ML3esx779mcuOsVOdzg/hh73GSdqePw7I9glkYdH0eSVJ6eDZ9yJZmjk+31Z/1KZcvCyIfUbfIoCkZvDid/tYdAOnssO9MgVBu8WNUw/X+vxWmUI5hxsSkzZEN/43eMEiGupSA7XJ/eOxdoUFWj8InH6Ip8awIqZZt3Iyf3Y5d5NO+KbIjREHsxWM2G9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M7Cqy3q9sNcRu5cmDv8pPaEcge/MWyzSkih6YQayEPM=;
 b=JB/UTwnHbi3MRI4hW8jgvEVE7sZTwvkzduYpM7gZDYQlvi3L5IWyGq+rU9Uf0NhvJMzybaVxBqD0DzCnetvQlhnhtt9ocMR05N3drRBDkubBOPwkzt+xAndlqBzeAwAbyKPT/eI3Zk2LIuHiBTok9L9Eyns9wl8Armku2+eTXOF5ULWYIowPDDTZwo2YuHxCVSqNG2ofyyB9bCCAGn6P4HrBxf1YhX4xGsaZwPUtLT/JMUD12N9XJZOodndkhV3QNXLVQbG6zhXbFnfMJeMIGCz3vJeF/XtsGv8+3GoD8uj5yJstlKHAiyo53KOz5o1eWYu2Qh1s5bk57CCod8wrJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7Cqy3q9sNcRu5cmDv8pPaEcge/MWyzSkih6YQayEPM=;
 b=ZIhoSjUguNnV9xbg+dG6wTV4ZYVeEciH4LHx16PniwrYodcFUyFeL9m7fEcZB1Lhn5a5JQBRdt4harynhJ6Rq+O1a8V1zTqdyVN5YP+qY1T2hgSHYvPGodJcyVatMw8EBbmnIvTJROH7qbUgoUUlK3ujFmN8MiTJ94hEOg087cWBpfBxUVGb5ZdZZ/YRt7A+vudhZhv+u9iD5/JmjpnIZmSYcHQl7ZhoQWfNExZC2Knhfrbb0vFHRRf1EXBMQ7HVcLK95mvoWtegI5fZC43GbpTf9nvTchgkWXa2QChdaqeG1R7qFb4AIVT9sjgDdU9YnKV61KTxxZaC/iTZR1JV6w==
Received: from MN2PR13CA0002.namprd13.prod.outlook.com (2603:10b6:208:160::15)
 by CYYPR12MB8654.namprd12.prod.outlook.com (2603:10b6:930:c9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.17; Mon, 24 Feb
 2025 09:18:01 +0000
Received: from BL6PEPF0001AB55.namprd02.prod.outlook.com
 (2603:10b6:208:160:cafe::1) by MN2PR13CA0002.outlook.office365.com
 (2603:10b6:208:160::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.17 via Frontend Transport; Mon,
 24 Feb 2025 09:18:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB55.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Mon, 24 Feb 2025 09:17:59 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 01:17:41 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 01:17:41 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 01:17:38 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v3 05/10] crypto: tegra: Transfer HASH init function to crypto engine
Date: Mon, 24 Feb 2025 14:46:05 +0530
Message-ID: <20250224091610.49683-6-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB55:EE_|CYYPR12MB8654:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aba833e-4d07-43b3-81af-08dd54b4223c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ujsgl96kqIhLpZul6ac3wqzJS6IpzWqXhF7lnD2cyRKQyqmakLJ/6Eb2xUD6?=
 =?us-ascii?Q?pnjT7d1imJb7E3/7LadE/hXuP4MR9VhKy3AFgxf+i5czYW7masoHNdjoS9Km?=
 =?us-ascii?Q?GAAXFZta/ZXbuzjt2lTEQnB8+ET1LdQyU7Ebhs6HAIqWxzQXj6lHNakLKTMi?=
 =?us-ascii?Q?8HS05y4AiAb/J8/pUQ0vEqC/jcuVQ4TzesA1fq1NiEw72U2pYztyFWgCf78s?=
 =?us-ascii?Q?JsChFJelZGV0Rc5LTLbAXC3gZpRDeXYr3i8ESZXgfr6a0YNlTI6Gox8rLvyf?=
 =?us-ascii?Q?pIdP56BSrPi6lIeucrGMpMMroxujCav5FGsWk5CRsqOh8YXXGsq4JlsCx+JL?=
 =?us-ascii?Q?u22Z8uYxvouqAvKzHeWw+cN74Rf3K5KMW9wET+Akvi6AkgKvsr4z2/myINnp?=
 =?us-ascii?Q?3QEGE/0Fe27djbcgpoHw2CHt2CsllbTbeCwDOglZhcXjt/vmJwpPyjfp5xgp?=
 =?us-ascii?Q?3ahpCmBDFqlU/hMgZkPrVugwuFZF9kukzQhK+FgYyux871nMqzl2w2XVe8qk?=
 =?us-ascii?Q?/py/Qki+JFueRKDuo6ySzBn5vk+KnOWklgGmqYYPH1mCLLYtT9uaHS5XjEHH?=
 =?us-ascii?Q?Uu+HzVxgHRNWUjbRwOy8wvlLpx1xHLbtsxClhroLQhuweFhmotVxJepY4bg/?=
 =?us-ascii?Q?EzSsMxqxRQBpjY3zICo29GsSTRZAmty6IcXuEkGuWGpDZa7Kag/uXlmHPlZJ?=
 =?us-ascii?Q?NyT36YB3lJy8PSLtRQed/Zeeu7Iyjn1wQPliTZuOHqGBEzUPHTaFehsWmchU?=
 =?us-ascii?Q?C9cWyZo9ISJdlPOJsXd8Tlyzb9Lvmpm08Jqy15+QwmPKn49tiUVtwPOjlBtx?=
 =?us-ascii?Q?L3N2H17DEU3oYFjJgqMzIhv6UyBkJ4hCda8K19I9dWd15Vp0jggiiyHBiWU1?=
 =?us-ascii?Q?9lFfYaoR0tx88DWcMDJYY60W92L9UZOa4BE6v+sTjOGoe493L2LBMAKnI3m6?=
 =?us-ascii?Q?onRm4bOsOn7Ijj9BtCmgCRaK3Quj2z7xIZCUrw38e3l2zbbKa04GmAdi40WN?=
 =?us-ascii?Q?9xG9+6vo6egMmhdrdDQxRmIj35Pj2r1U25pBYUHgbU9wbPk9Sp2uBRu/Pt86?=
 =?us-ascii?Q?9Z0anGP4FCcwHBrwGUeTHhnb4Gb3EuF2qq/kUvn5f3XOQIEfUEY8ZqRMaQyA?=
 =?us-ascii?Q?jj8RIjQxql3ErLDtkiwhx90Gq+gKnPeQdyHDJI67U9u+oi/D99kF3y7EcZlk?=
 =?us-ascii?Q?Xns1jNmemNOvdhNhr+xh1y2tqW3aiij/WUvskhkt+y2sv5hUcKUxR0DQXuIK?=
 =?us-ascii?Q?qREZTchuDqG1ZcZPEFH30hqBoukFPE3EI08jZ+TszgwcK6xULTjvDfjJZOQm?=
 =?us-ascii?Q?1RdpO1/iL4xS06yl1UGl1OPVtrNFWq23JjJIZCuYSkYrtJmVBCWqiiIMTdjR?=
 =?us-ascii?Q?FzK/Gjb8Qg3aFgbYKnA1BK05wzmxIS8Q+F0rOBBVyg/h62sFixuJ5tdywX10?=
 =?us-ascii?Q?t49lCvgSoa13/ya1mQsqiE5ns3uUYVOSHeDe1SKi97l1th/E93uuxikRXA8c?=
 =?us-ascii?Q?Qw6h/E+dPHweAtk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 09:17:59.9840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aba833e-4d07-43b3-81af-08dd54b4223c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB55.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8654

Ahash init() function was called asynchronous to the crypto engine queue.
This could corrupt the request context if there is any ongoing operation
for the same request. Queue the init function as well to the crypto
engine queue so that this scenario can be avoided.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c  |  81 ++++++++++++---------
 drivers/crypto/tegra/tegra-se-hash.c | 101 +++++++++++++++------------
 drivers/crypto/tegra/tegra-se.h      |   5 +-
 3 files changed, 109 insertions(+), 78 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 5ca7996ecc6d..13d76de2bc81 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1459,6 +1459,34 @@ static void tegra_cmac_paste_result(struct tegra_se *se, struct tegra_cmac_reqct
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
@@ -1604,6 +1632,14 @@ static int tegra_cmac_do_one_req(struct crypto_engine *engine, void *areq)
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
@@ -1684,34 +1720,6 @@ static void tegra_cmac_cra_exit(struct crypto_tfm *tfm)
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
@@ -1728,6 +1736,17 @@ static int tegra_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
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
@@ -1766,13 +1785,9 @@ static int tegra_cmac_digest(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct tegra_cmac_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct tegra_cmac_reqctx *rctx = ahash_request_ctx(req);
-	int ret;
 
-	ret = tegra_cmac_init(req);
-	if (ret)
-		return ret;
+	rctx->task |= SHA_INIT | SHA_UPDATE | SHA_FINAL;
 
-	rctx->task |= SHA_UPDATE | SHA_FINAL;
 	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
 }
 
diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 0ae5ce67bdd0..07e4c7320ec8 100644
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
@@ -635,16 +654,12 @@ static int tegra_sha_digest(struct ahash_request *req)
 	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
-	int ret;
 
 	if (ctx->fallback)
 		return tegra_sha_fallback_digest(req);
 
-	ret = tegra_sha_init(req);
-	if (ret)
-		return ret;
+	rctx->task |= SHA_INIT | SHA_UPDATE | SHA_FINAL;
 
-	rctx->task |= SHA_UPDATE | SHA_FINAL;
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

