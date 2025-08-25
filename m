Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C883E265CA2;
	Mon, 25 Aug 2025 07:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756106247; cv=fail; b=A9zTKOKDl4QacOd0nUIqGA7+9kFCvgHMzzRYplEG0/ESdpBeyU4R1EC2xVxzSEozABG2Xa//PJVzczvFVyETWCnfHMaETSna6QjibYoAQSHCPni/R6Tz/42AlcW1wnp+6uppfv70WyTwDXLJOzP89k55SHZtghnzByR6Y8WibzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756106247; c=relaxed/simple;
	bh=F/PrDA2pghW1j48v9EG1U5lNQ+NogehlbcqhRufsmxE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EFnVlujlND4kitYdXPkb45WtoB1C13OLsYQ8XWf8LuD1MtoOKzzgwLbFITUpPHAhZ5+ZWsQGf1BnvOx3hTequHo0mCSkj0Pcp5WxF/tsYQefFhaHyvZjKQ9wkQSqrCLnArvgKQBfN1ivr7cqJDVnwJi5Reqv89ZnMrZI1ZOhVRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XUoC34Gi; arc=fail smtp.client-ip=40.107.92.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XUoC34Gi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D9EhlUdpW5taJZj3RxgpK0Mpl1Ih0m404aTWdkma0cHNxXxRK9n1JSz6Ok6oK6kIirWR/8Qn8l3qSQwcPolGheYs2leV2DPKF9KAFSVzW9qywas0K67BBmtNsQOfjYqGmf4LKPB9pyNyO6mQvCUgydflJPmTIAVEYbONOvFaPVGlbU+wm62whjT5GyORpZl7U0Ti/HQu0Hsu2DA9cK70w0LGg7B061XMAix/ca3lrBbUV8q7HoCRKaer/gLR2tAfkLC/7TZEM9wEUjm/m+UcZAYrXVnOZTPFT1IY1wDHGElqfQ3oW1Ex8v9pxE5B+mdcrWnPgqUh1s8N4Jo8OpIXgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a5sefF+uJVrNn0zQ6w8WAuEv6H6KBP7GNan40jzCMrc=;
 b=x+hFJ0sQYulxmwZiG9OZS+nXuGaH6IQQO0XLhPMQ/tD6I/j30vDDQuu30d3F/Igim0hX/hFpkIetxZpTi7zIX53xpAyXKuqHfR2F+VzzKEJsdy2iPogRFJdt0gVReedrVju92w7ohoaW7JC2aadCw8mBz8ew8GtHOtwm318H/xbrbaGa5KoD9m7wAOjI5VxGC/SZi7dTK5wvR5+dM78PRQSJAFwW8Kmiix6ryKedymQSODUhb2lE2WaSrErZuFAY4hNrvgAY1cfm9d30VfozXZBSaooJquoUWlG0JQQOXc510nVMMIzjugftHEzb2M90GZ+06Iy3ggRTySeH0o3FcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5sefF+uJVrNn0zQ6w8WAuEv6H6KBP7GNan40jzCMrc=;
 b=XUoC34GiWBp3aj5WbLR8Fx7zQUq1Nthmbo2h399CbCQcmZXD5BL6dGAaBeGnb4dpiTNcdLWDHFPdgUbQzM/PfAYfdwrgESDpZ9g6OYHvd/YR/HRUqbRAWbfZPiYrcu5xZc6EiKcuLSNEFzRxb5qsw62oGCK8adJNi/LtqE3aXw4=
