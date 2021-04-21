Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EC0C433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Apr 2021 14:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5222F61434
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Apr 2021 14:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239485AbhDUOXM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Apr 2021 10:23:12 -0400
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:31713
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235421AbhDUOXL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Apr 2021 10:23:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfKlea5IJEFHjFdC8ZBfpHufwxTkQHSCswuPNrJwiPbufF2VC+xcxSM59d4tlK9hAqxsvT3aVECpEUj8zQzPBjlF1/DAheWNfIsrgGqmFJaasqKBI1MnTfaKyjiZ6GjuoJEtKcp9t5SDMvRwfgyC25a9nLiqT/i7kZQNcPLBz4lnPh4spArhTe1bW6vPNg9Qi++Y1ml6a9azO59b34t2ovr57vWsU4T/Ne94CyGqRjozLjULvcevpgCKwI08nrEcJFZ2n6da1ndjqn0ihvIuodPvt2uq4kAsQaZMhPLTXE34YDlB0G8wHLUh2qZOxVdIp85r/YpIvG7CFFbnSx8CRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCHXe+LB5eZa7ug7ox9QZoqROFEFV1T6+ANNfMR3Jlo=;
 b=nL1lU56Gwzy3qkyIxc0HUrvViUEybEdv9dqsq6XEyT7UVvFQX8L9goLGAAAVVz44Fz807VB5oUs1sOn/UjxrJ8imgjl3R9/1k+XvSMN6YNcjGKZ8vNsnWOxclqCedGfXbZEh08i1gq/ZxSRZ34AYifQHFsjgxAZuh7+kz2E1u02GENfK6v0D06vO2SXD2cQ0/OIcD/F+O74mokBijoCVO/qck1v5/aHJy146Tbsdokq5poV+cnss2VeKhc8snho520Ab9AP9aYc9JNQGkmp1T6aqASFYkrBwsbRJn3RTJAWqfnrRhuNADiTIthlEvU+DuJ1mHQ9y15C0TLuhvA0ThQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCHXe+LB5eZa7ug7ox9QZoqROFEFV1T6+ANNfMR3Jlo=;
 b=iEpYIAlJS/W1vrJbWkGk8fCjkg7uPdJ4f6SPuDDPd/f1onflcA4gmyN/+as8tPlDInMl4tnrNyCg256Uq6TFeOLV1+weQGTgdHWvy+34XoI1a3OCr/1BBVzf8x2V24+4Yb73c5skvAZvrAQqB6L3jVJcUB7YFwa1nyD5mNCDo5M=
Authentication-Results: hisilicon.com; dkim=none (message not signed)
 header.d=none;hisilicon.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17)
 by SN6PR12MB4704.namprd12.prod.outlook.com (2603:10b6:805:e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 14:22:37 +0000
Received: from SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::cc57:2080:e945:55ce]) by SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::cc57:2080:e945:55ce%3]) with mapi id 15.20.4065.020; Wed, 21 Apr 2021
 14:22:37 +0000
Date:   Wed, 21 Apr 2021 09:22:28 -0500
From:   John Allen <john.allen@amd.com>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ccp - Make ccp_dev_suspend and ccp_dev_resume
 void functions
