Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B8D20ADCB;
	Wed,  4 Dec 2024 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733329566; cv=none; b=mo2HJcd9IMZPA6gZuqihvDwYV4f4nCChxlgwgBBb2iDtZVm+AI/U27uT70sjacGdt6Iv6FjdabpulffoHKiaiLjboC11GfA9pYwpFdvjn3UIWFisBULcSqvM6elCYivnBDp+qjsbQVdSxHwlkY6LSVd6PvGl6lSEr7KYPjYmjWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733329566; c=relaxed/simple;
	bh=s59cjSI41ouAVWN5gqdjx84pbl6lMV5yXuNB7fDXpqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unW2JJ4NFREK1zDV+laPRY+IKdTSZBl9psL1WBLz+1LypdZUvx8vSM4tWRFkf1oasBcP+5FA/3HXLG2NbAj/pN74judqRkzULQmCRGdAD6sc992UlwlLRnSE6DPRaqnoRM2LTpWcJWQAPteoemTZ/pgn5btISczMrP6yYmTmsG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WYbbiUlA; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WYbbiUlA"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-385e2880606so4875768f8f.3;
        Wed, 04 Dec 2024 08:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733329563; x=1733934363; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KDfuCQe9icjSg3X2+FF0W1suXmAl6dQpcF+jtr4B0rc=;
        b=WYbbiUlA60s2C+mKVRzKEXRCLEybDyRLP20rVT+RKTl4xHBS8sjY2BdRRMjjut+JRl
         YaARLcTg1Vkkt25yXf8oHkBCXEgLl+nn+vKNy5KVUdw6Ra6ytL+nPxifzPWzZTVE8svI
         C3GFo63wuMc36VKNguF6SNYoG0DoOmbsxJyMEpR2EVeI7ZU322vG4+zrm6V3wcJuzFtB
         vcKmHpFAyaNYgTXLBwusNQALLt2Y24Nq1annUAwIAqN7HtsvlAnzKRYjL0VL0pGhle42
         ZltZ9rtbbDQlt2tTVnOImj+Jz48+Chz4103VyUKE9aqI6GDiMwMEaJmMoxUDndzy9oCW
         IsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733329563; x=1733934363;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDfuCQe9icjSg3X2+FF0W1suXmAl6dQpcF+jtr4B0rc=;
        b=f9DYRkTtrbEgbjboTTpEGKlAkcZ0N6SpHqQYel7pMmZp2lbAF5PHAtDNyrzidAHSWQ
         kE9zxJSKF36LCH+vGzLrUzPWiHua5z/WXbeHJzyLb/c3ORIBwtnDTaZsgP3UqJgAgLWA
         hinJXlOe6YlFiqbrsetk6p4Q0rjclwDrrtei+fShD37298mc+qnI+qyi+L+CumTvbrYN
         lZBDJ+Qam2FFT8fUfhwo0t90bMdpChwzqfxo0rysdWg2ouvHwfah7DrpYtYEEVHiKMX8
         taCVNa2A5F8MFqXZnODmd3GFV2kVrnMdzTjJXvwcgI3imze5pjhWxyeCC8JzLSPW4RMz
         h40w==
X-Forwarded-Encrypted: i=1; AJvYcCVLU2nNEp4lLVRwC5b9BpdAwp3GbTGrxBWT1mBIakD64zWtvKWLTnB6pDUhlub2h6hdU3EBVdp9bG7bMys=@vger.kernel.org, AJvYcCW6jG1w9dhlCYB6qh07v3KXV1Gdw4E6xkR7G22OSnMaXOHvAfxRZbz7pvUVIQo0nt1n1mOXLY6QzKKC/do=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh3N0RwWsMVKPSxVPIeGIjV5yb4WkQ7YRua16oC3EmkXxnzEtj
	B7KmdsS7igQXtV0iqKiGfDta4Xiu+tW2fWcoNmkJ6T7P9aa3bwn9Wzc6Bg==
X-Gm-Gg: ASbGncuGtLoGAFr3uj7Yy7wW7zli5U0ZpmG8EJE9tBa7fPS2idiCi0Dszzx/A/8cIba
	N9b+AMChg1xz/ifVIki1mh94+NcIN8chxC8EqrO44aBmQuKGUG+qB5lg1hcyHqnpCvzahi+hvkh
	ElDrZ3ZQbrHTsx7qkQLSCQ55QfNg1uoYKOzD4oWld7nWuQCbLqOSzgyUffm+9RFP03zwkYV3kuB
	+u/YFWEb6VTON6iB30pzl26lbcTRQz0KkeTdABvpSRtKsCdaRN6rRifzUhgrUdevWe6xAVNQJZp
	C8gZovBxyDPamWTdBpfpn83fzVBk6jDwYVT7
