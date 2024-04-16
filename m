Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E065685644;
	Tue, 16 Apr 2024 16:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713284250; cv=none; b=mEUhtXcWtjgZG6LLApqI8IX4SpOBdFOeMBcrBTR0WMFy1x15/Lnd9wnOqXifnvfY4wdlB07s0l8RmXg8ySZWf31Rxs/FaYxX5dpQf0W/d1znI2DLYFyNTcW1u7EbLBU2neARTDk51RP5x/Jo1F4wnHa7SKE2t9Wb4aWz0emHd6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713284250; c=relaxed/simple;
	bh=SXN/+ob5TKwQ1EXj22uBY1f/7PbRX/7pv6BcZyIE35E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QmopBdFE+XxPK/V8t2B+UIqsDdAxpdT+JfDVdqzSZ6LZzrk34btaZd2nuw1AJS+0O13G4k7UfUqRa7NISVERwxpoopt8GghBiuiGi/nyvf22gdbMOqe8ezWyVL2vgAiSsSRunBX1+9QjKwxcbEVRozrF8VgZ+brvCMc+/V6hC7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FkKCiTik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FkKCiTik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3DDC32783;
	Tue, 16 Apr 2024 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713284249;
	bh=SXN/+ob5TKwQ1EXj22uBY1f/7PbRX/7pv6BcZyIE35E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FkKCiTik+Pg+aJBR2LPfzeSFRoDqjxaXhkdAwSuOwU89dxgcQCPUqn9YSWx0BlDJU
	 pdVqBjVDn9DGMMCnXrf0iICDObzfAJ+UiN1hXaBhloiu2BV4XL/Tf74x3pFzIP5HUq
	 Fb1gjFbhpyU+EOPW0FO0p42DAT0uEOxkK7sed103Ht1i30e3bxPFYfpt6KsiX7EcBQ
	 cDwL/EKSADEUH2M8RiEqMYHsfTic65c9nzfbllo2QHY7prh3kvnLHTsMce3ymdjQGe
	 E251q5KWTz53PrOmhn02XiN5BwBKWTv19+lwil+hyft3oR6yPRNWof8ayJuvepN+qx
	 0C8bw2N2mUlAA==
Date: Tue, 16 Apr 2024 17:17:25 +0100
From: Conor Dooley <conor@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: starfive: Restore sort order
Message-ID: <20240416-payable-undocked-11cad39af1c5@spud>
References: <1b1bb24987409fcd7ea80940e92be2e9aa67ea49.1713282603.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hu7bXkhGRqUIgKrD"
Content-Disposition: inline
In-Reply-To: <1b1bb24987409fcd7ea80940e92be2e9aa67ea49.1713282603.git.geert+renesas@glider.be>


--hu7bXkhGRqUIgKrD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024 at 05:51:49PM +0200, Geert Uytterhoeven wrote:
> Restore alphabetical sort order of the list of supported compatible
> values.
>=20
> Fixes: 2ccf7a5d9c50f3ea ("dt-bindings: crypto: starfive: Add jh8100 suppo=
rt")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--hu7bXkhGRqUIgKrD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZh6klQAKCRB4tDGHoIJi
0ogsAP9TjJyVdzjKOEZTC4IeATsnYNeW0Ed+MWCIOvJ++Ib4wQD/aZP6yaI5reeJ
IljR+/t7Jw+rt+ysrkfqCDnPrntPswA=
=CTKP
-----END PGP SIGNATURE-----

--hu7bXkhGRqUIgKrD--
