Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E63C428463
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 21:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772140967; cv=pass; b=sQayv5S+klhW9xRJgsSZzoPwpdFSMiGHae9iZe3Xc/1nTh9rUID0h/fTszJIVaM53NL9f3IDw3+iDPS/yczTAoIVxYaAl0tODV84wP95xeCbrA4c3dTzozPrG9J13Bq6bnCq3kk5Fh1fxDwF2D8JugokBIjdb/9LncwVMSLVYSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772140967; c=relaxed/simple;
	bh=ivaSk08hsOQ+TfXEHtIOfQ/rw2QIDNUh0XWawt6aHAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SdQZDg+sr/sbtaFmekRqQXqiy0VNzpZT8a7BOutL6m03KJvPwAN4bhKFlbKymlGUQKkAwecVpyMIzw0Xwfhp4/RIQsl4psRduGcUfMsnEkb+WtfqSvF4FWcAnK/OvVL1RWqUIJyxb+4b1Mfrs8B2X1buq+ICfzKL/i0h7lko+Aw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KcTg4KAQ; arc=pass smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KcTg4KAQ"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7986b4e59d1so1449947b3.2
        for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 13:22:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772140964; cv=none;
        d=google.com; s=arc-20240605;
        b=PULSVMk0MpNOsa/I9EdjKTcYxH/A4sam32m+Rw1E0YvkcjZv0pFZcdw6nX75Xcf6TI
         KR3i/hd/ZUqBtG+UmS4XVF3yyeI+6+Gs/Dao0KkpltzxWjOgJdNWQBBEy3fLavwhsND/
         pB4xdeKvkp0DYTRrFHvorlP8EXEwdNax/iANlNXtL89q0i+h9WputTGysH/fm2gThny8
         CtAitOpP+Ay96kR9EG558RYH2jHjSCiqOykIrJUzHAahihZ1sScWWq/qJM7c+eofOBOx
         SgXPzWVXVx2/veGVsHDkmA3vV08KnZZdMhUkcAPjhOs7u4qdZEtlhhh2yMOQcGoSEopl
         GL5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JB4+0Jjmsb7WCQkN35VAE3lNJIaVQsTkaWwYNjZ0X0I=;
        fh=HmM/K7MnQASmVX2/mbKSwjZhEFhJOLeWEiHLEnA9osI=;
        b=WHSxxZNG/etKlI5KgsS+ls4GaDA1weBXrfxq+XNAO4WF9DlXMcqla1iY58Nka3d7M6
         QZZ00qRM3GuS8Nr1hu8YEtpvFspVBas95Va6/nryqEQ9F+uBdufAjh3XPM9/Q1D1eSrn
         is4lhGOWlla4Yuen0fwyIGhOq7JS52bCeC1Z0rBsotnJWRr67uZ4qFG6Dmkw/NG7Xwyp
         5gC1/WuQVpaeJP4Iv8+zWJbqRn6poDuxtqEEMRm5iA/r/fff9EwaO9debosia8XqYh80
         JGWYf+dlCHXwbPxiozpoyxjeqqdkP/66WiqiCyET8aWMLeuXWkSjxmu+ima+hz1vHFr6
         wLww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772140964; x=1772745764; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JB4+0Jjmsb7WCQkN35VAE3lNJIaVQsTkaWwYNjZ0X0I=;
        b=KcTg4KAQuH2dAQInBo4qSx7S9AmZ0QJO7TrzIofQaql1R/aciIGi6yWC75nTksszdN
         dt0UinD/NhIQLPDfI/OdTEbfT5uWjy8FIk0Y5c3dh4K2zgvSntImkGUi3DYZMfT4dDAZ
         VaoJp1TW2NZzP0PjE11/S3BGjqm3Vuv76msbV4JRQLaXNOoco0rgt6AMI2Iv7FL0zZD8
         bipIWSG3D6YkFqtp3XjaPYtoq2qFxePTXCvU8y6pq5xtZpyUoXz9lQE7595fPTSZwksF
         MVNNUVA56ZRycP+LLv47wziusX/ZYcUwfanzNQn6d3F9aBJ9OyrtnJk7fzL3OCoRfNyb
         jxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772140964; x=1772745764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JB4+0Jjmsb7WCQkN35VAE3lNJIaVQsTkaWwYNjZ0X0I=;
        b=iSM8wIQHJBPifMz8V2JyYEMHSha0bv0Dxq8tHeKNwey1WvP8IAg1JpJgMTb/FbjmJP
         whr7bk7LcVpbeDxHqqU5LFD1otVaL3CYhjxt0GmKqKGEFe05CH+W3DR9nwUYXs3e9pbH
         +9VATEjjezDurRsTeW0RW5HEZI5k22Aib5jWzD7yusitvF+t3dC30YnF5PLVTqXgmObn
         lTpjXvqQG/QwaB/CqpkthFQqr12ExTZQYh4oimCZ71ayVRzFFK861/e0W+uQU18+N2By
         Cu+vlJ3DyEMXIEu54sxZTYrOtLxOLFbg/6Y+Dm21wrnjvR/ka4frzKmvg2Z65sacZFEQ
         7jWg==
