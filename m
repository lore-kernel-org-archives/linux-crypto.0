Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70884199E94;
	Mon, 25 Aug 2025 07:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756106245; cv=fail; b=TMU2m90I+jEBpB9QDhhZJ8LUaMVewnXH0WO5picqMs3/ufRpTt4LVW2MDTe6BLwO03Z0IhbyS5RYo8KFsQ2MweR51x49wIaT++1hPcxp6TyjhX1DQ7hdSYjZuTJEgGTPavbzG7oFSAjZeFr2AhTLLzElkXiBXJO4Sz1DUCmQnrU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756106245; c=relaxed/simple;
	bh=lcgZGC3yLmFhZN3ukDy+otKt6n3As6Fk7Q0IZgWd2/U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MSctXEuDFgx3xQEbgZfUcydIitOHe7eExehbkclYT4kQrjF4/KODYawfZN2YB4kW3FO1QjdSbw4p76+EJEcXwfWeNeP/g2/3uu+M/AdkWmHGhv1kpPM1Ds5qAAM/8vh/L4Czuo3bERWZnYXGAp6MADqauI784m1E7OQQH1qBd48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tnVApau9; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tnVApau9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IrVjfrZuAAa0Ew/yoL3U4Gn9IMC1kCJDK6+FXGems9Knr/u/gOXeF77XQFjWZ+4t8FmJbaqODEUMi2N/f55xjerJJL7e+uRrCagNFDhoLM2xE2sq3LNvr/zw7YnXlfi5D+S9ZQJRcPNlD5Byg/mhdejouEFr2V1OYXKi1KB89+CPdUsgQe5DbZ+vYKGn9vYbE0tw5AHLwsdXMZpSANQKqPRAmL8FAfqDwqGU5aOFQaaWx3jrLp0nkZg1933JBIqXLeA2luxj+XKqFK+NVynM+iKgeR01xFS71BoSjML2Iduf3zxzYcJDk4DXgNuJUYLpTz7sNkcDhlW5v1as4DBfOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYun8vOgV9llq83tk3ewhpr8HhJnz29ZSMYaqC2mKDs=;
 b=iy0k1JRkm7SHnEDsnG06I7+qL68bXAkJeU8yinphNc6Krdkhs1zsIsC42uR8yoHCqQhA8ox1T7KPF8vb2IPZ/TUeCELL0iy4WKaMXtnZ3LR3X8ohdtk0r0wNDJku8Mo0fv/Go2gDeA1AOjVh4nYsMpOzFOE1rzVr7L84mJX6oI+Nc8SGF/QHVtUmQvVpSbtqwHJ5/SSztxqq1695KArkITYtbg4rP14jmCrTD/wWhNjrZdSyLboCeVKEayzEhGkRMgrjvpMa24eX9hSp6JIH6MxXDteMwU/1waZ2PshguTjUwa/pSi2asPWDv0Yd1fcKGiIe2Am6iJtb2pUK4Grkww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYun8vOgV9llq83tk3ewhpr8HhJnz29ZSMYaqC2mKDs=;
 b=tnVApau94sBf+/zZlp5ECDcTXQ8D+pDUQIOPihIeyQQX9KgG33qo7WgeYCRHC+r+4GuaLwrf2cBdw0AvSVC7SzQ2c9l3LwfZMs9RT1pIL4FuBXL4f35167uoGtnUM18jyqpUGYQZbU3oGcFmbdn3mmTXQXbqYbjk5SuQqNMxZJY=
