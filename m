Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BB944B679
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778841481; cv=pass; b=cns5B7FxISLLc2eaESr06YlVjluB34V4/puneSiFbni4LSjzn+JLon1ZIU5pNfXYjKXsBEouWcRYONdxVstMDNWaec5eEPRC59GCVIzaJFdGugajpB6TvCyMhR3+SEwED/m0TlzEzTwfnk8bEC8JfCskjlkXqBkPstglAEf1OWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778841481; c=relaxed/simple;
	bh=Mg37Wy3KRnUM1ONATbgQfacA9HiWz4ji3AcGoZ9aFz4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EoULWzl1ZiFt6qln6BQJ1vnVHgQww9S2VfL/1csmDLv9TszfzkdPwNQyS5aStLOINmi148hu5Mi/aVCiZbzSjdqylAuYcD4orJgQc8B7cWJiPBQdKE3RBUd8d21RheK73+dehHbu98J4GL3kMif/D71pZU2c7j5VbuDEAf8Kklw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QtOjj7YD; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QtOjj7YD"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9358dd7f79so1449601166b.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 03:37:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778841478; cv=none;
        d=google.com; s=arc-20240605;
        b=bd59cvraZ/3XBuryrY+FmpAhz2mjCaDQXORgYJrt0wbezePv1ZJaGsBb5q66sfsz2N
         WdZYAhWPmYMLNgP5AYYtmkeNT9lJ2jL6Oq7UMvVrdc++q6M2wcXB8WEFyKtYtns8wEdv
         HLoS89Qp9/pSEg48kSUZYxJdqoEbpzv5/OsfVep4sSdAIkPAxf5TYbkHimF6rUYr/+Ph
         cu1HCikcHzE5hXzXBQe/lTT9LN1g/a+/R+xg2vvUk1S2tTXql8JWj71WDvmNkw5qmPV7
         XV3sA9RfeWrttiJlGLvjQWzn/1RS7nVi7p9FRg4IgQ0zPQlMgwAUFqjtAclyBafpuMHY
         GyvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y2Yl47ee8MtjXEIcxqYtsCZZAToZXmE/PsXL+BkUBMc=;
        fh=cCR+vHDCYjWmTqAazdSMB52Elcv5STZy+GXQE6OoTcI=;
        b=i7NsBPz5gIBL2qikrE/8vDPxW+PxCzK+MoWKlp1Mh+aRq1Rf62BkbG3Mrk/nu+MyHl
         bj4GaqjOoKAfbdxRTnNbiPVa7pcvRzyMTGTDBiwG00nFoXL9QSzJ4fyG5vJZYqyUyjeI
         BQPmZo2iBWvldKMzjvzjMKbitozPrYmAd5FWJeVmhUymwCqAbDWLtILratErGJbWe4V1
         63aSowB4/LjtHtcnp1f3EddmvFiRj/esN08jisAMBpC2cP3ZpiiIiGUqTw2HHzc4Tv9d
         fRpJcgAG23eqm5M5+E3ZW5SDnG4Qi/d8c2UfqK6yRUrWPRsoGLBKORXdKFK2LPel9fvs
         Xp6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778841478; x=1779446278; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y2Yl47ee8MtjXEIcxqYtsCZZAToZXmE/PsXL+BkUBMc=;
        b=QtOjj7YDHKJ71LWW+HRX01pb/fw1kJ/REbbmui3Ew7YYeR5NOqun8NP8GPgCc+er37
         8SlfEgB0mPjU4liUknohOzApFEoVQv6s8tK48oGg0475lHWBsa0mrJYqZDfgSHZPZ9B9
         BhwjSyKQ/xE1dF/4K1HHTZAR2gAlBpTL0r/DSvf6TXGLatLPQOUnNPYoLpNNXhZXwNV3
         ovki0YEwo+Yin0nZKSmFq5qHd6uq8kyQr+1RiE4OE7dQbnc3UnXNOE6TByJmYde6Fz6t
         Ag6sA38HE7uvw1SyB+m3Lw2+eLTQc37wU4gvtyaWwSvuopDpbIjty617mscGnP/goD+W
         015w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778841478; x=1779446278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y2Yl47ee8MtjXEIcxqYtsCZZAToZXmE/PsXL+BkUBMc=;
        b=jHnEv6cLWL5Vz+JZ6lRBzhKDQhLHkhQR4uG6hIozv02AX6lzLr6K6OYFC9FPjzhJSy
         ha5fxm/9GysJB7yYOa+4xMBVpPCR8gdkn6Kz2hfHBAOw9PgK6BqnIIS/dbjGPV66ILy0
         /qio6hxSveNqBJYNxUaIXFdfPVVeZQjX7hXdoui8msb+hZ+NrhDZHn/I5hO1ZqKlZyXB
         dO/9BczdGH6n8sEBMDaamLkkJuud7B1LIZt23Mvf75ncw9QYyRzQIwrCUfKhWlgLQMk+
         GXmV0ni7TzMgL9OROfIka4JcHI5PEUWeNYE6LK5oGEqnp2EGmzwquPcWaXG91/QBc2gv
         w7hg==
