Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BB33A75A8;
	Wed,  1 Apr 2026 08:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775033284; cv=none; b=vATJLElk+l6ddWOLxGkdCi1VHu74O1ag6yFxqAH+tMGE2jRo4TXOMY2bkXP6s4qMqYWv4UGSdPXBqBCgmRYVHREPBEbXvSqZG6A97TycMKlQ3fBRlJ30bKjEArf5VOHZ3LEMhLC0kBJ0lGBdx+Pl9O1BgIb7S5D4mxFZPuDxSuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775033284; c=relaxed/simple;
	bh=kbzqwPjUI5FPIJ6Pezp/hV9jTHQNFhZvMfXHh1uylQM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CFEjtTjWNbwSsPQZE7v5kvUoxcgE1WckWYU3U3Lze2WgSUuZiDv0BBy5jPaaDUPgK0IOD/mamQNGERO6bgjwykU42W3WVZQwGX134haD84496odZcI0vXoUut5ECKRhd2paUYx57AZrVT6eWOax6VfEVJDzycKn9qdfOXRlxYR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=O8gwdWor; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="O8gwdWor"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 5CF441A310E;
	Wed,  1 Apr 2026 08:48:01 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 2799F602BF;
	Wed,  1 Apr 2026 08:48:01 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0A232104502B1;
	Wed,  1 Apr 2026 10:47:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1775033279; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=MulX6YMpnNOMv0Pee5WdBa40QBlB89kOy61SqtPUmhY=;
	b=O8gwdWorFGZ31oS+MUxUypavWrJm+WPFW7B9iYYf3nLc9EIVFbgNYH63p4x6hVyLOQ0owi
	DVEKZRJGe9fKHyuKzeosSHTJjPuClPcoe3qKSHiASpnph+6DJYEI1QO86tbKGmq7tNAaCa
	eOZa4WUj92yF+GeqNgexZfhQ6FQVTPliQN9YsLW/80Qi3IgqJuVChweuxfHjjKvFjwRShm
	3GZ2JwjptP7jnvMgvRTcNYaI887GlPBQOYCE2fEkiYjuNSFuqKDRTX48XzHD3BxGfmK6Xj
	ThbolGyeWrENnGcYTK/LswFcFGTPIfjdoy0tPogo5o9nL3igAjB/PihoOY+Mmw==
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Brian Masney <bmasney@redhat.com>
Cc: Michael Turquette <mturquette@baylibre.com>,  Stephen Boyd
 <sboyd@kernel.org>,  Rob Herring <robh@kernel.org>,  Krzysztof Kozlowski
 <krzk+dt@kernel.org>,  Conor Dooley <conor+dt@kernel.org>,  Thomas
 Gleixner <tglx@kernel.org>,  Olivia Mackall <olivia@selenic.com>,  Herbert
 Xu <herbert@gondor.apana.org.au>,  Jayesh Choudhary <j-choudhary@ti.com>,
  "David S. Miller" <davem@davemloft.net>,  Christian Marangi
 <ansuelsmth@gmail.com>,  Antoine Tenart <atenart@kernel.org>,  Geert
 Uytterhoeven <geert+renesas@glider.be>,  Magnus Damm
 <magnus.damm@gmail.com>,  Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
  Pascal EBERHARD <pascal.eberhard@se.com>,  Wolfram Sang
 <wsa+renesas@sang-engineering.com>,  linux-clk@vger.kernel.org,
  devicetree@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-crypto@vger.kernel.org,  linux-renesas-soc@vger.kernel.org,  Herve
 Codina <herve.codina@bootlin.com>
Subject: Re: [PATCH 10/16] clk: Add support for clock nexus dt bindings
In-Reply-To: <acqT3Dh03y3JiLLc@redhat.com> (Brian Masney's message of "Mon, 30
	Mar 2026 11:16:44 -0400")
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
	<20260327-schneider-v7-0-rc1-crypto-v1-10-5e6ff7853994@bootlin.com>
	<acqT3Dh03y3JiLLc@redhat.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Wed, 01 Apr 2026 10:47:51 +0200
Message-ID: <87y0j76p8o.fsf@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hello Brian,

First, thanks for the whole review.

On 30/03/2026 at 11:16:44 -04, Brian Masney <bmasney@redhat.com> wrote:
>> -		ret =3D of_parse_phandle_with_args(np, "clocks", "#clock-cells",
>> -						 index, out_args);
>> +		ret =3D of_parse_phandle_with_args_map(np, "clocks", "clock",
>> +						     index, out_args);
>
> Before I left my Reviewed-by, I should have double checked Sashiko. It
> has several questions about this patch. The first is:
>
>     Are there other places in the clock framework that need to transition=
 to the
>     new map API to ensure assigned clocks work?
>=20=20=20=20=20
>     For instance, assigned-clocks and assigned-clock-parents are parsed in
>     drivers/clk/clk-conf.c using of_parse_phandle_with_args(). If a device
>     specifies an assigned clock that routes through a nexus node, will it=
 fail
>     to configure because the map is not traversed?

The goal of the nexus node is to isolate what is behind. Are
assigned-clocks et al. supposed to traverse a nexus node? I am tempted
to say "no", but I'm open to discussing this ofc.

> https://sashiko.dev/#/patchset/20260327-schneider-v7-0-rc1-crypto-v1-0-5e=
6ff7853994%40bootlin.com?patch=3D12563

I have mixed feelings concerning Sashiko's feedback. I will go through
that page nevertheless, there are interesting comments in there.

Thanks,
Miqu=C3=A8l
