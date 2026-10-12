Received: from mail.zeus03.de (zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4305B3A1691
	for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 10:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.117.254.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801830; cv=none; b=kRa5Ca39g6MYnjcUZ9UdhivB/ouGOoNiOE80oWJwgpjN7AfCDksFdEuYc8EdteDShA7KNMvR8+SNUiCIyGAHKEPGWA9KVoYGR7lOW/BJgxvQfeHojWzVhVJdHdYtoIIyoDpBVRdz0bQsy2fsRH9RW2nXfOwkP11m7FRfWv3XC28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801830; c=relaxed/simple;
	bh=Zz2W0z0cWvL9+n753j1WAam4CZ5s6Xk6anZyjUmFcYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nWjVxPny7KZAdLlCgUlJVCFip5klxENFafW16lbWkgH12lz2La5+90UztjEeb7Esu/MhNCh9renfATEB9MRTKm9n6NzyTQ5LM9idenlDbjT8BkKYMHRCCevam7yJTmI6KPogFOOMMgsN1lGUMOAwAcp3hz3S8Iyje/spU4eG4gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com; spf=pass smtp.mailfrom=sang-engineering.com; dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b=Pfkrqqxj; arc=none smtp.client-ip=194.117.254.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="Pfkrqqxj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=date:from:to:cc:subject:message-id
	:references:mime-version:content-type:in-reply-to; s=k1; bh=Zz2W
	0z0cWvL9+n753j1WAam4CZ5s6Xk6anZyjUmFcYM=; b=PfkrqqxjfA00PkgN4eGe
	w9fYKHRwUyvNDBHQIdWkxcM4HNQ18C9RKNIwxq+Cah2yw/HWkmhMylE/eFZ2JcSo
	JD6mljTPVKaq1dhJlUq8TBFaQ9cdkbwtO4SliW0JS3O1H8/hgUsVAGYA5RYemkzZ
	EEBAlfm75RDHqWhuHBK1RcC+7uUghQr1JvK4HJGfLZOwqF6AKEO60AKuiTST35zw
	rTmoD9baJ+tTzCiqt5KuFCZO+npDkppd4FMEJD0PEfF2fQJ8d1LHhA9S2Q9wh7xR
	JR0Rb4k62oVIHqK5JXBWI5sIpf96c7N/ZYb8t7FXJ5YEYfbL5GAvtTx9rL2R+nUP
	dg==
Received: (qmail 2216586 invoked from network); 12 Oct 2026 12:43:44 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 12 Oct 2026 12:43:44 +0200
X-UD-Smtp-Session: l3s3148p1@uDVEX6JdHJQujnuu
Date: Mon, 12 Oct 2026 12:43:44 +0200
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: dmaengine@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - unmap descriptor before completing cookie
Message-ID: <asy53A_Noe3EE-KZ@shikoro>
References: <20261010125001.19300-3-wsa+renesas@sang-engineering.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WDG1I0qEgaCJ3/l0"
Content-Disposition: inline
In-Reply-To: <20261010125001.19300-3-wsa+renesas@sang-engineering.com>

--WDG1I0qEgaCJ3/l0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 10, 2026 at 02:50:03PM +0200, Wolfram Sang wrote:
> To ensure that buffers are flushed, make sure that the descriptor gets
> unmapped before completing the cookie.
>=20
> Link: https://lore.kernel.org/r/20261009093745.539924-1-vkoul@kernel.org
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

I'd like to drop this patch because Sashiko reported an issue with it
which I am not able to analyze.


--WDG1I0qEgaCJ3/l0
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmrMudwACgkQFA3kzBSg
KbZctg//QUjmtYf+fv/Tb+l0cx19fZ7DQ6TyitPOt+zSM6bAGICljOGxPoBUlBex
OnPPAc8g9lMK0JImxjzMBRydjne/HLE+AwwZq9FtALF9gnXahpvGXWZD9hnBAlvD
UwkwEPDOMZqLYD0zhZEusg9sxNoa9/nNCojhfq0gNrBTPRfaXXeC61gGY/MSrJXA
3TQuqEIUduyvfBPPUy1UhwFLLZADvZLPg5L94hD2z5EPWHf5LNY88aTiXYDy/CWz
xj7KqV3Xn4SzbDORjc0nsbtIJ7tx1O9u4e0B3g/wUQFyv4Pyt7jOaKWou2oHxbxv
rBlfuDjXtWSwD7Qy2/jodgSSEmORcM8VoNxFwcYXkxgbSAQR1luEmmOyyd3esUp/
h2URmUmqW5/kZ/7f5Sg1l345D5NIG/WsIWS6kRjTNkLH/hxTE5s/jX4wAPS5A6Us
qmizsVEDPfz7L2Gmo5ew9TsUGXIoe89bfcASaGBZtGv4WPi10vfwbao1/a859k6c
ZarkLWqToSQVcpxfmyV4U6wsF7oEEE98sZBJeMHXTzbBovtTgeB4NyqYom+mQhLa
xy0mEXN6DjeZd9iQSLIQLuHjSVktazTEY5xc30+lwNYMQvGBrJiKao6dslW2gz6+
sR6esEAkcaG/BeKsd0IvcQhVZ9pGMfwnjp7GSTj31PtO8aMKXD0=
=HbNB
-----END PGP SIGNATURE-----

--WDG1I0qEgaCJ3/l0--
