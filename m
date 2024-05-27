Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350C461FD0;
	Mon, 27 May 2024 15:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716823638; cv=fail; b=O1b8+CGkF2IuXawkHjL3GjPBcSNCog6SJSTtHmy5rxP9rf+pi1OU0m5dvIjrDsss6v0qKqvP7RjcQEdXXJzTZ4zxuT4KAlpexyfA5Vx9ORWJzYH9WWGak5BxR2ZW/kv3vWlZp6mJiR6VPuiwr4RsSccrs37ahgFI3hnk9iRZ71Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716823638; c=relaxed/simple;
	bh=YMILWaOGRWSMBvrwhfePgXZ/ZIjbeF/602QMlaOBQSY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BBUhPnlk/LNZXl6X/Utcaa0KhMBn3Ng8PK8HkCHPqTH4+pWpnAQTcVrWQdxnImxc4yOBiLAnK/likRMY5jqoJLmaFs1BhOgt1behYq/x/1970ceRtal2twppUR5g8LceRr6pzecGunHkzK5Ah3GL3mRhK5HTYH6SrHoWsiIUYsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cIEgzpTi; arc=fail smtp.client-ip=40.107.92.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cIEgzpTi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkpEYDlOjA9YmDYmagmp98+QihSyD78rycnnxuihCUlchTa51rsMu8EMyttFWPG0B96CqJtb2P/6nMiIUUYRqygGA+1+pMWbzyHFtdnZ5YbY1pEHAyGwSe9PG/2FXN56+vUDdproCGfvk7u2ToECYqrItsu+mCvTkD9Gv2mwz0Qw7ImFXRMUyNpiD5mXzdL94Psjz/ZRCjIjR5Wq8ij1fDo13RZXbB3GqapVRocKUNhSjLGUQRHLCHhemxHyduZY2eyzxtbR6saNpJltQi/o/L9Q1oJHMO7WVKosK7QncjLe699EstqXBiqoaG1b2RfnwaQLKG7JWPz/HXgXlv2njw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72JkkJTr3RB0Amnph3KZDQGNAS/VnqBT9ay/HYgD3FY=;
 b=LqDaPbWsPwdguwqfvrNIqfU70i4CUNvEKRfGnMd02NT6lsNszT35Z52EIJ4nsIWL+SpASqyrxyTgZ6ErWZ07zc9OuMrcsh/0tRstJRabLkdtx1JyBXnZZy7691b2MAsfIvT92xirnxetNq5YRm8JvsqyuHZlm7OrlamiF5CMx1rfJTzNES0n26Wmm4jqv/NPbg4UaYSZachCJPiPL8bifAAbA4M7PhEOC1OXi/iLkrXWt7xDjv5049nDw3EOeMLc8WlbvEU+tehPQ8JG82uUomwgzxkb0NjAcLnpmqRmxBwvLEOssHLDmTCETJrFYvCph7pgayoqgrRpA58jjgCzYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72JkkJTr3RB0Amnph3KZDQGNAS/VnqBT9ay/HYgD3FY=;
 b=cIEgzpTiKgIg0VgKJ7G4yUVzvFaRyUiwG1b2k6l1kIPtAPRa/F9ceJbMF3iTwAPA5jOX7nJDTFrAEM3SFiQLRLuyU5wAawmJDpSjjb49X9j2rxh2j+6qE10rx7okek8qqY+T1+fHbIVwY5cp6mOC01Z9EUMv/FW2wZOyFLeq+Nw=
Received: from CH2PR05CA0016.namprd05.prod.outlook.com (2603:10b6:610::29) by
 CH3PR12MB8401.namprd12.prod.outlook.com (2603:10b6:610:130::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Mon, 27 May
 2024 15:27:14 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:0:cafe::2d) by CH2PR05CA0016.outlook.office365.com
 (2603:10b6:610::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.16 via Frontend
 Transport; Mon, 27 May 2024 15:27:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Mon, 27 May 2024 15:27:12 +0000
Received: from AUS-P9-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 27 May
 2024 10:27:09 -0500
From: Mario Limonciello <mario.limonciello@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mario Limonciello <mario.limonciello@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP)
 DRIVER - DB..." <linux-crypto@vger.kernel.org>, Richard Hughes
	<hughsient@gmail.com>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] crypto: ccp: Move security attributes to their own file
