Return-Path: <SRS0=7Iqi=AE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC17C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 13:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7546A20738
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 13:44:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cerno.tech header.i=@cerno.tech header.b="LwF6LgBL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aYj0nDqL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbgFWNou (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jun 2020 09:44:50 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:53717 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732689AbgFWNou (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jun 2020 09:44:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 3AF2A9D9;
        Tue, 23 Jun 2020 09:44:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 23 Jun 2020 09:44:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=O
        0g8wXDhwaGH3wxJIDz/XxJs/BJnWAIK7T3LcqUUYKI=; b=LwF6LgBLm/H54i4bs
        dTm6x54o7AV9PmvS799JVOsUUj/jDz5jgfUhEon/VKaiOhJ45jyzb7ysGmYhQifi
        KnCy+ilEbWV7JYA4wQH4EZ0wqTH/jgURP/ji6Inf2qxxeqWqPSAjKQJjw8lQFh15
        3Xq3W6F5nAXmtNEPsRxyPGBrG4ImmPx9rS9ywI/IME7sfEvV5xUl+rYd0rraEHhV
        T4z/KL7VleSP+aIiCb9GUK/5+KtAvAdRmrg+Rx0dqbw+qRz643ZyCFG3pWEAWoW2
        Zr7JiO7KJ7+7rhy9EOyJNhv+ieEdsUKDsBL7B4FOgZRMKOY4hixZMB5SgENm7lae
        q1+qQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=O0g8wXDhwaGH3wxJIDz/XxJs/BJnWAIK7T3LcqUUY
        KI=; b=aYj0nDqL3IMLwvTDMgHK7kpquV6TSZk2izgJcAuo2I2h4+rTiOSYgX1Dp
        7f7KjPVrB2d1h0aIwe1tNFQ8NzjNCU8nPbd6cJWytmh1XxBVHUUPiDOvor3Os+TD
        iv+jotApenT6d6KjvnbxyNn88aMrqcPrOck0pfJqceD8MueyfWOaHMDsv+HnT/WQ
        n4rKSkV4fXK1Ts4UTyNefURCxUBpCifiPhmV2/JoVcSlWV4kaKRSZZVDJuNMgtq8
        DpdEFFfOBqz0oma6V10ax1hIU7LS/JKP+SJDeoe9DQLXoxTojCeXioOtxB2w6Wrh
        0PgkyOyFw04OqioCMRneQGV64J+qw==
X-ME-Sender: <xms:TQfyXgoWPKtkyOMzdHBQU4SkM1vZnLRvyEp7LiLsuAw9EfXoGrMIIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthhqredttddtjeenucfhrhhomhepofgrgihi
    mhgvucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrg
    htthgvrhhnpefhueeggfdvieegjeeigeffudeuhfeuveeuieelgfffleelgedtiefgvdev
    ieevvdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeeltddrkeelrdeike
    drjeeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    mhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:TQfyXmp6kCnuarhDOFpKWBBiEDJCr6uq49ulhBBMIoLZxmMd5Zcvag>
    <xmx:TQfyXlOzlz03GXkqCaoNFco4gwSPwQbXMKgd1Hhq5QcSpvh5gFMqIQ>
    <xmx:TQfyXn5YGxSGoB_t0V0RPe5VDKph15fK0iJjW3HvPq1ELRhQ7iXMog>
    <xmx:TwfyXnxxY0VIQfOKgYz-x0i5FYX_3WeZpJYYyWq7qFp7wOwcx4YPay1a4AU>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id B3A7E3280063;
        Tue, 23 Jun 2020 09:44:44 -0400 (EDT)
Date:   Tue, 23 Jun 2020 15:44:42 +0200
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
Message-ID: <20200623134442.wj4i3r3dlp6rtpaq@gilmour.lan>
References: <265c3a75-f8ce-fb34-d559-39e58a4dfb4f@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <265c3a75-f8ce-fb34-d559-39e58a4dfb4f@web.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 22, 2020 at 07:50:08PM +0200, Markus Elfring wrote:
> > Fix this by =E2=80=A6
>=20
> Please replace the beginning of this sentence with the tag =E2=80=9CFixes=
=E2=80=9D.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/process/submitting-patches.rst?id=3D625d3449788f85569096780592=
549d0340e9c0c7#n183

No, not really. The comment you (partially) quoted explains how the
issue is fixed, your suggestion explains what commit introduced the fix
in the first place. They are both beneficial, but there's strictly no
reason to remove the former for the latter.

Maxime
