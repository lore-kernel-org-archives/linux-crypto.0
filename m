Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77A822FAF4;
	Wed, 23 Jul 2025 18:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753294954; cv=fail; b=fTxBdirKHQxA/O2ix9BBfcd5RY0rQv6ml3PWDoe+bfI+3S0ATwZm/9C+dAOZH0V8CUWhXxVfco0vJN+fCZk20QVRJGKWntCXULzYUeOPxLgArPuYRBws4OXyrebptBADqUWRcUdJZZ45i3LCPZgLxk+Y5wpwht0uSle2OnPlh8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753294954; c=relaxed/simple;
	bh=/aL84wbp148C6EO+mzjsTuNO/ucR+FzOWbuFS3HU0m0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KseNIegW5pXCZXxATRXAJYzSGEVz87MEjC2Rh//g8gEIrhpwp4erhVSnSNBOWLQ4BouQF1x6lTGhli1zdyLPP9xcGzPAs7jMZw864tWMq2SWTqAGz2/s24x2e7xDLdh5r6QrEUkkVHs9+aotOCzRawJlgW9JA0FzgyjwOlJga9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=h7CF7ItS; arc=fail smtp.client-ip=40.107.101.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="h7CF7ItS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lPDpBJmyS3MFaerVnDSwuU5Ubwk8Ma3OvuQfwy5EabEwRBTAoRoEbX8A+nV9OSHC0DfcyzBcjjJ6b7k9aAA8up7iUEmLfpKh8b3hLD3YlPhahqBvmH3s0fH4cAsLZxDB/hj/fb8i5UCzZZND+hCT6MU2/So4dFR9OUnCNHgJOO+TtNglGaDjf2HRHSgN3ceO+2nRBJ34lQxgFiJ4LhY4Yayveko8uG7TxvB5kjny05K60JfLXkT/E221AxlZHOZ33nb3amNzOEv6v3QiIKHMaCVZN0gsOhUrVO+7CaJ4ylKdBSjOpb9SuRY4zZWgJ6TiCftp/SMNBdN95GCUI/dsvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVKeZzPurJgwsP3YutEpsE2gB56K6oWdkefiPa99e3E=;
 b=Hqbw4QB6r5q3Rmzcm8TTrUQ4vG1uvevrAWnjorzazP7x3lwwx9cdff0gQPGEjrxpaOaqRSasCaSPxd6Wahpeqv0GEhKfr/u8kxxKOCtnQdVPLBOtSe/iESjVw2M6vLY3c2OO7jDFI4yNbpwQa2P7XkjpTI4mVEZ4Q6Wj7EeQuUeWIFpKfIflUD/LTEbLOo3FAZ0VNq40QSIxmk2MgN51TyNulMCvcz9g/Pp7hTGnDm5gPdlqA2+gb3m92orIt4PljXHHnlkNmhpi+Iq4agjvvZrC9c2feJ1ut2Ba5vczNymldGKnn+mevm91BsTPYZYnnbOgf3t8fpFwObMej6KYRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVKeZzPurJgwsP3YutEpsE2gB56K6oWdkefiPa99e3E=;
 b=h7CF7ItSUsrbCnmfSKOJpWY6MHNGHVIO2h9WySYhb11gQkegVaAhzrk1V/WH8aK95pFbKUAlH/dUxHUidFOOxSC42bVXvdUv0AeZOrVHkDxFVXsDELgNLc+52VH8fqPuwuCyQJ9L0+yGa4uoQavFx9SzGch4WNngFA60iKbuvPY=
Received: from CYZPR12CA0003.namprd12.prod.outlook.com (2603:10b6:930:8b::16)
 by MN0PR12MB6128.namprd12.prod.outlook.com (2603:10b6:208:3c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 23 Jul
 2025 18:22:30 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:930:8b:cafe::61) by CYZPR12CA0003.outlook.office365.com
 (2603:10b6:930:8b::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.21 via Frontend Transport; Wed,
 23 Jul 2025 18:22:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Wed, 23 Jul 2025 18:22:29 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 23 Jul
 2025 13:22:29 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 23 Jul 2025 13:22:26 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>, <smueller@chronox.de>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v4 2/3] crypto: xilinx: Add TRNG driver for Versal
