Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98302C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 14:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 782B160F5B
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 14:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhIQOqn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Sep 2021 10:46:43 -0400
Received: from mail-vi1eur05on2076.outbound.protection.outlook.com ([40.107.21.76]:65249
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229929AbhIQOpx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Sep 2021 10:45:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZckPT0gG0carPY5gRS7slcY3UmGkIiuWGjWJYebwTdYqF5ZNu18IZAgeP5AL+A9/ac4bC/J9yzgBSi02mkkKEpCdWuvmvT7VeD55NY18Rf7AnoFRVnVMx3HDCVrml9Thufn9GkkfzGa9XU1oTtmSWbbcMrEh8wlxhcfZ/EMqNEcKOcmvNSG+Q5rUL/8A12heEYSJC/p1jdksNW1WieEZL0coFeePzoc0yN8n6MnhWiZakDvlOjySwuiRZ7MvbBJvJsXraNQaN6g0dTfo/hofXasTE+H5PPJMD3imr6WIOZNz9xQ3M+bmbO27AGYzuAxSuuAKq2lKvibeF/+cthhkuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jcDOjB+QSCUyhGuRchnYDaKBGhyvk0whvuJW2NDZeZI=;
 b=ZRjrMC2DRbK2rXWpUbk6VVrIjtqpGqZZ2nJpw3X32WkR0GAQmtm17HSBPztHIs7TV+9DyWD55u2w9x+A56XAkbz+ErqhtzDUO/1Udq5AYBuipow3C6FNtgEZYdhUY3x/wcWSsXBY8IRT8aIYXsNyFh+4Xl8aPGkFkMKwAuib+F7xzX1Kitn2fvoJ2irn1WclyaVJGFrDigrNebpgBNgBYQZUFatHIAnnh5eVJ8W4J41zfOAp6erepNWqDFUCwGCzE7UiPsIe7vZ8HboNpGUS/1FQyaQnrh8Vn3TQ8J2+UlcFwsrgsAbevnR9iqit4umM3kpPwQpT2sA33HSZi4fO4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcDOjB+QSCUyhGuRchnYDaKBGhyvk0whvuJW2NDZeZI=;
 b=DRd5B5I9RIzg0RBxyZTtU/kq2tvW8K1oMZBgj3MoiyStISHF22jKf9XuftQOgQ35uIclNzjUhhdbJBnHcJ7G+ntUPHMA1u6G2bjf9N2N6yovUj7zbM6KqfDklajHda4ljZK3q9brJ12o6zuZqHnZU05oiCDvfiBpUtsV2b2GXBY=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0401MB2318.eurprd04.prod.outlook.com (2603:10a6:800:27::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 14:44:17 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3567:55c:a665:a42f]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3567:55c:a665:a42f%2]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 14:44:17 +0000
Subject: Re: [RFC][PATCH] crypto: caam - Add missing MODULE_ALIAS
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Marek Vasut <marex@denx.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     "ch@denx.de" <ch@denx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
References: <20210916134154.8764-1-marex@denx.de>
 <441a7e2e-7ac8-5000-72e0-3793ae7e58d5@canonical.com>
 <08afb147-07c7-9fbb-4a0c-8a79717b06b7@denx.de>
 <ea7e5aae-be43-057a-2710-fbcb57d40ddc@nxp.com>
 <a8900033-d84d-d741-7d72-b266f973e0d6@canonical.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <bc94681c-58e5-8c6f-42d3-0e51ddd060c7@nxp.com>
