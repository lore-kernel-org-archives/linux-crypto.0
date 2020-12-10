Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD795C4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 08:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89E652343F
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 08:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387905AbgLJI33 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 03:29:29 -0500
Received: from mail-am6eur05on2087.outbound.protection.outlook.com ([40.107.22.87]:23265
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725953AbgLJI31 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 03:29:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j57CUgheiefd2etagMHc6OJVqEKnUixeJTJxXDzNvYGCxcYx+yyCYyCUhDHl9cdCfvQw67Vrc1I+PcZy6U2su6pZMKxa7FZ9jEOJ+wduq4AJaVKfbDZxO1o0NyT7UwGmrOlsNQykVLCykkKBLKbcg01Fj57dGxZXJiKTGYbPfYc1ULJk9zx8RqdphUUyyKIPNWiBV3ftWPzV5hvlYUziXnXJrabpyC0i3EQw3PKCcoKnfmSH38LPYggKEp+JVofGWGu+HnWiW18E3s/YjFI34cuJhw+mLLuDwubTnVd8vZiSBLjIQ65AhshdjTm8jszdOo+6nblPzEQjlJAJ4nBi6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTw6kcQl6Rr92Gugx/ukC/NtsfU2qCMPR4TnRZYg8YI=;
 b=kptbSITnEXxEp4+8LwBMUj8+3ZjrGEbyzzxx/1rShAB9CipuPP/BFtWOegkXTTSDF1EARN1nsto5Rl6XCJEoVTPF49G6M1XdODpmRjhX0/+EXIbecDTdW2IV2x7qBOAUzv86Cqcb5acMsPCclQwuOKecSGCyJq8QwS64UcW22h05Yo1+cLkY1JC3MXmdzCyugOqrBSll9N8eFeR0kpWnGXzLwuOLLyQU/1NcHy494VxVHEkBw9MzwWh/WhezzQHYMFSbH6QnLsVBt536u8zO4tSSEaUSGUkXWhcNWvsWHEu7OSfFl8Ff/IM1Y6zWP569SWXWqxBEir1j+kWV8xXBwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTw6kcQl6Rr92Gugx/ukC/NtsfU2qCMPR4TnRZYg8YI=;
 b=b0D7DvbXmsDnURJLs/GzItQj6B46Bx4rzIiYGTrOtZGDfi7Rg6G6M9D58wpTc0g2WDEE1A1YzL+nolAAOjCfhIitP4SJDuannFn8dj6YGw3wewWW9bXd5Bo4GmuEWY5xMES+HvaiZYDx++rkyMmDOOixN/EIrP8lee0Je/DT2w8=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB6144.eurprd04.prod.outlook.com (2603:10a6:803:fd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Thu, 10 Dec
 2020 08:28:38 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3cd1:fe15:f8d4:ac32]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3cd1:fe15:f8d4:ac32%5]) with mapi id 15.20.3654.014; Thu, 10 Dec 2020
 08:28:38 +0000
Subject: Re: [PATCH 0/5] crypto: caam - avoid allocating memory at crypto
 request runtime
