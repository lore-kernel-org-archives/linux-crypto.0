Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCAC3CCA15
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 20:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777407012; cv=pass; b=vFViGHS7n9G8uJOL8BYnSuNRoRi3M1sxxjBvfMji71CbhJkVh4DzVKPGtS5/+dyvNCW4G/ylOA9uRlXcOyTUIXdtLK/NvvdnKJ4IWEB9HNjhV1UAauE2sIPkXlz6mUyBNfoQvB+1hi8dFPM/XLfKn74uyQ5gQjFPUBTEZjhJE+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777407012; c=relaxed/simple;
	bh=2gxxhOOu/K3k2ZTsGez+sjaHrW9QR1b/hcGagEeUilg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fiR+LOJsOqbzbjS332AuBecl5YqiZcPbP8jPoamEMFUJ0op8R0Np7nLd09lbhiHNx7pVMu4ilCQGbwGE5Dv30G2l1xs58jFIOSwlayeuoUGyG2DCRemELmDn+D3KzI5YYSHZ3M5QX8B7xJqfeOwcowTTb80nefoi9OY/gqYVeYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wB8hS3hK; arc=pass smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wB8hS3hK"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-12dbd0f7ecaso3262585c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 13:10:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777407011; cv=none;
        d=google.com; s=arc-20240605;
        b=YgpS+yuDfKPsASSrM7ecXU1QQ8cky7dTLm05bD5SFRUUT+F4epwckwjhSbDBd8i4M6
         TUSbwMZWmjm4VhwZ3KN9gECc63/kW1nWIoaY/lkJta+l2OLkmAc39/BP+W4urXLi6Xz4
         nJoFpXvugQH0f0g2XcTrYcCn+GKqWi788b/ku5IhNMCmdBtSAcZ9LTDbvrfEQ7YcwkYo
         6hFUMdb2feHO/YQC2ws8dwfDoNN0i864ubh21I8YpxlNJZEqM42AMuLUK9QDvQXF+Gs2
         D3tgIlkmt6cgyPI5To0RgYJz1VpmHKRDlyOFXJLqB5oesW2PmNnqbrTSO4OpOnaAwaT/
         XacQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2gxxhOOu/K3k2ZTsGez+sjaHrW9QR1b/hcGagEeUilg=;
        fh=P9yb+sbTzWPgXN35V8DNTtLIv5NM1fQYW4O6USEUPPU=;
        b=Dt0eKYxKlVwvQdIzZgGuSwIGib+FxMKAkr+CYgF9Kx39H96aLIzpu/KKWwA4p9yqwF
         N/CGP7cCbDs6iIIePFDeN3SSGvofa0agUBqu3Z9qpRtdmnFPUqXE9itlbN7VJOmALY0w
         9YO8g+FaMDWXE6jJOqplpzeds4i6gZc9U87fTX/uYT3DTXsad2fOZ6jzeQYoBTH9FuAf
         FlqBuHqaOBAopUrc9R4sbKgzm9qD+J+0UAlTPiNKEgPi7Y0FMKdgoJz/jrbvcicVjSrd
         dbVRkrTcuyHo+8UBeabBhod4IYuB2WS4nmUs7oRBMqGKuLcEgmMhpH1KiZfcqshst7zF
         g6wA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777407011; x=1778011811; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gxxhOOu/K3k2ZTsGez+sjaHrW9QR1b/hcGagEeUilg=;
        b=wB8hS3hKg0rzoaVGo9f2i2ZlSYCVMHe3qZYJ89N2lQLPeHJVeb/aC5AP+THN3zC+WB
         DrjZfMYyx+M6TciZkUfzvxqIxZW1latQviSD1LRDpLSnUm0VWqHDT1b6JK9yC3jL5dQi
         6vE0retb9SIts2TTjY7ElFuyRy3QVM7T2UMR4u3thVIVhX7CVzy6EBKvDsmCDKDDHhBd
         pmY1z1ubSxI2uH7A5ScEKjQlaQg/hIbSU0WdQSlUp/wf4surRN+DMXcby1KvmSBzUB4I
         mFCs2M+2H5BFj3PgMqEaY4KQW0ywLfg9ZoBcP65qdS/cd941RtUbtSYQ+flhyv381fQo
         spJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777407011; x=1778011811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2gxxhOOu/K3k2ZTsGez+sjaHrW9QR1b/hcGagEeUilg=;
        b=mUpKDZOZQUYq708KzrSfjm0YoWiG0hlfGL8q2ip75oi0j+0N2dyMuC60q0FgYfaUJp
         P4hDNXvHVO8gavq9bDKjX+EQ61MiumGMPWQ5uz2siYMqko6UG5rXY89Bt3GPFlbcq+ET
         q5QlsiPg/6tLPetkFkutZtjmuh/Mg1Qgf2lzIiQfmF895tPwbDxaAP6tQfAN/FvTuQUz
         EMfQ7zxRuanmAp9gUsTFNQJf68OLUVMmkGBNGjDTgtPIGiERY0QYyVCTkqVh4BYAzV4D
         3k4ZE6S3HrnJeg2IwVbByMUswX3GczTpBgS41DO0vnnkOLaqvDa3tCPvH7wlCQeX5SAf
         ssXA==
