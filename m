Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189D825782D;
	Sun, 12 Apr 2026 01:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775956357; cv=none; b=ehPc8FTmFysDiB/zsnflGm5a6JIK152YkWuYz7c4Oi7tCG4tbELD52v/lW9Owcb7lJCbTCTZGxfUO9QhW9w9DKwA7kmRrMvOS3gjco9DYAnak74VxyDNirLacB+djAPkde6EUJy0y7ATkjso3gtdtMKXfPbEMTbXgj/x+1D6P6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775956357; c=relaxed/simple;
	bh=4p57nvVobDtPwbYUX8LLHjR3VXk6+LWR/y2qM3+ifEk=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=I+b1GDedS7Q3jJMDHKVPWFdiVK51gIavASXdXEoE9DVxSazaIoB1Fg+8ernyzV67CYSVDk+psd8iT89wnU8stzxig+T60EA/H6kSe3Vw7IPY0HmtJRJBevEWTO2GcQh8xNAgPtcQpG42jYf1lplWLm+LPZVVhIbYPrRoae3JKww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pg1Itq0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pg1Itq0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC45C116C6;
	Sun, 12 Apr 2026 01:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775956356;
	bh=4p57nvVobDtPwbYUX8LLHjR3VXk6+LWR/y2qM3+ifEk=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=pg1Itq0CXLLtqBup7RGT3yzWi06J02PDJz0GH7f8DfKt6CtJjyriX6P7gnY9k21RK
	 yfmZq41MpzCTgeUQ7mkAIvLc+Yei6c/yuiyxj/o/qfz1GeWyzUbIoLAkq+eLjYmiV7
	 uFcYKUhY09tBnfRcLBnqDpFDBj9+7E5rgtN+/2NrGgAMpdIJgSTKj5iYqu+Bdha0bv
	 26UqRytbrHPmbe4XGfUEiUcPV+maA+6gHe12VbykDu3gb52sfuueRAYNvu3djMR6Fx
	 62EDkiPR2UWLASm4iKSVo5aQ8IvNtpUearvMu/UimroEr6ApypFrL/XDiXna8JvcU+
	 fr/x8YszLD1bQ==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87y0j76p8o.fsf@bootlin.com>
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com> <20260327-schneider-v7-0-rc1-crypto-v1-10-5e6ff7853994@bootlin.com> <acqT3Dh03y3JiLLc@redhat.com> <87y0j76p8o.fsf@bootlin.com>
Subject: Re: [PATCH 10/16] clk: Add support for clock nexus dt bindings
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Jayesh Choudhary <j-choudhary@ti.com>, David S. Miller <davem@davemloft.net>, Christian Marangi <ansuelsmth@gmail.com>, Antoine Tenart <atenart@kernel.org>, Geert Uytterhoeven <geert+renesas@glider.be>, Magnus Damm <magnus.damm@gmail.com>, Thomas Petazzoni <thomas.petazzoni@bootlin.com>, Pascal EBERHARD <pascal.eberhard@se.com>, Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-clk@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-renesas-soc@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>
To: Brian Masney <bmasney@redhat.com>, Miquel Raynal <miquel.raynal@bootlin.com>
Date: Sat, 11 Apr 2026 18:12:34 -0700
Message-ID: <177595635458.5403.1619739189587608339@lazor>
User-Agent: alot/0.12

Quoting Miquel Raynal (2026-04-01 01:47:51)
> Hello Brian,
>=20
> First, thanks for the whole review.
>=20
> On 30/03/2026 at 11:16:44 -04, Brian Masney <bmasney@redhat.com> wrote:
> >> -            ret =3D of_parse_phandle_with_args(np, "clocks", "#clock-=
cells",
> >> -                                             index, out_args);
> >> +            ret =3D of_parse_phandle_with_args_map(np, "clocks", "clo=
ck",
> >> +                                                 index, out_args);
> >
> > Before I left my Reviewed-by, I should have double checked Sashiko. It
> > has several questions about this patch. The first is:
> >
> >     Are there other places in the clock framework that need to transiti=
on to the
> >     new map API to ensure assigned clocks work?
> >    =20
> >     For instance, assigned-clocks and assigned-clock-parents are parsed=
 in
> >     drivers/clk/clk-conf.c using of_parse_phandle_with_args(). If a dev=
ice
> >     specifies an assigned clock that routes through a nexus node, will =
it fail
> >     to configure because the map is not traversed?
>=20
> The goal of the nexus node is to isolate what is behind. Are
> assigned-clocks et al. supposed to traverse a nexus node? I am tempted
> to say "no", but I'm open to discussing this ofc.

Why would assigned-clocks not traverse the nexus node? If I'm a DT
author I would think any clock specifier should be routed properly
through the nexus node.