Date: Mon, 27 May 2024 10:26:46 -0500
Message-ID: <20240527152649.3722-3-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240527152649.3722-1-mario.limonciello@amd.com>
References: <20240527152649.3722-1-mario.limonciello@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|CH3PR12MB8401:EE_
X-MS-Office365-Filtering-Correlation-Id: ebdd041c-0474-4efd-0fb8-08dc7e617b97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z67hZx7S2BJKWS2pNtW4fbyanUMAJHBjETWarB+x0d9K5kY5Hxa5IUFRGP62?=
 =?us-ascii?Q?lxYXTWkg/R+Bp4fwzHcGBEwaTm0qLiaSVck9xS9jSYvcXI+g3PuVt18pbrdj?=
 =?us-ascii?Q?zFKil+G6d6S9J+rN9Nntbi0I1QYeBjfJbQ4KYBnbq+aFZ0iQPLuI3lm5Yvt3?=
 =?us-ascii?Q?bLwqtM6pQqpCnw3xHoJ9+N4uXpuU/DTQ/MpPAPzfOQDrPKASe/ZbA81JkuwA?=
 =?us-ascii?Q?wxrdmuoAEvlxoQaRRoo/fT52XkhWgde9LIs2o4+GzQEUhGmCZ/VwtP0NTQTy?=
 =?us-ascii?Q?5mskqvUX/Y9CBWsrRNwKOT8phTlPuVTeWHs8OjKsKtufcu3Gd87LWpaVe5MI?=
 =?us-ascii?Q?v1JFl9ebxiBU2WTAjmozMPZ7biOuj2pp7Z4YdiDcAtsdTzavzMW9Fq6h01jy?=
 =?us-ascii?Q?OD4AqA74CpNdHAnUrjNoBLdiEccq8Fq1vIsOjqIT0PcqClGstJ9m3u49AdC9?=
 =?us-ascii?Q?yVVn/9sdOl030f5u6bWgXeczFHIbrSBVlNLrgjym36bAzby+1YxMkDBXP7T+?=
 =?us-ascii?Q?AaI/kMu/CXZhO/jZjuJaUvUAF3B0uxuSEzjz3TACGx0znBX6NJGfR9XAekqK?=
 =?us-ascii?Q?bPVaG6ORLmIzrcOewtaKx2B0utBiGUSk630QNX67Sg87t5lPZKOM+1XsGao7?=
 =?us-ascii?Q?Tq9LbILOCojYUUzKnNbEwJEVw6wKj0FOwfAMMlPlfW2S0vUQA6MI5KY3yQyQ?=
 =?us-ascii?Q?Vy/ydQhaSuQAaOtqiG0RyD1G0usDSVUxUVa/0BjxQ+rYkKsxuYfS5p8DiSYl?=
 =?us-ascii?Q?bRdAtg017frWn6ApWvTJ6L/henN7/ty174yc51HkwxKOEu90OoLJ7NdXXG6Z?=
 =?us-ascii?Q?9J1C2rKJZ/hAA7SqJHuEXTDU7rM3merM2QZvitjqBD2kNUQHLqhtTpufbNw/?=
 =?us-ascii?Q?bCdYq4fszuZODmlnR9BFXgfmHIWVoGsYiDlCZwOI2K7ZRfg6TpJwnSahyd6H?=
 =?us-ascii?Q?induPsXYqKBLgHPKhqkHLTDLX8R83cPhP7wxwBd3p22hD+JpIgUgDrx9+5Fz?=
 =?us-ascii?Q?gWK2MiseN4vVvxLH4+wIOtXCTHShRX4vnSeL31ZlpgPRiPknhkvpGVIS3kIl?=
 =?us-ascii?Q?nrCp1ZjZMKVfx5ebp7h8eSrfYxe5gs5cUTCUoGP1njtFh5C0KbH+GKpYkcf0?=
 =?us-ascii?Q?XBv/4AizzX/4QT9sg3tSq0UNN+epqAjwWcLRRn/mIxqvT/HPpCGGQNgy4tSh?=
 =?us-ascii?Q?7A2LtxrgZQyvGO2ZY+JKAJyy44SZupdgPOVM7B1tVMTCjk1CdnMLcsFLqR7+?=
 =?us-ascii?Q?pene8S1RFWuttUfKaupIyaCHzF2Lwlwpjuh/YX0V5tvif0m3z+rA+i5gUF+N?=
 =?us-ascii?Q?envKeIJOMurzmWT8rwWWNm7dme4z/p/0bQRBjCkKY7/1t4OKdmGGI/d7V4vL?=
 =?us-ascii?Q?7zLWEvxCoeex9FGQ3WtSH1KyH3O9?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2024 15:27:12.9567
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebdd041c-0474-4efd-0fb8-08dc7e617b97
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8401

