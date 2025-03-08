Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8C52F30;
	Sat,  8 Mar 2025 01:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741396254; cv=fail; b=UwY4wiSYFDOfX1mCT6G2KK5wsiRGhbhBFQiIe5Re34na+/7SsV6j5MXaslrL13uuPDkxPXHZH4Le7wTNeSYZ9pY25c3WSLI3NHqjheeXA3yV/rQFw4ua7UOE+yMdxHH6ttarysVLJ03bds7v5Ae/YSfIvH68bhbPSU7nI+4M0cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741396254; c=relaxed/simple;
	bh=qS7YDL3tvnPSF9quhO7lGWBcOCQo3azKLq/+w9IZU7Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=clbYyinrjhMpyWaCwuhbc/MsG3iEgQieIYr149FS/LnnBepSMeS4TyBjVvJqdruIV3JwdkhO2y/e5yOqW76wZpTfByqRYQjCV7Tqllcj4Z4qGQGDdAUfm06JyEI8GE3d76PlpE+hD/KKbtl0VvBwfMlJrzLjBTHvTJnng8rf+V4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2Se0bQ0K; arc=fail smtp.client-ip=40.107.94.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2Se0bQ0K"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=twKR+jg6jSQmdDbl2wxTDTDOJMOn1WwmYwCCpOcqsAlojljueFxA6nAQYK0KDSQgb0J49tdk7Ow76WPVrXDr8duTUzTvzNOd+bSD4Qn1CoFmT7/2nfA7q8M+rLUBnZOJr1EGZisj2l8G88VirDDE9i6rZdz4zV2VMIg0kyk2xo6Y+VwV1Nc5knFfP388dlB/if/DvI+ueM6l00X7nfnKtynsRZl8L29EErJ6VsinyQCEnpag/3A7uvuGCf/+0WOkFx/t6DiOy93Lyn50OcrYrnIG2eYRq3yrzOEoTskLTkJUshSxwIdoBME4QHOC+MV9wArSRN/ObGluA3QXE5OGsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjPRQrn39bxjzHouzN3oumF7N0sICFxKxkU+bq6+8eE=;
 b=ER7XbMY0X7ovSau57vi8Gwa1IUI4ROiOCPE4sAS5qQTwXRRAKtorcwznHfiCptgHpCoU7c/BUiAmsp+vs9STtMZSwJs4D96yPzxY+zSBkQLTp4B/BCMxq2Dh9TOMi+5XxfNhHt3vxZWA+Eca2GEddQL7QQFDxP/2bOdfQYuRjeP19HQpGA15QfrF8LoPVfaIWECv5I2CwaIckZiRuZnR6oxW8Plr3esVPyJmOHob19mbS/I4thQHCDwHuUQkmVhjXAqscLm+4QpkM/mV6kvgslpm0wBXKwCJgrk1A3rXM6glm8eQCHl1ENqdyqJDodfj/wlL/zYYuJrAgQBiYZrhRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjPRQrn39bxjzHouzN3oumF7N0sICFxKxkU+bq6+8eE=;
 b=2Se0bQ0KCLVHOdbBqMUty0NnTxVqQHG/D1qxmU6Clb2w72iRagUXNIJEwYI4h6Lv1JwPjezw+38b69D9xPG7Yct7zeuBbUcY1nAKb3r6/5lHLTzQ2u1/Ci/ZWJ/YKzWAJPRqsTqA+np5JRMAy09JTBzG7F2GDCD7ARExvrv7jak=
