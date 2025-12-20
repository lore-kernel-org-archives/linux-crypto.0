Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011009.outbound.protection.outlook.com [52.101.52.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219982D12E7;
	Sat, 20 Dec 2025 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766246404; cv=fail; b=Rckc3ANv9JQTG2e0lT9g2K2HDNk/wA0t5w1GYZ/IISxBfPr+8H73AO1uFSXGhgb5h5yUc5ogPicZ4VgwMPIizYGzXPXHq/02MK1YJso0o4w57F3rvih699q9l4LbpX/YAq5J15O9wSZV0aeTdz44hVo5wPVEoubcZH/kJp6TEPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766246404; c=relaxed/simple;
	bh=J+I/zWo1jb/kyhnKOfPZbfezuxLvEpHKtWJ/she3T8s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ub+vK07FCRs+s47sZoGSndS6r52YxV3x55ReDTd3TpP6ZUycEHfdn2B/3icwZa10lJHY8vWi8/Xr2xJKyrQQI1BEi8Sy35yeEar1Ho0qi8tMIiYNpgXN45WXVSLjWaC1f2zvMA9Z00XfkEG6ItswE1BdIUni1fWexe0EVraiehs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KCpU8F0q; arc=fail smtp.client-ip=52.101.52.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KCpU8F0q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fmrrfDsS2uj5+nRFqn8IuFx8Ast4pf7KFq9/AjlZ8rEvrsNDD2+xjFOyGbuF2JTUSf/vXcbMiy00s6fAn42tiH7+MZQHYx+ZgzzUMtOvflEhUpR+kFTX5aQ33DSVRmnyNQNaMXp1YTkrd2v3zs5GzDjzyft+sVPDEoqhH0tVVn+J++Z+X+j5DOA/abcEQekJdZ5zsj8FkKMUTF6TJDGIiL+3QjZX9Cc/4bOIZwE0c8vwMw9pbijSgxolnQyu0qUfBtmPGhYCrvLitpW+/7pG8FJDLyhcgE4G+NBLIVHFtau5hU8XvnnypIS5rvOFd6UfXRbM/kp/vGGtQoZ/J3PG9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fznMF4q7MfTMFKdLBrdCQ/BI45CmfICzQCqPSksg5YA=;
 b=yWa3qjtlfxzh75HBJyjNHFuMCN9XAb5EMSjbBWYkUbRdVyCpsiOgXUpwlXonb4iaN9tN6YTpi+qFth4Jsg/KuB4MKtmbQPsY6VUB0IPtcvtix0Doh1GRAf2ooYPpcZ61vkudpjzW1bDz2jXO8/J/fJgBXlICSOn8DAos1uJFa+32IY0NY4be/PbIlMuM6aZJ23l1ptuJOoVjt9tmdRyYbC9RM2NDYxifvZszTslmhldP2HXQQ1InQcJyUZS4dgWNSI4lxS3teqUXNqjhX9PBMMXr4XMnOfvEMeKxlSJb4rjXD7IVDWpS5hZ85R/LaMRx2p+u8DkLbVNgcF0zRbhE+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fznMF4q7MfTMFKdLBrdCQ/BI45CmfICzQCqPSksg5YA=;
 b=KCpU8F0qkLgBH/GhpJl2DK5QvxlnkSC1e+jOL6lh4SfOwKn99qhnmFDZf0JDJ6blkw/hbC6UeGbgeMknbNm2I3eKZjfDzRLSfatzWDIpdidE7akFX6ADrDqssS1+szYuvkK3yD1FeVaHga9A6Rs62DMABotoUTzjxkLq2tSheDg=
Received: from PH5P220CA0002.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:34a::17)
 by SN7PR12MB6816.namprd12.prod.outlook.com (2603:10b6:806:264::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Sat, 20 Dec
 2025 15:59:58 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2603:10b6:510:34a:cafe::12) by PH5P220CA0002.outlook.office365.com
 (2603:10b6:510:34a::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.10 via Frontend Transport; Sat,
 20 Dec 2025 16:00:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Sat, 20 Dec 2025 15:59:57 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 20 Dec
 2025 09:59:57 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sat, 20 Dec 2025 07:59:54 -0800
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 11/14] crypto: zynqmp-aes-gcm: Change coherent DMA to streaming DMA API
Date: Sat, 20 Dec 2025 21:29:02 +0530
Message-ID: <20251220155905.346790-12-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|SN7PR12MB6816:EE_
X-MS-Office365-Filtering-Correlation-Id: a29542a6-2101-44d3-c19e-08de3fe0d2fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1/ExgNb/hwU7xMVCWE+9tfv5BLTUjp34+aX06Ao5s+j0LeP3Lf+n4ThjwDMi?=
 =?us-ascii?Q?l2Lw8onf3EDjAsLr+EM8KZTJz2z6dy7urhWgNq5PmE9DeuBHF+GeI1GaZJQt?=
 =?us-ascii?Q?QIlq5tsqEAJoklDKIF4PqzX95YiH581ifZjOhgYgUK28qZPnm9Pu6IkQ9JAV?=
 =?us-ascii?Q?OOTKLxfmPview7LqxU57get3VVVI/kcnIlDHvR2dmVZ4MHTfbVrkq2TWbrtm?=
 =?us-ascii?Q?M1z/KpcspL8vFRdM9JDGnClk6i2WsbLoybjHlZu63YY1bEuhLo6yKb9rodH9?=
 =?us-ascii?Q?gff1tT8fZCJiRH+AEPomQXWFd6EaApFAy/qt4P5Vc5I4YlFDAbM5xEW+PCVK?=
 =?us-ascii?Q?fHZtvXJVKsJNXtG1AgS2QObvvrLB28pJbHVt0NCp8xM68X8olN87ha0XdDHx?=
 =?us-ascii?Q?LeWnZ/lJ0OTOW6HUgDv6c9TCHOzQomNLH4LFwf7+d1anxoUh1LbyAUWQEMR5?=
 =?us-ascii?Q?tgcsoA4fYW3YWJCgaAsTNQMm+koiH5MAw+z1sZksC8WBgjX3tnWuWa9YZuI2?=
 =?us-ascii?Q?ceA6KywtlCPJLMcu0T8xWA6p20K3CHIkwIcu3KUVVK7U6Dvk/6Isqx0T4zop?=
 =?us-ascii?Q?IGYwUQ0dG19EmwHaDcj/4RV0rnxQNQ1xi8uke9QDfbaKLwozDH+685qqq2g0?=
 =?us-ascii?Q?R9Twdf0SIpX+jAGzUwj+Nfe7omEurZxxFp14QNEStveuy4B/FEXeBrEYmRLz?=
 =?us-ascii?Q?yLHN8adq7MTEbnxMQ8SsGTfjEFm7nSO/PRumaIpp0uCxjNNMjOjaFKljfOZX?=
 =?us-ascii?Q?JMuzkkEc7+qPux8x1T3/uOgtfYqOzKCos1kzfjiyD55iVn3XI2GN9j/z+SQF?=
 =?us-ascii?Q?cbwdZJj8vagvregNwy6zQdh+9Uk2G0llP90hEKDFKK3wELI3oZ1LK4ssD8Ev?=
 =?us-ascii?Q?UbF609IgZ5YrbmQDLlzgWKbWe3RYD34LVLwHrPiL8fXNBPxPt3pOLl4XLEqy?=
 =?us-ascii?Q?vhCposoJ9giIGYSTmEEJ7/OcOSE1XgklAo2yBFTIXTuBLNADJv+KRXXUCwv2?=
 =?us-ascii?Q?2xurCEsxeiFL8mmu/VU46Z3zaqFm6GdbE892xWhTeLJ7nqkcT1tiCpuIyBdS?=
 =?us-ascii?Q?azb3uE3VioktIKMEi4LlTvbxlC/ZZCKHLDSyDmV4CM5QGoa/KpMMaFvUal1x?=
 =?us-ascii?Q?ZWoCjLYg2M9uvFxBIg+datccIovoKzYHBDu/tNOBKY/Q4kTZQ5/lBE2Ktb1x?=
 =?us-ascii?Q?eF2X+S//l/kX9cxD5r0i0Umt1CaFIU2BF7sq9zC6/U11Ua9jgKl+RKFKnbSZ?=
 =?us-ascii?Q?0PjAxHMw7TWEes1GNnmkIUfxxNXKp4v5OHaRNea2MUDqFQwRrmQrXEWk6zTi?=
 =?us-ascii?Q?4QUe2vbSIv4MR+iPkU29vqLYKtCp1fzXqORfT3y558biu9QZL8Ay/7MY+H3D?=
 =?us-ascii?Q?aMQs7XLCkSTilQcB9mUr/qSusa78uSFt92mnNR7r5+k/11qMLB+rX2Umbo3M?=
 =?us-ascii?Q?zilQueudU/JP3Jkjw/K6gbAkqvq+mZmbsN9XtdMeCZSi2HZ02gYar21d+D8l?=
 =?us-ascii?Q?W0G4h5G3ePdYghNgRG7G2JZmYM5PJTVHTDOP3YUYxDZSyrwHy5DcQ6MzejeR?=
 =?us-ascii?Q?ZEusG2gzEXwAcBtuFsO8enB1aGgaVZRdJGZTS1S8?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2025 15:59:57.7264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a29542a6-2101-44d3-c19e-08de3fe0d2fb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6816

