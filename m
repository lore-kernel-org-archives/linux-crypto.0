Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0892749C1
	for <linux-crypto@vger.kernel.org>; Tue, 13 Jan 2026 12:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768307607; cv=none; b=gBuFXZ92jWqJLtM1h3Uv0qIwVn9Ml2ufy3jUf1+R7iSMg/GV/FR8Gt1PHJ8AQ5oPMPA1cNjrQGSVvt2UlnScVG0X5dqVOR3CiCD705mmqkUgvGo8SAEGFZ48MxR6xzHsyXgpXf7fz/q03ej6gMW7RVFtsNAKXPDZ14xg+a+3aJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768307607; c=relaxed/simple;
	bh=gF7/fWQyWmzkPClAmAUBXGyZOOP4YJ6wqtt/fKXe3BU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f5VAuAeV2WdxlMDBvOHJDLEOmM4SuOcdcq2ZL+XlgEKMYfZY0Xxge5nQ2Dzy0KsLi5STyapbVktGCBQ2cfmYb9x5UqzP4ouPODjYiL2dr1LvWjaPYK2ZdHLAuzGgfEIICZXEIeMakoHov5j6C9CAE/uv8xwKmiElhCTa2EFWrT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nW/woVd5; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nW/woVd5"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47d1d8a49f5so47862335e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 13 Jan 2026 04:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768307605; x=1768912405; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iu+hM+o5OVgosv83g1p0lFler2aXUxBOVyQODWO4k74=;
        b=nW/woVd5LvN2qWY5heeat0v6qpN9B7ABv9Mx33OkYs68QDqwkqrY995dROwBwuiDHo
         z5/GkKhVGVtWs3V94cCzdMpnZikEHhbPSnB4y+QEVUN1LGLxixtZN61qyApPK3r7NO2l
         PBxA8RXw4WDwItgp9jzVnRqRK99CEr6H63xp+iuRNK5eVsqGg251ycV3/asg2RrZsI6E
         HOTqEY/yJYpHufBiT8U5J3s/7rJiNYYit2VPkZV6Gjwq5XhmEJVrmeXg2Ja2x4uw5GYl
         4hAdTMYigz6NoMfKEe1xAGL+DIQ8e0irxBKPO8hfLyh23D/bFP8/ONR0pH5zZ1liGzAJ
         EZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768307605; x=1768912405;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iu+hM+o5OVgosv83g1p0lFler2aXUxBOVyQODWO4k74=;
        b=YXa3oAHy3+KcumG8dbeCPexHWeO8DOz0Od+R1HO60Ywz0ZuGXpkKMYyI+Vnex9ofAW
         sgY6Mks2qrvlmpCk8eGEM9Htfzx3QgAsYvAf0zyJEv8RKyiTEc0Air6Mbk+RYaD6EkOo
         GEq99QJCFBgVlOMI86ZrxyUWJ7KuKDd4Po8wrW5O4cjn9rRKHnFaaai8sgYydU67MEOr
         2RL2wpgtoQrakNOhviJhKN3I6nO9abt9/wkX0MM4wpkuVX0vfTPvKQP0YNBtcyYEe4IW
         acfwwsc3zgtYPQGsFtQC3iBoeskoDXhH2L0ru3o7cwVQzeol2760++F65Le25GgP4zR6
         pCTw==
X-Forwarded-Encrypted: i=1; AJvYcCXYaC+RJ5d8xQ192cpPY7VjEfl2wHq4fU6OtwYR9eisKRFD8yaEc5gPkXyW1J9AnI9C64onUIaY6Yh1NrU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhmvpWkwwrEf5X0mU47sv8ribJ87CxEK6OgXT4u28d9EWKGzyu
	i9N0bgB1oxr+KxBJMU+AKbMv1y9MqCxaP7zwS3Jh3rVNQneiFDKBdUD2
X-Gm-Gg: AY/fxX4kkm+mMKOgu16BoDAlfI6REndhjiezTWejPlWqOoGjCVQ8DnJt44UqNRDpq+s
	qSkIs8bf8Ew4eXPSfXBRkkX+pwX4Hqaa8rUm/r03vuB6/mNc8omG5Hizi2P+IjkbjPMPY2nv5zh
	zmn+XRTlGOY+bIkN73i7RgZedImH7HCLXO7C8POfDgUvB85U7Gfir7TbaZzIdD97j77zcw4pCzN
	nZIupYDWNughF2VQUWYmC1dAm/e5zoE3qt+jPiaqzNO1kqVAFNmQA5qljGF0AMJiVj23fAWhVzr
	+LVu7noiJ9niwDJltA2RuQ9XNk83iyZAZLM2RajPuZnARtKuQbA81pdZg2EnAGGvhrZwjuGopHn
	zK7wRuXoZJ8Ohwzqt5/cym/0BpV6O+4zVq4Eq/rya/F5txy5RSOiBZjri5e8xXRrgWTcjEr8N9x
	v73dH+iKKhvxoJJ7wP2FM7M6Yeitn5zRZ5fX1lWNEeuCGZBEATJqNXeaZcCoJXeVYukrgxihk/+
	SFE334Y4AtX
