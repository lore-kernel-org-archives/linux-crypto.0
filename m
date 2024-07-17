Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45499469D;
	Wed, 17 Jul 2024 02:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721185146; cv=none; b=DlRHE2hT5Lg7IO6V9S2TYQIo4CnjPSjRcrrEG6d3WIf94EjJ8WRs7/Z63WECnxgA//xAJXuejSc2iUEkGC7a16goB8Re9U/A5VXZzFaZhJGMDqo2xa16LENyh4C9C3LXfk6iNazeqrQ2WlxdsXbUmXlv3Pn24TfxE4vEJgjQgP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721185146; c=relaxed/simple;
	bh=8Z6LvjYkqZAZA9BLj34dX7n7F3kA3n+JYTUXN498kb8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cydeZXDDiMgS6cfSqOYYxUMI3zAXb1uxWuXnjPN9R9qPhxbIy74MhOscupYpBvBdPFalCvH8VtlLlcQak/biwd41KVE8nLdTmBqoBZAw/5Rkkkyu8w6smwEbn5QOoIc9nTHZho8t5J/M0XEYVF+pobqtufqLBR2h8vUJ39ghiZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0WwzhUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0WwzhUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B9AC4AF17;
	Wed, 17 Jul 2024 02:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721185145;
	bh=8Z6LvjYkqZAZA9BLj34dX7n7F3kA3n+JYTUXN498kb8=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
	b=J0WwzhUM3HG81W8gsWSqBs7fUp6LLj6x9oVS5QNgKl45YtbDuKJvcUDbbp+NOfe0P
	 I0LAD0sbBle5t7gaZeJhw6yjAPTs/WeaK0fzam/Tj4dLHgQrERRBj1su/InTta+3uD
	 rNxq29lh/fX5Fgyy4iTA7swGW7c9GU7hPSo9nP5mOWhQ4Lohc2R7cA3i1MoS+3OlFx
	 MYGfoOmDjhhYbPlH7A8h10Ulwx1YD12JgNIIWyeOeNYMEajP90BfZRI6It9/CotHjn
	 3IelFhmv6kuH8R8dIkcJ7zrYXvonDJStC4uu7G8hbMRcwwwr22/PJuthjo23QLwnxR
	 AK5F0OWo45+Zw==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2ee817dac89so3554111fa.1;
        Tue, 16 Jul 2024 19:59:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXOGGRSqy3SMvvqFbGF1sBBek2McKULVHL311vy0zlQQKDcK7hC8K34e0ClKWCn74t0VLdnwon00KztAf1JeTGdsgdSTIQQMon84yaV+JUEN0bAtfO1tlQ6XnkoSISGQY03dctFRTWOJ6z1p7mXv/g/euY93Ubo41wdPLpkOEGAzxg2tHGytw==
X-Gm-Message-State: AOJu0YzycrNwpeI6D4f9y5f0s+aEcq3DJcIrINL8/7ZOK9BDgbj5ayOm
	JN3UVnSoBaYI5Dws3H5/0oLm4dLQd7+vZdRzM3VkXNtyqO0o8AzGNmVcNmUFX7IZgBtIM6Baz+K
	lCfoZuV4MTJTnDhuj0oty/18Cuy4=
X-Google-Smtp-Source: AGHT+IF6M1MvWpqcnBWFgGyee1wdmH6gSbGXcC2xjWzFrJ0UZ8VRlr+1bXmtyhMyH+amFOHlY61HXtCtAHL8VhmGjZQ=
X-Received: by 2002:a2e:2a82:0:b0:2ee:8561:f388 with SMTP id
 38308e7fff4ca-2eef55c7ddbmr10590921fa.0.1721185143826; Tue, 16 Jul 2024
 19:59:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1720969799.git.daniel@makrotopia.org> <CAGb2v67zxs03xScN8OfWXR1gf8tddJciXrjw3FQZcL7pR3ocxA@mail.gmail.com>
 <3190961.CRkYR5qTbq@bagend> <3220752.Q7WYUMVHaa@bagend> <ZpcrdwZBNFu-YlZt@makrotopia.org>
