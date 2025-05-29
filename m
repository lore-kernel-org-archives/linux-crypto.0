Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF45614E2F2;
	Thu, 29 May 2025 11:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518304; cv=fail; b=uByDM6N/tOJViZRfCZzngrqbs5QSCozC3MPPR6RcMR+33yCLaRsTRZmJn5o3ZJacVF2dLEuTPFqZpgcdee6S9kyzXd4g7+8H6tSyesHzvqFelPdVxhtJ7EUxFqPBdeRM7uAFVpL6+Ty14xynAP5MDEEScjJMbQVLPi/MUtoIJNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518304; c=relaxed/simple;
	bh=vC2cMkfTi00UjNbHFzRA6f6Uc3vV0qK1JLHaq70sleA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T1YevaVV61tkHyOsmvdRE3dJbVN03hfwEpsKLTvd8IAXHIhk8rdJEmAGQ4QKlxqb7u7J4J6mFXietlZHerMSPgtg9zO3AUWNjItLJ3Z9XgoVqnQEpdDhM/2VZdZYT4k9NJAdoCetHu+amwlY6wBUJM40CRbzhsIPkXV5lv80lRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XgrJdqD1; arc=fail smtp.client-ip=40.107.93.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XgrJdqD1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SiF1fbN2ekkLscMhyk1kPQXNT+SKJPJAFM8dWt0ZT4ISc5gijrdO9vNt3KllhpiyeZB8gHdUuRLKmfXJAXhp/Ctv/n7nHEx9p4N5VEg6AEw3qdsw2fDKwWYJ3mgQGFmC6WU+0BcBS1yYicUpOzfiMqYkj7NIM0tVpNAsd7pU1t6sUNK0uRakoW1ewxPovfJNsZNNN7pEny9B84x1Wx6nG0QPWxCx7EUVSdgj44A5/Bu7XLKeH2R2otfYAqz1j21c0RChMH7+QJno2qnB1X235eI4BIbWE3bdT6SXFw3THvsYuIgNJbOmknBqUy87bc/1S4rAsCTJd+g4ODUjODcWbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4aBEXBgxv93OXQAHBeZsX1WOcofyPS6i8KqcFRIOYHU=;
 b=OjxzCVczYBvzYkKyhQwSahhBt/ekDQ/phfkkfsHtZm+xK9pU7XjnJbmJo9KqvJSr/53m4DltcfETzEHGQ8g0xrsQJggYrJ4g8AHEh9uMTBWdigbgIn1hMExhdNXFeu/Qb4muUM9uR+qEtAI26XFIVAAlffg8U8VSiPU1anHFVsVenp7rlrOcXZ9UR6g9W/dMFHkXE9u3YPHT9jGBncmItrsCH/VB/jEtI9D6B9848TPZh7sJtkpjmAmM5Lc0IP1tYaJ+K3NUJWUS7vLEboOVmN938lbAt4cdzGJEij+ql6/rrfeat7iCZmzmNWZwC7Tpkyh6kjHwoLCBK/1LUY5qpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4aBEXBgxv93OXQAHBeZsX1WOcofyPS6i8KqcFRIOYHU=;
 b=XgrJdqD1XpMPawuZYbWY/+kEaKexGrUMSwTyD9ZnNYbsKKyUpqgZPiKtmBaXaWcrpcK7w9mbnbhsw0LYXUszziAvTGXjcborfu85OMwNw24ZLyHSaBiY9Y0Q+Dk2CiQHneMWSBzNXtgx6F3LensyPrBnaXM6GX/dqo8iGcz0kfA=
