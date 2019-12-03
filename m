Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464A5C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 05:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1090B2068E
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 05:32:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="bnQXTTm6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfLCFcg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 00:32:36 -0500
Received: from mail-eopbgr800057.outbound.protection.outlook.com ([40.107.80.57]:10304
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbfLCFcg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 00:32:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0K+6aAYFdQqYBsBfl1fTKy8BsbIgI0VdxCSUSYkjggXsHONhkYPEUyZpgknkU0YzwU2zGZ1OiCG0+3peIP2JLqtgTs9l5urqm0b0o+dU1ZJC+fwfytLcdrvd1VKMKcfqI33gSbeyK8jmNXSkuiguSWH++hoccb+vb9NoL9vaahj2gFB+mC8raEayAL9ZdK/ywbuO574/Er9+33pPfuZ0qpegRBczz2ld3wFszi2/VLMK6j8L1OYNx5dDrg8y1kbyEaIfW7GdtAYP//x6+o8ACyilrPaxp00mEG1ggbiEvwaY0EPQtEXPbdS5y0WUbI7bUjnLR19fX0J/xRaTNnCww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3bvgiX4yhYoUqxDqwuCBTGLvlVb6Pp09Y1xTZ1aFcg=;
 b=ZKUZcveg18Eyd5w89QnqA9Nz0v3wcYNxPyXyL2R9J03FAxinW/XM4NhFBbn0S/3d0EgVcf2IGq9MUM9wpMJirr95mij5rH13z9ZKVcYpLp/c1wI3dmbnI3utqn0P5tdh+ILxXdjyNaji6flufbq4xWLTqwAuzvmDqocfKGhjfCFDD08Er2L9yvtvVol1FB27Z7e0YtcxQbKJddcs6fuUvtqlpxCwdzsZy1kb3CueOiXVw9hNL+ATYxumJadqpYl/DwkwUUVzdXsm7bb6MxE7l2aSKYc8D1V6bmVOVfHUwERDy/E6Cq39fKc5L1gtK7+jmEew0PCvLATGxxrAoXMlJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3bvgiX4yhYoUqxDqwuCBTGLvlVb6Pp09Y1xTZ1aFcg=;
 b=bnQXTTm6bG8eLqhUZLxTruuxyN1FWr7imhmNZ+K1t1LLzhUDoOfkSus88pS5BczEtK4JRZrNMhCQTmyLYiZBAL8WBo28nUjJvumv2PDjKuzcEwQJlQDR+fe58Hw3CWjX0y+WL5UnvjKFT+InAv1vkpg4/K2Ik9KHu1qmIgeifOw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1430.namprd12.prod.outlook.com (10.168.167.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Tue, 3 Dec 2019 05:32:21 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4%7]) with mapi id 15.20.2495.014; Tue, 3 Dec 2019
 05:32:21 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH v2 1/6] crypto: ccp - rename psp-dev files to sev-dev
