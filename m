Return-Path: <SRS0=AlyN=2X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1639EC2D0C2
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jan 2020 19:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB2FD21655
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jan 2020 19:57:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="HOnW7l6J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgABT5X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 14:57:23 -0500
Received: from mail-dm6nam11on2058.outbound.protection.outlook.com ([40.107.223.58]:6085
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728260AbgABT5X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 14:57:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQ1wSDB7YKdPYo/qwGzgKEy7VIiFRhapuwk7O8Ysb0ncy5/gkfgbQqraMBuekp6tBYwd5IJ4U+TtwjgEC6bpjEvbc5f7KctmrlNUtndE9/vQlz8A6R/o0kR34xgfYNz+ksUVHy7L6WUDn9HDdCiz7LbDV9JT+zHyFc8yr7/jND9uKCHWMONchnabN5Odp52Z6R0zPHsiUYfouBpfE5KI+nDRPYgkwVGCmnTxUePhWGgslkFMSYc9uSmt6IzOwLFl+vMkP/BVx4gyh/sS0bFn9NiOrDLWfW8YgBwwI2R/EI166SNOKwzn9x99dkJL4VaorGW7MtRXPhMx3yamndKvZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfrI3q6OuFkGJUI2L/MWBwTiecaDUwy/Dtv4JzFStsI=;
 b=kR12vRNiCnwUEyEwDBtbH+AitCPCzmxr//GUKfDCyjwbPv73H3rWc8KnEBVgBPxvFcQ1czoqj0lNg0lobdrNJ6ZPjEME3lSePxFDw3Y9ubUgak44aUMQozLJcuCGu/P+7wLY52+muGLch04xXNWIVkRcqX2i7sT09zLLA75G3jrn+aMq+kk9RStGVsi+coJ6dl1b8cGjHzB/SpB0+BYeRGRqDScv748lqvKA661JKl5/ahMGvOrOY0kI1enhiKX6ehGCjwlsk0vUqqVTy9T33M1sexPqKcV0WeCHNzczwUI/3cdJ6gke9Fd+RIi3tapBGQKuLKudNFEPL4UzTjFj7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfrI3q6OuFkGJUI2L/MWBwTiecaDUwy/Dtv4JzFStsI=;
 b=HOnW7l6JolI0rsxpV6MiVW3XzhKI7S8OZBRxCuiQEhEN40egvZOraQJtpAOatEDfk+I+QhNzSaj14vf6MFeocXfGQGppChFc4SiYqsso1ZZMrgXa67zQpddbKC3EDedMBRwHkMinHQsHzo341YzzjpIOaxnzvND4IdGaGxQjduk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from BN8PR12MB2916.namprd12.prod.outlook.com (20.179.66.155) by
 BN8PR12MB2964.namprd12.prod.outlook.com (20.178.210.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Thu, 2 Jan 2020 19:57:19 +0000
Received: from BN8PR12MB2916.namprd12.prod.outlook.com
 ([fe80::45d0:ec5c:7480:8029]) by BN8PR12MB2916.namprd12.prod.outlook.com
 ([fe80::45d0:ec5c:7480:8029%5]) with mapi id 15.20.2581.007; Thu, 2 Jan 2020
 19:57:19 +0000
From:   Gary R Hook <gary.hook@amd.com>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        thomas.lendacky@amd.com, Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Update MAINTAINERS for CCP driver
Date:   Thu,  2 Jan 2020 13:57:03 -0600
Message-Id: <20200102195703.7841-1-gary.hook@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0701CA0021.namprd07.prod.outlook.com
 (2603:10b6:803:28::31) To BN8PR12MB2916.namprd12.prod.outlook.com
 (2603:10b6:408:6a::27)
MIME-Version: 1.0
Received: from taos.amd.com (165.204.77.1) by SN4PR0701CA0021.namprd07.prod.outlook.com (2603:10b6:803:28::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend Transport; Thu, 2 Jan 2020 19:57:18 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 246f34fd-e8ab-41c0-052e-08d78fbdf950
X-MS-TrafficTypeDiagnostic: BN8PR12MB2964:|BN8PR12MB2964:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB2964D8FEEBB6385D44C727ABFD200@BN8PR12MB2964.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-Forefront-PRVS: 0270ED2845
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(396003)(136003)(366004)(376002)(346002)(199004)(189003)(16526019)(7696005)(8676002)(36756003)(6666004)(81166006)(81156014)(66476007)(186003)(2906002)(86362001)(26005)(66556008)(66946007)(52116002)(956004)(8936002)(2616005)(6486002)(6916009)(4326008)(5660300002)(316002)(4744005)(478600001)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR12MB2964;H:BN8PR12MB2916.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4E+DcKMoF5XEupS9sZ3CH+eCTFbH+oimPULeYygPa7JOaCdHG/wF4/z99GgwOhc+KQf7LLn3LD6FD0guAyKPQNutf43ghfiauM9m1o7SY5uoxYtcTfojT1ROceyLaGCHp7v3ha+6r39T14CsWNLx92ghM5R9nCzn4h3+g6WhCEmo6CKcFHvikkRZUfwq3Vj2jcSaRA12usXT6MVOXCs35KgaEJhNTNVwP64sDrUshwbxJelAeqQ052haqBcoL+uFKc+K8Opr7Wah8dfOXkg1VKvB9uVfkGcBfzlHedB9DeA9Nhp3AwG7QAybIUy/LqaQHkJFViskGGKmb03dM0UPIjw1xD6+3xU1M85SV0aAaN3/KRs/RB51az15UabSxaEeihta8zrdbL3JqRLRWAd87vFi3BOuxwejBQySWzo9MXbLOg0OFLKoJBrG2HcYALwY
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 246f34fd-e8ab-41c0-052e-08d78fbdf950
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2020 19:57:19.4694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: spKE9kQWxpNp8ldtn+1WlCahWCRgUFH4+iJgUQ/b9ABDaLiLNVXALtEhFuizXvB/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2964
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Gary R Hook <gary.hook@amd.com>

Remove Gary R Hook as CCP maintainer.
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fecbfc35897c..a0c161895e18 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -789,7 +789,6 @@ F:	include/uapi/rdma/efa-abi.h
 
 AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER
 M:	Tom Lendacky <thomas.lendacky@amd.com>
-M:	Gary Hook <gary.hook@amd.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	drivers/crypto/ccp/
-- 
2.17.1