To:     "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
References: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <d454a0da-395d-3893-9ae1-f52236bcdde8@nxp.com>
Date:   Thu, 10 Dec 2020 10:28:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR10CA0025.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::35) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR10CA0025.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 08:28:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3a8a07bb-7088-4e32-d2bc-08d89ce597bb
X-MS-TrafficTypeDiagnostic: VI1PR04MB6144:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB61447071ABB516CA163C9C7E98CB0@VI1PR04MB6144.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ewy20/zchZ2f+EpF9ENOVyaacMScA1dYaKoicjVTlpQOjuLmVkLKDeUHjkH07Rx3W1VEnLik4shW0S9LxS014mWGAPu7pKoa7MnN8YVwsAg5mb0d8KG67uPSh4NB/0tBwQqTMmxX9uH6jreCpNzArIFLBtF4I65Xb3n/ZNvuTqfcpJSlNZ2mdEUc8NfnnrWvkVSEHX0XVXIOl2uJz5vAq5p/BdL/fg3TKen5+0Z3IUIxO0uPoKQa06U+ZBSweONIT5hV3Ml1HqQn3X4LyZpRod2rcaNig1tAtadLB6b72ZX8fAVZFzDeNzEFCew+dsyi9BzV6yzNHPthOgkAXPWg93jlGD/UUKtErlf4cE5u0iU2K9xPhpYTcA4eF6sIwU4u3zMSk1uOTv5taKkHxY6Yij7xw3VDmE1o7k2uoSSwbYYu2v1iLYAqns4yeBMIkc2C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(66476007)(508600001)(2616005)(53546011)(52116002)(6486002)(186003)(5660300002)(8936002)(8676002)(16576012)(16526019)(26005)(34490700003)(31686004)(54906003)(110136005)(956004)(36756003)(66946007)(66556008)(31696002)(83380400001)(86362001)(4326008)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bU5EdHp0WlU5TU1wR3FJc2tBUVNoT09ScmNZdTlJbUFYZkxYL3lUVDAvSjZK?=
 =?utf-8?B?L1U2U2VzWmFhT1R3NG1mSjJsMSs0WDNOejN3c3QzNVFiTnYxQXYySUNFb2RP?=
 =?utf-8?B?MXZqcitPaG1nMm5TNXZNcFJSMGg5QkpEMzFEcmt6SUlUWEYxY24vMVB0L1J5?=
 =?utf-8?B?a2JuS2ZmWkxIc1lLcUdIaVl3WW0xU3QwV2YzVFlYQmVaSXNkRi9uKzVaY1lt?=
 =?utf-8?B?ckhVWU5tM2RCS1JmOFhVU1c1eG5NdUcwS2cwTWdFUEVVaU9yeWIybjROSXc4?=
 =?utf-8?B?SGhnSmtKUU43cTd1dW13SDR0czVWbWZ0QjdKaUJWL2FKWkZtK25QR3U1a3JT?=
 =?utf-8?B?MDZBU1ZwNkQ4cm42K0hOUlJnM3J0SnlBTGJkN3lXZzdsaGhVc0Z3Sk94bzd2?=
 =?utf-8?B?NXk3dERIT3VjWjlLN1FOWENVc05vQ1BmSkwzejJtQWFBN3dSTWlKbVovZHhl?=
 =?utf-8?B?bWxXSnVoTUJFQlhnRHI3dUR6WmZuQlRwdDE4Z0NpZm1ST3RpLzVnYXFkVkZm?=
 =?utf-8?B?cEVPdFloc2gxb0tHL1hlZzBhOHZxaml2MnZZWkJlNGkwSU9DWGV0Ulo0dHlm?=
 =?utf-8?B?SThWaitFdFlVRHZtRlhtczQvMDRkb3Y5OEo1NERHandjUnQ1OTBxay9YMTYy?=
 =?utf-8?B?TzlBT0lka2d4cUJnektxODhHRGNyWHdFa0gxQnh0Z1pCemxPVE9PYm1SYita?=
 =?utf-8?B?a1dDYkpZQnA2N09RRG1FQ1JWSFZCalhINDZ4dDIvVlZyRVc3ZFRDNk1uWVlQ?=
 =?utf-8?B?cldPUE1WUVJKRXVmUXhydmpIeklvb0hGWWYyNk82QWVqRHRoUHVKVVlFVXFC?=
 =?utf-8?B?UkNEeDlvVnFxS2w3YUJ1TG11V1BMUWk3bm9GU3hQaHhBRWxNK0UwUGUwSXJW?=
 =?utf-8?B?YVZ5NE5NY1YwUHhaRW90dlg1d1pXaU8yZms0UytRaDdYUW15eERHT0MrRTlU?=
 =?utf-8?B?bDRRUUdDOXFyV1F5NkZ5U2xqcHlPSHJSTGFCVUFqSHVkS0tuNW1neFFwZDFj?=
 =?utf-8?B?Z1VtSGtMdDFPTTduNGk1T21VZ2VCQ045cW1ZdFlReXdScUxWaUpoWXo5RkRT?=
 =?utf-8?B?TDhhMVArK3RVSkREZ0x0Vm41Q0NrelNWYWlDRXpxMjQ2cXk2dk0vc21DMllo?=
 =?utf-8?B?QjVVWmFTSS9LWUhqeHQwVkZSZ2FqOGx1TC9kb2l1eVpBNjllK0YyTHRIUmJ3?=
 =?utf-8?B?Ym1CT0UrVzY3K2svcnU3Qk5HdFFmc3pudC8rb05QbFROT3hGSGttSlNZbEJu?=
 =?utf-8?B?RUk5VDh5QW0rWW1sdi9ydVJXZUdTL1ZNRjlXTWNZOHpKTldpbUdsb2FvL0ZQ?=
 =?utf-8?Q?JDHHlsiAJhRtFw44ujNEsT2bAkqvr3l+sk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 08:28:37.9188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a8a07bb-7088-4e32-d2bc-08d89ce597bb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LHPZF0979IQdIMAOkCyOYuOUcU8tSyqL+PrMXTj4qmxUncLhsuUiPUwNn/tvoRokjHTcHJW6q0LYpS5gN6GIlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6144
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/3/2020 3:35 AM, Iuliana Prodan (OSS) wrote:
> From: Iuliana Prodan <iuliana.prodan@nxp.com>
> 
> This series removes CRYPTO_ALG_ALLOCATES_MEMORY flag and
> allocates the memory needed by the driver, to fulfil a
> request, within the crypto request object.
> The extra size needed for base extended descriptor, hw
> descriptor commands and link tables is added to the reqsize
> field that indicates how much memory could be needed per request.
> 
> CRYPTO_ALG_ALLOCATES_MEMORY flag is limited only to
> dm-crypt use-cases, which seems to be 4 entries maximum.
> Therefore in reqsize we allocate memory for maximum 4 entries
> for src and 4 for dst, aligned.
> If the driver needs more than the 4 entries maximum, the memory
> is dynamically allocated, at runtime.
> 
Moving the memory allocations from caam driver into the generic crypto API
has the side effect of dropping the GFP_DMA allocation flag.

For cases when caam device is limited to 32-bit address space and
there's no IOMMU, this could lead to DMA API using bounce buffering.

We need to measure the performance impact of this change before deciding
what we should do next.

Thanks,
Horia
