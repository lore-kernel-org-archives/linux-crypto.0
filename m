Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231E3C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 06:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5E122313A
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 06:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbhATGTg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 01:19:36 -0500
Received: from mail-eopbgr20134.outbound.protection.outlook.com ([40.107.2.134]:7943
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728385AbhATGSe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 01:18:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5tcptMV4C3jHcfIO0Nu+w8AqVB5litF7cQYmH40LOdJCzJrrmehrieWajAXNJp/Ox56qBohQS0cAZDnuhKb/xDx7n68xVgICG0mANiS7vb1nqELm+55LOQfYfegJpOwDnTVGvRbjfmCnKljy1gwE1Tgee7dH70oIeGh2h9x+VABH3/UCrXrnZ5u73p6QSloSP162NXvnXnZ4qgWohNlhhgyNMXjUQBCL2aV+Uvg8QOyg+N0vBLws7QWs1Y4ZDkP7o+bwQkw7d4viMDrmCtNvPLXOzlCbT7SKGtOi8S2OvQUqLWbp5B6jliYvUNbo24huUDvIDDGGb12LCbUgYFY7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TK3W4bLHLsIH0/6+8hCCPuszXpDyNAYNANILhWp36AA=;
 b=TYuqj2CI09Q6oVr8514xafJKLz/pg3rTiCIB/Y9Yq+cfVgYFoBKTsnnEZR/DmvfVSU3cImGOk7qGOmj2ldJ8s9gvkrZL4u23ISLS6SGGg+jqtRfuRZQ1EsecI/TaT0rs0Eok67XveaadhZjace6jfNfQGeZMIGdC00lZivXrzNTNaCF8v2Ea1TNnW967eLfGgB+022sv7k6jPE9dsfIUMBPAWEiELYDxpnuxWgacLXFC/UAquTq3SGaZRGGhpuqP0b3bgsiTMLzIYx7kf9f69TUAGkSczSeo3PXvG9ltFdTets/NrWjQIT10oy+xhdojZ7xBzxpJ5GsLevKm+1Omlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TK3W4bLHLsIH0/6+8hCCPuszXpDyNAYNANILhWp36AA=;
 b=K5UyIq3xDabIl0Jc0FzR8GDqMDvyvuL+r/zrgw0VnpWSNd1dPd+SdCmSrucQyW3l+NXWAUoUtDAtwvQJkZbEkQeinmrru/wtxZF6tK/3Zu6uK/tQ79WvUZdxWM+ehuiszFlRi21oqu3MTQSp5/0nHaI/+YhSQxa4WZFTbBO2lJ4=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM9PR05MB7635.eurprd05.prod.outlook.com (2603:10a6:20b:2cf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 20 Jan
 2021 06:17:43 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b%6]) with mapi id 15.20.3784.012; Wed, 20 Jan 2021
 06:17:43 +0000
Date:   Wed, 20 Jan 2021 07:17:42 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [BUG] marvell/cesa - Fix sparse warnings breaks driver
Message-ID: <20210120061742.mfqlyuyfu7757sze@svensmacbookair.sven.lan>
References: <20210118091808.3dlauqgbv5yk25oa@SvensMacbookPro.hq.voleatech.com>
 <20210120052629.GA7040@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120052629.GA7040@gondor.apana.org.au>
