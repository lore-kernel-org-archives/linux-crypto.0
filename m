Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD85AC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 08:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79BA565287
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 08:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhCIIM3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 03:12:29 -0500
Received: from mail-co1nam11on2079.outbound.protection.outlook.com ([40.107.220.79]:58721
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229520AbhCIIL6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 03:11:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWQgTBwq5Iy9cFv8kgApy5j6qcvT6soJyEKEKYl8Pu8xiC5RioKlV2G8vbzoq/Ob1g9dwrxcuXUSfuOesVfFmR7YLu+Iy74PgFiQ16eKlR/yz8hawC0QF2HqDJO9nPnfyt9nRL5LdADfS88Hr3Zlr4IBe4Nu9ef0UYX0oR+MydU7x1nHZKjUrUmzj18KHeALxT7MUC18REO97yxVuhOFiZbhRMHa1dCd5WKcdi9Xa65OhyeuLOEBC7p/YUtQgiRwmmoh5Ow62NYcobfKnQbFGmXvwMtmyF+w4qmdEW9L+lVAykWFeGSVlqkaodYw1o2nQPI4mlvXCq5vltI7LU6geg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQOwS+A8HdLAiWTerKUibK80WJRzhUKlIjF0VAdpRv8=;
 b=bOTsf0TU5kiWAoMLVb8gFUHtX8r8CoRSL0tVPl773HFTUPj6I/WlfWYcn8Pw2zktwdBh872kKrClt0sQlAbcp6LldbpPWdQ2vmTCiLNElJMsPor8C50Hoy0xCtnk49+Pu1Jrj/yV6Yj5QL/dtJU/WbVwwgo66Y6i9BG32PTfLRwpJPkprM5CdcfaZLyP9Ynu4Rpu3OHYzTLBkLNKrA4s2C78unNhX4IH3EobA8CpPeVRwv8P4w/FT3qUnZN3c7h76I2UTHL+MVZsqiIejthSGNWGgUHsylrPTJdT29gO3WQy4MaMOLRlEme0O7V1gaSeFG/8WhNlCX4cwOihqy369A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQOwS+A8HdLAiWTerKUibK80WJRzhUKlIjF0VAdpRv8=;
 b=MEkMnsINmq996spC4rX5/o++Yg6C/2FPn2n81vwkzAGohgjpxiz+ACG8hjIemCSNlepeBqu3LaCxkJqtBM8gdN2RQI9M3WgFQVXypi16rhzVTxRulI8jCGV4hygpJDY5vuo+CAJv011VhteBF9c0iohtNw2SFped/p6ZZZtIZAI=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SA0PR12MB4397.namprd12.prod.outlook.com (2603:10b6:806:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Tue, 9 Mar
 2021 08:11:57 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03%3]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 08:11:57 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Mythri Pandeshwara krishna <mythri.pandeshwarakrishna@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/3] crypto: ccp - update copyright year for tee
