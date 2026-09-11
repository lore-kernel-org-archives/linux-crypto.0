Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5515B4AA57F
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 18:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789151695; cv=none; b=XWDC470zHS26xLK0oIKVPiOCm1hnNLGUsls6GS0zGX9Cby358BCKhnaU6Oxrpm2U7R2fJFuaytVRCeeJSl0u2vhUIzBtarjWlGHr78QpXSMQnY+o6T2ZUbgXAT+hJwFF3+6tm40g5Fz5sD3OUBTtp7K3QMZxGkSTH4XqqAGRBsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789151695; c=relaxed/simple;
	bh=OH4TD0T1j9//gFx8Hjs8ilFM6X8S8rbMf9k/5jV8TiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PPYpIO6ZfjvVogWi5lPOEA+r4uwTZGygy2w7K0U8LzrQcU6b0nl9jTDVywC4BXfMinGDXWugPi2DIZYQRNduoVxiwb0KKSb/B7b0dMvNeUFqHQ+kW+XXbjgOPyLxKNqRAKloO3jXLhnXya7a0OXltaTPq8YJagVy2WY+UUCMsHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BH3Gvypw; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BH3Gvypw"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8871ada1a26so4087157b3.1
        for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 11:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789151685; x=1789756485; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hk2aRK1vwnRKpbCEcf4tT6rBkC59i6gDVNC/VnuWdwc=;
        b=BH3GvypwzTzf+/oIl4NT6GDRmDXXMjcAHSrFZ4cRo8DRjyQMX3wTU+6QQRpubYyYx9
         8z5CF1y8IHahAtaSdRTt+3L7xrZINfED0CTwHNaYpn0Yzm07BYK/rImo5Hzg+siyVle0
         dAjB9jeLLVnAPJFVEQ1iAOJatM4KfTdlpcz6Kd8s1PCj6KZwfsGrJfPhJXmfMVdjFSFv
         ldFZHmnNZJRofIi/4074FwY4VcpqfKU4K0jRslDR8vjcQCLzcTxLHmXdFUC4V2yZDf4H
         1Ely8tSPnp6YN8/BXdBjT+y1q/EnpCpLfEBaLpFw0NzSldJ+Yslt7lBG/frIPIaSo9HG
         pQEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789151685; x=1789756485;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hk2aRK1vwnRKpbCEcf4tT6rBkC59i6gDVNC/VnuWdwc=;
        b=OF9nqQANH4PYBjdyiU4OIbOFnzyf7qQFJZ8JUAt9G9pL7GbIZoliLh6k1Mu2dXS50R
         M9R1aPi8CL8hiZggm1M7ttf+DxPXsFZjF/0QEYayFlwpKtzRc6kKKvRWmlrYOV1BUBJd
         XuJBAKUHdnneoeN2wSmhHj1B+BgeYVJmQewsbNYtU3sxPQmcjdsoU0u6BRSWz8MEkuRj
         WLl0acUr/On1bRGuv72z5XN2bL5pEllaLFFtJDuB3S4EoIrwwX0QvTUwftHpOg7dXMK4
         yPVo4uWKKpTHhbwTY3n3Fy+HkxHNifDzOrtoPJDx38Qx9RMFGVynktqw61FwxUpt8cj8
         aWJQ==
X-Gm-Message-State: AFuF++mfDJaEsE2j8W4tE3w8vJ1vvKs6cOlLBGO4i93IyVVgaZIVa7Ih
	JfFp6CuOejYiGSCweZ+Uczpg14/s2ov3nqasA6iiki9EqEYpL14nzqTq
X-Gm-Gg: AYBFou2MKpyWDQziv1j6OGC082yeVZbLzrYBvMWQE1BikaiBfAuz6n0Fjlnm3eKOOCA
	xAHKu8gK/8mBMGVxyvjqo5gvrqRcviIH41XSjauYZ/0jI2CmHxFG4AGyHgcE/Dd2gWwoPRkDdsj
	u+1Y+jYpMua1MxPvDWb7GEMI85609V9jrrzO4i6nCg1posCdK4SoAEdUjdauZ2FOwBTchIEX4bG
	oXbAzNK7zoiLQHuPibkqi79VeueGDTaE/F9rEtDpMYq/b64XR0Y8U/ibltIWUimYRQjnVOhzhc+
	4COLSLCZ2I9mIQ9GuSUEkynuQtmZtrBiDIObduE5bKmhvuDDZXS549SiignEaIEu8GDeaSUrP0j
	j4+1spfRR/Cwn8+5Gq8ZMq+KJKPTc6snSjfeNLcm2UBQobPz4TdaFVZ63M9RP+yM1VVlkTeVEOA
	weiiPVI2oxPvUbFUdmPmuVU7eWCrOvtSIp4S5+bp3Mf4ZCNSh1BKwnQfjtFi1x4fMALhj/JroXh
	g==
