Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F2B262D12;
	Tue, 11 Feb 2025 17:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294444; cv=fail; b=hhEOgWp9waUMWoR18VqHIpmIlM+c0sl6sNq0WDx3sjP8q/sreUJYLlLjipVqXknbKht/VRFyrs6TUxCyN7cXr9wiOSKTugXtmLmz+UFtvXqwikqnqRw7ulwkn6v52RVAFShEwQM2GlKWgvr7U0cSQESmlmZgAVEFwqfDTrEGTk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294444; c=relaxed/simple;
	bh=S+079rxoA9BdyKsFTQlEvE116ubEHsAMr6u+2r9bMZM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VK0PNO0GyigFj/1mS0d5yQnbXu9K5JxIN1Vba+2OHio0e9QDUBkItRNAxM8MQraobM+EYzlxzGjGWJLuypKxFfMwpV7fpCIgQ6P7NTs01XQtgUW5D19/rqro0LxZizPv0P4VP5JltloNzuQD3PX1O8UUpum/vmpQtPmZWRcnr5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pgpb3oMj; arc=fail smtp.client-ip=40.107.94.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pgpb3oMj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SLQYzvFc3iqNBf5a6WIn4gv2KY6ALb7dAjU2C9yvVpjtu3czP7mSGVZgjq8UqmkMZilMSdXWP9nYFbXtrPrH08Nv+PUseyyXh0xOqM2WQBP+kjBvHiW9NN2A/+fozOj19Za/hGfJPyzM454T7YegsVjdOKdd2Wy8UDN3GuEucCS0qSM0MTi6DeFKZ2ruXumfWH4iBZVLJyXuk1vjm2bxFpLFX4kH+pDCeRzG3gWsLircIVsnKAmvRUzVso/ZQX/i+ojd0XbSaCqK3eMNl6eJ7h08YUB+taegpglhOdPQ5xJJGo2OoLdUkHeE2arpSAI5L3WLmeUeJRSMHpvPxeZM6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H6w45/3xytAm2JPRSKOkeS9Fjhl8mfnTk+c4KhL3DS8=;
 b=pAstu9UI/DTeQ7N4rNPxJPrYnD0coK+okrFWd75bbwpk5voLa0l6JVYA8PZcDFEdx24mGQyZzqk9TbKarOBgv4kwBMWuXTUobfrqNjTKCqdkOeHPl9dD8+4t0cbC5fhIqiU6EyCaCdRN/sp7e4uLXI60uYCYEXM7ZIkdCoPS2feb/xqH3Xzei0AcGoEKqyqAGfkyAWoRlj0RR2Cjb57EcM1SD3FJhoOSEsgzST7Io36jO1ntcpgRxb2ftEytBL3XsmrnK/QmbHYryfu7untjnmT3ckISMRmH/WiWngYVmcWyYClhchyuhhm6q4RECQ0/MgSTFYWERc26mK78E9VpLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6w45/3xytAm2JPRSKOkeS9Fjhl8mfnTk+c4KhL3DS8=;
 b=Pgpb3oMjIe/4yhEoWBKJWeCISPxtOTKKomlv/l2ztM/BNtJ4z4xTrSkCra+o7SixtDC8gekRnwi8lF9b5sMtvNdAEPNtbHJRLRYHkIKxT/K8x5F+nl2HL+h2QZnRatClocIfUCR8luuGxfmhOM0MvTYUqCEaM8AoD8w5dePyBH7Jl3cpHQQxnKEr19XE1KM+/5+wZqIqFyI+jOzjWHDaFh4JU5ntmGdmQ2Fmx8UrwsOkV/1Vvzm20EVFC1KpmXUqhRQWzGwaonvOXwc0LquWhA4ieXgEt+S7jOhftpb4PsTwIceREljm0a6MUqrwoqSIHx7qDGFfa9F3iZqe6VSeVw==
