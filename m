Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4ECD155C94;
	Mon, 27 May 2024 15:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716823642; cv=fail; b=UQnB5F/1d+iqmmQlDlhbjpI8/wWuD7Z3Fwptk2ABeuIlL5h1XUEoWrTVYVQ22tOoajXgPpp7jogdYC8a76gON+GF0NCq1E7ccKXYACogOG8H2DNqPUd3958HNVcEftrNWexeiZM1TQuGm7JAucN4A8DShAmnXMUDUaBy/svB9Rs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716823642; c=relaxed/simple;
	bh=S90x49+7R+I998XJ3s8cV1me2a1iMGchH+LNYBE1+sc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sFT6dnE4FpgD6oXXB0vP16wu2OU0CloYquhoS7Rb1gruIc1GTy3+Dwy+uxswAnBoZVYb4CPZRa30/M+hSbBcB1MBt3tH0HHn0eT9Oo29lo4ojPuKrkmZ2+O0C+4NqGjAW2yp/ZACBbztfIAAPBLNi+6u0FFoSy504epG9x4FbRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CYOnl7+8; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CYOnl7+8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwoEaqv5+pO4pvH91xKqz4tMcjxRgR9osvt2XUUmu7xmLkSeCzrj+MbOue8cA176sEY156aV3b2tmHCISiJvmWPRA5u4G9DL2WCmhyl/y9h0zbOB9wgnMu3e6Uh80wd4IUfc1MxqxPg5npR7pYLrmjx0tdMxc4nAD3mTLZPIrYGNAvp8XLQdzmOfkIE1AGIfgP6NpZAWQWHdHA/EszMYu4LemaoZ7dHwLOvWwZoLMOfwS0okDAVSiOJe/HsZfmH07RDGSTVyTHLj7Lcbk80lx1kGEB7saGZTVOSbfX/EvHoGVWfxBzMWJ4nmzXZkrVb8bgrDnwdWXRonCweQAqjK5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PHC1CfXe+YG8K8xprxUb30xtOttWxi1+KljRX0WY7ZE=;
 b=TGZS/dM1YXjLu8zp3XRuBg1bQWlfGCr0Tqgb3XqtY2jp3VWwKuL2A09KQONGuh1RiPsx4F/kZFGQpGhKxvVsREc0gLzxjIygDsRpI46mhChGsQc1Ve0n6IdCb5ejlOO0isXsArUCwvEnPrcsUrRKwfbRByC0WNvnCk+mlU2dw+j8ig6xXBHlH3qsajkGzHvFGCksv+jl/JIXfRH0pPeaq+ctMXSgpDvcjkHGia+iFl/Vg0W63mJ/B3Oywq3WIb5e6uejN7bUKZ2dawxwkUpKhLiukmo0inxDpnWtVd7oo9gSYAmsxNu1xwwX7EDxuedDJIpGohQEvSrh507/Y+qdwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHC1CfXe+YG8K8xprxUb30xtOttWxi1+KljRX0WY7ZE=;
 b=CYOnl7+8JtfrIDqcpwKgLD8pMJpFk3AkNgc5LpYjsJ8dmHFa500cNz8nmk/ptyHUEtLLl1gfJqSyeRx4jjakozhqF+0IG0X8kVSpYHCm6Cgq/PnR5ctahJR2eEGVEFK0FfWi0ZXGlt0qNUKiaNKkAji8QCPioRiJa53GZ/APOAI=
Received: from CH2PR05CA0013.namprd05.prod.outlook.com (2603:10b6:610::26) by
 CH0PR12MB8508.namprd12.prod.outlook.com (2603:10b6:610:18c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Mon, 27 May
 2024 15:27:18 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:0:cafe::40) by CH2PR05CA0013.outlook.office365.com
 (2603:10b6:610::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17 via Frontend
 Transport; Mon, 27 May 2024 15:27:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Mon, 27 May 2024 15:27:16 +0000
Received: from AUS-P9-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 27 May
 2024 10:27:11 -0500
From: Mario Limonciello <mario.limonciello@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mario Limonciello <mario.limonciello@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP)
 DRIVER - DB..." <linux-crypto@vger.kernel.org>, Richard Hughes
	<hughsient@gmail.com>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] crypto: ccp: Add support for getting security attributes on some older systems
