Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4B1413242
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 12:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777378714; cv=none; b=G50mC9T3N6BOyFBIgDyfC/bq49s3X7cZ482x78QuSccmqx3F16nZvleMkhoEt9BJ2aWwv8EUEe2r5y/mUd9ux6x9UV6D0mAwj5f2ESvA770G1PXPcwRAnsFMXJVrUcBWlCDSSZBDX3NxoyWIYnp1jy0Rg2kv13+rJtlLTzWhBeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777378714; c=relaxed/simple;
	bh=GeqJqgST61g8OZ+fogX7D5CEU6hK/KqNPJ7A/LOYCoY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=A1M9cfep/B9R9xoFgXv/wEIwQ2SwCMWGsnu+xCLh3pc8pTMPe4RyM6S8FzuzX8VCtWWjuRyVgITZjJjFiuij+/B4bBJ+GkhPPrzLvl8YbQFNKp/dHmnlXO2lonLznTKwnVQSsQ9fUdFGAmYMPdPALQBG0L52PDd59cRa5emWdYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYF9DMXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYF9DMXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE274C4AF09;
	Tue, 28 Apr 2026 12:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777378712;
	bh=GeqJqgST61g8OZ+fogX7D5CEU6hK/KqNPJ7A/LOYCoY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=LYF9DMXyjPku5RHvarWGr/REtS4xBQNefGlQ/j1sTcQJwuMSU3HPFBPyK+DCZjyMR
	 xnW9XQIP2RAYOEZvWBHRdjS7xT/HPOjc+VKOqyLWSHCNgGSVjCQ6dV044/95qZQm6+
	 NKNzBSgusgdjSnPbaxKvQmKpbIppjUrNeQueHjdv9fpT456yaoQXmoMwHbWEAsmF8/
	 XUUZwnCK1ZkqrsWUKU1+h7nAztyLkuNXDGuPcI6rOqVpCiUmAnI5NA/35SZc71lV1Z
	 oEX21fwdECZ36l8eXUqjayZl9HCRfVFPnG0wtnrLLNbEe/pzvGf8c7F4LtqAslzlqY
	 I6WM/iJ7+U7lg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id DEA55F4006B;
	Tue, 28 Apr 2026 08:18:30 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 28 Apr 2026 08:18:30 -0400
X-ME-Sender: <xms:lqXwaSbP0vC6GR3KCy2oubmXUGXw_ve2JCD_3OMHBbiIT9_4DSoqbQ>
    <xme:lqXwaQMrdbaxIYzyGSgibPPJjP3olDl0RrdxeMKLlVMG9eWULFAAF4S0XsvkmBDmM
    Tdpubvp9F6oSEnE5EVrK4XO0j-V-fLdWYwHf1EL6eILJcwPjjGI1BWy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekudehgecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:lqXwaSr54cDzuYtuwHKHuU-PebcJUz0HACAiQrqjh-mzFygSXUe9wA>
    <xmx:lqXwadBSq4VnzGGoCl_PJcOle4BXqKPdOytrAM6PNatO4qcbPgZHKg>
    <xmx:lqXwabqz1NAXxWa66z2EVrWErWOmh2QoKK35-Xa-nK51RVlGoLu36g>
    <xmx:lqXwaQC3toacqj6VJNpIIS-JXQTbGuxE7MNjVvpLHNesQXNPYSiiDg>
    <xmx:lqXwaeWK_OSeVfJtXxnMfpg3nobskTqaPV_5YGRzFO8v3pK44chGu7ES>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id B060A700065; Tue, 28 Apr 2026 08:18:30 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 28 Apr 2026 14:18:10 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
 "Bill Cox" <waywardgeek@gmail.com>
Cc: "Thorsten Blum" <thorsten.blum@linux.dev>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 "Nicolas Ferre" <nicolas.ferre@microchip.com>,
 "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
 "Claudiu Beznea" <claudiu.beznea@tuxon.dev>,
 "Linus Walleij" <linusw@kernel.org>, stable@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Message-Id: <fdc71111-dc61-4393-9740-12b86c880f05@app.fastmail.com>
In-Reply-To: 
 <25ntssyy6t5uwxlwfpmrpzpcq6xv62l643hflf26hxi6lv5wqu@6vub6ysczjvd>
References: <20260428101430.514838-3-thorsten.blum@linux.dev>
 <25ntssyy6t5uwxlwfpmrpzpcq6xv62l643hflf26hxi6lv5wqu@6vub6ysczjvd>
Subject: Re: [PATCH v2] crypto: atmel-sha204a - drop hwrng quality reduction for
 ATSHA204A
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Marek,

On Tue, 28 Apr 2026, at 13:18, Marek Beh=C3=BAn wrote:
> Adding Bill Cox (waywardgeek) to the conversation.
>
> In the meantime Nack from me on this patch.
>
> From the original messages by Bill, it seems to me the part he was rev=
iewing
> was the ATSHA204A.
>

According to Landon Cox, the Atmel engineer, the hashlet has a ATSHA204 =
not
ATSHA204A ([2] in the original post)

> In subsequent reply [1] Bill states
>
>   While there is some evidence, there is still no convincing proof tha=
t there
>   is an entropy source in this device at all.  There is some evidence =
that
>   Atmel has inserted a back-door.  My advice is to avoid this line of =
parts
>   from Atmel for cryptographic use.
>
> In another message Peter Gutmann asks about ATECC108 [2] and Bill repl=
ies [3]
>
>   This part uses the same language to describe the random number gener=
ator.
>   It is "high quality".  I think that's pretty funny.
>   I would be interested in seeing if the new part can generate random =
numbers
>   continuously, or if it fails after it's EEPROM wears out like their =
other
>   parts.  The use of an EEPROM seed is for PWN-ing your RNG, not makin=
g it
>   more secure.
>
> IMO the comments from the actual reviewer are more relevant than those=
 of the
> engineer working for the company which was accused of creating low qua=
lity
> / backdoored TRNG, at least until the Atmel engineer provides some eva=
luation
> code for the device (which they suggested they might do [4], but never=
 did as
> far as I can find).
>
> Maybe we can instead change the ATECC quality to something like 32? Do=
es that
> even make sense?
>

So Bill recommends against using the ATSHA204 based on his hands-on expe=
rience,
and extrapolates this to ATSHA204A/ATECC/etc based on the fact that the =
wording
in the data sheet description looks similar.

OTOH, the Atmel engineer claiming to have been involved in constructing =
these
parts acknowledges the ATSHA204 issue, and claims that the other parts a=
re not
affected in the same way.

I don't think we should be using the quality field as a reflection of our
assessment whether this engineer is lying or speaking the truth, or the
likelihood that the RNG is backdoored. It is a quality metric not a trus=
t metric.

So if the RNG is flawed and does not produce perfect entropy, we should =
set
the quality value to reflect this. If the device is compromised, it shou=
ld
be avoided entirely, and what the driver does is irrelevant.

IOW, let the user decide - if they choose to use the device, don't cripp=
le
it based on our skepticism alone.




