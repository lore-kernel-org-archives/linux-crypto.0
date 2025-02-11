Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C574262D21;
	Tue, 11 Feb 2025 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294474; cv=fail; b=Co59ygllmvpceEyTjPEyeUrab3tlq/8AvWXdWgB33Qw8hkpIr3NawPkh+oZcM+ZZpAp6c7tOn6nCLJ/8jd9EVhSV9cUZGbFJBqBtyLuMla/KLWNqLKBSygwGjMS1x4Sjn/RSCA3rjRhM2w8D1s2y9o+1dmZ6vdy3pZfe95NaVCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294474; c=relaxed/simple;
	bh=37W3yOA3j/RWRFmUR0HLIPlC8kpGry9zzti8PefNSrg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWFlCAI/qPUUVFOeoZIzZQLkS+gbCqyS0eJDUUCoTdQ67pJ3I3wZUDjH5Y06v+vBxWZSSf0JyELD2G7zUgIrxpNGL5IwUcQ9hCx/CYRw2vZ3T0W4ps28arXj+WGbP1zto+/ZRbWwckSFCg0jSexQ2Hh53oxDTdwtJ55HlK8X7o4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pa5CMcHa; arc=fail smtp.client-ip=40.107.236.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pa5CMcHa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JK7I4N+limHnlSh2eSPA/LSh0r3l/9Hr/a1w0GO2JJB9LNzb1ZYnmUJCO4wZ98POuxtHGY0xDeU7mkxNjC6Chhm8NNUb04RPUCxl6uYV6xFX0efcoYI/iwSB2XT6dkw1ZOssoCOG+5LB8vFXkNWG6qjftXJHNEy9IFx4YMktiE1Az7i3uonIgM9S46ifTJnoRFkuSEng6pZFw31M7e9M06m3zkpKaE6pQs++5LtNusGYhscUvjuj/A96Wfj34/tBN+MM5vUXB9G5vKbv33qsHlziVdB9roSX0top1bjlFGL+zWKFvTX0jwwG5wSbH4Tk9SJ9Kfd9QLw8EOAPxL+jJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2xkh8gOUn+tIzldnXrb/Kpm4oA/hXqAd1LJMDcwDARU=;
 b=ury7+Spupsbq1ZIwvw99kPViVaK9RmG5mLS8xUcxCw4DhkoIX8Nel3AMG0paqDGRUQaHxzHa1mQu6Qt4nCWV4P47OT/eDZKZhrYdJyKRTH22TulKk0XxnK5qbgwbsJzuEVn+R7/SkxHuHlY5mfBaTCbulbbQ7LpFIyfwZnl22OjF2xOx/2Xb3OTPRT/qPbpvlKWdCJASMX1REjJNg+SbYi93xsAUT3quMNKHiZG4b7BcW5PFGEijLiLLn9utD7Nx/naqTeFL/wFVWALwE659hyvJfmzrG1Cg9mO+v4R39FZWLd7b38wLJworFzKSn621X/ue2z1ReXQ94l7v3K2Vyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xkh8gOUn+tIzldnXrb/Kpm4oA/hXqAd1LJMDcwDARU=;
 b=Pa5CMcHa+lkvMvuH2RukCtscbvzlPDnfUofOTr/WUO9z5ZL5Xe1ole2JnjDxIWEbkcB84D3yjGNwf/R/SZeOmxXtMF99fxNbe0P0wdjBOcnQOhl5UaJA9tkuCbelNfwnQRo1ht5DtBOfR6MYRi/GfyKkQMnJx1mmRE7Q1xlHzBGE7ve5gQwGZ8AlwpWGF3f9xhsTPd19taFcmD0tWFoIYY7k4sWocfBG/lG6NNw7OhfvNh3+GVjDV2aZ2EleH/EEvs1b/9b3dI3uXbke7gqzA+GAc5MwHSD+FgyaMOqltDt7dDfDA3j0xM0r7h5HoKoWzoFEN0+Kx5Mqyk0FXDrDIA==
