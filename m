Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B221C56202
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1D152075A
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:39:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="S+/d9LtC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732678AbgKYVjb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Nov 2020 16:39:31 -0500
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:65376
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732581AbgKYVja (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Nov 2020 16:39:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lz7PONWBvCcdlXwjIwWg46wuLZp+Ugu8kzwIqb+T7bpOTAreIX05WAczpjLu3VvE5CTrY2l7PJqPEK40vWY/WmybWE/cfOQyJ5D1QwEuE/SrHUtjlWqvzD/CBgubrP+JxCkJq3twt6gN9KjusQIKZXtOy2ABHvo28hlIgu8ZJXgODjdXT/Jc8OnR04KOn5EN09tKiXRqXKZYr0F5b5K5+xDKVatM0Rkz6v4ax9sDE/PfNVLukHNPJKI0GqryR5UPOCS6GoOon9DWBZgtBUs47siyEdOHTEyO1a3Mhhh/TMr+jAWtAo/v1bG5R7wHGWwLHz6UJ2qaXtXEjdsyMzKaFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWtIflQrdNKNsBblWNXz/ub3zIcOtmOtiwoBeyo0U+Q=;
 b=na2VjQjZ9bLueOlyy+5JRZRphnrN5YzSQtjv6ozbSxWD6K2R7Q7b5/hb0W7iyLm2XoHyu6L0/bttMjW0pZJZGeSw8U3kfwlDl4SjEjiVg1ldVRYdyA7mS8Nk9pLXWfpvHMn2Gp7/KK9HOEc7M15EgnyvyDuV130SMnEzupo/mkhJRDdcvt1vZzMVIZvrD8oT49C+39tHONiR0vvCUNSzD0L1vmK7Ad4D6V/iyzqhlBwnDcd6kzAh6A7SdBrtkOS0d6QlIEeqAvU4AzPm3lY0aQBpUPgKqoZH91HTpe7cjnQy5hVpqR1zPmB7k+eJTHR1S/yhhzKZO/hqItTI8fdnXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWtIflQrdNKNsBblWNXz/ub3zIcOtmOtiwoBeyo0U+Q=;
 b=S+/d9LtCYgZ1hbaDE2p87e7SiwIx+SyciJJ89XDTW2EF1u4GAVFVyAnUSUYQrqjlk7mX9gw7AUtxqoZsB6gq60H7YwNb+zGT2WGPCtl+PdHvjucz55YL0apzpJsI4Mp6CN55wzKeK04J/z1e21d9HnM/3pB0+92ZcWl03MaFZhM=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB6941.eurprd04.prod.outlook.com
 (2603:10a6:803:12e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Wed, 25 Nov
 2020 21:39:26 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3589.025; Wed, 25 Nov 2020
 21:39:26 +0000
Subject: Re: [RFC PATCH 0/4] crypto: add CRYPTO_TFM_REQ_DMA flag
To:     Ard Biesheuvel <ardb@kernel.org>,
        "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>
References: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
 <CAMj1kXH=gyCz7NQXaAoNC4cf37t9E8znngyLFVPv+dO79=Z9oQ@mail.gmail.com>
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
Message-ID: <20b1493d-bfb6-d0bc-3b73-740b216db5f2@nxp.com>
Date:   Wed, 25 Nov 2020 23:39:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <CAMj1kXH=gyCz7NQXaAoNC4cf37t9E8znngyLFVPv+dO79=Z9oQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.26.141.79]
X-ClientProxiedBy: PR0P264CA0062.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::26) To VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.5] (188.26.141.79) by PR0P264CA0062.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Wed, 25 Nov 2020 21:39:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6cbc35f8-8428-4a4f-318e-08d8918a94ba
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6941FC0F9AC341BA512BBEC08CFA0@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yY6awcMngtbp69XJLvLzIhpJ6dK5osz8O6ajRSmfekGxzGnkSRFGkXjmnxVm/q6i1/xR7/hCRSo31Z/JxGDa1rTRk/k8tlqvfjYslXsh7vrnX1V5x/Cp63TYo55OgYBtQUG/0Zzoh/jlzinjL8XFSUAUFZCO/WvqmitwjOJJlZP73LuJmmkLfrE0uJI9nRb5hm/mNnBzoVitiTBtme7nX41s7jt4Tjdx90afMUGT7s/KpX3IlmnZYXuedF5aHg5tcmTwR4YTcdaNk/KSR7P0fGyheTvC8MTHRKb+uOsRd+8JIz4/uj0WKxkz9vBNtgfm8KsKJXhVEGECbPfEynYfFSGZN9WY+OMI8iErz0u/s1UcClTuHN6/IJPVitrADACl/4v8oLHIuNVFi8zfoPcGAvEmMIf5w/hcNb2RGaWRh++XSi28nGHBGsQw+Nqf1LNtY3fub/6t5ODYRIwwbnpbhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(316002)(86362001)(5660300002)(16576012)(66476007)(66556008)(186003)(52116002)(66946007)(31686004)(110136005)(26005)(2906002)(8676002)(6486002)(54906003)(16526019)(4326008)(36756003)(44832011)(31696002)(83380400001)(8936002)(478600001)(53546011)(966005)(2616005)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L2xncDNWWU5qSjdBemwwTTZDSUJrMHArVmExay8yUTByeTBrRnpwL1d6VnFE?=
 =?utf-8?B?dEtUMXBUWnY5bFBNSC96bDVYVnB4aUVycGE0MDluTERHT1lPWmFQaXZvWWRK?=
 =?utf-8?B?eDBIL0hQaU1oYVBmVXNPaXVZK3dHam9qcDNCWElSNmVWWHFFeSt3cGRqRzVy?=
 =?utf-8?B?M213Z2ZYU1RnaGZYTXF1cVN5Q0U2WG1Ha1cxZ242cWxDMEZKNWZZeWZaWXM5?=
 =?utf-8?B?MEg2MEpTMENERTNTcmFJK0JtUjRIYzVQYndlclhGNlZrLzdyMXBuTVUwMkFU?=
 =?utf-8?B?TkNHeVhMZ21HS2V1YWpuSCtGbEthcFBlcS9xTzFKM0tuRldQelpuYUw2dFBq?=
 =?utf-8?B?Kzloa3Zsa2NoR2RIcHRoWU91ZHlZMHNFaVZ2QklWWkgrbUVwK05PbXQ0SWN3?=
 =?utf-8?B?dVJPaytLK2cxQTVnMENVMG5BZXRPT0c4ZWpvM0hlMGJ3N1REdWlnVy9TcU8x?=
 =?utf-8?B?d255ZlIyTEFDcXZxT0VxUjBMNHZPanNZdGJYRm5SNXNvaFI2TDhmK3BWK1Uz?=
 =?utf-8?B?ZEZnaGVlVW41VU5BL2oyeUl1ZFhta3RxMHBCU3FhaXROMTI2VzZxbklqVnVo?=
 =?utf-8?B?VTRhc3o4SUlTcUZqQ0VzM3NVdlZJUkN1anluNlJuRjRxdkowYWpKUnVzTGli?=
 =?utf-8?B?dGl4dE1sRzF5MDFUQ1E2M2RtVzcvbG5lZ0kyOGJUekd3emxKSGtWZWFjTlpq?=
 =?utf-8?B?MXpPSHVpcjJrUkZUb2E1S1FiaGl4Q1orL04vRzRnZzJQeHp5MDFhRTdkU2V3?=
 =?utf-8?B?Q2FjMzBxN2gxRGRHRkRTYlZhUW96ZGx2emFKUDI5WFRPUVpIdUNLalB6bGRD?=
 =?utf-8?B?MFZheTMwbUJCQ1h5RWNWa2JZN1U1WEJsS2YxQlZIcGl1b0ZpcndpQ3pYTmNR?=
 =?utf-8?B?SDdDTXo0KzFIWXNXcW5xK1pyc3pwTHEwUkU3U3JwSW14Uy8vMFcyRnZpbEpn?=
 =?utf-8?B?Nmo1c25sSWkrMENzTzNwOHZYR0FteEZ3dWZ0QXRZbllXOGVOcFRLbk54RXBj?=
 =?utf-8?B?R0lpK25vQ0dLdEtoNld3dU1rMGhhR3FjNUFaY2xmeGhPUUtKMzdWaUo3UUJO?=
 =?utf-8?B?aHgybE81a25LUkxNSGhMYmtiWlVnVlRNYVE1dnVrMWFvUDllOHBrTzFJV0I4?=
 =?utf-8?B?V1RVUjdsSEk3WE9RVy8yY0I0RTJ0OHB2YmpyNnRlWS9iY3FFaGhnQkMrdksv?=
 =?utf-8?B?ejhUNjkycXpBUmdVYTVnK0VXQ0NaQzNVelNiTnJNN3FKMlJ3UlJRNTk5Ykta?=
 =?utf-8?B?UDRjQ1g2aVFnZWg0NkZKSTE3eE9ocmtMM0ltRk53UW5NUk54K1dma014ODhD?=
 =?utf-8?Q?yeK5RvUw3aVLxPW8qn44mz5IwvMUYByIMy?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cbc35f8-8428-4a4f-318e-08d8918a94ba
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2020 21:39:26.1658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DsoPVE3fCzm7XXcKn3Sh9LspBmbAAlRK34JDElzxl3bV1JBELPGaTr5V4zHkIGe/lBY24aQzNCIANoPHvVRs0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/25/2020 11:16 PM, Ard Biesheuvel wrote:
> On Wed, 25 Nov 2020 at 22:14, Iuliana Prodan (OSS)
> <iuliana.prodan@oss.nxp.com> wrote:
>>
>> From: Iuliana Prodan <iuliana.prodan@nxp.com>
>>
>> Add the option to allocate the crypto request object plus any extra space
>> needed by the driver into a DMA-able memory.
>>
>> Add CRYPTO_TFM_REQ_DMA flag to be used by backend implementations to
>> indicate to crypto API the need to allocate GFP_DMA memory
>> for private contexts of the crypto requests.
>>
> 
> These are always directional DMA mappings, right? So why can't we use
> bounce buffering here?
> 
The idea was to avoid allocating any memory in crypto drivers.
We want to be able to use dm-crypt with CAAM, which needs DMA-able 
memory and increasing reqsize is not enough.
It started from here 
https://lore.kernel.org/linux-crypto/71b6f739-d4a8-8b26-bf78-ce9acf9a0f99@nxp.com/T/#m39684173a2f0f4b83d8bcbec223e98169273d1e4

