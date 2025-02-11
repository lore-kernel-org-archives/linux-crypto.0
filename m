Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC49262171;
	Tue, 11 Feb 2025 17:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294396; cv=fail; b=afS22Aq/qnvaeWpM0S7Xhh+I8wdhFyGZht3CAxM5zC0hZ/wPlHAFnZl3GRm7uazUjW5/VE3Ofgs1RnFkkvN5zEiKJrdhqVrCw9H+4NAh45vxsu6L42JNsxdDCkmFRUeCXr0A/QMiaiWsk7dpcKQ++j3CRSEDVxPEw8C6xNt7K9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294396; c=relaxed/simple;
	bh=ky6avQTNlk5H2RTwq4XgHkXbOLa0/YatqxjpApepmNA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VEl1Wz2srVpyVGAZUzrtjFs+PYeHmkyNFcOVjtH+mmNl7HMWbf+5nOJ0ci20IGwM/70Ys0E8eqIiIoxqDb6/j56mbr/DQ/zhPikOx22lHUmDUt5RvuHV1uw3b/pQGJc7yEHMpf5guukighNWxmKPICRl7+L/tr8ethngUj0vbiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lJWZ7fCu; arc=fail smtp.client-ip=40.107.94.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lJWZ7fCu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dcNOdqQhuLQKrBPMgPOliAG/0nuwDyJn6KaUaF3MKDzaKn9qQzWFOjrfbvZKoR2WZFkpbUwtslEBuyeHKwXjsEkIJH6ejwUPKdZCD8/pR5P7M9g7BLvFw3Y2IpomtAwEUK8jw/Wuhu72ehlW0dKZzrx6Pg32nwSvAqJSDC5O9sl5YUATeBMILoJvy+26CaZVo/oaNty8K79NI5JiTfkfGeJJQHNRbgzBdwYgAkHum/9b95POVtjBYyUN4CZR+r9EQp0ftbYJIO0Sb+EKNMrjxmXxb2BPnyeVcqVTZVIxbR3ejsz6Ar+7gDij6ByvI1tqnvrvSK/3A8KzllJM2JY+Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fSi9lTCWDzxJrON1Yd5Sq4qkI+9rzl7SHRY83RkKIwk=;
 b=xG4BW5R5QndzxdCvPPmmf/A1+9Qs2xEDcZ2/Qwo1oG6FCSxlvlLWtCqdLyaAGeZpEY38AV5THA1JMev3+qztNvIPk2fpt6i6vwDh9TVabqxchJ61AxxNDxqCrgFqLpeDG7snXwx/e7xWHlePyFz1cm2w+zFptGBqvOWdY0J+SSs5QwgZaHhMcZ4E79BAuqXXYwFwF96RyMzTwu4d7F0TksGM3Dm8h8QMRdLlb/c7wxxKPq3NThUXqQHM6tmzLf6WOwMh4UjGx8ZhLI/6csoxRl/SY+L6uX7mHvBU+88OqvU7ng/WRvkYbF5Yi4IVzOmm92mxGuuUeZJUxzCForKebg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSi9lTCWDzxJrON1Yd5Sq4qkI+9rzl7SHRY83RkKIwk=;
 b=lJWZ7fCul14YLPEUSUwdQFqFxX6M1GlzrxBjyyoTS8SEwrhBHrQbHHL18SUtvIU4XMcaLeHMworhVbhRVyu0TxREGRYgDzIHGXMgt71nHf2tfLcf3p9Un1foNXs5jf/2dZrwhX8+jAsYtqZM/tQs96+RsVotdTV9R+WqEil2LS4Sn14LFpCmItx6Kojevs1tXw+8P3fdgyUGdl+EP9v1BTsLTBvNiurEID/6kqaSlPpvLmyHmIncUwK/6dyNjpMqiSrA4Vxf0gs+NIlKjvPApaOFmPhpofM0JtbvzYXyfJtLH6Ye2iFJr2/4pJ9Gk3W3LFIEYNV0iQAJcoQoLnO1gg==
