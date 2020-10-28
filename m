Return-Path: <SRS0=zC9F=ED=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFA0C56201
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Oct 2020 21:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D1942245A
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Oct 2020 21:50:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="lKWIidim"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgJ1VuB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:50:01 -0400
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:24345
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727942AbgJ1Vtw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Oct 2020 17:49:52 -0400
Received: from VI1PR04MB6992.eurprd04.prod.outlook.com (2603:10a6:803:139::22)
 by VI1PR04MB4654.eurprd04.prod.outlook.com (2603:10a6:803:71::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Wed, 28 Oct
 2020 15:16:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gzsg+EFrm852r/QA2XiejlFyBMAnOGV1uGDvoe5eIdthqVOFlG7mvAINCy+gBZ9kwAYpQAavn7ul66Gbrzc+rBJrA0ERObTkoiGvch2Uo59IhSu1uYqNDZsVndVueI5wS24IdYgWqWIaYVuzj1npev8r29Mw/SQbUxLvf2ZRP8IpuY3UtisBL6zGBk2Npu3cDVxImoh4Xo2fh7/SFw3hZqAfAmn5kKLG1QvwgmqpCOHJ7kFjpNlnRjTn0uw0V5coDFrjvQ267nCxrrj9pAW3P4KZELqw93fwJ3F41GMhK7096eRq7lmVLy/nVkXbEmvaUhmFS0HxqwXSkGWXL97eGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqQTxMjVmqDBpVcD+DA08c/tm2HNobxitXB7FO3bFD8=;
 b=k7CKfh6Uby1VFnMfl25mMrWHZ32/gMX1rUvwfmXBmpZd4POwPbrM3E97v13ujuUopoYa93shDPCG6ydID7mqDwkzTo17L6aoIrgjwDzMeKvfx8ps2muXaslyUMBSfo6xEg0FeoMJeSIXbc2Ykq4uOWNoCC0ZjemOEpzP87GjMqUGhpLZX5VAFloXB+ysJN2Y+W3uuMi+EiDWd3zrCixPximVtmgsByS62FZgnorFbgYd6XQfOq0BXA2BZSR7WH87AOTz2oYoM8rSQ/FXXdJkoC22M0bHksmEAxAZPxgweAHo7oXbTUuI9v5YwzS5pdLm3hCVszYCfDVTOJ7RKsaR5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqQTxMjVmqDBpVcD+DA08c/tm2HNobxitXB7FO3bFD8=;
 b=lKWIidimc6QlnRS44OfcMXkU1rcEv9tArUI3TI2OgSDtcL4StHsjcBwhO8ACHugIuVW2IPeYXkxmwqcAl77ofae0FjDGQnU18FRY6aaJqgCZCDhd9Hl/dq1XwYpVBj2qVd5sT2Fqmlgr0J946jJ2RBmSyEEtJ6eCT9/0u8sx1ZY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB6992.eurprd04.prod.outlook.com (2603:10a6:803:139::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Wed, 28 Oct
 2020 09:43:46 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3477.028; Wed, 28 Oct 2020
 09:43:45 +0000
Subject: Re: [PATCH] crypto: arm/aes-neonbs - fix usage of cbc(aes) fallback
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20201028090320.4222-1-horia.geanta@nxp.com>
 <CAMj1kXGfwuY_uEGT83QpoUZwy9X=6k7zaxHs2kFrdsArKpVpOw@mail.gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <dad58d52-7784-ab98-3634-15c86e52712d@nxp.com>
Date:   Wed, 28 Oct 2020 11:43:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
In-Reply-To: <CAMj1kXGfwuY_uEGT83QpoUZwy9X=6k7zaxHs2kFrdsArKpVpOw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR01CA0106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::47) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR01CA0106.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 28 Oct 2020 09:43:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6dbb232d-dcbc-4ae0-0589-08d87b25f6a6
X-MS-TrafficTypeDiagnostic: VI1PR04MB6992:|VI1PR04MB4654:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6992DE3ADEF801D2772F759C98170@VI1PR04MB6992.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PLx1TAryRUKrWTOAu2ryd0QsSY+BwbieGRSeemc8SiUc/xYBvdZn0tFHuIzzQNbXF+aTF5V5e/SYrrSDwJIFNn0nvuNr+TtI2bdQkqEwygoJM/7L1pONnjDqmHPd+pYUaL83wcz3I1ed5QflP7cPWfcwEeg8Yu4BN+WTPX2oORQZjgy35ei5ZeZxpB0mW4NzCih+0j3cPxeMl4hz0sjeqvQShtEiNPpIi2wrLzCeWQAjIkxSBPnzxsijnmgzcyxPrqIK5QYgffbDKDVsEdbIXA7cj24APzsBkzmPC7dPqCQufbd9Teto4iWQLO9Pj9OsCeT16l74/PSK00H+HG4cGw0MJJh+DhCGz2mmC2NcYDwBasealL6up8ukprLVumxt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66556008)(6486002)(54906003)(4326008)(83380400001)(8676002)(16576012)(31686004)(53546011)(16526019)(186003)(36756003)(2906002)(52116002)(6916009)(8936002)(26005)(5660300002)(66946007)(31696002)(498600001)(86362001)(956004)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LgO3aXwPsdT6vD9YHq+k3aMeNRq/74MZHF7embdDABnTvmVb6IYYWi+/S2nz7dAx/D8N34R22TV3bbVPumXHxGEan+OHrnTEWvr5cPEGfWoYfi+npB6bdESAF5OR49XZmL/s8xV6RPgKdkj2LNYr0e27gRwwZlXEzIGQShWjoYsInxDvuolC3QGIVxxGcEwlzoqvi34mb/MgwAEGH0BjQCUMR4xaDyP1cf08LSYu3sUyklQfjwh08UFxn0TJmc/KjBC4dggK6gMPLY6YOA16254wt0cBpqYM5Er6zAUqX786RvVSGATWI6MsD08ZfnwNxpu+TmRHgvp7eUUyJ988MVxzZfOvGZ7fCMXd79E/cuC7BXSpwENHJinBhwk2Lyf6fgXcPbPUy1jWgdiV4Js0hqpWjTWoCkcrBSUJbih4+S2DPNdV22tATt4ZC8KcJHS9cNgIrzDUtBGWr7e38Wg2ibZCpREtzd0BuMXNSQ1oB+iTN1CHdfiC4vOBonhUd+c7KZeVX+0U1LlL6edGaOK5zduGYu59Xfvnal9F+2BFd9q3ZsxH5mkWteqkEzhr7Mm4Ew2APMoPzaywIFUBBxpDztZrM1tsN/sKYW86G5YFbklT/yaqAL0T4waNYqtyJtPqWh4QiybBVFo8KR4ETw1ktQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dbb232d-dcbc-4ae0-0589-08d87b25f6a6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2020 09:43:45.8165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q/DyBse16iLuZB0dqCe/QIrCZU6kQJ1uuJoHXI7Ijqv08tk1Fe8XH204OYPUSrz8cqO+VB4PfPYeW/GW1NIv2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6992
X-OriginatorOrg: nxp.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/28/2020 11:07 AM, Ard Biesheuvel wrote:
> On Wed, 28 Oct 2020 at 10:03, Horia Geantă <horia.geanta@nxp.com> wrote:
>>
>> Loading the module deadlocks since:
>> -local cbc(aes) implementation needs a fallback and
>> -crypto API tries to find one but the request_module() resolves back to
>> the same module
>>
>> Fix this by changing the module alias for cbc(aes) and
>> using the NEED_FALLBACK flag when requesting for a fallback algorithm.
>>
>> Fixes: 00b99ad2bac2 ("crypto: arm/aes-neonbs - Use generic cbc encryption path")
>> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> 
> Not sure what is happening here: IIRC the intention was to rely on the
> fact that only the sync cbc(aes) implementation needs the fallback,
> and therefore, allocating a sync skcipher explicitly would avoid this
> recursion.
> 
My understanding is the following:

1. Local cbc_init() tries to allocate a fallback tfm for cbc(aes)

2. crypto API cbc(aes) tries to find a cbc(aes) algorithm implementation
crypto_alloc_skcipher ->
	crypto_alloc_tfm ->
		crypto_alloc_tfm_node ->
			crypto_find_alg ->
				crypto_alg_mod_lookup ->
					crypto_larval_lookup

Here crypto_alg_lookup() fails to find a cbc(aes) implementation.

3. Next step is to try to dynamically load a module (request_module)
that supports this implementation. And here it deadlocks, since it tries
to load aes-arm-bs module...

The fix is providing a way to (partially) skip the dynamic module loading
in crypto_alg_lookup() and allow for the last method of finding an algorithm
implementation, which is creating the cbc(aes) on the fly
via the cbc template - see:
	ok = crypto_probing_notify(CRYPTO_MSG_ALG_REQUEST, larval);
in crypto_alg_mod_lookup().

Horia