To prepare for other code that will manipulate security attributes
move the handling code out of sp-pci.c. No intended functional changes.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 MAINTAINERS                  |  6 ++++
 drivers/crypto/ccp/Makefile  |  3 +-
 drivers/crypto/ccp/hsti.c    | 68 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/hsti.h    | 15 ++++++++
 drivers/crypto/ccp/psp-dev.c |  1 +
 drivers/crypto/ccp/sp-pci.c  | 56 +----------------------------
 6 files changed, 93 insertions(+), 56 deletions(-)
 create mode 100644 drivers/crypto/ccp/hsti.c
 create mode 100644 drivers/crypto/ccp/hsti.h

diff --git a/MAINTAINERS b/MAINTAINERS
index d6c90161c7bf..883fb3b246b6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -991,6 +991,12 @@ F:	include/uapi/linux/psp-dbc.h
 F:	tools/crypto/ccp/*.c
 F:	tools/crypto/ccp/*.py
 
+AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - HSTI SUPPORT
+M:	Mario Limonciello <mario.limonciello@amd.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	drivers/crypto/ccp/hsti.*
+
 AMD DISPLAY CORE
 M:	Harry Wentland <harry.wentland@amd.com>
 M:	Leo Li <sunpeng.li@amd.com>
diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index aa0ba2d17e1e..394484929dae 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -12,7 +12,8 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
                                    sev-dev.o \
                                    tee-dev.o \
                                    platform-access.o \
-                                   dbc.o
+                                   dbc.o \
+                                   hsti.o
 
 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
 ccp-crypto-objs := ccp-crypto-main.o \
diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
new file mode 100644
index 000000000000..076c1d175b2b
--- /dev/null
+++ b/drivers/crypto/ccp/hsti.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD Secure Processor device driver, security attributes
+ *
+ * Copyright (C) 2023-2024 Advanced Micro Devices, Inc.
+ *
+ * Author: Mario Limonciello <mario.limonciello@amd.com>
+ */
+
+#include <linux/device.h>
+
+#include "psp-dev.h"
+#include "hsti.h"
+
+#define security_attribute_show(name)						\
+static ssize_t name##_show(struct device *d, struct device_attribute *attr,	\
+			   char *buf)						\
+{										\
+	struct sp_device *sp = dev_get_drvdata(d);				\
+	struct psp_device *psp = sp->psp_data;					\
+	return sysfs_emit(buf, "%d\n", psp->capability.name);		\
+}
+
+security_attribute_show(fused_part)
+static DEVICE_ATTR_RO(fused_part);
+security_attribute_show(debug_lock_on)
+static DEVICE_ATTR_RO(debug_lock_on);
+security_attribute_show(tsme_status)
+static DEVICE_ATTR_RO(tsme_status);
+security_attribute_show(anti_rollback_status)
+static DEVICE_ATTR_RO(anti_rollback_status);
+security_attribute_show(rpmc_production_enabled)
+static DEVICE_ATTR_RO(rpmc_production_enabled);
+security_attribute_show(rpmc_spirom_available)
+static DEVICE_ATTR_RO(rpmc_spirom_available);
+security_attribute_show(hsp_tpm_available)
+static DEVICE_ATTR_RO(hsp_tpm_available);
+security_attribute_show(rom_armor_enforced)
+static DEVICE_ATTR_RO(rom_armor_enforced);
+
+static struct attribute *psp_security_attrs[] = {
+	&dev_attr_fused_part.attr,
+	&dev_attr_debug_lock_on.attr,
+	&dev_attr_tsme_status.attr,
+	&dev_attr_anti_rollback_status.attr,
+	&dev_attr_rpmc_production_enabled.attr,
+	&dev_attr_rpmc_spirom_available.attr,
+	&dev_attr_hsp_tpm_available.attr,
+	&dev_attr_rom_armor_enforced.attr,
+	NULL
+};
+
+static umode_t psp_security_is_visible(struct kobject *kobj, struct attribute *attr, int idx)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct sp_device *sp = dev_get_drvdata(dev);
+	struct psp_device *psp = sp->psp_data;
+
+	if (psp && psp->capability.security_reporting)
+		return 0444;
+
+	return 0;
+}
+
+struct attribute_group psp_security_attr_group = {
+	.attrs = psp_security_attrs,
+	.is_visible = psp_security_is_visible,
+};
diff --git a/drivers/crypto/ccp/hsti.h b/drivers/crypto/ccp/hsti.h
new file mode 100644
index 000000000000..e5c5ceab9973
--- /dev/null
+++ b/drivers/crypto/ccp/hsti.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * AMD Secure Processor device driver, security attributes
+ *
+ * Copyright (C) 2023-2024 Advanced Micro Devices, Inc.
+ *
+ * Author: Mario Limonciello <mario.limonciello@amd.com>
+ */
+
+#ifndef __HSTI_H
+#define __HSTI_H
+
+extern struct attribute_group psp_security_attr_group;
+
+#endif /* __HSTI_H */
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 7d9d2042be35..1a7b991c27f7 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -19,6 +19,7 @@
 #include "tee-dev.h"
 #include "platform-access.h"
 #include "dbc.h"
