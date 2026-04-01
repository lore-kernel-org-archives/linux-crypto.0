Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4913D222580;
	Wed,  1 Apr 2026 08:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775033386; cv=none; b=DYijG5RSr6skZt1PoQVVznbwKqPqVgyHzqHZv1ESlf2OMDn/W67U53h/NfCjm1p6StrNRZhGbePxH8Bbb0lQQB09A4vuXrbZhKRqYUf2ACDiSKSTAhPr0jYySj4MHDiABv8RGVgTsYGbnM7hpDfrpgVfp+nt/an4TLzrRW4cSWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775033386; c=relaxed/simple;
	bh=jMllAiNzS9cWod+MVPKKd+bgclJPQsP6g3jKKwGPnaU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EjOY8L0dNIdPpATzqZN6RwCCHU6RVeAcqboXQi07KyCpElfs31eY3j0pCLRgL9+67FVZ8UPAwzfhAlcbLH2AHeWPjbIl62TE4gg/cRehBv1r3f2rDK8E69FsbDwTwq8fi2XAy/O/1Hyhz7/a/91Nwlxs8zJaSnR5Po2wPKWy2P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=GQF/BJD4; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="GQF/BJD4"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 0D1951A310E;
	Wed,  1 Apr 2026 08:49:43 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D72A4602BF;
	Wed,  1 Apr 2026 08:49:42 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DC3D2104502B1;
	Wed,  1 Apr 2026 10:49:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1775033381; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ZdDof3E64VuKteZJZYyiQE0W9ztWcs73qsS2cREQvAI=;
	b=GQF/BJD4QwFxFBgX9eNsIRAVzAxsLPiCxbs7s2rLRDyj2QieSJ1OS3E2OjxhUojDFdUngQ
	wBrFqRD8YeCN8/eALU/6syeKCjicRV2N3v9UYIi9P2SBRpVs1q5XkiSVn/nvoXNkA7PrqH
	ERkbal5Ep7glNJJMMB45hFRg6EaEUwT5vVNhLk+4et8BU1zVrKIRYJLTEcPt1BMZZtzcF6
	tCJqjF5bmQ5SMdi5x9bjg0ptoSGz7LUwKfac4X1wcOH30L7Kx4K+DxWvHp0uynmyWLCNFJ
	Z6yzQ+Ay/iw/i0GF8ar/H7KTvcK+zUHLBcCwslCGDKTTz3tVZY7jduwOTu8kXw==
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
  linux-crypto@vger.kernel.org,  linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 09/16] clk: Use the generic OF phandle parsing in only
 one place
In-Reply-To: <acqQZ5sx_WZrr4KJ@redhat.com> (Brian Masney's message of "Mon, 30
	Mar 2026 11:01:59 -0400")
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
	<20260327-schneider-v7-0-rc1-crypto-v1-9-5e6ff7853994@bootlin.com>
	<acqQZ5sx_WZrr4KJ@redhat.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Wed, 01 Apr 2026 10:49:37 +0200
Message-ID: <87se9f6p5q.fsf@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

On 30/03/2026 at 11:01:59 -04, Brian Masney <bmasney@redhat.com> wrote:

> On Fri, Mar 27, 2026 at 09:09:31PM +0100, Miquel Raynal (Schneider Electr=
ic) wrote:
>> There should be one single entry in the OF world, so that the way we
>> parse the DT is always the same. make sure this is the case by avoid
>> calling of_parse_phandle_with_args() from of_clk_get_parent_name(). This
>> is even more relevant as we currently fail to parse clock-ranges. As a
>> result, it seems to be safer to directly call of_parse_clkspec() there.
>>=20
>> Suggested-by: Stephen Boyd <sboyd@kernel.org>
>> Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin=
.com>
>> ---
>>  drivers/clk/clk.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index 591c0780b61e..93e33ff30f3a 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -5375,8 +5375,7 @@ const char *of_clk_get_parent_name(const struct de=
vice_node *np, int index)
>>  	int count;
>>  	struct clk *clk;
>>=20=20
>> -	rc =3D of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
>> -					&clkspec);
>> +	rc =3D of_parse_clkspec(np, index, NULL, &clkspec);
>>  	if (rc)
>>  		return NULL;
>
> Reviewed-by: Brian Masney <bmasney@redhat.com>
>
> In case a Fixes tag is warranted, it's not exactly clear what should be
> used. This was introduced in commit 766e6a4ec602 ("clk: add DT clock
> binding support") in 2012. However of_parse_clkspec was introduced in
> commit 4472287a3b2f5 ("clk: Introduce of_clk_get_hw_from_clkspec()") in
> 2018.

I didn't plan to add a Fixes here, but I can. In this case I would go
for:

    commit 4472287a3b2f5 ("clk: Introduce of_clk_get_hw_from_clkspec()")

Thanks,
Miqu=C3=A8l
