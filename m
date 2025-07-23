Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2061.outbound.protection.outlook.com [40.107.101.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B74229B21;
	Wed, 23 Jul 2025 18:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753294964; cv=fail; b=YGH5tBdCot/yllFvtyFMnhlSG3W2d1FrYTY87P/xRd7+3InvE+75dgRxeBIBo/qtrFlJIV+YFej1hXpG5zYhU+df/E1mH8ZlAYXnL78EZQYT9/HQRQ2TBhxcp6W8QTwOffSukBzZ5zMZd3DNlnOJSoQshApMVz3FAH9OvdLb3t4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753294964; c=relaxed/simple;
	bh=vk9BIAJlLyyoX6oV/NNmDj2ekZL++n/5kczMH61NzDU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4GmSCeOY5GmgMp79V3eK2Ul2Unri9eBCh6z1KDQu9i7HgNop88ozSoZu0Yxp0NcqDBki1Au3lNIq3f8fIExBSsRq3kL/wT5viCdi7wgEudDcs1hCoaSgR/v3E0phGM3trdwSI0BiEH3WeZV9M419gyZWvcaSidmabM2OLTjVxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bmgwzs09; arc=fail smtp.client-ip=40.107.101.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bmgwzs09"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ejfkxUdR/pgIR4nZJg9K/YpFHi5IEHmRNZlXHQLM5WWETgbcTsCIyOR+HKH7wplPXeFRrmD56zyX1ag9KMxj2Q9Hx54Pq14vOmk4beeeqrDbSlHT+mKOq/OmJ2k/PODmvitLpdyQUUwHu7296wTw2gRPxyDdnA+5fy28snxqsUoberaYhimprjiAkoewDRlRkcrpkZO2LLVNdi+Jjoi8N4F+GTkbl0r2T/q4k2GS9VN5fxuTNYaju2URN/TTeZKJVYZ35OhfbA7ZZFEIhBlyaP777aIh1gTJ6m9phZnvOZSBiHDiGyXRZgozUKOGSVUl+uIVgDsnsW/68PPj8cb8pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wv/ZGOomO4Xp/QqNMj4QPnz7nF8mCHNpPVCpy0MXXzk=;
 b=uTrwJH+iUcb5VIdsyHFXBB9zLZo5oLYd878xOuEz0ikHw82KOHHZUZyY8TZi8oGExYMQsALGQSiQUXizAu1Ow7Y42bm3vyxbUa+VsbZCgQVUjz21nO4We7iZ7ltco57wATWr8lAlt47r7UnTcuf+F6G3nobo3nITdLcc4Ha9yXj4J6Eckvhl0NwbPaQTIzLGDOt7HK78Gy4rUvoGbhq15El54bfC+cJmW9enyZmFT92CzPdQhG16lU1iPTyUc75lyqnyCtcekZjr7m9h6flwIF3XLG/KfRUFB9g92KBdklb8ZXX0ba5XrYIiBKWRa5ZBzMH4eynJ8HR8zw6Ua3TRCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wv/ZGOomO4Xp/QqNMj4QPnz7nF8mCHNpPVCpy0MXXzk=;
 b=bmgwzs097Aoa/A7IApJOuybZ7Vf5pgL6JXaz+hivBrPLKA6hrVXaSvJZ2gYQdDZVDPAFoZHTWCiB1JrtQstYmBswvmL+tP0Wz06IUUQ9wZgOxaQvkjiDqsIs9wSc0hE9bLcgaSgAWwvJ73IZoWxGtOBkiZoZNVIP/QApnJeAQag=
Received: from DS7PR05CA0046.namprd05.prod.outlook.com (2603:10b6:8:2f::14) by
 IA1PR12MB6410.namprd12.prod.outlook.com (2603:10b6:208:38a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 18:22:35 +0000
Received: from DS2PEPF00003441.namprd04.prod.outlook.com
 (2603:10b6:8:2f:cafe::74) by DS7PR05CA0046.outlook.office365.com
 (2603:10b6:8:2f::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.5 via Frontend Transport; Wed,
 23 Jul 2025 18:22:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003441.mail.protection.outlook.com (10.167.17.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Wed, 23 Jul 2025 18:22:34 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 23 Jul
 2025 13:22:33 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 23 Jul
 2025 13:22:33 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 23 Jul 2025 13:22:29 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>, <smueller@chronox.de>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v4 3/3] crypto: drbg: Export CTR DRBG DF functions
Date: Wed, 23 Jul 2025 23:51:10 +0530
Message-ID: <20250723182110.249547-4-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250723182110.249547-1-h.jain@amd.com>
References: <20250723182110.249547-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003441:EE_|IA1PR12MB6410:EE_
X-MS-Office365-Filtering-Correlation-Id: f468ccc8-92ea-4f9e-cfaf-08ddca15e518
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pFLcjkzS7iQA8IgZJDzIEwh6YHvSxjojsd9EQJKcpEvUwX4jKiU4aPUJnAaU?=
 =?us-ascii?Q?Uq8E00LsbWYRcMjYsrJqydJZCyhMyOifTPrtxNHVYyexNf+aq7qPuRKfgigK?=
 =?us-ascii?Q?NThwCMeFjYy8Os7niKHixAt5pVCA8alX5/qeYrpsJd8s7tyj6uG9XcAUHy4T?=
 =?us-ascii?Q?frcM+KhbTRVU4nw8ReAWTS+WnP/mW8IFiEqYbLeBzNN/7rl4HFCu3nkXjLnU?=
 =?us-ascii?Q?Q/z9FRqxxd38VP9P3+XVhtyTK5tXDVwfci9UDa67pfAxRyAg3LJSyQ6HQzv/?=
 =?us-ascii?Q?CMyRqVz4B5tN6Eg549sMGyypMddfjuKePbVZCKZFc/j5d/vjJfR8bK4w9d+L?=
 =?us-ascii?Q?yjFJ6oe+Ce4RiuZKWwWn+c67I5eYxMFOB3P0foNkdb/CjErwu24a+eZlqWXK?=
 =?us-ascii?Q?cMTgk6GSxjp6C9/vAIjgLMalDSojNwW6t9mNOSOxmjixq4eP+7b4LDazqOFj?=
 =?us-ascii?Q?I90ZbUzVTjdJMAwpszqjVBMHnTjM5s6Da8EJ6wmeGOc1ZSjY02+BN+NVVvnN?=
 =?us-ascii?Q?9cDglHBSAAPNRqM386NoRwBcb9Yz9VBCCesWv3xWlAx4HRYy5uWS+KiZe5GY?=
 =?us-ascii?Q?5UDkQo2bYtiPyIq6F7z+SwDRPNcsnfdj4jvjfOUBJU7/vRLQvFq1MQdNTE1J?=
 =?us-ascii?Q?zkiR3pXowLts3SF4QbTR5rHUPA3VNtd0CJL1yjobLoRAY+UJpXBHsURKPUCD?=
 =?us-ascii?Q?OIeBB0k8GJyWGxiOadly6+uVeT7Sxy5qBXfjVqJxA2uMmM84rlVgSJadkPgO?=
 =?us-ascii?Q?i00Uuw5z0TJG3IcpaHlwGLBdvS9gc6e6DIO2BR60zi7BElN3UWp9C7SPEDIe?=
 =?us-ascii?Q?AJ3SSc0XxV8sgSuF9NALO8JqGghdIHBnVc4hFeBaTc05Fp4DueDkDoo80v5D?=
 =?us-ascii?Q?dqqWV7PoV7gUTJMAguxUAo5mXRoLIvqPB3RuEJmJNdn1xw90HAfHk3/QpWUI?=
 =?us-ascii?Q?IUyQNFaPLJPaqc/nn+q3Ccrp+slkwWkukT8nayBggtz3o30Bd5NgtyfPww57?=
 =?us-ascii?Q?+bJ7ok7TEV4ale4PgjNBv5Vd1hmnyl5gItloczYGIpSHDtnIJS4aWfd8aLXe?=
 =?us-ascii?Q?M8pErivAW25fFZaf5LqHcMq/13DO+7vRqtrcEH58MB1sQpwIOjmANFwFFaRy?=
 =?us-ascii?Q?cJgQPSHnpS5a+CBmC7fgS+XFInjhoYG3VCk9c65DXyP0/jbZQD2V2N3FOBco?=
 =?us-ascii?Q?NWuBQOnKjjSRH4v3LP7YOQ1vWhNgspo5mYXzhR0DiWQvh7DiDEioEPTDFiFf?=
 =?us-ascii?Q?+KJbQxkQ4qBQUomIoehhJHADaSPvHHpm81Yq+g1ktbx0JDC+7pw6bhyqdQk9?=
 =?us-ascii?Q?HMFwR7OpVzaWQdQnTQDBMl8xnbUrByjygrYE+9sZQKvrFz8kr7RSbOkZO/Rb?=
 =?us-ascii?Q?mlprpwGkR5wvU8Z2vyEsSeXtpJBFLjNyCyoghnBENMXUg7jn6varQjTbG6zk?=
 =?us-ascii?Q?uhpREiVjOFAWsulK/n8YKzStSw4iw3PmpSHkbWuNKYsqxBPP8eZ1Oh8m4wpP?=
 =?us-ascii?Q?23xJl80q6+SmpoNy9GkCwi68F9EXvPcoszbmzY8F1yjmwrX3p1Dt2TocOQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 18:22:34.2420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f468ccc8-92ea-4f9e-cfaf-08ddca15e518
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003441.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6410

Export drbg_ctr_df() derivative function to re-use it in xilinx trng
driver. Changes has been tested by enabling CONFIG_CRYPTO_USER_API_RNG_CAVP

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 crypto/Kconfig                      |   8 +-
 crypto/Makefile                     |   2 +
 crypto/df_sp80090a.c                | 243 +++++++++++++++++++++++++++
 crypto/drbg.c                       | 244 +---------------------------
 drivers/crypto/Kconfig              |   1 +
 drivers/crypto/xilinx/xilinx-trng.c |  38 ++++-
 include/crypto/df_sp80090a.h        |  27 +++
 include/crypto/drbg.h               |  18 ++
 8 files changed, 337 insertions(+), 244 deletions(-)
 create mode 100644 crypto/df_sp80090a.c
 create mode 100644 include/crypto/df_sp80090a.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e9fee7818e27..ee2b84082f10 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1191,8 +1191,7 @@ config CRYPTO_DRBG_HASH
 
 config CRYPTO_DRBG_CTR
 	bool "CTR_DRBG"
-	select CRYPTO_AES
-	select CRYPTO_CTR
+	select CRYPTO_DF80090A
 	help
 	  CTR_DRBG variant as defined in NIST SP800-90A.
 
@@ -1328,6 +1327,11 @@ config CRYPTO_KDF800108_CTR
 	select CRYPTO_HMAC
 	select CRYPTO_SHA256
 
+config CRYPTO_DF80090A
+	tristate
+	select CRYPTO_AES
+	select CRYPTO_CTR
+
 endmenu
 menu "Userspace interface"
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 017df3a2e4bb..1bf90ca4d3cf 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -214,4 +214,6 @@ obj-$(CONFIG_CRYPTO_SIMD) += crypto_simd.o
 #
 obj-$(CONFIG_CRYPTO_KDF800108_CTR) += kdf_sp800108.o
 
+obj-$(CONFIG_CRYPTO_DF80090A) += df_sp80090a.o
+
 obj-$(CONFIG_CRYPTO_KRB5) += krb5/
diff --git a/crypto/df_sp80090a.c b/crypto/df_sp80090a.c
new file mode 100644
index 000000000000..bde5139ba163
--- /dev/null
+++ b/crypto/df_sp80090a.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * NIST SP800-90A DRBG derivation function
+ *
+ * Copyright (C) 2014, Stephan Mueller <smueller@chronox.de>
+ */
+
+#include <crypto/df_sp80090a.h>
+#include <crypto/drbg.h>
+
+static void drbg_kcapi_symsetkey(struct crypto_cipher *tfm,
+				 const unsigned char *key,
+				 u8 keylen);
+static int drbg_kcapi_sym(struct crypto_cipher *tfm, unsigned char *outval,
+			  const struct drbg_string *in, u8 blocklen_bytes);
+
+static void drbg_kcapi_symsetkey(struct crypto_cipher *tfm,
+				 const unsigned char *key, u8 keylen)
+{
+	crypto_cipher_setkey(tfm, key, keylen);
+}
+
+static int drbg_kcapi_sym(struct crypto_cipher *tfm, unsigned char *outval,
+			  const struct drbg_string *in, u8 blocklen_bytes)
+{
+	/* there is only component in *in */
+	BUG_ON(in->len < blocklen_bytes);
+	crypto_cipher_encrypt_one(tfm, outval, in->buf);
+	return 0;
+}
+
+/* BCC function for CTR DRBG as defined in 10.4.3 */
+
+static int drbg_ctr_bcc(struct crypto_cipher *tfm,
+			unsigned char *out, const unsigned char *key,
+			struct list_head *in,
+			u8 blocklen_bytes,
+			u8 keylen)
+{
+	int ret = 0;
+	struct drbg_string *curr = NULL;
+	struct drbg_string data;
+	short cnt = 0;
+
+	drbg_string_fill(&data, out, blocklen_bytes);
+
+	/* 10.4.3 step 2 / 4 */
+	drbg_kcapi_symsetkey(tfm, key, keylen);
+	list_for_each_entry(curr, in, list) {
+		const unsigned char *pos = curr->buf;
+		size_t len = curr->len;
+		/* 10.4.3 step 4.1 */
+		while (len) {
+			/* 10.4.3 step 4.2 */
+			if (blocklen_bytes == cnt) {
+				cnt = 0;
+				ret = drbg_kcapi_sym(tfm, out, &data, blocklen_bytes);
+				if (ret)
+					return ret;
+			}
+			out[cnt] ^= *pos;
+			pos++;
+			cnt++;
+			len--;
+		}
+	}
+	/* 10.4.3 step 4.2 for last block */
+	if (cnt)
+		ret = drbg_kcapi_sym(tfm, out, &data, blocklen_bytes);
+
+	return ret;
+}
+
+/*
+ * scratchpad usage: drbg_ctr_update is interlinked with crypto_drbg_ctr_df
+ * (and drbg_ctr_bcc, but this function does not need any temporary buffers),
+ * the scratchpad is used as follows:
+ * drbg_ctr_update:
+ *	temp
+ *		start: drbg->scratchpad
+ *		length: drbg_statelen(drbg) + drbg_blocklen(drbg)
+ *			note: the cipher writing into this variable works
+ *			blocklen-wise. Now, when the statelen is not a multiple
+ *			of blocklen, the generateion loop below "spills over"
+ *			by at most blocklen. Thus, we need to give sufficient
+ *			memory.
+ *	df_data
+ *		start: drbg->scratchpad +
+ *				drbg_statelen(drbg) + drbg_blocklen(drbg)
+ *		length: drbg_statelen(drbg)
+ *
+ * crypto_drbg_ctr_df:
+ *	pad
+ *		start: df_data + drbg_statelen(drbg)
+ *		length: drbg_blocklen(drbg)
+ *	iv
+ *		start: pad + drbg_blocklen(drbg)
+ *		length: drbg_blocklen(drbg)
+ *	temp
+ *		start: iv + drbg_blocklen(drbg)
+ *		length: drbg_satelen(drbg) + drbg_blocklen(drbg)
+ *			note: temp is the buffer that the BCC function operates
+ *			on. BCC operates blockwise. drbg_statelen(drbg)
+ *			is sufficient when the DRBG state length is a multiple
+ *			of the block size. For AES192 (and maybe other ciphers)
+ *			this is not correct and the length for temp is
+ *			insufficient (yes, that also means for such ciphers,
+ *			the final output of all BCC rounds are truncated).
+ *			Therefore, add drbg_blocklen(drbg) to cover all
+ *			possibilities.
+ * refer to crypto_drbg_ctr_df_datalen() to get required length
+ */
+
+/* Derivation Function for CTR DRBG as defined in 10.4.2 */
+int crypto_drbg_ctr_df(struct crypto_cipher *tfm,
+		       unsigned char *df_data, size_t bytes_to_return,
+		       struct list_head *seedlist,
+		       u8 blocklen_bytes,
+		       u8 statelen)
+{
+	int ret = -EFAULT;
+	unsigned char L_N[8];
+	/* S3 is input */
+	struct drbg_string S1, S2, S4, cipherin;
+	LIST_HEAD(bcc_list);
+	unsigned char *pad = df_data + statelen;
+	unsigned char *iv = pad + blocklen_bytes;
+	unsigned char *temp = iv + blocklen_bytes;
+	size_t padlen = 0;
+	unsigned int templen = 0;
+	/* 10.4.2 step 7 */
+	unsigned int i = 0;
+	/* 10.4.2 step 8 */
+	const unsigned char *K = (unsigned char *)
+			   "\x00\x01\x02\x03\x04\x05\x06\x07"
+			   "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			   "\x10\x11\x12\x13\x14\x15\x16\x17"
+			   "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f";
+	unsigned char *X;
+	size_t generated_len = 0;
+	size_t inputlen = 0;
+	struct drbg_string *seed = NULL;
+	u8 keylen;
+
+	memset(pad, 0, blocklen_bytes);
+	memset(iv, 0, blocklen_bytes);
+	keylen = statelen - blocklen_bytes;
+	/* 10.4.2 step 1 is implicit as we work byte-wise */
+
+	/* 10.4.2 step 2 */
+	if ((512 / 8) < bytes_to_return)
+		return -EINVAL;
+
+	/* 10.4.2 step 2 -- calculate the entire length of all input data */
+	list_for_each_entry(seed, seedlist, list)
+		inputlen += seed->len;
+	drbg_cpu_to_be32(inputlen, &L_N[0]);
+
+	/* 10.4.2 step 3 */
+	drbg_cpu_to_be32(bytes_to_return, &L_N[4]);
+
+	/* 10.4.2 step 5: length is L_N, input_string, one byte, padding */
+	padlen = (inputlen + sizeof(L_N) + 1) % (blocklen_bytes);
+	/* wrap the padlen appropriately */
+	if (padlen)
+		padlen = blocklen_bytes - padlen;
+	/*
+	 * pad / padlen contains the 0x80 byte and the following zero bytes.
+	 * As the calculated padlen value only covers the number of zero
+	 * bytes, this value has to be incremented by one for the 0x80 byte.
+	 */
+	padlen++;
+	pad[0] = 0x80;
+
+	/* 10.4.2 step 4 -- first fill the linked list and then order it */
+	drbg_string_fill(&S1, iv, blocklen_bytes);
+	list_add_tail(&S1.list, &bcc_list);
+	drbg_string_fill(&S2, L_N, sizeof(L_N));
+	list_add_tail(&S2.list, &bcc_list);
+	list_splice_tail(seedlist, &bcc_list);
+	drbg_string_fill(&S4, pad, padlen);
+	list_add_tail(&S4.list, &bcc_list);
+
+	/* 10.4.2 step 9 */
+	while (templen < (keylen + (blocklen_bytes))) {
+		/*
+		 * 10.4.2 step 9.1 - the padding is implicit as the buffer
+		 * holds zeros after allocation -- even the increment of i
+		 * is irrelevant as the increment remains within length of i
+		 */
+		drbg_cpu_to_be32(i, iv);
+		/* 10.4.2 step 9.2 -- BCC and concatenation with temp */
+		ret = drbg_ctr_bcc(tfm, temp + templen, K, &bcc_list,
+				   blocklen_bytes, keylen);
+		if (ret)
+			goto out;
+		/* 10.4.2 step 9.3 */
+		i++;
+		templen += blocklen_bytes;
+	}
+
+	/* 10.4.2 step 11 */
+	X = temp + (keylen);
+	drbg_string_fill(&cipherin, X, blocklen_bytes);
+
+	/* 10.4.2 step 12: overwriting of outval is implemented in next step */
+
+	/* 10.4.2 step 13 */
+	drbg_kcapi_symsetkey(tfm, temp, keylen);
+	while (generated_len < bytes_to_return) {
+		short blocklen = 0;
+		/*
+		 * 10.4.2 step 13.1: the truncation of the key length is
+		 * implicit as the key is only drbg_blocklen in size based on
+		 * the implementation of the cipher function callback
+		 */
+		ret = drbg_kcapi_sym(tfm, X, &cipherin, blocklen_bytes);
+		if (ret)
+			goto out;
+		blocklen = (blocklen_bytes <
+				(bytes_to_return - generated_len)) ?
+			    blocklen_bytes :
+				(bytes_to_return - generated_len);
+		/* 10.4.2 step 13.2 and 14 */
+		memcpy(df_data + generated_len, X, blocklen);
+		generated_len += blocklen;
+	}
+
+	ret = 0;
+
+out:
+	memset(iv, 0, blocklen_bytes);
+	memset(temp, 0, statelen + blocklen_bytes);
+	memset(pad, 0, blocklen_bytes);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_drbg_ctr_df);
+
+MODULE_IMPORT_NS("CRYPTO_INTERNAL");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
+MODULE_DESCRIPTION("Derivation Function conformant to SP800-90A");
diff --git a/crypto/drbg.c b/crypto/drbg.c
index dbe4c8bb5ceb..bad005eef03d 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -98,6 +98,7 @@
  */
 
 #include <crypto/drbg.h>
+#include <crypto/df_sp80090a.h>
 #include <crypto/internal/cipher.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
@@ -261,26 +262,6 @@ static int drbg_fips_continuous_test(struct drbg_state *drbg,
 	return 0;
 }
 
-/*
- * Convert an integer into a byte representation of this integer.
- * The byte representation is big-endian
- *
- * @val value to be converted
- * @buf buffer holding the converted integer -- caller must ensure that
- *      buffer size is at least 32 bit
- */
-#if (defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_CTR))
-static inline void drbg_cpu_to_be32(__u32 val, unsigned char *buf)
-{
-	struct s {
-		__be32 conv;
-	};
-	struct s *conversion = (struct s *) buf;
-
-	conversion->conv = cpu_to_be32(val);
-}
-#endif /* defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_CTR) */
-
 /******************************************************************
  * CTR DRBG callback functions
  ******************************************************************/
@@ -294,10 +275,6 @@ MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes192");
 MODULE_ALIAS_CRYPTO("drbg_pr_ctr_aes128");
 MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes128");
 
-static void drbg_kcapi_symsetkey(struct drbg_state *drbg,
-				 const unsigned char *key);
-static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *outval,
-			  const struct drbg_string *in);
 static int drbg_init_sym_kernel(struct drbg_state *drbg);
 static int drbg_fini_sym_kernel(struct drbg_state *drbg);
 static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
@@ -305,202 +282,12 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
 			      u8 *outbuf, u32 outlen);
 #define DRBG_OUTSCRATCHLEN 256
 
-/* BCC function for CTR DRBG as defined in 10.4.3 */
-static int drbg_ctr_bcc(struct drbg_state *drbg,
-			unsigned char *out, const unsigned char *key,
-			struct list_head *in)
-{
-	int ret = 0;
-	struct drbg_string *curr = NULL;
-	struct drbg_string data;
-	short cnt = 0;
-
-	drbg_string_fill(&data, out, drbg_blocklen(drbg));
-
-	/* 10.4.3 step 2 / 4 */
-	drbg_kcapi_symsetkey(drbg, key);
-	list_for_each_entry(curr, in, list) {
-		const unsigned char *pos = curr->buf;
-		size_t len = curr->len;
-		/* 10.4.3 step 4.1 */
-		while (len) {
-			/* 10.4.3 step 4.2 */
-			if (drbg_blocklen(drbg) == cnt) {
-				cnt = 0;
-				ret = drbg_kcapi_sym(drbg, out, &data);
-				if (ret)
-					return ret;
-			}
-			out[cnt] ^= *pos;
-			pos++;
-			cnt++;
-			len--;
-		}
-	}
-	/* 10.4.3 step 4.2 for last block */
-	if (cnt)
-		ret = drbg_kcapi_sym(drbg, out, &data);
-
-	return ret;
-}
-
-/*
- * scratchpad usage: drbg_ctr_update is interlinked with drbg_ctr_df
- * (and drbg_ctr_bcc, but this function does not need any temporary buffers),
- * the scratchpad is used as follows:
- * drbg_ctr_update:
- *	temp
- *		start: drbg->scratchpad
- *		length: drbg_statelen(drbg) + drbg_blocklen(drbg)
- *			note: the cipher writing into this variable works
- *			blocklen-wise. Now, when the statelen is not a multiple
- *			of blocklen, the generateion loop below "spills over"
- *			by at most blocklen. Thus, we need to give sufficient
- *			memory.
- *	df_data
- *		start: drbg->scratchpad +
- *				drbg_statelen(drbg) + drbg_blocklen(drbg)
- *		length: drbg_statelen(drbg)
- *
- * drbg_ctr_df:
- *	pad
- *		start: df_data + drbg_statelen(drbg)
- *		length: drbg_blocklen(drbg)
- *	iv
- *		start: pad + drbg_blocklen(drbg)
- *		length: drbg_blocklen(drbg)
- *	temp
- *		start: iv + drbg_blocklen(drbg)
- *		length: drbg_satelen(drbg) + drbg_blocklen(drbg)
- *			note: temp is the buffer that the BCC function operates
- *			on. BCC operates blockwise. drbg_statelen(drbg)
- *			is sufficient when the DRBG state length is a multiple
- *			of the block size. For AES192 (and maybe other ciphers)
- *			this is not correct and the length for temp is
- *			insufficient (yes, that also means for such ciphers,
- *			the final output of all BCC rounds are truncated).
- *			Therefore, add drbg_blocklen(drbg) to cover all
- *			possibilities.
- */
-
-/* Derivation Function for CTR DRBG as defined in 10.4.2 */
 static int drbg_ctr_df(struct drbg_state *drbg,
 		       unsigned char *df_data, size_t bytes_to_return,
 		       struct list_head *seedlist)
 {
-	int ret = -EFAULT;
-	unsigned char L_N[8];
-	/* S3 is input */
-	struct drbg_string S1, S2, S4, cipherin;
-	LIST_HEAD(bcc_list);
-	unsigned char *pad = df_data + drbg_statelen(drbg);
-	unsigned char *iv = pad + drbg_blocklen(drbg);
-	unsigned char *temp = iv + drbg_blocklen(drbg);
-	size_t padlen = 0;
-	unsigned int templen = 0;
-	/* 10.4.2 step 7 */
-	unsigned int i = 0;
-	/* 10.4.2 step 8 */
-	const unsigned char *K = (unsigned char *)
-			   "\x00\x01\x02\x03\x04\x05\x06\x07"
-			   "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
-			   "\x10\x11\x12\x13\x14\x15\x16\x17"
-			   "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f";
-	unsigned char *X;
-	size_t generated_len = 0;
-	size_t inputlen = 0;
-	struct drbg_string *seed = NULL;
-
-	memset(pad, 0, drbg_blocklen(drbg));
-	memset(iv, 0, drbg_blocklen(drbg));
-
-	/* 10.4.2 step 1 is implicit as we work byte-wise */
-
-	/* 10.4.2 step 2 */
-	if ((512/8) < bytes_to_return)
-		return -EINVAL;
-
-	/* 10.4.2 step 2 -- calculate the entire length of all input data */
-	list_for_each_entry(seed, seedlist, list)
-		inputlen += seed->len;
-	drbg_cpu_to_be32(inputlen, &L_N[0]);
-
-	/* 10.4.2 step 3 */
-	drbg_cpu_to_be32(bytes_to_return, &L_N[4]);
-
-	/* 10.4.2 step 5: length is L_N, input_string, one byte, padding */
-	padlen = (inputlen + sizeof(L_N) + 1) % (drbg_blocklen(drbg));
-	/* wrap the padlen appropriately */
-	if (padlen)
-		padlen = drbg_blocklen(drbg) - padlen;
-	/*
-	 * pad / padlen contains the 0x80 byte and the following zero bytes.
-	 * As the calculated padlen value only covers the number of zero
-	 * bytes, this value has to be incremented by one for the 0x80 byte.
-	 */
-	padlen++;
-	pad[0] = 0x80;
-
-	/* 10.4.2 step 4 -- first fill the linked list and then order it */
-	drbg_string_fill(&S1, iv, drbg_blocklen(drbg));
-	list_add_tail(&S1.list, &bcc_list);
-	drbg_string_fill(&S2, L_N, sizeof(L_N));
-	list_add_tail(&S2.list, &bcc_list);
-	list_splice_tail(seedlist, &bcc_list);
-	drbg_string_fill(&S4, pad, padlen);
-	list_add_tail(&S4.list, &bcc_list);
-
-	/* 10.4.2 step 9 */
-	while (templen < (drbg_keylen(drbg) + (drbg_blocklen(drbg)))) {
-		/*
-		 * 10.4.2 step 9.1 - the padding is implicit as the buffer
-		 * holds zeros after allocation -- even the increment of i
-		 * is irrelevant as the increment remains within length of i
-		 */
-		drbg_cpu_to_be32(i, iv);
-		/* 10.4.2 step 9.2 -- BCC and concatenation with temp */
-		ret = drbg_ctr_bcc(drbg, temp + templen, K, &bcc_list);
-		if (ret)
-			goto out;
-		/* 10.4.2 step 9.3 */
-		i++;
-		templen += drbg_blocklen(drbg);
-	}
-
-	/* 10.4.2 step 11 */
-	X = temp + (drbg_keylen(drbg));
-	drbg_string_fill(&cipherin, X, drbg_blocklen(drbg));
-
-	/* 10.4.2 step 12: overwriting of outval is implemented in next step */
-
-	/* 10.4.2 step 13 */
-	drbg_kcapi_symsetkey(drbg, temp);
-	while (generated_len < bytes_to_return) {
-		short blocklen = 0;
-		/*
-		 * 10.4.2 step 13.1: the truncation of the key length is
-		 * implicit as the key is only drbg_blocklen in size based on
-		 * the implementation of the cipher function callback
-		 */
-		ret = drbg_kcapi_sym(drbg, X, &cipherin);
-		if (ret)
-			goto out;
-		blocklen = (drbg_blocklen(drbg) <
-				(bytes_to_return - generated_len)) ?
-			    drbg_blocklen(drbg) :
-				(bytes_to_return - generated_len);
-		/* 10.4.2 step 13.2 and 14 */
-		memcpy(df_data + generated_len, X, blocklen);
-		generated_len += blocklen;
-	}
-
-	ret = 0;
-
-out:
-	memset(iv, 0, drbg_blocklen(drbg));
-	memset(temp, 0, drbg_statelen(drbg) + drbg_blocklen(drbg));
-	memset(pad, 0, drbg_blocklen(drbg));
-	return ret;
+	return crypto_drbg_ctr_df(drbg->priv_data, df_data, drbg_statelen(drbg),
+				  seedlist, drbg_blocklen(drbg), drbg_statelen(drbg));
 }
 
 /*
@@ -1310,10 +1097,8 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 		sb_size = 0;
 	else if (drbg->core->flags & DRBG_CTR)
 		sb_size = drbg_statelen(drbg) + drbg_blocklen(drbg) + /* temp */
-			  drbg_statelen(drbg) +	/* df_data */
-			  drbg_blocklen(drbg) +	/* pad */
-			  drbg_blocklen(drbg) +	/* iv */
-			  drbg_statelen(drbg) + drbg_blocklen(drbg); /* temp */
+			  crypto_drbg_ctr_df_datalen(drbg_statelen(drbg),
+						     drbg_blocklen(drbg));
 	else
 		sb_size = drbg_statelen(drbg) + drbg_blocklen(drbg);
 
@@ -1800,25 +1585,6 @@ static int drbg_init_sym_kernel(struct drbg_state *drbg)
 	return alignmask;
 }
 
