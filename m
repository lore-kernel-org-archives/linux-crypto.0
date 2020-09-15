Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704FCC2D0E0
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 12:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15F50206A5
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 12:46:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Gw3ocHnW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgIOMpw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 08:45:52 -0400
Received: from mail-eopbgr150080.outbound.protection.outlook.com ([40.107.15.80]:7554
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgIOMpC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 08:45:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzVDCeIEY6MrYRFEv8OdRb1O1DEKZMK9kM9ZiHGy4TyxIecEUq+tC6vaBR6Ia6btDfTrAVCrcCxILnnw8EBrh70WV0DwMyx9yiYg2LLKVUwOqjVgjfTKTh3TskmWoXgGC0YTYbdLnqS3mLEN0jXWEVGKHn8nuOlcFq2E3J7hXr3EPjwbU1LW6bF2pnjipcLyQd29KazpihkMdr7rTO6ajadfI2XDhOY3G+2aDdq3AYryalgz0+Mb0VFVvXqGO/UiyiAtVhOZ/qsBmkXNcWBphAzh1zCOhn/muiLBmfpiNKExCE1gAjwHEJLv5BgLRCpyMtXuW282uoCd3NR3nX3aFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/KVV9nEo7vVEtEkmiU0s2Uue4gBmhIfDdsab/KBGlA=;
 b=TxVUMQnMDpvLm8U3NF28Y5vyhXeddpT9L6BZ7C1pD2VOiQJCPiQ2xpsm27wpXn/bAIdZOhsXcu9IqDuJWylVr4eYZjankqvQyd2ZWuSCxE3C75HWhDiDzoUx4+2bB+6f36G729rvr3cbAUmzywVxTuA1Of8uCbmGNyvvp/M9h971tTLLHamlc9yxdVUPnOUVNwlRt5i/yyRnj37autuumvAzojj7ZGdZnNyk+Ca0hBRDXqkmG3xdR/H6inho9Wuslq/H62EvmA4SIQiJIARzQQEhIC4f9KdmHpqWy35sd4XESvte/eObFJLkLx51fo5C4LvRVMNpMMW8xY7nRXLaPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/KVV9nEo7vVEtEkmiU0s2Uue4gBmhIfDdsab/KBGlA=;
 b=Gw3ocHnWGYhLQWEkv3ZzO2n7aaO5avP8IQipRWtQ8bCXoDVqx7RMtqIk45Aary/3ENTksi9E8iiyq+uZJHyy0/XL63/krrVEZsrpc8LlSPSDLJGV7THmw3yWt49gmDMNoCZhg0r4XUaZFS7VxgBxaWdWoUX//rLzemRHMV1yQL0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VE1PR04MB6558.eurprd04.prod.outlook.com (2603:10a6:803:11b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 12:44:56 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 12:44:56 +0000
Subject: Re: [PATCH RESEND 1/9] crypto: caam/jr - add fallback for XTS with
 more than 8B IV
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
 <20200806163551.14395-2-andrei.botila@oss.nxp.com>
 <20200821034651.GA25442@gondor.apana.org.au>
 <c360d691-8253-bd99-af92-83d9f8e86a2d@nxp.com>
 <20200908221019.GA23497@gondor.apana.org.au>
 <67159207-1082-48be-d085-971a84b525e0@nxp.com>
 <CAMj1kXGg7bSh57kwE57mKRocNRPZCeXifwjF53-3Jb6LYsfZTg@mail.gmail.com>
 <38f9904b-5bf7-ea99-ed8a-27cb49f405bd@nxp.com>
 <CAMj1kXH0jOQms9y1MywORywoKjxQ2p8ttv+Xf9KTOkfORX5XWw@mail.gmail.com>
 <4393bf96-30fd-0d1c-73fe-f5ef7c967f76@nxp.com>
 <CAMj1kXFeZP7_TQ73yLq0dfb=3wMS0VxqbKKUCGny0xHW1xL+5g@mail.gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <89b9c29d-afb1-0082-66f6-8bb930710884@nxp.com>
Date:   Tue, 15 Sep 2020 15:44:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <CAMj1kXFeZP7_TQ73yLq0dfb=3wMS0VxqbKKUCGny0xHW1xL+5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0013.eurprd03.prod.outlook.com
 (2603:10a6:208:14::26) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR03CA0013.eurprd03.prod.outlook.com (2603:10a6:208:14::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Tue, 15 Sep 2020 12:44:55 +0000
X-Originating-IP: [78.97.206.147]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c19f377-8e63-4ea8-8d5e-08d859752618
X-MS-TrafficTypeDiagnostic: VE1PR04MB6558:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6558834F03A8247CCBDEE4A298200@VE1PR04MB6558.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C/un5SP33D5XQQBSB15EP3FyaL/w0Y8itrsyEW0jPF4jiTbx9CDhlJLdwuEqbhuPGu+UQyBXeD1CYhhyGuLFxrmqQGsFTIzm6X6TnH8VWWjuGsHO6O1QglRzetxCHfY8RroRzlb84W69qS3hDeeHteyCAmWXsu5D9pPudIhCEVtoBvacBLiNQD898fohjdvIckgngXZCL5hcVfDeLWnQ9XqnEee9GJZw9xaQfe34uQz0hNjXaaDzKzqbZgZDYvWtQKWMC+1OWcOYgYiHp0x4UWsC625YIthFDVyuoEJJbTi6AdtvityFWKfHiBYe4dWwqvHnOX4A5OOXik8MU7YYbmqzhi/MkYorLcI7vCraXeDsvs+7PYendaKl3YdBQoE4hxxjz0LfLf/2NOcEkNyWIDLqOrm/57jQJbE52R6wE9uF/fnuQWqoblmnKJoxXsU2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(8936002)(6916009)(4326008)(8676002)(316002)(6666004)(186003)(16526019)(16576012)(31686004)(36756003)(2906002)(53546011)(26005)(86362001)(66476007)(52116002)(66946007)(31696002)(66556008)(478600001)(5660300002)(956004)(2616005)(54906003)(83380400001)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cPS778RxxUabvB6Uxwg2kJcie7tgJJknssHJJgkwMvpFzrFnsVQpCG7qXbpRPNHs9O0iWq7t7UXuqYCJLICRu3oC8u6A4svCX36iLUtkZcOCFUo48HzM06ZVyBay9VhnwMZfMIvgd0HFPxwVms82jN32MnhvPM+4Qq3mRDWY+umhOtvBiQ4hAmCMvgVWrr2Ys7LjYbEi3nTllre9Gse+9NHHg9yeY+TosXY+dnFhvlpDY0q1vdHpoJ7Fu43Rb3dw14r3QsHuVyLacqoYPSkgW8gF/XbKIohkbfsBBAZAi9ctFNr2PShlmSzVYkCqquVtu+oFDzdYyPVDree4mxQWdgl9/YoBS5lbR4e4De6pA2lxWxUytV2QMFrWykJuxijcy9G1hXCOl5Fr12w0pF108oG6JRpsfP8KjfTZY+IyJUQ1je57bFq1x9OQx+osb/3ibG/jHb09ddXsMCkzu+bkoEKzCyCHlm9sxv+viHbL07alTN0RCR5pL9Gw5hAFrXFO32fMc9nvS0ElIDr4FhNh3jYCK6iCwvNluH2xnvs2+BL+2JZtC65ZU7CK16hINLv0cCp9Wr60WAetyhiI6PIQJaLOR8PYJOLbOh+ZojkMnXSYN2gyJ9C3tfHN6PkNt/Bq1zIV6x/J70QK1Q4GG1lcuA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c19f377-8e63-4ea8-8d5e-08d859752618
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 12:44:56.0742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xBBXnK8TJ5H/IYz5MetT+fffF9h7GYkedju48L/K2SV7gd6RMsWO99c/f4FAUe3JQp7e7eMMlFA8lOibJualg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6558
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/15/2020 1:26 PM, Ard Biesheuvel wrote:
> On Tue, 15 Sep 2020 at 13:02, Horia Geantă <horia.geanta@nxp.com> wrote:
>>
>> On 9/14/2020 9:20 PM, Ard Biesheuvel wrote:
>>> On Mon, 14 Sep 2020 at 20:12, Horia Geantă <horia.geanta@nxp.com> wrote:
>>>>
>>>> On 9/14/2020 7:28 PM, Ard Biesheuvel wrote:
>>>>> On Mon, 14 Sep 2020 at 19:24, Horia Geantă <horia.geanta@nxp.com> wrote:
>>>>>>
>>>>>> On 9/9/2020 1:10 AM, Herbert Xu wrote:
>>>>>>> On Tue, Sep 08, 2020 at 01:35:04PM +0300, Horia Geantă wrote:
>>>>>>>>
>>>>>>>>> Just go with the get_unaligned unconditionally.
>>>>>>>>
>>>>>>>> Won't this lead to sub-optimal code for ARMv7
>>>>>>>> in case the IV is aligned?
>>>>>>>
>>>>>>> If this should be optimised in ARMv7 then that should be done
>>>>>>> in get_unaligned itself and not open-coded.
>>>>>>>
>>>>>> I am not sure what's wrong with avoiding using the unaligned accessors
>>>>>> in case data is aligned.
>>>>>>
>>>>>> Documentation/core-api/unaligned-memory-access.rst clearly states:
>>>>>> These macros work for memory accesses of any length (not just 32 bits as
>>>>>> in the examples above). Be aware that when compared to standard access of
>>>>>> aligned memory, using these macros to access unaligned memory can be costly in
>>>>>> terms of performance.
>>>>>>
>>>>>> So IMO it makes sense to use get_unaligned() only when needed.
>>>>>> There are several cases of users doing this, e.g. siphash.
>>>>>>
>>>>>
>>>>> For ARMv7 code, using the unaligned accessors unconditionally is fine,
>>>>> and it will not affect performance.
>>>>>
>>>>> In general, when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is defined,
>>>>> you can use the unaligned accessors. If it is not, it helps to have
>>>>> different code paths.
>>>>>
>>>> arch/arm/include/asm/unaligned.h doesn't make use of
>>>> linux/unaligned/access_ok.h, even if CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>>>> is set.
>>>>
>>>> I understand the comment in the file, however using get_unaligned()
>>>> unconditionally takes away the opportunity to generate optimized code
>>>> (using ldrd/ldm) when data is aligned.
>>>>
>>>
>>> But the minimal optimization that is possible here (one ldrd/ldm
>>> instruction vs two ldr instructions) is defeated by the fact that you
>>> are using a conditional branch to select between the two. And this is
>>> not even a hot path to begin with,
>>>
>> This is actually on the hot path (encrypt/decrypt callbacks),
>> but you're probably right that the conditional branching is going to offset
>> the optimized code.
>>
> 
> This is called once per XTS request, right? And you are saying the
> extra cycle makes a difference?
> 
Yes, once per request and no, not super-important.

>> To avoid branching, code could be rewritten as:
>>
>> #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>>         size = *(u64 *)(req->iv + (ivsize / 2));
>> #else
>>         size = get_unaligned((u64 *)(req->iv + (ivsize / 2)));
>> #endif
>>
>> however in this case ARMv7 would suffer since
>> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y and
>> ldrd/ldm for accesses not word-aligned are inefficient - lead to traps.
>>
> 
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS means 'just use the unaligned
> accessors as they are basically free'. Casting a potentially
> misaligned u8* to a u64* is not permitted by the C standard.
> 
Seems that I misunderstood CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS.

Looking at its usage, e.g. ether_addr_equal() or __crypto_memneq_*(),
I see similar casts of pointers possibly misaligned.

>> Would it be ok to use:
>> #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && !defined(CONFIG_ARM)
>> to workaround the ARMv7 inconsistency?
>>
> 
> No, please just use the get_unaligned() accessor.
> 
Ok.

Thanks,
Horia
