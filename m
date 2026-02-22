Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EB443ABC
	for <linux-crypto@vger.kernel.org>; Sun, 22 Feb 2026 17:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771779834; cv=pass; b=Pa80iJBUnf9b8CiTtWBS5TsdhHa+NcSb5CWomfy5UYaJQ6tHR13qIYdqh3zdLAOK1swLRG6KdC9quNImWelTqscMucQu4w9Ssv6392nhsPCWoSek/yAgqsKA+OSBPCGNT5oosJT2qp21Cr7cQznsgtYifoAXzcLl8mfrpRjto2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771779834; c=relaxed/simple;
	bh=gfPxTAcGn6GgS3LFZjQMK6EB0WGi51aqWGuEHQrQwqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jOnv3b72xOagBOI02srqo3L9zcHv5BrFjdKUWAGbqFzAasiztTRRMlct6Aftru0FBcNBtuxfd8cuKA9M+SrTLPlVPamkwUgr9QN7nmDLmXZTGmqLKassnxl6XmAa9Xcskx8moi/2hzsgrNR2obQNjOFTGY9alRKWlwtEfeGAtx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mhFEelBx; arc=pass smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mhFEelBx"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-64ad9343163so498651d50.3
        for <linux-crypto@vger.kernel.org>; Sun, 22 Feb 2026 09:03:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771779832; cv=none;
        d=google.com; s=arc-20240605;
        b=LSobRgN+QPVk+9N2zR+dSoDXxaqld6omuMiwdDlf6eVajW+Ds3YsEUVR9Vet7aertz
         iMnyPsauz+usGzXrrYrgBPSlwZXYbGDWOsgi7ip7qdry/5HvnoAJ8f4e6sDt6hk8y0TG
         Hi1Ffo4NCmGBEhVQ5TXYRkRuMiRpB75bpMrN8WuRXHlUW4shMKy2YEKn+7AhTCBMvCEF
         Ahs6OB7E6+IGv0ef9WqR7DdA/zaLAiiwAJkaFyAB0k+5AVBcB5+8r0zzsfg3yBsgn44m
         mFoZD1tgyoT1abgbzbwqJNw3UfTKV6tg0Bhb8wIud3l7iinNi2/cPE5dZXj2c5Gr+/ZP
         W5dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iBykXcry3hRl95wYDSUTJ/cR3J3An6RSzJqIbZMk+XY=;
        fh=l/Y8MHvgZPBX2GECjEtNYF6Q6X1UwD1vsWm9hCa2h4c=;
        b=Itgyg24conauiPtz2rAIpae/LJwePCSevPPyWaIlUaZ5N5l72mH/BdSJ4yzoNfldA1
         vW5EeWAZypLM3KiSQvlIJa40OiagXvwWVBEHfi2C5VcqwvgO3BPA3/hekTAkarUEpdZh
         +fyZuXeMKdGfuU1rNTt4ilHZLopsGtaRn/SjGEpiyYddEJtwU1EN2hVkLAIx+ZbO3Y+t
         XC6UHvk1lzEegJ4zK1l9uD0N/YxEb5hb561IZUmadfstOp3KO/3gG6z1peSySFoXruqz
         z2swtxWv7XVtkg+hcOFAsJaLFMry8DrqtNdz3+OQYk6khYKFDqBle4kvxtf56sQ4YtKX
         hEBA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771779832; x=1772384632; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iBykXcry3hRl95wYDSUTJ/cR3J3An6RSzJqIbZMk+XY=;
        b=mhFEelBxILapHAdw/HYaKg34ulq0t6tjFxadbe6MiXapvc1Rz6AwtnKd2ec+kWbESx
         tUpXBcBZhclsZffi3asUHwCyPiV5pial1yZ3TuEWW0JJD4XLrXySlalOST5JBpTnR9DX
         FY4y5yfitsCzMiNwUN+aWVziCBKBaXZ516faTQG3mQXgUPDPoA0Ome9gnrvqCbO0oL0o
         bnbUepcgeGuTVSH5HD1dxTeaFgP6wU/gm6Z9NwWsce++YSCdWRsNzP5mpBqtU2nQj8H5
         CGSiVia+pu1YXVR1cavnDD1nruRYpkEz6jRsOFb4wEMJJ7jDZpRJXLk8+5eo8I4x4n7C
         2fZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771779832; x=1772384632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iBykXcry3hRl95wYDSUTJ/cR3J3An6RSzJqIbZMk+XY=;
        b=MuRd0bApcV3+lxqnvD0iahEfQGhWk8wGJ+e+sE8cACqjEkRb82cnfJpNVUEIz2YtaJ
         PVE27/7gpmpoVKvqfvNa8hj9CXCT+ox+l7Pz4ZJxFf6hiO5HiVQ6/NfBqdWsuEcB8S+d
         RDHiAFULWBZ586chx9d2gOdbYmXODb7xgsgEsQY5qeUrTKrcKb4W1P9HRAa1PxUvMZMs
         wZoQ9df54uA530GueqrUnPvNqH/d0yR6a/zyRHnyeG+8WpxjwywIPNIMdgIyzheBnhLZ
         swQ2xJ7HQmCFv8ccZUw/Qe0lLCYp/7rqZfwizc1pzVsc7PKT+DmSOvN2u3wYBLdP6UM9
         8IXA==
