Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB11948F004
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 05:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790055775; cv=none; b=UsCgLB2FA7YWPRvpsbQHH5s53i6ygz7WbEFprsOi76F49JH+jc0eHv7WXobBrNJrTa17J6sKPGzQQEeiMTpJWtRra+uJQKcLvUtt+7Pp6MhuhF/3+cts6Eim1dFV+m6J1HOm81qWvBh85CSsTURvdb1GdsEE/0SxPiX6HWnvG/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790055775; c=relaxed/simple;
	bh=c/faXrItK0j/8gDWnXDndDC81CuGn/Ff4NZ5bBIz3H0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HYF/G9wGUDnRYEuBNyOuu+b9cnE8AZgDz3fv3D0MRfVS59p9Hl0MZyY8ae/ck0CRUlLD+wpG+3ImrlTcE2FSjraLDd2qtOTBukpBI7mVqHnE0VfJ9zCeWS4MHXxvKrc1+Dt3IAC/0ipkgYfbyIR1Y9Fy5GUQ9Qt1m+0jB9AY8+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VhcZmMhF; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VhcZmMhF"
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-8716a5baf64so34578927b3.3
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 22:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790055765; x=1790660565; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xOf8LHzCJGb9DLLbIqkHEB8RegxFEU+aj+xMEqBxFFI=;
        b=VhcZmMhFekmHiofRFj1j6F5CZsflhLOoCS8EyQQNViYWUIAa1hxAL2gjY4zZsSdjKK
         mP5B7jBIHcwFoW/ui67IuiGFaMl35VQpRH0N1rG0ypM/QP0tnCu78PVtHtoLQhCSxGtI
         cGmC0XLRIPJiNUDVHraEoJIDYuKgpKOlUsRJpSAH9MXpr3eBQiKnsALzS+ueE4775/ji
         PZRwSxmxUbnQoSPjwTks/Z3Fa+Q8f7FnNHu9m3Rxq6fdD4AhkoKFzFX3qAGu50EeRrfO
         JDQLkueMkfOkGETyHywwulGgAl2r1ji3e+ffgCRbCwdvrg4OSen4Mfgur4BNCWTcHz2w
         VJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055765; x=1790660565;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xOf8LHzCJGb9DLLbIqkHEB8RegxFEU+aj+xMEqBxFFI=;
        b=ed4WPshFgNViPECohac3sxPPICnJ0nM0rfDz7OI031/0Jg66rj4rsuPt8OYm9Fn3Md
         LmPwKGCn/vCgxlCWtCr3wjfGp4yBkTVM4264jkc1Y9NrmU8LVSaB1pJawbkTGj+ja2M/
         mcqlLiUqFDP+xojMHzPERBf7rqGHNnDEmVZdCTE+GwQPtcXv2SZHLXPFFp4Gv0RRdbf2
         JPOuPK0Wznmq0AjqVUEjeXX38XeizWQGrnjLMPjpjlzv7cHGVxFe9H5zMibc2qCW1O3z
         0nZ1dVPABBGxkxuk0OR6UcpGK0Lal3E2MKd9L4x6desPfzTBuev2hC7ABRh7F+vAozLs
         R1+g==
X-Gm-Message-State: AFuF++mdBDfnkWS/I77R4xvP872Thjlc2G77rS0Xb+SFdq4qt8zhuSTz
	HYKb+pyzHdYWaYbqQwK6msqm7cOj4GLREBRSUjW4hKvwHnlBzQLnqQ8o
X-Gm-Gg: AYBFou1JfJIy/i22xGUAKvqemlOBt+JkLx0farZLydGAN8UyTkqAWC7ocXIU1sVf/1V
	sEMUAfYdDG5ixZbj8+VS1eiBhKtUqJfRcdHZ9xdSCx5O5UY0gm7JtDDxrLbEPJG7frT7xI52DA2
	Ak5NM82puojuZLxLJVMrRDArNu5uUVV+aNhTAnGcHgQijZBo9G3XJMrvDSS9do3Sz177j7LkblL
	L/7vULgAyu0nNdyy49m8/ogFnK7vt+U6Tw8WrNi42AQSyu5A/T44GC5rTU7kaYKphzHoNQMpwuz
	MFiS/KjqHlc9cpJtPDuHehPk4qoRze31bYk8h7CmYistH5Bug1M3i20Up6NPt2YYJsbIEMAHMf1
	fwaRdSPm1Gjg6dXnB4YE44dSvVjAhSZLvnA58hcTEbglvLmiwL6nikwuBWT+w4t6ppTydbsI9mZ
	DQWrM9FI1r/ZHuKf8Ua8vxvjImisnKxZUPpyJsZnOazBotXmwtqnWNl1wzYy56SOFUfNE8X8ZKZ
	FpsXwwPcIGyIA==