Update the driver to use streaming DMA API.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 94 ++++++++++++++++----------
 1 file changed, 58 insertions(+), 36 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 34dbb8b7d3a8..c2563c6837e4 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -69,8 +69,8 @@ struct zynqmp_aead_hw_req {
 
 struct xilinx_aead_tfm_ctx {
 	struct device *dev;
-	u8 key[AES_KEYSIZE_256];
-	u8 *iv;
+	dma_addr_t key_dma_addr;
+	u8 *key;
 	u32 keylen;
 	u32 authsize;
 	u8 keysrc;
@@ -88,39 +88,38 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
 	struct xilinx_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	dma_addr_t dma_addr_data, dma_addr_hw_req;
 	struct device *dev = tfm_ctx->dev;
 	struct zynqmp_aead_hw_req *hwreq;
-	dma_addr_t dma_addr_data, dma_addr_hw_req;
 	unsigned int data_size;
 	unsigned int status;
 	int ret;
 	size_t dma_size;
+	void *dmabuf;
 	char *kbuf;
 
-	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY)
-		dma_size = req->cryptlen + AES_KEYSIZE_256
-			   + GCM_AES_IV_SIZE;
-	else
-		dma_size = req->cryptlen + GCM_AES_IV_SIZE;
-
-	kbuf = dma_alloc_coherent(dev, dma_size, &dma_addr_data, GFP_KERNEL);
+	dma_size = req->cryptlen + XILINX_AES_AUTH_SIZE;
+	kbuf = kmalloc(dma_size, GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;
 
-	hwreq = dma_alloc_coherent(dev, sizeof(struct zynqmp_aead_hw_req),
-				   &dma_addr_hw_req, GFP_KERNEL);
-	if (!hwreq) {
-		dma_free_coherent(dev, dma_size, kbuf, dma_addr_data);
+	dmabuf = kmalloc(sizeof(*hwreq) + GCM_AES_IV_SIZE, GFP_KERNEL);
+	if (!dmabuf) {
+		kfree(kbuf);
 		return -ENOMEM;
 	}
-
+	hwreq = dmabuf;
 	data_size = req->cryptlen;
 	scatterwalk_map_and_copy(kbuf, req->src, 0, req->cryptlen, 0);
-	memcpy(kbuf + data_size, req->iv, GCM_AES_IV_SIZE);
+	memcpy(dmabuf + sizeof(struct zynqmp_aead_hw_req), req->iv, GCM_AES_IV_SIZE);
+	dma_addr_data = dma_map_single(dev, kbuf, dma_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(dev, dma_addr_data))) {
+		ret = -ENOMEM;
+		goto freemem;
+	}
 
 	hwreq->src = dma_addr_data;
 	hwreq->dst = dma_addr_data;
-	hwreq->iv = hwreq->src + data_size;
 	hwreq->keysrc = tfm_ctx->keysrc;
 	hwreq->op = rq_ctx->op;
 
@@ -129,17 +128,26 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	else
 		hwreq->size = data_size - XILINX_AES_AUTH_SIZE;
 
-	if (hwreq->keysrc == ZYNQMP_AES_KUP_KEY) {
-		memcpy(kbuf + data_size + GCM_AES_IV_SIZE,
-		       tfm_ctx->key, AES_KEYSIZE_256);
-
-		hwreq->key = hwreq->src + data_size + GCM_AES_IV_SIZE;
-	} else {
+	if (hwreq->keysrc == ZYNQMP_AES_KUP_KEY)
+		hwreq->key = tfm_ctx->key_dma_addr;
+	else
 		hwreq->key = 0;
-	}
 
+	dma_addr_hw_req = dma_map_single(dev, dmabuf, sizeof(struct zynqmp_aead_hw_req) +
+					 GCM_AES_IV_SIZE,
+					 DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, dma_addr_hw_req))) {
+		ret = -ENOMEM;
+		dma_unmap_single(dev, dma_addr_data, dma_size, DMA_BIDIRECTIONAL);
+		goto freemem;
+	}
+	hwreq->iv = dma_addr_hw_req + sizeof(struct zynqmp_aead_hw_req);
+	dma_sync_single_for_device(dev, dma_addr_hw_req, sizeof(struct zynqmp_aead_hw_req) +
+				   GCM_AES_IV_SIZE, DMA_TO_DEVICE);
 	ret = zynqmp_pm_aes_engine(dma_addr_hw_req, &status);
