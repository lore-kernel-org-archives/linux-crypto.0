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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2CBC4332D
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D82C64FA0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354249AbhCDAHt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352989AbhCDACy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 19:02:54 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2061f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::61f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4098DC061756
        for <linux-crypto@vger.kernel.org>; Wed,  3 Mar 2021 15:11:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHELIum9YK8Avs3Eh7xIGmWXRXeAOxGfqR5adW94f1SSDwvGZy/ai2n9hhhLSq/9V89pNBCp2lMoN7yU64AeaVPlHMfXt2l4aRjO56meQrW/cPwB/Zik7fHT6bx+IU0jMkTFhqJZTjHfAx0QxaqG2nZy3zkk7MhoLp5sphWemrcP6XSc9jpmTPMxtM3RtdjxESSiUO3a315uu0e9y9WOKRhn96e13wVltW8t/12aotDyhdIp7JGE6uZuo9JbHDYxsF1Te95wNe+/+j8pGMX+llY1iRqWO4oUHRlll7ah0mpitKbHHi1/EeFrpEF5pQMDPW+iFuy/fe4ngGRa+iFwpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2R9rZO0rcRjtBxCKKH8XBtcYOWGegVd6s8RxCM5X2Us=;
 b=HTEdIycJ/8qc4Xkcv5cefPvCBIld8NTrr1NlHlm4Q2j1X8UqTerTXV3vcVqg2WbYfTfmnTJt0EztDTjsliXt6Wbcv6A/KWtym4vreWvYpbIK8LwZ8VBMrX+AaBAbMdlRpfYr83eB+08SKDRNcVZH3U1gaO4KtuZe72dXCFleecEMpVEbs5oqgw3LvVr+Z9CBv+w78P0r0iElEp+3q9jAce+wnLYfUwopXHds3sP27MtkQyhW0s7XT4uQaCqehqzlNODtgz1ffCWoQijwUXEEWQqYlzEwDWUEyftXa2HTsJ/GWeM32yHr11hkoSjyf+ZN6NN4AI16uF0MK2mjm98thA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2R9rZO0rcRjtBxCKKH8XBtcYOWGegVd6s8RxCM5X2Us=;
 b=0sYDkSc0sRi+E89t512BYFY1xAJYX5SPSGysLdyg8DriZH/JRaTr3NCF0/tyOJNyheYQ4E5T/ys/ks8P1jbKX/6v/7BWTNoNtwN4B8iX4Yb98ckC9lnddz9r7QH3jva9Oz5In2VSEtwWtV4Hedawn3Ccr9cfd9CN5Xk+driU7R0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0027.namprd12.prod.outlook.com (2603:10b6:4:59::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.28; Wed, 3 Mar 2021 22:31:21 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3912.017; Wed, 3 Mar 2021
 22:31:21 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        John Allen <john.allen@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] crypto: ccp - Don't initialize SEV support without the SEV feature