Received: from CH0PR04CA0070.namprd04.prod.outlook.com (2603:10b6:610:74::15)
 by LV2PR12MB5822.namprd12.prod.outlook.com (2603:10b6:408:179::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.29; Thu, 29 May
 2025 11:31:40 +0000
Received: from CH1PEPF0000AD74.namprd04.prod.outlook.com
 (2603:10b6:610:74:cafe::55) by CH0PR04CA0070.outlook.office365.com
 (2603:10b6:610:74::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.30 via Frontend Transport; Thu,
 29 May 2025 11:31:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD74.mail.protection.outlook.com (10.167.244.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Thu, 29 May 2025 11:31:39 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 May
 2025 06:31:38 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Thu, 29 May 2025 06:31:36 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 3/3] crypto: drbg: Export CTR DRBG DF functions
Date: Thu, 29 May 2025 17:01:16 +0530
Message-ID: <20250529113116.669667-4-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250529113116.669667-1-h.jain@amd.com>
References: <20250529113116.669667-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD74:EE_|LV2PR12MB5822:EE_
X-MS-Office365-Filtering-Correlation-Id: e32770d3-b1e1-43f2-1ef4-08dd9ea4610e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lQXxop7YAz1O4JbktvE0etftn379HqLbZ4Kt++ibQDApl2hO0KlAqgN28fIP?=
 =?us-ascii?Q?sDx/KnYrT3yKCU9oSj3qQOOFitAPOi29BxjSDT9l+tksYBIvmAgvBWi/0ghk?=
 =?us-ascii?Q?ZiUGcTeIn2v+FmyGNrOBtSxFpRmxVKpuzoYsVhp684tdY31Kl1Vd1IEsQkcn?=
 =?us-ascii?Q?pE+prHYaLCMhCBE6nbbuMo0v7b4EFl107qZXnrf6X+5mz19eDvkFmQuE0cjz?=
 =?us-ascii?Q?Qo4dvEJwXMXl5F/vmvsuzPF0K/T6/pfO+0FD5xoIX9YjNz+4ZgiQbWSD13yl?=
 =?us-ascii?Q?R/AP0s0hQMS+cwIM2Sjs4tjpdgo325HCUyg7hIEDfiJtJZLt6tmeolcf/daB?=
 =?us-ascii?Q?bGMZPJ+9rEZrTsvuL4oX/ypoXpNxraXfkUfkV0jCDGHlW864Zo4UZNTPJfFI?=
 =?us-ascii?Q?O5b5DaD1qvNduANbAe9aokt7bulwLWs2I+ROY4Ke1kpYgCBkK1+CElXl9wUM?=
 =?us-ascii?Q?WdtN6/Q/zTygQ8QSMb9xAmWitOP6Lz7Nvm/yPttkgGN75/aIiBgFqXF92lGW?=
 =?us-ascii?Q?Y9BLlA25YntHB9VTt+jIMfGtcg9Cj6B7g6f1BnDpftEkC0mnzbMOMROZ9qR6?=
 =?us-ascii?Q?MBA0e13OsA7zjj5bfLyW3H6qLwp55XoqP9BRCnpjGHLV3UMvCh93m1tmHeo2?=
 =?us-ascii?Q?2wOtfLX7e51sz0RN0WyZS7GOsT/JHvbpvnweS68AV5X+lIpquGkvdf1Eiehw?=
 =?us-ascii?Q?zsd+uenXQl5DLW8AGMtdvu8k74RDFbT7dZzc568u5ak+frwkCDJqzvzg8o7W?=
 =?us-ascii?Q?vGj6m/tDGECZYhxOUgESXA7CaQCfP1jMysFJMznm8LKfqKV6kmrSteqMzVj8?=
 =?us-ascii?Q?XQ27TYybbcMa/nQIYGim1SqW86BSrYP3kBD6lJ3f/ZY0UyXCviNhe1qBqcq0?=
 =?us-ascii?Q?sexx7gW3rAMhpV/4kiEBpCGV0sTj6lWbQ4apyG6+MCi+YUEUFeTbXrWG/hKl?=
 =?us-ascii?Q?YeoiV8ClEwswepEezAdbwbeZXG9roYM5qeygBlH+0EWY5YcDQGqe5CRQC5nl?=
 =?us-ascii?Q?oJmOrK2bcTIqEa8JUdo5rnRJDSP60TTVNDN1rjIwMSWL2Ao8BdNbX49khMN+?=
 =?us-ascii?Q?Js/atLu+jBO5CSd4gpXLTnGcbyjv6o2i3LDr32zMsxsN0RVSBkFXiJu/NiXR?=
 =?us-ascii?Q?UUXvu74g9Olvn5WrNLRnc4uTXUhblbb6kT2GmUHRkqNkmUisbrs9RqCIOB5z?=
 =?us-ascii?Q?azm8mjn5xwDuFYPhtvCMfBq+zFq9dNr7/P9W/M6GwMFZKMFI0v7Qxe6juZkO?=
 =?us-ascii?Q?m1952Kwg93PcMB6d9KReSJTEq/bW3fyZ7UL8HAfCFwvmZ8EoLyRW0dHVTwOy?=
 =?us-ascii?Q?YFZO5JwP3NhjOZGsxcRc5VwosYY3xoGtqo+IZs/geaIxDY0aHa23gkgGUS0D?=
 =?us-ascii?Q?s9J9CM/t0eeVTxWXIvAjdNXTaG+wDaeigIXffJU3RWZ0rd9OY/Kb0/AbSANR?=
 =?us-ascii?Q?EfOjhYSCcfA3181wmORuS9RopOjVu6UZ28OpGCp2Z87cI3VGhLIoaDyhkyHh?=
 =?us-ascii?Q?77KOVUl0cy0xZXiaBV8vJwbc4AbKd10uutNw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2025 11:31:39.6068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e32770d3-b1e1-43f2-1ef4-08dd9ea4610e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD74.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5822

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
index a35c59937349..d540d46c651c 100644
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