>> For IPsec use cases, CRYPTO_TFM_REQ_DMA flag is also checked in
>> esp_alloc_tmp() function for IPv4 and IPv6.
>>
>> This series includes an example of how a driver can use
>> CRYPTO_TFM_REQ_DMA flag while setting reqsize to a larger value
>> to avoid allocating memory at crypto request runtime.
>> The extra size needed by the driver is added to the reqsize field
>> that indicates how much memory could be needed per request.
>>
>> Iuliana Prodan (4):
>>    crypto: add CRYPTO_TFM_REQ_DMA flag
>>    net: esp: check CRYPTO_TFM_REQ_DMA flag when allocating crypto request
>>    crypto: caam - avoid allocating memory at crypto request runtime for
>>      skcipher
>>    crypto: caam - avoid allocating memory at crypto request runtime for
>>      aead
>>
>>   drivers/crypto/caam/caamalg.c | 130 +++++++++++++++++++++++++---------
>>   include/crypto/aead.h         |   4 ++
>>   include/crypto/akcipher.h     |  21 ++++++
>>   include/crypto/hash.h         |   4 ++
>>   include/crypto/skcipher.h     |   4 ++
>>   include/linux/crypto.h        |   1 +
>>   net/ipv4/esp4.c               |   7 +-
>>   net/ipv6/esp6.c               |   7 +-
>>   8 files changed, 144 insertions(+), 34 deletions(-)
>>
>> --
>> 2.17.1
>>
