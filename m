Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012054.outbound.protection.outlook.com [52.101.53.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DED2D23AD;
	Sat, 20 Dec 2025 15:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766246400; cv=fail; b=AASQTQUc7wlnvYSVwYHvbYY6QHSEvolCtaF1Rcg98pRlxKaBp+BWphUd7q5u8qsQC2puHI7p6210btftCHC1jmg1VwIqBVRYeqgRM7RtzxFHQoHDCIAhgR+Z1OutaGAEyM24zKaMCTjGJ5Pc2RL5F6mBx9KVOURiHROz5Clt4qk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766246400; c=relaxed/simple;
	bh=Uk9GiBx8DhlPAjIGKYmeXjPOz0Fc3WnHSYmfkz1Ulqc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W+mWJn2/aBGwIaYN6JACmlDqKcmN8Gi6PSgpYnGdxH7bsmz7q1h72d1wQD9bAW9SNNqur/pcwIs31Ha2RWRkKc4ycNy2yHQR1Y+bkPSZyT80EKfhHuKqj5dfeJBFk826FajbZnI8ZWA/V6xkvpVg56qqrT1MBeup2IRSwcwjLGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GLDGYoX0; arc=fail smtp.client-ip=52.101.53.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GLDGYoX0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tZjHn4oSl0IAtGJrhL0c3eSevBS42umVh+cZw/fY5B+S4lVD8+PRCjqnp2zpLLB0OlbqQra/ejjxPDzYTIo6extFcpUJxg2q39mZJPZ+Q/tLzExljbUdbfnG6/LSV5YtlCSauukj/blSgqvdgwvWiZTbvjkM7CofVHrAsaD+AfbgNRxcIGkACghDGW+j70+lZ7ZzzTWFU3t7WmozSjFVd0zH3/mlXt+Its8QtVUUG/i55LnZ5bJ2i7jIi/SGgF0bkAfZd2+3nMya5wmWfR74aQeJ6L6xhIq/UFqsFlnalvzVEw8SGO6KnQjh51SqaYHvCZ40Ctd7zpB1QfQFtYV1rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iE4jZpNQAtizsWzQSdjQWoE4HQoHwPHeXFlXpsl+gvc=;
 b=LQxY8vxqMmi7AV4dPzdvfi6QArV1S65WGOgF7Iyc1jcR/ZbLynua/BGHot3DHTB/XTQ5lmnqJSYOu2ZCjyy3KiUFCx3+xZfsHTuuJcilLl6xZSy9NuspyCsJ0h5UtWSnlJy/gYfGvFHjBjJOM6D19J2k9NlBlryDfIFjJuLRMIh4zqFG+Fe0YWUdepwqW43vLG6MNSM5XIsTRcrHhu76OnOhMLQr/n7UuOV1FXuRmGIBeVuXVaYRSqEuy0dDSb9uEgn6NchJcEDTP9p/fOKiYJWTgj8DD1NTdpG2BoSHXMygUM7Mis48DcAU9rCL+xcyfm3rV4MNA07ZGJaImQ2KiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iE4jZpNQAtizsWzQSdjQWoE4HQoHwPHeXFlXpsl+gvc=;
 b=GLDGYoX0PVQ0K2WE3a0+RFBtNmu+3lNsucc5jUe6gZj85rRSa1ni74x/JpiyO961hA3HdXDv4CkGCT3s8uX6Jd7QC6TRzX/qN1Qo9oSKMjW+jcBtCpGA4bSOOpyPlfnfAhGJzbekfEGlO4AgZV4zGmF4rWF7sHRTuBKlUV35vSI=
Received: from SN7PR04CA0029.namprd04.prod.outlook.com (2603:10b6:806:f2::34)
 by CH2PR12MB4325.namprd12.prod.outlook.com (2603:10b6:610:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Sat, 20 Dec
 2025 15:59:51 +0000
Received: from SA2PEPF00003F68.namprd04.prod.outlook.com
 (2603:10b6:806:f2:cafe::57) by SN7PR04CA0029.outlook.office365.com
 (2603:10b6:806:f2::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Sat,
 20 Dec 2025 15:59:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003F68.mail.protection.outlook.com (10.167.248.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Sat, 20 Dec 2025 15:59:50 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Sat, 20 Dec
 2025 09:59:50 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sat, 20 Dec
 2025 09:59:49 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sat, 20 Dec 2025 07:59:46 -0800
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 09/14] crypto: zynqmp-aes-gcm: Register H/W key support with paes
Date: Sat, 20 Dec 2025 21:29:00 +0530
Message-ID: <20251220155905.346790-10-h.jain@amd.com>
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
Received-SPF: None (SATLEXMB03.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F68:EE_|CH2PR12MB4325:EE_
X-MS-Office365-Filtering-Correlation-Id: 67ac3b5a-ca12-4702-fa1f-08de3fe0ced1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZM4Qu4ncNg4E/dbXRqD9aXgMZ5kDCuxbpeDagFAv5WjEC/YVY8iwGMpIDQtT?=
 =?us-ascii?Q?4Vdga2WWuoAE9Faxeuz/V292D7IH3h2JrV29IiTA4YPuYrE0Ys3jQtwqU2i3?=
 =?us-ascii?Q?KFvc7ksqEstoKo4dddIkeZ//XIx+elXb+ALcOxHLrCTxCq0pHganScpDlZf/?=
 =?us-ascii?Q?2h/907xtJFcev+IvcXiExPNsEW71qiCJArwx3eGGB9dvTEj4t4p4u4HY3C00?=
 =?us-ascii?Q?61RK54a7Up9fv/DH5+sSrPW13V9MT1VrUyFaBSkXiCwz9jOEI+gjEnDHLKas?=
 =?us-ascii?Q?FsKuXrBQfvOQSLCH4/C5uKxcysePLXrH3SM694r9TaurlD7Clov944npZXkY?=
 =?us-ascii?Q?dxKED9XJl2rKdBfQuIUcIHxODE5lylF6MKvPANLZIGQdCcp6n6jsq1K0m5lQ?=
 =?us-ascii?Q?21Di76Ib5RI/Q+3kX4IxEu5S67bNkdznLdh5Y20i95kDvRmOKSUZ5Y4RkoFu?=
 =?us-ascii?Q?hmn1gcg/ZYiTwst3cQP/pQQ9FRh3a0Ey/lCWfZ8fYz7tq2PdbtZSvpOKoOFe?=
 =?us-ascii?Q?nGRGSS8u3jXDjHW6Ejv3Tt4GFeUvhCk2nZssSxuKEW4rM9Xn2B9w2p5LOhvf?=
 =?us-ascii?Q?ktQMc2wG+zrwIwS6pg9q+SSQhOHqObRIIBo5NGZTY00n4TeosCtxymYWjiG9?=
 =?us-ascii?Q?9HknDXRCWCjk4e0iagVWsYqLqLm5J3BPktrMnlZR834Da50I7ahIIDNZKTMX?=
 =?us-ascii?Q?0fija/imlqbH4MlV1STCPNLStq/lADfhPhyBtp2oQVNuNT8A39ofpWyLGIJY?=
 =?us-ascii?Q?2eo0fTxgkePJV0abM59C3y0F7Rh5RoxDwAVr2LTXEqFsAvC5yokJu/lXkyT1?=
 =?us-ascii?Q?4Pw54Ij5I3mG7sjreUlqeQgyph/paoKt5nsTTQ7qsu+BIUD79n+Om9bvJDvv?=
 =?us-ascii?Q?NSkaOokRyCK5gTNXJkTpdNYk1Zf7lzLyenlOeNXC9KnRkFCf83lW9N+TO2KH?=
 =?us-ascii?Q?2mww6lBkYry7FxtpjhGZllmXXi0pZ/TsoCUJiA6q24DoysrvbcsJgouB+Iyx?=
 =?us-ascii?Q?Mat1nKrj4579c573G3yjZQ878Sk29tMsQNbiWUI5wj2F74aRXzFd2ueFizKt?=
 =?us-ascii?Q?/mWZJanMexKnkVTnfYgDDtiUhLmcYYs7X5A95tn6iISrVSxygRa3JyN/iu10?=
 =?us-ascii?Q?brDGWE7nx3B7stF6gA2eQzMJuBGesJDJEAiJb/W2RUpjEZidm47HhGgB9/6F?=
 =?us-ascii?Q?ooVVc1U/ii/0dUxRwgKy4YrA60+NrFOe/F4NNEN3fNZYaCjsiL2P9HlmHkIt?=
 =?us-ascii?Q?oKMplQx+MemyE3TFLg+klbrOjf6y+ZrSqQAewNaK/m5BGRzUYeyWVLrq2oT7?=
 =?us-ascii?Q?5TY/88K3f9TtwE2ZRxnE4yuwZy8c1Yog2sc/U/EEN6Ux4QhFHxYzAZh679wk?=
 =?us-ascii?Q?Z00pLVGCXSV9qZCXyLdXs1wHTjg6TTsoEt+ui8Kex4afXnsapxmxwpyr9iJ3?=
 =?us-ascii?Q?OY52ycoLX19xH04906/Wzp90iYXLbWl78G/iR7xR/zFiYTZu3ZXuLeDUvg09?=
 =?us-ascii?Q?PrTqo0NV+6HOQ2kUVxEe17fU3jeMtLWcmBQFocPwx25U/byF59lAIoQ5VeHO?=
 =?us-ascii?Q?XTAyVdcpzDTwyy8zXwCPKGRpvNvqMteuL4WB9EIp?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2025 15:59:50.7589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67ac3b5a-ca12-4702-fa1f-08de3fe0ced1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F68.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4325

Register gcm(paes) for hardware supported keys.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 304 +++++++++++++++++--------
 1 file changed, 204 insertions(+), 100 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index b8574e144f48..179595b24f4f 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -22,14 +22,14 @@
 
 #define ZYNQMP_AES_KEY_SIZE		AES_KEYSIZE_256
 #define ZYNQMP_AES_AUTH_SIZE		16U
-#define ZYNQMP_KEY_SRC_SEL_KEY_LEN	1U
 #define ZYNQMP_AES_BLK_SIZE		1U
 #define ZYNQMP_AES_MIN_INPUT_BLK_SIZE	4U
 #define ZYNQMP_AES_WORD_LEN		4U
 
-#define ZYNQMP_AES_GCM_TAG_MISMATCH_ERR		0x01
-#define ZYNQMP_AES_WRONG_KEY_SRC_ERR		0x13
-#define ZYNQMP_AES_PUF_NOT_PROGRAMMED		0xE300
+#define ZYNQMP_AES_GCM_TAG_MISMATCH_ERR	0x01
+#define ZYNQMP_AES_WRONG_KEY_SRC_ERR	0x13
+#define ZYNQMP_AES_PUF_NOT_PROGRAMMED	0xE300
+#define XILINX_KEY_MAGIC		0x3EA0
 
 enum zynqmp_aead_op {
 	ZYNQMP_AES_DECRYPT = 0,
@@ -42,12 +42,23 @@ enum zynqmp_aead_keysrc {
 	ZYNQMP_AES_PUF_KEY
 };
 
-struct zynqmp_aead_drv_ctx {
-	struct aead_engine_alg aead;
+struct xilinx_aead_dev {
 	struct device *dev;
 	struct crypto_engine *engine;
+	struct xilinx_aead_alg *aead_algs;
+};
+
+struct xilinx_aead_alg {
+	struct xilinx_aead_dev *aead_dev;
+	struct aead_engine_alg aead;
+	u8 dma_bit_mask;
 };
 
+struct xilinx_hwkey_info {
+	u16 magic;
+	u16 type;
+} __packed;
+
 struct zynqmp_aead_hw_req {
 	u64 src;
 	u64 iv;
@@ -64,7 +75,7 @@ struct zynqmp_aead_tfm_ctx {
 	u8 *iv;
 	u32 keylen;
 	u32 authsize;
-	enum zynqmp_aead_keysrc keysrc;
+	u8 keysrc;
 	struct crypto_aead *fbk_cipher;
 };
 
@@ -72,6 +83,8 @@ struct zynqmp_aead_req_ctx {
 	enum zynqmp_aead_op op;
 };
 
+static struct xilinx_aead_dev *aead_dev;
+
 static int zynqmp_aes_aead_cipher(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
@@ -175,32 +188,29 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 static int zynqmp_fallback_check(struct zynqmp_aead_tfm_ctx *tfm_ctx,
 				 struct aead_request *req)
 {
-	int need_fallback = 0;
 	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 
 	if (tfm_ctx->authsize != ZYNQMP_AES_AUTH_SIZE && rq_ctx->op == ZYNQMP_AES_DECRYPT)
 		return 1;
 
-	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY &&
-	    tfm_ctx->keylen != ZYNQMP_AES_KEY_SIZE) {
-		need_fallback = 1;
-	}
 	if (req->assoclen != 0 ||
-	    req->cryptlen < ZYNQMP_AES_MIN_INPUT_BLK_SIZE) {
-		need_fallback = 1;
-	}
+	    req->cryptlen < ZYNQMP_AES_MIN_INPUT_BLK_SIZE)
+		return 1;
+	if (tfm_ctx->keylen == AES_KEYSIZE_128 ||
+	    tfm_ctx->keylen == AES_KEYSIZE_192)
+		return 1;
+
 	if ((req->cryptlen % ZYNQMP_AES_WORD_LEN) != 0)
-		need_fallback = 1;
+		return 1;
 
 	if (rq_ctx->op == ZYNQMP_AES_DECRYPT &&
-	    req->cryptlen <= ZYNQMP_AES_AUTH_SIZE) {
-		need_fallback = 1;
-	}
-	return need_fallback;
+	    req->cryptlen <= ZYNQMP_AES_AUTH_SIZE)
+		return 1;
+
+	return 0;
 }
 
-static int zynqmp_handle_aes_req(struct crypto_engine *engine,
-				 void *req)
+static int zynqmp_handle_aes_req(struct crypto_engine *engine, void *req)
 {
 	struct aead_request *areq =
 				container_of(req, struct aead_request, base);
@@ -218,32 +228,49 @@ static int zynqmp_aes_aead_setkey(struct crypto_aead *aead, const u8 *key,
 				  unsigned int keylen)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx =
-			(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
-	unsigned char keysrc;
+	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	int err;
 
-	if (keylen == ZYNQMP_KEY_SRC_SEL_KEY_LEN) {
-		keysrc = *key;
-		if (keysrc == ZYNQMP_AES_KUP_KEY ||
-		    keysrc == ZYNQMP_AES_DEV_KEY ||
-		    keysrc == ZYNQMP_AES_PUF_KEY) {
-			tfm_ctx->keysrc = (enum zynqmp_aead_keysrc)keysrc;
-		} else {
-			tfm_ctx->keylen = keylen;
-		}
-	} else {
-		tfm_ctx->keylen = keylen;
-		if (keylen == ZYNQMP_AES_KEY_SIZE) {
-			tfm_ctx->keysrc = ZYNQMP_AES_KUP_KEY;
-			memcpy(tfm_ctx->key, key, keylen);
-		}
+	if (keylen == ZYNQMP_AES_KEY_SIZE) {
+		memcpy(tfm_ctx->key, key, keylen);
 	}
 
 	tfm_ctx->fbk_cipher->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
 	tfm_ctx->fbk_cipher->base.crt_flags |= (aead->base.crt_flags &
-					CRYPTO_TFM_REQ_MASK);
+						CRYPTO_TFM_REQ_MASK);
 
-	return crypto_aead_setkey(tfm_ctx->fbk_cipher, key, keylen);
+	err = crypto_aead_setkey(tfm_ctx->fbk_cipher, key, keylen);
+	if (err)
+		goto err;
+	tfm_ctx->keylen = keylen;
+	tfm_ctx->keysrc = ZYNQMP_AES_KUP_KEY;
+err:
+	return err;
+}
+
+static int zynqmp_paes_aead_setkey(struct crypto_aead *aead, const u8 *key,
+				   unsigned int keylen)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	struct xilinx_hwkey_info hwkey;
+	unsigned char keysrc;
+	int err = -EINVAL;
+
+	if (keylen != sizeof(struct xilinx_hwkey_info))
+		return -EINVAL;
+	memcpy(&hwkey, key, sizeof(struct xilinx_hwkey_info));
+	if (hwkey.magic != XILINX_KEY_MAGIC)
+		return -EINVAL;
+	keysrc = hwkey.type;
+	if (keysrc == ZYNQMP_AES_DEV_KEY ||
+	    keysrc == ZYNQMP_AES_PUF_KEY) {
+		tfm_ctx->keysrc = keysrc;
+		tfm_ctx->keylen = sizeof(struct xilinx_hwkey_info);
+		err = 0;
+	}
+
+	return err;
 }
 
 static int zynqmp_aes_aead_setauthsize(struct crypto_aead *aead,
@@ -254,7 +281,7 @@ static int zynqmp_aes_aead_setauthsize(struct crypto_aead *aead,
 			(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
 
 	tfm_ctx->authsize = authsize;
-	return crypto_aead_setauthsize(tfm_ctx->fbk_cipher, authsize);
+	return tfm_ctx->fbk_cipher ? crypto_aead_setauthsize(tfm_ctx->fbk_cipher, authsize) : 0;
 }
 
 static int xilinx_aes_fallback_crypt(struct aead_request *req, bool encrypt)
@@ -278,11 +305,15 @@ static int zynqmp_aes_aead_encrypt(struct aead_request *req)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
 	struct aead_alg *alg = crypto_aead_alg(aead);
-	struct zynqmp_aead_drv_ctx *drv_ctx;
+	struct xilinx_aead_alg *drv_ctx;
 	int err;
 
+	drv_ctx = container_of(alg, struct xilinx_aead_alg, aead.base);
+	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY &&
+	    tfm_ctx->keylen == sizeof(struct xilinx_hwkey_info))
+		return -EINVAL;
+
 	rq_ctx->op = ZYNQMP_AES_ENCRYPT;
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
 	err = zynqmp_fallback_check(tfm_ctx, req);
 	if (err && tfm_ctx->keysrc != ZYNQMP_AES_KUP_KEY)
 		return -EOPNOTSUPP;
@@ -290,7 +321,7 @@ static int zynqmp_aes_aead_encrypt(struct aead_request *req)
 	if (err)
 		return xilinx_aes_fallback_crypt(req, true);
 
-	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
+	return crypto_transfer_aead_request_to_engine(drv_ctx->aead_dev->engine, req);
 }
 
 static int zynqmp_aes_aead_decrypt(struct aead_request *req)
@@ -299,18 +330,38 @@ static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
 	struct aead_alg *alg = crypto_aead_alg(aead);
-	struct zynqmp_aead_drv_ctx *drv_ctx;
+	struct xilinx_aead_alg *drv_ctx;
 	int err;
 
 	rq_ctx->op = ZYNQMP_AES_DECRYPT;
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
+	drv_ctx = container_of(alg, struct xilinx_aead_alg, aead.base);
+	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY &&
+	    tfm_ctx->keylen == sizeof(struct xilinx_hwkey_info))
+		return -EINVAL;
 	err = zynqmp_fallback_check(tfm_ctx, req);
 	if (err && tfm_ctx->keysrc != ZYNQMP_AES_KUP_KEY)
 		return -EOPNOTSUPP;
 	if (err)
 		return xilinx_aes_fallback_crypt(req, false);
 
-	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
+	return crypto_transfer_aead_request_to_engine(drv_ctx->aead_dev->engine, req);
+}
+
+static int xilinx_paes_aead_init(struct crypto_aead *aead)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	struct xilinx_aead_alg *drv_alg;
+	struct aead_alg *alg = crypto_aead_alg(aead);
+
+	drv_alg = container_of(alg, struct xilinx_aead_alg, aead.base);
+	tfm_ctx->dev = drv_alg->aead_dev->dev;
+	tfm_ctx->keylen = 0;
+
+	tfm_ctx->fbk_cipher = NULL;
+	crypto_aead_set_reqsize(aead, sizeof(struct zynqmp_aead_req_ctx));
+
+	return 0;
 }
 
 static int zynqmp_aes_aead_init(struct crypto_aead *aead)
@@ -318,11 +369,12 @@ static int zynqmp_aes_aead_init(struct crypto_aead *aead)
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
 	struct zynqmp_aead_tfm_ctx *tfm_ctx =
 		(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
-	struct zynqmp_aead_drv_ctx *drv_ctx;
+	struct xilinx_aead_alg *drv_ctx;
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
-	tfm_ctx->dev = drv_ctx->dev;
+	drv_ctx = container_of(alg, struct xilinx_aead_alg, aead.base);
+	tfm_ctx->dev = drv_ctx->aead_dev->dev;
+	tfm_ctx->keylen = 0;
 
 	tfm_ctx->fbk_cipher = crypto_alloc_aead(drv_ctx->aead.base.base.cra_name,
 						0,
@@ -341,6 +393,14 @@ static int zynqmp_aes_aead_init(struct crypto_aead *aead)
 	return 0;
 }
 
+static void xilinx_paes_aead_exit(struct crypto_aead *aead)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+
+	memzero_explicit(tfm_ctx, sizeof(struct zynqmp_aead_tfm_ctx));
+}
+
 static void zynqmp_aes_aead_exit(struct crypto_aead *aead)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
@@ -354,104 +414,148 @@ static void zynqmp_aes_aead_exit(struct crypto_aead *aead)
 	memzero_explicit(tfm_ctx, sizeof(struct zynqmp_aead_tfm_ctx));
 }
 
-static struct zynqmp_aead_drv_ctx zynqmp_aes_drv_ctx = {
-	.aead.base = {
-		.setkey		= zynqmp_aes_aead_setkey,
-		.setauthsize	= zynqmp_aes_aead_setauthsize,
-		.encrypt	= zynqmp_aes_aead_encrypt,
-		.decrypt	= zynqmp_aes_aead_decrypt,
-		.init		= zynqmp_aes_aead_init,
-		.exit		= zynqmp_aes_aead_exit,
-		.ivsize		= GCM_AES_IV_SIZE,
-		.maxauthsize	= ZYNQMP_AES_AUTH_SIZE,
-		.base = {
-		.cra_name		= "gcm(aes)",
-		.cra_driver_name	= "xilinx-zynqmp-aes-gcm",
-		.cra_priority		= 200,
-		.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
-					  CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY |
-					  CRYPTO_ALG_KERN_DRIVER_ONLY |
-					  CRYPTO_ALG_NEED_FALLBACK,
-		.cra_blocksize		= ZYNQMP_AES_BLK_SIZE,
-		.cra_ctxsize		= sizeof(struct zynqmp_aead_tfm_ctx),
-		.cra_module		= THIS_MODULE,
-		}
+static struct xilinx_aead_alg zynqmp_aes_algs[] = {
+	{
+		.aead.base = {
+			.setkey		= zynqmp_aes_aead_setkey,
+			.setauthsize	= zynqmp_aes_aead_setauthsize,
+			.encrypt	= zynqmp_aes_aead_encrypt,
+			.decrypt	= zynqmp_aes_aead_decrypt,
+			.init		= zynqmp_aes_aead_init,
+			.exit		= zynqmp_aes_aead_exit,
+			.ivsize		= GCM_AES_IV_SIZE,
+			.maxauthsize	= ZYNQMP_AES_AUTH_SIZE,
+			.base = {
+				.cra_name		= "gcm(aes)",
+				.cra_driver_name	= "xilinx-zynqmp-aes-gcm",
+				.cra_priority		= 200,
+			.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
+				CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_KERN_DRIVER_ONLY |
+				CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize		= ZYNQMP_AES_BLK_SIZE,
+			.cra_ctxsize		= sizeof(struct zynqmp_aead_tfm_ctx),
+			.cra_module		= THIS_MODULE,
+			}
+		},
+		.aead.op = {
+			.do_one_request = zynqmp_handle_aes_req,
+		},
+		.dma_bit_mask = ZYNQMP_DMA_BIT_MASK,
 	},
-	.aead.op = {
-		.do_one_request = zynqmp_handle_aes_req,
+	{
+		.aead.base = {
+			.setkey		= zynqmp_paes_aead_setkey,
+			.setauthsize	= zynqmp_aes_aead_setauthsize,
+			.encrypt	= zynqmp_aes_aead_encrypt,
+			.decrypt	= zynqmp_aes_aead_decrypt,
+			.init		= xilinx_paes_aead_init,
+			.exit		= xilinx_paes_aead_exit,
+			.ivsize		= GCM_AES_IV_SIZE,
+			.maxauthsize	= ZYNQMP_AES_AUTH_SIZE,
+			.base = {
+				.cra_name		= "gcm(paes)",
+				.cra_driver_name	= "xilinx-zynqmp-paes-gcm",
+				.cra_priority		= 200,
+			.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
+				CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize		= ZYNQMP_AES_BLK_SIZE,
+			.cra_ctxsize		= sizeof(struct zynqmp_aead_tfm_ctx),
+			.cra_module		= THIS_MODULE,
+			}
+		},
+		.aead.op = {
+			.do_one_request = zynqmp_handle_aes_req,
+		},
+		.dma_bit_mask = ZYNQMP_DMA_BIT_MASK,
 	},
+	{ /* sentinel */ }
 };
 
 static struct xlnx_feature aes_feature_map[] = {
 	{
 		.family = PM_ZYNQMP_FAMILY_CODE,
 		.feature_id = PM_SECURE_AES,
-		.data = &zynqmp_aes_drv_ctx,
+		.data = zynqmp_aes_algs,
 	},
 	{ /* sentinel */ }
 };
 
 static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 {
-	struct zynqmp_aead_drv_ctx *aes_drv_ctx;
+	struct xilinx_aead_alg *aead_algs;
 	struct device *dev = &pdev->dev;
 	int err;
+	int i;
 
 	/* Verify the hardware is present */
-	aes_drv_ctx = xlnx_get_crypto_dev_data(aes_feature_map);
-	if (IS_ERR(aes_drv_ctx)) {
+	aead_algs = xlnx_get_crypto_dev_data(aes_feature_map);
+	if (IS_ERR(aead_algs)) {
 		dev_err(dev, "AES is not supported on the platform\n");
-		return PTR_ERR(aes_drv_ctx);
+		return PTR_ERR(aead_algs);
 	}
 
 	/* ZynqMP AES driver supports only one instance */
-	if (!aes_drv_ctx->dev)
-		aes_drv_ctx->dev = dev;
-	else
+	if (aead_dev)
 		return -ENODEV;
 
-	platform_set_drvdata(pdev, aes_drv_ctx);
-	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(ZYNQMP_DMA_BIT_MASK));
+	aead_dev = devm_kzalloc(dev, sizeof(*aead_dev), GFP_KERNEL);
+	if (!aead_dev)
+		return -ENOMEM;
+	aead_dev->dev = dev;
+	aead_dev->aead_algs = aead_algs;
+	platform_set_drvdata(pdev, aead_dev);
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(aead_algs[0].dma_bit_mask));
 	if (err < 0) {
 		dev_err(dev, "No usable DMA configuration\n");
 		return err;
 	}
 
-	aes_drv_ctx->engine = crypto_engine_alloc_init(dev, 1);
-	if (!aes_drv_ctx->engine) {
+	aead_dev->engine = crypto_engine_alloc_init(dev, 1);
+	if (!aead_dev->engine) {
 		dev_err(dev, "Cannot alloc AES engine\n");
 		err = -ENOMEM;
 		goto err_engine;
 	}
 
-	err = crypto_engine_start(aes_drv_ctx->engine);
+	err = crypto_engine_start(aead_dev->engine);
 	if (err) {
 		dev_err(dev, "Cannot start AES engine\n");
 		goto err_engine;
 	}
 
-	err = crypto_engine_register_aead(&aes_drv_ctx->aead);
-	if (err < 0) {
-		dev_err(dev, "Failed to register AEAD alg.\n");
-		goto err_engine;
+	for (i = 0; aead_dev->aead_algs[i].dma_bit_mask; i++) {
+		aead_dev->aead_algs[i].aead_dev = aead_dev;
+		err = crypto_engine_register_aead(&aead_dev->aead_algs[i].aead);
+		if (err < 0) {
+			dev_err(dev, "Failed to register AEAD alg %d.\n", i);
+			goto err_alg_register;
+		}
 	}
 	return 0;
 
+	return 0;
+
+err_alg_register:
+	while (i > 0)
+		crypto_engine_unregister_aead(&aead_dev->aead_algs[--i].aead);
 err_engine:
-	if (aes_drv_ctx->engine)
-		crypto_engine_exit(aes_drv_ctx->engine);
+	crypto_engine_exit(aead_dev->engine);
 
 	return err;
 }
 
 static void zynqmp_aes_aead_remove(struct platform_device *pdev)
 {
-	struct zynqmp_aead_drv_ctx *aes_drv_ctx;
+	aead_dev = platform_get_drvdata(pdev);
+	crypto_engine_exit(aead_dev->engine);
+	for (int i = 0; aead_dev->aead_algs[i].dma_bit_mask; i++)
+		crypto_engine_unregister_aead(&aead_dev->aead_algs[i].aead);
 
-	aes_drv_ctx = platform_get_drvdata(pdev);
-	crypto_engine_exit(aes_drv_ctx->engine);
-	crypto_engine_unregister_aead(&aes_drv_ctx->aead);
+	 aead_dev = NULL;
 }
 
 static struct platform_driver zynqmp_aes_driver = {
-- 
2.49.1

