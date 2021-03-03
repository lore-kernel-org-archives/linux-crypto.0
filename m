Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19BFC15500
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D266864FD2
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357316AbhCDAHj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:39 -0500
Received: from mail-eopbgr50079.outbound.protection.outlook.com ([40.107.5.79]:34624
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235870AbhCCQFw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 11:05:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VH2LYN/+yDDhTR1fQQq5ZuvAd3MNl9/X14UUeZQ6m/FZzpXd3VpqfMsSfHOOPX5xqgTN6oF7Xl2JMPjw4ej0SWcfRHMgKQ4WWKbsglx/IC55YJOmFlZisaSzti6+ndOThg2qEPZ0zgwBKgGbxh4cXm+YKtnLFbMXlPAAGQKgLWnZ0/bRDLsRiYLXMTOMecT4C34IEjDQhbXMhYZByGBdQ1BnO79qMfxfG3tKHpO2qX3rH1aLFHhcxB63HtQILcrWa1B9vVvFuO0ojATINlhElvWTuSZV1ZSpYkqNrVbZtdWaPIo2oQ4XUZk6+99BK/eeSNG9SurtZNvKOwQpdbjoUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXTAyg/vaUOZs3eq4IaQPZq6AQsOJ4fCdlyJrAR/N/c=;
 b=H+D+sbRN8hko8SJEsXl2GItN8N7TZMWQsOfWvfwdfiraYmuEdiRGYmY6AsnDvDWrrBL0cnSU1W3JPGJy+v8jLFJf8OFPoonyhsHWA2QpANaoJooRyO4EzIGskkg57KbZ4KteJwnRAEE813eJTAcfCKq3vZo/liYYE04sDV0WZhj/Xl05rTWTHEnYXgpjAUZdFsAylulTnAHvWXcBBeFMdQrIJWeoGzho/x8ZEnTPkzqI8orI4hRedDKh7QNiU1MbteqE/zz5p6CUKmihtyZ76BAvd8VmCxrM0Za2yOAdHuVp1dX7gQviU60iJ8wbQqGBnW+VStso0ou8OaWDHpU3kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXTAyg/vaUOZs3eq4IaQPZq6AQsOJ4fCdlyJrAR/N/c=;
 b=gY1cs6OwGjF2+/pXYiVwzBFM+6uHRJFan/blZ6b+/N7zx5Zkp7uz9U6hycI0d6EMw/Nx5TeIMDzsEJBsQ7ZlcJPgwF0IIyPNTzReHlQ4E+9rNVcUujPmyfr4AQFFujFPMyTjh0ixXK+5JyYU1/ww126f7y10n1HmtJqrvJpFGXs=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB6989.eurprd04.prod.outlook.com (2603:10a6:803:131::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 16:04:21 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::29a6:a7ec:c1d:47ba]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::29a6:a7ec:c1d:47ba%5]) with mapi id 15.20.3912.017; Wed, 3 Mar 2021
 16:04:21 +0000
Subject: Re: CAAM: kernel BUG at drivers/crypto/caam/jr.c:230! (and
 dma-coherent query)
To:     Robin Murphy <robin.murphy@arm.com>,
        Sascha Hauer <sha@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20210301152231.GC5549@pengutronix.de>
 <a52e0a0f-a784-2430-4b37-fb9fdcf3692b@nxp.com>
 <a5d6cc26-cd23-7c31-f56e-f6d535ea39b0@arm.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <a1f8b4db-42e3-3719-070b-7e2143134af1@nxp.com>
