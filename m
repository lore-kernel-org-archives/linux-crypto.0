Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1810717DE09;
	Tue, 28 May 2024 21:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716930466; cv=fail; b=BVgXlDxk+JcejoiG97eA95oCxLD0MwXnpFZmuoWO/OrX87kgaeIFqk/fV76kU9ki8UxxkhP46XxEGfmxVenzjqzXXeewHbLAtT4ujRIoLqHPKLl9LDMjtKg+ZXyTy656+HwvDTEma5A5q9Eml6LQK5f/sHKloBn11tRW6SiuV6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716930466; c=relaxed/simple;
	bh=3shmZ5d//7qZN2slioqsRi+XosG0hrS2ylJoXixjNuA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fg+KvSUuuZ6kxGUKMu8YCStKotTFOPGFf3zSNYghGroM1oDmksZY0VNo2BtAb3KOG2309H3Oy5gIBCsYpw8zBI96IOdolKs4MHL2PDWV2Di9B6cO6e5SD9jFnLrlPJhhOB1PTV5l36FshVbeMcq9bZNwOQi3ePV5qRT9OKh4fjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Z3SeAo0c; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Z3SeAo0c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvRln6mEK+Rk4ob6w0NYFfobVSABoKWD6fOAv4FtFE5CBA3Db9TooKeAyfJKXUJ0KTh1PgMTz69o1OwgFh0P0IozYfvNwYyLu0aMUWk9x95Gu9rM1YwkWQVnHDLmYN/EjDKOfRQ/0vYoapQoDhuQIbiJC1CHsrBtN/2aSSIkxgKF2+z9WbYL8uep7eQev9O7R+Toa/kh4UE0oVS5SyQxIsA8KkJMJFXIOwyzALngpO9+GydKrKGbhTmiGvXao8ajmDackmlQuFAalWgVpwrSz9Lt/Amt5hP3pKJn3p7G4qns5R15uKR4vNh/sB9G1Z9ORML9PevctBsUO42el2eHaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmifaAvRtj5zAU+dGIOHQOE2YQbq/+vN0MS95zHT5e4=;
 b=BlfSwFDx4QFvPgsYnjPjDrYhHnxAM/49WVrKljybelWUFGTEg3ZucxKkjk1LjYOL4ukkWqdMrAciGOoQLMZZbXFFbKnxBDARATslona+bibiNQKBvpIgq4eFDgdQb+6zzzdYAsG2gmVdj2xlCFX4sP8uNbvd7wGUeWp4AOWEaXkjr77y2Puf6iA1XMC1LFOt9CQD4x6OlDcXqr2pMYUVwsTpIkIRj8MVKSYM2OZ/rwNL0oq1kmvARDQGoKsbfVxj5QkFmJfsMIBmlLGrwzrztnHPYE20phYmkf5M6cSCL4+JF16xAKpe4Afu2EXYSiIJjbwxTuLTWZCBUC7277Y3Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmifaAvRtj5zAU+dGIOHQOE2YQbq/+vN0MS95zHT5e4=;
 b=Z3SeAo0cga7oHrSQj3udyK+f7eIpnY9uD3vPo9j0xVgpvIqFDcVKMj9mY0VaCzGJjKwYCMH4BjoNXwFoE0UgCsdf6I+g+uePRm3AVOdG/tYOLwhtav4l+vnitLsDStA71ZK+PzRqUe0r94YRUrgEY/XUpv1tCt0f1Ee23byaQcE=
Received: from MN2PR16CA0003.namprd16.prod.outlook.com (2603:10b6:208:134::16)
 by BY5PR12MB4290.namprd12.prod.outlook.com (2603:10b6:a03:20e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Tue, 28 May
 2024 21:07:42 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:208:134:cafe::16) by MN2PR16CA0003.outlook.office365.com
 (2603:10b6:208:134::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.18 via Frontend
 Transport; Tue, 28 May 2024 21:07:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Tue, 28 May 2024 21:07:40 +0000
Received: from AUS-P9-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 28 May
 2024 16:07:34 -0500
From: Mario Limonciello <mario.limonciello@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mario Limonciello <mario.limonciello@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP)
 DRIVER - DB..." <linux-crypto@vger.kernel.org>, Richard Hughes
	<hughsient@gmail.com>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/5] crypto: ccp: Add support for getting security attributes on some older systems
