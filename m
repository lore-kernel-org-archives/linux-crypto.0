Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179CD3112C9
	for <linux-crypto@vger.kernel.org>; Tue, 17 Feb 2026 11:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771326102; cv=pass; b=Taca/4fikYBBsoeepHITZy+evnVk7YDBDZBw0iKH1tSuIGK9tpy19dJpo28v2Vb5OjWoiIvO4ZEMca64Vey2obxqiPOLeRafHLM+/NONJZH1a3qwt0Z/X5pnSo0N7MsOYHiN4EOfzNCrgGD4sbVMY8y3Z0e4r5dBUk9yu5rADkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771326102; c=relaxed/simple;
	bh=NejZiV/V3YzcLdOEsrDKIlM3Cm8jcTsCrNvnU8CR6xU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l3xDWSPrH/eQL8NZ4Bx/qPnYqbgbUls4SmjGVOlSJSiyGatKecDxDyoRy3ynf6B1K01NbM53fHBtw5GtDpz+0ZCaoRUHhYeeVpIY4/tHufYCJJ2Jj+wMN2X6rLjaZ4X4p2gwGNdi0OdDSiA6d7ZBIOsfS/OVQtsvDq5y+6luhDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WB/iGyuJ; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WB/iGyuJ"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7968b6f6dfdso4582287b3.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Feb 2026 03:01:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771326098; cv=none;
        d=google.com; s=arc-20240605;
        b=X9xG4oNveRJcB877CV8lcgsg7QiLOxrPt4d7NMJhQfBGF5g6vZU/C6UDAkGAMsAavL
         uJDtvbL1RVOaLqILfNp7y4DM1AfZqqIQ4f/WTpdjphfJsdPxSNVZeIDv10ml56W4bmjv
         TvGdAN8+NtWIqwAwogMG1XrVw0qE0Ms9X3Q9St8oRaCcva5Tv9Pj+Q2SDPMGPVetCx5g
         wZQQ3pxYvJGfsOoAKtPlJCPDZ+vpCpTsXx8KclCtMsYbmekNt5M7ncNOuIgZvUfoshV+
         ykFiDt17XeUjzq94n8pHosU6n9BFsjA+bN32oMGMc49ENbI1x5f0VQBZnGb6RuNV/Jkv
         avfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lNlPguOObx+yXshPeTIquRndnBus7h4jAK1vKKf010E=;
        fh=bfvOhyLvIOWJElk8Fp3xffruF7v7EgWwFC3fNg6j9cY=;
        b=BQJWrAKIUdyyfmeSJJ0KVP4pcHperw7ci5mV9zl7kqlTvOWNb9loBTFvv7qfWUAjQK
         EB7spHtgQz+fYG7iYKk7XyR5NVPOhS9NlAnMsLVww2LnE7EM3G2bdDCVpo+Jboe6HnA8
         UyWk8r/CzA7QkPJZkw5E5WhASC4VYUC45/DXe2xjfjIchEz8IKNVl/wZ2kA0BGgtqQ3/
         zdtL4cpnsM3NcCodgPTHuVcddrFexFjxlZ5RUQRFTRHZea/zXcS3Cxbn8ImV6/7htQgF
         Yj7O46Q7waairn0izYNJINRgs60qgMOwcZ6Pa512GEIDoc1J5JipDKATndYLBb1fPA1m
         f+cA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771326098; x=1771930898; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lNlPguOObx+yXshPeTIquRndnBus7h4jAK1vKKf010E=;
        b=WB/iGyuJW6p7cB2vylJaCC0PyE5AAIqvDkktIm+UAJKZeojOKob6paNG7uhr1StEo+
         JYylY50A7PiKGCH9GMFZBY4vad75ufeE9wNKBUnqOpQZAe+fp8KbUQuuS4A5QpTxT8Kz
         s5IUSTWBXTyPV9KWmsca5fZTaD62J9iT/V5Zq7ilgxoz+orGyQzN8hIZXt1xMp95lhBQ
         skdOWvqCFCWxP64dKx4iERmUh5gOq0xpBVhnrAfyvdrfjpJKtn5/tt8otXuxQ2Myh1Ph
         9TQyGTKY2lmxHeRgmequFggg8qFHgYPBEKBAivYVycDTYWzQ06ceTxSqNFFuRcAz19DR
         SQsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771326098; x=1771930898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lNlPguOObx+yXshPeTIquRndnBus7h4jAK1vKKf010E=;
        b=P2/iCLjsqNWebuhKCuvYTB1fzu9XFnyt4cIYtuNSxncYgvKsGyvYnf+UI9x1qHEaoa
         A0nqMLz0TVfk9wtDrKGXP18VYgcqvSHUTT3Ac79tywT+Hqztai9eZrLkr6lBrRCLbQm8
         c6ENAVuFlN5PKo6rTzhW7jhUCtIQvBG8d5IIogNoveLva+T7onBfjTFJu71EFZEtWKM4
         0SjOWdhYUMaIcBtQVwO0ACYEeP3qtvLQLgIukfnUuhcJwqoNF9Kaiod1qVlKskOrP7Wr
         s3cN5sxn5jbf6uqtxvyf93rvMztTGCLJpJEom0Ulsc8z27gV5s95KdG92B9WwTanXB6z
         /ziw==
