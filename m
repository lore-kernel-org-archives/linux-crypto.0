Return-Path: <SRS0=nOCY=3X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC484C33C9E
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 04:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E2F120679
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 04:09:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aj.id.au header.i=@aj.id.au header.b="jLEEj6Du";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DmuPSaKp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgBCEJW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Feb 2020 23:09:22 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:42353 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727327AbgBCEJV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Feb 2020 23:09:21 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id C156E6D27;
        Sun,  2 Feb 2020 23:09:20 -0500 (EST)
Received: from imap2 ([10.202.2.52])
  by compute4.internal (MEProxy); Sun, 02 Feb 2020 23:09:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm1; bh=RjS6hrJkvw6HKnule/qYTODmaAYp/hQ
        FP4smKfPmKGQ=; b=jLEEj6DuOY9JFldgz6GzluSbsV/j8Jxqp+dWzKfNwmDCsKk
        NP/mF1lEvBeknCTiyR4uzNfKGEiO3QDXQbc8/kaCqDMH7OqMNHWHqs0RXrXYMLZ0
        bMH0krwIh9AUdzsI/6YuMa6EgbgrmwclYfUUEgaZwT2QFNQj3tT5cxrKcu41T2Xi
        3NOXXV/ugy4b3jHye2tAfpgw5sSAMXIYrVGoedPkwAZ74WhvJuv1FqRtD+MNRQHS
        7o1n5mWsHYu0XM961jK+M0LkZjt6d1gnBKL86rfmR0N1djBSWIS5cP/6/bPdlnNd
        PX1bxHEsSj30BetS5LE01430WIHG9PWyr7oV5+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RjS6hr
        Jkvw6HKnule/qYTODmaAYp/hQFP4smKfPmKGQ=; b=DmuPSaKpvAxsFkXQD2TjPV
        457IBibzflOvIL/OIV3vx87Qo172/hR1rP41uWk/PS5DXGNAeuKnZWrVYiLIB2Po
        tHFT7+Yyz0VlzOs+bcxOtK2rGtbFxrifqIxBMb97IOHud5xRNsoLA3jFgbrMna9K
        ezAp2WRpmdoRJqOYWR+7OuToXToM8VJlnoT599ClS9KaEveGOd6Bk3Ix6EMO8gg3
        NwjjuJCA9YylBi303dieFUYdkHeiWIf/f7/R0b4n1IxSNhgTWDT6MmhyNJX1OOXC
        5rWc8qMmrRiJi0w8Ougj7k8sqzbA5QvAPc+JgtAtjSewhEjcc9TFgzDkyjONC6rw
        ==
X-ME-Sender: <xms:8Jw3Xr1SJOTNsngXqFBtuTDrEzdzuCTzo7B2CDSeJhBr414ExuothQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgeeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedftehnughr
    vgifucflvghffhgvrhihfdcuoegrnhgurhgvfiesrghjrdhiugdrrghuqeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvfiesrghj
    rdhiugdrrghu
X-ME-Proxy: <xmx:8Jw3XrUkY22zjYfoyBETKyB-x-H9Zh5jGuEbV2mSyqYdBdkFyOr8JA>
    <xmx:8Jw3XkVD1fVPMiiaKnDZgRUt8hkIBZgKTmm3s1FuLwEg8xNxAlmnJA>
    <xmx:8Jw3XnCzSnKK85gkFNgd56lWmuj2Ao3jH1hxFZJidO6xNHF8TIgXmw>
    <xmx:8Jw3XmszI8conWzhsZjiGRm5Lr_AzefRMi4d4IHNJknWRjABi4ymHA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 965ECE00A2; Sun,  2 Feb 2020 23:09:20 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-802-g7a41c81-fmstable-20200203v1
Mime-Version: 1.0
Message-Id: <42173df3-c060-4c62-a5b9-7f1deade21d1@www.fastmail.com>
In-Reply-To: <f6beee98-360c-4239-ab01-86ba41629f9b@www.fastmail.com>
References: <20200120150113.2565-1-linux@neuralgames.com>
 <CACPK8XfuVN3Q=npEoOP-amQS0-wemxcx6LKaHHZEsBAHzq1wzA@mail.gmail.com>
 <4446ffb694c7742ca9492c7360856789@neuralgames.com>
 <575811fd-24ca-409c-8d33-c2152ee401d7@www.fastmail.com>
 <136bbab84d13d8d56a5ac297e415975e@neuralgames.com>
 <b83f2a1f-e1be-433c-8dc8-c469cb38f423@www.fastmail.com>
 <27c5505acd8d09f70ec9cd12982b2e3e@neuralgames.com>
 <f6beee98-360c-4239-ab01-86ba41629f9b@www.fastmail.com>
Date:   Mon, 03 Feb 2020 14:39:06 +1030
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



On Mon, 3 Feb 2020, at 14:37, Andrew Jeffery wrote:
> 
> I think we should leverage existing work where we can. Lets not make
> more extra for ourselves :)

Dammit, replaced the wrong word there - the irony:

"Lets not make _extra work_ for ourselves"
