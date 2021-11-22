Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3FAC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 09:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238956AbhKVJLQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:11:16 -0500
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:50819 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239036AbhKVJLI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 04:11:08 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id A40DB2B01C7D;
        Mon, 22 Nov 2021 04:08:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 22 Nov 2021 04:08:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-type:content-transfer-encoding; s=fm1; bh=
        g7CpQC4vqv3CcMQzgY8dtmqZ9qwA0gZLzM452E0RDCs=; b=b2lIs3yG2e/ficTn
        epg6iTHeQ40ACMnqwWDOnEVS0dIzLAG0/flD9QzXCsXdxkqDYuUAk1pB6DJNO26q
        PtJdwcszKiAmb4AjxoaIfrdHhv5f34Tfxgq3l6dZLwU4xST0f8Yb0/Y7QmpM4iJI
        HzsKptuumIOD2XSAZoZ5q5XH8LTPY3IYI28PkVQvHCl+DXzUgySsMssUDgdlPiU3
        4jQ9ASmR/MoHQXMzOv7U90iDxyCCjvRwWmknDbU6c5jmX2nIDVkCJP2ipnTg9YB3
        OYMy2kvQCgUlK5z/ChAddKmwItzO0GYyG7MKNIb16YyOIJCnDlE86XTi4ZlQAKiQ
        0Gp6zA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=g7CpQC4vqv3CcMQzgY8dtmqZ9qwA0gZLzM452E0RD
        Cs=; b=RRTqYd9X69muQLRFLybXxZlogBe9pb5PzGldgRH/o/X9B6zbRlZooOEfM
        h/2MyaNR+Aofa2yFaM19+SOalDkX7Wl2O+lrLSLUg0TIOTH/EqwjxnuBw89VhnQ4
        vyvaLnFYGYXYLo/eJ54yZhoIX3PwXqc5jhnNJerTOD8U6Dfhb8oSl1+G1YB/fPsR
        c3JAArBqZMKNh9cI5kUvkFChsLG4QMSCu0MO7sdhbSNaxhKsoqEu/9FSR2MSOMVb
        gNwS48BSAQmDCpDrAGSz/ztFIt/K5aTil9RFtFIX0WAQPKfYNLwws25o6pqf1a1S
        /s05xn2FLLS2mi5N4JLsEY/Y43YkA==
X-ME-Sender: <xms:8F2bYbUtTSdAW_vGMfwvlyxmgNd430hQVdGzhDU011i5-NSIAHEghQ>
    <xme:8F2bYTkwv3Nf9XdaCBufEjWsdmibVApgvtPtsMg3NhicGZV4g0kUGWzmmbdebwO7U
    qakbeKUtZwc4rdWBaw>
X-ME-Received: <xmr:8F2bYXYWp-dngPH4puf0HIBDiwjlXr3N8qF8LPHUfV2NscTFTbZ_V93K3PMvj1ieti0kELxP8mPi32CQ2llu_y7fNzc5_wfaano>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeegucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    ephffvufffkffojghfgggtgfesthekredtredtjeenucfhrhhomhepofgrgihimhgvucft
    ihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrghtthgvrh
    hnpeejuefggeekfffgueevtddvudffhfejffejjedvvdduudethefhfefhfeegieekkeen
    ucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrgigih
    hmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:8F2bYWUA_g0RFjw9a7o7KOFn1lhHZ_1fnIlfafJ93mVvDBaSunKhCg>
    <xmx:8F2bYVmt4Fh9c4-zIFYjxi86mP8O_nA37hNJlhQ9CEFsAjQz5h7QMQ>
    <xmx:8F2bYTdhWjB_G3BAvJJNxzlQtJmKOp2EGzxMjQ5WwSD7xVqZv6LjJA>
    <xmx:8V2bYWgEWLSopLfjHoAHChO5IxMCArtiv6X33NFz7x6CGC6r66WCRA9oRr4>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Nov 2021 04:07:59 -0500 (EST)
From:   Maxime Ripard <maxime@cerno.tech>
To:     Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Ripard <maxime@cerno.tech>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Chen-Yu Tsai <wens@csie.org>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>
Subject: Re: [PATCH] dt-bindings: crypto: Add optional dma properties
Date:   Mon, 22 Nov 2021 10:07:45 +0100
Message-Id: <163757205949.21212.15408545485243752460.b4-ty@cerno.tech>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116143255.385480-1-maxime@cerno.tech>
References: <20211116143255.385480-1-maxime@cerno.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 16 Nov 2021 15:32:55 +0100, Maxime Ripard wrote:
> Some platforms, like the v3s, have DMA channels assigned to the crypto
> engine, which were in the DTSI but were never documented.
> 
> Let's make sure they are.
> 
> 

Applied to sunxi/linux.git (sunxi/dt-for-5.17).

Thanks!
Maxime
