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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CCFC433E9
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 04:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 532F564FEF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 04:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhCJEkx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 23:40:53 -0500
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:26721
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232191AbhCJEke (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 23:40:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cimfSXlQvyEaQ9yc98dq2MB1mRgzCZ3twCFyjii9yAfRGEM3glscSknd7XZAwnqbn4IqfcpovxDQiKWjdZHEEQAf83EjFh5uLSosA0+S5YTjoOWw0fh8SRMrOnDUl57IpIrvRM0NlEvg9rRdMsdBIgoT4Yu2eYT5N2OynXVrUDnA+7OMyxlVWNdLJ8w+iOeu6cZpxnJQ2017WsNM/etHZcsUuyrG8/XL04qhWcTjJ3O1v9EEmFYSv9MeTVXpYa6y9+3h9p1J04KIUHJCNzyP6vFBHB1FZSLe+43m0WD0FJYTCf8DQzxPaqcCMW6CJkmwBgUktEJLG7vo5Hh0H/pXZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPl6QTO809v7FQVSPOpW9fte9x6JzqJXKza9Z5Va3Z0=;
 b=EhWAFohj/ZsTiZbAzz0I5u1nwvY21c6qX4ABYy+URBnS0XM+6bOM0SffQPweXJGmr82m6wiJWIveOuQDRkbAKYM/H6xPGLuc/cQf2atNG2ilRVOfWWPIYMtBTcDn3X06/BwynwUwPQkEoEtdudSxVd0beF01uzSjuFaFyvSvB/1IB1CijsLWv8x8y6coFtjvhmXUBjy26MYJLogyWXcxuaCwqTz1cU+loe7U5mB8Gk318VGkP6KYI5q+TQtU4071Y+YS/Aq1Gg6QWxh//1kgmwcapDExXSHRpdMIbmgNRpdqbCz37lcZh9NIoHUm7NZxxudQv/xBtiuFObXvQR6eUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPl6QTO809v7FQVSPOpW9fte9x6JzqJXKza9Z5Va3Z0=;
 b=BSnLY6a2dfwe39fX0vYiSCSfyzxfA52LQoaXRehkax3L+Au147EEP3VGi0HODqZofxgg9Yb8/6Uq7e7yhS1nyKwFb9BnxfKlXAIVQfVjJQlIybI4IHQBOpo+cggqjb4q1mdqSiD7nbpRm5p/q9kOUlpLLjMJcvy8Fco7ETNmFpQ=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SN6PR12MB2846.namprd12.prod.outlook.com (2603:10b6:805:70::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Wed, 10 Mar
 2021 04:40:32 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03%3]) with mapi id 15.20.3912.030; Wed, 10 Mar 2021
 04:40:32 +0000
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
Subject: [PATCH v2 1/2] crypto: ccp - reduce tee command status polling interval from 5ms to 1ms
Date:   Wed, 10 Mar 2021 10:10:00 +0530
Message-Id: <b3eab0d35de1d20a71f7d3aa2b450adfb84cdfd7.1615350846.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1615350846.git.Rijo-john.Thomas@amd.com>
References: <cover.1615350846.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MA1PR0101CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::19) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from andbang6.amd.com (165.204.156.251) by MA1PR0101CA0009.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 04:40:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 083078e2-405e-44d7-d464-08d8e37ea3d4
X-MS-TrafficTypeDiagnostic: SN6PR12MB2846:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2846C46256813735A7C4DE82CF919@SN6PR12MB2846.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IgK8xjXWEh/epaoSvqHtvCUK5f94NIpILZ9LoePqKM+/HJxXN9uMr+Y2icWEv3bTkzLrZ7jFpLXc3SCGPu50dXTQhFff3aB/2hvziVI78Yihk2hx4Y1aDn0G+4SA6/fdwOWfQSq/zRvJMxDf10hYgGTYggDzmYK/n7uVegaZ3RpzO7hAT+pRFEcg5gzUna9V3eEnIcHdpk4qJm3Rw4c1FuMGP7iNHdm04U5a2mcMsCY5WyClqqUcXETfQZZHBUJQLBTPkaQEZRghpcprMnT0pirp6ITfAdkMcmSauMJS6PoNU230D2Rj/kVGmYV7Vmk4+PYJDYNAmTDWG5WfTAHSDhHRZHBypI5fbVRbCEd3ZC2qv7B+t9pGQtcLfCAfAdAIaFgDdNmf4oldeY6NSxBCRuMozIN1OIWyu3TWWckdsyX1wWjB8OyXoLPWoz/F37NovPepwev5BYcU/QReCU5IpX/5khmwcdDUeV599jXTd8coqoUCgNGfey/dM6mx6mZXFgTLL1faszgilwr+AEctGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(956004)(316002)(2616005)(66556008)(6486002)(6666004)(66476007)(2906002)(86362001)(36756003)(8936002)(66946007)(8676002)(83380400001)(52116002)(7696005)(26005)(4326008)(16526019)(110136005)(54906003)(478600001)(186003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?A4iGhDK3aUuho1fpGgAQWSDDz2Vl/3X4mmMYA2GGKrOfkvK8QtNe07ttv6Bx?=
 =?us-ascii?Q?/kpMUUvXUcN0e2nhU3891XtiKZ3ZsC9qy+6EmpTlxZ5G7jCgGck6S1rW8BaO?=
 =?us-ascii?Q?wmm029CPcU8Ru6JJPYIaO370k/yYB7UBuFKywuxcw1FVbmI5Yfs4L7PS07aj?=
 =?us-ascii?Q?dc045b+iHEetfewfPCGjnS7CSPuTSFqfFyJdOz0yofhGl4i0rmzMXi7CK7on?=
 =?us-ascii?Q?GFd0tKNl+l1YJxDJPdJXI1YAZjEK7eDMnYv8Fwwp1OYfctRkxd5giZnlT/gz?=
 =?us-ascii?Q?yg4hcn47WhKCscGtRm9H7aI70rpfyvXSht/56JOm7XOJwk3HqRJ01/SvHnD3?=
 =?us-ascii?Q?fNgizVyLikkBRd8u7cTvEgBFoSenFmcry8it2DIvCSKoguD9I2saiH2DcPyR?=
 =?us-ascii?Q?xYhBYl5x29LRSy6TbDLaGt5z49GLpiNBT8q/ycusIquYWBuHlL+JKVWgYQKY?=
 =?us-ascii?Q?hRM7A7FMl7oE7ozYKsc4GUfK8OGTAN7/tb8Xv2laLUGn6SYY4nDh+1+Uo2uO?=
 =?us-ascii?Q?/chxLi5TMZ4UvIqLqS6FivCH0za575coI5+M6vbp5P1jKhLFHxyDppwcp345?=
 =?us-ascii?Q?nIC+3JPN9CosGKC30HKfb2enwMKzwzT7vqHIM6DFetZ7XYR65uOWDqjDUbjh?=
 =?us-ascii?Q?LVSF0P18noQpO9bGcSGk+i2Z2FjOkVPF+Ypj3pms1TgcccL8limUiq2MzCP3?=
 =?us-ascii?Q?d3dNbkyTOCGActNEajDLkdrjqCtqYmdXMqWXPw1VT1G6StjxSaend/P+QXlB?=
 =?us-ascii?Q?izOVHw6H084KCEKC0WZRdaolem6dDVYEWei3JI8ZRN2iE7pUGHFD5ADr3mTP?=
 =?us-ascii?Q?TDoOudYVhTZRIzmfOs78AbcKObmg3zaLN1/qX4d3OH2pk8w+xmLpNT67u3ms?=
 =?us-ascii?Q?oGSHW45zZsQU0Z5/Sy9x98NSrc2RlMMZkgsaswNdounI+A8X5jUq2nPF9rKv?=
 =?us-ascii?Q?ta+w/CCBorzTUwvEQf/q0d5nOTNXSw5FivVzbTLP2H8Pto4WhSnwgr11uuqo?=
 =?us-ascii?Q?kpQFcDEYXstlUXotmrSmS+Nhy68sWo51lcEv2XoSwTZuoZ9xr2KRnUU06tOY?=
 =?us-ascii?Q?QLUYtFfjog242silebgDCckK0TweGKphGMahuzbBYZ9hWlERTgp1c92foBcY?=
 =?us-ascii?Q?YVVxiJfFQusuLs6M1i6CixRnjD5YPtD1KwDBgySb2K0TkXHZFFem8fxMw1Gf?=
 =?us-ascii?Q?gA30TNC1b83W1hGSeMoPfM8h131Dhqa2JnS82kxOyRmPkBnMEkQfK08N9NvJ?=
 =?us-ascii?Q?dNDxtx0M0j4ptLIpWeC6ZpVh89IBQUd+OhAoXGvGLgQXvRMeN/QwmpfV2ihs?=
 =?us-ascii?Q?msQitbDtltOTSur8qTrqiQMB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 083078e2-405e-44d7-d464-08d8e37ea3d4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 04:40:32.8003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0V3aCswgAIWsun2lKYNjT9rVQqw3ZeVGq/JMtF2wAxdkB1nUh32DMRpoX2IgCGrq9YraFhhbiKy2CVqO3fmfpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2846
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

