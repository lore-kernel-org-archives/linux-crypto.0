Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B484C63798
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 16:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DEEB21D40
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 16:00:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="dONczpa3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391498AbgKZQAO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Nov 2020 11:00:14 -0500
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:62691
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730602AbgKZQAO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Nov 2020 11:00:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nwi0B5VlKHT1BsuBaIOnBjBH99JNCmm2+gkljsa3nI9em0LrUxoLfDTaQEWjJmqVqNPO6bGFNGDpyvejtST2EyAt70pz//l6zA/rlWSRG1QeiqnKDA3UFWjvy3+4D0HgUtTxvS8W0mr8EQCumqNjkdzDStPXEodpL3N2dtrr7CF08HdMQHunlLJuaNtcEKQo9vr3q0uoiXuW3ORpDkNwvFo+O7gv0IuC9eOk4gam5m7yrje/kh6rCN7/GU3mYgQVD8O0QQv8x9H7do9UHaAboc1h6BEDlqiCArtmfggH6Q8b86a8JRRXd3G1j8x+ZB5HjawKxdshNBY6YeJ5gKi47w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QdodjfIcX+67mOg3QhTHDb6Kci1LRYAwUuQnDyitnM=;
 b=X0h4J4g0Lrc1DGGwQmO9T+AwlXhkJTjQAwXsjhjS0iYOw1ylfUDAq8yePnxNyMtjyQG0P6omCn42yBqXuAcbR2i+lGzW6IhvJsc4KFqwZGIFHIgLHAIIhXcEDl/ygudlIDZRG+yEx6wkIAN/lKzEJH1QmO51ncZhgSA79HXFyoywQqzuaxP7heeM/kxEq0Gcqi8waZzDkfkN9mBjxgBYfHK5D+49OLF+s2eh979jmvJJctvhHDdP6V4isHZRGBzA0UkLneBffnVMIvEYn2eZ6XGimOxtjH/w61vm6IfsR8fhKMwEOglsoS3ER2g7u1MuuJ5j0ZCl628rXVV8xF+ajw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QdodjfIcX+67mOg3QhTHDb6Kci1LRYAwUuQnDyitnM=;
 b=dONczpa31c/o238dY2kkcsO9Zqt7Xy1DARqyJ33NAIbI5m4sQ5h2LUnulWFbhc2yp56WaRKbKjvMJPRXC9SAgWfh1BXJ06JUrid1kBMDSuXjO+upAp3EvUPMNXeIo12fHDJnfvjMqhBkNjvIcNJ5zlLsdIDPNFxnHuODLil+mqQ=
Authentication-Results: oss.nxp.com; dkim=none (message not signed)
 header.d=none;oss.nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VE1PR04MB7325.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Thu, 26 Nov
 2020 16:00:09 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3589.025; Thu, 26 Nov 2020
 16:00:09 +0000
Subject: Re: [RFC PATCH 0/4] crypto: add CRYPTO_TFM_REQ_DMA flag
To:     Ard Biesheuvel <ardb@kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>,
        "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>