Date: Mon, 27 May 2024 10:26:48 -0500
Message-ID: <20240527152649.3722-5-mario.limonciello@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|CH0PR12MB8508:EE_
X-MS-Office365-Filtering-Correlation-Id: d6d52cc7-7bfb-4ada-9192-08dc7e617de1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400017|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?enYiohqzqmzRxu8l7IOuMnVtFZ2YWCL3EmCnYPSIzi/e5NKecQzMoGS4BwFG?=
 =?us-ascii?Q?8EJfG7wlsjFKdvfmc6+YBZpCwSeMFnVr0MNQk7H831ZQ3UDVT6C7SIG5g73C?=
 =?us-ascii?Q?SN6gamvZHHm7FpJd5FyqreIRXDtkVQnRhEFDnbzZ9jwLgb+XSO/NJGwAvq0b?=
 =?us-ascii?Q?xC12Pw4YMJtIXep6B8FnKjxdWlTINuOoTFfBQ86w+OOEznl1xzw+Jj5zgTZO?=
 =?us-ascii?Q?eKPZjjhdFXXfcTD9U2gTTFDeP2WahDy5SMOuu3zwvS6nMGvfAP176GlGji9w?=
 =?us-ascii?Q?N+86ZJR0qq7ln2VNtvfY8rK6uACaEck1+5a47GE8A3BPr3T63IQewT0B014i?=
 =?us-ascii?Q?6da0Pxz9OJ1AMLyJzldXX9leBbgxamQTf1DrmGHyOS+I49yVd824uN4LT/Bg?=
 =?us-ascii?Q?9UYEpyF0eZFrICYWSSyS9q0cTrkyHbMKYwqTr7U3ounMGjH6JavcUKd1z85A?=
 =?us-ascii?Q?aik7ef2vgMdVWnB3sRaf8ZqfvdZcYF3DnbvmOlkISRq958ms8FVd/ZDAWWYT?=
 =?us-ascii?Q?ZCT+/3wDwa3UUkBg6aTaam7k00q833PAZhKEXQJGsQf4o4Y0265qoGyZulJX?=
 =?us-ascii?Q?EDuLp+m5qACoL67EAO8WAKIdbkGR+n+VwqUzIyy+4wUJ5zbzh7ESoUCV93K8?=
 =?us-ascii?Q?LUnAd68Yj8UYy++6Mvg4apCyRJbPQhzWC/OauJtmyp/6ryKFJ9Qbcon5YwOW?=
 =?us-ascii?Q?PiP9ZBU3hnRE89+jFWj96mHjT+EZTmGMvQ4l1MVz4uW/4ye25Y2zcIVQDwyY?=
 =?us-ascii?Q?mWoHDzj7EMnd7c0VfNrGPySPqKhlEgJbKioCovo/ozs57UP8hkEmLdGCXIs/?=
 =?us-ascii?Q?+jkTrcXyL9nPeY0jk+nFBGFbpflRi8KhwBoLIF41PRHcJBJ/YYUPAyQJvc65?=
 =?us-ascii?Q?NBoEZXtB+FgJTh0R5BkZ3vwhSdEBll0oXh8rE08DxMq4/pDIMojcrtGotXrf?=
 =?us-ascii?Q?+crDppWxKDgT8f8jM3K/seewvO9uKBI6E/q7bOokaFL4UqE1/HekIM/rX3GA?=
 =?us-ascii?Q?nWrz0fozH0VafnYX5MJOOCzo3XXKlC5XacQPWRyRRiFdxwjQdgE/SBIpCEQE?=
 =?us-ascii?Q?LaEg2XA5wMPAQwXr6INE3CnDnocQyA2wQajqMTyhflYiEkW4+FLvtjjNJM0J?=
 =?us-ascii?Q?aY3dRvAAADPXEyCWKlvRWLQvllAm2rDRjMsrxWXyV7jcAUOK9HCEqyOliyHH?=
 =?us-ascii?Q?Jyd+QryNlVWD2r5DZ2/cUYLXYb48J3WG+8Uq9gIkhHMAH3TF2LdkWPVFvvlm?=
 =?us-ascii?Q?1FzTSs0dKFLTxUN6PZ7jbiuUbocElWZ5kw+poYZfcbeLb8pPravw8kwAq0O7?=
 =?us-ascii?Q?zphDdZ9dwN2rovjkJpNxAXrIfDp3SV8xt7aDSYzVLlJTwA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400017)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2024 15:27:16.8161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d52cc7-7bfb-4ada-9192-08dc7e617de1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8508

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
 drivers/crypto/ccp/hsti.c           | 63 +++++++++++++++++++++++++++++
 drivers/crypto/ccp/hsti.h           |  2 +
 drivers/crypto/ccp/psp-dev.c        |  5 +++
 drivers/crypto/ccp/psp-dev.h        |  2 -
 drivers/crypto/ccp/sp-dev.h         |  1 +
 drivers/crypto/ccp/sp-pci.c         |  5 ++-
 include/linux/psp-platform-access.h |  1 +
 7 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
index 076c1d175b2b..8f583902d786 100644
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
@@ -66,3 +73,59 @@ struct attribute_group psp_security_attr_group = {
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
+	/*
+	 * At this stage, if security information hasn't been populated by
+	 * either the PSP or by the driver through the platform command,
+	 * then there is nothing more to do.
+	 */
+	if (!psp->capability.security_reporting)
+		return 0;
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
index 2db46736a4d7..f2d416a4f539 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -395,10 +395,12 @@ static const struct psp_vdata pspv1 = {
 
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
@@ -411,7 +413,8 @@ static const struct psp_vdata pspv3 = {
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

