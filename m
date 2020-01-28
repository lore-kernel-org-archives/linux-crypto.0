Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC54C33CB7
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 00:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 300A62467F
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 00:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aj.id.au header.i=@aj.id.au header.b="nSY7MuUg";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="t+Sr/QmT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgA1Axo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 19:53:44 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:45319 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbgA1Axo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 19:53:44 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id B2CFF352A;
        Mon, 27 Jan 2020 19:53:40 -0500 (EST)
Received: from imap2 ([10.202.2.52])
  by compute4.internal (MEProxy); Mon, 27 Jan 2020 19:53:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm1; bh=blHIYvtrRVAHoWVDNslQKxu+cyHHHav
        Ikxh1pjfbb+M=; b=nSY7MuUgF727W/Fhydb46f9Kjw4h2UDlmUivqfrJI9+eefA
        0wcEJfRsjrwI/ZX+DwpE83RpT0aHWB2z4S18+SdFu1Fjqba2FtnWFQ/VQ6rRD7mc
        Dde6FgaeDaxjtKCpPdN5RaG5Jtvv51+VHPoAGafA/zBqPr/1shRSIebmZH+J/pCg
        e4bHnf1mIzFAXaQfKYIKTxu+cDyDgicZJjXzbl0K5lGb6T6sTvOJfwOzDkVXpdu1
        ewIJCy4vMbG0ryoihHtaxsoKrsZ2lqava55RtIkElXaW84M14r2RKEoOn6kry7bk
        jwQZ2jMa7NYf5G2Vs1zn2kuyuighnTo5lzjcwOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=blHIYv
        trRVAHoWVDNslQKxu+cyHHHavIkxh1pjfbb+M=; b=t+Sr/QmTMXtyUEjl2/Ln1X
        8eUU6Hj07lBbd+UlAS9UcPTnB/UfFWn+d84+J931HXfFh8/lNJACnKQIfwrEby7Q
        avcfr9uw/1o952zTcD/lhoewiygRlYEBzg+ZeoxBLOmKkm5MTwCkNAn+2hbdr/yN
        pf0GFjdiE3fm9nj+BbqDGjPKAqSSfALsaHFKUrSwCk1/L6PqAly/JDGwNqEVLsqp
        0Y4ajP8O+w30UdxGepCfpnWzApS6iJSLUuqzKnhHhrJs7Ayp8nLxHpHjVEhmjTaI
        Pd5kyXpJF6aGDkTiwFHZeiF+4HFxZ3vcMQZc5+2++e1gsReZaoa8hJ7aETq59yIA
        ==
X-ME-Sender: <xms:EIYvXlswTcnRWtTH_PvgM9OKYC0tzjmAELKVOOILJY4J07gNU2YNOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeefgddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedftehnughr
    vgifucflvghffhgvrhihfdcuoegrnhgurhgvfiesrghjrdhiugdrrghuqeenucffohhmrg
    hinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomheprghnughrvgifsegrjhdrihgurdgruh
X-ME-Proxy: <xmx:EIYvXgqG8IlDTgLTlMQmwIXN0z6Evqc7rRgNehPq_nQG5WquiBVndw>
    <xmx:EIYvXrihR97tETVtxI3gVASNGNc58ud7y-TzAKjjmhDBKnSz_7ovsg>
    <xmx:EIYvXnmrPn5UNelWW5gUNkbQUG7gkIw01qC7j-Z2U4108rVPXbJSkg>
    <xmx:FIYvXnwIY2fypY7y9_Jey6LqBsx4t8_wmhIpeQmzF37v2z_3iQBsPw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 44E0EE00A2; Mon, 27 Jan 2020 19:53:36 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-781-gfc16016-fmstable-20200127v1
Mime-Version: 1.0
Message-Id: <b83f2a1f-e1be-433c-8dc8-c469cb38f423@www.fastmail.com>
In-Reply-To: <136bbab84d13d8d56a5ac297e415975e@neuralgames.com>
References: <20200120150113.2565-1-linux@neuralgames.com>
 <CACPK8XfuVN3Q=npEoOP-amQS0-wemxcx6LKaHHZEsBAHzq1wzA@mail.gmail.com>
 <4446ffb694c7742ca9492c7360856789@neuralgames.com>
 <575811fd-24ca-409c-8d33-c2152ee401d7@www.fastmail.com>
 <136bbab84d13d8d56a5ac297e415975e@neuralgames.com>
Date:   Tue, 28 Jan 2020 11:23:19 +1030
From:   "Andrew Jeffery" <andrew@aj.id.au>
To:     "Oscar A Perez" <linux@neuralgames.com>
Cc:     "Joel Stanley" <joel@jms.id.au>, "Matt Mackall" <mpm@selenic.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        "Linux ARM" <linux-arm-kernel@lists.infradead.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] hwrng: Add support for ASPEED RNG
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Sat, 25 Jan 2020, at 11:40, linux@neuralgames.com wrote:
> On 2020-01-22 19:53, Andrew Jeffery wrote:
> >> Thanks for reviewing the patch.
> >> 
> >> The RNG on Aspeed hardware allows eight different modes for combining
> >> its four internal Ring Oscillators that together generate a stream of
> >> random bits. However, the timeriomem-rng driver does not allow for 
> >> mode
> >> selection so, the Aspeed RNG with this generic driver runs always on
> >> mode 'seven' (The default value for mode according to the AspeedTech
> >> datasheets).
> >> 
> >> I've performed some testings on this Aspeed RNG using the NIST
> >> Statistical Test Suite (NIST 800-22r1a) and, the results I got show 
> >> that
> >> the default mode 'seven' isn't producing the best entropy and linear
> >> rank when compared against the other modes available on these SOCs.  
> >> On
> >> the other hand, the driver that I'm proposing here allows for mode
> >> selection which would help improve the random output for those looking
> >> to get the best out of this Aspeed RNG.
> > 
> > Have you published the data and results of this study somewhere? This
> > really should be mentioned in the commit message as justification for
> > not using timeriomem-rng.
> > 
> > Andrew
> 
> Hi Andrew,
> 
> I have uploaded the results of my tests to my GitHub, along with all the 
> binaries
> containing the random bits that I collected from this Aspeed RNG using 
> all 8 modes.
> You can also find in this repository a patch for the hw_random core 
> driver that
> I've been using to collect this data. Here is the link:
>    https://github.com/operezmuena/aspeed-rng-testing
> 
> You can see in the reports that when using large enough samples (40Mb in 
> size)
> this Aspeed RNG consistently fails the linear rank and entropy tests, no 
> matter
> what RNG mode is selected. However, modes 2, 4 and 6 produce better 
> entropy than
> the rest.
> I'm now collecting rng data from 2 other AST2520 SOCs that I have in 
> order to
> compare results.

Nice work. Eyeballing the summaries, it seems mode 6 or mode 4 may be
improvements over 7? What's your analysis? It would be nice to have the
data from your other two SoCs to corroborate. Again, going forward, please
point to your measurements in your commit message.

Not that I've looked, but is it feasible to augment timeriomem-rng with
the ability to configure the RNG rather than implement a new driver? Why
didn't you go that route?

Andrew