Date: Tue, 28 May 2024 16:07:11 -0500
Message-ID: <20240528210712.1268-5-mario.limonciello@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|BY5PR12MB4290:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d7867e8-1b29-4465-4b71-08dc7f5a35ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?29a+1PSBzFDjeIKe+3iyfmokb0MVGODo0Vcvo6Yk3uFkQHi0QonJkTdodPCR?=
 =?us-ascii?Q?gl9C4yG5YSnAbPAKEl5CDHzqLX5vULuqu6UL3vgQ7KwXWgNpaTROiLSkz5Nr?=
 =?us-ascii?Q?o3c+hMOp/OTa58HR46ranXcLkxs9Pp9tesSerXy9yhSsqcOr//n5Bxe5cIk8?=
 =?us-ascii?Q?+UXBhHEhQApR18It060NFLRkjLMs9Pv3KXk8RxMB7ItWwWfW46zWUbnFFgRw?=
 =?us-ascii?Q?jWTGhb/V1ozOA2LQfTfC8VqKRtjBOyElHC+TxFVDW1RRPwNzMoss8y/5EK+y?=
 =?us-ascii?Q?390iqbcz0sKpj1fSlA6yK1AqaRmfBUwBBd9XQMdiOdvuaHY6qDWVTnKfXsEZ?=
 =?us-ascii?Q?QJRYx595QYCtT20/+tuMzqhyv248xW2asKFL6MvKy00/U4wNW+F+UKxEnU+D?=
 =?us-ascii?Q?iCqo+iWMn5CN7sgrww6WTQlzxPZYXSrGz7ybHGPa1r2XDvSudSeHNjUEzKip?=
 =?us-ascii?Q?VDoxjezA97rDakN1okXRhS6ejqzDNcVMJhT2gM/eQIvwWs2Sjg31BeQEaz9b?=
 =?us-ascii?Q?ACaISZvomTN+twyR+Pt7yqBJZYjFTok2YqcaQq8/S0WNRMXhC6P+UYUgdctj?=
 =?us-ascii?Q?hMcsz80+1ZcUiNxLeW+2wGJ6WgIsst54LVtxtG6vLw3cTrsHne8HobRk3BJy?=
 =?us-ascii?Q?d00CVoFAjn937py4N2gDiiBpSao+RMzb18V9lXNKn6LqtyZNWrQn2NQF87bo?=
 =?us-ascii?Q?5wQrgKm+9pe5ozYRSTOF6H6N5kj1QCfQAqE5iHEZiJZTgjxgey19N5kmXi2X?=
 =?us-ascii?Q?/Cr03k0zBp1CdWjBefD6GExz5tx31v2k2q0HgSmnAgpoTLVMthp2uhAlPgoS?=
 =?us-ascii?Q?KcqAZYQhlSl9bTcxUwmjzgSGQaHdqSuvUCTC0kqWDQjRNn4F7NGOQGernvHP?=
 =?us-ascii?Q?Niukmukt3w50nXmzbYwwhSKpYTsNr/PIeRg9eSNP2m91ynb1erlYLk3IKL47?=
 =?us-ascii?Q?Jh0jlwKmxLCxLuPNXI1HbR5qPJlkwTsJwesLs+SAk655lvT3BqLsTr0K9RdI?=
 =?us-ascii?Q?eFfx1S0L//TTNoFsABSU2gdsj+yk9emDtglzwSxcgZSmAnO/9l10AK/97e3G?=
 =?us-ascii?Q?pP2x5BC3PKOcpjkL/MM2e4lbbQPZN0utCgsF2xM0ezrJveR0J4XpsaZUuR7l?=
 =?us-ascii?Q?ZCQT02rMVaVNvhg4zxwBnjbHLT7Lf0F1goCvzddOP+l60w413QUfZpYzN6ci?=
 =?us-ascii?Q?rk2IZwbLrtHGrRpedwewTr4FPaFR5T+qHEBWQ/xa4pxeHLt8/MeQPUG5AAtZ?=
 =?us-ascii?Q?i13KJL98e3NMw9Tc2TQ2vhR0bnPE7rpAnJCtiR7P21d9Bp5YO7OK5toPbPoU?=
 =?us-ascii?Q?whW49VKHg9A6xXxKnzD94v1QDUhYenfBSwS4GxIiF1/I+g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 21:07:40.4640
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7867e8-1b29-4465-4b71-08dc7f5a35ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4290

