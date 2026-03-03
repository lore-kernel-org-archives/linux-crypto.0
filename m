Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010034.outbound.protection.outlook.com [52.101.193.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714E538D
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522464; cv=fail; b=kiG7NuJindLnLUXTIz8SLGai1VyCVnBD3cneRrLFDxRJvgvJpghHA6ACBl9de/gFBrJLrMrNy5kcTsfBTGVSC9hnrZYzJ3vvPF7Ss/rVsy1P8HXfirziKEqTYR43QwAGXrXn5dJL6yCQsunLoDpri5cZYfF6porEwjsYvKr6/jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522464; c=relaxed/simple;
	bh=E6Y+Z3CJmyOsHWpbuK5HdNaHOe1Uu89yMu/ylhy3oew=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FVp6v9Zd1EFJoWSR0xiSEpcUsQqSA9QS/JFwow5gqwROIKiptnRksVnYEy3LhruD2ElCAI8QzPW/Z11Uu+JbrxH2P6e7HwdH3CCOYn/HIxgnbAsZXOR9WqGeEpi0OTJiRqPVntp/uKuZlC2bPdPlHNb/xiZkuJh+AqNMbhpgjHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Esc328AB; arc=fail smtp.client-ip=52.101.193.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Esc328AB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d33khR0vy0MKWotzikYPb1Kqw1Z8G7DPeoq/PAgC8HP0UrBtc7Y1bTNYJdDT2KShRyv5UgfYx7vxxHF7C6ORXQt547eAD/XQbnC+CfYdHugP9/GYgZaXVVU9onwZ+FpGFCF/MkAVQWzVBJHT7VwOHjUwX84Fn3uJZDMCbet/3qYz7+MkYIKr7dSstCY7Oxo4WGvM1PRscEv4mwRV+Kl/AuATR5cyenxRsS6dBEDY6zU9iH4ptv+tYpfgypC8F7RCBsGxJsjbAli+d8C3uJ4SsszrXhTl5vbIufkhm39uAVVWYNyCwwRBFk4jwMYOAAd/Cr3fGSLlbCrnBPmpdpBgvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HSHFJF+dQqyYshIku25tGWexPK/TYFa/Nvrw65f2sBc=;
 b=rTNU+e4G/fUoBOpf4no0KzSZMrTwd3MXmGT8FpUHWAAW6LZMiub0OaGoDXRnJdVYZW7rbT//xz1CCZacjgLCT78IVN0MR5Kd6VkxhluQcybdtCBLx5mc6a0yFb/HqWdzubVeDfNWauEoVQYQ2nIdA/CARM9WhDg+1iilOZ8ubFICu1jSMSwzqCmv53/LtKptcRsDGgHuWhR1IB3RuYzZRIbUKoP66Y9wUirZ8lMUC2cKbU55RC5teDuSsjz26Uoh/mmX0d1K8WfHWzks+sptamS5/UBJp9AYvM6UicyR/M/U1wplaUeca0B/ZSyWmpb6rmj9dPLoUVPCHXv16jG+ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSHFJF+dQqyYshIku25tGWexPK/TYFa/Nvrw65f2sBc=;
 b=Esc328ABGRlx0/ALVrO4ItcMXUv2Lpb2JHVBzBW0vwxGIS7dBqEC92otEoQZoPIWR6LryYZ7vA6Z1kcXjq0xrd/+fjuzJrPqirEAnZK0k8qeZOCluhVVANYrdXIcj42w5XnXJ5vU1SCkfBPVWnFmUs1aoRYwBj8HMPDR6Mr30zE=
Received: from BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29)
 by CH3PR12MB8457.namprd12.prod.outlook.com (2603:10b6:610:154::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 07:20:59 +0000
Received: from MWH0EPF000C6187.namprd02.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::f1) by BY5PR04CA0019.outlook.office365.com
 (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Tue,
 3 Mar 2026 07:20:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000C6187.mail.protection.outlook.com (10.167.249.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Tue, 3 Mar 2026 07:20:58 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Mar
 2026 01:20:42 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Mar
 2026 01:20:41 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 3 Mar 2026 01:20:39 -0600
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <mounika.botcha@amd.com>,
	<sarat.chand.savitala@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 3/6] crypto: zynqmp-sha: Replace zynqmp prefix with xilinx
Date: Tue, 3 Mar 2026 12:49:50 +0530
Message-ID: <20260303071953.149252-4-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303071953.149252-1-h.jain@amd.com>
References: <20260303071953.149252-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6187:EE_|CH3PR12MB8457:EE_
X-MS-Office365-Filtering-Correlation-Id: 353ad064-77a8-47f0-77ff-08de78f56abd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	PNT3t6k4PnRvfJGVeZl9gZh5Ra+2XKOi3QHWccP+tweS0J1uePGibzLPl1uhjE6pjz60dBLWlIPc9vczNtv4hZG5TeFcz4v79LJeQM8Mi+YeIEH9tUXE1OAxPzE/5shdsEo1lDTyRtQypGbwla8GfAwOwwgVhWplGi4UcY8MXBYjpol9/TQDJ22kusOccyDL+ncNhs6SAjRfoZx88qA2SRXAPYP/BnebODDOlFJVBUohh0f8+O2x6fKThA/KHJ3YmYbjWOTmQQ1wGso4Rxexu8kQ3oh5lBEf8fc0x8ze/F8QpCFo/tNpid0VUaFVq6iDhQaD6gd5rpvt0KPlQLrlQIMTD2tYy8pjhNolFrA2ob+hLE2sysgiHoQ1e+xNVjaRu1fD3ds1YQshTKbotvpcmfaIjCHB5f+C2F3tCf6rAbzG7uWQkH6jnjeqqn1VVz6iSQ3o0+TTDUYnQWOcIznNM5B4b/j+wFOPVFwvoRB4ZOatuGnwzrkd1z7Cl+kV2lvMMLnXQQn1TKo8LVAZyaGGrlnOZ3OkycRLwT9yGndSemJzLQjcGxsbC6sDytaJmSte7JmsIE1RYCKx8xFJomkvRm5AiQbY/qs8NaQJG24op+nqJVQImcKglamCV4WZ/N+rybDttJXdPNgkzyeVdZuwjLd0nczYLNNBNILQ63o0tercm4E3nqqZxJjYVoCowt+jINnRsugewuLek2r2HV/jYfy6n7AJQYD20NCW9WAfUtIacPTCrAy5KI7FEuqLTBtx0DDzathzd/KR4M/EeHi7S21zvsUe4I0legp8iK22iQXj/YeheNpPqQWS5LNz5bBzM5fLOO9keLaSwri9Z6qsQA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bSsm10B86zpqtQtJYLjqHe0KDcKQ1xdkcYQTH1cEJI8UHqgjraCI4kQMs4e6Z242kyq3ft+3xmzALUHQ6lF7rTssXEye5bQaJ6MTmGNV0Azea6Pkb8luO3QPTZVLMW1s+cZ1GjNIcgqPi9mrJJKYMEQ6uEx1PqwXo+xJp/I38oCaG2LfLjELVN4UUh3TTJOMfr9IS9OFM4LX/6fxtOyxPB0whoBFZP0+RhYbsAbTb5Zc42SS5wrYXdkAQytzJgljKMAcylndbghhzBK3SiLni5mHmMG8WEJPlk9Uv8dP+J87u8vFJgRFfPxOO1GkrcjmJ8ZflIKP/dOlQY5yoHjjcWFAfscGRUYbn6Hcsqk5d/HEwF3SSw9zFkpF3AwKZeE6iTvr5LRkaOo9ubOEC7qq358X25aK/shWwrSFQ70BIT3brKnjqgnGruanTvnwFKsI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 07:20:58.4968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 353ad064-77a8-47f0-77ff-08de78f56abd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6187.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8457

Prepare for versal sha3-384 support by renaming symbols from
zynqmp to xilinx.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-sha.c | 54 +++++++++++++++---------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index cd951e692dd9..74e95df5eefc 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -27,18 +27,18 @@ enum zynqmp_sha_op {
 	ZYNQMP_SHA3_FINAL = 4,
 };
 
-struct zynqmp_sha_drv_ctx {
+struct xilinx_sha_drv_ctx {
 	struct ahash_engine_alg sha3_384;
 	struct crypto_engine *engine;
 	struct device *dev;
 };
 
-struct zynqmp_sha_tfm_ctx {
+struct xilinx_sha_tfm_ctx {
 	struct device *dev;
 	struct crypto_ahash *fbk_tfm;
 };
 
-struct zynqmp_sha_desc_ctx {
+struct xilinx_sha_desc_ctx {
 	struct ahash_request fallback_req;
 };
 
@@ -48,12 +48,12 @@ static char *ubuf, *fbuf;
 static int zynqmp_sha_init_tfm(struct crypto_tfm *tfm)
 {
 	const char *fallback_driver_name = crypto_tfm_alg_name(tfm);
-	struct zynqmp_sha_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	struct xilinx_sha_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
 	struct hash_alg_common *alg = crypto_hash_alg_common(__crypto_ahash_cast(tfm));
 	struct crypto_ahash *fallback_tfm;
-	struct zynqmp_sha_drv_ctx *drv_ctx;
+	struct xilinx_sha_drv_ctx *drv_ctx;
 
-	drv_ctx = container_of(alg, struct zynqmp_sha_drv_ctx, sha3_384.base.halg);
+	drv_ctx = container_of(alg, struct xilinx_sha_drv_ctx, sha3_384.base.halg);
 	tfm_ctx->dev = drv_ctx->dev;
 
 	/* Allocate a fallback and abort if it failed. */
@@ -67,28 +67,28 @@ static int zynqmp_sha_init_tfm(struct crypto_tfm *tfm)
 				   crypto_ahash_statesize(fallback_tfm));
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 crypto_ahash_reqsize(tfm_ctx->fbk_tfm) +
-				 sizeof(struct zynqmp_sha_desc_ctx));
+				 sizeof(struct xilinx_sha_desc_ctx));
 
 	return 0;
 }
 
 static void zynqmp_sha_exit_tfm(struct crypto_tfm *tfm)
 {
-	struct zynqmp_sha_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	struct xilinx_sha_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
 
 	if (tfm_ctx->fbk_tfm) {
 		crypto_free_ahash(tfm_ctx->fbk_tfm);
 		tfm_ctx->fbk_tfm = NULL;
 	}
 
-	memzero_explicit(tfm_ctx, sizeof(struct zynqmp_sha_tfm_ctx));
+	memzero_explicit(tfm_ctx, sizeof(struct xilinx_sha_tfm_ctx));
 }
 
 static int zynqmp_sha_init(struct ahash_request *req)
 {
-	struct zynqmp_sha_desc_ctx *dctx = ahash_request_ctx(req);
+	struct xilinx_sha_desc_ctx *dctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct zynqmp_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct xilinx_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&dctx->fallback_req, tctx->fbk_tfm);
 	dctx->fallback_req.base.flags = req->base.flags &
@@ -98,9 +98,9 @@ static int zynqmp_sha_init(struct ahash_request *req)
 
 static int zynqmp_sha_update(struct ahash_request *req)
 {
-	struct zynqmp_sha_desc_ctx *dctx = ahash_request_ctx(req);
+	struct xilinx_sha_desc_ctx *dctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct zynqmp_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct xilinx_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&dctx->fallback_req, tctx->fbk_tfm);
 	dctx->fallback_req.base.flags = req->base.flags &
@@ -112,9 +112,9 @@ static int zynqmp_sha_update(struct ahash_request *req)
 
 static int zynqmp_sha_final(struct ahash_request *req)
 {
-	struct zynqmp_sha_desc_ctx *dctx = ahash_request_ctx(req);
+	struct xilinx_sha_desc_ctx *dctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct zynqmp_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct xilinx_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&dctx->fallback_req, tctx->fbk_tfm);
 	dctx->fallback_req.base.flags = req->base.flags &
@@ -125,9 +125,9 @@ static int zynqmp_sha_final(struct ahash_request *req)
 
 static int zynqmp_sha_finup(struct ahash_request *req)
 {
-	struct zynqmp_sha_desc_ctx *dctx = ahash_request_ctx(req);
+	struct xilinx_sha_desc_ctx *dctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct zynqmp_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct xilinx_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&dctx->fallback_req, tctx->fbk_tfm);
 	dctx->fallback_req.base.flags = req->base.flags &
@@ -142,9 +142,9 @@ static int zynqmp_sha_finup(struct ahash_request *req)
 
 static int zynqmp_sha_import(struct ahash_request *req, const void *in)
 {
-	struct zynqmp_sha_desc_ctx *dctx = ahash_request_ctx(req);
+	struct xilinx_sha_desc_ctx *dctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct zynqmp_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct xilinx_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&dctx->fallback_req, tctx->fbk_tfm);
 	dctx->fallback_req.base.flags = req->base.flags &
@@ -154,9 +154,9 @@ static int zynqmp_sha_import(struct ahash_request *req, const void *in)
 
 static int zynqmp_sha_export(struct ahash_request *req, void *out)
 {
-	struct zynqmp_sha_desc_ctx *dctx = ahash_request_ctx(req);
+	struct xilinx_sha_desc_ctx *dctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct zynqmp_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct xilinx_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&dctx->fallback_req, tctx->fbk_tfm);
 	dctx->fallback_req.base.flags = req->base.flags &
@@ -168,9 +168,9 @@ static int sha_digest(struct ahash_request *req)
 {
 	struct crypto_tfm *tfm = crypto_ahash_tfm(crypto_ahash_reqtfm(req));
 	struct hash_alg_common *alg = crypto_hash_alg_common(__crypto_ahash_cast(tfm));
-	struct zynqmp_sha_drv_ctx *drv_ctx;
+	struct xilinx_sha_drv_ctx *drv_ctx;
 
-	drv_ctx = container_of(alg, struct zynqmp_sha_drv_ctx, sha3_384.base.halg);
+	drv_ctx = container_of(alg, struct xilinx_sha_drv_ctx, sha3_384.base.halg);
 	return crypto_transfer_hash_request_to_engine(drv_ctx->engine, req);
 }
 
@@ -220,7 +220,7 @@ static int handle_zynqmp_sha_engine_req(struct crypto_engine *engine, void *req)
 	return 0;
 }
 
