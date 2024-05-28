Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA73224D1;
	Tue, 28 May 2024 21:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716930464; cv=fail; b=YcIWcfXPmWV8ljFG+6nKblJmrxSivAKBnziI6xJEQshnvURj3LwFfH3JsIscLUFsBTLCaxXgClLmi5ciNF9qhXTVmr2aGIIeRcEna2FoR6nEdJWOB4UFNN3vG+Js23gwTYke1iYEgyJ0/8eUDxpW2x8HuojykKWZoavhCS+mq/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716930464; c=relaxed/simple;
	bh=+f4Lnmwh2gzeqUWqzm4t5O4hfXQa4KQqwOz+GY9rHvA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iiF3wBHVXOLjEJXFj7fLD1IoT7PqA5Rmpo5W06MrB3ufLzQ3kzil4oYBK1rPRyLbRUdPWMNfv9mFuOqbG4Mzgf8UejC3kbYT9GtDIZ4WP1iXrYlS0t51AmyJhZPNsGgeMDqPrhIBcK9olLTFY73Ai5enNeOXqxVyEcQw/eio1ZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q+09dSjY; arc=fail smtp.client-ip=40.107.243.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q+09dSjY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hW4jn4ec7oZT74zdVBAtlwRhtoQznJf5WqVKdlp/naUmdKRewUUomn1ARp18vT7Mpm8Au3wSCgylX+XJoOJK+3gLZ7crm+IJagfmbpUm/ohtTK6RN3ptr5ukChyNXnzr/nf2zqjqP6eW4dfuOvRqwS4NzeVDWxL6yuqwzXjK3YoV8N1iWOtb9M/e1satkKnEYcOFCn9fW6xLnDX1Xal+jj+YImJg0IbQ0BpAuZ+j6BiPf2IhKgcpXYIRWeMCDIfqG6C20QsCIv9QfWdwIUEhOAesUf+cf+0FYGVn9ExFYnHyHfsmNXtueh+j8CKfMB/97FSCv4oJEHgFJ+Z3mqXBHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJtYjAp0J6y+yVYbmMW8UV/A9XznDq/6znnfIjRCkT8=;
 b=ihvu63+KY5XVatUSgC1fQkTkYNuKLETTNj87yKfBRq6nhZNsewRUjlgkd6YFD1h24KwjqqGngb/jBzaeGmpovRxPPu4Z0hDba5d0FsVvGejEFgp3GLXrrMGZw3xpubV3bCjDwRS78nUacfK9RNbwfrGIp6vaHT16l3FpFjpD3h9YebCvbr4gY2vlwyYs9f0aEO4WzYUcQSy2nz+ltlgPfsJhD864wRJ3b2S6uj3MzZCFofeSO5WVMNdvrG+mTNaMDngLB6R7G0EKrVFWaDAnSFM+tgkmhOgxVSW1QhWzjUr2GfKnBfnStZEfXB6NGl9LM+1dTAOxUJA6cwdLkV0/gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJtYjAp0J6y+yVYbmMW8UV/A9XznDq/6znnfIjRCkT8=;
 b=q+09dSjYHjzoH6e7Kagr06jTI23ihD6CL+VySBsn5ZO20FJkv0rumAwa9FWG4vv/gFGDXp7s0yb+apT8y+UFRMIWzwjWOyXeKoTuAUok7u5v1hJ8Ku6Pz80HC7B1psBb0thamjXfxDEBy5Ob4h0xPTaWkDnK7L5xRr5jboc7Oh4=
Received: from MN2PR16CA0012.namprd16.prod.outlook.com (2603:10b6:208:134::25)
 by DS7PR12MB6311.namprd12.prod.outlook.com (2603:10b6:8:94::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Tue, 28 May
 2024 21:07:38 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:208:134:cafe::9) by MN2PR16CA0012.outlook.office365.com
 (2603:10b6:208:134::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30 via Frontend
 Transport; Tue, 28 May 2024 21:07:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Tue, 28 May 2024 21:07:37 +0000
Received: from AUS-P9-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 28 May
 2024 16:07:33 -0500
From: Mario Limonciello <mario.limonciello@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mario Limonciello <mario.limonciello@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP)
 DRIVER - DB..." <linux-crypto@vger.kernel.org>, Richard Hughes
	<hughsient@gmail.com>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/5] crypto: ccp: Move security attributes to their own file
