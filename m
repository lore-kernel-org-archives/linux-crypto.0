Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA1F3A7591
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 10:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777371503; cv=none; b=Jc+qpVIBD52uM6SeKrGiW2w1Ob4TubW4fbCH0PerkfHxsP4AU2NrS8Wmcm2CtSGC1/vhK8nRzjHqgAqLl+vtlbj1F8JmvOFJ04+yLp2djsHlTdQ93oFrqmGhRag+Tc2qhEaEfzE8h+PFhTLDqXziYbocPHt9gI/9muPR48YD14w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777371503; c=relaxed/simple;
	bh=/IixdDMiEf6l+3+Y/vERm1hC/tsP5pn8ut57x2lup+4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=JHt9C+qtCVj2aKdVc2fWwCeJDdCyNb9y8lMJLUbuPn51v2MdjA6TawXYa7cnT/ZZhiyqD05iUCkRXasBT7ttuTBxIKaT8kkEDj9p1LJf5uL8Yzyr+A2IJDk945UD/m528BwTQu2zZjOi8pkoWB3cJKf6qPbK7G9uQaNxMj8gUKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qVemluUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qVemluUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10A9C4AF0B;
	Tue, 28 Apr 2026 10:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777371503;
	bh=/IixdDMiEf6l+3+Y/vERm1hC/tsP5pn8ut57x2lup+4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=qVemluUYRSbRbB+jeTHcLHXfVd0fWVePHTR7D6EO1tbYHqRMbxroM8029raU8KGsg
	 ypnd63LwnL7BEHTr0KFMNBBDSvKmkEflTA9ksd1Cx8g00b6UDvliI6mlVZeeUtLF4g
	 N2OrJ+eqSpcovEpMPhItU/qR3Qovi4ASRSSVCt+dJjF+p2D3aXHlfIfMteRqJNQANW
	 WU4n2exmEJEOc5pEb+OAZ1XZ32f8bESrWvTxs2Iyr1gXul7qQ098SYy5ydU8f5GVJ4
	 d0IiiK1p8k1f05JhyTIfCtBXRGS+lQW5qOMORNbLgZFTNH41p+WMC0qe2ZJhmSYiiL
	 KBXWsWpglW6lg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id BAC7DF40082;
	Tue, 28 Apr 2026 06:18:21 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 28 Apr 2026 06:18:21 -0400
X-ME-Sender: <xms:bYnwaXcJmsECddzwi7UwtfuDBg3_l8GEaJLjfVVJGgqAfuR9oNMMmg>
    <xme:bYnwaYDFWZp0KZNoAkk-CJM6FtmXLX0CdG0SSqmglVA3Tsc5pKHgIR5cG3unv15In
    YhqBFZgSmZWTLLPx96cSG3Z1a0mBWe35Bgu_zhn8NOzdGYMxjmciX8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepkeevteduteehkeekteeugfdvvdekudevffejvddtueehuedvueegudfhtdet
    hfdunecuffhomhgrihhnpehmvghtiiguohifugdrtghomhdpmhhitghrohgthhhiphdrtg
    homhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegr
    rhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeelqd
    effedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgu
    rdgtohhmpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhhtphhouhhtpdhrtghpth
    htoheprghlvgigrghnughrvgdrsggvlhhlohhnihessghoohhtlhhinhdrtghomhdprhgt
    phhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohephhgvrh
    gsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopehkrggs
    vghlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhhsfieskhgvrhhnvghlrd
    horhhgpdhrtghpthhtohepthhhohhrshhtvghnrdgslhhumheslhhinhhugidruggvvhdp
    rhgtphhtthhopehlihhnuhigqdgrrhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrg
    guvggrugdrohhrghdprhgtphhtthhopehnihgtohhlrghsrdhfvghrrhgvsehmihgtrhho
    tghhihhprdgtohhmpdhrtghpthhtoheptghlrghuughiuhdrsggviihnvggrsehtuhigoh
    hnrdguvghv
X-ME-Proxy: <xmx:bYnwaUt31HIys7vPt9YU4LopGzBpnow_vORtPpBl32hzavV72d-Eiw>
    <xmx:bYnwaVIgjmgTPj7A1M09K_1WyhLnOMj9DqdC0Bm4Z0Yvqjfa267QsA>
    <xmx:bYnwaYa8nOTdbjaUgkJsRTCvKQKohu3p5EkpzZMSN_oUaFOIOPnv0g>
    <xmx:bYnwaYnwJFhxqjJ8Zy0G2oztVSCZXq9Vwh37Zuu475ECLPQAWlBtJg>
    <xmx:bYnwaWUIjGOUqoXxHFUT8s_8kAXaZaLHvFZ-BoMMcX7jY6CRwmWuZEQp>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 99D7A700065; Tue, 28 Apr 2026 06:18:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 28 Apr 2026 12:18:01 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Thorsten Blum" <thorsten.blum@linux.dev>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 "Nicolas Ferre" <nicolas.ferre@microchip.com>,
 "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
 "Claudiu Beznea" <claudiu.beznea@tuxon.dev>,
 =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
 "Linus Walleij" <linusw@kernel.org>
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-Id: <e1157e91-9a08-43c7-834d-cc6f3799b16a@app.fastmail.com>
In-Reply-To: <20260428101430.514838-3-thorsten.blum@linux.dev>
References: <20260428101430.514838-3-thorsten.blum@linux.dev>
Subject: Re: [PATCH v2] crypto: atmel-sha204a - drop hwrng quality reduction for
 ATSHA204A
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Tue, 28 Apr 2026, at 12:14, Thorsten Blum wrote:
> Commit 8006aff15516 ("crypto: atmel-sha204a - Set hwrng quality to
> lowest possible") reduced the hwrng quality to 1 based on a review by
> Bill Cox [1]. However, despite its title, the review only tested the
> ATSHA204, not the ATSHA204A.
>
> In the same thread, Atmel engineer Landon Cox wrote "this behavior has
> been eliminated entirely"[2] in the ATSHA204A and "this problem does not
> affect the ATECC108 or the ATECC108A (or the ATSHA204A)"[3].
>
> According to the official ATSHA204A datasheet [4], the device contains a
> high-quality hardware RNG that combines its output with an internal seed
> value stored in EEPROM or SRAM to generate random numbers. The device
> also implements all security functions using SHA-256, and the driver
> uses the chip's Random command in seed-update mode.
>
> Keep 'quality = 1' for ATSHA204, but drop the explicit hwrng quality
> reduction for ATSHA204A and fall back to the hwrng core default.
>
> [1] 
> https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
> [2] 
> https://www.metzdowd.com/pipermail/cryptography/2014-December/023852.html
> [3] 
> https://www.metzdowd.com/pipermail/cryptography/2014-December/023886.html
> [4] 
> https://ww1.microchip.com/downloads/en/DeviceDoc/ATSHA204A-Data-Sheet-40002025A.pdf
>
> Fixes: 8006aff15516 ("crypto: atmel-sha204a - Set hwrng quality to 
> lowest possible")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
