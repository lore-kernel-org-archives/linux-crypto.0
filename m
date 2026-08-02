Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91628331EC2
	for <linux-crypto@vger.kernel.org>; Sun,  2 Aug 2026 22:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785709246; cv=none; b=X6lK9/nIDrM4ET0GqRFnYHWAhcvrpvdOn89Dbg5MeqQ7cHIM9NiVJrwEoqERbbKs/VrWfqUGmnWBFYywJZmw7WeIMgVY7ZKrsyqm10T/qMPYLFu8oszb1kL/6My480gkdh0dPlW/RoCwQrFHDQbCogqp79uw3Rz9Vf5XNuT53cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785709246; c=relaxed/simple;
	bh=K/2jAp6khRcklPkNtuC/joaYI5lCI1uQRDZekKuvXIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E2a6zhLs6RqI0Hzshpuesls8ZF8xo42dISs5VTc8NYDRNMCyjbj9u30Ewp0CT3/G6/8dkY0VTDPkEjeiK9J3Ty/TzqJjMeIi7RcOVgGeO6T7wPlqirs2dsaqj+Ww9wAWzmLNQsm8F0pZJUA9LjqdWJpbcTnQQDHJyTRkZQbBoBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=KucLgUYr; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="KucLgUYr"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4954d29264cso7319105e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 02 Aug 2026 15:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1785709244; x=1786314044; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i9RUjiVyXXCN2eHfX1I53hQWCYFwzgd7w4b5P9lpT/E=;
        b=KucLgUYrXLYkqFnnrB+OswFPm43aE4h+rQLBGHyCrPaPHwHsOg0wXRAX2KQJrPx3h+
         EGAv8BsR0jrLauQPLWS1a0aaETpcngmntxISpqgHs0Cc7q/9ysdMNtzxqp0pnbrd02ct
         ON34Lyg/Vc9ZJc+PkqeucW5X3bXGI/L5Ma4tdm9jlQrvvgDXTuVCoxZAZHLs1XKnx6UX
         YAmNueUDeTPOBOkv8IqfCznAn/ncOvQOwC63Ylzc/7CwN/toh1OIrTntYZ0osH3BpGXa
         wdLuDJg44HljRBy3GWId3xSRUDjM7JMnm1pr7ZBiRSKUgsvxgQTKz5dQBVrl2yD6+4OY
         wv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785709244; x=1786314044;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i9RUjiVyXXCN2eHfX1I53hQWCYFwzgd7w4b5P9lpT/E=;
        b=NGlN4ENRgYG0+Sab377x9yVFj/IRbhxHfA8vWKlUB6cJjvgraGaIUTKSQopZWTbBOR
         fPI9/5CtWAFO22AJc9z9Lod3YhcBz6MBbFTZYji74wTzpUnDri2TMIVWizlqnv3vEnIB
         GsYo31hFti/eE1u66c7xP1P69gUgzoiXnmuStXgVYbMQ3CcYyAH6EcP3GCTu8aB4yFgh
         fdbl647+njIhvTg/68OZnskLkTQtMLhrymlOLxsHemb4oBxz4VhsOpp5rTdasnrMTIkd
         3xkpIm4u/Q53WSYp4jMgUP1nMDiwKZSe++duww8RjpgiYcYLDb9pd9XHTyFGaWlpfnQJ
         2oSQ==
X-Gm-Message-State: AOJu0YweTqmpq3D6xeI2RSwVsg1F/m4mCWroDGpKd7azTZkG/dDCxeww
	1Wd8Ajfel6H0UGwvVZqk8RyvKEd2JLXG1Y4UNGUw6rjQbFh6+Ae4crUxaPt3N9p42ls=
X-Gm-Gg: AR+sD13bFz+fffep6zxPVR+NwQVO+BBL8iw7QwbTlzhwqq7Qo34uRVgtqiG4/JVmver
	CHNiY1nImwIvYAkFUalrS12WveFj1fTs8GgkdoCdXCPHBGCy9qvsfNLWGDYXbNUByQ8AhFvyKZZ
	9FB495fKC1mPpjSTSJ2ievhYzkF3i5nv6k+fRdQIkgppXrTwJI27DNyqT/eYo5YyRb95ymcB0Rh
	SbQ15LueLfYxPQnkSi/0TVQMbHqU1SgXPzRt/+omHYmCnUmdvuGcnRjP5baNqAANGiY0EotQp5b
	NDWEGNj2DwrN43zqDDRx5n8Kq52gGqROMRwrsJzrZFGVHyALPUH4GOh22zgwZN4TOxw7xlUu4dK
	W6QFs0HzBxdzocarTh72ewxU/L/Yj0Sbp5pnAuBpbEHW68NlGbKwtGrNGqQ1QI2rgDecX34u8Og
	FvyqkQNLU13mjWJm7pwI/VSt1L14fpuw5DLWKC1SwLQC+LbpLKnV0irfDdOBXl29S80g==
