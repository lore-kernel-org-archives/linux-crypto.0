Return-Path: <SRS0=+KeW=2R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1A1C2D0C3
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 06:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0550D2173E
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 06:20:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="Y5k0xiFB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbfL0GUO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Dec 2019 01:20:14 -0500
Received: from mail-mw2nam12on2040.outbound.protection.outlook.com ([40.107.244.40]:35118
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbfL0GUO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Dec 2019 01:20:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzHqMCNQviKnSIXWEl7HIq7ulCbdr8GIgs+hMxaCxs/58u8fzI2gQCvGunVFmYa8wyFdgfMIOPrn2JlB247cTPHQMm/Mosr9vfRGYP4L9I0AjXMYl7CTTgl3G2hSxmW8SV79pUVXcKlR/5eH6mn8Kl8woir7xIeBp5zQjcVuTyB/o/7gdjiXBU77NHCdGzWa3otOrf4vvXr/MPGMxYNc42e7gJpy17Afj1CBfFxQcoKgZ3rVYIwbe26uHqdIDJERfe3CvsK7uZ0FS09R4IJIALAafqUMOTsfOyr4nU3/RcoBtWnNZKPjpvLzJwKShiG8xGrbTQzlOFrAx3bw/zDyiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eLPL1gFr9cg5lgOMlfZYC4vklEupqhsQuaD/dAQnJM=;
 b=VgbnH1TRIh8L0brh1sb3VkDCHwS7MlbQXGaHzmJl8K+0PuVemysvbwdVy9U6L31a6wt2f66qsJygyKEmzZ8agt45FXY/hFWQvX6F0GnMbISn6tBLC/199NADBh+ypBiL1AnJEf4Vp+pi67etQIQb63rW7CjP1zbiuAFQ5modNeheQmopqjgKdjn7gdSKJDB0LqSNyrOIlCq95RcnuISHg0yXOTzvSK8tRQvduFBBysFlSko7uateuLRhBBH8I6wg/7lyn6BJLzRIlaFcVDbpAKZDwsRqvFNVdfrl2ZT9YvEXjEoKruspDlckwdf3mpcWBqgP/h4kD98AkZ3kXBZkBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eLPL1gFr9cg5lgOMlfZYC4vklEupqhsQuaD/dAQnJM=;
 b=Y5k0xiFBInPSAXZFn1z5R+rjWrWn/tcjrzseR1m60fUzYtMti83xgJXICOc7JA3tR95RI1hObI3eH+9Xa/b7+HF9gPA4wx33L8x3icr3Y9t4neGqNP0B5B+af6Vq0Rg5I9T6E9PvYk+iKYmadztA3IC9To6LsioaWNaSuCxR6so=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1366.namprd12.prod.outlook.com (10.168.168.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 27 Dec 2019 06:20:03 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2581.007; Fri, 27 Dec 2019
 06:20:03 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tee-dev@lists.linaro.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>
Subject: [PATCH 3/4] tee: amdtee: check TEE status during driver initialization
Date:   Fri, 27 Dec 2019 10:54:02 +0530
Message-Id: <7510087f2b8cffab083184dfefca183a6b73471a.1577423898.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1577423898.git.Rijo-john.Thomas@amd.com>
References: <cover.1577423898.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0022.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::32) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from andbang1.amd.com (165.204.156.251) by MA1PR0101CA0022.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2581.11 via Frontend Transport; Fri, 27 Dec 2019 06:19:59 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 06f07a16-03d8-4e6b-bed5-08d78a94ceec
X-MS-TrafficTypeDiagnostic: CY4PR12MB1366:|CY4PR12MB1366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1366CC373BFA13D8A1CB519BCF2A0@CY4PR12MB1366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 0264FEA5C3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(189003)(199004)(81166006)(110136005)(316002)(8676002)(66556008)(478600001)(6486002)(66946007)(5660300002)(186003)(26005)(8936002)(2906002)(81156014)(54906003)(66476007)(956004)(4326008)(86362001)(2616005)(6666004)(52116002)(16526019)(7696005)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1366;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SL89fFDLUNLRyWUGFJ1p8fHVr0aTeNDsSF2pJ62EPy9xRHkXKVe8TM5VOR6cFC2gKQdW5dMktuYnzbC3RTavXDrYADS8/mTQ7o9hLbtpcUA9V4vQtwmIHq0NzasNtKlUvYoMRpAYHZ3s7SOVqDovmV5xCU5qRZvPGKSPKuzb+KV9YgzYPqfsnrtcy5aMFhBg1c2wG3u90b6CLV3TjTIIeevOphnR4BMdC1VPui4m/gohWW0+q5BP5guZ5t9s7NafW/altRYMgBNdd1j+ZTLZBUKy/gOxocaLhNKbxl3r/+Y0lxdzSPETRe7A3EuhugEUKT/vpsIW5EgzMwo/7HWi5xb6VxRDMEQ9fjjWqyi2X5beDOtJnVLIy2l8cqRoQbdhPENQR3fALiFMAI0fZkd5wrdt3Yh9QMMFSe4sIiXtMkUstl5sJwbHG+EwORFan/FP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f07a16-03d8-4e6b-bed5-08d78a94ceec
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2019 06:20:03.1667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZHiadw7gqHV5D4Ngls2S6OhRuDjFmSulPWc5keAa1WNAe7XBpMm31EATqSXsNuDVUZnmpuXi96j9VPqMyROddQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1366
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AMD-TEE driver should check if TEE is available before
registering itself with TEE subsystem. This ensures that
there is a TEE which the driver can talk to before proceeding
with tee device node allocation.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: Jens Wiklander <jens.wiklander@linaro.org>
Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/crypto/ccp/tee-dev.c | 11 +++++++++++
 drivers/tee/amdtee/core.c    |  6 ++++++
 include/linux/psp-tee.h      | 18 ++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 555c8a7..5e697a9 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -362,3 +362,14 @@ int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
 	return 0;
 }
 EXPORT_SYMBOL(psp_tee_process_cmd);
