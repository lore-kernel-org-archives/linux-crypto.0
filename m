Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A99CC433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 08:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0991865287
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 08:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCIIM1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 03:12:27 -0500
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:5550
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229480AbhCIILt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 03:11:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ivz1iX4xyH/7yXOnl773/sgkIePGTImLHiqpC2FAeFrM1ieq+YmrUwwRL/dMgCG6NGqqhKMT9LEOuQslViPsf9GhVS6i360LVfbO6kBq6p9GSPUL66a442Wv8WX5zmbpoA/6r0c9EeRLzMM3OmIorP6kT9uEueOnwsps1ewgownr9jEr0Pp7jbwTxPBZp8Kuyf8riOI4uuFtTTO7xOb77DEs5ZnGshWMsivGwG0bp31nlloMfip7i45ys8b+0IRbdORfyyLJ21A+UZVwPMc8nDFP6mKb37Ro2PGddSIYahwxBRKUuh/I6tdV1XXS76PCskxJdfr+SEPt0ZpK7ATPaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQGvOkESHeegcylNM+DfLV/WmquY+oXdUmvZKBiVEbc=;
 b=niJk+HcSkLVbx7anoNf1dm3CmnL437RoC+kpUIkNFSsj6gO7GTWa2SeTU+vlpUPTTZkdAYeL1sJJjA4cG5w/zfj36fUF+ZnwFzvy4GvDpXbnQcwXlrVzYFd8ig+DxfErITJkYej8qDUJxoPtrpPZitzLY2gJbv6VSh7m9osGvcm+ZwbbiDvqXMCOEeRBgAQIURO3rzfeN/uCDemGpzus088lFtOym9i0AaiqVRxgEeneXQV3LkIfsagDazurDMupHCKEt5pnEaf12S2LndXzdpo29/YRieBKCrJnr1MbBUGv11NCCVNjg2nknWZPZWH0dRVeNjkh5pX0f+mPshFYaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQGvOkESHeegcylNM+DfLV/WmquY+oXdUmvZKBiVEbc=;
 b=3UvP0FG9YCE74MN5c0YRBJltrtN6pPoAcMxs/Ug6t++sPPyxui+o1+3/pAT4jdbQQyvKUIBrB2hiux01Khj0V3lnsuh6ROuPr5fwJkAKUNH0gv5ZETu2Jt6OZ+oy+8CXLyvHi005FiS6MPN2kur8ow6Naou4VKXbRC4U8dlAb4k=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SA0PR12MB4397.namprd12.prod.outlook.com (2603:10b6:806:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Tue, 9 Mar
 2021 08:11:45 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03%3]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 08:11:45 +0000
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
Subject: [PATCH 0/3] PSP TEE driver update and bug fixes
Date:   Tue,  9 Mar 2021 13:41:10 +0530
Message-Id: <cover.1615276206.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MA1PR0101CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::30) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from andbang6.amd.com (165.204.156.251) by MA1PR0101CA0068.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:11:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c1209ffc-2aab-48eb-9984-08d8e2d2faa4
X-MS-TrafficTypeDiagnostic: SA0PR12MB4397:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4397C7CEC01BA44B85BB44ADCF929@SA0PR12MB4397.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: piRcKQf1/ClWV3Wn7Y9aBzrspLdUyaJVj75AMe1CEpkAstmF5L4bd3JR9BZKbCjzLISynvOeB7j1sX2n2gOoxfSCgf0XhCyvewZsRHG8OpB3mWecELzqDIWNhju5KcpNimJPkmizP1IZsCO25++QM8TWUjHWAoeKFedLm8ePlRaPRO0fgW2v+Omb5wH6/UTYw02tEePiwBv2XRuBPwANDcgyuKUqPV/f04Qo/SZ/cPn2KKVLBMVwwo/hW6DMGF8Udv+Ri08jxpFHiM3xmUJi8P8DDnsaKNNKbDSIugonYszFGZqeMp8/tBk+0PeUFtsXuxjbuySkUYdSlORsr2ZtE5c4XU+AHxbg2D2BEs6D9sVnRyiUtMyzlJvowSpZNrEoBb+TpJEwEKWNxLSOGFLXl9f/t4xqaKouid9B4aNbnv3sLTR8ZLTe7eJLKqn4guIKtm6sm6gOjvCv+sHkk5kmt8a8AyTP2LkWnLxgfYjESHhZxFBvVKRFMyCI2fZmbTa9foNMqWwTDdB9zkEErQU/TA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(66476007)(15650500001)(8936002)(5660300002)(4326008)(66556008)(2616005)(956004)(316002)(54906003)(26005)(2906002)(6666004)(8676002)(110136005)(6486002)(83380400001)(66946007)(36756003)(4744005)(86362001)(186003)(478600001)(16526019)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8cbh95Lo9wg3VEk3brtGyOFFszowtmZ3ZnAUXPkPZST42eJNpDTu15OhZxys?=
 =?us-ascii?Q?uqNsFT0w04iDLZlsxo5tpaElhln9MA9Fs51TbugMSfaGBLOw6eb1UngUXibf?=
 =?us-ascii?Q?6/eZpW8WPgBHBElTn54s+EIxuD4MXWrknFKEc7vpMMfZuLASWSK8Dug4HBdm?=
 =?us-ascii?Q?eJsvvPTCb+ciN19506rRtLAxSdpdxnkrCRFJ0fEalCpoxKuFrEJ91aDI7E2j?=
 =?us-ascii?Q?a4afFwyi8TUKgzHdkUgjyD+xBjZpCALgLexO9ETOlXtxSZ7cU7Hwg3RY2a+9?=
 =?us-ascii?Q?Ap1mJYWsWbzw4IMisBlV2a/YdO56rjAbTwMQnh6NOJlcgrzpWFYYnx5tIMou?=
 =?us-ascii?Q?8wreuuFiSSq2FnLnb9iTrL6tWwONWinCBPcsA94o8m1YQAUfVP2SEvoyYnSY?=
 =?us-ascii?Q?vIU8Au/qtZkCFp85U6B69w0fANl9ydluB+912QUPEPdUokCVAakOkD8spedj?=
 =?us-ascii?Q?wPTM6Gfk53w5DbjxarwoQ26S5RFPHd2TLFY3xRc1k/GhvFbUwbCasQ/yk7TN?=
 =?us-ascii?Q?xnT4Iq9vjBVwJl44oHFaz4rvOxICSYTa86wbYpZw/YSk3RdmhflalHMB0JuR?=
 =?us-ascii?Q?0JyXXu7ln6G0OeukmHC8XJlHDojaBDHC0uGrxetVUglvl7c4STyVxBJFOSN1?=
 =?us-ascii?Q?PBqoL2lj6NQPmwCciz3lvruw8tcWMDEmgfePnBwyVi3PowQxJbxhl2nKFD7n?=
 =?us-ascii?Q?FNiaLkJhBbI+QuIsM+5yAXCyuKoV1hpKyGxeJtNVjBMBbGvvJPq4+9CjEEm8?=
 =?us-ascii?Q?A22t8MaFJ22PHKcGenTJvOiRbTlUxfJ+LxH/HPDiybCYAEw5lSeTi7gWplWb?=
 =?us-ascii?Q?MSsttYvv63+jkxiCBRzU171/At0MIAVvT08XTQdckrtDYgVt8abd69uqzcwn?=
 =?us-ascii?Q?9FivFk3jLnGuzWqMuIz15kV4jCAw6u3wC2KPH2dDpJiTWFPWhzX6FaJDC7p4?=
 =?us-ascii?Q?oByh3eVs0k+m7Z9sMyittroQG0nG7fzHdQeJN3WlY7MpJPlkj2j1G07RQXc9?=
 =?us-ascii?Q?XZqy2Tpou4IHsB1s3YZk1/pdPHupBAr8wOl0iG/lSIny8UQ4zNDjdvHk+gLu?=
 =?us-ascii?Q?xQ0y2Ao68DiV2lnZM74tzVdW8NB4Zsib0WWs8c4cBZzHgjel7mJec2Ws8AQt?=
 =?us-ascii?Q?WQT1Rvoo1Oi9gj3NaoT/gRpyvOZsuphQeXHJBwZzxDr8a6Epig3amZVfYux6?=
 =?us-ascii?Q?lYZttTdRzIL4eCtuBtvRJuoGn9+wbGyErRE12rXo3VtlYqgccVkoAvO+2o5Y?=
 =?us-ascii?Q?3ckJLPouAUKr4ipcDQ80jew0NxR2kterIHVby5Mqy2VJu7ubzpNXmvuGnTJL?=
 =?us-ascii?Q?lgT4Sjr6zy3sboKwHmq1Qhu8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1209ffc-2aab-48eb-9984-08d8e2d2faa4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:11:45.5182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFI+a7pUyA2a7VWQ4K9IkIPyI7VvFxhZ1DeN6FqUHIuGKX0Z5AQ45XQBYKiXZNTuV1IygEYa+ZmmCxB1IwM3rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4397
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The first patch helps to improve the response time by reducing the
polling time of the tee command status variable.

Second patch is a bug fix to handle multi-threaded use-case.
During testing, race condition was seen due to missing synchronisation
in writes to the TEE ring buffer. This patch helps to resolve that.

Third patch is to update the copyright year for the tee driver files.

Rijo Thomas (3):
  crypto: ccp - reduce tee command status polling interval from 5ms to
    1ms
  crypto: ccp - fix command queuing to TEE ring buffer
  crypto: ccp - update copyright year for tee

 drivers/crypto/ccp/tee-dev.c | 57 ++++++++++++++++++++++++------------
 drivers/crypto/ccp/tee-dev.h | 20 +++++++++++--
 2 files changed, 57 insertions(+), 20 deletions(-)

-- 
2.17.1

