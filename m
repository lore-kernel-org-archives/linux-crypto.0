Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511AB23C4E3
	for <linux-crypto@vger.kernel.org>; Sat, 20 Sep 2025 07:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758352999; cv=none; b=k25Ajro/N+l62phVurFUdTnZERsFfWNN4Qd6m/NewjCOEzT8+mLfrD+RMR968hIknBw3AZa3/a9pR9jTw0AZlBx8511RONOJ4T/Dkm0an9DvRzy4kH8ZzysXQp5uvAvythCFHuimA7aIrAVpfn9lE35Tn5VaReJfc3weISZKpnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758352999; c=relaxed/simple;
	bh=nBDhyd2sKhjCLs0KLMOCgBwZYW709q4bxO6fngH7W3g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eg7I4odkrPW40GGVZQLo/V/itquLo0mHVvyk32EiSKlgwQLKMd32ZgBX+fm8k2V4aFnW1CIEt0us5YhSOu898U/xrM4eNnhhnXCDwRPoMr+nmNyp2pesJ4b6N5Woyw5bRmpxhiZd0hHXb9JJhyZTAVysHlGmYBnyhO4QzBZ7qcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vq2Mtp9O; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vq2Mtp9O"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3f0134ccc0cso1389208f8f.1
        for <linux-crypto@vger.kernel.org>; Sat, 20 Sep 2025 00:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758352995; x=1758957795; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ApjCVyxmlxpVT9WHGyaAdu9HZWD3mwm2FRllaMQUQmE=;
        b=Vq2Mtp9O4Y56h0N917wwGaGKWu8oqUdAfi4X5SzwijBc5VpglhSHcBw5VJepYqWQlr
         pIcB5JD7zpeoL4bM71RsQFJcS2m5huTzBGUftuoWv7cwTuXRA2cdA19ncCagfLpQaVAs
         b+cQKRL4bVUvB/CpeWf1wLFaQXbKZu9LBEWdBioJYlDCMF4NsYRxbys2PBQIShWkwRfe
         MvvfKylxWkeNaMqn4PXi7dm9N10vZxFFDAsFhlA4pKW1KWJbNAnQaKMOJ2Km3gTFI1WS
         /wRna6GmdnNg+JDKixTg1u9a7qWAbItYJ1Cz1bu+sKHQh3x9ev+DYehsLN0VKQm6ma75
         1Flg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758352995; x=1758957795;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ApjCVyxmlxpVT9WHGyaAdu9HZWD3mwm2FRllaMQUQmE=;
        b=K+ga/H84oTCiNRoUJNwR1H9kJxrFuZ27fLXfcHk1hHMvBvlLtAgV2dslRLmFWFQU/n
         wRkDlaTDIlZsJAy3WTH78NJwLwR1HOG8xYqZ5lmp7UaivNfsVmtCXBNkNwAVz4+A2Bag
         kWawnXkMW45ETrHDFzc01DFUwLR26DEagUuBd/6fNjvayCUDopHr8Y83n+/IgwACfLsH
         kE54QhDBfQgbX+WRdvVIrQualdb0ODLK0f+gp0ttDvTa12rDFON4LOCj05lOH+rdYgA9
         UXfJA3OuztWDi/9dcG1Fuu+LR55co8VEutZlbrfGwM+Dfw38PSxfLgpyUbl1fjczEfvO
         K/hA==
X-Forwarded-Encrypted: i=1; AJvYcCUI4sYximh0sO4mWvdzrE8PyK/+1cSNgD7dhN8o1JHToYHJxpDJvEzfWuDM8OwaY6AosAMaXQNscpGwBTo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDd2d/wC9rX3ubNvG0livenQnMkjqwUolI7JgjaFss1cvnm3RS
	Jswb4X0mCnk/dR7BxnprDtw8CqXCcP14p7Oqia9ndYNkborWf7FjhI8gejOfzLin
X-Gm-Gg: ASbGnctTri9sGPGFkU1hvuXawnOomHMKe1XoIMCylG+xNAOxTGI/NM6Gqb7GDonzQzU
	hHNbFw6dinXBDMby97F3ESzrVXm2eBdP6GsNwXEfZiNr0VbLS3Xr7GoV9GwmUbfrLecfDP2JNey
	yCm5i2fMsHjp8zlnH33KyzceCkO6f3fotjUzN1zukEA+9O2PEkGbEx+hGBZCkBzAgL5BexWbwHp
	QbcB3qgjH2xtcrgpqfJTU7rabcGG9WPfleIEaMoeYBEDo/yFv833+zRE9sb5lJ+XVYfy9bOxVSZ
	1gFNe5rPafFi/YUGp34kiw0ZbGVFD52fFNPCxM85MFANkrI+GutOPhVS8mlcIEp+OCoh14/xV4a
	CTndYbIP2zc/WBXPkiK7PmlVeggRcYtWmCi1fmC7TxSazB7p4x9ocsg==
