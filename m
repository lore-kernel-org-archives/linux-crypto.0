Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C13719AD70;
	Mon,  9 Jun 2025 04:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749444699; cv=fail; b=TSL0rBrxkkyWjo/m9COrTLZkoKLcIG4ISSJK87vsZ4E46Hp4QgvYicGTj0K5zt/fYgRiYRV1hytTCncf3UUMNWsRh1BN18PA5iNHxGBNVToL1lHyIXwDsfc9o0A/GCSfP4xsC1mcMnO7CXQT52xUWtA2mA8x9TCd+dVQAeSGJrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749444699; c=relaxed/simple;
	bh=MoI5QoDfZPxXPpY63QdCyXKdQQGXxZM94BedQ9p1wJU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GCo5EZN6wTdxDlpW6hRC5gWAcJKhQxlfGWMApuWY+lvbHRz0yzO8LtBoHmju9SAxzWgfLCTDUhd3mJeyZFhdSPffKw0fI6H4Zf9mtebzsaUFieO/P6c9MbAgBxGqaKFJCb5+dF/UQVMqWSvyztLP75OqMTUBtK8u0h6tF84prqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DFZaN/Zn; arc=fail smtp.client-ip=40.107.244.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DFZaN/Zn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z8yOrkc9is13rROcgbWGuNgbYpm270B1tUQGeQcn2a9vS8ETUKSeL1OjjBKph6Lb/LsX+DNPZ3h1zykLHbXhVOHyBXUHZkHn9aLHhY/EbGdXGMelGAhvER3BWJruCgnWPZYXULS3301u+xSzPJqmTINlMEdkypIbg3gB+RkM6qAfM1r3W8k31busSvQfph1PBTbPBiQ+CRLEubZ0k9Srb4lXdXU/yxEOEODF/wZa/WBCXnbDlqshW89H5iWe61wtWsBnVNU7412jfdTcpiQYeW6pH4NkHo4N5W7vd6MovHoYnmOTvFpZWm2Tb3tpZNxRpsM1677rFjV65wP9Az3taw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TUHpRqDKxmGsQCLJlc0SNCuvSYql0lFht/UId3+I7mA=;
 b=N+AxbbaqZxWnqb49LsuGbIS/XigFoRgwQiJhgfm/WBP2O8cXN5xFqajmX+2k3wHcPrzeAGOLqirTuaTW9GBQFEJCIyCNiwB/sNRQ4CAhgPyODmyFWsZL4+1Pjj7iO6+BFHIVZEJNkDuoXMNOKSpKp+TKYggEQhQLFGy+9p3+aAlipFDDO5AWfdJbLSrjiUF9LQqoHcNoKEUzHt94BX1bzB6aBF9tyr5buV7I04fJqX4yZJVpWd12q2c88o530miIREBio7tpyeZMGxX2aWyA5/CMTCP3EHOBkCOu/gj2P32WYw3eRolJNZ4fT+CM3cYMZrMnHcqHt4sqqh4xRgwurg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUHpRqDKxmGsQCLJlc0SNCuvSYql0lFht/UId3+I7mA=;
 b=DFZaN/Zna8J50mLb7IwIUv5jqgLmp724N/DpM+NeHWeIk67+BveeNMaMhBVaJ8DASKPCmUFMV9ajyKjfQq8OYkwLbYBUH8t2EbBOas9RpzK/D31VX9HN8WA18NOkp1muB0XXPud3RLyT57PYC4U8xjovAFXl8O2tUxazsj79kjU=
Received: from DM6PR21CA0008.namprd21.prod.outlook.com (2603:10b6:5:174::18)
 by SJ5PPF0170DF9F2.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::985) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Mon, 9 Jun
 2025 04:51:33 +0000
Received: from CY4PEPF0000E9D8.namprd05.prod.outlook.com
 (2603:10b6:5:174:cafe::c0) by DM6PR21CA0008.outlook.office365.com
 (2603:10b6:5:174::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.16 via Frontend Transport; Mon,
 9 Jun 2025 04:51:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000E9D8.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 04:51:32 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Jun
 2025 23:51:31 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Jun
 2025 23:51:30 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 8 Jun 2025 23:51:28 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 3/6] crypto: drbg: Export CTR DRBG DF functions
