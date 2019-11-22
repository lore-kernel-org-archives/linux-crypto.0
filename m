Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B0FC432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 12:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B7B620715
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 12:53:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cerno.tech header.i=@cerno.tech header.b="GY3TSJ3c";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="N2614tNY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfKVMxU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 07:53:20 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:43929 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726548AbfKVMxU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 07:53:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 778A150EA;
        Fri, 22 Nov 2019 07:53:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 22 Nov 2019 07:53:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=6sTaGdNaAmXwRq4Z1SN9IJKH5kM
        GbGtleKNhLuS6KCc=; b=GY3TSJ3cyNB/ELYaZuV8A4JzI1BnSHgTsWtwatzFMQ1
        +qyz/x4YpfIKfKwrxY14//8TUBs/sNm4IX89awRfB91iRdT3Qs8IBFEiiAGVp94D
        yVy1wB4cCHPAIkdS1nLHsgt9AzSlP+KhU04bxg46IMRT+9isBpe1QEJX+pdrKU5g
        QF8mHkIKr2rTNDjOwzoWKCK5wXsJfWuzcBJjc+gI7NTe3+x3r4CuIGQeu+DyGRzo
        C0JXS7dhk0R/Rqujk3ZlYG1NdlLADsSmxry7weB69Af84sgI2RYiCOpoDMIaLCws
        1Ec0vbvhbrKSLjjeqtX5A2TU6Gmecc5nEKzbHx0Micw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6sTaGd
        NaAmXwRq4Z1SN9IJKH5kMGbGtleKNhLuS6KCc=; b=N2614tNYPyX/Ppe8PZ7zoG
        OKJIyoH0vBdx58kOTNIEA4g4i5JAJiEX8fOdTX03t3E0hwHAy87hTvsZu8GL4vCv
        nMGos43iq3x3eUvMiPuWxVtfNGQPD0J3hAHQmNDucZsoQOT6upX4P9dn1x+IBAJR
        GVweTZka4jKc6D1T797Qt5/CqQIrOmg6PdodkG345U+XimATQoCYFrwDVc3Vm0n7
        wY9Bt4elDZ3XLU1KlBPplcPukeVY+guEhcHnIySzQKolG4dOPmkLPlUrbBOfUFY+
        DonKbF8GZvVl4bszSxshEaJzkAo6BQg97WQEB39j8BoKIeed2UgpwB422gz6sprw
        ==
X-ME-Sender: <xms:ONrXXfspYttb_FGwg4feQCUKW3Cuze2CKmn7gG8ultW6G6OyTKNPFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudehgedggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttd
    ertddtredvnecuhfhrohhmpeforgigihhmvgcutfhiphgrrhguuceomhgrgihimhgvsegt
    vghrnhhordhtvggthheqnecukfhppeeltddrkeelrdeikedrjeeinecurfgrrhgrmhepmh
    grihhlfhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghhnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:ONrXXR0A77t3Rrze9Stj3tjITlYJ9AbhRQbTDiroGSsfKYolhTB-ww>
    <xmx:ONrXXfxwTluPtoy8Vk-wAC-heffLw0dWicrlsRGrVmjqzNo16feFnw>
    <xmx:ONrXXVVqCv5JZ1My3N64FvfyexWvqlrx_t4BLF6v6biF18p6bBlSQA>
    <xmx:PNrXXTeRfTFSjCBjey-yFNLl_uofxUM5PdxlXGUT5Z_Aa1XYjxXA3g>
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD2DC8005B;
        Fri, 22 Nov 2019 07:53:11 -0500 (EST)
Date:   Fri, 22 Nov 2019 13:53:09 +0100
From:   Maxime Ripard <maxime@cerno.tech>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 3/3] crypto: sun4i-ss: add the A33 variant of SS
Message-ID: <20191122125309.GL4345@gilmour.lan>
References: <20191120152833.20443-1-clabbe.montjoie@gmail.com>
 <20191120152833.20443-4-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120152833.20443-4-clabbe.montjoie@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 20, 2019 at 04:28:33PM +0100, Corentin Labbe wrote:
> The A33 SS has a difference with all other SS, it give SHA1 digest
> directly in BE.
> So this patch adds variant support in sun4i-ss.
>
> Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Acked-by: Maxime Ripard <mripard@kernel.org>

I'll apply the DT patches once Herbert will have merged this patch.

Thanks!
Maxime