Message-ID: <20210421142228.GA11901@nikka.amd.com>
References: <1618535202-11397-1-git-send-email-tiantao6@hisilicon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618535202-11397-1-git-send-email-tiantao6@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [165.204.78.2]
X-ClientProxiedBy: SN4PR0201CA0039.namprd02.prod.outlook.com
 (2603:10b6:803:2e::25) To SN1PR12MB2590.namprd12.prod.outlook.com
 (2603:10b6:802:2e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nikka.amd.com (165.204.78.2) by SN4PR0201CA0039.namprd02.prod.outlook.com (2603:10b6:803:2e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 14:22:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1342f401-21dd-413a-5f81-08d904d0e9cd
X-MS-TrafficTypeDiagnostic: SN6PR12MB4704:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB47041E6ABB5FA291EF4E10BA9A479@SN6PR12MB4704.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8tAo9nqWQbAcLUvj+nOn//TgZ+Ll4hYO3fbOA67FzyNvfh1muOxr0G32FQaSdkkxEsIwAw50FuFwnc9nxyYkXm5BH3TxW2EFpxYiGbFkJh9p7coYUCG/cJ9K7FTuRKPUZk7j/5roulgN96YnJkusOu+UyzFittPZeMsjoL58Ke2fnVad/irFk09uXlNTZxva6+9cLXuJTX9uX3R7dkRf5ptyX+veL6NKaRpvVXkNBC7G2JmmBRH/E+6VW7wOjBCXJVXKz69Fs7a52G2hMQOhKf7VYSGnCMemiZqZdwEDoTW3RsjEwHjVsvaXGX0c7l7GjfKXut1QFcafFke6Ok+H4Dm2CykP2vSCHnID6sorS0s0HEwNeJIDteIhDFfWyGQiClIR9RvzuYK7lcEMS3R56Yk5ClswinLEVh7+BTvtCNfNlsl0Tw0IOYNMWogGv1wRVOPtVaEK3EySPnkQogjeFINv4FhQVxnU4ifK5o1YnSj83ZBCOIe368jz7ZbhkR6bWKBl8Ksu1LiHhFBpbY/Hm2qmn/ZKLAXNORaiDVMbSr3B9SQGLnezAW3eUT+o8B61woRjg2tET3pSYpiAjA3z2petBaEm4JyVUB5TpLFLlK+pKnIubZdU3FhJwLvbP5daEpSVlfrZVRzS4d6KsTBijG8frVo0hsLcciszgAzUOao=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(346002)(136003)(39860400002)(956004)(4326008)(5660300002)(1076003)(7696005)(52116002)(26005)(4744005)(316002)(8676002)(33656002)(66556008)(83380400001)(8936002)(66476007)(2906002)(38350700002)(6666004)(16526019)(186003)(38100700002)(478600001)(44832011)(55016002)(86362001)(6916009)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?K3518wE+ETYW7y4ocrHEiTw52hVsSiOI/HrrFJBp1tkCSwzndR6yV4UW0nZ0?=
 =?us-ascii?Q?/GNfpDlxpJ50gStt7tdAyeZXciRFvecnb8uc0/ZuHvMUTwudPimUAtLm8K82?=
 =?us-ascii?Q?rMgEBUz5j8jdgQcdpfLso5M0BYtZ8TNf/Y86FIRpyWg0044j3uW5wQVawL/H?=
 =?us-ascii?Q?NLdTihScjtWhqVW6sBCGgJjKE/wCpEQdp9m5AAUJwlR7bZT309WUDprXB8KR?=
 =?us-ascii?Q?wvMB4pgv49/U5/VXyGljrHhaWOt+4QxqTEz6ClTneZCPmVGbI3sRdnyFzJ+k?=
 =?us-ascii?Q?mymKKyvdms1bHNMjWoimwa4DlVhfUmclxBdc8jIb1HoUJShX10i5jZWfpBjk?=
 =?us-ascii?Q?a/K1Nq4+0xsjH7mJIvNDkbZVWrkWRBzIr0n+DelkgewuOw8UGtLkPTvef3J9?=
 =?us-ascii?Q?b/bm8PW9sNqIqi3BZXpLvgM5e2rpsYXFXQp5/j8jv85FTY9K5bdcCiOtpEUJ?=
 =?us-ascii?Q?6pCV3w5MAzxtRr96s02CJ8zEcIauTXYjOJYeUnwR+1pVizGwDrMFM7CWXI13?=
 =?us-ascii?Q?anImMGZaWdD0JnkjWWB3IPC4lbiw8SfVEpHuyAiiJe3bS9wP5Y2Vad2Cvaoe?=
 =?us-ascii?Q?FvANipmkVa0lcWmK6fQ8WG5ZNdevk37BGByPa56buKcodVr9RY5uXKX4XjAh?=
 =?us-ascii?Q?HIdsrJuErQO9s622n+FgMpYd0W+yIzEDjf8ER7jSYx2l65GvlMXaxnV99Ch7?=
 =?us-ascii?Q?D/+ggkIKwxVvAWBDQtXeTRsvVHAz0GwU5V8F6HJsymcKsBw/95o6hQq993QM?=
 =?us-ascii?Q?zKRw7xyoikDAjptz5NExR2xJCBehbm7qwubAaMz2lmp3WprKHhNUxsBeX9Oa?=
 =?us-ascii?Q?i3hvIlYNmJ3Ii2CeNjBjnTC2WFINWuN2+bGp5mJMDo0eKK0slHBBRpx4Np3n?=
 =?us-ascii?Q?v6Nk7pSB1gPyBOdb/7lqWXr09fEBLJQwkcqLwIk/zsT1t5TyVOwkGLFEl6Bw?=
 =?us-ascii?Q?WvAwd+4fGn3TYPFXzAQp5CpwbY2vxlHUjz3eVdQbx6EOxl8n2Jy1VhAu2Zab?=
 =?us-ascii?Q?ft1I+ucMtAQEYF6jq1drSQdhOazzSaA9r/WUDIp8ZAITmkhjXyr5K/s/wcmz?=
 =?us-ascii?Q?pHsNE+Yk5pWkjewHkbNVEVLje2dXxqD8PsDASWlkEAeD7nqRbcwj3NK4aeJN?=
 =?us-ascii?Q?Pw8bPWEp/LgFJ9XOperTPe/uQYP+HMU0ACSJp/YR8/c26VqLmoruH4/XqotD?=
 =?us-ascii?Q?ItntHYir+LV5rm5v0G+l+zoYn8ndOKtRts08oHUyIndTIYc2bHZ9BeuehpcL?=
 =?us-ascii?Q?kmltcPhCdEBD8gfLV+AL9S3S7S5kEWUqNJDXc40St2GTP+OWZGlT+ksNtUcS?=
 =?us-ascii?Q?3MBxTSqNz9rQnzeAstA3vrXz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1342f401-21dd-413a-5f81-08d904d0e9cd
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2590.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 14:22:37.3534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Thjr3yjfgTDUyxgOlEW8C3pP55Z1a/P20yfdIpj9wMwmkwMU1TdEV9XIOz8TI93fcFbG1anQuFEyju6ju/YDrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4704
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 16, 2021 at 09:06:42AM +0800, Tian Tao wrote:
> Since ccp_dev_suspend() and ccp_dev_resume() only return 0 which causes
> ret to equal 0 in sp_suspend and sp_resume, making the if condition
> impossible to use. it might be a more appropriate fix to have these be
> void functions and eliminate the if condition in sp_suspend() and
> sp_resume().
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>

Acked-by: John Allen <john.allen@amd.com>

