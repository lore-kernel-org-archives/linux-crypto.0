Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D75AC15502
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0C7764F4B
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353455AbhCDAHq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:46 -0500
Received: from mail-db8eur05on2065.outbound.protection.outlook.com ([40.107.20.65]:37408
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233805AbhCCQlk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 11:41:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amUqqIA8CF4AoC/g9eo9J9AqJ6B0LukDHfQ0FeZq9yq3DsegCjGrdHD53H7RUgYloHX9meHCj6GmJL0o3ePoY3RZThJW369qGxfXFg5OpjfFWQoPFEUtaD1t16Qq0s+u4vXUaOyywWPJF4YUI/Poc7rl3yunOejuuuq1AkHQ1czRTjrr+8DUGzRKIL2/EH+BOCc9mywc8pzm18ILlVduQvgv3+9977DGVv8zvy81DKxqOz8Q0yMm9z5nDCid4Fpjo+U94G0noIk6QoXeu625q8bv9JY9oA1fJWFx/mvu+C6DNep30NtmtFJGcH3u5eNtuS7vMvxI+98wWlEyunP8bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1FsJgXlj5kUtWbMijNPCXJ2zjpSXHjnmrtSyRIcnrg=;
 b=kMw6hJJht3rXG8g3POLoV5Eosti6Dm+JrUcZbSjRJT7Cl9QwN/TijBwXM1czUKf3er2weDnqJCzVb+8Pllh0Ygj7DY1RdIGxkirpH8rHsTfkxYYYO6Aa2r8NWjwWwTX5n8ZAC38lZ1dfwF85ydIISIOn4vzdVhNAT1Q1Dt5xJXII+lq1hMq65IH5b9vKQr7K3kBAQzeCIY1993+ScMArVJnRB+ngF3b+CkBnXwSfYTyn3d76dWR7Lhv6M6G0MjsuoSwAxshSgSt/mbE/AbHLpR+oVqXf3mPfTIwziiqPzBvIn82MLdOqcFR1/Md4v8WwCbOVAV7E1a+/HgyhS4qAfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1FsJgXlj5kUtWbMijNPCXJ2zjpSXHjnmrtSyRIcnrg=;
 b=PXP5wCmOqOczXsUkfUhnsLPB57oBh15agUwp7AcnhKw/ZOf8s77Brc50wENhLJpyvjnr0fu6knEhU96I3LrJhX+tAHnUZZhcgYsmkOm3HF+eq1Xb3q/jopZ2jRQfR9BGk6u9shSnIZv5L9qHGxcn246UxvjyuF3UYsoC5rfjzgg=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB3310.eurprd04.prod.outlook.com (2603:10a6:802:11::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Wed, 3 Mar
 2021 16:40:43 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::29a6:a7ec:c1d:47ba]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::29a6:a7ec:c1d:47ba%5]) with mapi id 15.20.3912.017; Wed, 3 Mar 2021
 16:40:43 +0000
Subject: Re: CAAM: kernel BUG at drivers/crypto/caam/jr.c:230! (and
 dma-coherent query)
To:     Sascha Hauer <sha@pengutronix.de>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Greg Ungerer <gerg@linux-m68k.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <20210301152231.GC5549@pengutronix.de>
 <a52e0a0f-a784-2430-4b37-fb9fdcf3692b@nxp.com>
 <20210303145656.GL5549@pengutronix.de>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <0103a43a-382d-0d71-a6ea-ead3d7ab7041@nxp.com>
