Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767E123E229;
	Mon, 24 Feb 2025 09:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740388662; cv=fail; b=lrQwTMh7p3KyAsYuS3N3T2yetwygolX3oPS6ieSczLDy1xGxn+cr7J/Q7snzYjEVFlT627jgon6XYf0QzZhOQaIpEoECQakVGHfFyK287h0IRAyf13bpvEqcloJaZJa41uHlHS9FgkLrdrsb/1M15OKY3nUirUJL99aUWK1FGJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740388662; c=relaxed/simple;
	bh=ky6avQTNlk5H2RTwq4XgHkXbOLa0/YatqxjpApepmNA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i7O2k/CqflGGzfl3SxMEHjBnMgHXJaRvrkAfm810T/0iKSWbH4/zhf9wPrOUXzVuVNwMaLs9IWuVzG9GrT8/fmV+3xwyLFjWwkbwMFzMJDMAha+Um11RowCtysng1gSYOST7GFGD16vqjSLibT1sQE9uixre+7ImwhAEm8wapCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QoZi6fs7; arc=fail smtp.client-ip=40.107.94.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QoZi6fs7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ESb8l5GOGt7FDHHG56Zuif/x3cBhtt+hcy62br1ok7SnpOSxrvPN5gmQRJAQ/9HrSTD3GiB023BdkE6esCSO+8MJEuyxLX1PADFtsxF1Kd5nFybKPDnOpg0ntfsna56UEoBETNP9NPa5z0XT0BqrGoWsQV6kxWrl6MSEacISnjJ5eTo83N936BQtxoQslUKj5kW+FTTha+g4XXddZoPgyUNnjylZ93LlpUB1AMF9XDblk6VNsegjCG4NNIDSTz3l7ysk7GUKrp6QwDMIIHbEr3RMHOclAncPjfA7yyx3XdoJ/gvQ4ZlejwxHlAJOKbYsvvDsqeZv8EZb/6sQGIQwww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fSi9lTCWDzxJrON1Yd5Sq4qkI+9rzl7SHRY83RkKIwk=;
 b=QG8Bkxa9mCwaXShlzCYrOeDz5N4On6dKBJ1D5TrAWGu23rWViPmR4JLnfSG9sCkCswpWGavrUDGJ4i8PQ+ZBaDAliSq9U4i3b7S3hRtg1N7tBv13+XRb7RN1sQeio/PQ90oPB9SVrLnVFMVGD/20iRWg+spfKYuMKAwVelkmvmroVhGWYqYzLPPmzuglyMGrU42cEv3lOCq6VJkXZm5GvuPJmrA1KuW9hZmAx3sYLsBZEtcoksq1KfJ+9CFiN8wR74o2PpiQwhJWZdkKiPzMzZN3904/H1LqHxuyHzzwwK42nUlpHLQmSVrGaCtXtYx2hpYdA8PoDFf0x4nZFDFBrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSi9lTCWDzxJrON1Yd5Sq4qkI+9rzl7SHRY83RkKIwk=;
 b=QoZi6fs7b7k2GuTq5TxXSBPqAEoq3aREmFqRclR7FXf4FeUuZx2N1Z0IQuRVT2K8/LyoyDC46oEG8ma7/7saskysS6EC2lPBHjVZXsKv6K/4DkDcJHpltj0ddaLrOFGhsbAKH5zZPqvk7J/Y/mz5SkMTWJ17k3GiB3g3ACQsGC610alLSFeYNb8+3meAamHp+nbjIHPe00Ydy6cGSwgDa+GxVpnIyu3XyuByc6l3E2IwBCsJve2HEiS2N4Z9wVhghi47NDb+GfKAD/MsRv/wDS9YFtD/6AhlQtWXLrQTQyhyhZmrk7oGBkHR+5WHEWlChd6t+kaXj0TraCDgMNig/g==
