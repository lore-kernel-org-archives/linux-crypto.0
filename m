Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7541FC7C5
	for <linux-crypto@vger.kernel.org>; Tue, 17 Feb 2026 10:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771324532; cv=pass; b=LwIAmQTgc4tczOO4kRBuBzS6AxN3OJSoQwKMNL7X5gJGQz8usMvQmpdRoUjjfX/lBQ4dkCY6pXJ/NSf/e4jdhuIw1hGFLOAFiozP0ck1sATbrjlFQGKuusG8unNFlNxI9KVJmFT553DvYBSXZauyqICtQsi2uZ7417zmDRDhTZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771324532; c=relaxed/simple;
	bh=hQ/FqnZ9bKw+6nwRHG3ZTJKdNXpanN5b0OW3+szbKJ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DcDdA04dyBaF1KNr83w6YU2etPp7JDkilt6jJ8R3HFXnMCfntKmFbNjz0meBcbzxQg8FqhCV8PFlQ+qVuMxF2gTNfS4xKsRHoKGjq2jRW44MPkfzoFaAf269JeFf2qRQx56glC7MTNmsSeVDlwDeAJi596Rlbgpf5JXFAH4TzPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EgBlfZ44; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EgBlfZ44"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-649ba337157so153566d50.2
        for <linux-crypto@vger.kernel.org>; Tue, 17 Feb 2026 02:35:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771324530; cv=none;
        d=google.com; s=arc-20240605;
        b=EWd9U9J014vPUxw6okYaWzkaxBkxb/0AeqbkgAnoDGEYNggrurfqFStUdJ6FsUV3F2
         1u2b2yhr1MIs2gaH7uXglKxe8XVG/mh2LgmsWE2v6zgN0i1f8LmkOqLLVPgFxv3vj6Qc
         4504zRM2glvbdoOA5BX41HS+X07X0VUXUFsNil7pEphpJuGkmNLs7VU0BaaWVQqMfCTk
         V9vEM9xhLKJoxvkFZ4ZfyBc2KDFZQWYoNbHQviPBz+bvW40A9tC9mJqGKV9PqHp30jbU
         cLT44ggpPeepP9Yb1yhfuxNlNVvTKPMyo94ToNrBuiv1GWfNP0+cJn2HFqu7I6ezmYSv
         heZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Uo6JCEeQIxQJPR/F/WxTJBoUZKo4YM7XMzFICKJsqXE=;
        fh=Ma1q1VeW5F2h30bJnZJ9Q6vnND2/p0EbYKpPB34biYk=;
        b=KAH/uIzx7JLQfovTGiO5cLwaxjfrAyd2QVcjz5x9nM8jd+RM99EzxUamQzDSQC2k5G
         RS4tsuM271ED3GE6TNGt/bmjteUM1NfAdP2yHjVaN7fz8aO72q0VdRlZAkz8RX+AEx0J
         ejTGADXYJDJrpQIyx7qUwdAnWU4nbJtXfFE0QbsRJkdtrj2ujAMqDzM8BArRHaAQZ2sb
         CQ+CZ6NSnvyFZ28dWYXOmOzFTQWFPwr7uccV31nWfK/8Vy3l+of8EW/T6l57egHhqm/Q
         b2wbmlpR2pCdEIuccd8U8dbH5JDSr6fBTrYcfwBL6I3GQI+Mx8xWlkdjOlWNqf6FPcnm
         ZOsQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771324530; x=1771929330; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uo6JCEeQIxQJPR/F/WxTJBoUZKo4YM7XMzFICKJsqXE=;
        b=EgBlfZ44TKAVsRNIWRXtLTs4YKdfVcek7m4w4lc6E2M22Q0r5g4qWAG5nZIs4mSa56
         5ugKCZBzu5v+/FHoWrxvMkCvhkxFu0ZgpPXQETMlNPSBpnmhYJPi4XdS60mDljF8veJD
         J6OMMTOtiVT9K2sIwgGcrR4gTEFntxQ+aO7+zVfhGJ1JDWnEwV4Ce7Uz15pG6Ut2Pujq
         /RRajVbYgUz29qYaN0LRJN+xczInUlb+qiSJEfwOpNwssUu6zOCLV6APta73BueT/PzF
         H46yVyTFElIbLXklgR0RMcNXe6/pKqggHgg4wfjQHWgHPa3wZw5/rLr48xeKzxnNvpKi
         SLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771324530; x=1771929330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Uo6JCEeQIxQJPR/F/WxTJBoUZKo4YM7XMzFICKJsqXE=;
        b=ks6tMEvcXa7HtSV17imhhDp+oq7raV9kGrgqB3h09J0JEHbj8aeJ1LB887MUaOrm8o
         H7wZDZD1BZUmlgl9TktRVw+cNwofsdKfJvl1Ifd4yxFSTcYxv6vUQmmMg7A7mO+nSHoF
         8T7ciRcdAtfyPhK76yXe6pmRsE77iywDmAN++YhIKT48/SZbzaP/Qfnn2hRXeybBGa8P
         Dj5f+kA/NEfrr/4fhVcZjlRuyfDDJtPR20hTuiY9LyFzdXJUx/YsasoRuzQNOWa4iXCI
         B/Ip5NCDf54lDcXsiPvxcoWs82jfkp2jQNAJ2MsDrZMx86JEMkrqLxRjvkZTjHohDNpM
         ToMw==