Older systems will not populate the security attributes in the
capabilities register. The PSP on these systems, however, does have a
command to get the security attributes. Use this command during ccp
startup to populate the attributes if they're missing.

Closes: https://github.com/fwupd/fwupd/issues/5284
Closes: https://github.com/fwupd/fwupd/issues/5675
Closes: https://github.com/fwupd/fwupd/issues/6253
Closes: https://github.com/fwupd/fwupd/issues/7280
Closes: https://github.com/fwupd/fwupd/issues/6323
Closes: https://github.com/fwupd/fwupd/discussions/5433
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v1->v2:
 * Move code to patch 5
---
 drivers/crypto/ccp/hsti.c           | 55 +++++++++++++++++++++++++++++
 drivers/crypto/ccp/hsti.h           |  2 ++
 drivers/crypto/ccp/psp-dev.c        |  5 +++
 drivers/crypto/ccp/psp-dev.h        |  2 --
 drivers/crypto/ccp/sp-dev.h         |  1 +
 drivers/crypto/ccp/sp-pci.c         |  5 ++-
 include/linux/psp-platform-access.h |  1 +
 7 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
index 076c1d175b2b..8b99bbd4efe2 100644
--- a/drivers/crypto/ccp/hsti.c
+++ b/drivers/crypto/ccp/hsti.c
@@ -12,6 +12,13 @@
 #include "psp-dev.h"
 #include "hsti.h"
 
+#define PSP_CAPABILITY_PSP_SECURITY_OFFSET	8
+
+struct hsti_request {
+	struct psp_req_buffer_hdr header;
+	u32 hsti;
+} __packed;
+
 #define security_attribute_show(name)						\
 static ssize_t name##_show(struct device *d, struct device_attribute *attr,	\
 			   char *buf)						\
@@ -66,3 +73,51 @@ struct attribute_group psp_security_attr_group = {
 	.attrs = psp_security_attrs,
 	.is_visible = psp_security_is_visible,
 };
