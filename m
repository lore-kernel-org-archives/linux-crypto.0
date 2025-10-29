Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012036.outbound.protection.outlook.com [40.93.195.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369F3327798;
	Wed, 29 Oct 2025 10:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733403; cv=fail; b=PGYSVcCVCdqJwbMKpxWVSLlndeho2/RcNXk2+O9jk6hJ9fQkXYwoF+eSI1Q8OK7xOGFEV6UZqCtgD87pdJpYzsm5W9kK9efKSfJViKS5i5F0NWuq6Ughb1Uf27aNaEwhe/yugc9K8zPL30RqHnZyf+AoHfmxM6WBpi1Mc8ED1Po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733403; c=relaxed/simple;
	bh=ZbvVrpwjk+hSWvMY/AEv781KZ2CJKQq7J4I/KgNFck8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r9fRnj3/HHHYaGiRC1Nu8ovA2lphKbp8tTXA4GvrMO/AsCS93ZtXWKY1htfqt8YEIvF5MsdcZiVuFI5toxjDim2wvIsMX/2i0PQO0HaF+ZmeobwCQR9geuUqaNtolaseWneM/AgG6pB8oItZDC8fxIxR3t5qLt70pDXSk9VXJcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kwDawFVs; arc=fail smtp.client-ip=40.93.195.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kwDawFVs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uPjZHee8u0JeHRpXaQWgRIIvNV3O+s8m+g0FdfgzKlYGBZ51YdDSZJrafecV/Aws5DTetvilX3QOuytkTF54ebPRZpto9E056qXFKo4sGoVV6GRN7m/I3enNngr0zzA3itaClhr0d0JJMefBwMQsGvavltKZqwi7FQeUFE5cnZiMaMv9EtfFBSEm6hPeIOdGVujQGh5xj520pcZnII4mUC7+f5CR70keHLaCt7BUyL7VuiFYR/61u/ZLmjZhLpbXOBZ3xV8tSlb00evhyu6YLehTikrqifyI+tBGwAvPqVJR3HGoQXNLPaQR77YkLtc/MSNzpYZIq6LeiChNNN5g/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3hga55nkvdeXIykkEXTRGYYXKct0Ac+N/E5IvQS8hc=;
 b=AOTQWCYg3UYCdSOdi9QRW2rPqQ5r5gKtD/FBU70SsCV8XsI2Ld2cBChfn+aTRFJtQZqDeoU9tfonRmYbBsS4+X1QrqU9eWyXfMdHOW3jxM5+3P2Mmn+bCUr4+z0KPQr8CPKonuWBQAMr+fnFUestoh+RD17L+KlSqi3tWz/efZlsVG4q4nrLM/OXQVxC6WAkngu1Gkt4XK1hhS2Ctt4jlFWBftqxY2K9M3DBtfBbHqSnT/NfZH2iaCyW33OnMp3A7ymYba7DbkNVZwjMuyUx+x1vmj5ZJwjYT3DXckm4WskXbzXhgOd6jeV+3AJsqANzJi4UvmRS/z5/NljdLOSoew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3hga55nkvdeXIykkEXTRGYYXKct0Ac+N/E5IvQS8hc=;
 b=kwDawFVs48G0/Ik06hIP1kiNXosd8DHse8xZXRabdIJMcyIf2MpQF6/WtuoWCLmllNSEMHfBOP1i70cNHMvE+7jSkL1wdltsYc4F9BoMjI7JOwTToDaeGicT/w4WvD3Up5H3k/8zDRa4bI6GGrJuYZvSayr82/eSKJyNgbINHU8=
Received: from BL1PR13CA0068.namprd13.prod.outlook.com (2603:10b6:208:2b8::13)
 by SJ5PPF7B9E98CB6.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::99a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Wed, 29 Oct
 2025 10:23:12 +0000
Received: from BL6PEPF00022574.namprd02.prod.outlook.com
 (2603:10b6:208:2b8:cafe::28) by BL1PR13CA0068.outlook.office365.com
 (2603:10b6:208:2b8::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.13 via Frontend Transport; Wed,
 29 Oct 2025 10:23:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF00022574.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 10:23:11 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:56 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 29 Oct
 2025 05:22:55 -0500
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Oct 2025 03:22:53 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 12/15] crypto: xilinx: Replace zynqmp prefix with xilinx
Date: Wed, 29 Oct 2025 15:51:55 +0530
Message-ID: <20251029102158.3190743-13-h.jain@amd.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251029102158.3190743-1-h.jain@amd.com>
References: <20251029102158.3190743-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB04.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022574:EE_|SJ5PPF7B9E98CB6:EE_
X-MS-Office365-Filtering-Correlation-Id: 110e4f4f-73b5-4c76-e128-08de16d52997
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H+c1JZvPPJ74izd1ceFmzslW0PdRwEME3dywfva2kzU4MKBs3R+2RTi0y6n7?=
 =?us-ascii?Q?qYv3RR3FVCdy9FRk111J7vtFJ30pI2QzMdsttqpDcNa0y2ahdP1I0WQYyLWE?=
 =?us-ascii?Q?IiE70cVTs8tZlKt21JlgdG9h1HnEiYssPkMP3WyY7IH4rmIL4S2knAKCVMCY?=
 =?us-ascii?Q?ndTu3kNINWTjE3x5WCcqZ0kzJ4qttdmkwKhuGJ7w8GbpgLEtnJAxI+52JO67?=
 =?us-ascii?Q?8VB+etxL6a0Z7r5gB8WBIRCPwioRi++wll4UHUsZ3QPE8AslLZqpEBP38Anr?=
 =?us-ascii?Q?I+3/MFDfHkvXj+kbSPPeWyAfmQAEHAqCrVPHNN5tYlh2BCAkHaMgepYVUzuU?=
 =?us-ascii?Q?j0qt+QXyS78sK3l7tPCQ63/mL4GoIgBklBKFObn48xBwZf171YlHo2kVu8ug?=
 =?us-ascii?Q?UV948AuMuZwVrrBTyr2ldotjvU/MHIUKq1WfFcQMxdGNS1v9XxbRPVgj6cbF?=
 =?us-ascii?Q?TBPXo5YhxESDPVFl+fZC5/mTuqR+P7V1/ifK4DiX+wfdf9iydoyE8+Ze1cgP?=
 =?us-ascii?Q?fJE+0b4uvxLpr8tcUXkAsjZtmxHIw6yHRCbRVd5nOx0xG8MxsInHhBaS6+86?=
 =?us-ascii?Q?UOC++9ggE5B07ldxrLGODLucrtf5tg5ay704vGKDmubT510qX9RNrAe620Qe?=
 =?us-ascii?Q?uc48gj7oUF4qPL7Fb56TOJj7uKg1jpG0lcWdLz5MUCa+S2WqP8oC5C6xfl5Z?=
 =?us-ascii?Q?x+0ebiiIX1jvLXXj88QG54H0zOSMOjgrCra6VuXj2T0qjf2PGp6Sr20AeaYW?=
 =?us-ascii?Q?/+wOFghSv+s9BncxGOALf54dR2FyeUcFNKFEfTd6idclsYoe516SUkEFFUUa?=
 =?us-ascii?Q?mvk1N6EIPDMViXJg3RgtC7g58fI2uzaEc0Mqs3vXnP/qCU8QjRD3PjCOuPBj?=
 =?us-ascii?Q?mWstwMXVmYseSUuwq9DfZkPzvr1Ww6sfQxmMuU/VUnvqfWzNM8meVBHS5G4b?=
 =?us-ascii?Q?xaNvk/iC+Bhe7qIuOXIZjXmC1Kwi11UzmnFTMP+IHZ1RHUfvPpYry0pZU43V?=
 =?us-ascii?Q?jg61jQXmzsMi3vJnWQS4rYwg85lCH8N8qi5Sxw4GMgmtGsEKvgSWrLYykNeA?=
 =?us-ascii?Q?uDKRSFZHIMAKUnHxeA9mAcZ4eqN3DxHELVOcNvFS/y3nt4jAyqaNneCusF6f?=
 =?us-ascii?Q?FSNvJk/ae3cWNb5/9bdjig0o55vC/oDyD4H5VH4GQZe/H3qB8hRwyeCqesLI?=
 =?us-ascii?Q?oH5IrSLGQiKFdSYvgNytbHZTv6DE/LNF1aYHSXsx5UahZPU18UiXIhXvwVhD?=
 =?us-ascii?Q?JBxtAQP7B10SWvmYMcGZJMJQXKqL6SlYi23vQZNYUIUb9iiKGQmF0n64nsuT?=
 =?us-ascii?Q?6fS52toc+2Mx/ypHET5vTzXCI0G1CAoIHiREigav1y+60VrdKveQVXAub5NG?=
 =?us-ascii?Q?x36o1BUg1lFGdwUnza9bNazQ+HP/DHZWpI+DZbLJN4I9Nioax68rsSTicSfv?=
 =?us-ascii?Q?ccqvBfOTNyOkAwsp0d0tp4VKKl8UkWMQq3+6aDxAz26hKqo/GB3yhgZBGTV1?=
 =?us-ascii?Q?uc5WVKxYRwJ4RGKGpAB0v5uKbtN+X/Ws3d46xMgRLtLuM1IDXmec9/J0WTh8?=
 =?us-ascii?Q?m3ogyVpbT6aSvkYZ/GEeN101Ty9qlie3n+i0qCtO?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 10:23:11.4419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 110e4f4f-73b5-4c76-e128-08de16d52997
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022574.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF7B9E98CB6

Replace zynqmp with xilinx to have more generic name.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 130 ++++++++++++-------------
 1 file changed, 64 insertions(+), 66 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index e3e7aef87571..b0ebb4971608 100644
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
@@ -42,7 +40,7 @@ enum zynqmp_aead_keysrc {
 	ZYNQMP_AES_PUF_KEY
 };
 
-struct zynqmp_aead_drv_ctx {
+struct xilinx_aead_drv_ctx {
 	struct aead_engine_alg aead;
 	struct device *dev;
 	struct crypto_engine *engine;
@@ -63,7 +61,7 @@ struct zynqmp_aead_hw_req {
 	u64 keysrc;
 };
 
-struct zynqmp_aead_tfm_ctx {
+struct xilinx_aead_tfm_ctx {
 	struct device *dev;
 	dma_addr_t key_dma_addr;
 	u8 *key;
@@ -74,13 +72,13 @@ struct zynqmp_aead_tfm_ctx {
 };
 
 struct zynqmp_aead_req_ctx {
-	enum zynqmp_aead_op op;
+	enum xilinx_aead_op op;
 };
 
 static int zynqmp_aes_aead_cipher(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
 	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 	dma_addr_t dma_addr_data, dma_addr_hw_req;
 	struct device *dev = tfm_ctx->dev;
@@ -92,7 +90,7 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	void *dmabuf;
 	char *kbuf;
 
-	dma_size = req->cryptlen + ZYNQMP_AES_AUTH_SIZE;
+	dma_size = req->cryptlen + XILINX_AES_AUTH_SIZE;
 	kbuf = kmalloc(dma_size, GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;
@@ -117,10 +115,10 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	hwreq->keysrc = tfm_ctx->keysrc;
 	hwreq->op = rq_ctx->op;
 
-	if (hwreq->op == ZYNQMP_AES_ENCRYPT)
+	if (hwreq->op == XILINX_AES_ENCRYPT)
 		hwreq->size = data_size;
 	else
-		hwreq->size = data_size - ZYNQMP_AES_AUTH_SIZE;
+		hwreq->size = data_size - XILINX_AES_AUTH_SIZE;
 
 	if (hwreq->keysrc == ZYNQMP_AES_KUP_KEY)
 		hwreq->key = tfm_ctx->key_dma_addr;
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
@@ -181,12 +179,12 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	return ret;
 }
 
-static int zynqmp_fallback_check(struct zynqmp_aead_tfm_ctx *tfm_ctx,
+static int zynqmp_fallback_check(struct xilinx_aead_tfm_ctx *tfm_ctx,
 				 struct aead_request *req)
 {
 	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 
-	if (tfm_ctx->authsize != ZYNQMP_AES_AUTH_SIZE && rq_ctx->op == ZYNQMP_AES_DECRYPT)
+	if (tfm_ctx->authsize != XILINX_AES_AUTH_SIZE && rq_ctx->op == XILINX_AES_DECRYPT)
 		return 1;
 
 	if (req->assoclen != 0 ||
@@ -199,14 +197,14 @@ static int zynqmp_fallback_check(struct zynqmp_aead_tfm_ctx *tfm_ctx,
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
@@ -224,7 +222,7 @@ static int zynqmp_aes_aead_setkey(struct crypto_aead *aead, const u8 *key,
 				  unsigned int keylen)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
 	struct xilinx_hwkey_info hwkey;
 	unsigned char keysrc;
 	int err;
@@ -244,11 +242,11 @@ static int zynqmp_aes_aead_setkey(struct crypto_aead *aead, const u8 *key,
 		return -EINVAL;
 	}
 
-	if (keylen == ZYNQMP_AES_KEY_SIZE && tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY) {
+	if (keylen == AES_KEYSIZE_256 && tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY) {
 		tfm_ctx->keylen = keylen;
 		memcpy(tfm_ctx->key, key, keylen);
 		dma_sync_single_for_device(tfm_ctx->dev, tfm_ctx->key_dma_addr,
-					   ZYNQMP_AES_KEY_SIZE,
+					   AES_KEYSIZE_256,
 					   DMA_TO_DEVICE);
 	} else if (tfm_ctx->keysrc != ZYNQMP_AES_KUP_KEY) {
 		return -EINVAL;
@@ -265,12 +263,12 @@ static int zynqmp_aes_aead_setkey(struct crypto_aead *aead, const u8 *key,
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
 	return crypto_aead_setauthsize(tfm_ctx->fbk_cipher, authsize);
@@ -281,17 +279,17 @@ static int zynqmp_aes_aead_encrypt(struct aead_request *req)
 	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 	struct aead_request *subreq = aead_request_ctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
 	struct aead_alg *alg = crypto_aead_alg(aead);
-	struct zynqmp_aead_drv_ctx *drv_ctx;
+	struct xilinx_aead_drv_ctx *drv_ctx;
 	int err;
 
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
+	drv_ctx = container_of(alg, struct xilinx_aead_drv_ctx, aead.base);
 	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY &&
 	    tfm_ctx->keylen == sizeof(struct xilinx_hwkey_info))
 		return -EINVAL;
 
-	rq_ctx->op = ZYNQMP_AES_ENCRYPT;
+	rq_ctx->op = XILINX_AES_ENCRYPT;
 	err = zynqmp_fallback_check(tfm_ctx, req);
 	if (err && tfm_ctx->keysrc != ZYNQMP_AES_KUP_KEY)
 		return -EOPNOTSUPP;
@@ -316,13 +314,13 @@ static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 	struct aead_request *subreq = aead_request_ctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
 	struct aead_alg *alg = crypto_aead_alg(aead);
-	struct zynqmp_aead_drv_ctx *drv_ctx;
+	struct xilinx_aead_drv_ctx *drv_ctx;
 	int err;
 
-	rq_ctx->op = ZYNQMP_AES_DECRYPT;
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
+	rq_ctx->op = XILINX_AES_DECRYPT;
+	drv_ctx = container_of(alg, struct xilinx_aead_drv_ctx, aead.base);
 	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY &&
 	    tfm_ctx->keylen == sizeof(struct xilinx_hwkey_info))
 		return -EINVAL;
@@ -344,15 +342,15 @@ static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
 }
 
-static int zynqmp_aes_aead_init(struct crypto_aead *aead)
+static int xilinx_aes_aead_init(struct crypto_aead *aead)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx =
-		(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
-	struct zynqmp_aead_drv_ctx *drv_ctx;
+	struct xilinx_aead_tfm_ctx *tfm_ctx =
+		(struct xilinx_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
+	struct xilinx_aead_drv_ctx *drv_ctx;
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
+	drv_ctx = container_of(alg, struct xilinx_aead_drv_ctx, aead.base);
 	tfm_ctx->dev = drv_ctx->dev;
 	tfm_ctx->keylen = 0;
 	tfm_ctx->keysrc = ZYNQMP_AES_KUP_KEY;
@@ -366,13 +364,13 @@ static int zynqmp_aes_aead_init(struct crypto_aead *aead)
 		       __func__, drv_ctx->aead.base.base.cra_name);
 		return PTR_ERR(tfm_ctx->fbk_cipher);
 	}
-	tfm_ctx->key = kmalloc(ZYNQMP_AES_KEY_SIZE, GFP_KERNEL);
+	tfm_ctx->key = kmalloc(AES_KEYSIZE_256, GFP_KERNEL);
 	if (!tfm_ctx->key) {
 		crypto_free_aead(tfm_ctx->fbk_cipher);
 		return -ENOMEM;
 	}
 	tfm_ctx->key_dma_addr = dma_map_single(tfm_ctx->dev, tfm_ctx->key,
-					       ZYNQMP_AES_KEY_SIZE,
+					       AES_KEYSIZE_256,
 					       DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(tfm_ctx->dev, tfm_ctx->key_dma_addr))) {
 		kfree(tfm_ctx->key);
@@ -387,31 +385,31 @@ static int zynqmp_aes_aead_init(struct crypto_aead *aead)
 	return 0;
 }
 
-static void zynqmp_aes_aead_exit(struct crypto_aead *aead)
+static void xilinx_aes_aead_exit(struct crypto_aead *aead)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx =
-			(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
+	struct xilinx_aead_tfm_ctx *tfm_ctx =
+			(struct xilinx_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
 
-	dma_unmap_single(tfm_ctx->dev, tfm_ctx->key_dma_addr, ZYNQMP_AES_KEY_SIZE, DMA_TO_DEVICE);
+	dma_unmap_single(tfm_ctx->dev, tfm_ctx->key_dma_addr, AES_KEYSIZE_256, DMA_TO_DEVICE);
 	kfree(tfm_ctx->key);
 	if (tfm_ctx->fbk_cipher) {
 		crypto_free_aead(tfm_ctx->fbk_cipher);
 		tfm_ctx->fbk_cipher = NULL;
 	}
-	memzero_explicit(tfm_ctx, sizeof(struct zynqmp_aead_tfm_ctx));
+	memzero_explicit(tfm_ctx, sizeof(struct xilinx_aead_tfm_ctx));
 }
 
-static struct zynqmp_aead_drv_ctx zynqmp_aes_drv_ctx = {
+static struct xilinx_aead_drv_ctx zynqmp_aes_drv_ctx = {
 	.aead.base = {
 		.setkey		= zynqmp_aes_aead_setkey,
-		.setauthsize	= zynqmp_aes_aead_setauthsize,
+		.setauthsize	= xilinx_aes_aead_setauthsize,
 		.encrypt	= zynqmp_aes_aead_encrypt,
 		.decrypt	= zynqmp_aes_aead_decrypt,
-		.init		= zynqmp_aes_aead_init,
-		.exit		= zynqmp_aes_aead_exit,
+		.init		= xilinx_aes_aead_init,
+		.exit		= xilinx_aes_aead_exit,
 		.ivsize		= GCM_AES_IV_SIZE,
-		.maxauthsize	= ZYNQMP_AES_AUTH_SIZE,
+		.maxauthsize	= XILINX_AES_AUTH_SIZE,
 		.base = {
 		.cra_name		= "gcm(aes)",
 		.cra_driver_name	= "xilinx-zynqmp-aes-gcm",
@@ -421,13 +419,13 @@ static struct zynqmp_aead_drv_ctx zynqmp_aes_drv_ctx = {
 					  CRYPTO_ALG_ALLOCATES_MEMORY |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY |
 					  CRYPTO_ALG_NEED_FALLBACK,
-		.cra_blocksize		= ZYNQMP_AES_BLK_SIZE,
-		.cra_ctxsize		= sizeof(struct zynqmp_aead_tfm_ctx),
+		.cra_blocksize		= XILINX_AES_BLK_SIZE,
+		.cra_ctxsize		= sizeof(struct xilinx_aead_tfm_ctx),
 		.cra_module		= THIS_MODULE,
 		}
 	},
 	.aead.op = {
-		.do_one_request = zynqmp_handle_aes_req,
+		.do_one_request = xilinx_handle_aes_req,
 	},
 };
 
@@ -440,9 +438,9 @@ static struct xlnx_feature aes_feature_map[] = {
 	{ /* sentinel */ }
 };
 
-static int zynqmp_aes_aead_probe(struct platform_device *pdev)
+static int xilinx_aes_aead_probe(struct platform_device *pdev)
 {
-	struct zynqmp_aead_drv_ctx *aes_drv_ctx;
+	struct xilinx_aead_drv_ctx *aes_drv_ctx;
 	struct device *dev = &pdev->dev;
 	int err;
 
@@ -493,18 +491,18 @@ static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 	return err;
 }
 
-static void zynqmp_aes_aead_remove(struct platform_device *pdev)
+static void xilinx_aes_aead_remove(struct platform_device *pdev)
 {
-	struct zynqmp_aead_drv_ctx *aes_drv_ctx;
+	struct xilinx_aead_drv_ctx *aes_drv_ctx;
 
 	aes_drv_ctx = platform_get_drvdata(pdev);
 	crypto_engine_exit(aes_drv_ctx->engine);
 	crypto_engine_unregister_aead(&aes_drv_ctx->aead);
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
@@ -516,15 +514,15 @@ static int __init aes_driver_init(void)
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
@@ -533,7 +531,7 @@ static int __init aes_driver_init(void)
 static void __exit aes_driver_exit(void)
 {
 	platform_device_unregister(platform_dev);
-	platform_driver_unregister(&zynqmp_aes_driver);
+	platform_driver_unregister(&xilinx_aes_driver);
 }
 
 module_init(aes_driver_init);
-- 
2.49.1

