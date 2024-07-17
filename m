Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B97339FDD
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jul 2024 08:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721206182; cv=none; b=gIUz4ngd2V5RETQThinX3GxeuL83D+3KJ2nvexlaLcFEBOxZ2EZgydegWmjZJu8fbIOCZhL+VRr3pQWvWhjEgdzvVY49miEjDcJgFiWkRl5lvo8NljOirQC233kVk3yxI5ZxD7twQcLNcm9JK3Wl9z1DI9SO59dZDSEj3wZLHQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721206182; c=relaxed/simple;
	bh=081daULEFELhHqzxk94Sgr65j7gPG2HGVObYF57Atf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ofy7RGR0mL10QhdpWOXAs1TnAQj4ZOHkoOq2ezXec9GheyTNOl8rxkBXjhoDgAWXmXbMWvHiEHzQrPT+hy71DUnytAGd/BedydD0ufRW8O99KyyFZ3sGay8rmuORZ+jsBnePVMiyacXi8OUyQZ7EOw0y4CkFiY3iGzdfs08K3LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=s/a+qNtL; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="s/a+qNtL"
X-Envelope-To: wens@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1721206178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qMec0RSVrrCOY60WZ07lvNhotWl9ZVFZxdQtiWaXMoU=;
	b=s/a+qNtLaNbBJ6b0ufW2plGzprOpDNLRrc/VZDygSZfeQWrAI70bTWz4ocWns4a7HatSI+
	X9BObrqXxaLaLVjf6gIXguiHZJMlImsi1/Ckb1csxxZU07Oz/TZuANfZAM8yzMSoRvaLta
	16XUbBo0MQRJ9cVHZai7Haf8Q2PSTUEUmEhchMN6nlqcooZIixzzSHZnAC0Xn4aDUWE/tV
	LwG9mPROSfhi0dy4eOrjxKPahVY/jPOMyEMUSih2rjKTwc2cTOfUP6UMWYdkv8ZZD2ADJz
	Fba4ilfn2YC/Vc+BMp7FRNf6QgqVzb2SOHxogUNSaZOhYRECOf14kTbgtEMMIg==
X-Envelope-To: daniel@makrotopia.org
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
X-Envelope-To: linux.amoon@gmail.com
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Diederik de Haas <didi.debian@cknow.org>
To: wens@kernel.org
Cc: Daniel Golle <daniel@makrotopia.org>, linux-rockchip@lists.infradead.org,
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
 Anand Moon <linux.amoon@gmail.com>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
Date: Wed, 17 Jul 2024 10:49:27 +0200
Message-ID: <1980864.2la4r23YhA@bagend>
Organization: Connecting Knowledge
In-Reply-To:
 <CAGb2v65BaN3rDGA+9D4mAoz4+7C4CfSqhEhd81ev-BViy0tEbw@mail.gmail.com>
References:
 <cover.1720969799.git.daniel@makrotopia.org> <2451882.5D0I8gZW9r@bagend>
 <CAGb2v65BaN3rDGA+9D4mAoz4+7C4CfSqhEhd81ev-BViy0tEbw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7866392.9XRq9apFvr";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Migadu-Flow: FLOW_OUT

--nextPart7866392.9XRq9apFvr
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
To: wens@kernel.org
Date: Wed, 17 Jul 2024 10:49:27 +0200
Message-ID: <1980864.2la4r23YhA@bagend>
Organization: Connecting Knowledge
MIME-Version: 1.0

On Wednesday, 17 July 2024 10:38:40 CEST Chen-Yu Tsai wrote:
> > On my Rock64('s) (RK3328) it doesn't work at all:
> > 
> > ```
> > root@cs21:~# cat /dev/hwrng | rngtest -c 1000
> > rngtest 5
> > ...
> > rngtest: starting FIPS tests...
> > cat: /dev/hwrng: No such device
> > rngtest: entropy source drained
> > ```
> 
> RK3399 and RK3328 are covered by a different driver:
> 
> https://lore.kernel.org/all/20230707115242.3411259-1-clabbe@baylibre.com/
> 
> And that patch says the TRNG on the RK3328 is utterly broken.

Yeah, someone made me aware of that post and then ofc I had to see it for 
myself ;-)

Cheers,
  Diederik
--nextPart7866392.9XRq9apFvr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZpeFlwAKCRDXblvOeH7b
bshTAQDJFuCJl89JpyQiEgOZcFpEdKK4wKZJfTiMN7nEsW1nYQD+Jeal7PPYI8Ef
wQuybNEyOBF1DlqrvTIOJCnuQl990wM=
=2lk0
-----END PGP SIGNATURE-----

--nextPart7866392.9XRq9apFvr--