+
+int psp_check_tee_status(void)
+{
+	struct psp_device *psp = psp_get_master_device();
+
+	if (!psp || !psp->tee_data)
+		return -ENODEV;
+
+	return 0;
+}
+EXPORT_SYMBOL(psp_check_tee_status);
diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index dd360f3..9d0cee1 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -16,6 +16,7 @@
 #include <linux/firmware.h>
 #include "amdtee_private.h"
 #include "../tee_private.h"
+#include <linux/psp-tee.h>
 
 static struct amdtee_driver_data *drv_data;
 static DEFINE_MUTEX(session_list_mutex);
@@ -438,6 +439,10 @@ static int __init amdtee_driver_init(void)
 	struct tee_shm_pool *pool = ERR_PTR(-EINVAL);
 	int rc;
 
+	rc = psp_check_tee_status();
+	if (rc)
+		goto err_fail;
+
 	drv_data = kzalloc(sizeof(*drv_data), GFP_KERNEL);
 	if (IS_ERR(drv_data))
 		return -ENOMEM;
@@ -485,6 +490,7 @@ static int __init amdtee_driver_init(void)
 	kfree(drv_data);
 	drv_data = NULL;
 
+err_fail:
 	pr_err("amd-tee driver initialization failed\n");
 	return rc;
 }
diff --git a/include/linux/psp-tee.h b/include/linux/psp-tee.h
index 63bb221..cb0c95d 100644
--- a/include/linux/psp-tee.h
+++ b/include/linux/psp-tee.h
@@ -62,6 +62,19 @@ enum tee_cmd_id {
 int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
 			u32 *status);
 
+/**
+ * psp_check_tee_status() - Checks whether there is a TEE which a driver can
+ * talk to.
+ *
+ * This function can be used by AMD-TEE driver to query if there is TEE with
+ * which it can communicate.
+ *
+ * Returns:
+ * 0          if the device has TEE
+ * -%ENODEV   if there is no TEE available
+ */
+int psp_check_tee_status(void);
+
 #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
 
 static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
@@ -69,5 +82,10 @@ static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
 {
 	return -ENODEV;
 }
+
+static inline int psp_check_tee_status(void)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
 #endif /* __PSP_TEE_H_ */
-- 
1.9.1