Date: Mon, 9 Jun 2025 10:21:07 +0530
Message-ID: <20250609045110.1786634-4-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250609045110.1786634-1-h.jain@amd.com>
References: <20250609045110.1786634-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D8:EE_|SJ5PPF0170DF9F2:EE_
X-MS-Office365-Filtering-Correlation-Id: ea532df3-1c1a-40c8-e79d-08dda7114e0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N3y/UEN0s3pcQP6DSXcbgpwVWJdOLWZZvMbThJCfUBip9ze1V6cVCIKoHcw7?=
 =?us-ascii?Q?XrYBgCGD9BptMehM5i8pyFn09vAm6/FZ6eT4QPGySITca/wCjRkjukayTJI5?=
 =?us-ascii?Q?z0cmDe883cQon9fTMeLw2gfKucEYh/v5kp4Oc7L4FMWiFVovA0PffXiewJBl?=
 =?us-ascii?Q?HsAU68uGRlujcwSRMNM7ZZC6X4fW89V8G3cuURLVkTFX7cnKLbuo2HJIGemf?=
 =?us-ascii?Q?0eHiQSEXZiTkiEvOe625EbXtyDR3xITKls0jJ0BB+cSsHISE2K5hZOasvrk2?=
 =?us-ascii?Q?3L64TO5ZkLVvHVdfAzCrrAooP/2/uBbRGWo2Jjl/tVMdprRe8er0VRqa4cUx?=
 =?us-ascii?Q?xQPsc9wQK/4+6OYbyJ3JH+c1b2QYpuHg1bmEnZDO493aSqF4JQW9nxDNTiTN?=
 =?us-ascii?Q?St25QFi+fOqnsi+O5KXUfMbMhUriy3Q83x+qX7mzRlgBjSZk66E3t4WL2MGo?=
 =?us-ascii?Q?YDda7FpO4nylmxAu5bc1zO9Z7u7/PfTuhSf+CJqAOJFYcMX+pz4Gzdk6gIxQ?=
 =?us-ascii?Q?WE+/t0vSwSvVq0twTqZUHKMZRyD0eCEe7uFjxpM3psyRJGhabYXWU9S/dbmq?=
 =?us-ascii?Q?/8COGfNRJj3qmAd3TGXjb+CcpYC4bSS2z1X3GFvECCFAX3qCrJ1HVHhP9PGx?=
 =?us-ascii?Q?mSml7gpz3BPcRSKuqHYQb2uHOQ/zb5uU54ze2A07SZHPZYlVCmyaRmWsNI7m?=
 =?us-ascii?Q?uDkOvUum5nUJW0jJSA1fPmxMkjbTIDlE62F0A7+DPPwIOmaZtGmkW5CEqCtQ?=
 =?us-ascii?Q?oUxkLywgMmOYIuhiaByknu1uqi3NyOEYnxB9BejuWsvMTzn9R6cl/ZHW65Rz?=
 =?us-ascii?Q?TugdR0F5bx8CPEm+MjACfxdHxg8xbbtMdxE+ZEZ2CLG703e7oeLEFr/3dD4h?=
 =?us-ascii?Q?3CUQWolq3kadPXl1Zf+OOsajBWu334cvYrXs14+G/SqqYRjiiHJfg04LcFiU?=
 =?us-ascii?Q?75TimP3foBLreraKU2ZlnTiqvrUo9juHyxW2WYsDFlb3AupE6nKNJbm0HSZU?=
 =?us-ascii?Q?O3tNFuXJohSpzhd+9NfXVLxJza41oNH5VB3VdUq8DoSlWxn3krtO4hqsnarU?=
 =?us-ascii?Q?bPSJL1dU8m/Ymy5VtfkbNAkG/3PrNjLX6SaNH0FxAk7agUkOFBKeOAMLCuRz?=
 =?us-ascii?Q?MJityZY6ngv+DWCVnCssGCyKyZo2e6ZjXIHpNiBFYWgwqKZDgMg0O/nDRIQu?=
 =?us-ascii?Q?3cOOEK8qeXGEefx9IHxjLkDbapNhnfx+3/Vy+c1FHS8d6hI9TgpDzBej6lG8?=
 =?us-ascii?Q?YBklRtSHgmV1Wc+P8GYl3QTC/LaEuBjUvPxpiHrgA0bfiOQA3XiNDnhd327r?=
 =?us-ascii?Q?P/RKnc/kkF/Nt+S5IeNReFEi/p/YQsHDInNXGP1t3BeWOXCapuLdfanYi452?=
 =?us-ascii?Q?NuwcNSouhuSSMKDK+q3chUB+PQHyS/1ZUi/8/Vn9w233RUlaOTDZVyBA9zmU?=
 =?us-ascii?Q?41/5iepV9dT27tKgHO6qkelEB7p5vSG2ne6JvxuRUq5bKZPlZuFAuPBOynfR?=
 =?us-ascii?Q?Rv6FZxcmFhGk467ktD5mdmggY1WWovf6KZ4T?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 04:51:32.1290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea532df3-1c1a-40c8-e79d-08dda7114e0d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0170DF9F2

