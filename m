Return-Path: <SRS0=7Iqi=AE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD04C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 16:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38A242076E
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 16:56:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cerno.tech header.i=@cerno.tech header.b="PFqYvF3/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tBPnBtyF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733058AbgFWQ43 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jun 2020 12:56:29 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:35861 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732416AbgFWQ4W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jun 2020 12:56:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 7F2B69DE;
        Tue, 23 Jun 2020 12:56:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 23 Jun 2020 12:56:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=r
        XOFys0881hoPtvQddDik70Gqk7ZL4a631nWuDDDZ1I=; b=PFqYvF3/V3fw9s6Ec
        8T68pPe2E60vme/LzpymHABo3wbSz/2S8vgWG0lweh28Vky31d7BFDnq4FV9KeYa
        C7Kz/ZlYO2yBy8WauJpnWACbeXq64l2Hg7lZaoT4xUyxfNRVkRuITcVVmGAVs0Tn
        WpawogUpkpeUGeyejBKcYQ2K54T7nxHjMaHDomMsCwo48ZgzO1BvUWLl2SFj18nt
        jnS+bedhN2GCgE2cEXO+5zfyQnzLEP+t1OeYSHGOFvCm2JbnIN2Cn7OrRkHbUCKT
        gzP7DENEnOVsQS4VowrD7Dc0ThWZDsJlb7mYgrAsvJoGKvD0r0ncfExPXgYQxyxj
        F2Hfw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=rXOFys0881hoPtvQddDik70Gqk7ZL4a631nWuDDDZ
        1I=; b=tBPnBtyFsmPfvutqSmQpxLJ9ooE+78MAjXS0FF5aEPgpEakX4/TUdFgBp
        UJhfzpjoHcerxVVobqO1FqmXpEEVHqr9ZE5nK7Sh72TUosBHZE9gsy9CqrqlDa1V
        1jQcIqTlVxOM2878UGeFbXPlaRhTBHuAW2VeKLVUYLzX1PPTrQ3PNRQ65nZqbdHa
        ulLfIHAM5RnJFV663hQz1Cd6Hhv5Er6diLdCc7/CmSliDXQMW/a/AvIk035hjtYG
        WPNF2CSYj54RwA7HHS3I5MYZiGRiWOY6ozT8Cb/j6G6Jlk3uAhub7Y/WPam6Fmlo
        0XG23Pm4yIS6KdwR2lF5bdO0EUD5w==
X-ME-Sender: <xms:MTTyXgzhD2oLsWAO__gBdGAUmkEU9buPzYFego_AB0XV6q0ZQMQfIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthhqredttddtjeenucfhrhhomhepofgrgihi
    mhgvucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrg
    htthgvrhhnpefhueeggfdvieegjeeigeffudeuhfeuveeuieelgfffleelgedtiefgvdev
    ieevvdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeeltddrkeelrdeike
    drjeeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    mhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:MTTyXkS2-ZPryP7_3pCY0SgEKGmnEp7E6Shv1poj5LgtASWsyxM95A>
    <xmx:MTTyXiULJFFtGvsjB4nIKOB3QHqGFPgBehWrCS5vOAwfsuiIb9dc1g>
    <xmx:MTTyXuhoW49IbOwmvyfGT1PSRVarzdvuBcXzDMcL0XvHATi-ulFXqg>
    <xmx:NDTyXu7UwjM8LGGqhYTjcH2uyHUIikJk-RnTCClKuAIgrS3Cdol8TzqklRg>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 63CA0328005A;
        Tue, 23 Jun 2020 12:56:17 -0400 (EDT)
Date:   Tue, 23 Jun 2020 18:56:15 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Aditya Pakki <pakki001@umn.edu>,
        Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Qiushi Wu <wu000273@umn.edu>, linux-kernel@vger.kernel.org,
        YueHaibing <yuehaibing@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH] crypto: sun8i-ce - Fix runtime PM imbalance in
 sun8i_ce_cipher_init
Message-ID: <20200623165615.i7iphakzjeu2d3fq@gilmour.lan>
References: <265c3a75-f8ce-fb34-d559-39e58a4dfb4f@web.de>
 <20200623134442.wj4i3r3dlp6rtpaq@gilmour.lan>
 <16341716-aeb6-febc-441c-c1826da8c4d3@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <16341716-aeb6-febc-441c-c1826da8c4d3@web.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 23, 2020 at 05:00:32PM +0200, Markus Elfring wrote:
> >>> Fix this by =E2=80=A6
> >>
> >> Please replace the beginning of this sentence with the tag =E2=80=9CFi=
xes=E2=80=9D.
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tre=
e/Documentation/process/submitting-patches.rst?id=3D625d3449788f85569096780=
592549d0340e9c0c7#n183
> >
> > No, not really. The comment you (partially) quoted explains how the
> > issue is fixed, your suggestion explains what commit introduced the fix
> > in the first place. They are both beneficial, but there's strictly no
> > reason to remove the former for the latter.
>=20
> Do you care to improve this change description another bit?

I'm not sure which change description you're talking about?

Maxime
