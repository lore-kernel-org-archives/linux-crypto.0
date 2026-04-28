Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DE12F549C;
	Tue, 28 Apr 2026 16:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777393827; cv=none; b=cJTfXKj2LwczRA//PW+7Rco0awYT3iU1/cUGG7QLUH7UHPOibyfs9XxE7KJmHqjFOX4ku9aKaLKcaUbWVZOcDm1uyW7Sf9Z5O8ekuOPE/zpBsLcwdcG8DzGxLy+XmwWwpmOy0d4e3Eg07JLhEN7BLy3e1Na0NRbCRDJUuzKtecU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777393827; c=relaxed/simple;
	bh=cT6jmt4+OY628kY0x9v/6nF8hRaDQ4Au465ssIAxw3M=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=OJvcSzqSFAs5e/emuy+6bxlQn5DUnJnNmaBEerrRL4sAmBvKUx96wd36WOic5DIeDo9AnkLLLTCB9G7/UgMyBAtLVpzH1qlSKePq+FFate8/QJELs9HoIxCUs2fsp0jA+3hBsDkmHotPxb3uCahbPeMDp6VTDAep/QSeUv5yN9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F3y9O+aE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F3y9O+aE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3434C2BCB5;
	Tue, 28 Apr 2026 16:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777393827;
	bh=cT6jmt4+OY628kY0x9v/6nF8hRaDQ4Au465ssIAxw3M=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=F3y9O+aEV2liAUh8duVwf15f7eF2F7pQp7XgzYRYG96dv2YDyXrG1XjtmGJT8NxKj
	 ljx/29VNG6peiMYMKakDMz56w06QEZx3SSD6eR9/solDSIE88YU1nTAvu6QCK/JOeu
	 6G0pGEi+dj9KwqClqwldkEPa5sXfeEMqeRAenqw6s2HXZGV81kyBnuIR+myppq1ygA
	 8Xhv4zYF61zqC1rUiwriPLlwVNBz6aGT4hHW16pxiqzX3M5Hb6BDewTOC31xp9rp8V
	 WX/hsyovH//iLhPL0puhEK0cYKCRy60F70fL1Q6ZOi8tCzE3KUyTA99PQpusOIsHzt
	 F9toxrhrm+LfQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id F2CB6F4007A;
	Tue, 28 Apr 2026 12:30:25 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 28 Apr 2026 12:30:26 -0400
X-ME-Sender: <xms:oeDwaZ_SIJWZCzMsXdEmnR6abvrpCGjZom6lLJmF3sDs5t33kzZC7w>
    <xme:oeDwaYhbV-QQbXUq9fxYdbDt5PO8bPgkARgkG4d_cai1QoysW-Lbl5DqnFOoqMiTF
    4AE3F5nxHxQS6OHyEBhcWIkASLfpnls7n6SGRWypjo3ErgRYHzSM0qQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekvddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepueetieduieegkeejvdehudeiheettefgtdeugffhjefghfeftdelhedvheff
    hfdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepudefpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrlhgvgigrnhgurhgvrdgsvghllhhonhhisegsohhothhlihhnrdgtohhmpdhrtg
    hpthhtohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopeifrgih
    figrrhgughgvvghksehgmhgrihhlrdgtohhmpdhrtghpthhtohephhgvrhgsvghrthesgh
    honhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopehkrggsvghlsehkvghr
    nhgvlhdrohhrghdprhgtphhtthhopehlihhnuhhsfieskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtohepthhhohhrshhtvghnrdgslhhumheslhhinhhugidruggvvhdprhgtphhtthho
    pehlihhnuhigqdgrrhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehnihgtohhlrghsrdhfvghrrhgvsehmihgtrhhotghhihhprdgt
    ohhm
X-ME-Proxy: <xmx:oeDwaZPggO74vB7wrQLF7speBYdfnd01gSe0p9olcABtb2uEr4k_lg>
    <xmx:oeDwaYUwCBmRcyWxV06AW7L3pdaiAHk9hyDqPrYUrET4Ays-lW8Qng>
    <xmx:oeDwacu3a1eHN6kzIEqhZTlEyREx2gFMMKD8GANLaBETYjhfi-r-2w>
    <xmx:oeDwaT24VgAv82RcB8cX59TaC7YV83tddMfnlXMuGkno2m7_PmX1lg>
    <xmx:oeDwad7fdXlfgR-kjIXQ9T6ds72LMlqq0snGUjuV0caTSefqdkAvQAcq>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D56D4700065; Tue, 28 Apr 2026 12:30:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 28 Apr 2026 18:30:05 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
 "Thorsten Blum" <thorsten.blum@linux.dev>
Cc: "Bill Cox" <waywardgeek@gmail.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 "Nicolas Ferre" <nicolas.ferre@microchip.com>,
 "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
 "Claudiu Beznea" <claudiu.beznea@tuxon.dev>,
 "Linus Walleij" <linusw@kernel.org>, stable@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Message-Id: <e4091e56-0230-48fb-bd31-e617c32b6348@app.fastmail.com>
In-Reply-To: 
 <cbk4ho3bpprjxvcywv4sudbmb2fhfsgaguoywv5mhtoql4vhd6@f7oisxcrvii4>
References: <20260428101430.514838-3-thorsten.blum@linux.dev>
 <25ntssyy6t5uwxlwfpmrpzpcq6xv62l643hflf26hxi6lv5wqu@6vub6ysczjvd>
 <afCo9PbDpTYeqGd4@linux.dev>
 <cbk4ho3bpprjxvcywv4sudbmb2fhfsgaguoywv5mhtoql4vhd6@f7oisxcrvii4>
Subject: Re: [PATCH v2] crypto: atmel-sha204a - drop hwrng quality reduction for
 ATSHA204A
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Tue, 28 Apr 2026, at 15:24, Marek Beh=C3=BAn wrote:
> Hi Thorsten,
>
> Bill also wrote about ATSHA204A [1]
>
>   My best guess as to what's going on here is that the device has a
>   ring-oscillator based entropy source, but that it generates only a f=
ew bits
>   of entropy for each use.  It seems to be called before generating ea=
ch
>   32-byte "random" value, which is why the second set of 32-bit values=
 have
>   more possible values, and the 3rd has even more.  However, the numbe=
r of
>   unique values in the final column of 32*N byte values is always equa=
l to
>   the number of unique values of the entire string of bytes.
>
> If this is true that the device generates <256 true random bits and th=
en
> mixes in non-volatile pseudorandom number generator to produce 256 bit=
s,
> then the quality should not be set to full 1024.
>

This post is about the Hashlet, which has a ATSHA204 not ATSHA204A.


