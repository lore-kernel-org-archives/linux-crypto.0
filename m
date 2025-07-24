Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2043.outbound.protection.outlook.com [40.107.236.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837152ECD39;
	Thu, 24 Jul 2025 21:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753391942; cv=fail; b=P9yqtRFyqUtP4nm1ouVRAbA0l+sYJrEydak7tZN5SJeKlsmzmg5K7ZtKHdErLgyFf0NEaLXx9hSwLCLuvCY/+qt8a5jyJTpMOFicsbztv6ApfyMl0c1li7xRi8BOdDyT70oZG9QWFZ/WV94xnAryCUq3KygEgTu7MJRdksKCJHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753391942; c=relaxed/simple;
	bh=IH3TsbbuFS7c/JWx1GMv93WQCFHEWCZs9iZS4pMIAec=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZPBmpb76wMcdVgHsuiw6mCn1Bf8To+94PZlhQN0ATkbTLvHYID3mWqpeYaoPZk570Vo/DEFHpsE2YRczrIw+o2GnpJMxsYc1kB+ZAlFLv9xcs2DNgLFINNRTZQVf1w3pnPx30zDpUhM1E/w3A5RZwzUwRp6G+5krxM26aMUI2Gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zbxliPql; arc=fail smtp.client-ip=40.107.236.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zbxliPql"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ln1AmmOzNHzedoqM3oTR6NeYBlCfJCyNF55tYxA7AlF9k41wDVehS3+Lin974mPfsfXsYXAju2mWvhvJhak3JVEdMGJlLmuPxHtc8GTSqoSPrTvkQRDLw6pww3BQWIlUD6LxcJfVO8htWrnwPTbKUnxJE9I52fcNTTGYO7OXfGSlpPdWYDasQoUIc1LCic1xHwbOkKSXiuvfTMfv+wdDKCGE4wmkm4XwMBVuhqKeI6gP+gR0fz06H+GLpXjnyBt4mwR3V8hFGpqRKw8ghdVP9WO+4YuwO0GpFnMZv6Q+32rkFjgpVoRDLhQt1sCTmRkEe55tdu+r7tGYjT0Ubzr//w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LDZ7dkw1sMwEBp28UPLalIasHkeJZjISeWLiKbKHqqs=;
 b=AIQJHJX6ieZQnuuV8Rx0OL94+RRip8VM0GoK/lVPW+//gm/qvhQZDzok0XNJyeExBRKbhOlorBrHPaqYknD04RLH4c0E2wAi1XBsEyudQzwO0KAmiykaCLK5+dc6eq6R8dXzqTVk4bsoGFsC9l+80CCYfPeqziv9n49+s7b/oc6gpm32DJWeYNOSe1zxQ/gU3dXTt3pucD+vd2EP3Hmic98/LBbuow0vpwaAHpceNOHzKgCp3Y1Ih/0LI/ZbVsMFesTfoNLti1fw5PPaVfZc83bo8l9qNV5tItbVjkuRNpK3goJblrGToDt9Rq66AG/u5pxzxTilK+sYidg5ofNbOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDZ7dkw1sMwEBp28UPLalIasHkeJZjISeWLiKbKHqqs=;
 b=zbxliPqlKASyzShfoeR44u3KngxKIO8wOHcTGtvGfMEJBuD8fcDbG/Uuf52NNeXQzuvaJlzJwetc2yS6sXwxbbfTgIESY99l3UO3K6NkiJZxBXxq42rqlTTOP20sGR+Ji8TU1ZmlOw4yr1OcYzEy49UR/Un6xRo9vp5n3xkP2zU=
Received: from PH8PR07CA0029.namprd07.prod.outlook.com (2603:10b6:510:2cf::27)
 by IA0PR12MB8304.namprd12.prod.outlook.com (2603:10b6:208:3dc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Thu, 24 Jul
 2025 21:18:54 +0000
Received: from SJ1PEPF000026C7.namprd04.prod.outlook.com
 (2603:10b6:510:2cf:cafe::9f) by PH8PR07CA0029.outlook.office365.com
 (2603:10b6:510:2cf::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.22 via Frontend Transport; Thu,
 24 Jul 2025 21:18:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000026C7.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Thu, 24 Jul 2025 21:18:53 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 24 Jul
 2025 16:17:17 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <michael.roth@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver
Date: Thu, 24 Jul 2025 21:16:28 +0000
Message-ID: <82acbf87e782c482ebd8d80092b5ad47d1f4b854.1753389962.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1753389962.git.ashish.kalra@amd.com>
References: <cover.1753389962.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C7:EE_|IA0PR12MB8304:EE_
X-MS-Office365-Filtering-Correlation-Id: 27c797f4-5668-4d0a-e1b5-08ddcaf7b156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7/ULLg8EuaqOFhD+XnAWJT/UCDrZP2jxWWVSOvqX1hLltF4mZglcNJXRjtnF?=
 =?us-ascii?Q?HbXpyJSGHWgsWpuOW5cuunQj7nXqFTbJtRdJnnMmeFH06IXvRUhhS33sxIeh?=
 =?us-ascii?Q?eDNWjocnWv3INdzNy9DNfpNTC7o75UDq00y15AourE5zWGkhPGkt6NC7ISiF?=
 =?us-ascii?Q?JUwpxlv69yIWmmK9v+BMSbfVjkLe5pLo3syy0QbhxJU3uFjFuGvuq1X7xKxf?=
 =?us-ascii?Q?IoApzS4FVf4lSiLoLVBRlN8jdzSTWGMrPxVMbH9nPt9Fbyd/A4pmfujI0PRd?=
 =?us-ascii?Q?hDfWxXD98YxhbSsbDCxY4Tbh+ABr5pKzEybI3mrw9cnUED3T6RIluarh9Y38?=
 =?us-ascii?Q?LI9idyVEME4Km3756skBkxV4aW75Q6Ep8DM4uNlidR5HMsquh6P6SPr53jtn?=
 =?us-ascii?Q?KZKZk+/HKn9aIHEuMpaOdvWoy2iq/FOW1Vd6Ub4Jdzbt9x1yWJPr8Ta99AdL?=
 =?us-ascii?Q?RwntK3LAgXh21HfEpAt5JzdgZpDSOdz8Dj20J8BvJlXlntgwmhfckZJ8U5hZ?=
 =?us-ascii?Q?tbpONgaBOS9AabtU6x+2scR1mqKNdjzjvLRWYxt1T68P7U3UJGcmT49bZogP?=
 =?us-ascii?Q?JZE/hYxHENjQ1eSteiW49SM4WSqUMf2xqFF+0pp1rClxKepQZreuJGoSlc8M?=
 =?us-ascii?Q?GVZg9X1KlHT+0t27x6ofTlFqBFcjRxCz8N1yqmsd2oZQG4fAhtiXLcbWgRLp?=
 =?us-ascii?Q?C/4Dzsh5qDCfh7LPvVRuHasDdKc/ZVUw6n0skC13IFkoBvTkLCPfEbG7GsGR?=
 =?us-ascii?Q?FXgVPLcObXgNN/bjy+mC19l5gRtRA8QwlrrIgT+hcEhlHcERAAKt8hFIWL/Y?=
 =?us-ascii?Q?STN6QvRgDXTIKRVCbEUy8+Rw/e8gQZuG31e2MvswpXYu+SwoeSqNo6i5sOco?=
 =?us-ascii?Q?fG+4OWYFARW1pq7GL13ton4qq7UFb/WoRz4ciTG976bMaLET/bVhZhXE4M/+?=
 =?us-ascii?Q?veFAPBC6tluxVcXZUfiNbspuWm/gDGjf/x3CX2BG+/MFRBf4oiRSCHvRHxUm?=
 =?us-ascii?Q?lLAG0enCohNz6Kq/YUpUcaAMmff52+GcL8Kv64E3jXwUy4ws8cUgbXgVE9mB?=
 =?us-ascii?Q?+wR6EP44fGsZFvqpBdQOxVScCrKaNNhZyiXEfNuf0KzwUlWShkXpB8brzGio?=
 =?us-ascii?Q?UVnqYbzE3D6br1P+35rNSNilAmSDwue7+mEbMWVCwg/M1JVFmeT9jk51lLdu?=
 =?us-ascii?Q?If6URFj9jFSPd0VZfd+Mg5+3ZtaGOnCe9n+nV2SCEs6neS4JnIbhdFhXrjj7?=
 =?us-ascii?Q?b6lXvPz1r3kmyanPD29XYEeINUYuPSv+4jfm3jCjrGJvTWviwNT03o8opXT0?=
 =?us-ascii?Q?jzv0oY9Jrh9+iJ/z3bbquAuZBOOQ18iL+W1g+hnboK9tGNG7C357Y/JQ0V7T?=
 =?us-ascii?Q?m81WDua9NptcWsb5lWJhnm6jBmDzIjH5iAG3a/2p2fiMjWejr55c/roSk9vk?=
 =?us-ascii?Q?g/HzVWIYxR7JUrlgfMOtj0XWTqlWtCDseVrdPmIaI/ZxhP6kCueIF4X92jTp?=
 =?us-ascii?Q?oNEgPYb7ZA8P9ZFnJCVj1tk/OeGr0Ga60L8OJ81wkVvG5KpSjiSYPvcdcA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 21:18:53.6138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c797f4-5668-4d0a-e1b5-08ddcaf7b156
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8304

From: Ashish Kalra <ashish.kalra@amd.com>

AMD Seamless Firmware Servicing (SFS) is a secure method to allow
non-persistent updates to running firmware and settings without
requiring BIOS reflash and/or system reset.

SFS does not address anything that runs on the x86 processors and
it can be used to update ASP firmware, modules, register settings
and update firmware for other microprocessors like TMPM, etc.

SFS driver support adds ioctl support to communicate the SFS
commands to the ASP/PSP by using the TEE mailbox interface.

The Seamless Firmware Servicing (SFS) driver is added as a
PSP sub-device.

For detailed information, please look at the SFS specifications:
https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58604.pdf

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/Makefile         |   3 +-
 drivers/crypto/ccp/psp-dev.c        |  20 ++
 drivers/crypto/ccp/psp-dev.h        |   8 +-
 drivers/crypto/ccp/sfs.c            | 316 ++++++++++++++++++++++++++++
 drivers/crypto/ccp/sfs.h            |  53 +++++
 include/linux/psp-platform-access.h |   2 +
 include/uapi/linux/psp-sfs.h        |  87 ++++++++
 7 files changed, 487 insertions(+), 2 deletions(-)
 create mode 100644 drivers/crypto/ccp/sfs.c
 create mode 100644 drivers/crypto/ccp/sfs.h
 create mode 100644 include/uapi/linux/psp-sfs.h

diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 394484929dae..9b876bfb1289 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -13,7 +13,8 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
                                    tee-dev.o \
                                    platform-access.o \
                                    dbc.o \
-                                   hsti.o
+                                   hsti.o \
+				   sfs.o
 
 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
 ccp-crypto-objs := ccp-crypto-main.o \
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 1c5a7189631e..8c4ad225ad67 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -17,6 +17,7 @@
 #include "psp-dev.h"
 #include "sev-dev.h"
 #include "tee-dev.h"
+#include "sfs.h"
 #include "platform-access.h"
 #include "dbc.h"
 #include "hsti.h"
@@ -182,6 +183,17 @@ static int psp_check_tee_support(struct psp_device *psp)
 	return 0;
 }
 
+static int psp_check_sfs_support(struct psp_device *psp)
+{
+	/* Check if device supports SFS feature */
+	if (!psp->capability.sev) {
+		dev_dbg(psp->dev, "psp does not support SFS\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int psp_init(struct psp_device *psp)
 {
 	int ret;
@@ -198,6 +210,12 @@ static int psp_init(struct psp_device *psp)
 			return ret;
 	}
 
+	if (!psp_check_sfs_support(psp)) {
+		ret = sfs_dev_init(psp);
+		if (ret)
+			return ret;
+	}
+
 	if (psp->vdata->platform_access) {
 		ret = platform_access_dev_init(psp);
 		if (ret)
@@ -302,6 +320,8 @@ void psp_dev_destroy(struct sp_device *sp)
 
 	tee_dev_destroy(psp);
 
+	sfs_dev_destroy(psp);
+
 	dbc_dev_destroy(psp);
 
 	platform_access_dev_destroy(psp);
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
index e43ce87ede76..268c83f298cb 100644
--- a/drivers/crypto/ccp/psp-dev.h
+++ b/drivers/crypto/ccp/psp-dev.h
@@ -32,7 +32,8 @@ union psp_cap_register {
 		unsigned int sev			:1,
 			     tee			:1,
 			     dbc_thru_ext		:1,
-			     rsvd1			:4,
+			     sfs			:1,
+			     rsvd1			:3,
 			     security_reporting		:1,
 			     fused_part			:1,
 			     rsvd2			:1,
@@ -68,6 +69,7 @@ struct psp_device {
 	void *tee_data;
 	void *platform_access_data;
 	void *dbc_data;
+	void *sfs_data;
 
 	union psp_cap_register capability;
 };
@@ -118,12 +120,16 @@ struct psp_ext_request {
  * @PSP_SUB_CMD_DBC_SET_UID:		Set UID for DBC
  * @PSP_SUB_CMD_DBC_GET_PARAMETER:	Get parameter from DBC
  * @PSP_SUB_CMD_DBC_SET_PARAMETER:	Set parameter for DBC
+ * @PSP_SUB_CMD_SFS_GET_FW_VERS:	Get firmware versions for ASP and other MP
+ * @PSP_SUB_CMD_SFS_UPDATE:		Command to load, verify and execute SFS package
  */
 enum psp_sub_cmd {
 	PSP_SUB_CMD_DBC_GET_NONCE	= PSP_DYNAMIC_BOOST_GET_NONCE,
 	PSP_SUB_CMD_DBC_SET_UID		= PSP_DYNAMIC_BOOST_SET_UID,
 	PSP_SUB_CMD_DBC_GET_PARAMETER	= PSP_DYNAMIC_BOOST_GET_PARAMETER,
 	PSP_SUB_CMD_DBC_SET_PARAMETER	= PSP_DYNAMIC_BOOST_SET_PARAMETER,
+	PSP_SUB_CMD_SFS_GET_FW_VERS	= PSP_SFS_GET_FW_VERSIONS,
+	PSP_SUB_CMD_SFS_UPDATE		= PSP_SFS_UPDATE,
 };
 
 int psp_extended_mailbox_cmd(struct psp_device *psp, unsigned int timeout_msecs,
diff --git a/drivers/crypto/ccp/sfs.c b/drivers/crypto/ccp/sfs.c
new file mode 100644
index 000000000000..cbca01a884e1
--- /dev/null
+++ b/drivers/crypto/ccp/sfs.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD Secure Processor Seamless Firmware Servicing support.
+ *
+ * Copyright (C) 2023-2025 Advanced Micro Devices, Inc.
+ *
+ * Author: Ashish Kalra <ashish.kalra@amd.com>
+ */
+
+#include <linux/firmware.h>
+
+#include "sfs.h"
+#include "sev-dev.h"
+
+#define SFS_DEFAULT_TIMEOUT		(10 * MSEC_PER_SEC)
+#define SFS_MAX_PAYLOAD_SIZE		(2 * 1024 * 1024)
+#define ORDER_2MB 9
+
+/* SFS Status values */
+#define SFS_SUCCESS			0x00
+#define SFS_INVALID_TOTAL_SIZE		0x02
+#define SFS_INVALID_PKG_SIZE		0x04
+#define SFS_DISABLED			0x05
+#define SFS_INVALID_CUST_SIGN		0x06
+#define SFS_INVALID_AMD_SIGN		0x07
+#define SFS_INTERNAL_ERROR		0x08
+#define SFS_CUST_SIGN_NOT_ALLOWED	0x09
+#define SFS_INVALID_BASE_PATCH_LVL	0x0A
+#define SFS_INVALID_CURR_PATCH_LVL	0x0B
+#define SFS_INVALID_NEW_PATCH_LVL	0x0C
+#define SFS_INVALID_SUBCOMMAND		0x0D
+#define SFS_PROTECTION_FAIL		0x0E
+#define SFS_BUSY			0x0F
+#define SFS_FW_VERSION_MISMATCH	0x10
+#define SFS_SYS_VERSION_MISMATCH	0x11
+#define SFS_SEV_STILL_INITIALIZED	0x12
+
+static bool sfs_initialized;
+
+static int send_sfs_cmd(struct psp_sfs_device *sfs_dev, int msg)
+{
+	int ret;
+
+	*sfs_dev->result = 0;
+	sfs_dev->command_hdr->ext_req.header.sub_cmd_id = msg;
+
+	ret = psp_extended_mailbox_cmd(sfs_dev->psp,
+					SFS_DEFAULT_TIMEOUT,
+					(struct psp_ext_request *)sfs_dev->command_hdr);
+	if (ret == -EIO) {
+		dev_dbg(sfs_dev->dev,
+			 "msg 0x%x failed with PSP error: 0x%x\n",
+			 msg, *sfs_dev->result);
+		dev_dbg(sfs_dev->dev,
+			 "msg 0x%x extended status: 0x%x\n",
+			 msg, *(u32 *)sfs_dev->payload);
+	}
+
+	return ret;
+}
+
+static int send_sfs_get_fw_versions(struct psp_sfs_device *sfs_dev)
+{
+	int ret;
+
+	sfs_dev->payload_size = &sfs_dev->command_hdr->ext_req.header.payload_size;
+	sfs_dev->result = &sfs_dev->command_hdr->ext_req.header.status;
+	sfs_dev->payload = &sfs_dev->command_hdr->ext_req.buf;
+	sfs_dev->pkg_hdr = (void *)sfs_dev->command_hdr + PAGE_SIZE;
+	sfs_dev->header_size = sizeof(struct psp_ext_req_buffer_hdr);
+
+	/*
+	 * SFS_GET_FW_VERSIONS command needs the output buffer to be
+	 * initialized to 0xC7 in every byte.
+	 */
+	memset(sfs_dev->pkg_hdr, 0xc7, PAGE_SIZE);
+	*sfs_dev->payload_size = 2 * PAGE_SIZE;
+
+	ret = send_sfs_cmd(sfs_dev, PSP_SFS_GET_FW_VERSIONS);
+
+	return ret;
+}
+
+static int send_sfs_update_package(struct psp_sfs_device *sfs_dev, char *payload_name)
+{
+	char payload_path[PAYLOAD_NAME_SIZE];
+	const struct firmware *firmware;
+	unsigned long package_size;
+	int ret;
+
+	sprintf(payload_path, "amd/%s", payload_name);
+
+	ret = firmware_request_nowarn(&firmware, payload_path, sfs_dev->dev);
+	if (ret < 0) {
+		dev_warn(sfs_dev->dev, "firmware request fail %d\n", ret);
+		return -ENOENT;
+	}
+
+	/* SFS Update Package should be 64KB aligned */
+	package_size = ALIGN(firmware->size + PAGE_SIZE, 0x10000U);
+
+	/*
+	 * SFS command buffer is a pre-allocated 2MB buffer, fail update package
+	 * if SFS payload is larger than the pre-allocated command buffer.
+	 */
+	if (package_size > SFS_MAX_PAYLOAD_SIZE) {
+		dev_warn(sfs_dev->dev,
+			 "SFS payload size %ld larger than maximum supported payload size of 2MB\n",
+			 package_size);
+		return -ENOMEM;
+	}
+
+	sfs_dev->payload_size = &sfs_dev->command_hdr->ext_req.header.payload_size;
+	sfs_dev->result = &sfs_dev->command_hdr->ext_req.header.status;
+	sfs_dev->payload = &sfs_dev->command_hdr->ext_req.buf;
+	sfs_dev->pkg_hdr = (void *)sfs_dev->command_hdr + PAGE_SIZE;
+	sfs_dev->header_size = sizeof(struct psp_ext_req_buffer_hdr);
+
+	/*
+	 * Copy firmware data to a kernel allocated contiguous
+	 * memory region.
+	 */
+	memcpy(sfs_dev->pkg_hdr, firmware->data, firmware->size);
+	*sfs_dev->payload_size = package_size;
+
+	ret = send_sfs_cmd(sfs_dev, PSP_SFS_UPDATE);
+
+	release_firmware(firmware);
+	return ret;
+}
+
+static long sfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct psp_device *psp_master = psp_get_master_device();
+	void __user *argp = (void __user *)arg;
+	char payload_name[PAYLOAD_NAME_SIZE];
+	struct psp_sfs_device *sfs_dev;
+	int ret;
+
+	if (!psp_master || !psp_master->sfs_data)
+		return -ENODEV;
+	sfs_dev = psp_master->sfs_data;
+
+	if (!sfs_initialized)
+		return -EINVAL;
+
+	mutex_lock(&sfs_dev->ioctl_mutex);
+
+	switch (cmd) {
+	case SFSIOCFWVERS:
+		dev_dbg(sfs_dev->dev, "in SFSIOCFWVERS\n");
+
+		ret = send_sfs_get_fw_versions(sfs_dev);
+		if (ret && ret != -EIO)
+			goto unlock;
+		/*
+		 * return SFS status and extended status back to userspace
+		 * if PSP status indicated command error.
+		 */
+		if (copy_to_user(argp, sfs_dev->pkg_hdr, PAGE_SIZE))
+			ret = -EFAULT;
+		if (copy_to_user(argp + PAGE_SIZE, sfs_dev->result, sizeof(u32)))
+			ret = -EFAULT;
+		if (copy_to_user(argp + PAGE_SIZE + sizeof(u32), sfs_dev->payload, sizeof(u32)))
+			ret = -EFAULT;
+		break;
+	case SFSIOCUPDATEPKG:
+		dev_dbg(sfs_dev->dev, "in SFSIOCUPDATEPKG\n");
+
+		if (copy_from_user(payload_name, argp, PAYLOAD_NAME_SIZE)) {
+			ret = -EFAULT;
+			goto unlock;
+		}
+
+		ret = send_sfs_update_package(sfs_dev, payload_name);
+		if (ret && ret != -EIO)
+			goto unlock;
+		/*
+		 * return SFS status and extended status back to userspace
+		 * if PSP status indicated command error.
+		 */
+		if (copy_to_user(argp + PAYLOAD_NAME_SIZE, sfs_dev->result, sizeof(u32)))
+			ret = -EFAULT;
+		if (copy_to_user(argp + PAYLOAD_NAME_SIZE + sizeof(u32), sfs_dev->payload,
+				 sizeof(u32)))
+			ret = -EFAULT;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+unlock:
+	mutex_unlock(&sfs_dev->ioctl_mutex);
+
+	return ret;
+}
+
+static const struct file_operations sfs_fops = {
+	.owner	= THIS_MODULE,
+	.unlocked_ioctl = sfs_ioctl,
+};
+
+void sfs_dev_destroy(struct psp_device *psp)
+{
+	struct psp_sfs_device *sfs_dev = psp->sfs_data;
+	int ret;
+
+	if (!sfs_dev)
+		return;
+
+	/*
+	 * TODO: free pre-allocated 2MB command buffer,
+	 * if SEV-SNP is initialized the command buffer has
+	 * been marked HV_Fixed and HV_Fixed pages remain
+	 * in that state till system reset, they cannot be
+	 * released back to the page allocator.
+	 *
+	 */
+	snp_delete_hypervisor_fixed_pages_list(page_to_pfn(sfs_dev->page) << PAGE_SHIFT);
+
+	ret = set_memory_wb((unsigned long)page_address(sfs_dev->page), 512);
+	if (ret)
+		dev_dbg(sfs_dev->dev, "set memory wb failed\n");
+
+	sfs_initialized = false;
+	misc_deregister(&sfs_dev->char_dev);
+	mutex_destroy(&sfs_dev->ioctl_mutex);
+	psp->sfs_data = NULL;
+}
+
+int sfs_dev_init(struct psp_device *psp)
+{
+	struct device *dev = psp->dev;
+	struct psp_sfs_device *sfs_dev;
+	struct page *page;
+	u64 cmd_buf_paddr;
+	int ret;
+
+	/*
+	 * SFS feature support can be detected on multiple devices but the SFS
+	 * FW commands must be issued on the master. During probe, we do not
+	 * know the master hence we create /dev/sfs on the first device probe.
+	 */
+	if (sfs_initialized)
+		return 0;
+
+	sfs_dev = devm_kzalloc(dev, sizeof(*sfs_dev), GFP_KERNEL);
+	if (!sfs_dev)
+		return -ENOMEM;
+
+	BUILD_BUG_ON(sizeof(struct sfs_command) > PAGE_SIZE);
+
+	/*
+	 * Pre-allocate static 2MB command buffer for all SFS commands.
+	 */
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, ORDER_2MB);
+	if (!page)
+		return -ENOMEM;
+	sfs_dev->page = page;
+	sfs_dev->command_hdr = page_address(page);
+	cmd_buf_paddr = page_to_pfn(sfs_dev->page) << PAGE_SHIFT;
+
+	/*
+	 * If SEV-SNP is enabled the SFS command buffer needs to
+	 * transitioned to HV_Fixed page state.
+	 */
+	dev_dbg(sfs_dev->dev, "cmdbuf page pa 0x%llx to be marked as HV_Fixed\n",
+		cmd_buf_paddr);
+
+	ret = snp_insert_hypervisor_fixed_pages_list(cmd_buf_paddr, 512);
+	if (ret) {
+		dev_dbg(sfs_dev->dev, "cmdbuf page failed insertion in HV-Fixed page list\n");
+		goto cleanup_cmd_buf;
+	}
+
+	/*
+	 * Buffers used for communication with different processors, x86 to ASP
+	 * in this case must be mapped as non-cacheable.
+	 */
+	ret = set_memory_uc((unsigned long)page_address(page), 512);
+	if (ret) {
+		dev_dbg(sfs_dev->dev, "set memory uc failed\n");
+		goto cleanup_cmd_buf_after_hv_fixed;
+	}
+
+	dev_dbg(sfs_dev->dev, "cmdbuf page va 0x%lx marked as UnCacheable\n",
+		(unsigned long)sfs_dev->command_hdr);
+
+	psp->sfs_data = sfs_dev;
+	sfs_dev->dev = dev;
+	sfs_dev->psp = psp;
+
+	dev_dbg(sfs_dev->dev, "seamless firmware serviving support is available\n");
+
+	sfs_dev->char_dev.minor = MISC_DYNAMIC_MINOR;
+	sfs_dev->char_dev.name = "sfs";
+	sfs_dev->char_dev.fops = &sfs_fops;
+	sfs_dev->char_dev.mode = 0600;
+	ret = misc_register(&sfs_dev->char_dev);
+	if (ret)
+		goto cleanup_cmd_buf_after_hv_fixed;
+
+	mutex_init(&sfs_dev->ioctl_mutex);
+	sfs_initialized = true;
+
+	return 0;
+
+cleanup_cmd_buf_after_hv_fixed:
+	snp_delete_hypervisor_fixed_pages_list(cmd_buf_paddr);
+cleanup_cmd_buf:
+	__free_pages(page, ORDER_2MB);
+	psp->sfs_data = NULL;
+	devm_kfree(dev, sfs_dev);
+
+	return ret;
+}
diff --git a/drivers/crypto/ccp/sfs.h b/drivers/crypto/ccp/sfs.h
new file mode 100644
index 000000000000..89b7792af076
--- /dev/null
+++ b/drivers/crypto/ccp/sfs.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * AMD Platform Security Processor (PSP) Seamless Firmware (SFS) Support.
+ *
+ * Copyright (C) 2023-2025 Advanced Micro Devices, Inc.
+ *
+ * Author: Ashish Kalra <ashish.kalra@amd.com>
+ */
+
+#ifndef __SFS_H__
+#define __SFS_H__
+
+#include <uapi/linux/psp-sfs.h>
+
+#include <linux/device.h>
+#include <linux/miscdevice.h>
+#include <linux/psp-sev.h>
+#include <linux/psp-platform-access.h>
+#include <linux/set_memory.h>
+
+#include <asm/sev.h>
+
+#include "psp-dev.h"
+
+struct psp_sfs_device {
+	struct device *dev;
+	struct psp_device *psp;
+
+	struct sfs_command *command_hdr;
+
+	struct mutex ioctl_mutex;
+
+	struct miscdevice char_dev;
+
+	struct page *page;
+
+	/* used to abstract communication path */
+	u32	header_size;
+	u32	*payload_size;
+	u32	*result;
+	void	*payload;
+	void	*pkg_hdr;
+};
+
+struct sfs_command {
+	struct psp_ext_request ext_req;
+};
+
+void sfs_dev_destroy(struct psp_device *psp);
+int sfs_dev_init(struct psp_device *psp);
+void sfs_pci_init(void);
+
+#endif /* __SFS_H__ */
diff --git a/include/linux/psp-platform-access.h b/include/linux/psp-platform-access.h
index 1504fb012c05..540abf7de048 100644
--- a/include/linux/psp-platform-access.h
+++ b/include/linux/psp-platform-access.h
@@ -7,6 +7,8 @@
 
 enum psp_platform_access_msg {
 	PSP_CMD_NONE			= 0x0,
+	PSP_SFS_GET_FW_VERSIONS,
+	PSP_SFS_UPDATE,
 	PSP_CMD_HSTI_QUERY		= 0x14,
 	PSP_I2C_REQ_BUS_CMD		= 0x64,
 	PSP_DYNAMIC_BOOST_GET_NONCE,
diff --git a/include/uapi/linux/psp-sfs.h b/include/uapi/linux/psp-sfs.h
new file mode 100644
index 000000000000..e752fa041683
--- /dev/null
+++ b/include/uapi/linux/psp-sfs.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * Userspace interface for AMD Seamless Firmware Servicing (SFS)
+ *
+ * Copyright (C) 2023-2025 Advanced Micro Devices, Inc.
+ *
+ * Author: Ashish Kalra <ashish.kalra@amd.com>
+ */
+
+#ifndef __PSP_SFS_USER_H__
+#define __PSP_SFS_USER_H__
+
+#include <linux/types.h>
+
+/**
+ * SFS: AMD Seamless Firmware Support (SFS) interface
+ */
+
+#define PAYLOAD_NAME_SIZE		64
+#define TEE_EXT_CMD_BUFFER_SIZE	4096
+
+/**
+ * struct sfs_user_get_fw_versions - get current level of base firmware (output).
+ * @blob:                  current level of base firmware for ASP and patch levels (input/output).
+ * @sfs_status:            32-bit SFS status value (output).
+ * @sfs_extended_status:   32-bit SFS extended status value (output).
+ */
+struct sfs_user_get_fw_versions {
+	__u8	blob[TEE_EXT_CMD_BUFFER_SIZE];
+	__u32	sfs_status;
+	__u32	sfs_extended_status;
+} __packed;
+
+/**
+ * struct sfs_user_update_package - update SFS package (input).
+ * @payload_name:          name of SFS package to load, verify and execute (input).
+ * @sfs_status:            32-bit SFS status value (output).
+ * @sfs_extended_status:   32-bit SFS extended status value (output).
+ */
+struct sfs_user_update_package {
+	char	payload_name[PAYLOAD_NAME_SIZE];
+	__u32	sfs_status;
+	__u32	sfs_extended_status;
+} __packed;
+
+/**
+ * Seamless Firmware Support (SFS) IOC
+ *
+ * possible return codes for all SFS IOCTLs:
+ *  0:          success
+ *  -EINVAL:    invalid input
+ *  -E2BIG:     excess data passed
+ *  -EFAULT:    failed to copy to/from userspace
+ *  -EBUSY:     mailbox in recovery or in use
+ *  -ENODEV:    driver not bound with PSP device
+ *  -EACCES:    request isn't authorized
+ *  -EINVAL:    invalid parameter
+ *  -ETIMEDOUT: request timed out
+ *  -EAGAIN:    invalid request for state machine
+ *  -ENOENT:    not implemented
+ *  -ENFILE:    overflow
+ *  -EPERM:     invalid signature
+ *  -EIO:       unknown error
+ */
+#define SFS_IOC_TYPE	'S'
+
+/**
+ * SFSIOCFWVERS - returns blob containing FW versions
+ *                ASP provides the current level of Base Firmware for the ASP
+ *                and the other microprocessors as well as current patch
+ *                level(s).
+ */
+#define SFSIOCFWVERS	_IOWR(SFS_IOC_TYPE, 0x1, struct sfs_user_get_fw_versions)
+
+/**
+ * SFSIOCUPDATEPKG - updates package/payload
+ *                   ASP loads, verifies and executes the SFS package.
+ *                   By default, the SFS package/payload is loaded from
+ *                   /lib/firmware/amd, but alternative firmware loading
+ *                   path can be specified using kernel parameter
+ *                   firmware_class.path or the firmware loading path
+ *                   can be customized using sysfs file:
+ *                   /sys/module/firmware_class/parameters/path.
+ */
+#define SFSIOCUPDATEPKG	_IOWR(SFS_IOC_TYPE, 0x2, struct sfs_user_update_package)
+
+#endif /* __PSP_SFS_USER_H__ */
-- 
2.34.1