Date:   Wed, 3 Mar 2021 18:40:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210303145656.GL5549@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:208:be::49) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.213] (78.97.206.147) by AM0PR04CA0108.eurprd04.prod.outlook.com (2603:10a6:208:be::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 16:40:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7e63b893-e9b9-47b9-afce-08d8de63161d
X-MS-TrafficTypeDiagnostic: VI1PR04MB3310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB331010DFE7BAD0EFF795440E98989@VI1PR04MB3310.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Di5ACUMhBoHItB50B/LMR5nbwpZWT328HikzCeUA6/TyM7K0re+4dXMH3wzTTbGK2U9G5D4+VrTNPlkwqnf4+jxDT/JXSWcS0uD55N3vVVDS8Z8loZw0tkaJrlTtkxOc6eJwjcISQ96kFa30hxLPX3KgsL800F3ajpCOh/PjmtDHRJBH5PVtKT/6c4h2XzMkB7MBSedh04G2fPy1Otj268k1EUwcvWehaH5+x0Q8+0weoJPpZxgljXllOWSa+/FOZOko9MCEb6oIO+Bz5Lc5hSyiD6O7eLaqOQVKD9/MSJKVlpVeo3cnQeVjp+ACB64Zr3GRZW02fFEliijKrHUatbiXjvA1ZuSUBXbH+zIfkRDbiPvUHQPlx9gUHDVNpfbLKBl++SJfuAXAnf53/IxH2dd4973800/ckmJHSxu6/wwy4hcM47QffY7o4vmOtvKvvo7pCrSjxXMfz9HyFmbkp46d4RJPEEuzG6vNLKTesYT6mevDHy9AIhK/Td7laRfcx3hD0AcerBCm8S8BH7hmbRCIy/pCrZ6kQmkRa9VfpwIdj6glSxmiT0GceQvXxg7d6BjhguoyaZpoKgQffpbFqivE45rS8BR+21d6uqMBMvvrpLNAEQqYjp1I56AlS+HaAg+L4C1d+87Tz1e4+VAQjENuiEuFulxXb+wjBa5y3WtLg+gpojtL+XnQPsvIWGx/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(54906003)(52116002)(7416002)(66946007)(83380400001)(8936002)(86362001)(8676002)(66476007)(36756003)(66556008)(53546011)(26005)(16526019)(2906002)(31686004)(4326008)(316002)(6486002)(186003)(2616005)(45080400002)(16576012)(6916009)(478600001)(956004)(5660300002)(31696002)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L1d0WlhWN2pUc3hUTjRJL2cxQUhQcVRnWk13bnZDVGRrU2J2ekc4ejFBcnQx?=
 =?utf-8?B?WGFEanc4YzNpYmFTYkdMV250OWpaZW9SZkF5SmRrK2lvRGxGQVVzdmNYN2xR?=
 =?utf-8?B?ck5uUjRqRS9xZTNVVTNRWkhQcStlWEJnMjRhVWtiWFNxVGE3bDhJa25Bajl5?=
 =?utf-8?B?RHBVellVLzF6dnZFblF0enI4YnVPVDF0dWNCQXN2ZnVWWGI3R2dJemQ4ZTlR?=
 =?utf-8?B?bG9wRHl0S0s1NUdPQ3JLYjhRaGVkaFZ0cVRrVDd3NWNoTnpTYnVtc3ZreWxX?=
 =?utf-8?B?QmR2L2t1S0lDdVNSRHFMRk1wczI1UlhEYVR5ZmVHVk14UmYxYitwWXE4VmZP?=
 =?utf-8?B?cDNXMDBSc1Zjb3hUcjViUXIvVTlQVVVFTDdOQXN3a3JFekJMeGd1WTlLbWdE?=
 =?utf-8?B?YXh6TjZwcXhhREM0bHl1R2t2QUJuUUZxdTlDTStpVlR6alBWT0J1S0dIMXpl?=
 =?utf-8?B?aTNjTFBLbEJDc2o4TEJ0dnNTdStNejE5elg1Z0J3QmNLeVArNlhFRzhqWUUz?=
 =?utf-8?B?QkdyWnhybjR2VFBpVlREWXVCZVhkZ0FjejBncW1nOU5SV3JKVmV3RU9URFFM?=
 =?utf-8?B?MmFWVzZoMW9KOGFHN2tUeWxtcG1FNHpXTXF1YUVUeVZiVnNzUU02SjJsbkQr?=
 =?utf-8?B?RUlHQnVJTllkbnFNR0tsNk8xS1ZobTJlWUI5bTlBa0lTamduR29YUU5MMTRy?=
 =?utf-8?B?L3Z0QTYrd2xlUFY1UTVJNi9QbEZIK3RkQmh1WHJzNlhsYlUraC84dDIxRGpF?=
 =?utf-8?B?L0duRWlNYW5GZDBwbjV4bFh1QkdkMzVpV0VFdW44Q1podk9EdlQrT1FVOFBv?=
 =?utf-8?B?SFFrSUxiayszUFRJdm1IR0RmSG9iQ2lZTzBXUU50eGxIL1JEbndRUytGaC9W?=
 =?utf-8?B?WFZFa3ZuOHZFcG9FalJaQnFNMC96NXdoNEdTY09oRUZzM0h0a1ZhK29RNlk0?=
 =?utf-8?B?UDhXZEZQNkZHUWgvR0JlZHNOR2VyM3M5clhLWXNncnR6Tnk2eFVzTEg2M2Fh?=
 =?utf-8?B?NWdWRG0vbVhBM210aFZ1RUJ5SWkvbXhkTEcwcUcydzNKOUZERGc3QkRLbms5?=
 =?utf-8?B?N3N2UHovNktJR0hmelNVMVdHMXh6dGRSZUs4R2dsTS9iM01ycnFyRTNtYmdx?=
 =?utf-8?B?YTRtNzBKWmdIMFJuOUlacFQxTytjY3pJb0crbEpGQlFYWERzSnZ3VlRyYzFS?=
 =?utf-8?B?bkNNYkFWbFlaRE11aXFRRkErQTBzYlZKUVdaeWI0dkNhdlVjQXQrV1BaV2FM?=
 =?utf-8?B?RXJtSFFLT2hoWEhoUDVtMWd0eGQ0Q0g0UmpiTy8xRHZ2OWJTaWw4bG8vYnd3?=
 =?utf-8?B?blJsTTYvKy9qOGlNSTY2bmNEakh0U0lROFgwYURiRGFFNW9sRi9jbUc1ZWRZ?=
 =?utf-8?B?Y2dIN1VMaUhwY2NTQWkzVzdOQWx2MUpQK0FIcVovRjB1QXJoNU9NRURqQXZJ?=
 =?utf-8?B?b01YMUJFRVRUNzhIMmtWcUF4MzZLZ200TWVGZTBoU1B0TVNwWnBoYWpMeHly?=
 =?utf-8?B?NTFlUEZ1Sk5mNzZiYTRuV1l0YzZIZVljZzB0WUM5OEc4WHRDSnY1Zm9hR2tJ?=
 =?utf-8?B?eVVxYkdLdXBPOUtMKzNDdDZVcTJQWFRnR1pHdmVLMi9VRXpDZzdNMjFpZTZG?=
 =?utf-8?B?cDJ4c3V2aWVFREc4NnAwa0lUdjMvNk1WcHJjTC9ZY3JaZk55aXBLb0lwdGNl?=
 =?utf-8?B?QnNGNVlnemNHZWVKM2R4a1VaSWQ0cFZNbXJ0M2hkendyZlRWeDhNNWtpU2dF?=
 =?utf-8?Q?Gw0MdnKHDBGmhFwYgzj1kPvqBpfakuXPZYTPQQ2?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e63b893-e9b9-47b9-afce-08d8de63161d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 16:40:42.9986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4kVwhflvmKPo9Qey3Y9s6UQuMz9G5WHuyFjv6HCjc4auEpdLckIRRz+2uR+FPE01tqFXSdiMYP4BuodYTOtbqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3310
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/3/2021 4:57 PM, Sascha Hauer wrote:
> On Wed, Mar 03, 2021 at 12:26:32PM +0200, Horia Geantă wrote:
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
>>>>  caam_jr_dequeue+0x98/0x57c
>>>>  tasklet_action_common.constprop.0+0x164/0x18c
>>>>  tasklet_action+0x44/0x54
>>>>  __do_softirq+0x160/0x454
>>>>  __irq_exit_rcu+0x164/0x16c
>>>>  irq_exit+0x1c/0x30
>>>>  __handle_domain_irq+0xc0/0x13c
>>>>  gic_handle_irq+0x5c/0xf0
>>>>  el1_irq+0xb4/0x180
>>>>  arch_cpu_idle+0x18/0x30
>>>>  default_idle_call+0x3c/0x1c0
>>>>  do_idle+0x23c/0x274
>>>>  cpu_startup_entry+0x34/0x70
>>>>  rest_init+0xdc/0xec
>>>>  arch_call_rest_init+0x1c/0x28
>>>>  start_kernel+0x4ac/0x4e4
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
> 
> Indeed this seems to solve it for me as well, you can add my
> 
> Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
Thanks!
I'll append the tag to the formally submitted patch.

> However, there seem to be two problems: First that "DECO Invalid KEY
> command" actually occurs and second that the deqeueue code currently
> can't handle a NULL pointer in the output ring.
Currently the dequeue code BUGs not only for "NULL pointer", but for any
IOVA in the output ring that is not matched with an entry in the "shadow"
(SW) ring.
Here the BUG_ON() should be replaced with WARN_ON since not finding a match
means driver can't go to the "SW context" and eventually call complete()
to wake up the crypto API user. In many cases the user relies on
crypto_wait_req(), which does not time out and is not killable.

> Do you think that the occurence of a NULL pointer is also a coherency
> issue?
> 
I strongly believe there's a single problem because the issue goes away
when the patch is applied, even though I haven't figured out what is
the exact place / data structure that gets corrupted.

One theory is that corruption occurs in the input ring:
-CPU sets up correctly the input ring entry
-device doesn't see the "fresh" data, reading 0x0 for the descriptor address
-device reads the descriptor commands from address 0x0 and issues
"DECO invalid KEY command" (note that KEY command opcode is b'00000, so reading
all zeros from address 0x0 would lead to this error)

But then the input & output rings are allocated using dma_alloc_coherent(),
so I'll need to check if lack of "dma-coherent" DT property has the same
effect on consistent DMA mappings as on streaming DMA mappings.

Horia