X-Forwarded-Encrypted: i=1; AFNElJ8hEBEG9SCuINEPzUZQ5sndjlafjcPUOBryDnT2BgrLiIWj+m58P9l7/ZDAxmntEVjHfMMytxStf+oybNk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo1SCAMQR5VrKVmTYT5Dyg7A0I731z65qN5GA0fiIY+ltVZNr8
	3szSqtBuKX5B16dPsdKrsKMV2pI6o0rZPyAIsPpKebA7q/8lvxVcRLKP+e3WjKWnArQ35dNqLEQ
	Ng1X/61QxMfmBpf2cWyNQlIXcm50/S3HMHtRCUhO/nxyAYzV4o/J9XdQl
X-Gm-Gg: AeBDietyzU+v8bdjpa8pRkV7K9g3vH1R0LuENsIgL+8+OXc0bABbd1fxO6vY8hM5ds1
	diOQn05RRF42mgyrxRGU+tZbs9uBlgbdNE/CjS5ak2KUhJTmKjBnZPxEGzXMNewnxOLhGWT9FW0
	L4LbtxT0e7J0Wj/prlki7yr6/KUJ416byBg87AbtVlyePijXkoV4xov7rLrAzFYHAhjIxePCXdx
	JYc2mQcFjm1AvJjES3CY2jJP2p1GLygIUoaTSAASzg0AVCDkLGZrKUQBn7/FJ/mviPPEvndyYNo
	kXejmaN/hnqgPcIfwYb3CtQIhR8tt0SpdzK1Cko3/K5YpBjtyHLZuJSWbwe8FMS5HqOQwuKCgbF
	8yA5lJ0jaMiBKvSesHpvrBMbbwZdf8RnxUzag28NzuQZvIwnH3KrvhqW2mxVbAo+rniuxqg==
X-Received: by 2002:a05:7022:69a7:b0:12d:b8e5:5e0 with SMTP id
 a92af1059eb24-12de2a5401cmr357938c88.22.1777407010149; Tue, 28 Apr 2026
 13:10:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427104129.309982-7-thorsten.blum@linux.dev> <20260427104129.309982-12-thorsten.blum@linux.dev>
In-Reply-To: <20260427104129.309982-12-thorsten.blum@linux.dev>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 28 Apr 2026 13:09:58 -0700
X-Gm-Features: AVHnY4Kr5JjOQA8hjH_A2CnBwTI-oM5GEnAJqf68jIS5vek893GwlRKMhoRoYJA
Message-ID: <CAAVpQUDYhDUccDd2qXJcPreUWj2FiMyRt0UW=_s9SMnJFvs_xg@mail.gmail.com>
Subject: Re: [PATCH 6/6] crypto: algif_skcipher - use sock_kzalloc in accept_parent_nokey
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
> simplify skcipher_accept_parent_nokey().
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
