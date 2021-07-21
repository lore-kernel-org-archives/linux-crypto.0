Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65604C636C9
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 12:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4639E6120E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 12:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbhGULac (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Jul 2021 07:30:32 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:36375 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbhGULab (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jul 2021 07:30:31 -0400
Received: from [192.168.0.113] ([178.252.67.224]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.163]) with ESMTPSA (Nemesis) id
 1MK3FW-1lo5Ap3rpu-00LRrJ; Wed, 21 Jul 2021 14:10:38 +0200
Subject: Re: [RFC PATCH 00/11] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <66b3b869-02bd-9dee-fadc-8538c6aad57a@vlnb.net>
 <e339e6e7-fc32-2480-ca99-516547105776@suse.de>
From:   Vladislav Bolkhovitin <vst@vlnb.net>
Message-ID: <833cfd62-1e1f-1dca-2e38-ff07b3a5e8fb@vlnb.net>
Date:   Wed, 21 Jul 2021 15:10:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <e339e6e7-fc32-2480-ca99-516547105776@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:zbM9u+v9ZDUik8JpLNXsF0h3y9Y2NPHI/N8c7/Lq5bR/vSdJKcp
 UZrccZ5qijLT8pbjYGo99G2jl0cbo2Aqoyd7CoiZPwrLkpJxwE5yYobTiSE1iJ61MbBjbQm
 s5NvnnGCmAbV4PxAULDCThn0tlG7Wg/rpCTEl8Gx42rQOIkLZ6bIKdnb9VdvRVUy3lYMGDq
 MEKPfG0Xp2DTJdrbdjsMw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hDe7GysI62M=:FkCpEmbyBNAb/Hb1GlBvwN
 x69T+n5bwvlFeX2EbCRLfKQwfD+DEiNO6x6Gefrb2xzzVZ/w7+g52mkNe1pCDhJT7iaODtMeY
 K6Ov6NWgBFAhstWKkUBxQvzen61UR7togP+R7iCtgBzT0rjLNlx3WVH9wgrNCvZbT6EOzmOlZ
 whJDnjDB2f7qaqti3kg9xoazzYugJYnzoBHuCruMJkTjKiKZVm4YgulK8g/OkyeYK6eNvbuVA
 FoObD2/a+HctvDXsLaGy0ZU1Pg/qAbeqAjqR7akfRXr0LNPirCs+XAK4EtVX1D8hiF4CRW8vH
 i20DhWH+Ari6EvLwnCwUurQW5ElcWwZ37zEAXX86yTXb7T4U5D/ocz8kGwS/TH4pncS5hHT/7
 QJU643kS2jgdn6p8//nW+ZpQhFHqer3I6gX8pWwsLWa9QyJH/Rn2YDXMpRHidTRaV9m1rYMgL
 I64NUts2JaBEdzq0AMlzEf7C7JHxZPO25wRjtJtT1MWWwhtvx/XOmFVDnmT+TLltlCuSgZ5db
 4mWPKQCVK2D1fBjNylawiATxFHyDhrLsIqKJ42AEI26PLnx5BR8w7J1oFpEvhrtqTClkMSxIK
 +ZNrWsSkZNQV+uFyE4j81kNlY/zSGMtU9vRHm60VfCz1gf+zJs5cqIOzfBlngDhYao22XYOql
 JJF4vlfNcFSOb24jN5Fye2h6GL2kbiALACFbXYsR9mVDX/1YY8lcC0VUfmXTbV/gPG8hr4qA7
 KGEt+f3WKY7t2bpCaS6uZE9mKiH3EejhnkoBF4Bp3B7IL0hb8pOlcqP2r96Ja34hAcbWf9Hoy
 E/6Wifo9PElo/PyM6JhKGpZtfOD0WAMwZIN6UDlHNyV495kGtrGPnduCl3MEu2swUdOXrve
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 7/21/21 9:06 AM, Hannes Reinecke wrote:
> On 7/20/21 10:26 PM, Vladislav Bolkhovitin wrote:
>> Hi,
>>
>> Great to see those patches coming! After some review, they look to be
>> very well done. Some comments/suggestions below.
>>
>> 1. I strongly recommend to implement DH exponentials reuse (g x mod p /
>> g y mod p as well as g xy mod p) as specified in section 8.13.5.7
>> "DH-HMAC-CHAP Security Requirements". When I was working on TP 8006 I
>> had a prototype that demonstrated that DH math has quite significant
>> latency, something like (as far as I remember) 30ms for 4K group and few
>> hundreds of ms for 8K group. For single connection it is not a big deal,
>> but imagine AMD EPYC with 128 cores. Since all connections are created
>> sequentially, even with 30 ms per connection time to complete full
>> remote device connection would become 128*30 => almost 4 seconds. With
>> 8K group it might be more than 10 seconds. Users are unlikely going to
>> be happy with this, especially in cases, when connecting multiple of
>> NVMe-oF devices is a part of a server or VM boot sequence.
>>
> Oh, indeed, I can confirm that. FFDHE calculations are quite time-consuming.
> But incidentally, ECDH and curve25519 are reasonably fast,

Yes, EC calculations are very fast, this is why EC cryptography is
gaining more and more popularity.

> so maybe
> there _is_ a value in having a TPAR asking for them to be specified, too ...

There's too much politics and procedures involved here. Even in the
current scope it took more, than 2 years to get the spec officially done
(I started proposing it early 2018). Maybe, in future, if someone comes
in the the committee with the corresponding proposal and value
justification.

Although, frankly speaking, with DH exponentials reuse I personally
don't see much value in ECDH in this application. Maybe, only for very
small embedded devices with really limited computational capabilities.

>> If DH exponential reuse implemented, for all subsequent connections the
>> DH math is excluded, so authentication overhead becomes pretty much
>> negligible.
>>
>> In my prototype I implemented DH exponential reuse as a simple
>> per-host/target cache that keeps DH exponentials (including g xy mod p)
>> for up to 10 seconds. Simple and sufficient.
>>
> 
> Frankly, I hadn't looked at exponential reuse; this implementation
> really is just a first step to get feedback from people if this is a
> direction they want to go.

Sure, I understand.

>> Another, might be ever more significant reason why DH exponential reuse
>> is important is that without it x (or y on the host side) must always be
>> randomly generated each time a new connection is established. Which
>> means, for instance, for 8K groups for each connection 1KB of random
>> bytes must be taken from the random pool. With 128 connections it is now
>> 128KB. Quite a big pressure on the random pool that DH exponential reuse
>> mostly avoids.
>>
>> Those are the 2 reasons why we added this DH exponential reuse sentence
>> in the spec. In the original TP 8006 there was a small informative piece
>> explaining reasonings behind that, but for some reasons it was removed
>> from the final version.
>>
> 
> Thanks for the hint. I'll be adding exponential reuse to the code.

Yes, please. Otherwise, people might start talking that Linux NVMe-oF
authentication is too bad and slow.

Vlad
