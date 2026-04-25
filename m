Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499C81E2614
	for <linux-crypto@vger.kernel.org>; Sat, 25 Apr 2026 13:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777124087; cv=pass; b=dS+jAwJue55vY1YQOZa6fMTOTSkF4aGZNaDb6d6sh4X4CC8/eEdOhf61ZJ+T1OtVak1/yAnKHrLx/LB1akiMxidiKfb/YLIWsU5QrOYzaIeEhvbwKAb2FHG0wzEL4rn517Zb9rtznbWqVEtjVVYf/msJL/Tmeru5PHCfrDZjIHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777124087; c=relaxed/simple;
	bh=6Eo8A5WAsAtwkceGaEZbfQ6JIDCw1JyUvM2PU9cxYd0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S3suZ1GSVR+VSVwZWidAs4Q7qF1FsHTN9fD/N64AAxUpxNG0TNm/HV6ZMroGahG2C6xXqQk11krwDX2zCOqQSwl5dDlXdmQA+3mPtAYTKFHI1qquCdJgRPtonov0EFVy/icGT1t4KiCzN8Db+xxINkiZNAiMn2hE0qtft9j41z0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WBymSY8s; arc=pass smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WBymSY8s"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-6500f949a23so1028620d50.0
        for <linux-crypto@vger.kernel.org>; Sat, 25 Apr 2026 06:34:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777124083; cv=none;
        d=google.com; s=arc-20240605;
        b=OLk0b77L8zI4gFOdqh1hlTOx7eO/yT1BXQlvW3qsO9L+lwsqJpsrW2QPb9GoCx6AYk
         qTJ2mRIE43YdFARsgBLf/rY96yCEOSXJtnAYGkr77aT3tad2s9zvbzdapgKxbef/+kCH
         vVaFDPJ0JQg0FlV6/1b7SS7zCYeGCpF2QHQ7FSsHuVLr8TiRcfqOZrw6U4gvuVRGaMHy
         WMXaxPH6SLAdzyaEz9iPwUmU+r3WncT2shenoXGPt/eTTkS6c4vslJ9R16KQE+cIGEGB
         NsIKC7RXcriSbgffdm7hRYOZDOUcQGGdDe5AF4xmNYZ3O0Z8erykyqnmkVEw5AsuFBQw
         Lz1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aGQ1Nkb49nhA/wS/U7QyGOOaUJyCf1SaXvIle7aKzjQ=;
        fh=w3J4wHsvX5QplIUi39bU1e2byyrstCCUUwgZWGfB7hg=;
        b=C9EPxmx8++gZ+dlZa3PuB9aw/AMEAtPQQZ8ygMjN37NKd2lRFMqReYlGLr1p2BwweL
         LmMNS4hNsoeJTsoqlhjGFEJVuWj3iSJQpkPM8qoYKt3SHMvYVv2b7L1y4tFbOXSEseR4
         fyGJHZqaii1VMx9jx5ZsZz+avXUuu4/hafjsrVWTK8L2d/A7qHUHK65c7bisYbCtRPs5
         JUP3O5jLmDaI66XAP9izJ1t1aUajerVlZDLI3MMItIROpXZ3tG7gd5IQXkiGqCDbjPuf
         PsohVMY976dDMGFVesS6ABDktuoTYYYcGb3gntWSYrtJ92BHZ0CvhCLzG2rGCt8OVuLJ
         hYaQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777124083; x=1777728883; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGQ1Nkb49nhA/wS/U7QyGOOaUJyCf1SaXvIle7aKzjQ=;
        b=WBymSY8slZC2PPFxlwBuapv/aVSGyN7grFDPxpvYSmYWIvpEEWIh3T07CGXachox1W
         pElSG8c9rr/2GkXpvR+rnGozLxnc4Isaky9T0Byxn9DbEFeTUvg6cE352OB8itEYwe10
         a+WrUYfnrlbPvcnMZHUshflr9TshFi35rBPEKSS9+LLO+WJK0dPuHeUy7nJ6OoPRoQM2
         Ouvoh2JCyQ7j0+zDCyb96OUqtIKtofQp/nHVEVukZDyxjlD/pHhQQDPVqT6/8tESL4eE
         tzJG0Ve1f2U1OonLY+HZ4gRn6qPnp4YWUfiWZY/UGOSuydvXWWl/WXiLW6kwnQCgUY7x
         6NXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777124083; x=1777728883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aGQ1Nkb49nhA/wS/U7QyGOOaUJyCf1SaXvIle7aKzjQ=;
        b=mM+9J/RE21PCTuLqxTe68e13CqNSAYpzBbmU/r7hr4cslBye5EVeCC9JDrES71LFEs
         mS43Yrw7Djbq/xCS9JMx7ntG3LXFl9gG0LI6G+ZQAh0tTqIEmcewJrs6l5Oo63mYayS8
         mcMApmO77Ihh5o4GRA1tSwAQ2mdapOKF0lNykZsOuloCyMx+Y/76j0xvF8Fq1jGkXKKU
         zHK9s6Bi0mFbDfu3lL9JGTCL98nLFq2mUxaqMvvtkhHarF2+QcdtXvpTw9v0t00eplBo
         hZ2qLws0YNdjhaXErvvZcgTTiRevk6N8WK5Kq66/r8qHLfgbD+zAA75l/QsjO4dvYIzW
         jl3Q==
