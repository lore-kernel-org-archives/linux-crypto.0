Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7C43A8D8;
	Wed, 17 Jul 2024 08:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721205536; cv=none; b=no5dWiT8vA+UTmgG+gXsEDbHkWGDCmbnDH8RElxmwFTYoquvc6r8fXqY8Kn41mUi/OWuxz6nf5glnvFyHE/8eI+UaeUZ52Ft8AbFyRWyc9mI7ysS/UkGb+Yb4Mnh5uC0u32bKbS+Wj2A4x41pDnaOCdoNgIRMJ3SXzfzIlwTrbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721205536; c=relaxed/simple;
	bh=//VhoJmBRXereTEafCipN5TRxv7+uitmznbzZSgGUu0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rNk6NKzpyeLZuvHDfTHs+yubK5OkfLKLa+5e9drulYLflTB8AaJmjbEAzVs1UIEqKCc9hjHSoJFoTiqzMveOL85S4OiQEtdDu8KJdp2lcqSlSxD2GV815R/3YCiibOyq/Akhck/8ihYxgOMCr/HytByAwJ3Vvhl9XGACZz+9d6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJ4W7Pj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJ4W7Pj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A9AC4AF12;
	Wed, 17 Jul 2024 08:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721205535;
	bh=//VhoJmBRXereTEafCipN5TRxv7+uitmznbzZSgGUu0=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
	b=HJ4W7Pj2XMkvDazsjdRJl7yYjY2VPHC2gR5kKLwVIEkcahMuIENlnxkrjZJ0m195l
	 mx+MOrc1xPQB6cf6fzjj1t+TuUccwK/T/5BhBEZtV/TCbevxPrQZPxGwmuWZbb4pKK
	 xI9p1dFuCQEkRSrlpEnirHfIoCjrpnBK1XjhRTjYFx8/ySU7HSnvK4P9pWXglOMk80
	 reZ7hkw6gGTt1fBUMlqGUisKQx4WsJ83fg9EZQ0ZrQ5UI9npWmwmrpl4NDmQljnA96
	 fmKiFXNStmfmr8ayex0swnCfJJkoRWfrIXYM5HQq1RJiUNAgg0uqTQGLKtZ8kRa2Jk
	 YJkRRQ3+r9swA==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ebed33cb65so84641421fa.2;
        Wed, 17 Jul 2024 01:38:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVP1TthzR6KRwvC5c8ZQ264/tRk8Yx1i8VFaUODJNp9l9kuUxJH7wov0/OV0WCDN4+Hhz+TKNO0WzAGIu79vYwvv8pPXO1SHN5rI+5IPy2Zel8LjTMgf3uqOWFS8kGfj4vEpTodZOlyVQLrnXsLfQEQQjxxm0d2V/SRmSlmNxXivNGOGw/Svg==
X-Gm-Message-State: AOJu0YxiUipVfsuuYX8/Kl5eiW0Xd0XVFwlqe65n1Uc3TdFaC8uWPXFk
	p00aoT6AAMQ91J2y05TsmolzxiCisxWPCcic5zy6ro+PYLfpDM7V7AUT8FS8xQOLWp+zfuftEMC
	KRO6yg4c5pdJ/M1yXyxXyfZ4BN5A=
X-Google-Smtp-Source: AGHT+IFyCom2uSVQC8OGjrwqFp3CJD+Hy+n9usyiPhTcFaUGFgcAkPR+nxjKE/oaopQzVIh5whJj6h5GPI+vuF8O6kQ=
X-Received: by 2002:a2e:6a09:0:b0:2ee:4a63:e927 with SMTP id
 38308e7fff4ca-2eefd14c9c0mr6925311fa.39.1721205533799; Wed, 17 Jul 2024
 01:38:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1720969799.git.daniel@makrotopia.org> <ZpcrdwZBNFu-YlZt@makrotopia.org>
 <CAGb2v65Mm5s96asU7iaAC_sJnUk=Yuh+zMJJBbmSgETWrPLoFA@mail.gmail.com> <2451882.5D0I8gZW9r@bagend>
In-Reply-To: <2451882.5D0I8gZW9r@bagend>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Wed, 17 Jul 2024 16:38:40 +0800
X-Gmail-Original-Message-ID: <CAGb2v65BaN3rDGA+9D4mAoz4+7C4CfSqhEhd81ev-BViy0tEbw@mail.gmail.com>
Message-ID: <CAGb2v65BaN3rDGA+9D4mAoz4+7C4CfSqhEhd81ev-BViy0tEbw@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
To: Diederik de Haas <didi.debian@cknow.org>
Cc: Daniel Golle <daniel@makrotopia.org>, linux-rockchip@lists.infradead.org, 
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