X-Forwarded-Encrypted: i=1; AJvYcCVqBgkkB3fsZ3O8zl0wQJ5tLxVUogLr4veFhkL62utvG4d5XCzZUKEqKhWa6PSKg5crc7ZkdMhY8ZQkcoM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJccPcT5qrcv6TBdrJqptykdfEXBGEw8nzG08bLPJhp8oqR2bX
	a74DyLkktHPqdYlvHZAGqe4T5rIAXxHwMpDnlxcBbLOX8aLhn6ZXx3MQ19eXOuiTbSzTj/+YAdg
	xnyxks4A9im0m50VkjRy65bmqM1QHz9B7aA==
X-Gm-Gg: AZuq6aJb29UNs/nMIb9y9cVq8GShkVtokmyW3M9aR45o2faiHgx03IwJQqz+f4sfoqO
	8JNBoWfpca+FhgzA/ODv7DWh1kfuGLJTwE1ke4HtNzUX5AyDxGY/y/5T+InhA+fDjw/wZPMO85R
	2xSnExZj/Gm9EGLurZ6WuDV5/k9cMWI2vJtKI5QFHAi7UujG0nTeevgnQWzofEq7AZ4q9hNwEIf
	7rf7WG8Eu0xTsG5qVvLs1FgGsa3/VWTY+Fzrl13GsI0dmLxauCBTMuTWntsRP/DMbRi6wAmaybw
	TaIT
X-Received: by 2002:a53:d009:0:b0:649:c3be:a387 with SMTP id
 956f58d0204a3-64c78d3e730mr3895155d50.4.1771779831946; Sun, 22 Feb 2026
 09:03:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260215205152.518472-3-thorsten.blum@linux.dev>
In-Reply-To: <20260215205152.518472-3-thorsten.blum@linux.dev>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Sun, 22 Feb 2026 18:03:16 +0100
X-Gm-Features: AaiRm501A03rgVMp3fr1R-CFD3HgkD42BVCx_r2SycJdlIw_EXWDQ4yLRJnqDhk
Message-ID: <CAFXKEHZ9TTZMdzKr8_5UesUdajGoQNm_u_paakggtGONbzjPcQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: atmel-sha204a - Fix error codes in OTP reads
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	stable@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, find some comments below inlined.

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
Since I2C bus errors are caught here.

> @@ -106,7 +107,7 @@ static int atmel_sha204a_otp_read(struct i2c_client *=
client, u16 addr, u8 *otp)
>
>         if (cmd.data[0] =3D=3D 0xff) {
>                 dev_err(&client->dev, "failed, device not ready\n");
> -               return -EINVAL;
> +               return -EIO;
The cmd.data holding 0xff here is not a bus error. AFAIR it can have
to do with the locking state, pre-initialization,
typically the atmel watchdog kicked in / timeout, etc - so the
response is invalid, although hardware connection (I2C) is
supposed to work. Currently the caller of this function does not
distinguish anyway.

But why is EIO preferable here, over EINVAL?


>         }
>
>         memcpy(otp, cmd.data+1, 4);
> --
> Thorsten Blum <thorsten.blum@linux.dev>
> GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4
>