X-Received: by 2002:a05:600c:564b:b0:495:52dc:73a9 with SMTP id 5b1f17b1804b1-4980c675370mr125127215e9.11.1785709243887;
        Sun, 02 Aug 2026 15:20:43 -0700 (PDT)
Received: from localhost ([2a02:8071:56d1:2de0:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-47fd456a6besm25058203f8f.22.2026.08.02.15.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 15:20:41 -0700 (PDT)
Date: Mon, 3 Aug 2026 00:20:39 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Demi Marie Obenour <demiobenour@gmail.com>, 
	Bartosz Golaszewski <brgl@kernel.org>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
Message-ID: <am_CG_kR24lpos6D@monoceros>
References: <20260731050838.158825-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ll56pjw5fggcc5xl"
Content-Disposition: inline
In-Reply-To: <20260731050838.158825-1-ebiggers@kernel.org>


--ll56pjw5fggcc5xl
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
MIME-Version: 1.0

Hello,

On Thu, Jul 30, 2026 at 10:08:38PM -0700, Eric Biggers wrote:
> diff --git a/drivers/crypto/qce/qcrypto.c b/drivers/crypto/qce/qcrypto.c
> new file mode 100644
> index 000000000000..d526902b3060
> --- /dev/null
> +++ b/drivers/crypto/qce/qcrypto.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2010-2014, The Linux Foundation. All rights reserved.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/interconnect.h>
> +#include <linux/module.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/platform_device.h>

<linux/platform_device.h> already makes sure that of_device_id is
available, so don't include <linux/mod_devicetable.h> which will go away
soon.

Also I wonder why/if you need <linux/device.h> here.

> +static int qce_crypto_probe(struct platform_device *pdev)
> +{
> +	struct icc_path *mem_path;
> +
> +	mem_path = devm_of_icc_get(&pdev->dev, "memory");
> +	if (IS_ERR(mem_path))
> +		return PTR_ERR(mem_path);
> +
> +	return icc_set_bw(mem_path, 0, 0);
> +}
> +
> +static const struct of_device_id qce_crypto_of_match[] = {
> +	{ .compatible = "qcom,crypto-v5.1", },

No , before a closing } please

> +	{ .compatible = "qcom,crypto-v5.4", },
> +	{ .compatible = "qcom,qce", },
> +	{}

A single space between { and } is the most usual form, please stick to
that.

> +};
> +MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
> +
> +static struct platform_driver qce_crypto_driver = {
> +	.probe = qce_crypto_probe,
> +	.driver = {
> +		.name = KBUILD_MODNAME,
> +		.of_match_table = qce_crypto_of_match,
> +	},
> +};
> +module_platform_driver(qce_crypto_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Qualcomm crypto engine stub driver");
> +MODULE_ALIAS("platform:" KBUILD_MODNAME);
> +MODULE_AUTHOR("The Linux Foundation");

Best regards
Uwe

--ll56pjw5fggcc5xl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmpvwrUACgkQj4D7WH0S
/k67nQf+OehFcZIDtgFxkyFvQZvZvj8xuSmIv0XdUJH05uJUlrPzdkpGEIhFcanz
X8NT6EKrJBiBvrf3pUe00j0mjuhrKvSlNwD/OIOfIyKO/vqCUA7I9I7Z2rytufiF
ctDEwPQm1DhHjgqODVsHjkhxh8GL/DJRZfJI5rlD/owrDhjUVV23+9el/AnKy9Pa
rbNI92rAQ0E6Oqn6PzhUz7szbSaZwNOIHHwEDSKza6Nz2ReOBoqmNzb+wtiSV0Zw
ZU88/nUiGRYBZohrjw28Vog4+tLMFK5yqZunqMgevvJNdVSkJCt/6DSH0F5uI4py
p1VS4MphWJzPY13zmlS5FUlxowzcFQ==
=dBQw
-----END PGP SIGNATURE-----

--ll56pjw5fggcc5xl--