Export drbg_ctr_df() derivative function to re-use it in xilinx trng
driver. Changes has been tested by enabling CONFIG_CRYPTO_USER_API_RNG_CAVP

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 crypto/drbg.c                       | 108 +++++++++++++++-------------
 drivers/crypto/Kconfig              |   1 +
 drivers/crypto/xilinx/xilinx-trng.c |  30 +++++++-
 include/crypto/drbg.h               |  15 ++++
 4 files changed, 101 insertions(+), 53 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index dbe4c8bb5ceb..322c630c54b8 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -294,10 +294,11 @@ MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes192");
 MODULE_ALIAS_CRYPTO("drbg_pr_ctr_aes128");
 MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes128");
 
-static void drbg_kcapi_symsetkey(struct drbg_state *drbg,
-				 const unsigned char *key);
-static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *outval,
-			  const struct drbg_string *in);
+static void drbg_kcapi_symsetkey(struct crypto_cipher *tfm,
+				 const unsigned char *key,
+				 u8 keylen);
+static int drbg_kcapi_sym(struct crypto_cipher *tfm, unsigned char *outval,
+			  const struct drbg_string *in, u8 blocklen_bytes);
 static int drbg_init_sym_kernel(struct drbg_state *drbg);
 static int drbg_fini_sym_kernel(struct drbg_state *drbg);
 static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
@@ -306,28 +307,31 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
 #define DRBG_OUTSCRATCHLEN 256
 
 /* BCC function for CTR DRBG as defined in 10.4.3 */