X-Forwarded-Encrypted: i=1; AJvYcCXyVji05Jhk9FhPfXObdnC223oUJywIPKhl7MUFG7f9U5QEdU0f7f6jn3ey6lX46QBLBy/D86ZGNBRhmJI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2SiVfvk+kqOnAkrssb1NQyYNGAc1sQIvDkpw0OwY3ngxE2BwA
	2RgfyD3Rs5uEKcfL3trtTvf3o1n70sYEDvKCtD+MJuVwfCgEtmW53ACqMCmuH+Dj1jj/aS0p2h0
	EyML+RoUIdBEu+FuKbtixs3R20j2vdgw=
X-Gm-Gg: ATEYQzw3FFJxZ2WSp5DStCnoioZUv70l4IREsgU4gtx23mr6HeiBwlCIPTzPR3FQ9SO
	WiiVg9vrFRLEC5Qjm2wwjEy2dUEjS7OoRjy7vu4tdQkYr0fo5XGz+LebvQ0yJGbKtuv5jnuOZU1
	RyEKXLu01rOkjpWIN+w6y+WS3AATTKgvxAjeQg6OtkDzAVLGt/6Qp3SFXDZ0qnFSldJm2bH44Og
	jp4AR73VmhHUQaopRr1FZAZADZIKh1CXqJu9h4DU+QqWPDJl2/RcpU1+RtaKW+nfO5e6o4howv9
	bPSe
X-Received: by 2002:a05:690e:1596:10b0:64c:a2fc:807b with SMTP id
 956f58d0204a3-64cc23341c0mr449268d50.6.1772140964164; Thu, 26 Feb 2026
 13:22:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224225547.683713-2-thorsten.blum@linux.dev>
In-Reply-To: <20260224225547.683713-2-thorsten.blum@linux.dev>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Thu, 26 Feb 2026 22:22:07 +0100
X-Gm-Features: AaiRm52It-aXFcuLq__go6bqOZfdSs9Bh4efwCHuAs4dMiL1mpRRlFj6QRKv3qw
Message-ID: <CAFXKEHYTZHT1sX0rNhbZoG40eEkn2B1Utrx+9Jn4a580sGj7Ew@mail.gmail.com>
Subject: Re: [PATCH] crypto: atmel-sha204a - Fix OTP address check and
 uninitialized data access
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	stable@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Thorsten, thx for squashing. I hope this goes ok with the maintainers.

