Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661A41F63F5;
	Tue, 17 Dec 2024 16:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734452033; cv=fail; b=L7/fOeyAyli1XzKlKDLFsQwJXb4n3z239nludpMJPGL0HwYhKuWqlqaQOgHnhcX7mFFtd2XDMAFkHwexT72dKzsxi7HFdfiNZCeLyjzqIbxRNB+JQtLZ9r91BpsxPulhfx0IalFEu1IC7qY4oV8BWQVzCxqFX/8GIQbiWhlfJXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734452033; c=relaxed/simple;
	bh=QN7MGsI3BwxY4U6QvLTAj1vAmLvwiZhE4Xgjw33Vmt4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZCg7tV0TCFVQNcTbOgCT1U1jwMDuWC3hHWCPnZ88z5US0vPxpKb+eG5ilTerB8oNkdCfW0LHO842ZTw7vM80Jt3TWBEI26j4uNhQLLPGX8IkMdPU1NXOArs8m4bS6O18MtZAUwjAmDMStUxPK0qLCc9Ff0oloM4684VXLw9Xmhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KRyhRfNV; arc=fail smtp.client-ip=40.107.244.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KRyhRfNV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kl+1GznUJJYzD67Ahi/GzCrTHtr6hAJ1bXV1m0UEdbI7B1DExEQ80OHAb/rDTSADZ+scn6g5+4HNERnJdbiYOiI7USCtUNYNPd9prg0Xb7uowd6CBiYZLbNOxSlAxokj4UDoR+eCxUmAio3uOnn6Apg00sson9btIXlwc8xOp2fGmZNLAHd9brcuPqpZOYPvh1Rpaxpcqp3ETpiDYHukJzr2Pux1oSFtwKTcC4OFvzl9ELwg617B59xrE4Y8OfcmsrEJPo7AlHx54Qjxq/Y2JkglPa/QmICaVZufCkpVwuJIK7rQJ9CKN/Gs7FA9s7dB8O3cJCPZuxTpQwXJCkm6Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4DM67iu85/nkYxfzaoHOQ1PXKjJZnoizsAzXN6Bw0c8=;
 b=g9gNKE7gpEZQvYPHxUuyPimYfkC2XRVFT8zDx6uJ5VEsJBEZVlgd4z462YGTmlZIi3WF0c2zmjiY00EGthUTlKNeSWGGr4xHtEetY/jnMRoWNDAUyVXpApvxPz6i977UkXY4L2b0hiRLuLI/9ufwckZxxU+TXgsDWQY7eHsCDEoJfdZHLGzs2YqOYrlskzrO7tGE6Zn+Wyva6Oc01TvQia1WH5p9DLSvEGl/+dIkfbsPeAQ8AGDs1UqR7hk8ZNcU2+Gj7ljB5On1/GMCPl1sBPPgl+YQWFLIR0QzWJk+Rg4qRnPPUVrmwI2j3mX8+dRNrlR6u+eR5nDvoq9PneS6ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DM67iu85/nkYxfzaoHOQ1PXKjJZnoizsAzXN6Bw0c8=;
 b=KRyhRfNVYA9Il08KztyEBxjUFYhwzDbU4PpVxejXgfXiFjAdX+paqYkZYs/AzJKYdv2V0xgVdzw0e2zKvTySMFwvuQ8uAHTUZ0H9n8B4EG3Ad4LKZuRgxuz5KiSRn2zAHkiB0ZHGfk7bdFCGqMetWjsmSTuOC3MsUuBgLLU2J0ws1WP2JI5U27vxnFVh7LcFqCv7tmDd8awlHjPk9ujd56bbZ9OmXZJcFeFluHeJNkQsKcOmcnz0icthRR5Xr6JaTKyImS58ghcopNlAq0FOH6WnOISQS4RZ8G2bdeY8M62+835GCHz3yN7+h5AjAxqOWfLpD6zRzkhbM3JgXIMSSw==