X-Google-Smtp-Source: AGHT+IHQ/XHfmmVlqcvkBjMQX5+z6izyk0e6FqMAalU7cycDTL3qFUQ12Q7Tw8CXbf7brzi9bJP9Yg==
X-Received: by 2002:a05:6000:1842:b0:3ee:1233:4673 with SMTP id ffacd0b85a97d-3ee7d0c7f3cmr4373741f8f.16.1758352994450;
        Sat, 20 Sep 2025 00:23:14 -0700 (PDT)
Received: from giga-mm-1.home ([2a02:1210:8642:2b00:82ee:73ff:feb8:99e3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f32674bf8sm91662745e9.11.2025.09.20.00.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 00:23:13 -0700 (PDT)
Message-ID: <a0cc0a58218478a182b8d32fe9158f143816a7fd.camel@gmail.com>
Subject: Re: [PATCH] hwrng: fix division by zero in ks_sa_rng_init
From: Alexander Sverdlin <alexander.sverdlin@gmail.com>
To: Nishanth Menon <nm@ti.com>, Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?=
	 <u.kleine-koenig@baylibre.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
 Olivia Mackall <olivia@selenic.com>
Cc: Alexander Sverdlin <alexander.sverdlin@nokia.com>, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Date: Sat, 20 Sep 2025 09:23:10 +0200
In-Reply-To: <20250919132002.180874-1-nm@ti.com>
References: <20250919132002.180874-1-nm@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Nishanth,

On Fri, 2025-09-19 at 08:20 -0500, Nishanth Menon wrote:
> Fix division by zero in ks_sa_rng_init caused by missing clock
> pointer initialization. The clk_get_rate() call is performed on
> an uninitialized clk pointer, resulting in division by zero when
> calculating delay values.
>=20
> Add clock initialization code before using the clock.
>=20
> Fixes: 6d01d8511dce ("hwrng: ks-sa - Add minimum sleep time before ready-=
polling")
> Signed-off-by: Nishanth Menon <nm@ti.com>

Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>

> =C2=A0drivers/char/hw_random/ks-sa-rng.c | 7 +++++++
> =C2=A01 file changed, 7 insertions(+)
> ---
>=20
> Noticed this when looking at kci logs:
> https://dashboard.kernelci.org/log-viewer?itemId=3Dti%3A0af42187f4b24261b=
0c102f0&org=3Dti&type=3Dtest&url=3Dhttp%3A%2F%2Ffiles.kernelci.org%2F%2Fti%=
2Fmainline%2Fmaster%2Fv6.17-rc6-43-g8b789f2b7602%2Farm%2Fmulti_v7_defconfig=
%2BCONFIG_EFI%3Dy%2BCONFIG_ARM_LPAE%3Dy%2Bdebug%2Bkselftest%2Btinyconfig%2F=
gcc-12%2Fbaseline-nfs-boot.nfs-k2hk-evm.txt.gz
>=20
> Fixed version boot:
> https://gist.github.com/nmenon/0996e5f7bdbcd3b014cee9921a60d88c
>=20
> =C2=A0drivers/char/hw_random/ks-sa-rng.c | 4 ++++
> =C2=A01 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/char/hw_random/ks-sa-rng.c b/drivers/char/hw_random/=
ks-sa-rng.c
> index d8fd8a354482..9e408144a10c 100644
> --- a/drivers/char/hw_random/ks-sa-rng.c
> +++ b/drivers/char/hw_random/ks-sa-rng.c
> @@ -231,6 +231,10 @@ static int ks_sa_rng_probe(struct platform_device *p=
dev)
> =C2=A0	if (IS_ERR(ks_sa_rng->regmap_cfg))
> =C2=A0		return dev_err_probe(dev, -EINVAL, "syscon_node_to_regmap failed\=
n");
> =C2=A0
> +	ks_sa_rng->clk =3D devm_clk_get_enabled(dev, NULL);
> +	if (IS_ERR(ks_sa_rng->clk))
> +		return dev_err_probe(dev, PTR_ERR(ks_sa_rng->clk), "Failed to get cloc=
k\n");
> +
> =C2=A0	pm_runtime_enable(dev);
> =C2=A0	ret =3D pm_runtime_resume_and_get(dev);
> =C2=A0	if (ret < 0) {

--=20
Alexander Sverdlin.