X-Forwarded-Encrypted: i=1; AFNElJ9I5lQ/n0irIa/xsbXL3MD0jdx55pWcea2k351x/LCcG3CPKM/0TJ+lk57aTSiRIcUz85lz3FpuQCBg6eo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCNguf1VSaUdhDfjOAlTWBIiO9Ve2ib8+qI0gh7bov2EE4M426
	o1cr+Fxc6rdRuHfo87q56X5RAzo9Dv5TSwx42eQt5P/7iUJslz+xj+eZwoLBzYFat1P6LyCDj8E
	kaaiE+g23fVQbUFEq/ISniZz3E5u/9V0=
X-Gm-Gg: AeBDiesC/U0WhY7kmVSa+2xaYK0PA/0ER3RecYCGugFS76rpk2b5vVofimv/9emSBwT
	LcRcrivt70TxJjHR7xfbd5paUiQkCi6M1HzAie1/zgmsNTcRoLXbFNGew+D6bea7qDuidQTkyrG
	2BBrFmzGh4OX3acIxteJOOBNQXj9DfF0ZNJwDEb4NkMcsxf+FPnAZ0TM8cCYMWZOYhD47mGvivU
	xpxK5yf0CQyQyW1gT+sTqzwf8Z40Ngc9619xeBRhMpGT/aGJ1L0j6JJ7478cN9W2y65xONpPGyw
	Qr50Zqeij34KymBsat+3yFqhPA==
X-Received: by 2002:a05:690c:6c91:b0:79e:631e:67b with SMTP id
 00721157ae682-7b9ecfc22a0mr233059967b3.4.1777124083091; Sat, 25 Apr 2026
 06:34:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422210936.20095-1-l.rubusch@gmail.com> <a82278e5-9b5e-4fb9-9e7a-800ef2898ec5@app.fastmail.com>
In-Reply-To: <a82278e5-9b5e-4fb9-9e7a-800ef2898ec5@app.fastmail.com>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Sat, 25 Apr 2026 15:34:07 +0200
X-Gm-Features: AQROBzCmsBuaXju-NqY78Bw0VoyzGEz_6XU6QAWYP44UpTkOPq9HD768Tc8rUWE
Message-ID: <CAFXKEHbc74tB1pxuDmw9z-HWBQiktwwbo0ciN_rHQn2Y2D843A@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] crypto: atmel-sha204a - multiple RNG fixes
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Thorsten Blum <thorsten.blum@linux.dev>, 
	davem@davemloft.net, nicolas.ferre@microchip.com, 
	alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev, 
	Linus Walleij <linusw@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ard and ML!

