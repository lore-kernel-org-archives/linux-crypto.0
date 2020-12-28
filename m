Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC4EC433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Dec 2020 15:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CDC82245C
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Dec 2020 15:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437025AbgL1PYC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Dec 2020 10:24:02 -0500
Received: from mail-bn7nam10on2059.outbound.protection.outlook.com ([40.107.92.59]:47364
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437391AbgL1PYB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Dec 2020 10:24:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZPd2dko1NKgI0nu9kKMfwuNYYcnR2HavodTNWJ+DczvCdQO8NM7yxHYcMx5f5lRAHRnsiepV9FskAV3rFHQ75VzsU9silFPvwTFYUSJOTapmVGu16yPVjRxqu9hSH/8XvsZOsFiZ+WckT2wTNfpOlYRSoew9zFXNWTrm65Rrwq0gtYEpfBoQQNYjfcj7HEv04P2gq3GVRw63epmnyla84NB8bAJFXUUeTz5mEG0mysGUQci/qVirB8SnIr9hXRnKpsNK+XeLxVR71WJ4ft/b2HycKGbDzRnmDOekVFiIDcrYiMGqLXaU935Jzy08vKEqMpl5teLnvz5MeBHZBb4Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxD9dnK1puo6RN4hlOQA78bDPfymYDmc+RjjuvakyYM=;
 b=XV2ZgDYqCCS0efTSIKSkGFGkIf7OS7XMJd5Aa76s3gtR0rgi+ykaiNcpLVgDJ1lMGtVPXvt01MjWdP6I58qm8asVIFJbXkwxR5pqC72AsekBFemD3BYseoDbzY+3uczCV8pcwc8W+cCkpLTsgk+0bzTII+a7bav5uIiOFvp6f3peD+7Y3/vpEyknveLpZlABq9CKuDBlIzVfKi6Rw2VuCUjJtrfpndpH+41mgQ0h7hVVyDI6h/HrmyvvGToJCIKGOPzmyRIrwYQ+MBqeeysgO5Ll0Kc3lvtMHxJIOEQCutzjnRYmskhtIXKzBuhaGBSlPGx1OrQ4pLrP0g/q10UzUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxD9dnK1puo6RN4hlOQA78bDPfymYDmc+RjjuvakyYM=;
 b=ME8cS0NtPGc0zNz39J5pS80dSql8xRLGmA3OGHdqsk5Joelnq3gIx0xC0lRFvZncrhpUqIUiI0Bq41EWcuCefFQNFjTyBFW0EGaVSM0QzUv3q/X0mwQUQ8EPQBqQHuonnqylCsMwLoqTn57oU+Z0pFMS+pjV+BlJHcZbxVToqMw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2590.namprd12.prod.outlook.com (52.132.199.17) by
 SA0PR12MB4463.namprd12.prod.outlook.com (20.181.60.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3700.28; Mon, 28 Dec 2020 15:23:08 +0000
Received: from SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::21ed:fdce:2ba8:2179]) by SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::21ed:fdce:2ba8:2179%7]) with mapi id 15.20.3700.031; Mon, 28 Dec 2020
 15:23:08 +0000