Received: from MW2PR16CA0015.namprd16.prod.outlook.com (2603:10b6:907::28) by
 BY5PR12MB4082.namprd12.prod.outlook.com (2603:10b6:a03:212::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.13; Tue, 11 Feb
 2025 17:19:50 +0000
Received: from MWH0EPF000989EB.namprd02.prod.outlook.com
 (2603:10b6:907:0:cafe::12) by MW2PR16CA0015.outlook.office365.com
 (2603:10b6:907::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.24 via Frontend Transport; Tue,
 11 Feb 2025 17:19:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989EB.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Tue, 11 Feb 2025 17:19:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Feb
 2025 09:19:31 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Feb
 2025 09:19:31 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Feb 2025 09:19:28 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>, kernel test robot <lkp@intel.com>, "Dan
 Carpenter" <dan.carpenter@linaro.org>
Subject: [PATCH v2 04/10] crypto: tegra: check return value for hash do_one_req
Date: Tue, 11 Feb 2025 22:47:07 +0530
Message-ID: <20250211171713.65770-5-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EB:EE_|BY5PR12MB4082:EE_
X-MS-Office365-Filtering-Correlation-Id: 80a7083d-73a8-4d6f-9ac3-08dd4ac04a6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/XA+mlU3Fvby6BbMM7rMHQRzBYa9OF1frtVw1P2qDAq6e1xIHaJm0Y7NuTCz?=
 =?us-ascii?Q?ijifjqM3JOF8jpY5AZIAkS7WUDLiNWySqtzrOWi48jMrXanTeaKRrr8UTNiC?=
 =?us-ascii?Q?byVYwe6HdS2sJQdc7/kdh/vTRGfVB1yk2tyJZNSoQLqiFS8zRbUB4bKT4SS2?=
 =?us-ascii?Q?A9FqKL2XnGoOEAOzdgkJSLdDzyxO+EeqL1n1aSzKGmv6bNJmJdJmzcG6DhS0?=
 =?us-ascii?Q?xsglC953VhtLOcEs6iv1uSbsqtMRZECCx1X0j5WMSa88HhyjB57skfG1sWML?=
 =?us-ascii?Q?a/ZS8QzERUS7Xb9SuSwNrW1z/WJrGVnWiL5MzYxAj/1ACVzSZ9uYCJMCMhxm?=
 =?us-ascii?Q?1PrPDmS2k1EK7d3nBNNZpnUeIB9+FzXQlni86zM+zu3eSRSp0xMZqK63xChu?=
 =?us-ascii?Q?g0RLhLhr+doF87A/ya+djGkzt+4rQf3kUJgLfXOVWnR782T+STK2WpP5CAWC?=
 =?us-ascii?Q?LcBFq9A0P0G06pHwun8Yw2eXnhRqDEpc215pEEPJHvXoLPx622bM1j3Ldupp?=
 =?us-ascii?Q?KKJnotTXOo4UYgQHkRNpxs/LL1gIiK2f9MC1A+NzcnedTclNvNYHjw9LXIAX?=
 =?us-ascii?Q?y0MggTbaNbsCiLqQb8U7LmBojsoEQFV2YoAdtlxeqUEjhPJGZ+8x6Kk+tUQq?=
 =?us-ascii?Q?7Xv/x80Me2CewbYYlCgU4kFxz2YJnJo7k2Os7nPWVtedM3Jxn71rSU+Xe0qj?=
 =?us-ascii?Q?p2fydEDhmIELW7ykh7c0L9Oui0OMneTXZvQ+j1IsaKNnnVq/m3+EXJn9ItKn?=
 =?us-ascii?Q?rSfbVHRyTBOc3p+V8ERiGGBHQXx8QzG7NHnRLZTAN0zSw0i53OKU6n1DJWvC?=
 =?us-ascii?Q?G/AKrkXv3h0h1B00su8ZVVCHhzO6aQANrAsRtSKGNlZAGdPXB3JZ0y/O5t/M?=
 =?us-ascii?Q?ldbhvUV/DH1ZtnSyaT6ALOrd/iWyOCmXD1IahcCPChNbxM/AdJUM5vL8WBOE?=
 =?us-ascii?Q?JPuiSS9ORPgtvr0k5Yo2+38xDI3vuKTScq+JRXhqcF1sKkzaJ5jvB/mzHGom?=
 =?us-ascii?Q?PdqAs/AXJP4aBOqsqIeUSct9yNtNbEDdN5YVwWBAAnbtyK2G1oJ76SS0jw0d?=
 =?us-ascii?Q?R5SQ7+0JuQ8s36sdbd50sisrVGbtzVLDTBjCFEYMSgylPI3palcq8/elCY5i?=
 =?us-ascii?Q?cFpr7OqWoisxinWkiAisBjWGHcN7o0xgPtZ7DS2TTJHHjY1DYUwPTZLPCKU3?=
 =?us-ascii?Q?ms4vIZnfFPHLuUQIwRjuU1VMrtNC0cTA6hEhBstrofeJ17mF0R7St6VC5utO?=
 =?us-ascii?Q?dKiSTnIjQdKpSUanzgl0GRhYANfxP8MzxKQo/6SrbAgh3WP8lYfDn22LmCPx?=
 =?us-ascii?Q?2G1+6nu599gmcOXe7xT+HkQEISD8OXvgSvqeQguD7wpSMNRSjqUunc66e5Hr?=
 =?us-ascii?Q?n67J6RYKFziUeEM1LNcDFEtaK0esPE6TYKpHh00bArFFL/7avZzSJ/BBH6H7?=
 =?us-ascii?Q?piwBjoj9wk9vXn5H5wcWcQf7thCqVAAzZvdKSaTpcWH5TKbJm+8LsTl2UIf0?=
 =?us-ascii?Q?W4ss3h6WYINhBVg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 17:19:49.8167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80a7083d-73a8-4d6f-9ac3-08dd4ac04a6e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4082

Initialize and check the return value in hash *do_one_req() functions
and exit the function if there is an error. This fixes the
'uninitialized variable' warnings reported by testbots.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202412071747.flPux4oB-lkp@intel.com/
Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 10 ++++++++--
 drivers/crypto/tegra/tegra-se-hash.c |  7 +++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index c7bb6f951a84..5ca7996ecc6d 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1602,18 +1602,24 @@ static int tegra_cmac_do_one_req(struct crypto_engine *engine, void *areq)
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
index b4a179a8febd..0ae5ce67bdd0 100644
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

