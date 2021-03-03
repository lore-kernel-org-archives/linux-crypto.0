Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95979C4161F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79CF664F3A
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356795AbhCDAHQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:16 -0500
Received: from mail-vi1eur05on2068.outbound.protection.outlook.com ([40.107.21.68]:3169
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238819AbhCCK1Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 05:27:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVIqvpbn7ZgySHDpDuATbBiF0xvxKbWV77BngEIXroZPqtE/L0YszMo+Zc2PMBPnoFak1RZbOdDCAys92eNJTfPLPyKz/74Cyl38CBtyGLDJj+f0HNYJuknRBract+3rO3UrgfHrQJomsC4WbKRI+Vk6YC/ZSBB9z7vMfaIftdjyYyTMA6IhqeSuC/mAyaHP6CyqPk1inquZMOGfFJqDYbMEvCb4cLrIDdJnWKSSwl1Kp0EdxR0S8C5UUvdiq4GuDqSxEZdKWpAx46agcK/xt1/FmgX26GNux8PzbDI58l5p5XzVQGzxdC2qYYSr2wNSCpOmzL8ouYS+o0N390Llvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9lFXCfyq5FtYrHqcZNlIUcYB53K2WNRT86q51SnmoY=;
 b=C3nq68vmA8rCRd5pZQd/lDoipg5TgxQHwBffHRJmgjIyOIjr24m3GsQeR/w3NHLa2VHqBzpRv/HUktax8/A5PIL8lC8FULBFC3BbT2RpVnFMb2q56rBPvZUC5q2bi7fNstpsBuB8Ch1Tkj+tNo/5TDi2mQylXNfwl6whK1UPbqJqpW+TNLzLUPezVolNHt6v5k7tdr8GiabhJgomCuw+tLsllfJLIR2pDrY/Atd5vPxTABFJAV8/guqiEcBpHtTDGaZR/xJ6t71tUAfXM9lqHb0a034xOofXuraHf2GBbHJivooliX5eMfpmRl6PDbb4dsYteSKHp86xF+3LOUSKcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9lFXCfyq5FtYrHqcZNlIUcYB53K2WNRT86q51SnmoY=;
 b=aUB+73M3rs3RGgDL0wB9sg3Hf3keuNC7P26kUPpccXBGE/ytAQisDqRYbErTTEZqcebX4NqRjHe7SzMmfzXOHfmSVPdZ3N4Z3bcRW7qjRfs6rqU09B4EyqGn5LneH2PW3NjUDPVfuYM+ZLyNywwD7wqo1epbN4/weh71NQvgHLY=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB4592.eurprd04.prod.outlook.com (2603:10a6:803:75::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Wed, 3 Mar
 2021 10:26:35 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::29a6:a7ec:c1d:47ba]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::29a6:a7ec:c1d:47ba%5]) with mapi id 15.20.3912.017; Wed, 3 Mar 2021
 10:26:35 +0000
Subject: Re: CAAM: kernel BUG at drivers/crypto/caam/jr.c:230! (and
 dma-coherent query)