Received: from SA0PR13CA0001.namprd13.prod.outlook.com (2603:10b6:806:130::6)
 by CY3PR12MB9556.namprd12.prod.outlook.com (2603:10b6:930:10a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 07:17:16 +0000
Received: from SA2PEPF00003AEA.namprd02.prod.outlook.com
 (2603:10b6:806:130:cafe::d1) by SA0PR13CA0001.outlook.office365.com
 (2603:10b6:806:130::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Mon,
 25 Aug 2025 07:17:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003AEA.mail.protection.outlook.com (10.167.248.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 25 Aug 2025 07:17:14 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 02:17:13 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 02:17:13 -0500
Received: from xhdharshj40x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Mon, 25 Aug 2025 02:17:10 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>, <smueller@chronox.de>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH V6 2/3] crypto: xilinx: Add TRNG driver for Versal
Date: Mon, 25 Aug 2025 12:46:59 +0530
Message-ID: <20250825071700.819759-3-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AEA:EE_|CY3PR12MB9556:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e8748a2-e59d-4e2d-b1c0-08dde3a76a9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lmPmB6kKMUJn1LRsTXkWfSjYB67WDUjtP7IQ4LT3UWJj3At7ir37G4j9Mo9S?=
 =?us-ascii?Q?JIaW2U6wsm5axQ7ns6DPwqwj6jfgjPRGPVLcak3+PFWCjHxCBjIGaXc2ByOM?=
 =?us-ascii?Q?QDq3P5/D+CSQLV6eci7qoxLSqv9h/SJheScvc9DDYhR2CHassY69Ei+Gyfz5?=
 =?us-ascii?Q?35Wwd2Llf/ttUlrr90LEXijXAOGQFa04xPmzyBI4BIfbLof1eXz2mqnJBoP8?=
 =?us-ascii?Q?ZRTRqiSjjy+/pW5+rpjguiP6cp0ufMqpUORfNC0ZQwd+x1mJsQm3c+4m7SDk?=
 =?us-ascii?Q?a9q7e4DgkOJszG/72uuhkzRtW9EVMd9HEIOdgrM7VZoTEr4tcNKW+pW2nln3?=
 =?us-ascii?Q?DJvyih1USSx7S5hH5DHiVSPit/3Kd2a0fzGiYfZmFninH0uU3BsIEGhYEa6L?=
 =?us-ascii?Q?v6q3SIA+VW6EDYT6Mp+4ir/j3mLlG3JfEZjcDqGuxmSomUOwUeTJv+F2l4NH?=
 =?us-ascii?Q?ZP1knZCK4etnnBBSMM78qsgZv3JYx48D++Z2yKMQsDk2tPJBzMrTCijNpQvf?=
 =?us-ascii?Q?wQtm329AHnvDMzGPgI38g9HsfTZ5wSAKW5FxZS2wvPLCgZpZRjrOBOvyIyT5?=
 =?us-ascii?Q?0QM4HmvYvHMvS1c7wadDQapDivQeXxmM2HDBQzp0AIvQgd3VXzM5Ff3taD2k?=
 =?us-ascii?Q?pguZY9QQq/r0H4mJGw9ctp2EamsL0cE3yi0p/AqrYlZSqkm9qtqIhpjMkaA3?=
 =?us-ascii?Q?O8C7hQU3Ued3StZ5VBrzf1qXIZ3Ip/NTloiFmZjdhEyQCvqUJoWVq4+Tk3H6?=
 =?us-ascii?Q?F6R5mxBoyByrShqxhp/GO3jI6snon3uDgxN/evEyGbrqL7bLf6W1J9Fq8GjQ?=
 =?us-ascii?Q?jKipYvv2f9bnO5iwGeUeX3T7cQBhiMeuOC4n4UMxswj/hYq0QWiFVIY3kW/T?=
 =?us-ascii?Q?m0g9kRWF7F7HWEVSv207yutCKiT5v1ygj+d9IOfwgCqvNrjx5DplpoMhujzn?=
 =?us-ascii?Q?MGVX/fHR7yTbtTTsRPSbW2JJ0Kp6uCW1Ww6iDBQLJ4rGA35K6/q7QhOquBWH?=
 =?us-ascii?Q?Asd6JR8pOZOOa8qJtZIucvbvxbvuDinWJbh4V8uqRPiQSdXnWT8Z0JaICVnA?=
 =?us-ascii?Q?EF9votCyuFfGpXvlhC64qQaiQ8D3gO/kUso8oIlD/D3xekSJk3Pa94d7WUj/?=
 =?us-ascii?Q?XWzQV9pU15bbKP3+WWxm6CC695VZkQ7oaZWLhqcezVi4urzMzT4LT6sxLGQe?=
 =?us-ascii?Q?tQJV/lmamQcVGvr4BUiQG1RotOBsNJ7nleWzVXyM7+AMIl115HlfIgEKfYT9?=
 =?us-ascii?Q?2sgT8rBoli6+H9/NLoTWI6pp5NifqJTfqi89mervO1QT6FX1/cZeV45LNFOI?=
 =?us-ascii?Q?Ad7bec8PHTCLQlRNq8rdCFe3YWVCJZ4v1Tq3fVYl92Q7+XJpKMUhhUDqk+Dq?=
 =?us-ascii?Q?4y71SOmaUlyj78BiwDiozfJw+5GiflCovOjGjjF1CqFa47VHsZoqpibv8YBg?=
 =?us-ascii?Q?lYL3eMg7wylnh9gHOyEZvh0sSQafPbIg4+58VqFB0pp1Q3kd+98DeXkj64VL?=
 =?us-ascii?Q?i8ygwrNQqvsyiysStR5zeEJuBOxW/dk28UKj3S6P7SQ5Vp0rZ8mkzFPnXw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 07:17:14.3316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e8748a2-e59d-4e2d-b1c0-08dde3a76a9a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AEA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9556

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