Received: from MN2PR22CA0009.namprd22.prod.outlook.com (2603:10b6:208:238::14)
 by SN7PR12MB7177.namprd12.prod.outlook.com (2603:10b6:806:2a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Sat, 8 Mar
 2025 01:10:49 +0000
Received: from BL02EPF0001A0FB.namprd03.prod.outlook.com
 (2603:10b6:208:238:cafe::6) by MN2PR22CA0009.outlook.office365.com
 (2603:10b6:208:238::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.19 via Frontend Transport; Sat,
 8 Mar 2025 01:10:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FB.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Sat, 8 Mar 2025 01:10:48 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 7 Mar
 2025 19:10:45 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Ashish Kalra
	<ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Borislav
 Petkov (AMD)" <bp@alien8.de>, Herbert Xu <herbert@gondor.apana.org.au>,
	Alexey Kardashevskiy <aik@amd.com>, <stable@vger.kernel.org>, Dionna Glaze
	<dionnaglaze@google.com>
Subject: [PATCH] crypto: ccp: Fix uAPI definitions of PSP errors
Date: Sat, 8 Mar 2025 12:10:28 +1100
Message-ID: <20250308011028.719002-1-aik@amd.com>
X-Mailer: git-send-email 2.47.1
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FB:EE_|SN7PR12MB7177:EE_
X-MS-Office365-Filtering-Correlation-Id: 41973dd7-f524-429a-b3f7-08dd5dde0fe6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J5NEvAoV9OHOads4jYYpm7Ei5AbuHTbhfRhwtiKUokx0YMvzF988dAk9/gK7?=
 =?us-ascii?Q?4bwhmZU4Rtm6dGZOp2Qi80+XVqm0oD7xKrCFz4DrFN3/ieP4+1DNk1iYjVrI?=
 =?us-ascii?Q?fj2qZwUCzhWaqKNU9hdIUlmuqnhhh+tYUCgE31+iBXU5A27XQ0N6MC7QwKaH?=
 =?us-ascii?Q?+RuwgeP1XuCl97yn5yg3N/Glm1NSwy4Czq6eQKe0uqd8HCaqc0gBjmuQBEIq?=
 =?us-ascii?Q?ZTBv51G3d2aKCN8hk/Wsf4HVvRiLTignQdjPb3M8ckU8vUjARk6Nopi+ddG0?=
 =?us-ascii?Q?q0tPA2y0j9W5Fj7cPNyrj9YJdR581JRf5jTVCLFoMrQMwAR02evBpRwBv6e/?=
 =?us-ascii?Q?ScV86DgOfhPRtDMUaDgch7hNA3MW7MFxsVjaBo1gANMsq58txqBbeRonBOaM?=
 =?us-ascii?Q?Nz8FiIx6CuMUQPwEGbjW7cCFqKpnsLwSQKK+EpFCjXX59SzjEJAeEUx2K5p4?=
 =?us-ascii?Q?URUhoM9Woz/MtIjog05Ki61CuFoXBJXt4+PfDSE4DblIz23kzdMYOaEjBsMy?=
 =?us-ascii?Q?y3T5DrncK+v4uUapSaDzRDJx23irADLlQRkRbxPf1HVGXD2gi2DjG2RbGROI?=
 =?us-ascii?Q?zSCgQCRAl7zHOaIecQwuLb1Hdm20AjhYlQdSLoKMeVlI8qdzYksHWf1FcL0r?=
 =?us-ascii?Q?AV5EGc/3vGBPcm+oo7wSh4qDnLRn7jrXgt+b3GAg6RPLCBbB3Qk+i2KLoRED?=
 =?us-ascii?Q?LS4pJHytli5r4c325Rm9xaSJXDZfBVlmpzIP+D0e862VILBXagXowdY3TVkR?=
 =?us-ascii?Q?InMweMUHz+0aY9qPfaoh0Fh634XAVTokpMM7WknHgabJs1Y/PgeGhhHTk7GK?=
 =?us-ascii?Q?9mh/AE4swzpBU9CanxHTUzcKfVwS0eHbJW7tVH5VcsbFteHcwn9jS9ha276n?=
 =?us-ascii?Q?PIR2OUAFpLgFT822vLY287lfU0uifauSnMUQqwqwfbpV2Xb5nJCpo5TuYWPF?=
 =?us-ascii?Q?I0b9fFYIXnyxX3REaHqc0kbatVlkwBwFyRUQNU6lJ5EXa5dcqKgY8aiZbOZ9?=
 =?us-ascii?Q?+ghLYOjPiDj/ANJuUOiNQV5ZsXOffStXz5HipfazROVUUAIIfJdgB3efg1V1?=
 =?us-ascii?Q?2DGu8leZPgJsJssOhSYi4T//JGbYrB6wyW7xWtc/d7jTkjqTsafwHhDaFCdN?=
 =?us-ascii?Q?awI1BvGRL3ph2C4wtito7Ljvq3kWfeYar0TnWlTemCWSz0EocPTjGpb5Eyl5?=
 =?us-ascii?Q?i+xkpFZRIzrzxiC18QAgr7biXdwmQPUTJXFy5tqb9ZfnbJmA8htSh4Bevm07?=
 =?us-ascii?Q?rRmi0J7DGZnKJWSFVrofw8imXHvAROR3QSQF64I7VuhiPZUvvKI+khbsHqjX?=
 =?us-ascii?Q?iDDUNfm3f5juCjBHm8zA9Uu5qjfibLvNcuhGGN8B2rS3ltg4XNwRksUB9a/7?=
 =?us-ascii?Q?GhHNYXk6ujqutu5i1PxlhIYJGzsZSM+cf/iRYUX+Kcg0U39Z+OKMgJqOCVQ2?=
 =?us-ascii?Q?JtW0a3FmXw32qGImyH78VzXQxJOipRjbHAo6XL0hiqHWv3gSyruTW0vt3o4+?=
 =?us-ascii?Q?sygzamPSngzB2ww=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2025 01:10:48.6910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41973dd7-f524-429a-b3f7-08dd5dde0fe6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7177

Additions to the error enum after explicit 0x27 setting for
SEV_RET_INVALID_KEY leads to incorrect value assignments.

Use explicit values to match the manufacturer specifications more
clearly.

Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
CC: stable@vger.kernel.org
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

Reposting as requested in
https://lore.kernel.org/r/Z7f2S3MigLEY80P2@gondor.apana.org.au

I wrote it in the first place but since then it travelled a lot,
feel free to correct the chain of SOBs and RB :)
---
 include/uapi/linux/psp-sev.h | 21 +++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 832c15d9155b..eeb20dfb1fda 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -73,13 +73,20 @@ typedef enum {
 	SEV_RET_INVALID_PARAM,
 	SEV_RET_RESOURCE_LIMIT,
 	SEV_RET_SECURE_DATA_INVALID,
-	SEV_RET_INVALID_KEY = 0x27,
-	SEV_RET_INVALID_PAGE_SIZE,
-	SEV_RET_INVALID_PAGE_STATE,
-	SEV_RET_INVALID_MDATA_ENTRY,
-	SEV_RET_INVALID_PAGE_OWNER,
-	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
-	SEV_RET_RMP_INIT_REQUIRED,
+	SEV_RET_INVALID_PAGE_SIZE          = 0x0019,
+	SEV_RET_INVALID_PAGE_STATE         = 0x001A,
+	SEV_RET_INVALID_MDATA_ENTRY        = 0x001B,
+	SEV_RET_INVALID_PAGE_OWNER         = 0x001C,
+	SEV_RET_AEAD_OFLOW                 = 0x001D,
+	SEV_RET_EXIT_RING_BUFFER           = 0x001F,
+	SEV_RET_RMP_INIT_REQUIRED          = 0x0020,
+	SEV_RET_BAD_SVN                    = 0x0021,
+	SEV_RET_BAD_VERSION                = 0x0022,
+	SEV_RET_SHUTDOWN_REQUIRED          = 0x0023,
+	SEV_RET_UPDATE_FAILED              = 0x0024,
+	SEV_RET_RESTORE_REQUIRED           = 0x0025,
+	SEV_RET_RMP_INITIALIZATION_FAILED  = 0x0026,
+	SEV_RET_INVALID_KEY                = 0x0027,
 	SEV_RET_MAX,
 } sev_ret_code;
 
-- 
2.47.1

