Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24259377EBA;
	Tue,  9 Jun 2026 16:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781021590; cv=none; b=jFIwsu17Ug8vLw1V+VIUoLOAGtsMMm6i+/lJPemUReDWzXHai3c6WX7I1sj9ibBsfSeMOKP59Sbl79rqFF8yIVXQkeDnTyQttc5Pu0bSjjgdgIcgyHj41IH+nPb5HIqcgC0UynmJgZRL1aJnHtehhjCW2/7/jcMmPejZn4N96Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781021590; c=relaxed/simple;
	bh=n8UWQHRfngrNcosp9Oy8IoumVeE29kBIVStca2EBYuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kpR5g+xadCc21Gd0n+lmxEI+6DeugOdCbv9/UPmfFQ0PUyLf+QKq16r4tp5v0hDkik/6LGpAn8FGqtFcc/QZsy/IsIqBHvDOeIRq2NfYqScIBThEyw/F1QhP9oW3TgS2p6wCxN7HKekAQcIPgOQRhTXFJfi2xrRln3etToJGVTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+PTFrEE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+PTFrEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C081F00893;
	Tue,  9 Jun 2026 16:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781021588;
	bh=n8UWQHRfngrNcosp9Oy8IoumVeE29kBIVStca2EBYuc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S+PTFrEEQ1Qr5Zmy5zxS99GhWZ4ByQEAXix22Kr+j3zKvXHCJmdfEwyXl1It9D4Rb
	 jwqwejWp+Kt8UuF9OeHUtf7JiQiT2eWtAnPW9dVJfoXP+uZwXn4HjRQfrcQWqm5wQL
	 GhkKeZcTAqdIpgiu6XLWQeaavaIRBvj1yk4paoRAFItc1fRuJhQa4TL9RZ4JSp/NAr
	 Muc9B5LFhNtdKl/XLkDbapJSA4tjzBbjMyJywSUR7wMTJu/NUTHsh2iZmGlxOz8HFn
	 MvsynBkCe+qXuBdLhFBPDItIaMSJZK8F1NzBhSRaf6fp9jfWwEXnvA5jZWT6rmYwjQ
	 qqIGPwNzGelBw==
Date: Tue, 9 Jun 2026 17:13:04 +0100
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
Subject: Re: [PATCH v4 1/2] dt-bindings: rng: starfive,jh7110-trng: add
 jhb100, drop jh8100
Message-ID: <20260609-prefix-eastward-f98bb6be1a69@spud>
References: <20260609095726.160559-1-lianfeng.ouyang@starfivetech.com>
 <20260609095726.160559-2-lianfeng.ouyang@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VRZzHBdtYtMenYE5"
Content-Disposition: inline
In-Reply-To: <20260609095726.160559-2-lianfeng.ouyang@starfivetech.com>


--VRZzHBdtYtMenYE5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Acked-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

--VRZzHBdtYtMenYE5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaig7kAAKCRB4tDGHoIJi
0hlMAQDYh1ptYp8Yx8p3qOU2dirZCNlVM91riYnsIVmJzMywjgEA+wl7n/zjaltD
z91QmKM+M2zJiUe1nKeXbmFbCpxRRwc=
=9lAQ
-----END PGP SIGNATURE-----

--VRZzHBdtYtMenYE5--
