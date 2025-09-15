Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012006.outbound.protection.outlook.com [52.101.43.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821F331282E
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 13:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757943051; cv=fail; b=aq+WNmGjJlFtS0sthqV3nfheOXVwN8WDF4v3pZFF9QycM2x7Qf76kX0xNmKoPOsdy/YGOvP0YBGK5v70CyUbxz4qsc+Sjcj/v41qz9y+sLftWdTL6QBjdU6kzl1nd8AOOngRsHq2YLVbziL/ORUIpwHXVG8pMIy3Y8hdDVl2asM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757943051; c=relaxed/simple;
	bh=s4M4ut+jWYQclhmIfrcP2UwDSKz+N2JNo+S2Mv14Xbo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WiwTqnB4uhGR2vWiNfp6qIMZBvKg4RBx9X0+LSTusd3xio0FETG3MvuqKCnKoSj1xSugba5GCIsspumZr0IsUk/n5JclXRktooPAiRSFvn+vjjynAnx6BycEG5jDz3T2U1+LKrG6S5A81A5iDygOiHImRi4ElJXF/wAXcJiKT58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cHX1V3PP; arc=fail smtp.client-ip=52.101.43.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cHX1V3PP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G4oZsBbHcsBo7yUz6zUlRBmzKvnu5oIYhTIRIamaxs3PBx76depQniFp24X1n7zbS0tzQINZaRxTLXIfR2BBJoEXjVRWItW+LkK+7CS8dZFl9L4XZs+6MI8QlNw5QtvTSNUzd/L8uJDoKLrJIbXYsqsfgrhddv20hlFz+esGs6wAOeUHkvG/77n0QReftEiN+LGgJUnrrHJhT4wDK7MN20TxirCm8tY26JhskUC/jUKkACDEnKWNBcVTMDqJQ17IEWSLC/pZClHcIll+/Q3Rbhieu2/heC8TXzq+XgTWifr9whQb7OmbzF/NLHZ6pKJBk9V2lpzu9X0drmB8qD8k0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pYF6NrQ/ISVr8A+G9U5X1Cmsb6rH1LvXcaIcJrXhgU8=;
 b=j/dSDiCEA6btvWBU3RE3mvjL170ganhpCLZGn5aJPkbpAdOE+mkITQKasi0TpUMm0+IMRq9LNfXhyrLXMOYQjewNXmTICg5edIMTVU3pp2aTvL2G85vZEqU/mDoGylaEwxymIVIiPLOEAOYtZcJQi/aza8ykBNNty6exBGKVKUipHxC6+rGij2z7kr+a66s5tqJQIFKD2PN3ttrwX8wwhPW5G7VXI4vLx6EnuaRkG4wtbXnfWfD63R6bJMhBUizYvldTMaTr52ywDp4zSS9NCin+/3WpXCjPQ8F38QaY3HZ76Tsf26LrNZ0JinCigWll1TF1ZSOQ0ZgrXff6wEnqdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYF6NrQ/ISVr8A+G9U5X1Cmsb6rH1LvXcaIcJrXhgU8=;
 b=cHX1V3PPLgLdXJd/jdIJ+iIqUzyDwd1uZ7FLeNiaymQ2XuT5bDWdkxcF96YeQkWPpV/fGT+/25tFSnyfwZy4Pfano+p/J64skK0Q915JjP5eLS8Gw18SdmoI2aELFrkg9AfaszCkf62h499fahyBJxsSMEBKAyX+KQWeQfvx0uk=
Received: from BN8PR04CA0053.namprd04.prod.outlook.com (2603:10b6:408:d4::27)
 by SJ2PR12MB8650.namprd12.prod.outlook.com (2603:10b6:a03:544::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 13:30:42 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:408:d4:cafe::b0) by BN8PR04CA0053.outlook.office365.com
 (2603:10b6:408:d4::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Mon,
 15 Sep 2025 13:30:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Mon, 15 Sep 2025 13:30:41 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Sep
 2025 06:30:40 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 15 Sep 2025 06:30:37 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <mounika.botcha@amd.com>,
	<sarat.chand.savitala@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 1/3] crypto: drbg: Export CTR DRBG DF functions
Date: Mon, 15 Sep 2025 19:00:25 +0530
Message-ID: <20250915133027.2100914-2-h.jain@amd.com>
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
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|SJ2PR12MB8650:EE_
X-MS-Office365-Filtering-Correlation-Id: 53b12aa4-d4d4-4ddd-bce0-08ddf45c1121
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vHyemnx8p4C8WJc/1JvGmowxBWyVm5q25JVlpMpWqB/qGJP3dig7LaSa/xcA?=
 =?us-ascii?Q?IBUbq+SaIzav5fRQlX2pUbVZ8bJSNirCUq5A10n3Ltz2u+t3OotlJUbszqA6?=
 =?us-ascii?Q?Q11R/YdIOV2cejmApVW8QoUIFMa9VcNKOd5FMQGKiUECZnT12FfYgT3pa1ly?=
 =?us-ascii?Q?GuLH4G1xwuX8eRH5k2AvS5R5vOjbWxUobwJyA3zdYZ3yf2uGB4oITa+1EIeW?=
 =?us-ascii?Q?yDV2EWHbfBF7gG/lhtR6it5UvWyhtqj+z4AjCKvKrzKE30vyf/cCcGNORB/r?=
 =?us-ascii?Q?H4u3tMRr2Jb9tgqKhf1XgzyLYS1mj69BZBQPJtL6g2Va7i7EPwvvi+e2WWWJ?=
 =?us-ascii?Q?utsicuCALeb4W3HHMI3Seol0aBdTNDHDy24GE77E4en6aVZ88EHGOsL7d6xr?=
 =?us-ascii?Q?lzLpPPHA1H30uoEMfO+cpmcrk1qpZrXYiUUg/44m9S9Q/482bg93OLUq2klz?=
 =?us-ascii?Q?r0gip658PUWt0ei64h18/55VvpqB/U/qPgXwamrkrNK7YwMNbLwGiYOJMAVP?=
 =?us-ascii?Q?FcmVGzkJSZ/sR0fAG1XSNe6XWSw9cCZFRvlXya2OahDP5Lf2MuGrTtBqSHLR?=
 =?us-ascii?Q?G7jMjTQFB1ZvV1ZQSFPiKHhbc1LyavHQCFQcOBU8R3a8U/EaR6iAsFPgLykm?=
 =?us-ascii?Q?4f/hHr27WoIgPxG3vek68aPakY1S8lkjl5u36IyOy7oVtG4LJMNz7cfLpuJr?=
 =?us-ascii?Q?0sKlvBJ9H/ua5+NsuxjSKIN+9TA2lw0g7wZq5AwBkoFM4S+v6b2qhUpdNsxU?=
 =?us-ascii?Q?meSquPjNSf8AUOJayVqN3mTI2D9Lmmzm9T7QOKWMnAQlHFmiyVVYqhnMxKOh?=
 =?us-ascii?Q?Vsz7WmGsRz5Ay0uEeG7WSGpsqMGxTnYB2K4MHa8Bl1MEEJNoMUM9ezjO8kbR?=
 =?us-ascii?Q?qA+Sx7Cxr/VWuBFZx4WQDihh8xvZ/jVpQRp+4QtlK2X3J8mYfGmrnRfNC/Lw?=
 =?us-ascii?Q?7RaQoibJQcrF75+vUCBSfyeVPnxYq2EsblAkp8XpZjBgw5xxZK1RgkupWTDs?=
 =?us-ascii?Q?yfwLvIe9slJw0EulseX1T2mJN5T9RYT+XfWJeRPt8xVeR/VZuhCrdcD0Fwi1?=
 =?us-ascii?Q?IYn0UZ0EWT6v5LM4GufLZo5ZwtgkxRtK5SyjPYQBdsQYGmKZV6DZQSx1exXz?=
 =?us-ascii?Q?9p6TpG0Nhrsch8BWAf164ohUc2Wfh1SQry9w6cZIBWY8PcBDD+j88kvL0kde?=
 =?us-ascii?Q?UVvtb94lnn6xzY483eQ5tc9i3xlmVxmRNldfrOs+yr3ilzeOoZpLex6WCDnx?=
 =?us-ascii?Q?uI2sx6/26uK+UsHUiQwDh0ae/Ktqt6r301Gq5FMPaGg679Dn+Z7SbSB/fwmK?=
 =?us-ascii?Q?Od7r7LrJaseP51ZslI0Qy5wUVT9BB7WFcOU1HgXuZbNSXS8MdSQxGxM98CsS?=
 =?us-ascii?Q?kEdCUjSj3eucuurmUWOWrvKCJdTTiLidHMGs28H//Js8Ha0gW27m+xez6fuJ?=
 =?us-ascii?Q?Aa7t34681Eq6hCX8AbFJS7JRRY4m1jY43XViS7P0VbxnFNrp8qWzH71KFAoS?=
 =?us-ascii?Q?+1mVJPW4R02hI80TwfFHrUIAlXpTSMZjwmSn?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 13:30:41.7642
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b12aa4-d4d4-4ddd-bce0-08ddf45c1121
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8650

Export drbg_ctr_df() derivative function to new module df_sp80090.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 crypto/Kconfig                 |   8 +-
 crypto/Makefile                |   2 +
 crypto/df_sp80090a.c           | 247 +++++++++++++++++++++++++++++++++
 crypto/drbg.c                  | 244 +-------------------------------
 drivers/crypto/Kconfig         |   1 +
 include/crypto/df_sp80090a.h   |  27 ++++
 include/crypto/drbg.h          |  25 +---
 include/crypto/internal/drbg.h |  54 +++++++
 8 files changed, 343 insertions(+), 265 deletions(-)
 create mode 100644 crypto/df_sp80090a.c
 create mode 100644 include/crypto/df_sp80090a.h
 create mode 100644 include/crypto/internal/drbg.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 23bd98981ae8..f773c84f056b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1211,8 +1211,7 @@ config CRYPTO_DRBG_HASH
 
 config CRYPTO_DRBG_CTR
 	bool "CTR_DRBG"
-	select CRYPTO_AES
-	select CRYPTO_CTR
+	select CRYPTO_DF80090A
 	help
 	  CTR_DRBG variant as defined in NIST SP800-90A.
 
@@ -1348,6 +1347,11 @@ config CRYPTO_KDF800108_CTR
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
index 6c5d59369dac..ba3cab673ee5 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -210,4 +210,6 @@ obj-$(CONFIG_CRYPTO_SIMD) += crypto_simd.o
 #
 obj-$(CONFIG_CRYPTO_KDF800108_CTR) += kdf_sp800108.o
 
+obj-$(CONFIG_CRYPTO_DF80090A) += df_sp80090a.o
+
 obj-$(CONFIG_CRYPTO_KRB5) += krb5/
diff --git a/crypto/df_sp80090a.c b/crypto/df_sp80090a.c
new file mode 100644
index 000000000000..8309e62abe27
--- /dev/null
+++ b/crypto/df_sp80090a.c
@@ -0,0 +1,247 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * NIST SP800-90A DRBG derivation function
+ *
+ * Copyright (C) 2014, Stephan Mueller <smueller@chronox.de>
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <crypto/df_sp80090a.h>
+#include <crypto/internal/drbg.h>
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
index 657035cfe940..a15e6bfa8948 100644
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
index af5ad51d3eef..2d42518cbdce 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -47,6 +47,7 @@
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/slab.h>
+#include <crypto/internal/drbg.h>
 #include <crypto/internal/rng.h>
 #include <crypto/rng.h>
 #include <linux/fips.h>
@@ -54,30 +55,6 @@
 #include <linux/list.h>
 #include <linux/workqueue.h>
 
-/*
- * Concatenation Helper and string operation helper
- *
- * SP800-90A requires the concatenation of different data. To avoid copying
- * buffers around or allocate additional memory, the following data structure
- * is used to point to the original memory with its size. In addition, it
- * is used to build a linked list. The linked list defines the concatenation
- * of individual buffers. The order of memory block referenced in that
- * linked list determines the order of concatenation.
- */
-struct drbg_string {
-	const unsigned char *buf;
-	size_t len;
-	struct list_head list;
-};
-
-static inline void drbg_string_fill(struct drbg_string *string,
-				    const unsigned char *buf, size_t len)
-{
-	string->buf = buf;
-	string->len = len;
-	INIT_LIST_HEAD(&string->list);
-}
-
 struct drbg_state;
 typedef uint32_t drbg_flag_t;
 
diff --git a/include/crypto/internal/drbg.h b/include/crypto/internal/drbg.h
new file mode 100644
index 000000000000..371e52dcee6c
--- /dev/null
+++ b/include/crypto/internal/drbg.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * NIST SP800-90A DRBG derivation function
+ *
+ * Copyright (C) 2014, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _INTERNAL_DRBG_H
+#define _INTERNAL_DRBG_H
+
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
+	struct s {
+		__be32 conv;
+	};
+	struct s *conversion = (struct s *)buf;
+
+	conversion->conv = cpu_to_be32(val);
+}
+
+/*
+ * Concatenation Helper and string operation helper
+ *
+ * SP800-90A requires the concatenation of different data. To avoid copying
+ * buffers around or allocate additional memory, the following data structure
+ * is used to point to the original memory with its size. In addition, it
+ * is used to build a linked list. The linked list defines the concatenation
+ * of individual buffers. The order of memory block referenced in that
+ * linked list determines the order of concatenation.
+ */
+struct drbg_string {
+	const unsigned char *buf;
+	size_t len;
+	struct list_head list;
+};
+
+static inline void drbg_string_fill(struct drbg_string *string,
+				    const unsigned char *buf, size_t len)
+{
+	string->buf = buf;
+	string->len = len;
+	INIT_LIST_HEAD(&string->list);
+}
+
+#endif //_INTERNAL_DRBG_H
-- 
2.34.1