Date:   Fri, 17 Sep 2021 17:44:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <a8900033-d84d-d741-7d72-b266f973e0d6@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0206.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::13) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.213] (89.136.162.44) by AM0PR02CA0206.eurprd02.prod.outlook.com (2603:10a6:20b:28f::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17 via Frontend Transport; Fri, 17 Sep 2021 14:44:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f99b4b1-3c79-46e5-4e7d-08d979e9a04d
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2318306EDE32C0A39AB5A91A98DD9@VI1PR0401MB2318.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cQ8pb+E8kG6WR7xSsAY9R7k+AWl3Ix+VjBUhejPXRwdru5r3Ctz8JrkHH3KXKugGzdnLHDDU0ibWzKUsKnTrqNG3CWXZZx5OCX1looLROIkQ6Jybx30zxHzLjVojCl51sgOvK+4+jw9Zx7Y9cPv4Jbupk30gHUA+/M1gY7vTgPoIho1C2RzTiXC/omWBvLMKftycykNP4spPa0+hENhl4YZaG+lLOqE0OXlG6EPvr4RoCZ7EpG9w3C27xFls0pcY5ma8xzL0OMgjS4Eh5VdxWG89IA9cePW1LzOmqbOEWcvNYswno14jZquQgB07HIgU13HnWC//ISuJx1NHLabYERoObbOHx8Fr50rfTq6ixrqMrB4mEPUSbSN4TTURlvDp1wKqjk/EczueFGP8TP0Fmq8lNHdij7G5QJ1Po4azdaCsQSktfKVZ55W0tatKtu5XZVQpe522eUjIRIUL+vK3oBPmwIGgGzjbkSMt/08u96xI+8y+lbDpJhMPKGZKiWdz9grFx8l3xwcFW23GgguKUpEQu38f3PnktpePIRg7zm270Eh0ylj0Y6ypyoUAgWxxm8wBS5Lb8j+xtlPCrGpvdIwDCse6NRoEOB4QKDJNTiIdWF1/jVmJ7Fvbiba3hzzsTPU7OrA87qAvu8wywjx9rF8ILlQYtxOrW33Et3L25rlML1heUoB5NjmV0rxZ5YeQ3EZ0HHhX0odJCqlwz+L8kVb/nUJ32bV6Zy0BgoRaTbLXHoNAGElrDDMPhYdfCFzxhQhUxt+4M49v7u4e8qQKJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(53546011)(8676002)(66556008)(66476007)(186003)(31686004)(86362001)(5660300002)(83380400001)(66946007)(2616005)(26005)(110136005)(54906003)(8936002)(31696002)(316002)(38100700002)(38350700002)(6486002)(16576012)(508600001)(2906002)(52116002)(4326008)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1h2bHBOZHhIL0RqZ0RlazF1d0xSNTRmOHlBbUlEMTRxWHBCV1JBYWorMlR2?=
 =?utf-8?B?TUFFcWNjQUJMaW9CZkpQUVVwb0RYeGMyTTkrNFNVOEhTS3haWDVzc096N1hx?=
 =?utf-8?B?dktrTHdyZS9vWVlxbDNST1A2dm0renFycXpGelhlSzUycHNQM1hOK2ZhTjFi?=
 =?utf-8?B?OUE1aVJjQzlPQzF5STJmWXdwS1ZYWDg1MERyRHJVeWV3ZjBCU09pM0JWSDRk?=
 =?utf-8?B?YlQwYTFKV2RoK3JKc0RIVm84ZkJtRHVTVSttdmpQWGNRYU1HVlFDQ0UzVFJ3?=
 =?utf-8?B?czdsZGhjdjUxT2crU3BKZW9ZTmgrTnR4MjBsczdZNlREZUNUNlVrL3VwWFdr?=
 =?utf-8?B?S0k2Vm1PNm80cnZEOSsxT3lNRmxsS1pLWU5obGRhT1NtaUpJYWhsdU9yUloy?=
 =?utf-8?B?NHc2emZXVGtHYmlEMWU1cnJ2b2phYVJUNnVDdG5WRnk2SEVOYTJ5ZVMwVFhI?=
 =?utf-8?B?UTRwek50UkoreEczU0tOTUVkZzNERVRwNFYwR25KcExVZmMvMzhSL0gwTDF1?=
 =?utf-8?B?bmNFOGVRbFNBRHBiZVAreUYyak1hZG5DYmNHUnNUcmJVQjQxRy9OWjJYYS9B?=
 =?utf-8?B?WVN5ZjNnNXpHaEROT2lTai9hdDdtYll6dWpsdTN6bk01SkcyQW1kcjVnUGVI?=
 =?utf-8?B?eDBvTzQvZzdYLzl2cWxlQkhadE41RkJIUlVtSUJHdVdSSGRvZFQ4K3c3YmJF?=
 =?utf-8?B?ZUFYR1pqbUZENWExWHl2OWhJdUtTZnRCV1N1R2ZKcXRVWWM4UHVHeWhxbDIr?=
 =?utf-8?B?RTIyaUF5d1FkYitvMGVZRDV4bFFIczFYVmhHWkdzYzJQVTMyMG1OWTBqdGQr?=
 =?utf-8?B?aTRrcE1TdWVhN2l4MjVuazgzblg1MWdZazFibHIxYzNYZU43RmdxNHEyUG95?=
 =?utf-8?B?WkczdFRUV1dvNEU5SXVPUXp4RDZsZUFhRFRKajZmMG9QZ2YvMW9Vbm85ZFU2?=
 =?utf-8?B?K0s5dENMMjlRem1aMGRVMDJEOTRzZWNYeERWTzdmL3dNZmpydVNWUzlyTXlP?=
 =?utf-8?B?Y3FyNlRIblRFTjNPb3lkbmh6MkVaNE83TzlUUy92OUJXMFgvUTdDYjdXSkFF?=
 =?utf-8?B?QTVxVzF3RERWNEhGMHEvVzBBOXVxdVBwNHJYc2lUQm9hR25GSU5Bd21RWnA3?=
 =?utf-8?B?aXE1bFhqRXNkVVA1eHd1dCsvS25idGE5STd5VzRVdklnM2R4RGdkckdRSmRX?=
 =?utf-8?B?MktydVhzUHVzcFltbTJjSXNyQmU3VTZuYnV0ekdVaStYM3o0K0J1bkJMS1pC?=
 =?utf-8?B?OUp1ZkV4aW9TL1pxbDV5aXVpTkRyMEpMUXpmZlZjZ1o1aU1NTHZ2ZVg3YzY5?=
 =?utf-8?B?TDh6bWFobUNncjJLcyszOG5kaDI5UW8zL0d5SVVETTFrblNyN1ZEbm5QVk91?=
 =?utf-8?B?OXBBNDhmUnQ1NWNqeUtKL1oySlF1REVmK2kzR1RIdVIwa0I1b0dQNkhjWG9H?=
 =?utf-8?B?aWtNYlJ5N1Z5YThzbURFcE5aUEFZamJjZ3JCZjZKc1cvRGFpWFd6Q010TTNL?=
 =?utf-8?B?RThPTkZkRGV6Zlg2S0E1R1dTNjBOZXNGcHRPYzQ2bzRzUTAxMW03TGpIMFBi?=
 =?utf-8?B?ZGd3c1BiWkNLNjlRQlRlSTBVdEUrdE81bW04MmF6M2FCbjJKZXhjWVVnY1lj?=
 =?utf-8?B?Tk41Qm03dEw3SnNaZFRadGJtaXJ1K2FseHR1bzJRbHhJcDZpRzVvbVN2WU83?=
 =?utf-8?B?WFBnaGUvWWZFTTF1eWs3d09SSk5zNFh1RnBTY2RXT0FBVk1mVWhDNml6dS9N?=
 =?utf-8?Q?58Dm/zEg7Xd9HRReYY48Kckwl2uji/FIqUH5Jyg?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f99b4b1-3c79-46e5-4e7d-08d979e9a04d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 14:44:17.5906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ONr1CMX/8EwaFJviVdR4IiEkJfnR/2RSSxdbbn+CmvggkKH3B501i/Um252oWK37sE+LMjRyzYDP5i5xLciM2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2318
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/17/2021 1:33 PM, Krzysztof Kozlowski wrote:
> On 17/09/2021 11:51, Horia Geantă wrote:
>> On 9/16/2021 5:06 PM, Marek Vasut wrote:
>>> On 9/16/21 3:59 PM, Krzysztof Kozlowski wrote:
>>>> On 16/09/2021 15:41, Marek Vasut wrote:
>>>>> Add MODULE_ALIAS for caam and caam_jr modules, so they can be auto-loaded.
>>>>>
>>>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>>>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>>>>> Cc: Horia Geantă <horia.geanta@nxp.com>
>>>>> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
>>>>> Cc: Krzysztof Kozlowski <krzk@kernel.org>
>>>>> ---
>>>>>   drivers/crypto/caam/ctrl.c | 1 +
>>>>>   drivers/crypto/caam/jr.c   | 1 +
>>>>>   2 files changed, 2 insertions(+)
>>>>>
>>>>
>>>> Since you marked it as RFC, let me share a comment - would be nice to
>>>> see here explanation why do you need module alias.
>>>>
>>>> Drivers usually do not need module alias to be auto-loaded, unless the
>>>> subsystem/bus reports different alias than one used for binding. Since
>>>> the CAAM can bind only via OF, I wonder what is really missing here. Is
>>>> it a MFD child (it's one of cases this can happen)?
>>>
>>> I noticed the CAAM is not being auto-loaded on boot, and then I noticed 
>>> the MODULE_ALIAS fixes cropping up in the kernel log, but I couldn't 
>>> find a good documentation for that MODULE_ALIAS. So I was hoping to get 
>>> a feedback on it.
>>>
>> What platform are you using?
>>
>> "make modules_install" should take care of adding the proper aliases,
>> relying on the MODULE_DEVICE_TABLE() macro in the caam, caam_jr drivers.
>>
>> modules.alias file should contain:
>> alias of:N*T*Cfsl,sec4.0C* caam
>> alias of:N*T*Cfsl,sec4.0 caam
>> alias of:N*T*Cfsl,sec-v4.0C* caam
>> alias of:N*T*Cfsl,sec-v4.0 caam
>> alias of:N*T*Cfsl,sec4.0-job-ringC* caam_jr
>> alias of:N*T*Cfsl,sec4.0-job-ring caam_jr
>> alias of:N*T*Cfsl,sec-v4.0-job-ringC* caam_jr
>> alias of:N*T*Cfsl,sec-v4.0-job-ring caam_jr
> 
> Marek added a platform alias which is not present here on the list
> (because there are no platform device IDs). The proper question is who
> requests this device via a platform match? Who sends such event?
> 
AFAICS the platform bus adds the "platform:" alias to uevent env.
in its .uevent callback - platform_uevent().

When caam (platform) device is added, the uevent is generated with this env.,
which contains both OF-style and "platform:" modaliases.

Regards,
Horia
