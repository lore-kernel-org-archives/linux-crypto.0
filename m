Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2945C1E25F2;
	Thu, 12 Jun 2025 05:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706069; cv=fail; b=kxyhKCzwblu3wm7W8ZlbyuMuHBapWA6kM2G110sKb/H5v/5GaYgMUe/YV26FZo3HnSzGLa1NOMgiL/zOKBNyppZb1bgMf3ksDAGIdVjHACXvjQpWWrjS8FaBPfW7S5cjEWqTPnzDqV2Ku90pYDhFZ/yQOPp0fmK9cT7SGdjgBkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706069; c=relaxed/simple;
	bh=HXRH5al8zuStaygcnO5bLgPxsITnbGWTY3GO9N4qnDs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FuIYZStMNM4B17TUAMSxGYAK4USuCss5azE+lCrI6+R2xF8axaB5qCJlzDDt38Gts+i1za0kk8zsPd1ACGG6u0pRKTqwG+hz2keLLStS5RwlCTv8kDoP7O+ubQ74SVrK29rU1tkP0MxHPyJhm1P09qpxwByhALbbW07YqMhzbCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IeOuDGek; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IeOuDGek"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F63Xdx0vjBiexhwjP6wH0HQMoGvhbYfFQI+CEjzl9fh9NdbEWu7ECuRnHH7YfIiu1GD8FP8FgE7xavBZ24UkZnI+9Bx1IsZW38qtL63GMTfAu1pLcn+3AF8AXAcoW+jKqlL6Z8MsaNZesgIcpQymUnwHlVNKo+3WLL+WWpoiCc6SpaU8MZjRQGsXG8Ihfy4OkWRsk2Xme07CgQaq8DXMtk91iHardnGyFtE69yfJSsZp8o6YJ7rpoN+y3U/3DVl8wdcNm0SkeWVYRYfXmnDrh8CqZ7q263Q8O9sLmkoPz3KAr3HJ9V0IqNt5yj2FmMKiVBXHswr4esOEdA/RCMgAcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tpv0KJNvYi5es3DNoZQ1gbwZ0uFB4WRPtB1us8Dg00k=;
 b=UYuRWLVOsHuKU4OYCEy4SCGbwh8yfVIzH15KpWOIU7VErvrQgNbnzdasZu89SnMY+ILixPAH9UOpLVfUs5JFshGiPpOX6eJ8Ql7tYYeuKvEtcLf8TYPtAAIdSpBFAgmcnACQ9cnFzu1qz/NPayzkPYafMVWEZUVGu2bCfi46haFsTsWyV0vycq35WNo7sQlDyZCv5Paez3eVgRW2oLSDYluVkhFQXiRsGIEmNZAyh+T6YQj2k5ftA+VdLDHFzbLnteOzYIm0lwOWPeDR74MqK7YiceVmP7ULu4q8alcW3H+5oFAdRj/JAdfUYEX8t+ATAdosWVezhpQ/ZeZvMOc/cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tpv0KJNvYi5es3DNoZQ1gbwZ0uFB4WRPtB1us8Dg00k=;
 b=IeOuDGekGJ8wXR4JvYMw0e8SHbIhPnfhIg4bZoG5tSQpfQ8AjOdKt3wkFmEeSVJe/aQSQr+6J+FXpBXdB3ibHyYzmxmxfiW4XlsrnRGFsjimQ3Y3emc5ZbM3k96ek4RZkl4Xs1ru5YQ3g92Appxh9x1Zbf5uNuCa3QFYhGPd2Ho=
Received: from SJ0PR03CA0095.namprd03.prod.outlook.com (2603:10b6:a03:333::10)
 by DM6PR12MB4042.namprd12.prod.outlook.com (2603:10b6:5:215::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 05:27:41 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:a03:333:cafe::63) by SJ0PR03CA0095.outlook.office365.com
 (2603:10b6:a03:333::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Thu,
 12 Jun 2025 05:27:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Thu, 12 Jun 2025 05:27:40 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Jun
 2025 00:27:39 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Thu, 12 Jun 2025 00:27:37 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v3 3/3] crypto: drbg: Export CTR DRBG DF functions
