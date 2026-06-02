Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121D7357D07;
	Tue,  2 Jun 2026 16:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780419557; cv=none; b=FW12jOBw+ntiE0LPsVmGM4sNRTVpn/6MW5OtxHvVlv1w8cSpv+KuWMX/LcsXQiSdPE8vuPEd2mmBMaP1jS/uVyNq0yBz18UqzE2tckZSrTRc5MNWnoVCeYnJB35MjxWcJemFMiGEMaF5s51uiNX6j8lBZ342sIzBpp0/Y94OGrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780419557; c=relaxed/simple;
	bh=P8hsqb49G0SN50czZNQWl8HIQ19BJZjUwz9RXuVw6ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=raw0nHQd6mvqwz5T2PpKvH6s1fEDK2W4Awtabn8BYbSl9NsEq15PAUBnYwXTqHzIwfSJOQkZWoAXJhr7twXtOnuwI6GJvPT/Sd/YiH/xQ5XWcWEPBqTFVvksuK3NV2o0ITYKufbEMjBspFWy8qMFF8nhBE2jqr5ZFNDQxSDMPhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h25FyAdp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h25FyAdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFA31F00893;
	Tue,  2 Jun 2026 16:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780419556;
	bh=ihjvTG8bUTk74TyBzjsPKCeSdhfuewiWVtTZyub5lgs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h25FyAdpjOyBvIhtUfhmSSFlSrFgDlY2smeHP10ztP3mMHzWcrGKEmTWvVYwI8ZMs
	 UpGh/GyGGAHzx1kDczQUKqBv+imRWL2zApjpjuwhQvudIEA8UwO68OWRwE1C1fK9mq
	 Uj3uI7opHVS+XlOE+IQoFDAPO8BtjmF8P49nYjXnKBffyc/GIL0ysw/H96gfrodtGt
	 KMqCOVHjvFrlrBSWaC5VkpnWIqMYoSvy9DbHI7CHNC1VkxsjUyvkNMWmwVyuDq/her
	 rtRzQO6gT1ZjNQ7p34mgVytoH77lgda3dGdSffBIsA5qTuaRjcyzpQn8tWy7lR/0Iz
	 GiBPEmzHl0Yyw==
Date: Tue, 2 Jun 2026 17:59:12 +0100
From: Conor Dooley <conor@kernel.org>
To: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: rng: starfive,jh7110-trng: add
 jhb100, drop jh8100
Message-ID: <20260602-staple-rehire-00045d4cb667@spud>
References: <20260601093744.84210-1-lianfeng.ouyang@starfivetech.com>
 <20260601093744.84210-2-lianfeng.ouyang@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TcxcuW3GM/PibzPD"
Content-Disposition: inline
In-Reply-To: <20260601093744.84210-2-lianfeng.ouyang@starfivetech.com>


--TcxcuW3GM/PibzPD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 01, 2026 at 05:37:43PM +0800, lianfeng.ouyang wrote:
> From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
>=20
> - Drop "starfive,jh8100-trng" since JH8100 SoC is no longer
>   supported
> - Add "starfive,jhb100-trng" for the JHB100 SoC TRNG.
> - Update maintainer to current owner
>=20
> Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

Although, commit messages really should not be bullet point lists,
please keep that in mind for the future.

--TcxcuW3GM/PibzPD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCah8L4AAKCRB4tDGHoIJi
0pvPAP48c69zeUJZcxblJ2W9Dl/b5QIv7K3GBR22LJXNAsuvnwD+J3e4mzRolRhB
8oCZVxOOzoXm17S6Rrlr+ocxLq++pA4=
=EXL0
-----END PGP SIGNATURE-----

--TcxcuW3GM/PibzPD--
