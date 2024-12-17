Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E05A1F75A6;
	Tue, 17 Dec 2024 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734452104; cv=fail; b=FWvcefKW4bELzxsz5GF0xNUErDXBwHqi2sY3bEtlkUF1GRqB3BWQDkAX2Sajvj57Kk+2dWdxjxvGfUCrpi9DHPKgJgallrjditu6swuaP0nioNtOlac1yf6wLkuF6/T5zG47vmki5AOLPmf5APHiooyJ8Tc8+Qze/PkxOOTI4Tg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734452104; c=relaxed/simple;
	bh=qayZfjSgSUxtt1LUEtrQbN2GT+bHE/gUM8InuUl4taM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rG7QexoiogAKCjumd95qtjZRyR5yXpPRzL1y76FI1DC6FfgYonlrkf3gO4yAXL+VpEUNjrO45tBL/xaSdbhfgreacam3nRbP3WvY3/K0x0Zt82Yg7F63UHDOMdYrtr4EKNmTszRc3RiOuxh4aF5PE0JuR3a8ywLJ1WDJSUgc18s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Mvy8V9M5; arc=fail smtp.client-ip=40.107.243.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Mvy8V9M5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gj+F3+ecPVBfAggk1FbHheqS+unj7mcJtDGeil+hB0rlcAl1/Zx4LbdWKbFB353ScPeaqE5IITOK/rO3CcIlUJEfnufBrRpGTNElxHULQ/9urOWLJyuBDG+x+pvGZisLVdYQmcNOUAs1o/KaxnIZop74V7NWqigCdlsydqHxE1YSGrO3CZ1C0CSmRS9xcdqqkIMSe9OvSqx8hteQoqDes9K2FQiBnYUQsRSdRcvCAxf99rBxBr/UcIEr3Lb4QrXc69KoPqUU0zaEEWrfBL273FhuMTPVOdwRVWt5JbP0cun0gi/SrMsE9T7n083xKEygNddVmbQIYsepQcv5TvZfHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4pAzyuq35YI7++gb63pUwYIywZttwbekA5LiKoUJkY=;
 b=GA/7qrsYPqhmZzOlk/gu9m5MvHAzq6Hy6fknsWATIQbKFp6buUSKOFC1fgJa1EM7Rb+O5i4y23IjGXq2vUIYCizDhCo+L97BjsiQgwF21ZHdNQrriK4VHUCWzgxgDjWV67DMQpfqDC/uyv5z9hSo9IBk82Yb7puG4csIpYEMf9Y08cZe1N2kIuUdQ5zXmfO0vNXiI9V/FegZkxzZA1cQAJTZJbiDj77Ntt7n/sKDbTqW3T+o0g+3w94LJEqnGyeRlG1aTJiznNWOWMod9yXaqineLziBPR7DgFbB5htScnmoVM4rez0j6kPNDdOfbTIdJgIDgSLInIzVbU9qhVsZEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4pAzyuq35YI7++gb63pUwYIywZttwbekA5LiKoUJkY=;
 b=Mvy8V9M5BQ87iHc6RLXhy0Ha2o1RxxrkDrm0NF0vreWFlGXd+RXZtTck8hVTVIL+kGTA6gCswS15RSh32LrYPfNMuJRjQRE2O1m5ZjkFZDoTVxoC5aQHaDkgJi7I/5iRQ05pTX1fUIXKku1n/UmvM4jLE3P4K+3nQFvfAq8B5q3ohN3ga3kcrbyLNzarf55zwEA9/jDGthEhBfTcc2kqrBSMUQ4ObTudDSxVWyMNKl2bmMP+mb6fRY3haswG8l1IgtDyLYxGZxHHfm6xgrm9fHIKqQ0JfCMrCN2la091To/NZW8tJH/DG+SV8dw7RRfCwQeHeoD6J/C1jbY4NMj0Pw==