-static int drbg_ctr_bcc(struct drbg_state *drbg,
+
+static int drbg_ctr_bcc(struct crypto_cipher *tfm,
 			unsigned char *out, const unsigned char *key,
-			struct list_head *in)
+			struct list_head *in,
+			u8 blocklen_bytes,
+			u8 keylen)
 {
 	int ret = 0;
 	struct drbg_string *curr = NULL;
 	struct drbg_string data;
 	short cnt = 0;
 
-	drbg_string_fill(&data, out, drbg_blocklen(drbg));
+	drbg_string_fill(&data, out, blocklen_bytes);
 
 	/* 10.4.3 step 2 / 4 */
-	drbg_kcapi_symsetkey(drbg, key);
+	drbg_kcapi_symsetkey(tfm, key, keylen);
 	list_for_each_entry(curr, in, list) {
 		const unsigned char *pos = curr->buf;
 		size_t len = curr->len;
 		/* 10.4.3 step 4.1 */
 		while (len) {
 			/* 10.4.3 step 4.2 */
-			if (drbg_blocklen(drbg) == cnt) {
+			if (blocklen_bytes == cnt) {
 				cnt = 0;
-				ret = drbg_kcapi_sym(drbg, out, &data);
+				ret = drbg_kcapi_sym(tfm, out, &data, blocklen_bytes);
 				if (ret)
 					return ret;
 			}
@@ -339,13 +343,13 @@ static int drbg_ctr_bcc(struct drbg_state *drbg,
 	}
 	/* 10.4.3 step 4.2 for last block */
 	if (cnt)
-		ret = drbg_kcapi_sym(drbg, out, &data);
+		ret = drbg_kcapi_sym(tfm, out, &data, blocklen_bytes);
 
 	return ret;
 }
 
 /*
- * scratchpad usage: drbg_ctr_update is interlinked with drbg_ctr_df
+ * scratchpad usage: drbg_ctr_update is interlinked with crypto_drbg_ctr_df
  * (and drbg_ctr_bcc, but this function does not need any temporary buffers),
  * the scratchpad is used as follows:
  * drbg_ctr_update:
@@ -362,7 +366,7 @@ static int drbg_ctr_bcc(struct drbg_state *drbg,
  *				drbg_statelen(drbg) + drbg_blocklen(drbg)
  *		length: drbg_statelen(drbg)
  *
- * drbg_ctr_df:
+ * crypto_drbg_ctr_df:
  *	pad
  *		start: df_data + drbg_statelen(drbg)
  *		length: drbg_blocklen(drbg)
@@ -381,21 +385,24 @@ static int drbg_ctr_bcc(struct drbg_state *drbg,
  *			the final output of all BCC rounds are truncated).
  *			Therefore, add drbg_blocklen(drbg) to cover all
  *			possibilities.
+ * refer to crypto_drbg_ctr_df_datalen() to get required length
  */
 
 /* Derivation Function for CTR DRBG as defined in 10.4.2 */
-static int drbg_ctr_df(struct drbg_state *drbg,
+int crypto_drbg_ctr_df(struct crypto_cipher *tfm,
 		       unsigned char *df_data, size_t bytes_to_return,
-		       struct list_head *seedlist)
+		       struct list_head *seedlist,
+		       u8 blocklen_bytes,
+		       u8 statelen)
 {
 	int ret = -EFAULT;
 	unsigned char L_N[8];
 	/* S3 is input */
 	struct drbg_string S1, S2, S4, cipherin;
 	LIST_HEAD(bcc_list);
-	unsigned char *pad = df_data + drbg_statelen(drbg);
-	unsigned char *iv = pad + drbg_blocklen(drbg);
-	unsigned char *temp = iv + drbg_blocklen(drbg);
+	unsigned char *pad = df_data + statelen;
+	unsigned char *iv = pad + blocklen_bytes;
+	unsigned char *temp = iv + blocklen_bytes;
 	size_t padlen = 0;
 	unsigned int templen = 0;
 	/* 10.4.2 step 7 */
@@ -410,10 +417,11 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 	size_t generated_len = 0;
 	size_t inputlen = 0;
 	struct drbg_string *seed = NULL;
+	u8 keylen;
 
-	memset(pad, 0, drbg_blocklen(drbg));
-	memset(iv, 0, drbg_blocklen(drbg));
-
+	memset(pad, 0, blocklen_bytes);
+	memset(iv, 0, blocklen_bytes);
+	keylen = statelen - blocklen_bytes;
 	/* 10.4.2 step 1 is implicit as we work byte-wise */
 
 	/* 10.4.2 step 2 */
@@ -429,10 +437,10 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 	drbg_cpu_to_be32(bytes_to_return, &L_N[4]);
 
 	/* 10.4.2 step 5: length is L_N, input_string, one byte, padding */
-	padlen = (inputlen + sizeof(L_N) + 1) % (drbg_blocklen(drbg));
+	padlen = (inputlen + sizeof(L_N) + 1) % (blocklen_bytes);
 	/* wrap the padlen appropriately */
 	if (padlen)
-		padlen = drbg_blocklen(drbg) - padlen;
+		padlen = blocklen_bytes - padlen;
 	/*
 	 * pad / padlen contains the 0x80 byte and the following zero bytes.
 	 * As the calculated padlen value only covers the number of zero
@@ -442,7 +450,7 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 	pad[0] = 0x80;
 
 	/* 10.4.2 step 4 -- first fill the linked list and then order it */
-	drbg_string_fill(&S1, iv, drbg_blocklen(drbg));
+	drbg_string_fill(&S1, iv, blocklen_bytes);
 	list_add_tail(&S1.list, &bcc_list);
 	drbg_string_fill(&S2, L_N, sizeof(L_N));
 	list_add_tail(&S2.list, &bcc_list);
@@ -451,7 +459,7 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 	list_add_tail(&S4.list, &bcc_list);
 
 	/* 10.4.2 step 9 */
-	while (templen < (drbg_keylen(drbg) + (drbg_blocklen(drbg)))) {
+	while (templen < (keylen + (blocklen_bytes))) {
 		/*
 		 * 10.4.2 step 9.1 - the padding is implicit as the buffer
 		 * holds zeros after allocation -- even the increment of i
@@ -459,22 +467,23 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 		 */
 		drbg_cpu_to_be32(i, iv);
 		/* 10.4.2 step 9.2 -- BCC and concatenation with temp */
-		ret = drbg_ctr_bcc(drbg, temp + templen, K, &bcc_list);
+		ret = drbg_ctr_bcc(tfm, temp + templen, K, &bcc_list,
+				   blocklen_bytes, keylen);
 		if (ret)
 			goto out;
 		/* 10.4.2 step 9.3 */
 		i++;
-		templen += drbg_blocklen(drbg);
+		templen += blocklen_bytes;
 	}
 
 	/* 10.4.2 step 11 */
-	X = temp + (drbg_keylen(drbg));
-	drbg_string_fill(&cipherin, X, drbg_blocklen(drbg));
+	X = temp + (keylen);
+	drbg_string_fill(&cipherin, X, blocklen_bytes);
 
 	/* 10.4.2 step 12: overwriting of outval is implemented in next step */
 
 	/* 10.4.2 step 13 */
-	drbg_kcapi_symsetkey(drbg, temp);
+	drbg_kcapi_symsetkey(tfm, temp, keylen);
 	while (generated_len < bytes_to_return) {
 		short blocklen = 0;
 		/*
@@ -482,12 +491,12 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 		 * implicit as the key is only drbg_blocklen in size based on
 		 * the implementation of the cipher function callback
 		 */
-		ret = drbg_kcapi_sym(drbg, X, &cipherin);
+		ret = drbg_kcapi_sym(tfm, X, &cipherin, blocklen_bytes);
 		if (ret)
 			goto out;
-		blocklen = (drbg_blocklen(drbg) <
+		blocklen = (blocklen_bytes <
 				(bytes_to_return - generated_len)) ?
-			    drbg_blocklen(drbg) :
+			    blocklen_bytes :
 				(bytes_to_return - generated_len);
 		/* 10.4.2 step 13.2 and 14 */
 		memcpy(df_data + generated_len, X, blocklen);
@@ -497,11 +506,12 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 	ret = 0;
 
 out:
-	memset(iv, 0, drbg_blocklen(drbg));
-	memset(temp, 0, drbg_statelen(drbg) + drbg_blocklen(drbg));
-	memset(pad, 0, drbg_blocklen(drbg));
+	memset(iv, 0, blocklen_bytes);
+	memset(temp, 0, statelen + blocklen_bytes);
+	memset(pad, 0, blocklen_bytes);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(crypto_drbg_ctr_df);
 
 /*
  * update function of CTR DRBG as defined in 10.2.1.2
@@ -548,7 +558,9 @@ static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
 
 	/* 10.2.1.3.2 step 2 and 10.2.1.4.2 step 2 */
 	if (seed) {
-		ret = drbg_ctr_df(drbg, df_data, drbg_statelen(drbg), seed);
+		ret = crypto_drbg_ctr_df(drbg->priv_data, df_data, drbg_statelen(drbg), seed,
+					 drbg_blocklen(drbg),
+					 drbg_statelen(drbg));
 		if (ret)
 			goto out;
 	}
@@ -1310,10 +1322,8 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
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
 
@@ -1800,21 +1810,17 @@ static int drbg_init_sym_kernel(struct drbg_state *drbg)
 	return alignmask;
 }
 
-static void drbg_kcapi_symsetkey(struct drbg_state *drbg,
-				 const unsigned char *key)
+static void drbg_kcapi_symsetkey(struct crypto_cipher *tfm,
+				 const unsigned char *key, u8 keylen)
 {
-	struct crypto_cipher *tfm = drbg->priv_data;
-
-	crypto_cipher_setkey(tfm, key, (drbg_keylen(drbg)));
+	crypto_cipher_setkey(tfm, key, keylen);
 }
 
-static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *outval,
-			  const struct drbg_string *in)
+static int drbg_kcapi_sym(struct crypto_cipher *tfm, unsigned char *outval,
+			  const struct drbg_string *in, u8 blocklen_bytes)
 {
-	struct crypto_cipher *tfm = drbg->priv_data;
-
 	/* there is only component in *in */
-	BUG_ON(in->len < drbg_blocklen(drbg));
+	BUG_ON(in->len < blocklen_bytes);
 	crypto_cipher_encrypt_one(tfm, outval, in->buf);
 	return 0;
 }
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 209720b42ec6..1bbac5298ffa 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -714,6 +714,7 @@ config CRYPTO_DEV_TEGRA
 config CRYPTO_DEV_XILINX_TRNG
 	tristate "Support for Xilinx True Random Generator"
 	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
+	select CRYPTO_DRBG_CTR
 	select CRYPTO_RNG
 	select HW_RANDOM
 	help
diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
index 3b861d1a8a8d..adaf69c58647 100644
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -57,6 +57,8 @@
 struct xilinx_rng {
 	void __iomem *rng_base;
 	struct device *dev;
+	unsigned char *scratchpadbuf;
+	struct crypto_cipher *tfm;
 	struct mutex lock;	/* Protect access to TRNG device */
 	struct hwrng trng;
 };
@@ -195,9 +197,14 @@ static int xtrng_reseed_internal(struct xilinx_rng *rng)
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
 
@@ -327,6 +334,7 @@ static void xtrng_hwrng_unregister(struct hwrng *trng)
 static int xtrng_probe(struct platform_device *pdev)
 {
 	struct xilinx_rng *rng;
+	size_t sb_size;
 	int ret;
 
 	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
@@ -340,6 +348,19 @@ static int xtrng_probe(struct platform_device *pdev)
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
@@ -352,8 +373,9 @@ static int xtrng_probe(struct platform_device *pdev)
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
@@ -366,6 +388,9 @@ static int xtrng_probe(struct platform_device *pdev)
 crypto_rng_free:
 	crypto_unregister_rng(&xtrng_trng_alg);
 
+cipher_cleanup:
+	crypto_free_cipher(rng->tfm);
+
 	return ret;
 }
 
@@ -377,6 +402,7 @@ static void xtrng_remove(struct platform_device *pdev)
 	rng = platform_get_drvdata(pdev);
 	xtrng_hwrng_unregister(&rng->trng);
 	crypto_unregister_rng(&xtrng_trng_alg);
+	crypto_free_cipher(rng->tfm);
 	xtrng_write_multiple_registers(rng->rng_base + TRNG_EXT_SEED_OFFSET, zero,
 				       TRNG_NUM_INIT_REGS);
 	xtrng_write_multiple_registers(rng->rng_base + TRNG_PER_STRNG_OFFSET, zero,
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index af5ad51d3eef..978a4a0c34e0 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -53,6 +53,7 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/workqueue.h>
+#include <crypto/internal/cipher.h>
 
 /*
  * Concatenation Helper and string operation helper
@@ -264,6 +265,14 @@ static inline int crypto_drbg_reset_test(struct crypto_rng *drng,
 	return crypto_rng_reset(drng, pers->buf, pers->len);
 }
 
+static inline int crypto_drbg_ctr_df_datalen(u8 statelen, u8 blocklen)
+{
+	return statelen +	/* df_data */
+		blocklen +	/* pad */
+		blocklen +	/* iv */
+		statelen + blocklen;  /* temp */
+}
+
 /* DRBG type flags */
 #define DRBG_CTR	((drbg_flag_t)1<<0)
 #define DRBG_HMAC	((drbg_flag_t)1<<1)
@@ -283,4 +292,10 @@ enum drbg_prefixes {
 	DRBG_PREFIX3
 };
 
+int crypto_drbg_ctr_df(struct crypto_cipher *tfm,
+		       unsigned char *df_data, size_t bytes_to_return,
+		       struct list_head *seedlist,
+		       u8 blocklen_bytes,
+		       u8 statelen);
+
 #endif /* _DRBG_H */
-- 
2.34.1

