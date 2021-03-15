Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918F7C4332B
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Mar 2021 08:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64FBA64E98
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Mar 2021 08:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhCOI0F (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Mar 2021 04:26:05 -0400
Received: from mail-mw2nam10on2064.outbound.protection.outlook.com ([40.107.94.64]:59873
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229828AbhCOIZ5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Mar 2021 04:25:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AF+/AFIzRXH6eir6pWLUkgu+yVKoVlkwBkiTwBz6AkVs1GDppkDtkDSULwALaj3mBDT1sbYJSYpQZ/I6g7sXc5fntPgM5KthbwoeeNMNztXPGYjkeIsuUQfMr1BmQAIebLxLFG0p+F3JAdGmIJEsRCZjfgXaQ1yXwe8CG2/l6oVOQFW+7Cjc0dvXKgLcG4a66TDMyshX9ODZpJHIUFCdyvEUSEIajsahMXnBpZVeybbOGrDUgdXrZDOKB7HYMKMnoC9eJ8I8sgbzZQW4t5g1UlsAebU4yioM3NgvzQ9o1JmtiF5f2xmeW519QZgPtGmIvSiQnxzZ2AigA55P+vrqcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ry24HoLGyAxZXhGENAa1e+s5VCDHSB/6/dMzajuA/Hs=;
 b=HY50GPAyiu203ywXZVTQBR7t9jkWKjf4BDVYyLUlSscFB12LrchcFLA3E/sGmjlSLKEQ8qK26TIl33Fn3qm0JOm6smWpvaafVz5+D9ltDT8wvmmqkjKeNzt2tTq0oyOEriZshqkUqvZTtqkM8wnvmLy+nMsK792wWVajGNBC+w8LIQBwUga0nA2JlY7tKOOR1mCfjnlMz0FOrxq2UBu85rz6q833dn5cuaxxtMBQsEPwZu8jaAJ5Mxf1oTZUIwfL97zIuMBQzPkL+TctcezoL5mfDag4aov3zfPxRF1jglNUIctPQm3AKidGuce5nQvZO3WQg5BYk7r7t2ZwY68oVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ry24HoLGyAxZXhGENAa1e+s5VCDHSB/6/dMzajuA/Hs=;
 b=vRn1Yfc7kFplXCItY+UX5AyGRNxNxxrubtBWtTNbXDBXFDshwEbgVAcMBTis1q/TjorDvg2Xoxf7JBi/SWnqxxIzeu0cMCaHKOIdVc9K9oVlY1OiT7pZTg3NcBrk8AKGjsppFm7HvX+/UuptMjVq5+FyLzQBpT1tcjCrwQyvXkQ=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SA0PR12MB4368.namprd12.prod.outlook.com (2603:10b6:806:9f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 08:25:56 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03%3]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 08:25:55 +0000
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
Subject: [PATCH v3 0/2] PSP TEE driver update and bug fixes
Date:   Mon, 15 Mar 2021 13:55:27 +0530
Message-Id: <cover.1615796554.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::19) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from andbang6.amd.com (165.204.156.251) by MAXPR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 08:25:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15a946b8-82c7-45b1-2cd6-08d8e78bf3fe
X-MS-TrafficTypeDiagnostic: SA0PR12MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4368EF9325D649C78FF41F07CF6C9@SA0PR12MB4368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tMib75H3wLTwPMUEo/iyu4dxPmKynXZz0A9db/7HF2uwpPpJ0Hzs96TjHfuhUROOAfcn/tpPsHBSMA3IXy6GIf/RvcbNSxgMmPi+vEd24XpMeRFbNR3ZTp5fvc+B73Mg44h4GEfIeQS322HaL0Vt4xGCrAY4WhYOJo8kOPlRwhlS02A8a8V7TNdNgnpiRlkPLKjJd+0so90Y6m2dbbbnMHciIyiUoWSrHUl2hLdJu/Uhz3WTvHaQVz56ylgrqSoBNFgz7/wHSDmN/jv2Z9vBBuhM6QLrisrbFpVKxTeqyZk9QTmfFgzd6TLMDN61CgQtz5jNBRdXl3BnE2p8inQa8v1eHGRNcEimXOJu0MqqLpwseD8+yenXlIY4pKRvT686OXOJ5/0Jhhl+5AhrRjhFq6zbYl/1oFUoh7OtBRPHMuaEVrReF+GAImPN3sW3EigQdOwqclHyLoJCbMckyUE6RYLDG1jGgIjh39r3SDo0meKsbYPYm/9tCcgNwu2LdjMsAU7IS3DwaadeOS92BqHdP6XGhX7Zeqj01EbNSvFjo2OSGvvGssno7XjeruoGv+bv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(36756003)(52116002)(8676002)(4326008)(7696005)(83380400001)(2906002)(478600001)(8936002)(54906003)(15650500001)(86362001)(6486002)(26005)(110136005)(186003)(5660300002)(66556008)(66476007)(6666004)(316002)(956004)(16526019)(66946007)(2616005)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cQgvnYHUg0RokQlt+jDqW8Al9s1cS+WgYemoFgAT2GZVp14ejyH1cwwskhEJ?=
 =?us-ascii?Q?AkxojM+Fe6shU6PtgV2RnxYKuBbKblRsBBYmxNsobfo24SoEeO2LNxgyvIJI?=
 =?us-ascii?Q?BHWk2xlJl8mfC8qLWuOtRrO7Hv7X7q4LcrReWMuvqiGinpUpB+xYyCqiWRsA?=
 =?us-ascii?Q?F2pgmSiBei3+DAlsx83kIQzJHAgYH9YGx5AN7ETkuiTYuU0kVICpM76BT8BC?=
 =?us-ascii?Q?srS4APKQK9NABJHO2Cgd91GKVB6vxF0rNJwrkiimaMPQqd9ogc7o/uWNyyXh?=
 =?us-ascii?Q?hv4zt6phdcR4VJY3Iwg/MAR1kajzJT/f8wBNvRKf3YXLPW/rQ4Gh55McE/Cx?=
 =?us-ascii?Q?oJ7L1xeM88tszPWLY78wXGZCpxivRbJMKYw9ZgMz8uwYFupEC52BpJatqDkt?=
 =?us-ascii?Q?ZvUvc/L2is3yLsj0MmHXFSD/EJU6Ik+u58aa01TC2FaQtc1T/X+M6L5WxwQS?=
 =?us-ascii?Q?Rbl8JSgnNvLPVbYj1Knlqlhji9Jn6JVE218X3augRhQ+FjJ91Cd14bhIvJ2u?=
 =?us-ascii?Q?9FSMVRN4cXGb9Dmpq+tFQN6st1ng6s9lFQrG/MyZ6ifD04O0AA7W2mW5ZEmA?=
 =?us-ascii?Q?vGqcqboHFJLGVDjytRLBwLjJ0VSB0NzuvjNN2n+TzXQ4mYktVZeSNl8JF5bZ?=
 =?us-ascii?Q?juYZuq5yDEyWvsaLVNGLDMMezcDYtF0HQpQx/Owh19xbJInVCxmOhCQQ7DMz?=
 =?us-ascii?Q?zhv6Pcpk+Y5zF/KXLUGrb04TLe+Ksy71nzOyttxWiVrbtyQDSQoWD61NHPbt?=
 =?us-ascii?Q?xYI04DyYN8xD+YJV/oAKl0BBBMGa+/6k/gaxkZtk5BFaD80dJxkHCiDQajsT?=
 =?us-ascii?Q?223IsoZ5Xv0FRi9FcM1fjoisgOvnS6eqk9so8yEu+JMb9i3ldCd7Z28RMPcg?=
 =?us-ascii?Q?ILX5dxpXiDNckjhYS04v4p8uN46x7x1Qf4EeW83s28dl1C1J8FBnf7TAl6Fj?=
 =?us-ascii?Q?jvSxwJim9FvVT4jLkn0tG02yW5BFYL6KZO4LrF5P38GSNhJ8iF5pllwtpTCY?=
 =?us-ascii?Q?JuofMMpnwdTPH0S2ag2Msxe19S7tFnpc7olq9fQf8zewInmAQLcPl2dUIJxX?=
 =?us-ascii?Q?0Gtnihs9XzIM7epmrYlREYWuax4ZgAi97pbBhHjpkG4j+IwkVKovUvUxNAf9?=
 =?us-ascii?Q?HTa0vgRTThrZFS/kC0vgnPpz0sTCp5ZYzMqbMTdwM5qf5Os0PSIPifLRxxlG?=
 =?us-ascii?Q?0VjsHOmo9wulI1OZE87YaV/YbEe2DjYfuUMjl1d8UZEkHfvOxK3dA1D17rUE?=
 =?us-ascii?Q?pMXiOiukWroQHv+Yj9kcZDU62utd6kuT1o0o5Uz5CZcviN7kN/mzuRzX9TLe?=
 =?us-ascii?Q?a8BgdLr+kWAkzkyodYq4l/Qn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15a946b8-82c7-45b1-2cd6-08d8e78bf3fe
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 08:25:55.7494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vaf2TrSkR2/7XShDVMhkDV8LXAAMwjI0YxsPFH3r3bvLEgicxirhkn41gkaFiqWp4Xhib6uvIEM3jwhHKRKSiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4368
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The first patch helps to improve the response time by reducing the
polling time of the tee command status variable.

Second patch is a bug fix to handle multi-threaded use-case.
During testing, race condition was seen due to missing synchronisation
in writes to the TEE ring buffer. This patch helps to resolve that.

v3:
 * Fixed checkpatch.pl warning

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