Date:   Wed, 3 Mar 2021 18:04:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <a5d6cc26-cd23-7c31-f56e-f6d535ea39b0@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR01CA0100.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::41) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.213] (78.97.206.147) by AM0PR01CA0100.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 16:04:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 584ee782-a78a-4d50-4aca-08d8de5e019e
X-MS-TrafficTypeDiagnostic: VI1PR04MB6989:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB698923BA1382D7D388EA265C98989@VI1PR04MB6989.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FFH2GoEdreJqImRJgGt5vzwV6xyrmFfZo7sywUamGE4Scc+LCCBxtifYyuKDf79YaaLh/LI8bZt8FIAaYPmUuw1RDeSSbBiwJ62UlAmWcSmgkXm4VoMFP4uo8FG5biyYbKHoOVJnZqjeN326ljzU7EKdPQkJ6axkREdqRA0Kojo5fdmmbGdQ3HfvyNtOWFqCDXJX/yvgE7MowXp9p914wYGVXzp2L/GT5PKEVRhZr2RQtMEDv3TTY9Z73XYPbQVa7NSYeGZ0j8+Nd9F+9VEl7ZUuL9HlSzs+CSNrCpV6bx+DT/yMh2X/JlhiavuXJb2H98/Av+XJLwGCyW/4WMcoa6SpmIbUS+4MCPp1p58Y7/9JKECmtkP3KEGRpmWbHp4i7Nl96V4Nzw1c5nnqQX0PV+PoAhqtK4EKuceTOhy4yTHxdfcqZrNINFpO+RxfjmcIYw8EglVz7elucBI1xfndqXktDLA2/f+E76OrMChqKEF1wMdoMpGaJ74/XK7TWsBPl6ZAX3KzJg40HJWNZz+Ald/IBui9wdsdrRkUp+EcCFMQe1kjAQ8MgM84o5h/BTTfVPzyyMYeNb2J34MRx36KUxnE2bW44GkxsZ+DKFkU29RkTgWxFfJnv7Ul2ehXZwDqdA2eN6fPS3Ns0UujA+LLCyzEkrP8rw8uaIH61lhNRac=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(83380400001)(45080400002)(54906003)(16576012)(66556008)(66476007)(110136005)(5660300002)(66946007)(316002)(966005)(53546011)(2616005)(16526019)(478600001)(2906002)(186003)(26005)(52116002)(86362001)(31696002)(956004)(8676002)(4326008)(31686004)(8936002)(6486002)(36756003)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U3ZnT0Q3dEV5bGdmL3JSci91cDFkN0dXNHA2TU43MjcxQlBBbXlVRmVGd2ZD?=
 =?utf-8?B?USt0eldnS1lkSFVtT3dQdUVCT0YxSVVxOHVoUy8yblRIemFFSlc4akszRXlO?=
 =?utf-8?B?dkQvRmNmWTJIb3ZpM0RRY3RGVTd6UHFKMzg4RWhoSDl2WXJ1UDROcXppTGN1?=
 =?utf-8?B?eGNYbS9MZDA5dmwvdWVjajl1RW11cmtzVk5oMExnK2JIMHdqaWcyVGhXVkFk?=
 =?utf-8?B?MmM3K2hoTktxbVhkS0JxaUtxTHM3bnJiZTErbGd0MWpOQ1hHRkJ0RGVpL0xQ?=
 =?utf-8?B?MFY0VTAzdU5QdyttZGhmWjVyeFpCVTlyaXJ1WmRJK1ZOM1ZzazZCRE1EcVVV?=
 =?utf-8?B?blY5OEJLS0ozdXIyaElyTU00UXRubC93UXBPdDJiSEJGdkxSdmY0N0xzaHZV?=
 =?utf-8?B?RWpkRnJGRG5XcFoyU3ZWTFYxVGVxRFV6S2xrT2JxaGRldG83aUZCRGJWZ2FG?=
 =?utf-8?B?NEpEMVFJbktFanhEOEdPd3dHUkw4bmdTOHQ5ZGRReHRDTTdBM0JIRE1HTTJy?=
 =?utf-8?B?Y3MvYWw2QUJsU1ZrbmZPaEtPdVE1T0taM0VLQ3dRQlNpaHg3MXZrdFNTc2tv?=
 =?utf-8?B?b1p3N25adjUxdldNYk5GUEt1ekxzdkpaazV0bjNudnRjcG1aZTBrYjdTQW05?=
 =?utf-8?B?UThrVnl1N0lLYWVSWVVEQ1Y5MUFuWTVEa281WVNkWi9KNjJvUjB4dllGalZy?=
 =?utf-8?B?ZFF5TTR4c1gwSEVtdDZuaUw3WEhjWHhSMWFmOVhSZGFSRTUvUExhTmRPbzFi?=
 =?utf-8?B?NTlqd0cxT0JjbnFtVnhSM1VyZ016UkRWZFkzNDFuUGNhWUk0VXN6dGw2NXdU?=
 =?utf-8?B?MFpJUjVxSmVDTWpPRERmRFFVQ2RCTDRJc0pEM1BXdzZvM3hDLzQ4MytGK1k3?=
 =?utf-8?B?RllKQkhMcTNKZFF5VmRRb2hLeW5JeFg1N0pESnRYUmxldzV0SnAwK0ZWK3d2?=
 =?utf-8?B?OFIzT1FwSUM2RjRnWnVUbHR0RWdIdnB1M1VhNHAvVkdMcmhCMnpIOVVFSTlT?=
 =?utf-8?B?RTJaUEZJM2lyNUU3cmlQWWc5OXMwWE1yL0RQd3pkMjFIdm9jRFdLUkZET3E0?=
 =?utf-8?B?TzVjbmRHdEpVbEVIN0FDeUxnRDExQ0tKVFd3djBWalcrS2ZrTm9xeFdleWFB?=
 =?utf-8?B?WXpkTFpkUGEyVnZqcnY3bU1zK3RpQmVURUpMN09xMmt2UEhOMThXR3dpR2pS?=
 =?utf-8?B?WU1QVXdJKzEvSkFFQWJqL1VGblg3S1hxY2Z4cUR4V0grVFZ3UGNuTUE4M243?=
 =?utf-8?B?WWk0YnhyTnpwOVBNNCtxLzVqMVMvbU45SUY1T1J3QXZmSUtGZWtCYlZyRFYw?=
 =?utf-8?B?TEJVNExONmdYOFVLd2RvR3J6QkpSd2hEVDg2ajRDOThDVXQyTHNJN2E5K2xi?=
 =?utf-8?B?a1dCbUtBa253Z0pVMWhKZU4wZmVhWFRsSTFrWis1NFZNajZ6bjV0NldhdGUw?=
 =?utf-8?B?dkdjWCtvcjZRczNnYjlabWM4akhKVjk4eVhZV1JXc1lLTFVZdDFvaFI0aE50?=
 =?utf-8?B?UVBycHBndndtSUo5MjFLd0J0U25VQ1ZhWTRIR1cyYmMwbjJIN0hqMFVHTmpW?=
 =?utf-8?B?R1JvYjNhTlVlcGVVWEM1RXlMTU9SVk9ma3g5d1Baa0creFpsMHV1UG5BM1Jj?=
 =?utf-8?B?K0RkRVZicEFaSFJYNGhvUTRmM1pVTkRCR08xQ29WTzkxdlZhNFZ0d3lURDcv?=
 =?utf-8?B?NkE0QmwvVmtXdXJzZWJJRmk1dVlBRmtuNHB1TmNCNHhabXRTaFI5RDZTdkl1?=
 =?utf-8?Q?0JfE2qq3I8nZ/7aQ1C7eMK8IrYtRLVwFJx54lXb?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 584ee782-a78a-4d50-4aca-08d8de5e019e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 16:04:21.1866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ShZYSaIkHQPHT1w0mH72he0PUMTpCDj8xElqfc9vGr6UgsHIRNSjXO0xEP9lvpDO0FQw6MrrPhzbEFV4isy92Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6989
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/3/2021 2:07 PM, Robin Murphy wrote:
> On 2021-03-03 10:26, Horia Geantă wrote:
>> Adding some people in the loop, maybe they could help in understanding
>> why lack of "dma-coherent" property for a HW-coherent device could lead to
>> unexpected / strange side effects.
>>
>> On 3/1/2021 5:22 PM, Sascha Hauer wrote:
>>> Hi All,
>>>
>>> I am on a Layerscape LS1046a using Linux-5.11. The CAAM driver sometimes
>>> crashes during the run-time self tests with:
>>>
>>>> kernel BUG at drivers/crypto/caam/jr.c:247!
>>>> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
>>>> Modules linked in:
>>>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.11.0-20210225-3-00039-g434215968816-dirty #12
>>>> Hardware name: TQ TQMLS1046A SoM on Arkona AT1130 (C300) board (DT)
>>>> pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
>>>> pc : caam_jr_dequeue+0x98/0x57c
>>>> lr : caam_jr_dequeue+0x98/0x57c
>>>> sp : ffff800010003d50
>>>> x29: ffff800010003d50 x28: ffff8000118d4000
>>>> x27: ffff8000118d4328 x26: 00000000000001f0
>>>> x25: ffff0008022be480 x24: ffff0008022c6410
>>>> x23: 00000000000001f1 x22: ffff8000118d4329
>>>> x21: 0000000000004d80 x20: 00000000000001f1
>>>> x19: 0000000000000001 x18: 0000000000000020
>>>> x17: 0000000000000000 x16: 0000000000000015
>>>> x15: ffff800011690230 x14: 2e2e2e2e2e2e2e2e
>>>> x13: 2e2e2e2e2e2e2020 x12: 3030303030303030
>>>> x11: ffff800011700a38 x10: 00000000fffff000
>>>> x9 : ffff8000100ada30 x8 : ffff8000116a8a38
>>>> x7 : 0000000000000001 x6 : 0000000000000000
>>>> x5 : 0000000000000000 x4 : 0000000000000000
>>>> x3 : 00000000ffffffff x2 : 0000000000000000
>>>> x1 : 0000000000000000 x0 : 0000000000001800
>>>> Call trace:
>>>>   caam_jr_dequeue+0x98/0x57c
>>>>   tasklet_action_common.constprop.0+0x164/0x18c
>>>>   tasklet_action+0x44/0x54
>>>>   __do_softirq+0x160/0x454
>>>>   __irq_exit_rcu+0x164/0x16c
>>>>   irq_exit+0x1c/0x30
>>>>   __handle_domain_irq+0xc0/0x13c
>>>>   gic_handle_irq+0x5c/0xf0
>>>>   el1_irq+0xb4/0x180
>>>>   arch_cpu_idle+0x18/0x30
>>>>   default_idle_call+0x3c/0x1c0
>>>>   do_idle+0x23c/0x274
>>>>   cpu_startup_entry+0x34/0x70
>>>>   rest_init+0xdc/0xec
>>>>   arch_call_rest_init+0x1c/0x28
>>>>   start_kernel+0x4ac/0x4e4
>>>> Code: 91392021 912c2000 d377d8c6 97f24d96 (d4210000)
>>>
>>> The driver iterates over the descriptors in the output ring and matches them
>>> with the ones it has previously queued. If it doesn't find a matching
>>> descriptor it complains with the BUG_ON() seen above. What I see sometimes is
>>> that the address in the output ring is 0x0, the job status in this case is
>>> 0x40000006 (meaning DECO Invalid KEY command). It seems that the CAAM doesn't
>>> write the descriptor address to the output ring at least in some error cases.
>>> When we don't have the descriptor address of the failed descriptor we have no
>>> way to find it in the list of queued descriptors, thus we also can't find the
>>> callback for that descriptor. This looks very unfortunate, anyone else seen
>>> this or has an idea what to do about it?
>>>
>>> I haven't investigated yet which job actually fails and why. Of course that would
>>> be my ultimate goal to find that out.
>>>
>> This looks very similar to an earlier report from Greg.
>> He confirmed that adding "dma-coherent" property to the "crypto" DT node
>> fixes the issue:
>> https://lore.kernel.org/linux-crypto/74f664f5-5433-d322-4789-3c78bdb814d8@kernel.org
>> Patch rebased on v5.11 is at the bottom. Does it work for you too?
>>
>> What I don't understand (and the reason I've postponed upstreaming it) is
>> _why_ exactly this patch is working.
>> I would have expected that a HW-coherent device to work fine even without
>> the "dma-coherent" DT property in the corresponding node.
>> I've found what seems related discussions involving eSDHC, but still I am trying
>> to figure out what's happening. I'd really appreciate a clarification on what
>> could go wrong (e.g. interactions with SW-based cache management etc.):
>> https://lore.kernel.org/linux-mmc/20190916171509.GG25745@shell.armlinux.org.uk
>> https://lore.kernel.org/lkml/20191010083503.250941866@linuxfoundation.org
>> https://lore.kernel.org/linux-mmc/AM7PR04MB688507B5B4D84EB266738891F8320@AM7PR04MB6885.eurprd04.prod.outlook.com
> 
> Consider the flow for a non-coherent DMA_FROM_DEVICE transfer:
> 
> 1: dma_map_page() - cleans and invalidates caches to prevent any dirty 
> lines being written back during the transfer
> 2: CPU cache may prefetch the buffer back in at any time from now on 
> (e.g. if other threads access nearby memory), but that's OK since the 
> CPU must not actually access it until after step 4, and clean lines 
> don't get written back
> 3: device writes to buffer - non-coherent so goes straight to DRAM
> 4: dma_unmap_page() - invalidates caches to discard any clean lines 
> speculatively fetched since step 1
> 5: CPU reads from buffer - fetches new data into cache, all is well
> 
> Now consider what can happen if the device is secretly coherent, but the 
> DMA API still uses the same non-coherent flow:
> 
> 1: dma_map_page() - cleans and invalidates caches to prevent any dirty 
> lines being written back during the transfer
> 2: CPU cache *does* happen to prefetch the buffer back in
> 3: device writes to buffer - write snoop hits in cache so data goes 
> there instead of DRAM
> 4: dma_unmap_page() - invalidates caches, unknowingly destroying new data
> 5: CPU reads from page - fetches whatever old data was cleaned to DRAM 
> in step 1, hilarity ensues.
> 
> Note that it still *can* work out OK in the (likely) case that the 
> prefetch at step 2 doesn't happen, so in step 3 the snoop doesn't hit 
> and the data does end up going to DRAM, or (less likely) the updated 
> dirty lines are naturally evicted and written back between steps 3 and 4.
> 
> Similarly, if a buffer is mmap'ed to userspace (or remapped for coherent 
> DMA) with non-cacheable attributes on the assumption that the device is 
> non-coherent - the cacheable alias from the kernel linear map can still 
> be present in caches, so coherent device accesses can unexpectedly hit 
> that and fail to observe CPU reads and writes going straight to/from 
> DRAM via the non-cacheable alias. We hit this case with Panfrost on some 
> Amlogic platforms not too long ago.
> 
> Hope that helps clarify things.
> 
Thanks Robin.
Indeed this example shows how things can go awry.

Horia