-
+	dma_unmap_single(dev, dma_addr_hw_req, sizeof(struct zynqmp_aead_hw_req) + GCM_AES_IV_SIZE,
+			 DMA_TO_DEVICE);
+	dma_unmap_single(dev, dma_addr_data, dma_size, DMA_BIDIRECTIONAL);
 	if (ret) {
 		dev_err(dev, "ERROR: AES PM API failed\n");
 	} else if (status) {
@@ -170,15 +178,11 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 		ret = 0;
 	}
 
-	if (kbuf) {
-		memzero_explicit(kbuf, dma_size);
-		dma_free_coherent(dev, dma_size, kbuf, dma_addr_data);
-	}
-	if (hwreq) {
-		memzero_explicit(hwreq, sizeof(struct zynqmp_aead_hw_req));
-		dma_free_coherent(dev, sizeof(struct zynqmp_aead_hw_req),
-				  hwreq, dma_addr_hw_req);
-	}
+freemem:
+	memzero_explicit(kbuf, dma_size);
+	kfree(kbuf);
+	memzero_explicit(dmabuf, sizeof(struct zynqmp_aead_hw_req) + GCM_AES_IV_SIZE);
+	kfree(dmabuf);
 
 	return ret;
 }
@@ -231,6 +235,9 @@ static int zynqmp_aes_aead_setkey(struct crypto_aead *aead, const u8 *key,
 
 	if (keylen == AES_KEYSIZE_256) {
 		memcpy(tfm_ctx->key, key, keylen);
+		dma_sync_single_for_device(tfm_ctx->dev, tfm_ctx->key_dma_addr,
+					   AES_KEYSIZE_256,
+					   DMA_TO_DEVICE);
 	}
 
 	tfm_ctx->fbk_cipher->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
@@ -355,7 +362,7 @@ static int xilinx_paes_aead_init(struct crypto_aead *aead)
 	drv_alg = container_of(alg, struct xilinx_aead_alg, aead.base);
 	tfm_ctx->dev = drv_alg->aead_dev->dev;
 	tfm_ctx->keylen = 0;
-
+	tfm_ctx->key = NULL;
 	tfm_ctx->fbk_cipher = NULL;
 	crypto_aead_set_reqsize(aead, sizeof(struct xilinx_aead_req_ctx));
 
@@ -383,7 +390,20 @@ static int xilinx_aes_aead_init(struct crypto_aead *aead)
 		       __func__, drv_ctx->aead.base.base.cra_name);
 		return PTR_ERR(tfm_ctx->fbk_cipher);
 	}
