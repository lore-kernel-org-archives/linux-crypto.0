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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131A8C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 09:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E52DD610A6
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 09:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240922AbhIQJx3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Sep 2021 05:53:29 -0400
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:49480
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241576AbhIQJx2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Sep 2021 05:53:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMUoizgvaCUCOwlzLwpPF7qRKbzxSdWlji18EuDpyGZ7PUZsPqdM2nWVf0b4SoFsCWWaieiahWL+tArkI2IVXSAfGFClKd2Dxno4trxo7Qv4CeIZq8Uhfy0asP0b2wr9SK86KVCdqfbIuskx1V8rMLjXv7LqO7zcv0AZlw5D09EmuVAxG710fGdrFJAx3bdNIaHly1RCpXsss0RK5TGQWhknbaQZ6q0f2wVDcSZksGxJjz58ZdQwPgTa0yIJTa1geJAyxlsH5UKUMfJNsNkTwnn2J+3V5Al6XwLlBg7JugtWCmJpSwpne1NA8hxZe7Ih+RVuNclC/yFuX1vrJYx4QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mO0WSz//iAT+XSRo7KyWiZZUq6P3e/fwI4SSS97S9XQ=;
 b=dAru117b9uZN+a1Roq/5Hva+ElwkGj94zFsffRRkjMnX5YUS/j9DQl6T1P3oF9r49JTkSGvF8kKfeEEINqdtYsl18kknL6+pVElOyxx3qsZSDSEMLDpQ0QJgkRlgvBjIXblDe93yvuiRMC7d4QfoTS1DoIIrRFCR53jwKRY2Rg0kwxDGdR+svy8n2Bw34qKKbQ3DnVCU1F2H10Yd9CfpI+Rg7LTAm+abBs9V1gCQmRbiEaGDlb9UdxwtBL2/cy4upaLnIpGoPlCiRRZj2jpUEN0Lhw8cWVzassUu+dg6BjuU5uR0HeGJKlBASisMdeMaEyLMulchDgTRux03UuyTgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mO0WSz//iAT+XSRo7KyWiZZUq6P3e/fwI4SSS97S9XQ=;
 b=QqmtNEyDco3dHA5KShDw+FROhug9SCmlQMqUMliRc+lTDi4gNLwy+tZ+vuG8vnLqjYHgNbk5zPDiV1vTKBIY7ZVau6Q5UStoBZ8ajfeix7JjTgH5nirUU1Md4l0LpdpZOj03yDvjDemJ0sUbP0wVMzbQgZXkXYl3w9Rh6uIpVKc=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB6141.eurprd04.prod.outlook.com (2603:10a6:803:f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 17 Sep
 2021 09:52:03 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3567:55c:a665:a42f]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3567:55c:a665:a42f%2]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 09:52:03 +0000
Subject: Re: [RFC][PATCH] crypto: caam - Add missing MODULE_ALIAS
To:     Marek Vasut <marex@denx.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     "ch@denx.de" <ch@denx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
References: <20210916134154.8764-1-marex@denx.de>
 <441a7e2e-7ac8-5000-72e0-3793ae7e58d5@canonical.com>
 <08afb147-07c7-9fbb-4a0c-8a79717b06b7@denx.de>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <ea7e5aae-be43-057a-2710-fbcb57d40ddc@nxp.com>
