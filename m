Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E80D5C54FC9
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 17:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC8DD2070B
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 17:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="clKR6OZi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgDURpG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 13:45:06 -0400
Received: from mail-bn8nam11on2072.outbound.protection.outlook.com ([40.107.236.72]:6190
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725963AbgDURpF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 13:45:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMTTnOOElPiLziHtAY4ExV2wPHPK2RRVXhX5ZztfapWxjKZVtYllyvsEopCMH/graLwCRTiuVjtEWtnGA/H9GPRJ+KQfWN7si1ZGZDDvQMQjyyIE19N9y6rNZRtJ6O6Xpg2eVKBM8auu+Osp0CTqd2Arc6hXeV2/I6O3u+dWN6rtAlTcPmyW7m08bYXO6OTAsBfIAJScpCcI/JIFCeNVatjGSkVVSE1Cqfc/n5Evt09Jxt5hn6iPa27tYrIReKtZP1szng9be9FSH78mpp51C71q4nky0tdUbjuirRXAFo8jsjiRc1eF8kK2uAuEiRxl3qA6ZTcoTxbBxnd911KR5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0sRG5H2QkSWwm6z4ETfxtC+TNcX+dTAbQiSPu6F2ck=;
 b=UEtkRB8E03NCvVq9zK1B919+4eXzVbrey27o5XKHXMF+olJ5JcS4nrhbf82tJ/e84F0HPeZw9Jq+bgdeWa2laEmXSQk3NokfQTdIPSpW7OPS/4gZpBBWH6WSFagw2SssuI7AHGTiORPzSgfiazcFjm5X1VlkrNX2Gv2VxVPgH9HAYwU5Ap+CMHejwFrtr3mkit/hZFovHGhmUvBhd99TtDCPBoJH5VP7x03JmUGJeeCZXuhJVldCCyR+XxkPw7bmJwt9n6+U2vTpYGQHxA/bXawROjC6Ds11AElfE1uzFhU/DiXckCsoUMW8BKcLNqzRLZMjKyCgehZ4RCJjvgPykw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0sRG5H2QkSWwm6z4ETfxtC+TNcX+dTAbQiSPu6F2ck=;
 b=clKR6OZiXAyV1TGiYphrsUX1n+OcY5kUroHStqJ0KZYQsGikc0zhvSAe2djeG+tJKFkx+3hm/KOVt0iSqSaxpe4RGbUphTHVh8VKGNO48UpDsz3wsJsn+0WAm3DmBmcEgonYOJXO4ATkEaos8EyeBMgDXFVAbSXHItqoPaBYcSc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB4514.namprd12.prod.outlook.com (2603:10b6:5:2a7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Tue, 21 Apr
 2020 17:45:02 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9ae:cb95:c925:d5bf]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9ae:cb95:c925:d5bf%4]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 17:45:02 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v2] crypto: ccp: Add support for SEV-ES to the PSP driver
