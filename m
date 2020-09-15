Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5470AC433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 10:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A2CE208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 10:03:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="bPLrQc5o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgIOKDB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 06:03:01 -0400
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:14209
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbgIOKC4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 06:02:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhYvp3v2gi5JqBeTsSsQZ+8N9P//lzWAHlhXzqFxB952/q6oxmdTOGuJSiSg+ElXGPfpmHD8U7H9sxCoHQoPpQ6syCIaBZv/JDD0bVgyXmLvxYDlnMiRgdnpV9qDRsmHsI+vHEsxVH6YG5B1HrJHNpDZZGEii/49WGGno15H8T4ogVwj5D9ntJxVjTJyqzxwUuF/PTHy7B0VTNQ68gouY+dvcExrZRtFkCF1gCa2gG3D6WFXiSVfUzWoqhpHDO82s3dP/wlbnfa/fOdzhF/6sm+nalBa1J4BqHQiTBMF/0/GcmbkVHhKKOwuuvzEoHYCpLpb3Cwqq/w6XPU0Vww5Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfMcbfU5DLfQlUw5sJSofcIFtSlzec+/Jxh0n6tP4Xg=;
 b=UKnwX+M9gzTiKkQ5qGVoUXDXdN8RVd5l1Es6HebuFRqyln/T1C42C+nAgXETGxU0mSA2cRsCfvT2RZXEL/Sz+87PdQHqjTZMl6aL2wqh3uSF5Aabil4QjtOOk89JSGWPyB4WhMPhH+6hdt1Oi7MO+9HsuSZ3iQhwgYdYt5iFqrH1JKXyVstjLedW6boGPXqUCGEHyQD2U8zLpLVw+LiIc7gLSn/q2znNxDUBmr4VHiUkbY1tZuM3ILl0kTCY7O4srjJFMwJFVFKUDOEGbVDQD3qEEp0HZWZb43XFQpri6p7Slv9nMPC/+24+uYtTe5PM14KI3n5zTWRsT+lAD48kUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfMcbfU5DLfQlUw5sJSofcIFtSlzec+/Jxh0n6tP4Xg=;
 b=bPLrQc5oI4Z6k6Yhpt5V/g/7mBg7g4lOInP0Vcr5gLpVJh+z6aWbUptGguGjCS+ELzkksP7JywQhJZfnowqHcNBOIrfUWZ7r8uRWiQvSO2I0DpBAY/TOZUGY3vQ7yj1AnECr0Hx1RkmnHVAIF0DnX+p/whBAtqj7REAzqv0IjKw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB6142.eurprd04.prod.outlook.com (2603:10a6:803:fe::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 10:02:51 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 10:02:51 +0000
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
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <4393bf96-30fd-0d1c-73fe-f5ef7c967f76@nxp.com>
Date:   Tue, 15 Sep 2020 13:02:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <CAMj1kXH0jOQms9y1MywORywoKjxQ2p8ttv+Xf9KTOkfORX5XWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0103.eurprd02.prod.outlook.com
 (2603:10a6:208:154::44) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR02CA0103.eurprd02.prod.outlook.com (2603:10a6:208:154::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 10:02:50 +0000
X-Originating-IP: [78.97.206.147]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 48aed4de-d68e-4a85-77a7-08d8595e81e5
X-MS-TrafficTypeDiagnostic: VI1PR04MB6142:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB61422A863D0905958DE4B68998200@VI1PR04MB6142.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7vlaNG7yosW0vqXheXXPCW4nNZuh2CJK1ecYSmIUqzjjymdVriDz5+ChYenoGsa/HBVH3veEv/DLtR7jo/fad+wu/mqBIDy/6Y6pfOi+I2SmeT5RSPMxT1GS0Jb3rc7JEDDpEe7C1R2EEe4SAQj0IalMa1J0C8QxBb/XooTcgzouJzoa5GCdwXqeN///8SrRwl53YNzhO7c3MtXdT5LxrQTWgTDK/V9rZx5D491Yl71ZuHBB19bWubR0dqxEjZYc4B8Xh4y4Hn4lr1TZPAK5RVve65yh2ay5cYukSGhf69LPP6CRDBOMuVwrjzuLVFxNOCocK6cFHg8nj7w06bg8tLeyCClMxdKyYt1b5fShYhtHnn8NH+18zTDVQnimVJk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(8936002)(316002)(31696002)(186003)(5660300002)(6666004)(6486002)(66556008)(66476007)(66946007)(86362001)(16526019)(31686004)(2906002)(36756003)(8676002)(16576012)(956004)(6916009)(2616005)(4326008)(54906003)(83380400001)(53546011)(52116002)(478600001)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xzsuM+6oDRpP5EoA8n47xKJC/N0cbrOqvUvcLg9IRD3vnJ5nYnP4FUS54V5NKmXHI3nVugQeys5X44lRENqZNn+cbIkzE05a74ybL7Mi+GzjJDDJ2xfQeZ8GaVDdPFW5f2k9QFsex7p62klWqps8CoszYwuYi6ifD6dcD6Q5Ok02WJFPbf8Rr9nws1MRJXebohdQcalToQkSpw5tDnCoUwXMrc1Pu7THcbjBH4ffurs5ZM7w4FtJ8bQA6JjPoVP2mGdXlacIg9292nRuxSBozGnywe4OBLhInuLnIqKgKOWnmukdiMf5oVDELZ2XRxClkJgveRgtw9rzrO5C/8XKSs1M5D4TY07nuoTKGs32IZHromt/cGE4OHuwcGiH8hDiZXjDwM5+RHNPFsnvaIDOoASrq89WtZdkoLFA1/Z27eGlzVCO0q08vGUH+5J6KRLp2xRm7fnSb0nKTzitjuptktaP1z1G6nfld1X3JtWr82kmGOLC//OrnXxutz/s3Bb1tQ9qrhLcoM+y5Jp5F4v787mKDw3zGV2tf2FtUJAYY8J7qssT9gIhu2c6fqSXtjQER6RoJouNBgyU7hRjI4nzcTp2jC24/Jdjx7vFV8fUR8KFfckOFBrdGB8kwOEnfaVaI2T7VLsfK1k4HAudhkg5GQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48aed4de-d68e-4a85-77a7-08d8595e81e5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 10:02:51.7070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S2B+Og7JuU6hPHhv5Z1xCT4FVkQGDyNWARfu85A5c2XX4FjDCq7gL8/nSv7IkqV2iUVO5T5zvz8yVaZJ34t1Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6142
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/14/2020 9:20 PM, Ard Biesheuvel wrote:
> On Mon, 14 Sep 2020 at 20:12, Horia Geantă <horia.geanta@nxp.com> wrote:
>>
>> On 9/14/2020 7:28 PM, Ard Biesheuvel wrote:
>>> On Mon, 14 Sep 2020 at 19:24, Horia Geantă <horia.geanta@nxp.com> wrote:
>>>>
>>>> On 9/9/2020 1:10 AM, Herbert Xu wrote:
>>>>> On Tue, Sep 08, 2020 at 01:35:04PM +0300, Horia Geantă wrote:
>>>>>>
>>>>>>> Just go with the get_unaligned unconditionally.
>>>>>>
>>>>>> Won't this lead to sub-optimal code for ARMv7
>>>>>> in case the IV is aligned?
>>>>>
>>>>> If this should be optimised in ARMv7 then that should be done
>>>>> in get_unaligned itself and not open-coded.
>>>>>
>>>> I am not sure what's wrong with avoiding using the unaligned accessors
>>>> in case data is aligned.
>>>>
>>>> Documentation/core-api/unaligned-memory-access.rst clearly states:
>>>> These macros work for memory accesses of any length (not just 32 bits as
>>>> in the examples above). Be aware that when compared to standard access of
>>>> aligned memory, using these macros to access unaligned memory can be costly in
>>>> terms of performance.
>>>>
>>>> So IMO it makes sense to use get_unaligned() only when needed.
>>>> There are several cases of users doing this, e.g. siphash.
>>>>
>>>
>>> For ARMv7 code, using the unaligned accessors unconditionally is fine,
>>> and it will not affect performance.
>>>
>>> In general, when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is defined,
>>> you can use the unaligned accessors. If it is not, it helps to have
>>> different code paths.
>>>
>> arch/arm/include/asm/unaligned.h doesn't make use of
>> linux/unaligned/access_ok.h, even if CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>> is set.
>>
>> I understand the comment in the file, however using get_unaligned()
>> unconditionally takes away the opportunity to generate optimized code
>> (using ldrd/ldm) when data is aligned.
>>
> 
> But the minimal optimization that is possible here (one ldrd/ldm
> instruction vs two ldr instructions) is defeated by the fact that you
> are using a conditional branch to select between the two. And this is
> not even a hot path to begin with,
> 
This is actually on the hot path (encrypt/decrypt callbacks),
but you're probably right that the conditional branching is going to offset
the optimized code.

To avoid branching, code could be rewritten as:

#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
	size = *(u64 *)(req->iv + (ivsize / 2));
#else
	size = get_unaligned((u64 *)(req->iv + (ivsize / 2)));
#endif

however in this case ARMv7 would suffer since
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y and
ldrd/ldm for accesses not word-aligned are inefficient - lead to traps.

Would it be ok to use:
#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && !defined(CONFIG_ARM)
to workaround the ARMv7 inconsistency?

Thanks,
Horia