On Wed, Jul 17, 2024 at 4:22=E2=80=AFPM Diederik de Haas <didi.debian@cknow=
.org> wrote:
>
> On Wednesday, 17 July 2024 04:58:51 CEST Chen-Yu Tsai wrote:
> > On Wed, Jul 17, 2024 at 10:25=E2=80=AFAM Daniel Golle <daniel@makrotopi=
a.org> wrote:
> > > On Tue, Jul 16, 2024 at 07:19:35PM +0200, Diederik de Haas wrote:
> > > > On Tuesday, 16 July 2024 18:53:43 CEST Diederik de Haas wrote:
> > > > > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> > > >
> > > > I don't know if it means something, but I noticed that I have
> > > > ``Long run: 0`` with all my poor results,
> > > > while Chen-Yu had ``Long run: 1``.
> > > >
> > > > Different SoC (RK3399), but Anand had ``Long run: 0`` too on their
> > > > very poor result (100% failure):
> > > > https://lore.kernel.org/linux-rockchip/CANAwSgTTzZOwBaR9zjJ5VMpxm5B=
ydtW6
> > > > rB2S7jg+dnoX8hAoWg@mail.gmail.com/>
> > > The conclusions I draw from that rather ugly situation are:
> > >  - The hwrng should not be enabled by default, but it should by done
> > >
> > >    for each board on which it is known to work well.
> > >
> > >  - RK_RNG_SAMPLE_CNT as well as the assumed rng quality should be
> > >
> > >    defined in DT for each board:
> > >    * introduce new 'rochchip,rng-sample-count' property
> > >    * read 'quality' property already used for timeriomem_rng
> > >
> > > I will prepare a follow-up patch taking those conclusions into accoun=
t.
> > >
> > > Just for completeness, here my test result on the NanoPi R5C:
> > > root@OpenWrt:~# cat /dev/hwrng | rngtest -c 1000
> > > rngtest 6.15
> > > Copyright (c) 2004 by Henrique de Moraes Holschuh
> > > This is free software; see the source for copying conditions.  There =
is NO
> > > warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
> > > PURPOSE.
> > >
> > > rngtest: starting FIPS tests...
> > > rngtest: bits received from input: 20000032
> > > rngtest: FIPS 140-2 successes: 875
> > > rngtest: FIPS 140-2 failures: 125
> > > rngtest: FIPS 140-2(2001-10-10) Monobit: 123
> > > rngtest: FIPS 140-2(2001-10-10) Poker: 5
> > > rngtest: FIPS 140-2(2001-10-10) Runs: 4
> > > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> > > rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> > > rngtest: input channel speed: (min=3D85.171; avg=3D141.102;
> > > max=3D4882812.500)Kibits/s rngtest: FIPS tests speed: (min=3D17.809;
> > > avg=3D19.494; max=3D60.169)Mibits/s rngtest: Program run time: 139628=
605
> > > microseconds
> >
> > I doubt this is per-board. The RNG is inside the SoC, so it could be a =
chip
> > quality thing.
>
> I agree with ChenYu (and others) that this is isn't a per-board level thi=
ng.
> I'd even go further: 's/I doubt/It can't be that/' (for the same reason
> though; this is inside the SoC).
>
> Before I saw these latest emails, I was going to suggest:
> 1. Enable it only on RK3568 for now. I would be fine if this would be acc=
epted
> by the maintainer
>
> 2. Ask that you make a special version (for me) where I could play with t=
he
> params without having to compile a new kernel for each variant (it genera=
lly
> takes me more then 24h on my Q64-A). Either through kernel module propert=
ies
> or properties defined in the DeviceTree is fine with me.
>
> 3. Based on the results make  a choice to not enable it on rk3566 at all =
or
> (indeed) introduce DT properties to configure it differently per SoC.
>
> 4. Hope/Ask for more test results
>
> > On the RK3399 we also saw wildly varying results.
>
> On my Rock64('s) (RK3328) it doesn't work at all:
>
> ```
> root@cs21:~# cat /dev/hwrng | rngtest -c 1000
> rngtest 5
> ...
> rngtest: starting FIPS tests...
> cat: /dev/hwrng: No such device
> rngtest: entropy source drained
> ```

RK3399 and RK3328 are covered by a different driver:

https://lore.kernel.org/all/20230707115242.3411259-1-clabbe@baylibre.com/

And that patch says the TRNG on the RK3328 is utterly broken.


ChenYu


> Cheers,
>   Diederik