Received: from CH3P221CA0025.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1e7::20)
 by SJ1PR12MB6052.namprd12.prod.outlook.com (2603:10b6:a03:489::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Mon, 24 Feb
 2025 09:17:33 +0000
Received: from CH3PEPF00000011.namprd21.prod.outlook.com
 (2603:10b6:610:1e7:cafe::2e) by CH3P221CA0025.outlook.office365.com
 (2603:10b6:610:1e7::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.21 via Frontend Transport; Mon,
 24 Feb 2025 09:17:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF00000011.mail.protection.outlook.com (10.167.244.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.0 via Frontend Transport; Mon, 24 Feb 2025 09:17:32 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 01:17:24 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 01:17:23 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 01:17:20 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>, kernel test robot <lkp@intel.com>, "Dan
 Carpenter" <dan.carpenter@linaro.org>
Subject: [PATCH v3 04/10] crypto: tegra: check return value for hash do_one_req
Date: Mon, 24 Feb 2025 14:46:04 +0530
Message-ID: <20250224091610.49683-5-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000011:EE_|SJ1PR12MB6052:EE_
X-MS-Office365-Filtering-Correlation-Id: 809d38b4-2f3c-4a9b-da70-08dd54b41187
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GfKkj+JqDh7HBABit/8Tt0FMyHR6/IxYbin6/AynKQhQ/18L0P0yR4QJQSCN?=
 =?us-ascii?Q?P8+BFvnYTHoLomBeFRAtFOLovJM0Wg35qB79HHhBv2JL0Lt3F2uT2sgh1J0X?=
 =?us-ascii?Q?tTofeJ3alIf4+2UBWTxWZLjbDDmPQAIfRBQDc3qhOh5FF1eGeRUfMSR2ygbx?=
 =?us-ascii?Q?kByXQOuzfKxhnS3yb7kOeFN/3xi420hdM4pDxyyvBtoU62VUmsG6OPUOpdk1?=
 =?us-ascii?Q?AYXxjwi3sIQedRx5CysaI2OMlmqwXU0YcqZM6/yNC9E4EF5pUd8WhJmRux4t?=
 =?us-ascii?Q?VHppG2u6k70g66BlM7ZcR+YdDMDTxOaQyO/XiC55NUKDtgPPGaa0FoaKaiPl?=
 =?us-ascii?Q?Hh5xqbre3mI0ymjInJriELAHn69TlCAER1TrDdMs3nly5kz7PA4RgIw8eFI3?=
 =?us-ascii?Q?/092j0QTL+6/Mu1IKdM115crt5WkmTIvQ9p9HABDCZMon/xhAxgD5vDXWfFX?=
 =?us-ascii?Q?XlzAglLd/KSTDb1CFpQXFhaqVC8LWgwcuqyyMVzRi1c8RUMjrJyOVrGXen9G?=
 =?us-ascii?Q?mUtBI4Uu9x0i04uOF16mOnvA+tMGkre9g/LPFaE34/1HGcMUjEyhAhla854p?=
 =?us-ascii?Q?IK2ODtdESujDcMmCjL4WngbLKEP6D0jBks5cozV/G4vQVa9xQVOX6+GRPGbo?=
 =?us-ascii?Q?Z2Np+G5OArsWnTeQd5oXJyJXM9hDNwmXTXltXCxNgGE+u1rLYsBMx/6kNxg8?=
 =?us-ascii?Q?eA5qhMUE/VKkS7wD9fpNhoR+uHnYJvoc1f5dFo+rveSIhWghCG3v0/f276ap?=
 =?us-ascii?Q?4Iw1vVN3rVtJyvi1Z5g9jKE8e8xamd8xKPi+Ti3w6wm0mf4W5qTeeOoFK3MV?=
 =?us-ascii?Q?VKDfYbRljUuGLnifJff67ibPhon5T+FnnoagjAI7xd1LivvB/g3pnFYOD2oW?=
 =?us-ascii?Q?XzqiFE56ctodHBf4OEMW6g5LIASanqT9Fw0KT9kOYpkj1CRsTerFMkIduUZp?=
 =?us-ascii?Q?ZU8w8mW3O8dUrKDni3JS7vi9Ppv/YiejRjgd4JGGDg+PdXeZYs3ghzqSvLdo?=
 =?us-ascii?Q?w2wgr1mM4J9MOMInjU9i780BW9vR7C4gFYnehrbB2eZWLEqUteucbUHkoTuS?=
 =?us-ascii?Q?nKpBgUC4aBWRe/29iz/efO41DdUzrwm2bLO6AWUTjWWuK7DWTSQ3/OBHg9x7?=
 =?us-ascii?Q?VnuzYvRF++znBF7F9f6hJWYotQM+VGJtIa3I/x2tGlX7vHhrtzAT7iKLyWaq?=
 =?us-ascii?Q?++EP7lo0V9hPQqE1mYgl4ZUM6+t3gDjmGf4vEPd5146Hki9+5dsrNJeSvK7B?=
 =?us-ascii?Q?eOq4arCw9SfOaJ1LnJs8uQZHQc3YePnhrIl1Jrxtar7fiIlqJ7/14WAP5Vb+?=
 =?us-ascii?Q?RNFNGguRkW3KFE3gUfunkYc5abee7/0M+RhBMoVDz8wjwckf7ep92DQgiDCY?=
 =?us-ascii?Q?7EWRuVYOVSmlJlvLCSXGq7ZRAZRY27D6yYLmVmG15bTH/flb3EQh2hzaPQMd?=
 =?us-ascii?Q?/mQUSVLTb2Y4Kscm6+GlGo9fDL5+OVJA9U2zShRwbmPkcAjFIKtPBZJjL7vq?=
 =?us-ascii?Q?9nllevaVoGwy7gE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 09:17:32.0034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 809d38b4-2f3c-4a9b-da70-08dd54b41187
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000011.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6052

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