Date: Thu, 12 Jun 2025 10:55:42 +0530
Message-ID: <20250612052542.2591773-4-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250612052542.2591773-1-h.jain@amd.com>
References: <20250612052542.2591773-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|DM6PR12MB4042:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ff0395f-0cfc-46b5-dfbd-08dda971d9f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m77sIoZ08iAwpt6JFRTXx3T9Ji2egsZ9gbnNwmabMsInR9spVu3wM+1H9QL0?=
 =?us-ascii?Q?sYMvwqMJzG/mtWxsSXRR3xRLTzDlmJMSOAAzgopLcDNMKYRjIKKbK1jlB76Z?=
 =?us-ascii?Q?jrAJyr8s1gonAUXYVKnkbPA5R4sNwGhha7uFiH8Gs7SQUpdEQK/1fsxlPhKg?=
 =?us-ascii?Q?4AUvNPdfC+4h1mi9N8xB1sYBudLtnbXqw7jQoVJPbDFtO0qhn9236Mzagm+G?=
 =?us-ascii?Q?QdOUuHAVCR8Q7pdj2F6usn8fG3Cfc0K89E9CNICRlrT5lu0HNbUA66WF7Wlb?=
 =?us-ascii?Q?6ACYv6e9gOWeNxFz+mcWDKzWK00omNnF3I0U+p4cylSZkuQHAa41QrUY1A/z?=
 =?us-ascii?Q?VZS2RMI1FPnc4XfPcP3LY/znZ9T8SGTmGxFoR17XZNGnr1WRmiLElf3nmA0c?=
 =?us-ascii?Q?i7UDDp7ICiO/asm+hKkERf6WnnhBaYQMbwaOny0JWfwcP0RFg9McaH75NsQM?=
 =?us-ascii?Q?Eu7MEY8MMK59gI9jjeXiFDG4V9PD519KfCiBkA8cfjZT1E1ahgGFqjFvRDUa?=
 =?us-ascii?Q?6Kxl8V8xYp5Vd9Gtvto627j5HiPBPaBupR1r8Qmvji6xM57L/D1XrmYNXMMJ?=
 =?us-ascii?Q?EWLrcey9fHs2O3uoaj2PFv9V0rrHM0S+VXHVxjiNSRNh01Grt9ZgErK5meq5?=
 =?us-ascii?Q?Dwf4YJZatPmZmi8RVBwrg8UhNqqwjOiUa6rY58bF2fJa7+ugo60CDFe88AFE?=
 =?us-ascii?Q?ZiENJRxU5Jmszw849PZIDt361bv7iFJdYyMtvhGeow2oDNahicyl/Hu6IPVr?=
 =?us-ascii?Q?i/4v14SiT1m6qy6vlVk5v7yqwYDzre1yVHf7yHjk5vH3jrMU703s9VZXsNc6?=
 =?us-ascii?Q?mfScbkjwAv1ALYLTpYW6XNgd3CeJJr+v03NSUzZxm/WyxlenwZu/iW/8PN40?=
 =?us-ascii?Q?BP1MCWCVm7iCa+LwMhaQaJtuypGcoSRqfssoNl/0CBXK24XsfNZaQugQ6lxP?=
 =?us-ascii?Q?UeA2Cvi3BVh4YFVyGdbv49yVKXGolWsTDWEDCDn98nIAmN5zKkgDzG623juH?=
 =?us-ascii?Q?DfwH6t0dZiUmYN9E3kCd5Jw6mu9Wem9PvMifRWKpJtOMMSa9bdvqm5wj0xgf?=
 =?us-ascii?Q?V1CaXGc1BEgh3QWLCNwaAHrj4rcAMRFpPPx/Ct3HAQaOsZTDLnl5P/OSOFyA?=
 =?us-ascii?Q?RjsuTZlkV6I/VzleOH4+wnGIUziXmTF8WsTj02mM/xwfFkQkRaLn/VE9HY7/?=
 =?us-ascii?Q?3fFTLnZt7ClEN1GtZOz7V9ws5Aa6PO0RB1JpOsZRUUMqLoTo2Zv5imxft8Cx?=
 =?us-ascii?Q?uPehHp4Hs2HVALRzttzN4LCuodBiwvHGn1sxM0Sy2XazLOOzZ3OUOBfVIVV7?=
 =?us-ascii?Q?pxUtWNCjEgXaOy7ISodKpIZBQtChwzqT/xL1OygpgpzAE00RkuycBulAeH99?=
 =?us-ascii?Q?Af22aKS2ntNUggb5dDBdIJk2n+uXg+tzikg7ej/xw7NO4zWE9nMHR0gG2sQX?=
 =?us-ascii?Q?GoZKsV73Lxcvr90r835tfjbcDI3u3l501BgksD07RitaHl19a3iTWQrVQfIc?=
 =?us-ascii?Q?vh1qoJ2DSyh+BHNxxK02AJi23ek7CrI0zSqg?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 05:27:40.7863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff0395f-0cfc-46b5-dfbd-08dda971d9f2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4042

Export drbg_ctr_df() derivative function to re-use it in xilinx trng
driver. Changes has been tested by enabling CONFIG_CRYPTO_USER_API_RNG_CAVP

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 crypto/drbg.c                       | 108 +++++++++++++++-------------
 drivers/crypto/Kconfig              |   2 +
 drivers/crypto/xilinx/xilinx-trng.c |  32 ++++++++-
 include/crypto/drbg.h               |  15 ++++
 4 files changed, 103 insertions(+), 54 deletions(-)

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
index 209720b42ec6..cfbc06451fec 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -714,6 +714,8 @@ config CRYPTO_DEV_TEGRA
 config CRYPTO_DEV_XILINX_TRNG
 	tristate "Support for Xilinx True Random Generator"
 	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
+	select CRYPTO_DRBG_MENU
+	select CRYPTO_DRBG_CTR
 	select CRYPTO_RNG
 	select HW_RANDOM
 	help
diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
index da043e31ec17..e339ee95d01c 100644
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
@@ -340,11 +348,24 @@ static int xtrng_probe(struct platform_device *pdev)
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