+#include "hsti.h"
 
 struct psp_device *psp_master;
 
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index b57392292af1..2db46736a4d7 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -24,6 +24,7 @@
 
 #include "ccp-dev.h"
 #include "psp-dev.h"
+#include "hsti.h"
 
 /* used for version string AA.BB.CC.DD */
 #define AA				GENMASK(31, 24)
@@ -39,61 +40,6 @@ struct sp_pci {
 };
 static struct sp_device *sp_dev_master;
 
-#define security_attribute_show(name)						\
-static ssize_t name##_show(struct device *d, struct device_attribute *attr,	\
-			   char *buf)						\
-{										\
-	struct sp_device *sp = dev_get_drvdata(d);				\
-	struct psp_device *psp = sp->psp_data;					\
-	return sysfs_emit(buf, "%d\n", psp->capability.name);			\
-}
-
-security_attribute_show(fused_part)
-static DEVICE_ATTR_RO(fused_part);
-security_attribute_show(debug_lock_on)
-static DEVICE_ATTR_RO(debug_lock_on);
-security_attribute_show(tsme_status)
-static DEVICE_ATTR_RO(tsme_status);
-security_attribute_show(anti_rollback_status)
-static DEVICE_ATTR_RO(anti_rollback_status);
-security_attribute_show(rpmc_production_enabled)
-static DEVICE_ATTR_RO(rpmc_production_enabled);
-security_attribute_show(rpmc_spirom_available)
-static DEVICE_ATTR_RO(rpmc_spirom_available);
-security_attribute_show(hsp_tpm_available)
-static DEVICE_ATTR_RO(hsp_tpm_available);
-security_attribute_show(rom_armor_enforced)
-static DEVICE_ATTR_RO(rom_armor_enforced);
-
-static struct attribute *psp_security_attrs[] = {
-	&dev_attr_fused_part.attr,
-	&dev_attr_debug_lock_on.attr,
-	&dev_attr_tsme_status.attr,
-	&dev_attr_anti_rollback_status.attr,
-	&dev_attr_rpmc_production_enabled.attr,
-	&dev_attr_rpmc_spirom_available.attr,
-	&dev_attr_hsp_tpm_available.attr,
-	&dev_attr_rom_armor_enforced.attr,
-	NULL
-};
-
-static umode_t psp_security_is_visible(struct kobject *kobj, struct attribute *attr, int idx)
-{
-	struct device *dev = kobj_to_dev(kobj);
-	struct sp_device *sp = dev_get_drvdata(dev);
-	struct psp_device *psp = sp->psp_data;
-
-	if (psp && psp->capability.security_reporting)
-		return 0444;
-
-	return 0;
-}
-
-static struct attribute_group psp_security_attr_group = {
-	.attrs = psp_security_attrs,
-	.is_visible = psp_security_is_visible,
-};
-
 #define version_attribute_show(name, _offset)					\
 static ssize_t name##_show(struct device *d, struct device_attribute *attr,	\
 			   char *buf)						\
-- 
2.43.0

