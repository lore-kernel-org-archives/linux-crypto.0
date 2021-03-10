Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A08AC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 04:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42A6464F7D
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 04:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhCJEkw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 23:40:52 -0500
Received: from mail-dm6nam08on2077.outbound.protection.outlook.com ([40.107.102.77]:20320
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232182AbhCJEkb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 23:40:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIbD1rrSMO/Ei1AIs/S5Nnd8r8KibD/T07s8TYauwxfU5ctnyMIkM0a1/SjOVQ/OC8UqyZvSC1yYilAWdTkaEo8CVhOVnJSq8H1Mxy2AT9OKdMtVQzwfnGpU9LAiMH/ApP6sKYJI+NXtEcs3IkUo6yPrv6G7AKPDkQmmtasojMHr4vbZGbM7EPilzxIWKlGK6NkChUxlT1JF8Mf9U6fd7sRNSm+YzFoOUPAfah4tZs/DyUhzRrCeUw45acuiVA2tg5K/zqSuGDpLnCGdTmDC5MQtHiPhJvMiSCq55HtfhOkqmybQ2A51prqjffCN4YCeOjcktxW0zFeqvOfvAhy58Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XO5m8Iu0mndhKLuTxDNEJan8BjlhLIXzSC/DioPdrWk=;
 b=IW/aBw2uWnKbCH4HIhGM1sIjCU9NWOj5Boz6uPNTxoWcNxxjKsVKrnIqTxVFfTzZHhSaqVVCPjEHIwGxwonTwek8zsUQV38eJGLJazpvAiOGIoslkqCdArsnaxmoYOwavhDpo3avaXfrbHboiYZ7cL2lqSYUE2DlMW3XrQ8+UNe1U4r8/ZuWw4+te0nPw6IFfXkGqza4ceaUpnKozUa39G9uILZfAmi21ohf+d3f683v8gU6Nl8UtsOcvbEN3lTuhjIOtro5As6lHrl9wxdoOArpKWJMObsHUWWDamE0QK8T6+lYGh4i9aSreW+kcXxCh6U2abBK+xPacu2yisOsyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XO5m8Iu0mndhKLuTxDNEJan8BjlhLIXzSC/DioPdrWk=;
 b=ZFdn9rxeR2DmCYIeZg1e94sk9dXtw+X48jTkafmnueTHPdhBKK1DZBgmZdTrg/f4LsQ2SdhVvJQuOTzN10+Vge7dLa2x8u5tIoTbUiPu/qjcXa2toQb7r44W2uLxnzex2WvZghhUKanH7kpc2obROtlJ6RDRtCGerVMj5N7kn+I=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SN6PR12MB2846.namprd12.prod.outlook.com (2603:10b6:805:70::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Wed, 10 Mar
 2021 04:40:29 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03%3]) with mapi id 15.20.3912.030; Wed, 10 Mar 2021
 04:40:29 +0000
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
Subject: [PATCH v2 0/2] PSP TEE driver update and bug fixes
Date:   Wed, 10 Mar 2021 10:09:59 +0530
Message-Id: <cover.1615350846.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MA1PR0101CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::19) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from andbang6.amd.com (165.204.156.251) by MA1PR0101CA0009.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 04:40:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ef94e220-db09-4900-29ed-08d8e37ea18a
X-MS-TrafficTypeDiagnostic: SN6PR12MB2846:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB28462C7B9A69AD842BC8899FCF919@SN6PR12MB2846.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jpKXp5OtfviP/59tSQiHgglTho/IcWC0nqiQKeVscFJt+Vm/FOU/RdwPxe8lFeUjC0NVog/50gfGxOCM3eB7nKMOV/Oq0NVuizrWwkyWMrGYFX1BS4opJ/7ynz02dhHmSfMFV0MbjfZMM2/h6njxhzPiunBnSs/kzYQqvgQVAZZD+JUloMcj2Gez/IT6E5/KKEUSUQ6cTM+gxMFCeR7H6XcdH3zBWV61R2mHAIqO5vMIhCtGocziSA899dnVbaJirJ5yGTOaN6lX5c534bT2OzxQwmtYAnnN91gHoeVqWxoGifuM/u6enHImoVa43gDhDlolK6lYkYxu35SFVz/HtURuFjZW8P/oYuzJueN0u+dnW1ZRFTnBYd8nV2jGOyfLtsJSi8PxhdqjttmOZYBLDxsBHKWTeBSQFDMlmV1+lkTePDJQS2aelKbgvJbZ+mOhbB2bc9MFjW9ATVyzx9+uTbFyfsSJYtNFvmsp9qm0MFNgM08NC59K2Mf3/Soaekb4266R2vM/Gb6nDfyTNUFH8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(956004)(316002)(2616005)(66556008)(15650500001)(6486002)(6666004)(66476007)(2906002)(86362001)(36756003)(8936002)(66946007)(8676002)(83380400001)(52116002)(7696005)(26005)(4326008)(16526019)(110136005)(54906003)(478600001)(186003)(5660300002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+kbrXpOIqBFFV7k8qnV0JUAT6G8qbhpceORSqjefB+v4UVeWwoLq8B3ZfD9O?=
 =?us-ascii?Q?ERXnSsH5rprlpeCx/89uhC9FWN3R+G2bt09bGobv6VWsH6PmU1dCkP4iTXUY?=
 =?us-ascii?Q?ty1Tg5srMYEDb7q2g+WIas9JakW31NzkNsq4sJ6ncLQ0XKXVcNJWMPjqezcC?=
 =?us-ascii?Q?4jtWFPexJaRM6AUHIMbo3+c7kdjiiIGMCK83RO+eQE+MyvDayblO8rjyNM+u?=
 =?us-ascii?Q?zlocrjbscbHymDIqB1i0QexLeR6LDeF91pL3BzLo2G908323agyULTqTxO9o?=
 =?us-ascii?Q?NUvyI+IAW2jfRBtFmIWiBfy+jHwbmf5RbULrESrT7wM9Uud/bjr8ocy7iIxF?=
 =?us-ascii?Q?GaSks4eoiaKVrmaeWiAIQqkRldbktVHeAcm2Fb0jp1EyQFzvwvHKeANcGJou?=
 =?us-ascii?Q?no7wyNZOwjSfL3mSWY2+LFaAC5bM+Hwh4QrGRPegopPT6eWP63zDgj5I45TR?=
 =?us-ascii?Q?Y9kyVgtVqbSvHbDla0LGGMzBKz8CDpsgADvew+aKSSz3OnoEx5ePVgVQ7gBS?=
 =?us-ascii?Q?W9vR3JuZx+ttPZeZlx5LxM/9d3MxLey80JOUs5rhlCUSmu0ok5NYIItxtI8s?=
 =?us-ascii?Q?qHdq8HWvmb6SMmvNmKxSgOQBChY0RkjGOT+VNstjNaRl3VpdZlRCgfTFnVm/?=
 =?us-ascii?Q?ZtK+vC+gGpj5JaB1ZAtj/SFkkiiSeE7ipdUSeTtGG+50fo4K5eKls6aJekDe?=
 =?us-ascii?Q?uHFS39GVmzi7jNTW3D5o4v8kxIDrTP/T5ZkFNUdCk+qipwayfd5+GU31cBR+?=
 =?us-ascii?Q?UvO2qJ5hACAmDPV7EMjcAzmNlRkpxQa5fVBE6WN6d6n2G6tWflDVUhVDWOMb?=
 =?us-ascii?Q?nExJvXhROsyjb7skuZG3HwGX+5LL+NvgV7wa+A2UWfojp1xjKx+3adIc0JBs?=
 =?us-ascii?Q?BTSxKDF/r5xazRy4pq8gpsG8QVC0z1nhEjvphS0AOvF/G0tPPMRUN33a8JoI?=
 =?us-ascii?Q?Y0N2rO4IRWf9HdKxHSFHZCrd/b3TKCxqAqo/Vi0ZaLr5QrtiC71NWPIY21sS?=
 =?us-ascii?Q?FTL4dgZotDACcLwLBsgXpOaymgy/97UrpHm0lNa3QRHGeduyrOcaqQ/Uz60s?=
 =?us-ascii?Q?uwMqJT3HG1wTlmxTTbeug1nVHg5lYpDy6IO/eERP+9cySRnWQfI0+VutOtNj?=
 =?us-ascii?Q?1NHyeH5jkz/KSfNlaHhhIq1MrPmj2/RgyQeDRlZZgDT4as5RRj6S0oUFYznW?=
 =?us-ascii?Q?uojmHJxW+0E8XLr2LKIfqg/TwUzuhRXe/0Q0QieehF8K+1BmI230Hcbd92Y8?=
 =?us-ascii?Q?KSF2N4QwF4a1EFWlZd4b6qZm3pqHLivpOdQprQEge0oFPZQ5heJ76Hz1gp0y?=
 =?us-ascii?Q?xx4LRCqyNhlmV8/u2pJDdiJVGWQNViM8LT718b5EVwk0Pg=3D=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef94e220-db09-4900-29ed-08d8e37ea18a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 04:40:29.2423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9jrtfDmmVCS02Q0EPZxzoWdqvnrMRe2AWBkdMLazpoH07xWY0Cv3l6nj8pN9VrUrlMecR6TlSiAF/Ovw+VYUmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2846
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The first patch helps to improve the response time by reducing the
polling time of the tee command status variable.

Second patch is a bug fix to handle multi-threaded use-case.
During testing, race condition was seen due to missing synchronisation
in writes to the TEE ring buffer. This patch helps to resolve that.

v2:
 * Updated copyright year as a part of code change

Rijo Thomas (2):
  crypto: ccp - reduce tee command status polling interval from 5ms to
    1ms
  crypto: ccp - fix command queuing to TEE ring buffer

 drivers/crypto/ccp/tee-dev.c | 57 ++++++++++++++++++++++++------------
 drivers/crypto/ccp/tee-dev.h | 20 +++++++++++--
 2 files changed, 57 insertions(+), 20 deletions(-)

-- 
2.17.1