Date: Tue, 28 May 2024 16:07:09 -0500
Message-ID: <20240528210712.1268-3-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240528210712.1268-1-mario.limonciello@amd.com>
References: <20240528210712.1268-1-mario.limonciello@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|DS7PR12MB6311:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f674aed-a13b-4abe-edc0-08dc7f5a33b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hc5AM6Bd5zHDnssoSUosPta+9GJFDjuiEKaACCm4vXzhOnfFUUAofzKjNfnR?=
 =?us-ascii?Q?7CgEcJyjwaJXbWIWZGG1NyRCh73nQDp0aeVSolfMzZjxAwg6Xc5Sk5AX1Nlo?=
 =?us-ascii?Q?AQfPjTm1GHWobpNAYitM6pYR/CL+LIIH9ly+3CD19Jbon+9OivdhOm7nEBWv?=
 =?us-ascii?Q?CrV0P4WFiO0v7LmmeRfZNV76Qw7HwhEwgi3zdVzhQPCktRJqHBiGEjK84Kli?=
 =?us-ascii?Q?kyZpFvVXeiSANDZN9xcxVta7vNDihbG0eUn3nRBBPZcnAU93DigLtphy+COP?=
 =?us-ascii?Q?zm5dxJZDwYwtZItnCCKPmNCvLYH1VBJfwABCipyo9VFhhyFTPdK8YL8LWAx+?=
 =?us-ascii?Q?7cGW7gF5Ha5MEhFCSzM654ci7I1PVj0hZhiXuSmq4GpnJH2h74vlEx0VE8qF?=
 =?us-ascii?Q?Ira+jNGVlUpJvJGsu1t+SkQgP28OjJWo/ABXS7V1cPU3UitmMUeE//feeUDG?=
 =?us-ascii?Q?kni2+84zheFFnIhsM6fHmjtA8IucB8KG4qN1mO1fjwemuLYUgcm4hbeWKY2Q?=
 =?us-ascii?Q?x7ykLFVWAb14oOyQNGxIZ4J11eKVAKF6oMjb2LfFIg+6WpCWhOPAz+TpbSb3?=
 =?us-ascii?Q?IF80AgRPu/O+ggQOITIpNAhID5xkCnR36FXeShIS1IzS3EseRv/H6QgZiimW?=
 =?us-ascii?Q?ZO4B2byPHBlt4/M6IfoLTOW34Qhv6udAAxZGvmLaJt03acrlIEL/ooX51gKR?=
 =?us-ascii?Q?+R5GRPyo02/ekmjK952FTNfZIp1BOBiknrR78nHJYVFt3yf6EOzfDRT1AYfA?=
 =?us-ascii?Q?Ed7fVdqXndSuhgIoMPqvuKl2/unIyyyHuHPjcIAabqhmvZ/Ijigc/X3En9nI?=
 =?us-ascii?Q?LhRUY4tJC6Dv7W/W84u7pGS+Rm/cj+0b/trhq9Oi2iGlUYe183XjJtovoy8k?=
 =?us-ascii?Q?71w/Y16Iw+KbKBXumL6+UiGoWXp6b5tQ+cpXETKSeq0ya/Kdi6DnnDeNnYBv?=
 =?us-ascii?Q?v6iQXgeQ8mghVuzZPk7LOm9D2xYgaXX6aigLGaJFqwcXOsmuacgWye3xkMnk?=
 =?us-ascii?Q?j5p2y2k67EuEMPG87W/ze7RRQkScZLUCCrNtml/Us7qTLxONlToHOzHk0AJo?=
 =?us-ascii?Q?uUt9UvNjJYR0ywuLro1qSjZk/n+rAq0+8FuOopmPPORHf9AxQ+P7nk5qI3Aj?=
 =?us-ascii?Q?oc+PRTJgpAwtCjgpXR4NzuWs/EZy7IOGkDE7TukhLLoOqdSJyKIm26fATMNB?=
 =?us-ascii?Q?OJG8D7OfyZrECSvfk3n8INe7C0B+ewH6560WQiAFV30wjYPKh2CmZ48m/TrT?=
 =?us-ascii?Q?RAQYwH638eeHT2qY1394r63tRAkoKQ/aTtba28v52jXXa4Ma+OZ2DLd+3uqE?=
 =?us-ascii?Q?cXPqYvN/98XS7/2YTYLpNVN+5gG/RN1lman6WLiQRj+WspEruPPU3/mj5s9e?=
 =?us-ascii?Q?k0AuKfzMVGXcWGUXC7awLGQgZ82s?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 21:07:37.0734
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f674aed-a13b-4abe-edc0-08dc7f5a33b4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6311

To prepare for other code that will manipulate security attributes
move the handling code out of sp-pci.c. No intended functional changes.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v1->v2:
 * Only add psp_security_attr_group when PSP support enabled
   (Fixes lkp robot reported Kconfig issue)
---
 MAINTAINERS                  |  6 ++++
 drivers/crypto/ccp/Makefile  |  3 +-
 drivers/crypto/ccp/hsti.c    | 68 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/hsti.h    | 15 ++++++++
 drivers/crypto/ccp/psp-dev.c |  1 +
 drivers/crypto/ccp/sp-pci.c  | 58 ++----------------------------
 6 files changed, 95 insertions(+), 56 deletions(-)
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
index b57392292af1..dd31e791156d 100644
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
@@ -150,7 +96,9 @@ static struct attribute_group psp_firmware_attr_group = {
 };
 
 static const struct attribute_group *psp_groups[] = {
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
 	&psp_security_attr_group,
+#endif
 	&psp_firmware_attr_group,
 	NULL,
 };
-- 
2.43.0

