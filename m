Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D952DC3F2D7
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 13:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A735D20857
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 13:58:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="E9rdzTSm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbgCCN6C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 08:58:02 -0500
Received: from mail-co1nam11on2088.outbound.protection.outlook.com ([40.107.220.88]:6191
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729221AbgCCN6A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 08:58:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4owdKqshwSOhazMFP+285PQwhbrbqCJMozJduJ1rJAmQnGEF8Ai6jhofDgAtT7dl6kxI0ppKxJRhunnbmntolkeprE/cCsu4+cAaN1EEus/rZwDewrO+i27iBC1gwaajkXGVybDdL5lAfnBTqAyjX7egxeOsdPn49nrt1AbQ34p755tCEg8EVgeEbgjbAkv4OlQyn250PSfAa6xZ6U3to9wdm9RpYEd+/6Spp3d0mMOsgyohXMQmcXtm7mVe4wJvN5LjYvjbb+TFiQ2LGGz5rQZz+XZWQzPPeBMpuDuCdf8lsL73jCf8zSJyyPjtdym+5/lJvZ/70XAqec4V4VNmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxFF7ge0Np68AOeCRzrePADGpN5rxY8q+5lDAqCGYU4=;
 b=G3taHuilYNSQdaz8Tka8B4jURLVMD0uhNwmsDbs1tE04EmwjuorA+8BtumOG32dXfLa3M9y2Znm7RCbq4hWBg0oKnrfrZ51DRcxZxpZF6MkQ/McXX/cKcMaibqKVt/fJeFtqOjwsnn8aI8Uylo1/7pOXBPv2iuRd2cqd14Tlkn5qI0iKGN+IbgIiZwY+8/r4wsxKLkNPYHduTRGpru6RByTcbfrmnYPiNLB0ElN5TAHJo+gjk1EWlGNcsLmEV4wwBkt+5h/c2V4SQG1RZlkTAdgIIraIzIs5VJufq6LNZWnlffJ+T8+y2rMvcsK4fIO2eI9MIEO2dSc8FOWjDeGMYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxFF7ge0Np68AOeCRzrePADGpN5rxY8q+5lDAqCGYU4=;
 b=E9rdzTSmxfriB/kDRWYEMhED1CcxONnKBSg77PpTQGDaU1agKSX6syFtlBNj2bG9XysVwlmSf92W6F+djomtxTwhjSFNpnM04OwN7kSmOBJ510gWfqFhfMZwn8JoYBsmEsvXz/k4twafw45GvUGqZH9Oltr31OPfeY9/DqcpPWM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=John.Allen@amd.com; 
Received: from SN1PR12MB2448.namprd12.prod.outlook.com (2603:10b6:802:28::23)
 by SN1PR12MB2414.namprd12.prod.outlook.com (2603:10b6:802:2e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Tue, 3 Mar
 2020 13:57:54 +0000
Received: from SN1PR12MB2448.namprd12.prod.outlook.com
 ([fe80::4064:dc7:d9b9:1f64]) by SN1PR12MB2448.namprd12.prod.outlook.com
 ([fe80::4064:dc7:d9b9:1f64%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 13:57:54 +0000
From:   John Allen <john.allen@amd.com>
To:     linux-crypto@vger.kernel.org
Cc:     thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, brijesh.singh@amd.com, bp@suse.de,
        linux-kernel@vger.kernel.org, John Allen <john.allen@amd.com>
Subject: [PATCH 2/2] crypto/ccp: Cleanup sp_dev_master in psp_dev_destroy()
Date:   Tue,  3 Mar 2020 07:57:24 -0600
Message-Id: <20200303135724.14060-3-john.allen@amd.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303135724.14060-1-john.allen@amd.com>
References: <20200303135724.14060-1-john.allen@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0060.namprd07.prod.outlook.com
 (2603:10b6:4:ad::25) To SN1PR12MB2448.namprd12.prod.outlook.com
 (2603:10b6:802:28::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mojo.amd.com (165.204.77.1) by DM5PR07CA0060.namprd07.prod.outlook.com (2603:10b6:4:ad::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Tue, 3 Mar 2020 13:57:53 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e3236002-00d5-4163-c1f6-08d7bf7adee7
X-MS-TrafficTypeDiagnostic: SN1PR12MB2414:|SN1PR12MB2414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB24140A6BB62BA3F0DCBA008F9AE40@SN1PR12MB2414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:480;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(189003)(199004)(478600001)(26005)(6486002)(4326008)(8676002)(81166006)(36756003)(8936002)(16526019)(6666004)(52116002)(7696005)(44832011)(86362001)(186003)(81156014)(316002)(1076003)(2616005)(66476007)(956004)(66556008)(66946007)(5660300002)(2906002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2414;H:SN1PR12MB2448.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G72HIWkURfMExqwBejq6x39yEfq4/JG6gctWxFxcE3HiCk2vdiFfj3GHFvBcFHQOWoqi3JN3jjOflAyadCWXy6UkmCaLUSMXocFAMrN/SwBV1T7PaKnwSntuVfp945RQJ16TjSlclRM0TuHFMIhrIpom0FNDoiw5TY63fsVH17u55DayXYw1eMD675Josg7Qd9uSLTyJRVOlWekUlqpgY6AagpDcs1UdtyBX1lME3jfDxUpiWeFEzG+HVpAVnbG4WjoCVDVJN7KrBEVmz3U1lkXF0gBWCeL4FIH5een9IKtYzyt3ynsfwLF+Hu/OyB0Z4DuiFuAE1i9keKUyerpEsvJ9gXLae6zj1vx493OuwFyRa+QfFwJV5fjftzggSzT1n4jZmlgOTnwUO1UsdWerKKJ5vsnB92eHgUIkm/JkQtJ7YB9an035ynRvargQdPIm
X-MS-Exchange-AntiSpam-MessageData: eamE7WfJ8T7UF++26B1K2vlWGTFCRfVvdk4VkyJGyy91vc6hwVw2+So4WcLBNHMG6iFsz2Oi10Yja7ZYVXAWajrVxZwqWiYeKO9Z028GmkANYIbwPxUAHuFiI3LAgOGGAct5SKS5wqEuwAXkUKNjNA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3236002-00d5-4163-c1f6-08d7bf7adee7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 13:57:54.4829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZB+WIgCHiRPQ3xVA35+SYOv0SHZ5idGstljhaQUydSd/EraMNpY+7j67yUXn3hA3y1idYo3bkDv3VjAz/6qg6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2414
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce clear_psp_master_device() to ensure that sp_dev_master gets
properly cleared on the release of a psp device.

Fixes: 2a6170dfe755 ("crypto: ccp: Add Platform Security Processor (PSP) device support")
Signed-off-by: John Allen <john.allen@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 3 +++
 drivers/crypto/ccp/sp-dev.h  | 1 +
 drivers/crypto/ccp/sp-pci.c  | 9 +++++++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index e95e7aa5dbf1..ae7b44599914 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -215,6 +215,9 @@ void psp_dev_destroy(struct sp_device *sp)
 	tee_dev_destroy(psp);
 
 	sp_free_psp_irq(sp, psp);
+
+	if (sp->clear_psp_master_device)
+		sp->clear_psp_master_device(sp);
 }
 
 void psp_set_sev_irq_handler(struct psp_device *psp, psp_irq_handler_t handler,
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 423594608ad1..f913f1494af9 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -90,6 +90,7 @@ struct sp_device {
 	/* get and set master device */
 	struct sp_device*(*get_psp_master_device)(void);
 	void (*set_psp_master_device)(struct sp_device *);
+	void (*clear_psp_master_device)(struct sp_device *);
 
 	bool irq_registered;
 	bool use_tasklet;
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 56c1f61c0f84..cb6cb47053f4 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -146,6 +146,14 @@ static struct sp_device *psp_get_master(void)
 	return sp_dev_master;
 }
 
+static void psp_clear_master(struct sp_device *sp)
+{
+	if (sp == sp_dev_master) {
+		sp_dev_master = NULL;
+		dev_dbg(sp->dev, "Cleared sp_dev_master\n");
+	}
+}
+
 static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct sp_device *sp;
@@ -206,6 +214,7 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_master(pdev);
 	sp->set_psp_master_device = psp_set_master;
 	sp->get_psp_master_device = psp_get_master;
+	sp->clear_psp_master_device = psp_clear_master;
 
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
 	if (ret) {
-- 
2.18.2