Date: Wed, 23 Jul 2025 23:51:09 +0530
Message-ID: <20250723182110.249547-3-h.jain@amd.com>
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
Received-SPF: None (SATLEXMB03.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|MN0PR12MB6128:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a15a77a-65ec-4821-ec53-08ddca15e278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K+c8hgKcScl+bIUfCxlcqVZtZwIdu2Jq3HxekyFEzRiSbeGTKBDamycSK15x?=
 =?us-ascii?Q?Rl9rYLdIgPSDG7wuQv769K6dzA7SyxkhQS2LcEpRz+/dST3uEues2//7xBNV?=
 =?us-ascii?Q?WBMmWf6wY7J6rCECBjRs5IqJ8C19FpHtmw1n72N8QK2ZzEJVbVHV8EKDzTu7?=
 =?us-ascii?Q?ejuT+fq8slZ2OptmobykdVXF+2sN4MZ2upFBAMjcw0QqEy7As0t4YWWlF4d8?=
 =?us-ascii?Q?J9ujDIAITP72fU9xH9kKEXEm9aOnBZ7PJgzsIOBQbu5d241T9U+8nlS9Q5t4?=
 =?us-ascii?Q?D9q4ibGBGbS0p+vD8la40vhuLZLXzvF0qt8bPSpFbey0mQkmxp+mM67KkLxA?=
 =?us-ascii?Q?H842ONfcDOlCzgnT1e76N/eZIl+kXXdJVuAQN8qZf8lLQTWltLY8m0qTfQYj?=
 =?us-ascii?Q?lULgeYj3ULJI75SH52kIOtHLqnf9HF07zbubp1BER47qsr0qgpEgYH+kZRHY?=
 =?us-ascii?Q?WLigtMBDpqffmcDCqCU9F0TbJnjPx1GAKqISjVAFg3BO19E67k78qxKjoHnn?=
 =?us-ascii?Q?OIOA/hELKHTYrbabsROk5GI24GqHZLAiUX7F9PqwWwguWdzJxr+DTT6IgBmD?=
 =?us-ascii?Q?sEetFwQPnUBRjwO8o1N/pr8SGJC9BnVA8RlVwOyWJYNfO1mFt2cem2XFhWBQ?=
 =?us-ascii?Q?Zp5CvO0KU0o01c3b5uHpcHfJbuNKFvmW/6vAFjFgqL/SysiOWYmk3uBsyeTY?=
 =?us-ascii?Q?KzCWsCM0uLfU47qI3IBNZ02tYPIWGs+PSFz/FSUkr29HzbHlxZxXqwlnfxhn?=
 =?us-ascii?Q?hxGToftK6i8o2gZdAsSFphu7abYi33mUedpL7Hzg0862KdDrWMDZpBU86cxI?=
 =?us-ascii?Q?No83VczeP5jafgTYfkXif729aeiXJKxuSLnuwIvpVpRlLG08lyMmCfglODj+?=
 =?us-ascii?Q?1c0qavAwwymGJ1SWhwgTEPAPBQqHVy0Mjdc2Vfx4DdRyqKNYeUq147+XJTgQ?=
 =?us-ascii?Q?HUoNkaMD7rbvgfNiFcfg4ZlcJ3YadoBjK5xsasFFJCnDBZkjEQVRKqQlRvt1?=
 =?us-ascii?Q?yA2WeT/UBX3v9MPztT8HRh54v7WTWvbrIWj11Anu7/TJsnHpuC9obLXFOTkW?=
 =?us-ascii?Q?o3I2GwZTE3RokRmbz0hexC9enhqpMT9edNxyNACyQLC2UBMfNy0guq14GoLT?=
 =?us-ascii?Q?/sq4Rm9E697uQhm/835fsS3yWj/myY7ctmVvEdNiZOcSzBzMQXFU0Y2yTg8C?=
 =?us-ascii?Q?TXuTU/Zrx+zbiGCTXt1tngb4yaEG9Xxie92l4KsQZwAbyjpu1RmlrLEcM3vS?=
 =?us-ascii?Q?l+Wi2IQQRnkT4EOW6hROU3cnf8OMTlA1CGlDNJkfh5BXcadKbpLmKV92h3tk?=
 =?us-ascii?Q?kdML2BE3bX0X7arbLDV4SMlEkuU5DKvVMyky9UqVNw2kn5Z8psBGmnEiYt+9?=
 =?us-ascii?Q?peRWzNBTkDIMH29eMLAU1CZa3yRWI8qMCGzX6bW0Ny5Yy/qLIuaZMEM0bQfj?=
 =?us-ascii?Q?D2GW8OIBJhu0DCwE2Vo05hLUwJKrNk0C5YykJhRupK+kngWPRhS2SRZGWt6i?=
 =?us-ascii?Q?cUBAs85wYVgF/3Xi+3kRm1KrcSKTkUlwNyPxCzUHrP74UJOomSBiM3YC0w?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 18:22:29.8307
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a15a77a-65ec-4821-ec53-08ddca15e278
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6128

Add True Random Number Generator(TRNG) driver for Versal
platform.

Co-developed-by: Mounika Botcha <mounika.botcha@amd.com>
Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 MAINTAINERS                         |   6 +
 drivers/crypto/Kconfig              |  12 +
 drivers/crypto/xilinx/Makefile      |   1 +
 drivers/crypto/xilinx/xilinx-trng.c | 402 ++++++++++++++++++++++++++++
 4 files changed, 421 insertions(+)
 create mode 100644 drivers/crypto/xilinx/xilinx-trng.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a92290fffa16..e0a89fe78727 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27176,6 +27176,12 @@ F:	Documentation/misc-devices/xilinx_sdfec.rst
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
index 04b4c43b6bae..53eedc0dea4d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -725,6 +725,18 @@ config CRYPTO_DEV_TEGRA
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
index 000000000000..989d2dbee124
--- /dev/null
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -0,0 +1,402 @@
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
+	u32 val;
+	int ret;
+
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
+		memcpy(data + i, buf, min_t(int, ret, (max - i)));
+		i += min_t(int, ret, (max - i));
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
+	{ .compatible = "xlnx,versal-trng", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, xtrng_of_match);
+
+static struct platform_driver xtrng_driver = {
+	.driver = {
+		.name = "xlnx,versal-trng",
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

