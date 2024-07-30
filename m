Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EFE19415E;
	Tue, 30 Jul 2024 12:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722341301; cv=none; b=SXx3P+CCLo+wCKY9oM2Le09tlBSjgA6k7mKC/N0cjnS0IpU82vOanXGc9NqKRf5sMZ7O0JPYp72UPze94cfU628obY2wd+R3WNgongV47RS3V1zgxqNvRAbVPSJLAymLZ6a/oSqFxxc/KELfAV5I5UpybVeHSttP8pJMcwxjsGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722341301; c=relaxed/simple;
	bh=pPjpBfbivKL6cAv5q8a1r5/0D4K3ehqMUNcKDTlaZW8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eQUpYaH1bswKApE7vU+dhdkf1z+baYOP1eOAvG3/+lwPQ1hArbG73KaVoIonzb89v04xzQZ0aRkgHdq4JVN9t2nSZpT4xla+Ud5qDzfyLFjgAudiS73tplkdwllovnCKtdx5nHAlURl4UJfuu4KTTRQMry9Q93e9/hStYX33w9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FhoKyhBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FhoKyhBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8BDC32782;
	Tue, 30 Jul 2024 12:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722341299;
	bh=pPjpBfbivKL6cAv5q8a1r5/0D4K3ehqMUNcKDTlaZW8=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
	b=FhoKyhBwlE5KAF61bGSntzRr7kl53sTSu/xykZvfmLRgajXu3ecq9K2BPuXOpNMQG
	 RJR+GKm6G/0Ox9UEp+ToWbP3PmBzRruOg5A8z7oOo1I+idyScmPoCtuklB+xGtTsJo
	 xcCwVB7hM4omI4xl8AE2vvNiOgFqldoSwXtMZ1pG8GCfk0+ZRv7tooqUnHM/OGZEWZ
	 hrk8ioBYhzHaOyBeyrr0FZcu8sKDWaBlixHe7BkhoN7/rmS2EnYFdO7duEtCaQMNci
	 wsrst8amyTth0X5Twgby5vRpU1Mv1spZK0V7rVrx3qACqnGoSuC24lZ1LCV0F6Qx/r
	 IXHMhZsZCTIUw==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2f035ae1083so59562111fa.3;
        Tue, 30 Jul 2024 05:08:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWCrofFxFNIny2wraNiJ9RK+FAesF/nJ74h1EIMu8rQvij4301DxOzO76dPdLJnI55SzlTUCUuVqsG6nMxiet4yticTKI62Z9vomjj45z5cmgyAZlQBVjn4agTT1JrkoPTNcXMJZc55RpTf+jFhuu4jgUJAEoP+ErZ4IOiCwxzOZwR0fTeMsg==
X-Gm-Message-State: AOJu0YzyX2Jcy5WmkTEYtC9j444PhLwQpfElHBCjxsaKGJ0dCfF0fMOj
	wo11okaC6w3AKHJHRqqlMsOQ0McUIXzJFNZIiZQZdoodhwNfdwjFB1plGSczZpbCHETVeMLdc3m
	YcQrxHFFpq7y4jxZT6x1v7EiNPi8=
X-Google-Smtp-Source: AGHT+IEew2ptwjzerzes/DjMQPGgSwoLU7EI7pt/rY+1Yqs+CFA3dSUw8u2GOoxP5Z1uV8X2YApMbOoHS69Zl0l9/D8=
X-Received: by 2002:a2e:91d4:0:b0:2ef:1f68:eae1 with SMTP id
 38308e7fff4ca-2f12ee077famr71560271fa.17.1722341298040; Tue, 30 Jul 2024
 05:08:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1720969799.git.daniel@makrotopia.org> <ZqgjTQMgWZO2FjaC@makrotopia.org>
 <6690040.iosknibmi9@bagend> <17577153.5WZRyvrzyv@diego>
In-Reply-To: <17577153.5WZRyvrzyv@diego>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Tue, 30 Jul 2024 20:08:04 +0800
X-Gmail-Original-Message-ID: <CAGb2v65xZEeZWmKFCRqyO7H=r7_jA4FTJxwKSVj7-qVXPS_fKw@mail.gmail.com>
Message-ID: <CAGb2v65xZEeZWmKFCRqyO7H=r7_jA4FTJxwKSVj7-qVXPS_fKw@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Dragan Simic <dsimic@manjaro.org>, Daniel Golle <daniel@makrotopia.org>, 
	Diederik de Haas <didi.debian@cknow.org>, linux-rockchip@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, Martin Kaiser <martin@kaiser.cx>, 
	Sascha Hauer <s.hauer@pengutronix.de>, 
	Sebastian Reichel <sebastian.reichel@collabora.com>, Ard Biesheuvel <ardb@kernel.org>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@debian.org>, 
	devicetree@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Philipp Zabel <p.zabel@pengutronix.de>, Olivia Mackall <olivia@selenic.com>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2024 at 6:37=E2=80=AFPM Heiko St=C3=BCbner <heiko@sntech.de=
> wrote:
>
> Am Dienstag, 30. Juli 2024, 11:03:06 CEST schrieb Diederik de Haas:
> > On Tuesday, 30 July 2024 01:18:37 CEST Daniel Golle wrote:
> > > On Wed, Jul 24, 2024 at 08:07:51AM +0200, Dragan Simic wrote:
> > > > Thanks a lot for the testing.  Though, such wildly different test r=
esults
> > > > can, regrettably, lead to only one conclusion:  the HWRNG found in =
RK3566
> > > > is unusable. :/
> >
> > FTR: I agree with Dragan, unfortunately.
> >
> > > The results on RK3568 look much better and the series right now also
> > > only enabled the RNG on RK3568 systems. However, we have only seen fe=
w
> > > boards with RK3568 up to now, and I only got a couple of NanoPi R5C
> > > here to test, all with good hwrng results.
> > >
> > > Do you think it would be agreeable to only enable the HWRNG for RK356=
8
> > > as suggested in this series? Or are we expecting quality to also vary
> > > as much as it (sadly) does for RK3566?
> >
> > Unless we get *evidence* to the contrary, we should assume that the HWR=
NG on
> > RK3568 is fine as the currently available test results are fine.
> > So I think enabling it only for RK3568 is the right thing to do.
> >
> > So a 'revert' to v7 variant seems appropriate, but with the following c=
hanges:
> > - Add `status =3D "disabled";` property to the definition in rk356x.dts=
i
> > - Add a new commit where you enable it only for rk3568 and document in =
the
> > commit message why it's not enabled on rk3566 with a possible link to t=
he v7
> > thread for clarification on why that is
>
> I was going to protest about the "disable" until reading the 2nd part :-D=
 .
>
> And yeah that makes a lot of sense, "add" it to rk356x.dtsi, as the IP is
> part of both variants, but only enable it in rk3568.dtsi because of the
> seemingly faulty implementation on the rk3566.

Better yet, mark it as "broken" in rk3566.dtsi to reflect the tests that
we've all done.

ChenYu

> > You could probably also integrate that into 1 commit, but make sure tha=
t the
> > commit summary and description match the implementation.
> > IMO that wasn't 'technically' the case in v8 as the rng node was added =
to
> > rk356x, but it was only enabled on rk3568.
> >
> > My 0.02
>
>
>
>
