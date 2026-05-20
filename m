Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607D734B404
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 06:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779259465; cv=none; b=IBx/NW3o4QAq8XDNC1YGUJgGaCWmOw7M8X+FoubrNTvPjIBoRuSzS4n6CdbO0Z/k0/4S/ibfy7RbZAewTlRQjGbX7s5CNboW53uk/5NrWR/octDYcE3kFhMfMdpZ8Q6PAfqvQpAK6s5xPhDDmPUwX5nz1ia6z0JjQJ/VQUocPsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779259465; c=relaxed/simple;
	bh=cyaxZDnfncpfz96qJu+jO+sMOq2b8h0bNELQs9DTTn0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=MYlrMVDIA9XALWKxWdXfjy1Qvn3IvpkVEiaqK7TEuHW2Q8nbG+3gwUa4UivQhxS9RQIVY0/j31m25foUhkTPvUjwzxkg4IOq4bQdosCw3KNGCxB7BEIqMm7/QEE99MK1LEOjnp01/oP6t3xzCMlfWoExmL1nXSeDJca5Rnw2bgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ozmZTUjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozmZTUjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916611F000E9;
	Wed, 20 May 2026 06:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779259461;
	bh=/XU1KJEIpJD7sz0WHWX8jsl8435fYv6zL2ltBSoQIW8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=ozmZTUjWFWt99kP2+KjNWiH2zgJafxakMIw0IOcmg0FpvHTYgdWwZBFXAzcsO1WEE
	 TrSHQPczsIthEY3Y6kHOE4CCdxZYBN5ZiOxSea6/ZwBMd7QNzeC7TKEubbeQaV2pLi
	 c5ACGh3MezgaB3SWK6u7t8gUTgWrfy69xEf7YS8wS8JYWeAWLHDQwI3MOaxLLISP/P
	 ul/Okbif8ZmTaPe4bS/1bUdSOy0TLIvXvph5ud9Ognn45A67P5sPqWQK4gbSaMsfVE
	 QXjwjVvg+eQridave7D+WMhO+Eo6JAxBlhs546GQH2N1dMGsG7zclnUofNXFjCLyKn
	 ELIufQJ/y9veg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id B46D6F40084;
	Wed, 20 May 2026 02:44:20 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Wed, 20 May 2026 02:44:20 -0400
X-ME-Sender: <xms:RFgNamKwEMr56_MZsB0rJLrqLo9mTMHz7oUajwELiRJhDD2W-JFgDA>
    <xme:RFgNao_5eXkQ-RB4L579oFItpKUyRhpxBjd6mx_eKds2yPYAVckbtPjZRBaSDHKfi
    cJYo7QzRRv-A_jQ6mQSsgxY0OyWuBMI50rZbHXbqjpTun02tK4QuFc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeefleegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeefhefgtefgkefhgfdvffdukeejheeuvedthfdtiefhleejhfefjeffieeu
    jeefteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    uddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehurdhklhgvihhnvgdqkhhovg
    hnihhgsegsrgihlhhisghrvgdrtghomhdprhgtphhtthhopegrlhgvgigrnhgurhgvrdgs
    vghllhhonhhisegsohhothhlihhnrdgtohhmpdhrtghpthhtohepuggrvhgvmhesuggrvh
    gvmhhlohhfthdrnhgvthdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghp
    rghnrgdrohhrghdrrghupdhrtghpthhtohepthhhohhrshhtvghnrdgslhhumheslhhinh
    hugidruggvvhdprhgtphhtthhopehlihhnuhigqdgrrhhmqdhkvghrnhgvlheslhhishht
    shdrihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehnihgtohhlrghsrdhfvghrrh
    gvsehmihgtrhhotghhihhprdgtohhmpdhrtghpthhtoheptghlrghuughiuhdrsggviihn
    vggrsehtuhigohhnrdguvghvpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvgh
    gvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:RFgNanvJG5sya091gFvdSd_PKlx3lHUJvyL3znodAG7glX0fYIVQ8A>
    <xmx:RFgNakUeImDMwdrinZ2SrqXFu9XhcHw5f6r7WE7XlEM0ADZ-udLfDQ>
    <xmx:RFgNanz8HyOcRulfnmChXHaMK8dw6NXyqZSMf4Z-xsTY7JLJmtyt1Q>
    <xmx:RFgNarFT97jvAlkyHQee9xD2iuGOBJk-ldnLQ_Cz9G_m7LUrS3FVRQ>
    <xmx:RFgNasvh_GPgvwexsFeXBe4i90XykWYnaGW7bZtxw7iIIMJn1yMeCrdh>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 8FE65182007E; Wed, 20 May 2026 02:44:20 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 20 May 2026 08:43:59 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: 
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>,
 "Thorsten Blum" <thorsten.blum@linux.dev>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 "Nicolas Ferre" <nicolas.ferre@microchip.com>,
 "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
 "Claudiu Beznea" <claudiu.beznea@tuxon.dev>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Message-Id: <fa73cb3b-df9a-4070-b525-29c640f81230@app.fastmail.com>
In-Reply-To: <20260519141033.1586036-2-u.kleine-koenig@baylibre.com>
References: <20260519141033.1586036-2-u.kleine-koenig@baylibre.com>
Subject: Re: [PATCH v1] crypto: Use named initializers for struct i2c_device_id
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Tue, 19 May 2026, at 16:10, Uwe Kleine-K=C3=B6nig (The Capable Hub) w=
rote:
> While being less compact, using named initializers allows to more easi=
ly
> see which members of the structs are assigned which value without havi=
ng
> to lookup the declaration of the struct. And it's also more robust
> against changes to the struct definition.
>
> This patch doesn't modify the compiled arrays, only their representati=
on
> in source form benefits. The former was confirmed with x86 and arm64
> builds.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig (The Capable Hub) <u.kleine-koeni=
g@baylibre.com>
> ---
> Hello,
>
> this patch is part of a bigger quest to use named initializers for
> mainly struct i2c_device_id::driver_data to be able to modify
> i2c_device_id. See e.g.
> https://lore.kernel.org/all/20260518111203.639603-2-u.kleine-koenig@ba=
ylibre.com/
> for the details.
>
> This patch here isn't critical for this quest, as no driver makes use =
of
> .driver_data, so apart from the better readability this is only about
> consistency with other subsystems.
>
> Best regards
> Uwe
>
>  drivers/crypto/atmel-ecc.c     | 2 +-
>  drivers/crypto/atmel-sha204a.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> index 9c380351d2f9..56350454ac29 100644
> --- a/drivers/crypto/atmel-ecc.c
> +++ b/drivers/crypto/atmel-ecc.c
> @@ -380,7 +380,7 @@ MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids);
>  #endif
>=20
>  static const struct i2c_device_id atmel_ecc_id[] =3D {
> -	{ "atecc508a" },
> +	{ .name =3D "atecc508a" },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(i2c, atmel_ecc_id);
> diff --git a/drivers/crypto/atmel-sha204a.c=20
> b/drivers/crypto/atmel-sha204a.c
> index dbb39ed0cea1..0fcb4692494f 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -210,8 +210,8 @@ static const struct of_device_id=20
> atmel_sha204a_dt_ids[] __maybe_unused =3D {
>  MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
>=20
>  static const struct i2c_device_id atmel_sha204a_id[] =3D {
> -	{ "atsha204" },
> -	{ "atsha204a" },
> +	{ .name =3D "atsha204" },
> +	{ .name =3D "atsha204a" },
>  	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(i2c, atmel_sha204a_id);
>
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
> --=20
> 2.47.3
