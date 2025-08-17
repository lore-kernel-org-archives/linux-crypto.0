Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4031A9FB0;
	Sun, 17 Aug 2025 10:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755428062; cv=fail; b=jaM098rpnDTGjL2zn2uE559Qep7TzEoRqkWrtyBXUi8Cekjv1ci19VXRaSIdOM/ESFD7jbG4O0kb+hAGIeH2d6s2huvv+taf3OR0KrWNr9t0u8o1Kv9bz22U7paBZM/UxdplU4iKb5mjqwGGt7lCmNIZ/6GVGNXf4hDafUeUhVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755428062; c=relaxed/simple;
	bh=F/PrDA2pghW1j48v9EG1U5lNQ+NogehlbcqhRufsmxE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eIuL/iI47UwJGfdSZiQ8aNB9EDJvLh8PvaTDORFYO/VHCkFWhXGymHjKyhljtdBzCL0RZrmX7zE8Zkkor88qVBlor/ywoHHnjfATFjst2ZCwkKJHsb+7M6L8K0hKRhxBkMJ8Jf5posXr28tcPJsuo5fheWyUCfzdf8kYUxovemA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FLENLyPt; arc=fail smtp.client-ip=40.107.93.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FLENLyPt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AxKQ37BbqKn+mt5w0LEY8QB02UCdU2GIpGMgd7vXO5LNv3/TkYUc4BIoO8rNwXScmaqs+vWRGMFfY+gqTNN8xGsvBYTgSlUqwH6Jr0r4xORJLR7wlS3wFIltSDTPK17JgoYV5yTgLetRolEGt+f7YBmwgY6I201uth3V8P+t/nCswu0bPB/1GoRUH4t9a7+YeFRR4HRnv49GwdjDU6g/jXktc3y6ocisZhjhfBRXsCRRdYwW7NWfsYS418DljIceLzpIdpBBjliSYzsjWcrpHb6NbcDkkTC8gQbL0EzBzBlYG60WFKIz2B+rhES84jEgn+tZj9ctRhdD14rYhymprQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a5sefF+uJVrNn0zQ6w8WAuEv6H6KBP7GNan40jzCMrc=;
 b=Gxtm7xdlLts+2LQC+UZSKoKOw9IhxH1U69GkkhG11ODQQtJsMYVC/NrgoJxLbCU43ZLTDtGsSkD1AubmjkHnr3WM+uOLqEM4IQwlIuDBd3bazDF8tWnsz+YJ2JJCaDxTqr6OBp433Y+i+sZxU9NYQBkmGSIQzJkV8z6HTTOSR6HIwCjnyEn48+IhSxdt32K4FQo63EyXqAA0+1X8OyTeN69+sGgCBbNOSurQc/3nKUqsXeKUQoMzuMLZ77uVsRpz1iBeHMKvIi+KwMR5cx8qLxcjwNdyunzUZnEoaU2vJdaldJP4wnvrNEOBcpj/HsaV6ex3A/hZs2CFKErh9bxmNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5sefF+uJVrNn0zQ6w8WAuEv6H6KBP7GNan40jzCMrc=;
 b=FLENLyPtn46k0hSHNHTcLkHr94jp1nKTid3rCjwcIqx8nx6DDc4/MULBmndNrvWnqxUCQ6/aVP8yNK7F0Dx5ti87Vv2sYLBMNT42BQMdC4tm6bV+ni73tA5XkY29tiLShig6yS3YwN8NDKeHslR+FkpaBxg3fHKtmO+HfBFHEMQ=
