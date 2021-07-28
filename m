Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34064C4338F
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Jul 2021 15:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EC8460FE7
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Jul 2021 15:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbhG1PPx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Jul 2021 11:15:53 -0400
Received: from mail-sn1anam02on2045.outbound.protection.outlook.com ([40.107.96.45]:4398
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235546AbhG1PPx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jul 2021 11:15:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+8AmMsRF64CUURaBeP4LO1nGD4sCzIX3p5VeCYN7zwijMA+N20A7NHpzdACwPdf91+9u/jVC0eY0rjjpIZARM87gGTPesPxwsTMWGbxNJd+yyTaKHQARcrx4vdM/hOsVeOiZZvuusHs6gRocNevBgl/6mEiXSEz8/qWsgdnhWMqD0hAOgo5gdmQMxoarPNb0+mX1iVKi4fRHbTY6Txx5nUIKL476T09pyRLKPRTvHwHLf0tEgG/lq+eVDU7UK2wvYa5syuqAe2tVxdNTk0z/q54ZyVsDXqstM59G2wNIVTdQqYN9wn5GtSxKZxrKOxPeJb8bwNUkDGvU3NGCqx0UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L79AFbhiQ6X5AVDBIlBu3i93dO9GaVj+jpDJ+sw1X8E=;
 b=WUcmGACNAnrwVLEjligZauVpV6ZpfN6UjVKDTwjlsWUDirUiG2WJGfxZZSPULsz1le3lfCwlxr8UDUN/G6G3h7c2EIHLwwr3y7fkcyVxH0qblO60fs+LxLZgB6P1uBqunrbhYfimyjHqFrttMiPfxLK4HNmhiOggV+4+0EVpH1hZG7gV8zgX9VLQDO4GDQIJqvOlJ5cjUndceg89c3WeF40kE3Hj2ldXgQfvO/9hbhVsA8Xom2tZ6HETFD+CQ2QxFvsfA+J4nlA56izpm6Z2Ppr9lw2CIKumudUqjHxXhGFKiIXmLp0eYOSCZNvlKOZhdVsf9HKx2yTHkYMGEk4GYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L79AFbhiQ6X5AVDBIlBu3i93dO9GaVj+jpDJ+sw1X8E=;
 b=qaQ1zjYtGRjb0/2TQxmq8LT7oGyna4OPUmiBd9sJ6eMfbOKB5mCYnQGSrY94URCMHJ/lUa7dlOnXErP3boTyysMDOHwy/dPefR4dqrXRw1ceeKJRu9dZgAUCZTBMEZ4zctpKfbct/TsOaXREYSa0uwWdDhz0EL5hqqQBznAQVcc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB4750.namprd12.prod.outlook.com (2603:10b6:805:e3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 15:15:50 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 15:15:50 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, lucas.nussbaum@inria.fr,
        Brijesh Singh <brijesh.singh@amd.com>, stable@kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH] crypto: ccp: shutdown SEV firmware on kexec
Date:   Wed, 28 Jul 2021 10:15:21 -0500
Message-Id: <20210728151521.5319-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0069.namprd13.prod.outlook.com
 (2603:10b6:806:23::14) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA9PR13CA0069.namprd13.prod.outlook.com (2603:10b6:806:23::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Wed, 28 Jul 2021 15:15:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85924551-b2f9-4f1f-f719-08d951da9548
X-MS-TrafficTypeDiagnostic: SN6PR12MB4750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4750CE55A013B6C6EDADBADEE5EA9@SN6PR12MB4750.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vB0XLNyYX6aRtgQC2nVMNoDSlJARW/wzNuCOg+Wfo3ebafss8wmkLbp5kqNTQqAWyxBhqJX7laUs7lr5l9pQtTkLytRx31F+GxDPEoPFOTRKsd/SlZj1E11NMDBkZ7bSvoXuhbCeE9oroocbsFpxUcH1BePKL/zii1NwVAmZKeOHPeoC+BSSUhKVI4Sn7dd9/hic1HoQSauIcnOoRqnK+gPKn0kOx0vAYMXk2Fp8tym6FJrL31hMZv574miV4X9AxdQb6Zxj8PXXTyl7r6DR0rUlgT1zbP3V6BFQ4QN3Mepe4Fsc/3CiRg68O/eKwftFbmiy1LYo1R8uhesp2yGjF/9SMBcKU1NWNzCAn3dJl3H67oAB4akqmcOBgnguQlKZnpr+0JO98rK9FpJJ+qNjQK+d43+NROyJ+ZMQw9ns8L6YmjsXTBOWGXKCaeEwlF4YTdLuyO9zNm+h6cx46v3C0uWiDX2XtnLWIJmLsjc6q2NuefB+apsTdZn2IJHTrqvhVRPQGzjUpePNiyCBB17TM915Y9W36zWJn78V55z0G/w+6RnCMByPrhB3vjZrRwRvqNDz0MBN2dqjwfD4J4uPy6L5Cogm66X2pFFJ6dqZnzT+bVxeftXTXzWKNCyyIIOog0AqOwbV/st+iQ/m82AuyqqnOyKvT658fWoZ1TeIfHzVNLiU7DGQ6s1IesfK/32HIGtGMwHjJP4pY8aM91GYow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(6916009)(38350700002)(2906002)(1076003)(38100700002)(83380400001)(66946007)(5660300002)(8676002)(26005)(4326008)(36756003)(186003)(6666004)(86362001)(478600001)(54906003)(52116002)(66556008)(44832011)(6486002)(66476007)(2616005)(316002)(956004)(8936002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UzW6tK9qjZ29RAdHRlErJgdrBN21byMu7tpFRXSl9xpXDPnib1iOErrONF24?=
 =?us-ascii?Q?L+l9QsAUqNGUHepkZiUVZ3D5G20guOMKZjfVXE5ix9g8bIkHlWW6x8yaSkuc?=
 =?us-ascii?Q?C/Q1K6zsdqDCVlJUIYm9LxRw4gNB83EerV+EB/nDx4Ck1oo55XmGqC9FLVbb?=
 =?us-ascii?Q?hF9Rp5puuQ1gZMZZZMztnYydtq+dWP9IpFd0Tcv5nzMKTILH3BpFoQxi5/2N?=
 =?us-ascii?Q?3KNoT/Ixzc2i5ffSXLBZan7QY7fp2OXA5oDSm2OgapG+AaT82tQBD1i0HGWm?=
 =?us-ascii?Q?xkKBeO6XbAD7FNGpkcS69hQhVmtcOwpoGX8kPfoYHhwTOJ+dUmnUMZSQEt9g?=
 =?us-ascii?Q?0fai72H2piyFBxw5v355LCexrmWlBZrv6cTLUjCJIA0J0Veax09sou1HT0MO?=
 =?us-ascii?Q?hUj8eWty66xmeEspfNIF7NFBFkrVXpADhlshP+zzK98yPEzpx9czINdesrmB?=
 =?us-ascii?Q?xLot4s7UQfZsmABcFSB4zgRjgm9OoY1gVUFSajnS6/s5iIpi5EQFRBX9KoU+?=
 =?us-ascii?Q?/Eok1wyASim/rjy3757+NQAv7mcsILcnFfW3t8aJQ/3Y2SqRybFWR0G/z2H4?=
 =?us-ascii?Q?+DoALSsvusJRQrktQMcEK9bWuaEapwgvxHXbrbpY8kKYcUb+btdXcxiwOl84?=
 =?us-ascii?Q?ZLkbCmGnjyBOwM4QWNndgesZFDQLQ4wyQX4NWW37INoeE59ia75kF0JhzLAQ?=
 =?us-ascii?Q?Lw77jjwqrJanCYWbYJRiJU0YW7a0EEGgJ9R3wq/HiJ0AAGpAVMj4mB0YScyY?=
 =?us-ascii?Q?PQ4+E/XS/gTNKqCwyAVZJ/3hj/irSOte5h9AbSE6T1bihYh2yvZhOmCB18xq?=
 =?us-ascii?Q?E0xA7+wR9t1BKg807y/X9NJVguMtvLURXLHW4aiZur4QB3sEf6peo+tgBIY2?=
 =?us-ascii?Q?37fwEqMwxpvBWUhMBIh4rbbZz4ebRorXJGRrtjWHn9W6KX4ZzirR1dDF4UKo?=
 =?us-ascii?Q?Utg/VeuvCY5LmulArrt7APbIMUmEXko5muCAdiFyej4iU/lm74BujmlaACVJ?=
 =?us-ascii?Q?pkV+3FTBvh0iTrYMulDbKSfpR3I82WLCnkk53SF8SSvbhD9/YDRdjE9snaV1?=
 =?us-ascii?Q?ATYKie/jN1v6W1YfhxYWluHRKtdTCo4Mrmc07PFbDhhz7l+hhtCwnoJFAahc?=
 =?us-ascii?Q?tmZKrcEggA7zH/dHsJErNFiooMlYJeVgrbKdH1ojCC9pSz0iqSePCTT/6oe6?=
 =?us-ascii?Q?2fB/S6E1niKEwrmHuKUaNru6nmhuDEY6rD2TVeoApzELKi5itvSs7VCdRi5d?=
 =?us-ascii?Q?Y+dx7ETUhULEpdAZtpZG6HNdhI5dkB8xdIDy8cYgkLc8k6qFHGwxB/BkN2p9?=
 =?us-ascii?Q?CbwAY0qS4GrfqEdlCQ4Tpsuk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85924551-b2f9-4f1f-f719-08d951da9548
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 15:15:50.0522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8G6ivIboDwusK/HUpYrnAh1mdQ53vUHxLOCbDidH59sK+aZVTnHU3SsKJ9myIOTvLtKlWc8MrHHJadamovRg9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4750
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The commit 97f9ac3db6612 ("crypto: ccp - Add support for SEV-ES to the
PSP driver") added support to allocate Trusted Memory Region (TMR)
used during the SEV-ES firmware initialization. The TMR gets locked
during the firmware initialization and unlocked during the shutdown.
While the TMR is locked, access to it is disallowed.

Currently, the CCP driver does not shutdown the firmware during the
kexec reboot, leaving the TMR memory locked.

Register a callback to shutdown the SEV firmware on the kexec boot.

Fixes: 97f9ac3db6612 ("crypto: ccp - Add support for SEV-ES to the PSP driver")
Reported-by: Lucas Nussbaum <lucas.nussbaum@inria.fr>
Tested-by: Lucas Nussbaum <lucas.nussbaum@inria.fr>
Cc: <stable@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 49 +++++++++++++++++-------------------
 drivers/crypto/ccp/sp-pci.c  | 12 +++++++++
 2 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 91808402e0bf..2ecb0e1f65d8 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -300,6 +300,9 @@ static int __sev_platform_shutdown_locked(int *error)
 	struct sev_device *sev = psp_master->sev_data;
 	int ret;
 
+	if (sev->state == SEV_STATE_UNINIT)
+		return 0;
+
 	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
 	if (ret)
 		return ret;
@@ -1019,6 +1022,20 @@ int sev_dev_init(struct psp_device *psp)
 	return ret;
 }
 
+static void sev_firmware_shutdown(struct sev_device *sev)
+{
+	sev_platform_shutdown(NULL);
+
+	if (sev_es_tmr) {
+		/* The TMR area was encrypted, flush it from the cache */
+		wbinvd_on_all_cpus();
+
+		free_pages((unsigned long)sev_es_tmr,
+			   get_order(SEV_ES_TMR_SIZE));
+		sev_es_tmr = NULL;
+	}
+}
+
 void sev_dev_destroy(struct psp_device *psp)
 {
 	struct sev_device *sev = psp->sev_data;
@@ -1026,6 +1043,8 @@ void sev_dev_destroy(struct psp_device *psp)
 	if (!sev)
 		return;
 
+	sev_firmware_shutdown(sev);
+
 	if (sev->misc)
 		kref_put(&misc_dev->refcount, sev_exit);
 
@@ -1056,21 +1075,6 @@ void sev_pci_init(void)
 	if (sev_get_api_version())
 		goto err;
 
-	/*
-	 * If platform is not in UNINIT state then firmware upgrade and/or
-	 * platform INIT command will fail. These command require UNINIT state.
-	 *
-	 * In a normal boot we should never run into case where the firmware
-	 * is not in UNINIT state on boot. But in case of kexec boot, a reboot
-	 * may not go through a typical shutdown sequence and may leave the
-	 * firmware in INIT or WORKING state.
-	 */
-
-	if (sev->state != SEV_STATE_UNINIT) {
-		sev_platform_shutdown(NULL);
-		sev->state = SEV_STATE_UNINIT;
-	}
-
 	if (sev_version_greater_or_equal(0, 15) &&
 	    sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
@@ -1115,17 +1119,10 @@ void sev_pci_init(void)
 
 void sev_pci_exit(void)
 {
-	if (!psp_master->sev_data)
-		return;
-
-	sev_platform_shutdown(NULL);
+	struct sev_device *sev = psp_master->sev_data;
 
-	if (sev_es_tmr) {
-		/* The TMR area was encrypted, flush it from the cache */
-		wbinvd_on_all_cpus();
+	if (!sev)
+		return;
 
-		free_pages((unsigned long)sev_es_tmr,
-			   get_order(SEV_ES_TMR_SIZE));
-		sev_es_tmr = NULL;
-	}
+	sev_firmware_shutdown(sev);
 }
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 6fb6ba35f89d..9bcc1884c06a 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -241,6 +241,17 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
+static void sp_pci_shutdown(struct pci_dev *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct sp_device *sp = dev_get_drvdata(dev);
+
+	if (!sp)
+		return;
+
+	sp_destroy(sp);
+}
+
 static void sp_pci_remove(struct pci_dev *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -371,6 +382,7 @@ static struct pci_driver sp_pci_driver = {
 	.id_table = sp_pci_table,
 	.probe = sp_pci_probe,
 	.remove = sp_pci_remove,
+	.shutdown = sp_pci_shutdown,
 	.driver.pm = &sp_pci_pm_ops,
 };
 
-- 
2.17.1