Received: from DS7PR03CA0007.namprd03.prod.outlook.com (2603:10b6:5:3b8::12)
 by SA1PR12MB8987.namprd12.prod.outlook.com (2603:10b6:806:386::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Tue, 11 Feb
 2025 17:20:37 +0000
Received: from DS1PEPF00017091.namprd03.prod.outlook.com
 (2603:10b6:5:3b8:cafe::b2) by DS7PR03CA0007.outlook.office365.com
 (2603:10b6:5:3b8::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.12 via Frontend Transport; Tue,
 11 Feb 2025 17:20:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017091.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Tue, 11 Feb 2025 17:20:36 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Feb
 2025 09:20:21 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Feb
 2025 09:20:21 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Feb 2025 09:20:18 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v2 08/10] crypto: tegra: Set IV to NULL explicitly for AES ECB
Date: Tue, 11 Feb 2025 22:47:11 +0530
Message-ID: <20250211171713.65770-9-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|SA1PR12MB8987:EE_
X-MS-Office365-Filtering-Correlation-Id: 37d71d8b-aede-4a4f-18c7-08dd4ac06663
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OiSy15e2XsPMRUNZMBqS79/WYkew746CH8t6fJF3CT4anKxEs6E4UDrAMJ0s?=
 =?us-ascii?Q?oKB8m5EOnH92C76qUXXXX2feCaFQzIiNMye70f9y1gPL5/lpi6D1LLAQP+gG?=
 =?us-ascii?Q?0XXWhy9ah71i44xy/jy3ody/xySXiiKXvWK88576nFH3kP8cahfoKFGv0AdE?=
 =?us-ascii?Q?+pysVjZO9b5YPJDqfCHaGcv7pEBUrO+Og9RhNxlnW+fY390/bfuK+keD/G5m?=
 =?us-ascii?Q?08WuXqjgI/DmZ2MqWqX20sCsP45gW8zjpwhPmJylgy6iZJklK10J4ohfwEyl?=
 =?us-ascii?Q?sXblwbFNz0ih2hHMNmABlhuR34TVp76iXoC8k2G0zhDbrhyz/RzV2uE8rJ2P?=
 =?us-ascii?Q?n7haUA91cD+i44Flq0Feok+woWMCWbsnBc872PvrhdyCTDlZgoadiiJzZum3?=
 =?us-ascii?Q?RVJkU27kFbZka+p9DJleQ6nJifyabQxmlkkXjFdI05yGG1WnsySMYWES7bRg?=
 =?us-ascii?Q?TGfHjRFXBTsFgxT/HHd/Oxm2digLsq9S2dpejysHaxdE/serZbVAK6rMmTfv?=
 =?us-ascii?Q?8ZY5fL8REjEqKJvu/Wv+thTt0m0Ht6G1340HErNTwCoix8DOTFSRAn/4ruhS?=
 =?us-ascii?Q?PSeKYG9zwK/oDKfTxFvbwieMYt1dQqVwrVnItURt+F64emfd+WoUkFiq7mLp?=
 =?us-ascii?Q?Wfjt5zJejeeZkhI854M/cuvyNqfS6UN33kbJBM5vqwJqoyaTC7JP3WPkM2oH?=
 =?us-ascii?Q?tR5JIt2RLREUEh7anBT9RwEqRDpfnRa1AOXzheMA9UH/BhKeOrAmsX2myw5f?=
 =?us-ascii?Q?EsYprI7fuy3GSY89KQATNClV4KjtX8NkRWBXgIhh1um/eQsmn789kRIR9YeG?=
 =?us-ascii?Q?iw38OCACiOZ3dIuDs50pHCcUcniCpaBsl4BponqYp7+PZAJoREQFuEyHPc4+?=
 =?us-ascii?Q?LhLbn9swHgzFNzefVgoBgusYYdUulV8UcjpE+/M4Uck4KkMXtmtKUEfmJzol?=
 =?us-ascii?Q?ImgIGH2mkTxZBqFInsMzQayIxwFUwoPIFMgzZbwW2JFiPV3eNreBIO4iG+U5?=
 =?us-ascii?Q?P/BXBA8aUalxMOogx3fjKXIysNDM0Y0/8fZO8MuGeVxzV99aHbI+/RWKOPFo?=
 =?us-ascii?Q?TBWvq5wwiUcFxq4XtvysJkCkMongCLn35sQF4MT1htaIq4EgMIG/cGVCh3Li?=
 =?us-ascii?Q?subi/NoItdbOPrjSvQhQEaCR3rSYsFyWyyWH71ubcuIi6wnGd57823Fie3OO?=
 =?us-ascii?Q?PY37TpUJ3fkkqhUbUXFidPJqt+7tWnjSssP+LDVf64mqb0NWsvoYOqkjUnN9?=
 =?us-ascii?Q?LN7osvGlXTmzJr7Q7s7gclCtpbR/OX+nwqVKiC+HWkWoT54M6urRCNOM4dNB?=
 =?us-ascii?Q?t7h0rCLOYaMgfUk20wmtJkuhz9JwV33If32HX8jARAmDTO960YsS/24wO/Ua?=
 =?us-ascii?Q?0iZPkhLPytKD798AwSd1NJt7FzZMF531Ng8EiwrgmM2Nsk6dgaUlrIQbqbvG?=
 =?us-ascii?Q?nLakFWyWUq4WXrAwQjh/KL/FhW4MukIFzavjG584Y7aRkG8LVoCa/nx3lSfF?=
 =?us-ascii?Q?6o4HhpolMMOLECc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 17:20:36.6706
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d71d8b-aede-4a4f-18c7-08dd4ac06663
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8987

It may happen that the variable req->iv may have stale values or
zero sized buffer by default and may end up getting used during
encryption/decryption. This inturn may corrupt the results or break the
operation. Set the req->iv variable to NULL explicitly for algorithms
like AES-ECB where IV is not used.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index c97dc2043b3d..196f3b7ad7bb 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -446,6 +446,9 @@ static int tegra_aes_crypt(struct skcipher_request *req, bool encrypt)
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