-static void drbg_kcapi_symsetkey(struct drbg_state *drbg,
-				 const unsigned char *key)
-{
-	struct crypto_cipher *tfm = drbg->priv_data;
-
-	crypto_cipher_setkey(tfm, key, (drbg_keylen(drbg)));
-}
-
-static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *outval,
-			  const struct drbg_string *in)
-{
-	struct crypto_cipher *tfm = drbg->priv_data;
-
-	/* there is only component in *in */
-	BUG_ON(in->len < drbg_blocklen(drbg));
-	crypto_cipher_encrypt_one(tfm, outval, in->buf);
-	return 0;
-}
-
 static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
 			      u8 *inbuf, u32 inlen,
 			      u8 *outbuf, u32 outlen)
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 53eedc0dea4d..78557bff0753 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -728,6 +728,7 @@ config CRYPTO_DEV_TEGRA
 config CRYPTO_DEV_XILINX_TRNG
 	tristate "Support for Xilinx True Random Generator"
 	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
+	select CRYPTO_DF80090A
 	select CRYPTO_RNG
 	select HW_RANDOM
 	help
diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
index 989d2dbee124..ce765a3c722e 100644
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -7,6 +7,8 @@
 #include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/crypto.h>
+#include <crypto/df_sp80090a.h>
+#include <crypto/drbg.h>
 #include <linux/firmware/xlnx-zynqmp.h>
 #include <linux/hw_random.h>
 #include <linux/io.h>
