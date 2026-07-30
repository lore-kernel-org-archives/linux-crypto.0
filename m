Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5036927E07E
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 07:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397968; cv=none; b=ZcDiGJOs9wOEBCPbuiB34uSKc7mhORiaETunY06hYKcvrvHKSbaJuIX/ILgqaXcC7K7DGsPDLUt6QmZrcvWslbvWDWme6eeJvOg6nfQQx9kHhVffgg1QBSgo29u3mDwPjil3zpZMYKKI6IEbgaaCqtfsP1nAbNW3t7BahcST+Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397968; c=relaxed/simple;
	bh=pVfDo6tsIwtz2gpzHHuK8dvaOM2LRFu/3TgvVMqAy6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TXAWmP0vo2qXREEM1ZdYExvoH5+MWaymoaW4U4GkP18EU65pAkAPikJrA2ZvlefJOgb0dlDphkNl/O6dbCkmeze60tFcctc0ZeTKQo/zYJHPQW+R1iwHdolTz+cSRYRAx99Fjug4JrcTLWdvWiqc58HXqs8u+PYxLHGgUQSZrdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=pOSrM1qD; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="pOSrM1qD"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49802c418b5so1575265e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 00:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1785397965; x=1786002765; darn=vger.kernel.org;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pVfDo6tsIwtz2gpzHHuK8dvaOM2LRFu/3TgvVMqAy6o=;
        b=pOSrM1qDpAgw/LZm4y1godkJJakSvRamJMdlyh65AddRF93h6+h/kOm4bG+/8W2A6R
         B8tkSPHzOvg8pnyLCZbK+JIvV/mMlIUNbMZA4iV/mgcbD0O/j8hnaBCKr8rggka0+UmI
         rgLFpCSnkHqj5zsMnACO9jledE7u2TMSg6Qm6pojuh6XMrNzFMiEnG9ZkiLsdvgFDoyS
         4wifmEtAzdZe5CHiHOXPAUfY/2vgDfkzSQD+fWlreDN1TPjN81119fUiZufOHs7ykQXw
         PGsrZ0Q4kyZzzaLn+DCVh2ZCFTI2UMd2pZlouht2tPFs4vciJVIia0DvXJq/7Nv5GNJ8
         ZPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785397965; x=1786002765;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pVfDo6tsIwtz2gpzHHuK8dvaOM2LRFu/3TgvVMqAy6o=;
        b=hF0LVSjho38tyRNxCnSpmMdBXZ4yPfsCClMsmTFW0eLbNjR5Me0n4BEY3rbqpswgjS
         +VfVl5QVIwyenwIGaKLLnt3bq53SFXWC5aSM5myAafDuxDd9DIQBsCxpe4muxDxtc9Q+
         zXo5i1JJwQcjSoLqWigYNGUcfQZI42D+r9lIPHFDAVogKTqDw62bEJYntilRcCsFQWPX
         TAhwNLh/UU+IKdwrqwMzn+Fx36nLCL44Lc3h+C26AhPI72AYkDMt+yXag9qsLOi9FqjR
         YrIKwI5vxERYIrQCrngBrKUqS1me6N82ZwXw2cMiS2a4zpZSk4wqow6yQ6fzk/0pSmNB
         5b2w==
X-Forwarded-Encrypted: i=1; AHgh+RqITR7kKXT+LG74S6YMacavsY036kMNl6yfaKEytDJqmKAczrsF2ETZXK67SiIlYDZIJRTpkou9XlIaRB0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw18zJkfbL0dJ85X2TUUW5eRyt5c9qIM+ntCKSFajQlRv9TlZJd
	zQfOYLscVPVCRDRcXZIrmBl1vMFOLwiYiULIA4E3aufTEYBWxqiZ5f0jr0KueIl5oXQ=
X-Gm-Gg: AR+sD13fwTMVAV4tzUW+AznxzQ9sBOVlnsckjrwczgOB7I76zml+LP3wKWN1iDxad5U
	uej958UUn7AmGbJ47/a49B0dEBzLzmz3jJrn3U8PNfY/OHYF+R3se9fthw/29qwj+MeYwxVU8lI
	uh0i4coc8wiVQwyyGlm9sy9sZgvB8C627ADPayHqK6awg817X+bosXhA4cfp+QYQm7f/v2l1Rze
	uRxcNufsSpqT8DlyXe7Wp2iJ6vHQq/kwkUlTSkTjYz2lad3PKw4SRp6PuFPNHwzwEOOtW67NVXk
	mpxPeobE9plm40mwV6fnXorqSwPbdEl56HQtOWbjvDiuZ5NpLj5f09MIoakyZeq2qQQS2jc0Qxa
	MuE4KEAJD5ZfAWAZWOOOlaH056oXgpFvD22Dm+FJHngV6gzKErBaNcfONVj5aaz1jIijPenXSfT
	638qbe/iDJpxrJQMhtpUIXIflcKGxA0h/KIMM17tbNkBMlc5UNiFDev94PaV0zJA==
X-Received: by 2002:a05:600c:8b2e:b0:493:cefc:d113 with SMTP id 5b1f17b1804b1-49800e729e3mr20234615e9.5.1785397965460;
        Thu, 30 Jul 2026 00:52:45 -0700 (PDT)
Received: from somecomputer ([82.150.214.1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49764d72d9asm125617585e9.3.2026.07.30.00.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 00:52:45 -0700 (PDT)
From: Richard Weinberger <richard@sigma-star.at>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Richard Weinberger <richard@nod.at>, upstream@sigma-star.at,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 demiobenour@gmail.com, davem@davemloft.net, ebiggers@kernel.org,
 upstream+linux@sigma-star.at
Subject: Re: [PATCH] crypto: af_alg: Allow cbc(paes)
Date: Thu, 30 Jul 2026 09:52:44 +0200
Message-ID: <5915345.sfYGdeWWPf@nailgun>
In-Reply-To: <amsCPXNkPr4dYd6F@gondor.apana.org.au>
References:
 <20260726192716.2351505-1-richard@nod.at> <5372653.jyWNHgNrjM@nailgun>
 <amsCPXNkPr4dYd6F@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Donnerstag, 30. Juli 2026 09:50 Herbert Xu wrote:
> On Thu, Jul 30, 2026 at 09:39:24AM +0200, Richard Weinberger wrote:
> > On Donnerstag, 30. Juli 2026 09:37 'Herbert Xu' via upstream wrote:
> > > This does not apply against cryptodev.
> >=20
> > This is not material for next/7.3, this is for the current release cycl=
e.
>=20
> So what am I supposed to do for next? Allow cbc(paes) or deny it?
>=20
> Because it's not in the white list.

Eric asked me to wait a bit before I send a patch for next:
https://lore.kernel.org/linux-crypto/20260727172004.GA877700@google.com/

Thanks,
//richard

=2D-=20
=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8Bsigma star gmbh | Eduard-Bodem=
=2DGasse 6, 6020 Innsbruck, AUT UID/VAT Nr:
ATU 66964118 | FN: 374287y