X-Received: by 2002:a05:690c:a756:b0:882:1d1e:d73a with SMTP id 00721157ae682-8973090270amr29013187b3.4.1790055765385;
        Mon, 21 Sep 2026 22:42:45 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a2c24c4fa4sm2402157b3.21.2026.09.21.22.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 22:42:43 -0700 (PDT)
Message-ID: <71cba843-1643-4f5e-9830-9e60b5f1c334@gmail.com>
Date: Tue, 22 Sep 2026 01:42:28 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 10/14] Revert "crypto: qce - Mark QCE as BROKEN"
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Stanimir Varbanov <svarbanov@mm-sol.com>,
 Eneas U de Queiroz <cotequeiroz@gmail.com>,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Eric Biggers <ebiggers@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Russell King
 <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, brgl@kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
 <20260921-qce-fix-self-tests-v8-10-107537869a72@oss.qualcomm.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260921-qce-fix-self-tests-v8-10-107537869a72@oss.qualcomm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------hZGDlRLrKnd03jrOhfI7ouRT"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------hZGDlRLrKnd03jrOhfI7ouRT
Content-Type: multipart/mixed; boundary="------------hcBi0xuRtuG0C0y5h9SjgbL0";
 protected-headers="v1"; hp="clear"
Message-ID: <71cba843-1643-4f5e-9830-9e60b5f1c334@gmail.com>
Date: Tue, 22 Sep 2026 01:42:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 10/14] Revert "crypto: qce - Mark QCE as BROKEN"
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Stanimir Varbanov <svarbanov@mm-sol.com>,
 Eneas U de Queiroz <cotequeiroz@gmail.com>,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Eric Biggers <ebiggers@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Russell King
 <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, brgl@kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
 <20260921-qce-fix-self-tests-v8-10-107537869a72@oss.qualcomm.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260921-qce-fix-self-tests-v8-10-107537869a72@oss.qualcomm.com>

--------------hcBi0xuRtuG0C0y5h9SjgbL0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 9/21/26 08:58, Bartosz Golaszewski wrote:
> The self-tests for this driver have been fixed. The crypto algorithms
> are only registered if the user explicitly requests it with the provide=
d
> module parameter defaulting to false. There's no reason to further keep=