@@ -56,6 +58,8 @@
 struct xilinx_rng {
 	void __iomem *rng_base;
 	struct device *dev;
+	unsigned char *scratchpadbuf;
+	struct crypto_cipher *tfm;
 	struct mutex lock;	/* Protect access to TRNG device */
 	struct hwrng trng;
 };
@@ -179,9 +183,13 @@ static void xtrng_enable_entropy(struct xilinx_rng *rng)
 static int xtrng_reseed_internal(struct xilinx_rng *rng)
 {
 	u8 entropy[TRNG_ENTROPY_SEED_LEN_BYTES];
+	struct drbg_string data;
+	LIST_HEAD(seedlist);
 	u32 val;
 	int ret;
 
+	drbg_string_fill(&data, entropy, TRNG_SEED_LEN_BYTES);
+	list_add_tail(&data.list, &seedlist);
 	memset(entropy, 0, sizeof(entropy));
 	xtrng_enable_entropy(rng);
 
@@ -189,9 +197,14 @@ static int xtrng_reseed_internal(struct xilinx_rng *rng)
 	ret = xtrng_collect_random_data(rng, entropy, TRNG_SEED_LEN_BYTES, true);
 	if (ret != TRNG_SEED_LEN_BYTES)
 		return -EINVAL;
+	ret = crypto_drbg_ctr_df(rng->tfm, rng->scratchpadbuf,
+				 TRNG_SEED_LEN_BYTES, &seedlist, AES_BLOCK_SIZE,
+				 TRNG_SEED_LEN_BYTES);
+	if (ret)
+		return ret;
 
 	xtrng_write_multiple_registers(rng->rng_base + TRNG_EXT_SEED_OFFSET,
-				       (u32 *)entropy, TRNG_NUM_INIT_REGS);
+				       (u32 *)rng->scratchpadbuf, TRNG_NUM_INIT_REGS);
 	/* select reseed operation */
 	iowrite32(TRNG_CTRL_PRNGXS_MASK, rng->rng_base + TRNG_CTRL_OFFSET);
 
