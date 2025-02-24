Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A242512CF;
	Mon, 24 Feb 2025 09:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740388771; cv=fail; b=auAIt4vUatC8Sry+QHMuXDPnqDobWr+ffxk0PC0eMKg9NhWDibGqJquHSXFRF47Krt6B8a6g+Qx/W2f1XqGs7Zojx6VRePGqJ/OeWvHK/G1zM9zZzlMcBJj/70FOFbqTvmZt2HxD8kmFBsbJgm+fNzmcJgpBiTQ6g/N/+ar4Znk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740388771; c=relaxed/simple;
	bh=lHYe3Mli+tkd0oKiANZNynKgD4O8IP21Giv9eBPFrKE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=apqCU7V3Tj8EmGVTh8e+3dwEC48vUl/TF1S5+i3YOgZ8ekj24Cj12Na7izLFzV7buBeRetf8b/By0KzckaD7gNLTjJs/yc10ZEsrmWzm8U83K+KYxky6qDhMLu1JRFC1YtbZYQ0x+6XtZfJwPS0g9ivX6l0V2GKFX8Sqlg0dlHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fKNyWC/t; arc=fail smtp.client-ip=40.107.93.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fKNyWC/t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cba1lby8+XS5P49COe9SfUecAXbH1NQOMA/u3tGtL0t9+pRPV++Xml3YvaknYu5NKls1E6X5WyuE4RAcEweP6RRpdl/KNuFSCZDntEOVozwdnLbPjQAFgRv04uiTEXyvm8MjB0ey22/7Civ3QZAldpgfAS0AX0EPT1EzjY4d5W1kCjY06VnpzO9Fc3BsG4gcwFNuiODowmhEWMA5ZZ68ylbcTscVWSqJPr5/emUY74f3k0XYg3J91es2sx2m6FbSRd52n0NPqzs5CJd/1LanR4L8YWTG0eAQRJuU0N158bBZqPgVnQb0Cv5nKn9c7RFt1TL6vkrnTyFFJpFe5lLPDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QW7LCFM7Vr0bEJ/swnOhbZMhXQUqpciF9luYxMV9xJc=;
 b=b94z8ORPQdwhw5uVDMmwUuHP/rnCkmGz+ZZ1SlJJe75enFwiB0/7PS8X1D6jYB6fnNCsNUhJ8GwGA/U89MEfe+USfKSxpPA+VGkhtfxbZ/9oLqurl91N7Iz6xjNLzYlecw/fbNvJRXSPRuDMT1NbVwhgUFJ0L0O431eugWLpu1mVFC7RKJpbX+JCG3eGmy/seNuA/2czb9abK5qM0Aaj69Q8OWV44sF3vIpd67mBQ+4aeeRFM+kr51SqaZdD59B4fGkbhSWiB3Ndvxy5/UmNc0m3iA9EhzXCCV1vWE+b0ZvQeyADO5kyqb4EIQN4aek4y1gSYr5QrOLT47cf3ziSog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QW7LCFM7Vr0bEJ/swnOhbZMhXQUqpciF9luYxMV9xJc=;
 b=fKNyWC/t7A53j6a/OBuW0+HmqJ9/AUE1nRWEpkOuq0nEjmU2N0Y715ZssNBWI4eTb8cZ51EkDNw+wjFnnRmD2OBXUXiYWmsPwy4A0UpbcNgmiRTaDBccjFWOdJ9Z0gtSTSyKGrTPednSj/ffq9oqp8OG4bDTDhq63Zj4uBCIRxs/zbTy3kE9IW31mFlL9GLmfam521ESSy5N0oNo1Rq7fkHP8wHbbyClb+Klqr15v2peRJ0At3/lirctDh8ZjMRnu2l4NIGOl3LsZI/2mIQ0ag8LFdAi2hTL1rtRHTFxI1HUDQKB8VKolgZxVN2H7XHww3lJ9Vtxh9ce+zgCXy4OCQ==
