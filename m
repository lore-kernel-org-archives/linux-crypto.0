Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5BB2C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 13:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 930A0233ED
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 13:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgLGNus (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:50:48 -0500
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:64215
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726263AbgLGNur (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 08:50:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgnfxlE3dJ6nkF3k1boNsBOJKSWJUhZ6ehsUnQDwjldeGsNWDp8mkQIZC53oKW0jiwYNOmF2JnifNAAogPzA7FTSdWsDN8J/8RPo/xDezEwxus1CHbD0UPGXnMnnnkcKonosDLEucRxzkldo0+rw3is6AyJjUUvA9RYFOdU16/VVAAZMIBIxSyppsxMPltVPZct6xSxvEvq4rjMEYAhO90tGngdi2p15JHSrb2fYEGZvdBaXmf1xoPpHqe5szvxZhOMwYL8KcDADyOA8xMBEAYPIQuCtFMpgnbj57vfKbnlLx3zgcJlSeEpl+48zeapDxKPgMJ/g68SjB7zLz9Y6Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DRXR6B0cDi8YtCe3y2fF1ZlTXpJ2YNO/kjha88KaZU=;
 b=k3LmmajcVrRjV8IZkMrelbAdNHIhEhMjTIVWgSd0ZGJKlCBvUFPi0mQqnZamavGU0CvKEtI53ZKWvuLwVXkBFSQQ3XZ68eXILWag7677hSe4e023uaZ42xxyTMX/My8VbN71DCOEv8ZSmoyVTubkQvc+VLIALUkrlvAf0wAUjnT2ejlr2IdaSru/EVyOkG68nhOmAjkvk5KJYMq7FrbkNu2HRyD5jbI6ii7ncNeSiHNt788S9M0J5LZy4Ma82yVetIms06WZfV8rmbfAP65tTLsqOnjmRdfEn892uydKxHTK4OFg0Gwfkg2MgozjbhT6USt4FJHwHD1DlixMxhHpjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DRXR6B0cDi8YtCe3y2fF1ZlTXpJ2YNO/kjha88KaZU=;
 b=KxERO9FYq98pHx/gjKD50AII6Cke+63PP8GArWvcrJlaRzLaG2aoG9oiu5Fp++Lotp7RWSKviQpk+/Y7N75PatK0Ma/WRcFgWrUOLhE05ZftYByw8GiXyeto00jXwRRHCVTNNJIpL2MlW1hH6h5Gk406B68ApSBv9W5mG0usJwg=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB7085.eurprd04.prod.outlook.com (2603:10a6:800:122::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Mon, 7 Dec
 2020 13:49:58 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3cd1:fe15:f8d4:ac32]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3cd1:fe15:f8d4:ac32%5]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 13:49:58 +0000
Subject: Re: [RFC PATCH 0/4] crypto: add CRYPTO_TFM_REQ_DMA flag
To:     Ard Biesheuvel <ardb@kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
 <CAMj1kXH=gyCz7NQXaAoNC4cf37t9E8znngyLFVPv+dO79=Z9oQ@mail.gmail.com>
 <20b1493d-bfb6-d0bc-3b73-740b216db5f2@nxp.com>
 <CAMj1kXGBa7st9duOu1Z1y28_-Xci3ur7kevAP+pPFp6+xvcy2Q@mail.gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <6ab2e280-a699-67c6-2066-af0b7ea9b709@nxp.com>
Date:   Mon, 7 Dec 2020 15:49:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <CAMj1kXGBa7st9duOu1Z1y28_-Xci3ur7kevAP+pPFp6+xvcy2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR01CA0122.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::27) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR01CA0122.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Mon, 7 Dec 2020 13:49:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f19273e-4c5b-4c93-6f29-08d89ab6fc82
X-MS-TrafficTypeDiagnostic: VI1PR04MB7085:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB70852A86B28FFB948825B09798CE0@VI1PR04MB7085.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rYOfU84aqMCApxf796vq1lwVQfwkQ5gdR2exArBihbr56/kfnDvMJcUGXzJHfQ4GNnTvbUVKljl/pK89hIuA6+nGu8AV4Q29uFDCYHISF5y27QQ6Djqwnq9ME8rgKoBvi+LcgliARw63kctKo0LK65o0C0iFg0DR0mPykAR8HY8kcDwnh5IZVnwrM5tVYEtb9YurxtLsZB7I3wMLQzbIIZMLwMtqy3x91potaE9EhWvTPAuPQEUtzP4xWUH+YqtemDFAiEP0MUFKFK5lMECBntzBqvlXflzxvtDxhCa0UUe0zBxgh9ubqKPNw0N3i4UXior8FGeQIhhvZNvYgBClgYGvEbCvtuw+f88nsEDMxPUzWnYd9FsNrIzcpf2VqxN1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(66556008)(4326008)(956004)(36756003)(8936002)(8676002)(6636002)(6486002)(31686004)(83380400001)(2906002)(16576012)(53546011)(316002)(66476007)(5660300002)(2616005)(54906003)(66946007)(31696002)(26005)(110136005)(86362001)(52116002)(16526019)(478600001)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RXVvUndCZWJYUHp6bVp4bndjZnNLRVhBN2tla3FLb0E3bjg4SWJpSXJTaUll?=
 =?utf-8?B?RXBqVG9Qa1VMaUEraWE4Q0lzNXlSV3dyNk5LZUd1V2lFSWVTTGkxT1lFZ3M1?=
 =?utf-8?B?UHRNNGFtZ3hYVVE1VkZJTE5QdzRhOVlpNlhyUUVxeUYzMjRzU2p4ckRkRWJI?=
 =?utf-8?B?YmlFZmNHSlhXQm5scmF3N0prbmg5SjlReE9JenpVOEdlNUtuaFJaVlRSalRW?=
 =?utf-8?B?eE1McUpHSGFRZTlvTkVjK21nck1Vd0E1T3RhYWVxeGYwS2tpY1pQUWpDelNo?=
 =?utf-8?B?K3pqbG1nUzc3NUlOOGlzbFhxOThmUlF0N3JDcldJSFQ3eE9kd05uOWN2bGc1?=
 =?utf-8?B?NkRha1JiWVZNYWsvTEtxcGpiZkRnQTE0S3VJQkhzK21Ed1ZWSU1JV09GdjFJ?=
 =?utf-8?B?THBjZSs3Mk9LN0sxRmJ3UEJ1V0RXSXp0VDVKdXVFbEtZMm9tMjRvcUtEbWFL?=
 =?utf-8?B?TXNnS0hESS9HU2RZUG9xZlRseWx6R3FyeU01bjR2UEVqMEZrRWlhc1Z3ZU5m?=
 =?utf-8?B?ZFJyS1lBcUxOU3lYV3ovK0Y1ZE15SitJM0I3Vml5S2l5ZUJ6eVlQT2FJeEZI?=
 =?utf-8?B?cGpkVUVCbmJTbXN1RkNtZzVpRDVvUzlUcFRDaHpQL2RCQnM5ZGFYV2kyNW1o?=
 =?utf-8?B?UG5VRmRIQ3Axa0x6bFZyWFN0bEpCVjRaNUFUbnlFbHNsMFNqSWVsSmRWKytk?=
 =?utf-8?B?Q29Va0NtUlFlUWR0aFF3Rno0QWpkMTJrKzNxcFhhYzFjRjVSM2lua0dVeWZO?=
 =?utf-8?B?d3NRMm85Y3hOUlZGNEpLNFQ1SEEzK2Y2Tm53a1dINFdxSVl6enVWMlpPOW9n?=
 =?utf-8?B?TVNCNUFiNGhDcW5jU1JlT2ZlUmorQ0hTYUgzUHQ3Q1NISlorcnptdDJkVWhT?=
 =?utf-8?B?SkFmYnNYVk45TG5GL0hXOWpWdHhLQm1zWnVpTysxTU5vZWZwY2Z3SFg4RUFv?=
 =?utf-8?B?dzdrS2xlL2ZIZGltMGV5eGk1QjZ5ZlpvSW5tS1ltblQ3M0FGY0RSek02R0pN?=
 =?utf-8?B?S2NpUVpsdHZENVk3SDk1ZUM5RjdoME9DbGpWYnVnWEs2RFl2Z2J1Q3B5c29y?=
 =?utf-8?B?ZVJFb3NwSVlIaXU0VVBtQzlsUXp1TGdRYVdFT0xDREV1N2FSY1ZLTzVKL3U1?=
 =?utf-8?B?VVRuYW1QKzB6VkhiRlVYcDZnT1ViL3FnN3k0RkI5WEZkZlRoL09FeFEzbXVE?=
 =?utf-8?B?cWF4Yk5YZEZrT0pIKzI0d0lJNEVMUy9aVmpKNDJ1YXArZ0Vad1FRd1Y4K0M2?=
 =?utf-8?B?TWFrZkpJU24rMXd4bUtrYlBnbnIzd05EKzNGN2Z1YWpTblNVVkhzdzBrbWZr?=
 =?utf-8?Q?MfI0051IoBAFomG52CsGeUB1FFBRubedju?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f19273e-4c5b-4c93-6f29-08d89ab6fc82
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 13:49:58.6505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+f6wL0F5GbT8XJ5OkaGEsQ5T/xKB3TTZnpDxt8icYuOx8tpwU+XJANudadUMeW50ZbYcJtnq9pix+TpzpOC3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7085
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/26/2020 9:09 AM, Ard Biesheuvel wrote:
> On Wed, 25 Nov 2020 at 22:39, Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
>>
>> On 11/25/2020 11:16 PM, Ard Biesheuvel wrote:
>>> On Wed, 25 Nov 2020 at 22:14, Iuliana Prodan (OSS)
>>> <iuliana.prodan@oss.nxp.com> wrote:
>>>>
>>>> From: Iuliana Prodan <iuliana.prodan@nxp.com>
>>>>
>>>> Add the option to allocate the crypto request object plus any extra space
>>>> needed by the driver into a DMA-able memory.
>>>>
>>>> Add CRYPTO_TFM_REQ_DMA flag to be used by backend implementations to
>>>> indicate to crypto API the need to allocate GFP_DMA memory
>>>> for private contexts of the crypto requests.
>>>>
>>>
>>> These are always directional DMA mappings, right? So why can't we use
>>> bounce buffering here?
>>>
>> The idea was to avoid allocating any memory in crypto drivers.
>> We want to be able to use dm-crypt with CAAM, which needs DMA-able
>> memory and increasing reqsize is not enough.
> 
> But what does 'needs DMA-able memory' mean? DMA operations are
> asynchronous by definition, and so the DMA layer should be able to
> allocate bounce buffers when needed. This will cost some performance
> in cases where the hardware cannot address all of memory directly, but
> this is a consequence of the design, and I don't think we should
> burden the generic API with this.
> 
The performance loss due to bounce buffering is non-negligible.
Previous experiments we did showed a 35% gain (when forcing all data,
including I/O buffers, in ZONE_DMA32).

I don't have the exact numbers for bounce buffering introduced by allowing
only by the control data structures (descriptors etc.) in high memory,
but I don't think it's fair to easily dismiss this topic,
given the big performance drop and relatively low impact
on the generic API.

Thanks,
Horia