@@ -321,6 +334,7 @@ static void xtrng_hwrng_unregister(struct hwrng *trng)
 static int xtrng_probe(struct platform_device *pdev)
 {
 	struct xilinx_rng *rng;
+	size_t sb_size;
 	int ret;
 
 	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
@@ -334,11 +348,24 @@ static int xtrng_probe(struct platform_device *pdev)
 		return PTR_ERR(rng->rng_base);
 	}
 
+	rng->tfm = crypto_alloc_cipher("aes", 0, 0);
+	if (IS_ERR(rng->tfm)) {
+		pr_info("DRBG: could not allocate cipher TFM handle:\n");
+		return PTR_ERR(rng->tfm);
+	}
+
+	sb_size = crypto_drbg_ctr_df_datalen(TRNG_SEED_LEN_BYTES, AES_BLOCK_SIZE);
+	rng->scratchpadbuf = devm_kzalloc(&pdev->dev, sb_size, GFP_KERNEL);
+	if (!rng->scratchpadbuf) {
+		ret = -ENOMEM;
+		goto cipher_cleanup;
+	}
+
 	xtrng_trng_reset(rng->rng_base);
 	ret = xtrng_reseed_internal(rng);
 	if (ret) {
 		dev_err(&pdev->dev, "TRNG Seed fail\n");
-		return ret;
+		goto cipher_cleanup;
 	}
 
 	xilinx_rng_dev = rng;