Date:   Wed,  3 Mar 2021 16:31:09 -0600
Message-Id: <c1ea9899e6169bf3a3042866e165a2f90bda3ebd.1614810669.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0601CA0022.namprd06.prod.outlook.com
 (2603:10b6:803:2f::32) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amdoffice.net (165.204.77.1) by SN4PR0601CA0022.namprd06.prod.outlook.com (2603:10b6:803:2f::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 22:31:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1e1df150-ab7a-4a94-f070-08d8de9411a4
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0027:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0027680047C733E289F2DD44EC989@DM5PR1201MB0027.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKFonX3xT19/D5Fft0E2E+CEThQ6wIAqOqOqe67QzMo3PdA7PUwhSaCwD4DqYSPEVRUr6XGRENZvbKIx1UgaZiWYnkmcszpOQ21MvvfOW3NmG2eH/ZIm88o5mqLtsTafucumNJXfMLmuIfqg/sU8ayiaCByrJLIjvzSMZ2fzYBhExVpKByG/1VidUcanCVURdpi0mE9X80XSXUV0m+GaMpQJxI+/OXrY1bZdX/A5XlZMYoIZIObYJJZc/HNflFSuLQcjgAAV1pHrIoINoy/9cacd1tvJH6HZeOqZ1uTj7BwctEcCDyaYCgMsUgP8bI3n49shLREYpNwR8EzXPn6xKnSr0csJC8K8+/huZ1KWiWJ+Hzs65nISIARU/BPUuRK0hX0p20D5SKCzP0m7Zv28IqNAISsu4VPCiDq5xqW5y6yfF2Ca4UtrSmiAdwPpoDH1oGa1deo4gp/XTOv0PTfiqWPN8QdojVj4LGXWHMkP/AFELPZNwziXzTBuGzskaq0I8Zejzenwwd+cZVwH55glwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(6506007)(26005)(36756003)(8676002)(16526019)(186003)(478600001)(6666004)(956004)(52116002)(66476007)(4326008)(2906002)(66946007)(8936002)(83380400001)(86362001)(5660300002)(66556008)(2616005)(54906003)(316002)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GqjgYUplNz1M1VxwekRbcjkhpNSJwald1vJctZ1OlxkNqGFOhOEpJpao/nxj?=
 =?us-ascii?Q?trCGzma0biAMHXlQiaES/TmcB1pHuja7Dbn6fbzhR6bBSv9LzIFsV/9Y+r0A?=
 =?us-ascii?Q?IobOoEqa+z+G158VsB91UIjo0pGT9LsUXojszosfPUMwle3+JPMz5QVtAvkO?=
 =?us-ascii?Q?JmhX8oka7hhYM8AagC9kLi6+pqxbNGEs8CT1uWi3/PplDJvUvWNf4p+Xf1rn?=
 =?us-ascii?Q?aPWw4QU/hqgTW7t00lfwhrUJHovTvK8bs0zWTxEXZ4q9KnCK1QDl4QWgTVn+?=
 =?us-ascii?Q?NlLcEa/rIlN/00OycaHu6FDG5xjJor0U9aVu0RT0+pFqISqs4Tm8MZ5U4OZJ?=
 =?us-ascii?Q?1MTByyDHi+m7qgUAK6/T6+neo7CQqRmFvDlYeNVK7tTd0X3G4c2/XORj3Tr5?=
 =?us-ascii?Q?2xdYOL022hQP9jELOsbKJzv6JQ60ihz+CpuJpEVRaqDM4q+mNB5+zG2P8L+n?=
 =?us-ascii?Q?eiNrCL6lf6MTEKgycHEPhl6y5vEeZiMhHLVQtYQ4xzFqY+Ge846flxxItMcg?=
 =?us-ascii?Q?xFurQ8d8IPdiWQZ1V5BQ9a5nPBEG3yvvt7psFHUfFrWkyhl+Bbx7MMAmMIAq?=
 =?us-ascii?Q?ce3MqeQCPF/84KSJVSorMIJwN6dlJ3GlyMDCc/2rdjSj+Mpx+xdRjIStjctf?=
 =?us-ascii?Q?l08vBaq6vx/Dv1bDDaIKc6HIol1cgEdAk64w/avmYdRrEVYiBL3wGPh5LCLE?=
 =?us-ascii?Q?Zdzmx/kaVgITCTGLggJPFUUXov616mUa+t/sLMZLtOkXXFB0KFCE+wNFpWrf?=
 =?us-ascii?Q?jGtdrpROu80BF7pIjQL1tY44G6jerIvm97P7JuVPqOKvZ6yEa6Q/TH69BRvK?=
 =?us-ascii?Q?9UBTQBcGwlipx7vaVU0Xd6Hgk1Z73TKxO5TzSp5DWAlyvsBstpTmS54JpNiI?=
 =?us-ascii?Q?kLJOcJUKusfv8q5wtt1Fzs1LDZbDbn+KjtkXgQgIYLmUfYXTDKwuMtOTuRj3?=
 =?us-ascii?Q?BmYkHdcR92ztI8bBl/YCsAl6CLsmCrRovv00OvHUfc6Bck63yb2uIDSS1JCi?=
 =?us-ascii?Q?k+OvWpReaaxNsn29fap4eAGZW8lpxEBjMv9IhxrYDXue7tSZogteP6gXu8Pv?=
 =?us-ascii?Q?sJwfhE+DiXs2kEoDFYrviy0C1iuqcpBmcpFIYFJ62gjEax6NqFWebUhRiLjL?=
 =?us-ascii?Q?RIZ7M1odmFsRwWx3o3xobMLSZ+w8VqWgngI/z/OZi5roz9wvZb4KvqR1eS7L?=
 =?us-ascii?Q?TlggcBTthaqFtytxaoe/YwK62tVw+SoYMTCLOgC+dRyS/GBrcA5fgZtmFRbM?=
 =?us-ascii?Q?mlMP0eYxnXfgAx4ZhsSW5KPYEzvaMqzYasTO4TlwbOSeKiSXIzn6BvKnMubW?=
 =?us-ascii?Q?ADi8qFJFQexX7mfhdACAU/53?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e1df150-ab7a-4a94-f070-08d8de9411a4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 22:31:20.9121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z6DO2S0aorVFYYY7Z9XUbPhPF7pV6/MO+SyoMgFUet7Ac9vWs2Gh3eEcx/CYA/YrApsrLtBcO9S4xuFKJaYmzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0027
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

If SEV has been disabled (e.g. through BIOS), the driver probe will still
issue SEV firmware commands. The SEV INIT firmware command will return an
error in this situation, but the error code is a general error code that
doesn't highlight the exact reason.

Add a check for X86_FEATURE_SEV in sev_dev_init() and emit a meaningful
message and skip attempting to initialize the SEV firmware if the feature
is not enabled. Since building the SEV code is dependent on X86_64, adding
the check won't cause any build problems.

Cc: John Allen <john.allen@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 476113e12489..b9fc8d7aca73 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -21,6 +21,7 @@
 #include <linux/ccp.h>
 #include <linux/firmware.h>
 #include <linux/gfp.h>
+#include <linux/cpufeature.h>
 
 #include <asm/smp.h>
 
@@ -971,6 +972,11 @@ int sev_dev_init(struct psp_device *psp)
 	struct sev_device *sev;
 	int ret = -ENOMEM;
 
+	if (!boot_cpu_has(X86_FEATURE_SEV)) {
+		dev_info_once(dev, "SEV: memory encryption not enabled by BIOS\n");
+		return 0;
+	}
+
 	sev = devm_kzalloc(dev, sizeof(*sev), GFP_KERNEL);
 	if (!sev)
 		goto e_err;
-- 
2.30.0