Date:   Tue,  3 Dec 2019 10:09:16 +0530
Message-Id: <072bd042e28d2a0a4e76154e3da02f9a69fb423e.1575282249.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1575282249.git.Rijo-john.Thomas@amd.com>
References: <cover.1575282249.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0006.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::16) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 710baa9b-96dc-4f27-5102-08d777b22b09
X-MS-TrafficTypeDiagnostic: CY4PR12MB1430:|CY4PR12MB1430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1430875A5E631CE72FC0C1D9CF420@CY4PR12MB1430.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 02408926C4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(199004)(189003)(81156014)(3846002)(50226002)(52116002)(305945005)(11346002)(2616005)(186003)(316002)(110136005)(6486002)(16586007)(26005)(48376002)(66556008)(66476007)(66946007)(54906003)(14444005)(5660300002)(6666004)(478600001)(14454004)(36756003)(51416003)(8676002)(8936002)(50466002)(99286004)(386003)(6436002)(446003)(25786009)(6506007)(76176011)(7736002)(118296001)(47776003)(6116002)(86362001)(6512007)(2906002)(66066001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1430;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OICEdaAxzWowyUU+YEF80464hGDazvfJwMpkF7Cc9ZvQvLT2UMRXLf2yblmghsC/8oDmf9e60/Ik9RF6hqG6tD/+w5BF+Zj6lJSHJkdsF4GkpBpd0Rp8k0DqYpxUcoEQ9OWvfiy/Z3JhjmQhC/0YZOZdkJyzwA+ubRFrIPk9A1UwniUP+CMuwRSmMF9gxonSnBiMkV64yKRlQ5VRTJ/UGJElM2T9GcrHxgpHBgrnwP0JvNfXblbvsOVpDBSjUwDoe2P7aF7nj/ggcB62z+VCqsKdLUHLOyl8HatGYDaBrTysDFy42aUkeyXKm7vhAZBdYJ6f/euPknU0BO72cr7xiAxUyH15gedpxLjBJrk3o48rTeNNVRQ1d2doG8CGn+4WCKkAegU0ZGAcknzmUhuKLRUJIPQVjimqe15WZLcgg3LnfbJhWi91/PySbl9ARHep
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 710baa9b-96dc-4f27-5102-08d777b22b09
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2019 05:32:21.1427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZaIsmK7F803O9ZleDQZNMIgZh7wsK1L0Uo0OtDCFLpxPAEvD/lB4KFs1wNRv8CcwxyRV7uHgJ7HDyhjaw/6dHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1430
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a preliminary patch for creating a generic PSP device driver
file, which will have support for both SEV and TEE (Trusted Execution
Environment) interface.

This patch does not introduce any new functionality, but simply renames
psp-dev.c and psp-dev.h files to sev-dev.c and sev-dev.h files
respectively.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Jens Wiklander <jens.wiklander@linaro.org>
Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/crypto/ccp/Makefile                 | 2 +-
 drivers/crypto/ccp/{psp-dev.c => sev-dev.c} | 6 +++---
 drivers/crypto/ccp/{psp-dev.h => sev-dev.h} | 8 ++++----
 drivers/crypto/ccp/sp-pci.c                 | 2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)
 rename drivers/crypto/ccp/{psp-dev.c => sev-dev.c} (99%)
 rename drivers/crypto/ccp/{psp-dev.h => sev-dev.h} (90%)

diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 6b86f1e..9dafcf2 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -8,7 +8,7 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_CCP) += ccp-dev.o \
 	    ccp-dmaengine.o
 ccp-$(CONFIG_CRYPTO_DEV_CCP_DEBUGFS) += ccp-debugfs.o
 ccp-$(CONFIG_PCI) += sp-pci.o
-ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o
+ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += sev-dev.o
 
 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
 ccp-crypto-objs := ccp-crypto-main.o \
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/sev-dev.c
similarity index 99%
rename from drivers/crypto/ccp/psp-dev.c
rename to drivers/crypto/ccp/sev-dev.c
index c4da8d1..ba9f555 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * AMD Platform Security Processor (PSP) interface
+ * AMD Secure Encrypted Virtualization (SEV) interface
  *
- * Copyright (C) 2016,2018 Advanced Micro Devices, Inc.
+ * Copyright (C) 2016,2019 Advanced Micro Devices, Inc.
  *
  * Author: Brijesh Singh <brijesh.singh@amd.com>
  */
@@ -22,7 +22,7 @@
 #include <linux/firmware.h>
 
 #include "sp-dev.h"
-#include "psp-dev.h"
+#include "sev-dev.h"
 
 #define DEVICE_NAME		"sev"
 #define SEV_FW_FILE		"amd/sev.fw"
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/sev-dev.h
similarity index 90%
rename from drivers/crypto/ccp/psp-dev.h
rename to drivers/crypto/ccp/sev-dev.h
index 82a084f..c178d9f 100644
--- a/drivers/crypto/ccp/psp-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -2,13 +2,13 @@
 /*
  * AMD Platform Security Processor (PSP) interface driver
  *
- * Copyright (C) 2017-2018 Advanced Micro Devices, Inc.
+ * Copyright (C) 2017-2019 Advanced Micro Devices, Inc.
  *
  * Author: Brijesh Singh <brijesh.singh@amd.com>
  */
 
-#ifndef __PSP_DEV_H__
-#define __PSP_DEV_H__
+#ifndef __SEV_DEV_H__
+#define __SEV_DEV_H__
 
 #include <linux/device.h>
 #include <linux/spinlock.h>
@@ -63,4 +63,4 @@ struct psp_device {
 	u8 build;
 };
 
-#endif /* __PSP_DEV_H */
+#endif /* __SEV_DEV_H */
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index b29d2e6..473cf14 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -22,7 +22,7 @@
 #include <linux/ccp.h>
 
 #include "ccp-dev.h"
-#include "psp-dev.h"
+#include "sev-dev.h"
 
 #define MSIX_VECTORS			2
 
-- 
1.9.1