Date:   Tue, 21 Apr 2020 12:44:49 -0500
Message-Id: <9530369b1f0be211ae2512a1ab9f54281a4420d9.1587491088.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0062.prod.exchangelabs.com (2603:10b6:800::30) To
 DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN2PR01CA0062.prod.exchangelabs.com (2603:10b6:800::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Tue, 21 Apr 2020 17:45:01 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f12b9845-e9fc-4ef2-22bb-08d7e61bb7d5
X-MS-TrafficTypeDiagnostic: DM6PR12MB4514:|DM6PR12MB4514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4514CA93E648C4004C7F1492ECD50@DM6PR12MB4514.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(16526019)(6486002)(2906002)(81156014)(186003)(66946007)(66476007)(66556008)(5660300002)(36756003)(26005)(4326008)(7696005)(6666004)(8676002)(316002)(8936002)(2616005)(956004)(478600001)(52116002)(86362001)(54906003)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZAsIq8o5Ya1GjZg61frBbSoWg9GMxKq8gLqBu3F1uNKER7CWoHCaRswjvyyS2OZjViewLgUe+ZJSdjmf79U9K1yfLeKKvBUVIkg+Aj27tWq5HKfkVuG8kUVdSKi7wDbHqWPQBeVkyohOzLm0k4z5VKMsAZz3WxeMYA4hUuMimJhRC8F4C7DzLMCreiZC3lgdy0sgSuTg+Wm3LCiJUIlbm1Y5DK1HfrzSWav42qd4miEMYIMvz+G5g0uQTh+kyCVmHQXbqMg13HUaX3SkGEnVQi3tdEuxuXrDtHE+4PNwMVmEP5WJPFwmACK9FFo1kh8t6f4c5hZ39ZfkqSIONOBxNEdsx/O2w5oEJpNIOtZpUA4VP7eP1lC8C0TiGuZAmrb9f2k9mOh4Q6qtJq0z9MdFR+9WUDvF/Tn2QMsncce//JjNReKgrc3xeZQucOhk18Ux1ClNFyoXUssJw0yyr3KPQxUyuP4XLJ5YD3P6TYKhafmYi+FSlD9jPgLxGIuK6p9P
X-MS-Exchange-AntiSpam-MessageData: Qx25/ondtDJlz6tvcO8+Vwqxk0a1zyGG3oSc+ns2DlEsEM5b+BVrFzLXmuB4Np4HiFDGh5a4PHgDhujC8m8g531bmrE+MDnf4G9kHQuJhSuhGh8V1suD1BqiXkSzh2rTgi9mth5qzhCCPre+M9CvVQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f12b9845-e9fc-4ef2-22bb-08d7e61bb7d5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 17:45:02.0907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghMo9vj60y/Fpee0c50NXKsyXR8lCqeh3evE6R+dRdC40BGyi73kOTU5+om5HaPhNayOaJXaJJkOns2nntO6yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4514
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

Changes since v1:
- No need to over-allocate the memory area to obtain the required
  alignment when using the page allocator.
---
 drivers/crypto/ccp/sev-dev.c | 43 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      |  2 ++
 include/uapi/linux/psp-sev.h |  2 ++
 3 files changed, 47 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 896f190b9a50..439cd737076e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -20,6 +20,7 @@
 #include <linux/hw_random.h>
 #include <linux/ccp.h>
 #include <linux/firmware.h>
+#include <linux/gfp.h>
 
 #include <asm/smp.h>
 
@@ -44,6 +45,14 @@ MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during
 static bool psp_dead;
 static int psp_timeout;
 
+/* Trusted Memory Region (TMR):
+ *   The TMR is a 1MB area that must be 1MB aligned.  Use the page allocator
+ *   to allocate the memory, which will return aligned memory for the specified
+ *   allocation order.
+ */
+#define SEV_ES_TMR_SIZE		(1024 * 1024)
+static void *sev_es_tmr;
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -214,6 +223,20 @@ static int __sev_platform_init_locked(int *error)
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
+
+		sev->init_cmd_buf.flags |= SEV_INIT_FLAGS_SEV_ES;
+		sev->init_cmd_buf.tmr_address = tmr_pa;
+		sev->init_cmd_buf.tmr_len = SEV_ES_TMR_SIZE;
+	}
+
 	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &sev->init_cmd_buf, error);
 	if (rc)
 		return rc;
@@ -1012,6 +1035,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
+	struct page *tmr_page;
 	int error, rc;
 
 	if (!sev)
@@ -1041,6 +1065,16 @@ void sev_pci_init(void)
 	    sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
 
+	/* Obtain the TMR memory area for SEV-ES use */
+	tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_SIZE));
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
@@ -1075,4 +1109,13 @@ void sev_pci_exit(void)
 		return;
 
 	sev_platform_shutdown(NULL);
+
+	if (sev_es_tmr) {
+		/* The TMR area was encrypted, flush it from the cache */
+		wbinvd_on_all_cpus();
+
+		free_pages((unsigned long)sev_es_tmr,
+			   get_order(SEV_ES_TMR_SIZE));
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

