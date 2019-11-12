Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63889C43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 19:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25D2420818
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 19:59:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="g7h9m80m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfKLT7s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 14:59:48 -0500
Received: from mail-eopbgr690087.outbound.protection.outlook.com ([40.107.69.87]:54402
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726376AbfKLT7s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 14:59:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHoUBmpHyueFFTVqEeFPGFj9X4V7Y0C7cMNS50j4S/ix1Isfb0DrrxhWNsN3njVuMLZIMzWfP0SRLiO/KuNeq0as8VCfwF2NJqNu8bQPzI/eYcA7TA4Qj93HkNRLpufiaYJ8oUFK/J5ZDqQWpTYl9h9MabvQjEzPOOQPOCuFFSYILpcNisYBJW1wUfJ6pzgB0D0qE7pf6ITUPv5XdXvAg6NOori7K4MWYnYlsulIz/h+rwSuDY1hktmAMC4GTjl8ZrthcTDsi7HBjMzAgeTwD+CBIPT04vZVBJ3Eqygu3WGJBVd5KzKyARwLv8wYdacjhIgeM8TWWignh5qLuQy/Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UC7ob3ys8Yvhb3cO5YzsbJRJlVr/3c1Dewoq/LRIU7A=;
 b=L8DVQTBU3H8JtkHz1UjJRXBiD1i3UJI/VqoshebQYnaidFCHz6yXLQrx9MIchTVK94I7bGaxzl0+iXWpFGxOYlT3Gd5nmICuUSnlbE/G9mbgFRM+Rx815Xbvo3ZstqcnFSshez1lx3frEGrLvCihwQqWdW3rlV5ohA9OAPzBPlV7BGMMpcpg/xfnkQmqq5Gok3+UAE8YATJRrjyI0aDsAjq29cOg3nCI8nlOUF5c+ERX74kT66X6Tgn7K/V0pWyyLAhcDLJl/dxfD9Szj65e/2wSPJb8eZU4i6uY6QPUlY/kPGF/3xYBL902Y3GZk6xD5iFzrdEAwf8oVsx4XIQPJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UC7ob3ys8Yvhb3cO5YzsbJRJlVr/3c1Dewoq/LRIU7A=;
 b=g7h9m80mQFKK6QvVcgbwV1SmyMJhgLW2dxpFVPcBJu6Mk18bmSkULF6aHmoTE/jpOwynNZnmzjXQu0/lVuoMYpTdR/+iOPI+uKRI9ksd1buocR2jNVNZ7DfW1KSNReUJ2ot6Kj+MV5hBD336s/9JFaU4kdHlxnHXrHdqqtBNNkA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3225.namprd12.prod.outlook.com (20.179.106.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 12 Nov 2019 19:59:05 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9%7]) with mapi id 15.20.2430.023; Tue, 12 Nov 2019
 19:59:05 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-crypto@vger.kernel.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH] crypto: ccp: add SEV command privilege separation
Date:   Tue, 12 Nov 2019 13:58:34 -0600
Message-Id: <20191112195834.7795-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN6PR1501CA0003.namprd15.prod.outlook.com
 (2603:10b6:805::16) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
