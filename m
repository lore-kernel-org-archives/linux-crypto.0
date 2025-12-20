Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011007.outbound.protection.outlook.com [40.107.208.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA4B207DE2;
	Sat, 20 Dec 2025 15:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766246372; cv=fail; b=NyCceSJS/tIlrWYYyMwbhUBiwhC3iEUktAWH1rTLUMr2Lhvg0S6T75mGnsD6WdWDxTInBf3OghZDdVd7bL3BZfN4UPxoulKDhVfqerwEYqkgP9Fg6H1Dn4j/Yfnl2ZnWwUEoV86XJTvc1nAtNxbwtSS9dgdBod95gPnCoAjCiRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766246372; c=relaxed/simple;
	bh=RtlywX7Spo3VplwOaoK4+lB6nk/K8oMYXi5qRlIKkz0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WvNkWjj+ix78Rb1jOD5DhOVoXDrPWe8ZzFTyIxe3HdnNiyEOtxZuybJPC7M8x5qT1kdgrOJqY8QwZ13DhMm+qebPiprDEvz5g5nWDQ8HRY3hWyKIOcnYR3naqsElybnO4vZxJJY6LejtPiLJyL7XTKlx6SOg5QeYjxsDRQCrbCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ioK1+IUs; arc=fail smtp.client-ip=40.107.208.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ioK1+IUs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vSW7hGjVw8cMOXAS93az52O3VXZwQN0aEC9jaaYY/IhnKXxbWtx+YINNN6Bwns1ADYmTR7FkqKra8WxHlbPfPvgSMeGjKI903IsErc7N5QI1b1tr4eAsFEz/CfAOno3lNP5dHUy93btBr2bd+6tpb0mlZM3/JZYCl2HLsoOo7AElD/udawzegfY9UF19umq+CbfePn/L7HF6lQlufQoBQAzpMsfAevCthUWmpHJ4ZSJ/7k1YCoy4wiyvh/v81qlxxhMk4K6Um2Sdei8NtDxvQS7jjTZd7S5jmh8pq4+KLaU4STdH2nG9dQ9kS+7oGfvU65a2n+vXdTSLKszAd3RGuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MUMRK8zl+KuFVCo5rGg+8JQJSK5NQArsC55bI/pBxgo=;
 b=bumv+muQlfheLnzCx0f05qIQrvqvjUweuDuAMi09o3VESxtZ2LAqoAtpMU6SASHbOzSSRpM+iel4IW0Rc6RkPCGGiJg+rBHeF9AwJ8cSTZDm1p8l5aokc/FoR7OZT+GYfJuo3XzvoLG2N1vMhIXJgOve14P0syUC3HRE36BrqyGgTa6w1PwU8mk9olQZq0Leb9kwgqELCEMt62f+cvQiFcO21kBXFKwnrKKUPvr/BPIM14rqSVKUcPZA0IYxBK1O62/gSE+7bKelTXnioBWqUGK+C6lG5PYxkDFdLDv1r8upXTI0yLj23YMaj1gMezu3gDdoix2iKlUCmJL/hT930w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUMRK8zl+KuFVCo5rGg+8JQJSK5NQArsC55bI/pBxgo=;
 b=ioK1+IUsjcE7tcqokLWQ1H+9K9TOBSXiAQXJ65876uLLbxB90A3fjKz8u5PKC3m3GgwwxG0c8VaX+t0sYCPIWp9Qceex4ZQaUBywyN2vcuxFY4+2ncTKQFeRFdhEeRWl9zayGxSiPi31N4raxXjZW7mTbyQquRRZKnscPa5Jut0=
Received: from PH3PEPF0000409D.namprd05.prod.outlook.com (2603:10b6:518:1::50)
 by BY5PR12MB4226.namprd12.prod.outlook.com (2603:10b6:a03:203::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.10; Sat, 20 Dec
 2025 15:59:26 +0000
Received: from CY4PEPF0000EE36.namprd05.prod.outlook.com
 (2a01:111:f403:f912::2) by PH3PEPF0000409D.outlook.office365.com
 (2603:1036:903:49::3) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9456.8 via Frontend Transport; Sat,
 20 Dec 2025 15:59:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CY4PEPF0000EE36.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Sat, 20 Dec 2025 15:59:25 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 20 Dec
 2025 09:59:25 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 20 Dec
 2025 09:59:24 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sat, 20 Dec 2025 07:59:21 -0800
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 02/14] crypto: zynqmp-aes-gcm: cleanup: Remove union from zynqmp_aead_drv_ctx
Date: Sat, 20 Dec 2025 21:28:53 +0530
Message-ID: <20251220155905.346790-3-h.jain@amd.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251220155905.346790-1-h.jain@amd.com>
References: <20251220155905.346790-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE36:EE_|BY5PR12MB4226:EE_
X-MS-Office365-Filtering-Correlation-Id: e22985e9-872d-4c9c-1bb1-08de3fe0bfcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wb8RFBLVUJnbS4jMs/MfxM9pD0tCTpsuNePRq5wbKj8hdd79v1dnq+ejQ8kE?=
 =?us-ascii?Q?UdPBmVeB62wfsl57fJlPW5ziNYlkYb3wzSK/oUq4j13nMnd7dEH4SdYvnj5s?=
 =?us-ascii?Q?OfGCEJvmqnl9leTQPpM/Ic2vxYx0c76/WkcJc6hd41LiNQKHwHF0En8SCZ47?=
 =?us-ascii?Q?8Xp6bm2saduc3Nrk8Ge8ZzEJSEAUWdWOOzQmwPPCD4CJJEHX/bpEavl963A7?=
 =?us-ascii?Q?LvgiASX0ZkgegHJA7qDtNYrInTf4Z/nnME2jdAVB02Ppuww7eXWF9RW2FgFd?=
 =?us-ascii?Q?PuEFEe+bGMiS7aOo/UT5Si5hZOzq99H1qmCUFDd/MJFdQJym94BEChmRMGub?=
 =?us-ascii?Q?3TDCiKurpnhwrWoWJuc4I+HZJiO98RCyZT/ZzDgXL4xenGldjXNYhSpq6axX?=
 =?us-ascii?Q?Zdl/aDUAUuEQ61zCrbQ5DkpsCPaOpkY4GsS7o2ReUWMv0lqCEZE9qLx9g1tO?=
 =?us-ascii?Q?LdrVOzs/VHOq/bfdhHv8jfgifOKkh9w+mWY+D7YpBlvCN0yqrI3kZFXu15fd?=
 =?us-ascii?Q?8dXpUpmYhMMNccIaQqInExrUPpIoqOa3SXr78RRaWNLJg4emFEXfYSX+NKis?=
 =?us-ascii?Q?eshBgAZFceB5l25/d33aWuA4MrU+pIqhXsQH6mQrpNFZ2sKwFqlTfXQrnFmI?=
 =?us-ascii?Q?YW3Vl0f8RYsbKKSeoYoZF8wIcMGtQqYNN8ENpN/9Rt1jzdLGHHsA1dNh0bpQ?=
 =?us-ascii?Q?tIVP4MFK520lGUub0ConutHvNDMC20n/OdxnOo7IErfl+ajAjONLwLRv4I1A?=
 =?us-ascii?Q?cvnz92axOI76prOz99MeuQPb1c0Vt5hg1IsJ8pEAkgNXKC9KNtlt0/fE2KWe?=
 =?us-ascii?Q?f5zt8yzr9RNCH4F8MvERM5UdR2H1syw0oBLIgthpSHlI6QaI+3Z9XakZnuPs?=
 =?us-ascii?Q?6nyL8+8xHgzJ+GV2YDZbYqOW5Irt3mdznBpa/YkvzfYg5XClCc7s/S1Y/mgT?=
 =?us-ascii?Q?7fZ/qp1i5RMybdUzTnSdOZedkDTeliWjnJbZwRalpyZCUSNWj7Lz2taceOMX?=
 =?us-ascii?Q?MgBUUSffCusmGv94w/xsVCamVph6gFQIfC+zmKeHWG5o6JCJtLjdC8WtybvA?=
 =?us-ascii?Q?xHi1tXdZEuf9mkLUiFsktaHuWuQVY2SSnSveT6qNHdRLCowO6GUqg+pY7YE7?=
 =?us-ascii?Q?lE9BN5BnJCLITYM8tJpmlfo40hpC+G58fPclNKCl5gBVAl9k+NLpCn6I3uew?=
 =?us-ascii?Q?bXJOcd0nKha9alYrDjgiA7U1Sv5NsDV2WAmXsZcAw0u7JGjtrd2g/GFIx0us?=
 =?us-ascii?Q?XNXPQNRxjnl5G7TZp7Jk9wv9nybcK0bWui06aW2tPfS43h5TI4DYKNwbPvg9?=
 =?us-ascii?Q?Fv/gxOfpKnVWzbJE4RacDbbi+z3n2zNL4FNPor67/VW3zAYFBZ5j+wS7V44V?=
 =?us-ascii?Q?9RFxMmhLhr4oErJ26Jt3uyMEFnfdeRrU3kD8IN4qVKMAARSNxJyot9RWzF+g?=
 =?us-ascii?Q?C/16qlUJLIlhHrA40GwGlfCz2KAnjQV2fL9T/d00iWxPVl7Id1eUg9M0IkEL?=
 =?us-ascii?Q?CsYX50IPZVBaeIbbDHH5fU4aegZNoaz3iTvTLLnH+dvmaRVIKIyWeCYmLRtp?=
 =?us-ascii?Q?IEYhDKwcj73YCIeSQAdyeBtuqENM4U6/KwAWQiNb?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2025 15:59:25.5308
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e22985e9-872d-4c9c-1bb1-08de3fe0bfcb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE36.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4226

"alg" in zynqmp_aead_drv_ctx is single field union variable.
Remove unnecessary alg union from structure.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 6e72d9229410..3ce1319d1a1a 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -43,9 +43,7 @@ enum zynqmp_aead_keysrc {
 };
 
 struct zynqmp_aead_drv_ctx {
-	union {
-		struct aead_engine_alg aead;
-	} alg;
+	struct aead_engine_alg aead;
 	struct device *dev;
 	struct crypto_engine *engine;
 };
@@ -289,7 +287,7 @@ static int zynqmp_aes_aead_encrypt(struct aead_request *req)
 	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 
 	rq_ctx->op = ZYNQMP_AES_ENCRYPT;
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead.base);
+	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
 
 	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
 }
