Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2059.outbound.protection.outlook.com [40.107.95.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4738A262D0F;
	Tue, 11 Feb 2025 17:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294399; cv=fail; b=iub6TdvmEi87Xu/TAKogUooX36yH/PWvw1Opi4gnwgqAMghRj1Y6WBYw2j/KRWVoiTw8RGguS181wGYqnXhaYXsL6KD+fG3NVP+u/iobaFjRWzHnhUgYK3zNt3FIUnUEdkdPtTumxryJWFzwJocOhvDcPccKiHKZkdIc6nDDCxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294399; c=relaxed/simple;
	bh=wJb6IrX1qTl6YiD8NDIjKcntz2OzJF1avICH4elaI/E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NE/sIto4PxUvSQTsreYlPVcpJkrwXMnM/0ymo36k9rHONIJCX7pgc4dfvAlwrqmtq4zyx8N97aNP4PB4A5rpruVdaFFyfCRBHYkx6fTVutHFziC7VWSr2FQ9MmuvZlyHAKEMDcn9Uv55lThUznwWbJUkUj7LiUewQ8X0Op/Et+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=piEgRC8j; arc=fail smtp.client-ip=40.107.95.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="piEgRC8j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U/MfBAHNUeFI5GIy74XiOYUlH3QTpv7yWQKKoEYqtE3ZVDU0ZRzvOfEMbhhuCraSZPlLKsZsF7ea8XS7/wrd7GDBgUGqJuP03mlgflYn2jhf1C4f+XJXAKcyD5qoMpnfc0MV32QAge3OWmRHeEzXkLkGDNHjA5veFoTvNkA9cSBfOiFW+IATrDUUiC9G+tH6Fpt9TNK+KuBYeBXaJhNcRZksJ7rlA35ADjZzWrBKAHhYAM+1RqAouu2zh4TdZWjGijf3OM06MpeJVu63M11DkdUpL9+xUtKnvX37cpJWwfBQWzFoaQXYwkpuDF1CFspDPP/r8Tqf1wMDQqkbvNhchA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8J5cmJL8kFZYpJ7KtX3gXqX+N17bmrKqQkkpI7yKwv0=;
 b=LefhfIeMhM55hB2OGh40oxJygqaagiWXbQ4N8Bd5b66ZOKK0qwVsBvzSOoKlNe1HLDN+dfeCucusIJRr5pVwsFpGqVclNK27TuVsQI6uuEk1aIIwBjGmIGN5KfLSLm6ypis+mBcCqjGh+ggH6PrOLdn8gDyj8j8P/KXY0wqWuIsVHyLaQXSO9SgYvylSyqMg0u3ptXv7dWkVJqpFyYlxuI5nb9FKCLOZGlWLDapsnQy8g1RwmEP93zApFGpdssosF/osr3cfgx61cUNWvlAC3QtukenPlHq8GXC40TC/EJichcMFbmMkL05g8yTEyr5P9gckHUYw++OUjGhBwTpO5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8J5cmJL8kFZYpJ7KtX3gXqX+N17bmrKqQkkpI7yKwv0=;
 b=piEgRC8jwRCfc66Knn3PG4xmvio+JbRkyoKUxAJf6N7h875KgxCzNa13DapoWLixs9h37+iorOOChtzNMoRXNnUGgxuqCME4BUrs8YdUzzL8PEdxHvdhnlejbk+f5sJXuqrAswg0ukBAyxybFNXucMwUwMGe7bIA+14Rg46onp1rUV9Cs5kztantBhlW3+dODac6KQcuNcX8RRuKVZ9ALr3lat/QyF2PgiFmcMYmK9ncCshpMFIIWFrO8NQ66eEENedoNys44cgDhggBRkOiUR5gROPQL+AWospZGHBpzU3cxB/VtZkhD6ZglZ8QruUHZaccoa0FOHEISm7I6XS9ow==
Received: from DM6PR10CA0003.namprd10.prod.outlook.com (2603:10b6:5:60::16) by
 DM4PR12MB6062.namprd12.prod.outlook.com (2603:10b6:8:b2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.12; Tue, 11 Feb 2025 17:19:52 +0000
Received: from DS1PEPF0001708E.namprd03.prod.outlook.com
 (2603:10b6:5:60:cafe::9b) by DM6PR10CA0003.outlook.office365.com
 (2603:10b6:5:60::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.31 via Frontend Transport; Tue,
 11 Feb 2025 17:19:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0001708E.mail.protection.outlook.com (10.167.17.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Tue, 11 Feb 2025 17:19:51 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Feb
 2025 09:19:37 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Feb
 2025 09:19:36 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Feb 2025 09:19:34 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v2 05/10] crypto: tegra: Transfer HASH init function to crypto engine
Date: Tue, 11 Feb 2025 22:47:08 +0530
Message-ID: <20250211171713.65770-6-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708E:EE_|DM4PR12MB6062:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ad4950a-816f-4811-b322-08dd4ac04bbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r0zGTSMEXm2EyepkR5wUtWwKxcjoqwkhSv5m2AeH11I9zElmBY1+nM6LKvRC?=
 =?us-ascii?Q?ioJ5oMpo3CYsCKIse30FNEdTapbrR3sWNDiS1Tt3MkEQ4+z69R72RDxSre5Q?=
 =?us-ascii?Q?6U+3Lx1bWE4/ZJYnaB+5vzYfg5XrvSYL9bIt8FNLN6idCcZQXHCa4kGzfyan?=
 =?us-ascii?Q?LUuH+fZ5HXTqX+KmL6voBIu5hHMKw4KeptawdLLCSS5JsP+mDRIMwfE8KjDp?=
 =?us-ascii?Q?0F/i0APgNSaUgF12l5KkBzy204ewutV71Js9ONvZBLf0xiO1d/ST+j8mHf9r?=
 =?us-ascii?Q?Ri37jsynaSs6RzAv8NOQvdVHOe/HA4jcGeAZiSSZUcczLllXGyjdOfI7J5Jh?=
 =?us-ascii?Q?L4id8K9EqPus8e8hO7H2gsNkHAYU8o1siclQFR4NcRUcL9kGOmGHRoSZwUUF?=
 =?us-ascii?Q?XbIIr7LyTK2XvBm+5AVkYaGoR+YKfTguVSNmgjbvZSTzf1AEZioBMN3rKrXQ?=
 =?us-ascii?Q?f+n6nFV4/3lf+VO2qHKxTo165bcC08UkXJWvuyDl8x5k53R7D9dWUFAYOFb9?=
 =?us-ascii?Q?HQ8tpSpu5+msZ7KEe88IR4YBN1RNSYEEHKbIxrbkKoFv014rh4oAB5641MRa?=
 =?us-ascii?Q?AxspJprJpwZS/zbtQpQ+4q8F+Ee7mxtotefCOcAz4yENoqmhlkaexWYCKEWB?=
 =?us-ascii?Q?UtlSUpduF+NQcKOUMO5/i7cYFzGIvQloFOLXiNIYY8tgJzEKmf4KCiXkgSRH?=
 =?us-ascii?Q?WL32c7ynMWdDchJcjiX/qylcxXWcCFeHhSYh6fANXOL8n/O+BmSx61WGkUK3?=
 =?us-ascii?Q?KvBMX7bazGvcUkQGSSOlH7OAI/G8jB5Oria5hKHqrr7wgNWmDz86At6vZyJ4?=
 =?us-ascii?Q?Vx24tm9vYVXJGh3seDKuaSyjMUFSaHBOVstkkSFFgIGzbJ4e1cqbYxr6HtBB?=
 =?us-ascii?Q?jbNpofAH4IiebIA9uhAPz2yBiqva71ibEGltza/hAiGKq2tUbqTL9kEez5a8?=
 =?us-ascii?Q?dF1f4Brm1all+3RxH9AFgDL4lLKwK6NPZhlAyVmJZITaMduLsjLw9RUKX1b4?=
 =?us-ascii?Q?W6FgInB5Umkwul8gPovR6tbet5ZbUAPYiufGWROcVtkUmkAuOspmwXATqpY+?=
 =?us-ascii?Q?l3PEQvGlxbIKYdNnf39JSODLqryKcvcohLfCZXKdiANViQ+vKUhpqnaQWQkK?=
 =?us-ascii?Q?7cCSxymDq1GHIhGydb2mjnBgVnrODMQigj9n5YGaBSFEAe9Ia54wC4U074u+?=
 =?us-ascii?Q?N65+NXTAcFRt2lAUEYPLL+pVO0MJGlQ6Lgsm1ev9NCKDb5//iPpqWnNkTpfm?=
 =?us-ascii?Q?AEpurcw9YI46x9GnU3SG5SUbwLfOQF05votyIJL6iio0bBiljYJ9cyFH863r?=
 =?us-ascii?Q?vxUZQCXIgMrl3LlPysWXkCWHdYiVFJ0KHLGUgN02nT01Dvv4FDnI0l97bqjz?=
 =?us-ascii?Q?uOZCIbn44k3JxWRUBEiOjOLn7wk99jDH19afpcShrXEa57zIeOrxLdhcvdiQ?=
 =?us-ascii?Q?/Zxr0eNm3N81SoTzqcCVowT5NDLwqeU+5uCF5uKSrRhaZrB9/V+9iFXDuJyv?=
 =?us-ascii?Q?Y0ZDFk007ZONf68=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 17:19:51.9684
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad4950a-816f-4811-b322-08dd4ac04bbb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6062

Ahash init() function was called asynchronous to the crypto engine queue.
This could corrupt the request context if there is any ongoing operation
for the same request. Queue the init function as well to the crypto
engine queue so that this scenario can be avoided.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c  |  80 ++++++++++++---------
 drivers/crypto/tegra/tegra-se-hash.c | 100 ++++++++++++++++-----------
 drivers/crypto/tegra/tegra-se.h      |   5 +-
 3 files changed, 109 insertions(+), 76 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 5ca7996ecc6d..2d5a59f0b249 100644
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
@@ -1768,11 +1787,8 @@ static int tegra_cmac_digest(struct ahash_request *req)
 	struct tegra_cmac_reqctx *rctx = ahash_request_ctx(req);
 	int ret;
 
-	ret = tegra_cmac_init(req);
-	if (ret)
-		return ret;
+	rctx->task |= SHA_INIT | SHA_UPDATE | SHA_FINAL;
 
-	rctx->task |= SHA_UPDATE | SHA_FINAL;
 	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
 }
 
diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 0ae5ce67bdd0..6da18f0f7ce9 100644
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
@@ -640,11 +659,8 @@ static int tegra_sha_digest(struct ahash_request *req)
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