X-Received: by 2002:a05:690c:7107:b0:873:5bb2:6c31 with SMTP id 00721157ae682-884b2eb52bemr20024517b3.56.1789151684818;
        Fri, 11 Sep 2026 11:34:44 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-88488a4c120sm14489077b3.38.2026.09.11.11.34.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 11:34:43 -0700 (PDT)
Message-ID: <7e1b4800-258b-4410-8e88-2ce49505689e@gmail.com>
Date: Fri, 11 Sep 2026 14:34:39 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/12] crypto: qce - Fix crypto self-test failures
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Stanimir Varbanov <svarbanov@mm-sol.com>,
 Eneas U de Queiroz <cotequeiroz@gmail.com>,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Eric Biggers <ebiggers@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, brgl@kernel.org, stable@vger.kernel.org
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------b6Pv0kWTnPJ4ZTrxShFmchbP"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------b6Pv0kWTnPJ4ZTrxShFmchbP
Content-Type: multipart/mixed; boundary="------------b0zZgz1THSQE2fTDm71bz4rh";
 protected-headers="v1"; hp="clear"
Message-ID: <7e1b4800-258b-4410-8e88-2ce49505689e@gmail.com>
Date: Fri, 11 Sep 2026 14:34:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/12] crypto: qce - Fix crypto self-test failures
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Stanimir Varbanov <svarbanov@mm-sol.com>,
 Eneas U de Queiroz <cotequeiroz@gmail.com>,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Eric Biggers <ebiggers@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, brgl@kernel.org, stable@vger.kernel.org
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>

--------------b0zZgz1THSQE2fTDm71bz4rh
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 9/10/26 09:00, Bartosz Golaszewski wrote:
> This iteration - in addition to the previous fixes - proposes to split
> the QCE driver into a core part necessary to bind to the QCE DT node an=
d
> enable runtime power management in order to allow to drop the
> interconnect votes, and the crypto part registering the crypto
> algorithms. The core module is then enabled in arm64 defconfig while th=
e
> crypto part stays disabled by default.
>=20
> The QCE hardware crypto engine has several limitations that cause it to=

> produce incorrect results or stall on certain inputs. This series fixes=

> several bugs and adds workaround allowing the deiver to pass crypto
> self-tests.
>=20
> The failures addressed are:
>=20
> - HMAC self-test failures for empty messages
> - AES-XTS returning success on zero-length input (should be -EINVAL)
> - AES-CTR: partial final block causes the engine to stall, output IV
>   derivation was incorrect
> - AES-XTS with key1 =3D=3D key2 is not supported by the CE
> - AES-CCM: partial final block and fragmented payload both stall the
>   engine
>=20
> All fixes were tested on an SM8650 QRD board with
> CONFIG_CRYPTO_SELFTESTS=3Dy and CONFIG_CRYPTO_SELFTESTS_FULL=3Dy.
>=20
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.co=
m>
For stable, would it be better to not register the algorithms, thus
preventing their use?  Another option would be to replace the whole
driver with an always-on stub driver that just does power management.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------b0zZgz1THSQE2fTDm71bz4rh--

--------------b6Pv0kWTnPJ4ZTrxShFmchbP
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmqkSb8ACgkQszaHOrMp
8lO7hg//dbVegiswT9OWuiiGRNL+3ZcajQKPRYop7Furtl8QGFJLNnPvy9HGsoC/
dNu7zvnyjdvq0yUCPYUDX4FRu91ub4jeLjERVoiVt0vBG4vZ9Q+GaIOQkh8mN4zD
9LOIe3f4oXZmcP2VNBmngRY74+liMEianyQS1VUum6ARhwG0w6J8lFAjTWcXGt23
djST7HR04rLN/nhRR1+fNaoAkOVVrNP499u1Db/otch9dmWGXtdFc8x9Cr9Fqi+d
796xeQyEG3uoRpKj9VAoNrJtKgEUe/ccZCDoBkxEyT6PE45rCj3sN6A0Yim4Pstg
BCeppYc/tz076CaQ8JPm7/xuOhsm8pXfytihp/zBNQ1nsvm+mp46shmkqZteNo0W
Xhw/Jjc4ZG+JjuIIGTpoPJ6sIP8atO8meSSmHnLAJnCfsMKZBDeQxNsxSHc+E1Qh
RQ2JO9O7gF8XPmt0A1XdzuUp19k32ET50Q9/WQQUUG5I0bbBjUiO3OdTju5pYNuZ
V9NYKGLGoQpSZ2oIHmfDU84rEwdHl1tewrWqtmUmRJ5o/3yzWRElBSmOkd89KJRz
4ZItImyuy/eerN7T8Z7PP24Klc3mAFgT3cXGsY1yLyvBvJiHoutMvPwSNkGyB4ig
opXcjqL9WRB65MrV6H1RG864VH4a4dlCmdemgBV2aJuTL4TCj7M=
=zFw5
-----END PGP SIGNATURE-----

--------------b6Pv0kWTnPJ4ZTrxShFmchbP--