Received: from MN2PR01CA0041.prod.exchangelabs.com (2603:10b6:208:23f::10) by
 DS0PR12MB8019.namprd12.prod.outlook.com (2603:10b6:8:14e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.22; Sun, 17 Aug 2025 10:54:11 +0000
Received: from BL02EPF0001A0FD.namprd03.prod.outlook.com
 (2603:10b6:208:23f:cafe::b) by MN2PR01CA0041.outlook.office365.com
 (2603:10b6:208:23f::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Sun,
 17 Aug 2025 10:54:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FD.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Sun, 17 Aug 2025 10:54:10 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 17 Aug
 2025 05:54:10 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 17 Aug
 2025 03:54:12 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 17 Aug 2025 05:54:06 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>, <smueller@chronox.de>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH V5 2/3] crypto: xilinx: Add TRNG driver for Versal
Date: Sun, 17 Aug 2025 16:23:48 +0530
Message-ID: <20250817105349.1113807-3-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250817105349.1113807-1-h.jain@amd.com>
References: <20250817105349.1113807-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FD:EE_|DS0PR12MB8019:EE_
X-MS-Office365-Filtering-Correlation-Id: d8873010-b267-4c94-5bcf-08dddd7c65ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qy94NZfc+4220YmUaOp86umXaA/NGJvSV9BE6duGcCEo9SA6/9p9d+EkHt6e?=
 =?us-ascii?Q?uswVyDZ2TTZXcc/mBkpkVwZnhx9J/80OZGTemioHdgvKA3s03bv9y52J9Ogu?=
 =?us-ascii?Q?S+8JOW9UMgPyegL8W/YIUk3/V96K+Za1C64Is9K9h0GajaiXs/m3yrkJ5ZWC?=
 =?us-ascii?Q?A5opHYUGxLkJNvVxUIoVL2fs4LVj5ec0NU9+tlpJaW7ceiM6p7Fc4ynErwY9?=
 =?us-ascii?Q?7ZA/zWjgBp9PgIqgrYJY0biHmkpdsHgpPXDFjHic6fW581QhhOgg4QYkCc5M?=
 =?us-ascii?Q?m4o0udwGCCRJA0+mMlSLJ4McBBFWSgD8PMw4rpVg4uXPM5kvJLhlU0Yxs9si?=
 =?us-ascii?Q?s0ny6ViUXQy1LmVWUGQ4t4P2UIpsSh1G2e6hFuUOr0lqsUInp1A2zu7pO60/?=
 =?us-ascii?Q?QEWAmJDSV3bZOxuBf5G/AQk41mS1LvxnfHute8pMNNnkBBgMJ18s+PUmiMYB?=
 =?us-ascii?Q?p0z+f+1QgW882/btviefCJRIFD6KShMU18ib9JWkUmDhdoixaVOWp6ChCHY2?=
 =?us-ascii?Q?S9Sml1C+mRKnxhUHIj7SHTj77fiPsRyt+3/kyRmWoqPODMR8vRoG1RmBwME6?=
 =?us-ascii?Q?WhGCtTeRd5YC/K/Mo/GsraA71PBm6MmN74Npz4iez8mfUjW8hhyZP/nszIoA?=
 =?us-ascii?Q?guQYrZ0DF8w6o119lS7K/IQzejkkYMn7rgJ4cwixhery0nisVkQLAv/XUKGX?=
 =?us-ascii?Q?9c3unZRo7MnuGEzIR6SBtAqNuFVibt9Nqxn3KoOkTwHyX0hS2/OGQMAySqwx?=
 =?us-ascii?Q?tA8z1idQEqFCRMU7JzspYTPaBNdVJ36TimJyNqMbBFX/k0P8S0CiO68cj3Ap?=
 =?us-ascii?Q?f6MKtQmOpu59CuH2RO/6CccZBk84b7aJsxuSxftpmkwanNpyw9v3jARPMWx2?=
 =?us-ascii?Q?IOdIZLp+stB+HHSUJgzhYDIAtsnj2oa8RlPexxrFMsB0PbHlZuTkFdxpX/P0?=
 =?us-ascii?Q?HES5DXBQCmHvidZT1Mje7eyg6kK1aFhLLtvK7zzigsO1/qbK2ieqBnDHSiCJ?=
 =?us-ascii?Q?JcBtjl6TNOw1zri/YHsW58HREM0ZKzwMmeJWLVSKjlIXTC0WlDmKMFiz3EwX?=
 =?us-ascii?Q?i7vBxL7iZ84+S2tUnbypFw0CRz+KSPg7rfIwcT7+EyjMfmlkGagOGRirCwqh?=
 =?us-ascii?Q?DoQI2G7Uu7fGe7+7O8ZJM7wvRdBhZQE/2XKpXTh68IQ6BuTKIXhmwgBCQa+W?=
 =?us-ascii?Q?WtX+iv0z71i8smXmLg9ZGuvn8WJujOFL+lGElq6dz+wUmrA4ruvG0BYI1C1v?=
 =?us-ascii?Q?k19XOZTulImeaOsw/dOuAcgAaX0ycxJssZ8w5m/wE7PomIDc7udB4AIrGaiY?=
 =?us-ascii?Q?ElZaZrzqkC0QY+F7vanRPwDleRhJju9ECpljQ3xXhOt2MMOsanuHtgQyND3l?=
 =?us-ascii?Q?kC6mGDR1kwvmAWi2wvA3L9uzO4pvaWkEsyy37cE0zjUBt6PUdYz3qS7arE3H?=
 =?us-ascii?Q?T2qPMVMkDUkJ0tSBGjht7Ye+NsC+wxv18XnXf41iPbFkSakKjICDILWx1VhS?=
 =?us-ascii?Q?rh2q3Tlrp3fS8SgT/KX+aCHwU3vq6Roz4lHjpCDp7VAju9gRowDAFuyV5g?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2025 10:54:10.7649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8873010-b267-4c94-5bcf-08dddd7c65ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8019

Add True Random Number Generator(TRNG) driver for Versal
platform.

Co-developed-by: Mounika Botcha <mounika.botcha@amd.com>
Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 MAINTAINERS                         |   6 +
 drivers/crypto/Kconfig              |  12 +
 drivers/crypto/xilinx/Makefile      |   1 +
 drivers/crypto/xilinx/xilinx-trng.c | 405 ++++++++++++++++++++++++++++
 4 files changed, 424 insertions(+)
 create mode 100644 drivers/crypto/xilinx/xilinx-trng.c

diff --git a/MAINTAINERS b/MAINTAINERS
index fe168477caa4..e8424fcbc255 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27602,6 +27602,12 @@ F:	Documentation/misc-devices/xilinx_sdfec.rst
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
index 000000000000..4e4700d68127
--- /dev/null
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -0,0 +1,405 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * AMD Versal True Random Number Generator driver
+ * Copyright (c) 2024 - 2025 Advanced Micro Devices, Inc.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/clk.h>
+#include <linux/crypto.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/firmware/xlnx-zynqmp.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/mod_devicetable.h>
+#include <linux/platform_device.h>
+#include <linux/string.h>
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