To:     Sascha Hauer <sha@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20210301152231.GC5549@pengutronix.de>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <a52e0a0f-a784-2430-4b37-fb9fdcf3692b@nxp.com>
Date:   Wed, 3 Mar 2021 12:26:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210301152231.GC5549@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12)
 To VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.213] (78.97.206.147) by FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.16 via Frontend Transport; Wed, 3 Mar 2021 10:26:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 92fad99b-3647-4a12-288c-08d8de2ed27d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB45920E6A3005B188BC3290A198989@VI1PR04MB4592.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +KHEN9RS1gm1/ehLQkHe0U5mbW/0k1jOuSkbQsJB5slUPvP4TtK5fEDM1dJjTgyzXgJ7yQuKJDAFXau4B0s3G1y7ZjYEbvGqM+hlOUfRTio13iiElRXqEaRm9u+V+GDHbOCgVTrdTZFtwEw4A/kQXcMAR07APR0Lls4Kds6vwkXdYCXLpjlN2YwZg7x8TsneHQzMIk5jqNmJEOTjN/54K7vDQnsopRjgWVYqKCyMbi7zKprse6gUHkzfamBU6WqedKgy0MMAsGov9u7N5ggJO/iUfhpQ15TYWyF7j4atvOQSxsbBaPYQLKhi8cMpxLGEwXyw4LnZsh0WMRE2FzBjasWG0Mx3ZViyypiDtKGQFQHuS6Eqrnlczel3YkjADuE2QLkkK3VhGRvQzdji8GjzsmiSZVVPN+RtijMsxJKv+0dxsyownPVzoy8DNnklset4Emxw4Ka8MDSfQhagNGm/D5utEQrTBNS6Su+E0m/qTByGtwTwVQXwE4QEuDSErfBdGHyChNzTrQtCtE9qujGw8CYvUmsJCIIOpLu2e3FP5oBeQnSgbou3Q6BY9z75Gg1zx9xFNdSzZipL4tuZIYQphn56GhPlpP36fmZmCgztK8L/V3y8hv5KpieeMBYvaGeHx9F8oVK2pDSuh3GXq/9tc1smV2zhsxi1H6EKkF2j+8k+9yKhHCNGHsmYhOZaUwnd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(7416002)(31686004)(83380400001)(8676002)(2906002)(45080400002)(66946007)(8936002)(4326008)(186003)(16526019)(26005)(52116002)(66556008)(54906003)(2616005)(5660300002)(66476007)(478600001)(36756003)(956004)(53546011)(966005)(86362001)(31696002)(6486002)(16576012)(110136005)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cDJZalVzbko4RWUyR3U5Q2RWTXZyVllVbDlqUXhYOFg3TDRha2sydUJkY0Ju?=
 =?utf-8?B?TUt0bkQ5WmNzb01XaFNCVGdVMWNMYVA0ZkZ4OEljYUllQ3BqQkZVVkJVMUNN?=
 =?utf-8?B?L21VSldoYndWLzFyUUJuc1dPZEJVQ0ZkY0lpQkxVblNTOXp6L2cyTG96ZXJl?=
 =?utf-8?B?TlhPV2NVd0F2bnZLV3lkcXh1Q2xmY0JaeHZhQ1NpMEM2UmtIbmZuVmJxeXZN?=
 =?utf-8?B?UE5Fa1RzZSszNFdTOEp3OWQ4NW15RFRxcVJEWWRVbUl4ZGxjK054QnBYb1Bi?=
 =?utf-8?B?dmdzQmxJeC90Skp3dkVDUXRCVy9IWEhndTRzcTV5a1FKT0FlUUxBeS9Cdjhp?=
 =?utf-8?B?SHRHaU9Oc09MZW8wcEY4TXNmUVB1d2tCekJBNGZkWDFXN3Z1bm5mMnRXMEk5?=
 =?utf-8?B?Mm1MT3JPVWVWMVdPb0x0WEJ0aStqdFJxQ1RaRkJWaE5YN2JUdU1nS1FUVmdT?=
 =?utf-8?B?Y2JWZXZHSEttb0lMUWdSLzVRbGdDRnpKbUJUemZEa1BVd2lkTUVMMEdiU1dR?=
 =?utf-8?B?RGZCSEdDSWV3aVNSTHZENUVQeWtoVk1pSEkxdWVTc09oYTkyVkVpZ0VGNkVH?=
 =?utf-8?B?NkttRmpmNGNRaGdYbWthQmJ3NWZlUzJzcGxBQSt3RGVvendIS28rbEdGOXd4?=
 =?utf-8?B?dzFOc3dzRWJoc1hqbzE1Q3JDT3pTSFBNSUJCc2RxamFQdjB6akNRYWVwN1VP?=
 =?utf-8?B?VzA2cTZjOEszR2wxMjU4dUEzdmRWRjBLWHY1S0dEYVB2cUxGY3ZHRENKOXB0?=
 =?utf-8?B?WG9pbHZwRk1aRFV1RHVTTE5jU3F5KytScVk2TFVicXQ5R1ZoanlFL204QTBw?=
 =?utf-8?B?NzE0NHowa2N4bERKeGxyYmFHTlpZbUs0YlRrK0V5ZHlsaU10ejgxd2t1OWt4?=
 =?utf-8?B?UW05MHZJQVF2UlUxaEVCSlBWQktpdnE0N0I5QnNHQjJQak4rR0dIRUtXY3Fr?=
 =?utf-8?B?bUk0WlBuR3dmSGNYZ1pSRjJUS0RzV2x4eEVlNlVtRWhJYVZobkJLWTJESE81?=
 =?utf-8?B?OGpSWDBlSTkxeVBuODdIYWZpRDFBT1hIL29oZVZUNVNjV3NtUDdhb3E4bGxN?=
 =?utf-8?B?elJyVnh6RU04WmZuSHFJeHNPZnVVc1loNEFqVWpPU3I0VDZDUWJyaUlyQ0Rk?=
 =?utf-8?B?WWN0ZXg4c0JuWlcvRVdHWlY1NlNuK3pOb0ZZZ2NZL1JNTWRQK1Q1cTF0UE1p?=
 =?utf-8?B?OTg2ZUc0NHFQaFQ3K3RmajlNZVJVeGEzRHljczJNS3NSaGtoZ0kzWUVvWGVj?=
 =?utf-8?B?VWNFRUdmQnZNdG5XdkRXVkdselpPVmliNGRGOEZUR1pyKzVqbk94VUFCejFm?=
 =?utf-8?B?NlVkS1RWeGdodU8ydVNpT2loNlo2S2MxNkJ2NFhEWnFnTXplaGVnNlB3UmZF?=
 =?utf-8?B?U1pHbVRaN0hPVENUOExUcGJGV3hObmZKQkxLbE5FWEIzd2QwbHV1ZTNjYmNl?=
 =?utf-8?B?NmxFM0VmL0NPU3B6dGxGYlpvUiswUjRwR3VoT05KUFN0M2x3ZUxJdEZ3WCt1?=
 =?utf-8?B?SGtTUGFBUjlrSGh0cFc1WEdRWHRVV25kVTRoRnhEdVFuVDk3YWNGK2oxWHlK?=
 =?utf-8?B?WVhDR2FQeHBKcUdHQWF3akdKU0UvTWVIZGI1L01ibkp0SlpOQ0M4RDRuVzJ4?=
 =?utf-8?B?TzlsTjB4andFaTVuVDdQNkVBZFRFNnVSVWhQNVMzSnkzZnJNOVZTeVp1cHFW?=
 =?utf-8?B?ODFNLzVXZWFYMTFvWDhLbTIveHEwcEpiNGJWU3BWSncyUnY3ZHNLdHF0Y1pQ?=
 =?utf-8?Q?mecpq3TnHtxcMRLEVLcQbDS0ia3ic9npwVLuY+F?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92fad99b-3647-4a12-288c-08d8de2ed27d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 10:26:35.6803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6+KOcgM4tmcssLRjBXY6nusTgDVdzVmkdHvj23nqbXu4MaA+8XpRrBE6mEtu85nNGfeDk7bsjwsMdFwwvRQkmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4592
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adding some people in the loop, maybe they could help in understanding
why lack of "dma-coherent" property for a HW-coherent device could lead to
unexpected / strange side effects.

