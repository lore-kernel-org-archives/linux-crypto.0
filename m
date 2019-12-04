Return-Path: <SRS0=RobT=Z2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D037C43603
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 07:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 422D620863
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 07:12:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="vkd8sJik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfLDHMV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 02:12:21 -0500
Received: from mail-eopbgr760077.outbound.protection.outlook.com ([40.107.76.77]:12403
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726599AbfLDHMV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 02:12:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MX4wW2Ut46E8QmCPjvbrnUViB7zycerHo2rtzoZOLn9tLsqJrk8CdG6mrSKh5lRCHjKki5+xCh1tvNPv28m68pGfCAamfhWWBcte90bCxwbuP4N+EJl8cyqnqeriKcD33bn3b/Lrt1bS/xaUydq5/PBrQork9Sslvh5Xa26zgJWrhO6J0Mb3e3FeCrYlB5nKDcK4k9cqrozp5U/S0i5hFSKsbCjNzOfu8AxV5acEoBlx31LObhRiiw2E7AgcLnT2g6CusPLKsrGGSEUa6iyJiUdA0fWtozehslQC+53SGFndXPdzhR0ZJrkZ7HMCQueqWBncM/PVghanrvjfwGFsfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jfn44zHyr/xtMEAFzx9HGhBo/37PTt4/xd7UMknOIFc=;
 b=Bsq7D8WcCGEKtMAdIKyvxNry7iz3S599FBY/J0jc+/WiAeE+fCn/mi0Kqg5kQVGj3/CbqFfxeJWxOrnzjn+uPM+lOkr4Xl5DPFnLyKW1hKw79KajZfpcDavhNLeam0VHDQ0fvlu5H4mXi61c3Z9imzzeJKHuvf//2cn8gvAsYfh98QOnHrzUE2YiVXcKE3lf+mdvwRhEZd3U649BnTgOX/+3aNpk88DESNtC/Cd7RBQ0H0LTJlY8xZbd5iaDC4U86K1HoscvpIe8RCS6ngGTSvaEB9vv7G6Zigmd7RAeDve1GdkUKgbSqopGHdLc0mqf6h6lAzDkDdnNsZchmo8Oig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jfn44zHyr/xtMEAFzx9HGhBo/37PTt4/xd7UMknOIFc=;
 b=vkd8sJikpBj1RaBVyHJh3EKz0CupvgwoU+XFG1SNp1XmWEWhfyGXK3n3AnDBo07n2SAm/bOiwWGFOstMNRTp7U1k+citmirDQPV/gwuRNEjma32J6Xh6+2pLZAvCOIoOBcHDXYKNN35CpHR2fIHFiafZJMOidb5wR64RnwIZ7Rk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1400.namprd12.prod.outlook.com (10.168.165.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 4 Dec 2019 07:11:37 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4%7]) with mapi id 15.20.2495.014; Wed, 4 Dec 2019
 07:11:37 +0000
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
Subject: [RFC PATCH v3 1/6] crypto: ccp - rename psp-dev files to sev-dev
Date:   Wed,  4 Dec 2019 11:48:58 +0530
Message-Id: <57c6797e99b1f62ff13222c8f0ee4687e8617a48.1575438845.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1575438845.git.Rijo-john.Thomas@amd.com>
References: <cover.1575438845.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0065.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::27) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 31fd1705-63ca-4788-ce1a-08d7788933df
X-MS-TrafficTypeDiagnostic: CY4PR12MB1400:|CY4PR12MB1400:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1400C478704CBFDB9F1DEF4CCF5D0@CY4PR12MB1400.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0241D5F98C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(199004)(189003)(2616005)(66556008)(2906002)(66476007)(50466002)(48376002)(478600001)(14454004)(50226002)(11346002)(36756003)(81156014)(26005)(54906003)(110136005)(81166006)(3846002)(66946007)(8936002)(446003)(8676002)(5660300002)(6486002)(6116002)(386003)(186003)(6436002)(4326008)(99286004)(25786009)(6506007)(14444005)(118296001)(76176011)(16586007)(316002)(86362001)(52116002)(7736002)(51416003)(6666004)(6512007)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1400;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RMbTVE6Qql1HqxMmRvKTu0IvrTURSru368FCTsCBCLMvuAGMREiP3ox7i1lg+RPvOR9ctcarjKRtJWsSL1HcPC8ZL2Oata7E5rSScAQ+nQd/jZkjB/s9zZt662s03SGjTjv6CHKKjDYqKKU8OFrFWYLBP5F56VXyORXAyLHLvVOeZPzxtVFYnGnPjTqVjpjLz+0wqhSW0bV9//GZR2hlyQ6TjS20rmXbFdoQYyqYU8p0E3PKw/zJkNkkLPzJfr47nGUFvu8DDWxNHqZ239rqbpDQv/eLOT4IYYXGs2fZEXZYXWRVBH0pg9F+nnAjOCUqCY/kutL8SQ5eIpCVXSnu+ysXxB8samcfhXa5/RZvaziUD4XTY8cyrSXWqfkoysLhpSIrTIS4pHgb0GnC7/hkEa7dHbFBQJeWiRkUr6ZIme5wkwR6uhjtAOeYUyBMSKpb
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31fd1705-63ca-4788-ce1a-08d7788933df
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2019 07:11:37.7320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IYZMqpVwR5gC8PdvlxW4bU/mI0Sz4Bnj4R91ceI1q7/JIjfnroCOYcjUPoUrBEoDL8jRG2SexlQnAXcI6opPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1400
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
index 5ff842c..9a8c523 100644
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
index dd516b3..e861647 100644
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
@@ -64,4 +64,4 @@ struct psp_device {
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

