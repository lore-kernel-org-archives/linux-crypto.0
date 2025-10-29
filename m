Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010005.outbound.protection.outlook.com [52.101.193.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ECA2FBDE3;
	Wed, 29 Oct 2025 10:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733377; cv=fail; b=BeiO46EgZnksGClxtceRzNtovWuahjUY53GpjchTcMHqgQ8tHBE6oTcv34ZPM4wxf/rHr/5tnkDcnJBkUN1bfvRF8rxjHpoFXZDnCwkeBkNdLmW+Rz90p767LLTUcnxcZo//umG+IpkCcqR7VYJr0N09w+wRHEvQkX5eTwnRRWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733377; c=relaxed/simple;
	bh=BtkoLH/sixoozPMciXtgEJueY4xTGwCOpax6dhhm9S8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t7+z8f3o7dk7vAQbT/dyCYhUlmYmyM9Ms5tlD+smZ8ZaY5SbFVJw3TBa9O0KE9fbTEBpZZZC8duO2iDyag+SfAE3fRJHTNLFYCbANUMZapaBQReER9pG+s5UwJbCPHbpuDPd3ThjuMbbBNjgy8Q0cfGpA5lA8D9P+AvmCJ+++BA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U6uHaOdx; arc=fail smtp.client-ip=52.101.193.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U6uHaOdx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ht8SLOyNGex8qavusxSZcHTGEXUi+mTskiDhJdXtllUhkf59mmKSVfjmJPy301I8Qn+acBZHjfJ2G1Y8xXd69ZwNzLZ9wIJP34mrkAhZIcqM5guG8FJSSogbnL6AF6/jINPcgJWxFqzv9w8aXPbNbqMEXWU3tSRQ4vJL5VXeaSbxIjziAmrZroLyZz2caFDow8lVm/X/k1fbUGdE1RnWVqMOp7JlPR0foCeEprPiJwbsgwVcD4yQgHqPNiJcvE+of+HkOeeHvpnAS74b+nX/i4UHIViDjDBtjwA0eOQgRyjUJqbt1F42tfNYeIkoksDLeXdTsGzAma8YhK4Rz3Y1lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/y8kFwCNNHl45KqVXdIeL0iT2jIDPF24sdPuSdr0ckk=;
 b=Iv97o7k2f3Q4qPRw4fsgPQSZXWnuraCYMv457QaI9dSF45yqf4qqffCYMR39cFe91lQpykRR41CDAXuyKu61HT+gKjJCsgXQyAKb7OqDSY8piIQbS5abcMc93q7VQ0qP59+NOn+CvbOT4eOsbxZpnvGlM/bLmKV82umoQgtVZRy7HjsQrnDRQ53JPXGfGbXDxP2V0ic5AdEzhoZOLK/WlCXZl06rAqRsWE4Mdil6Eam5Gt3JFOGL5Az21Y+XyMn7owQ2sZ6ONEF1yQdYy5DLeUOD5wzwYJY1RI4DQiX4Bewua/Zd2DmmArcd4grO6ZUtTLaai34tDspWiMnqL4EIXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/y8kFwCNNHl45KqVXdIeL0iT2jIDPF24sdPuSdr0ckk=;
 b=U6uHaOdxVOnzpoO1zqQkpCTRT0miusp0vbZMexO4ydKahDOzuz6yth3YOgSJnD44UXk4YAdvZvnfy7pWGJkASN6b7huCMvrkXuhaXhZ1md4CDOgpFiy5yBpCfkRRjwjW9u5L2crw8SZH4/xzNeyeIf0iTx8UKrsDgvyv9WgrCBU=
Received: from MW4PR04CA0162.namprd04.prod.outlook.com (2603:10b6:303:85::17)
 by DM4PR12MB6544.namprd12.prod.outlook.com (2603:10b6:8:8d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.12; Wed, 29 Oct 2025 10:22:51 +0000
Received: from CO1PEPF000044EF.namprd05.prod.outlook.com
 (2603:10b6:303:85:cafe::10) by MW4PR04CA0162.outlook.office365.com
 (2603:10b6:303:85::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.14 via Frontend Transport; Wed,
 29 Oct 2025 10:22:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044EF.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 10:22:50 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:45 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:45 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Oct 2025 03:22:42 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 09/15] crypto: zynqmp-aes-gcm: Fix setkey operation to select HW keys
Date: Wed, 29 Oct 2025 15:51:52 +0530
Message-ID: <20251029102158.3190743-10-h.jain@amd.com>
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
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EF:EE_|DM4PR12MB6544:EE_
X-MS-Office365-Filtering-Correlation-Id: bb7fef65-9f3a-49d2-dfad-08de16d51d03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tdO8v6CZaO6vWkbgRtMjggWcp7SYnGboXJt/K50MF1rEAQ2jxqMHexExz3rR?=
 =?us-ascii?Q?DtRMaeCPQxWCPaLiZEn9bOGxvUL0IOHRg1g48Y2u3mN3DH1iYAf6KO/WnV2n?=
 =?us-ascii?Q?UuuLzdi5ahMNsWzW2KnAutUyvaJ7aQCFUeaZpVcomiGrw1kf4Fng72GUjATI?=
 =?us-ascii?Q?QklikCdTYjKdrtrZ3rCDRawp6h7c8IZsk2tbBO6AiVuNE2F0E+xbZ7td2K5J?=
 =?us-ascii?Q?FRjOvi3b6Jlj0gQx1jI2gJyRcou7EfypvA0uP6yhKOs/swERZFkThM4Kcwap?=
 =?us-ascii?Q?eaofLJXB5FO9LcZMIqdZoFv5y5DJBigei+epfCS5RbywIpQoljYglgsKKiVC?=
 =?us-ascii?Q?DktcPgAQd9IK18NbHWpNjwB5J7MhtIC95v214qHZaKPZ5/pbDJ/rEWljAG0N?=
 =?us-ascii?Q?mJsjzI5tcDkneTR+wkTHYB/sm4lamWFibP/r6zhGwXjcA3Y20Bf9Io08rots?=
 =?us-ascii?Q?w5ptd224p1lmLfmcrS0dTrS4JHeI4YjmteivgxsCe4siLJAeY400QM6gK6ef?=
 =?us-ascii?Q?L70Jynqm46OA9u21Lhx/XENfaavHAFgS+8tSKdAaNdJQFwJaBcOdUMA0V9PV?=
 =?us-ascii?Q?qQtLO2mN+0sahC6xSOzJnipqtoa/U8Lt5zwyB3YB0lS97nT/xTbMspmT2s84?=
 =?us-ascii?Q?NQtNCBfWglnhRPJ8tmB0ttl3jD1NJT7kTeSiWT7IgyEHhpRrfM2e82n5UnHm?=
 =?us-ascii?Q?IIfxeZUJG7zF6XcTZTJm4i/3f7py6rjKMemkhaD3opi7ef43KEqac2hOTIog?=
 =?us-ascii?Q?bZNATAYJd756dQzQPC6d1FN4gJCUOyqjhq8yAVOjdbqjRaQlo3oUM2KogQmj?=
 =?us-ascii?Q?jdtPbDpSATKN0yZkw8sGlKfhYOE/mF+zlcj3rSQMRngW9HIRbriiGlCgMEWt?=
 =?us-ascii?Q?RmaxwfNvQHSQVEj+tjBSecBPoTqy7De1gDXwxGZQRZ6Nbz3YLhOl7bDWh5NK?=
 =?us-ascii?Q?kwFQM3wgTfeCnXkAqkamjjHQDPC44rFyr804YKftgLXCycDRwVIEJTI/1NxL?=
 =?us-ascii?Q?PDPFZSXMGjUMvUIMMMyy9b1bAXlyhmkoKhtS76RNqQkwK7mRDHr+WW/GnDx8?=
 =?us-ascii?Q?3pjvvSrAI0AijHAzvMJBSm9LC2V6hAspZN3j1mM0FZGmKP3RgFtS8oY/VbUt?=
 =?us-ascii?Q?KK8ES5wNWulKB/sblKqVIjyghxjQmhxpItL9BgwuL/bT0Dh0ZDzQgv5tUlVZ?=
 =?us-ascii?Q?w9Q2UPvp6bB4Yd3jD5zuYzzEQvgHm1F2XgOBIJj3oPqlb39bJlScEJXfNlyf?=
 =?us-ascii?Q?e+MhH/CZl+OWd8oEorNn2372NNj4+CggJXSkEJqpgBOVEXsMH6YOgGcUVM1b?=
 =?us-ascii?Q?jW/mYVfrIxncEfXsDdz+eReha635zWRfeaq41G/IE3a2/s1EoFBQtT/6GrLM?=
 =?us-ascii?Q?mGbNoF4bnC6uNaHP20po0ttOVlW55vDmOROjCoEJUVjb5z9yFg9ZVMHMppxB?=
 =?us-ascii?Q?hr/V2Lp6ZXa7TEr/AtLMTuUg21Hp9VMkJDkutS5NvpBfrUZw3acS4AbJqktv?=
 =?us-ascii?Q?lTrmpJl7+9kaoG3WQOLg5uz2FHOYCQZnr4isZPCLbpleZxks+P9OpQ4ejRXY?=
 =?us-ascii?Q?s9ZlSf8VW+xP8YhP9M/ezL5TagEWLJfxZncT2ZSd?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 10:22:50.2493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb7fef65-9f3a-49d2-dfad-08de16d51d03
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6544

Currently keylen 1 is used to select hw key. There are -ve self test
which can fail for setkey length 1. Update driver to use 4 bytes
with magic number to select H/W key type.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 94 ++++++++++++++++----------
 1 file changed, 60 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 9be1305b79d2..bc12340487be 100644
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
@@ -48,6 +48,11 @@ struct zynqmp_aead_drv_ctx {
 	struct crypto_engine *engine;
 };
 
+struct xilinx_hwkey_info {
+	u16 magic;
+	u16 type;
+} __packed;
+
 struct zynqmp_aead_hw_req {
 	u64 src;
 	u64 iv;
@@ -64,7 +69,7 @@ struct zynqmp_aead_tfm_ctx {
 	u8 *iv;
 	u32 keylen;
 	u32 authsize;
-	enum zynqmp_aead_keysrc keysrc;
+	u8 keysrc;
 	struct crypto_aead *fbk_cipher;
 };
 
@@ -175,32 +180,29 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
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
@@ -218,32 +220,42 @@ static int zynqmp_aes_aead_setkey(struct crypto_aead *aead, const u8 *key,
 				  unsigned int keylen)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx =
-			(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
+	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	struct xilinx_hwkey_info hwkey;
 	unsigned char keysrc;
+	int err;
 
-	if (keylen == ZYNQMP_KEY_SRC_SEL_KEY_LEN) {
-		keysrc = *key;
+	if (keylen == sizeof(struct xilinx_hwkey_info)) {
+		memcpy(&hwkey, key, sizeof(struct xilinx_hwkey_info));
+		if (hwkey.magic != XILINX_KEY_MAGIC)
+			return -EINVAL;
+		keysrc = hwkey.type;
 		if (keysrc == ZYNQMP_AES_KUP_KEY ||
 		    keysrc == ZYNQMP_AES_DEV_KEY ||
 		    keysrc == ZYNQMP_AES_PUF_KEY) {
-			tfm_ctx->keysrc = (enum zynqmp_aead_keysrc)keysrc;
-		} else {
-			tfm_ctx->keylen = keylen;
+			tfm_ctx->keysrc = keysrc;
+			tfm_ctx->keylen = sizeof(struct xilinx_hwkey_info);
+			return 0;
 		}
-	} else {
+		return -EINVAL;
+	}
+
+	if (keylen == ZYNQMP_AES_KEY_SIZE && tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY) {
 		tfm_ctx->keylen = keylen;
-		if (keylen == ZYNQMP_AES_KEY_SIZE) {
-			tfm_ctx->keysrc = ZYNQMP_AES_KUP_KEY;
-			memcpy(tfm_ctx->key, key, keylen);
-		}
+		memcpy(tfm_ctx->key, key, keylen);
+	} else if (tfm_ctx->keysrc != ZYNQMP_AES_KUP_KEY) {
+		return -EINVAL;
 	}
 
 	tfm_ctx->fbk_cipher->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
 	tfm_ctx->fbk_cipher->base.crt_flags |= (aead->base.crt_flags &
 					CRYPTO_TFM_REQ_MASK);
 
-	return crypto_aead_setkey(tfm_ctx->fbk_cipher, key, keylen);
+	err = crypto_aead_setkey(tfm_ctx->fbk_cipher, key, keylen);
+	if (!err)
+		tfm_ctx->keylen = keylen;
+
+	return err;
 }
 
 static int zynqmp_aes_aead_setauthsize(struct crypto_aead *aead,
@@ -267,9 +279,16 @@ static int zynqmp_aes_aead_encrypt(struct aead_request *req)
 	struct zynqmp_aead_drv_ctx *drv_ctx;
 	int err;
 
-	rq_ctx->op = ZYNQMP_AES_ENCRYPT;
 	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
+	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY &&
+	    tfm_ctx->keylen == sizeof(struct xilinx_hwkey_info))
+		return -EINVAL;
+
+	rq_ctx->op = ZYNQMP_AES_ENCRYPT;
 	err = zynqmp_fallback_check(tfm_ctx, req);
+	if (err && tfm_ctx->keysrc != ZYNQMP_AES_KUP_KEY)
+		return -EOPNOTSUPP;
+
 	if (err) {
 		aead_request_set_tfm(subreq, tfm_ctx->fbk_cipher);
 		aead_request_set_callback(subreq, req->base.flags,
@@ -297,7 +316,12 @@ static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 
 	rq_ctx->op = ZYNQMP_AES_DECRYPT;
 	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
+	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY &&
+	    tfm_ctx->keylen == sizeof(struct xilinx_hwkey_info))
+		return -EINVAL;
 	err = zynqmp_fallback_check(tfm_ctx, req);
+	if (err && tfm_ctx->keysrc != ZYNQMP_AES_KUP_KEY)
+		return -EOPNOTSUPP;
 	if (err) {
 		aead_request_set_tfm(subreq, tfm_ctx->fbk_cipher);
 		aead_request_set_callback(subreq, req->base.flags,
@@ -323,6 +347,8 @@ static int zynqmp_aes_aead_init(struct crypto_aead *aead)
 
 	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
 	tfm_ctx->dev = drv_ctx->dev;
+	tfm_ctx->keylen = 0;
+	tfm_ctx->keysrc = ZYNQMP_AES_KUP_KEY;
 
 	tfm_ctx->fbk_cipher = crypto_alloc_aead(drv_ctx->aead.base.base.cra_name,
 						0,
-- 
2.49.1