On 3/1/2021 5:22 PM, Sascha Hauer wrote:
> Hi All,
> 
> I am on a Layerscape LS1046a using Linux-5.11. The CAAM driver sometimes
> crashes during the run-time self tests with:
> 
>> kernel BUG at drivers/crypto/caam/jr.c:247!
>> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
>> Modules linked in:
>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.11.0-20210225-3-00039-g434215968816-dirty #12
>> Hardware name: TQ TQMLS1046A SoM on Arkona AT1130 (C300) board (DT)
>> pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
>> pc : caam_jr_dequeue+0x98/0x57c
>> lr : caam_jr_dequeue+0x98/0x57c
>> sp : ffff800010003d50
>> x29: ffff800010003d50 x28: ffff8000118d4000
>> x27: ffff8000118d4328 x26: 00000000000001f0
>> x25: ffff0008022be480 x24: ffff0008022c6410
>> x23: 00000000000001f1 x22: ffff8000118d4329
>> x21: 0000000000004d80 x20: 00000000000001f1
>> x19: 0000000000000001 x18: 0000000000000020
>> x17: 0000000000000000 x16: 0000000000000015
>> x15: ffff800011690230 x14: 2e2e2e2e2e2e2e2e
>> x13: 2e2e2e2e2e2e2020 x12: 3030303030303030
>> x11: ffff800011700a38 x10: 00000000fffff000
>> x9 : ffff8000100ada30 x8 : ffff8000116a8a38
>> x7 : 0000000000000001 x6 : 0000000000000000
>> x5 : 0000000000000000 x4 : 0000000000000000
>> x3 : 00000000ffffffff x2 : 0000000000000000
>> x1 : 0000000000000000 x0 : 0000000000001800
>> Call trace:
>>  caam_jr_dequeue+0x98/0x57c
>>  tasklet_action_common.constprop.0+0x164/0x18c
>>  tasklet_action+0x44/0x54
>>  __do_softirq+0x160/0x454
>>  __irq_exit_rcu+0x164/0x16c
>>  irq_exit+0x1c/0x30
>>  __handle_domain_irq+0xc0/0x13c
>>  gic_handle_irq+0x5c/0xf0
>>  el1_irq+0xb4/0x180
>>  arch_cpu_idle+0x18/0x30
>>  default_idle_call+0x3c/0x1c0
>>  do_idle+0x23c/0x274
>>  cpu_startup_entry+0x34/0x70
>>  rest_init+0xdc/0xec
>>  arch_call_rest_init+0x1c/0x28
>>  start_kernel+0x4ac/0x4e4
>> Code: 91392021 912c2000 d377d8c6 97f24d96 (d4210000)
> 
> The driver iterates over the descriptors in the output ring and matches them
> with the ones it has previously queued. If it doesn't find a matching
> descriptor it complains with the BUG_ON() seen above. What I see sometimes is
> that the address in the output ring is 0x0, the job status in this case is
> 0x40000006 (meaning DECO Invalid KEY command). It seems that the CAAM doesn't
> write the descriptor address to the output ring at least in some error cases.
> When we don't have the descriptor address of the failed descriptor we have no
> way to find it in the list of queued descriptors, thus we also can't find the
> callback for that descriptor. This looks very unfortunate, anyone else seen
> this or has an idea what to do about it?
> 
> I haven't investigated yet which job actually fails and why. Of course that would
> be my ultimate goal to find that out.
> 
This looks very similar to an earlier report from Greg.
He confirmed that adding "dma-coherent" property to the "crypto" DT node
fixes the issue:
https://lore.kernel.org/linux-crypto/74f664f5-5433-d322-4789-3c78bdb814d8@kernel.org
Patch rebased on v5.11 is at the bottom. Does it work for you too?