@@ -302,7 +300,7 @@ static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 
 	rq_ctx->op = ZYNQMP_AES_DECRYPT;
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead.base);
+	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
 
 	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
 }
@@ -315,16 +313,16 @@ static int zynqmp_aes_aead_init(struct crypto_aead *aead)
 	struct zynqmp_aead_drv_ctx *drv_ctx;
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead.base);
+	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
 	tfm_ctx->dev = drv_ctx->dev;
 
-	tfm_ctx->fbk_cipher = crypto_alloc_aead(drv_ctx->alg.aead.base.base.cra_name,
+	tfm_ctx->fbk_cipher = crypto_alloc_aead(drv_ctx->aead.base.base.cra_name,
 						0,
 						CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(tfm_ctx->fbk_cipher)) {
 		pr_err("%s() Error: failed to allocate fallback for %s\n",
-		       __func__, drv_ctx->alg.aead.base.base.cra_name);
+		       __func__, drv_ctx->aead.base.base.cra_name);
 		return PTR_ERR(tfm_ctx->fbk_cipher);
 	}
 
@@ -349,7 +347,7 @@ static void zynqmp_aes_aead_exit(struct crypto_aead *aead)
 }
 
 static struct zynqmp_aead_drv_ctx aes_drv_ctx = {
-	.alg.aead.base = {
+	.aead.base = {
 		.setkey		= zynqmp_aes_aead_setkey,
 		.setauthsize	= zynqmp_aes_aead_setauthsize,
 		.encrypt	= zynqmp_aes_aead_encrypt,
@@ -372,7 +370,7 @@ static struct zynqmp_aead_drv_ctx aes_drv_ctx = {
 		.cra_module		= THIS_MODULE,
 		}
 	},
-	.alg.aead.op = {
+	.aead.op = {
 		.do_one_request = zynqmp_handle_aes_req,
 	},
 };
@@ -407,7 +405,7 @@ static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 		goto err_engine;
 	}
 
-	err = crypto_engine_register_aead(&aes_drv_ctx.alg.aead);
+	err = crypto_engine_register_aead(&aes_drv_ctx.aead);
 	if (err < 0) {
 		dev_err(dev, "Failed to register AEAD alg.\n");
 		goto err_aead;
@@ -415,7 +413,7 @@ static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 	return 0;
 
 err_aead:
-	crypto_engine_unregister_aead(&aes_drv_ctx.alg.aead);
+	crypto_engine_unregister_aead(&aes_drv_ctx.aead);
 
 err_engine:
 	if (aes_drv_ctx.engine)
@@ -427,7 +425,7 @@ static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 static void zynqmp_aes_aead_remove(struct platform_device *pdev)
 {
 	crypto_engine_exit(aes_drv_ctx.engine);
-	crypto_engine_unregister_aead(&aes_drv_ctx.alg.aead);
+	crypto_engine_unregister_aead(&aes_drv_ctx.aead);
 }
 
 static const struct of_device_id zynqmp_aes_dt_ids[] = {
-- 
2.49.1