X-Forwarded-Encrypted: i=1; AFNElJ9UvcMMwtJ5qG0KszDZWUXH1cedvfc8OycRAFnmi7MUb1UymEeZyeiHXBIMZsIzzZh+gTGrlkPCUyZaDL0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1UrBODWKsp5mMhdDizlqj7mbIffuTrfwgnWOn2/01N+85WEbo
	r4Bx4kUhCLH0dqRrLHi5Ufg2CACtZCL6W87lhxV5jpp/gOzHpNyLCc9k2bgznIstXlBbwP+PMr6
	rrlUcBzUGp2kNihjbY9ett7lbtxbqGk4=
X-Gm-Gg: Acq92OH7wi5qhLbhmX6YKsfG27M6Ky92MwKwItGIoHz5dctRizoV4Zm8mzDw2CZkFup
	8iRyJchioIWfWC4u0srZxIck25WoyqnHM42FsTYCYeSZwVrCxTuq9w/mMwWHtejb0arT8VAvk4y
	uen6PP/Miu75iYh7V2sHoPmcyhrEyaPOktInJD2bF9Fce4SxMGdeJy9fc3C20Y56xvg63tuyaQI
	3LfC4QUagW5F9RkEvD4G3ayb6V1VXpD+dED8gXq1kaEd8K2wN4w0pjDGtoKR5Gm/njrPCPy2jYL
	2F5oloMl
X-Received: by 2002:a17:907:c486:b0:bd5:7a3:a590 with SMTP id
 a640c23a62f3a-bd51797a605mr162534266b.47.1778841477716; Fri, 15 May 2026
 03:37:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <782bc59d5939aa69b58cad42f71946f1c0a6dccb.1778741457.git.lukas@wunner.de>
In-Reply-To: <782bc59d5939aa69b58cad42f71946f1c0a6dccb.1778741457.git.lukas@wunner.de>
From: Alistair Francis <alistair23@gmail.com>
Date: Fri, 15 May 2026 20:37:29 +1000
X-Gm-Features: AVHnY4J6Fk9yBInmPYPIDVgxM9398Q03MJN3uwc9o-hhnM1187xvX0jLlEj4EeM
Message-ID: <CAKmqyKP=UuH4LGZC+HwDa8C9178b3345xo6GECxQw-dx8CUphg@mail.gmail.com>
Subject: Re: [PATCH] X.509: Fix validation of ASN.1 certificate header
To: Lukas Wunner <lukas@wunner.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	David Howells <dhowells@redhat.com>, Ignat Korchagin <ignat@linux.win>, keyrings@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2026 at 4:57=E2=80=AFPM Lukas Wunner <lukas@wunner.de> wrot=
e:
>
> x509_load_certificate_list() seeks to enforce that a certificate starts
> with 0x30 0x82 (ASN.1 SEQUENCE tag followed by a length of more than 256
> and less than 65535 bytes).
>
> But it only enforces that *either* of those two byte values are present,
> instead of checking for the *conjunction* of the two values.  Fix it.
>
> Fixes: 631cc66eb9ea ("MODSIGN: Provide module signing public keys to the =
kernel")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/r/20260508033917.B5873C2BCB0@smtp.kernel.=
org/
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: stable@vger.kernel.org # v3.7+

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  crypto/asymmetric_keys/x509_loader.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/asymmetric_keys/x509_loader.c b/crypto/asymmetric_key=
s/x509_loader.c
> index a417413..0d516c7 100644
> --- a/crypto/asymmetric_keys/x509_loader.c
> +++ b/crypto/asymmetric_keys/x509_loader.c
> @@ -20,7 +20,7 @@ int x509_load_certificate_list(const u8 cert_list[],
>                  */
>                 if (end - p < 4)
>                         goto dodgy_cert;
> -               if (p[0] !=3D 0x30 &&
> +               if (p[0] !=3D 0x30 ||
>                     p[1] !=3D 0x82)
>                         goto dodgy_cert;
>                 plen =3D (p[2] << 8) | p[3];
> --
> 2.51.0
>
