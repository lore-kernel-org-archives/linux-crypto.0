Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FF318FDB5
	for <linux-crypto@vger.kernel.org>; Tue, 30 Jul 2024 09:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722330209; cv=none; b=ufajzgxB1jW3FYyirAkyTL0vF5vskwDq3SalQnHWnXwDcOuGJnDvJkQYrizBbc+tUoPCED3basLY5h9fAFJQgc2zJgrQGXdoT2lP+KxE3SDm8D1VK5aULrtwu1opLkpSzEc0atTUxjbv/GvE4+z5uhqiaxSJfyPmSPT0m2YsUME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722330209; c=relaxed/simple;
	bh=zc7ynQ7hZEdCKr5OMyZXMTbXDiP/ds7IClc69cxmDUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8AqNawoDlCHG09VBcSALbp+Yyio96p/n459fsfDc9Tuf5l/w7MINBRVhY5Ox+H5Y7Nads8HDvS9Z988VHoRbVPWE44ypHRErRJO2umnDRY+568pFc7ubYz3nnMx5tnBjogS1bj3iWku4RoMf8Lhr8QZ1/h/Tz/z2ILU6KRadII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=bCfFGBIT; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="bCfFGBIT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1722330203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B1rX42vyLb2o7bCFZWbpolb7axljRnf+cPcxVtkPaGQ=;
	b=bCfFGBIT1faiidn30la/pcdfIJvxka3DNVc0xjGFfX6kvV2FhIXUlEqbjhoKhyZVD6OrZu
	rUWUQCJCb90tmf8Ez/2TwpgNJatjH6TVQ2qCBKL6H1pwV2sVJIuEwRP9qxWWFT+CrqbuFX
	IKAjb5OD/VQm9YCL6AEP+0qmdTMRRpA36I4UqbQ6LxOkXwRaXEhfPwhsGbjsGOrxweKuOX
	EvdKyeXhkFALDJjEWLNZJ0Hr7gSWA75mH6TWg25dyyU3j00GjKVCoTSNaVBvQhMEElubb6
	7Qd/GNZXXTZRjpCPAImtTpu5VYy3orfCohbBN26pAlMSOWBH5vwLH7nb9B/3Qw==
From: Diederik de Haas <didi.debian@cknow.org>
To: Dragan Simic <dsimic@manjaro.org>, Daniel Golle <daniel@makrotopia.org>
Cc: Chen-Yu Tsai <wens@kernel.org>, linux-rockchip@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, Martin Kaiser <martin@kaiser.cx>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <ukleinek@debian.org>,
 devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
 Philipp Zabel <p.zabel@pengutronix.de>, Olivia Mackall <olivia@selenic.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Aurelien Jarno <aurelien@aurel32.net>, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
Date: Tue, 30 Jul 2024 11:03:06 +0200
Message-ID: <6690040.iosknibmi9@bagend>
Organization: Connecting Knowledge
In-Reply-To: <ZqgjTQMgWZO2FjaC@makrotopia.org>
References:
 <cover.1720969799.git.daniel@makrotopia.org>
 <faa0baebabd3c31adf1afa7efbbdf608@manjaro.org>
 <ZqgjTQMgWZO2FjaC@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart20867227.UFCzubSe9b";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Migadu-Flow: FLOW_OUT

--nextPart20867227.UFCzubSe9b
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
Date: Tue, 30 Jul 2024 11:03:06 +0200
Message-ID: <6690040.iosknibmi9@bagend>
Organization: Connecting Knowledge
In-Reply-To: <ZqgjTQMgWZO2FjaC@makrotopia.org>
MIME-Version: 1.0

On Tuesday, 30 July 2024 01:18:37 CEST Daniel Golle wrote:
> On Wed, Jul 24, 2024 at 08:07:51AM +0200, Dragan Simic wrote:
> > Thanks a lot for the testing.  Though, such wildly different test results
> > can, regrettably, lead to only one conclusion:  the HWRNG found in RK3566
> > is unusable. :/

FTR: I agree with Dragan, unfortunately.

> The results on RK3568 look much better and the series right now also
> only enabled the RNG on RK3568 systems. However, we have only seen few
> boards with RK3568 up to now, and I only got a couple of NanoPi R5C
> here to test, all with good hwrng results.
> 
> Do you think it would be agreeable to only enable the HWRNG for RK3568
> as suggested in this series? Or are we expecting quality to also vary
> as much as it (sadly) does for RK3566?

Unless we get *evidence* to the contrary, we should assume that the HWRNG on 
RK3568 is fine as the currently available test results are fine.
So I think enabling it only for RK3568 is the right thing to do.

So a 'revert' to v7 variant seems appropriate, but with the following changes:
- Add `status = "disabled";` property to the definition in rk356x.dtsi
- Add a new commit where you enable it only for rk3568 and document in the 
commit message why it's not enabled on rk3566 with a possible link to the v7 
thread for clarification on why that is

You could probably also integrate that into 1 commit, but make sure that the 
commit summary and description match the implementation.
IMO that wasn't 'technically' the case in v8 as the rng node was added to 
rk356x, but it was only enabled on rk3568.

My 0.02
--nextPart20867227.UFCzubSe9b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZqisSgAKCRDXblvOeH7b
brDnAQD8u6tajseWbanb373R9KrnELq+Iwcw8RlufXKnVpFIQwD/YZ/Dq5lXye++
z2hXSo/Jh+izrQpNgfewXWOAVGeswAI=
=mbtE
-----END PGP SIGNATURE-----

--nextPart20867227.UFCzubSe9b--



