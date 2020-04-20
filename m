Return-Path: <SRS0=BVES=6E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E25C3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 19:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A6DA206A1
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 19:55:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="0IQu2K1q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgDTTzQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:55:16 -0400
Received: from mail-mw2nam12on2076.outbound.protection.outlook.com ([40.107.244.76]:58752
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725897AbgDTTzQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Apr 2020 15:55:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijWwz4hyWLM4YSxt7bgB/itZWzWOnMUW6V6SvXDaoALdUY6QJ3Wfe/N6R6gph1n9npHCLvruEPLEItfk5UDjSxtGZ9pI9EzFUT5IfcYnGlAcP2dpz1bMOlcG8m3KTp7dfLA+ZNqw4BvAtl8r6dLzcrTHwWI0AB4Lm+WyvbWhVOlCkdKOXVxW9LEPbEWHbqfKb2NJmXQMOXAmR6tvEzIUge+/cW3Hv7hqcVP6h9a9uFDuHRwkZzcq21ZzSsUumPTw2hp2ub19mDD4lNPTdXR6qzGcL+7h2Bj2XLEODHpV8UWjMlTlm19beVtbSxvuYGFufnecsIT0/u4ko485uhp0rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYSwgL2MArJfH7eMf3xTgVjuBoJ/KA9hwUw2qJNBIjo=;
 b=flPHfZD66FxqrBk5NsFr/mv5N9SFzMtuZ9jr5b6y47E70uylC+crItuOC+rVFNtP8NVXo92rcnxxOxlVoqLIhq8GTobTMrsK8+6d4i1m44NR54ERor7Sdd5hVconFKI/+6X0Awjrcq/g2PVkpKrv8Yrh6qhD9ttuTvAOuE6p7jYOu64HEL1WpiqzGuPlhWfKunHH+aoqCfk65clyZxZuOqtwW+U1CoD+f2cXqSOxyHx8fUTzE3rznCuGoXS7RwJXJ4QZVdOjQnNROyzYgJHwRyMhH8/IWZNdAefn8fTyvn1GWxC39JIK0/i4dWd9d4HEKMO2mtgxdBhNWD5NEAM+Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYSwgL2MArJfH7eMf3xTgVjuBoJ/KA9hwUw2qJNBIjo=;
 b=0IQu2K1qevenAbVthEXI+pqq6CUiD0uJ9N1FwzUUGWk4PiXMgB5eDHTKjQpOrWpn8Myu277zSZturfDTtWc4qoq7BDppyy4ByfsAtMRCn+OVoo3T35b3DA5aWVHs6eyPzSwbyK6X2khDD/4qxDh5iTTtxZnnezB+Y8Ijp8qXN1Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB4250.namprd12.prod.outlook.com (2603:10b6:5:21a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.30; Mon, 20 Apr
 2020 19:55:12 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9ae:cb95:c925:d5bf]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9ae:cb95:c925:d5bf%4]) with mapi id 15.20.2921.030; Mon, 20 Apr 2020
 19:55:12 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] crypto: ccp: Add support for SEV-ES to the PSP driver
