Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010008.outbound.protection.outlook.com [52.101.193.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42A72D1907;
	Sat, 20 Dec 2025 16:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766246403; cv=fail; b=EA+2XlX1nDRrsDbJExR/d5r9TnMyV9IFpMvGwgUNviAunNGerviU7DOVy9HD8vvV+FTUGcjeFiIYZB+GUC9/lm5Hub0uNzfdIgv/rfquXAamMV9yJoK9KB4PXJBpcS2ZcbI//gahd+1mYCZ5zNGvWOuDw9Fx1l0gtSqqqJxixk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766246403; c=relaxed/simple;
	bh=6aF6YdHnhqihgi2wCBXenzqws4KpvJ6omSvI6lYoVFY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qrf2cMk3Tpdi7srJU660nh90ggAYRfPiIm5r4zeup5EVmk7+7za6rZQBMWBjRaUDnygoTkqbCdJj1snqmjz8R9fghlT1hxCOMFeDGTgGYqyIRUvKO4oy3mXB8fCXPpblvqeQ5RwQnQxV2qJ205e6LO8c8aqp1A2bFVsDhtvPq7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hn+2QXUE; arc=fail smtp.client-ip=52.101.193.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hn+2QXUE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ya8M5y0oFV+NCS9q/tkqP2EpQ1u14cgGBcVCNjwHJ/7FE4/H8OKDmCkTBTKnHjmgmocqanuT6SRCbly7sroUBYa1GqGtmLgz2Qkmn5d5NB5/ctkxlN8FUinUAj1xR07nVmvg4aJYylw5s3y4Tsnigw6b/B7lBdga5Pot22/nenRvfc/I3hbunkjoXY+bNMvCzXF64420Ilpk5cSTbsUtVvR4jfbTqtFkAf4bhuGrNP90CPlEjBpzIvA0c0/aHpeDsp9zLFZf8ajRgVHdDr995eHA6eJsQ59IZN75DZKT7LFqrLxXwr3zDZ8w32AnSCqqOXqbEbC66oafvVmErxtw/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m4/0UuRr7BMUSSuQ/IxhAfyUArAjOet52JyEYoTFHwQ=;
 b=WtFXcm2KP+nI2t0mYCFh6y6sAETf3Xh4gizntj7NFp3RbwD7fFoT7tpsSlLEt/+LhD2lZA7hEqCImBvf1Cz3nshMXev4qXY69MaTzr4/kpCJz9KeVrCfzs9MNq1QhEcHFX6zl3U5Oj60KdibUqQ+TN5yHomx7edy2EEigO+zEdPDfwIs1w6CQZnxx6Aw0rzGPyWLfm8uVJW2WyehJSY0TfxC0zIyZCGGc5f+tmIu9vWDn3rp1psFNLr+Htk7vJYBM+T0tCkU/Ths60rK4ujnU+5Uh1meL40cHyhCBWbJjlna5gaPPcynFf2NQcm3hG0m3QELsjdH8S+8yYZ+IDdlDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4/0UuRr7BMUSSuQ/IxhAfyUArAjOet52JyEYoTFHwQ=;
 b=Hn+2QXUEqAzgcDmYJOg9gmF/e7Olxi0JmWsglo+96zWMyZ7+pzoGFBO0l/iWVQhUBtuPc+sCrRgrDapb7e7+moiafzRwGN9EO+vTEl7ZAsK8wSDTjtkXtfacfGCxKpLBDNVBN3oRDnimJxL90Bv5BVtJ2M2MnsEnXeCsf4qQwDA=
Received: from PH0PR07CA0081.namprd07.prod.outlook.com (2603:10b6:510:f::26)
 by LV3PR12MB9165.namprd12.prod.outlook.com (2603:10b6:408:19f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.10; Sat, 20 Dec
 2025 15:59:54 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:510:f:cafe::32) by PH0PR07CA0081.outlook.office365.com
 (2603:10b6:510:f::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.10 via Frontend Transport; Sat,
 20 Dec 2025 15:59:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.9 via Frontend Transport; Sat, 20 Dec 2025 15:59:54 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 20 Dec
 2025 09:59:53 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sat, 20 Dec 2025 07:59:50 -0800
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 10/14] crypto: xilinx: Replace zynqmp prefix with xilinx
Date: Sat, 20 Dec 2025 21:29:01 +0530
Message-ID: <20251220155905.346790-11-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|LV3PR12MB9165:EE_
X-MS-Office365-Filtering-Correlation-Id: fadd0ab1-18ec-4fcd-60ea-08de3fe0d0df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3nG8buZCwPK7Zyggq/gVzDMESG2e2EVncJcpcqJoxZmenRLP/ezaFgc9SttA?=
 =?us-ascii?Q?LLNetktcQfeovDlfrD51UpPn6pXGdWpw08vCs9UelTBifKaQLHluZjzcAMWW?=
 =?us-ascii?Q?Vx1mKxHHZU1dtEq6c8FPZ2A6pjlHfN/8zvPdwMrUkt/HRD64HydnwbioXf4S?=
 =?us-ascii?Q?n/wkDcQMY1beRIy/b72o9Kj+UXZnT+k1JBn2gF8K9pM8uariEdstGZEUKj0F?=
 =?us-ascii?Q?fDCn/tRqFAegfO3f+/vqnXyh9ChKQshQvD2hjFeO0anwG+z/O0JCkL9sTpre?=
 =?us-ascii?Q?WyzjGf/q7nsm7InNBJ0LxZ+LTllsQ+i6ptX/W7TeoVkCPn+UsRglINP/6m/V?=
 =?us-ascii?Q?GuhwbumsKa7e4ECBFQpXlPn97rFsxAezPkIgr6sumVfgW3dnWAsfsMHGwFhe?=
 =?us-ascii?Q?BcP9eSZgFvq3uxbb54sG3ooMNXYdAfbzZEMNPYayJHUYr52/KbBppLFvgpmE?=
 =?us-ascii?Q?V3bW86Zq6w0dbMPoaDwh6CQUl2A5WBDjZf/rf31zoJl3zM1hhgQHKNza1w5y?=
 =?us-ascii?Q?e2G9GZR+u3cZ36YmSOYfnxHnK/1wErQjGDY0q0H2ae3TG5DmZYHY2F/ltL42?=
 =?us-ascii?Q?wETNGtYiP6cKl5fvgMJqqiRiLqxTSVqElCiRhkhMbA3P41GshdwzNjYv/DGh?=
 =?us-ascii?Q?cixQMQs+2hQLFe+ZmpQq4zcmEw17owMxTUi23n//ZnEtWNmn5B+ZxdEDg/Fd?=
 =?us-ascii?Q?bwSxy37UZKJKkYQNDJDC5j+NoqNeb7UhwVtRR7X9ulNGG2WZ9qhDuwsKuCZB?=
 =?us-ascii?Q?Pa1Kp1MxKyh575eie5LjsWIGIw/YNeTxm79GgEfi90F5bzC3eegN0cohgrB/?=
 =?us-ascii?Q?pZfRGRox9ZTqOU5wR88bx4akROb/DvCgwJsQYJ1ffcqy9h5Bx80MNyii/f/i?=
 =?us-ascii?Q?nD888G/xgBfF5PpocJSVTNKH5m86rOR/8qBCMpxQ2wQbsCKJBw1pKoByxzkx?=
 =?us-ascii?Q?XPVkTcMlfwY3fvk52Bd8Fzx17GU7hikMz5ngF18QS0UkCfnP0jiUHoemVTEH?=
 =?us-ascii?Q?++JEkXpKtAQfO+vunFFnSdQU49kAtMnLX7T9PxfOaG1+VP+zIvI41ekVy3fZ?=
 =?us-ascii?Q?8B8Ez5+9hL5DaadzSrUWUabBkSwdOR+KahDgPUwK4t9SHU3EZb0fJBY9V12o?=
 =?us-ascii?Q?hRLZzgf1l9ocPeyJb8lszXA0Xf7Xr6830JeKbWYTW332MccaWZLDzQNS0SFH?=
 =?us-ascii?Q?LKLz5xYh7DNBSQPl6SQTNpPhrg0ZZxH5S76YKE7o21UMtmnSkxZPWn06Y4/x?=
 =?us-ascii?Q?0epBxWCRqq6Ncse2jUFohAoVj/WsnS4Qlnnl1T4jYPAAFFOS1voq2zZtbfF9?=
 =?us-ascii?Q?Ej6Vq6d3jJxgWCSniGBMCU2uGw9isNhcg3Lg1GmMKPxn/u8BZrShXy9Atbqs?=
 =?us-ascii?Q?OVmPZ2gJ0drndWaqI9HJg8eQCQIbks2xLX8e+8FZmwY//0OWVbqJy5FDfwaD?=
 =?us-ascii?Q?6+kwUjBdfwaxqNarFMs0hPtOXkxkKxNL03Y8hWiB5O8FKeD/YBSzMXOcVYey?=
 =?us-ascii?Q?fxV7F1zIhZ2nb7rIV6rVV38oNH8exHLnj12MeKDvmW8KxH6ks3CFUUV57PY5?=
 =?us-ascii?Q?qXNe33Idatbm2VYu4ogkHpn2hVaybvwXEbg4ZnWM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2025 15:59:54.1838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fadd0ab1-18ec-4fcd-60ea-08de3fe0d0df
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9165

Replace zynqmp with xilinx to have more generic name.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 140 ++++++++++++-------------
 1 file changed, 69 insertions(+), 71 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 179595b24f4f..34dbb8b7d3a8 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -19,10 +19,8 @@
 #include <linux/string.h>
 
 #define ZYNQMP_DMA_BIT_MASK	32U
-
-#define ZYNQMP_AES_KEY_SIZE		AES_KEYSIZE_256
-#define ZYNQMP_AES_AUTH_SIZE		16U
-#define ZYNQMP_AES_BLK_SIZE		1U
+#define XILINX_AES_AUTH_SIZE		16U
+#define XILINX_AES_BLK_SIZE		1U
 #define ZYNQMP_AES_MIN_INPUT_BLK_SIZE	4U
 #define ZYNQMP_AES_WORD_LEN		4U
 
@@ -31,9 +29,9 @@
 #define ZYNQMP_AES_PUF_NOT_PROGRAMMED	0xE300
 #define XILINX_KEY_MAGIC		0x3EA0
 
-enum zynqmp_aead_op {
-	ZYNQMP_AES_DECRYPT = 0,
-	ZYNQMP_AES_ENCRYPT
+enum xilinx_aead_op {
+	XILINX_AES_DECRYPT = 0,
+	XILINX_AES_ENCRYPT
 };
 
 enum zynqmp_aead_keysrc {
@@ -69,9 +67,9 @@ struct zynqmp_aead_hw_req {
 	u64 keysrc;
 };
 
-struct zynqmp_aead_tfm_ctx {
+struct xilinx_aead_tfm_ctx {
 	struct device *dev;
-	u8 key[ZYNQMP_AES_KEY_SIZE];
+	u8 key[AES_KEYSIZE_256];
 	u8 *iv;
 	u32 keylen;
 	u32 authsize;
@@ -79,8 +77,8 @@ struct zynqmp_aead_tfm_ctx {
 	struct crypto_aead *fbk_cipher;
 };
 
-struct zynqmp_aead_req_ctx {
-	enum zynqmp_aead_op op;
+struct xilinx_aead_req_ctx {
+	enum xilinx_aead_op op;
 };
 
 static struct xilinx_aead_dev *aead_dev;
@@ -88,8 +86,8 @@ static struct xilinx_aead_dev *aead_dev;
 static int zynqmp_aes_aead_cipher(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
-	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct xilinx_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 	struct device *dev = tfm_ctx->dev;
 	struct zynqmp_aead_hw_req *hwreq;
 	dma_addr_t dma_addr_data, dma_addr_hw_req;
@@ -100,7 +98,7 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	char *kbuf;
 
 	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY)
-		dma_size = req->cryptlen + ZYNQMP_AES_KEY_SIZE
+		dma_size = req->cryptlen + AES_KEYSIZE_256
 			   + GCM_AES_IV_SIZE;
 	else
 		dma_size = req->cryptlen + GCM_AES_IV_SIZE;
@@ -126,14 +124,14 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	hwreq->keysrc = tfm_ctx->keysrc;
 	hwreq->op = rq_ctx->op;
 
-	if (hwreq->op == ZYNQMP_AES_ENCRYPT)
+	if (hwreq->op == XILINX_AES_ENCRYPT)
 		hwreq->size = data_size;
 	else
-		hwreq->size = data_size - ZYNQMP_AES_AUTH_SIZE;
+		hwreq->size = data_size - XILINX_AES_AUTH_SIZE;
 
 	if (hwreq->keysrc == ZYNQMP_AES_KUP_KEY) {
 		memcpy(kbuf + data_size + GCM_AES_IV_SIZE,
-		       tfm_ctx->key, ZYNQMP_AES_KEY_SIZE);
+		       tfm_ctx->key, AES_KEYSIZE_256);
 
 		hwreq->key = hwreq->src + data_size + GCM_AES_IV_SIZE;
 	} else {
@@ -162,10 +160,10 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 			break;
 		}
 	} else {
-		if (hwreq->op == ZYNQMP_AES_ENCRYPT)
+		if (hwreq->op == XILINX_AES_ENCRYPT)
 			data_size = data_size + crypto_aead_authsize(aead);
 		else
-			data_size = data_size - ZYNQMP_AES_AUTH_SIZE;
+			data_size = data_size - XILINX_AES_AUTH_SIZE;
 
 		sg_copy_from_buffer(req->dst, sg_nents(req->dst),
 				    kbuf, data_size);
@@ -185,12 +183,12 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	return ret;
 }
 
-static int zynqmp_fallback_check(struct zynqmp_aead_tfm_ctx *tfm_ctx,
+static int zynqmp_fallback_check(struct xilinx_aead_tfm_ctx *tfm_ctx,
 				 struct aead_request *req)
 {
-	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	struct xilinx_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 
-	if (tfm_ctx->authsize != ZYNQMP_AES_AUTH_SIZE && rq_ctx->op == ZYNQMP_AES_DECRYPT)
+	if (tfm_ctx->authsize != XILINX_AES_AUTH_SIZE && rq_ctx->op == XILINX_AES_DECRYPT)
 		return 1;
 
 	if (req->assoclen != 0 ||
@@ -203,14 +201,14 @@ static int zynqmp_fallback_check(struct zynqmp_aead_tfm_ctx *tfm_ctx,
 	if ((req->cryptlen % ZYNQMP_AES_WORD_LEN) != 0)
 		return 1;
 
-	if (rq_ctx->op == ZYNQMP_AES_DECRYPT &&
-	    req->cryptlen <= ZYNQMP_AES_AUTH_SIZE)
+	if (rq_ctx->op == XILINX_AES_DECRYPT &&
+	    req->cryptlen <= XILINX_AES_AUTH_SIZE)
 		return 1;
 
 	return 0;
 }
 
-static int zynqmp_handle_aes_req(struct crypto_engine *engine, void *req)
+static int xilinx_handle_aes_req(struct crypto_engine *engine, void *req)
 {
 	struct aead_request *areq =
 				container_of(req, struct aead_request, base);
@@ -228,10 +226,10 @@ static int zynqmp_aes_aead_setkey(struct crypto_aead *aead, const u8 *key,
 				  unsigned int keylen)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
 	int err;
 
-	if (keylen == ZYNQMP_AES_KEY_SIZE) {
+	if (keylen == AES_KEYSIZE_256) {
 		memcpy(tfm_ctx->key, key, keylen);
 	}
 
@@ -252,7 +250,7 @@ static int zynqmp_paes_aead_setkey(struct crypto_aead *aead, const u8 *key,
 				   unsigned int keylen)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
 	struct xilinx_hwkey_info hwkey;
 	unsigned char keysrc;
 	int err = -EINVAL;
@@ -273,12 +271,12 @@ static int zynqmp_paes_aead_setkey(struct crypto_aead *aead, const u8 *key,
 	return err;
 }
 
-static int zynqmp_aes_aead_setauthsize(struct crypto_aead *aead,
+static int xilinx_aes_aead_setauthsize(struct crypto_aead *aead,
 				       unsigned int authsize)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx =
-			(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
+	struct xilinx_aead_tfm_ctx *tfm_ctx =
+			(struct xilinx_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
 
 	tfm_ctx->authsize = authsize;
 	return tfm_ctx->fbk_cipher ? crypto_aead_setauthsize(tfm_ctx->fbk_cipher, authsize) : 0;
@@ -288,7 +286,7 @@ static int xilinx_aes_fallback_crypt(struct aead_request *req, bool encrypt)
 {
 	struct aead_request *subreq = aead_request_ctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
 
 	aead_request_set_tfm(subreq, tfm_ctx->fbk_cipher);
 	aead_request_set_callback(subreq, req->base.flags, NULL, NULL);
@@ -301,9 +299,9 @@ static int xilinx_aes_fallback_crypt(struct aead_request *req, bool encrypt)
 
 static int zynqmp_aes_aead_encrypt(struct aead_request *req)
 {
-	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	struct xilinx_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
 	struct aead_alg *alg = crypto_aead_alg(aead);
 	struct xilinx_aead_alg *drv_ctx;
 	int err;
@@ -313,7 +311,7 @@ static int zynqmp_aes_aead_encrypt(struct aead_request *req)
 	    tfm_ctx->keylen == sizeof(struct xilinx_hwkey_info))
 		return -EINVAL;
 
-	rq_ctx->op = ZYNQMP_AES_ENCRYPT;
+	rq_ctx->op = XILINX_AES_ENCRYPT;
 	err = zynqmp_fallback_check(tfm_ctx, req);
 	if (err && tfm_ctx->keysrc != ZYNQMP_AES_KUP_KEY)
 		return -EOPNOTSUPP;
@@ -326,14 +324,14 @@ static int zynqmp_aes_aead_encrypt(struct aead_request *req)
 
 static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 {
-	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	struct xilinx_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
 	struct aead_alg *alg = crypto_aead_alg(aead);
 	struct xilinx_aead_alg *drv_ctx;
 	int err;
 
-	rq_ctx->op = ZYNQMP_AES_DECRYPT;
+	rq_ctx->op = XILINX_AES_DECRYPT;
 	drv_ctx = container_of(alg, struct xilinx_aead_alg, aead.base);
 	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY &&
 	    tfm_ctx->keylen == sizeof(struct xilinx_hwkey_info))
@@ -350,7 +348,7 @@ static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 static int xilinx_paes_aead_init(struct crypto_aead *aead)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
 	struct xilinx_aead_alg *drv_alg;
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
@@ -359,16 +357,16 @@ static int xilinx_paes_aead_init(struct crypto_aead *aead)
 	tfm_ctx->keylen = 0;
 
 	tfm_ctx->fbk_cipher = NULL;
-	crypto_aead_set_reqsize(aead, sizeof(struct zynqmp_aead_req_ctx));
+	crypto_aead_set_reqsize(aead, sizeof(struct xilinx_aead_req_ctx));
 
 	return 0;
 }
 
-static int zynqmp_aes_aead_init(struct crypto_aead *aead)
+static int xilinx_aes_aead_init(struct crypto_aead *aead)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx =
-		(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
+	struct xilinx_aead_tfm_ctx *tfm_ctx =
+		(struct xilinx_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
 	struct xilinx_aead_alg *drv_ctx;
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
@@ -387,7 +385,7 @@ static int zynqmp_aes_aead_init(struct crypto_aead *aead)
 	}
 
 	crypto_aead_set_reqsize(aead,
-				max(sizeof(struct zynqmp_aead_req_ctx),
+				max(sizeof(struct xilinx_aead_req_ctx),
 				    sizeof(struct aead_request) +
 				    crypto_aead_reqsize(tfm_ctx->fbk_cipher)));
 	return 0;
@@ -396,35 +394,35 @@ static int zynqmp_aes_aead_init(struct crypto_aead *aead)
 static void xilinx_paes_aead_exit(struct crypto_aead *aead)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
 
-	memzero_explicit(tfm_ctx, sizeof(struct zynqmp_aead_tfm_ctx));
+	memzero_explicit(tfm_ctx, sizeof(struct xilinx_aead_tfm_ctx));
 }
 
-static void zynqmp_aes_aead_exit(struct crypto_aead *aead)
+static void xilinx_aes_aead_exit(struct crypto_aead *aead)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx =
-			(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
+	struct xilinx_aead_tfm_ctx *tfm_ctx =
+			(struct xilinx_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
 
 	if (tfm_ctx->fbk_cipher) {
 		crypto_free_aead(tfm_ctx->fbk_cipher);
 		tfm_ctx->fbk_cipher = NULL;
 	}
-	memzero_explicit(tfm_ctx, sizeof(struct zynqmp_aead_tfm_ctx));
+	memzero_explicit(tfm_ctx, sizeof(struct xilinx_aead_tfm_ctx));
 }
 
 static struct xilinx_aead_alg zynqmp_aes_algs[] = {
 	{
 		.aead.base = {
 			.setkey		= zynqmp_aes_aead_setkey,
-			.setauthsize	= zynqmp_aes_aead_setauthsize,
+			.setauthsize	= xilinx_aes_aead_setauthsize,
 			.encrypt	= zynqmp_aes_aead_encrypt,
 			.decrypt	= zynqmp_aes_aead_decrypt,
-			.init		= zynqmp_aes_aead_init,
-			.exit		= zynqmp_aes_aead_exit,
+			.init		= xilinx_aes_aead_init,
+			.exit		= xilinx_aes_aead_exit,
 			.ivsize		= GCM_AES_IV_SIZE,
-			.maxauthsize	= ZYNQMP_AES_AUTH_SIZE,
+			.maxauthsize	= XILINX_AES_AUTH_SIZE,
 			.base = {
 				.cra_name		= "gcm(aes)",
 				.cra_driver_name	= "xilinx-zynqmp-aes-gcm",
@@ -434,26 +432,26 @@ static struct xilinx_aead_alg zynqmp_aes_algs[] = {
 				CRYPTO_ALG_ALLOCATES_MEMORY |
 				CRYPTO_ALG_KERN_DRIVER_ONLY |
 				CRYPTO_ALG_NEED_FALLBACK,
-			.cra_blocksize		= ZYNQMP_AES_BLK_SIZE,
-			.cra_ctxsize		= sizeof(struct zynqmp_aead_tfm_ctx),
+			.cra_blocksize		= XILINX_AES_BLK_SIZE,
+			.cra_ctxsize		= sizeof(struct xilinx_aead_tfm_ctx),
 			.cra_module		= THIS_MODULE,
 			}
 		},
 		.aead.op = {
-			.do_one_request = zynqmp_handle_aes_req,
+			.do_one_request = xilinx_handle_aes_req,
 		},
 		.dma_bit_mask = ZYNQMP_DMA_BIT_MASK,
 	},
 	{
 		.aead.base = {
 			.setkey		= zynqmp_paes_aead_setkey,
-			.setauthsize	= zynqmp_aes_aead_setauthsize,
+			.setauthsize	= xilinx_aes_aead_setauthsize,
 			.encrypt	= zynqmp_aes_aead_encrypt,
 			.decrypt	= zynqmp_aes_aead_decrypt,
 			.init		= xilinx_paes_aead_init,
 			.exit		= xilinx_paes_aead_exit,
 			.ivsize		= GCM_AES_IV_SIZE,
-			.maxauthsize	= ZYNQMP_AES_AUTH_SIZE,
+			.maxauthsize	= XILINX_AES_AUTH_SIZE,
 			.base = {
 				.cra_name		= "gcm(paes)",
 				.cra_driver_name	= "xilinx-zynqmp-paes-gcm",
@@ -462,13 +460,13 @@ static struct xilinx_aead_alg zynqmp_aes_algs[] = {
 				CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_ALLOCATES_MEMORY |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize		= ZYNQMP_AES_BLK_SIZE,
-			.cra_ctxsize		= sizeof(struct zynqmp_aead_tfm_ctx),
+			.cra_blocksize		= XILINX_AES_BLK_SIZE,
+			.cra_ctxsize		= sizeof(struct xilinx_aead_tfm_ctx),
 			.cra_module		= THIS_MODULE,
 			}
 		},
 		.aead.op = {
-			.do_one_request = zynqmp_handle_aes_req,
+			.do_one_request = xilinx_handle_aes_req,
 		},
 		.dma_bit_mask = ZYNQMP_DMA_BIT_MASK,
 	},
@@ -484,7 +482,7 @@ static struct xlnx_feature aes_feature_map[] = {
 	{ /* sentinel */ }
 };
 
-static int zynqmp_aes_aead_probe(struct platform_device *pdev)
+static int xilinx_aes_aead_probe(struct platform_device *pdev)
 {
 	struct xilinx_aead_alg *aead_algs;
 	struct device *dev = &pdev->dev;
@@ -548,7 +546,7 @@ static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 	return err;
 }
 
-static void zynqmp_aes_aead_remove(struct platform_device *pdev)
+static void xilinx_aes_aead_remove(struct platform_device *pdev)
 {
 	aead_dev = platform_get_drvdata(pdev);
 	crypto_engine_exit(aead_dev->engine);
@@ -558,9 +556,9 @@ static void zynqmp_aes_aead_remove(struct platform_device *pdev)
 	 aead_dev = NULL;
 }
 
-static struct platform_driver zynqmp_aes_driver = {
-	.probe	= zynqmp_aes_aead_probe,
-	.remove = zynqmp_aes_aead_remove,
+static struct platform_driver xilinx_aes_driver = {
+	.probe	= xilinx_aes_aead_probe,
+	.remove = xilinx_aes_aead_remove,
 	.driver = {
 		.name		= "zynqmp-aes",
 	},
@@ -572,15 +570,15 @@ static int __init aes_driver_init(void)
 {
 	int ret;
 
-	ret = platform_driver_register(&zynqmp_aes_driver);
+	ret = platform_driver_register(&xilinx_aes_driver);
 	if (ret)
 		return ret;
 
-	platform_dev = platform_device_register_simple(zynqmp_aes_driver.driver.name,
+	platform_dev = platform_device_register_simple(xilinx_aes_driver.driver.name,
 						       0, NULL, 0);
 	if (IS_ERR(platform_dev)) {
 		ret = PTR_ERR(platform_dev);
-		platform_driver_unregister(&zynqmp_aes_driver);
+		platform_driver_unregister(&xilinx_aes_driver);
 	}
 
 	return ret;
@@ -589,7 +587,7 @@ static int __init aes_driver_init(void)
 static void __exit aes_driver_exit(void)
 {
 	platform_device_unregister(platform_dev);
-	platform_driver_unregister(&zynqmp_aes_driver);
+	platform_driver_unregister(&xilinx_aes_driver);
 }
 
 module_init(aes_driver_init);
-- 
2.49.1

