Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2B33E8320;
	Thu, 28 May 2026 12:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779970564; cv=none; b=c8JVnmPUfsvgzvH/EATfMuzCP7ggdYqKxHwoi3s1lx9JQRYPk6u2IhkUWBmG87KnggAwhhD49d8vBfF6/RNYiCeksVpmwh3/bmG0/JYm9c7Pji6rvZZhVCVEuKdiLWtjSOzOdGvtsWQUA8h18ZQ4K+85OaKUikWK9+UG82Pd4zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779970564; c=relaxed/simple;
	bh=Ir+St5jjuyDHu0k2ayfYcSBkd8eojxxhArhUYtGtJQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZgPGexKByTF/2eoaHFY9Y0aJ5M4+DzjHz4JkovSHgbxJNjkbvdf9zQC4CC2VYVcJod1fv+YGbkUlvSDUKvcuMRRhUgxQd4ZD3oKExO1JmZnEiaGPYVa9O4S2N+/LZUG82JbPfKgMyfeHv67/TQ694kz1tHWHPlROLZWsP/a3NoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V2CGDCj0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V2CGDCj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58101F00A3A;
	Thu, 28 May 2026 12:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779970562;
	bh=+buq2ptcz3JEj/EpBlSaTdBpCSUNhIEKXgsoTZroRW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V2CGDCj0qdObonA6xsEmiUruzdyDhaDVcOjnUYm5RBz6bWG2BFVJy+o7es7XrKb17
	 loHnHSxcdsS1+5bdiIepwg9k4Ca1cnPNI1PaXfX/ioYPQsRAFTHkvv6xTSTV/qGEu7
	 XaXN+Ued0ofGEUw/Oih5zwV3xVSl8QzgiDus81nLKMosrdfQUYw5Vtf1dhrHQ9Hb+b
	 ALjTzN+b72hj+v2GRBi4hjWrlAz4hmDBEJB5B66MfJ06ML/FL/Icz31uct8YbfaiE3
	 IZlpfWZ6sWOcikRO5P9eRSqFv/iGUa/qAHupsdk9ewECpxaRrOEoOp337GpH4ZdRan
	 ljNXA04XVAWSw==
Date: Thu, 28 May 2026 14:16:00 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Akhil R <akhilrajeev@nvidia.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Aaron Kling <webgeek1234@gmail.com>, dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] gpu: host1x: Allow entries in BO caches to be freed
Message-ID: <ahgx9L954jPBWkdO@orome>
References: <20260515-host1x-bocache-leak-v1-0-a0375f68aeab@nvidia.com>
 <20260515-host1x-bocache-leak-v1-1-a0375f68aeab@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6my564ulmhwxpudn"
Content-Disposition: inline
In-Reply-To: <20260515-host1x-bocache-leak-v1-1-a0375f68aeab@nvidia.com>


--6my564ulmhwxpudn
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/2] gpu: host1x: Allow entries in BO caches to be freed
MIME-Version: 1.0

On Fri, May 15, 2026 at 11:34:51AM +0900, Mikko Perttunen wrote:
> When a buffer object is pinned via host1x_bo_pin() with a cache, the
> resulting mapping is kept in the cache so it can be reused on subsequent
> pins. Each mapping held a reference to the underlying host1x_bo (taken
> in tegra_bo_pin / gather_bo_pin), so as long as a mapping was cached,
> the bo itself could not be freed.
>=20
> However, the only way to remove the cached mapping was through the free
> path of the buffer object. This meant that if a bo got cached, it could
> never get freed again.
>=20
> Resolve the circularity by holding a weak reference to the bo from the
> cache side. This is done by having the .pin callbacks not bump the bo's
> refcount -- instead the common Host1x bo code does so, except for the
> cache reference.
>=20
> Also move the remove-cache-mapping-on-free code into a common function
> inside Host1x code. This is only called from the TegraDRM GEM buffers
> since those are the only ones that can be cached at the moment.
>=20
> Reported-by: Aaron Kling <webgeek1234@gmail.com>
> Fixes: 1f39b1dfa53c ("drm/tegra: Implement buffer object cache")
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
>  drivers/gpu/drm/tegra/gem.c    | 13 ++-------
>  drivers/gpu/drm/tegra/submit.c |  3 +--
>  drivers/gpu/host1x/bus.c       | 60 ++++++++++++++++++++++++++++++++++++=
+++++-
>  include/linux/host1x.h         |  7 +++++
>  4 files changed, 69 insertions(+), 14 deletions(-)

Applied, thanks.

Thierry

--6my564ulmhwxpudn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmoYMgAACgkQ3SOs138+
s6H4tQ//XkWRl3y7bAt9TLAdXWliceZEHfMdVL/tnvQt61OaxMiMXb3KF0U1CFSz
bCrOSsS4t3L1/2zRbicJ7rW92tT3J3bNmHGroLo64ODozmDX9A8IKrLLPJ+1a3a5
SXzNHyeK+3Gz7cUl0EwUyoCY0r/wBTl/povwzAE7Wk0cKL7vBMW8rjFTQkb/KYr3
Tj4+q0VAELLmHLUGBo+zQlJHJIWN6SSCvzvaL7zE2vlgFvX0tZW1EMZrZ3AdNEln
UmXCYkIYHOthnhqMFD1xUmp5YNcpaO0dQMY0kt3YC9AK5ZuDJXfs/Cv8ztittEOf
KMITTDm+JyJ11MY5ycp9ipDpaSUk3Cbsw9vfwd0TNltsJvwyQnYNTlSpXMdseJPP
hqRzk1j828d11x1FN+Qq3xtxQZUCSxX/V5DnioScXPMujFp48qh5W7evIwbJ2dss
tfjImpSwWRZ7FmH4Rl7FnioU2oLUKTFP903bp0sEHWMQXW+HemlCPMKBxa6sgVRo
9OTu2v29Vypb8Rp4VoehjumCjQxW64RZ9NfxH7MYyidh/Hxhz+2FEs/PzxreGp5e
aLoWkLxgD2GJ1ueuh0sIf+4uS99Lf0Dho6Er2uko9+P0lgaxjIB4j2CQZ6Mjk5km
cpWpm9CGI4v4e38pGfrXG0UhiWF4OK6lCYeut3jTgDzGw65UMY4=
=fyjP
-----END PGP SIGNATURE-----

--6my564ulmhwxpudn--