On Tue, Feb 24, 2026 at 11:57=E2=80=AFPM Thorsten Blum <thorsten.blum@linux=
.dev> wrote:
>
> Return -EINVAL from atmel_i2c_init_read_otp_cmd() on invalid addresses
> instead of -1. Since the OTP zone is accessed in 4-byte blocks, valid
> addresses range from 0 to OTP_ZONE_SIZE / 4 - 1. Fix the bounds check
> accordingly.
>
> In atmel_sha204a_otp_read(), propagate the actual error code from
> atmel_i2c_init_read_otp_cmd() instead of -1, and return early if
> atmel_i2c_send_receive() fails to avoid checking potentially
> uninitialized data in 'cmd.data'.
>
> Also, return -EIO instead of -EINVAL when the device is not ready.
>
> Fixes: e05ce444e9e5 ("crypto: atmel-sha204a - add reading from otp zone")
> Cc: stable@vger.kernel.org
> Reviewed-by: Lothar Rubusch <l.rubusch@gmail.com>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Compile-tested only.
>
> This patch combines [1] and [2], as suggested by Lothar in [2].
>
> Lothar's Reviewed-by: for [1] has been preserved.
>
> In [2], Lothar questioned whether returning -EIO is appropriate; the
> exact error code can be adjusted if needed. The errno is currently not
> propagated to userspace, but [3] changes this.
>
This was just more curiosity, nothing to mention.

> [1] https://lore.kernel.org/lkml/20260215205152.518472-3-thorsten.blum@li=
nux.dev/
> [2] https://lore.kernel.org/lkml/20260220133135.1122081-2-thorsten.blum@l=
inux.dev/
> [3] https://lore.kernel.org/lkml/20260216074552.656814-1-thorsten.blum@li=
nux.dev/
> ---
>  drivers/crypto/atmel-i2c.c     |  4 ++--
>  drivers/crypto/atmel-sha204a.c | 11 ++++++++---
>  2 files changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
> index da3cd986b1eb..59d11fa5caeb 100644
> --- a/drivers/crypto/atmel-i2c.c
> +++ b/drivers/crypto/atmel-i2c.c
> @@ -72,8 +72,8 @@ EXPORT_SYMBOL(atmel_i2c_init_read_config_cmd);
>
>  int atmel_i2c_init_read_otp_cmd(struct atmel_i2c_cmd *cmd, u16 addr)
>  {
> -       if (addr < 0 || addr > OTP_ZONE_SIZE)
> -               return -1;
> +       if (addr >=3D OTP_ZONE_SIZE / 4)
> +               return -EINVAL;
>
>         cmd->word_addr =3D COMMAND;
>         cmd->opcode =3D OPCODE_READ;
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204=
a.c
> index 8adc7fe71c04..b0480d3bec70 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -94,19 +94,24 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, =
void *data, size_t max,
>  static int atmel_sha204a_otp_read(struct i2c_client *client, u16 addr, u=
8 *otp)
>  {
>         struct atmel_i2c_cmd cmd;
> -       int ret =3D -1;
> +       int ret;
>
> -       if (atmel_i2c_init_read_otp_cmd(&cmd, addr) < 0) {
> +       ret =3D atmel_i2c_init_read_otp_cmd(&cmd, addr);
> +       if (ret < 0) {
>                 dev_err(&client->dev, "failed, invalid otp address %04X\n=
",
>                         addr);
>                 return ret;
>         }
>
>         ret =3D atmel_i2c_send_receive(client, &cmd);
> +       if (ret < 0) {
> +               dev_err(&client->dev, "failed to read otp at %04X\n", add=
r);
> +               return ret;
> +       }
>
>         if (cmd.data[0] =3D=3D 0xff) {
>                 dev_err(&client->dev, "failed, device not ready\n");
> -               return -EINVAL;
> +               return -EIO;
>         }
>
>         memcpy(otp, cmd.data+1, 4);
> --
> Thorsten Blum <thorsten.blum@linux.dev>
> GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4
>

I compiled this patch, loaded and unloaded it, sysfs entry also still
working. LGTM.
Reviewed-by: Lothar Rubusch <l.rubusch@gmail.com>

Best,
L