@@ -346,8 +373,9 @@ static int xtrng_probe(struct platform_device *pdev)
 	ret = crypto_register_rng(&xtrng_trng_alg);
 	if (ret) {
 		dev_err(&pdev->dev, "Crypto Random device registration failed: %d\n", ret);
-		return ret;
+		goto cipher_cleanup;
 	}
+
 	ret = xtrng_hwrng_register(&rng->trng);
 	if (ret) {
 		dev_err(&pdev->dev, "HWRNG device registration failed: %d\n", ret);
@@ -360,6 +388,9 @@ static int xtrng_probe(struct platform_device *pdev)
 crypto_rng_free:
 	crypto_unregister_rng(&xtrng_trng_alg);
 
+cipher_cleanup:
+	crypto_free_cipher(rng->tfm);
+
 	return ret;
 }
 
@@ -371,6 +402,7 @@ static void xtrng_remove(struct platform_device *pdev)
 	rng = platform_get_drvdata(pdev);
 	xtrng_hwrng_unregister(&rng->trng);
 	crypto_unregister_rng(&xtrng_trng_alg);
+	crypto_free_cipher(rng->tfm);
 	xtrng_write_multiple_registers(rng->rng_base + TRNG_EXT_SEED_OFFSET, zero,
 				       TRNG_NUM_INIT_REGS);
 	xtrng_write_multiple_registers(rng->rng_base + TRNG_PER_STRNG_OFFSET, zero,
diff --git a/include/crypto/df_sp80090a.h b/include/crypto/df_sp80090a.h
new file mode 100644
index 000000000000..182865538662
--- /dev/null
+++ b/include/crypto/df_sp80090a.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright Stephan Mueller <smueller@chronox.de>, 2014
+ */
+
+#ifndef _CRYPTO_DF80090A_H
+#define _CRYPTO_DF80090A_H
+
+#include <crypto/internal/cipher.h>
+
+static inline int crypto_drbg_ctr_df_datalen(u8 statelen, u8 blocklen)
+{
+	return statelen +       /* df_data */
+		blocklen +      /* pad */
+		blocklen +      /* iv */
+		statelen + blocklen;  /* temp */
+}
+
+int crypto_drbg_ctr_df(struct crypto_cipher *tfm,
+		       unsigned char *df_data,
+		       size_t bytes_to_return,
+		       struct list_head *seedlist,
+		       u8 blocklen_bytes,
+		       u8 statelen);
+
+#endif /* _CRYPTO_DF80090A_H */
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index af5ad51d3eef..4234f15d74be 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -144,6 +144,24 @@ struct drbg_state {
 	struct drbg_string test_data;
 };
 
+/*
+ * Convert an integer into a byte representation of this integer.
+ * The byte representation is big-endian
+ *
+ * @val value to be converted
+ * @buf buffer holding the converted integer -- caller must ensure that
+ *      buffer size is at least 32 bit
+ */
+static inline void drbg_cpu_to_be32(__u32 val, unsigned char *buf)
+{
+        struct s {
+                __be32 conv;
+        };
+        struct s *conversion = (struct s *) buf;
+
+        conversion->conv = cpu_to_be32(val);
+}
+
 static inline __u8 drbg_statelen(struct drbg_state *drbg)
 {
 	if (drbg && drbg->core)
-- 
2.34.1