X-Google-Smtp-Source: AGHT+IG8MSHR6UelEVmGpCyFD9NdUlMZd6tKUDDeZ0GaaRamXIcxo7BgHJmGz6YZQf7c2j4pEDiVyw==
X-Received: by 2002:a05:600c:83c7:b0:479:3a86:dc1c with SMTP id 5b1f17b1804b1-47d84b52e31mr244947625e9.36.1768307604465;
        Tue, 13 Jan 2026 04:33:24 -0800 (PST)
Received: from orome (p200300e41f0ffa00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f0f:fa00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f390a69sm399651475e9.0.2026.01.13.04.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 04:33:22 -0800 (PST)
Date: Tue, 13 Jan 2026 13:33:20 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: Akhil R <akhilrajeev@nvidia.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Mikko Perttunen <mperttunen@nvidia.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sowjanya Komatineni <skomatineni@nvidia.com>, Luca Ceresoli <luca.ceresoli@bootlin.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, linux-staging@lists.linux.dev
Subject: Re: [PATCH 0/2] host1x: Convert to bus methods
Message-ID: <aWY7f5V_VE2RY74T@orome>
References: <cover.1765355236.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="u2bmktfhhry3gyx6"
Content-Disposition: inline
In-Reply-To: <cover.1765355236.git.u.kleine-koenig@baylibre.com>


--u2bmktfhhry3gyx6
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 0/2] host1x: Convert to bus methods
MIME-Version: 1.0

On Wed, Dec 10, 2025 at 09:31:36AM +0100, Uwe Kleine-K=C3=B6nig wrote:
> Hello,
>=20
> with the eventual goal to get rid of the callbacks .probe(), .remove()
> and .shutdown() in struct device_driver, migrate host1x to use bus
> callbacks instead.
>=20
> Best regards
> Uwe
>=20
> Uwe Kleine-K=C3=B6nig (2):
>   host1x: Make remove callback return void
>   host1x: Convert to bus methods
>=20
>  drivers/crypto/tegra/tegra-se-main.c      |  4 +-
>  drivers/gpu/drm/tegra/drm.c               |  4 +-
>  drivers/gpu/host1x/bus.c                  | 67 +++++++++++------------
>  drivers/staging/media/tegra-video/video.c |  4 +-
>  include/linux/host1x.h                    |  2 +-
>  5 files changed, 37 insertions(+), 44 deletions(-)

Applied, thanks.

Thierry

--u2bmktfhhry3gyx6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmlmO40ACgkQ3SOs138+
s6GKWBAAkeHMxtj03MuTuHomrmoj2kYvczHvqu0BchkARJlcBuq1QbDBow2Tyjil
qTY5YZp/VaU/tTbssrx5tdAsTOEK2yYugUOxfVz5IbyDzavUQAv8tq6kKLhY468g
v4+p3ypGVT+XiQaAoQOn7GVdKp9X5SLxkJclGirBiepzO2CrJR6ci+NjBqaBBa7n
mO8nh6jRN891vYt9IyZSd0VUf7W4K4mFS/RDKQaQYreFWSNiBAqdYMWCoUknnNY4
lSKKIwp8IUO7wSW6kO7sEFfrQDdQjzp7kBDmG18NkhOsaXs+WjXgEFP3aQqKgmu9
PYV79R8kRqMLuin51hrHrNvGuFbZqNOYFFJe86ipiO2wZTdXbaR4FjkBV5bGcj/a
nwGAeax2FkhF4wGu9Zlfo0Zc0IuAb+S03c+RojN5EguuwTQpj8Fpd4TM6wLC/hur
86LbYnh7oDIeq6rF31GpQv/uQKoXtbseL5CKi0uK9wc+MP0xP/LwONb8oNHbynRq
rPyCADy46HhE0MX7Ki6wONVMloMept5PQdKzt7uizTB7W9cTZDJzIbPCq/kUhw4q
AT9+bH0Pxgn7Q4MpCoQCwvz164tWFowRgcKmbuVO5Bp9WfkzhCNsp01s9+Y+PL+0
1zY/BIC2SpeWjz1ip4Cl19Vid5SJ+6Tv/3EXKQ/PauUfgWbF2sU=
=lJz6
-----END PGP SIGNATURE-----

--u2bmktfhhry3gyx6--