+
+static int psp_poulate_hsti(struct psp_device *psp)
+{
+	struct hsti_request *req;
+	int ret;
+
+	/* Are the security attributes already reported? */
+	if (psp->capability.security_reporting)
+		return 0;
+
+	/* Allocate command-response buffer */
+	req = kzalloc(sizeof(*req), GFP_KERNEL | __GFP_ZERO);
+	if (!req)
+		return -ENOMEM;
+
+	req->header.payload_size = sizeof(req);
+
+	ret = psp_send_platform_access_msg(PSP_CMD_HSTI_QUERY, (struct psp_request *)req);
+	if (ret)
+		goto out;
+
+	if (req->header.status != 0) {
+		dev_dbg(psp->dev, "failed to populate HSTI state: %d\n", req->header.status);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	psp->capability.security_reporting = 1;
+	psp->capability.raw |= req->hsti << PSP_CAPABILITY_PSP_SECURITY_OFFSET;
+
+out:
+	kfree(req);
+
+	return ret;
+}
+
+int psp_init_hsti(struct psp_device *psp)
+{
+	int ret;
+
+	if (PSP_FEATURE(psp, HSTI)) {
+		ret = psp_poulate_hsti(psp);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/ccp/hsti.h b/drivers/crypto/ccp/hsti.h
index e5c5ceab9973..6a70f922d2c4 100644
--- a/drivers/crypto/ccp/hsti.h
+++ b/drivers/crypto/ccp/hsti.h
@@ -12,4 +12,6 @@
 
 extern struct attribute_group psp_security_attr_group;
 
+int psp_init_hsti(struct psp_device *psp);
+
 #endif /* __HSTI_H */
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 1a7b991c27f7..0a01ad134609 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -220,6 +220,11 @@ static int psp_init(struct psp_device *psp)
 			return ret;
 	}
 
+	/* HSTI uses platform access on some systems. */
+	ret = psp_init_hsti(psp);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
index 02a7c94c02df..e43ce87ede76 100644
--- a/drivers/crypto/ccp/psp-dev.h
+++ b/drivers/crypto/ccp/psp-dev.h
@@ -78,8 +78,6 @@ void psp_clear_sev_irq_handler(struct psp_device *psp);
 
 struct psp_device *psp_get_master_device(void);
 
-#define PSP_CAPABILITY_PSP_SECURITY_OFFSET	8
-
 /**
  * enum psp_cmd - PSP mailbox commands
  * @PSP_CMD_TEE_RING_INIT:	Initialize TEE ring buffer
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index c4e125efe6c7..0895de823674 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -29,6 +29,7 @@
 #define CACHE_WB_NO_ALLOC		0xb7
 
 #define PLATFORM_FEATURE_DBC		0x1
+#define PLATFORM_FEATURE_HSTI		0x2
 
 #define PSP_FEATURE(psp, feat)	(psp->vdata && psp->vdata->platform_features & PLATFORM_FEATURE_##feat)
 
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index dd31e791156d..248d98fd8c48 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -397,10 +397,12 @@ static const struct psp_vdata pspv1 = {
 
 static const struct psp_vdata pspv2 = {
 	.sev			= &sevv2,
+	.platform_access	= &pa_v1,
 	.bootloader_info_reg	= 0x109ec,	/* C2PMSG_59 */
 	.feature_reg		= 0x109fc,	/* C2PMSG_63 */
 	.inten_reg		= 0x10690,	/* P2CMSG_INTEN */
 	.intsts_reg		= 0x10694,	/* P2CMSG_INTSTS */
+	.platform_features	= PLATFORM_FEATURE_HSTI,
 };
 
 static const struct psp_vdata pspv3 = {
@@ -413,7 +415,8 @@ static const struct psp_vdata pspv3 = {
 	.feature_reg		= 0x109fc,	/* C2PMSG_63 */
 	.inten_reg		= 0x10690,	/* P2CMSG_INTEN */
 	.intsts_reg		= 0x10694,	/* P2CMSG_INTSTS */
-	.platform_features	= PLATFORM_FEATURE_DBC,
+	.platform_features	= PLATFORM_FEATURE_DBC |
+				  PLATFORM_FEATURE_HSTI,
 };
 
 static const struct psp_vdata pspv4 = {
diff --git a/include/linux/psp-platform-access.h b/include/linux/psp-platform-access.h
index 23893b33e48c..1504fb012c05 100644
--- a/include/linux/psp-platform-access.h
+++ b/include/linux/psp-platform-access.h
@@ -7,6 +7,7 @@
 
 enum psp_platform_access_msg {
 	PSP_CMD_NONE			= 0x0,
+	PSP_CMD_HSTI_QUERY		= 0x14,
 	PSP_I2C_REQ_BUS_CMD		= 0x64,
 	PSP_DYNAMIC_BOOST_GET_NONCE,
 	PSP_DYNAMIC_BOOST_SET_UID,
-- 
2.43.0

