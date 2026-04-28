Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139633C3420
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 20:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777406918; cv=pass; b=XpVbXK4lRWYIKwT4fp8Npj6bh7VTfiTzBdjDEHbDZG0H9o94zHCjSaZqZasMNDwt36Uu5Ifv3tEKcSSqFX7SLKhb8yx6xnYiIsGmx8QDTVaAPNeW0t4NFHh43f7ersO8pzSM/7vJNiIPGYmlONXTFDJhi/wdIOP4fKFdrtdH3IM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777406918; c=relaxed/simple;
	bh=8XL4RzPZvV0sHpDFQnbyp7nfkDGy2ogJAkMAXFZRkrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vhc6oyjNhxteYIfJcLxNuZBCKlMPFBpnHYabGQVnoNhGLydQdktyE8vbnGxTibYIAXEQFiVHEoJg6imdPEOC8LoiJkqmithZ/WUag8YE4SgKcLskzGD82Z2sPhGcap6m9RO961uCzHLlUu2v48OaG5It8zcBqLrC1lvJ6kDNLp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fzpX2mwj; arc=pass smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fzpX2mwj"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-12c726ef332so16519938c88.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 13:08:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777406916; cv=none;
        d=google.com; s=arc-20240605;
        b=h9Q/AYyrJK5PP2Mu0l0jm+8hdLgT8AZ/TcIzX2xkYpM1VFrkj4J48o5vPOrH6phBrb
         BRH3zPfYgLiCwt6aYVlGNKoMwA0lJIO0CLf6WwGRJE0kXJdxG9d9Kh7leEpM3QT8Z3tF
         p7C9oX1jrysV/BiglQHUIB2tpDr0lm5Cs84sevYs8ZvQV9YidX1HcGd2GqdqyHeTUW30
         C06MDEBow0IMiNKWbx3zRLCxvdvhnDpp7gTgNXYRheLsAEBggEFJUI5Rfj4YytNZbqWa
         fpPhm+nGU1skbrz7Y5tRggjWg319I6U/KzB2cBwO750jKMA+QrBdYtagnGc+mysyBVnP
         MwrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8XL4RzPZvV0sHpDFQnbyp7nfkDGy2ogJAkMAXFZRkrM=;
        fh=LY2IUuzrrc66blZJFSypgCpFX7giKAEbM4k2uoyoYlY=;
        b=Xr30/VouCAb50VNOGsPyAYis7ZPy74aIEwg07phoT71z13s4/oYVgv7aot4rkJYimC
         VxX1A7g3BLgqSOamP3bbUqutVLdMqRZ5lm6hPetzcS3Zf1KZD5JD9OsZohLuaUj3hVwL
         Cdx61ifsknPMKJLNBxjRwYripdP0CGPpyJa9QFlnt81b0MQn3GAh32FnWr9Ou6K7m56x
         YH+8yaxC5yY97RoKn/8uehhGVjVRDmTxqlf1dzzeIm8lGnKRKPDSnxLUFWch1gw8LVSl
         z8Pw0GKUTajcEPo/YyEpxh9yoIL+u/Z2Gn7DOqSv+1JGDbNzuso17bG3Yd464IIMAdRA
         gTwQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777406916; x=1778011716; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8XL4RzPZvV0sHpDFQnbyp7nfkDGy2ogJAkMAXFZRkrM=;
        b=fzpX2mwj3i8gUpMZDpVjWgGTgin0P/Euk/ccRhHQqzBoh7CmPGPte5smI2Ma34DoON
         8bb0AlInhHRe1/DK7M+lidRZUxRlF3Hs2m1cvajJnEtyQ49FG8ezRlcx0hIos0WMpTWN
         fr4uFedaz0L4ZmQ20k0cpclb1++AqGsVR0VAC2jtpfGk3T7r17qz0UckKovCEaKk88mz
         n15XR/wdXDyio8A+tHQAewZ7RmfEouP9yWiN20h1YKiBno4ymJt20huiB+yc3+2k8bhK
         Hk/8/SjSzC0t+IdNZ0dIOXEdTwczVrnzpfu781NPcIXcrGq64c/FszWjFegOeci8Qz8F
         tXzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777406916; x=1778011716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8XL4RzPZvV0sHpDFQnbyp7nfkDGy2ogJAkMAXFZRkrM=;
        b=Alrf6Xc24vCxsdUwAA8PKJ/nY3zWE1SmuebcLS6YNTsIEwpIdZf+0+fy5rG80wQCgF
         Ib27q4nDA1dJFfS84OrkHmFghwjHicKkabGuTEDfTaatXqwQwuncTr974nJ79XtbUZO/
         12BdX22U+iobpoG5PhxnpyXuRJXdacFCGoqnHCCReG7Xvkikdf9BWGvLBNkvQYTfmV1r
         gprfa36HBI9TP7cPOiQPJAAf5MVo8NoM2kB49ZM6UbkxWeACYtZaGFW+uf+e6xZch2th
         SbWJtzriT9XYHfGGkUwo/YB8xLuTtioigrMkWSCAMLDK/KRS9DztHqcepNIPxStukl6R
         WKyA==
