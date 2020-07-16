Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD349C433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 08:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 963FE20657
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 08:09:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="O0VqiDU0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgGPIJR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 04:09:17 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:51304
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726882AbgGPIJN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 04:09:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RovOJTDFSUOJNcja6/Vjaov82EpcJNw479M15O+xQPIug/aMR4MVwTIQ77tAV5jTP722KsTS13oM4byFLrCmUOFQGMuQM66x5SQKE6zK5vG203YJOpWOcPycYgH70HC8wbL/GBB20ZrlnVzr8vPpL0nO6UKhHk7UAkbsgwzmaZCAPXXZfa/Sfz8w7QpD803Qydwf3V3/VeH6g4z9gFeKhiQa3cbDIkLKLG+MZd/p5bktNps6niE103SWrPYiLFODm/7c1vkJiace0aq93EBa7WJ0f2C8I5Hni5bACzkdhHqmjMNwSIECihUy6ElZ3RF9CNa9FcrBTdeGeiTyuWjlDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2QdIPcgZcmNk8BSdZ2AGgB+8u/ceNL1gm/CNqoXTM8=;
 b=Abur4fbSg9YhLtDtTpN85U5osHGJ5l56QvE/GR3aazuE2aU3aR+q/96saRCj8a+gHyX3rXzmh35aPeq8T29iG9RpNc8WcBhIss5zXKG5S7Hxt9Shp7SMVOGyQCUWHR2ZBgbLWtMST291cTM9J2UyWeW6uMDFORE2drAHo/ihGBNPg6/NZ1rOO4cHwEpFyTvKlbslKJ2kIguRgIAT5j6PV13058Ih4dFeiLzA3C/hrF4Vl890fVPQqYybsZ+0io+BuV28K/KU8ZUysdvKffXUa2iV5Lut5bUB8fM5xFyKt8aRIrPiuMpeyS/PRjOVzi1ezsVKsUS62Q8ENt9Dw9oegg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2QdIPcgZcmNk8BSdZ2AGgB+8u/ceNL1gm/CNqoXTM8=;
 b=O0VqiDU0Z7pnPkJ2RBFB5gxrTj6IyAUXB5KqfqC9qUba1/mB+A+FtfXhgxb8AgIUIzn+wz86c7EZUwkYk3jPYEwBuMQzYGazSRWxMmHmhR6LOcsFLmhxpOGPmlGLXCKyyn1W+XEB37dbCfnMPRVifCwZFugXarUEx9haAF50st0=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5581.eurprd04.prod.outlook.com (2603:10a6:803:d2::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 16 Jul
 2020 08:09:11 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3195.018; Thu, 16 Jul 2020
 08:09:11 +0000
Subject: Re: [PATCH] crypto: caam - Remove broken arc4 support
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>
References: <20200702043648.GA21823@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <6b810baf-9eb7-ddc3-de7e-14078ae160e0@nxp.com>
Date:   Thu, 16 Jul 2020 11:09:08 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200702043648.GA21823@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR01CA0123.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::28) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR01CA0123.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Thu, 16 Jul 2020 08:09:10 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: da8bb99e-c179-48ab-5ff0-08d8295f8539
X-MS-TrafficTypeDiagnostic: VI1PR04MB5581:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB55813B32AE17FC19AA7C340B987F0@VI1PR04MB5581.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UJ2nr2LRotJW5hq+Xk80wcpx6bvHjnJPq/xS23FgTRuVhY1MrH4BfQ3cxzpdEHaMRKN7dJCwZZTjwSFYF78Gl9SXHoJUkjCycj6nEk7HUrh5RhdEa354mkMErPdrjH0nmL2yQAATVh8iQ6rKbTxLMjAX82NhlBY23wiHMCadLY9J/C6BECOdCgZCki0ca3WoixLsewHKVz0PQlRfh2nyF1/w0G9a4QDoHvgGyK2QmNgc6SwgWvzv3oUIqEgngq2UhKwDvZAubThehB1dyesUvtTMulQ09XBCvl1xZDkRNCjy5Bixu/HcJzZE5cmyDkXi/rdS/ORgPUwq5CVodNhZBBdY7sFFKA8slW2gZchFWeOQoyEzZvzZoQFQFGfgJHvSQGvrIr0Qfmg8Cqu2ct/LdDq1xnXdMM3OFAVKekcufdEKAa4JW7XsAjOjjX8mM/giyRyFemNawfy/rWG45rFBvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(8936002)(2616005)(2906002)(4326008)(36756003)(83380400001)(16526019)(31686004)(186003)(6486002)(4744005)(53546011)(52116002)(26005)(86362001)(5660300002)(8676002)(966005)(66946007)(956004)(66476007)(478600001)(16576012)(31696002)(316002)(110136005)(66556008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BWPxBN8o1oBZb6WUFWYizo4SPcZjHNZKXf9zVJex0kGXbYwPsiheCYPO/kkKXhvvDiagFfCxn2RVSaRBZTKTTJVDezJSFrgquH+RIYnLZ44ll2xRjH+4ekMI9TNg7ex4ZdR5q2mjywexvAMQPpTV/Y4fg7tqAc2s0SdX7jPFwXTTOwi0JSRkzTnBuVLc3DMYRsyOCdVfStdLSwCkisrW1VY/CfFQLWKA+SQkwEEHetjM0crPh/nc2jbth4s5pU1uqEQox/+B1FjJ9RWAomWoUKpg8XeJGhDhDyERTXha0CDtSWEEXyF5CsaxOhH28SL4w7Cow/BSDuIXFeGBhhL4GpkTSYh+/641jLPftZGllrCHVYjXzeN+z0k62g0wtMlA7/n9Idowm2ep8daBf4w6Xy1uDY2KF/QFiGbshO4NgVb5c9IFoHBDmN6FSl2piJVSrWfmZ6jvtpW08jsgYZIa53PilYizm5jtzS2+jD2/EvD5bCdGncdN7Rb9rrYO+9Xy
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da8bb99e-c179-48ab-5ff0-08d8295f8539
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 08:09:11.0334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnVdyOeifT7K8YEyUK4GpGgIq/sdBN62Il9c36wIWqXXOPIyAv451uYo8UP/vpNi4hvFabj/vXTbsOpg4jmcZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5581
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/2/2020 7:36 AM, Herbert Xu wrote:
> The arc4 algorithm requires storing state in the request context
> in order to allow more than one encrypt/decrypt operation.  As this
> driver does not seem to do that, it means that using it for more
> than one operation is broken.
> 
> Fixes: eaed71a44ad9 ("crypto: caam - add ecb(*) support")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Given the circumstances, it's not feasible to fix arc4 in caam.

Link: https://lore.kernel.org/linux-crypto/CAMj1kXGvMe_A_iQ43Pmygg9xaAM-RLy=_M=v+eg--8xNmv9P+w@mail.gmail.com
Link: https://lore.kernel.org/linux-crypto/20200702101947.682-1-ardb@kernel.org
Acked-by: Horia Geantă <horia.geanta@nxp.com>

Horia
