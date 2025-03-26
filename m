Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2045.outbound.protection.outlook.com [40.107.100.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812791DED5F;
	Wed, 26 Mar 2025 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743000706; cv=fail; b=JI8RwINeCZziG5Ap/r6SsA5DdhXxqPQF+XkRMzYHHSDOim7wndXEczndkKeWuD3YpKnYU3Cw1fxyR1hx1q5mSgd464+LPbxb9zOJtI5/Z2k6Uqy+EmkPWpweWn90m/SwQzNoHn5Q7bDwsBus6h8rg7Q7JV4aLH7k35b3YgxAK3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743000706; c=relaxed/simple;
	bh=lKJYS3yqbijytUjk9kx/KiLnGF3suEEaQtEIWdMfCqM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kJqoHLkWUIU0W2Mw0xtuEs7RpVOBGmRZuPFzkOlVcyrmZdGjTBsTGuomqEkOjVmUU3e5TRQmAeZAYgSWo7vWiCk1ed0GGFR5nC1a5g3PZEd7V+sxHTfymWID0nFsNhaWyDQamW6xHVo7Hj5kGWsjJt2mUUDirVupK3SDk2ccmcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=czJXluoG; arc=fail smtp.client-ip=40.107.100.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="czJXluoG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hAVNlrmTC7YsHxSPZ2gqQNTaI9GXRibwy5ELAPwOJydnfcn8uMHy2xNnE3eFN/mliDBWBpjLYxu84l6uYrcaiGAx4AYopHLG9pPRduwUpMtX5EeeDfmc542LGygGx7iF9r0WK2GGy5myJT9KrIn18hg8cXRblhZC20N1zXDf9JZFc8Mj8upeiNVJDvrzyapIqmV4lIX/XfQYt55nQdPlyla8IGB/XuAOUbPRLXoxn3xMR7T7w6lIxw0VhpdxXmsEIFXfOWWgxMVMrgK+N5tkDzqYX+x3iGQwPt9D2kCWHr7xtcv/A5S23MzukfKy90NrhezlHIV6cjlBDcPR6vvNyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ny/skl1M4u8Zad6jVHcSfa61Xg88+FJTh4cHVDrCRys=;
 b=RwZflJrqBwVmXrdaR7oDZTfpdAwHwUeVAewrORxLC8vcjv3NXOfdC99sVVcHgRdt8ShOsEeXf0T7TAx3YvWXDNIrpoiW/LAsLE6qxxUZYxTEuIf4T/JgKFG9S3nUMb45JcbWCWDNEQ7KhgKMhpgVKozTee3dbns0WyBL9ga6QwicnSqfYDGUppZjDTXAM7rOQvgpb4H6IEYfyAaxXh4SPGFhDMyrvEY1N/82kiPhvJtoq68Gm7jIXxxO+v7iPQvf+jZ7HC4EvDKw2D/4iOM56g0oRkCXl/6cXiMZNKxRBxGMmYJk4Ct93BbgSOWJc8VFJ4fMzVQYm5AdeKNZPk/F7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ny/skl1M4u8Zad6jVHcSfa61Xg88+FJTh4cHVDrCRys=;
 b=czJXluoGe8lTAy9MjRTsoPJq5Qetfjp90HeKC47Y6AXH2xxLR+HXIsvTJktN3ZeJ+Z7r//wYmwnujZKXB0X1fayB01qMQeUPmS9AOoLvuzroZytLheNuNEQC+6NHBOhuHK2qA1PVWRKpz3kqp30cN9XbtyuFHt/1Ju0dK+Y4noRChRLDJdLbosn98QcopnFhb2ajt0xlKGnqH2PwmWZfSXCMJj5lbu5lneKtyaC7vAmj+UZQxc5yDsbrJbC5s6LNO6KJ0jfzkkeoL+HYmVXVS8n2Ui6ObCzUEepYhC5WXEsIMee8RI0yTunRs5e4o6exFoFhEm2BXehoyTVJdNpxTg==
Received: from SJ0PR03CA0199.namprd03.prod.outlook.com (2603:10b6:a03:2ef::24)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Wed, 26 Mar
 2025 14:51:41 +0000
Received: from SJ1PEPF000023D1.namprd02.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::8e) by SJ0PR03CA0199.outlook.office365.com
 (2603:10b6:a03:2ef::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.42 via Frontend Transport; Wed,
 26 Mar 2025 14:51:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000023D1.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Wed, 26 Mar 2025 14:51:40 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 26 Mar
 2025 07:51:21 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 26 Mar
 2025 07:51:21 -0700
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 26 Mar 2025 07:51:18 -0700
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH] crypto: tegra: Fix IV usage for AES ECB
Date: Wed, 26 Mar 2025 20:21:10 +0530
Message-ID: <20250326145111.57991-1-akhilrajeev@nvidia.com>
X-Mailer: git-send-email 2.43.2
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D1:EE_|SA0PR12MB4349:EE_
X-MS-Office365-Filtering-Correlation-Id: 670e3566-eda7-4f7b-5828-08dd6c75b7a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q97W1XbWpiOtuUV6caYkfy1ri/2DWUcPwnve3PkhszuAAL+2Q2RZEfbTgU0j?=
 =?us-ascii?Q?wP80cxe0Nf8oMHhNZb/l613K0oIjLyGK7cwnCFktkFm7McQgJCVxu5gP4R28?=
 =?us-ascii?Q?yiSkPbhhj5r8qyxyw7WP/lxDKzaadyhweTUwgIWKUvVFI8Bz2zqLJaPxT5ve?=
 =?us-ascii?Q?4ultMZZGdR2XZ58HCCMriz0wdTFbA3GIZMs39TiEJOZAZ7u+qY0gp99/MsIL?=
 =?us-ascii?Q?fIe04l1fpUMUXp26MN13CrDPxHEi4hsEq+ytHZo4rPaG+fsjpu1t+qbk0vvi?=
 =?us-ascii?Q?JEJbJhz1UjAw7h7RM+owmOzxVZjRUtSsypIdteVkm1Uvszidf3l/1Eb/nG/h?=
 =?us-ascii?Q?o5MIQ1FcNhVN1iltAIUJR6RtkoL/nGQtMuY8Iqwbbjw/YITq1Uy98BpDptzX?=
 =?us-ascii?Q?Kn3cGD4tmcdsAAkFizMM1ppKVsfY+s0k/tRqa36bnwmAF1qRpwbqC207mJlR?=
 =?us-ascii?Q?yT8zJT3ThPTjpjNNbAs3ITKXRb1LD25I9+D3Ma4/ee4ic2sKiXiUqaX1MNkT?=
 =?us-ascii?Q?CV1pUVt9rzmC/C0M4BA4uD/NBsOqYpIhY8JsB1xYN2p63lkrOzJz9XwSw4P+?=
 =?us-ascii?Q?bxM+WKMwNGchl1q3dtKT+PgGTCaii+wSu50cE9Bop+XKOQs/3GY8tSnruQWn?=
 =?us-ascii?Q?PvN1gnYp2OWD27DY8gT3WULpMlDWJOo92NPWKPpToq3dhlp0zzwR6XxAurlN?=
 =?us-ascii?Q?ZUHyG51C+M5ozNJQjSvMgVRO548aXbTvmUEvdngv5dliAek4RYh7ESyHqAqJ?=
 =?us-ascii?Q?XyY7XEs9YXjY5hXyCeyzTtBjCpF1GHKe06pLWxWRbEVZgwsEXwX7S2A80kUI?=
 =?us-ascii?Q?sEWEJd/47MZ0ocbFx1G+Sqfjr71hjFCfkkGEKnFZhL3cMUxpd16y1fORDNxn?=
 =?us-ascii?Q?F80ybPJcnK2TCpn4ee8riEvHRb7vch14bgq0jUWSssYZK4JYQDBD+VDdaQ2n?=
 =?us-ascii?Q?HnHaDPO76VZPqUAhzB4YnUM77eMLEVdAeRcppKaW7jsdAfKPYUWjNAmXUz3+?=
 =?us-ascii?Q?MzXQYV9Qb0qrLlHStJGrNT3a120AFiCB1MU3bIUP2imo0ILNs5XteNi4SfoK?=
 =?us-ascii?Q?3ft+q7Cxm5Rt46DxThFdavFzRCYLzVaNlbgEgb98BynW22UxEY3WTYhFF7s9?=
 =?us-ascii?Q?TM6E74F3DftFX3FeLhO1h7RXj4S8+4jE4MvV5wEcOILHbYLWhhpzAPhosSzv?=
 =?us-ascii?Q?yNbagkxwghrHEG5L2CpHUBWuGqDLcV0nm1qop1WMNgaKCbXovXasUqVVq8tH?=
 =?us-ascii?Q?0zb7jivNHEbtoYNSMUsItInbmQWtgEybn3VF0S5yM/MI1Jg+IxGoq/E25QUi?=
 =?us-ascii?Q?QGIKVzI55BRVv9kARalVC9g/bo7BooU+MSbVilR0pRUydZaePLHmCMwQVXsd?=
 =?us-ascii?Q?sxFjktKZN0vB32EX8mts8fp9YrbeE7IzjppN1BO1VGBArB/V8O3XA5i/9et3?=
 =?us-ascii?Q?HLXfFeQNN9EyDIOFYQ5RKFJxVevfxpJwY/6VSqwWDazyk72TVaFC4VuTBFjD?=
 =?us-ascii?Q?46I6g5zXQYIQ9cc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 14:51:40.3137
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 670e3566-eda7-4f7b-5828-08dd6c75b7a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349

Modifying the crypto_request turns out to be not the right way to handle
the stale value issue with the IV. Though the IV is not used for AES ECB,
it eventually get used in algorithms like LRW in the next step after
AES ECB encryption/decryption. Setting req->iv to NULL breaks the
implementation of such algorithms. Hence modify only the local reqctx
to check for IV.

Fixes: bde558220866 ("crypto: tegra - Set IV to NULL explicitly for AES ECB")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index ca9d0cca1f74..0e07d0523291 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -269,7 +269,7 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	unsigned int cmdlen, key1_id, key2_id;
 	int ret;
 
-	rctx->iv = (u32 *)req->iv;
+	rctx->iv = (ctx->alg == SE_ALG_ECB) ? NULL : (u32 *)req->iv;
 	rctx->len = req->cryptlen;
 	key1_id = ctx->key1_id;
 	key2_id = ctx->key2_id;
@@ -498,9 +498,6 @@ static int tegra_aes_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->alg == SE_ALG_ECB)
-		req->iv = NULL;
-
 	rctx->encrypt = encrypt;
 
 	return crypto_transfer_skcipher_request_to_engine(ctx->se->engine, req);
-- 
2.43.2

