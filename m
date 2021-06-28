Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FA6C11F64
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jun 2021 17:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74AA661C6F
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jun 2021 17:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhF1Rqe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Jun 2021 13:46:34 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:30912
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233327AbhF1Rqd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Jun 2021 13:46:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zg9Fuc4FPb3c8wlXDD0f/pXDdwnRgXyl86Sjwb2BCojp/QfxuG1GZi6C5/s7kjW3S0FlO7/0paLx1kKREUuHvPqGz94ab1nBcRjkRQj9gVPyeJ/7SgyJt3zQv2UEnHbNOF2QBFTIOVctfCLj/KLc8Dqk3WcDsqUr3tIEBhgkJWe3EXuUS+MokPeIwquM4i85csJTLHY6ArcDUhxAMLwHDrqNb4Err1RmRkJl7b+8OEd10tHCQgbpHe9apli1jGnCWLax6hyGhOADQWsH0nG7Sepr4nAs1XhO7ZoFdqpLr21k8fx1UBlQwpTmvk5A7sSOxNUB4Vf4/R6e5oTrHnoxIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9lLCWA92MyyOSpzz9CC20gqkLL7M3no3L15Ee+vnirU=;
 b=LVB26ghP5e52XfTG+UsrqqlVrhzN5+1mbrw87PP8x8t37uCXlZb794S5wT4CEP0dwfw4VdNm61+PUZqCE9Y45O3LUzedznxEG2Vo61gKBzE2IYmegTvCQKeIjJ7pZ3Y1c1t48o/XjYBrLdXSKNmGqheAgR5EKWqlZ1wOOtTYR4U6PKJlZ4RlDnS8DpW6YkQhVWzZ56oslF4ZiAv/lHO5Wetrhs+RNi+DFxsHQ72Ol2BXd2GwOgF1FXIvAFX9ElMWs9+81P1GJRWpu0atnSNr+/YcamCpyrdHU2WRtFJYIoTnMX0PnL4PMEKMiDrpZL1s5fPvVMM3ZltHgxpXP8WQsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9lLCWA92MyyOSpzz9CC20gqkLL7M3no3L15Ee+vnirU=;
 b=U7X9miyD2bjUT5y9kBMScynjMqO2P3ROLBr/Qexs7ur4jfgaGoN1gI5ZRDWqja5WRY5hNYWkAiyxzyfcQIK7/RJXIplOxzv4YcGxwUOw/EEBUjILIvsoiNKm1uBk4a9fdxA8hDvD7eyxkhWEreVAE8yL75lDz4Mso2QGEcDHrWw=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB4618.eurprd03.prod.outlook.com (2603:10a6:10:18::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Mon, 28 Jun
 2021 17:44:04 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b%5]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 17:44:04 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH 2/2] crypto: mxs_dcp: Use sg_mapping_iter to copy data
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
References: <20210618211411.1167726-1-sean.anderson@seco.com>
 <20210618211411.1167726-2-sean.anderson@seco.com>
 <20210624065644.GA7826@gondor.apana.org.au>
 <dfe6dc8d-8e26-643e-1e29-6bf05611e9db@seco.com>
 <20210625001640.GA23887@gondor.apana.org.au>
 <f3117c42-7918-3d32-059e-4e6c338a781a@seco.com>
 <20210628032522.GA1375@gondor.apana.org.au>