What I don't understand (and the reason I've postponed upstreaming it) is
_why_ exactly this patch is working.
I would have expected that a HW-coherent device to work fine even without
the "dma-coherent" DT property in the corresponding node.
I've found what seems related discussions involving eSDHC, but still I am trying
to figure out what's happening. I'd really appreciate a clarification on what
could go wrong (e.g. interactions with SW-based cache management etc.):
https://lore.kernel.org/linux-mmc/20190916171509.GG25745@shell.armlinux.org.uk
https://lore.kernel.org/lkml/20191010083503.250941866@linuxfoundation.org
https://lore.kernel.org/linux-mmc/AM7PR04MB688507B5B4D84EB266738891F8320@AM7PR04MB6885.eurprd04.prod.outlook.com

Thanks,
Horia

-- >8 --

Subject: [PATCH] arm64: dts: ls1046a: mark crypto engine dma coherent

Crypto engine (CAAM) on LS1046A platform has support for HW coherency,
mark accordingly the DT node.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
index 025e1f587662..6d4db3e021e8 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
@@ -325,6 +325,7 @@
                        ranges = <0x0 0x00 0x1700000 0x100000>;
                        reg = <0x00 0x1700000 0x0 0x100000>;
                        interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
+                       dma-coherent;

                        sec_jr0: jr@10000 {
                                compatible = "fsl,sec-v5.4-job-ring",