X-Forwarded-Encrypted: i=1; AFNElJ94lRKfBfUkY5cei/WQxR4a0309mdsw4Gvd9thIA3sEQ+VFPufpnl67UreWRw+2K3vRN9c7z42JhUOHgxI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxECQLmx8EM0cFi1N+5oziDbHXLlxWrfAjOdeu4XIW4eFT6gkZV
	wxgDceVO+b3V0cy3dyZRllbSlzkNe3cwV03d6AU+url1g2dg1hh5KQL0dwSrMPS3Ls/NoKU8Eqi
	lNLYdVfOkPnbclEFiz/DXwT3cNnO2K14YTbm7MZHl
X-Gm-Gg: AeBDiescGDImqpP2ce1IxbyB5tji62Bl3gcqfZYNpy09nrz2xaA82FworzTBfkJPI9E
	d/Pdh4gTv42fmSEvCsa76A2hT6NjjdnAah30Zf6oGGANmTT/NxHs3m/dwK2GENmpmTVIfU3GYu/
	D07pGuxlvgs6KUJY1d7GdFemlsMkK0j3dPjptj4Ym1DX134oUriZn8/CW8tAQcsPr4jPflA817v
	NEFoUQjV5b52kWMg0xjjXG0poF5slf0WSOqvnZvwQH927uOA0loAeVGITq0StzcxWrwKxRudFqF
	smtdJgPq4x5amGH8iBvJKFRIdpu7S+zLomPMjxkV7n6uYCC/A1jRuWTvfMKVLEGrpgQprPEG2d3
	z3F6NtwP583tCyj/LB78E+Fat965fNnxmAyDSEvMvaJqnnP4iPTnWGY8+VXgc/8e0QYar5w==
X-Received: by 2002:a05:7022:4182:b0:12d:d972:b969 with SMTP id
 a92af1059eb24-12de2a59b53mr351660c88.24.1777406915778; Tue, 28 Apr 2026
 13:08:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427104129.309982-7-thorsten.blum@linux.dev> <20260427104129.309982-8-thorsten.blum@linux.dev>
In-Reply-To: <20260427104129.309982-8-thorsten.blum@linux.dev>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 28 Apr 2026 13:08:24 -0700
X-Gm-Features: AVHnY4LF65-i_Ur6DdEmNpFr-Yd5JkJhdzz_Xvkqxci5WFZmon9fOla8Fj5sCSQ
Message-ID: <CAAVpQUAwTJy3YfHoCqMFqLnDZwDcmd6=pYNkA6rwPyvYQTNNbw@mail.gmail.com>
Subject: Re: [PATCH 2/6] crypto: af_alg - use sock_kzalloc in af_alg_alloc_areq
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 3:43=E2=80=AFAM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Replace sock_kmalloc() followed by memset(0) with sock_kzalloc() to
> simplify af_alg_alloc_areq().
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
