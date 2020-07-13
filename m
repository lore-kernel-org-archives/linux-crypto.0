Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61625C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 17:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F33F207D4
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 17:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="CSUYXOZ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgGMRxN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 13:53:13 -0400
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:54727
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729826AbgGMRxM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 13:53:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwQqgJu57NCrtYDjTFrWWfi3do2k3JkLRPbGHfku6A3WEQopzrXi3IIh+gbWLE4o6IWOIJeJNeVM3NZJHRtLPWPqnVDFkSiDyml8UhMjFzvyDVbXJ3hFgUuhUjVWnzvx0jyPsnSaWLLsKNYu4jQZsyDsWRwfCKVnK53XXkQT1jJHd50uFsDZ3KC98xrfmZnyXhycTm9ZnWOX4Oaiqaq9m3CMi2RkPbhdO3gXvqsTf3BR1A3k9UEjmv5+tDLEoARA8BZ8z0nAsS31jEntW9kONM3Ex+OtDDad7d4vPv2xFW4wi/oxZ28X1YwakHwu2cHrfXOJR/su4RN4ym2GyvbXFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTix2+7xPU9UVZoKeoM6U06j7/y/9wLyrSuIYOKtdTE=;
 b=O0cH77Un1iGJbQ8gwvVqBcDSwVC/CdjxNgWiso9vKwezeQ7/MZl0+9gV4v2jcvCNvoGxyS4XLC+yMwI2Y1c7lmgVrSeW05ZrEYy56bBHLS2KmNFmjbl0RwNhPsGZIMnNQ90Mt7q3kXm6h2Djp0rYSQRWaIIzs2yqESibH4oyBm4q/9wjjl4xmEOdVlofhU4BZOGqLtc5cR25wUrmvzcSwma2ULHOZfa80AjGEKkG8PaK8kVtWaFPnUUi9IyCETsz4rYpeq+FUOrIdCIOyuhRj/K3v+ygbmZFGrGxhQS9ik+Ks0gSOWBf7hItzehAk9u/3evR22i+DUuAbSKzdrW6Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTix2+7xPU9UVZoKeoM6U06j7/y/9wLyrSuIYOKtdTE=;
 b=CSUYXOZ0siOuwt322xYS+ITUeF3iUgcbM8p/6SoDN3W77d/ETOh1U/rvXTo7K2L9XNPZtU2/rgJT3lI7ElNLUv78w+OFDMU79hyzq5wmU6d7fhkNSx3s+275ONZ5FoL/i1QkqSJQEPd34e+vCAf1M4MwW9JHqwTtd5DZf6Yfb80=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB4045.eurprd04.prod.outlook.com (2603:10a6:803:43::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Mon, 13 Jul
 2020 17:53:06 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3174.025; Mon, 13 Jul 2020
 17:53:06 +0000
Subject: Re: [PATCH 5/6] crypto: set the flag CRYPTO_ALG_ALLOCATES_MEMORY
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
References: <20200701045217.121126-1-ebiggers@kernel.org>
 <20200701045217.121126-6-ebiggers@kernel.org>
 <3f2d3409-2739-b121-0469-b14c86110b2d@nxp.com>
 <20200713160136.GA1696@sol.localdomain>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <780cb500-2241-61bc-eb44-6f872ad567d3@nxp.com>
Date:   Mon, 13 Jul 2020 20:53:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200713160136.GA1696@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR08CA0264.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::37) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by VI1PR08CA0264.eurprd08.prod.outlook.com (2603:10a6:803:dc::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Mon, 13 Jul 2020 17:53:06 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dc39e25c-c5c2-4b5a-4331-08d8275598e0
X-MS-TrafficTypeDiagnostic: VI1PR04MB4045:
X-Microsoft-Antispam-PRVS: <VI1PR04MB40458E035425EB717BEED00E98600@VI1PR04MB4045.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VnO+VCZsI7YnG4cgFbPhEOnzojLDh7PHQXIxRaSm0AFof8OffOBX9swOo4ewYc3DfKdTxgBhNWbe+BvDwMmJLvaNhD8UiDWpuBB8ZO0fmggVdxD3amQzwSYEN8GApeZEOkEEpVOvU0/9NprQJ25TdIPWIFx7pehoW01MKXy58hqkDz2XcH2txPQBcg8/C7W+1cMsAl9+209d/892HlTXoNVaTgOOBm46thN5DvUXMi9wHWhQYUOcuykExc/z93MV5ATgBgOLOExWx8jAcpt4ZSBf6gqvp6wRqmtgI49bcTaW0eOAjyWVTeEFO1HMzgIfXFQ4K2xuj4i/1PuPuRWAInp31WhS6j2RgWcPtFv5hrhQq4XTq/2JARmuez+/bjSVWDw6Aqeu4+cLSH4td8Q72j2KsuUXI2a6CU6cWUkQP7QxBBZMNgoTyoOe4kx8EQV5cgd6727A51LAkkxVZ4YmMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(36756003)(31696002)(6916009)(66476007)(86362001)(66556008)(66946007)(8676002)(478600001)(966005)(4326008)(8936002)(5660300002)(956004)(2616005)(316002)(54906003)(31686004)(2906002)(26005)(16576012)(186003)(53546011)(83380400001)(52116002)(16526019)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: v/8aIDjdrH2N3Zf/VvhFi4PvCi3CVVxTnhHvNQDYSgGsXPunThCYtojtodr6jyw60tVpwboNedsj2F3f46nELHRw1HSaeeyYgbE+ZZrAVSs180jhvrP0TecxezNFhaXW+8seRnG5p7vIVDzwLdstzWfORPcnQVtqIun7+pFwALBWBRWbeVSr2vnmzT1MJSu5h10DB8hKTsv6ZF4RrwbFERb1RBNsjlZAWZWpMzodl87g52QQEpvLa9a4/xVdpdFBxXvxut+yJ4eBXj3NhRVWydgeaA687cMPx/UytwVtMUpswZ3pvDjIPMnw68pHMiG2wJy8NlbFM1JO58sZdCHg8jCw6QeJmmoloy4/cKnWpazg96ou+HNXU37pcUc/rJEhfbRqttwR7CA1PWVAwzZllIv+57BvXHs+Qi5biX1+MOetUF9mImo0lsPCmWR7HuCPn0yeAQVj3Qwfw82u5sSkm+N7LMlvySp1w9MqkLSRYEo3mb80MgRWh3/YZHVgxugp
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc39e25c-c5c2-4b5a-4331-08d8275598e0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2020 17:53:06.5031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VySyus4Zb29Zvp/2jxsnJizV/jFuuxDEvEZ3+i93b2vZTI+/TJ7OQOdzcQI7RU0vzfA//3KVx4vMyEEVkQL1WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4045
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/13/2020 7:01 PM, Eric Biggers wrote:
> On Mon, Jul 13, 2020 at 06:49:00PM +0300, Horia Geantă wrote:
>> On 7/1/2020 7:52 AM, Eric Biggers wrote:
>>> From: Mikulas Patocka <mpatocka@redhat.com>
>>>
>>> Set the flag CRYPTO_ALG_ALLOCATES_MEMORY in the crypto drivers that
>>> allocate memory.
>>>
>> Quite a few drivers are impacted.
>>
>> I wonder what's the proper way to address the memory allocation.
>>
>> Herbert mentioned setting up reqsize:
>> https://lore.kernel.org/linux-crypto/20200610010450.GA6449@gondor.apana.org.au/
>>
>> I see at least two hurdles in converting the drivers to using reqsize:
>>
>> 1. Some drivers allocate the memory using GFP_DMA
>>
>> reqsize does not allow drivers to control gfp allocation flags.
>>
>> I've tried converting talitos driver (to use reqsize) at some point,
>> and in the process adding a generic CRYPTO_TFM_REQ_DMA flag:
>> https://lore.kernel.org/linux-crypto/54FD8D3B.5040409@freescale.com
>> https://lore.kernel.org/linux-crypto/1426266882-31626-1-git-send-email-horia.geanta@freescale.com
>>
>> The flag was supposed to be transparent for the user,
>> however there were users that open-coded the request allocation,
>> for example esp_alloc_tmp() in net/ipv4/esp4.c.
>> At that time, Dave NACK-ed the change:
>> https://lore.kernel.org/linux-crypto/1426266922-31679-1-git-send-email-horia.geanta@freescale.com
>>
>>
>> 2. Memory requirements cannot be determined / are not known
>> at request allocation time
>>
>> An analysis for talitos driver is here:
>> https://lore.kernel.org/linux-crypto/54F8235B.5080301@freescale.com
>>
>> In general, drivers would be forced to ask more memory than needed,
>> to handle the "worst-case".
>> Logic will be needed to fail in case the "worst-case" isn't correctly estimated.
>>
>> However, this is still problematic.
>>
>> For example, a driver could set up reqsize to accommodate for 32 S/G entries
>> (in the HW S/G table). In case a dm-crypt encryption request would require more,
>> then driver's .encrypt callback would fail, possibly with -ENOMEM,
>> since there's not enough pre-allocated memory.
>> This brings us back to the same problem we're trying to solve,
>> since in this case the driver would be forced to either fail immediately or
>> to allocate memory at .encrypt/.decrypt time.
>>
> 
> We have to place restrictions on what cases
> !(flags & CRYPTO_ALG_ALLOCATES_MEMORY) applies to anyway; see the patch that
> introduces it.  If needed we could add more restrictions, like limit the number
> of scatterlist elements.  If we did that, the driver could allocate memory if
> the number of scatterlist elements is large, without having to set
> CRYPTO_ALG_ALLOCATES_MEMORY.
> 
This sounds reasonable.

> Also, have you considered using a mempool?  A mempool allows allocations without
> a possibility of failure, at the cost of pre-allocations.
> 
Thanks for the suggestion.

Would this be safe for all cases, e.g. IPsec - where .encrypt/.decrypt callbacks
execute in (soft)IRQ context?
kernel-doc for mempool_alloc() mentions it could fail when called from
"IRQ context". 

Thanks,
Horia
