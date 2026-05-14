Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE60E3D7A16
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 07:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778743227; cv=none; b=EC9Rs8PAvP9wGlzaSz9RDsrz9siDyBqrdizCof63haY7f5OODiL4dMZ0wTxSNRH6WQqHErQvpY4tXjCqe9V/Gt5+rkbrUw8Nbf17y7V4pdD4UOrT6ibcMY3iJgV2rEc3Sm+1G8JjuFtEU7GlZnaRltFcJcNTrfJgW23E56AGncY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778743227; c=relaxed/simple;
	bh=E6RssBBmAqBzFjzTCkj4CSOEJNkyV8OLPtr7KQ6b734=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PEXgvranJKjQwFp1131FPrdWA8CPpnrwGoORr01Vo3fpp/JQ3BQMf3dsXbNOJ1xCG0udFEAZUTzo2f5d77CK0Jvx7Rqi6iQN5lWifgPPeUuOh2/vYG5gG7MiyxShLKcZgO4CsHO4nE3mrigaV1ixu1MBrFDVm7IEaN8LdoP5qMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-67929ff6dbfso1509849a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 00:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778743224; x=1779348024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7B5MWKMFLrmoGLirIc8b2/MwxqSJztL07xc8VW1aWxo=;
        b=gCcgz56bDup/xd1dMCj14Mn791xdv832AUy38UxG/IZ401BOY67wxkpzT2e4TeQlKR
         EkQ7qOmGSyi2+6WiLnCmwpKPTHslWmq84vZ4bm6pH9J8g04kt+dvrw/aoK9rniub9J89
         er5+BYucBwrR9TZSvth9I/0tvgaBUtuS//xOkgK/iFxy2xFm9+m1lrsnEbSJGY9zAqqi
         EK4V8PRUGT0UtVIZUijgzSBSlRS+g9B/GOIEaUrPAmq/o/+ZtD5mb8Ro43Zuj7JCkOn7
         iHJzINRvuMk7qw+kPalSASMB1psCQIplSoQSgScCXaWUD0yDg3P5tnR7+KGMEA5G9qqI
         kC/w==
X-Forwarded-Encrypted: i=1; AFNElJ94D+oO3sFBrda7On/V15804bdkFoGiT5lj65VyxxQZpV1gGk1Hd0RaqKwlcfGLXmtKL4op8m9McEatsFs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA1ohjW46w7OuLpYNOv/FjHQekAQxdkIFYjoqtUq3Y9iv80a7J
	UZjbc7ODfMfWKywDnvuTA1Gq4OHXDF7wJ1keOHO+okF97E4D/+1UuqUCGIq/Ytv4UTo=
X-Gm-Gg: Acq92OG0e/FliVY9+yEtEyJu5fLWmFODZOCIOpNxz9U4qsNzWw+HFnq9mc+CVLGvnq1
	bchpV6GmB3zvBzXVBfn8A+MjjhLdU+3+YhFGrCosKLTDYZy3faOr8qzsm1h7rEd0Lrp7N6vCdKW
	oxRCQ4OSbPIUL1EfIEMGiy1G2e0/fHtqQ462rxQJZchns/ecuXXMU2byRJpp2ofnjRos7qsnwgy
	cA7dJC/eF2SD0iibJ56PIhjiNqlgH7Ft10lE8f7AD4gKIHOP2PIFU6nXv7f88c5jySssTVemfky
	U85M8BA7eFwKKZgZqfg1ZbBBybFFes4faAFczp2bd28/W7sy0WosQUHp/2fPqcxLc1Wyw5GlHDD
	LBdLvWdcBLuoPyO/xbqjb8mcuqI1vbiluFzEgTsgUMnk6bFZueTS8XjSXROqQHR6udq9soJg3aj
	vK7x0BbX5Q5YMfbkPdLc+eMoPfGiYDVRajmUUIvmRXf1vqC8Fwt7+1kNDjzmGaV2E5
X-Received: by 2002:a17:907:96a6:b0:bae:456f:fbb2 with SMTP id a640c23a62f3a-bd3e1d2e6d5mr405955566b.23.1778743224389;
        Thu, 14 May 2026 00:20:24 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4bcf7f3sm58811966b.2.2026.05.14.00.20.22
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 00:20:22 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bd22b2abaa4so503569266b.0
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 00:20:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9yXOrKvvEKhO0lQXr5k5N/wbNOMyAKFqZZONHUBVDkGZobbP1AEJdmzEX53G5wse7T2/f7m9p0dELQWos=@vger.kernel.org
X-Received: by 2002:a17:906:dc8a:b0:bd1:e2db:f0d6 with SMTP id
 a640c23a62f3a-bd3df57e0b3mr363059766b.5.1778743222610; Thu, 14 May 2026
 00:20:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <782bc59d5939aa69b58cad42f71946f1c0a6dccb.1778741457.git.lukas@wunner.de>
In-Reply-To: <782bc59d5939aa69b58cad42f71946f1c0a6dccb.1778741457.git.lukas@wunner.de>
From: Ignat Korchagin <ignat@linux.win>
Date: Thu, 14 May 2026 08:20:11 +0100
X-Gmail-Original-Message-ID: <CAOs+rJVQj=dyEwPM8ujD8pjRwufwLRjZtq7nPVyw4q9e-ryC0A@mail.gmail.com>
X-Gm-Features: AVHnY4L2fQW0KVM2kvDv2OdU52Z0W7UgO7CoJj1AAZsBE1bEz9lIfLFwU_zoRZM
Message-ID: <CAOs+rJVQj=dyEwPM8ujD8pjRwufwLRjZtq7nPVyw4q9e-ryC0A@mail.gmail.com>
Subject: Re: [PATCH] X.509: Fix validation of ASN.1 certificate header
To: Lukas Wunner <lukas@wunner.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2026 at 7:55=E2=80=AFAM Lukas Wunner <lukas@wunner.de> wrot=
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

Reviewed-by: Ignat Korchagin <ignat@linux.win>

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

Whoa! Nice catch...

>                     p[1] !=3D 0x82)
>                         goto dodgy_cert;
>                 plen =3D (p[2] << 8) | p[3];
> --
> 2.51.0
>
>