Date:   Mon, 20 Apr 2020 14:54:58 -0500
Message-Id: <134926f3bcd38e51d5d0b0919afc7a16311d9c0f.1587412498.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0010.namprd04.prod.outlook.com
 (2603:10b6:803:21::20) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0401CA0010.namprd04.prod.outlook.com (2603:10b6:803:21::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Mon, 20 Apr 2020 19:55:11 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e2adcc25-09e0-4ab1-6cba-08d7e564bc88
X-MS-TrafficTypeDiagnostic: DM6PR12MB4250:|DM6PR12MB4250:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB425004E7EA1312BAE0096D25ECD40@DM6PR12MB4250.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(478600001)(26005)(5660300002)(52116002)(66946007)(4326008)(6666004)(7696005)(6486002)(16526019)(186003)(86362001)(316002)(8936002)(66476007)(81156014)(8676002)(2906002)(66556008)(956004)(2616005)(54906003)(36756003)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UjdRHpBSP1Jz3mEQwwsSOojcFH0rRqa7nh51cYssnYvIBMRYpMT060EsWQ0ATRrv5WspWfw0WtQrm7IVGuRuMBbFP/NG0BzdlP3p60sX8eONKgOJC0NwEgJBOyv6gwxXjm5oi5aet6T6kwmS4zqEUrEga6gfpeHd8hlPb4ncBqo9dbTyhfRmMMxs8KKyOgix8jhwqYSx8lfCboZgZZagHIjtGGHew+WsEh8QWDC/HgbUwA84YHiCLDvgMcUr7Q0Yl1EDj9nNvjbUeeSSTx465KRXxCECh8RFjSYuPF80l8X49COXa563pdecbUu1UsYsfpdLlqhAiUN/7xRHlnnM+Fq3PBZ5wcjcNPgcq0bCJTAhSOTTWJWsjsSqdqQb+Xtyp29Dx6aZfAiXSM82cQYHTc+nfNuytabhSYDtUfNaxz9oC3dRVNOlYoaqbY572gDs7T7jiN+oWAKewMPcISwrr6netCSLh/6eV4KQ/esTvm70eHkPjHnnf9oKeIPXgkep
X-MS-Exchange-AntiSpam-MessageData: Z+AbIBoFgkBCGpblNBQ7E0NOa1igRRIqQ2mOetf4IlqVQBFsO5oECxaYm+0JaFOu7olz+b+hmDea4hJhmsmlXquosBBfMIDBvsF8LYUK3AVH+8wuzkmBP8o6nQlt5x/KGAs5I1uH4hprKcjN1apY/g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2adcc25-09e0-4ab1-6cba-08d7e564bc88
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 19:55:12.0101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5sqktH0o+veuRMSasg9D2QJI72updLG7Ug7l60fB7yb/5mmKTOrEKvtOIwCY4UODVdckYrf5HqZJxe4TeaD3IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4250
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

To provide support for SEV-ES, the hypervisor must provide an area of
memory to the PSP. Once this Trusted Memory Region (TMR) is provided to
the PSP, the contents of this area of memory are no longer available to
the x86.

Update the PSP driver to allocate a 1MB region for the TMR that is 1MB
aligned and then provide it to the PSP through the SEV INIT command.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 47 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      |  2 ++
 include/uapi/linux/psp-sev.h |  2 ++
 3 files changed, 51 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 896f190b9a50..0d978bad60d9 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -20,6 +20,7 @@
 #include <linux/hw_random.h>
 #include <linux/ccp.h>
 #include <linux/firmware.h>
+#include <linux/gfp.h>
 
 #include <asm/smp.h>
 
@@ -44,6 +45,17 @@ MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during
 static bool psp_dead;
 static int psp_timeout;
 
+/* Trusted Memory Region (TMR):
+ *   The TMR is a 1MB area that must be 1MB aligned.  To achieve this, allocate
+ *   an amount that is the size of area plus an amount equal to the required
+ *   alignment. The aligned address will be calculated from the returned
+ *   address.
+ */
+#define SEV_ES_TMR_ALIGN	(1024 * 1024)
+#define SEV_ES_TMR_SIZE		(1024 * 1024)
+#define SEV_ES_TMR_LEN		(SEV_ES_TMR_ALIGN + SEV_ES_TMR_SIZE)
+static void *sev_es_tmr;
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -214,6 +226,21 @@ static int __sev_platform_init_locked(int *error)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
+	if (sev_es_tmr) {
+		u64 tmr_pa;
+
+		/*
+		 * Do not include the encryption mask on the physical
+		 * address of the TMR (firmware should clear it anyway).
+		 */
+		tmr_pa = __pa(sev_es_tmr);
+		tmr_pa = ALIGN(tmr_pa, SEV_ES_TMR_ALIGN);
+
+		sev->init_cmd_buf.flags |= SEV_INIT_FLAGS_SEV_ES;
+		sev->init_cmd_buf.tmr_address = tmr_pa;
+		sev->init_cmd_buf.tmr_len = SEV_ES_TMR_SIZE;
+	}
+
 	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &sev->init_cmd_buf, error);
 	if (rc)
 		return rc;
@@ -1012,6 +1039,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
+	struct page *tmr_page;
 	int error, rc;
 
 	if (!sev)
@@ -1041,6 +1069,16 @@ void sev_pci_init(void)
 	    sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
 
+	/* Obtain the TMR memory area for SEV-ES use */
+	tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_LEN));
+	if (tmr_page) {
+		sev_es_tmr = page_address(tmr_page);
+	} else {
+		sev_es_tmr = NULL;
+		dev_warn(sev->dev,
+			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
+	}
+
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
 	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
@@ -1075,4 +1113,13 @@ void sev_pci_exit(void)
 		return;
 
 	sev_platform_shutdown(NULL);
+
+	if (sev_es_tmr) {
+		/* The TMR area was encrypted, flush it from the cache */
+		wbinvd_on_all_cpus();
+
+		free_pages((unsigned long)sev_es_tmr,
+			   get_order(SEV_ES_TMR_LEN));
+		sev_es_tmr = NULL;
+	}
 }
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 5167bf2bfc75..7fbc8679145c 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -100,6 +100,8 @@ struct sev_data_init {
 	u32 tmr_len;			/* In */
 } __packed;
 
+#define SEV_INIT_FLAGS_SEV_ES	0x01
+
 /**
  * struct sev_data_pek_csr - PEK_CSR command parameters
  *
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 0549a5c622bf..91b4c63d5cbf 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -83,6 +83,8 @@ struct sev_user_data_status {
 	__u32 guest_count;			/* Out */
 } __packed;
 
+#define SEV_STATUS_FLAGS_CONFIG_ES	0x0100
+
 /**
  * struct sev_user_data_pek_csr - PEK_CSR command parameters
  *
-- 
2.17.1