References: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
 <CAMj1kXH=gyCz7NQXaAoNC4cf37t9E8znngyLFVPv+dO79=Z9oQ@mail.gmail.com>
 <20b1493d-bfb6-d0bc-3b73-740b216db5f2@nxp.com>
 <CAMj1kXGBa7st9duOu1Z1y28_-Xci3ur7kevAP+pPFp6+xvcy2Q@mail.gmail.com>
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
Message-ID: <50866e6a-e352-3728-a6c4-1fcc33af13f9@nxp.com>
Date:   Thu, 26 Nov 2020 18:00:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <CAMj1kXGBa7st9duOu1Z1y28_-Xci3ur7kevAP+pPFp6+xvcy2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.26.141.79]
X-ClientProxiedBy: AM0PR03CA0014.eurprd03.prod.outlook.com
 (2603:10a6:208:14::27) To VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.5] (188.26.141.79) by AM0PR03CA0014.eurprd03.prod.outlook.com (2603:10a6:208:14::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Thu, 26 Nov 2020 16:00:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2c73529c-8079-44e1-2c12-08d892245949
X-MS-TrafficTypeDiagnostic: VE1PR04MB7325:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB73256D1E7534EA5FDB601C068CF90@VE1PR04MB7325.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Isc5ktcjrKnDpNPpKxVFpt9bN5zB0Btrt5ubV8+PVm6RIhPi7jv1Hfi2Pht0gtvVs3K7a3cTFR3DJnwA7/WzNI2uA9YBflSHP5Gzu2wQdyWXd2WFf91yS3lA50QTtiq9i63npaw+7ui+RAOzz8Q5xanowOP94pO5XhgRCHZMuHM2fgKF6Rz5EiKVe5qwUarI/NMXyIwubn83Doz01qEIcIzh1aSWN5khqHwOewX/05AzZeYOYw+9tKemYIbFiRAhecatXjzJZxwUKDpzM0WQYSIhvb3QSAnJTaOxz+a2rlcwQUIP8P2jup1bB30ZBh3zhH8ovvVOVjyumAt73xlxqnbY9V5NlplQC6kDMVWbkfpkLwKxT4lq8+UWxKN/5gb3xFVNtJ+NwFvMTNqz6FEp8YzseQu3/weJ77CXpdHLMmElE4bM8VId6Ez7E9xBV1AyRLEAJ4721O5BHIpdX/vZPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(86362001)(31696002)(54906003)(110136005)(2906002)(16576012)(16526019)(36756003)(26005)(186003)(966005)(2616005)(83380400001)(8936002)(53546011)(45080400002)(44832011)(6636002)(4326008)(5660300002)(52116002)(956004)(8676002)(6486002)(31686004)(66946007)(66556008)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MGtpZFlsS3YzQWVBVGRCa0pBSlVJTExhZ3ZTbCtodWtxc05mdU5WbzB3ZmQw?=
 =?utf-8?B?dFRQTUtSbkYyNWNPelNtWnNqZG1HR0FmVnQ4cjVIdUw4NS9RdmxDL1VPVHhv?=
 =?utf-8?B?YlRDc1JVb1A5NjUxYW1RbncveE5CN04zb2ZQRlJCSUZGNGZaZk5rc0RtUWxQ?=
 =?utf-8?B?Mmx3VUdXUzhTSUZLbjZqaVhLWThhM1B3UDJsQitYVGUxWmJRUGFvVUdENVhw?=
 =?utf-8?B?cGx1eDlaV0dwQnVRT3lUVjdWaVN2WlVZcUt3akxOMjlGbTdHWUs5N1g4SkhG?=
 =?utf-8?B?a0c1b3Q1MEFXYXRQUHA0RXB2aHJwN00wWjQwQ0NzdjZJelpIZ2srMTU1dXVs?=
 =?utf-8?B?YVBnQ0NSTlhPQi8xSURUMWc2MGlxL2NlQUdrMlRnRUhDbEZpUSs2NWcxSmdY?=
 =?utf-8?B?aUdsV3FqMnhOeUZLOW9uczZ4cDBHS0gxcC8yVGhlb3hCajBQbEdEcHFBN1h5?=
 =?utf-8?B?bmtlSk5IYUZVODJocjIzYk5ja1ppWmc1NGV3cldUQTk3ODNXOUNlc3NRNFdD?=
 =?utf-8?B?dVRpV3BCeWxSbmhjTXZvWUFLeFF5dDBGUzJBZVRTWHNJZnlkc1phOWlTWUFR?=
 =?utf-8?B?SUpSdHBXQlY2WmZKMmQwWXhXQ0VJMllkY1djbkdyNUV3eDZlenl0d3pDZ0hW?=
 =?utf-8?B?TXNULzVxakxqdW1GNFNsVDVZdmJqN0VXaTlkcFRXc1gxQ3M3dHJMSTNCNVVy?=
 =?utf-8?B?Rm4xN3Q2OS94YTZKbVRaZkFMeE1Lbzh0azFiTi9SVXh2V3gva0tadjkzQmNm?=
 =?utf-8?B?Wk9ldW5LL0txQ2RLSC91Y1grWTVON21icDVvZGg5NWpYNUVDMjZqYy8vYWd1?=
 =?utf-8?B?SVZORmhsSG9lT0tTcnA5RjNHa3VjRGliWW5vRUhaUGxQYnBselptbldNdlRQ?=
 =?utf-8?B?R2kxaCtwTTJZSE85elRId2c2L3pmUFdMeUREN0ppQ09JclFqMHFLS3pLeFJz?=
 =?utf-8?B?TWZ3UDBhWk9WMmQ5dmtoZ1JvOW5obGZKV0xUNFJiRlVXMkEzeUVjSEZudHFk?=
 =?utf-8?B?aUE2Y1FZM3dueVE5bTRjRTZqdHV3NTdZUkMzTWE4VEtzbWlVcFdHc1JKcW9u?=
 =?utf-8?B?NzJJRGdMd0JTTkJ4MW9mRnExSmQweC9idmtVcVMzM1Uyd2VoaDNNZFJxU0JN?=
 =?utf-8?B?ZUNjT1JvRFh3eFcxVnNZM0JlVVdaWVl1OTV0VHoxbHFxZzUzNWEyeSt1Rk1x?=
 =?utf-8?B?eEhkME0xZGdrcDErWFBNSFVIVGF4bzR4VGo2OC9CdmJvZUNiaGlIcUM2NCs3?=
 =?utf-8?B?eC9LdDN3RGZUSFdoUGVnZkJXSVR3N2t3eXc4K1NlMndiQTcrMElEVW9MZHJS?=
 =?utf-8?Q?qpMAnjmiNFyt6DXFwjqDzugtsLdPR3FirU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c73529c-8079-44e1-2c12-08d892245949
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2020 16:00:08.9009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G/0PzUg9/ExEsu9ozmTDYsHP2zJwKIJezGfE6GN91lULfWTWDM2ey0lk62uC90b4id543SvdkgM4KrnawYZTrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7325
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/26/2020 9:09 AM, Ard Biesheuvel wrote:
> On Wed, 25 Nov 2020 at 22:39, Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
>>
>> On 11/25/2020 11:16 PM, Ard Biesheuvel wrote:
>>> On Wed, 25 Nov 2020 at 22:14, Iuliana Prodan (OSS)
>>> <iuliana.prodan@oss.nxp.com> wrote:
>>>>
>>>> From: Iuliana Prodan <iuliana.prodan@nxp.com>
>>>>
>>>> Add the option to allocate the crypto request object plus any extra space
>>>> needed by the driver into a DMA-able memory.
>>>>
>>>> Add CRYPTO_TFM_REQ_DMA flag to be used by backend implementations to
>>>> indicate to crypto API the need to allocate GFP_DMA memory
>>>> for private contexts of the crypto requests.
>>>>
>>>
>>> These are always directional DMA mappings, right? So why can't we use
>>> bounce buffering here?
>>>
>> The idea was to avoid allocating any memory in crypto drivers.
>> We want to be able to use dm-crypt with CAAM, which needs DMA-able
>> memory and increasing reqsize is not enough.
> 
> But what does 'needs DMA-able memory' mean? DMA operations are
> asynchronous by definition, and so the DMA layer should be able to
> allocate bounce buffers when needed. This will cost some performance
> in cases where the hardware cannot address all of memory directly, but
> this is a consequence of the design, and I don't think we should
> burden the generic API with this.
> 
Ard, I believe you're right.

In CAAM, for req->src and req->dst, which comes from crypto request, we 
use DMA mappings without knowing if the memory is DMAable or not.

We should do the same for CAAM's hw descriptors commands and link 
tables. That's the extra memory allocated by increasing reqsize.

Horia, do you see any limitations, in CAAM, for not using the above 
approach?


>> It started from here
>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flinux-crypto%2F71b6f739-d4a8-8b26-bf78-ce9acf9a0f99%40nxp.com%2FT%2F%23m39684173a2f0f4b83d8bcbec223e98169273d1e4&amp;data=04%7C01%7Ciuliana.prodan%40nxp.com%7C436d50e009434fd1c52808d891da3c8f%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637419713794116972%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=38rJuxFhPWDJXWc2R66Hu%2Fn7vve9u%2BeF0Evp%2BFAhCwQ%3D&amp;reserved=0
>>
>>>> For IPsec use cases, CRYPTO_TFM_REQ_DMA flag is also checked in
>>>> esp_alloc_tmp() function for IPv4 and IPv6.
>>>>
>>>> This series includes an example of how a driver can use
>>>> CRYPTO_TFM_REQ_DMA flag while setting reqsize to a larger value
>>>> to avoid allocating memory at crypto request runtime.
>>>> The extra size needed by the driver is added to the reqsize field
>>>> that indicates how much memory could be needed per request.
>>>>
>>>> Iuliana Prodan (4):
>>>>     crypto: add CRYPTO_TFM_REQ_DMA flag
>>>>     net: esp: check CRYPTO_TFM_REQ_DMA flag when allocating crypto request
>>>>     crypto: caam - avoid allocating memory at crypto request runtime for
>>>>       skcipher
>>>>     crypto: caam - avoid allocating memory at crypto request runtime for
>>>>       aead
>>>>
>>>>    drivers/crypto/caam/caamalg.c | 130 +++++++++++++++++++++++++---------
>>>>    include/crypto/aead.h         |   4 ++
>>>>    include/crypto/akcipher.h     |  21 ++++++
>>>>    include/crypto/hash.h         |   4 ++
>>>>    include/crypto/skcipher.h     |   4 ++
>>>>    include/linux/crypto.h        |   1 +
>>>>    net/ipv4/esp4.c               |   7 +-
>>>>    net/ipv6/esp6.c               |   7 +-
>>>>    8 files changed, 144 insertions(+), 34 deletions(-)
>>>>
>>>> --
>>>> 2.17.1
>>>>
