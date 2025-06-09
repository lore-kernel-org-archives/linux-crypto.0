Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2073.outbound.protection.outlook.com [40.107.236.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA1733F6;
	Mon,  9 Jun 2025 04:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749444698; cv=fail; b=TDET/ztLj7RFbalx0JOvK7HR3TGZ82vFwjPbznOrgY42XFDggyl+2lvwyg4PsNCgsM6XXdX2eE/nFilgyHp3y17L+bjDn4VjXcsXLRjwXf7MapSuVZIaR+s3sRiLSDnhhFGzrh1A93hLQCL5Z8X1EfemS2JTF16/0GP6MT1Ceog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749444698; c=relaxed/simple;
	bh=BnKHssEn1YmsxSu8/un5ujyzy6DU2nTOnSnio/xwemg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NG6UeVGaROqoF7qnGe9ddjcy/W4EAQ5f8IMo+8pqUB1YaP8uyN+1QeOXAv7R2/hug8yTIBVKeYPAVX1zRcmholc3UPfXUzx8xM4ztqGbcQNd2f2qaVctT8SsUBhS/o4na8rdCrvTPEYgVdvBU8WcpOcAwis2eoZJOwgnY6Vhzeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3y9LS+XY; arc=fail smtp.client-ip=40.107.236.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3y9LS+XY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dvO4SYjheKv/DFFPS1WXrPrk/Ms5rU0asyHole297ESUUpIu7sHboUKZOcCRMX1JYydymGTysr9s3yDoe0Da5WO4yS9WOK39HqrOqUMmqYdSV6rmWdTa/c/fqsiFXPEhXJR+ZNyN2opm9XvIRgVHK/BCuSkVnIgbmN7RnwwNeNnAjkrjQy6fS3vHZqCGl1oCJsz3j9i1zDJVtqky+6KUD1RGhXWn3n1g8u8FOkdgD2vSWeOrbecOdo1U8E/wa4Uctc3YxvcYYLbXsvoR8l1PLxKGt6hjnVYS5PM7L2gpjvEmKNqmdyc4mQyWQ4YHmB1nE4k5mnZ1Ix/+84wDJ3W9bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oSXnda0Nk4/moBRR1HBdBhGHnz72fYK1ITx4A2LfxFM=;
 b=A+VDHJkr1cJenCSVEfz0u68VgLFNwxb1pmmMoJd0aS24XreP71iK4NTbjQ8MFWCAhxNdSCkskIz4+gFa6FsFCpYF80Zijxw4cZ39qblh1Ol8OjuY3G64C6Aazk358JK86/6vucBk1z2my0hPiEQnplFx9iJ+W7oLAQ1Ei9IWqXztlHhN1LlFJ6RWo9tOEHMQe591SLEKeOqkCaA1fjGDI79JPzhQqzkHj1PhHcfYeMjGYdS9zh0MG4ZZfU5nRM2jfNxkNGd/iE8aUjIcAcpKdmsCWgedFjL3NIw+Y5I0+5MgHzX6HjduNm2LrID8w3OSt+7cILqeNUXENiIhmcm2rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSXnda0Nk4/moBRR1HBdBhGHnz72fYK1ITx4A2LfxFM=;
 b=3y9LS+XYLhWULiihIilPRxGHWnjbtD9lO97D5sNQcH6S31KUWMmzGtgzldbiO5O+Rek1xbKpmvLLAylyRf6Pzl2ajlZadXMUFHN7XhGNvoUbNBhQuvhBF42at7alswpmxvmZy50v9FTjr3vg0QeAr2uvrzXayDGaxpA/NfIVYnc=
Received: from BL1PR13CA0101.namprd13.prod.outlook.com (2603:10b6:208:2b9::16)
 by PH7PR12MB9074.namprd12.prod.outlook.com (2603:10b6:510:2f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.40; Mon, 9 Jun
 2025 04:51:29 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:2b9:cafe::e2) by BL1PR13CA0101.outlook.office365.com
 (2603:10b6:208:2b9::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.16 via Frontend Transport; Mon,
 9 Jun 2025 04:51:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 04:51:28 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Jun
 2025 23:51:28 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Jun
 2025 23:51:27 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 8 Jun 2025 23:51:25 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 2/6] crypto: xilinx: Add TRNG driver for Versal
Date: Mon, 9 Jun 2025 10:21:06 +0530
Message-ID: <20250609045110.1786634-3-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|PH7PR12MB9074:EE_
X-MS-Office365-Filtering-Correlation-Id: be4c0a90-c5d9-400d-2dd0-08dda7114bf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9NkVh+3G1+KIqemcJDG5ryg3IKQN6nNAV8qVJpxj+zU8MHBDbgeCSjhYFprg?=
 =?us-ascii?Q?3GKaXtYf9SVlcXjODnC92fbnR0ObWH60z1SU7P6/R9snKpK1/MzSzRSzXwaj?=
 =?us-ascii?Q?ge7C9u+MUPwIvVnaQMw0nB8VTGTNITwiEwk6ncASxOmVzd84McK7d1YCweQz?=
 =?us-ascii?Q?trT/e2vTVZpt44BRHZDfO7pnwPdk9oMg6zS4c9EGzqQdhpi3768G9JE9H2dQ?=
 =?us-ascii?Q?CxRPD+sH29oKFIz2iXx9wN2KllQ8AXohObCpPblNtxQbVulDQ3wejzHzyf1x?=
 =?us-ascii?Q?Gzl5sZN7e6lKlQWT4gYQkSfyw/+wxNyuCBQme/E9gW5zT8gw77zRX6EuS5Dv?=
 =?us-ascii?Q?mQnzMpLukZZtOmbOEsz1x49PJVCqWl1/Uc0gZ5yFK4tsUQ01cranulmN0MNY?=
 =?us-ascii?Q?kDSUJMp6IeOVn+2xt7KvKw+bOhP8aoi512YUXv2tXwFFOSXaHhBru3sgGW4B?=
 =?us-ascii?Q?p+w+kJQX6bpYuIPqa+RAYlyWDbZ+HZySL5ibOK+1Y4crbWLa/vBm3D7x4DY7?=
 =?us-ascii?Q?08nQMV3qij1LVl2BbohLR8/e6bAoPvIEpmp2B9iJznCi9LICFQqCGXSc3L0V?=
 =?us-ascii?Q?GIvW9/d0yKV2OPXBua6eW3dakg01STZnNa/QxhObeIXysK+M6lkYwzQzUAa8?=
 =?us-ascii?Q?ZThiWex0iFq6nfHN1iXyMafAVkdn6JlL9HoXMNO7D9yWcDgQzwxuPiqY2bVp?=
 =?us-ascii?Q?UF2NUtSTtbWiVF9j1jhI+mh7EJF9KMuoIX4idBOuZbrvQYOnnP5GzRHMJ3UE?=
 =?us-ascii?Q?jLdLZelQtyXYk3Temb861cLJFR9+8rqEGBsXmC4Smf8FM8oYIdeqRV4UpNcY?=
 =?us-ascii?Q?42QLnTb28/091F77Dyk2AL+SwNT4cJM8rQaHRua15ZX1fb/yhfCqyuVp4OzZ?=
 =?us-ascii?Q?YDqr38Yf5HjMUCpDLKn6wSIoMphJ6n1OT8rYueRvIJL5pTL09LFN8qhwcPuC?=
 =?us-ascii?Q?SXLXWVXXMFGZs2bsLOnWz+FREAWkaApW0v3DAZ2eVsANv9kRwFmOibsYFXr+?=
 =?us-ascii?Q?AyXydq7CQq2ByIdU3VuoraS+JHnl5lOsLmNppbTQpFR7BL/BwKr2mmqALALD?=
 =?us-ascii?Q?8wsuVjr3w/cavnRKPJS7zW4pUGSXeDtRggiH8K3aV/XGYpSo5QJtZ5q0uApg?=
 =?us-ascii?Q?I27FmrxDYSK7Tv3tZI07b0+17R/hftBT0771cgutqbrAWl8ONn+IbzruTyXj?=
 =?us-ascii?Q?a6wYO13vTAr3gijTa19nz+VDQu0RvloxqhB8QI5YpceHNkQpJZeQk+Mmh2mg?=
 =?us-ascii?Q?qrQbIqZkmXsIqbQFkQWao7+8La5gRJqiTJqmt/hrTGadIs3/ZWd70GPX6GQm?=
 =?us-ascii?Q?QxV4Z0uOOaxd7eQI2AWgR2ON9EIA7XBQlRv5GnnznEXCEHFOgVtRqL1SKap0?=
 =?us-ascii?Q?tbC4TWsvNG5Y618sGBBOnxrcM3MxOdjhObd1whtlvOarpk/V/BrCgBT/fJML?=
 =?us-ascii?Q?mYzA7s26P9p18bpgz6vBBVC2tyDvqbnVIc4/GOD+etQ2eA1KZl3jGkBYBjHl?=
 =?us-ascii?Q?JguyXcp+5pIxzCxsaDmb1g7HcLjZph4UUG+R?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 04:51:28.6564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be4c0a90-c5d9-400d-2dd0-08dda7114bf3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9074

Add True Random Number Generator(TRNG) driver for Versal
platform.

Co-developed-by: Mounika Botcha <mounika.botcha@amd.com>
Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 MAINTAINERS                         |   6 +
 drivers/crypto/Kconfig              |  12 +
 drivers/crypto/xilinx/Makefile      |   1 +
 drivers/crypto/xilinx/xilinx-trng.c | 408 ++++++++++++++++++++++++++++
 4 files changed, 427 insertions(+)
 create mode 100644 drivers/crypto/xilinx/xilinx-trng.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 85f7619e06b6..6995a0017a35 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26578,6 +26578,12 @@ F:	drivers/misc/Makefile
 F:	drivers/misc/xilinx_sdfec.c
 F:	include/uapi/misc/xilinx_sdfec.h
 
+XILINX TRNG DRIVER
+M:	Mounika Botcha <mounika.botcha@amd.com>
+M:	Harsh Jain <h.jain@amd.com>
+S:	Maintained
+F:	drivers/crypto/xilinx/xilinx-trng.c
+
 XILINX UARTLITE SERIAL DRIVER
 M:	Peter Korsgaard <jacmet@sunsite.dk>
 L:	linux-serial@vger.kernel.org
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 5686369779be..209720b42ec6 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -711,6 +711,18 @@ config CRYPTO_DEV_TEGRA
 	  Select this to enable Tegra Security Engine which accelerates various
 	  AES encryption/decryption and HASH algorithms.
 
+config CRYPTO_DEV_XILINX_TRNG
+	tristate "Support for Xilinx True Random Generator"
+	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
+	select CRYPTO_RNG
+	select HW_RANDOM
+	help
+	  Xilinx Versal SoC driver provides kernel-side support for True Random Number
+	  Generator and Pseudo random Number in CTR_DRBG mode as defined in NIST SP800-90A.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called xilinx-trng.
+
 config CRYPTO_DEV_ZYNQMP_AES
 	tristate "Support for Xilinx ZynqMP AES hw accelerator"
 	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
diff --git a/drivers/crypto/xilinx/Makefile b/drivers/crypto/xilinx/Makefile
index 730feff5b5f2..9b51636ef75e 100644
--- a/drivers/crypto/xilinx/Makefile
+++ b/drivers/crypto/xilinx/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_XILINX_TRNG) += xilinx-trng.o
 obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += zynqmp-aes-gcm.o
 obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_SHA3) += zynqmp-sha.o
diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
new file mode 100644
index 000000000000..3b861d1a8a8d
--- /dev/null
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -0,0 +1,408 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * AMD Versal True Random Number Generator driver
+ * Copyright (c) 2024 - 2025 Advanced Micro Devices, Inc.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/clk.h>
+#include <linux/crypto.h>
+#include <linux/firmware/xlnx-zynqmp.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/mod_devicetable.h>
+#include <linux/platform_device.h>
+#include <crypto/internal/cipher.h>
+#include <crypto/internal/rng.h>
+#include <crypto/aes.h>
+#include <crypto/drbg.h>
+
+/* TRNG Registers Offsets */
+#define TRNG_STATUS_OFFSET			0x4U
+#define TRNG_CTRL_OFFSET			0x8U
+#define TRNG_EXT_SEED_OFFSET			0x40U
+#define TRNG_PER_STRNG_OFFSET			0x80U
+#define TRNG_CORE_OUTPUT_OFFSET			0xC0U
+#define TRNG_RESET_OFFSET			0xD0U
+#define TRNG_OSC_EN_OFFSET			0xD4U
+
+/* Mask values */
+#define TRNG_RESET_VAL_MASK			BIT(0)
+#define TRNG_OSC_EN_VAL_MASK			BIT(0)
+#define TRNG_CTRL_PRNGSRST_MASK			BIT(0)
+#define TRNG_CTRL_EUMODE_MASK			BIT(8)
+#define TRNG_CTRL_TRSSEN_MASK			BIT(2)
+#define TRNG_CTRL_PRNGSTART_MASK		BIT(5)
+#define TRNG_CTRL_PRNGXS_MASK			BIT(3)
+#define TRNG_CTRL_PRNGMODE_MASK			BIT(7)
+#define TRNG_STATUS_DONE_MASK			BIT(0)
+#define TRNG_STATUS_QCNT_MASK			GENMASK(11, 9)
+#define TRNG_STATUS_QCNT_16_BYTES		0x800
+
+/* Sizes in bytes */
+#define TRNG_SEED_LEN_BYTES			48U
+#define TRNG_ENTROPY_SEED_LEN_BYTES		64U
+#define TRNG_SEC_STRENGTH_SHIFT			5U
+#define TRNG_SEC_STRENGTH_BYTES			BIT(TRNG_SEC_STRENGTH_SHIFT)
+#define TRNG_BYTES_PER_REG			4U
+#define TRNG_RESET_DELAY			10
+#define TRNG_NUM_INIT_REGS			12U
+#define TRNG_READ_4_WORD			4
+#define TRNG_DATA_READ_DELAY			8000
+
+struct xilinx_rng {
+	void __iomem *rng_base;
+	struct device *dev;
+	struct mutex lock;	/* Protect access to TRNG device */
+	struct hwrng trng;
+};
+
+struct xilinx_rng_ctx {
+	struct xilinx_rng *rng;
+};
+
+static struct xilinx_rng *xilinx_rng_dev;
+
+static void xtrng_readwrite32(void __iomem *addr, u32 mask, u8 value)
+{
+	u32 val;
+
+	val = ioread32(addr);
+	val = (val & (~mask)) | (mask & value);
+	iowrite32(val, addr);
+}
+
+static void xtrng_trng_reset(void __iomem *addr)
+{
+	xtrng_readwrite32(addr + TRNG_RESET_OFFSET, TRNG_RESET_VAL_MASK, TRNG_RESET_VAL_MASK);
+	udelay(TRNG_RESET_DELAY);
+	xtrng_readwrite32(addr + TRNG_RESET_OFFSET, TRNG_RESET_VAL_MASK, 0);
+}
+
+static void xtrng_hold_reset(void __iomem *addr)
+{
+	xtrng_readwrite32(addr + TRNG_CTRL_OFFSET, TRNG_CTRL_PRNGSRST_MASK,
+			  TRNG_CTRL_PRNGSRST_MASK);
+	iowrite32(TRNG_RESET_VAL_MASK, addr + TRNG_RESET_OFFSET);
+	udelay(TRNG_RESET_DELAY);
+}
+
+static void xtrng_softreset(struct xilinx_rng *rng)
+{
+	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET, TRNG_CTRL_PRNGSRST_MASK,
+			  TRNG_CTRL_PRNGSRST_MASK);
+	udelay(TRNG_RESET_DELAY);
+	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET, TRNG_CTRL_PRNGSRST_MASK, 0);
+}
+
+/* Return no. of bytes read */
+static size_t xtrng_readblock32(void __iomem *rng_base, __be32 *buf, int blocks32, bool wait)
+{
+	int read = 0, ret;
+	int timeout = 1;
+	int i, idx;
+	u32 val;
+
+	if (wait)
+		timeout = TRNG_DATA_READ_DELAY;
+
+	for (i = 0; i < (blocks32 * 2); i++) {
+		/* TRNG core generate data in 16 bytes. Read twice to complete 32 bytes read */
+		ret = readl_poll_timeout(rng_base + TRNG_STATUS_OFFSET, val,
+					 (val & TRNG_STATUS_QCNT_MASK) ==
+					 TRNG_STATUS_QCNT_16_BYTES, !!wait, timeout);
+		if (ret)
+			break;
+
+		for (idx = 0; idx < TRNG_READ_4_WORD; idx++) {
+			*(buf + read) = cpu_to_be32(ioread32(rng_base + TRNG_CORE_OUTPUT_OFFSET));
+			read += 1;
+		}
+	}
+	return read * 4;
+}
+
+static int xtrng_collect_random_data(struct xilinx_rng *rng, u8 *rand_gen_buf,
+				     int no_of_random_bytes, bool wait)
+{
+	u8 randbuf[TRNG_SEC_STRENGTH_BYTES];
+	int byteleft, blocks, count = 0;
+	int ret;
+
+	byteleft = no_of_random_bytes & (TRNG_SEC_STRENGTH_BYTES - 1);
+	blocks = no_of_random_bytes >> TRNG_SEC_STRENGTH_SHIFT;
+	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET, TRNG_CTRL_PRNGSTART_MASK,
+			  TRNG_CTRL_PRNGSTART_MASK);
+	if (blocks) {
+		ret = xtrng_readblock32(rng->rng_base, (__be32 *)rand_gen_buf, blocks, wait);
+		if (!ret)
+			return 0;
+		count += ret;
+	}
+
+	if (byteleft) {
+		ret = xtrng_readblock32(rng->rng_base, (__be32 *)randbuf, 1, wait);
+		if (!ret)
+			return count;
+		memcpy(rand_gen_buf + (blocks * TRNG_SEC_STRENGTH_BYTES), randbuf, byteleft);
+		count += byteleft;
+	}
+
+	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET,
+			  TRNG_CTRL_PRNGMODE_MASK | TRNG_CTRL_PRNGSTART_MASK, 0U);
+
+	return count;
+}
+
+static void xtrng_write_multiple_registers(void __iomem *base_addr, u32 *values, size_t n)
+{
+	void __iomem *reg_addr;
+	size_t i;
+
+	/* Write seed value into EXTERNAL_SEED Registers in big endian format */
+	for (i = 0; i < n; i++) {
+		reg_addr = (base_addr + ((n - 1 - i) * TRNG_BYTES_PER_REG));
+		iowrite32((u32 __force)(cpu_to_be32(values[i])), reg_addr);
+	}
+}
+
+static void xtrng_enable_entropy(struct xilinx_rng *rng)
+{
+	iowrite32(TRNG_OSC_EN_VAL_MASK, rng->rng_base + TRNG_OSC_EN_OFFSET);
+	xtrng_softreset(rng);
+	iowrite32(TRNG_CTRL_EUMODE_MASK | TRNG_CTRL_TRSSEN_MASK, rng->rng_base + TRNG_CTRL_OFFSET);
+}
+
+static int xtrng_reseed_internal(struct xilinx_rng *rng)
+{
+	u8 entropy[TRNG_ENTROPY_SEED_LEN_BYTES];
+	u32 entropylen = TRNG_SEED_LEN_BYTES;
+	struct drbg_string data;
+	LIST_HEAD(seedlist);
+	u32 val;
+	int ret;
+
+	drbg_string_fill(&data, entropy, entropylen);
+	list_add_tail(&data.list, &seedlist);
+	memset(entropy, 0, sizeof(entropy));
+	xtrng_enable_entropy(rng);
+
+	/* collect random data to use it as entropy (input for DF) */
+	ret = xtrng_collect_random_data(rng, entropy, TRNG_SEED_LEN_BYTES, true);
+	if (ret != TRNG_SEED_LEN_BYTES)
+		return -EINVAL;
+
+	xtrng_write_multiple_registers(rng->rng_base + TRNG_EXT_SEED_OFFSET,
+				       (u32 *)entropy, TRNG_NUM_INIT_REGS);
+	/* select reseed operation */
+	iowrite32(TRNG_CTRL_PRNGXS_MASK, rng->rng_base + TRNG_CTRL_OFFSET);
+
+	/* Start the reseed operation with above configuration and wait for STATUS.Done bit to be
+	 * set. Monitor STATUS.CERTF bit, if set indicates SP800-90B entropy health test has failed.
+	 */
+	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET, TRNG_CTRL_PRNGSTART_MASK,
+			  TRNG_CTRL_PRNGSTART_MASK);
+
+	ret = readl_poll_timeout(rng->rng_base + TRNG_STATUS_OFFSET, val,
+				 (val & TRNG_STATUS_DONE_MASK) == TRNG_STATUS_DONE_MASK,
+				  1U, 15000U);
+	if (ret)
+		return ret;
+
+	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET, TRNG_CTRL_PRNGSTART_MASK, 0U);
+
+	return 0;
+}
+
+static int xtrng_random_bytes_generate(struct xilinx_rng *rng, u8 *rand_buf_ptr,
+				       u32 rand_buf_size, int wait)
+{
+	int nbytes;
+	int ret;
+
+	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET,
+			  TRNG_CTRL_PRNGMODE_MASK | TRNG_CTRL_PRNGXS_MASK,
+			  TRNG_CTRL_PRNGMODE_MASK | TRNG_CTRL_PRNGXS_MASK);
+	nbytes = xtrng_collect_random_data(rng, rand_buf_ptr, rand_buf_size, wait);
+
+	ret = xtrng_reseed_internal(rng);
+	if (ret) {
+		dev_err(rng->dev, "Re-seed fail\n");
+		return ret;
+	}
+
+	return nbytes;
+}
+
+static int xtrng_trng_generate(struct crypto_rng *tfm, const u8 *src, u32 slen,
+			       u8 *dst, u32 dlen)
+{
+	struct xilinx_rng_ctx *ctx = crypto_rng_ctx(tfm);
+	int ret;
+
+	mutex_lock(&ctx->rng->lock);
+	ret = xtrng_random_bytes_generate(ctx->rng, dst, dlen, true);
+	mutex_unlock(&ctx->rng->lock);
+
+	return ret < 0 ? ret : 0;
+}
+
+static int xtrng_trng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
+{
+	return 0;
+}
+
+static int xtrng_trng_init(struct crypto_tfm *rtfm)
+{
+	struct xilinx_rng_ctx *ctx = crypto_tfm_ctx(rtfm);
+
+	ctx->rng = xilinx_rng_dev;
+
+	return 0;
+}
+
+static struct rng_alg xtrng_trng_alg = {
+	.generate = xtrng_trng_generate,
+	.seed = xtrng_trng_seed,
+	.seedsize = 0,
+	.base = {
+		.cra_name = "stdrng",
+		.cra_driver_name = "xilinx-trng",
+		.cra_priority = 300,
+		.cra_ctxsize = sizeof(struct xilinx_rng_ctx),
+		.cra_module = THIS_MODULE,
+		.cra_init = xtrng_trng_init,
+	},
+};
+
+static int xtrng_hwrng_trng_read(struct hwrng *hwrng, void *data, size_t max, bool wait)
+{
+	u8 buf[TRNG_SEC_STRENGTH_BYTES];
+	struct xilinx_rng *rng;
+	int ret = -EINVAL, i = 0;
+
+	rng = container_of(hwrng, struct xilinx_rng, trng);
+	/* Return in case wait not set and lock not available. */
+	if (!mutex_trylock(&rng->lock) && !wait)
+		return 0;
+	else if (!mutex_is_locked(&rng->lock) && wait)
+		mutex_lock(&rng->lock);
+
+	while (i < max) {
+		ret = xtrng_random_bytes_generate(rng, buf, TRNG_SEC_STRENGTH_BYTES, wait);
+		if (ret < 0)
+			break;
+
+		memcpy(data + i, buf, min(ret, (max - i)));
+		i += min(ret, (max - i));
+	}
+	mutex_unlock(&rng->lock);
+
+	return ret;
+}
+
+static int xtrng_hwrng_register(struct hwrng *trng)
+{
+	int ret;
+
+	trng->name = "Xilinx Versal Crypto Engine TRNG";
+	trng->read = xtrng_hwrng_trng_read;
+
+	ret = hwrng_register(trng);
+	if (ret)
+		pr_err("Fail to register the TRNG\n");
+
+	return ret;
+}
+
+static void xtrng_hwrng_unregister(struct hwrng *trng)
+{
+	hwrng_unregister(trng);
+}
+
+static int xtrng_probe(struct platform_device *pdev)
+{
+	struct xilinx_rng *rng;
+	int ret;
+
+	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
+	if (!rng)
+		return -ENOMEM;
+
+	rng->dev = &pdev->dev;
+	rng->rng_base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(rng->rng_base)) {
+		dev_err(&pdev->dev, "Failed to map resource %ld\n", PTR_ERR(rng->rng_base));
+		return PTR_ERR(rng->rng_base);
+	}
+
+	xtrng_trng_reset(rng->rng_base);
+	ret = xtrng_reseed_internal(rng);
+	if (ret) {
+		dev_err(&pdev->dev, "TRNG Seed fail\n");
+		return ret;
+	}
+
+	xilinx_rng_dev = rng;
+	mutex_init(&rng->lock);
+	ret = crypto_register_rng(&xtrng_trng_alg);
+	if (ret) {
+		dev_err(&pdev->dev, "Crypto Random device registration failed: %d\n", ret);
+		return ret;
+	}
+	ret = xtrng_hwrng_register(&rng->trng);
+	if (ret) {
+		dev_err(&pdev->dev, "HWRNG device registration failed: %d\n", ret);
+		goto crypto_rng_free;
+	}
+	platform_set_drvdata(pdev, rng);
+
+	return 0;
+
+crypto_rng_free:
+	crypto_unregister_rng(&xtrng_trng_alg);
+
+	return ret;
+}
+
+static void xtrng_remove(struct platform_device *pdev)
+{
+	struct xilinx_rng *rng;
+	u32 zero[TRNG_NUM_INIT_REGS] = { };
+
+	rng = platform_get_drvdata(pdev);
+	xtrng_hwrng_unregister(&rng->trng);
+	crypto_unregister_rng(&xtrng_trng_alg);
+	xtrng_write_multiple_registers(rng->rng_base + TRNG_EXT_SEED_OFFSET, zero,
+				       TRNG_NUM_INIT_REGS);
+	xtrng_write_multiple_registers(rng->rng_base + TRNG_PER_STRNG_OFFSET, zero,
+				       TRNG_NUM_INIT_REGS);
+	xtrng_hold_reset(rng->rng_base);
+	xilinx_rng_dev = NULL;
+}
+
+static const struct of_device_id xtrng_of_match[] = {
+	{ .compatible = "xlnx,versal-rng", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, xtrng_of_match);
+
+static struct platform_driver xtrng_driver = {
+	.driver = {
+		.name = "xlnx,versal-rng",
+		.of_match_table	= xtrng_of_match,
+	},
+	.probe = xtrng_probe,
+	.remove = xtrng_remove,
+};
+
+module_platform_driver(xtrng_driver);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Harsh Jain <h.jain@amd.com>");
+MODULE_AUTHOR("Mounika Botcha <mounika.botcha@amd.com>");
+MODULE_DESCRIPTION("True Random Number Generator Driver");
-- 
2.34.1

