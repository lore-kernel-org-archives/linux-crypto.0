Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B509C63798
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 18:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7CC62067D
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 18:21:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="oDK1WElQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404956AbgKZSVT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Nov 2020 13:21:19 -0500
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:33926
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404542AbgKZSVS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Nov 2020 13:21:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XeNf6YC8bSj9LGHDxFn3WpnAzdUignd/y+eaRo7tdvO10I6jVHirR4c8Mrbrdp8XZqCe8oBbWUAP2Co2W/+k+46qNw/osph4gDttlNV697FaKDaay2EZNf9Lcvd7XkfQT2DHd+XLeOqrcVx8rFIKADjOjXTyij7y6S3E9jOrJu1oh+Enn8yVH9LrOp9sN/Eu2UyCRuqAsz3DpfQ3g+3H4h1x9vX5z5CxRLxC5bmXM0fu/uKg/F3PxvDS9uHpU8MKHUXcPaBpoT6zfs3C/wcxj1+UpVFJJDBKEvfmGuK5vJmx4ayOGmz8aycg5kGcsMOwHCMgXCJrqADUMz1Yw0QChg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCDQeXyjA49nID2m9RZveE2D/Pv/YJ0WXA2gOr3jZlo=;
 b=ACJNsVhuyxbrggAWoDMB8AVmkX99MSg5R9+QSaiSGqGEyCnumXwC9WCGBOixs8PgWno34xmR/Pvi6qMKvwAlHXmMcj/R3xtu0nAn4XtfMdymTNF27fdH7Bek3ftUgAgSi5hj4mqkFx+NxPNVgy5+zHuD1aDvX5+X46TeL6LzEoMB2/998D4dwS7NHo6qCyRUVhwIRZt0jmkydmrW1DhXAJ5PmVm8qC4iINJTAnZ8EYvb+1Tn6k84jeBoNM/tLjkljS+7SH/5nUmtA5g14vYyMx84LFEX6qm0JwXPfL9lVM7NKHvaqLa6o7lLQZq9VCj69urr+E2JgZt3klPNHn6KTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCDQeXyjA49nID2m9RZveE2D/Pv/YJ0WXA2gOr3jZlo=;
 b=oDK1WElQsMII9pCI8de3kMui9E4ZkAHhxFzRM2tsdyzGuM1esmmeHScpmTDSL/oBXJ76oil0uHepBX8Q3hO6hH2qz4gro/lDzCsiCJyWgN+UnZNypW7ck13x0IozDvMP8OggRNMnZi7vq/qDHquaP0qPmV9+dckhDcATKakMkPM=