Received: from DM6PR11CA0048.namprd11.prod.outlook.com (2603:10b6:5:14c::25)
 by PH7PR12MB6467.namprd12.prod.outlook.com (2603:10b6:510:1f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 09:19:21 +0000
Received: from CH3PEPF00000018.namprd21.prod.outlook.com
 (2603:10b6:5:14c:cafe::90) by DM6PR11CA0048.outlook.office365.com
 (2603:10b6:5:14c::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Mon,
 24 Feb 2025 09:19:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF00000018.mail.protection.outlook.com (10.167.244.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.0 via Frontend Transport; Mon, 24 Feb 2025 09:19:20 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 01:19:13 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 01:19:13 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 01:19:10 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v3 10/10] crypto: tegra: Use HMAC fallback when keyslots are full
Date: Mon, 24 Feb 2025 14:46:10 +0530
Message-ID: <20250224091610.49683-11-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000018:EE_|PH7PR12MB6467:EE_
X-MS-Office365-Filtering-Correlation-Id: 8573c151-5a66-4c4d-d597-08dd54b4521a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m+HKD0FmE6aC9wWmYVH6eRQ8IunTfoC1p4fsgtSn0k7OsTJAV00PbUfZCH0w?=
 =?us-ascii?Q?kwRCD8A803p8CizEeU+UzK9EOvDgC2uoNViFzODOwbvDNT0bwyiJX/5rTniD?=
 =?us-ascii?Q?pgFa1FbWZoqZlnFWdH6923wt0OPQECJuuj9KqL+dowNB1t/WPSUAFjqQJXeK?=
 =?us-ascii?Q?664PcAubcyzISGxAmmKXcnknMzPJxpKXVBw+BXuv034x6zIG4hAC4cWlL1hy?=
 =?us-ascii?Q?wtxYcEEjBXc98WAgaZonygBdN3mw+B7F8Cn+/pacD+h7DvX2M6/+xNvlq83f?=
 =?us-ascii?Q?UNoOGRoa7T4xx2qP/vVG2AWheyjB4bdmf5zyIECnb2jNXbMOgC6EkTXLJu72?=
 =?us-ascii?Q?UhF7Ay3YDnlMUr3EsOYfPbmCFl21pipFQugDOErn8VZpBjR6AQ1Wyb0kRY+r?=
 =?us-ascii?Q?RwRXgJPvkeamkANNCObpBzA6V2hsdedII35bUbdK7WcaCsrdNQXUi/DUtVpl?=
 =?us-ascii?Q?lOqWnTfpJ/hKK3JSlzbsH1wL2UdUHGH/kGUYdtWPJeOXg826DwSeNqZup+WJ?=
 =?us-ascii?Q?8omauBNI5ivGtpzCld5vtNmRnS5fqvGKsjnki+4KMR5pMTTbRs4hU0cXsnwg?=
 =?us-ascii?Q?TONJInY6AyLx/MqfU5qtH2gDuSC3XXiNKEZkxnEO+Nh+cJlqUQN/EXWLh+co?=
 =?us-ascii?Q?HvQhmwFHHNa1vbrWF/S7g4X9Ec7Cqhr7hVJCfWM0xutmKFiAidOtUJb2Oo/H?=
 =?us-ascii?Q?lUdns8x5KY87CQRrFwPvOxytuOQY118S+Sdn+ciyHkDiyx6FD+x2VOlybTik?=
 =?us-ascii?Q?mKYjLczdvAVWNUOEk6lWJU7L9GJRBHOETkKHeyT7B9hKwhlbPXUOJG4udhVm?=
 =?us-ascii?Q?LU4CzKUZr5wTx9uKysziBOf9lX16UNLQkv3NIoomVGxndN5kAnvEip8tPPgt?=
 =?us-ascii?Q?luYK6aSE+iw/uCd2D97VT4QyXS39Wl5aXEc2FaAr8t9GSQ9atHTc0E/Ij20w?=
 =?us-ascii?Q?ewHEnv71vQM21ZJyGCi9E+vqd96N+1ZGvA/XmQHCe+xmdoMVOgkHgMbsbXLd?=
 =?us-ascii?Q?MATGACE6tpaJRdYRAp2n6aEZJH7inz3GTXZ9u8bq7MUeISlayiF2m8egwY7v?=
 =?us-ascii?Q?qhtN2IJnObfVYsc70rMyEmMoYuFYWJ2ECmynH6kC//dBvhnwW83iEWC2OAPX?=
 =?us-ascii?Q?jaqYV+AJQNW9cAgj+dU3ZCPJAtwfCbM/ustbwEbvm3Fri3/5kVVBZW3/ADq2?=
 =?us-ascii?Q?BKa4a2bsL7fm5HHIYRiaHZBMQYNKEyQJdjFv/GyxRI9FRkdNNPK+IRCVbhwu?=
 =?us-ascii?Q?89k9JWI3CU8Kr/DyjeIN6JZDLpzmYZrglpEvBdXyYqdJtQS5R81xI6m9ul+D?=
 =?us-ascii?Q?Phq8U0My+5RNISDiXAjVjWyGYrDUUpi2GOinOfvUBz30B9zG6qwK6VV/9Fnu?=
 =?us-ascii?Q?OLQ6XrAIicGc609JpYTH67Qsh32bxg48wpd6MbNFCI3kYB221CIa60e+Baj/?=
 =?us-ascii?Q?APFL88rF5yjmhOmYVxCW+JIo0f6/IVO9mg4o7pQfnvQCtSzpLlTYqfvATeEY?=
 =?us-ascii?Q?QVVx8NO2E+AhUog=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 09:19:20.3565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8573c151-5a66-4c4d-d597-08dd54b4521a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000018.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6467

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
index 8bed13552ab9..65a50f29bd7e 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -632,13 +632,18 @@ static int tegra_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
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