-
+	tfm_ctx->key = kmalloc(AES_KEYSIZE_256, GFP_KERNEL);
+	if (!tfm_ctx->key) {
+		crypto_free_aead(tfm_ctx->fbk_cipher);
+		return -ENOMEM;
+	}
+	tfm_ctx->key_dma_addr = dma_map_single(tfm_ctx->dev, tfm_ctx->key,
+					       AES_KEYSIZE_256,
+					       DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(tfm_ctx->dev, tfm_ctx->key_dma_addr))) {
+		kfree(tfm_ctx->key);
+		crypto_free_aead(tfm_ctx->fbk_cipher);
+		tfm_ctx->fbk_cipher = NULL;
+		return -ENOMEM;
+	}
 	crypto_aead_set_reqsize(aead,
 				max(sizeof(struct xilinx_aead_req_ctx),
 				    sizeof(struct aead_request) +
@@ -405,6 +425,8 @@ static void xilinx_aes_aead_exit(struct crypto_aead *aead)
 	struct xilinx_aead_tfm_ctx *tfm_ctx =
 			(struct xilinx_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
 
+	dma_unmap_single(tfm_ctx->dev, tfm_ctx->key_dma_addr, AES_KEYSIZE_256, DMA_TO_DEVICE);
+	kfree(tfm_ctx->key);
 	if (tfm_ctx->fbk_cipher) {
 		crypto_free_aead(tfm_ctx->fbk_cipher);
 		tfm_ctx->fbk_cipher = NULL;
-- 
2.49.1