Authentication-Results: oss.nxp.com; dkim=none (message not signed)
 header.d=none;oss.nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VE1PR04MB7216.eurprd04.prod.outlook.com
 (2603:10a6:800:1b0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Thu, 26 Nov
 2020 18:21:12 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3589.025; Thu, 26 Nov 2020
 18:21:12 +0000
Subject: Re: [RFC PATCH 0/4] crypto: add CRYPTO_TFM_REQ_DMA flag
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>,
        "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>
References: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
 <CAMj1kXH=gyCz7NQXaAoNC4cf37t9E8znngyLFVPv+dO79=Z9oQ@mail.gmail.com>
 <20b1493d-bfb6-d0bc-3b73-740b216db5f2@nxp.com>
 <CAMj1kXGBa7st9duOu1Z1y28_-Xci3ur7kevAP+pPFp6+xvcy2Q@mail.gmail.com>
 <50866e6a-e352-3728-a6c4-1fcc33af13f9@nxp.com>
 <CAMj1kXGNqY18R7f=oOvrjeboVHVNZ415ASV6EOiwvXU_UKB5fQ@mail.gmail.com>
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
Message-ID: <5ec4c8bd-d7ca-ad98-55b1-e49944d3113d@nxp.com>
Date:   Thu, 26 Nov 2020 20:21:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <CAMj1kXGNqY18R7f=oOvrjeboVHVNZ415ASV6EOiwvXU_UKB5fQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.26.141.79]
X-ClientProxiedBy: AM4PR0101CA0053.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::21) To VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.5] (188.26.141.79) by AM4PR0101CA0053.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Thu, 26 Nov 2020 18:21:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e2d3fc98-550c-4fa1-0492-08d892380dfd
X-MS-TrafficTypeDiagnostic: VE1PR04MB7216:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7216AD46FF841E6AE9902A508CF90@VE1PR04MB7216.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ua0Madlr0kb8L61Jbu92O9jzZBC0bY5j8gVdxBIM7GtoHhLDtHSpJDEaw/6PW+hWwJefZnzfGV/uYyVI+7zI5YIIq+A0dnWxLOVix5J4np/7RMaoAgptoTN8YEngncGOESpffmDbHSv1bvm66HKGilLczF5kLTchgtrFNIE2BeaZ80Sc/tFGzmMhoD3jhBi44JcasGsMUeMjFuNklbX+CC10eja+ijLGVc/+qAsVoiTeozuH+xh1CE/NaJBTkriDMDIaGI7mkI1WanYQ8hUsXFIOudOzjykUMVDl4NAIILtOOYHMPQ9YdE5A9BlJpyFKDqLKENSb41WsPDjHBLv9OJnr5XcT/k/5nL2YO7lp3Rohj3OL6LCuLBPdSOn8k0pq1uYdot5Xbr4ARIzQAAnNcdpaPn1yfJUfzwe5384Xhvri3BdcLHOz+J57n9JrrAVm96i93BRsnMiN+vRZR9Hc+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(16576012)(316002)(2906002)(54906003)(52116002)(6486002)(66946007)(26005)(53546011)(31686004)(66556008)(31696002)(6916009)(66476007)(86362001)(8936002)(5660300002)(966005)(44832011)(45080400002)(36756003)(83380400001)(4326008)(478600001)(956004)(6666004)(16526019)(2616005)(186003)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SCtpZThpWkttR0lxc1VkUWZoN1BVL1hsZXRzSW5hdEZxd2VOTGJqSzBGT0lm?=
 =?utf-8?B?aG82T2puYklUaitkSzFYdVlva0ZxODcvbW5UN1VGM0dHU1lpNkZoMjdoQXhS?=
 =?utf-8?B?bmQ2WE9CaWVkYjdadmczV0h6N0pHblIxTUNCcTRNNXZzcnlFcFYvVGMwd055?=
 =?utf-8?B?bDlHZkJNY1d3UnNoL05OTklkT1M3M1hYM1krV2RLR1FHdFpwcDVEVzBtbEsy?=
 =?utf-8?B?Y2V4TmFZclFMNlVjZG5CSFhSNklMMGxlOCtGblpxQXgzRjBFTVNJSFpIT1V4?=
 =?utf-8?B?TWJ5aFZ0cFYzZGhMUks2eTZxUmxmMzMrdlhEWjU4ckV6eFVNZEFUUkFMTlFW?=
 =?utf-8?B?dEwzUlBKVUdsVXRqVThUZFd5MUpzUTYxLzFKQjlxRHZzeXQrYVBiMWhRcE9y?=
 =?utf-8?B?bnJmcGRmbnZLSVNYbENnVTR3eHRFRnRVbUdZWFo2VTNUaUNrYTZGVW9YVm9S?=
 =?utf-8?B?YnFtWmpvUEkreFJ3dENPRXFDKzhnaUlDTndZWGhSNnhyNzNwUkFtNXZjc0J5?=
 =?utf-8?B?c2RXcTdlenkwOUJOa3JSWEN2c1ZZNjQzdTFhRFFzbDFjOEc0aUFHUFVuZDlO?=
 =?utf-8?B?bjJ2eGc0V2NKTGFGbkVGMkJBZkUxQjlLRnlhYUlUNXkyZXRKK2E1UnVlYkcv?=
 =?utf-8?B?cGp1Szc0UlZINlJsOGR3U040dnRzTkpsMjlzL21EMDlGRzd0QXU3YjZqSmc4?=
 =?utf-8?B?SFd5MmxaU2RsalcyR25CdndaZUo5N2tDY1B0R2JzTHA5NzhhWjRHeGdGVjlG?=
 =?utf-8?B?WjBwU0p6dU84UWxNQXBtOTdkV0k3RlE2UzFNbW9QVmZ5RHcrMGYxaVR4aUo1?=
 =?utf-8?B?ejQ5RnpONFZUTlR3bGNQSmNBVCtGd1VWa1ZsTnNiMUNDZG1BUTFYNWI2VDFX?=
 =?utf-8?B?ZkVQakcvTHBPVEYwV21jd3FTR2pSNEJYL0V6cnZBam9IbFdQY093eXhuZjZa?=
 =?utf-8?B?WTVZVlEzTEE4a1FkSlZBZVg1alkrVzRGYllaTUlZcGJFNk1pclBCZzJrS0ts?=
 =?utf-8?B?V0hnZDRaTXV2REt1QmpYOTE4Vi9lS2l2NDFxLys3MXZTNndNWmNCYTExd1JH?=
 =?utf-8?B?dnRWSHU0UkZ0QXRBRTZOYjN0RnhwQ1U4cGpEYTVNL1dXMG53UVBjWlJzRXR0?=
 =?utf-8?B?cmVXNDZ5b1J2TGtrbTM3SFZvVGE1WFVNU0RmSlpIaTZzVlNtOXQ0ZXlkVkNw?=
 =?utf-8?B?aUl2V2d2QWcxMzRjdXkxUi9iUXpsQWZNaURyN0g2TzgwZUFzSkVtRXdFTjcr?=
 =?utf-8?B?MmJDNGZFckpyVE5ucWJ1L1ZyaFpCUHFRU09vMThuTTllc1l0a3JKQ0hEeE1r?=
 =?utf-8?Q?+S75nBIdGbJ/8vc3xiGJK6687mbqt9gapn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d3fc98-550c-4fa1-0492-08d892380dfd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2020 18:21:12.6892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wx89z0PWaBNLoRLa+lCVVVB/zj7+7DwzCg2FfQq9Sawv3NQRmV9T79QwXQAQL4mL2X6TH5wtfsluUt9ELxRRpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/26/2020 7:12 PM, Ard Biesheuvel wrote:
> On Thu, 26 Nov 2020 at 17:00, Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
>>
>> On 11/26/2020 9:09 AM, Ard Biesheuvel wrote:
>>> On Wed, 25 Nov 2020 at 22:39, Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
>>>>
>>>> On 11/25/2020 11:16 PM, Ard Biesheuvel wrote:
>>>>> On Wed, 25 Nov 2020 at 22:14, Iuliana Prodan (OSS)
>>>>> <iuliana.prodan@oss.nxp.com> wrote:
>>>>>>
>>>>>> From: Iuliana Prodan <iuliana.prodan@nxp.com>
>>>>>>
>>>>>> Add the option to allocate the crypto request object plus any extra space
>>>>>> needed by the driver into a DMA-able memory.
>>>>>>
>>>>>> Add CRYPTO_TFM_REQ_DMA flag to be used by backend implementations to
>>>>>> indicate to crypto API the need to allocate GFP_DMA memory
>>>>>> for private contexts of the crypto requests.
>>>>>>
>>>>>
>>>>> These are always directional DMA mappings, right? So why can't we use
>>>>> bounce buffering here?
>>>>>
>>>> The idea was to avoid allocating any memory in crypto drivers.
>>>> We want to be able to use dm-crypt with CAAM, which needs DMA-able
>>>> memory and increasing reqsize is not enough.
>>>
>>> But what does 'needs DMA-able memory' mean? DMA operations are
>>> asynchronous by definition, and so the DMA layer should be able to
>>> allocate bounce buffers when needed. This will cost some performance
>>> in cases where the hardware cannot address all of memory directly, but
>>> this is a consequence of the design, and I don't think we should
>>> burden the generic API with this.
>>>
>> Ard, I believe you're right.
>>
>> In CAAM, for req->src and req->dst, which comes from crypto request, we
>> use DMA mappings without knowing if the memory is DMAable or not.
>>
>> We should do the same for CAAM's hw descriptors commands and link
>> tables. That's the extra memory allocated by increasing reqsize.
>>
> 
> It depends on whether any such mappings are non-directional. But I
> would not expect per-request mappings to be modifiable by both the CPU
> and the device at the same time.
> 
There are bidirectional mappings on req->src (if it's also used for 
output) and IV (if exits).
But, these are not modify by CPU and CAAM at the same time.

> 
>> Horia, do you see any limitations, in CAAM, for not using the above
>> approach?
>>
>>
>>>> It started from here
>>>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flinux-crypto%2F71b6f739-d4a8-8b26-bf78-ce9acf9a0f99%40nxp.com%2FT%2F%23m39684173a2f0f4b83d8bcbec223e98169273d1e4&amp;data=04%7C01%7Ciuliana.prodan%40nxp.com%7Cfdd8e587f49f44821e6d08d8922e8ca9%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637420075916446952%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=x2G4kaWiKVVcOie2yC8JwOpDnPsa3OPO6HpfThqXChE%3D&amp;reserved=0
>>>>
>>>>>> For IPsec use cases, CRYPTO_TFM_REQ_DMA flag is also checked in
>>>>>> esp_alloc_tmp() function for IPv4 and IPv6.
>>>>>>
>>>>>> This series includes an example of how a driver can use
>>>>>> CRYPTO_TFM_REQ_DMA flag while setting reqsize to a larger value
>>>>>> to avoid allocating memory at crypto request runtime.
>>>>>> The extra size needed by the driver is added to the reqsize field
>>>>>> that indicates how much memory could be needed per request.
>>>>>>
>>>>>> Iuliana Prodan (4):
>>>>>>      crypto: add CRYPTO_TFM_REQ_DMA flag
>>>>>>      net: esp: check CRYPTO_TFM_REQ_DMA flag when allocating crypto request
>>>>>>      crypto: caam - avoid allocating memory at crypto request runtime for
>>>>>>        skcipher
>>>>>>      crypto: caam - avoid allocating memory at crypto request runtime for
>>>>>>        aead
>>>>>>
>>>>>>     drivers/crypto/caam/caamalg.c | 130 +++++++++++++++++++++++++---------
>>>>>>     include/crypto/aead.h         |   4 ++
>>>>>>     include/crypto/akcipher.h     |  21 ++++++
>>>>>>     include/crypto/hash.h         |   4 ++
>>>>>>     include/crypto/skcipher.h     |   4 ++
>>>>>>     include/linux/crypto.h        |   1 +
>>>>>>     net/ipv4/esp4.c               |   7 +-
>>>>>>     net/ipv6/esp6.c               |   7 +-
>>>>>>     8 files changed, 144 insertions(+), 34 deletions(-)
>>>>>>
>>>>>> --
>>>>>> 2.17.1
>>>>>>
