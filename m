Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165F7C77B7C
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Apr 2023 14:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjDSOhC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Apr 2023 10:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjDSOhC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2023 10:37:02 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBFA46A9;
        Wed, 19 Apr 2023 07:37:01 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id BAD4C5C00D8;
        Wed, 19 Apr 2023 10:37:00 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Wed, 19 Apr 2023 10:37:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1681915020; x=1682001420; bh=0P
        S+QhYHdNXdAlj4r8UkUsyc/WPDJbyieoQD9gMfB2w=; b=hz0te82XcMpe1L4Ion
        XKq/lfSJIXhwA1aReFrOIleV4oqtNWouRGMMhYM6fsxDSxNbXMOknZY0h1gLQEAs
        Rmo2Al8LrFbOxig2SW2ddfgDhhKzwj7Os8kKuYr+UwGuMC/hWPnG5vzeTAFY0p5x
        NIfOCpcEVK7BueX1LZXo0aMgfRo/ZgjGlDIxeVMTu7LUtd/Gc2eyAj3co5lBRFMA
        XOkT3XgazK+DcqDWdpBO/dv8buEdVZJGhoSDfIjUPID7O4DJ+OHtuROGnd2vHKKJ
        KXNMMoaEy6fkN+XDi/tncT8RJ6X9I1eVdCmH1bl3Lfm8JxkIRDuKn6z2vWesHzHb
        07IQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681915020; x=1682001420; bh=0PS+QhYHdNXdA
        lj4r8UkUsyc/WPDJbyieoQD9gMfB2w=; b=DSoyUwiEZu7BV997oE03ZX9kVUh0Z
        YV3BMmRYiTHIZ4KOlX+ENQgUkon9pKW/xas9VvnwpsGl+EwB8Xskf3YzmExVITMG
        Ol8qnoDhk6KN5eS2sRu7pFWOGtBqDyDitRit4oDL+KLMVHRJZYpi19yf2ceE3P8U
        LlJPPqesDkY00sZUjoLebJPcoSfi4WsguGk4LzNgxAXH42huR87dqBjFS6lVz5f2
        cj71eZmClj/8HTXumay/VaiROr2+KFRm9p925wsnGANq/RAnQDgW3YtzZF0HJ5de
        iPBQNIsM0HGR0rFGCzUVkI0AxVrms1JiY8w8aHkjr7ZEYpE8avHQyzkmg==
X-ME-Sender: <xms:jPw_ZFWPKOiWTqXEpoO11V6p9QzmtjmHLdcVLGgTO--lGjAxe41dVg>
    <xme:jPw_ZFmBXWp29Nuo1L8lmYmewtajhG3lmuJgooUv9laS-1y4jELsy6kEU_1FatFmm
    295GmXXm930F6XYU_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedttddgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:jPw_ZBZhcq9yt0Wd7qJT-UQPaDiPOOX8738evhquj5ajHD5O_mjXMQ>
    <xmx:jPw_ZIWGGFDW0ojEmKsVoL0Ln5lgmoffG8qSt-lj6f_dsoEIE3jctQ>
    <xmx:jPw_ZPmILLjaGqY8-Mn4oE8HI0z9WTiFzIp5AoXGcrH7HPBRK8FtYQ>
    <xmx:jPw_ZNZzXMHYWjh3Bridt-wzaG9D0HsqKKDLri6bngcDKOT49U1npQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 1DDA1B60086; Wed, 19 Apr 2023 10:37:00 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-372-g43825cb665-fm-20230411.003-g43825cb6
Mime-Version: 1.0
Message-Id: <2f72edd3-4cec-4380-9c7e-9d280798ccd2@app.fastmail.com>
In-Reply-To: <7de7d932-d01b-4ada-ae07-827c32438e00@kili.mountain>
References: <7de7d932-d01b-4ada-ae07-827c32438e00@kili.mountain>
Date:   Wed, 19 Apr 2023 16:36:39 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Dan Carpenter" <dan.carpenter@linaro.org>
Cc:     "Linus Walleij" <linusw@kernel.org>,
        "Imre Kaloz" <kaloz@openwrt.org>,
        "Krzysztof Halasa" <khalasa@piap.pl>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: ixp4xx - silence uninitialized variable warning
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 19, 2023, at 16:26, Dan Carpenter wrote:
> Smatch complains that "dma" is uninitialized if dma_pool_alloc() fails.
> This is true, but also harmless.  Anyway, move the assignment after the
> error checking to silence this warning.
>
> Fixes: 586d492f2856 ("crypto: ixp4xx - fix building wiht 64-bit dma_addr_t")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Nice catch, thanks for the fix,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
