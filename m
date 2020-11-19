Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB25C6379D
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 18:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB9CD20731
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 18:29:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="UmvqDrAb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgKSS3U (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Nov 2020 13:29:20 -0500
Received: from mail-am6eur05on2068.outbound.protection.outlook.com ([40.107.22.68]:37450
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727869AbgKSS3T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Nov 2020 13:29:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B38VbXBAbY/jyf0lt2VqL5/KK3mj6r34t07rKNiqvoLRm6xPe1E+YRrGjqWi8WUcLAHBoJ6WH8SmJHdpRmakig6slqOTzP7GaufNrIKLncSMFCGigGd+ImPhEztK1nlTTj9Lmwbalf5C0/F4b3Ub2Fz9QZP0GQdbDYLinPNk33bmRNHgQZ56BmAWs6js1fu1IMk7YLqjY7rRt/n+8u2ypN8RycNGOQBzbsfvkCMYezsaJDCC/4QPZFwQxkSdRPf972JYwXc5XxoNCwqE3r8X0m7nfky37Z0JI7glPRhrsKY8hBKilSRI2mwF2aOtxxFbBNc0uvyj8oqgh8ZQZ2oaXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkucT6LsT9RsOKA6o0afKj81cL7mf7BvMv59Z2zvtVg=;
 b=BzuXkrbvRVW48ncp3AkZHSr07or5Q48xjaABGQyXXN/RrTYp7ZA6D8pVU5MlPWRwJj97LRMsZeIT0Tqw0oOXiBopb9zLwwBpFFty4IG4yv8fgj00st6eaaA5IotPtgROiMWzGHoHQTGXZohcEK5S5Q75KxVkUwhk7le8ybZrw0QoRRsn95f8Yy4mH8oXjgdmBoTHm9eUocLt/9+vFpwJ01cIvqaAKWPOuSVN89xy88n5OayHklyjGiToqoAjpkhHbjm2hXFQrjNNT29ufhnz4sVa6AG9USRe86yPohj9HRVpc3C7S4KoFChKDZoa+roJ1DNhwwwUCdEEpe41Pgdbkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkucT6LsT9RsOKA6o0afKj81cL7mf7BvMv59Z2zvtVg=;
 b=UmvqDrAbruVbZCrVE3p4qiPQ9acx1Yyr5PH03q3MTK+qMPoDycL4xinBIr48p54T5cPJVevoac062v1aazw9wYqvKwyfDQRDgWMLlUbqONKFn96g/s1jKZHwBm/le4rar6mOU5GPQ3I9cO9jzT7JVjuX7LUWW87dH7RZL+qSkfg=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB5501.eurprd04.prod.outlook.com
 (2603:10a6:803:d3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Thu, 19 Nov
 2020 18:29:16 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 18:29:16 +0000
Subject: Re: [PATCH v2 0/7] crypto: add CRYPTO_ALG_ALLOCATES_MEMORY
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     mpatocka@redhat.com, linux-crypto@vger.kernel.org,
        dm-devel@redhat.com,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Franck LENORMAND <franck.lenormand@nxp.com>
References: <20200716115538.GA31461@gondor.apana.org.au>
 <8eefed8b-5ad5-424b-ab32-85e0cbac0a15@nxp.com>
 <20200722072932.GA27544@gondor.apana.org.au>
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
Message-ID: <71b6f739-d4a8-8b26-bf78-ce9acf9a0f99@nxp.com>
Date:   Thu, 19 Nov 2020 20:29:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
In-Reply-To: <20200722072932.GA27544@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [188.26.141.79]
X-ClientProxiedBy: AM4PR0501CA0055.eurprd05.prod.outlook.com
 (2603:10a6:200:68::23) To VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.5] (188.26.141.79) by AM4PR0501CA0055.eurprd05.prod.outlook.com (2603:10a6:200:68::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 18:29:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5f9095ab-e9de-482f-8572-08d88cb9053d
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5501B8607750C285604AFE1C8CE00@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TKQqSWdp+lAJcOXKtrhEdABIV2QRaeie4U8n+1RT6vmG8rQAcqQ0YZxUePcq4TyoQbhkmsH7bo9aToYNF+FzSlv3wfftRZ6clmGLp1Y9j7wYlSmyOgN1vaY7lA/aFjA4TOSZnKcGhBhmnhMZK9waDbBtH21+eYNTT4LVbzMWO2PYvPFGqp+JSgEMCq+3YBTSVN7BBK3pIdCVPAZeWzaRHS1D0EajjNoJ4MyinLCtl2f1iP8aFaOZt+ghvEoyTUlSQtWbdQEik3u5tTGkgk3ru/FtCpZuW5RDkQYzntgKCmn4hHc672FfRtBat8ZrotCWKCBaLhYVBPshYE8kPQqV5e4lcY4KmnkQ4OG610jJfXkfK5NAkdWrRAELXzEGmPiuDQGYeYozoyCgNU3e5zfvXWHFha9H047juRiDcgEWVo6IUgVG0pTtI6p5nebzQBkCjCUEvPNvwefFNqfrh2HGuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(966005)(31686004)(36756003)(31696002)(4326008)(6486002)(26005)(956004)(2616005)(66946007)(478600001)(66476007)(54906003)(8936002)(2906002)(66556008)(86362001)(45080400002)(186003)(8676002)(52116002)(16526019)(83380400001)(16576012)(110136005)(44832011)(5660300002)(316002)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EauyW3szrujTVUeRhdgIdiKACJVweluW6JsVl4Xp0doXL53wEhoBdl57o7JoVuQMqOvbu9oaq54YcydESSR8zgPnaBYcF8Fp6k9Kv6gVLkEeP5+qlIdotHFkg8l7qawxJFoU4L+CNeGRQukPTi3qZPAtdSObo4v6nk5xUB1W27Pmxn4gbsTRWxsa25QcA+uQl/re7KFHpB3z+Dt4MtPXztMb0ZzXX5l6caS5BhLTcam3rm6luD3YWVoAXIlOwsoJ8HjY74AMmq/TrZPTNWDM3gQFVYcebG6ISR/mBhSsIV6Wc49c7WevGjV9CiJimZfkq5puNKbWevCDJF7CVCMag7QH8dWaHHjU8Ryp5QBmtdEkHRFxGNAezYOgRw73G92PkcgckrxVXvmURojGUr2nzSrQ5O7Ajw/CZQt0Bt8NM19gS4QAAFPDM2aPfEUEkYvY4nJujo9jMTBvj2n19C3hOIMi7Fv8KtPv+gd+SAvC0DjbLFnWu6pvIFfc9cZc67DZshTj/HvMN1rfxiMXqOJHOsTFJaTkgvY3POuieOQDu7YO/DSTvm6Li7MvvSacAQrNrQ2i4knUtRzq/aSl+DziaSZFdkXcwYctwwz3ipg0jIPnmueVDnRvGDmilKCGABk0877g9M88wIM+Ij44Xb4PBqzHm+dCgMlB7JtzoLGRJ0C+xLJetSBEueEXVERpT1MKsgq6xNW2Yl39CWnkwkBoqgTRvQ/7iBXKXfMfRW0isKlpPwdMkHFJtmBDev/chbAohqOhOERa1eRKLYeIPAW8mEVN4dC2/XpfosKy8LsW+T5DTH0L1QCvlCXbQXUC/YHAEQG2QnfqP5FzF+nQ1WTppe3e25FlmpHuWZab+iLn9rMqbsvHqoSPhks74bbakv3IvdOEKBFixF1dvbD2/Nawow==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f9095ab-e9de-482f-8572-08d88cb9053d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 18:29:16.0010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5zIgxluNjMLbFKacYbyrVRvAT8bj4Eleeo8N4PIgbaH7rWOFwyJruuIRs0eDvDrIGkODi1oy0qLia6t+G5hFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Hi Herbert,

On 7/22/2020 10:29 AM, Herbert Xu wrote:
> On Fri, Jul 17, 2020 at 05:42:43PM +0300, Horia Geantă wrote:
>>
>> Looks like there's no mention of a limit on src, dst scatterlists size
>> that crypto implementations could use when pre-allocating memory
>> and crypto users needing CRYPTO_ALG_ALLOCATES_MEMORY should be aware of
>> (for the contract to be honoured):
>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flinux-crypto%2F780cb500-2241-61bc-eb44-6f872ad567d3%40nxp.com&amp;data=02%7C01%7Ciuliana.prodan%40nxp.com%7Ca077782ce45c4ad3458b08d82e1100ac%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C1%7C637309997855351100&amp;sdata=T9RLjA%2B4l3zpxUSkFUGTxGQFu4kWfghQAKGyfUco%2Fb8%3D&amp;reserved=0
> 
> Good point.  I think we should limit this flag only to the cases
> applicable to dm-crypt, which seems to be 4 entries maximum.
> 
> Anything else should be allowed to allocate extra memory as needed.

I'm working on removing the CRYPTO_ALG_ALLOCATES_MEMORY flag from CAAM.
For memory allocation I want to use the crypto request object and set 
the size needed in reqsize (as suggested by you 
https://lore.kernel.org/linux-crypto/20200610010450.GA6449@gondor.apana.org.au/).
But CAAM needs DMA-able memory and the current mechanism doesn't allow it.

I want to use Horia's solution from a couple of years ago 
(https://lore.kernel.org/linux-crypto/1426266882-31626-1-git-send-email-horia.geanta@freescale.com/), 
but modify request object allocation only in Crypto API.

What do you think?

Thanks,
Iulia





