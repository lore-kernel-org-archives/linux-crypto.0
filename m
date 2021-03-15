Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DAD5C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Mar 2021 08:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26C4564EAE
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Mar 2021 08:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhCOI0F (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Mar 2021 04:26:05 -0400
Received: from mail-mw2nam10on2043.outbound.protection.outlook.com ([40.107.94.43]:54657
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230204AbhCOI0A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Mar 2021 04:26:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQeB2pAQmgcYMr4pRV/2W/ouO19popcRbeVlBxP9bT5leeR0oNTB37WQBCOlEXfXsvQecws/bZ0HzdPj2JZYN4UcUwBtolDEFkrKPCOc3EjGEAbvG0+Vw2Vb9sMVcHHGHTgnWvPkuOu0T/3DF7KJmmtnAAQMpOwHR+PHrKgF4YBnZ8ObyhTvyCy2cTq9YSptM0icGzCuB5xRRiuWOVDLA/hV0at22svXr0zCHa+5nxDc4nN7qfZEQ5Hw/WKVDHeIWgIJDKPKZVhxsMYeB5XHDCPtCHZQie346Y6ZTrW2r2Mglpt2NUceg9ShYnj7T3dLBEQbd+GlRb4QE7uidpQERQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPl6QTO809v7FQVSPOpW9fte9x6JzqJXKza9Z5Va3Z0=;
 b=VsIUZP2G13Cw4tlYPfhWr7MI1vFezmlp+aLxwhWVmOSMgowROMLSaUupAm508ZBDnSLI12GswemnLRTM2kXfwVVHHWEnlE8Y3ltZs3SjymqeX5/qaFqiAWoNuZhTP8q9njWtHqQk8GSzwwh/wwNhn8niv5NQGVxj4Ylxpamh1K4jipRlk70tHdkeQyXtknSRRRq96Xw0bRkHZY4dTsTkAUqlX9YU6jMnH53v8/Oiud/dp+h3I9zdqfQ6UtxghYkRUuKFSaT2vBvIbaeZlyeCl+yo2LVKbit4JzDTzhgUmYBkIYZm41Ns0pmaE+kag5NzSrWwC62tFGLuRrMcM+JKGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPl6QTO809v7FQVSPOpW9fte9x6JzqJXKza9Z5Va3Z0=;
 b=Bye5e05QTKtkCWkI/GPi+jig9HOWd/qGWaicZBSr7t5+0W6CT+3eQlaKrYzMikq0KnHaOK3jVbH0wHy3ZaRIz949KOwNpW5vUKHt9pcZNI26qMRj0Cuom48Mm5w7acX06Nynw1amt/j0nABbkOKHn8eBv4tc0dXQAhpVOepHGdw=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SA0PR12MB4368.namprd12.prod.outlook.com (2603:10b6:806:9f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 08:25:59 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03%3]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 08:25:59 +0000
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
Subject: [PATCH v3 1/2] crypto: ccp - reduce tee command status polling interval from 5ms to 1ms
Date:   Mon, 15 Mar 2021 13:55:28 +0530
Message-Id: <b3eab0d35de1d20a71f7d3aa2b450adfb84cdfd7.1615796554.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1615796554.git.Rijo-john.Thomas@amd.com>
References: <cover.1615796554.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::19) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from andbang6.amd.com (165.204.156.251) by MAXPR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 08:25:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7a0fc304-d6e0-44f4-2917-08d8e78bf650
X-MS-TrafficTypeDiagnostic: SA0PR12MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4368DC13F252794D5FD51784CF6C9@SA0PR12MB4368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tSLADfoUoKLGX4V32uQcOglNEg8pIXb+gPWDFQHYH/LG/KComoiP6B2+o/Qum4kqt2RW6W5ToBTxv2Bjw4STVINCTpu+YcAC8XMLbCOdv+L2zAGG5pqvNiGJFoLHWeg+G5eKMxc0bJ6cSjtJjeUMRD67NvNndUowwUN/K+LaQmH+G3+OAMgQzvvuX6gVF8c3u/rtgP46R+QTZCuASBfBVy1TdWdILeW5PrDHmTazqGGuwc0dd5KaAQ4yuwTiQKKYSIfCF6y0YtwaWaH53Kab73En4JfFtOTqXPCRPoymoFemyBoy9I1UOkAl1ZPV8cPHInFiaVjea/LwqxZPBRIabgvrx63UilqNpE9hHqpDNlVOyKlffmLCnGpJFW86yJr62I2CzyesGQcK8UXjOJsAAzXWD2JH5CH3EE/jx3V8qFzh2wKV+LtcYcsPYPIKhyONH48ArHfA8Qej3aoe6RbhaFOecB7NGxnlr/gf1TAKYRfIXpo7sELfyCPW/NRdogUDwRldE42aXed09g8Ti0OPIRhkmG6p3Zj+zXcU/jJQZKE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(36756003)(52116002)(8676002)(4326008)(7696005)(83380400001)(2906002)(478600001)(8936002)(54906003)(86362001)(6486002)(26005)(110136005)(186003)(5660300002)(66556008)(66476007)(6666004)(316002)(956004)(16526019)(66946007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rSXke6Kp7nSsWm96lgj2MSU/MS5lBTJ9Xu2MzXGiPxljyMun9DgiETALr6t+?=
 =?us-ascii?Q?zYG5wnLsOHbggf+zYwKKRCCPbtqKpBtUBnJjDRN7AgmR3DuSoN521+ugCkui?=
 =?us-ascii?Q?SmXSmXkejTWfTSxM28mf+rYINAFJYIzE6eUQOLEc6AzcoqJD6pTaQh/zRysr?=
 =?us-ascii?Q?eOogLZyJ7Blg2wIxSKWeQmYvNib3hJbOHYUMwPprkTffM5vCM5TYp//Q984Z?=
 =?us-ascii?Q?Eb0qyZoxi7caFv1sxSaJ26riVcGtV+NkONCBRaxruDFhA9iJGvKqJd6Oc5nd?=
 =?us-ascii?Q?J86gEYQVmi9X9XsFk13u8yCBKIY53Bc9tEpG8eHEqVuoKDsboMGReCIxdIa9?=
 =?us-ascii?Q?e5xxkB2ds0vs0wvlyyyt6oV+lyb17Ugn3eV7xNRqA9FbS6ObmMmk/zlwm4Z9?=
 =?us-ascii?Q?nPnrYeesYVlx9cH5WZpzRChszF+eHTRIUc3Q4eA8e4fMTlETcG5V0OQN1qOi?=
 =?us-ascii?Q?2A+KidOTdJ/Ii9EySo4h4GiDopgbN7u26WjXHGKnmHpw/eiJKOBRywmKM/nk?=
 =?us-ascii?Q?MO8BlfeQik5J3PaANhtcdWOlN7S5+L0K1v/183jW4fZIhD/t7l40JUmnnp6A?=
 =?us-ascii?Q?lM8PLZ7e+9hLFJFYL6MGYO1ppKCxEn+KLmOwEwmVKBzea1exVTgAbATCQAIf?=
 =?us-ascii?Q?tX5CDvV6nen8V2OYz1Pwr7UcFLMYUdG8sdyY6HByfYqn5tSVl46yEJoBWWXq?=
 =?us-ascii?Q?PHXoLSVW6eWNK/vDrdTh9o+ieFUwLRG57LXodSSHs4kOzfNNhhX3cr6kx5fA?=
 =?us-ascii?Q?+0Ps5AuYu6gdC06qnunISnHY+Hyn+r3HnO/eDiHVPkd5Q7Ydac2uHd8KDX8L?=
 =?us-ascii?Q?YuxMT/u5rq3nl+fze4wEZEqOXwwC1b/68Y6dyHKTKuii5z6+kU5YuSmzyOcv?=
 =?us-ascii?Q?CuLWhj+yAz6udbjjhYBblBkTJ4TiVsFZzkSiOzT1+lc/4eC7EFbxIQUFjt0u?=
 =?us-ascii?Q?nTCSCzOr0C3yQz0VSLpB6CnhxxaxBPb+wDwf4BIT8IUq2RwIJ7jr7AYO67wu?=
 =?us-ascii?Q?NosFtU59VZZeAMy98Lf9L5FiPZfbJbCY2kffLzCmd2syPRSU2NbPEDsR4NCR?=
 =?us-ascii?Q?P4lTmEhruKTKECp+2cxe2CBpjYZs4b+uahdyviXxGXt/ktkiyWiB+8YFLTpe?=
 =?us-ascii?Q?eAtL5nPXBwiMFzQtlgG74v2OwHoZmBsvFyLhqL90rXu1e9aeNNXb9SkI2H4Y?=
 =?us-ascii?Q?FToHDGji5j8kd6p2cv4CnD47j8PUgrxiITISfb9Yh9jbkmHrxKteCZTBnzij?=
 =?us-ascii?Q?jC/qaW0lE+uChHh8iZpaBI+9Diq1/Q1fFRCtpPRktnEwUWjUfVJ04vzCr4Wm?=
 =?us-ascii?Q?N6TXYPuuSWnx9ha7yWZUK6D4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a0fc304-d6e0-44f4-2917-08d8e78bf650
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 08:25:59.3533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hM2pISbl4Q4mCaAS1XdCRcqbG8qDTYG5Ba9gQ0jfVGLD4f+Eo11Sy7VPCvDJPVrCTtImUZn3zhMsGjy9VHDb9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4368
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The PSP TEE device driver polls the command status variable every
5ms to check for command completion. Reduce this time to 1ms so that
there is an improvement in driver response time to clients which submit
TEE commands.

Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/crypto/ccp/tee-dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 5e697a90ea7f..910b71df2aef 100644
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
@@ -309,14 +309,14 @@ static int tee_wait_cmd_completion(struct psp_tee_device *tee,
 				   struct tee_ring_cmd *resp,
 				   unsigned int timeout)
 {
-	/* ~5ms sleep per loop => nloop = timeout * 200 */
-	int nloop = timeout * 200;
+	/* ~1ms sleep per loop => nloop = timeout * 1000 */
+	int nloop = timeout * 1000;
 
 	while (--nloop) {
 		if (resp->cmd_state == TEE_CMD_STATE_COMPLETED)
 			return 0;
 
-		usleep_range(5000, 5100);
+		usleep_range(1000, 1100);
 	}
 
 	dev_err(tee->dev, "tee: command 0x%x timed out, disabling PSP\n",
-- 
2.17.1