Received: from BN9PR03CA0626.namprd03.prod.outlook.com (2603:10b6:408:106::31)
 by SJ0PR12MB6926.namprd12.prod.outlook.com (2603:10b6:a03:485::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Tue, 17 Dec
 2024 16:13:47 +0000
Received: from BL02EPF0001A108.namprd05.prod.outlook.com
 (2603:10b6:408:106:cafe::14) by BN9PR03CA0626.outlook.office365.com
 (2603:10b6:408:106::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.21 via Frontend Transport; Tue,
 17 Dec 2024 16:13:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A108.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Tue, 17 Dec 2024 16:13:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:13:21 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:13:21 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 17 Dec 2024 08:13:18 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <akhilrajeev@nvidia.com>, kernel test robot <lkp@intel.com>, Dan Carpenter
	<dan.carpenter@linaro.org>
Subject: [PATCH 3/7] crypto: tegra: check retrun value for hash do_one_req
Date: Tue, 17 Dec 2024 21:42:03 +0530
Message-ID: <20241217161207.72921-4-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A108:EE_|SJ0PR12MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e0bea20-9e5a-4e03-9115-08dd1eb5c80a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xo3eg6Z2YvCAd8QGg89P3CcHJM4em4kNqxJGc3VAkDndoaBJPUsOgw6zhqMa?=
 =?us-ascii?Q?AOYULIqWBPn0yR71SfeulW2SWCEttRPRmEQwzlX9xK5FXqRPbiNJxaCG6zLr?=
 =?us-ascii?Q?268K/UxlS+FytoNjzTbE6MSkv8CnbFXdQOJasvkR+syY4rp1xhBTXPmpU0fe?=
 =?us-ascii?Q?9i/RjfGkxYj00+iuJJzp5EhjpSReZkexZXAEc6DZXWw+iKMqtRvBrarNHdih?=
 =?us-ascii?Q?S+VSEoek0rIuSJQxRQNOT9wINQrjbPU7KBKCViYBNQKsZmOKO76IuMzaUec8?=
 =?us-ascii?Q?dF202rx2sKqTmNtWbyuG0KQk9KZB9AAgAe7TC33CFeq0VSBxiYcHStTakugZ?=
 =?us-ascii?Q?WOucMLbLmTU6v0/2BzTGISPG0SrtkPIKc2ZQiFRqGrCFJT4mexulKIv5KH5E?=
 =?us-ascii?Q?zOXJXCR++Jr3nwZqGeQRkFrlgP49Dqhbgzn1OVCmEV404z3H0+FjnNyw3TaI?=
 =?us-ascii?Q?oljRxMJVHYScE/ght1KE8JvwOBgIhmhZaj+RI6vpzO8lOJx9FM4ifqJa8mI5?=
 =?us-ascii?Q?Da6XYJjhQ8R/PWpGv+z/9tylaEruV4nZ10NQgGXRgTN55o9wfhoS0mD6UT/m?=
 =?us-ascii?Q?bGxE5Wtv9y27EX0yaGaiC2d1u+wGWzwkee2V4avh/C4m/SVx6tNourVz3Qxi?=
 =?us-ascii?Q?xrWa4jjHa/zhy1n969dz3LxKxliCUmsuuI+eD/wGpuwrbxnwnGbd6MmxZzx9?=
 =?us-ascii?Q?VJW1mJKd9IgkWVy94fXI9MQ+xDio8nM9AH2YWB83rSIHNThfPNxQXpioAxyr?=
 =?us-ascii?Q?cAEfgYXv4RNbdHF3dt+vHmh/53m1xIZb1IOkm97DdgDJIq8+WztXf75OUQE/?=
 =?us-ascii?Q?brRKSkNCA3UjBTWz8bKhzBaS0qnPFCKE3DTaCgiOKvDFYpSS7LCxoXGBlIwE?=
 =?us-ascii?Q?sPYbaDaVPSK6n9ii92DqK5sxfkpzJRZSpId2WEpfmvnVMNJGs8e5E9I5x/3N?=
 =?us-ascii?Q?lMUv+SvQ5EUJC6L/GEA6EaXsEn1cxBOR3PqWdGruX7KWzTS4wUEzvufvX/Eo?=
 =?us-ascii?Q?kWf3Cvsj6sVxjP6To3UIWpbNvcZXsW1kiBK51ttBcUl0lyraI7GX4BW43EOG?=
 =?us-ascii?Q?+xXNWr9p4AkC+gw5Zb7Krqi9hSqo81PuN8tPjeCx0pH1JGW0nMb8LM2lBiUl?=
 =?us-ascii?Q?mi1bOPC+jX9jcdCiiRzL12Kw75WANHImg5wBI8uSqyVgi8iPhh/cYn2xIr6s?=
 =?us-ascii?Q?Ft2zjCmGJ+XpKLIKKMbsOdzcThTpnJC14H/z9vD8Ve9rD9FsJ25MuzGZJkhM?=
 =?us-ascii?Q?nUyzBOji+M0I8CGVq9OGjzbUXY/RvsEEbh+x6mA65qeWBMQAf0dbkrugyy0G?=
 =?us-ascii?Q?zT4IgkgNzlzlSBFs+sYueUqU/n4kldXlyAXxzPTeJwzcxCJJ/fKEWUjyTAfU?=
 =?us-ascii?Q?RPF3iFAzqDEFda7JHQsJ9TqP+N0+G78RGWHASoOGXWUwaQLWVoV2/axhLMkg?=
 =?us-ascii?Q?S5cc+O3MCcULUBqkb4IK8c0QFxELWi3TYjmcMCgA8YkcxBU/WIatyoRp+c6j?=
 =?us-ascii?Q?kTG7PCWNG/TGxRM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 16:13:44.8340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e0bea20-9e5a-4e03-9115-08dd1eb5c80a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A108.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6926

Initialize and check the return value in hash *do_one_req() functions
and exit the function if there is an error. This fixes the
'uninitialized variable' warnings reported by testbots.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202412071747.flPux4oB-lkp@intel.com/
Fixes:  0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 10 ++++++++--
 drivers/crypto/tegra/tegra-se-hash.c |  7 +++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index b80786c5e4fd..6ed6da0ecc32 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1596,18 +1596,24 @@ static int tegra_cmac_do_one_req(struct crypto_engine *engine, void *areq)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct tegra_cmac_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct tegra_se *se = ctx->se;
-	int ret;
+	int ret = 0;
 
 	if (rctx->task & SHA_UPDATE) {
 		ret = tegra_cmac_do_update(req);
+		if (ret)
+			goto out;
+
 		rctx->task &= ~SHA_UPDATE;
 	}
 
 	if (rctx->task & SHA_FINAL) {
 		ret = tegra_cmac_do_final(req);
+		if (ret)
+			goto out;
+
 		rctx->task &= ~SHA_FINAL;
 	}
-
+out:
 	crypto_finalize_hash_request(se->engine, req, ret);
 
 	return 0;
diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index aed82d82b5fb..d35bce81e017 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -437,14 +437,21 @@ static int tegra_sha_do_one_req(struct crypto_engine *engine, void *areq)
 
 	if (rctx->task & SHA_UPDATE) {
 		ret = tegra_sha_do_update(req);
+		if (ret)
+			goto out;
+
 		rctx->task &= ~SHA_UPDATE;
 	}
 
 	if (rctx->task & SHA_FINAL) {
 		ret = tegra_sha_do_final(req);
+		if (ret)
+			goto out;
+
 		rctx->task &= ~SHA_FINAL;
 	}
 
+out:
 	crypto_finalize_hash_request(se->engine, req, ret);
 
 	return 0;
-- 
2.43.2