X-Forwarded-Encrypted: i=1; AJvYcCUCMP8DrP4cAOP9yTw98iXDaGKagqW95t8YwC+AsJxWxc/enXwY4enXMB5wcigy8QCOjDVuIVQMs2xeVUg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkMUijqL8u2vQY6+7oRLHnqYqowG3fOQO2gj1XNsgfC77GaYdC
	Ke9Whl4U1rBpeuIpIEm683PIS1bc5QvNNns7OtsmS3ctwM/5NSlnESbl0K45q0V9elrgjrzSzez
	epsGLiTtbuVWamh9un2hbpNa2+A+QFTw=
X-Gm-Gg: AZuq6aIjS4u0bfj5D+HOmnPK1W/UYjvWxGIJgn91FZX5zyo1dkmYZydK/Mw9HrttjBR
	/5weSfTdrc4KblKLPtdRszMQhF/tTWu0c52F2F9HUYgVsNVnd9npkt8S5yc/XlwSsm9f9dFSGsz
	Eh3QxanN4g6VOInlZxgR6fW5IB5VxG/NpVDBFu7d1D+WG81KUkkO8uNc+6fSQox8xxI0IDKnNnF
	ItMX9chHaCrbFTve3Q5KlCUtvIiw+2LN6oPVzO6jQH9pV7DDkeyjbM5z+DBKSskvPJiuMsiEid0
	W+35Yxa6nHcB2/w=
X-Received: by 2002:a05:690e:4004:b0:649:bf2a:71d with SMTP id
 956f58d0204a3-64c14d8c91dmr10695377d50.4.1771326096397; Tue, 17 Feb 2026
 03:01:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260215205152.518472-3-thorsten.blum@linux.dev>
In-Reply-To: <20260215205152.518472-3-thorsten.blum@linux.dev>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Tue, 17 Feb 2026 12:01:00 +0100
X-Gm-Features: AZwV_QhRbxpAvpo2UBR8-Y_jstIAD1Nkb3C6Xx--Z_yv-x7ERa_X4u_C0YYTw2Q
Message-ID: <CAFXKEHbzStf-8egh4QVdxz6MmAn_fBh1A4G-sb4gg+pxU9Qdkg@mail.gmail.com>
Subject: Re: [PATCH] crypto: atmel-sha204a - Fix error codes in OTP reads
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	stable@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, the change works (doesn't break behavior at least) verified on
hardware, LGTM.

I remember that time we had a small discussion on what is the right
approach with the return
handling, and at least me was unsure about it. If this puts it
straight I'll take it for me as take
away. Thank you Thorsten, and sorry for the fuzz.

Reviewed-by: Lothar Rubusch <l.rubusch@gmail.com>

Best,
L

On Sun, Feb 15, 2026 at 9:52=E2=80=AFPM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Return -EINVAL from atmel_i2c_init_read_otp_cmd() on invalid addresses
> instead of -1. Since the OTP zone is accessed in 4-byte blocks, valid
> addresses range from 0 to OTP_ZONE_SIZE / 4 - 1. Fix the bounds check
> accordingly.
>
> In atmel_sha204a_otp_read(), propagate the actual error code from
> atmel_i2c_init_read_otp_cmd() instead of -1. Also, return -EIO instead
> of -EINVAL when the device is not ready.
>
> Cc: stable@vger.kernel.org
> Fixes: e05ce444e9e5 ("crypto: atmel-sha204a - add reading from otp zone")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Compile-tested only.
> ---
>  drivers/crypto/atmel-i2c.c     | 4 ++--
>  drivers/crypto/atmel-sha204a.c | 7 ++++---
>  2 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
> index 9688d116d07e..ba9d3f593601 100644
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
> index 0fcf4a39de27..6b4e2764523e 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -94,9 +94,10 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, v=
oid *data, size_t max,
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
> @@ -106,7 +107,7 @@ static int atmel_sha204a_otp_read(struct i2c_client *=
client, u16 addr, u8 *otp)
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
