Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB6628DC1
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 05:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723786336; cv=none; b=UN0nZ9+rnUPmbBYija2KiWlPhGN9jzxMeeF6TD8IgSvFsRyFxK/wJbDs+oiBujIwBthFgD3gKyyvk+PpRSEdmUr/IhdzAwOQOamMP6OGkHr6Mee4utgwABD7iaL+6pfy4oioC/bNL5h/8a71ILnrUBiPSCwvIxQ/Azgk8QiO7co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723786336; c=relaxed/simple;
	bh=t6dBjJNspxNJMiuyVhLfO46biPaQfYP4iqSPFh4Tvy0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YNi/5L1KggASPOD/dPHeRBmv+TmcBDyRTFa9KCbdG6QHN401Vya3cwHl/+w/umd5TePINLMg1l5e6dTNCbYC/1Eo+5isxgk5zMbF6mc2x1QlWaHlSpFp6x4tdemn9fBOQg7oOkM2P9/Lq17We7Q3rcn9xAIZ+n15vhu6F0peMvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Vp93FvkN; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Vp93FvkN"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e0e76380433so1710164276.2
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 22:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1723786334; x=1724391134; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKf+BnEef5L32P6EXA0ra05sebTP4mjfU3AAuqCmOKQ=;
        b=Vp93FvkN1w1Ehsg/2hNwGGEnseZ82brMV7Mls4EEytLAasPgLaRrjNmXa0XgFjVNbj
         m3A5AjU+y573ecqtBtlJnqRNyTsbFgPOyrhqoGdot2Oyz62RLS4d09nH7djiB1rs5X7k
         iWFZ2a0CHi3zGYTdO5ibTCyF+H696mQytW/+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723786334; x=1724391134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tKf+BnEef5L32P6EXA0ra05sebTP4mjfU3AAuqCmOKQ=;
        b=aQnaLcjbNEZjhtG0qyVCif7qfcE6LAmZBHBUivk0aUZq9tNko3z0T/pNBh2DLiftEF
         D0AAT+o76aPeoEJY9ToLaqwppGa4MyOSk5iEQ71mULWrBw987dTtx5P50/1jjta+gzcq
         LnHzdLH/ambJNvzriglcsVBim15A9gfAb4q5/lF3sv04W3UsIrsr8GSUd27xcljOxAlW
         8z3HAUktaLd8c48JfPetKmmI3AlxEObiEacMsMmArS8VURcrALLctGUkrO/ao60jJyFf
         9JpodXRWkmVLwzbtOsS0B05k7atdpAv2ttjH2xvm5wGXAFQ7okcXYK+zSuUL1OOE/cOP
         OkwQ==
X-Gm-Message-State: AOJu0YwaRJWeGGJtBZdNm2nFRxuqgj37wuCLNMOv9qxFxS/NWmOE2PAo
	RhN1OWswvhlQKoGsMuW5424Jz6lVcKLCTZmaNBjO6a9Gq0cb0Rug9VGFwLMnw4H7ORwksrGGFfe
	FUbmBeqfCxavEQOaI2BXQ04yD+8WmzPs2OsTme6S3/2oYUOopgZw=
X-Google-Smtp-Source: AGHT+IElK2YMcGwRuA6H4ODWbpw4Ugx6ciqtulepx4JDlIqDyWL1XeqtTuzloaYt9q+S87aexYHU0qBBfdLke3fMCJk=
X-Received: by 2002:a05:690c:6605:b0:667:e5fa:5d4f with SMTP id
 00721157ae682-6b1bed90f2dmr18183057b3.46.1723786334033; Thu, 15 Aug 2024
 22:32:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f61e2eb5-2493-4d7d-a2fa-4b3659c50880@stanley.mountain>
In-Reply-To: <f61e2eb5-2493-4d7d-a2fa-4b3659c50880@stanley.mountain>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Fri, 16 Aug 2024 11:02:02 +0530
Message-ID: <CALxtO0nXB=ED3JcawcMQjetLewdvqq+kjsfSCthAiZ6oT9n0rg@mail.gmail.com>
Subject: Re: [bug report] crypto: spacc - Add SPAcc Skcipher support
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dan,
   This is a counter width check. The counter widths can be 8,16,32,64 bits=
.
That check is a bug and not dead code, I am pushing a patch for that.

Warm regards,
PK


On Thu, Aug 15, 2024 at 2:57=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> Hello Pavitrakumar M,
>
> Commit c8981d9230d8 ("crypto: spacc - Add SPAcc Skcipher support")
> from Jul 29, 2024 (linux-next), leads to the following Smatch static
> checker warning:
>
>         drivers/crypto/dwc-spacc/spacc_skcipher.c:458 spacc_cipher_proces=
s()
>         warn: bitwise AND condition is false here
>
> drivers/crypto/dwc-spacc/spacc_skcipher.c
>     441                 } else if (readl(device_h->regmap + SPACC_REG_VER=
SION_EXT_3)
>     442                            & (0x1)) { /* 16-bit counter width */
>     443
>     444                         for (i =3D 14; i < 16; i++) {
>     445                                 num_iv <<=3D 8;
>     446                                 num_iv |=3D ivc1[i];
>     447                         }
>     448
>     449                         diff =3D SPACC_CTR_IV_MAX16 - num_iv;
>     450
>     451                         if (len > diff) {
>     452                                 name =3D salg->calg->cra_name;
>     453                                 ret =3D spacc_skcipher_fallback(n=
ame,
>     454                                                               req=
, enc_dec);
>     455                                 return ret;
>     456                         }
>     457                 } else if (readl(device_h->regmap + SPACC_REG_VER=
SION_EXT_3)
> --> 458                            & (0x0)) { /* 8-bit counter width */
>                                    ^^^^^^^
> What the deal here?  Generally in the kernel we don't allow dead code.  I=
f it's
> necessary then we can add it later.
>
>     459
>     460                         for (i =3D 15; i < 16; i++) {
>     461                                 num_iv <<=3D 8;
>     462                                 num_iv |=3D ivc1[i];
>     463                         }
>     464
>     465                         diff =3D SPACC_CTR_IV_MAX8 - num_iv;
>     466
>     467                         if (len > diff) {
>     468                                 name =3D salg->calg->cra_name;
>     469                                 ret =3D spacc_skcipher_fallback(n=
ame,
>     470                                                               req=
, enc_dec);
>     471                                 return ret;
>     472                         }
>     473                 }
>     474         }
>
> regards,
> dan carpenter