-static struct zynqmp_sha_drv_ctx zynqmp_sha3_drv_ctx = {
+static struct xilinx_sha_drv_ctx zynqmp_sha3_drv_ctx = {
 	.sha3_384.base = {
 		.init = zynqmp_sha_init,
 		.update = zynqmp_sha_update,
@@ -241,7 +241,7 @@ static struct zynqmp_sha_drv_ctx zynqmp_sha3_drv_ctx = {
 				CRYPTO_ALG_ALLOCATES_MEMORY |
 				CRYPTO_ALG_NEED_FALLBACK,
 			.base.cra_blocksize = SHA3_384_BLOCK_SIZE,
-			.base.cra_ctxsize = sizeof(struct zynqmp_sha_tfm_ctx),
+			.base.cra_ctxsize = sizeof(struct xilinx_sha_tfm_ctx),
 			.base.cra_module = THIS_MODULE,
 		}
 	},
@@ -262,7 +262,7 @@ static struct xlnx_feature sha_feature_map[] = {
 
 static int zynqmp_sha_probe(struct platform_device *pdev)
 {
-	struct zynqmp_sha_drv_ctx *sha3_drv_ctx;
+	struct xilinx_sha_drv_ctx *sha3_drv_ctx;
 	struct device *dev = &pdev->dev;
 	int err;
 
@@ -328,7 +328,7 @@ static int zynqmp_sha_probe(struct platform_device *pdev)
 
 static void zynqmp_sha_remove(struct platform_device *pdev)
 {
-	struct zynqmp_sha_drv_ctx *sha3_drv_ctx;
+	struct xilinx_sha_drv_ctx *sha3_drv_ctx;
 
 	sha3_drv_ctx = platform_get_drvdata(pdev);
 	crypto_engine_unregister_ahash(&sha3_drv_ctx->sha3_384);
-- 
2.34.1