X-Forwarded-Encrypted: i=1; AJvYcCUDqpXLoCG8RSmKQu2SvZEC8wIl/oatY//MCvpJuuEeajHa8F7YxqWW/2xlo7xWt90dgnv5Bf+yaRy4cd4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQuGN78Y52RNh7lmwaZEj4NU8ut2FkT3LYO4prMTfQhxMuq+Qw
	zX3NiMZjHk2N712Q+drhcuOMB1M4Bvsfa+njTOQOosKtdn8tHuvcrObWN6ieoSEVrWQ+u+OoyX7
	COAVj8IYJj0TOHNf5c8yz9J7RzTPQyvQ=
X-Gm-Gg: AZuq6aJwG+tfbpu0yH8C6W9u5XaeOHx8h3fOBFF9L6ibyXifluL1XDeS5w2qUgndKKZ
	6TVvJtkVusZ+VfHa/53Kpmr9sYXmThOSO/TlcINoB3FkarmBNQr27IfUAJxJYvQTDpfMzlWZIvg
	gk3+JskjczWOXoGgutoekKL5bczRheqQGeyt0FF+vxbt++jjTc9MwAWlrWUy2yrL7jFwAmK894r
	DGa8h/k908K/8oEdA49bY/QcGy9bMIoCSsupwuFK++x0iCBZp5rW6YftbxNpQt30+myoDh0M387
	smpNZ+hd1Sphhqk=
X-Received: by 2002:a05:690e:1c1c:b0:649:f09d:a6cc with SMTP id
 956f58d0204a3-64c14b29c19mr10556977d50.1.1771324530052; Tue, 17 Feb 2026
 02:35:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260216074552.656814-1-thorsten.blum@linux.dev>
In-Reply-To: <20260216074552.656814-1-thorsten.blum@linux.dev>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Tue, 17 Feb 2026 11:34:54 +0100
X-Gm-Features: AZwV_QiWJubl1SYRemd2GYIh64zSBa8SJWZKFL5Plf5tVXdnNSQH30MoF3bKYeE
Message-ID: <CAFXKEHbveJdNM9gEiJ5P4kExvFii=V7KtP4TnQLVve5_3FheMw@mail.gmail.com>
Subject: Hi Thorsten,
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	stable@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 16, 2026 at 8:46=E2=80=AFAM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Fix otp_show() to read and print all 64 bytes of the OTP zone.
> Previously, the loop only printed half of the OTP (32 bytes), and
> partial output was returned on read errors.
>
> Propagate the actual error from atmel_sha204a_otp_read() instead of
> producing partial output.
>
> Replace sprintf() with sysfs_emit_at(), which is preferred for
> formatting sysfs output because it provides safer bounds checking.
>
> Cc: stable@vger.kernel.org
> Fixes: 13909a0c8897 ("crypto: atmel-sha204a - provide the otp content")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Compile-tested only.
>
> Changes in v2:
> - Return the total number of bytes written by sysfs_emit_at() after
>   feedback from Lothar (thanks!)
> - Link to v1: https://lore.kernel.org/lkml/20260215124125.465162-2-thorst=
en.blum@linux.dev/
> ---
>  drivers/crypto/atmel-sha204a.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204=
a.c
> index 0fcf4a39de27..8af767f903ea 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -15,6 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/scatterlist.h>
>  #include <linux/slab.h>
> +#include <linux/sysfs.h>
>  #include <linux/workqueue.h>
>  #include "atmel-i2c.h"
>
> @@ -119,21 +120,22 @@ static ssize_t otp_show(struct device *dev,
>  {
>         u16 addr;
>         u8 otp[OTP_ZONE_SIZE];
> -       char *str =3D buf;
>         struct i2c_client *client =3D to_i2c_client(dev);
> -       int i;
> +       ssize_t len =3D 0;
> +       int i, ret;
>
> -       for (addr =3D 0; addr < OTP_ZONE_SIZE/4; addr++) {
> -               if (atmel_sha204a_otp_read(client, addr, otp + addr * 4) =
< 0) {
> +       for (addr =3D 0; addr < OTP_ZONE_SIZE / 4; addr++) {
> +               ret =3D atmel_sha204a_otp_read(client, addr, otp + addr *=
 4);
> +               if (ret < 0) {
>                         dev_err(dev, "failed to read otp zone\n");
> -                       break;
> +                       return ret;
>                 }
>         }
>
> -       for (i =3D 0; i < addr*2; i++)
> -               str +=3D sprintf(str, "%02X", otp[i]);
> -       str +=3D sprintf(str, "\n");
> -       return str - buf;
> +       for (i =3D 0; i < OTP_ZONE_SIZE; i++)
> +               len +=3D sysfs_emit_at(buf, len, "%02X", otp[i]);
> +       len +=3D sysfs_emit_at(buf, len, "\n");
> +       return len;
>  }
>  static DEVICE_ATTR_RO(otp);
>
> --
> Thorsten Blum <thorsten.blum@linux.dev>
> GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4
>

I took the patch as of link below. I verified on the before described setup=
.
https://lore.kernel.org/lkml/20260216074552.656814-1-thorsten.blum@linux.de=
v/

worked, LGTM

Reviewed-by: Lothar Rubusch <l.rubusch@gmail.com>

Best,
L