Message-ID: <76f45b3d-3f4b-7ed8-b33c-49a48dad27fa@seco.com>
Date:   Mon, 28 Jun 2021 13:44:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210628032522.GA1375@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.195.82.171]
X-ClientProxiedBy: MN2PR18CA0014.namprd18.prod.outlook.com
 (2603:10b6:208:23c::19) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.27.1.65] (50.195.82.171) by MN2PR18CA0014.namprd18.prod.outlook.com (2603:10b6:208:23c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Mon, 28 Jun 2021 17:44:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1898c7e0-1f14-4602-9b25-08d93a5c526e
X-MS-TrafficTypeDiagnostic: DB7PR03MB4618:
X-Microsoft-Antispam-PRVS: <DB7PR03MB46187F1853F615A25052C4BE96039@DB7PR03MB4618.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:302;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x01CnKV7W5nzw60htae2UsnusS3VX+MUrCSRREsYCKTsVYMrswyu8rQOQLJVpBUBjxDIq6DQoZ4r1TJmczg9r3wBSahzz8JtR+0QtLQGuYvCTzc5fDrIIZAIT+11OW51sSF+XgOndXzWmqgkdk5T2asYJiZWOZQ0ldtpioQyf+XNCHF+1fVCGpB6CI+R89AUf1d/lCSenvGNnjVvq/QitN6ZTydopCnKUN+vNqWhpCld2zy9yXI38ZJQEC8ti9csF33XYUBZx7W01+lJm4oOWqAMLPdwNijoGQZWpuqf3pP5HJd4RA83aBgFplgVNjwnsu8c9yVhl8jJiphrQ5odk7pXoHjUqhNcir6pMRZU1IJCROdkLCONXKAq6x/poPXFHLvJgOsy7DAlAgFcyFO0SmYQ1Zh2UQ+7z9rdXSmD4qQCR1EhD6eWg83QNONMQp0fJpAcuL41GqbPk7MsvI7n72nncEgzODfw0a8Fh0Mrj3XHwVHt10njNvcmkhGrN/AE67qGDN+UtHBsUPvTKfqQLpMuTBjnd0oqCb2utUhGzAzFKB3DlQWBF87PJ9AuyzlQrlvJYyOISwGSGU09BzeRbIqG9C+MShloM6edFSqdcMWuiY+MphWtpJBqcBCtW5TGmbq2KuKfmj0Uo9jvByVGQIsRgqEPHMKvF9nZWkOZp290mpYvaeXnp9srMsZAKSqWM8B0BXT21aBHdfYhrAXU8RJoQ39Us5w2H8ihay5PznDb9FWGnpUHFm4ydWV++1dEwzrTXJIoreMUrc/YEMDLIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39840400004)(136003)(366004)(376002)(66476007)(66556008)(316002)(66946007)(31696002)(16576012)(86362001)(16526019)(31686004)(186003)(26005)(52116002)(8936002)(53546011)(54906003)(38350700002)(8676002)(38100700002)(956004)(5660300002)(4326008)(2906002)(2616005)(36756003)(83380400001)(44832011)(478600001)(6486002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2pJOGI1WkFLcGJWSGl3SElLMUorUlNSNkNpMmhvMzZuQUxkbEdLSTZhZzh0?=
 =?utf-8?B?RWRoM3libzJFQnJNZmx4TGZ2aGVmdHVjbVZjRCs4UlRkOUlScHFKd1E0Z1hZ?=
 =?utf-8?B?eDFHbkUxQWtKeURLU2JScyt4OVlzMlZid3k5cE5JbHBXYTdCNDA4S3NJRzU0?=
 =?utf-8?B?a2dqSy9rK3AzYmRWdzV0dFQwQldxQXhIZ3pyZnVOSFVGTDR2UlN1Z0FjRXZF?=
 =?utf-8?B?dmJzMlQybG1Zdm5sQmw3TWIxQnVZRXlPUmpWT2QzUVpZbHJTbDRXSW04d2w3?=
 =?utf-8?B?d1BsM1JkM3Z1RlFTTm93Vm1GNStyeVZjMS9WV09jT0NjWFh1eFRpMEpDbTcr?=
 =?utf-8?B?MjNyaC9ENkVaUmFmcXBKbEdxaklOQ1lVSTFkU3dTUnhNNGZJcWp0RWJhdnpF?=
 =?utf-8?B?N1dWZXd5Y1Vvb3E2OEFrcXcrOVk3OXc5TlFWWDBoN2lFL0pBN3VFQlRKWGk5?=
 =?utf-8?B?MVFaVXFUZ1pjL1oyQXJVQnUyMlF5ckExaUltZnBkWVdnODBrekx4NmZ2VFlF?=
 =?utf-8?B?NXIrQzdNbWFocFo1bURPajhrL0trZHcxV2d4YVNkcDJSbHJmQkpsOEdYS1hO?=
 =?utf-8?B?ZXU3THE2Q3lpWkppM1hCVGxEazhNelVDUTJabWhTeGlXOUNqYUp6bXc2aGlE?=
 =?utf-8?B?eGJUWnM5WDM4RndoSEZTWDB3ei8vaVNEZUc0ZTJxeHJmRGkvUTg1cmM0ZHU2?=
 =?utf-8?B?QTJxSU9RL0Y2UUhvQjBEZXJLcWNCaXZSbmJ2K2htaTduOFp5WUsxUSs2YTdz?=
 =?utf-8?B?WWVHNnk0eUI2ZTl3eE5IdXNuWEFBZWw3OGNjL0FaeW9ZV1JQa3M3d3JDalFs?=
 =?utf-8?B?WEUyWkJZaWsra1F6aHFBTnNaOGhVRHFNTTYzdk1EUldxRkZoMlJOZExocnAy?=
 =?utf-8?B?RjlpLzE0SzMzUWxHVWlBR3V2VFMyQldIakVFMkNNeVRWUHJZYmJSREkwU2dT?=
 =?utf-8?B?RXhYQ3l1MHVyWDk3eHVxRkw4RDBFNmpWS0dmU011aGlLUyt2NUVIU0g4S3lz?=
 =?utf-8?B?RUVVb051NlU5dlMxY2IyVWhnZXY2dVpJVStZS2xKV0dPclpIWkdBRVRMeHVI?=
 =?utf-8?B?NFVOQnIreHhQVTROa1F6SzcxWmJ1WnZxbmNqRUdaeVNBMW1EQlB4bE9Gc1N2?=
 =?utf-8?B?U3NrSDNlTmxnVkROQlRkUXgyRURkYUIrRVMzS0pzdEV0KzhrejM3Z0JMWFla?=
 =?utf-8?B?dW8xT0FPUjlYNVlKaXExN3dBTDN6TzVQcFg2TnFGalAvWmM2Mnc5OEhsTFl1?=
 =?utf-8?B?SkRwM2ZkUlRwYmtYYXpVYzM1ek1xQ0t2cGZjUVFhTWdlMjdSMGZWOEIxeXVE?=
 =?utf-8?B?L2tuYVRzT2puSWlETUh2U1UwbmxyQzNudVRrTHRmRjJKRmNiUXZBRG1lbVJT?=
 =?utf-8?B?QzlKNnMzMkprekFGNzZURVhZQ01Jak1nb2hvcW03QXY5SDBvamRWVE5McE9Q?=
 =?utf-8?B?bEJTd1F5RlNzTnV5dTlFSkt1cTZnSEVtZFNiN3l5UysvblAyWmVCbUVlMk05?=
 =?utf-8?B?M2pJR0NlNUVaeVJuWEZGU2RNaW1IOWk2algwQTVFL3FHaTIyYmREbEt0QWlU?=
 =?utf-8?B?bm5yOWYrU0F0OTN1bFdzSllaOVViRjVqaFlXZ3RvMGlVVk1XZFVFM0htUlI2?=
 =?utf-8?B?M3JsOFpFSHh5N000YVAxNmVvRmFiT1JpdUkwd1ZLSGlxYnhBVVp3V1BtUjEw?=
 =?utf-8?B?V2MybTN5anJaUlVMQzVpRWdhWlpBR1VQbzJiQnNLWG9Td2huQTZiSllXZnla?=
 =?utf-8?Q?sD0mc8Rq0sypVSMcsYBtET/xVjDShPRRTLjBY0D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1898c7e0-1f14-4602-9b25-08d93a5c526e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 17:44:04.4997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pe1cQqhYthUC4wl/hZnmJIJX4kyBzcvOiVce/sWsOHJo/Wn8JXMNQe8Yz6qxUE6dKeFf1c1ZMSAY/cgZTrz2Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4618
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 6/27/21 11:25 PM, Herbert Xu wrote:
> On Fri, Jun 25, 2021 at 10:49:08AM -0400, Sean Anderson wrote:
>>
>> What version of sparse are you using? With sparse 0.6.2, gcc 9.3.0, and
>> with C=1 and W=2 I don't see this warning.
>
> OK I've upgraded my sparse to the latest git tree, but it still
> gives the same warning, because the two types are of different
> sizes:
>
> $ make C=1 W=1 O=build-compile drivers/crypto/
> make[1]: Entering directory '/home/herbert/src/build/kernel/test/build-compile'
>    GEN     Makefile
>    CALL    ../scripts/checksyscalls.sh
>    CALL    ../scripts/atomic/check-atomics.sh
>    CC [M]  drivers/crypto/mxs-dcp.o
> In file included from ../include/linux/kernel.h:15,
>                   from ../arch/x86/include/asm/percpu.h:27,
>                   from ../arch/x86/include/asm/current.h:6,
>                   from ../include/linux/sched.h:12,
>                   from ../include/linux/ratelimit.h:6,
>                   from ../include/linux/dev_printk.h:16,
>                   from ../include/linux/device.h:15,
>                   from ../include/linux/dma-mapping.h:7,
>                   from ../drivers/crypto/mxs-dcp.c:8:
> ../drivers/crypto/mxs-dcp.c: In function \u2018mxs_dcp_aes_block_crypt\u2019:
> ../include/linux/minmax.h:18:28: warning: comparison of distinct pointer types lacks a cast
>    (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>                              ^~
> ../include/linux/minmax.h:32:4: note: in expansion of macro \u2018__typecheck\u2019
>     (__typecheck(x, y) && __no_side_effects(x, y))
>      ^~~~~~~~~~~
> ../include/linux/minmax.h:42:24: note: in expansion of macro \u2018__safe_cmp\u2019
>    __builtin_choose_expr(__safe_cmp(x, y), \
>                          ^~~~~~~~~~
> ../include/linux/minmax.h:51:19: note: in expansion of macro \u2018__careful_cmp\u2019
>   #define min(x, y) __careful_cmp(x, y, <)
>                     ^~~~~~~~~~~~~
> ../drivers/crypto/mxs-dcp.c:369:12: note: in expansion of macro \u2018min\u2019
>        rem = min(dst_iter.length, actx->fill);
>              ^~~
>    CHECK   ../drivers/crypto/mxs-dcp.c
> ../drivers/crypto/mxs-dcp.c:369:47: error: incompatible types in comparison expression (different type sizes):
> ../drivers/crypto/mxs-dcp.c:369:47:    unsigned long *
> ../drivers/crypto/mxs-dcp.c:369:47:    unsigned int *
> make[1]: Leaving directory '/home/herbert/src/build/kernel/test/build-compile'
> $
>
> In fact as you can see that gcc is warning too.  Perhaps you're
> building on 32-bit?

Ah, that would be it. Although this module depends on ARCH_MXS ||
ARCH_MXC and does not (yet) have COMPILE_TEST as an option, so I wonder
how you ran into this :)

Either way, I will send a v2 with this fixed.

>
> Thanks,
>