Date:   Mon, 28 Dec 2020 09:22:45 -0600
From:   John Allen <john.allen@amd.com>
To:     Domen Stangar <domen.stangar@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
Subject: Re: problem with ccp-crypto module on apu
Message-ID: <20201228152245.GA90548@nikka.amd.com>
References: <em96a2a8ae-80a7-4608-905e-5d932c0cf9bb@domen1-pc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <em96a2a8ae-80a7-4608-905e-5d932c0cf9bb@domen1-pc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [165.204.78.2]
X-ClientProxiedBy: SA9PR10CA0026.namprd10.prod.outlook.com
 (2603:10b6:806:a7::31) To SN1PR12MB2590.namprd12.prod.outlook.com
 (2603:10b6:802:2e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nikka.amd.com (165.204.78.2) by SA9PR10CA0026.namprd10.prod.outlook.com (2603:10b6:806:a7::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.31 via Frontend Transport; Mon, 28 Dec 2020 15:23:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5be61b10-1af2-4a61-e53c-08d8ab447b33
X-MS-TrafficTypeDiagnostic: SA0PR12MB4463:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44630572C6ADED493A4B66E59AD90@SA0PR12MB4463.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1wZM5A9RhogNoUggCLrZbhQ1aV60LYMMP5xPoS3aLNPYeVPe0hv6SMkd1hvQJBigELqlxYD6b11CwDkcwywQRQRmW5YJnPXeLtRqle7BS1LSnTEuhBmt+OBYy7Ud9pt/tc8kHfuDZj2QB+oNJkqrd48Is6eRW6BTRO1HOLQNR7/jiQDtKwyaJm/TbafduKAu3JK+8oZrUKNe8o0Faay5ncRiWd8P69jXkp9DoDfBC4DDX5qZdi4FISSkh1hRoihjrWaZk9pOZGbTkmlX1pPYCKGN7xW1IMRXgNL3ApCqzREXMEbPugzwedVjvXrkzn1/tbOTFdLHRGlQTpDi07Beucvyl0aPibEqLEBJLsFClNZ0FMAIHlVY3KtmFH8eN7PS8Xdb445tG5+yEwGcnft5pA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(66476007)(26005)(5660300002)(8676002)(16526019)(1076003)(6666004)(86362001)(316002)(8936002)(6916009)(44832011)(52116002)(4326008)(55016002)(83380400001)(478600001)(4744005)(2906002)(66946007)(186003)(956004)(33656002)(7696005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5jsvWGXjI0XIJfgdbhR6Ntz97wG9N+7+Vlx8Mv8CQqCd7yB63xBSRbmsOAa6?=
 =?us-ascii?Q?E0w8L66faYcG8B+itwUYXF/C0Zfpn3pVfWJQ+kDagQ9iZH4oUfaTLgLwcXeq?=
 =?us-ascii?Q?GyAJTszpbMZhgi1QB0+JKJVNnAPn6oLZ1fPhRK1eko0F0VfYoiAyd1GAUxIk?=
 =?us-ascii?Q?aKRWqZXWrDAzPZDUG5lZ8MZfgWDkCM4Llj0/2uK08WV8mZNDSIRnoaTfKTJO?=
 =?us-ascii?Q?z1tXjcpIQnv1/9YSu1Ycl02TuXQ2DUqbqN9wRoqHN9VbG6D6kRtRgveZ4szP?=
 =?us-ascii?Q?Z1aq4UxaNujuaNYamKKHNfYmIXhGaq3fCYLvG9tfL4wZkt+/J+tnnfjHyHb2?=
 =?us-ascii?Q?BX3/H+2qeV6+/HP+chAHDotvwtXQHuNR18kVboxWtgYUW2tmSf918WpHuuFJ?=
 =?us-ascii?Q?kP522wkQpyI27926RSFlQ3c0pRXNDepiZewh5K7mvlqWCvdpzZEvcw7CBKd8?=
 =?us-ascii?Q?GSuNPvSS8ywPKF0+iP1Z0woRXluD3OCEY/ipdj5/79Yub+GGA0l6dpLmI8c9?=
 =?us-ascii?Q?O6Ka/Ss7Wx8UtGkaH8l6CbvJAzw+iK75ZHrdNViEgOl/YwqxTNf3Mq4kt39T?=
 =?us-ascii?Q?AiKitytGxZXvqGW0OfLHA07t68f2l7bYELV6Y54ddeGSyP2qazZFzkrWSvDS?=
 =?us-ascii?Q?Esk4jQZNc594fRxvPMjFgfTq6nxSvDuhhR11g5CTgymhRMbxoTmGMV5L1FdS?=
 =?us-ascii?Q?bEU0JWRVv/nkVCc8Ys2yXDJxFOhz7+Sq/tAU3Xoi0OP6FbrMzo+Xf6IThWXO?=
 =?us-ascii?Q?6uyJe6HwY6petD47prS4JxlqJ0zy4Ij3iG+IoowGjjwCg1DAaP1GShkGjwB5?=
 =?us-ascii?Q?v47s2ZtcQ6MleW0Yps4aihj6QxdwyXnYZ+oaz7rw5VCndJoOJBN+mT7X0vmp?=
 =?us-ascii?Q?XiH53uJdKSI98motxuRCipRHtVmGtXom5G1gwNeWYwaFTIJ4ALaZ1qER6B9I?=
 =?us-ascii?Q?QTn110ujOEHY3AoqL0xzWtlQshYSXRVxqqcm9RSmPSA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2590.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2020 15:23:08.5030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be61b10-1af2-4a61-e53c-08d8ab447b33
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZGGj+NKBIZuKexjI8urddnZWPN8oeEFTMjfEjYJ4tMJnMqtP9pMkKxQP0IirOKatSlWwCSUWV5fWGtGwRiHhyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4463
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 17, 2020 at 07:42:52AM +0000, Domen Stangar wrote:
> Hi,
> I would like to report issue with ccp-crypto.
> When I issue modprobe command, it would not continue, without SIGINT signal
> (ctrl+c).
> If module is compiled in kernel, boot doesn't finish.
> Looks like problem is that ecb(aes) selftest do not finish ?

Hi Domen,

Thanks for reporting this issue. I'll look into this as soon as
possible. Once I can track down some hardware, I'll reproduce and debug.

Thanks,
John