On Thu, Apr 23, 2026 at 11:25=E2=80=AFAM Ard Biesheuvel <ardb@kernel.org> w=
rote:
>
> Hi Lothar,
>
> On Wed, 22 Apr 2026, at 23:09, Lothar Rubusch wrote:
> > When testing the RNG functionality on the Atmel SHA204a hardware, I
> > found the following issues: rngtest reported failures and hexdump
> > reveiled only the first 8 bytes out of 32 provided actually entropy.
> >
> > Having a closer look into it, I found a (small) memory leak, missing
> > to free work_data, miss-reading of the count field into the entropy
> > fields and parts of the 32 random bytes staying 0 due to reading the
> > slow i2c device.
> >
> > The series proposes fixes and how fixed functionality can be/was
> > verified. Executing rngtest afterward showed a decent result, due
> > to the i2c bus a bit slow.
> >
> > All setups require selecting the Atmel-sha204a as active RNG.
> > $ cat /sys/class/misc/hw_random/rng_available
> >     3f104000.rng 1-0064 none
> >
> > $ echo 1-0064 > /sys/class/misc/hw_random/rng_current
> >
> > $ cat /sys/class/misc/hw_random/rng_current
> >     1-0064
> >
> > Testing RNG properties currently shows problematic results:
> > $ rngtest < /dev/hwrng
> >     rngtest 2.6
> >     Copyright (c) 2004 by Henrique de Moraes Holschuh
> >     This is free software; see the source for copying conditions.  Ther=
e is NO
> >     warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR =
PURPOSE.
> >
> >     rngtest: starting FIPS tests...
> >     rngtest: bits received from input: 1040032
> >     rngtest: FIPS 140-2 successes: 0
> >     rngtest: FIPS 140-2 failures: 52
> >     rngtest: FIPS 140-2(2001-10-10) Monobit: 52
> >     rngtest: FIPS 140-2(2001-10-10) Poker: 52
> >     rngtest: FIPS 140-2(2001-10-10) Runs: 52
> >     rngtest: FIPS 140-2(2001-10-10) Long run: 52
> >     rngtest: FIPS 140-2(2001-10-10) Continuous run: 52
> >     rngtest: input channel speed: (min=3D7.631; avg=3D7.804; max=3D7.82=
7)Kibits/s
> >     rngtest: FIPS tests speed: (min=3D32.273; avg=3D32.701; max=3D33.05=
6)Mibits/s
> >     rngtest: Program run time: 130177956 microseconds
> >
> > Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> > ---
> > v2 -> v3: Removal blank line, rebased
> > v1 -> v2: Removal of C++ style comment (I saw it too late, sry for that=
)
> > ---
> > Lothar Rubusch (3):
> >   crypto: atmel-sha204a - fix memory leak at non-blocking RNG work_data
> >   crypto: atmel-sha204a - fix truncated 32-byte blocking read
> >   crypto: atmel-sha204a - fix non-blocking read logic
> >
> >  drivers/crypto/atmel-sha204a.c | 60 ++++++++++++++++++++++------------
> >  1 file changed, 39 insertions(+), 21 deletions(-)
> >
>
> Thanks for the report and the fixes. However, I'm not sure you are entire=
ly
> on the right track here. I managed to fix the rngtest issues that you rep=
ort by
> making the changes below. As I already replied, I think it would be bette=
r to
> propose this as a standalone patch, and backport it to stable.
>

Thank you so much for taking the time and answering, I really appreciate!

Like two months ago I started playing a bit more with these Atmel i2c
devices. Actually I wanted to prepare something
different (and still pretend doing so). Figuring out things here, I
noticed this RNG feature did not work as I expected.
Around that time I prepared this patch set.
Probably, I was a bit too euphoric - I mean, it's a bit unlikely the
driver was upstreamed and never really worked.
I have to admit, I did not go thoroughly through the git history
first, since the driver does not do significantly more than
RNG, there must have happened a degradation. I'll keep this in mind:
first to build up better understanding of the driver
history. than to start digging into the code. Anyway, I wanted to get
some feedback.

> The remaining changes are somewhat debatable IMO: the leak is not really =
a leak,
> so I'd like to understand better what you are fixing here. The command fi=
eld
> changes seems completely misguided (unless I am missing something)
>

So, firstly in the current RNG implementation I definitely see an
issue. If that's ok, I'll to prepare a patch to re-init probably
rather
to what you proposed, since it makes more sense to me now. Thank you
for pointing this out.

Secondly, I noticed the device is picky about its i2c communication
timings. Yes, definitely. Nowadays, after having worked with
it a bit more, I'd rather say generally reducing response time is
probably not the solution. I still think I see some timing issue,
which
I wanted to better address in an upcoming patch set (but probably not
related to this RNG thing). Currently the AtSHA204a and
the AtECC508a (and related families) are sharing the same Atmel i2c
driver. This core driver uses hardcoded max timings for
its i2c command operations. Going over the datasheets of both chips,
both have totally different max timings.
Currently just having RNG for AtSHA204a and ECDH and related for AtECC
- it probably doesn't matter too much. Anyway, also
read and write command timings differ and mix up then in the Atmel i2c
core driver. I guess, this was kind of a starting point for
me to dig deeper. So, I probably will drop that i2c timing change from
this RNG fix set.

Thirdly, the "leak" I think is probably rather a theoretic issue. I'll
sepearate it out, think over it, and in case prepare something,
let me then know what you think.

>
>
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -47,8 +47,8 @@
>
>         if (rng->priv) {
>                 work_data =3D (struct atmel_i2c_work_data *)rng->priv;
> -               max =3D min(sizeof(work_data->cmd.data), max);
> -               memcpy(data, &work_data->cmd.data, max);
> +               max =3D min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
> +               memcpy(data, &work_data->cmd.data[1], max);
>                 rng->priv =3D 0;
>         } else {
>                 work_data =3D kmalloc_obj(*work_data, GFP_ATOMIC);
> @@ -86,8 +86,8 @@
>         if (ret)
>                 return ret;
>
> -       max =3D min(sizeof(cmd.data), max);
> -       memcpy(data, cmd.data, max);
> +       max =3D min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
> +       memcpy(data, &cmd.data[1], max);
>
>         return max;
>  }
