Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C3AC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 19:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C48D2053B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 19:00:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="NncnRHoR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgFZTAi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 15:00:38 -0400
Received: from mail-dm6nam11on2078.outbound.protection.outlook.com ([40.107.223.78]:34913
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725768AbgFZTAi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 15:00:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOiji3QZx9IaCsBhfez67maP0khl+fql/NlXbAYb2hbqCmGML37UUBK9LqiYfbL9qrb3YpOCLuId0IC40tYITAxkI6ifXeWkW3PJmkYYk2J3J56vtVzF3T19lAlp281zeEqruZg08HKWzAVMvd5MoFiaiFhKIEGjBxhdXGS/r61NxC3WwARDMZh1ILvf2sr4061Bg8CVmPSXLCypFUTKvJ+0UlfLb2IXxHbpwyRC2Vd61YQJpt4p6Yr7qssrYQxxhBTASZ93wzsJ6CdU9Tf/wxAhKAIoRwjWxnBSMApPHJZV2UaIeNX2eS7QSkZTBoMCrY4PxgjV2TluhDl4VMhULQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZd4qOgqFfPFh886Hz9FIcWDPG7i5kJik6Ww/d5pXL0=;
 b=mvWhrkM20t+VOOa1Byj8tlTPpfDZG/6Bjr9yL9FVzWd3vL9reXDSv8E3VaGznvHAifaXXnlnQZSYQ0zGW3nwpgGJcA2bZn3gX5txzVtJ8aNc1ETruTaHAFpIEjyahJ3CSvdn97wSGX9kP8DdZCuDMLeI3I9e2jGXw5BFbs88v756uX8tkveNbyRkqDzNhGGUyW1S++PEBMRcFuDSDv6JXrbJOPQhcvbcqDxoUx43WYffFytjCETbDJ7Q+IBoXNkXD6wZ8R61YDmBHAnj2AcJf2WL2ZkmZqDP24utfItdI5e+0SmnLcg/2ySl6PMXjn7pt8fx0BfHN2WwhAThGaiooQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZd4qOgqFfPFh886Hz9FIcWDPG7i5kJik6Ww/d5pXL0=;
 b=NncnRHoRYoyTPR40BZCxjuE67HmEpAmjQiN5FzWfwzxtB92BEs2umei3TSVcmaqAFZ+bVnwWiCkjSnrnruPbkVrHjOVUDUDSMJBwsOcoS4sPjPp1BdzYgM/yOC5n43vILynu8P5vraU2ea8grhNZfs6vZah3O+N+h5Ry6zhl48w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1302.namprd12.prod.outlook.com (2603:10b6:903:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Fri, 26 Jun
 2020 19:00:32 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::135:b45b:bf4c:e3]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::135:b45b:bf4c:e3%10]) with mapi id 15.20.3131.025; Fri, 26 Jun 2020
 19:00:32 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        John Allen <john.allen@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] crypto: ccp - Update CCP driver maintainer information
Date:   Fri, 26 Jun 2020 14:00:17 -0500
Message-Id: <10d21bb66593de4ab9b07bd4fa053b5cbe2d9278.1593198017.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.27.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR11CA0013.namprd11.prod.outlook.com
 (2603:10b6:5:190::26) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR11CA0013.namprd11.prod.outlook.com (2603:10b6:5:190::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Fri, 26 Jun 2020 19:00:31 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fc45b24c-730c-40f0-2dbf-08d81a033320
X-MS-TrafficTypeDiagnostic: CY4PR12MB1302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1302F3B5BD9DEFCCA02FC8C7EC930@CY4PR12MB1302.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FScbUCbkvLC2UO1WgxGN+lX4OfCBK2KjYqfqGMbFxxGmLffPJ/bfVB/aIeQQJw1oc2Nu4RQbXkj3CKsRLpV0pmUFnlvkS1BXLbsIqM+A5ufWLqGR8++8VEw2ExzOTrnTPrpEunaPvQvJZwkcVckBCNNtHwb7qxPgf3afDihR77gcZaPMYtm1v0DtHk/j9RnPseNGmXjD/O14SWIbKYtezOtnglb518+ON0seG7TotrPjkl0wVRVnxX5Yro794+p0eAa9dselYyENcJm9PzWgBt85YxKaT0JsGPzVH+x05NQTsRBjhcv0pUlVwwkGKruhWepzzDa5DqRuPjMGiy/QS+hiWch9Fjzl1Y0POwcEYGnA/lTd5bBI2jDjdcglkokb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(2616005)(956004)(5660300002)(66946007)(66556008)(66476007)(8676002)(6666004)(52116002)(7696005)(316002)(4326008)(16526019)(54906003)(36756003)(478600001)(6486002)(186003)(8936002)(2906002)(86362001)(26005)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rie2l6QE4y2D41zHODhQAzantBecRnR7DoG4ze8m++fc985hNybNiNxS5NO1cRg6JiiNRK2zJafg5kmHpMGP67TjUInnOkklfuJTKNe36pWt4YQpwjrU/3J3RSbjnFwxX5ntbkeOMFcpWXFW7B/MvwIO499tOIQJmFdf9NE0+dXrTWTQMuO4rODI1EoB102a2dyVWklDIKd1zrXpZ5t7gctxmaiUHROmuc/OO1nZj0blfwdJvZeNMF95t+rwbcntjnDFwewOaM9mTpCKCzeeE5R3AolOdYSOfMblNbBUz2W0aaRZUT/aX0f0e4u9nedT/ZOndTZKcPm57xCxEHVQOOH2NHtlVl3F3rEYSL6wMj0zrr9qb3xrO0cMMkbmN3A2FcYyIe1Fqj/SJLRO4s3BziqkKamzi0SiJa+8v2Yr07MtisZfTigAB42dUFNGHpwiyTngT7ksYVaYOqGWMLk/QhPG6x46l8SVI/BGNVB2IQo=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc45b24c-730c-40f0-2dbf-08d81a033320
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 19:00:32.0215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rv2xBwT4J03rEz505rbKqYUnxaEADqNBXkb5VZ2ENbdu9Ce4aQLfO5qhIvscf/3LqcxTdQDP7mep46gnH8VgQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1302
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add John Allen as a new CCP driver maintainer. Additionally, break out
the driver SEV support and create a new maintainer entry, with Brijesh
Singh and Tom Lendacky as maintainers.

Cc: John Allen <john.allen@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 68f21d46614c..8af94aea20fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -830,11 +830,20 @@ F:	include/uapi/rdma/efa-abi.h
 
 AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER
 M:	Tom Lendacky <thomas.lendacky@amd.com>
+M:	John Allen <john.allen@amd.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	drivers/crypto/ccp/
 F:	include/linux/ccp.h
 
+AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SEV SUPPORT
+M:	Brijesh Singh <brijeshkumar.singh@amd.com>
+M:	Tom Lendacky <thomas.lendacky@amd.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	drivers/crypto/ccp/sev*
+F:	include/uapi/linux/psp-sev.h
+
 AMD DISPLAY CORE
 M:	Harry Wentland <harry.wentland@amd.com>
 M:	Leo Li <sunpeng.li@amd.com>
-- 
2.27.0