Received: from PH7PR13CA0014.namprd13.prod.outlook.com (2603:10b6:510:174::28)
 by SJ0PR12MB8616.namprd12.prod.outlook.com (2603:10b6:a03:485::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Tue, 17 Dec
 2024 16:14:57 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:510:174:cafe::1f) by PH7PR13CA0014.outlook.office365.com
 (2603:10b6:510:174::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8272.10 via Frontend Transport; Tue,
 17 Dec 2024 16:14:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Tue, 17 Dec 2024 16:14:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:14:35 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:14:34 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 17 Dec 2024 08:14:32 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <akhilrajeev@nvidia.com>
Subject: [PATCH 7/7] crypto: tegra: Set IV to NULL explicitly for AES ECB
Date: Tue, 17 Dec 2024 21:42:07 +0530
Message-ID: <20241217161207.72921-8-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|SJ0PR12MB8616:EE_
X-MS-Office365-Filtering-Correlation-Id: 818f5eb3-8ccc-424f-2099-08dd1eb5f2e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YzCr3yuyluccZ3e7lwDSxRc7AqnB83kxwOh+26ZPgxkFhXzt8bwWFQdSy3Py?=
 =?us-ascii?Q?T6Q0ApLZNzOYpbsgw5pg9X+pJUX761B7FYxSMGhUZajOs0UWK6yXKsp4zaAQ?=
 =?us-ascii?Q?OMvYpZV3HHbN77Yk+1C1YANnYGhlgJmjBxlqEyiZe+n+8Q5wCnxDSsGmUcQ6?=
 =?us-ascii?Q?ahtHQRvfyOATWuKkTgF6C3w9l+6XXFdLCqczj5aQ2agqWQBZN672bKeMzsbL?=
 =?us-ascii?Q?KLcKCKZ2OsK3PHSGRzcKPyB+AKoCZNf6k7TUMuHy7vmK/wjQzKmftoGWaxNV?=
 =?us-ascii?Q?hUjSvF7h76T1IVky7CWI5GmOzIHjbLy9aKiAaqvbZPMyQ8R+/lK3RpLcr/0D?=
 =?us-ascii?Q?AZSMrMEv/nac+GB4fmI39pXK+OdxsAwaNHEsfwyGYrW88pIlGbd3NLF4bNWK?=
 =?us-ascii?Q?RaYbB+NvoKWyad3g0AdkGMjWt3L6SarE90keV/yp+sNoTHW/mXaGFvxhG9m8?=
 =?us-ascii?Q?Yhzq5EJij02Tnq85hjAKbPwuNPHKN2Lu8RjqmPamDMF4fApydpUtpIYc4u30?=
 =?us-ascii?Q?VOsWClRXNuFYHN3sG5NNtHYCsOWiQPNa3OLgrzCu12Ocu1uYRdfoSutUGLSS?=
 =?us-ascii?Q?mXI8Xi+E0oCjoggx6/JP93/jJkVRKHfDKp4fr66tuUTd8wmAkCV8TI75hT0C?=
 =?us-ascii?Q?VkSDj419e69rtaqA7BRMejik6kL5flBeigkhA12vNKLyg2N9cu3VHtYYMksh?=
 =?us-ascii?Q?ZeklsQS4/Baf53rN+ykCa54NNsxq4iBIbrstdxbpnmH7UqJ9ZmpJ05hmC6Ga?=
 =?us-ascii?Q?kkSA/jkywTK9pre3rwf6Ud8THvNgTaLXgKc9GPwcoM+h0TjvX0XsFOYoxx7P?=
 =?us-ascii?Q?BqknmF99JRd6Ij9tC6dH4DAx4+5xOFY1l5LStRv9zIjpP7g+5V5OI+fuDMy+?=
 =?us-ascii?Q?yab2xL3ucBHGodNPj0qsB+FkYfExx4iQleZ6Hhxd0EIK8Te+n2oaIytMggYf?=
 =?us-ascii?Q?F2TQFN1hjx5HpL4WDyN7VCO/mdLpora+S9DElBGeC3S45QPNOA4eQr9AAxvr?=
 =?us-ascii?Q?+PvPRaeZWNKgo5BjDa8Un3rb1Rwoaev0VNDeDGLiLjmp7YYc/dYV+xksXauv?=
 =?us-ascii?Q?hhRLYXTSwTWnwdv8asKUDLEO5oJI3k/AEOLqw2HfKhGpJazLBUfxO6o0gX9n?=
 =?us-ascii?Q?h4o1mH7SpGU0JetTtBXDISmqf3qM9axbB+3efDFf8L1/waBrLfyUbE0W7ncA?=
 =?us-ascii?Q?eMF+OCkRd1huFz2umfKk7fJi5CjK+ksIlMS9nFmCEg+a0UbhGjGIJaCKcZhq?=
 =?us-ascii?Q?tnRzkks/bDIdp18mzJCuUoDUnClBvWDWh1h+TbVz4DpXMRjJY8gsg4b4QQwd?=
 =?us-ascii?Q?S+fLNYvPM8PS4OyEGew6eusskmoTLDnJqNeNHhq9HyWjFC1fDvQYqX/t0ejl?=
 =?us-ascii?Q?27xwIcW0pGV3mUvzHReBwjAgC3CdjACsAgGB/tQt1aIm/t3MhgYQJ9WL1HOp?=
 =?us-ascii?Q?NYjiGG6X56P45cfQMYmEI2Wr0O1ut/3fnBbqI5xMRcAoyDHh3f1J9jmDFdC3?=
 =?us-ascii?Q?/potCG/zMmjRHRA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 16:14:56.8738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 818f5eb3-8ccc-424f-2099-08dd1eb5f2e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8616

It may happen that the variable req->iv may have stale values or
zero sized buffer by default and may end up getting used during
encryption/decryption. This inturn may corrupt the results or break the
operation. Set the req->iv variable to NULL explicitly for algorithms
like AES-ECB where IV is not used.

Fixes:  0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index cdcf05e235ca..be0a0b51f5a5 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -443,6 +443,9 @@ static int tegra_aes_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
+	if (ctx->alg == SE_ALG_ECB)
+		req->iv = NULL;
+
 	rctx->encrypt = encrypt;
 	rctx->config = tegra234_aes_cfg(ctx->alg, encrypt);
 	rctx->crypto_config = tegra234_aes_crypto_cfg(ctx->alg, encrypt);
-- 
2.43.2