Received: from DM6PR08CA0037.namprd08.prod.outlook.com (2603:10b6:5:1e0::11)
 by DM6PR12MB4108.namprd12.prod.outlook.com (2603:10b6:5:220::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.11; Tue, 11 Feb
 2025 17:21:07 +0000
Received: from DS1PEPF00017095.namprd03.prod.outlook.com
 (2603:10b6:5:1e0:cafe::ce) by DM6PR08CA0037.outlook.office365.com
 (2603:10b6:5:1e0::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.31 via Frontend Transport; Tue,
 11 Feb 2025 17:21:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017095.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Tue, 11 Feb 2025 17:21:07 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Feb
 2025 09:20:44 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Feb
 2025 09:20:44 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Feb 2025 09:20:41 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v2 10/10] crypto: tegra: Use HMAC fallback when keyslots are full
Date: Tue, 11 Feb 2025 22:47:13 +0530
Message-ID: <20250211171713.65770-11-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017095:EE_|DM6PR12MB4108:EE_
X-MS-Office365-Filtering-Correlation-Id: ef9ff5fc-8fc2-43cc-ccab-08dd4ac07884
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O3PzD+nocRCCb5EqzABvpZ8ph1Uv7K/60aZ+aKA3nqH9jJXiJ8SpMECBBSKr?=
 =?us-ascii?Q?iAcJlgesWDpqrCRgX2Gl0LyCUBDg50/sZonlX+wD6qMHUfVnaigUIlnjVI+8?=
 =?us-ascii?Q?u4Ly6EUxPDiw+Yf6M07cb8z6IqSGIJ77+vABSWlFnO2GXwaOlKrZ88JLdYPE?=
 =?us-ascii?Q?M6XCMwe5ciu+iKHYSwY+85/5OLiEWXESKr9BOAPJy8t5CYfWnai4C1JXv/UW?=
 =?us-ascii?Q?GKGFQ+9SUKOsS+uwy4j1rV+S+Hx9Cw0RbEB98V2DN1tXMrLmDrOaP45NGqLA?=
 =?us-ascii?Q?3eE/gFcxlw7B1NfhiAg5Jbb0vboEKS2kIu1B630nlvUZtlEagz2qu9vN/7Rs?=
 =?us-ascii?Q?hLXmoSUzQp/lsYFr4H6Y1/2zdJxQGGZfHR13gjxtJhjuvsFixYOUjSecGLYL?=
 =?us-ascii?Q?g5joCCyA7lj4qP1/agh3MMEL/imibbgcN7Ej9ayaO00ahlDj2ikIEc4cyjQP?=
 =?us-ascii?Q?0/0CU6fOOv6Ph9qUF1EEsJtyvnHWpkS8sMenAlkBD0tuTFDbBnku5+cV2NVw?=
 =?us-ascii?Q?mDiam+ONcgZDOIReuMQtBkwRQafd8K+i/SQgJ2O7Hmcac/P2S/VFwJuWgxsP?=
 =?us-ascii?Q?dFeqFK5nWavQlV4qD31ddeT7wRkCobQlBpiD3TnO1ZlrnUUAEXm6a20htlJi?=
 =?us-ascii?Q?aj9i/3yM2zojg17KUbzDlGvfxjyLFOL+Tn6atEW94bpqEstH+HPJMGRxS2X1?=
 =?us-ascii?Q?n4d2ym9CXnnLtlm7eE/kBmR5pQcD3EEnSo/9fL2RS5AAKp6Rpc1XRXj5S72r?=
 =?us-ascii?Q?EDByVMRRa2V5HIecg2QfIlmfX5tTaE1PVvve/QQ2DUKNsvCU79Qk2loyes2T?=
 =?us-ascii?Q?Cf3QTfdt9ooSngY7w/LlJ+jZR+OFudLlZp0HLRH8l0VKBEg+hnGm0fDjP+ZE?=
 =?us-ascii?Q?Wl+368mm7Sli2fTV8RV8VUR8aB9vIa22J8BdJm2aQO7m0VHjxaqhnaPn9weZ?=
 =?us-ascii?Q?B+p1jqZv/1RyRLIakyEPnYktaKLPBC9h/Cc8Yq7hgZFtQIHPJS5N7d21ix9R?=
 =?us-ascii?Q?BT16yQBAAVfSlyxSimEnPgW4i1/I9/VvBQ+eq9VvqPT2hexVhwTKjMp6Y7Cq?=
 =?us-ascii?Q?qB9ORD4VUcIacurr6zGB/D5nPWftxD8U3KgoXZbfAzsCSLyNT3rEKaCHDNjo?=
 =?us-ascii?Q?fCDgMD0UfNeXzo6p5ByQPB5pPmsmizKvp2gqI5885S75toc1ZMM9rYft3H5e?=
 =?us-ascii?Q?EYdy1PfQFOccw+h4ajG23YEG/cwqCBueDu9tNcLr+lJeZERdadGO8qWDjPMF?=
 =?us-ascii?Q?PcFmRB1+7pQSu8sn46ZExNk7bZYp7qaO4cJVTJGAVpM5+rqzMoo5NYuwOj2t?=
 =?us-ascii?Q?KbAx3/Rw1fegB7+Q7MQtvVQWZLcTN4zL2qkcerWALwGc+sSEYqOtcSQjMuU6?=
 =?us-ascii?Q?QvHdMLvMF/w73XHVrreetGJhkULe3zAnvHtkewNDmdpY+wXuoEB/1JE3gcM2?=
 =?us-ascii?Q?fM7OIQJwj6fOwTgnfrsnBJueK8grff1MPVFJdXbrKazU2vAQZ6fUXyRKZjXY?=
 =?us-ascii?Q?wo74c5Vj2OQIox0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 17:21:07.0905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef9ff5fc-8fc2-43cc-ccab-08dd4ac07884
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017095.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4108

The intermediate results for HMAC is stored in the allocated keyslot by
the hardware. Dynamic allocation of keyslot during an operation is hence
not possible. As the number of keyslots are limited in the hardware,
fallback to the HMAC software implementation if keyslots are not available

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-hash.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 89c1e1a0016b..c607a37d5e0e 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -631,13 +631,18 @@ static int tegra_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 			     unsigned int keylen)
 {
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
+	int ret;
 
 	if (aes_check_keylen(keylen))
 		return tegra_hmac_fallback_setkey(ctx, key, keylen);
 
+	ret = tegra_key_submit(ctx->se, key, keylen, ctx->alg, &ctx->key_id);
+	if (ret)
+		return tegra_hmac_fallback_setkey(ctx, key, keylen);
+
 	ctx->fallback = false;
 
-	return tegra_key_submit(ctx->se, key, keylen, ctx->alg, &ctx->key_id);
+	return 0;
 }
 
 static int tegra_sha_init(struct ahash_request *req)
-- 
2.43.2