Date:   Fri, 17 Sep 2021 12:51:59 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <08afb147-07c7-9fbb-4a0c-8a79717b06b7@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0202CA0018.eurprd02.prod.outlook.com
 (2603:10a6:200:89::28) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.213] (89.136.162.44) by AM4PR0202CA0018.eurprd02.prod.outlook.com (2603:10a6:200:89::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Fri, 17 Sep 2021 09:52:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6bface6-d338-45a2-b140-08d979c0cd33
X-MS-TrafficTypeDiagnostic: VI1PR04MB6141:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6141D95C3EDAF103E2D0803798DD9@VI1PR04MB6141.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 30Q/0TSZO+LNrEG/XxuJlHxaUiyiN+sUh3KW3u78zX2jsfQrAp/6MItZL2yDImMjZ40g5ojIx8q/3lu8aqCOjtslROW62F7x03cyu7hVewBKE38oh39liBZsskmvNvx/eayD1ONPJCzKRHlt2+cGuSX4uOomtP9NLjGzZ5YMef66LTB6TXUNvnyzsVRdc3qzx1HYcEo6fZx91OVfLMd88dcgPsuFiPTbW63VLZDJL7wVr3uDTdWT4vkJOFPnN55bK/HhR5ts/XJ0mTYpJoSlULqNE66YmspuXjCwwqvABjrb0wjwliaiFcVlQpWJyWV+vdNZmxrvk7DObnudkoJTjhmEqxGVDvPobMW4i5MNSPzmTsBKUWZOjURb9WmRjVvxn/U9jAU/2rfHz1jZx2cwgiphHG4h8TVxqmQ2owK6abxg5hkmF2Ljl/xKrhkGAju9UdsraUoulrtBJeioEGXr0llKqN/H4S4/QDziQaP0Y0AzlWGm0kCeTluCjEPQxbQHHPNATTKnP5G6lFnsCq9GIkMWv2k4RgTtpo+nhDKoLYxOF5qz8HLZPsdb1SYV2Yt2q6ngwQ0vngLdqOjGJwFwjpY3+rEYM5EKz9uMmvIwt9FABAEBML7a6laYLiUvjVDsG/FYbBp4yU1vcmTVvsihBCn5rtKQJlQQqwmKHT1mYkEInP64DjeEsLzhYUMNOefBw6fQ63NfCbAmepDDrGPt+L+svwIZfJ7TWl6Rl0Vz3h2L0BvtP9HVgec8V808tXg8jxqqys69mHxzheCcD1W+QA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(16576012)(31686004)(5660300002)(316002)(508600001)(31696002)(8676002)(2906002)(6666004)(186003)(110136005)(54906003)(8936002)(4326008)(53546011)(6486002)(38100700002)(66946007)(38350700002)(52116002)(2616005)(66556008)(36756003)(956004)(66476007)(83380400001)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlVZMnZOeEVjVFBEcUQwQ1g2U2tZMm9GcG85SStwc2lJSGs3QmRUMnlvM0ZX?=
 =?utf-8?B?T2RYYkVDbE1OOWptT0daZzNIWW50eVZjbzErSzErb3dsZlV6Zk9rRTlzNEdM?=
 =?utf-8?B?eXdycitJWFNIRTVFWElsbWg0OTg2Ulc5TS9vTEZ0d2NkVlFIdXVkQmpNYkNw?=
 =?utf-8?B?OHVUeDllSktlYnNoaFdVRThEcE9FaWdhMFBNcHpOcmltbEE2L3RaZkluQXd0?=
 =?utf-8?B?QjFmbGUzOGhNSkJTeUNrNTBkb1BZTWk0aG0wZ2xzTjhFZzFIakhENVI2K3Jq?=
 =?utf-8?B?bTdsRW5QWjA0R3lEOFBudG01RlFxTHNGZytFcEgrMXpIREhIQzQ1WnBDMitt?=
 =?utf-8?B?SDlSMmt4VXRVeVpnYWlBMzZaTHFKaWF0VVRXaVd6Y2VBSk12cDlaREI2b2M3?=
 =?utf-8?B?ZVRCRXIwNG4xREI4ZXJhZS9yK1g2c09wb0dMdHBMczdwNzBuVlpCdzAxUUlQ?=
 =?utf-8?B?aXdhNjJJR1hwM3RiUkE3NkQ4a0VWRExUenljT3ZmR0t3Z2xKbDZJM1A0Q3U5?=
 =?utf-8?B?cUtrakI3Q1g4MmNvUTRGZStxL0dWRFo0d1UxNEV5em1hV2JkajNjbXFRTHk1?=
 =?utf-8?B?L2thTXIrTjNDOVdzdEJjODkwRmEvT2dRSmJIYkFLSXZtd1JMRnByQlI3S1Rq?=
 =?utf-8?B?U3Z5QTJmOWtad0lzTC9YQVhvRG9uNm9ta1plYzhiNjEvVmtEdGdJS1VUMVV1?=
 =?utf-8?B?cm1pVk5OOFhLbS9WRmtNbmkyTGF3WXVjbXdwZytLeWZZL3JYOFVlMzhlbVRs?=
 =?utf-8?B?VFJLZ0tLZ0JzeC9ZTDRmWWQ5ays1SHFBeG5OTlBFcytjeVhPdDVwSWFpcURw?=
 =?utf-8?B?eDNhaUpvMmxlNnNkK2M2MHduaExCRmRaa0tpWUx3VEYxQ3RHQ2FGVWJUN2tT?=
 =?utf-8?B?Sk5CYnU4RE9iU3lXdFA4dFhCVk5NckVVVGFVMEVkOVBzS0xwSUhKUnJiejBx?=
 =?utf-8?B?ZXVKVk04bFVQT0dMTUR4ODlHb0szNlJFdlVBNW1xYTRWSGcyVzI5cU1OaWIx?=
 =?utf-8?B?MXhRMlFvTnMvS0NSOGdBc3dqYTU3akF0OHRmZnNyTVhFOEpoYzQra3prQ1pm?=
 =?utf-8?B?SXRhdWdiSDBjTVo4ampxUWJEWUdOSXF6TlNBZUpBaXlYYXYyTmlOTmxVYWFm?=
 =?utf-8?B?bm9HNWF0Mlp6LzBDKzlqSE5lS2NVL1V4TlBLb3R4eTFQN0dTVGZiUGE3d1d6?=
 =?utf-8?B?VUxwbE80L1dqK2FuZU42RVZOblhPNEMrRUlPS3l3SXJrRDVzR3ZueFJKaEpY?=
 =?utf-8?B?UzNneUZmaTdUVXI0VGFaTmU1dzRRcit5NjZJZkRlUk4xY0xSd01oeW1SRkZK?=
 =?utf-8?B?Zkp5TjJXVDU0ZmFXUkpIdTNiWmRNZ1RXSng2ZlFLWHdWdjAzY2JxUlJQeHZx?=
 =?utf-8?B?a2p6WStkamxsN0VSOEJWY0J3LzV6YVhRUHpkdE9QTTlnbWw3UTliYWdFMGlQ?=
 =?utf-8?B?L0VDS1pnenJXdEVUelBDTlZ1cXNVWE1FM0tkVFhSTXkwN2pxN2VaUG9nQVdP?=
 =?utf-8?B?VjBlYU00OEtMVWM2bUJzR3E0RHhyZ3Jld09IN2J2eHM2SkpqcUZtSXErdFhV?=
 =?utf-8?B?VXBaT3lkSE92YzhoOUdLa1pTa2VhbG5wNTJUdGoycTZkbXgvNkFlQjNjNVhO?=
 =?utf-8?B?cllKRUVTdmVYa2NsRFpBVkRZRkVhOTVlSzk0bmszYTIvWWVDZWpjUFN2enNZ?=
 =?utf-8?B?Zld6Z1FlbUJyTFNWcmZFNG1tZWc0UWFST0wxdG9Mejc2c3J0aFhqU0M5Qi9u?=
 =?utf-8?Q?2tK6qlNqpnnuKoiNVSj+z9wXjfOSIY5IE6cHtwo?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6bface6-d338-45a2-b140-08d979c0cd33
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 09:52:03.7142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gPkCMSFw+NDIRCVlLKgL/BNWrmy8Z5qJYjh1QTK+Vf/zQZlCmk1VF0hbuSGhCnk/bsnYn9Ou8QU9cTV+Fx6OyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6141
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/16/2021 5:06 PM, Marek Vasut wrote:
> On 9/16/21 3:59 PM, Krzysztof Kozlowski wrote:
>> On 16/09/2021 15:41, Marek Vasut wrote:
>>> Add MODULE_ALIAS for caam and caam_jr modules, so they can be auto-loaded.
>>>
>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>>> Cc: Horia Geantă <horia.geanta@nxp.com>
>>> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
>>> Cc: Krzysztof Kozlowski <krzk@kernel.org>
>>> ---
>>>   drivers/crypto/caam/ctrl.c | 1 +
>>>   drivers/crypto/caam/jr.c   | 1 +
>>>   2 files changed, 2 insertions(+)
>>>
>>
>> Since you marked it as RFC, let me share a comment - would be nice to
>> see here explanation why do you need module alias.
>>
>> Drivers usually do not need module alias to be auto-loaded, unless the
>> subsystem/bus reports different alias than one used for binding. Since
>> the CAAM can bind only via OF, I wonder what is really missing here. Is
>> it a MFD child (it's one of cases this can happen)?
> 
> I noticed the CAAM is not being auto-loaded on boot, and then I noticed 
> the MODULE_ALIAS fixes cropping up in the kernel log, but I couldn't 
> find a good documentation for that MODULE_ALIAS. So I was hoping to get 
> a feedback on it.
> 
What platform are you using?

"make modules_install" should take care of adding the proper aliases,
relying on the MODULE_DEVICE_TABLE() macro in the caam, caam_jr drivers.

modules.alias file should contain:
alias of:N*T*Cfsl,sec4.0C* caam
alias of:N*T*Cfsl,sec4.0 caam
alias of:N*T*Cfsl,sec-v4.0C* caam
alias of:N*T*Cfsl,sec-v4.0 caam
alias of:N*T*Cfsl,sec4.0-job-ringC* caam_jr
alias of:N*T*Cfsl,sec4.0-job-ring caam_jr
alias of:N*T*Cfsl,sec-v4.0-job-ringC* caam_jr
alias of:N*T*Cfsl,sec-v4.0-job-ring caam_jr

Regards,
Horia