MIME-Version: 1.0
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 43deeb66-f765-4563-d0d7-08d767aac554
X-MS-TrafficTypeDiagnostic: DM6PR12MB3225:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB32257DB6491D69208F335984E5770@DM6PR12MB3225.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 021975AE46
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(199004)(189003)(48376002)(86362001)(305945005)(7736002)(6116002)(3846002)(50226002)(486006)(81156014)(81166006)(1076003)(6916009)(8676002)(8936002)(51416003)(476003)(66476007)(66946007)(52116002)(2361001)(66556008)(386003)(6506007)(44832011)(5660300002)(2616005)(2906002)(50466002)(6512007)(99286004)(6436002)(4326008)(14454004)(26005)(36756003)(6486002)(14444005)(47776003)(478600001)(6666004)(16586007)(316002)(2351001)(186003)(54906003)(66066001)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3225;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vZUW1NmZVrgCYFlfYvbNZF8l5+tNkfk+o1q/exjvynJbR2v7ekibK9fzeDNQ8+bpz+Bp3jEKohz1+lUDi7C8Bpi81edCd8rGaWFgC8sqlg+FkSUxk9YBf8zmZ6W5Hxpdy5y2/SgxuUqInO+jZR//QZiQuKP0iYIxvGdGuDfjYiGmQnpN00RWEz4NZzD9LJQdtvUseq+0/MgW/Yv1tfU52CXGz+vCo6E/Bj8uuIx/vKV01JUyd8x67RXRY4+sfeXoFlZyS780cyPwrpqa283flL8r9BmmwKIajija0GepHDxLuBvaKlPKEWMXhLIOLQEqqo/pwuTOynGXrfLYL/TgizB08zciNsCoQx1jd8FeEP1NsygICx8lgzsDAGEEprO8PTvZ77iBE4kJ22Ydo3+Kg+z2PwckQnuTqpTFbGvRTRJP1YTRnVw0fuxhkDoA7whu
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43deeb66-f765-4563-d0d7-08d767aac554
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2019 19:59:05.3183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M1i/UZA6zNqL/GmL4OyCY0/hWI/1Goscp/Nfv2otiX4mUZSX3Kj+4apMKWmz3uuJMCNK2qHALTkkM8ZRJ6VBRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3225
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, there is no privilege separation of the SEV command; you can
run them all or none of them. This is less than ideal because it means
that a compromise of the code which launches VMs could make permanent
change to the SEV certifcate chain which will affect others.

These commands are required to attest the VM environment:
 - SEV_PDH_CERT_EXPORT
 - SEV_PLATFORM_STATUS
 - SEV_GET_{ID,ID2}

These commands manage the SEV certificate chain:
 - SEV_PEK_CERR_IMPORT
 - SEV_FACTORY_RESET
 - SEV_PEK_GEN
 - SEV_PEK_CSR
 - SEV_PDH_GEN

Lets add the CAP_SYS_ADMIN check for the group of the commands which alters
the SEV certificate chain to provide some level of privilege separation.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Erdem Aktas <erdemaktas@google.com>
Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
Tested-by: David Rientjes <rientjes@google.com>
Co-developed-by: David Rientjes <rientjes@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 29 ++++++++++++++++++++++-------
 drivers/crypto/ccp/psp-dev.h |  1 +
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index c4da8d1a9abc..5ff842c03a70 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -294,6 +294,9 @@ static int sev_ioctl_do_reset(struct sev_issue_cmd *argp)
 {
 	int state, rc;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	/*
 	 * The SEV spec requires that FACTORY_RESET must be issued in
 	 * UNINIT state. Before we go further lets check if any guest is
@@ -338,6 +341,9 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
 {
 	int rc;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (psp_master->sev_state == SEV_STATE_UNINIT) {
 		rc = __sev_platform_init_locked(&argp->error);
 		if (rc)
@@ -354,6 +360,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
 	void *blob = NULL;
 	int ret;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
@@ -540,6 +549,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
 	void *pek_blob, *oca_blob;
 	int ret;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
@@ -695,6 +707,16 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
 	struct sev_data_pdh_cert_export *data;
 	int ret;
 
+	/* If platform is not in INIT state then transition it to INIT. */
+	if (psp_master->sev_state != SEV_STATE_INIT) {
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		ret = __sev_platform_init_locked(&argp->error);
+		if (ret)
+			return ret;
+	}
+
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
@@ -741,13 +763,6 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
 	data->cert_chain_len = input.cert_chain_len;
 
 cmd:
-	/* If platform is not in INIT state then transition it to INIT. */
-	if (psp_master->sev_state != SEV_STATE_INIT) {
-		ret = __sev_platform_init_locked(&argp->error);
-		if (ret)
-			goto e_free_cert;
-	}
-
 	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, data, &argp->error);
 
 	/* If we query the length, FW responded with expected data. */
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
index 82a084f02990..dd516b35ba86 100644
--- a/drivers/crypto/ccp/psp-dev.h
+++ b/drivers/crypto/ccp/psp-dev.h
@@ -23,6 +23,7 @@
 #include <linux/dmaengine.h>
 #include <linux/psp-sev.h>
 #include <linux/miscdevice.h>
+#include <linux/capability.h>
 
 #include "sp-dev.h"
 
-- 
2.17.1