Received: from MW4PR04CA0189.namprd04.prod.outlook.com (2603:10b6:303:86::14)
 by DS0PR12MB6536.namprd12.prod.outlook.com (2603:10b6:8:d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 07:17:18 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:303:86:cafe::9f) by MW4PR04CA0189.outlook.office365.com
 (2603:10b6:303:86::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Mon,
 25 Aug 2025 07:17:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Mon, 25 Aug 2025 07:17:18 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 02:17:17 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Mon, 25 Aug
 2025 00:17:16 -0700
Received: from xhdharshj40x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Mon, 25 Aug 2025 02:17:13 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>, <smueller@chronox.de>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH V6 3/3] crypto: drbg: Export CTR DRBG DF functions
Date: Mon, 25 Aug 2025 12:47:00 +0530
Message-ID: <20250825071700.819759-4-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250825071700.819759-1-h.jain@amd.com>
References: <20250825071700.819759-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|DS0PR12MB6536:EE_
X-MS-Office365-Filtering-Correlation-Id: ba377218-7bb6-4cbd-ca5b-08dde3a76cd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y8UwSG9vpCC0fz2AZP+5BgoMsOdjss4FA7mZwumzL9T7iUBVT6/95RNDJioN?=
 =?us-ascii?Q?10qrLwGYXhqjwxIRzEHTEfQl6nJDYgTsRZ6vtvk1crtG8iOB75ibkUrYn6+K?=
 =?us-ascii?Q?+2X8CVPqFa2iUHU7/RF5t6sMM4MjGuFhCev/TjcCPlSp4Q3BuoolGzIL9KyU?=
 =?us-ascii?Q?tGNkQ/z8akjy4YsaSJfNiXnXXCPxdidiTUxIn5N8m2lvjK6/fHnOD4XI0oDu?=
 =?us-ascii?Q?9s74B2C+VmvvCJI+WaJAJCm0wY5W+oO0heASvJOYxpnHz9yk4mbvdAiNwO6u?=
 =?us-ascii?Q?h+HI93JJ0b2LCdKfKUO6Z/SZrEuJYSSOu72zFhAcbMwr6KSqLdsivH9up1Sg?=
 =?us-ascii?Q?piGlVwB+U/lkAx3eLKydYRLsY0ZppyHt+jvR6EqHje5rhjtiaLJMgrx/ielK?=
 =?us-ascii?Q?MtLnlCbXvsq2qMrx9W4seJUmY+MeY11zQT8uCotofODUccPRUHbko5OmXoN/?=
 =?us-ascii?Q?iYv9LL2OoOmzf8OgVIbhuTgYILvKgF07sXO+CIOpM+iWUJnGucKo+mgw6C1E?=
 =?us-ascii?Q?Se9pmpbcn1ZbQySdtIiZ4mmN1E7LQvagyZBBnVBgrRZBAl9Qe1zz0vgtUQBS?=
 =?us-ascii?Q?JeB5Tc/fZ7h9kYQ8F4XuPplKx83EjiaWNy1A47OUdEyt5gaZHaya8uKyk1+B?=
 =?us-ascii?Q?HnH0h8VfiWJ/K9HmpisGToQ9mX06vLejcx6y+veaiALaddswnKttCHIys6KW?=
 =?us-ascii?Q?2es/SYeOdZ35rky9lPRYB28Xft9urgxnqjYCuX/geKZKpcmX0i121bNN7N3h?=
 =?us-ascii?Q?7Yh/W8SePsPYFpw5SwLca6xYymR5jCjuK8pxoHHtTQ8YlCxKViJ8XzXLSMUj?=
 =?us-ascii?Q?eMLxRE6Qs+QuPdKNrdVctOz+ayg8JjpVag26ueoBqVUkPdpE05NPFlomxDRc?=
 =?us-ascii?Q?wN8J7Mtr45lunDU5/ElRGG1c5FxM3yKx1O18H6u2pAqsVZ5HRIuo6xes+HsQ?=
 =?us-ascii?Q?gw9Nx3Vvrd0FV9xzRTgIJGF5852zEMHNaSVeoguRHA818ZfQlfcu3IIOPCgE?=
 =?us-ascii?Q?kSByDmV3mZO5zWRAIJ53J9ihgNJuTWr86oh4gkXSz9pmDDhfi5s4Rcd2Y3m5?=
 =?us-ascii?Q?BKMYIFJUpKgdT0qy9exbqYddzgnTKljaIbXpr5bwqPjevrvkimltL+BP+OCj?=
 =?us-ascii?Q?2BWg4MhFn8RcV+LfqoDH5Z2m+atZRF6+fIZuol6ECjL4Qkt+s+Sq32C1e8YD?=
 =?us-ascii?Q?eBDf8nFOq2tQWCQKQwY2+W62ACd6GJ4weGzxDlUn4wCeHvccHMODDMkP/UCG?=
 =?us-ascii?Q?EPEeD42wbU1ePpPGdRaPeXHW3QuH+CgHdJSoi5RUz9NxuuhB0xMbgmxZPUEM?=
 =?us-ascii?Q?zNfzNFnG4wXn/6VL5mAQmgGtK9ycN3TZpAN9f+487ZpW5FY96QKgu7AYecVb?=
 =?us-ascii?Q?LU6l3nPJTKrfgoXa11WSjTQoPzBSkSg6Mz1maqQqJP0TmJD5DVv+/g4NPgYj?=
 =?us-ascii?Q?Y209yp6J0Ypz4b1/sR0LgKi+GHu03CUKB+fLYQitDQZJPS8r3VHH3uH2ZsaG?=
 =?us-ascii?Q?vNGRm68Hg+TaQslDtv5oyzDNLmRRxwDvskMI1xpR+HwrBMkZaz5BCL7Y7w?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 07:17:18.0392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba377218-7bb6-4cbd-ca5b-08dde3a76cd9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6536