X-Originating-IP: [93.237.75.159]
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from svensmacbookair.sven.lan (93.237.75.159) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Wed, 20 Jan 2021 06:17:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63adfedd-9ffa-4fbe-3dfc-08d8bd0b18c8
X-MS-TrafficTypeDiagnostic: AM9PR05MB7635:
X-Microsoft-Antispam-PRVS: <AM9PR05MB7635BDC568673B2BBCAFC0EAEFA20@AM9PR05MB7635.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ttm44whOoA1uXEdcHrFn5pdaPekPPfg3g8yfZfMOW/QvKx3zvOHdBdyNnd+M0fquA/U1MGRvcQV2f4bl/E3Gj841oRQZDK7Rx8F+R32SOnpKPIM2JBV0femrKqJO7iTm2KFMcPaG4GXjKjk1WRHGORZSsD8SiCS9lCiEdO4/GyhAZz5Knt8hJZ3kRBHaIICFicpz22u7X8GsSPfpVY58FuH4OYuxHCfqZsfL3BMFxYLhCRIViyHCiCoC0grnQ/9GglWlyivk4ZHvZf2Wr08MR+MutHFN8BCwq9n0o+KNeRAgW4wgTRVb6Ms0W/K3A4e9HMHjwk0JTcd3qwzE5iwAzTjJhDCE/CpBxOix12918stzuVh8wYC11W1RHSRWAxrgcNMEgqHohVuV8SzH0T1Cy2W06yrywiufH81gikZG2h17S5vk5MvvveVrWefATzKyPwRqV/5Noug/Eee39/TT5m+TzkX+7n8qa4EmtqNOeTjH8w6fK1yxtwJiUAoQRoxn6M2pt4aE/fDU+AyuNLfQ9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39830400003)(396003)(346002)(136003)(366004)(9686003)(186003)(956004)(66556008)(86362001)(6916009)(26005)(52116002)(7696005)(16526019)(6506007)(8936002)(44832011)(4326008)(2906002)(45080400002)(1076003)(478600001)(66946007)(966005)(316002)(8676002)(83380400001)(5660300002)(66476007)(55016002)(83080400002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7tBpyl2G9JeiEMWDdjfBff3Gd14BSJxMVb0JLjmIIEbrCGQzyPNz+6TvrE5b?=
 =?us-ascii?Q?19L7Mp/O98uw4WSd1Q0+yKsMrjIAz7h1GHlOChxQc2S0OsmqYJOiY4KEniqq?=
 =?us-ascii?Q?j5IM/Wpe86CpVBEcalwp9/FO8mbU/2teJknV3cU/hmrEJt4PGKaJtmbSj6nY?=
 =?us-ascii?Q?oqJnMAuwaeXbxCcQ+UHaFlGXztsWdZ1bBT242Z0E/+riZSQExV3pdq7eWlqB?=
 =?us-ascii?Q?aR2dGFAn1jFFEtsLbp8TSx6r6BpZpskEeEYCKSjqkbkpfrqmlgVRASCpTXqw?=
 =?us-ascii?Q?DGl35wxMCSPJF09Y57qARK0H0xYL+aLnug63R4/HH2cq65+rIEKwQAeP3HqK?=
 =?us-ascii?Q?1NcKvamfCuRWr8myPdRAMtwKkkgueGp52ve67T7aybAI/b2GPN35IYUH5qpr?=
 =?us-ascii?Q?VZ6zwuPMK2P1XfIsYO21LTlFnij8W4A9esyncZPim7iU2mKWEBR62+vCXAer?=
 =?us-ascii?Q?F2KWrd5u1+ChdID/AYDAXCyXZ5LXPAwuMjHt5u+OlyHheqaSTxMwlhRyITwc?=
 =?us-ascii?Q?J38s9BvYDhVa0J4bu+Q3+lAV2swsdnq7+3a4G3C7NMLAMm7x5mOTdJlR5AiQ?=
 =?us-ascii?Q?xcDSa2O8wdUpvkPC57UsSS62mhlaZQYwAh3vRO4zpKVQNpEBcAYpRcLKS7s/?=
 =?us-ascii?Q?KL9dZy4y/R4HiEwCOOTRSAQh7qaW7zpzvEZievBGlAO4A6MpmHfguueBlagJ?=
 =?us-ascii?Q?S/ZS2FGsZbbaH3phsGrf0Qe328YYva5/HN5AvnTOZbYH4E/ITTkps+EXt8xe?=
 =?us-ascii?Q?X2EX9v9Lxv+OFPVJxfk11rh3NuQkl8Dm2hVxko/zCBu/DqIJ3T9T1z5cMqm/?=
 =?us-ascii?Q?nZlstdoZ3fpTrk+1a7SM1AdCJYISRDVFyYiW+j5v18XouRkgjrDZnZ81gMd/?=
 =?us-ascii?Q?MWwX8t40mYMOnRP92A69Ta5SmdIZfFJ9d2qV7WxH593BN8Eh77T1S5wmHa7Y?=
 =?us-ascii?Q?22YSCsa9gUpCiXcJchGDCTBzHg3eGDpS2UOlVMQX8UV7pFWOVFr8Qkgvyhoj?=
 =?us-ascii?Q?9gMZ?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 63adfedd-9ffa-4fbe-3dfc-08d8bd0b18c8
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2021 06:17:43.2663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oyqSNp818KTgYTBafS2Oc7JchLVse4GP1F+rqAk1cH1r8AYmA6kZBuT7FNpfeqmAQW/ajb/VDsyys0QasfpMEdC2ysM5CtFqB2kuQWpQIM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR05MB7635
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 20, 2021 at 04:26:29PM +1100, Herbert Xu wrote:
> On Mon, Jan 18, 2021 at 10:18:08AM +0100, Sven Auhagen wrote:
> >
> > Also on my 5.10 Kernel the hash tests are failing now
> > but this also happens when I remove your patch:
> > 
> > [    6.859791] alg: ahash: mv-hmac-md5 test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
> > [    6.883144] alg: ahash: mv-hmac-sha1 test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
> > [    6.923069] alg: ahash: mv-hmac-sha256 test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
> 
> Are these errors with or without my patch?

Without the patch.
With the patch the tests never finish and the entire
system hangs.

> 
> Is your machine big-endian or little-endian?
> 

It is armhf so little-endian.

Best
Sven

> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2F&amp;data=04%7C01%7Csven.auhagen%40voleatech.de%7C0e9b8c37f9ec46a6cb7608d8bd03f50a%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637467172009606124%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=rVPM0bynvNOKPxE3nYbEtloPcS5tSJBJh1KyDNCem5g%3D&amp;reserved=0
> PGP Key: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2Fpubkey.txt&amp;data=04%7C01%7Csven.auhagen%40voleatech.de%7C0e9b8c37f9ec46a6cb7608d8bd03f50a%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637467172009606124%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=TpNGCvaGo9yXH%2B9L82lkrH3EmbhCUwWxrCgY%2FNkXTVM%3D&amp;reserved=0