In-Reply-To: <ZpcrdwZBNFu-YlZt@makrotopia.org>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Wed, 17 Jul 2024 10:58:51 +0800
X-Gmail-Original-Message-ID: <CAGb2v65Mm5s96asU7iaAC_sJnUk=Yuh+zMJJBbmSgETWrPLoFA@mail.gmail.com>
Message-ID: <CAGb2v65Mm5s96asU7iaAC_sJnUk=Yuh+zMJJBbmSgETWrPLoFA@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
To: Daniel Golle <daniel@makrotopia.org>
Cc: Diederik de Haas <didi.debian@cknow.org>, linux-rockchip@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, Martin Kaiser <martin@kaiser.cx>, 
	Sascha Hauer <s.hauer@pengutronix.de>, 
	Sebastian Reichel <sebastian.reichel@collabora.com>, Ard Biesheuvel <ardb@kernel.org>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@debian.org>, 
	devicetree@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Philipp Zabel <p.zabel@pengutronix.de>, Olivia Mackall <olivia@selenic.com>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Dragan Simic <dsimic@manjaro.org>, 
	Aurelien Jarno <aurelien@aurel32.net>, Heiko Stuebner <heiko@sntech.de>, 
	Anand Moon <linux.amoon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2024 at 10:25=E2=80=AFAM Daniel Golle <daniel@makrotopia.or=
g> wrote:
>
> On Tue, Jul 16, 2024 at 07:19:35PM +0200, Diederik de Haas wrote:
> > On Tuesday, 16 July 2024 18:53:43 CEST Diederik de Haas wrote:
> > > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> >
> > I don't know if it means something, but I noticed that I have
> > ``Long run: 0`` with all my poor results,
> > while Chen-Yu had ``Long run: 1``.
> >
> > Different SoC (RK3399), but Anand had ``Long run: 0`` too on their
> > very poor result (100% failure):
> > https://lore.kernel.org/linux-rockchip/CANAwSgTTzZOwBaR9zjJ5VMpxm5BydtW=
6rB2S7jg+dnoX8hAoWg@mail.gmail.com/
>
> The conclusions I draw from that rather ugly situation are:
>  - The hwrng should not be enabled by default, but it should by done
>    for each board on which it is known to work well.
>  - RK_RNG_SAMPLE_CNT as well as the assumed rng quality should be
>    defined in DT for each board:
>    * introduce new 'rochchip,rng-sample-count' property
>    * read 'quality' property already used for timeriomem_rng
>
> I will prepare a follow-up patch taking those conclusions into account.
>
> Just for completeness, here my test result on the NanoPi R5C:
> root@OpenWrt:~# cat /dev/hwrng | rngtest -c 1000
> rngtest 6.15
> Copyright (c) 2004 by Henrique de Moraes Holschuh
> This is free software; see the source for copying conditions.  There is N=
O warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOS=
E.
>
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 875
> rngtest: FIPS 140-2 failures: 125
> rngtest: FIPS 140-2(2001-10-10) Monobit: 123
> rngtest: FIPS 140-2(2001-10-10) Poker: 5
> rngtest: FIPS 140-2(2001-10-10) Runs: 4
> rngtest: FIPS 140-2(2001-10-10) Long run: 0
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=3D85.171; avg=3D141.102; max=3D4882812=
.500)Kibits/s
> rngtest: FIPS tests speed: (min=3D17.809; avg=3D19.494; max=3D60.169)Mibi=
ts/s
> rngtest: Program run time: 139628605 microseconds

I doubt this is per-board. The RNG is inside the SoC, so it could be a chip
quality thing. On the RK3399 we also saw wildly varying results.

ChenYu