Export drbg_ctr_df() derivative function to re-use it in xilinx trng
driver. Changes has been tested by enabling CONFIG_CRYPTO_USER_API_RNG_CAVP

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 crypto/Kconfig                      |   8 +-
 crypto/Makefile                     |   2 +
 crypto/df_sp80090a.c                | 247 ++++++++++++++++++++++++++++
 crypto/drbg.c                       | 244 +--------------------------
 drivers/crypto/Kconfig              |   1 +
 drivers/crypto/xilinx/xilinx-trng.c |  42 ++++-
 include/crypto/df_sp80090a.h        |  27 +++
 include/crypto/drbg.h               |  25 +--
 include/crypto/internal/drbg.h      |  54 ++++++
 9 files changed, 379 insertions(+), 271 deletions(-)
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
index 4e4700d68127..53ec0c3485d0 100644
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -8,7 +8,6 @@
 #include <linux/clk.h>
 #include <linux/crypto.h>
 #include <linux/delay.h>
-#include <linux/errno.h>
 #include <linux/firmware/xlnx-zynqmp.h>
 #include <linux/hw_random.h>
 #include <linux/io.h>
@@ -18,10 +17,11 @@
 #include <linux/mutex.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
-#include <linux/string.h>
+#include <crypto/aes.h>
+#include <crypto/df_sp80090a.h>
+#include <crypto/internal/drbg.h>
 #include <crypto/internal/cipher.h>
 #include <crypto/internal/rng.h>
-#include <crypto/aes.h>
 
 /* TRNG Registers Offsets */
 #define TRNG_STATUS_OFFSET			0x4U
@@ -59,6 +59,8 @@
 struct xilinx_rng {
 	void __iomem *rng_base;
 	struct device *dev;
+	unsigned char *scratchpadbuf;
+	struct crypto_cipher *tfm;
 	struct mutex lock;	/* Protect access to TRNG device */
 	struct hwrng trng;
 };
@@ -182,9 +184,13 @@ static void xtrng_enable_entropy(struct xilinx_rng *rng)
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
 
@@ -192,9 +198,14 @@ static int xtrng_reseed_internal(struct xilinx_rng *rng)
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
 
@@ -324,6 +335,7 @@ static void xtrng_hwrng_unregister(struct hwrng *trng)
 static int xtrng_probe(struct platform_device *pdev)
 {
 	struct xilinx_rng *rng;
+	size_t sb_size;
 	int ret;
 
 	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
@@ -337,11 +349,24 @@ static int xtrng_probe(struct platform_device *pdev)
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
@@ -349,8 +374,9 @@ static int xtrng_probe(struct platform_device *pdev)
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
@@ -363,6 +389,9 @@ static int xtrng_probe(struct platform_device *pdev)
 crypto_rng_free:
 	crypto_unregister_rng(&xtrng_trng_alg);
 
+cipher_cleanup:
+	crypto_free_cipher(rng->tfm);
+
 	return ret;
 }
 
@@ -374,6 +403,7 @@ static void xtrng_remove(struct platform_device *pdev)
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

