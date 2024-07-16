Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B591F171
	for <linux-crypto@vger.kernel.org>; Tue, 16 Jul 2024 17:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721150390; cv=none; b=JhiyTNxRF5tXc4poUhTxPAktxPQEcX1KF71oKzBk3cyk1SQ7tZ40dmYFNaj4IcjraPisZIlkuJKtdWrRxjfkeuE98/qIlcL9U7zYYGsVjDUzac/wdYeKwsUGS0y/BfsmMqmFJWlOnPj7J8DYMRndmpmccpnkV5nRwIpxldrwl3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721150390; c=relaxed/simple;
	bh=LQtVgMXT1kLs9xuSAb2Dnp0S9QMFr2sEd0jibq58t+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hodr6A9M5+j0dqi7nq1wC0OHf4LrzAOqc+DULzuDJnOATX3r85T6Jo13b0bKvm9MzgZmya6amGRK+csQR62jH0h4ny6krdicXmzUKq+ogzCBq/3stEsouQ/BtuEGBkaGslZ6jJ2P1ATvdbsj5bqf2h66Txp5rlqDjibLEHdTSi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=qc8zIPW0; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="qc8zIPW0"
X-Envelope-To: wens@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1721150385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LQtVgMXT1kLs9xuSAb2Dnp0S9QMFr2sEd0jibq58t+M=;
	b=qc8zIPW0HWu090g9RF35uDSfiwvOgImM2IhEQPwe4ttIfKmuVhVARSUh+CW3NoFQWb2A+t
	N7ZhQYxRoUK3P54ZsqKHUcKBRvUDzJyA9kf7GNsk/vrif1Bt6SJ+jJSPXC89ufy8mcxvRv
	lAsOS4t3za0sjHnk2be5j1wXrPrpP4+UhjJjcQNN9hACBFfRzj2roqKHxC7S8m745JJSCl
	QTmDpIcOpWBvVC/ljM7CogwHo/wi5a9l1Up23ke9vE05Bo/BzSgyIs7CbORxL2ZxEIDgbC
	kyo2QL09uMIfaEz4x2Gp9LrtI2XzzX5pZcAQdCeIeOcKCcYlON0+qSZzCE/1HQ==
X-Envelope-To: daniel@makrotopia.org
X-Envelope-To: linux-rockchip@lists.infradead.org
X-Envelope-To: linux-rockchip@lists.infradead.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: robh@kernel.org
X-Envelope-To: conor+dt@kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: herbert@gondor.apana.org.au
X-Envelope-To: martin@kaiser.cx
X-Envelope-To: s.hauer@pengutronix.de
X-Envelope-To: sebastian.reichel@collabora.com
X-Envelope-To: ardb@kernel.org
X-Envelope-To: ukleinek@debian.org
X-Envelope-To: devicetree@vger.kernel.org
X-Envelope-To: linux-crypto@vger.kernel.org
X-Envelope-To: p.zabel@pengutronix.de
X-Envelope-To: olivia@selenic.com
X-Envelope-To: krzk+dt@kernel.org
X-Envelope-To: dsimic@manjaro.org
X-Envelope-To: aurelien@aurel32.net
X-Envelope-To: heiko@sntech.de
X-Envelope-To: didi.debian@cknow.org
X-Envelope-To: linux.amoon@gmail.com
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Diederik de Haas <didi.debian@cknow.org>
To: Chen-Yu Tsai <wens@kernel.org>, Daniel Golle <daniel@makrotopia.org>
Cc: linux-rockchip@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, Martin Kaiser <martin@kaiser.cx>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <ukleinek@debian.org>,
 devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
 Philipp Zabel <p.zabel@pengutronix.de>, Olivia Mackall <olivia@selenic.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Dragan Simic <dsimic@manjaro.org>,
 Aurelien Jarno <aurelien@aurel32.net>, Heiko Stuebner <heiko@sntech.de>,
 Diederik de Haas <didi.debian@cknow.org>, Anand Moon <linux.amoon@gmail.com>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
Date: Tue, 16 Jul 2024 19:19:35 +0200
Message-ID: <3220752.Q7WYUMVHaa@bagend>
Organization: Connecting Knowledge
In-Reply-To: <3190961.CRkYR5qTbq@bagend>
References:
 <cover.1720969799.git.daniel@makrotopia.org>
 <CAGb2v67zxs03xScN8OfWXR1gf8tddJciXrjw3FQZcL7pR3ocxA@mail.gmail.com>
 <3190961.CRkYR5qTbq@bagend>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4668013.QbK88pdo3q";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Migadu-Flow: FLOW_OUT

--nextPart4668013.QbK88pdo3q
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
Date: Tue, 16 Jul 2024 19:19:35 +0200
Message-ID: <3220752.Q7WYUMVHaa@bagend>
Organization: Connecting Knowledge
In-Reply-To: <3190961.CRkYR5qTbq@bagend>
MIME-Version: 1.0

On Tuesday, 16 July 2024 18:53:43 CEST Diederik de Haas wrote:
> rngtest: FIPS 140-2(2001-10-10) Long run: 0

I don't know if it means something, but I noticed that I have
``Long run: 0`` with all my poor results,
while Chen-Yu had ``Long run: 1``.

Different SoC (RK3399), but Anand had ``Long run: 0`` too on their
very poor result (100% failure):
https://lore.kernel.org/linux-rockchip/CANAwSgTTzZOwBaR9zjJ5VMpxm5BydtW6rB2S7jg+dnoX8hAoWg@mail.gmail.com/
--nextPart4668013.QbK88pdo3q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZparpwAKCRDXblvOeH7b
bghfAP0STaXg+UlSKsk1L6VzJ9BHzyphyFMlfj7FGoFob7nyLgEAh1Yebqje+avX
NIUvaQhX4nxlMMHIY/hZdtpdZIfbigs=
=VxyF
-----END PGP SIGNATURE-----

--nextPart4668013.QbK88pdo3q--