> it unbuildable with the BROKEN label.
>=20
> While at it: update the Kconfig description by saying this is an
> "offloader" and not an "accelerator".
>=20
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.co=
m>
> ---
>  arch/arm/configs/multi_v7_defconfig |  1 +
>  arch/arm64/configs/defconfig        |  1 +
>  drivers/crypto/Kconfig              | 16 ++++++++--------
>  3 files changed, 10 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/mul=
ti_v7_defconfig
> index f9b8dbf9318c9d4947e56ef0159311634bf0c1ee..2d6292f8cab39596b540084=
fbd8b30f4c25cd4ff 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -1323,6 +1323,7 @@ CONFIG_CRYPTO_DEV_ATMEL_AES=3Dm
>  CONFIG_CRYPTO_DEV_ATMEL_TDES=3Dm
>  CONFIG_CRYPTO_DEV_ATMEL_SHA=3Dm
>  CONFIG_CRYPTO_DEV_MARVELL_CESA=3Dm
> +CONFIG_CRYPTO_DEV_QCE=3Dm
>  CONFIG_CRYPTO_DEV_ROCKCHIP=3Dm
>  CONFIG_CRYPTO_DEV_STM32_HASH=3Dm
>  CONFIG_CRYPTO_DEV_STM32_CRYP=3Dm
> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfi=
g
> index 982ea1758eb667a1949721140961764b3e9be1f6..55a2e8c3ae3522630df8c31=
cb2b7c7663e973aed 100644
> --- a/arch/arm64/configs/defconfig
> +++ b/arch/arm64/configs/defconfig
> @@ -1957,6 +1957,7 @@ CONFIG_CRYPTO_AES_ARM64_CE_CCM=3Dy
>  CONFIG_CRYPTO_DEV_SUN8I_CE=3Dm
>  CONFIG_CRYPTO_DEV_FSL_CAAM=3Dm
>  CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM=3Dm
> +CONFIG_CRYPTO_DEV_QCE=3Dm
>  CONFIG_CRYPTO_DEV_TEGRA=3Dm
>  CONFIG_CRYPTO_DEV_ZYNQMP_AES=3Dm
>  CONFIG_CRYPTO_DEV_ZYNQMP_SHA3=3Dm
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 0189dfdcbbe11098ead0ea194293422a31d8fe65..baf6c4a4c8aed663e89ae24=
68a7e9ed9dcb66f34 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -527,17 +527,17 @@ source "drivers/crypto/marvell/Kconfig"
>  source "drivers/crypto/intel/Kconfig"
> =20
>  config CRYPTO_DEV_QCE
> -	tristate "Qualcomm crypto engine accelerator"
> -	depends on (BROKEN && ARCH_QCOM) || COMPILE_TEST
> +	tristate "Qualcomm crypto engine offloader"
> +	depends on ARCH_QCOM || COMPILE_TEST
>  	depends on HAS_IOMEM
>  	help
> -	  This driver supports Qualcomm crypto engine accelerator
> -	  hardware. To compile this driver as a module, choose M here. The
> -	  module will be called qcrypto.
> +	  This driver supports Qualcomm crypto engine offloader hardware. To
> +	  compile this driver as a module, choose M here. The module will be
> +	  called qcrypto.
> =20
> -	  This driver does not have exclusive access to the
> -	  hardware, causing races with the secure world.  It
> -	  is also slower than the CPU.
> +	  NOTE: This driver does not have exclusive access to the hardware,
> +	  causing races with the secure world. It is also *slower* than the
> +	  CPU for the same algorithms. Use at your own risk!

Would it make sense to clarify that this is only an issue if you pass
do_register_algos=3D1?  With do_register_algos=3D0 (the default), the
driver is perfectly safe (unless you made a mistake elsewhere) and
saves power, so most people want it on.

Also, if I understand your previous messages correctly, Linux currently
doesn't use any of the features that would cause the races with the
secure world.

>  config CRYPTO_DEV_QCE_SKCIPHER
>  	bool
>=20
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------hcBi0xuRtuG0C0y5h9SjgbL0--

--------------hZGDlRLrKnd03jrOhfI7ouRT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmqyFU4ACgkQszaHOrMp
8lNAXQ//aGdnZkkwqbte0yMCxsNvRT8fzkRkN+G6RbFCXrZTBTldeYeBFF9EVKHq
BvXdeWWcgRF7ucW/m3up3k94kMaG2mPBhOqRQUeOWcxg2lFCACnwI2JIU9v+Q20l
KQzbvfYAk3wGNqGmw3U8Be1ZycMZFtiiHqLlomXXzW0jyJVmlTyRJWUTH6MImFv5
GUkzvLUI6rFNzl6D+RO5MjEEHQh1jnyDjuS5ANk6bs6aEixLDath60rcUqaxmppC
KPSkylFQOQv1mLU/saPYw71WeomPTQivWvBBxaQJFC+acYmMpNp/SSzqMeH2HsIU
cBtofkhBYEKtlwNB57ZGvwlJ24phrLrgR0G3ywdVROO22stuxtxe3H7roaLwEkNg
GJkCWK7z6NePSivu/KDSAvprmirjZc6Ryb3uSpacaHQnFq67S6+IG03SZdKaDd+6
9VQVY7yifSt2Gg97rb84BkqajHTa3qDKLbONIrH0x4tiYOZ3InKWGotNgwrr0T4/
3fUb0WlNrJc5CEFcMS9OXNiI1rvNLKY0xRzcZjai+Kc+Xap1fSTstr4hIq8zAqBv
yU5ktQvwFVBZrfrcKkHA1nTOr98978F65rP4QfLSvcGvATBWO3WBJuL/LZ5x5yxr
F5oQzVPVA4m2qziCiS14ODLspfAFxb8d8u8mY7B0CYlPrqfGoj4=
=rE7a
-----END PGP SIGNATURE-----

--------------hZGDlRLrKnd03jrOhfI7ouRT--
