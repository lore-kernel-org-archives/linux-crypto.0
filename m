Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012023.outbound.protection.outlook.com [52.101.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A1A86353
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 13:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757943049; cv=fail; b=ELOw3n9V8HHbnlO28XwNuLRbLBNVW21kw/mHNWJFwansbWAAibdZmvZL53TFn6vAigf78Gp1SewYCjpbJpEP6ygXROh/bJV6NpcksIxJroc3KyeLipasCCkTlYsVbBWStwYdoRmIFUDs2RY8yeMR25BWCq3MtKEyTLb7WcYq7HU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757943049; c=relaxed/simple;
	bh=GuUG08t1M2Edka1TpmWmogksxUdayjxTavANIXBpKn8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lRRqGmz7OJwNB/rLsVxPIqHYiEbNVkS0iqsaNirApUInsCSsdNCVpap0fmB2dmXS0OoaVz6BJSHUiOdELLh33bf2i5qZaXQlpo2W+tR36+Hhqx+Q6tmnHqY4s3kwanqx9BTFXmevkNBjBEZsSTAlgB0+SwddM0aQMYpQOYoOqnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OheiMYRU; arc=fail smtp.client-ip=52.101.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OheiMYRU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kYpSUdxGo5WFLv0xHoUDdS7m3n111xalxnK/rhgRNxm5WH4+YSoCIZ1IpPvsfPY6W1LWVEasPCDPEqQFcIf3vFDyGDL4PHSFOHpngo/vRN5fu9ry6qBGeTQOVdfTfZjQB52UQiB4GCZWppQhLmQxjwYhyr0HyjcxDUQukzBT0D//Loiyso05Oi9Z7E3vQymazkEYQK8W2O+d/wJhM3BVD9QU/hc0ThVaQazzY1qUHnueD5iPhBoD+bQZF9107QuHZtQped+ISb67vWi8O8AUcWEXEZy+faioUoJ6+uwwEYcNqOL+1112LsDG4G94sMX2WXXaDxhrtMQ3P6EucbkB3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHmr7fDqL3iFJ/faeHQETu9IRH7PCH5dXouQn7fiS/I=;
 b=ZIpZHpsASWCtN1pjjsW6kb+SjHSQyvSck9TQ0RZYZ/t+7w+qLdVdsUfwFDr7GQWBbDFaIlEi7AEdDTewlyKFME1l8A3jH5rstADIlWQYyt8KURUScsXyN5HkFzMvhqxvoY+NP8LiapBhrQ00+DfC2esKL7uv46R6fjXSBSOkjrR/Y7LnslMMdNyBdO+KaoEMU+df1s9O5nMO0f9tAiw7EIKWnnTxTBO/D051+Vb7xTn/+f3NYWng/id/m6lUO77DYKUOOrqP/n5x6vhF7Pjz0Jqz3SNecwtFDeCnm/gmHzN5WBAC7w87NQywo7lVtffIh7uzluvFkHwoke3EPF8iAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHmr7fDqL3iFJ/faeHQETu9IRH7PCH5dXouQn7fiS/I=;
 b=OheiMYRUzxtfmGhz4NCZu3gecjo1j8pQ+cb36nX9VQxOxBp4b1/35McBGJIgSby5dUXuj8GJBdVUHngC3fqeQVBJgdMMudkTKZ+P4iwhcJwOev5ibOqLZ6pCd8Bz+hCml3C8jtWPWUyxWIsU7jWVxe/j/783ahVK08eoIDNY1O8=
Received: from BN8PR04CA0066.namprd04.prod.outlook.com (2603:10b6:408:d4::40)
 by MN2PR12MB4301.namprd12.prod.outlook.com (2603:10b6:208:1d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 13:30:44 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:408:d4:cafe::97) by BN8PR04CA0066.outlook.office365.com
 (2603:10b6:408:d4::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.20 via Frontend Transport; Mon,
 15 Sep 2025 13:30:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Mon, 15 Sep 2025 13:30:44 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Mon, 15 Sep
 2025 06:30:44 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 15 Sep
 2025 08:30:43 -0500
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 15 Sep 2025 06:30:41 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <mounika.botcha@amd.com>,
	<sarat.chand.savitala@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 2/3] crypto: drbg: Replace AES cipher calls with library calls
Date: Mon, 15 Sep 2025 19:00:26 +0530
Message-ID: <20250915133027.2100914-3-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250915133027.2100914-1-h.jain@amd.com>
References: <20250915133027.2100914-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB05.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|MN2PR12MB4301:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a310940-106f-45fd-a160-08ddf45c12ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I+Bm2Zhj0XM2rYKB8CQ5jQypzmVvBtk38rnawPFsjuYObQJyxwjQ8KNGr60+?=
 =?us-ascii?Q?2T0zEpL6EM8EYr062lj8J7qVSb/HFOiuC1JIyae5D3bwMrROPMRIsQnxs5c/?=
 =?us-ascii?Q?QmwsOOVXpvgCf4LFh+GhkeK2yLv2bs4FS7Gifg1guXkS7PalbjdttkOHMZw1?=
 =?us-ascii?Q?oAJejoDmchHOSYxfixVlLIClrgS6Wvwdf3hx/c2sL5QvEvCbPRm3TGXAdIkm?=
 =?us-ascii?Q?267oos3MIRAUNVKT8B6llLaFgLgoejzoT+xv57OQn2tQEF8hu6/4b5ET+821?=
 =?us-ascii?Q?Or9AbIxnbWvfVHsh6vOK7Qa2cLiuRsLXu5x/BfIkInyTTDKdZPklVMho20G/?=
 =?us-ascii?Q?kKxas10Cs4yEQZAjPE0AHBPoiJyobiD//zaqD0lly8YIwPgDYInrRyMFLmkq?=
 =?us-ascii?Q?KhQ1OlA9usnJ3t9D1YzsHVe6l5zelifjLTTchwWY41Mfpl14B7iKLUmXN+g5?=
 =?us-ascii?Q?SJgflnjEYX9mZxetD2wfxfcPaotJQuJisMXGZnItw7wcMTfjWj9B2Z0Q/GfP?=
 =?us-ascii?Q?h49m4BJUAx5pwQNxP+8Ei3ucUNU61mXC60uC5O3exFnksh9Ia8H0EtI6Bl14?=
 =?us-ascii?Q?vUHztnOn1Zwgu5YutxlZmShil85m3V5NxYBrJAVrwi66Sa0Uang61RRB2lyC?=
 =?us-ascii?Q?pNeGu1QNbwVC3gz5OkJAInMGIv8P5aK3sWOwMiOLn2OIkKUWJdsfBPUmO/uE?=
 =?us-ascii?Q?YfN173pl++J9hsTi6g3KR7Hy5ZTwI+Z7NPmwePpXbwYGp7ymzlFvIB9CW75S?=
 =?us-ascii?Q?1d/4PKDoVSsGmQfeVlChyGLmMOlBUJsbAQpN1/sF/xDuE8YGYwLriWXggjVf?=
 =?us-ascii?Q?wuisPPqVYGAeYc3dzlIcVUUm9X+7pGZLyvsJygv+m0sCLDJdH1WGuZHmdssU?=
 =?us-ascii?Q?oRjgMOzBcSHK+KTIkSGwsar8aHIvkKnioFOhnJgzATYOkWeXkxTFszY8rBX5?=
 =?us-ascii?Q?RaH6EnEkdnRsyB9web6dgEWx+Zfxr7ffnJVFlXyMKsQxd0kNT0DjxD/Lw9Jq?=
 =?us-ascii?Q?J53ocRz0KOOoxIAYu0MtmtfoPpMVtSaXx5We6vQqW8Mu2WUz+RcPfrpdYyC/?=
 =?us-ascii?Q?m1aO9nf7pV9MarAUoOA84A3qL1sSjwDxJmzkyOG/tKPtfzFKeW3qByebNGvv?=
 =?us-ascii?Q?Bv7M34CgC9HrcGqydqBJNLWTToyT2LJJA2DHQBFviVKKLSe33YFSo6cdzW4v?=
 =?us-ascii?Q?PrxOn/5HIpvg/+UdW+wdsFb+ZuVuUf9desDXIAqK+syLHugWWaIqf8lqajI+?=
 =?us-ascii?Q?1+rTu3Cbrujn+26mV0FXpLJpiiuezCV8gRztS2jtpEJu2IiE6oZicNb6Q8rD?=
 =?us-ascii?Q?6jGbWIFofJCOf0LgFFNGc0kg8kInTUR4zbyLkYqjgDBmJ3MmUA0amcnKBV8n?=
 =?us-ascii?Q?/NjHBYyGRFQmracQVAdtmjellellbjZK6Gr2HY7qiiOraLn0VjMVsXBmejND?=
 =?us-ascii?Q?DWorVoiSDIgQVRLSfFZdrU0aXGHmpPlUKyHZATg/FhEtTyVP3Ll2T+P0OeQC?=
 =?us-ascii?Q?1cxwTpEj1S551TvT7Kcewp+TjDy00C/jFF6F?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 13:30:44.7646
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a310940-106f-45fd-a160-08ddf45c12ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4301

Replace aes used in drbg with library calls.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 crypto/df_sp80090a.c         | 29 +++++++++++++++--------------
 crypto/drbg.c                | 21 ++++++++-------------
 include/crypto/df_sp80090a.h |  3 ++-
 3 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/crypto/df_sp80090a.c b/crypto/df_sp80090a.c
index 8309e62abe27..bad38c267180 100644
--- a/crypto/df_sp80090a.c
+++ b/crypto/df_sp80090a.c
@@ -10,33 +10,34 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <crypto/aes.h>
 #include <crypto/df_sp80090a.h>
 #include <crypto/internal/drbg.h>
 
-static void drbg_kcapi_symsetkey(struct crypto_cipher *tfm,
+static void drbg_kcapi_symsetkey(struct crypto_aes_ctx *aesctx,
 				 const unsigned char *key,
 				 u8 keylen);
-static int drbg_kcapi_sym(struct crypto_cipher *tfm, unsigned char *outval,
+static int drbg_kcapi_sym(struct crypto_aes_ctx *aesctx, unsigned char *outval,
 			  const struct drbg_string *in, u8 blocklen_bytes);
 
-static void drbg_kcapi_symsetkey(struct crypto_cipher *tfm,
+static void drbg_kcapi_symsetkey(struct crypto_aes_ctx *aesctx,
 				 const unsigned char *key, u8 keylen)
 {
-	crypto_cipher_setkey(tfm, key, keylen);
+	aes_expandkey(aesctx, key, keylen);
 }
 
-static int drbg_kcapi_sym(struct crypto_cipher *tfm, unsigned char *outval,
+static int drbg_kcapi_sym(struct crypto_aes_ctx *aesctx, unsigned char *outval,
 			  const struct drbg_string *in, u8 blocklen_bytes)
 {
 	/* there is only component in *in */
 	BUG_ON(in->len < blocklen_bytes);
-	crypto_cipher_encrypt_one(tfm, outval, in->buf);
+	aes_encrypt(aesctx, outval, in->buf);
 	return 0;
 }
 
 /* BCC function for CTR DRBG as defined in 10.4.3 */
 
-static int drbg_ctr_bcc(struct crypto_cipher *tfm,
+static int drbg_ctr_bcc(struct crypto_aes_ctx *aesctx,
 			unsigned char *out, const unsigned char *key,
 			struct list_head *in,
 			u8 blocklen_bytes,
@@ -50,7 +51,7 @@ static int drbg_ctr_bcc(struct crypto_cipher *tfm,
 	drbg_string_fill(&data, out, blocklen_bytes);
 
 	/* 10.4.3 step 2 / 4 */
-	drbg_kcapi_symsetkey(tfm, key, keylen);
+	drbg_kcapi_symsetkey(aesctx, key, keylen);
 	list_for_each_entry(curr, in, list) {
 		const unsigned char *pos = curr->buf;
 		size_t len = curr->len;
@@ -59,7 +60,7 @@ static int drbg_ctr_bcc(struct crypto_cipher *tfm,
 			/* 10.4.3 step 4.2 */
 			if (blocklen_bytes == cnt) {
 				cnt = 0;
-				ret = drbg_kcapi_sym(tfm, out, &data, blocklen_bytes);
+				ret = drbg_kcapi_sym(aesctx, out, &data, blocklen_bytes);
 				if (ret)
 					return ret;
 			}
@@ -71,7 +72,7 @@ static int drbg_ctr_bcc(struct crypto_cipher *tfm,
 	}
 	/* 10.4.3 step 4.2 for last block */
 	if (cnt)
-		ret = drbg_kcapi_sym(tfm, out, &data, blocklen_bytes);
+		ret = drbg_kcapi_sym(aesctx, out, &data, blocklen_bytes);
 
 	return ret;
 }
@@ -117,7 +118,7 @@ static int drbg_ctr_bcc(struct crypto_cipher *tfm,
  */
 
 /* Derivation Function for CTR DRBG as defined in 10.4.2 */
-int crypto_drbg_ctr_df(struct crypto_cipher *tfm,
+int crypto_drbg_ctr_df(struct crypto_aes_ctx *aesctx,
 		       unsigned char *df_data, size_t bytes_to_return,
 		       struct list_head *seedlist,
 		       u8 blocklen_bytes,
@@ -195,7 +196,7 @@ int crypto_drbg_ctr_df(struct crypto_cipher *tfm,
 		 */
 		drbg_cpu_to_be32(i, iv);
 		/* 10.4.2 step 9.2 -- BCC and concatenation with temp */
-		ret = drbg_ctr_bcc(tfm, temp + templen, K, &bcc_list,
+		ret = drbg_ctr_bcc(aesctx, temp + templen, K, &bcc_list,
 				   blocklen_bytes, keylen);
 		if (ret)
 			goto out;
@@ -211,7 +212,7 @@ int crypto_drbg_ctr_df(struct crypto_cipher *tfm,
 	/* 10.4.2 step 12: overwriting of outval is implemented in next step */
 
 	/* 10.4.2 step 13 */
-	drbg_kcapi_symsetkey(tfm, temp, keylen);
+	drbg_kcapi_symsetkey(aesctx, temp, keylen);
 	while (generated_len < bytes_to_return) {
 		short blocklen = 0;
 		/*
@@ -219,7 +220,7 @@ int crypto_drbg_ctr_df(struct crypto_cipher *tfm,
 		 * implicit as the key is only drbg_blocklen in size based on
 		 * the implementation of the cipher function callback
 		 */
-		ret = drbg_kcapi_sym(tfm, X, &cipherin, blocklen_bytes);
+		ret = drbg_kcapi_sym(aesctx, X, &cipherin, blocklen_bytes);
 		if (ret)
 			goto out;
 		blocklen = (blocklen_bytes <
diff --git a/crypto/drbg.c b/crypto/drbg.c
index bad005eef03d..511a27c91813 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1506,10 +1506,9 @@ static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
 #ifdef CONFIG_CRYPTO_DRBG_CTR
 static int drbg_fini_sym_kernel(struct drbg_state *drbg)
 {
-	struct crypto_cipher *tfm =
-		(struct crypto_cipher *)drbg->priv_data;
-	if (tfm)
-		crypto_free_cipher(tfm);
+	struct crypto_aes_ctx *aesctx =	(struct crypto_aes_ctx *)drbg->priv_data;
+
+	kfree(aesctx);
 	drbg->priv_data = NULL;
 
 	if (drbg->ctr_handle)
@@ -1528,20 +1527,16 @@ static int drbg_fini_sym_kernel(struct drbg_state *drbg)
 
 static int drbg_init_sym_kernel(struct drbg_state *drbg)
 {
-	struct crypto_cipher *tfm;
+	struct crypto_aes_ctx *aesctx;
 	struct crypto_skcipher *sk_tfm;
 	struct skcipher_request *req;
 	unsigned int alignmask;
 	char ctr_name[CRYPTO_MAX_ALG_NAME];
 
-	tfm = crypto_alloc_cipher(drbg->core->backend_cra_name, 0, 0);
-	if (IS_ERR(tfm)) {
-		pr_info("DRBG: could not allocate cipher TFM handle: %s\n",
-				drbg->core->backend_cra_name);
-		return PTR_ERR(tfm);
-	}
-	BUG_ON(drbg_blocklen(drbg) != crypto_cipher_blocksize(tfm));
-	drbg->priv_data = tfm;
+	aesctx = kzalloc(sizeof(*aesctx), GFP_KERNEL);
+	if (!aesctx)
+		return -ENOMEM;
+	drbg->priv_data = aesctx;
 
 	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "ctr(%s)",
 	    drbg->core->backend_cra_name) >= CRYPTO_MAX_ALG_NAME) {
diff --git a/include/crypto/df_sp80090a.h b/include/crypto/df_sp80090a.h
index 182865538662..6b25305fe611 100644
--- a/include/crypto/df_sp80090a.h
+++ b/include/crypto/df_sp80090a.h
@@ -8,6 +8,7 @@
 #define _CRYPTO_DF80090A_H
 
 #include <crypto/internal/cipher.h>
+#include <crypto/aes.h>
 
 static inline int crypto_drbg_ctr_df_datalen(u8 statelen, u8 blocklen)
 {
@@ -17,7 +18,7 @@ static inline int crypto_drbg_ctr_df_datalen(u8 statelen, u8 blocklen)
 		statelen + blocklen;  /* temp */
 }
 
-int crypto_drbg_ctr_df(struct crypto_cipher *tfm,
+int crypto_drbg_ctr_df(struct crypto_aes_ctx *aes,
 		       unsigned char *df_data,
 		       size_t bytes_to_return,
 		       struct list_head *seedlist,
-- 
2.34.1

