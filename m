Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCAC32938D
	for <linux-crypto@vger.kernel.org>; Thu, 12 Feb 2026 11:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770894947; cv=pass; b=MVIiYxLmuFTtLSIiTGISHjsmrCuWFodnjjMuBshBPyPI2qioG78U12EDeGLF063rELgnOpNgpUHI+gL+DSL4slMP5D6I8QuwpPVP23bpHCkH1416S4CHnbd3ysFhu1WKpv90qM3oCQFJdaSyrudIn5mK5RaF3q69Q4vLfrEtwyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770894947; c=relaxed/simple;
	bh=ElMnZ70+zoQeLBgc318HQhw7roMB7XWFjCkvnwtFtzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cOKGa2GCDB6/KaPdodVvk5mZ3EYSz2hYNMSAMV9erl9D2JO/QvhIp7pC2eGuV04jLvpA+TXPoI1hJC41d/KcDbLnYmBFYN09hhRSI4AF2+FP7Osvh+hoaFqBIyDJT5MqifZ8uA/TLuWF4IO/FVqsXCMQFGXfNtlSGxPtESI4qTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=fTctf9H5; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="fTctf9H5"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59ddf02b00aso9131756e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Feb 2026 03:15:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770894944; cv=none;
        d=google.com; s=arc-20240605;
        b=j3HtSUsL1zEswlNFOHwoTwm/pkanULnf1hsZ0GB23Uv8mLYMGE9hzTzoz+ZEhM0R7t
         ss6ikTsimw3CfJ9rwMSxKmvrF7N3viYbNw9nm2Z+dxAJf6ZdnPnd/QymhmFSYEir2oLL
         WblAXZu86oNoXNPu2Y+4PjPxhO/IE49EjcH3YWPCYLdVXc5CLYYpz6l6K4XmlugWmqS3
         yF+/0dz4CWZg4mlh/Hy1F+w6x7/gtivk5PgAof93y1WvkeXy+7jFQbWG6V5UBL6J9KK5
         eTvC1E1G2mmyT9lweZ0fchv8a7ZGYyEnirqLuasmX/V8RW990l0jJhzxK7itfyd7zC6g
         Yu5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=97eMc5qt5Ski44FO6QDuAEwHvuGExgtxR7fg9XZJj30=;
        fh=Iq9jAbe2ujuY5VDL5gQ3nveyX9IZ50zOahYfHGmKumk=;
        b=bJjfOCRC6+W2Bq/aA2VCzOpDUVSIVgHY1U4wWlEFLVIPQcaspHvaHN9CFs54WcVeOM
         tfl8zWUEYdehiSImH0v50FFXqFa620sshJ5U6F31Znm8oOFmCmwjEUgEwiRJSLoWaCaI
         ES29p95K3j8DzGduDCvQaVQNzTnSAkl6Y+cUwiKCwUfIhGWSdlknBy61ax8zwqT+NYf1
         tHdVCroiPBVs8cDXWm85RaV1UiNcBbgVyvpmmp4z1Ps0dE3pp3mgXSEkJcT8hwEctfcs
         SLOZOXGB1ot8oE+ElUACVUan8szAUJXKkcrPsbMJ2uMLTJZg2bkIZXClV4Iakltjrdgd
         AFBA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1770894944; x=1771499744; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=97eMc5qt5Ski44FO6QDuAEwHvuGExgtxR7fg9XZJj30=;
        b=fTctf9H5XoWiLX4TcrK+I1DnImmCC1Gf4HDAhIn9aCWZDO0UnUOw/wnWlgeJYU+bqx
         T3BU1QPX7bYjgl8XK/lUX48jckrlIvuCKNbV7mI2yHr5gg41ae+Dl6uW8aY9i/cAhMf9
         9vwMyUGy7rvz7cGBczwl1u9WTzMmqHazuYiR527LXWxIakVO5qZGqnItoqoVTYXzn8uK
         1Kyl19IBsmc3hJgqbtr2am/A5xAY6LOGFnIF42Wx631trSCWg8OdCTgmmTTTvY5Vr3im
         GYqyNcxx/zILzrGcXB7RXlJpFb8VIz+x4V6Y7HlcV+LSrBE8yOj9gSn52Qi/gqQNcE81
         WEqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770894944; x=1771499744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=97eMc5qt5Ski44FO6QDuAEwHvuGExgtxR7fg9XZJj30=;
        b=xEney2Rd4vXG9S2zCnJD6DWUTsLSs/JFigtUPO7gwzB6oNgmVq0xWhcLoLUV8bufdF
         l4F5WZRirAVdbafRpgDC6a0Bnaln9sM9QAy74voS3iBP9LWPmDeWDd0mjuncyNu88lGu
         /Gi3rIdAnri9FDGW7DJKqZTn0R7+/uWt6J18Iqu97+ICmvox6oLcgbS8+AC10ggl+dGK
         3OM8jJuWDpUt9GlgcY0PJYI0Zl8U1b4NCCHZLUxeD81FQH0z/i+q+ouoWdJraTJmgApb
         I2RIFQt/I5OCQpjZD1M1rETgUKphQa0AQD1WCj8OG1w20WmoWlmma1zTOT0+NrbjYP17
         47WQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/PmUUZKoOB8xE7zGKvxxxQer8C5WwdNPF95C2iRGW4b7nmMiXCbyYJICfZVxLHeeN/SnOBCPDQ0EaRko=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywav2lwWH7DhvffEWUkV3C4ZQiTXOe0QJM6ZiYfRY+O7+BCt+Ao
	1me4wpjxlg2wlHg+9Qgbeb7Mim5lv659xCVcO1YMc1pAOGrq4TQouWJ/baQ12wUEY+kl4EBBPFO
	fIxftQpUnQYunvSQKh5l19jlWAhKtIB4eS6UKM/F9Bw==