X-Google-Smtp-Source: AGHT+IEn5vWUfD1edchw71iKaQWPJ5zrPY/RlGyVC53tCnJMzCLUo9wCZmfXhp3ZVBQC2zZ3MzIvEg==
X-Received: by 2002:a05:6000:1a86:b0:385:ef8e:a652 with SMTP id ffacd0b85a97d-385fd43c331mr7817874f8f.56.1733329563235;
        Wed, 04 Dec 2024 08:26:03 -0800 (PST)
Received: from orome (p200300e41f281900f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f28:1900:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385ccd3a5f7sm18703181f8f.54.2024.12.04.08.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 08:26:02 -0800 (PST)
Date: Wed, 4 Dec 2024 17:26:01 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akhilrajeev@nvidia.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, jonathanh@nvidia.com, linux-crypto@vger.kernel.org, 
	linux-tegra@vger.kernel.org, chenridong@huawei.com, wangweiyang2@huawei.com
Subject: Re: [PATCH v2] crypto: tegra - do not transfer req when tegra init
 fails
Message-ID: <lpmdwlmokmxhtd2nuwbhtqkowgih7ytwgkbehd4ht43hwet52a@uwdufvfwotfe>
References: <20241111012827.1788341-1-chenridong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dkyalcrzdvdlsjuv"
Content-Disposition: inline
In-Reply-To: <20241111012827.1788341-1-chenridong@huaweicloud.com>


--dkyalcrzdvdlsjuv
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] crypto: tegra - do not transfer req when tegra init
 fails
MIME-Version: 1.0

On Mon, Nov 11, 2024 at 01:28:27AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
>=20
> The tegra_cmac_init or tegra_sha_init function may return an error when
> memory is exhausted. It should not transfer the request when they return
> an error.
>=20
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> Acked-by: Akhil R <akhilrajeev@nvidia.com>
> ---
>  drivers/crypto/tegra/tegra-se-aes.c  | 7 +++++--
>  drivers/crypto/tegra/tegra-se-hash.c | 7 +++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)

Acked-by: Thierry Reding <treding@nvidia.com>

--dkyalcrzdvdlsjuv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmdQgpgACgkQ3SOs138+
s6F+VA//XsmF/86dhPIvYT8EDkVqmnc65aEE8+toNiwurcNTS9f+FwkEijK7aifU
DnPlknSEymzj2hAzKlY6n5ORz+Fp9XXKraLsxUYyHNNeE4hq2bIRU5AmW+SbJaNy
KjYfw48SqQ3zViExjWRHrVBA+xN4XojBMtDT2XOQ2s5d6ujVSAgCkbdf9IX1YNbL
7gF5H10nXYhQZsEmU75spNN4ra2K8kk49+kOpSZkJiOkOmYcdS+4lYg0SorvKqOF
JQ74XKfDNtauIaKC1FPJ6y55ee+rR5W/Fae5BzgHJeAn3xiq63bZy2zpPskEN7iv
mA3eNkG9Qf1EzvjtzFA7hSCuYa1yf+f6OelspzjhHD5+0jbEs2zUJNRi3b8/7G3g
KSjeNsECzN59UmW3XN1tkpMud39lSaut/2hhF7JCQ82TO+9iucXNBJRyE1MXYbLN
+eVhm4zQYDnBSGKFIF+wkjcmxT7dhLp9g5x71f9Ey9m/4f1xQYqSmLtBChw44Uzx
+gxrDql697GOcoprI1yIJyWgj6LnK9c8jXAmIBjzrm4fP9UN4QJi71hmc6SDlCO8
pwM8e6jJ2fevn+ZBYeLZMu73QkiwIxdmPd0KE6A95ukLPdrnxsJM0BJLaHtcdggb
5fMQublciBZ79W1649/Y/yuIpIeSnJNuI9gksnAANc5rOR83jLo=
=eI0r
-----END PGP SIGNATURE-----

--dkyalcrzdvdlsjuv--