Date:   Tue,  9 Mar 2021 13:41:13 +0530
Message-Id: <a87bc3ff11249e0cfa891a80a65cda555be723be.1615276206.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1615276206.git.Rijo-john.Thomas@amd.com>
References: <cover.1615276206.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MA1PR0101CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::30) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from andbang6.amd.com (165.204.156.251) by MA1PR0101CA0068.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:11:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0ee93f39-4239-4a97-3c44-08d8e2d301d0
X-MS-TrafficTypeDiagnostic: SA0PR12MB4397:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4397E492BDAD221BEAB82C74CF929@SA0PR12MB4397.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UbolDd2ABQRQywyPJmExj3yWIuW3sfEIF5CyvxAoklp88g3QqEigV7NvUGzlKP16ersf3KyD0211zwYZHoU5wtYO4kBhZztj5mfsjhxaOp9jCnXQ3VVo/ZQC8HoTJ71K6sRIzyQbMYcr7cxdS4Wr39qB3FhYZGG7sOBQkbaLTPGqSOtf8K/AGO0QVVPKhzGIBgc0BYwYfyCS8JqJjaC9/SKaGCtjwJqwzvvDj98PNoueggaOJ1qgz+Lf/t61WoKQsCb/gsKUlkM4/AAh2RGPG3tLTm+wFr38IYVi4jxdlP3zhYK1PtKy9bJgO4i8xz8n8nZuCFnKe3QEhdA9iO9i9MiNZFlgr9Z1JYQwP6H2VvIBPZnwpzXrH7+3Ud6xrjTAbGYoyPMUPCUkFo0toCdo7ZGeNvVYHUHa0H08A5VW0bh1btUZ5u7wWT12IivDCNG1X7WUA/eaczwXFKzgjFnuiKnMjGD+FD29oUVfza19CbMkvT1K+eMvftWEJjthszvRv5VjNLhaTCgfsY6DM/Ij+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(66476007)(15650500001)(8936002)(5660300002)(4326008)(66556008)(2616005)(956004)(316002)(54906003)(26005)(2906002)(6666004)(8676002)(110136005)(6486002)(83380400001)(66946007)(36756003)(86362001)(186003)(478600001)(16526019)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5NeWXrz5EccJUMw+F/ASYNPWmeTecoknCKs6GtyH9ptCEafHOHgzM53jAS/w?=
 =?us-ascii?Q?eFPjGzvTMHs7/cHr1Pc2v5NGHhmVU7hCxk9UyDq8kyIrr20+CbkmD7RUxDM/?=
 =?us-ascii?Q?W2xZjNXi7TP6UJvUCCRXghHnTn17d7yXuZKi8QgMmr3ht5BW1P+tVtnzlIPH?=
 =?us-ascii?Q?sz7kjAch43+QUoJAoqZlUnJRFBBddomYY+V16JnZ7gwI8inwIecG4OyvPbQS?=
 =?us-ascii?Q?BUlKe4TBvr8qwnMpU9Sic/LbBJjkjSjh0dvrj+RYMHbfHqijr7UBo+PxkLV3?=
 =?us-ascii?Q?98JMNPVt93zvjEjEmk5LqCW/WiDQ1K0J5e2OQ5WwVTPHDTHU5nfsO4cj7nrn?=
 =?us-ascii?Q?K/24vFY7oSZkO8ShYGPWWgskf6iJeXlL1kVLyE8ygSsAfX2BQ0PjIJvGn6Fi?=
 =?us-ascii?Q?VGm8h5B6PxgCyeLVc/ypusKdSZU8sMPWtE6m7v8eH7cEVbpJN5MHfNJ9NXke?=
 =?us-ascii?Q?Vh1ApJQEZhE28awPJl5z5MjxOHfMc+KDcEr0TgSYjUo2pmzdOPhGcNHVZNwD?=
 =?us-ascii?Q?fo8wPPSpCBa5w1zqpNESg4UajIZjdEYGkQ/fLLoOuFrMYn6uxuyK6kFEl4NF?=
 =?us-ascii?Q?ipwk+8fUVAK/cdRsCG+MTQ8UHgMvmhqVkPbZFOd4e7pI/zQjtRaVbMZRz+Bz?=
 =?us-ascii?Q?Ks5g1ES799kF8dDJ9jjUKE6f0T3tPr/RmLLbXXfavH7xec7CI3v2TfuJtEji?=
 =?us-ascii?Q?CV4eV6pB+Wsj2XF3uGXgNIIGdwXtGivYZavAA5unIOg7v6ud3aJfPUc34HcO?=
 =?us-ascii?Q?aEKoTUj6t5lz1uTqKSsiPSXCC7PRaOQUteHAqCs/C7kQj3tTeYoe1tegp7Os?=
 =?us-ascii?Q?kzTE5RsKVwhQjZl//xeETrkCb/KizTh7S9F5nOdCNxxvg0fFua35BikLyUPR?=
 =?us-ascii?Q?tLoFPJSKXfhbv3/bZH5lO2MUmRCHNrroqA+NM6iLLS/wDMQYDFAspeTvOR/K?=
 =?us-ascii?Q?/mnh0JarLzv7AJBt4lGMd8BOuWnLXe4rnrgU1ANSzhXJudxvPC9cu9DvljnH?=
 =?us-ascii?Q?PI6wZeMNtC93ZmM5y4zg4N6kPZ/aSw69nwZrrI+5F5fJhtQW3NeziHZRSmcV?=
 =?us-ascii?Q?2UxK+1h1uJS+odiFBtI4vyTXRfCMcv28isKKTuSD3fwYmp57q5UfCvTHe08a?=
 =?us-ascii?Q?9JvMmw7973XEIVQcso2Y1JMmQfjATBXGHN91dm8p2b7qvfztAt1FK0SpgqK4?=
 =?us-ascii?Q?8VW57IprDFNS7OYG4ebxXU+L3hyd/z6DCA64njXScerdfEgSvETHgawAhS2I?=
 =?us-ascii?Q?WGdSOBzJQ7JI2izITPQFLWzDoIMK6P0VMK7siKYCqqr69arYpMU/b180PCpy?=
 =?us-ascii?Q?uY/HFa0D7uaqT9/0m+iijqxj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee93f39-4239-4a97-3c44-08d8e2d301d0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:11:57.3823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VghX3DT+kYp53/xZQ10OcQmlCjnSzKQJaO9Rav2vpVofHQxNS4lOrWiuq5emrr+YHiTxxavuh8h199mz53159A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4397
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update the copyright year for PSP TEE driver files.

Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/crypto/ccp/tee-dev.c | 2 +-
 drivers/crypto/ccp/tee-dev.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 1aa264815028..8cade4775115 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -5,7 +5,7 @@
  * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
  * Author: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
  *
- * Copyright 2019 Advanced Micro Devices, Inc.
+ * Copyright (C) 2019,2021 Advanced Micro Devices, Inc.
  */
 
 #include <linux/types.h>
diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
index dbeb7d289acb..49d26158b71e 100644
--- a/drivers/crypto/ccp/tee-dev.h
+++ b/drivers/crypto/ccp/tee-dev.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: MIT */
 /*
- * Copyright 2019 Advanced Micro Devices, Inc.
+ * Copyright (C) 2019,2021 Advanced Micro Devices, Inc.
  *
  * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
  * Author: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
-- 
2.17.1