X-Gm-Gg: AZuq6aKMTPcWhKWKAqifKuMT4xz3p69/K5JGnJXqbVKWMQRTXJRwQDJZKw4YRpjBDs2
	Wm9lHr92MD/38hOFeO5ABNZnTt34OsMuIy427gCQwN16raHqEme19pZ2w/CXlDYxvSk3tt/0NDS
	HeqtmyKKt5SHwCi1EuCjlSOOMKiOQ2lKnF8Ecch6ygA/n7jWeAyLWiJqp6/WuUsshiQkG+n2egG
	bGmotMjHUzcMfX7KPnaY1Reu7+MN5K6JqS2zJIBQtcL4BK1GXjhxpJbjYj/sp113MUoHErzVseb
	ri1AUUhqf34Y9NNYQ99+Xf1/Vw==
X-Received: by 2002:a05:6512:2c8d:b0:59e:6058:f160 with SMTP id
 2adb3069b0e04-59e64043dc0mr579027e87.25.1770894943805; Thu, 12 Feb 2026
 03:15:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212103915.2375576-1-martin.kepplinger-novakovic@ginzinger.com>
In-Reply-To: <20260212103915.2375576-1-martin.kepplinger-novakovic@ginzinger.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 12 Feb 2026 11:15:32 +0000
X-Gm-Features: AZwV_QitoqfQoVTEix3xPDR27nujXBVhj7L5gjmSDHlQSQtn7OoK4gHTZ6LY5aE
Message-ID: <CALrw=nFiAfpFYWVZzpLZdrT=Vgn2X8mehgEm9J=yxT3K+X8CcQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: rsa: add debug message if leading zero byte is missing
To: Martin Kepplinger-Novakovic <martin.kepplinger-novakovic@ginzinger.com>
Cc: ebiggers@google.com, lukas@wunner.de, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 12, 2026 at 10:39=E2=80=AFAM Martin Kepplinger-Novakovic
<martin.kepplinger-novakovic@ginzinger.com> wrote:
>
> When debugging RSA certificate validation it can be valuable to see
> why the RSA verify() callback returns -EINVAL.

Not sure if this would be some kind of an information leak (depending
on a subsystem using RSA). Also what makes this case so special?
Should we then annotate every other validation check in the code?

> Signed-off-by: Martin Kepplinger-Novakovic <martin.kepplinger-novakovic@g=
inzinger.com>
> ---
>
> hi,
>
> my real issue is: When using a certificate based on an RSA-key,
> I sometimes see signature-verify errors and (via dm-verity)
> rootfs signature-verify errors, all triggered by "no leading 0 byte".
>
> key/cert generation:
> openssl req -x509 -newkey rsa:4096 -keyout ca_key.pem -out ca.pem -nodes =
-days 365 -set_serial 01 -subj /CN=3Dginzinger.com
> and simply used as trusted built-in key and rootfs hash sign appended
> to rootfs (squashfs).
>
> I'm on imx6ul. The thing is: Using the same certificate/key, works on
> old v5.4-based kernels, up to v6.6!
>
> Starting with commit 2f1f34c1bf7b309 ("crypto: ahash - optimize performan=
ce
> when wrapping shash") it starts to break. it is not a commit on it's own =
I
> can revert and move on.
>
> What happended since v6.6 ? On v6.7 I see
> [    2.978722] caam_jr 2142000.jr: 40000013: DECO: desc idx 0: Header Err=
or. Invalid length or parity, or certain other problems.
>
> and later the above -EINVAL from the RSA verify callback, where I add
> the debug printing I see.
>
> What's the deal with this "leading 0 byte"?

See RFC 2313, p 8.1

>
> thank you!
>
>                                     martin
>
>
>
>  crypto/rsa-pkcs1pad.c | 5 +++--
>  crypto/rsassa-pkcs1.c | 5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
> index 50bdb18e7b483..65a4821e9758b 100644
> --- a/crypto/rsa-pkcs1pad.c
> +++ b/crypto/rsa-pkcs1pad.c
> @@ -191,9 +191,10 @@ static int pkcs1pad_decrypt_complete(struct akcipher=
_request *req, int err)
>
>         out_buf =3D req_ctx->out_buf;
>         if (dst_len =3D=3D ctx->key_size) {
> -               if (out_buf[0] !=3D 0x00)
> -                       /* Decrypted value had no leading 0 byte */
> +               if (out_buf[0] !=3D 0x00) {
> +                       pr_debug("Decrypted value had no leading 0 byte\n=
");
>                         goto done;
> +               }
>
>                 dst_len--;
>                 out_buf++;
> diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
> index 94fa5e9600e79..22919728ea1c8 100644
> --- a/crypto/rsassa-pkcs1.c
> +++ b/crypto/rsassa-pkcs1.c
> @@ -263,9 +263,10 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tf=
m,
>                 return -EINVAL;
>
>         if (dst_len =3D=3D ctx->key_size) {
> -               if (out_buf[0] !=3D 0x00)
> -                       /* Encrypted value had no leading 0 byte */
> +               if (out_buf[0] !=3D 0x00) {
> +                       pr_debug("Encrypted value had no leading 0 byte\n=
");
>                         return -EINVAL;
> +               }
>
>                 dst_len--;
>                 out_buf++;
> --
> 2.47.3
>

Ignat
